import "./../error/ErrorUtils.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x3B070aA6847bd0fB56eFAdB351f49BBb7619dbc2#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\ExchangeRouter\PayableMulticall
//SPDX-License-Identifier: None




//import "../error/ErrorUtils.sol";

/**
 * @title PayableMulticall
 * @dev Contract to help call multiple functions in a single transaction
 * all function calls will have the original sender as the msg.sender value
 * IMPORTANT: in the multicall, msg.value will be the same for each delegatecall
 * extra care should be taken if msg.value is used in any of the functions of the inheriting contract
 */
abstract contract PayableMulticall {
    /**
     * @dev Receives and executes a batch of function calls on this contract.
     */
// @aduit-check what permissions does the exchange router have, in case someone uses and impersonates
    function multicall(bytes[] calldata data) external payable virtual returns (bytes[] memory results) {
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