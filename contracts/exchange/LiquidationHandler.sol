import "./BaseOrderHandler.sol";
import "./../openzeppelin/utils/math/SafeCast.sol";
import "./../order/Order.sol";
import "./../utils/Array.sol";
import "./../role/RoleStore.sol";
import "./../data/DataStore.sol";
import "./../event/EventEmitter.sol";
import "./../order/OrderVault.sol";
import "./../oracle/Oracle.sol";
import "./../swap/SwapHandler.sol";
import "./../referral/IReferralStorage.sol";
import "./../oracle/OracleUtils.sol";
import "./../liquidation/LiquidationUtils.sol";
import "./../order/BaseOrderUtils.sol";
import "./../feature/FeatureUtils.sol";
import "./../data/Keys.sol";
import "./../order/OrderUtils.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0xB665B6dBB45ceAf3b126cec98aDB1E611b6a6aea#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\LiquidationHandler\LiquidationHandler
//SPDX-License-Identifier: None




//import "./BaseOrderHandler.sol";

// @title LiquidationHandler
// @dev Contract to handle liquidations
contract LiquidationHandler is BaseOrderHandler {
    using SafeCast for uint256;
    using Order for Order.Props;
    using Array for uint256[];

    constructor(
        RoleStore _roleStore,
        DataStore _dataStore,
        EventEmitter _eventEmitter,
        OrderVault _orderVault,
        Oracle _oracle,
        SwapHandler _swapHandler,
        IReferralStorage _referralStorage
    ) BaseOrderHandler(
        _roleStore,
        _dataStore,
        _eventEmitter,
        _orderVault,
        _oracle,
        _swapHandler,
        _referralStorage
    ) {}

    // @dev executes a position liquidation
    // @param account the account of the position to liquidate
    // @param market the position's market
    // @param collateralToken the position's collateralToken
    // @param isLong whether the position is long or short
    // @param oracleParams OracleUtils.SetPricesParams
    function executeLiquidation(
        address account,
        address market,
        address collateralToken,
        bool isLong,
        OracleUtils.SetPricesParams calldata oracleParams
    ) external
        globalNonReentrant
        onlyLiquidationKeeper
        withOraclePrices(oracle, dataStore, eventEmitter, oracleParams)
    {
        uint256 startingGas = gasleft();

        bytes32 key = LiquidationUtils.createLiquidationOrder(
            dataStore,
            eventEmitter,
            account,
            market,
            collateralToken,
            isLong
        );

        BaseOrderUtils.ExecuteOrderParams memory params = _getExecuteOrderParams(
            key,
            oracleParams,
            msg.sender,
            startingGas,
            Order.SecondaryOrderType.None
        );

        FeatureUtils.validateFeature(params.contracts.dataStore, Keys.executeOrderFeatureDisabledKey(address(this), uint256(params.order.orderType())));

        OrderUtils.executeOrder(params);
    }
}