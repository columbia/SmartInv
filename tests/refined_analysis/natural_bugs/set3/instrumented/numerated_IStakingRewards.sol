1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IStakingRewards {
5     function stakeTo(uint256 amount, address _to) external;
6     function notifyRewardAmount(uint256 reward) external;
7 }