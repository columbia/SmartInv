1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 contract MockAggregatorProxy {
5   struct Data {
6     uint80 roundId;         // The round ID.
7     int256 answer;          // The price.
8     uint256 timestamp;      // Timestamp of when the round was updated.
9     uint256 roundTimestamp; // Timestamp of when the round started.
10     uint80 answeredInRound; // The round ID of the round in which the answer was computed.
11   }
12 
13   string constant description_ = "Mock Aggregator";
14   uint256 constant version_ = 1;
15   uint8 public decimals_;
16   uint80 public currentRoundId_;
17   mapping(uint256 => Data) public data_;
18 
19   constructor(uint8 _decimals) {
20     decimals_ = _decimals;
21   }
22 
23   function mockSetData(Data calldata data) external {
24     data_[data.roundId] = data;
25     currentRoundId_ = data.roundId;
26   }
27 
28   function mockSetValidAnswer(int256 answer) external {
29     currentRoundId_++;
30     data_[currentRoundId_] = 
31       Data(
32         currentRoundId_,
33         answer,
34         block.timestamp,
35         block.timestamp,
36         currentRoundId_
37       );
38   }
39 
40   function latestAnswer() external view returns (int256) {
41     return data_[currentRoundId_].answer; 
42   }
43 
44   function latestTimestamp() external view returns (uint256) {
45     return data_[currentRoundId_].timestamp;
46   }
47 
48   function latestRound() external view returns (uint256) {
49     return currentRoundId_;
50   }
51 
52   function getAnswer(uint256 roundId) external view returns (int256) {
53     return data_[roundId].answer;
54   }
55 
56   function getTimestamp(uint256 roundId) external view returns (uint256) {
57     return data_[roundId].timestamp;
58   }
59 
60   function decimals() external view returns (uint8) {
61     return decimals_;
62   }
63 
64   function description() external pure returns (string memory) {
65     return description_;
66   }
67 
68   function version() external pure returns (uint256) {
69     return version_;
70   }
71 
72   function getRoundData(uint80 _roundId) external view 
73   returns (
74       uint80 roundId,
75       int256 answer,
76       uint256 startedAt,
77       uint256 updatedAt,
78       uint80 answeredInRound
79     ) {
80     Data memory result = data_[_roundId];
81     return (
82       result.roundId,
83       result.answer,
84       result.timestamp,
85       result.roundTimestamp,
86       result.answeredInRound
87     );
88   }
89 
90   function latestRoundData() external view 
91   returns (
92       uint80 roundId,
93       int256 answer,
94       uint256 startedAt,
95       uint256 updatedAt,
96       uint80 answeredInRound
97     ) {
98     Data memory result = data_[currentRoundId_];
99     return (
100       result.roundId,
101       result.answer,
102       result.timestamp,
103       result.roundTimestamp,
104       result.answeredInRound
105     );
106   }
107 }
