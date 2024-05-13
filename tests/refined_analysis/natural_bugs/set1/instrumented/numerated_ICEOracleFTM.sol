1 // SPDX-License-Identifier: AGPL-3.0-only
2 // Using the same Copyleft License as in the original Repository
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 import "../interfaces/IOracle.sol";
6 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
7 import "@boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol";
8 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol";
9 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
10 import "../libraries/FixedPoint.sol";
11 
12 import "hardhat/console.sol";
13 
14 // solhint-disable not-rely-on-time
15 
16 // adapted from https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleSlidingWindowOracle.sol
17 interface IAggregator {
18     function latestAnswer() external view returns (int256 answer);
19 }
20 
21 contract ICEOracleFTM is IOracle {
22     using FixedPoint for *;
23     using BoringMath for uint256;
24     uint256 public constant PERIOD = 10 minutes;
25     IAggregator public constant FTM_USD = IAggregator(0xf4766552D15AE4d256Ad41B6cf2933482B0680dc);
26     IUniswapV2Pair public constant ICE_FTM = IUniswapV2Pair(0x84311ECC54D7553378c067282940b0fdfb913675);
27     IERC20 public constant ICE = IERC20(0xf16e81dce15B08F326220742020379B855B87DF9);
28 
29     struct PairInfo {
30         uint256 priceCumulativeLast;
31         uint32 blockTimestampLast;
32         uint144 priceAverage;
33     }
34 
35     PairInfo public pairInfo;
36     function _get(uint32 blockTimestamp) public view returns (uint256) {
37         uint256 priceCumulative = ICE_FTM.price1CumulativeLast();
38 
39         // if time has elapsed since the last update on the pair, mock the accumulated price values
40         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(ICE_FTM).getReserves();
41         priceCumulative += uint256(FixedPoint.fraction(reserve0, reserve1)._x) * (blockTimestamp - blockTimestampLast); // overflows ok
42 
43         // overflow is desired, casting never truncates
44         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
45         return priceCumulative;
46     }
47 
48     // Get the latest exchange rate, if no valid (recent) rate is available, return false
49     /// @inheritdoc IOracle
50     function get(bytes calldata) external override returns (bool, uint256) {
51         uint32 blockTimestamp = uint32(block.timestamp);
52         if (pairInfo.blockTimestampLast == 0) {
53             pairInfo.blockTimestampLast = blockTimestamp;
54             pairInfo.priceCumulativeLast = _get(blockTimestamp);
55             return (false, 0);
56         }
57         uint32 timeElapsed = blockTimestamp - pairInfo.blockTimestampLast; // overflow is desired
58               console.log(timeElapsed);
59         if (timeElapsed < PERIOD) {
60             return (true, pairInfo.priceAverage);
61         }
62 
63         uint256 priceCumulative = _get(blockTimestamp);
64         pairInfo.priceAverage = uint144(1e44 / uint256(FixedPoint
65             .uq112x112(uint224((priceCumulative - pairInfo.priceCumulativeLast) / timeElapsed))
66             .mul(1e18)
67             .decode144()).mul(uint256(FTM_USD.latestAnswer())));
68         pairInfo.blockTimestampLast = blockTimestamp;
69         pairInfo.priceCumulativeLast = priceCumulative;
70 
71         return (true, pairInfo.priceAverage);
72     }
73 
74     // Check the last exchange rate without any state changes
75     /// @inheritdoc IOracle
76     function peek(bytes calldata) public view override returns (bool, uint256) {
77         uint32 blockTimestamp = uint32(block.timestamp);
78         if (pairInfo.blockTimestampLast == 0) {
79             return (false, 0);
80         }
81         uint32 timeElapsed = blockTimestamp - pairInfo.blockTimestampLast; // overflow is desired
82         if (timeElapsed < PERIOD) {
83             return (true, pairInfo.priceAverage);
84         }
85 
86         uint256 priceCumulative = _get(blockTimestamp);
87         uint144 priceAverage = uint144(1e44 / uint256(FixedPoint
88             .uq112x112(uint224((priceCumulative - pairInfo.priceCumulativeLast) / timeElapsed))
89             .mul(1e18)
90             .decode144()).mul(uint256(FTM_USD.latestAnswer())));
91 
92         return (true, priceAverage);
93     }
94 
95     // Check the current spot exchange rate without any state changes
96     /// @inheritdoc IOracle
97     function peekSpot(bytes calldata) external view override returns (uint256 rate) {
98         (uint256 reserve0, uint256 reserve1, ) = ICE_FTM.getReserves();
99         rate = 1e44 / (reserve0.mul(1e18) / reserve1).mul(uint256(FTM_USD.latestAnswer()));
100     }
101 
102     /// @inheritdoc IOracle
103     function name(bytes calldata) public view override returns (string memory) {
104         return "ICE TWAP";
105     }
106 
107     /// @inheritdoc IOracle
108     function symbol(bytes calldata) public view override returns (string memory) {
109         return "ICE";
110     }
111 }
