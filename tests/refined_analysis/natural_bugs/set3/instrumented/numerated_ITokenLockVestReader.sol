1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 import "./IRevokableTokenLock.sol";
5 
6 interface ITokenLockVestReader is IRevokableTokenLock {
7     struct VestingParams {
8         uint256 unlockBegin;
9         uint256 unlockCliff;
10         uint256 unlockEnd;
11         uint256 lockedAmounts;
12         uint256 claimedAmounts;
13     }
14 
15     function vesting(address) external view returns (VestingParams memory);
16 }
