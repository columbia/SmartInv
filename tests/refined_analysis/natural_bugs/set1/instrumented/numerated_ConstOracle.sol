1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 
12 contract ConstOracle {
13     uint256 public tokenPrice;
14 
15     constructor(uint256 _price) public {
16         tokenPrice = _price;
17     }
18 
19     function getPrice() external view returns (uint256) {
20         return tokenPrice;
21     }
22 }
