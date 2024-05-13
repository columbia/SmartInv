1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 
5 interface IStakingRewards {
6     // Mutative
7     function stake(uint256 amount) external;
8 
9     function withdraw(uint256 amount) external;
10 
11     function getReward() external;
12 
13     function exit() external;
14     // Views
15     function lastTimeRewardApplicable() external view returns (uint256);
16 
17     function rewardPerToken() external view returns (uint256);
18 
19     function earned(address account) external view returns (uint256);
20 
21     function getRewardForDuration() external view returns (uint256);
22 
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27 }
