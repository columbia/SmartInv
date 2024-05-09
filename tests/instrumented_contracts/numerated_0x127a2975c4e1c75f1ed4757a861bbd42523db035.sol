1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IUniswapV2Factory {
5     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
6 
7     function feeTo() external view returns (address);
8     function feeToSetter() external view returns (address);
9 
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13 
14     function createPair(address tokenA, address tokenB) external returns (address pair);
15 
16     function setFeeTo(address) external;
17     function setFeeToSetter(address) external;
18 }
19 
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23 
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30 
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34 
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38 
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40 
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52 
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61 
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67 
68     function initialize(address, address) external;
69 }
70 
71 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
72 library FixedPoint {
73     // range: [0, 2**112 - 1]
74     // resolution: 1 / 2**112
75     struct uq112x112 {
76         uint224 _x;
77     }
78 
79     // range: [0, 2**144 - 1]
80     // resolution: 1 / 2**112
81     struct uq144x112 {
82         uint _x;
83     }
84 
85     uint8 private constant RESOLUTION = 112;
86 
87     // encode a uint112 as a UQ112x112
88     function encode(uint112 x) internal pure returns (uq112x112 memory) {
89         return uq112x112(uint224(x) << RESOLUTION);
90     }
91 
92     // encodes a uint144 as a UQ144x112
93     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
94         return uq144x112(uint256(x) << RESOLUTION);
95     }
96 
97     // divide a UQ112x112 by a uint112, returning a UQ112x112
98     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
99         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
100         return uq112x112(self._x / uint224(x));
101     }
102 
103     // multiply a UQ112x112 by a uint, returning a UQ144x112
104     // reverts on overflow
105     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
106         uint z;
107         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
108         return uq144x112(z);
109     }
110 
111     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
112     // equivalent to encode(numerator).div(denominator)
113     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
114         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
115         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
116     }
117 
118     // decode a UQ112x112 into a uint112 by truncating after the radix point
119     function decode(uq112x112 memory self) internal pure returns (uint112) {
120         return uint112(self._x >> RESOLUTION);
121     }
122 
123     // decode a UQ144x112 into a uint144 by truncating after the radix point
124     function decode144(uq144x112 memory self) internal pure returns (uint144) {
125         return uint144(self._x >> RESOLUTION);
126     }
127 }
128 
129 // library with helper methods for oracles that are concerned with computing average prices
130 library UniswapV2OracleLibrary {
131     using FixedPoint for *;
132 
133     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
134     function currentBlockTimestamp() internal view returns (uint32) {
135         return uint32(block.timestamp % 2 ** 32);
136     }
137 
138     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
139     function currentCumulativePrices(
140         address pair
141     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
142         blockTimestamp = currentBlockTimestamp();
143         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
144         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
145 
146         // if time has elapsed since the last update on the pair, mock the accumulated price values
147         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
148         if (blockTimestampLast != blockTimestamp) {
149             // subtraction overflow is desired
150             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
151             // addition overflow is desired
152             // counterfactual
153             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
154             // counterfactual
155             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
156         }
157     }
158 }
159 
160 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
161 
162 library SafeMath {
163     function add(uint x, uint y) internal pure returns (uint z) {
164         require((z = x + y) >= x, 'ds-math-add-overflow');
165     }
166 
167     function sub(uint x, uint y) internal pure returns (uint z) {
168         require((z = x - y) <= x, 'ds-math-sub-underflow');
169     }
170 
171     function mul(uint x, uint y) internal pure returns (uint z) {
172         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
173     }
174 }
175 
176 library UniswapV2Library {
177     using SafeMath for uint;
178 
179     // returns sorted token addresses, used to handle return values from pairs sorted in this order
180     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
181         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
182         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
183         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
184     }
185 
186     // calculates the CREATE2 address for a pair without making any external calls
187     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
188         (address token0, address token1) = sortTokens(tokenA, tokenB);
189         pair = address(uint(keccak256(abi.encodePacked(
190                 hex'ff',
191                 factory,
192                 keccak256(abi.encodePacked(token0, token1)),
193                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
194             ))));
195     }
196 
197     // fetches and sorts the reserves for a pair
198     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
199         (address token0,) = sortTokens(tokenA, tokenB);
200         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
201         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
202     }
203 
204     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
205     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
206         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
207         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
208         amountB = amountA.mul(reserveB) / reserveA;
209     }
210 
211     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
212     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
213         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
214         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
215         uint amountInWithFee = amountIn.mul(997);
216         uint numerator = amountInWithFee.mul(reserveOut);
217         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
218         amountOut = numerator / denominator;
219     }
220 
221     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
222     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
223         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
224         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
225         uint numerator = reserveIn.mul(amountOut).mul(1000);
226         uint denominator = reserveOut.sub(amountOut).mul(997);
227         amountIn = (numerator / denominator).add(1);
228     }
229 
230     // performs chained getAmountOut calculations on any number of pairs
231     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
232         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
233         amounts = new uint[](path.length);
234         amounts[0] = amountIn;
235         for (uint i; i < path.length - 1; i++) {
236             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
237             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
238         }
239     }
240 
241     // performs chained getAmountIn calculations on any number of pairs
242     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
243         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
244         amounts = new uint[](path.length);
245         amounts[amounts.length - 1] = amountOut;
246         for (uint i = path.length - 1; i > 0; i--) {
247             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
248             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
249         }
250     }
251 }
252 
253 interface IKeep3rV1 {
254     function isKeeper(address) external returns (bool);
255     function worked(address keeper) external;
256 }
257 
258 // sliding window oracle that uses observations collected over a window to provide moving price averages in the past
259 // `windowSize` with a precision of `windowSize / granularity`
260 contract UniswapV2Oracle {
261     using FixedPoint for *;
262     using SafeMath for uint;
263 
264     struct Observation {
265         uint timestamp;
266         uint price0Cumulative;
267         uint price1Cumulative;
268     }
269     
270     modifier keeper() {
271         require(KP3R.isKeeper(msg.sender), "::isKeeper: keeper is not registered");
272         _;
273     }
274     
275     modifier upkeep() {
276         require(KP3R.isKeeper(msg.sender), "::isKeeper: keeper is not registered");
277         _;
278         KP3R.worked(msg.sender);
279     }
280     
281     address public governance;
282     address public pendingGovernance;
283     
284     /**
285      * @notice Allows governance to change governance (for future upgradability)
286      * @param _governance new governance address to set
287      */
288     function setGovernance(address _governance) external {
289         require(msg.sender == governance, "setGovernance: !gov");
290         pendingGovernance = _governance;
291     }
292 
293     /**
294      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
295      */
296     function acceptGovernance() external {
297         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
298         governance = pendingGovernance;
299     }
300     
301     function setKeep3r(address _keep3r) external {
302         require(msg.sender == governance, "setKeep3r: !gov");
303         KP3R = IKeep3rV1(_keep3r);
304     }
305     
306     IKeep3rV1 public KP3R;
307 
308     address public immutable factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
309     // the desired amount of time over which the moving average should be computed, e.g. 24 hours
310     uint public immutable windowSize = 14400;
311     // the number of observations stored for each pair, i.e. how many price observations are stored for the window.
312     // as granularity increases from 1, more frequent updates are needed, but moving averages become more precise.
313     // averages are computed over intervals with sizes in the range:
314     //   [windowSize - (windowSize / granularity) * 2, windowSize]
315     // e.g. if the window size is 24 hours, and the granularity is 24, the oracle will return the average price for
316     //   the period:
317     //   [now - [22 hours, 24 hours], now]
318     uint8 public immutable granularity = 8;
319     // this is redundant with granularity and windowSize, but stored for gas savings & informational purposes.
320     uint public immutable periodSize = 1800;
321     
322     address[] internal _pairs;
323     mapping(address => bool) internal _known;
324     mapping(address => uint) public lastUpdated;
325     
326     function pairs() external view returns (address[] memory) {
327         return _pairs;
328     }
329 
330     // mapping from pair address to a list of price observations of that pair
331     mapping(address => Observation[]) public pairObservations;
332 
333     constructor(address _keep3r) public {
334         governance = msg.sender;
335         KP3R = IKeep3rV1(_keep3r);
336     }
337 
338     // returns the index of the observation corresponding to the given timestamp
339     function observationIndexOf(uint timestamp) public view returns (uint8 index) {
340         uint epochPeriod = timestamp / periodSize;
341         return uint8(epochPeriod % granularity);
342     }
343 
344     // returns the observation from the oldest epoch (at the beginning of the window) relative to the current time
345     function getFirstObservationInWindow(address pair) private view returns (Observation storage firstObservation) {
346         uint8 observationIndex = observationIndexOf(block.timestamp);
347         // no overflow issue. if observationIndex + 1 overflows, result is still zero.
348         uint8 firstObservationIndex = (observationIndex + 1) % granularity;
349         firstObservation = pairObservations[pair][firstObservationIndex];
350     }
351     
352     function updatePair(address pair) external keeper returns (bool) {
353         return _update(pair);
354     }
355 
356     // update the cumulative price for the observation at the current timestamp. each observation is updated at most
357     // once per epoch period.
358     function update(address tokenA, address tokenB) external keeper returns (bool) {
359         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
360         return _update(pair);
361     }
362     
363     function add(address tokenA, address tokenB) external {
364         require(msg.sender == governance, "UniswapV2Oracle::add: !gov");
365         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
366         require(!_known[pair], "known");
367         _known[pair] = true;
368         _pairs.push(pair);
369     }
370     
371     function work() public upkeep {
372         bool worked = _updateAll();
373         require(worked, "UniswapV2Oracle: !work");
374     }
375     
376     function _updateAll() internal returns (bool updated) {
377         for (uint i = 0; i < _pairs.length; i++) {
378             if (_update(_pairs[i])) {
379                 updated = true;
380             }
381         }
382     }
383     
384     function updateFor(uint i, uint length) external keeper returns (bool updated) {
385         for (; i < length; i++) {
386             if (_update(_pairs[i])) {
387                 updated = true;
388             }
389         }
390     }
391     
392     function updateableList() external view returns (address[] memory list) {
393         uint _index = 0;
394         for (uint i = 0; i < _pairs.length; i++) {
395             if (updateable(_pairs[i])) {
396                list[_index++] = _pairs[i];
397             }
398         }
399     }
400     
401     function updateable(address pair) public view returns (bool) {
402         return (block.timestamp - lastUpdated[pair]) > periodSize;
403     }
404     
405     function updateable() external view returns (bool) {
406         for (uint i = 0; i < _pairs.length; i++) {
407             if (updateable(_pairs[i])) {
408                 return true;
409             }
410         }
411         return false;
412     }
413     
414     function updateableFor(uint i, uint length) external view returns (bool) {
415         for (; i < length; i++) {
416             if (updateable(_pairs[i])) {
417                 return true;
418             }
419         }
420         return false;
421     }
422     
423     function _update(address pair) internal returns (bool) {
424         // populate the array with empty observations (first call only)
425         for (uint i = pairObservations[pair].length; i < granularity; i++) {
426             pairObservations[pair].push();
427         }
428 
429         // get the observation for the current period
430         uint8 observationIndex = observationIndexOf(block.timestamp);
431         Observation storage observation = pairObservations[pair][observationIndex];
432 
433         // we only want to commit updates once per period (i.e. windowSize / granularity)
434         uint timeElapsed = block.timestamp - observation.timestamp;
435         if (timeElapsed > periodSize) {
436             (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
437             observation.timestamp = block.timestamp;
438             lastUpdated[pair] = block.timestamp;
439             observation.price0Cumulative = price0Cumulative;
440             observation.price1Cumulative = price1Cumulative;
441             return true;
442         }
443         
444         return false;
445     }
446 
447     // given the cumulative prices of the start and end of a period, and the length of the period, compute the average
448     // price in terms of how much amount out is received for the amount in
449     function computeAmountOut(
450         uint priceCumulativeStart, uint priceCumulativeEnd,
451         uint timeElapsed, uint amountIn
452     ) private pure returns (uint amountOut) {
453         // overflow is desired.
454         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
455             uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
456         );
457         amountOut = priceAverage.mul(amountIn).decode144();
458     }
459 
460     // returns the amount out corresponding to the amount in for a given token using the moving average over the time
461     // range [now - [windowSize, windowSize - periodSize * 2], now]
462     // update must have been called for the bucket corresponding to timestamp `now - windowSize`
463     function consult(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut) {
464         address pair = UniswapV2Library.pairFor(factory, tokenIn, tokenOut);
465         Observation storage firstObservation = getFirstObservationInWindow(pair);
466 
467         uint timeElapsed = block.timestamp - firstObservation.timestamp;
468         require(timeElapsed <= windowSize, 'SlidingWindowOracle: MISSING_HISTORICAL_OBSERVATION');
469         // should never happen.
470         require(timeElapsed >= windowSize - periodSize * 2, 'SlidingWindowOracle: UNEXPECTED_TIME_ELAPSED');
471 
472         (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
473         (address token0,) = UniswapV2Library.sortTokens(tokenIn, tokenOut);
474 
475         if (token0 == tokenIn) {
476             return computeAmountOut(firstObservation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);
477         } else {
478             return computeAmountOut(firstObservation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);
479         }
480     }
481 }