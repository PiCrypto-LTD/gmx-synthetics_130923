import "./../bank/StrictBank.sol";
import "./../role/RoleStore.sol";
import "./../data/DataStore.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0xD9AebEA68DE4b4A3B58833e1bc2AEB9682883AB0#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\DepositHandler\DepositVault
//SPDX-License-Identifier: None




//import "../bank/StrictBank.sol";

// @title DepositVault
// @dev Vault for deposits
contract DepositVault is StrictBank {
    constructor(RoleStore _roleStore, DataStore _dataStore) StrictBank(_roleStore, _dataStore) {}
}