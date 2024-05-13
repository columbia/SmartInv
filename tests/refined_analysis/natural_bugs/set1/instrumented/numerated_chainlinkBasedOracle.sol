1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 interface IChainlinkAggregatorV2V3 {
6     function decimals() external view returns (uint8);
7     function description() external view returns (string memory);
8     function latestAnswer() external view returns (int256);
9     function latestTimestamp() external view returns (uint256);
10 }
11 
12 /// @notice Provides generic contract for fetching underlying/ETH Chainlink price, using underlying/USD and ETH/USD Chainlink oracles
13 contract ChainlinkBasedOracle is IChainlinkAggregatorV2V3 {
14     address immutable public underlyingUSDChainlinkAggregator;
15     address immutable public ETHUSDChainlinkAggregator;
16     string desc;
17 
18     constructor(
19         address _underlyingUSDChainlinkAggregator,
20         address _ETHUSDChainlinkAggregator,
21         string memory _description
22     ) {
23         underlyingUSDChainlinkAggregator = _underlyingUSDChainlinkAggregator;
24         ETHUSDChainlinkAggregator = _ETHUSDChainlinkAggregator;
25         desc = _description;
26     }
27 
28     function decimals() external pure override returns (uint8) {
29         return 18;
30     }
31 
32     function description() external view override returns (string memory) {
33         return desc;
34     }
35 
36     /// @notice Get latest underlying/USD Chainlink feed timestamp
37     /// @return timestamp latest underlying/USD Chainlink feed timestamp
38     function latestTimestamp() external view override returns (uint256 timestamp) {
39         return IChainlinkAggregatorV2V3(underlyingUSDChainlinkAggregator).latestTimestamp();
40     }
41 
42     /// @notice Get underlying/ETH price. It does not check Chainlink oracles staleness! If staleness check needed, it's recommended to use latestTimestamp() functions on both Chainlink feeds used
43     /// @return answer underlying/ETH price or 0 if failure
44     function latestAnswer() external view override returns (int256 answer) {
45         // get the ETH/USD and underlying/USD prices
46         int256 ETHUSDPrice = IChainlinkAggregatorV2V3(ETHUSDChainlinkAggregator).latestAnswer();
47         int256 underlyingUSDPrice = IChainlinkAggregatorV2V3(underlyingUSDChainlinkAggregator).latestAnswer();
48 
49         if (ETHUSDPrice <= 0 || underlyingUSDPrice <= 0) return 0;
50 
51         // calculate underlying/ETH price
52         return underlyingUSDPrice * 1e18 / ETHUSDPrice;
53     }
54 }
