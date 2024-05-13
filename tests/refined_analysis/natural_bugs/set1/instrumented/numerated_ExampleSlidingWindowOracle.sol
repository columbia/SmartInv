1 pragma solidity =0.6.6;
2 
3 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
4 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
5 import '@uniswap/lib/contracts/libraries/FixedPoint.sol';
6 
7 import '../libraries/SafeMath.sol';
8 import '../libraries/UniswapV2Library.sol';
9 import '../libraries/UniswapV2OracleLibrary.sol';
10 
11 // sliding window oracle that uses observations collected over a window to provide moving price averages in the past
12 // `windowSize` with a precision of `windowSize / granularity`
13 // note this is a singleton oracle and only needs to be deployed once per desired parameters, which
14 // differs from the simple oracle which must be deployed once per pair.
15 contract ExampleSlidingWindowOracle {
16     using FixedPoint for *;
17     using SafeMath for uint;
18 
19     struct Observation {
20         uint timestamp;
21         uint price0Cumulative;
22         uint price1Cumulative;
23     }
24 
25     address public immutable factory;
26     // the desired amount of time over which the moving average should be computed, e.g. 24 hours
27     uint public immutable windowSize;
28     // the number of observations stored for each pair, i.e. how many price observations are stored for the window.
29     // as granularity increases from 1, more frequent updates are needed, but moving averages become more precise.
30     // averages are computed over intervals with sizes in the range:
31     //   [windowSize - (windowSize / granularity) * 2, windowSize]
32     // e.g. if the window size is 24 hours, and the granularity is 24, the oracle will return the average price for
33     //   the period:
34     //   [now - [22 hours, 24 hours], now]
35     uint8 public immutable granularity;
36     // this is redundant with granularity and windowSize, but stored for gas savings & informational purposes.
37     uint public immutable periodSize;
38 
39     // mapping from pair address to a list of price observations of that pair
40     mapping(address => Observation[]) public pairObservations;
41 
42     constructor(address factory_, uint windowSize_, uint8 granularity_) public {
43         require(granularity_ > 1, 'SlidingWindowOracle: GRANULARITY');
44         require(
45             (periodSize = windowSize_ / granularity_) * granularity_ == windowSize_,
46             'SlidingWindowOracle: WINDOW_NOT_EVENLY_DIVISIBLE'
47         );
48         factory = factory_;
49         windowSize = windowSize_;
50         granularity = granularity_;
51     }
52 
53     // returns the index of the observation corresponding to the given timestamp
54     function observationIndexOf(uint timestamp) public view returns (uint8 index) {
55         uint epochPeriod = timestamp / periodSize;
56         return uint8(epochPeriod % granularity);
57     }
58 
59     // returns the observation from the oldest epoch (at the beginning of the window) relative to the current time
60     function getFirstObservationInWindow(address pair) private view returns (Observation storage firstObservation) {
61         uint8 observationIndex = observationIndexOf(block.timestamp);
62         // no overflow issue. if observationIndex + 1 overflows, result is still zero.
63         uint8 firstObservationIndex = (observationIndex + 1) % granularity;
64         firstObservation = pairObservations[pair][firstObservationIndex];
65     }
66 
67     // update the cumulative price for the observation at the current timestamp. each observation is updated at most
68     // once per epoch period.
69     function update(address tokenA, address tokenB) external {
70         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
71 
72         // populate the array with empty observations (first call only)
73         for (uint i = pairObservations[pair].length; i < granularity; i++) {
74             pairObservations[pair].push();
75         }
76 
77         // get the observation for the current period
78         uint8 observationIndex = observationIndexOf(block.timestamp);
79         Observation storage observation = pairObservations[pair][observationIndex];
80 
81         // we only want to commit updates once per period (i.e. windowSize / granularity)
82         uint timeElapsed = block.timestamp - observation.timestamp;
83         if (timeElapsed > periodSize) {
84             (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
85             observation.timestamp = block.timestamp;
86             observation.price0Cumulative = price0Cumulative;
87             observation.price1Cumulative = price1Cumulative;
88         }
89     }
90 
91     // given the cumulative prices of the start and end of a period, and the length of the period, compute the average
92     // price in terms of how much amount out is received for the amount in
93     function computeAmountOut(
94         uint priceCumulativeStart, uint priceCumulativeEnd,
95         uint timeElapsed, uint amountIn
96     ) private pure returns (uint amountOut) {
97         // overflow is desired.
98         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
99             uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
100         );
101         amountOut = priceAverage.mul(amountIn).decode144();
102     }
103 
104     // returns the amount out corresponding to the amount in for a given token using the moving average over the time
105     // range [now - [windowSize, windowSize - periodSize * 2], now]
106     // update must have been called for the bucket corresponding to timestamp `now - windowSize`
107     function consult(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut) {
108         address pair = UniswapV2Library.pairFor(factory, tokenIn, tokenOut);
109         Observation storage firstObservation = getFirstObservationInWindow(pair);
110 
111         uint timeElapsed = block.timestamp - firstObservation.timestamp;
112         require(timeElapsed <= windowSize, 'SlidingWindowOracle: MISSING_HISTORICAL_OBSERVATION');
113         // should never happen.
114         require(timeElapsed >= windowSize - periodSize * 2, 'SlidingWindowOracle: UNEXPECTED_TIME_ELAPSED');
115 
116         (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
117         (address token0,) = UniswapV2Library.sortTokens(tokenIn, tokenOut);
118 
119         if (token0 == tokenIn) {
120             return computeAmountOut(firstObservation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);
121         } else {
122             return computeAmountOut(firstObservation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);
123         }
124     }
125 }
