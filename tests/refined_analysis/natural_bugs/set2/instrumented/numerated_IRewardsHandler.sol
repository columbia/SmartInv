1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 interface IRewardsHandler {
6 
7     struct UserBalance {
8         uint allocPoint; // Allocation points
9         uint lastMul;
10     }
11 
12     function receiveFee(address token, uint amount) external;
13 
14     function updateLPShares(uint fnftId, uint newShares) external;
15 
16     function updateBasicShares(uint fnftId, uint newShares) external;
17 
18     function getAllocPoint(uint fnftId, address token, bool isBasic) external view returns (uint);
19 
20     function claimRewards(uint fnftId, address caller) external returns (uint);
21 
22     function setStakingContract(address stake) external;
23 
24     function getRewards(uint fnftId, address token) external view returns (uint);
25 }
