import "./../openzeppelin/token/ERC20/ERC20.sol";
import "./../bank/Bank.sol";
import "./../role/RoleStore.sol";
import "./../data/DataStore.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\MarketToken
//SPDX-License-Identifier: None




//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "../bank/Bank.sol";

// @title MarketToken
// @dev The market token for a market, stores funds for the market and keeps track
// of the liquidity owners
contract MarketToken is ERC20, Bank {
    constructor(RoleStore _roleStore, DataStore _dataStore) ERC20("GMX Market", "GM") Bank(_roleStore, _dataStore) {
    }

    // @dev mint market tokens to an account
    // @param account the account to mint to
    // @param amount the amount of tokens to mint
    function mint(address account, uint256 amount) external onlyController {
        _mint(account, amount);
    }

    // @dev burn market tokens from an account
    // @param account the account to burn tokens for
    // @param amount the amount of tokens to burn
    function burn(address account, uint256 amount) external onlyController {
        _burn(account, amount);
    }
}