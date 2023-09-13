import "./../order/BaseOrderUtils.sol";
import "./../oracle/OracleUtils.sol";
import "./../order/Order.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x3B070aA6847bd0fB56eFAdB351f49BBb7619dbc2#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\ExchangeRouter\IOrderHandler
//SPDX-License-Identifier: None




//import "../order/BaseOrderUtils.sol";
//import "../oracle/OracleUtils.sol";

interface IOrderHandler {
    function createOrder(address account, BaseOrderUtils.CreateOrderParams calldata params) external returns (bytes32);

    function simulateExecuteOrder(bytes32 key, OracleUtils.SimulatePricesParams memory params) external;

    function updateOrder(
        bytes32 key,
        uint256 sizeDeltaUsd,
        uint256 acceptablePrice,
        uint256 triggerPrice,
        uint256 minOutputAmount,
        Order.Props memory order
    ) external;

    function cancelOrder(bytes32 key) external;
}