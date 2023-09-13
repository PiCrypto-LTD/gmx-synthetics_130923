import "./../error/ErrorUtils.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0xf86aE903B5866bCf8723B9C3642758C87f2F3Ef2#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\Config\BasicMulticall
//SPDX-License-Identifier: None




//import "../error/ErrorUtils.sol";

/**
 * @title BasicMulticall
 */
abstract contract BasicMulticall {
    /**
     * @dev Receives and executes a batch of function calls on this contract.
     */
    function multicall(bytes[] calldata data) external virtual returns (bytes[] memory results) {
        results = new bytes[](data.length);

        for (uint256 i; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);

            if (!success) {
                ErrorUtils.revertWithParsedMessage(result);
            }

            results[i] = result;
        }

        return results;
    }
}