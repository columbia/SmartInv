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
17 // for SNX-USDC(decimals=6) price convert
18 
19 contract ChainlinkSNXUSDCPriceOracleProxy {
20     address public chainlink = 0xDC3EA94CD0AC27d9A86C180091e7f78C683d3699;
21 
22     function getPrice() external view returns (uint256) {
23         return IChainlink(chainlink).latestAnswer() / 100;
24     }
25 }
