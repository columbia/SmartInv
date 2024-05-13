1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 interface AggregatorV3Interface {
5     function decimals() external view returns (uint8);
6 
7     function latestRoundData()
8         external
9         view
10         returns (
11             uint80 roundId,
12             int256 answer,
13             uint256 startedAt,
14             uint256 updatedAt,
15             uint80 answeredInRound
16         );
17 }
18 
19 /// @title MimAvaxOracleV1
20 /// @author 0xCalibur
21 /// @notice Oracle used for getting the price of 1 MIM in AVAX using Chainlink
22 contract MimAvaxOracleV1 is AggregatorV3Interface {
23     AggregatorV3Interface public constant MIMUSD = AggregatorV3Interface(0x54EdAB30a7134A16a54218AE64C73e1DAf48a8Fb);
24     AggregatorV3Interface public constant AVAXUSD = AggregatorV3Interface(0x0A77230d17318075983913bC2145DB16C7366156);
25     
26     function decimals() external override pure returns (uint8) {
27         return 18;
28     }
29 
30     function latestRoundData()
31         external
32         view
33         override
34         returns (
35             uint80 roundId,
36             int256 answer,
37             uint256 startedAt,
38             uint256 updatedAt,
39             uint80 answeredInRound
40         )
41     {
42         (,int256 mimUsdFeed,,,) = MIMUSD.latestRoundData();
43         (,int256 avaxUsdFeed,,,) = AVAXUSD.latestRoundData();
44 
45         return (0, (mimUsdFeed * 1e18) / avaxUsdFeed, 0, 0, 0);
46     }
47 }
