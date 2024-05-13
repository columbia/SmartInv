1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IFortressCompounder {
5 
6     function getUnderlyingAssets() external view returns (address[] memory);
7 
8     function getName() external view returns (string memory);
9 
10     function getSymbol() external view returns (string memory);
11 
12     function getDescription() external view returns (string memory);
13 }