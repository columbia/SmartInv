1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IPancakeFactory {
5     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
6 
7     function feeTo() external view returns (address);
8     function feeToSetter() external view returns (address);
9 
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13 
14     function createPair(address tokenA, address tokenB) external returns (address pair);
15 
16     function setFeeTo(address) external;
17     function setFeeToSetter(address) external;
18 }