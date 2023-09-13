import "./../withdrawal/WithdrawalUtils.sol";
import "./../oracle/OracleUtils.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x3B070aA6847bd0fB56eFAdB351f49BBb7619dbc2#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\ExchangeRouter\IWithdrawalHandler
//SPDX-License-Identifier: None




//import "../withdrawal/WithdrawalUtils.sol";
//import "../oracle/OracleUtils.sol";

interface IWithdrawalHandler {
    function createWithdrawal(address account, WithdrawalUtils.CreateWithdrawalParams calldata params) external returns (bytes32);
    function cancelWithdrawal(bytes32 key) external;
    function simulateExecuteWithdrawal(bytes32 key, OracleUtils.SimulatePricesParams memory params) external;
}