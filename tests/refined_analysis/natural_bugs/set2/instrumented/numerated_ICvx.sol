1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 interface ICvx {
5     function reductionPerCliff() external view returns(uint256);
6     function totalSupply() external view returns(uint256);
7     function totalCliffs() external view returns(uint256);
8     function maxSupply() external view returns(uint256);
9 }