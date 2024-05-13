1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 // Angle StakingRewards contract
5 interface IAngleStakingRewards {
6     function stakingToken() external returns (address);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function stake(uint256 amount) external;
11 
12     function withdraw(uint256 amount) external;
13 
14     function getReward() external;
15 }
