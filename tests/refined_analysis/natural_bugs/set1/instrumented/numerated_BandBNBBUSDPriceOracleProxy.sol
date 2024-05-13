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
12 interface IBandOracleAggregator {
13     function getReferenceData(string memory base, string memory quote)
14         external
15         view
16         returns (uint256);
17 }
18 
19 
20 contract BandBNBBUSDPriceOracleProxy {
21     IBandOracleAggregator public aggregator;
22 
23     constructor(IBandOracleAggregator _aggregator) public {
24         aggregator = _aggregator;
25     }
26 
27     function getPrice() public view returns (uint256) {
28         return aggregator.getReferenceData("BNB", "USD");
29     }
30 }
