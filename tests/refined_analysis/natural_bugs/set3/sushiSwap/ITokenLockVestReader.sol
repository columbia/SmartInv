// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./IRevokableTokenLock.sol";

interface ITokenLockVestReader is IRevokableTokenLock {
    struct VestingParams {
        uint256 unlockBegin;
        uint256 unlockCliff;
        uint256 unlockEnd;
        uint256 lockedAmounts;
        uint256 claimedAmounts;
    }

    function vesting(address) external view returns (VestingParams memory);
}
