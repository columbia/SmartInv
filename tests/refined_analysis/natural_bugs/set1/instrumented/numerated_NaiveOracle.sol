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
11 import {Ownable} from "../lib/Ownable.sol";
12 
13 
14 // Oracle only for test
15 contract NaiveOracle is Ownable {
16     uint256 public tokenPrice;
17 
18     function setPrice(uint256 newPrice) external onlyOwner {
19         tokenPrice = newPrice;
20     }
21 
22     function getPrice() external view returns (uint256) {
23         return tokenPrice;
24     }
25 }
