pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\IWNT
//SPDX-License-Identifier: None




/**
 * @title IWNT
 * @dev Interface for Wrapped Native Tokens, e.g. WETH
 * The contract is named WNT instead of WETH for a more general reference name
 * that can be used on any blockchain
 */
interface IWNT {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}