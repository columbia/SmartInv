1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 import "../interfaces/IOracle.sol";
4 
5 // Chainlink Aggregator
6 
7 interface IAggregator {
8     function latestAnswer() external view returns (int256 answer);
9 }
10 
11 contract USTOracle is IOracle {
12     IAggregator constant public UST = IAggregator(0x8b6d9085f310396C6E4f0012783E9f850eaa8a82);
13 
14     // Calculates the lastest exchange rate
15     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
16     function _get() internal view returns (uint256) {
17 
18         uint256 ustPrice = uint256(UST.latestAnswer());
19 
20         return 1e26 / ustPrice;
21     }
22 
23     // Get the latest exchange rate
24     /// @inheritdoc IOracle
25     function get(bytes calldata) public view override returns (bool, uint256) {
26         return (true, _get());
27     }
28 
29     // Check the last exchange rate without any state changes
30     /// @inheritdoc IOracle
31     function peek(bytes calldata) public view override returns (bool, uint256) {
32         return (true, _get());
33     }
34 
35     // Check the current spot exchange rate without any state changes
36     /// @inheritdoc IOracle
37     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
38         (, rate) = peek(data);
39     }
40 
41     /// @inheritdoc IOracle
42     function name(bytes calldata) public pure override returns (string memory) {
43         return "Chainlink UST";
44     }
45 
46     /// @inheritdoc IOracle
47     function symbol(bytes calldata) public pure override returns (string memory) {
48         return "LINK/UST";
49     }
50 }
