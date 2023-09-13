import "./../bank/StrictBank.sol";
import "./../role/RoleStore.sol";
import "./../data/DataStore.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x3B070aA6847bd0fB56eFAdB351f49BBb7619dbc2#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\ExchangeRouter\WithdrawalVault
//SPDX-License-Identifier: None




//import "../bank/StrictBank.sol";

// @title WithdrawalVault
// @dev Vault for withdrawals
contract WithdrawalVault is StrictBank {
    constructor(RoleStore _roleStore, DataStore _dataStore) StrictBank(_roleStore, _dataStore) {}
}