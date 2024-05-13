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
12 contract ETHOracle is IOracle {
13     using BoringMath for uint256; // Keep everything in uint256
14 
15     IAggregator public constant aggregatorProxy = IAggregator(0x976B3D034E162d8bD72D6b9C989d545b839003b0);
16 
17     // Calculates the lastest exchange rate
18     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
19     function _get() internal view returns (uint256) {
20         return 1e26 / uint256(aggregatorProxy.latestAnswer());
21     }
22 
23     // Get the latest exchange rate
24     /// @inheritdoc IOracle
25     function get(bytes calldata) public override returns (bool, uint256) {
26         return (true, _get());
27     }
28 
29     // Check the last exchange rate without any state changes
30     /// @inheritdoc IOracle
31     function peek(bytes calldata ) public view override returns (bool, uint256) {
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
42     function name(bytes calldata) public view override returns (string memory) {
43         return "ETH Chainlink";
44     }
45 
46     /// @inheritdoc IOracle
47     function symbol(bytes calldata) public view override returns (string memory) {
48         return "ETH/USD";
49     }
50 }
