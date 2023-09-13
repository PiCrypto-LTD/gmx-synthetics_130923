import "./../openzeppelin/security/ReentrancyGuard.sol";
import "./../role/RoleModule.sol";
import "./SwapUtils.sol";
import "./../role/RoleStore.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\SwapHandler
//SPDX-License-Identifier: None




//import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

//import "../role/RoleModule.sol";
//import "./SwapUtils.sol";

/**
 * @title SwapHandler
 * @dev A contract to help with swap functions
 */
contract SwapHandler is ReentrancyGuard, RoleModule {
    constructor(RoleStore _roleStore) RoleModule(_roleStore) {}

    /**
     * @dev perform a swap based on the given params
     * @param params SwapUtils.SwapParams
     * @return (outputToken, outputAmount)
     */
    function swap(
        SwapUtils.SwapParams memory params
    )
        external
        nonReentrant
        onlyController
        returns (address, uint256)
    {
        return SwapUtils.swap(params);
    }
}