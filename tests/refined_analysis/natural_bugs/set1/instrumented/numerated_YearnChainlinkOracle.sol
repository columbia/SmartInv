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
12 interface IYearnVault {
13     function pricePerShare() external view returns (uint256 price);
14 }
15 
16 contract YearnChainlinkOracle is IOracle {
17     using BoringMath for uint256; // Keep everything in uint256
18 
19     // Calculates the lastest exchange rate
20     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
21     function _get(
22         address multiply,
23         address divide,
24         uint256 decimals,
25         address yearnVault
26     ) internal view returns (uint256) {
27         uint256 price = uint256(1e36);
28         if (multiply != address(0)) {
29             price = price.mul(uint256(IAggregator(multiply).latestAnswer()));
30         } else {
31             price = price.mul(1e18);
32         }
33 
34         if (divide != address(0)) {
35             price = price / uint256(IAggregator(divide).latestAnswer());
36         }
37 
38         // @note decimals have to take into account the decimals of the vault asset
39         return price / decimals.mul(IYearnVault(yearnVault).pricePerShare());
40     }
41 
42     function getDataParameter(
43         address multiply,
44         address divide,
45         uint256 decimals,
46         address yearnVault
47     ) public pure returns (bytes memory) {
48         return abi.encode(multiply, divide, decimals, yearnVault);
49     }
50 
51     // Get the latest exchange rate
52     /// @inheritdoc IOracle
53     function get(bytes calldata data) public override returns (bool, uint256) {
54         (address multiply, address divide, uint256 decimals, address yearnVault) = abi.decode(data, (address, address, uint256, address));
55         return (true, _get(multiply, divide, decimals, yearnVault));
56     }
57 
58     // Check the last exchange rate without any state changes
59     /// @inheritdoc IOracle
60     function peek(bytes calldata data) public view override returns (bool, uint256) {
61         (address multiply, address divide, uint256 decimals, address yearnVault) = abi.decode(data, (address, address, uint256, address));
62         return (true, _get(multiply, divide, decimals, yearnVault));
63     }
64 
65     // Check the current spot exchange rate without any state changes
66     /// @inheritdoc IOracle
67     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
68         (, rate) = peek(data);
69     }
70 
71     /// @inheritdoc IOracle
72     function name(bytes calldata) public view override returns (string memory) {
73         return "Chainlink";
74     }
75 
76     /// @inheritdoc IOracle
77     function symbol(bytes calldata) public view override returns (string memory) {
78         return "LINK";
79     }
80 }
