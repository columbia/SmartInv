1 // SPDX-License-Identifier: None
2 pragma solidity 0.6.12;
3 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
4 import "../interfaces/IOracle.sol";
5 
6 // Chainlink Aggregator
7 
8 interface IAggregator {
9     function latestAnswer() external view returns (int256 answer);
10 }
11 
12 contract WXTOracle is IOracle {
13     using BoringMath for uint256; // Keep everything in uint256
14 
15 
16 
17     IAggregator public constant aggregatorProxy = IAggregator(0x17F7589C98e6e58FdA9B1ceaa2021DB3779549fA);
18 
19     // Calculates the lastest exchange rate
20     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
21     function _get() internal view returns (uint256) {
22         return 1e24 / uint256(aggregatorProxy.latestAnswer());
23     }
24 
25     // Get the latest exchange rate
26     /// @inheritdoc IOracle
27     function get(bytes calldata) public override returns (bool, uint256) {
28         return (true, _get());
29     }
30 
31     // Check the last exchange rate without any state changes
32     /// @inheritdoc IOracle
33     function peek(bytes calldata ) public view override returns (bool, uint256) {
34         return (true, _get());
35     }
36 
37     // Check the current spot exchange rate without any state changes
38     /// @inheritdoc IOracle
39     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
40         (, rate) = peek(data);
41     }
42 
43     /// @inheritdoc IOracle
44     function name(bytes calldata) public view override returns (string memory) {
45         return "WXT";
46     }
47 
48     /// @inheritdoc IOracle
49     function symbol(bytes calldata) public view override returns (string memory) {
50         return "WXT/USDT";
51     }
52 }
