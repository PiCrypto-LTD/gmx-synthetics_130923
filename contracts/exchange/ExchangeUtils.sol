import "./../bank/StrictBank.sol";
import "./../chain/Chain.sol";
import "./../data/DataStore.sol";
import "./../data/Keys.sol";
import "./../error/Errors.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\ExchangeUtils
//SPDX-License-Identifier: None




//import "../bank/StrictBank.sol";
//import "../chain/Chain.sol";
//import "../data/DataStore.sol";
//import "../data/Keys.sol";

// @title ExchangeUtils
// @dev Library for exchange helper functions
library ExchangeUtils {
    // @dev validate that sufficient time has passed for request to be cancelled
    // @param dataStore DataStore
    // @param createdAtBlock the block the request was created at
    // @param requestType the type of the request
    function validateRequestCancellation(
        DataStore dataStore,
        uint256 createdAtBlock,
        string memory requestType
    ) internal view {
        uint256 requestExpirationAge = dataStore.getUint(Keys.REQUEST_EXPIRATION_BLOCK_AGE);
        uint256 requestAge = Chain.currentBlockNumber() - createdAtBlock;
        if (requestAge < requestExpirationAge) {
            revert Errors.RequestNotYetCancellable(requestAge, requestExpirationAge, requestType);
        }
    }
}