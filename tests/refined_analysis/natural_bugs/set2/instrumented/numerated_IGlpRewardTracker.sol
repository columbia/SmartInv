1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IGlpRewardTracker {
5 
6     function claimable(address _account) external view returns (uint256);
7 }