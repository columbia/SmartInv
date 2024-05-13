1 // SPDX-License-Identifier: agpl-3.0
2 pragma solidity ^0.8.17;
3 
4 interface IChainlinkAggregator {
5   function decimals() external view returns (uint8);
6 
7   function latestAnswer() external view returns (int256);
8 
9   function latestTimestamp() external view returns (uint256);
10 
11   function latestRound() external view returns (uint256);
12 
13   function getAnswer(uint256 roundId) external view returns (int256);
14 
15   function getTimestamp(uint256 roundId) external view returns (uint256);
16 
17   function latestRoundData()
18     external
19     view
20     returns (
21       uint80 roundId,
22       int256 answer,
23       uint256 startedAt,
24       uint256 updatedAt,
25       uint80 answeredInRound
26     );
27 
28   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);
29   event NewRound(uint256 indexed roundId, address indexed startedBy);
30 }