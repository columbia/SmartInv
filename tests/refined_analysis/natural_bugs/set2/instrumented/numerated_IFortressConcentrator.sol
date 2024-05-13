1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IFortressConcentrator {
5 
6     function getUnderlyingAssets() external view returns (address[] memory);
7 
8     function getName() external view returns (string memory);
9 
10     function getSymbol() external view returns (string memory);
11 
12     function getDescription() external view returns (string memory);
13 
14     function getCompounder() external view returns (address);
15 
16     function claim(address _owner, address _receiver) external returns (uint256 _rewards);
17 }