1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.6.12;
7 pragma experimental ABIEncoderV2;
8 
9 interface ISushiswap2Factory {
10     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
11 
12     function feeTo() external view returns (address);
13     function feeToSetter() external view returns (address);
14 
15     function getPair(address tokenA, address tokenB) external view returns (address pair);
16     function allPairs(uint) external view returns (address pair);
17     function allPairsLength() external view returns (uint);
18 
19     function createPair(address tokenA, address tokenB) external returns (address pair);
20 
21     function setFeeTo(address) external;
22     function setFeeToSetter(address) external;
23 }
24 
25 interface ISushiswapV2Pair {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28 
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35 
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39 
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43 
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45 
46     event Mint(address indexed sender, uint amount0, uint amount1);
47     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
48     event Swap(
49         address indexed sender,
50         uint amount0In,
51         uint amount1In,
52         uint amount0Out,
53         uint amount1Out,
54         address indexed to
55     );
56     event Sync(uint112 reserve0, uint112 reserve1);
57 
58     function MINIMUM_LIQUIDITY() external pure returns (uint);
59     function factory() external view returns (address);
60     function token0() external view returns (address);
61     function token1() external view returns (address);
62     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
63     function price0CumulativeLast() external view returns (uint);
64     function price1CumulativeLast() external view returns (uint);
65     function kLast() external view returns (uint);
66 
67     function mint(address to) external returns (uint liquidity);
68     function burn(address to) external returns (uint amount0, uint amount1);
69     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
70     function skim(address to) external;
71     function sync() external;
72 
73     function initialize(address, address) external;
74 }
75 
76 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
77 library FixedPoint {
78     // range: [0, 2**112 - 1]
79     // resolution: 1 / 2**112
80     struct uq112x112 {
81         uint224 _x;
82     }
83 
84     // range: [0, 2**144 - 1]
85     // resolution: 1 / 2**112
86     struct uq144x112 {
87         uint _x;
88     }
89 
90     uint8 private constant RESOLUTION = 112;
91 
92     // encode a uint112 as a UQ112x112
93     function encode(uint112 x) internal pure returns (uq112x112 memory) {
94         return uq112x112(uint224(x) << RESOLUTION);
95     }
96 
97     // encodes a uint144 as a UQ144x112
98     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
99         return uq144x112(uint256(x) << RESOLUTION);
100     }
101 
102     // divide a UQ112x112 by a uint112, returning a UQ112x112
103     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
104         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
105         return uq112x112(self._x / uint224(x));
106     }
107 
108     // multiply a UQ112x112 by a uint, returning a UQ144x112
109     // reverts on overflow
110     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
111         uint z;
112         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
113         return uq144x112(z);
114     }
115 
116     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
117     // equivalent to encode(numerator).div(denominator)
118     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
119         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
120         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
121     }
122 
123     // decode a UQ112x112 into a uint112 by truncating after the radix point
124     function decode(uq112x112 memory self) internal pure returns (uint112) {
125         return uint112(self._x >> RESOLUTION);
126     }
127 
128     // decode a UQ144x112 into a uint144 by truncating after the radix point
129     function decode144(uq144x112 memory self) internal pure returns (uint144) {
130         return uint144(self._x >> RESOLUTION);
131     }
132 }
133 
134 // library with helper methods for oracles that are concerned with computing average prices
135 library SushiswapV2OracleLibrary {
136     using FixedPoint for *;
137 
138     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
139     function currentBlockTimestamp() internal view returns (uint32) {
140         return uint32(block.timestamp % 2 ** 32);
141     }
142 
143     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
144     function currentCumulativePrices(
145         address pair
146     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
147         blockTimestamp = currentBlockTimestamp();
148         price0Cumulative = ISushiswapV2Pair(pair).price0CumulativeLast();
149         price1Cumulative = ISushiswapV2Pair(pair).price1CumulativeLast();
150 
151         // if time has elapsed since the last update on the pair, mock the accumulated price values
152         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = ISushiswapV2Pair(pair).getReserves();
153         if (blockTimestampLast != blockTimestamp) {
154             // subtraction overflow is desired
155             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
156             // addition overflow is desired
157             // counterfactual
158             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
159             // counterfactual
160             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
161         }
162     }
163 }
164 
165 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
166 
167 /**
168  * @dev Wrappers over Solidity's arithmetic operations with added overflow
169  * checks.
170  *
171  * Arithmetic operations in Solidity wrap on overflow. This can easily result
172  * in bugs, because programmers usually assume that an overflow raises an
173  * error, which is the standard behavior in high level programming languages.
174  * `SafeMath` restores this intuition by reverting the transaction when an
175  * operation overflows.
176  *
177  * Using this library instead of the unchecked operations eliminates an entire
178  * class of bugs, so it's recommended to use it always.
179  */
180 library SafeMath {
181     /**
182      * @dev Returns the addition of two unsigned integers, reverting on overflow.
183      *
184      * Counterpart to Solidity's `+` operator.
185      *
186      * Requirements:
187      * - Addition cannot overflow.
188      */
189     function add(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a + b;
191         require(c >= a, "SafeMath: addition overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
198      *
199      * Counterpart to Solidity's `+` operator.
200      *
201      * Requirements:
202      * - Addition cannot overflow.
203      */
204     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         uint256 c = a + b;
206         require(c >= a, errorMessage);
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      * - Subtraction cannot underflow.
218      */
219     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220         return sub(a, b, "SafeMath: subtraction underflow");
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      * - Subtraction cannot underflow.
230      */
231     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b <= a, errorMessage);
233         uint256 c = a - b;
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
240      *
241      * Counterpart to Solidity's `*` operator.
242      *
243      * Requirements:
244      * - Multiplication cannot overflow.
245      */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
248         // benefit is lost if 'b' is also tested.
249         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
250         if (a == 0) {
251             return 0;
252         }
253 
254         uint256 c = a * b;
255         require(c / a == b, "SafeMath: multiplication overflow");
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
262      *
263      * Counterpart to Solidity's `*` operator.
264      *
265      * Requirements:
266      * - Multiplication cannot overflow.
267      */
268     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
270         // benefit is lost if 'b' is also tested.
271         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
272         if (a == 0) {
273             return 0;
274         }
275 
276         uint256 c = a * b;
277         require(c / a == b, errorMessage);
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers.
284      * Reverts on division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      * - The divisor cannot be zero.
292      */
293     function div(uint256 a, uint256 b) internal pure returns (uint256) {
294         return div(a, b, "SafeMath: division by zero");
295     }
296 
297     /**
298      * @dev Returns the integer division of two unsigned integers.
299      * Reverts with custom message on division by zero. The result is rounded towards zero.
300      *
301      * Counterpart to Solidity's `/` operator. Note: this function uses a
302      * `revert` opcode (which leaves remaining gas untouched) while Solidity
303      * uses an invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
309         // Solidity only automatically asserts when dividing by 0
310         require(b > 0, errorMessage);
311         uint256 c = a / b;
312         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
313 
314         return c;
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * Reverts when dividing by zero.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
329         return mod(a, b, "SafeMath: modulo by zero");
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * Reverts with custom message when dividing by zero.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      * - The divisor cannot be zero.
342      */
343     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
344         require(b != 0, errorMessage);
345         return a % b;
346     }
347 }
348 
349 library SushiswapV2Library {
350     using SafeMath for uint;
351 
352     // returns sorted token addresses, used to handle return values from pairs sorted in this order
353     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
354         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
355         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
356         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
357     }
358 
359     // calculates the CREATE2 address for a pair without making any external calls
360     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
361         (address token0, address token1) = sortTokens(tokenA, tokenB);
362         pair = address(uint(keccak256(abi.encodePacked(
363                 hex'ff',
364                 factory,
365                 keccak256(abi.encodePacked(token0, token1)),
366                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
367             ))));
368     }
369 
370     // fetches and sorts the reserves for a pair
371     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
372         (address token0,) = sortTokens(tokenA, tokenB);
373         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
374         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
375     }
376 
377     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
378     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
379         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
380         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
381         amountB = amountA.mul(reserveB) / reserveA;
382     }
383 
384     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
385     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
386         require(amountIn > 0, 'SushiswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
387         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
388         uint amountInWithFee = amountIn.mul(997);
389         uint numerator = amountInWithFee.mul(reserveOut);
390         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
391         amountOut = numerator / denominator;
392     }
393 
394     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
395     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
396         require(amountOut > 0, 'SushiswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
397         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
398         uint numerator = reserveIn.mul(amountOut).mul(1000);
399         uint denominator = reserveOut.sub(amountOut).mul(997);
400         amountIn = (numerator / denominator).add(1);
401     }
402 
403     // performs chained getAmountOut calculations on any number of pairs
404     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
405         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
406         amounts = new uint[](path.length);
407         amounts[0] = amountIn;
408         for (uint i; i < path.length - 1; i++) {
409             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
410             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
411         }
412     }
413 
414     // performs chained getAmountIn calculations on any number of pairs
415     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
416         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
417         amounts = new uint[](path.length);
418         amounts[amounts.length - 1] = amountOut;
419         for (uint i = path.length - 1; i > 0; i--) {
420             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
421             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
422         }
423     }
424 }
425 
426 interface WETH9 {
427     function withdraw(uint wad) external;
428 }
429 
430 interface ISushiswapV2Router {
431     function swapExactTokensForTokens(
432         uint amountIn,
433         uint amountOutMin,
434         address[] calldata path,
435         address to,
436         uint deadline
437     ) external returns (uint[] memory amounts);
438 }
439 
440 interface IKeep3rV1 {
441     function isMinKeeper(address keeper, uint minBond, uint earned, uint age) external returns (bool);
442     function receipt(address credit, address keeper, uint amount) external;
443     function unbond(address bonding, uint amount) external;
444     function withdraw(address bonding) external;
445     function bonds(address keeper, address credit) external view returns (uint);
446     function unbondings(address keeper, address credit) external view returns (uint);
447     function approve(address spender, uint amount) external returns (bool);
448     function jobs(address job) external view returns (bool);
449     function balanceOf(address account) external view returns (uint256);
450     function worked(address keeper) external;
451     function KPRH() external view returns (IKeep3rV1Helper);
452 }
453 
454 interface IKeep3rV1Helper {
455     function getQuoteLimit(uint gasUsed) external view returns (uint);
456 }
457 
458 // sliding oracle that uses observations collected to provide moving price averages in the past
459 contract SushiswapV1Oracle {
460     using FixedPoint for *;
461     using SafeMath for uint;
462 
463     struct Observation {
464         uint timestamp;
465         uint price0Cumulative;
466         uint price1Cumulative;
467     }
468     
469     uint public minKeep = 200e18;
470 
471     modifier keeper() {
472         require(KP3R.isMinKeeper(msg.sender, minKeep, 0, 0), "::isKeeper: keeper is not registered");
473         _;
474     }
475 
476     modifier upkeep() {
477         uint _gasUsed = gasleft();
478         require(KP3R.isMinKeeper(msg.sender, minKeep, 0, 0), "::isKeeper: keeper is not registered");
479         _;
480         uint _received = KP3R.KPRH().getQuoteLimit(_gasUsed.sub(gasleft()));
481         KP3R.receipt(address(KP3R), address(this), _received);
482         _received = _swap(_received);
483         msg.sender.transfer(_received);
484     }
485 
486     address public governance;
487     address public pendingGovernance;
488     
489     function setMinKeep(uint _keep) external {
490         require(msg.sender == governance, "setGovernance: !gov");
491         minKeep = _keep;
492     }
493 
494     /**
495      * @notice Allows governance to change governance (for future upgradability)
496      * @param _governance new governance address to set
497      */
498     function setGovernance(address _governance) external {
499         require(msg.sender == governance, "setGovernance: !gov");
500         pendingGovernance = _governance;
501     }
502 
503     /**
504      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
505      */
506     function acceptGovernance() external {
507         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
508         governance = pendingGovernance;
509     }
510 
511     IKeep3rV1 public constant KP3R = IKeep3rV1(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
512     WETH9 public constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
513     ISushiswapV2Router public constant UNI = ISushiswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
514 
515     address public constant factory = 0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac;
516     // this is redundant with granularity and windowSize, but stored for gas savings & informational purposes.
517     uint public constant periodSize = 1800;
518 
519     address[] internal _pairs;
520     mapping(address => bool) internal _known;
521 
522     function pairs() external view returns (address[] memory) {
523         return _pairs;
524     }
525 
526     mapping(address => Observation[]) public observations;
527     
528     function observationLength(address pair) external view returns (uint) {
529         return observations[pair].length;
530     }
531     
532     function pairFor(address tokenA, address tokenB) external pure returns (address) {
533         return SushiswapV2Library.pairFor(factory, tokenA, tokenB);
534     }
535     
536     function pairForWETH(address tokenA) external pure returns (address) {
537         return SushiswapV2Library.pairFor(factory, tokenA, address(WETH));
538     }
539 
540     constructor() public {
541         governance = msg.sender;
542     }
543 
544     function updatePair(address pair) external keeper returns (bool) {
545         return _update(pair);
546     }
547 
548     function update(address tokenA, address tokenB) external keeper returns (bool) {
549         address pair = SushiswapV2Library.pairFor(factory, tokenA, tokenB);
550         return _update(pair);
551     }
552 
553     function add(address tokenA, address tokenB) external {
554         require(msg.sender == governance, "!gov");
555         address pair = SushiswapV2Library.pairFor(factory, tokenA, tokenB);
556         require(!_known[pair], "known");
557         _known[pair] = true;
558         _pairs.push(pair);
559 
560         (uint price0Cumulative, uint price1Cumulative,) = SushiswapV2OracleLibrary.currentCumulativePrices(pair);
561         observations[pair].push(Observation(block.timestamp, price0Cumulative, price1Cumulative));
562     }
563 
564     function work() public upkeep {
565         bool worked = _updateAll();
566         require(worked, "!work");
567     }
568 
569     function workForFree() public keeper {
570         bool worked = _updateAll();
571         require(worked, "!work");
572     }
573     
574     function lastObservation(address pair) public view returns (Observation memory) {
575         return observations[pair][observations[pair].length-1];
576     }
577 
578     function _updateAll() internal returns (bool updated) {
579         for (uint i = 0; i < _pairs.length; i++) {
580             if (_update(_pairs[i])) {
581                 updated = true;
582             }
583         }
584     }
585 
586     function updateFor(uint i, uint length) external keeper returns (bool updated) {
587         for (; i < length; i++) {
588             if (_update(_pairs[i])) {
589                 updated = true;
590             }
591         }
592     }
593 
594     function workable(address pair) public view returns (bool) {
595         return (block.timestamp - lastObservation(pair).timestamp) > periodSize;
596     }
597 
598     function workable() external view returns (bool) {
599         for (uint i = 0; i < _pairs.length; i++) {
600             if (workable(_pairs[i])) {
601                 return true;
602             }
603         }
604         return false;
605     }
606 
607     function _update(address pair) internal returns (bool) {
608         // we only want to commit updates once per period (i.e. windowSize / granularity)
609         Observation memory _point = lastObservation(pair);
610         uint timeElapsed = block.timestamp - _point.timestamp;
611         if (timeElapsed > periodSize) {
612             (uint price0Cumulative, uint price1Cumulative,) = SushiswapV2OracleLibrary.currentCumulativePrices(pair);
613             observations[pair].push(Observation(block.timestamp, price0Cumulative, price1Cumulative));
614             return true;
615         }
616         return false;
617     }
618 
619     function computeAmountOut(
620         uint priceCumulativeStart, uint priceCumulativeEnd,
621         uint timeElapsed, uint amountIn
622     ) private pure returns (uint amountOut) {
623         // overflow is desired.
624         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
625             uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
626         );
627         amountOut = priceAverage.mul(amountIn).decode144();
628     }
629 
630     function _valid(address pair, uint age) internal view returns (bool) {
631         return (block.timestamp - lastObservation(pair).timestamp) <= age;
632     }
633 
634     function current(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut) {
635         address pair = SushiswapV2Library.pairFor(factory, tokenIn, tokenOut);
636         require(_valid(pair, periodSize.mul(2)), "SushiswapV1Oracle::quote: stale prices");
637         (address token0,) = SushiswapV2Library.sortTokens(tokenIn, tokenOut);
638 
639         Observation memory _observation = lastObservation(pair);
640         (uint price0Cumulative, uint price1Cumulative,) = SushiswapV2OracleLibrary.currentCumulativePrices(pair);
641         if (block.timestamp == _observation.timestamp) {
642             _observation = observations[pair][observations[pair].length-2];
643         }
644         
645         uint timeElapsed = block.timestamp - _observation.timestamp;
646         timeElapsed = timeElapsed == 0 ? 1 : timeElapsed;
647         if (token0 == tokenIn) {
648             return computeAmountOut(_observation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);
649         } else {
650             return computeAmountOut(_observation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);
651         }
652     }
653 
654     function quote(address tokenIn, uint amountIn, address tokenOut, uint granularity) external view returns (uint amountOut) {
655         address pair = SushiswapV2Library.pairFor(factory, tokenIn, tokenOut);
656         require(_valid(pair, periodSize.mul(granularity)), "SushiswapV1Oracle::quote: stale prices");
657         (address token0,) = SushiswapV2Library.sortTokens(tokenIn, tokenOut);
658 
659         uint priceAverageCumulative = 0;
660         uint length = observations[pair].length-1;
661         uint i = length.sub(granularity);
662 
663 
664         uint nextIndex = 0;
665         if (token0 == tokenIn) {
666             for (; i < length; i++) {
667                 nextIndex = i+1;
668                 priceAverageCumulative += computeAmountOut(
669                     observations[pair][i].price0Cumulative,
670                     observations[pair][nextIndex].price0Cumulative, 
671                     observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
672             }
673         } else {
674             for (; i < length; i++) {
675                 nextIndex = i+1;
676                 priceAverageCumulative += computeAmountOut(
677                     observations[pair][i].price1Cumulative,
678                     observations[pair][nextIndex].price1Cumulative, 
679                     observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
680             }
681         }
682         return priceAverageCumulative.div(granularity);
683     }
684     
685     function prices(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
686         return sample(tokenIn, amountIn, tokenOut, points, 1);
687     }
688     
689     function sample(address tokenIn, uint amountIn, address tokenOut, uint points, uint window) public view returns (uint[] memory) {
690         address pair = SushiswapV2Library.pairFor(factory, tokenIn, tokenOut);
691         (address token0,) = SushiswapV2Library.sortTokens(tokenIn, tokenOut);
692         uint[] memory _prices = new uint[](points);
693         
694         uint length = observations[pair].length-1;
695         uint i = length.sub(points * window);
696         uint nextIndex = 0;
697         uint index = 0;
698         
699         if (token0 == tokenIn) {
700             for (; i < length; i+=window) {
701                 nextIndex = i + window;
702                 _prices[index] = computeAmountOut(
703                     observations[pair][i].price0Cumulative,
704                     observations[pair][nextIndex].price0Cumulative, 
705                     observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
706                 index = index + 1;
707             }
708         } else {
709             for (; i < length; i+=window) {
710                 nextIndex = i + window;
711                 _prices[index] = computeAmountOut(
712                     observations[pair][i].price1Cumulative,
713                     observations[pair][nextIndex].price1Cumulative, 
714                     observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
715                 index = index + 1;
716             }
717         }
718         return _prices;
719     }
720     
721     function hourly(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
722         return sample(tokenIn, amountIn, tokenOut, points, 2);
723     }
724     
725     function daily(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
726         return sample(tokenIn, amountIn, tokenOut, points, 48);
727     }
728     
729     function weekly(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
730         return sample(tokenIn, amountIn, tokenOut, points, 336);
731     }
732     
733     function realizedVolatility(address tokenIn, uint amountIn, address tokenOut, uint points, uint window) external view returns (uint) {
734         return stddev(sample(tokenIn, amountIn, tokenOut, points, window));
735     }
736     
737     function realizedVolatilityHourly(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
738         return stddev(sample(tokenIn, amountIn, tokenOut, 1, 2));
739     }
740     
741     function realizedVolatilityDaily(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
742         return stddev(sample(tokenIn, amountIn, tokenOut, 1, 48));
743     }
744     
745     function realizedVolatilityWeekly(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
746         return stddev(sample(tokenIn, amountIn, tokenOut, 1, 336));
747     }
748     
749     /**
750      * @dev sqrt calculates the square root of a given number x
751      * @dev for precision into decimals the number must first
752      * @dev be multiplied by the precision factor desired
753      * @param x uint256 number for the calculation of square root
754      */
755     function sqrt(uint256 x) public pure returns (uint256) {
756         uint256 c = (x + 1) / 2;
757         uint256 b = x;
758         while (c < b) {
759             b = c;
760             c = (x / c + c) / 2;
761         }
762         return b;
763     }
764     
765     /**
766      * @dev stddev calculates the standard deviation for an array of integers
767      * @dev precision is the same as sqrt above meaning for higher precision
768      * @dev the decimal place must be moved prior to passing the params
769      * @param numbers uint[] array of numbers to be used in calculation
770      */
771     function stddev(uint[] memory numbers) public pure returns (uint256 sd) {
772         uint sum = 0;
773         for(uint i = 0; i < numbers.length; i++) {
774             sum += numbers[i];
775         }
776         uint256 mean = sum / numbers.length;        // Integral value; float not supported in Solidity
777         sum = 0;
778         uint i;
779         for(i = 0; i < numbers.length; i++) {
780             sum += (numbers[i] - mean) ** 2;
781         }
782         sd = sqrt(sum / (numbers.length - 1));      //Integral value; float not supported in Solidity
783         return sd;
784     }
785     
786     
787     /**
788      * @dev blackScholesEstimate calculates a rough price estimate for an ATM option
789      * @dev input parameters should be transformed prior to being passed to the function
790      * @dev so as to remove decimal places otherwise results will be far less accurate
791      * @param _vol uint256 volatility of the underlying converted to remove decimals
792      * @param _underlying uint256 price of the underlying asset
793      * @param _time uint256 days to expiration in years multiplied to remove decimals
794      */
795     function blackScholesEstimate(
796         uint256 _vol,
797         uint256 _underlying,
798         uint256 _time
799     ) public pure returns (uint256 estimate) {
800         estimate = 40 * _vol * _underlying * sqrt(_time);
801         return estimate;
802     }
803     
804     /**
805      * @dev fromReturnsBSestimate first calculates the stddev of an array of price returns
806      * @dev then uses that as the volatility param for the blackScholesEstimate
807      * @param _numbers uint256[] array of price returns for volatility calculation
808      * @param _underlying uint256 price of the underlying asset
809      * @param _time uint256 days to expiration in years multiplied to remove decimals
810      */
811     function retBasedBlackScholesEstimate(
812         uint256[] memory _numbers,
813         uint256 _underlying,
814         uint256 _time
815     ) public pure {
816         uint _vol = stddev(_numbers);
817         blackScholesEstimate(_vol, _underlying, _time);
818     }
819     
820     receive() external payable {}
821     
822     function _swap(uint _amount) internal returns (uint) {
823         KP3R.approve(address(UNI), _amount);
824         
825         address[] memory path = new address[](2);
826         path[0] = address(KP3R);
827         path[1] = address(WETH);
828 
829         uint[] memory amounts = UNI.swapExactTokensForTokens(_amount, uint256(0), path, address(this), now.add(1800));
830         WETH.withdraw(amounts[1]);
831         return amounts[1];
832     }
833 }