1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity =0.7.6;
3 import '@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol';
4 import "../interfaces/IOracle.sol";
5 
6 interface IAggregator {
7     function latestAnswer() external view returns (int256 answer);
8 }
9 contract AGLDUniV3ChainlinkOracle is IOracle {
10     using LowGasSafeMath for uint256; // Keep everything in uint256
11     IAggregator public constant ETH_USD = IAggregator(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
12     uint32 public constant period = 10 minutes;
13     address public constant pool = 0x5d752F322beFB038991579972e912B02F61A3DDA;
14     address public constant AGLD = 0x32353A6C91143bfd6C7d363B546e62a9A2489A20;
15     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
16     uint128 private constant BASE_AMOUNT = 1e18;
17 
18     // Calculates the lastest exchange rate
19     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
20     function _get() internal view returns (uint256) {
21 
22         int24 timeWeightedTick = OracleLibrary.consult(pool, period);
23 
24         uint256 priceETH = OracleLibrary.getQuoteAtTick(
25             timeWeightedTick,
26             BASE_AMOUNT,
27             AGLD,
28             WETH
29         );
30 
31         return 1e44 / priceETH.mul(uint256(ETH_USD.latestAnswer()));
32     }
33 
34     // Get the latest exchange rate
35     /// @inheritdoc IOracle
36     function get(bytes calldata) public view override returns (bool, uint256) {
37         return (true, _get());
38     }
39 
40     // Check the last exchange rate without any state changes
41     /// @inheritdoc IOracle
42     function peek(bytes calldata) public view override returns (bool, uint256) {
43         return (true, _get());
44     }
45 
46     // Check the current spot exchange rate without any state changes
47     /// @inheritdoc IOracle
48     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
49         (, rate) = peek(data);
50     }
51 
52     /// @inheritdoc IOracle
53     function name(bytes calldata) public pure override returns (string memory) {
54         return "Chainlink UNIV3 AGLD";
55     }
56 
57     /// @inheritdoc IOracle
58     function symbol(bytes calldata) public pure override returns (string memory) {
59         return "LINK/UNIV3 AGLD";
60     }
61 }
