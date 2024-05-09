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
452         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
453             pairFor(factory, tokenA, tokenB)
454         )
455             .getReserves();
456         (reserveA, reserveB) = tokenA == token0
457             ? (reserve0, reserve1)
458             : (reserve1, reserve0);
459     }
460 
461     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
462     function quote(
463         uint256 amountA,
464         uint256 reserveA,
465         uint256 reserveB
466     ) internal pure returns (uint256 amountB) {
467         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
468         require(
469             reserveA > 0 && reserveB > 0,
470             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
471         );
472         amountB = amountA.mul(reserveB) / reserveA;
473     }
474 
475     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
476     function getAmountOut(
477         uint256 amountIn,
478         uint256 reserveIn,
479         uint256 reserveOut
480     ) internal pure returns (uint256 amountOut) {
481         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
482         require(
483             reserveIn > 0 && reserveOut > 0,
484             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
485         );
486         uint256 amountInWithFee = amountIn.mul(997);
487         uint256 numerator = amountInWithFee.mul(reserveOut);
488         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
489         amountOut = numerator / denominator;
490     }
491 
492     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
493     function getAmountIn(
494         uint256 amountOut,
495         uint256 reserveIn,
496         uint256 reserveOut
497     ) internal pure returns (uint256 amountIn) {
498         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
499         require(
500             reserveIn > 0 && reserveOut > 0,
501             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
502         );
503         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
504         uint256 denominator = reserveOut.sub(amountOut).mul(997);
505         amountIn = (numerator / denominator).add(1);
506     }
507 
508     // performs chained getAmountOut calculations on any number of pairs
509     function getAmountsOut(
510         address factory,
511         uint256 amountIn,
512         address[] memory path
513     ) internal view returns (uint256[] memory amounts) {
514         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
515         amounts = new uint256[](path.length);
516         amounts[0] = amountIn;
517         for (uint256 i; i < path.length - 1; i++) {
518             (uint256 reserveIn, uint256 reserveOut) = getReserves(
519                 factory,
520                 path[i],
521                 path[i + 1]
522             );
523             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
524         }
525     }
526 
527     // performs chained getAmountIn calculations on any number of pairs
528     function getAmountsIn(
529         address factory,
530         uint256 amountOut,
531         address[] memory path
532     ) internal view returns (uint256[] memory amounts) {
533         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
534         amounts = new uint256[](path.length);
535         amounts[amounts.length - 1] = amountOut;
536         for (uint256 i = path.length - 1; i > 0; i--) {
537             (uint256 reserveIn, uint256 reserveOut) = getReserves(
538                 factory,
539                 path[i - 1],
540                 path[i]
541             );
542             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
543         }
544     }
545 }
546 
547 // File: contracts/lib/UniswapV2OracleLibrary.sol
548 
549 pragma solidity ^0.6.0;
550 
551 // library with helper methods for oracles that are concerned with computing average prices
552 library UniswapV2OracleLibrary {
553     using FixedPoint for *;
554 
555     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
556     function currentBlockTimestamp() internal view returns (uint32) {
557         return uint32(block.timestamp % 2**32);
558     }
559 
560     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
561     function currentCumulativePrices(address pair)
562         internal
563         view
564         returns (
565             uint256 price0Cumulative,
566             uint256 price1Cumulative,
567             uint32 blockTimestamp
568         )
569     {
570         blockTimestamp = currentBlockTimestamp();
571         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
572         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
573 
574         // if time has elapsed since the last update on the pair, mock the accumulated price values
575         (
576             uint112 reserve0,
577             uint112 reserve1,
578             uint32 blockTimestampLast
579         ) = IUniswapV2Pair(pair).getReserves();
580         if (blockTimestampLast != blockTimestamp) {
581             // subtraction overflow is desired
582             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
583             // addition overflow is desired
584             // counterfactual
585             price0Cumulative +=
586                 uint256(FixedPoint.fraction(reserve1, reserve0)._x) *
587                 timeElapsed;
588             // counterfactual
589             price1Cumulative +=
590                 uint256(FixedPoint.fraction(reserve0, reserve1)._x) *
591                 timeElapsed;
592         }
593     }
594 }
595 
596 // File: @openzeppelin/contracts/GSN/Context.sol
597 
598 pragma solidity ^0.6.0;
599 
600 /*
601  * @dev Provides information about the current execution context, including the
602  * sender of the transaction and its data. While these are generally available
603  * via msg.sender and msg.data, they should not be accessed in such a direct
604  * manner, since when dealing with GSN meta-transactions the account sending and
605  * paying for execution may not be the actual sender (as far as an application
606  * is concerned).
607  *
608  * This contract is only required for intermediate, library-like contracts.
609  */
610 abstract contract Context {
611     function _msgSender() internal virtual view returns (address payable) {
612         return msg.sender;
613     }
614 
615     function _msgData() internal virtual view returns (bytes memory) {
616         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
617         return msg.data;
618     }
619 }
620 
621 // File: @openzeppelin/contracts/access/Ownable.sol
622 
623 pragma solidity ^0.6.0;
624 
625 /**
626  * @dev Contract module which provides a basic access control mechanism, where
627  * there is an account (an owner) that can be granted exclusive access to
628  * specific functions.
629  *
630  * By default, the owner account will be the one that deploys the contract. This
631  * can later be changed with {transferOwnership}.
632  *
633  * This module is used through inheritance. It will make available the modifier
634  * `onlyOwner`, which can be applied to your functions to restrict their use to
635  * the owner.
636  */
637 contract Ownable is Context {
638     address private _owner;
639 
640     event OwnershipTransferred(
641         address indexed previousOwner,
642         address indexed newOwner
643     );
644 
645     /**
646      * @dev Initializes the contract setting the deployer as the initial owner.
647      */
648     constructor() internal {
649         address msgSender = _msgSender();
650         _owner = msgSender;
651         emit OwnershipTransferred(address(0), msgSender);
652     }
653 
654     /**
655      * @dev Returns the address of the current owner.
656      */
657     function owner() public view returns (address) {
658         return _owner;
659     }
660 
661     /**
662      * @dev Throws if called by any account other than the owner.
663      */
664     modifier onlyOwner() {
665         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
666         _;
667     }
668 
669     /**
670      * @dev Leaves the contract without owner. It will not be possible to call
671      * `onlyOwner` functions anymore. Can only be called by the current owner.
672      *
673      * NOTE: Renouncing ownership will leave the contract without an owner,
674      * thereby removing any functionality that is only available to the owner.
675      */
676     function renounceOwnership() public virtual onlyOwner {
677         emit OwnershipTransferred(_owner, address(0));
678         _owner = address(0);
679     }
680 
681     /**
682      * @dev Transfers ownership of the contract to a new account (`newOwner`).
683      * Can only be called by the current owner.
684      */
685     function transferOwnership(address newOwner) public virtual onlyOwner {
686         require(
687             newOwner != address(0),
688             'Ownable: new owner is the zero address'
689         );
690         emit OwnershipTransferred(_owner, newOwner);
691         _owner = newOwner;
692     }
693 }
694 
695 // File: contracts/owner/Operator.sol
696 
697 pragma solidity ^0.6.0;
698 
699 contract Operator is Context, Ownable {
700     address private _operator;
701 
702     event OperatorTransferred(
703         address indexed previousOperator,
704         address indexed newOperator
705     );
706 
707     constructor() internal {
708         _operator = _msgSender();
709         emit OperatorTransferred(address(0), _operator);
710     }
711 
712     function operator() public view returns (address) {
713         return _operator;
714     }
715 
716     modifier onlyOperator() {
717         require(
718             _operator == msg.sender,
719             'operator: caller is not the operator'
720         );
721         _;
722     }
723 
724     function isOperator() public view returns (bool) {
725         return _msgSender() == _operator;
726     }
727 
728     function transferOperator(address newOperator_) public onlyOwner {
729         _transferOperator(newOperator_);
730     }
731 
732     function _transferOperator(address newOperator_) internal {
733         require(
734             newOperator_ != address(0),
735             'operator: zero address given for new operator'
736         );
737         emit OperatorTransferred(address(0), newOperator_);
738         _operator = newOperator_;
739     }
740 }
741 
742 // File: contracts/utils/Epoch.sol
743 
744 pragma solidity ^0.6.0;
745 
746 contract Epoch is Operator {
747     using SafeMath for uint256;
748 
749     uint256 private period;
750     uint256 private startTime;
751     uint256 private epoch;
752 
753     /* ========== CONSTRUCTOR ========== */
754 
755     constructor(
756         uint256 _period,
757         uint256 _startTime,
758         uint256 _startEpoch
759     ) public {
760         period = _period;
761         startTime = _startTime;
762         epoch = _startEpoch;
763     }
764 
765     /* ========== Modifier ========== */
766 
767     modifier checkStartTime {
768         require(now >= startTime, 'Epoch: not started yet');
769 
770         _;
771     }
772 
773     modifier checkEpoch {
774         require(now >= nextEpochPoint(), 'Epoch: not allowed');
775 
776         _;
777 
778         epoch = epoch.add(1);
779     }
780 
781     /* ========== VIEW FUNCTIONS ========== */
782 
783     function getCurrentEpoch() public view returns (uint256) {
784         return epoch;
785     }
786 
787     function getPeriod() public view returns (uint256) {
788         return period;
789     }
790 
791     function getStartTime() public view returns (uint256) {
792         return startTime;
793     }
794 
795     function nextEpochPoint() public view returns (uint256) {
796         return startTime.add(epoch.mul(period));
797     }
798 
799     /* ========== GOVERNANCE ========== */
800 
801     function setPeriod(uint256 _period) external onlyOperator {
802         period = _period;
803     }
804 }
805 
806 // File: contracts/interfaces/IUniswapV2Factory.sol
807 
808 pragma solidity ^0.6.0;
809 
810 interface IUniswapV2Factory {
811     event PairCreated(
812         address indexed token0,
813         address indexed token1,
814         address pair,
815         uint256
816     );
817 
818     function getPair(address tokenA, address tokenB)
819         external
820         view
821         returns (address pair);
822 
823     function allPairs(uint256) external view returns (address pair);
824 
825     function allPairsLength() external view returns (uint256);
826 
827     function feeTo() external view returns (address);
828 
829     function feeToSetter() external view returns (address);
830 
831     function createPair(address tokenA, address tokenB)
832         external
833         returns (address pair);
834 }
835 
836 // File: contracts/Oracle.sol
837 
838 pragma solidity ^0.6.0;
839 
840 // fixed window oracle that recomputes the average price for the entire period once every period
841 // note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
842 contract Oracle is Epoch {
843     using FixedPoint for *;
844     using SafeMath for uint256;
845 
846     /* ========== STATE VARIABLES ========== */
847 
848     // uniswap
849     address public token0;
850     address public token1;
851     IUniswapV2Pair public pair;
852 
853     // oracle
854     uint32 public blockTimestampLast;
855     uint256 public price0CumulativeLast;
856     uint256 public price1CumulativeLast;
857     FixedPoint.uq112x112 public price0Average;
858     FixedPoint.uq112x112 public price1Average;
859 
860     /* ========== CONSTRUCTOR ========== */
861 
862     constructor(
863         address _factory,
864         address _tokenA,
865         address _tokenB,
866         uint256 _period,
867         uint256 _startTime
868     ) public Epoch(_period, _startTime, 0) {
869         IUniswapV2Pair _pair = IUniswapV2Pair(
870             UniswapV2Library.pairFor(_factory, _tokenA, _tokenB)
871         );
872         pair = _pair;
873         token0 = _pair.token0();
874         token1 = _pair.token1();
875         price0CumulativeLast = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
876         price1CumulativeLast = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
877         uint112 reserve0;
878         uint112 reserve1;
879         (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();
880         require(reserve0 != 0 && reserve1 != 0, 'Oracle: NO_RESERVES'); // ensure that there's liquidity in the pair
881     }
882 
883     /* ========== MUTABLE FUNCTIONS ========== */
884 
885     /** @dev Updates 1-day EMA price from Uniswap.  */
886     function update() external checkEpoch {
887         (
888             uint256 price0Cumulative,
889             uint256 price1Cumulative,
890             uint32 blockTimestamp
891         ) = UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
892         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
893 
894         if (timeElapsed == 0) {
895             // prevent divided by zero
896             return;
897         }
898 
899         // overflow is desired, casting never truncates
900         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
901         price0Average = FixedPoint.uq112x112(
902             uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)
903         );
904         price1Average = FixedPoint.uq112x112(
905             uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)
906         );
907 
908         price0CumulativeLast = price0Cumulative;
909         price1CumulativeLast = price1Cumulative;
910         blockTimestampLast = blockTimestamp;
911 
912         emit Updated(price0Cumulative, price1Cumulative);
913     }
914 
915     // note this will always return 0 before update has been called successfully for the first time.
916     function consult(address token, uint256 amountIn)
917         external
918         view
919         returns (uint144 amountOut)
920     {
921         if (token == token0) {
922             amountOut = price0Average.mul(amountIn).decode144();
923         } else {
924             require(token == token1, 'Oracle: INVALID_TOKEN');
925             amountOut = price1Average.mul(amountIn).decode144();
926         }
927     }
928 
929     function pairFor(
930         address factory,
931         address tokenA,
932         address tokenB
933     ) external pure returns (address lpt) {
934         return UniswapV2Library.pairFor(factory, tokenA, tokenB);
935     }
936 
937     event Updated(uint256 price0CumulativeLast, uint256 price1CumulativeLast);
938 }