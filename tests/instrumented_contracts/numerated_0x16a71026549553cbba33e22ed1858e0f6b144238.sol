1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: contracts/lib/Babylonian.sol
164 
165 pragma solidity ^0.6.0;
166 
167 library Babylonian {
168     function sqrt(uint256 y) internal pure returns (uint256 z) {
169         if (y > 3) {
170             z = y;
171             uint256 x = y / 2 + 1;
172             while (x < z) {
173                 z = x;
174                 x = (y / x + x) / 2;
175             }
176         } else if (y != 0) {
177             z = 1;
178         }
179         // else z = 0
180     }
181 }
182 
183 // File: contracts/lib/FixedPoint.sol
184 
185 pragma solidity ^0.6.0;
186 
187 
188 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
189 library FixedPoint {
190     // range: [0, 2**112 - 1]
191     // resolution: 1 / 2**112
192     struct uq112x112 {
193         uint224 _x;
194     }
195 
196     // range: [0, 2**144 - 1]
197     // resolution: 1 / 2**112
198     struct uq144x112 {
199         uint256 _x;
200     }
201 
202     uint8 private constant RESOLUTION = 112;
203     uint256 private constant Q112 = uint256(1) << RESOLUTION;
204     uint256 private constant Q224 = Q112 << RESOLUTION;
205 
206     // encode a uint112 as a UQ112x112
207     function encode(uint112 x) internal pure returns (uq112x112 memory) {
208         return uq112x112(uint224(x) << RESOLUTION);
209     }
210 
211     // encodes a uint144 as a UQ144x112
212     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
213         return uq144x112(uint256(x) << RESOLUTION);
214     }
215 
216     // divide a UQ112x112 by a uint112, returning a UQ112x112
217     function div(uq112x112 memory self, uint112 x)
218         internal
219         pure
220         returns (uq112x112 memory)
221     {
222         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
223         return uq112x112(self._x / uint224(x));
224     }
225 
226     // multiply a UQ112x112 by a uint, returning a UQ144x112
227     // reverts on overflow
228     function mul(uq112x112 memory self, uint256 y)
229         internal
230         pure
231         returns (uq144x112 memory)
232     {
233         uint256 z;
234         require(
235             y == 0 || (z = uint256(self._x) * y) / y == uint256(self._x),
236             'FixedPoint: MULTIPLICATION_OVERFLOW'
237         );
238         return uq144x112(z);
239     }
240 
241     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
242     // equivalent to encode(numerator).div(denominator)
243     function fraction(uint112 numerator, uint112 denominator)
244         internal
245         pure
246         returns (uq112x112 memory)
247     {
248         require(denominator > 0, 'FixedPoint: DIV_BY_ZERO');
249         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
250     }
251 
252     // decode a UQ112x112 into a uint112 by truncating after the radix point
253     function decode(uq112x112 memory self) internal pure returns (uint112) {
254         return uint112(self._x >> RESOLUTION);
255     }
256 
257     // decode a UQ144x112 into a uint144 by truncating after the radix point
258     function decode144(uq144x112 memory self) internal pure returns (uint144) {
259         return uint144(self._x >> RESOLUTION);
260     }
261 
262     // take the reciprocal of a UQ112x112
263     function reciprocal(uq112x112 memory self)
264         internal
265         pure
266         returns (uq112x112 memory)
267     {
268         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
269         return uq112x112(uint224(Q224 / self._x));
270     }
271 
272     // square root of a UQ112x112
273     function sqrt(uq112x112 memory self)
274         internal
275         pure
276         returns (uq112x112 memory)
277     {
278         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
279     }
280 }
281 
282 // File: contracts/interfaces/IUniswapV2Pair.sol
283 
284 pragma solidity ^0.6.0;
285 
286 interface IUniswapV2Pair {
287     event Approval(
288         address indexed owner,
289         address indexed spender,
290         uint256 value
291     );
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     function name() external pure returns (string memory);
295 
296     function symbol() external pure returns (string memory);
297 
298     function decimals() external pure returns (uint8);
299 
300     function totalSupply() external view returns (uint256);
301 
302     function balanceOf(address owner) external view returns (uint256);
303 
304     function allowance(address owner, address spender)
305         external
306         view
307         returns (uint256);
308 
309     function approve(address spender, uint256 value) external returns (bool);
310 
311     function transfer(address to, uint256 value) external returns (bool);
312 
313     function transferFrom(
314         address from,
315         address to,
316         uint256 value
317     ) external returns (bool);
318 
319     function DOMAIN_SEPARATOR() external view returns (bytes32);
320 
321     function PERMIT_TYPEHASH() external pure returns (bytes32);
322 
323     function nonces(address owner) external view returns (uint256);
324 
325     function permit(
326         address owner,
327         address spender,
328         uint256 value,
329         uint256 deadline,
330         uint8 v,
331         bytes32 r,
332         bytes32 s
333     ) external;
334 
335     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
336     event Burn(
337         address indexed sender,
338         uint256 amount0,
339         uint256 amount1,
340         address indexed to
341     );
342     event Swap(
343         address indexed sender,
344         uint256 amount0In,
345         uint256 amount1In,
346         uint256 amount0Out,
347         uint256 amount1Out,
348         address indexed to
349     );
350     event Sync(uint112 reserve0, uint112 reserve1);
351 
352     function MINIMUM_LIQUIDITY() external pure returns (uint256);
353 
354     function factory() external view returns (address);
355 
356     function token0() external view returns (address);
357 
358     function token1() external view returns (address);
359 
360     function getReserves()
361         external
362         view
363         returns (
364             uint112 reserve0,
365             uint112 reserve1,
366             uint32 blockTimestampLast
367         );
368 
369     function price0CumulativeLast() external view returns (uint256);
370 
371     function price1CumulativeLast() external view returns (uint256);
372 
373     function kLast() external view returns (uint256);
374 
375     function mint(address to) external returns (uint256 liquidity);
376 
377     function burn(address to)
378         external
379         returns (uint256 amount0, uint256 amount1);
380 
381     function swap(
382         uint256 amount0Out,
383         uint256 amount1Out,
384         address to,
385         bytes calldata data
386     ) external;
387 
388     function skim(address to) external;
389 
390     function sync() external;
391 
392     function initialize(address, address) external;
393 }
394 
395 // File: contracts/lib/UniswapV2Library.sol
396 
397 pragma solidity ^0.6.0;
398 
399 
400 
401 library UniswapV2Library {
402     using SafeMath for uint256;
403 
404     // returns sorted token addresses, used to handle return values from pairs sorted in this order
405     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
406         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
407         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
408         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
409     }
410 
411     // calculates the CREATE2 address for a pair without making any external calls
412     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
413         (address token0, address token1) = sortTokens(tokenA, tokenB);
414         pair = address(uint(keccak256(abi.encodePacked(
415                 hex'ff',
416                 factory,
417                 keccak256(abi.encodePacked(token0, token1)),
418                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
419             ))));
420     }
421 
422     // fetches and sorts the reserves for a pair
423     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
424         (address token0,) = sortTokens(tokenA, tokenB);
425         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
426         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
427     }
428 
429     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
430     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
431         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
432         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
433         amountB = amountA.mul(reserveB) / reserveA;
434     }
435 
436     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
437     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
438         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
439         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
440         uint amountInWithFee = amountIn.mul(997);
441         uint numerator = amountInWithFee.mul(reserveOut);
442         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
443         amountOut = numerator / denominator;
444     }
445 
446     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
447     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
448         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
449         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
450         uint numerator = reserveIn.mul(amountOut).mul(1000);
451         uint denominator = reserveOut.sub(amountOut).mul(997);
452         amountIn = (numerator / denominator).add(1);
453     }
454 
455     // performs chained getAmountOut calculations on any number of pairs
456     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
457         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
458         amounts = new uint[](path.length);
459         amounts[0] = amountIn;
460         for (uint i; i < path.length - 1; i++) {
461             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
462             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
463         }
464     }
465 
466     // performs chained getAmountIn calculations on any number of pairs
467     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
468         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
469         amounts = new uint[](path.length);
470         amounts[amounts.length - 1] = amountOut;
471         for (uint i = path.length - 1; i > 0; i--) {
472             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
473             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
474         }
475     }
476 }
477 
478 // File: contracts/lib/UniswapV2OracleLibrary.sol
479 
480 pragma solidity ^0.6.0;
481 
482 
483 
484 // library with helper methods for oracles that are concerned with computing average prices
485 library UniswapV2OracleLibrary {
486     using FixedPoint for *;
487 
488     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
489     function currentBlockTimestamp() internal view returns (uint32) {
490         return uint32(block.timestamp % 2**32);
491     }
492 
493     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
494     function currentCumulativePrices(address pair)
495         internal
496         view
497         returns (
498             uint256 price0Cumulative,
499             uint256 price1Cumulative,
500             uint32 blockTimestamp
501         )
502     {
503         blockTimestamp = currentBlockTimestamp();
504         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
505         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
506 
507         // if time has elapsed since the last update on the pair, mock the accumulated price values
508         (
509             uint112 reserve0,
510             uint112 reserve1,
511             uint32 blockTimestampLast
512         ) = IUniswapV2Pair(pair).getReserves();
513         if (blockTimestampLast != blockTimestamp) {
514             // subtraction overflow is desired
515             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
516             // addition overflow is desired
517             // counterfactual
518             price0Cumulative +=
519                 uint256(FixedPoint.fraction(reserve1, reserve0)._x) *
520                 timeElapsed;
521             // counterfactual
522             price1Cumulative +=
523                 uint256(FixedPoint.fraction(reserve0, reserve1)._x) *
524                 timeElapsed;
525         }
526     }
527 }
528 
529 // File: @openzeppelin/contracts/GSN/Context.sol
530 
531 pragma solidity ^0.6.0;
532 
533 /*
534  * @dev Provides information about the current execution context, including the
535  * sender of the transaction and its data. While these are generally available
536  * via msg.sender and msg.data, they should not be accessed in such a direct
537  * manner, since when dealing with GSN meta-transactions the account sending and
538  * paying for execution may not be the actual sender (as far as an application
539  * is concerned).
540  *
541  * This contract is only required for intermediate, library-like contracts.
542  */
543 abstract contract Context {
544     function _msgSender() internal view virtual returns (address payable) {
545         return msg.sender;
546     }
547 
548     function _msgData() internal view virtual returns (bytes memory) {
549         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
550         return msg.data;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/access/Ownable.sol
555 
556 pragma solidity ^0.6.0;
557 
558 /**
559  * @dev Contract module which provides a basic access control mechanism, where
560  * there is an account (an owner) that can be granted exclusive access to
561  * specific functions.
562  *
563  * By default, the owner account will be the one that deploys the contract. This
564  * can later be changed with {transferOwnership}.
565  *
566  * This module is used through inheritance. It will make available the modifier
567  * `onlyOwner`, which can be applied to your functions to restrict their use to
568  * the owner.
569  */
570 contract Ownable is Context {
571     address private _owner;
572 
573     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
574 
575     /**
576      * @dev Initializes the contract setting the deployer as the initial owner.
577      */
578     constructor () internal {
579         address msgSender = _msgSender();
580         _owner = msgSender;
581         emit OwnershipTransferred(address(0), msgSender);
582     }
583 
584     /**
585      * @dev Returns the address of the current owner.
586      */
587     function owner() public view returns (address) {
588         return _owner;
589     }
590 
591     /**
592      * @dev Throws if called by any account other than the owner.
593      */
594     modifier onlyOwner() {
595         require(_owner == _msgSender(), "Ownable: caller is not the owner");
596         _;
597     }
598 
599     /**
600      * @dev Leaves the contract without owner. It will not be possible to call
601      * `onlyOwner` functions anymore. Can only be called by the current owner.
602      *
603      * NOTE: Renouncing ownership will leave the contract without an owner,
604      * thereby removing any functionality that is only available to the owner.
605      */
606     function renounceOwnership() public virtual onlyOwner {
607         emit OwnershipTransferred(_owner, address(0));
608         _owner = address(0);
609     }
610 
611     /**
612      * @dev Transfers ownership of the contract to a new account (`newOwner`).
613      * Can only be called by the current owner.
614      */
615     function transferOwnership(address newOwner) public virtual onlyOwner {
616         require(newOwner != address(0), "Ownable: new owner is the zero address");
617         emit OwnershipTransferred(_owner, newOwner);
618         _owner = newOwner;
619     }
620 }
621 
622 // File: contracts/owner/Operator.sol
623 
624 pragma solidity ^0.6.0;
625 
626 
627 
628 contract Operator is Context, Ownable {
629     address private _operator;
630 
631     event OperatorTransferred(
632         address indexed previousOperator,
633         address indexed newOperator
634     );
635 
636     constructor() internal {
637         _operator = _msgSender();
638         emit OperatorTransferred(address(0), _operator);
639     }
640 
641     function operator() public view returns (address) {
642         return _operator;
643     }
644 
645     modifier onlyOperator() {
646         require(
647             _operator == msg.sender,
648             'operator: caller is not the operator'
649         );
650         _;
651     }
652 
653     function isOperator() public view returns (bool) {
654         return _msgSender() == _operator;
655     }
656 
657     function transferOperator(address newOperator_) public onlyOwner {
658         _transferOperator(newOperator_);
659     }
660 
661     function _transferOperator(address newOperator_) internal {
662         require(
663             newOperator_ != address(0),
664             'operator: zero address given for new operator'
665         );
666         emit OperatorTransferred(address(0), newOperator_);
667         _operator = newOperator_;
668     }
669 }
670 
671 // File: contracts/utils/Epoch.sol
672 
673 pragma solidity ^0.6.0;
674 
675 
676 
677 contract Epoch is Operator {
678     using SafeMath for uint256;
679 
680     uint256 private period;
681     uint256 private startTime;
682     uint256 private epoch;
683 
684     /* ========== CONSTRUCTOR ========== */
685 
686     constructor(
687         uint256 _period,
688         uint256 _startTime,
689         uint256 _startEpoch
690     ) public {
691         period = _period;
692         startTime = _startTime;
693         epoch = _startEpoch;
694     }
695 
696     /* ========== Modifier ========== */
697 
698     modifier checkStartTime {
699         require(now >= startTime, 'Epoch: not started yet');
700 
701         _;
702     }
703 
704     modifier checkEpoch {
705         require(now >= nextEpochPoint(), 'Epoch: not allowed');
706 
707         _;
708 
709         epoch = epoch.add(1);
710     }
711 
712     /* ========== VIEW FUNCTIONS ========== */
713 
714     function getCurrentEpoch() public view returns (uint256) {
715         return epoch;
716     }
717 
718     function getPeriod() public view returns (uint256) {
719         return period;
720     }
721 
722     function getStartTime() public view returns (uint256) {
723         return startTime;
724     }
725 
726     function nextEpochPoint() public view returns (uint256) {
727         return startTime.add(epoch.mul(period));
728     }
729 
730     /* ========== GOVERNANCE ========== */
731 
732     function setPeriod(uint256 _period) external onlyOperator {
733         period = _period;
734     }
735 }
736 
737 // File: contracts/interfaces/IUniswapV2Factory.sol
738 
739 pragma solidity ^0.6.0;
740 
741 interface IUniswapV2Factory {
742     event PairCreated(
743         address indexed token0,
744         address indexed token1,
745         address pair,
746         uint256
747     );
748 
749     function getPair(address tokenA, address tokenB)
750         external
751         view
752         returns (address pair);
753 
754     function allPairs(uint256) external view returns (address pair);
755 
756     function allPairsLength() external view returns (uint256);
757 
758     function feeTo() external view returns (address);
759 
760     function feeToSetter() external view returns (address);
761 
762     function createPair(address tokenA, address tokenB)
763         external
764         returns (address pair);
765 }
766 
767 // File: contracts/Oracle.sol
768 
769 pragma solidity ^0.6.0;
770 
771 
772 
773 
774 
775 
776 
777 
778 
779 // fixed window oracle that recomputes the average price for the entire period once every period
780 // note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
781 contract Oracle is Epoch {
782     using FixedPoint for *;
783     using SafeMath for uint256;
784 
785     /* ========== STATE VARIABLES ========== */
786 
787     // uniswap
788     address public token0;
789     address public token1;
790     IUniswapV2Pair public pair;
791 
792     // oracle
793     uint32 public blockTimestampLast;
794     uint256 public price0CumulativeLast;
795     uint256 public price1CumulativeLast;
796     FixedPoint.uq112x112 public price0Average;
797     FixedPoint.uq112x112 public price1Average;
798 
799     /* ========== CONSTRUCTOR ========== */
800 
801     constructor(
802         address _factory,
803         address _tokenA,
804         address _tokenB,
805         uint256 _period,
806         uint256 _startTime
807     ) public Epoch(_period, _startTime, 0) {
808         IUniswapV2Pair _pair = IUniswapV2Pair(
809             UniswapV2Library.pairFor(_factory, _tokenA, _tokenB)
810         );
811         pair = _pair;
812         token0 = _pair.token0();
813         token1 = _pair.token1();
814         price0CumulativeLast = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
815         price1CumulativeLast = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
816         uint112 reserve0;
817         uint112 reserve1;
818         (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();
819         require(reserve0 != 0 && reserve1 != 0, 'Oracle: NO_RESERVES'); // ensure that there's liquidity in the pair
820     }
821 
822     /* ========== MUTABLE FUNCTIONS ========== */
823 
824     /** @dev Updates 1-day EMA price from Uniswap.  */
825     function update() external checkEpoch {
826         (
827             uint256 price0Cumulative,
828             uint256 price1Cumulative,
829             uint32 blockTimestamp
830         ) = UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
831         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
832 
833         if (timeElapsed == 0) {
834             // prevent divided by zero
835             return;
836         }
837 
838         // overflow is desired, casting never truncates
839         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
840         price0Average = FixedPoint.uq112x112(
841             uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)
842         );
843         price1Average = FixedPoint.uq112x112(
844             uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)
845         );
846 
847         price0CumulativeLast = price0Cumulative;
848         price1CumulativeLast = price1Cumulative;
849         blockTimestampLast = blockTimestamp;
850 
851         emit Updated(price0Cumulative, price1Cumulative);
852     }
853 
854     // note this will always return 0 before update has been called successfully for the first time.
855     function consult(address token, uint256 amountIn)
856         external
857         view
858         returns (uint144 amountOut)
859     {
860         if (token == token0) {
861             amountOut = price0Average.mul(amountIn).decode144();
862         } else {
863             require(token == token1, 'Oracle: INVALID_TOKEN');
864             amountOut = price1Average.mul(amountIn).decode144();
865         }
866     }
867 
868     function pairFor(
869         address factory,
870         address tokenA,
871         address tokenB
872     ) external pure returns (address lpt) {
873         return UniswapV2Library.pairFor(factory, tokenA, tokenB);
874     }
875 
876     event Updated(uint256 price0CumulativeLast, uint256 price1CumulativeLast);
877 }