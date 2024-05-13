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
21 contract XJoeOracleV2 is IOracle {
22     using FixedPoint for *;
23     using BoringMath for uint256;
24     uint256 public constant PERIOD = 10 minutes;
25     IAggregator public constant AVAX_USD = IAggregator(0x0A77230d17318075983913bC2145DB16C7366156);
26     IUniswapV2Pair public constant JOE_AVAX = IUniswapV2Pair(0x454E67025631C065d3cFAD6d71E6892f74487a15);
27     IERC20 public constant JOE = IERC20(0x6e84a6216eA6dACC71eE8E6b0a5B7322EEbC0fDd);
28     IERC20 public constant XJOE = IERC20(0x57319d41F71E81F3c65F2a47CA4e001EbAFd4F33);
29 
30     struct PairInfo {
31         uint256 priceCumulativeLast;
32         uint32 blockTimestampLast;
33         uint144 priceAverage;
34     }
35 
36     PairInfo public pairInfo;
37     function _get(uint32 blockTimestamp) public view returns (uint256) {
38         uint256 priceCumulative = JOE_AVAX.price0CumulativeLast();
39 
40         // if time has elapsed since the last update on the pair, mock the accumulated price values
41         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(JOE_AVAX).getReserves();
42         priceCumulative += uint256(FixedPoint.fraction(reserve1, reserve0)._x) * (blockTimestamp - blockTimestampLast); // overflows ok
43 
44         // overflow is desired, casting never truncates
45         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
46         return priceCumulative;
47     }
48 
49     function toXJOE(uint256 amount) internal view returns (uint256) {
50         return amount.mul(JOE.balanceOf(address(XJOE))) / XJOE.totalSupply();
51     }
52 
53     // Get the latest exchange rate, if no valid (recent) rate is available, return false
54     /// @inheritdoc IOracle
55     function get(bytes calldata) external override returns (bool, uint256) {
56         uint32 blockTimestamp = uint32(block.timestamp);
57         if (pairInfo.blockTimestampLast == 0) {
58             pairInfo.blockTimestampLast = blockTimestamp;
59             pairInfo.priceCumulativeLast = _get(blockTimestamp);
60             return (false, 0);
61         }
62         uint32 timeElapsed = blockTimestamp - pairInfo.blockTimestampLast; // overflow is desired
63               console.log(timeElapsed);
64         if (timeElapsed < PERIOD) {
65             return (true, pairInfo.priceAverage);
66         }
67 
68         uint256 priceCumulative = _get(blockTimestamp);
69         pairInfo.priceAverage = uint144(1e44 / toXJOE(uint256(FixedPoint
70             .uq112x112(uint224((priceCumulative - pairInfo.priceCumulativeLast) / timeElapsed))
71             .mul(1e18)
72             .decode144())).mul(uint256(AVAX_USD.latestAnswer())));
73         pairInfo.blockTimestampLast = blockTimestamp;
74         pairInfo.priceCumulativeLast = priceCumulative;
75 
76         return (true, pairInfo.priceAverage);
77     }
78 
79     // Check the last exchange rate without any state changes
80     /// @inheritdoc IOracle
81     function peek(bytes calldata) public view override returns (bool, uint256) {
82         uint32 blockTimestamp = uint32(block.timestamp);
83         if (pairInfo.blockTimestampLast == 0) {
84             return (false, 0);
85         }
86         uint32 timeElapsed = blockTimestamp - pairInfo.blockTimestampLast; // overflow is desired
87         if (timeElapsed < PERIOD) {
88             return (true, pairInfo.priceAverage);
89         }
90 
91         uint256 priceCumulative = _get(blockTimestamp);
92         uint144 priceAverage = uint144(1e44 / toXJOE(uint256(FixedPoint
93             .uq112x112(uint224((priceCumulative - pairInfo.priceCumulativeLast) / timeElapsed))
94             .mul(1e18)
95             .decode144())).mul(uint256(AVAX_USD.latestAnswer())));
96 
97         return (true, priceAverage);
98     }
99 
100     // Check the current spot exchange rate without any state changes
101     /// @inheritdoc IOracle
102     function peekSpot(bytes calldata) external view override returns (uint256 rate) {
103         (uint256 reserve0, uint256 reserve1, ) = JOE_AVAX.getReserves();
104         rate = 1e44 / toXJOE(reserve1.mul(1e18) / reserve0).mul(uint256(AVAX_USD.latestAnswer()));
105     }
106 
107     /// @inheritdoc IOracle
108     function name(bytes calldata) public view override returns (string memory) {
109         return "xJOE TWAP";
110     }
111 
112     /// @inheritdoc IOracle
113     function symbol(bytes calldata) public view override returns (string memory) {
114         return "xJOE";
115     }
116 }
