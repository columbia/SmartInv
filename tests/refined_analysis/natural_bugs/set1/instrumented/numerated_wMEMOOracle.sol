1 // SPDX-License-Identifier: AGPL-3.0-only
2 // Using the same Copyleft License as in the original Repository
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 import "../interfaces/IOracle.sol";
6 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
7 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol";
8 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
9 import "../libraries/FixedPoint.sol";
10 
11 // solhint-disable not-rely-on-time
12 
13 // adapted from https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleSlidingWindowOracle.sol
14 interface IAggregator {
15     function latestAnswer() external view returns (int256 answer);
16 }
17 
18 interface IWMEMO {
19     function MEMOTowMEMO( uint256 _amount ) external view returns ( uint256 );
20 }
21 
22 contract wMemoOracle is IOracle {
23     using FixedPoint for *;
24     using BoringMath for uint256;
25     uint256 public constant PERIOD = 10 minutes;
26     IAggregator public constant MIM_USD = IAggregator(0x54EdAB30a7134A16a54218AE64C73e1DAf48a8Fb);
27     IUniswapV2Pair public constant WMEMO_MIM = IUniswapV2Pair(0x4d308C46EA9f234ea515cC51F16fba776451cac8);
28 
29     IWMEMO public constant WMEMO = IWMEMO(0x0da67235dD5787D67955420C84ca1cEcd4E5Bb3b);
30 
31     struct PairInfo {
32         uint256 priceCumulativeLast;
33         uint32 blockTimestampLast;
34         uint144 priceAverage;
35     }
36 
37     PairInfo public pairInfo;
38     function _get(uint32 blockTimestamp) public view returns (uint256) {
39         uint256 priceCumulative = WMEMO_MIM.price0CumulativeLast();
40 
41         // if time has elapsed since the last update on the pair, mock the accumulated price values
42         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(WMEMO_MIM).getReserves();
43         priceCumulative += uint256(FixedPoint.fraction(reserve1, reserve0)._x) * (blockTimestamp - blockTimestampLast); // overflows ok
44 
45         // overflow is desired, casting never truncates
46         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
47         return priceCumulative;
48     }
49 
50     // Get the latest exchange rate, if no valid (recent) rate is available, return false
51     /// @inheritdoc IOracle
52     function get(bytes calldata data) external override returns (bool, uint256) {
53         uint32 blockTimestamp = uint32(block.timestamp);
54         if (pairInfo.blockTimestampLast == 0) {
55             pairInfo.blockTimestampLast = blockTimestamp;
56             pairInfo.priceCumulativeLast = _get(blockTimestamp);
57             return (false, 0);
58         }
59         uint32 timeElapsed = blockTimestamp - pairInfo.blockTimestampLast; // overflow is desired
60         if (timeElapsed < PERIOD) {
61             return (true, pairInfo.priceAverage);
62         }
63 
64         uint256 priceCumulative = _get(blockTimestamp);
65         pairInfo.priceAverage = uint144(1e44 / uint256(FixedPoint
66             .uq112x112(uint224((priceCumulative - pairInfo.priceCumulativeLast) / timeElapsed))
67             .mul(1e18)
68             .decode144()).mul(uint256(MIM_USD.latestAnswer())));
69         pairInfo.blockTimestampLast = blockTimestamp;
70         pairInfo.priceCumulativeLast = priceCumulative;
71 
72         return (true, pairInfo.priceAverage);
73     }
74 
75     // Check the last exchange rate without any state changes
76     /// @inheritdoc IOracle
77     function peek(bytes calldata data) public view override returns (bool, uint256) {
78         uint32 blockTimestamp = uint32(block.timestamp);
79         if (pairInfo.blockTimestampLast == 0) {
80             return (false, 0);
81         }
82         uint32 timeElapsed = blockTimestamp - pairInfo.blockTimestampLast; // overflow is desired
83         if (timeElapsed < PERIOD) {
84             return (true, pairInfo.priceAverage);
85         }
86 
87         uint256 priceCumulative = _get(blockTimestamp);
88         uint144 priceAverage = uint144(1e44 / uint256(FixedPoint
89             .uq112x112(uint224((priceCumulative - pairInfo.priceCumulativeLast) / timeElapsed))
90             .mul(1e18)
91             .decode144()).mul(uint256(MIM_USD.latestAnswer())));
92 
93         return (true, priceAverage);
94     }
95 
96     // Check the current spot exchange rate without any state changes
97     /// @inheritdoc IOracle
98     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
99         (uint256 reserve0, uint256 reserve1, ) = WMEMO_MIM.getReserves();
100         rate = 1e44 / (reserve1.mul(1e18) / reserve0).mul(uint256(MIM_USD.latestAnswer()));
101     }
102 
103     /// @inheritdoc IOracle
104     function name(bytes calldata) public view override returns (string memory) {
105         return "wMEMO TWAP";
106     }
107 
108     /// @inheritdoc IOracle
109     function symbol(bytes calldata) public view override returns (string memory) {
110         return "wMEMO";
111     }
112 }
