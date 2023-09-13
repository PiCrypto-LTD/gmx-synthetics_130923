import "./../data/Keys.sol";
import "./../data/DataStore.sol";
pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\GlobalReentrancyGuard
//SPDX-License-Identifier: None




//import "../data/Keys.sol";
//import "../data/DataStore.sol";

abstract contract GlobalReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.
    uint256 private constant NOT_ENTERED = 0;
    uint256 private constant ENTERED = 1;

    DataStore public immutable dataStore;

    constructor(DataStore _dataStore) {
        dataStore = _dataStore;
    }

    modifier globalNonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        uint256 status = dataStore.getUint(Keys.REENTRANCY_GUARD_STATUS);

        require(status == NOT_ENTERED, "ReentrancyGuard: reentrant call");

        dataStore.setUint(Keys.REENTRANCY_GUARD_STATUS, ENTERED);
    }

    function _nonReentrantAfter() private {
        dataStore.setUint(Keys.REENTRANCY_GUARD_STATUS, NOT_ENTERED);
    }
}