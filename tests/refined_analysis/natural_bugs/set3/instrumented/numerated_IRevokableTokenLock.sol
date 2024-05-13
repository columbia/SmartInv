1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 interface IRevokableTokenLock {
5     function setupVesting(
6         address recipient,
7         uint256 _unlockBegin,
8         uint256 _unlockCliff,
9         uint256 _unlockEnd
10     ) external;
11 
12     function lock(address recipient, uint256 amount) external;
13 }
