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
11 interface IYearnVault {
12     function pricePerShare() external view returns (uint256 price);
13 }
14 
15 interface ICurvePool {
16     function get_virtual_price() external view returns (uint256 price);
17 }
18 
19 contract YVIronBankOracle is IOracle {
20     ICurvePool constant public IronBank = ICurvePool(0x2dded6Da1BF5DBdF597C45fcFaa3194e53EcfeAF);
21     IYearnVault constant public YVIB = IYearnVault(0x27b7b1ad7288079A66d12350c828D3C00A6F07d7);
22     IAggregator constant public DAI = IAggregator(0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9);
23     IAggregator constant public USDC = IAggregator(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6);
24     IAggregator constant public USDT = IAggregator(0x3E7d1eAB13ad0104d2750B8863b489D65364e32D);
25 
26     /**
27      * @dev Returns the smallest of two numbers.
28      */
29     // FROM: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/6d97f0919547df11be9443b54af2d90631eaa733/contracts/utils/math/Math.sol
30     function min(uint256 a, uint256 b) internal pure returns (uint256) {
31         return a < b ? a : b;
32     }
33 
34     // Calculates the lastest exchange rate
35     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
36     function _get() internal view returns (uint256) {
37 
38         // As the price should never be negative, the unchecked conversion is acceptable
39         uint256 minStable = min(uint256(DAI.latestAnswer()), min(uint256(USDC.latestAnswer()), uint256(USDT.latestAnswer())));
40 
41         uint256 yVCurvePrice = IronBank.get_virtual_price() * minStable * YVIB.pricePerShare();
42 
43         return 1e62 / yVCurvePrice;
44     }
45 
46     // Get the latest exchange rate
47     /// @inheritdoc IOracle
48     function get(bytes calldata) public view override returns (bool, uint256) {
49         return (true, _get());
50     }
51 
52     // Check the last exchange rate without any state changes
53     /// @inheritdoc IOracle
54     function peek(bytes calldata) public view override returns (bool, uint256) {
55         return (true, _get());
56     }
57 
58     // Check the current spot exchange rate without any state changes
59     /// @inheritdoc IOracle
60     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
61         (, rate) = peek(data);
62     }
63 
64     /// @inheritdoc IOracle
65     function name(bytes calldata) public pure override returns (string memory) {
66         return "Yearn Chainlink Curve IronBank";
67     }
68 
69     /// @inheritdoc IOracle
70     function symbol(bytes calldata) public pure override returns (string memory) {
71         return "LINK/yvIB";
72     }
73 }
