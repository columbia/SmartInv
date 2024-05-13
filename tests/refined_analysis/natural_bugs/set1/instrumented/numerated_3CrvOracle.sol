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
19 contract ThreeCrvOracle is IOracle {
20     ICurvePool constant public threecrv = ICurvePool(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7);
21     IAggregator constant public DAI = IAggregator(0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9);
22     IAggregator constant public USDC = IAggregator(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6);
23     IAggregator constant public USDT = IAggregator(0x3E7d1eAB13ad0104d2750B8863b489D65364e32D);
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     // FROM: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/6d97f0919547df11be9443b54af2d90631eaa733/contracts/utils/math/Math.sol
29     function min(uint256 a, uint256 b) internal pure returns (uint256) {
30         return a < b ? a : b;
31     }
32 
33     // Calculates the lastest exchange rate
34     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
35     function _get() internal view returns (uint256) {
36 
37         // As the price should never be negative, the unchecked conversion is acceptable
38         uint256 minStable = min(uint256(DAI.latestAnswer()), min(uint256(USDC.latestAnswer()), uint256(USDT.latestAnswer())));
39 
40         uint256 yVCurvePrice = threecrv.get_virtual_price() * minStable;
41 
42         return 1e44 / yVCurvePrice;
43     }
44 
45     // Get the latest exchange rate
46     /// @inheritdoc IOracle
47     function get(bytes calldata) public view override returns (bool, uint256) {
48         return (true, _get());
49     }
50 
51     // Check the last exchange rate without any state changes
52     /// @inheritdoc IOracle
53     function peek(bytes calldata) public view override returns (bool, uint256) {
54         return (true, _get());
55     }
56 
57     // Check the current spot exchange rate without any state changes
58     /// @inheritdoc IOracle
59     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
60         (, rate) = peek(data);
61     }
62 
63     /// @inheritdoc IOracle
64     function name(bytes calldata) public pure override returns (string memory) {
65         return "Chainlink 3Crv";
66     }
67 
68     /// @inheritdoc IOracle
69     function symbol(bytes calldata) public pure override returns (string memory) {
70         return "LINK/3crv";
71     }
72 }
