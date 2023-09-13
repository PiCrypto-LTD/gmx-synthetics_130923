import "./../deposit/DepositUtils.sol";
import "./../oracle/OracleUtils.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0xD9AebEA68DE4b4A3B58833e1bc2AEB9682883AB0#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\DepositHandler\IDepositHandler
//SPDX-License-Identifier: None




//import "../deposit/DepositUtils.sol";
//import "../oracle/OracleUtils.sol";

interface IDepositHandler {
    function createDeposit(address account, DepositUtils.CreateDepositParams calldata params) external returns (bytes32);
    function cancelDeposit(bytes32 key) external;
    function simulateExecuteDeposit(bytes32 key, OracleUtils.SimulatePricesParams memory params) external;
}