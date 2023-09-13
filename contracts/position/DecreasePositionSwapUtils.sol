import "./PositionUtils.sol";
import "./../order/Order.sol";
import "./Position.sol";
import "./../market/Market.sol";
import "./../swap/SwapUtils.sol";
import "./../bank/Bank.sol";
import "./../error/Errors.sol";
import "./../error/ErrorUtils.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\DecreasePositionSwapUtils
//SPDX-License-Identifier: None




//import "./PositionUtils.sol";

library DecreasePositionSwapUtils {
    using Order for Order.Props;
    using Position for Position.Props;

    // swap the withdrawn collateral from collateralToken to pnlToken if needed
    function swapWithdrawnCollateralToPnlToken(
        PositionUtils.UpdatePositionParams memory params,
        PositionUtils.DecreasePositionCollateralValues memory values
    ) external returns (PositionUtils.DecreasePositionCollateralValues memory) {
        if (values.output.outputAmount > 0 && params.order.decreasePositionSwapType() == Order.DecreasePositionSwapType.SwapCollateralTokenToPnlToken) {
            Market.Props[] memory swapPathMarkets = new Market.Props[](1);
            swapPathMarkets[0] = params.market;

            try params.contracts.swapHandler.swap(
                SwapUtils.SwapParams(
                    params.contracts.dataStore,
                    params.contracts.eventEmitter,
                    params.contracts.oracle,
                    Bank(payable(params.market.marketToken)),
                    params.orderKey,
                    params.position.collateralToken(), // tokenIn
                    values.output.outputAmount, // amountIn
                    swapPathMarkets, // markets
                    0, // minOutputAmount
                    params.market.marketToken, // receiver
                    params.order.uiFeeReceiver(), // uiFeeReceiver
                    false // shouldUnwrapNativeToken
                )
            ) returns (address tokenOut, uint256 swapOutputAmount) {
                if (tokenOut != values.output.secondaryOutputToken) {
                    revert Errors.InvalidOutputToken(tokenOut, values.output.secondaryOutputToken);
                }
                // combine the values into outputToken and outputAmount
                values.output.outputToken = tokenOut;
                values.output.outputAmount = values.output.secondaryOutputAmount + swapOutputAmount;
                values.output.secondaryOutputAmount = 0;
            } catch Error(string memory reason) {
                emit SwapUtils.SwapReverted(reason, "");
            } catch (bytes memory reasonBytes) {
                (string memory reason, /* bool hasRevertMessage */) = ErrorUtils.getRevertMessage(reasonBytes);
                emit SwapUtils.SwapReverted(reason, reasonBytes);
            }
        }

        return values;
    }

    // swap the realized profit from the pnlToken to the collateralToken if needed
    function swapProfitToCollateralToken(
        PositionUtils.UpdatePositionParams memory params,
        address pnlToken,
        uint256 profitAmount
    ) external returns (bool, uint256) {
        if (profitAmount > 0 && params.order.decreasePositionSwapType() == Order.DecreasePositionSwapType.SwapPnlTokenToCollateralToken) {
            Market.Props[] memory swapPathMarkets = new Market.Props[](1);
            swapPathMarkets[0] = params.market;

            try params.contracts.swapHandler.swap(
                SwapUtils.SwapParams(
                    params.contracts.dataStore,
                    params.contracts.eventEmitter,
                    params.contracts.oracle,
                    Bank(payable(params.market.marketToken)),
                    params.orderKey,
                    pnlToken, // tokenIn
                    profitAmount, // amountIn
                    swapPathMarkets, // markets
                    0, // minOutputAmount
                    params.market.marketToken, // receiver
                    params.order.uiFeeReceiver(), // uiFeeReceiver
                    false // shouldUnwrapNativeToken
                )
            ) returns (address /* tokenOut */, uint256 swapOutputAmount) {
                return (true, swapOutputAmount);
            } catch Error(string memory reason) {
                emit SwapUtils.SwapReverted(reason, "");
            } catch (bytes memory reasonBytes) {
                (string memory reason, /* bool hasRevertMessage */) = ErrorUtils.getRevertMessage(reasonBytes);
                emit SwapUtils.SwapReverted(reason, reasonBytes);
            }
        }

        return (false, 0);
    }
}