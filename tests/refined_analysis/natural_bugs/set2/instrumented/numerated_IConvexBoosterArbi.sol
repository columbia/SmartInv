1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 pragma abicoder v2;
4 
5 interface IConvexBoosterArbi {
6   
7   struct PoolInfo {
8         address lptoken; //the curve lp token
9         address gauge; //the curve gauge
10         address rewards; //the main reward/staking contract
11         bool shutdown; //is this pool shutdown?
12         address factory; //a reference to the curve factory used to create this pool (needed for minting crv)
13   }
14         
15   function poolInfo(uint256 _pid) external view returns (PoolInfo memory);
16 
17   function depositAll(uint256 _pid, bool _stake) external returns (bool);
18 
19   function deposit(uint256 _pid, uint256 _amount) external returns (bool);
20 
21   function earmarkRewards(uint256 _pid) external returns (bool);
22 }