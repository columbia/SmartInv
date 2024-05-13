1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IBalancerPool {
5 
6   function getPoolId() external view returns (bytes32);
7 
8 }