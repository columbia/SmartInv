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
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14 }
15 
16 contract sSpellOracle is IOracle {
17     IAggregator constant public SPELLUSD = IAggregator(0x8c110B94C5f1d347fAcF5E1E938AB2db60E3c9a8);
18 
19     IERC20 public constant SSPELL = IERC20(0x26FA3fFFB6EfE8c1E69103aCb4044C26B9A106a9);
20     IERC20 public constant SPELL = IERC20(0x090185f2135308BaD17527004364eBcC2D37e5F6);
21 
22     function toSSpell(uint256 amount) internal view returns (uint256) {
23         return amount * SPELL.balanceOf(address(SSPELL)) / SSPELL.totalSupply();
24     }
25 
26     // Calculates the lastest exchange rate
27     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
28     function _get() internal view returns (uint256) {
29 
30         return 1e26 / toSSpell(uint256(SPELLUSD.latestAnswer()));
31     }
32 
33     // Get the latest exchange rate
34     /// @inheritdoc IOracle
35     function get(bytes calldata) public view override returns (bool, uint256) {
36         return (true, _get());
37     }
38 
39     // Check the last exchange rate without any state changes
40     /// @inheritdoc IOracle
41     function peek(bytes calldata) public view override returns (bool, uint256) {
42         return (true, _get());
43     }
44 
45     // Check the current spot exchange rate without any state changes
46     /// @inheritdoc IOracle
47     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
48         (, rate) = peek(data);
49     }
50 
51     /// @inheritdoc IOracle
52     function name(bytes calldata) public pure override returns (string memory) {
53         return "Chainlink sSpell";
54     }
55 
56     /// @inheritdoc IOracle
57     function symbol(bytes calldata) public pure override returns (string memory) {
58         return "LINK/sSpell";
59     }
60 }
