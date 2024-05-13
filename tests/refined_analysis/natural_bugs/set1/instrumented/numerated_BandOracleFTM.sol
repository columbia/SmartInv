1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity 0.6.12;
4 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
5 import "../interfaces/IOracle.sol";
6 
7 // Band
8 
9 interface IStdReference {
10     /// A structure returned whenever someone requests for standard reference data.
11     struct ReferenceData {
12         uint256 rate; // base/quote exchange rate, multiplied by 1e18.
13         uint256 lastUpdatedBase; // UNIX epoch of the last time when base price gets updated.
14         uint256 lastUpdatedQuote; // UNIX epoch of the last time when quote price gets updated.
15     }
16 
17     /// Returns the price data for the given base/quote pair. Revert if not available.
18     function getReferenceData(string memory _base, string memory _quote)
19         external
20         view
21         returns (ReferenceData memory);
22 
23     /// Similar to getReferenceData, but with multiple base/quote pairs at once.
24     function getReferenceDataBulk(string[] memory _bases, string[] memory _quotes)
25         external
26         view
27         returns (ReferenceData[] memory);
28 }
29 
30 contract BandOracleFTMV1 is IOracle {
31     using BoringMath for uint256; // Keep everything in uint256
32 
33     IStdReference constant ftmOracle = IStdReference(0x56E2898E0ceFF0D1222827759B56B28Ad812f92F);
34 
35     // Calculates the lastest exchange rate
36     function _get() internal view returns (uint256 rate) {
37         IStdReference.ReferenceData memory referenceData = ftmOracle.getReferenceData("USD", "FTM");
38         return referenceData.rate;
39     }
40 
41     // Get the latest exchange rate
42     /// @inheritdoc IOracle
43     function get(bytes calldata) public override returns (bool, uint256) {
44         return (true, _get());
45     }
46 
47     // Check the last exchange rate without any state changes
48     /// @inheritdoc IOracle
49     function peek(bytes calldata) public view override returns (bool, uint256) {
50         return (true, _get());
51     }
52 
53     // Check the current spot exchange rate without any state changes
54     /// @inheritdoc IOracle
55     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
56         (, rate) = peek(data);
57     }
58 
59     /// @inheritdoc IOracle
60     function name(bytes calldata) public view override returns (string memory) {
61         return "BAND FTM/USD";
62     }
63 
64     /// @inheritdoc IOracle
65     function symbol(bytes calldata) public view override returns (string memory) {
66         return "BAND";
67     }
68 }