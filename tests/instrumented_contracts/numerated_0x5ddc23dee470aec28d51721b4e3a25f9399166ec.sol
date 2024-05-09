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
355 
356     /**
357      * @dev Divide a value by a base value (result is rounded down).
358      */
359     function baseDiv(
360         uint256 value,
361         uint256 baseValue
362     )
363         internal
364         pure
365         returns (uint256)
366     {
367         return value.mul(BASE).div(baseValue);
368     }
369 
370     /**
371      * @dev Returns a base value representing the reciprocal of another base value (result is
372      *  rounded down).
373      */
374     function baseReciprocal(
375         uint256 baseValue
376     )
377         internal
378         pure
379         returns (uint256)
380     {
381         return baseDiv(BASE, baseValue);
382     }
383 }
384 
385 // File: contracts/protocol/lib/Math.sol
386 
387 /**
388  * @title Math
389  * @author dYdX
390  *
391  * @dev Library for non-standard Math functions.
392  */
393 library Math {
394     using SafeMath for uint256;
395 
396     // ============ Library Functions ============
397 
398     /**
399      * @dev Return target * (numerator / denominator), rounded down.
400      */
401     function getFraction(
402         uint256 target,
403         uint256 numerator,
404         uint256 denominator
405     )
406         internal
407         pure
408         returns (uint256)
409     {
410         return target.mul(numerator).div(denominator);
411     }
412 
413     /**
414      * @dev Return target * (numerator / denominator), rounded up.
415      */
416     function getFractionRoundUp(
417         uint256 target,
418         uint256 numerator,
419         uint256 denominator
420     )
421         internal
422         pure
423         returns (uint256)
424     {
425         if (target == 0 || numerator == 0) {
426             // SafeMath will check for zero denominator
427             return SafeMath.div(0, denominator);
428         }
429         return target.mul(numerator).sub(1).div(denominator).add(1);
430     }
431 
432     /**
433      * @dev Returns the minimum between a and b.
434      */
435     function min(
436         uint256 a,
437         uint256 b
438     )
439         internal
440         pure
441         returns (uint256)
442     {
443         return a < b ? a : b;
444     }
445 
446     /**
447      * @dev Returns the maximum between a and b.
448      */
449     function max(
450         uint256 a,
451         uint256 b
452     )
453         internal
454         pure
455         returns (uint256)
456     {
457         return a > b ? a : b;
458     }
459 }
460 
461 // File: contracts/protocol/lib/SafeCast.sol
462 
463 /**
464  * @title SafeCast
465  * @author dYdX
466  *
467  * @dev Library for casting uint256 to other types of uint.
468  */
469 library SafeCast {
470 
471     /**
472      * @dev Returns the downcasted uint128 from uint256, reverting on
473      *  overflow (i.e. when the input is greater than largest uint128).
474      *
475      *  Counterpart to Solidity's `uint128` operator.
476      *
477      *  Requirements:
478      *  - `value` must fit into 128 bits.
479      */
480     function toUint128(
481         uint256 value
482     )
483         internal
484         pure
485         returns (uint128)
486     {
487         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
488         return uint128(value);
489     }
490 
491     /**
492      * @dev Returns the downcasted uint120 from uint256, reverting on
493      *  overflow (i.e. when the input is greater than largest uint120).
494      *
495      *  Counterpart to Solidity's `uint120` operator.
496      *
497      *  Requirements:
498      *  - `value` must fit into 120 bits.
499      */
500     function toUint120(
501         uint256 value
502     )
503         internal
504         pure
505         returns (uint120)
506     {
507         require(value < 2**120, "SafeCast: value doesn\'t fit in 120 bits");
508         return uint120(value);
509     }
510 
511     /**
512      * @dev Returns the downcasted uint32 from uint256, reverting on
513      *  overflow (i.e. when the input is greater than largest uint32).
514      *
515      *  Counterpart to Solidity's `uint32` operator.
516      *
517      *  Requirements:
518      *  - `value` must fit into 32 bits.
519      */
520     function toUint32(
521         uint256 value
522     )
523         internal
524         pure
525         returns (uint32)
526     {
527         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
528         return uint32(value);
529     }
530 }
531 
532 // File: contracts/protocol/lib/SignedMath.sol
533 
534 /**
535  * @title SignedMath
536  * @author dYdX
537  *
538  * @dev SignedMath library for doing math with signed integers.
539  */
540 library SignedMath {
541     using SafeMath for uint256;
542 
543     // ============ Structs ============
544 
545     struct Int {
546         uint256 value;
547         bool isPositive;
548     }
549 
550     // ============ Functions ============
551 
552     /**
553      * @dev Returns a new signed integer equal to a signed integer plus an unsigned integer.
554      */
555     function add(
556         Int memory sint,
557         uint256 value
558     )
559         internal
560         pure
561         returns (Int memory)
562     {
563         if (sint.isPositive) {
564             return Int({
565                 value: value.add(sint.value),
566                 isPositive: true
567             });
568         }
569         if (sint.value < value) {
570             return Int({
571                 value: value.sub(sint.value),
572                 isPositive: true
573             });
574         }
575         return Int({
576             value: sint.value.sub(value),
577             isPositive: false
578         });
579     }
580 
581     /**
582      * @dev Returns a new signed integer equal to a signed integer minus an unsigned integer.
583      */
584     function sub(
585         Int memory sint,
586         uint256 value
587     )
588         internal
589         pure
590         returns (Int memory)
591     {
592         if (!sint.isPositive) {
593             return Int({
594                 value: value.add(sint.value),
595                 isPositive: false
596             });
597         }
598         if (sint.value > value) {
599             return Int({
600                 value: sint.value.sub(value),
601                 isPositive: true
602             });
603         }
604         return Int({
605             value: value.sub(sint.value),
606             isPositive: false
607         });
608     }
609 
610     /**
611      * @dev Returns a new signed integer equal to a signed integer plus another signed integer.
612      */
613     function signedAdd(
614         Int memory augend,
615         Int memory addend
616     )
617         internal
618         pure
619         returns (Int memory)
620     {
621         return addend.isPositive
622             ? add(augend, addend.value)
623             : sub(augend, addend.value);
624     }
625 
626     /**
627      * @dev Returns a new signed integer equal to a signed integer minus another signed integer.
628      */
629     function signedSub(
630         Int memory minuend,
631         Int memory subtrahend
632     )
633         internal
634         pure
635         returns (Int memory)
636     {
637         return subtrahend.isPositive
638             ? sub(minuend, subtrahend.value)
639             : add(minuend, subtrahend.value);
640     }
641 
642     /**
643      * @dev Returns true if signed integer `a` is greater than signed integer `b`, false otherwise.
644      */
645     function gt(
646         Int memory a,
647         Int memory b
648     )
649         internal
650         pure
651         returns (bool)
652     {
653         if (a.isPositive) {
654             if (b.isPositive) {
655                 return a.value > b.value;
656             } else {
657                 // True, unless both values are zero.
658                 return a.value != 0 || b.value != 0;
659             }
660         } else {
661             if (b.isPositive) {
662                 return false;
663             } else {
664                 return a.value < b.value;
665             }
666         }
667     }
668 
669     /**
670      * @dev Returns the minimum of signed integers `a` and `b`.
671      */
672     function min(
673         Int memory a,
674         Int memory b
675     )
676         internal
677         pure
678         returns (Int memory)
679     {
680         return gt(b, a) ? a : b;
681     }
682 
683     /**
684      * @dev Returns the maximum of signed integers `a` and `b`.
685      */
686     function max(
687         Int memory a,
688         Int memory b
689     )
690         internal
691         pure
692         returns (Int memory)
693     {
694         return gt(a, b) ? a : b;
695     }
696 }
697 
698 // File: contracts/protocol/v1/intf/I_P1Funder.sol
699 
700 /**
701  * @title I_P1Funder
702  * @author dYdX
703  *
704  * @notice Interface for an oracle providing the funding rate for a perpetual market.
705  */
706 interface I_P1Funder {
707 
708     /**
709      * @notice Calculates the signed funding amount that has accumulated over a period of time.
710      *
711      * @param  timeDelta  Number of seconds over which to calculate the accumulated funding amount.
712      * @return            True if the funding rate is positive, and false otherwise.
713      * @return            The funding amount as a unitless rate, represented as a fixed-point number
714      *                    with 18 decimals.
715      */
716     function getFunding(
717         uint256 timeDelta
718     )
719         external
720         view
721         returns (bool, uint256);
722 }
723 
724 // File: contracts/protocol/v1/lib/P1Types.sol
725 
726 /**
727  * @title P1Types
728  * @author dYdX
729  *
730  * @dev Library for common types used in PerpetualV1 contracts.
731  */
732 library P1Types {
733     // ============ Structs ============
734 
735     /**
736      * @dev Used to represent the global index and each account's cached index.
737      *  Used to settle funding paymennts on a per-account basis.
738      */
739     struct Index {
740         uint32 timestamp;
741         bool isPositive;
742         uint128 value;
743     }
744 
745     /**
746      * @dev Used to track the signed margin balance and position balance values for each account.
747      */
748     struct Balance {
749         bool marginIsPositive;
750         bool positionIsPositive;
751         uint120 margin;
752         uint120 position;
753     }
754 
755     /**
756      * @dev Used to cache commonly-used variables that are relatively gas-intensive to obtain.
757      */
758     struct Context {
759         uint256 price;
760         uint256 minCollateral;
761         Index index;
762     }
763 
764     /**
765      * @dev Used by contracts implementing the I_P1Trader interface to return the result of a trade.
766      */
767     struct TradeResult {
768         uint256 marginAmount;
769         uint256 positionAmount;
770         bool isBuy; // From taker's perspective.
771         bytes32 traderFlags;
772     }
773 }
774 
775 // File: contracts/protocol/v1/lib/P1IndexMath.sol
776 
777 /**
778  * @title P1IndexMath
779  * @author dYdX
780  *
781  * @dev Library for manipulating P1Types.Index structs.
782  */
783 library P1IndexMath {
784 
785     // ============ Constants ============
786 
787     uint256 private constant FLAG_IS_POSITIVE = 1 << (8 * 16);
788 
789     // ============ Functions ============
790 
791     /**
792      * @dev Returns a compressed bytes32 representation of the index for logging.
793      */
794     function toBytes32(
795         P1Types.Index memory index
796     )
797         internal
798         pure
799         returns (bytes32)
800     {
801         uint256 result =
802             index.value
803             | (index.isPositive ? FLAG_IS_POSITIVE : 0)
804             | (uint256(index.timestamp) << 136);
805         return bytes32(result);
806     }
807 }
808 
809 // File: contracts/protocol/v1/oracles/P1FundingOracle.sol
810 
811 /**
812  * @title P1FundingOracle
813  * @author dYdX
814  *
815  * @notice Oracle providing the funding rate for a perpetual market.
816  */
817 contract P1FundingOracle is
818     Ownable,
819     I_P1Funder
820 {
821     using BaseMath for uint256;
822     using SafeCast for uint256;
823     using SafeMath for uint128;
824     using SafeMath for uint256;
825     using P1IndexMath for P1Types.Index;
826     using SignedMath for SignedMath.Int;
827 
828     // ============ Constants ============
829 
830     uint256 private constant FLAG_IS_POSITIVE = 1 << 128;
831     uint128 constant internal BASE = 10 ** 18;
832 
833     /**
834      * @notice Bounding params constraining updates to the funding rate.
835      *
836      *  Like the funding rate, these are per-second rates, fixed-point with 18 decimals.
837      *  We calculate the per-second rates from the market specifications, which use 8-hour rates:
838      *  - The max absolute funding rate is 0.75% (8-hour rate).
839      *  - The max change over a 45-minute period is 1.5% (8-hour rate).
840      *
841      *  This means the fastest the funding rate can go from its min to its max value, or vice versa,
842      *  is in 45 minutes.
843      */
844     uint128 public constant MAX_ABS_VALUE = BASE * 75 / 10000 / (8 hours);
845     uint128 public constant MAX_ABS_DIFF_PER_SECOND = MAX_ABS_VALUE * 2 / (45 minutes);
846 
847     // ============ Events ============
848 
849     event LogFundingRateUpdated(
850         bytes32 fundingRate
851     );
852 
853     event LogFundingRateProviderSet(
854         address fundingRateProvider
855     );
856 
857     // ============ Mutable Storage ============
858 
859     // The funding rate is denoted in units per second, as a fixed-point number with 18 decimals.
860     P1Types.Index private _FUNDING_RATE_;
861 
862     // Address which has the ability to update the funding rate.
863     address public _FUNDING_RATE_PROVIDER_;
864 
865     // ============ Constructor ============
866 
867     constructor(
868         address fundingRateProvider
869     )
870         public
871     {
872         P1Types.Index memory fundingRate = P1Types.Index({
873             timestamp: block.timestamp.toUint32(),
874             isPositive: true,
875             value: 0
876         });
877         _FUNDING_RATE_ = fundingRate;
878         _FUNDING_RATE_PROVIDER_ = fundingRateProvider;
879 
880         emit LogFundingRateUpdated(fundingRate.toBytes32());
881         emit LogFundingRateProviderSet(fundingRateProvider);
882     }
883 
884     // ============ External Functions ============
885 
886     /**
887      * @notice Set the funding rate, denoted in units per second, fixed-point with 18 decimals.
888      * @dev Can only be called by the funding rate provider. Emits the LogFundingRateUpdated event.
889      *
890      * @param  newRate  The intended new funding rate. Is bounded by the global constant bounds.
891      * @return          The new funding rate with a timestamp of the update.
892      */
893     function setFundingRate(
894         SignedMath.Int calldata newRate
895     )
896         external
897         returns (P1Types.Index memory)
898     {
899         require(
900             msg.sender == _FUNDING_RATE_PROVIDER_,
901             "The funding rate can only be set by the funding rate provider"
902         );
903 
904         SignedMath.Int memory boundedNewRate = _boundRate(newRate);
905         P1Types.Index memory boundedNewRateWithTimestamp = P1Types.Index({
906             timestamp: block.timestamp.toUint32(),
907             isPositive: boundedNewRate.isPositive,
908             value: boundedNewRate.value.toUint128()
909         });
910         _FUNDING_RATE_ = boundedNewRateWithTimestamp;
911 
912         emit LogFundingRateUpdated(boundedNewRateWithTimestamp.toBytes32());
913 
914         return boundedNewRateWithTimestamp;
915     }
916 
917     /**
918      * @notice Set the funding rate provider. Can only be called by the admin.
919      * @dev Emits the LogFundingRateProviderSet event.
920      *
921      * @param  newProvider  The new provider, who will have the ability to set the funding rate.
922      */
923     function setFundingRateProvider(
924         address newProvider
925     )
926         external
927         onlyOwner
928     {
929         _FUNDING_RATE_PROVIDER_ = newProvider;
930         emit LogFundingRateProviderSet(newProvider);
931     }
932 
933     // ============ Public Functions ============
934 
935     /**
936      * @notice Calculates the signed funding amount that has accumulated over a period of time.
937      *
938      * @param  timeDelta  Number of seconds over which to calculate the accumulated funding amount.
939      * @return            True if the funding rate is positive, and false otherwise.
940      * @return            The funding amount as a unitless rate, represented as a fixed-point number
941      *                    with 18 decimals.
942      */
943     function getFunding(
944         uint256 timeDelta
945     )
946         public
947         view
948         returns (bool, uint256)
949     {
950         // Note: Funding interest in PerpetualV1 does not compound, as the interest affects margin
951         // balances but is calculated based on position balances.
952         P1Types.Index memory fundingRate = _FUNDING_RATE_;
953         uint256 fundingAmount = uint256(fundingRate.value).mul(timeDelta);
954         return (fundingRate.isPositive, fundingAmount);
955     }
956 
957     // ============ Helper Functions ============
958 
959     /**
960      * @dev Apply the contract-defined bounds and return the bounded rate.
961      */
962     function _boundRate(
963         SignedMath.Int memory newRate
964     )
965         private
966         view
967         returns (SignedMath.Int memory)
968     {
969         // Get the old rate from storage.
970         P1Types.Index memory oldRateWithTimestamp = _FUNDING_RATE_;
971         SignedMath.Int memory oldRate = SignedMath.Int({
972             value: oldRateWithTimestamp.value,
973             isPositive: oldRateWithTimestamp.isPositive
974         });
975 
976         // Get the maximum allowed change in the rate.
977         uint256 timeDelta = block.timestamp.sub(oldRateWithTimestamp.timestamp);
978         uint256 maxDiff = MAX_ABS_DIFF_PER_SECOND.mul(timeDelta);
979 
980         // Calculate and return the bounded rate.
981         if (newRate.gt(oldRate)) {
982             SignedMath.Int memory upperBound = SignedMath.min(
983                 oldRate.add(maxDiff),
984                 SignedMath.Int({ value: MAX_ABS_VALUE, isPositive: true })
985             );
986             return SignedMath.min(
987                 newRate,
988                 upperBound
989             );
990         } else {
991             SignedMath.Int memory lowerBound = SignedMath.max(
992                 oldRate.sub(maxDiff),
993                 SignedMath.Int({ value: MAX_ABS_VALUE, isPositive: false })
994             );
995             return SignedMath.max(
996                 newRate,
997                 lowerBound
998             );
999         }
1000     }
1001 }
1002 
1003 // File: contracts/protocol/v1/oracles/P1InverseFundingOracle.sol
1004 
1005 /**
1006  * @title P1InverseFundingOracle
1007  * @author dYdX
1008  *
1009  * @notice P1FundingOracle that uses the inverted rate (i.e. flips base and quote currencies)
1010  *  when getting the funding amount.
1011  */
1012 contract P1InverseFundingOracle is
1013     P1FundingOracle
1014 {
1015     // ============ Constructor ============
1016 
1017     constructor(
1018         address fundingRateProvider
1019     )
1020         P1FundingOracle(fundingRateProvider)
1021         public
1022     {
1023     }
1024 
1025     // ============ External Functions ============
1026 
1027     /**
1028      * @notice Calculates the signed funding amount that has accumulated over a period of time.
1029      *
1030      * @param  timeDelta  Number of seconds over which to calculate the accumulated funding amount.
1031      * @return            True if the funding rate is positive, and false otherwise.
1032      * @return            The funding amount as a unitless rate, represented as a fixed-point number
1033      *                    with 18 decimals.
1034      */
1035     function getFunding(
1036         uint256 timeDelta
1037     )
1038         public
1039         view
1040         returns (bool, uint256)
1041     {
1042         (bool isPositive, uint256 fundingAmount) = super.getFunding(timeDelta);
1043         return (!isPositive, fundingAmount);
1044     }
1045 }