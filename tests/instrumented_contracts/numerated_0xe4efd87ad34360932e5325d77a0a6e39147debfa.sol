1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, 'SafeMath: addition overflow');
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, 'SafeMath: subtraction overflow');
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, 'SafeMath: multiplication overflow');
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, 'SafeMath: division by zero');
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, 'SafeMath: modulo by zero');
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts with custom message when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(
164         uint256 a,
165         uint256 b,
166         string memory errorMessage
167     ) internal pure returns (uint256) {
168         require(b != 0, errorMessage);
169         return a % b;
170     }
171 }
172 
173 // File: contracts/lib/Babylonian.sol
174 
175 pragma solidity ^0.6.0;
176 
177 library Babylonian {
178     function sqrt(uint256 y) internal pure returns (uint256 z) {
179         if (y > 3) {
180             z = y;
181             uint256 x = y / 2 + 1;
182             while (x < z) {
183                 z = x;
184                 x = (y / x + x) / 2;
185             }
186         } else if (y != 0) {
187             z = 1;
188         }
189         // else z = 0
190     }
191 }
192 
193 // File: contracts/lib/FixedPoint.sol
194 
195 pragma solidity ^0.6.0;
196 
197 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
198 library FixedPoint {
199     // range: [0, 2**112 - 1]
200     // resolution: 1 / 2**112
201     struct uq112x112 {
202         uint224 _x;
203     }
204 
205     // range: [0, 2**144 - 1]
206     // resolution: 1 / 2**112
207     struct uq144x112 {
208         uint256 _x;
209     }
210 
211     uint8 private constant RESOLUTION = 112;
212     uint256 private constant Q112 = uint256(1) << RESOLUTION;
213     uint256 private constant Q224 = Q112 << RESOLUTION;
214 
215     // encode a uint112 as a UQ112x112
216     function encode(uint112 x) internal pure returns (uq112x112 memory) {
217         return uq112x112(uint224(x) << RESOLUTION);
218     }
219 
220     // encodes a uint144 as a UQ144x112
221     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
222         return uq144x112(uint256(x) << RESOLUTION);
223     }
224 
225     // divide a UQ112x112 by a uint112, returning a UQ112x112
226     function div(uq112x112 memory self, uint112 x)
227         internal
228         pure
229         returns (uq112x112 memory)
230     {
231         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
232         return uq112x112(self._x / uint224(x));
233     }
234 
235     // multiply a UQ112x112 by a uint, returning a UQ144x112
236     // reverts on overflow
237     function mul(uq112x112 memory self, uint256 y)
238         internal
239         pure
240         returns (uq144x112 memory)
241     {
242         uint256 z;
243         require(
244             y == 0 || (z = uint256(self._x) * y) / y == uint256(self._x),
245             'FixedPoint: MULTIPLICATION_OVERFLOW'
246         );
247         return uq144x112(z);
248     }
249 
250     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
251     // equivalent to encode(numerator).div(denominator)
252     function fraction(uint112 numerator, uint112 denominator)
253         internal
254         pure
255         returns (uq112x112 memory)
256     {
257         require(denominator > 0, 'FixedPoint: DIV_BY_ZERO');
258         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
259     }
260 
261     // decode a UQ112x112 into a uint112 by truncating after the radix point
262     function decode(uq112x112 memory self) internal pure returns (uint112) {
263         return uint112(self._x >> RESOLUTION);
264     }
265 
266     // decode a UQ144x112 into a uint144 by truncating after the radix point
267     function decode144(uq144x112 memory self) internal pure returns (uint144) {
268         return uint144(self._x >> RESOLUTION);
269     }
270 
271     // take the reciprocal of a UQ112x112
272     function reciprocal(uq112x112 memory self)
273         internal
274         pure
275         returns (uq112x112 memory)
276     {
277         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
278         return uq112x112(uint224(Q224 / self._x));
279     }
280 
281     // square root of a UQ112x112
282     function sqrt(uq112x112 memory self)
283         internal
284         pure
285         returns (uq112x112 memory)
286     {
287         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
288     }
289 }
290 
291 // File: contracts/interfaces/IUniswapV2Pair.sol
292 
293 pragma solidity ^0.6.0;
294 
295 interface IUniswapV2Pair {
296     event Approval(
297         address indexed owner,
298         address indexed spender,
299         uint256 value
300     );
301     event Transfer(address indexed from, address indexed to, uint256 value);
302 
303     function name() external pure returns (string memory);
304 
305     function symbol() external pure returns (string memory);
306 
307     function decimals() external pure returns (uint8);
308 
309     function totalSupply() external view returns (uint256);
310 
311     function balanceOf(address owner) external view returns (uint256);
312 
313     function allowance(address owner, address spender)
314         external
315         view
316         returns (uint256);
317 
318     function approve(address spender, uint256 value) external returns (bool);
319 
320     function transfer(address to, uint256 value) external returns (bool);
321 
322     function transferFrom(
323         address from,
324         address to,
325         uint256 value
326     ) external returns (bool);
327 
328     function DOMAIN_SEPARATOR() external view returns (bytes32);
329 
330     function PERMIT_TYPEHASH() external pure returns (bytes32);
331 
332     function nonces(address owner) external view returns (uint256);
333 
334     function permit(
335         address owner,
336         address spender,
337         uint256 value,
338         uint256 deadline,
339         uint8 v,
340         bytes32 r,
341         bytes32 s
342     ) external;
343 
344     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
345     event Burn(
346         address indexed sender,
347         uint256 amount0,
348         uint256 amount1,
349         address indexed to
350     );
351     event Swap(
352         address indexed sender,
353         uint256 amount0In,
354         uint256 amount1In,
355         uint256 amount0Out,
356         uint256 amount1Out,
357         address indexed to
358     );
359     event Sync(uint112 reserve0, uint112 reserve1);
360 
361     function MINIMUM_LIQUIDITY() external pure returns (uint256);
362 
363     function factory() external view returns (address);
364 
365     function token0() external view returns (address);
366 
367     function token1() external view returns (address);
368 
369     function getReserves()
370         external
371         view
372         returns (
373             uint112 reserve0,
374             uint112 reserve1,
375             uint32 blockTimestampLast
376         );
377 
378     function price0CumulativeLast() external view returns (uint256);
379 
380     function price1CumulativeLast() external view returns (uint256);
381 
382     function kLast() external view returns (uint256);
383 
384     function mint(address to) external returns (uint256 liquidity);
385 
386     function burn(address to)
387         external
388         returns (uint256 amount0, uint256 amount1);
389 
390     function swap(
391         uint256 amount0Out,
392         uint256 amount1Out,
393         address to,
394         bytes calldata data
395     ) external;
396 
397     function skim(address to) external;
398 
399     function sync() external;
400 
401     function initialize(address, address) external;
402 }
403 
404 // File: contracts/lib/UniswapV2Library.sol
405 
406 pragma solidity ^0.6.0;
407 
408 library UniswapV2Library {
409     using SafeMath for uint256;
410 
411     // returns sorted token addresses, used to handle return values from pairs sorted in this order
412     function sortTokens(address tokenA, address tokenB)
413         internal
414         pure
415         returns (address token0, address token1)
416     {
417         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
418         (token0, token1) = tokenA < tokenB
419             ? (tokenA, tokenB)
420             : (tokenB, tokenA);
421         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
422     }
423 
424     // calculates the CREATE2 address for a pair without making any external calls
425     function pairFor(
426         address factory,
427         address tokenA,
428         address tokenB
429     ) internal pure returns (address pair) {
430         (address token0, address token1) = sortTokens(tokenA, tokenB);
431         pair = address(
432             uint256(
433                 keccak256(
434                     abi.encodePacked(
435                         hex'ff',
436                         factory,
437                         keccak256(abi.encodePacked(token0, token1)),
438                         hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
439                     )
440                 )
441             )
442         );
443     }
444 
445     // fetches and sorts the reserves for a pair
446     function getReserves(
447         address factory,
448         address tokenA,
449         address tokenB
450     ) internal view returns (uint256 reserveA, uint256 reserveB) {
451         (address token0, ) = sortTokens(tokenA, tokenB);
452         (uint256 reserve0, uint256 reserve1, ) =
453             IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
454         (reserveA, reserveB) = tokenA == token0
455             ? (reserve0, reserve1)
456             : (reserve1, reserve0);
457     }
458 
459     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
460     function quote(
461         uint256 amountA,
462         uint256 reserveA,
463         uint256 reserveB
464     ) internal pure returns (uint256 amountB) {
465         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
466         require(
467             reserveA > 0 && reserveB > 0,
468             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
469         );
470         amountB = amountA.mul(reserveB) / reserveA;
471     }
472 
473     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
474     function getAmountOut(
475         uint256 amountIn,
476         uint256 reserveIn,
477         uint256 reserveOut
478     ) internal pure returns (uint256 amountOut) {
479         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
480         require(
481             reserveIn > 0 && reserveOut > 0,
482             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
483         );
484         uint256 amountInWithFee = amountIn.mul(997);
485         uint256 numerator = amountInWithFee.mul(reserveOut);
486         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
487         amountOut = numerator / denominator;
488     }
489 
490     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
491     function getAmountIn(
492         uint256 amountOut,
493         uint256 reserveIn,
494         uint256 reserveOut
495     ) internal pure returns (uint256 amountIn) {
496         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
497         require(
498             reserveIn > 0 && reserveOut > 0,
499             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
500         );
501         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
502         uint256 denominator = reserveOut.sub(amountOut).mul(997);
503         amountIn = (numerator / denominator).add(1);
504     }
505 
506     // performs chained getAmountOut calculations on any number of pairs
507     function getAmountsOut(
508         address factory,
509         uint256 amountIn,
510         address[] memory path
511     ) internal view returns (uint256[] memory amounts) {
512         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
513         amounts = new uint256[](path.length);
514         amounts[0] = amountIn;
515         for (uint256 i; i < path.length - 1; i++) {
516             (uint256 reserveIn, uint256 reserveOut) =
517                 getReserves(factory, path[i], path[i + 1]);
518             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
519         }
520     }
521 
522     // performs chained getAmountIn calculations on any number of pairs
523     function getAmountsIn(
524         address factory,
525         uint256 amountOut,
526         address[] memory path
527     ) internal view returns (uint256[] memory amounts) {
528         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
529         amounts = new uint256[](path.length);
530         amounts[amounts.length - 1] = amountOut;
531         for (uint256 i = path.length - 1; i > 0; i--) {
532             (uint256 reserveIn, uint256 reserveOut) =
533                 getReserves(factory, path[i - 1], path[i]);
534             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
535         }
536     }
537 }
538 
539 // File: contracts/lib/UniswapV2OracleLibrary.sol
540 
541 pragma solidity ^0.6.0;
542 
543 // library with helper methods for oracles that are concerned with computing average prices
544 library UniswapV2OracleLibrary {
545     using FixedPoint for *;
546 
547     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
548     function currentBlockTimestamp() internal view returns (uint32) {
549         return uint32(block.timestamp % 2**32);
550     }
551 
552     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
553     function currentCumulativePrices(address pair)
554         internal
555         view
556         returns (
557             uint256 price0Cumulative,
558             uint256 price1Cumulative,
559             uint32 blockTimestamp
560         )
561     {
562         blockTimestamp = currentBlockTimestamp();
563         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
564         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
565 
566         // if time has elapsed since the last update on the pair, mock the accumulated price values
567         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) =
568             IUniswapV2Pair(pair).getReserves();
569         if (blockTimestampLast != blockTimestamp) {
570             // subtraction overflow is desired
571             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
572             // addition overflow is desired
573             // counterfactual
574             price0Cumulative +=
575                 uint256(FixedPoint.fraction(reserve1, reserve0)._x) *
576                 timeElapsed;
577             // counterfactual
578             price1Cumulative +=
579                 uint256(FixedPoint.fraction(reserve0, reserve1)._x) *
580                 timeElapsed;
581         }
582     }
583 }
584 
585 // File: @openzeppelin/contracts/math/Math.sol
586 
587 pragma solidity ^0.6.0;
588 
589 /**
590  * @dev Standard math utilities missing in the Solidity language.
591  */
592 library Math {
593     /**
594      * @dev Returns the largest of two numbers.
595      */
596     function max(uint256 a, uint256 b) internal pure returns (uint256) {
597         return a >= b ? a : b;
598     }
599 
600     /**
601      * @dev Returns the smallest of two numbers.
602      */
603     function min(uint256 a, uint256 b) internal pure returns (uint256) {
604         return a < b ? a : b;
605     }
606 
607     /**
608      * @dev Returns the average of two numbers. The result is rounded towards
609      * zero.
610      */
611     function average(uint256 a, uint256 b) internal pure returns (uint256) {
612         // (a + b) / 2 can overflow, so we distribute
613         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
614     }
615 }
616 
617 // File: @openzeppelin/contracts/GSN/Context.sol
618 
619 pragma solidity ^0.6.0;
620 
621 /*
622  * @dev Provides information about the current execution context, including the
623  * sender of the transaction and its data. While these are generally available
624  * via msg.sender and msg.data, they should not be accessed in such a direct
625  * manner, since when dealing with GSN meta-transactions the account sending and
626  * paying for execution may not be the actual sender (as far as an application
627  * is concerned).
628  *
629  * This contract is only required for intermediate, library-like contracts.
630  */
631 abstract contract Context {
632     function _msgSender() internal view virtual returns (address payable) {
633         return msg.sender;
634     }
635 
636     function _msgData() internal view virtual returns (bytes memory) {
637         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
638         return msg.data;
639     }
640 }
641 
642 // File: @openzeppelin/contracts/access/Ownable.sol
643 
644 pragma solidity ^0.6.0;
645 
646 /**
647  * @dev Contract module which provides a basic access control mechanism, where
648  * there is an account (an owner) that can be granted exclusive access to
649  * specific functions.
650  *
651  * By default, the owner account will be the one that deploys the contract. This
652  * can later be changed with {transferOwnership}.
653  *
654  * This module is used through inheritance. It will make available the modifier
655  * `onlyOwner`, which can be applied to your functions to restrict their use to
656  * the owner.
657  */
658 contract Ownable is Context {
659     address private _owner;
660 
661     event OwnershipTransferred(
662         address indexed previousOwner,
663         address indexed newOwner
664     );
665 
666     /**
667      * @dev Initializes the contract setting the deployer as the initial owner.
668      */
669     constructor() internal {
670         address msgSender = _msgSender();
671         _owner = msgSender;
672         emit OwnershipTransferred(address(0), msgSender);
673     }
674 
675     /**
676      * @dev Returns the address of the current owner.
677      */
678     function owner() public view returns (address) {
679         return _owner;
680     }
681 
682     /**
683      * @dev Throws if called by any account other than the owner.
684      */
685     modifier onlyOwner() {
686         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
687         _;
688     }
689 
690     /**
691      * @dev Leaves the contract without owner. It will not be possible to call
692      * `onlyOwner` functions anymore. Can only be called by the current owner.
693      *
694      * NOTE: Renouncing ownership will leave the contract without an owner,
695      * thereby removing any functionality that is only available to the owner.
696      */
697     function renounceOwnership() public virtual onlyOwner {
698         emit OwnershipTransferred(_owner, address(0));
699         _owner = address(0);
700     }
701 
702     /**
703      * @dev Transfers ownership of the contract to a new account (`newOwner`).
704      * Can only be called by the current owner.
705      */
706     function transferOwnership(address newOwner) public virtual onlyOwner {
707         require(
708             newOwner != address(0),
709             'Ownable: new owner is the zero address'
710         );
711         emit OwnershipTransferred(_owner, newOwner);
712         _owner = newOwner;
713     }
714 }
715 
716 // File: contracts/owner/Operator.sol
717 
718 pragma solidity ^0.6.0;
719 
720 contract Operator is Context, Ownable {
721     address private _operator;
722 
723     event OperatorTransferred(
724         address indexed previousOperator,
725         address indexed newOperator
726     );
727 
728     constructor() internal {
729         _operator = _msgSender();
730         emit OperatorTransferred(address(0), _operator);
731     }
732 
733     function operator() public view returns (address) {
734         return _operator;
735     }
736 
737     modifier onlyOperator() {
738         require(
739             _operator == msg.sender,
740             'operator: caller is not the operator'
741         );
742         _;
743     }
744 
745     function isOperator() public view returns (bool) {
746         return _msgSender() == _operator;
747     }
748 
749     function transferOperator(address newOperator_) public onlyOwner {
750         _transferOperator(newOperator_);
751     }
752 
753     function _transferOperator(address newOperator_) internal {
754         require(
755             newOperator_ != address(0),
756             'operator: zero address given for new operator'
757         );
758         emit OperatorTransferred(address(0), newOperator_);
759         _operator = newOperator_;
760     }
761 }
762 
763 // File: contracts/utils/Epoch.sol
764 
765 pragma solidity ^0.6.0;
766 
767 contract Epoch is Operator {
768     using SafeMath for uint256;
769 
770     uint256 private period;
771     uint256 private startTime;
772     uint256 private lastExecutedAt;
773 
774     /* ========== CONSTRUCTOR ========== */
775 
776     constructor(
777         uint256 _period,
778         uint256 _startTime,
779         uint256 _startEpoch
780     ) public {
781         require(_startTime > block.timestamp, 'Epoch: invalid start time');
782         period = _period;
783         startTime = _startTime;
784         lastExecutedAt = startTime.add(_startEpoch.mul(period));
785     }
786 
787     /* ========== Modifier ========== */
788 
789     modifier checkStartTime {
790         require(now >= startTime, 'Epoch: not started yet');
791 
792         _;
793     }
794 
795     modifier checkEpoch {
796         require(now > startTime, 'Epoch: not started yet');
797         require(callable(), 'Epoch: not allowed');
798 
799         _;
800 
801         lastExecutedAt = block.timestamp;
802     }
803 
804     /* ========== VIEW FUNCTIONS ========== */
805 
806     function callable() public view returns (bool) {
807         return getCurrentEpoch() >= getNextEpoch();
808     }
809 
810     // epoch
811     function getLastEpoch() public view returns (uint256) {
812         return lastExecutedAt.sub(startTime).div(period);
813     }
814 
815     function getCurrentEpoch() public view returns (uint256) {
816         return Math.max(startTime, block.timestamp).sub(startTime).div(period);
817     }
818 
819     function getNextEpoch() public view returns (uint256) {
820         if (startTime == lastExecutedAt) {
821             return getLastEpoch();
822         }
823         return getLastEpoch().add(1);
824     }
825 
826     function nextEpochPoint() public view returns (uint256) {
827         return startTime.add(getNextEpoch().mul(period));
828     }
829 
830     // params
831     function getPeriod() public view returns (uint256) {
832         return period;
833     }
834 
835     function getStartTime() public view returns (uint256) {
836         return startTime;
837     }
838 
839     /* ========== GOVERNANCE ========== */
840 
841     function setPeriod(uint256 _period) external onlyOperator {
842         period = _period;
843     }
844 }
845 
846 // File: contracts/interfaces/IUniswapV2Factory.sol
847 
848 pragma solidity ^0.6.0;
849 
850 interface IUniswapV2Factory {
851     event PairCreated(
852         address indexed token0,
853         address indexed token1,
854         address pair,
855         uint256
856     );
857 
858     function getPair(address tokenA, address tokenB)
859         external
860         view
861         returns (address pair);
862 
863     function allPairs(uint256) external view returns (address pair);
864 
865     function allPairsLength() external view returns (uint256);
866 
867     function feeTo() external view returns (address);
868 
869     function feeToSetter() external view returns (address);
870 
871     function createPair(address tokenA, address tokenB)
872         external
873         returns (address pair);
874 }
875 
876 // File: contracts/Oracle.sol
877 
878 pragma solidity ^0.6.0;
879 
880 // fixed window oracle that recomputes the average price for the entire period once every period
881 // note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
882 contract Oracle is Epoch {
883     using FixedPoint for *;
884     using SafeMath for uint256;
885 
886     /* ========== STATE VARIABLES ========== */
887 
888     // uniswap
889     address public token0;
890     address public token1;
891     IUniswapV2Pair public pair;
892 
893     // oracle
894     uint32 public blockTimestampLast;
895     uint256 public price0CumulativeLast;
896     uint256 public price1CumulativeLast;
897     FixedPoint.uq112x112 public price0Average;
898     FixedPoint.uq112x112 public price1Average;
899 
900     /* ========== CONSTRUCTOR ========== */
901 
902     constructor(
903         address _factory,
904         address _tokenA,
905         address _tokenB,
906         uint256 _period,
907         uint256 _startTime
908     ) public Epoch(_period, _startTime, 0) {
909         IUniswapV2Pair _pair =
910             IUniswapV2Pair(
911                 UniswapV2Library.pairFor(_factory, _tokenA, _tokenB)
912             );
913         pair = _pair;
914         token0 = _pair.token0();
915         token1 = _pair.token1();
916         price0CumulativeLast = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
917         price1CumulativeLast = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
918         uint112 reserve0;
919         uint112 reserve1;
920         (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();
921         require(reserve0 != 0 && reserve1 != 0, 'Oracle: NO_RESERVES'); // ensure that there's liquidity in the pair
922     }
923 
924     /* ========== MUTABLE FUNCTIONS ========== */
925 
926     /** @dev Updates 1-day EMA price from Uniswap.  */
927     function update() external checkEpoch {
928         (
929             uint256 price0Cumulative,
930             uint256 price1Cumulative,
931             uint32 blockTimestamp
932         ) = UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
933         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
934 
935         if (timeElapsed == 0) {
936             // prevent divided by zero
937             return;
938         }
939 
940         // overflow is desired, casting never truncates
941         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
942         price0Average = FixedPoint.uq112x112(
943             uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)
944         );
945         price1Average = FixedPoint.uq112x112(
946             uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)
947         );
948 
949         price0CumulativeLast = price0Cumulative;
950         price1CumulativeLast = price1Cumulative;
951         blockTimestampLast = blockTimestamp;
952 
953         emit Updated(price0Cumulative, price1Cumulative);
954     }
955 
956     // note this will always return 0 before update has been called successfully for the first time.
957     function consult(address token, uint256 amountIn)
958         external
959         view
960         returns (uint144 amountOut)
961     {
962         if (token == token0) {
963             amountOut = price0Average.mul(amountIn).decode144();
964         } else {
965             require(token == token1, 'Oracle: INVALID_TOKEN');
966             amountOut = price1Average.mul(amountIn).decode144();
967         }
968     }
969 
970     // collaboration of update / consult
971     function expectedPrice(address token, uint256 amountIn)
972         external
973         view
974         returns (uint224 amountOut)
975     {
976         (
977             uint256 price0Cumulative,
978             uint256 price1Cumulative,
979             uint32 blockTimestamp
980         ) = UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
981         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
982 
983         FixedPoint.uq112x112 memory avg0 =
984             FixedPoint.uq112x112(
985                 uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)
986             );
987         FixedPoint.uq112x112 memory avg1 =
988             FixedPoint.uq112x112(
989                 uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)
990             );
991 
992         if (token == token0) {
993             amountOut = avg0.mul(amountIn).decode144();
994         } else {
995             require(token == token1, 'Oracle: INVALID_TOKEN');
996             amountOut = avg1.mul(amountIn).decode144();
997         }
998         return amountOut;
999     }
1000 
1001     function pairFor(
1002         address factory,
1003         address tokenA,
1004         address tokenB
1005     ) external pure returns (address lpt) {
1006         return UniswapV2Library.pairFor(factory, tokenA, tokenB);
1007     }
1008 
1009     event Updated(uint256 price0CumulativeLast, uint256 price1CumulativeLast);
1010 }