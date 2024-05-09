1 /*
2 
3     Copyright 2020 dYdX Trading Inc.
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.16;
20 pragma experimental ABIEncoderV2;
21 
22 // File: @openzeppelin/contracts/math/SafeMath.sol
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations with added overflow
26  * checks.
27  *
28  * Arithmetic operations in Solidity wrap on overflow. This can easily result
29  * in bugs, because programmers usually assume that an overflow raises an
30  * error, which is the standard behavior in high level programming languages.
31  * `SafeMath` restores this intuition by reverting the transaction when an
32  * operation overflows.
33  *
34  * Using this library instead of the unchecked operations eliminates an entire
35  * class of bugs, so it's recommended to use it always.
36  */
37 library SafeMath {
38     /**
39      * @dev Returns the addition of two unsigned integers, reverting on
40      * overflow.
41      *
42      * Counterpart to Solidity's `+` operator.
43      *
44      * Requirements:
45      * - Addition cannot overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      *
76      * _Available since v2.4.0._
77      */
78     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b <= a, errorMessage);
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the multiplication of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `*` operator.
90      *
91      * Requirements:
92      * - Multiplication cannot overflow.
93      */
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96         // benefit is lost if 'b' is also tested.
97         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
98         if (a == 0) {
99             return 0;
100         }
101 
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      *
134      * _Available since v2.4.0._
135      */
136     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         // Solidity only automatically asserts when dividing by 0
138         require(b > 0, errorMessage);
139         uint256 c = a / b;
140         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return mod(a, b, "SafeMath: modulo by zero");
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
162      * Reverts with custom message when dividing by zero.
163      *
164      * Counterpart to Solidity's `%` operator. This function uses a `revert`
165      * opcode (which leaves remaining gas untouched) while Solidity uses an
166      * invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      *
171      * _Available since v2.4.0._
172      */
173     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b != 0, errorMessage);
175         return a % b;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/GSN/Context.sol
180 
181 /*
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with GSN meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 contract Context {
192     // Empty internal constructor, to prevent people from mistakenly deploying
193     // an instance of this contract, which should be used via inheritance.
194     constructor () internal { }
195     // solhint-disable-previous-line no-empty-blocks
196 
197     function _msgSender() internal view returns (address payable) {
198         return msg.sender;
199     }
200 
201     function _msgData() internal view returns (bytes memory) {
202         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
203         return msg.data;
204     }
205 }
206 
207 // File: @openzeppelin/contracts/ownership/Ownable.sol
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * This module is used through inheritance. It will make available the modifier
215  * `onlyOwner`, which can be applied to your functions to restrict their use to
216  * the owner.
217  */
218 contract Ownable is Context {
219     address private _owner;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     /**
224      * @dev Initializes the contract setting the deployer as the initial owner.
225      */
226     constructor () internal {
227         address msgSender = _msgSender();
228         _owner = msgSender;
229         emit OwnershipTransferred(address(0), msgSender);
230     }
231 
232     /**
233      * @dev Returns the address of the current owner.
234      */
235     function owner() public view returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(isOwner(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     /**
248      * @dev Returns true if the caller is the current owner.
249      */
250     function isOwner() public view returns (bool) {
251         return _msgSender() == _owner;
252     }
253 
254     /**
255      * @dev Leaves the contract without owner. It will not be possible to call
256      * `onlyOwner` functions anymore. Can only be called by the current owner.
257      *
258      * NOTE: Renouncing ownership will leave the contract without an owner,
259      * thereby removing any functionality that is only available to the owner.
260      */
261     function renounceOwnership() public onlyOwner {
262         emit OwnershipTransferred(_owner, address(0));
263         _owner = address(0);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Can only be called by the current owner.
269      */
270     function transferOwnership(address newOwner) public onlyOwner {
271         _transferOwnership(newOwner);
272     }
273 
274     /**
275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
276      */
277     function _transferOwnership(address newOwner) internal {
278         require(newOwner != address(0), "Ownable: new owner is the zero address");
279         emit OwnershipTransferred(_owner, newOwner);
280         _owner = newOwner;
281     }
282 }
283 
284 // File: contracts/protocol/lib/BaseMath.sol
285 
286 /**
287  * @title BaseMath
288  * @author dYdX
289  *
290  * @dev Arithmetic for fixed-point numbers with 18 decimals of precision.
291  */
292 library BaseMath {
293     using SafeMath for uint256;
294 
295     // The number One in the BaseMath system.
296     uint256 constant internal BASE = 10 ** 18;
297 
298     /**
299      * @dev Getter function since constants can't be read directly from libraries.
300      */
301     function base()
302         internal
303         pure
304         returns (uint256)
305     {
306         return BASE;
307     }
308 
309     /**
310      * @dev Multiplies a value by a base value (result is rounded down).
311      */
312     function baseMul(
313         uint256 value,
314         uint256 baseValue
315     )
316         internal
317         pure
318         returns (uint256)
319     {
320         return value.mul(baseValue).div(BASE);
321     }
322 
323     /**
324      * @dev Multiplies a value by a base value (result is rounded down).
325      *  Intended as an alternaltive to baseMul to prevent overflow, when `value` is known
326      *  to be divisible by `BASE`.
327      */
328     function baseDivMul(
329         uint256 value,
330         uint256 baseValue
331     )
332         internal
333         pure
334         returns (uint256)
335     {
336         return value.div(BASE).mul(baseValue);
337     }
338 
339     /**
340      * @dev Multiplies a value by a base value (result is rounded up).
341      */
342     function baseMulRoundUp(
343         uint256 value,
344         uint256 baseValue
345     )
346         internal
347         pure
348         returns (uint256)
349     {
350         if (value == 0 || baseValue == 0) {
351             return 0;
352         }
353         return value.mul(baseValue).sub(1).div(BASE).add(1);
354     }
355 }
356 
357 // File: contracts/protocol/lib/Math.sol
358 
359 /**
360  * @title Math
361  * @author dYdX
362  *
363  * @dev Library for non-standard Math functions.
364  */
365 library Math {
366     using SafeMath for uint256;
367 
368     // ============ Library Functions ============
369 
370     /**
371      * @dev Return target * (numerator / denominator), rounded down.
372      */
373     function getFraction(
374         uint256 target,
375         uint256 numerator,
376         uint256 denominator
377     )
378         internal
379         pure
380         returns (uint256)
381     {
382         return target.mul(numerator).div(denominator);
383     }
384 
385     /**
386      * @dev Return target * (numerator / denominator), rounded up.
387      */
388     function getFractionRoundUp(
389         uint256 target,
390         uint256 numerator,
391         uint256 denominator
392     )
393         internal
394         pure
395         returns (uint256)
396     {
397         if (target == 0 || numerator == 0) {
398             // SafeMath will check for zero denominator
399             return SafeMath.div(0, denominator);
400         }
401         return target.mul(numerator).sub(1).div(denominator).add(1);
402     }
403 
404     /**
405      * @dev Returns the minimum between a and b.
406      */
407     function min(
408         uint256 a,
409         uint256 b
410     )
411         internal
412         pure
413         returns (uint256)
414     {
415         return a < b ? a : b;
416     }
417 
418     /**
419      * @dev Returns the maximum between a and b.
420      */
421     function max(
422         uint256 a,
423         uint256 b
424     )
425         internal
426         pure
427         returns (uint256)
428     {
429         return a > b ? a : b;
430     }
431 }
432 
433 // File: contracts/protocol/lib/SafeCast.sol
434 
435 /**
436  * @title SafeCast
437  * @author dYdX
438  *
439  * @dev Library for casting uint256 to other types of uint.
440  */
441 library SafeCast {
442 
443     /**
444      * @dev Returns the downcasted uint128 from uint256, reverting on
445      *  overflow (i.e. when the input is greater than largest uint128).
446      *
447      *  Counterpart to Solidity's `uint128` operator.
448      *
449      *  Requirements:
450      *  - `value` must fit into 128 bits.
451      */
452     function toUint128(
453         uint256 value
454     )
455         internal
456         pure
457         returns (uint128)
458     {
459         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
460         return uint128(value);
461     }
462 
463     /**
464      * @dev Returns the downcasted uint120 from uint256, reverting on
465      *  overflow (i.e. when the input is greater than largest uint120).
466      *
467      *  Counterpart to Solidity's `uint120` operator.
468      *
469      *  Requirements:
470      *  - `value` must fit into 120 bits.
471      */
472     function toUint120(
473         uint256 value
474     )
475         internal
476         pure
477         returns (uint120)
478     {
479         require(value < 2**120, "SafeCast: value doesn\'t fit in 120 bits");
480         return uint120(value);
481     }
482 
483     /**
484      * @dev Returns the downcasted uint32 from uint256, reverting on
485      *  overflow (i.e. when the input is greater than largest uint32).
486      *
487      *  Counterpart to Solidity's `uint32` operator.
488      *
489      *  Requirements:
490      *  - `value` must fit into 32 bits.
491      */
492     function toUint32(
493         uint256 value
494     )
495         internal
496         pure
497         returns (uint32)
498     {
499         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
500         return uint32(value);
501     }
502 }
503 
504 // File: contracts/protocol/lib/SignedMath.sol
505 
506 /**
507  * @title SignedMath
508  * @author dYdX
509  *
510  * @dev SignedMath library for doing math with signed integers.
511  */
512 library SignedMath {
513     using SafeMath for uint256;
514 
515     // ============ Structs ============
516 
517     struct Int {
518         uint256 value;
519         bool isPositive;
520     }
521 
522     // ============ Functions ============
523 
524     /**
525      * @dev Returns a new signed integer equal to a signed integer plus an unsigned integer.
526      */
527     function add(
528         Int memory sint,
529         uint256 value
530     )
531         internal
532         pure
533         returns (Int memory)
534     {
535         if (sint.isPositive) {
536             return Int({
537                 value: value.add(sint.value),
538                 isPositive: true
539             });
540         }
541         if (sint.value < value) {
542             return Int({
543                 value: value.sub(sint.value),
544                 isPositive: true
545             });
546         }
547         return Int({
548             value: sint.value.sub(value),
549             isPositive: false
550         });
551     }
552 
553     /**
554      * @dev Returns a new signed integer equal to a signed integer minus an unsigned integer.
555      */
556     function sub(
557         Int memory sint,
558         uint256 value
559     )
560         internal
561         pure
562         returns (Int memory)
563     {
564         if (!sint.isPositive) {
565             return Int({
566                 value: value.add(sint.value),
567                 isPositive: false
568             });
569         }
570         if (sint.value > value) {
571             return Int({
572                 value: sint.value.sub(value),
573                 isPositive: true
574             });
575         }
576         return Int({
577             value: value.sub(sint.value),
578             isPositive: false
579         });
580     }
581 
582     /**
583      * @dev Returns true if signed integer `a` is greater than signed integer `b`, false otherwise.
584      */
585     function gt(
586         Int memory a,
587         Int memory b
588     )
589         internal
590         pure
591         returns (bool)
592     {
593         if (a.isPositive) {
594             if (b.isPositive) {
595                 return a.value > b.value;
596             } else {
597                 // True, unless both values are zero.
598                 return a.value != 0 || b.value != 0;
599             }
600         } else {
601             if (b.isPositive) {
602                 return false;
603             } else {
604                 return a.value < b.value;
605             }
606         }
607     }
608 
609     /**
610      * @dev Returns the minimum of signed integers `a` and `b`.
611      */
612     function min(
613         Int memory a,
614         Int memory b
615     )
616         internal
617         pure
618         returns (Int memory)
619     {
620         return gt(b, a) ? a : b;
621     }
622 
623     /**
624      * @dev Returns the maximum of signed integers `a` and `b`.
625      */
626     function max(
627         Int memory a,
628         Int memory b
629     )
630         internal
631         pure
632         returns (Int memory)
633     {
634         return gt(a, b) ? a : b;
635     }
636 }
637 
638 // File: contracts/protocol/v1/intf/I_P1Funder.sol
639 
640 /**
641  * @title I_P1Funder
642  * @author dYdX
643  *
644  * @notice Interface for an oracle providing the funding rate for a perpetual market.
645  */
646 interface I_P1Funder {
647 
648     /**
649      * @notice Calculates the signed funding amount that has accumulated over a period of time.
650      *
651      * @param  timeDelta  Number of seconds over which to calculate the accumulated funding amount.
652      * @return            True if the funding rate is positive, and false otherwise.
653      * @return            The funding amount as a unitless rate, represented as a fixed-point number
654      *                    with 18 decimals.
655      */
656     function getFunding(
657         uint256 timeDelta
658     )
659         external
660         view
661         returns (bool, uint256);
662 }
663 
664 // File: contracts/protocol/v1/lib/P1Types.sol
665 
666 /**
667  * @title P1Types
668  * @author dYdX
669  *
670  * @dev Library for common types used in PerpetualV1 contracts.
671  */
672 library P1Types {
673     // ============ Structs ============
674 
675     /**
676      * @dev Used to represent the global index and each account's cached index.
677      *  Used to settle funding paymennts on a per-account basis.
678      */
679     struct Index {
680         uint32 timestamp;
681         bool isPositive;
682         uint128 value;
683     }
684 
685     /**
686      * @dev Used to track the signed margin balance and position balance values for each account.
687      */
688     struct Balance {
689         bool marginIsPositive;
690         bool positionIsPositive;
691         uint120 margin;
692         uint120 position;
693     }
694 
695     /**
696      * @dev Used to cache commonly-used variables that are relatively gas-intensive to obtain.
697      */
698     struct Context {
699         uint256 price;
700         uint256 minCollateral;
701         Index index;
702     }
703 
704     /**
705      * @dev Used by contracts implementing the I_P1Trader interface to return the result of a trade.
706      */
707     struct TradeResult {
708         uint256 marginAmount;
709         uint256 positionAmount;
710         bool isBuy; // From taker's perspective.
711         bytes32 traderFlags;
712     }
713 }
714 
715 // File: contracts/protocol/v1/lib/P1IndexMath.sol
716 
717 /**
718  * @title P1IndexMath
719  * @author dYdX
720  *
721  * @dev Library for manipulating P1Types.Index structs.
722  */
723 library P1IndexMath {
724 
725     // ============ Constants ============
726 
727     uint256 private constant FLAG_IS_POSITIVE = 1 << (8 * 16);
728 
729     // ============ Functions ============
730 
731     /**
732      * @dev Returns a compressed bytes32 representation of the index for logging.
733      */
734     function toBytes32(
735         P1Types.Index memory index
736     )
737         internal
738         pure
739         returns (bytes32)
740     {
741         uint256 result =
742             index.value
743             | (index.isPositive ? FLAG_IS_POSITIVE : 0)
744             | (uint256(index.timestamp) << 136);
745         return bytes32(result);
746     }
747 }
748 
749 // File: contracts/protocol/v1/oracles/P1FundingOracle.sol
750 
751 /**
752  * @title P1FundingOracle
753  * @author dYdX
754  *
755  * @notice Oracle providing the funding rate for a perpetual market.
756  */
757 contract P1FundingOracle is
758     Ownable,
759     I_P1Funder
760 {
761     using BaseMath for uint256;
762     using SafeCast for uint256;
763     using SafeMath for uint128;
764     using SafeMath for uint256;
765     using P1IndexMath for P1Types.Index;
766     using SignedMath for SignedMath.Int;
767 
768     // ============ Constants ============
769 
770     uint256 private constant FLAG_IS_POSITIVE = 1 << 128;
771     uint128 constant internal BASE = 10 ** 18;
772 
773     /**
774      * @notice Bounding params constraining updates to the funding rate.
775      *
776      *  Like the funding rate, these are per-second rates, fixed-point with 18 decimals.
777      *  We calculate the per-second rates from the market specifications, which uses 8-hour rates:
778      *  - The max absolute funding rate is 0.75% (8-hour rate).
779      *  - The max change in a single update is 0.75% (8-hour rate).
780      *  - The max change over a 55-minute period is 0.75% (8-hour rate).
781      *
782      *  This means the fastest the funding rate can go from zero to its min or max allowed value
783      *  (or vice versa) is in 55 minutes.
784      */
785     uint128 public constant MAX_ABS_VALUE = BASE * 75 / 10000 / (8 hours);
786     uint128 public constant MAX_ABS_DIFF_PER_UPDATE = MAX_ABS_VALUE;
787     uint128 public constant MAX_ABS_DIFF_PER_SECOND = MAX_ABS_VALUE / (55 minutes);
788 
789     // ============ Events ============
790 
791     event LogFundingRateUpdated(
792         bytes32 fundingRate
793     );
794 
795     // ============ Mutable Storage ============
796 
797     // The funding rate is denoted in units per second, as a fixed-point number with 18 decimals.
798     P1Types.Index private _FUNDING_RATE_;
799 
800     // ============ Functions ============
801 
802     constructor()
803         public
804     {
805         _FUNDING_RATE_ = P1Types.Index({
806             timestamp: block.timestamp.toUint32(),
807             isPositive: true,
808             value: 0
809         });
810         emit LogFundingRateUpdated(_FUNDING_RATE_.toBytes32());
811     }
812 
813     // ============ External Functions ============
814 
815     /**
816      * @notice Calculates the signed funding amount that has accumulated over a period of time.
817      *
818      * @param  timeDelta  Number of seconds over which to calculate the accumulated funding amount.
819      * @return            True if the funding rate is positive, and false otherwise.
820      * @return            The funding amount as a unitless rate, represented as a fixed-point number
821      *                    with 18 decimals.
822      */
823     function getFunding(
824         uint256 timeDelta
825     )
826         external
827         view
828         returns (bool, uint256)
829     {
830         // Note: Funding interest in PerpetualV1 does not compound, as the interest affects margin
831         // balances but is calculated based on position balances.
832         P1Types.Index memory fundingRate = _FUNDING_RATE_;
833         uint256 fundingAmount = uint256(fundingRate.value).mul(timeDelta);
834         return (fundingRate.isPositive, fundingAmount);
835     }
836 
837     /**
838      * @notice Set the funding rate.
839      * @dev Can only be called by the owner of this contract. Emits the LogFundingRateUpdated event.
840      * The rate is denoted in units per second, as a fixed-point number with 18 decimals.
841      *
842      * @param  newRate  The intended new funding rate. Is bounded by the global constant bounds.
843      * @return          The new funding rate with a timestamp of the update.
844      */
845     function setFundingRate(
846         SignedMath.Int calldata newRate
847     )
848         external
849         onlyOwner
850         returns (P1Types.Index memory)
851     {
852         SignedMath.Int memory boundedNewRate = _boundRate(newRate);
853         P1Types.Index memory boundedNewRateWithTimestamp = P1Types.Index({
854             timestamp: block.timestamp.toUint32(),
855             isPositive: boundedNewRate.isPositive,
856             value: boundedNewRate.value.toUint128()
857         });
858         _FUNDING_RATE_ = boundedNewRateWithTimestamp;
859         emit LogFundingRateUpdated(boundedNewRateWithTimestamp.toBytes32());
860         return boundedNewRateWithTimestamp;
861     }
862 
863     // ============ Helper Functions ============
864 
865     /**
866      * @dev Apply the contract-defined bounds and return the bounded rate.
867      */
868     function _boundRate(
869         SignedMath.Int memory newRate
870     )
871         private
872         view
873         returns (SignedMath.Int memory)
874     {
875         // Get the old rate from storage.
876         P1Types.Index memory oldRateWithTimestamp = _FUNDING_RATE_;
877         SignedMath.Int memory oldRate = SignedMath.Int({
878             value: oldRateWithTimestamp.value,
879             isPositive: oldRateWithTimestamp.isPositive
880         });
881 
882         // Get the maximum allowed change in the rate.
883         uint256 timeDelta = block.timestamp.sub(oldRateWithTimestamp.timestamp);
884         uint256 maxDiff = Math.min(
885             MAX_ABS_DIFF_PER_UPDATE,
886             MAX_ABS_DIFF_PER_SECOND.mul(timeDelta)
887         );
888 
889         // Calculate and return the bounded rate.
890         if (newRate.gt(oldRate)) {
891             SignedMath.Int memory upperBound = SignedMath.min(
892                 oldRate.add(maxDiff),
893                 SignedMath.Int({ value: MAX_ABS_VALUE, isPositive: true })
894             );
895             return SignedMath.min(
896                 newRate,
897                 upperBound
898             );
899         } else {
900             SignedMath.Int memory lowerBound = SignedMath.max(
901                 oldRate.sub(maxDiff),
902                 SignedMath.Int({ value: MAX_ABS_VALUE, isPositive: false })
903             );
904             return SignedMath.max(
905                 newRate,
906                 lowerBound
907             );
908         }
909     }
910 }