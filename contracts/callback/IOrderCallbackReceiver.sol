import "./../event/EventUtils.sol";
import "./../order/Order.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\IOrderCallbackReceiver
//SPDX-License-Identifier: None




//import "../event/EventUtils.sol";
//import "../order/Order.sol";

// @title IOrderCallbackReceiver
// @dev interface for an order callback contract
interface IOrderCallbackReceiver {
    // @dev called after an order execution
    // @param key the key of the order
    // @param order the order that was executed
    function afterOrderExecution(bytes32 key, Order.Props memory order, EventUtils.EventLogData memory eventData) external;

    // @dev called after an order cancellation
    // @param key the key of the order
    // @param order the order that was cancelled
    function afterOrderCancellation(bytes32 key, Order.Props memory order, EventUtils.EventLogData memory eventData) external;

    // @dev called after an order has been frozen, see OrderUtils.freezeOrder in OrderHandler for more info
    // @param key the key of the order
    // @param order the order that was frozen
    function afterOrderFrozen(bytes32 key, Order.Props memory order, EventUtils.EventLogData memory eventData) external;
}