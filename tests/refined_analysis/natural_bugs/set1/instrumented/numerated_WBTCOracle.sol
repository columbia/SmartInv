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
12 /// @notice Provides contract for fetching WBTC/ETH Chainlink price, using WBTC/BTC and BTC/ETH Chainlink oracles
13 contract WBTCOracle is IChainlinkAggregatorV2V3 {
14     address immutable public WBTCBTCChainlinkAggregator;
15     address immutable public BTCETHChainlinkAggregator;
16 
17     constructor(
18         address _WBTCBTCChainlinkAggregator,
19         address _BTCETHChainlinkAggregator
20     ) {
21         // WBTCBTCChainlinkAggregator = "0xfdFD9C85aD200c506Cf9e21F1FD8dd01932FBB23";
22         // BTCETHChainlinkAggregator = "0xdeb288F737066589598e9214E782fa5A8eD689e8";
23 
24         WBTCBTCChainlinkAggregator = _WBTCBTCChainlinkAggregator;
25         BTCETHChainlinkAggregator = _BTCETHChainlinkAggregator;
26     }
27 
28     function decimals() external pure override returns (uint8) {
29         return 18;
30     }
31 
32     function description() external pure override returns (string memory) {
33         return "WBTC / ETH";
34     }
35 
36     /// @notice Get latest WBTC/BTC Chainlink feed timestamp
37     /// @return timestamp latest WBTC/BTC Chainlink feed timestamp
38     function latestTimestamp() external view override returns (uint256 timestamp) {
39         return IChainlinkAggregatorV2V3(WBTCBTCChainlinkAggregator).latestTimestamp();
40     }
41 
42     /// @notice Get WBTC/ETH price. It does not check Chainlink oracles staleness! If staleness check needed, it's recommended to use latestTimestamp() functions on both Chainlink feeds used
43     /// @return answer WBTC/ETH price or 0 if failure
44     function latestAnswer() external view override returns (int256 answer) {
45         // get the WBTC/BTC and BTC/ETH prices
46         int256 WBTCBTCPrice = IChainlinkAggregatorV2V3(WBTCBTCChainlinkAggregator).latestAnswer();
47         int256 BTCETHPrice = IChainlinkAggregatorV2V3(BTCETHChainlinkAggregator).latestAnswer();
48 
49         if (WBTCBTCPrice <= 0 || BTCETHPrice <= 0) return 0;
50 
51         // calculate WBTC/ETH price
52         return WBTCBTCPrice * BTCETHPrice / 1e8;
53     }
54 }
