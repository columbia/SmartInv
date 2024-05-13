1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity ^0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 
12 interface IDODOLpToken {
13     function mint(address user, uint256 value) external;
14 
15     function burn(address user, uint256 value) external;
16 
17     function balanceOf(address owner) external view returns (uint256);
18 
19     function totalSupply() external view returns (uint256);
20 }
