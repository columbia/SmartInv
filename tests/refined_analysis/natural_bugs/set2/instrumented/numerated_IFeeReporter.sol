1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 
6 interface IFeeReporter {
7 
8     function getFlatWeiFee(address asset) external view returns (uint);
9 
10     function getERC20Fee(address asset) external view returns (uint);
11 
12 }
