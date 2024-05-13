1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
5 
6 /// @title a PCV Deposit interface
7 /// @author Fei Protocol
8 interface IUniswapPCVDeposit {
9     // ----------- Events -----------
10 
11     event MaxBasisPointsFromPegLPUpdate(uint256 oldMaxBasisPointsFromPegLP, uint256 newMaxBasisPointsFromPegLP);
12 
13     // ----------- Governor only state changing api -----------
14 
15     function setMaxBasisPointsFromPegLP(uint256 amount) external;
16 
17     // ----------- Getters -----------
18 
19     function router() external view returns (IUniswapV2Router02);
20 
21     function liquidityOwned() external view returns (uint256);
22 
23     function maxBasisPointsFromPegLP() external view returns (uint256);
24 }
