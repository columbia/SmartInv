1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IConvexBasicRewardsArbi {
5 
6   struct EarnedData {
7         address token;
8         uint256 amount;
9     }
10 
11   function stakeFor(address, uint256) external returns (bool);
12 
13   function balanceOf(address) external view returns (uint256);
14 
15   function earned(address) external view returns (EarnedData memory);
16 
17   function withdrawAll(bool) external returns (bool);
18 
19   function withdraw(uint256, bool) external returns (bool);
20 
21   // function withdrawAndUnwrap(uint256, bool) external returns (bool);
22 
23   function getReward(address) external;
24 
25   function stake(uint256) external returns (bool);
26 
27   function claimable_reward (address, address) external view returns (uint256);
28 
29   function rewards(address) external view returns (uint256);
30 }