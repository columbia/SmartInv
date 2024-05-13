1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { Pools, Pool } from "../carbon/Pools.sol";
5 import { Token } from "../token/Token.sol";
6 
7 contract TestPools is Pools {
8     function test_poolById(uint256 poolId) external view returns (Pool memory) {
9         return _poolById(poolId);
10     }
11 
12     function test_createPool(Token token0, Token token1) external returns (Pool memory) {
13         return _createPool(token0, token1);
14     }
15 }
