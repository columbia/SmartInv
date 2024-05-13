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
12 interface IChainlink {
13     function latestAnswer() external view returns (uint256);
14 }
15 
16 
17 // for WETH-USDT(decimals=6) price convert
18 
19 contract ChainlinkETHUSDTPriceOracleProxy {
20     address public chainlink = 0xEe9F2375b4bdF6387aa8265dD4FB8F16512A1d46;
21 
22     function getPrice() external view returns (uint256) {
23         return 10**24 / IChainlink(chainlink).latestAnswer();
24     }
25 }
