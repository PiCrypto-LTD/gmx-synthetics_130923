pragma solidity 0.8.18;
//webAddress: https://arbiscan.io/address/0x12CA21bd73b5887f4d2A0054Ca52510523f18c60#code
//comparedWebAddress: None
//fileName: arbitrum\GMX_V2\AdlHandler\ReferralTier
//SPDX-License-Identifier: None




// @title ReferralTier
// @dev Struct for referral tiers
library ReferralTier {
    // @param totalRebate the total rebate for the tier (affiliate reward + trader discount)
    // @param discountShare the share of the totalRebate for traders
    struct Props {
        uint256 totalRebate;
        uint256 discountShare;
    }
}