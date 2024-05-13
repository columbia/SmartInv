1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.0;
4 
5 interface IBabyFactory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10 
11     function getPair(address tokenA, address tokenB) external view returns (address pair);
12     function expectPairFor(address token0, address token1) external view returns (address);
13     function allPairs(uint) external view returns (address pair);
14     function allPairsLength() external view returns (uint);
15 
16     function createPair(address tokenA, address tokenB) external returns (address pair);
17 
18     function setFeeTo(address) external;
19     function setFeeToSetter(address) external;
20 }
