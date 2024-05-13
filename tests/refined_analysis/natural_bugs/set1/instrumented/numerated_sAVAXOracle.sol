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
12 interface IStakedAvax {
13     // The total amount of AVAX controlled by the contract
14     function totalPooledAvax() external view returns (uint256 total);
15     // The total number of sAVAX shares
16     function totalShares() external view returns (uint256 total);
17 }
18 
19 contract sAVAXOracle is IOracle {
20     using BoringMath for uint256; // Keep everything in uint256
21 
22     IAggregator public constant aggregatorProxy = IAggregator(0x0A77230d17318075983913bC2145DB16C7366156);
23     IStakedAvax public constant stakedAvax = IStakedAvax(0x2b2C81e08f1Af8835a78Bb2A90AE924ACE0eA4bE);
24 
25     // Calculates the latest exchange rate
26     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
27     function _get() internal view returns (uint256) {
28         uint256 sAvaxPrice =  uint256(stakedAvax.totalPooledAvax()) * uint256(aggregatorProxy.latestAnswer()) / uint256(stakedAvax.totalShares()) ;
29 
30         return 1e26 / sAvaxPrice;
31     }
32 
33     // Get the latest exchange rate
34     /// @inheritdoc IOracle
35     function get(bytes calldata) public override returns (bool, uint256) {
36         return (true, _get());
37     }
38 
39     // Check the last exchange rate without any state changes
40     /// @inheritdoc IOracle
41     function peek(bytes calldata ) public view override returns (bool, uint256) {
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
52     function name(bytes calldata) public view override returns (string memory) {
53         return "sAVAX Chainlink";
54     }
55 
56     /// @inheritdoc IOracle
57     function symbol(bytes calldata) public view override returns (string memory) {
58         return "sAVAX/USD";
59     }
60 }
