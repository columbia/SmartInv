1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
5 
6 /// @title UniRef interface
7 /// @author Fei Protocol
8 interface IUniRef {
9     // ----------- Events -----------
10 
11     event PairUpdate(address indexed oldPair, address indexed newPair);
12 
13     // ----------- Governor only state changing api -----------
14 
15     function setPair(address newPair) external;
16 
17     // ----------- Getters -----------
18 
19     function pair() external view returns (IUniswapV2Pair);
20 
21     function token() external view returns (address);
22 
23     function getReserves() external view returns (uint256 feiReserves, uint256 tokenReserves);
24 }
