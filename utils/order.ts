import { mine } from "@nomicfoundation/hardhat-network-helpers";

import { logGasUsage } from "./gas";
import { bigNumberify, expandDecimals } from "./math";
import { executeWithOracleParams } from "./exchange";

import * as keys from "./keys";

export const OrderType = {
  MarketSwap: 0,
  LimitSwap: 1,
  MarketIncrease: 2,
  LimitIncrease: 3,
  MarketDecrease: 4,
  LimitDecrease: 5,
  StopLossDecrease: 6,
  Liquidation: 7,
};

export const DecreasePositionSwapType = {
  NoSwap: 0,
  SwapPnlTokenToCollateralToken: 1,
  SwapCollateralTokenToPnlToken: 2,
};

export function getOrderCount(dataStore) {
  return dataStore.getBytes32Count(keys.ORDER_LIST);
}

export function getOrderKeys(dataStore, start, end) {
  return dataStore.getBytes32ValuesAt(keys.ORDER_LIST, start, end);
}

export function getAccountOrderCount(dataStore, account) {
  return dataStore.getBytes32Count(keys.accountOrderListKey(account));
}

export function getAccountOrderKeys(dataStore, account, start, end) {
  return dataStore.getBytes32ValuesAt(keys.accountOrderListKey(account), start, end);
}

export async function createOrder(fixture, overrides) {
  const { initialCollateralToken, orderType, gasUsageLabel } = overrides;

  const { orderVault, orderHandler, wnt } = fixture.contracts;
  const { wallet, user0 } = fixture.accounts;

  const decreasePositionSwapType = overrides.decreasePositionSwapType || DecreasePositionSwapType.NoSwap;
  const sender = overrides.sender || wallet;
  const account = overrides.account || user0;
  const receiver = overrides.receiver || account;
  const callbackContract = overrides.callbackContract || { address: ethers.constants.AddressZero };
  const market = overrides.market || { marketToken: ethers.constants.AddressZero };
  const sizeDeltaUsd = overrides.sizeDeltaUsd || "0";
  const initialCollateralDeltaAmount = overrides.initialCollateralDeltaAmount || "0";
  const swapPath = overrides.swapPath || [];
  const acceptablePrice = overrides.acceptablePrice || "0";
  const triggerPrice = overrides.triggerPrice || "0";
  const isLong = overrides.isLong || false;
  const executionFee = overrides.executionFee || fixture.props.executionFee;
  const executionFeeToMint = overrides.executionFeeToMint || executionFee;
  const callbackGasLimit = overrides.callbackGasLimit || bigNumberify(0);
  const minOutputAmount = overrides.minOutputAmount || 0;
  const shouldUnwrapNativeToken = overrides.shouldUnwrapNativeToken || false;
  const referralCode = overrides.referralCode || ethers.constants.HashZero;

  if (
    orderType === OrderType.MarketSwap ||
    orderType === OrderType.LimitSwap ||
    orderType === OrderType.MarketIncrease ||
    orderType === OrderType.LimitIncrease
  ) {
    await initialCollateralToken.mint(orderVault.address, initialCollateralDeltaAmount);
  }

  await wnt.mint(orderVault.address, executionFeeToMint);

  const params = {
    addresses: {
      receiver: receiver.address,
      callbackContract: callbackContract.address,
      market: market.marketToken,
      initialCollateralToken: initialCollateralToken.address,
      swapPath,
    },
    numbers: {
      sizeDeltaUsd,
      initialCollateralDeltaAmount,
      acceptablePrice,
      triggerPrice,
      executionFee,
      callbackGasLimit,
      minOutputAmount,
    },
    orderType,
    decreasePositionSwapType,
    isLong,
    shouldUnwrapNativeToken,
    referralCode,
  };

  return await logGasUsage({
    tx: orderHandler.connect(sender).createOrder(account.address, params),
    label: gasUsageLabel,
  });
}

export async function executeOrder(fixture, overrides = {}) {
  const { wnt, usdc } = fixture.contracts;
  const { gasUsageLabel, oracleBlockNumberOffset } = overrides;
  const { reader, dataStore, orderHandler } = fixture.contracts;
  const tokens = overrides.tokens || [wnt.address, usdc.address];
  const precisions = overrides.precisions || [8, 18];
  const minPrices = overrides.minPrices || [expandDecimals(5000, 4), expandDecimals(1, 6)];
  const maxPrices = overrides.maxPrices || [expandDecimals(5000, 4), expandDecimals(1, 6)];
  const orderKeys = await getOrderKeys(dataStore, 0, 10);
  const orderKey = orderKeys[orderKeys.length - 1];
  const order = await reader.getOrder(dataStore.address, orderKey);
  let oracleBlockNumber = overrides.oracleBlockNumber || order.numbers.updatedAtBlock;
  oracleBlockNumber = bigNumberify(oracleBlockNumber);

  const oracleBlocks = overrides.oracleBlocks;
  const minOracleBlockNumbers = overrides.minOracleBlockNumbers;
  const maxOracleBlockNumbers = overrides.maxOracleBlockNumbers;
  const oracleTimestamps = overrides.oracleTimestamps;
  const blockHashes = overrides.blockHashes;

  if (oracleBlockNumberOffset) {
    if (oracleBlockNumberOffset > 0) {
      mine(oracleBlockNumberOffset);
    }

    oracleBlockNumber = oracleBlockNumber.add(oracleBlockNumberOffset);
  }

  const params = {
    key: orderKey,
    oracleBlockNumber,
    tokens,
    precisions,
    minPrices,
    maxPrices,
    simulate: overrides.simulate,
    execute: overrides.simulate ? orderHandler.simulateExecuteOrder : orderHandler.executeOrder,
    gasUsageLabel,
    oracleBlocks,
    minOracleBlockNumbers,
    maxOracleBlockNumbers,
    oracleTimestamps,
    blockHashes,
  };

  return await executeWithOracleParams(fixture, params);
}

export async function handleOrder(fixture, overrides = {}) {
  const createResult = await createOrder(fixture, overrides.create);
  const executeResult = await executeOrder(fixture, overrides.execute);
  return { createResult, executeResult };
}
