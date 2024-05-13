1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.5.0;
3 
4 interface IUniswapV2Factory {
5     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
6 
7     function getPair(address tokenA, address tokenB) external view returns (address pair);
8     function allPairs(uint) external view returns (address pair);
9     function allPairsLength() external view returns (uint);
10 
11     function feeTo() external view returns (address);
12     function feeToSetter() external view returns (address);
13 
14     function createPair(address tokenA, address tokenB) external returns (address pair);
15 }
