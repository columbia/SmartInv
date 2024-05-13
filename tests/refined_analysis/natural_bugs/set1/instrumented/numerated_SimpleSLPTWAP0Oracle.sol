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
14 
15 contract SimpleSLPTWAP0Oracle is IOracle {
16     using FixedPoint for *;
17     using BoringMath for uint256;
18     uint256 public constant PERIOD = 5 minutes;
19 
20     struct PairInfo {
21         uint256 priceCumulativeLast;
22         uint32 blockTimestampLast;
23         uint144 priceAverage;
24     }
25 
26     mapping(IUniswapV2Pair => PairInfo) public pairs; // Map of pairs and their info
27     mapping(address => IUniswapV2Pair) public callerInfo; // Map of callers to pairs
28 
29     function _get(IUniswapV2Pair pair, uint32 blockTimestamp) public view returns (uint256) {
30         uint256 priceCumulative = pair.price0CumulativeLast();
31 
32         // if time has elapsed since the last update on the pair, mock the accumulated price values
33         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
34         priceCumulative += uint256(FixedPoint.fraction(reserve1, reserve0)._x) * (blockTimestamp - blockTimestampLast); // overflows ok
35 
36         // overflow is desired, casting never truncates
37         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
38         return priceCumulative;
39     }
40 
41     function getDataParameter(IUniswapV2Pair pair) public pure returns (bytes memory) {
42         return abi.encode(pair);
43     }
44 
45     // Get the latest exchange rate, if no valid (recent) rate is available, return false
46     /// @inheritdoc IOracle
47     function get(bytes calldata data) external override returns (bool, uint256) {
48         IUniswapV2Pair pair = abi.decode(data, (IUniswapV2Pair));
49         uint32 blockTimestamp = uint32(block.timestamp);
50         if (pairs[pair].blockTimestampLast == 0) {
51             pairs[pair].blockTimestampLast = blockTimestamp;
52             pairs[pair].priceCumulativeLast = _get(pair, blockTimestamp);
53             return (false, 0);
54         }
55         uint32 timeElapsed = blockTimestamp - pairs[pair].blockTimestampLast; // overflow is desired
56         if (timeElapsed < PERIOD) {
57             return (true, pairs[pair].priceAverage);
58         }
59 
60         uint256 priceCumulative = _get(pair, blockTimestamp);
61         pairs[pair].priceAverage = FixedPoint
62             .uq112x112(uint224((priceCumulative - pairs[pair].priceCumulativeLast) / timeElapsed))
63             .mul(1e18)
64             .decode144();
65         pairs[pair].blockTimestampLast = blockTimestamp;
66         pairs[pair].priceCumulativeLast = priceCumulative;
67 
68         return (true, pairs[pair].priceAverage);
69     }
70 
71     // Check the last exchange rate without any state changes
72     /// @inheritdoc IOracle
73     function peek(bytes calldata data) public view override returns (bool, uint256) {
74         IUniswapV2Pair pair = abi.decode(data, (IUniswapV2Pair));
75         uint32 blockTimestamp = uint32(block.timestamp);
76         if (pairs[pair].blockTimestampLast == 0) {
77             return (false, 0);
78         }
79         uint32 timeElapsed = blockTimestamp - pairs[pair].blockTimestampLast; // overflow is desired
80         if (timeElapsed < PERIOD) {
81             return (true, pairs[pair].priceAverage);
82         }
83 
84         uint256 priceCumulative = _get(pair, blockTimestamp);
85         uint144 priceAverage =
86             FixedPoint.uq112x112(uint224((priceCumulative - pairs[pair].priceCumulativeLast) / timeElapsed)).mul(1e18).decode144();
87 
88         return (true, priceAverage);
89     }
90 
91     // Check the current spot exchange rate without any state changes
92     /// @inheritdoc IOracle
93     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
94         IUniswapV2Pair pair = abi.decode(data, (IUniswapV2Pair));
95         (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
96         rate = reserve1.mul(1e18) / reserve0;
97     }
98 
99     /// @inheritdoc IOracle
100     function name(bytes calldata) public view override returns (string memory) {
101         return "SushiSwap TWAP";
102     }
103 
104     /// @inheritdoc IOracle
105     function symbol(bytes calldata) public view override returns (string memory) {
106         return "S";
107     }
108 }
