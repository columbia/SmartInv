1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 interface ICoreOracle {
6     function pricePerShare() external view returns (uint256);
7 }
