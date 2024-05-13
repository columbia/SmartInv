1 // SPDX-License-Identifier: MIT
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
12 contract ALCXOracle is IOracle {
13     using BoringMath for uint256; // Keep everything in uint256
14 
15     IAggregator public constant alcxOracle = IAggregator(0x194a9AaF2e0b67c35915cD01101585A33Fe25CAa);
16     IAggregator public constant ethUSDOracle = IAggregator(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
17 
18     // Calculates the lastest exchange rate
19     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
20     function _get() internal view returns (uint256) {
21         return 1e44 / uint256(alcxOracle.latestAnswer()).mul(uint256(ethUSDOracle.latestAnswer()));
22     }
23 
24     // Get the latest exchange rate
25     /// @inheritdoc IOracle
26     function get(bytes calldata) public override returns (bool, uint256) {
27         return (true, _get());
28     }
29 
30     // Check the last exchange rate without any state changes
31     /// @inheritdoc IOracle
32     function peek(bytes calldata ) public view override returns (bool, uint256) {
33         return (true, _get());
34     }
35 
36     // Check the current spot exchange rate without any state changes
37     /// @inheritdoc IOracle
38     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
39         (, rate) = peek(data);
40     }
41 
42     /// @inheritdoc IOracle
43     function name(bytes calldata) public view override returns (string memory) {
44         return "ALCX Chainlink";
45     }
46 
47     /// @inheritdoc IOracle
48     function symbol(bytes calldata) public view override returns (string memory) {
49         return "LINK/ALCX";
50     }
51 }
