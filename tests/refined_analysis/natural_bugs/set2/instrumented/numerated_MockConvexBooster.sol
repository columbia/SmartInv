1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockERC20.sol";
5 import "./MockConvexBaseRewardPool.sol";
6 
7 contract MockConvexBooster is MockERC20 {
8     MockConvexBaseRewardPool public reward;
9     MockERC20 public lpToken;
10 
11     constructor(address _reward, address _lpTokens) {
12         reward = MockConvexBaseRewardPool(_reward);
13         lpToken = MockERC20(_lpTokens);
14     }
15 
16     function deposit(
17         uint256, /* poolId*/
18         uint256 lpTokens,
19         bool stake
20     ) public returns (bool) {
21         lpToken.transferFrom(msg.sender, address(reward), lpTokens);
22 
23         if (stake) {
24             reward.stakeFor(msg.sender, lpTokens);
25         }
26 
27         return true;
28     }
29 }
