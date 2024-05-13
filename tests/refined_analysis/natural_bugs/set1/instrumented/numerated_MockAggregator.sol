1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.3;
3 
4 contract MockAggregator {
5     int256 internal _answer;
6 
7     function setAnswer(int256 _a) external {
8         _answer = _a;
9     }
10 
11     function latestAnswer() external view returns (int256) {
12         return _answer;
13     }
14 
15     function latestRoundData()
16         external
17         view
18         returns (
19             uint80,
20             int256,
21             uint256,
22             uint256,
23             uint80
24         )
25     {
26         return (0, _answer, 0, 0, 0);
27     }
28 }
