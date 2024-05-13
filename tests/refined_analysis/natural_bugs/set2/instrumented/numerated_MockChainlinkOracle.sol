1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
5 
6 contract MockChainlinkOracle is AggregatorV3Interface {
7     // fixed value
8     int256 public _value;
9     uint8 public _decimals;
10 
11     // mocked data
12     uint80 _roundId;
13     uint256 _startedAt;
14     uint256 _updatedAt;
15     uint80 _answeredInRound;
16 
17     constructor(int256 value, uint8 oracleDecimals) {
18         _value = value;
19         _decimals = oracleDecimals;
20         _roundId = 42;
21         _startedAt = 1620651856;
22         _updatedAt = 1620651856;
23         _answeredInRound = 42;
24     }
25 
26     function decimals() external view override returns (uint8) {
27         return _decimals;
28     }
29 
30     function description() external pure override returns (string memory) {
31         return "MockChainlinkOracle";
32     }
33 
34     function getRoundData(uint80 _getRoundId)
35         external
36         view
37         override
38         returns (
39             uint80 roundId,
40             int256 answer,
41             uint256 startedAt,
42             uint256 updatedAt,
43             uint80 answeredInRound
44         )
45     {
46         return (_getRoundId, _value, 1620651856, 1620651856, _getRoundId);
47     }
48 
49     function latestRoundData()
50         external
51         view
52         override
53         returns (
54             uint80 roundId,
55             int256 answer,
56             uint256 startedAt,
57             uint256 updatedAt,
58             uint80 answeredInRound
59         )
60     {
61         return (_roundId, _value, block.timestamp, block.timestamp, _answeredInRound);
62     }
63 
64     function set(
65         uint80 roundId,
66         int256 answer,
67         uint256 startedAt,
68         uint256 updatedAt,
69         uint80 answeredInRound
70     ) external {
71         _roundId = roundId;
72         _value = answer;
73         _startedAt = startedAt;
74         _updatedAt = updatedAt;
75         _answeredInRound = answeredInRound;
76     }
77 
78     function version() external pure override returns (uint256) {
79         return 1;
80     }
81 }
