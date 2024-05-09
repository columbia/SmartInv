1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10 
11     function getPair(address tokenA, address tokenB) external view returns (address pair);
12     function allPairs(uint) external view returns (address pair);
13     function allPairsLength() external view returns (uint);
14 
15     function createPair(address tokenA, address tokenB) external returns (address pair);
16 
17     function setFeeTo(address) external;
18     function setFeeToSetter(address) external;
19 }
20 
21 interface IUniswapV2Pair {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24 
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31 
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35 
36     function DOMAIN_SEPARATOR() external view returns (bytes32);
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38     function nonces(address owner) external view returns (uint);
39 
40     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
41 
42     event Mint(address indexed sender, uint amount0, uint amount1);
43     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
44     event Swap(
45         address indexed sender,
46         uint amount0In,
47         uint amount1In,
48         uint amount0Out,
49         uint amount1Out,
50         address indexed to
51     );
52     event Sync(uint112 reserve0, uint112 reserve1);
53 
54     function MINIMUM_LIQUIDITY() external pure returns (uint);
55     function factory() external view returns (address);
56     function token0() external view returns (address);
57     function token1() external view returns (address);
58     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
59     function price0CumulativeLast() external view returns (uint);
60     function price1CumulativeLast() external view returns (uint);
61     function kLast() external view returns (uint);
62 
63     function mint(address to) external returns (uint liquidity);
64     function burn(address to) external returns (uint amount0, uint amount1);
65     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
66     function skim(address to) external;
67     function sync() external;
68 
69     function initialize(address, address) external;
70 }
71 
72 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
73 library FixedPoint {
74     // range: [0, 2**112 - 1]
75     // resolution: 1 / 2**112
76     struct uq112x112 {
77         uint224 _x;
78     }
79 
80     // range: [0, 2**144 - 1]
81     // resolution: 1 / 2**112
82     struct uq144x112 {
83         uint _x;
84     }
85 
86     uint8 private constant RESOLUTION = 112;
87 
88     // encode a uint112 as a UQ112x112
89     function encode(uint112 x) internal pure returns (uq112x112 memory) {
90         return uq112x112(uint224(x) << RESOLUTION);
91     }
92 
93     // encodes a uint144 as a UQ144x112
94     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
95         return uq144x112(uint256(x) << RESOLUTION);
96     }
97 
98     // divide a UQ112x112 by a uint112, returning a UQ112x112
99     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
100         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
101         return uq112x112(self._x / uint224(x));
102     }
103 
104     // multiply a UQ112x112 by a uint, returning a UQ144x112
105     // reverts on overflow
106     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
107         uint z;
108         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
109         return uq144x112(z);
110     }
111 
112     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
113     // equivalent to encode(numerator).div(denominator)
114     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
115         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
116         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
117     }
118 
119     // decode a UQ112x112 into a uint112 by truncating after the radix point
120     function decode(uq112x112 memory self) internal pure returns (uint112) {
121         return uint112(self._x >> RESOLUTION);
122     }
123 
124     // decode a UQ144x112 into a uint144 by truncating after the radix point
125     function decode144(uq144x112 memory self) internal pure returns (uint144) {
126         return uint144(self._x >> RESOLUTION);
127     }
128 }
129 
130 // library with helper methods for oracles that are concerned with computing average prices
131 library UniswapV2OracleLibrary {
132     using FixedPoint for *;
133 
134     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
135     function currentBlockTimestamp() internal view returns (uint32) {
136         return uint32(block.timestamp % 2 ** 32);
137     }
138 
139     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
140     function currentCumulativePrices(
141         address pair
142     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
143         blockTimestamp = currentBlockTimestamp();
144         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
145         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
146 
147         // if time has elapsed since the last update on the pair, mock the accumulated price values
148         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
149         if (blockTimestampLast != blockTimestamp) {
150             // subtraction overflow is desired
151             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
152             // addition overflow is desired
153             // counterfactual
154             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
155             // counterfactual
156             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
157         }
158     }
159 }
160 
161 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
162 
163 /**
164  * @dev Wrappers over Solidity's arithmetic operations with added overflow
165  * checks.
166  *
167  * Arithmetic operations in Solidity wrap on overflow. This can easily result
168  * in bugs, because programmers usually assume that an overflow raises an
169  * error, which is the standard behavior in high level programming languages.
170  * `SafeMath` restores this intuition by reverting the transaction when an
171  * operation overflows.
172  *
173  * Using this library instead of the unchecked operations eliminates an entire
174  * class of bugs, so it's recommended to use it always.
175  */
176 library SafeMath {
177     /**
178      * @dev Returns the addition of two unsigned integers, reverting on overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      * - Addition cannot overflow.
184      */
185     function add(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 c = a + b;
187         require(c >= a, "SafeMath: addition overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      * - Addition cannot overflow.
199      */
200     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         uint256 c = a + b;
202         require(c >= a, errorMessage);
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
209      *
210      * Counterpart to Solidity's `-` operator.
211      *
212      * Requirements:
213      * - Subtraction cannot underflow.
214      */
215     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216         return sub(a, b, "SafeMath: subtraction underflow");
217     }
218 
219     /**
220      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      * - Subtraction cannot underflow.
226      */
227     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b <= a, errorMessage);
229         uint256 c = a - b;
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
236      *
237      * Counterpart to Solidity's `*` operator.
238      *
239      * Requirements:
240      * - Multiplication cannot overflow.
241      */
242     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
244         // benefit is lost if 'b' is also tested.
245         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
246         if (a == 0) {
247             return 0;
248         }
249 
250         uint256 c = a * b;
251         require(c / a == b, "SafeMath: multiplication overflow");
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
258      *
259      * Counterpart to Solidity's `*` operator.
260      *
261      * Requirements:
262      * - Multiplication cannot overflow.
263      */
264     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
266         // benefit is lost if 'b' is also tested.
267         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
268         if (a == 0) {
269             return 0;
270         }
271 
272         uint256 c = a * b;
273         require(c / a == b, errorMessage);
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the integer division of two unsigned integers.
280      * Reverts on division by zero. The result is rounded towards zero.
281      *
282      * Counterpart to Solidity's `/` operator. Note: this function uses a
283      * `revert` opcode (which leaves remaining gas untouched) while Solidity
284      * uses an invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b) internal pure returns (uint256) {
290         return div(a, b, "SafeMath: division by zero");
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers.
295      * Reverts with custom message on division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      * - The divisor cannot be zero.
303      */
304     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         // Solidity only automatically asserts when dividing by 0
306         require(b > 0, errorMessage);
307         uint256 c = a / b;
308         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * Reverts when dividing by zero.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      * - The divisor cannot be zero.
323      */
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         return mod(a, b, "SafeMath: modulo by zero");
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * Reverts with custom message when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      * - The divisor cannot be zero.
338      */
339     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
340         require(b != 0, errorMessage);
341         return a % b;
342     }
343 }
344 
345 library UniswapV2Library {
346     using SafeMath for uint;
347 
348     // returns sorted token addresses, used to handle return values from pairs sorted in this order
349     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
350         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
351         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
352         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
353     }
354 
355     // calculates the CREATE2 address for a pair without making any external calls
356     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
357         (address token0, address token1) = sortTokens(tokenA, tokenB);
358         pair = address(uint(keccak256(abi.encodePacked(
359                 hex'ff',
360                 factory,
361                 keccak256(abi.encodePacked(token0, token1)),
362                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
363             ))));
364     }
365 
366     // fetches and sorts the reserves for a pair
367     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
368         (address token0,) = sortTokens(tokenA, tokenB);
369         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
370         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
371     }
372 
373     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
374     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
375         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
376         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
377         amountB = amountA.mul(reserveB) / reserveA;
378     }
379 
380     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
381     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
382         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
383         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
384         uint amountInWithFee = amountIn.mul(997);
385         uint numerator = amountInWithFee.mul(reserveOut);
386         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
387         amountOut = numerator / denominator;
388     }
389 
390     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
391     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
392         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
393         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
394         uint numerator = reserveIn.mul(amountOut).mul(1000);
395         uint denominator = reserveOut.sub(amountOut).mul(997);
396         amountIn = (numerator / denominator).add(1);
397     }
398 
399     // performs chained getAmountOut calculations on any number of pairs
400     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
401         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
402         amounts = new uint[](path.length);
403         amounts[0] = amountIn;
404         for (uint i; i < path.length - 1; i++) {
405             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
406             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
407         }
408     }
409 
410     // performs chained getAmountIn calculations on any number of pairs
411     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
412         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
413         amounts = new uint[](path.length);
414         amounts[amounts.length - 1] = amountOut;
415         for (uint i = path.length - 1; i > 0; i--) {
416             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
417             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
418         }
419     }
420 }
421 
422 interface WETH9 {
423     function withdraw(uint wad) external;
424 }
425 
426 interface IUniswapV2Router {
427     function swapExactTokensForTokens(
428         uint amountIn,
429         uint amountOutMin,
430         address[] calldata path,
431         address to,
432         uint deadline
433     ) external returns (uint[] memory amounts);
434 }
435 
436 interface IKeep3rV1 {
437     function isMinKeeper(address keeper, uint minBond, uint earned, uint age) external returns (bool);
438     function receipt(address credit, address keeper, uint amount) external;
439     function unbond(address bonding, uint amount) external;
440     function withdraw(address bonding) external;
441     function bonds(address keeper, address credit) external view returns (uint);
442     function unbondings(address keeper, address credit) external view returns (uint);
443     function approve(address spender, uint amount) external returns (bool);
444     function jobs(address job) external view returns (bool);
445     function balanceOf(address account) external view returns (uint256);
446     function worked(address keeper) external;
447     function KPRH() external view returns (IKeep3rV1Helper);
448 }
449 
450 interface IKeep3rV1Helper {
451     function getQuoteLimit(uint gasUsed) external view returns (uint);
452 }
453 
454 // sliding oracle that uses observations collected to provide moving price averages in the past
455 contract Keep3rV1Oracle {
456     using FixedPoint for *;
457     using SafeMath for uint;
458 
459     struct Observation {
460         uint timestamp;
461         uint price0Cumulative;
462         uint price1Cumulative;
463     }
464     
465     uint public minKeep = 200e18;
466 
467     modifier keeper() {
468         require(KP3R.isMinKeeper(msg.sender, minKeep, 0, 0), "::isKeeper: keeper is not registered");
469         _;
470     }
471 
472     modifier upkeep() {
473         uint _gasUsed = gasleft();
474         require(KP3R.isMinKeeper(msg.sender, minKeep, 0, 0), "::isKeeper: keeper is not registered");
475         _;
476         uint _received = KP3R.KPRH().getQuoteLimit(_gasUsed.sub(gasleft()));
477         KP3R.receipt(address(KP3R), address(this), _received);
478         _received = _swap(_received);
479         msg.sender.transfer(_received);
480     }
481 
482     address public governance;
483     address public pendingGovernance;
484     
485     function setMinKeep(uint _keep) external {
486         require(msg.sender == governance, "setGovernance: !gov");
487         minKeep = _keep;
488     }
489 
490     /**
491      * @notice Allows governance to change governance (for future upgradability)
492      * @param _governance new governance address to set
493      */
494     function setGovernance(address _governance) external {
495         require(msg.sender == governance, "setGovernance: !gov");
496         pendingGovernance = _governance;
497     }
498 
499     /**
500      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
501      */
502     function acceptGovernance() external {
503         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
504         governance = pendingGovernance;
505     }
506 
507     IKeep3rV1 public constant KP3R = IKeep3rV1(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
508     WETH9 public constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
509     IUniswapV2Router public constant UNI = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
510 
511     address public constant factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
512     // this is redundant with granularity and windowSize, but stored for gas savings & informational purposes.
513     uint public constant periodSize = 1800;
514 
515     address[] internal _pairs;
516     mapping(address => bool) internal _known;
517 
518     function pairs() external view returns (address[] memory) {
519         return _pairs;
520     }
521 
522     mapping(address => Observation[]) public observations;
523     
524     function observationLength(address pair) external view returns (uint) {
525         return observations[pair].length;
526     }
527     
528     function pairFor(address tokenA, address tokenB) external pure returns (address) {
529         return UniswapV2Library.pairFor(factory, tokenA, tokenB);
530     }
531     
532     function pairForWETH(address tokenA) external pure returns (address) {
533         return UniswapV2Library.pairFor(factory, tokenA, address(WETH));
534     }
535 
536     constructor() public {
537         governance = msg.sender;
538     }
539 
540     function updatePair(address pair) external keeper returns (bool) {
541         return _update(pair);
542     }
543 
544     function update(address tokenA, address tokenB) external keeper returns (bool) {
545         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
546         return _update(pair);
547     }
548 
549     function add(address tokenA, address tokenB) external {
550         require(msg.sender == governance, "UniswapV2Oracle::add: !gov");
551         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
552         require(!_known[pair], "known");
553         _known[pair] = true;
554         _pairs.push(pair);
555 
556         (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
557         observations[pair].push(Observation(block.timestamp, price0Cumulative, price1Cumulative));
558     }
559 
560     function work() public upkeep {
561         bool worked = _updateAll();
562         require(worked, "UniswapV2Oracle: !work");
563     }
564 
565     function workForFree() public keeper {
566         bool worked = _updateAll();
567         require(worked, "UniswapV2Oracle: !work");
568     }
569     
570     function lastObservation(address pair) public view returns (Observation memory) {
571         return observations[pair][observations[pair].length-1];
572     }
573 
574     function _updateAll() internal returns (bool updated) {
575         for (uint i = 0; i < _pairs.length; i++) {
576             if (_update(_pairs[i])) {
577                 updated = true;
578             }
579         }
580     }
581 
582     function updateFor(uint i, uint length) external keeper returns (bool updated) {
583         for (; i < length; i++) {
584             if (_update(_pairs[i])) {
585                 updated = true;
586             }
587         }
588     }
589 
590     function workable(address pair) public view returns (bool) {
591         return (block.timestamp - lastObservation(pair).timestamp) > periodSize;
592     }
593 
594     function workable() external view returns (bool) {
595         for (uint i = 0; i < _pairs.length; i++) {
596             if (workable(_pairs[i])) {
597                 return true;
598             }
599         }
600         return false;
601     }
602 
603     function _update(address pair) internal returns (bool) {
604         // we only want to commit updates once per period (i.e. windowSize / granularity)
605         Observation memory _point = lastObservation(pair);
606         uint timeElapsed = block.timestamp - _point.timestamp;
607         if (timeElapsed > periodSize) {
608             (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
609             observations[pair].push(Observation(block.timestamp, price0Cumulative, price1Cumulative));
610             return true;
611         }
612         return false;
613     }
614 
615     function computeAmountOut(
616         uint priceCumulativeStart, uint priceCumulativeEnd,
617         uint timeElapsed, uint amountIn
618     ) private pure returns (uint amountOut) {
619         // overflow is desired.
620         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
621             uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
622         );
623         amountOut = priceAverage.mul(amountIn).decode144();
624     }
625 
626     function _valid(address pair, uint age) internal view returns (bool) {
627         return (block.timestamp - lastObservation(pair).timestamp) <= age;
628     }
629 
630     function current(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut) {
631         address pair = UniswapV2Library.pairFor(factory, tokenIn, tokenOut);
632         require(_valid(pair, periodSize.mul(2)), "UniswapV2Oracle::quote: stale prices");
633         (address token0,) = UniswapV2Library.sortTokens(tokenIn, tokenOut);
634 
635         Observation memory _observation = lastObservation(pair);
636         (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
637         if (block.timestamp == _observation.timestamp) {
638             _observation = observations[pair][observations[pair].length-2];
639         }
640         
641         uint timeElapsed = block.timestamp - _observation.timestamp;
642         timeElapsed = timeElapsed == 0 ? 1 : timeElapsed;
643         if (token0 == tokenIn) {
644             return computeAmountOut(_observation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);
645         } else {
646             return computeAmountOut(_observation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);
647         }
648     }
649 
650     function quote(address tokenIn, uint amountIn, address tokenOut, uint granularity) external view returns (uint amountOut) {
651         address pair = UniswapV2Library.pairFor(factory, tokenIn, tokenOut);
652         require(_valid(pair, periodSize.mul(granularity)), "UniswapV2Oracle::quote: stale prices");
653         (address token0,) = UniswapV2Library.sortTokens(tokenIn, tokenOut);
654 
655         uint priceAverageCumulative = 0;
656         uint length = observations[pair].length-1;
657         uint i = length.sub(granularity);
658 
659 
660         uint nextIndex = 0;
661         if (token0 == tokenIn) {
662             for (; i < length; i++) {
663                 nextIndex = i+1;
664                 priceAverageCumulative += computeAmountOut(
665                     observations[pair][i].price0Cumulative,
666                     observations[pair][nextIndex].price0Cumulative, 
667                     observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
668             }
669         } else {
670             for (; i < length; i++) {
671                 nextIndex = i+1;
672                 priceAverageCumulative += computeAmountOut(
673                     observations[pair][i].price1Cumulative,
674                     observations[pair][nextIndex].price1Cumulative, 
675                     observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
676             }
677         }
678         return priceAverageCumulative.div(granularity);
679     }
680     
681     function prices(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
682         return sample(tokenIn, amountIn, tokenOut, points, 1);
683     }
684     
685     function sample(address tokenIn, uint amountIn, address tokenOut, uint points, uint window) public view returns (uint[] memory) {
686         address pair = UniswapV2Library.pairFor(factory, tokenIn, tokenOut);
687         (address token0,) = UniswapV2Library.sortTokens(tokenIn, tokenOut);
688         uint[] memory _prices = new uint[](points);
689         
690         uint length = observations[pair].length-1;
691         uint i = length.sub(points * window);
692         uint nextIndex = 0;
693         uint index = 0;
694         
695         if (token0 == tokenIn) {
696             for (; i < length; i+=window) {
697                 nextIndex = i + window;
698                 _prices[index] = computeAmountOut(
699                     observations[pair][i].price0Cumulative,
700                     observations[pair][nextIndex].price0Cumulative, 
701                     observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
702                 index = index + 1;
703             }
704         } else {
705             for (; i < length; i+=window) {
706                 nextIndex = i + window;
707                 _prices[index] = computeAmountOut(
708                     observations[pair][i].price1Cumulative,
709                     observations[pair][nextIndex].price1Cumulative, 
710                     observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
711                 index = index + 1;
712             }
713         }
714         return _prices;
715     }
716     
717     function hourly(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
718         return sample(tokenIn, amountIn, tokenOut, points, 2);
719     }
720     
721     function daily(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
722         return sample(tokenIn, amountIn, tokenOut, points, 48);
723     }
724     
725     function weekly(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
726         return sample(tokenIn, amountIn, tokenOut, points, 336);
727     }
728     
729     function realizedVolatility(address tokenIn, uint amountIn, address tokenOut, uint points, uint window) external view returns (uint) {
730         return stddev(sample(tokenIn, amountIn, tokenOut, points, window));
731     }
732     
733     function realizedVolatilityHourly(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
734         return stddev(sample(tokenIn, amountIn, tokenOut, 1, 2));
735     }
736     
737     function realizedVolatilityDaily(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
738         return stddev(sample(tokenIn, amountIn, tokenOut, 1, 48));
739     }
740     
741     function realizedVolatilityWeekly(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
742         return stddev(sample(tokenIn, amountIn, tokenOut, 1, 336));
743     }
744     
745     /**
746      * @dev sqrt calculates the square root of a given number x
747      * @dev for precision into decimals the number must first
748      * @dev be multiplied by the precision factor desired
749      * @param x uint256 number for the calculation of square root
750      */
751     function sqrt(uint256 x) public pure returns (uint256) {
752         uint256 c = (x + 1) / 2;
753         uint256 b = x;
754         while (c < b) {
755             b = c;
756             c = (x / c + c) / 2;
757         }
758         return b;
759     }
760     
761     /**
762      * @dev stddev calculates the standard deviation for an array of integers
763      * @dev precision is the same as sqrt above meaning for higher precision
764      * @dev the decimal place must be moved prior to passing the params
765      * @param numbers uint[] array of numbers to be used in calculation
766      */
767     function stddev(uint[] memory numbers) public pure returns (uint256 sd) {
768         uint sum = 0;
769         for(uint i = 0; i < numbers.length; i++) {
770             sum += numbers[i];
771         }
772         uint256 mean = sum / numbers.length;        // Integral value; float not supported in Solidity
773         sum = 0;
774         uint i;
775         for(i = 0; i < numbers.length; i++) {
776             sum += (numbers[i] - mean) ** 2;
777         }
778         sd = sqrt(sum / (numbers.length - 1));      //Integral value; float not supported in Solidity
779         return sd;
780     }
781     
782     
783     /**
784      * @dev blackScholesEstimate calculates a rough price estimate for an ATM option
785      * @dev input parameters should be transformed prior to being passed to the function
786      * @dev so as to remove decimal places otherwise results will be far less accurate
787      * @param _vol uint256 volatility of the underlying converted to remove decimals
788      * @param _underlying uint256 price of the underlying asset
789      * @param _time uint256 days to expiration in years multiplied to remove decimals
790      */
791     function blackScholesEstimate(
792         uint256 _vol,
793         uint256 _underlying,
794         uint256 _time
795     ) public pure returns (uint256 estimate) {
796         estimate = 40 * _vol * _underlying * sqrt(_time);
797         return estimate;
798     }
799     
800     /**
801      * @dev fromReturnsBSestimate first calculates the stddev of an array of price returns
802      * @dev then uses that as the volatility param for the blackScholesEstimate
803      * @param _numbers uint256[] array of price returns for volatility calculation
804      * @param _underlying uint256 price of the underlying asset
805      * @param _time uint256 days to expiration in years multiplied to remove decimals
806      */
807     function retBasedBlackScholesEstimate(
808         uint256[] memory _numbers,
809         uint256 _underlying,
810         uint256 _time
811     ) public pure {
812         uint _vol = stddev(_numbers);
813         blackScholesEstimate(_vol, _underlying, _time);
814     }
815     
816     receive() external payable {}
817     
818     function _swap(uint _amount) internal returns (uint) {
819         KP3R.approve(address(UNI), _amount);
820         
821         address[] memory path = new address[](2);
822         path[0] = address(KP3R);
823         path[1] = address(WETH);
824 
825         uint[] memory amounts = UNI.swapExactTokensForTokens(_amount, uint256(0), path, address(this), now.add(1800));
826         WETH.withdraw(amounts[1]);
827         return amounts[1];
828     }
829 }