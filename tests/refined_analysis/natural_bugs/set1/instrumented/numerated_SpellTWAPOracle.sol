1 // SPDX-License-Identifier: AGPL-3.0-only
2 // Using the same Copyleft License as in the original Repository
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 import "../interfaces/IOracle.sol";
6 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
7 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol";
8 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
9 import "@boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol";
10 import "../libraries/FixedPoint.sol";
11 
12 // solhint-disable not-rely-on-time
13 
14 // adapted from https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleSlidingWindowOracle.sol
15 
16 interface IAggregator {
17     function latestAnswer() external view returns (int256 answer);
18 }
19 
20 contract SpellTWAPOracle is IOracle {
21     using FixedPoint for *;
22     using BoringMath for uint256;
23     uint256 public constant PERIOD = 10 minutes;
24     IAggregator public constant ETH_USD = IAggregator(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
25     IUniswapV2Pair public constant pair = IUniswapV2Pair(0xb5De0C3753b6E1B4dBA616Db82767F17513E6d4E);
26 
27     IERC20 public constant SSPELL = IERC20(0x26FA3fFFB6EfE8c1E69103aCb4044C26B9A106a9);
28     IERC20 public constant SPELL = IERC20(0x090185f2135308BaD17527004364eBcC2D37e5F6);
29 
30     struct PairInfo {
31         uint256 priceCumulativeLast;
32         uint32 blockTimestampLast;
33         uint144 priceAverage;
34     }
35 
36     PairInfo public pairInfo;
37     function _get(uint32 blockTimestamp) public view returns (uint256) {
38         uint256 priceCumulative = pair.price0CumulativeLast();
39 
40         // if time has elapsed since the last update on the pair, mock the accumulated price values
41         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
42         priceCumulative += uint256(FixedPoint.fraction(reserve1, reserve0)._x) * (blockTimestamp - blockTimestampLast); // overflows ok
43 
44         // overflow is desired, casting never truncates
45         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
46         return priceCumulative;
47     }
48 
49     function toSSpell(uint256 amount) internal view returns (uint256) {
50         return amount.mul(SPELL.balanceOf(address(SSPELL))) / SSPELL.totalSupply();
51     }
52 
53     // Get the latest exchange rate, if no valid (recent) rate is available, return false
54     /// @inheritdoc IOracle
55     function get(bytes calldata data) external override returns (bool, uint256) {
56         uint32 blockTimestamp = uint32(block.timestamp);
57         if (pairInfo.blockTimestampLast == 0) {
58             pairInfo.blockTimestampLast = blockTimestamp;
59             pairInfo.priceCumulativeLast = _get(blockTimestamp);
60             return (false, 0);
61         }
62         uint32 timeElapsed = blockTimestamp - pairInfo.blockTimestampLast; // overflow is desired
63         if (timeElapsed < PERIOD) {
64             return (true, pairInfo.priceAverage);
65         }
66 
67         uint256 priceCumulative = _get(blockTimestamp);
68         pairInfo.priceAverage = uint144(1e44 / toSSpell(uint256(FixedPoint
69             .uq112x112(uint224((priceCumulative - pairInfo.priceCumulativeLast) / timeElapsed))
70             .mul(1e18)
71             .decode144())).mul(uint256(ETH_USD.latestAnswer())));
72         pairInfo.blockTimestampLast = blockTimestamp;
73         pairInfo.priceCumulativeLast = priceCumulative;
74 
75         return (true, pairInfo.priceAverage);
76     }
77 
78     // Check the last exchange rate without any state changes
79     /// @inheritdoc IOracle
80     function peek(bytes calldata data) public view override returns (bool, uint256) {
81         uint32 blockTimestamp = uint32(block.timestamp);
82         if (pairInfo.blockTimestampLast == 0) {
83             return (false, 0);
84         }
85         uint32 timeElapsed = blockTimestamp - pairInfo.blockTimestampLast; // overflow is desired
86         if (timeElapsed < PERIOD) {
87             return (true, pairInfo.priceAverage);
88         }
89 
90         uint256 priceCumulative = _get(blockTimestamp);
91         uint144 priceAverage = uint144(1e44 / toSSpell(uint256(FixedPoint
92             .uq112x112(uint224((priceCumulative - pairInfo.priceCumulativeLast) / timeElapsed))
93             .mul(1e18)
94             .decode144())).mul(uint256(ETH_USD.latestAnswer())));
95 
96         return (true, priceAverage);
97     }
98 
99     // Check the current spot exchange rate without any state changes
100     /// @inheritdoc IOracle
101     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
102         (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
103         rate = 1e44 / toSSpell(reserve1.mul(1e18) / reserve0).mul(uint256(ETH_USD.latestAnswer()));
104     }
105 
106     /// @inheritdoc IOracle
107     function name(bytes calldata) public view override returns (string memory) {
108         return "SSpell TWAP CHAINLINK";
109     }
110 
111     /// @inheritdoc IOracle
112     function symbol(bytes calldata) public view override returns (string memory) {
113         return "SSpell";
114     }
115 }
