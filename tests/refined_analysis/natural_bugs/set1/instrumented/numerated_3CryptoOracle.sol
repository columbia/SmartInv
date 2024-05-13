1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 import "../interfaces/IOracle.sol";
4 
5 // Chainlink Aggregator
6 
7 
8 interface ILPOracle {
9     function lp_price() external view returns (uint256 price);
10 }
11 
12 contract ThreeCryptoOracle is IOracle {
13     ILPOracle constant public LP_ORACLE = ILPOracle(0xE8b2989276E2Ca8FDEA2268E3551b2b4B2418950);
14 
15     // Calculates the lastest exchange rate
16     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
17     function _get() internal view returns (uint256) {
18         return 1e36 / LP_ORACLE.lp_price();
19     }
20 
21     // Get the latest exchange rate
22     /// @inheritdoc IOracle
23     function get(bytes calldata) public view override returns (bool, uint256) {
24         return (true, _get());
25     }
26 
27     // Check the last exchange rate without any state changes
28     /// @inheritdoc IOracle
29     function peek(bytes calldata) public view override returns (bool, uint256) {
30         return (true, _get());
31     }
32 
33     // Check the current spot exchange rate without any state changes
34     /// @inheritdoc IOracle
35     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
36         (, rate) = peek(data);
37     }
38 
39     /// @inheritdoc IOracle
40     function name(bytes calldata) public pure override returns (string memory) {
41         return "3Crv";
42     }
43 
44     /// @inheritdoc IOracle
45     function symbol(bytes calldata) public pure override returns (string memory) {
46         return "3crv";
47     }
48 }