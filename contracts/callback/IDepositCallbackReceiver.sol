import "./../event/EventUtils.sol";
import "./../deposit/Deposit.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\IDepositCallbackReceiver
//SPDX-License-Identifier: None




//import "../event/EventUtils.sol";
//import "../deposit/Deposit.sol";

// @title IDepositCallbackReceiver
// @dev interface for a deposit callback contract
interface IDepositCallbackReceiver {
    // @dev called after a deposit execution
    // @param key the key of the deposit
    // @param deposit the deposit that was executed
    function afterDepositExecution(bytes32 key, Deposit.Props memory deposit, EventUtils.EventLogData memory eventData) external;

    // @dev called after a deposit cancellation
    // @param key the key of the deposit
    // @param deposit the deposit that was cancelled
    function afterDepositCancellation(bytes32 key, Deposit.Props memory deposit, EventUtils.EventLogData memory eventData) external;
}