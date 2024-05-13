1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0;
3 
4 interface AggregatorV3Interface {
5 
6     function decimals() external view returns (uint8);
7     function description() external view returns (string memory);
8     function version() external view returns (uint256);
9 
10     // getRoundData and latestRoundData should both raise "No data present"
11     // if they do not have data to report, instead of returning unset values
12     // which could be misinterpreted as actual reported values.
13     function getRoundData(uint80 _roundId)
14     external
15     view
16     returns (
17         uint80 roundId,
18         int256 answer,
19         uint256 startedAt,
20         uint256 updatedAt,
21         uint80 answeredInRound
22     );
23     function latestRoundData()
24     external
25     view
26     returns (
27         uint80 roundId,
28         int256 answer,
29         uint256 startedAt,
30         uint256 updatedAt,
31         uint80 answeredInRound
32     );
33 
34 }
