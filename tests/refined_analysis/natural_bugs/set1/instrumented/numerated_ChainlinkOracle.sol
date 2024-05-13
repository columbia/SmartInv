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
12 contract ChainlinkOracle is IOracle {
13     using BoringMath for uint256; // Keep everything in uint256
14 
15     // Calculates the lastest exchange rate
16     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
17     function _get(
18         address multiply,
19         address divide,
20         uint256 decimals
21     ) internal view returns (uint256) {
22         uint256 price = uint256(1e36);
23         if (multiply != address(0)) {
24             price = price.mul(uint256(IAggregator(multiply).latestAnswer()));
25         } else {
26             price = price.mul(1e18);
27         }
28 
29         if (divide != address(0)) {
30             price = price / uint256(IAggregator(divide).latestAnswer());
31         }
32 
33         return price / decimals;
34     }
35 
36     function getDataParameter(
37         address multiply,
38         address divide,
39         uint256 decimals
40     ) public pure returns (bytes memory) {
41         return abi.encode(multiply, divide, decimals);
42     }
43 
44     // Get the latest exchange rate
45     /// @inheritdoc IOracle
46     function get(bytes calldata data) public override returns (bool, uint256) {
47         (address multiply, address divide, uint256 decimals) = abi.decode(data, (address, address, uint256));
48         return (true, _get(multiply, divide, decimals));
49     }
50 
51     // Check the last exchange rate without any state changes
52     /// @inheritdoc IOracle
53     function peek(bytes calldata data) public view override returns (bool, uint256) {
54         (address multiply, address divide, uint256 decimals) = abi.decode(data, (address, address, uint256));
55         return (true, _get(multiply, divide, decimals));
56     }
57 
58     // Check the current spot exchange rate without any state changes
59     /// @inheritdoc IOracle
60     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
61         (, rate) = peek(data);
62     }
63 
64     /// @inheritdoc IOracle
65     function name(bytes calldata) public view override returns (string memory) {
66         return "Chainlink";
67     }
68 
69     /// @inheritdoc IOracle
70     function symbol(bytes calldata) public view override returns (string memory) {
71         return "LINK";
72     }
73 }
