1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.6;
4 
5 import "../interfaces/IBabyFactory.sol";
6 import "../interfaces/IBabyPair.sol";
7 import "../libraries/BabyLibrary.sol";
8 
9 library FixedPoint {
10     // range: [0, 2**112 - 1]
11     // resolution: 1 / 2**112
12     struct uq112x112 {
13         uint224 _x;
14     }
15 
16     // range: [0, 2**144 - 1]
17     // resolution: 1 / 2**112
18     struct uq144x112 {
19         uint _x;
20     }
21 
22     uint8 private constant RESOLUTION = 112;
23 
24     // encode a uint112 as a UQ112x112
25     function encode(uint112 x) internal pure returns (uq112x112 memory) {
26         return uq112x112(uint224(x) << RESOLUTION);
27     }
28 
29     // encodes a uint144 as a UQ144x112
30     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
31         return uq144x112(uint256(x) << RESOLUTION);
32     }
33 
34     // divide a UQ112x112 by a uint112, returning a UQ112x112
35     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
36         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
37         return uq112x112(self._x / uint224(x));
38     }
39 
40     // multiply a UQ112x112 by a uint, returning a UQ144x112
41     // reverts on overflow
42     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
43         uint z;
44         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
45         return uq144x112(z);
46     }
47 
48     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
49     // equivalent to encode(numerator).div(denominator)
50     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
51         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
52         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
53     }
54 
55     // decode a UQ112x112 into a uint112 by truncating after the radix point
56     function decode(uq112x112 memory self) internal pure returns (uint112) {
57         return uint112(self._x >> RESOLUTION);
58     }
59 
60     // decode a UQ144x112 into a uint144 by truncating after the radix point
61     function decode144(uq144x112 memory self) internal pure returns (uint144) {
62         return uint144(self._x >> RESOLUTION);
63     }
64 }
65 
66 library BabyOracleLibrary {
67     using FixedPoint for *;
68 
69     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
70     function currentBlockTimestamp() internal view returns (uint32) {
71         return uint32(block.timestamp % 2 ** 32);
72     }
73 
74     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
75     function currentCumulativePrices(
76         address pair
77     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
78         blockTimestamp = currentBlockTimestamp();
79         price0Cumulative = IBabyPair(pair).price0CumulativeLast();
80         price1Cumulative = IBabyPair(pair).price1CumulativeLast();
81 
82         // if time has elapsed since the last update on the pair, mock the accumulated price values
83         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IBabyPair(pair).getReserves();
84         if (blockTimestampLast != blockTimestamp) {
85             // subtraction overflow is desired
86             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
87             // addition overflow is desired
88             // counterfactual
89             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
90             // counterfactual
91             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
92         }
93     }
94 }
95 
96 contract Oracle {
97     using FixedPoint for *;
98     using SafeMath for uint;
99 
100     struct Observation {
101         uint timestamp;
102         uint price0Cumulative;
103         uint price1Cumulative;
104     }
105 
106     address public immutable factory;
107     uint public constant CYCLE = 30 minutes;
108 
109     // mapping from pair address to a list of price observations of that pair
110     mapping(address => Observation) public pairObservations;
111 
112     constructor(address factory_) public {
113         factory = factory_;
114     }
115 
116 
117     function update(address tokenA, address tokenB) external {
118         if (IBabyFactory(factory).getPair(tokenA, tokenB) == address(0)) {
119             return;
120         }
121         address pair = IBabyFactory(factory).expectPairFor(tokenA, tokenB);
122 
123         Observation storage observation = pairObservations[pair];
124         uint timeElapsed = block.timestamp - observation.timestamp;
125         require(timeElapsed >= CYCLE, 'MDEXOracle: PERIOD_NOT_ELAPSED');
126         (uint price0Cumulative, uint price1Cumulative,) = BabyOracleLibrary.currentCumulativePrices(pair);
127         observation.timestamp = block.timestamp;
128         observation.price0Cumulative = price0Cumulative;
129         observation.price1Cumulative = price1Cumulative;
130     }
131 
132 
133     function computeAmountOut(
134         uint priceCumulativeStart, uint priceCumulativeEnd,
135         uint timeElapsed, uint amountIn
136     ) private pure returns (uint amountOut) {
137         // overflow is desired.
138         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
139             uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
140         );
141         amountOut = priceAverage.mul(amountIn).decode144();
142     }
143 
144 
145     function consult(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut) {
146         address pair = IBabyFactory(factory).expectPairFor(tokenIn, tokenOut);
147         Observation storage observation = pairObservations[pair];
148         uint timeElapsed = block.timestamp - observation.timestamp;
149         (uint price0Cumulative, uint price1Cumulative,) = BabyOracleLibrary.currentCumulativePrices(pair);
150         (address token0,) = BabyLibrary.sortTokens(tokenIn, tokenOut);
151 
152         if (token0 == tokenIn) {
153             return computeAmountOut(observation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);
154         } else {
155             return computeAmountOut(observation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);
156         }
157     }
158 }
