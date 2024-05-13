1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 // Chainlink Aggregator
5 interface IAggregator {
6     function latestAnswer() external view returns (int256 answer);
7 }
8 
9 
10 interface IExchangeRateFeeder {
11     function exchangeRateOf(
12         address _token,
13         bool _simulate
14     ) external view returns (uint256);
15 }
16 
17 contract aUSTOracle is IExchangeRateFeeder {
18     IAggregator public constant aUST = IAggregator(0x73bB8A4220E5C7Db3E73e4Fcb8d7DCf2efe04805);
19     function exchangeRateOf(address, bool) external view returns (uint256) {
20         return uint256(aUST.latestAnswer());
21     }
22 }