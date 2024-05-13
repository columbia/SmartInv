1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IUniswapV3Pool {
5     
6   function token0() external returns (address);
7 
8   function token1() external returns (address);
9 
10   function fee() external returns (uint24);
11 }