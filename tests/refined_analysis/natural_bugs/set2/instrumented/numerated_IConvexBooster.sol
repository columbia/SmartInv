1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 pragma abicoder v2;
4 
5 interface IConvexBooster {
6   
7   struct PoolInfo {
8     address lptoken;
9     address token;
10     address gauge;
11     address crvRewards;
12     address stash;
13     bool shutdown;
14   }
15 
16   function poolInfo(uint256 _pid) external view returns (PoolInfo memory);
17 
18   function depositAll(uint256 _pid, bool _stake) external returns (bool);
19 
20   function deposit(uint256 _pid, uint256 _amount, bool _stake) external returns (bool);
21 
22   function earmarkRewards(uint256 _pid) external returns (bool);
23 }