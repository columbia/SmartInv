1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IConvexVirtualBalanceRewardPool {
5   function earned(address account) external view returns (uint256);
6 }