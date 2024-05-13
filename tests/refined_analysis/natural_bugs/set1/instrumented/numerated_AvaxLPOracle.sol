1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 import "../interfaces/IOracle.sol";
4 
5 // Chainlink Aggregator
6 
7 interface IAggregator {
8     function latestAnswer() external view returns (int256 answer);
9 }
10 
11 contract AvaxLPOracle is IOracle {
12     IAggregator public constant AVAX = IAggregator(0x0A77230d17318075983913bC2145DB16C7366156);
13 
14     /// @dev should be using an implementation of LPChainlinkOracle
15     IAggregator public immutable lpOracle;
16     string private desc;
17 
18     constructor(
19         IAggregator _lpOracle,
20         string memory _desc
21     ) {
22         lpOracle = _lpOracle;
23         desc = _desc;
24     }
25     
26     /// @notice Returns 1 USD price in LP denominated in USD
27     /// @dev lpOracle.latestAnswer() returns the price of 1 LP in AVAX multipled by Avax Price.
28     /// It's then inverted so it gives how many LP can 1 USD buy.
29     function _get() internal view returns (uint256) {
30         uint256 lpPrice = uint256(lpOracle.latestAnswer()) * uint256(AVAX.latestAnswer());
31 
32         return 1e44 / lpPrice;
33     }
34 
35     // Get the latest exchange rate
36     /// @inheritdoc IOracle
37     function get(bytes calldata) public view override returns (bool, uint256) {
38         return (true, _get());
39     }
40 
41     // Check the last exchange rate without any state changes
42     /// @inheritdoc IOracle
43     function peek(bytes calldata) public view override returns (bool, uint256) {
44         return (true, _get());
45     }
46 
47     // Check the current spot exchange rate without any state changes
48     /// @inheritdoc IOracle
49     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
50         (, rate) = peek(data);
51     }
52 
53     /// @inheritdoc IOracle
54     function name(bytes calldata) public view override returns (string memory) {
55         return desc;
56     }
57 
58     /// @inheritdoc IOracle
59     function symbol(bytes calldata) public view override returns (string memory) {
60         return desc;
61     }
62 }
