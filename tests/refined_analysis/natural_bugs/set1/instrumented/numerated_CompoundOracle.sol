1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
4 import "../interfaces/IOracle.sol";
5 
6 interface IUniswapAnchoredView {
7     function price(string memory symbol) external view returns (uint256);
8 }
9 
10 contract CompoundOracle is IOracle {
11     using BoringMath for uint256;
12 
13     IUniswapAnchoredView private constant ORACLE = IUniswapAnchoredView(0x922018674c12a7F0D394ebEEf9B58F186CdE13c1);
14 
15     struct PriceInfo {
16         uint128 price;
17         uint128 blockNumber;
18     }
19 
20     mapping(string => PriceInfo) public prices;
21 
22     function _peekPrice(string memory symbol) internal view returns (uint256) {
23         if (bytes(symbol).length == 0) {
24             return 1000000;
25         } // To allow only using collateralSymbol or assetSymbol if paired against USDx
26         PriceInfo memory info = prices[symbol];
27         if (block.number > info.blockNumber + 8) {
28             return uint128(ORACLE.price(symbol)); // Prices are denominated with 6 decimals, so will fit in uint128
29         }
30         return info.price;
31     }
32 
33     function _getPrice(string memory symbol) internal returns (uint256) {
34         if (bytes(symbol).length == 0) {
35             return 1000000;
36         } // To allow only using collateralSymbol or assetSymbol if paired against USDx
37         PriceInfo memory info = prices[symbol];
38         if (block.number > info.blockNumber + 8) {
39             info.price = uint128(ORACLE.price(symbol)); // Prices are denominated with 6 decimals, so will fit in uint128
40             info.blockNumber = uint128(block.number); // Blocknumber will fit in uint128
41             prices[symbol] = info;
42         }
43         return info.price;
44     }
45 
46     function getDataParameter(
47         string memory collateralSymbol,
48         string memory assetSymbol,
49         uint256 division
50     ) public pure returns (bytes memory) {
51         return abi.encode(collateralSymbol, assetSymbol, division);
52     }
53 
54     // Get the latest exchange rate
55     /// @inheritdoc IOracle
56     function get(bytes calldata data) public override returns (bool, uint256) {
57         (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
58         return (true, uint256(1e36).mul(_getPrice(assetSymbol)) / _getPrice(collateralSymbol) / division);
59     }
60 
61     // Check the last exchange rate without any state changes
62     /// @inheritdoc IOracle
63     function peek(bytes calldata data) public view override returns (bool, uint256) {
64         (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
65         return (true, uint256(1e36).mul(_peekPrice(assetSymbol)) / _peekPrice(collateralSymbol) / division);
66     }
67 
68     // Check the current spot exchange rate without any state changes
69     /// @inheritdoc IOracle
70     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
71         (, rate) = peek(data);
72     }
73 
74     /// @inheritdoc IOracle
75     function name(bytes calldata) public view override returns (string memory) {
76         return "Compound";
77     }
78 
79     /// @inheritdoc IOracle
80     function symbol(bytes calldata) public view override returns (string memory) {
81         return "COMP";
82     }
83 }
