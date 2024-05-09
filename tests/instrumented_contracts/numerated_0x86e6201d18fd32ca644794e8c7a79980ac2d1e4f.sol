1 pragma solidity 0.6.6;
2 
3 // File: contracts/util/DeployerRole.sol
4 
5 
6 abstract contract DeployerRole {
7     address internal immutable _deployer;
8 
9     modifier onlyDeployer() {
10         require(
11             _isDeployer(msg.sender),
12             "only deployer is allowed to call this function"
13         );
14         _;
15     }
16 
17     constructor() public {
18         _deployer = msg.sender;
19     }
20 
21     function _isDeployer(address account) internal view returns (bool) {
22         return account == _deployer;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/math/SafeMath.sol
27 
28 
29 
30 /**
31  * @dev Wrappers over Solidity's arithmetic operations with added overflow
32  * checks.
33  *
34  * Arithmetic operations in Solidity wrap on overflow. This can easily result
35  * in bugs, because programmers usually assume that an overflow raises an
36  * error, which is the standard behavior in high level programming languages.
37  * `SafeMath` restores this intuition by reverting the transaction when an
38  * operation overflows.
39  *
40  * Using this library instead of the unchecked operations eliminates an entire
41  * class of bugs, so it's recommended to use it always.
42  */
43 library SafeMath {
44     /**
45      * @dev Returns the addition of two unsigned integers, reverting on
46      * overflow.
47      *
48      * Counterpart to Solidity's `+` operator.
49      *
50      * Requirements:
51      * - Addition cannot overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b <= a, errorMessage);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the multiplication of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `*` operator.
94      *
95      * Requirements:
96      * - Multiplication cannot overflow.
97      */
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
100         // benefit is lost if 'b' is also tested.
101         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
102         if (a == 0) {
103             return 0;
104         }
105 
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return div(a, b, "SafeMath: division by zero");
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         // Solidity only automatically asserts when dividing by 0
140         require(b > 0, errorMessage);
141         uint256 c = a / b;
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         return mod(a, b, "SafeMath: modulo by zero");
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts with custom message when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b != 0, errorMessage);
175         return a % b;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/math/SignedSafeMath.sol
180 
181 
182 
183 /**
184  * @title SignedSafeMath
185  * @dev Signed math operations with safety checks that revert on error.
186  */
187 library SignedSafeMath {
188     int256 constant private _INT256_MIN = -2**255;
189 
190     /**
191      * @dev Multiplies two signed integers, reverts on overflow.
192      */
193     function mul(int256 a, int256 b) internal pure returns (int256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
202 
203         int256 c = a * b;
204         require(c / a == b, "SignedSafeMath: multiplication overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
211      */
212     function div(int256 a, int256 b) internal pure returns (int256) {
213         require(b != 0, "SignedSafeMath: division by zero");
214         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
215 
216         int256 c = a / b;
217 
218         return c;
219     }
220 
221     /**
222      * @dev Subtracts two signed integers, reverts on overflow.
223      */
224     function sub(int256 a, int256 b) internal pure returns (int256) {
225         int256 c = a - b;
226         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
227 
228         return c;
229     }
230 
231     /**
232      * @dev Adds two signed integers, reverts on overflow.
233      */
234     function add(int256 a, int256 b) internal pure returns (int256) {
235         int256 c = a + b;
236         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
237 
238         return c;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/SafeCast.sol
243 
244 
245 
246 
247 /**
248  * @dev Wrappers over Solidity's uintXX casting operators with added overflow
249  * checks.
250  *
251  * Downcasting from uint256 in Solidity does not revert on overflow. This can
252  * easily result in undesired exploitation or bugs, since developers usually
253  * assume that overflows raise errors. `SafeCast` restores this intuition by
254  * reverting the transaction when such an operation overflows.
255  *
256  * Using this library instead of the unchecked operations eliminates an entire
257  * class of bugs, so it's recommended to use it always.
258  *
259  * Can be combined with {SafeMath} to extend it to smaller types, by performing
260  * all math on `uint256` and then downcasting.
261  */
262 library SafeCast {
263 
264     /**
265      * @dev Returns the downcasted uint128 from uint256, reverting on
266      * overflow (when the input is greater than largest uint128).
267      *
268      * Counterpart to Solidity's `uint128` operator.
269      *
270      * Requirements:
271      *
272      * - input must fit into 128 bits
273      */
274     function toUint128(uint256 value) internal pure returns (uint128) {
275         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
276         return uint128(value);
277     }
278 
279     /**
280      * @dev Returns the downcasted uint64 from uint256, reverting on
281      * overflow (when the input is greater than largest uint64).
282      *
283      * Counterpart to Solidity's `uint64` operator.
284      *
285      * Requirements:
286      *
287      * - input must fit into 64 bits
288      */
289     function toUint64(uint256 value) internal pure returns (uint64) {
290         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
291         return uint64(value);
292     }
293 
294     /**
295      * @dev Returns the downcasted uint32 from uint256, reverting on
296      * overflow (when the input is greater than largest uint32).
297      *
298      * Counterpart to Solidity's `uint32` operator.
299      *
300      * Requirements:
301      *
302      * - input must fit into 32 bits
303      */
304     function toUint32(uint256 value) internal pure returns (uint32) {
305         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
306         return uint32(value);
307     }
308 
309     /**
310      * @dev Returns the downcasted uint16 from uint256, reverting on
311      * overflow (when the input is greater than largest uint16).
312      *
313      * Counterpart to Solidity's `uint16` operator.
314      *
315      * Requirements:
316      *
317      * - input must fit into 16 bits
318      */
319     function toUint16(uint256 value) internal pure returns (uint16) {
320         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
321         return uint16(value);
322     }
323 
324     /**
325      * @dev Returns the downcasted uint8 from uint256, reverting on
326      * overflow (when the input is greater than largest uint8).
327      *
328      * Counterpart to Solidity's `uint8` operator.
329      *
330      * Requirements:
331      *
332      * - input must fit into 8 bits.
333      */
334     function toUint8(uint256 value) internal pure returns (uint8) {
335         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
336         return uint8(value);
337     }
338 
339     /**
340      * @dev Converts a signed int256 into an unsigned uint256.
341      *
342      * Requirements:
343      *
344      * - input must be greater than or equal to 0.
345      */
346     function toUint256(int256 value) internal pure returns (uint256) {
347         require(value >= 0, "SafeCast: value must be positive");
348         return uint256(value);
349     }
350 
351     /**
352      * @dev Converts an unsigned uint256 into a signed int256.
353      *
354      * Requirements:
355      *
356      * - input must be less than or equal to maxInt256.
357      */
358     function toInt256(uint256 value) internal pure returns (int256) {
359         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
360         return int256(value);
361     }
362 }
363 
364 // File: contracts/math/UseSafeMath.sol
365 
366 
367 
368 
369 
370 
371 
372 /**
373  * @notice ((a - 1) / b) + 1 = (a + b -1) / b
374  * for example a.add(10**18 -1).div(10**18) = a.sub(1).div(10**18) + 1
375  */
376 
377 library SafeMathDivRoundUp {
378     using SafeMath for uint256;
379 
380     function divRoundUp(
381         uint256 a,
382         uint256 b,
383         string memory errorMessage
384     ) internal pure returns (uint256) {
385         if (a == 0) {
386             return 0;
387         }
388         require(b > 0, errorMessage);
389         return ((a - 1) / b) + 1;
390     }
391 
392     function divRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {
393         return divRoundUp(a, b, "SafeMathDivRoundUp: modulo by zero");
394     }
395 }
396 
397 
398 /**
399  * @title UseSafeMath
400  * @dev One can use SafeMath for not only uint256 but also uin64 or uint16,
401  * and also can use SafeCast for uint256.
402  * For example:
403  *   uint64 a = 1;
404  *   uint64 b = 2;
405  *   a = a.add(b).toUint64() // `a` become 3 as uint64
406  * In additionally, one can use SignedSafeMath and SafeCast.toUint256(int256) for int256.
407  * In the case of the operation to the uint64 value, one need to cast the value into int256 in
408  * advance to use `sub` as SignedSafeMath.sub not SafeMath.sub.
409  * For example:
410  *   int256 a = 1;
411  *   uint64 b = 2;
412  *   int256 c = 3;
413  *   a = a.add(int256(b).sub(c)); // `a` become 0 as int256
414  *   b = a.toUint256().toUint64(); // `b` become 0 as uint64
415  */
416 abstract contract UseSafeMath {
417     using SafeMath for uint256;
418     using SafeMathDivRoundUp for uint256;
419     using SafeMath for uint64;
420     using SafeMathDivRoundUp for uint64;
421     using SafeMath for uint16;
422     using SignedSafeMath for int256;
423     using SafeCast for uint256;
424     using SafeCast for int256;
425 }
426 
427 // File: contracts/oracle/OracleInterface.sol
428 
429 
430 // Oracle referenced by OracleProxy must implement this interface.
431 interface OracleInterface {
432     // Returns if oracle is running.
433     function alive() external view returns (bool);
434 
435     // Returns latest id.
436     // The first id is 1 and 0 value is invalid as id.
437     // Each price values and theirs timestamps are identified by id.
438     // Ids are assigned incrementally to values.
439     function latestId() external returns (uint256);
440 
441     // Returns latest price value.
442     // decimal 8
443     function latestPrice() external returns (uint256);
444 
445     // Returns timestamp of latest price.
446     function latestTimestamp() external returns (uint256);
447 
448     // Returns price of id.
449     function getPrice(uint256 id) external returns (uint256);
450 
451     // Returns timestamp of id.
452     function getTimestamp(uint256 id) external returns (uint256);
453 
454     function getVolatility() external returns (uint256);
455 }
456 
457 // File: contracts/oracle/UseOracle.sol
458 
459 
460 abstract contract UseOracle {
461     OracleInterface internal _oracleContract;
462 
463     constructor(address contractAddress) public {
464         require(
465             contractAddress != address(0),
466             "contract should be non-zero address"
467         );
468         _oracleContract = OracleInterface(contractAddress);
469     }
470 
471     /// @notice Get the latest USD/ETH price and historical volatility using oracle.
472     /// @return rateETH2USDE8 (10^-8 USD/ETH)
473     /// @return volatilityE8 (10^-8)
474     function _getOracleData()
475         internal
476         returns (uint256 rateETH2USDE8, uint256 volatilityE8)
477     {
478         rateETH2USDE8 = _oracleContract.latestPrice();
479         volatilityE8 = _oracleContract.getVolatility();
480 
481         return (rateETH2USDE8, volatilityE8);
482     }
483 
484     /// @notice Get the price of the oracle data with a minimum timestamp that does more than input value
485     /// when you know the ID you are looking for.
486     /// @param timestamp is the timestamp that you want to get price.
487     /// @param hintID is the ID of the oracle data you are looking for.
488     /// @return rateETH2USDE8 (10^-8 USD/ETH)
489     function _getPriceOn(uint256 timestamp, uint256 hintID)
490         internal
491         returns (uint256 rateETH2USDE8)
492     {
493         uint256 latestID = _oracleContract.latestId();
494         require(
495             latestID != 0,
496             "system error: the ID of oracle data should not be zero"
497         );
498 
499         require(hintID != 0, "the hint ID must not be zero");
500         uint256 id = hintID;
501         if (hintID > latestID) {
502             id = latestID;
503         }
504 
505         require(
506             _oracleContract.getTimestamp(id) > timestamp,
507             "there is no price data after maturity"
508         );
509 
510         id--;
511         while (id != 0) {
512             if (_oracleContract.getTimestamp(id) <= timestamp) {
513                 break;
514             }
515             id--;
516         }
517 
518         return _oracleContract.getPrice(id + 1);
519     }
520 }
521 
522 // File: contracts/BondMakerInterface.sol
523 
524 
525 interface BondMakerInterface {
526     event LogNewBond(
527         bytes32 indexed bondID,
528         address bondTokenAddress,
529         uint64 stableStrikePrice,
530         bytes32 fnMapID
531     );
532 
533     event LogNewBondGroup(uint256 indexed bondGroupID);
534 
535     event LogIssueNewBonds(
536         uint256 indexed bondGroupID,
537         address indexed issuer,
538         uint256 amount
539     );
540 
541     event LogReverseBondToETH(
542         uint256 indexed bondGroupID,
543         address indexed owner,
544         uint256 amount
545     );
546 
547     event LogExchangeEquivalentBonds(
548         address indexed owner,
549         uint256 indexed inputBondGroupID,
550         uint256 indexed outputBondGroupID,
551         uint256 amount
552     );
553 
554     event LogTransferETH(
555         address indexed from,
556         address indexed to,
557         uint256 value
558     );
559 
560     function registerNewBond(uint256 maturity, bytes calldata fnMap)
561         external
562         returns (
563             bytes32 bondID,
564             address bondTokenAddress,
565             uint64 solidStrikePrice,
566             bytes32 fnMapID
567         );
568 
569     function registerNewBondGroup(
570         bytes32[] calldata bondIDList,
571         uint256 maturity
572     ) external returns (uint256 bondGroupID);
573 
574     function issueNewBonds(uint256 bondGroupID)
575         external
576         payable
577         returns (uint256 amount);
578 
579     function reverseBondToETH(uint256 bondGroupID, uint256 amount)
580         external
581         returns (bool success);
582 
583     function exchangeEquivalentBonds(
584         uint256 inputBondGroupID,
585         uint256 outputBondGroupID,
586         uint256 amount,
587         bytes32[] calldata exceptionBonds
588     ) external returns (bool);
589 
590     function liquidateBond(uint256 bondGroupID, uint256 oracleHintID) external;
591 
592     function getBond(bytes32 bondID)
593         external
594         view
595         returns (
596             address bondAddress,
597             uint256 maturity,
598             uint64 solidStrikePrice,
599             bytes32 fnMapID
600         );
601 
602     function getFnMap(bytes32 fnMapID)
603         external
604         view
605         returns (bytes memory fnMap);
606 
607     function getBondGroup(uint256 bondGroupID)
608         external
609         view
610         returns (bytes32[] memory bondIDs, uint256 maturity);
611 
612     function generateBondID(uint256 maturity, bytes calldata functionHash)
613         external
614         pure
615         returns (bytes32 bondID);
616 }
617 
618 // File: contracts/UseBondMaker.sol
619 
620 
621 
622 
623 
624 abstract contract UseBondMaker {
625     BondMakerInterface internal immutable _bondMakerContract;
626 
627     constructor(address contractAddress) public {
628         require(
629             contractAddress != address(0),
630             "contract should be non-zero address"
631         );
632         _bondMakerContract = BondMakerInterface(payable(contractAddress));
633     }
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
637 
638 
639 
640 /**
641  * @dev Interface of the ERC20 standard as defined in the EIP.
642  */
643 interface IERC20 {
644     /**
645      * @dev Returns the amount of tokens in existence.
646      */
647     function totalSupply() external view returns (uint256);
648 
649     /**
650      * @dev Returns the amount of tokens owned by `account`.
651      */
652     function balanceOf(address account) external view returns (uint256);
653 
654     /**
655      * @dev Moves `amount` tokens from the caller's account to `recipient`.
656      *
657      * Returns a boolean value indicating whether the operation succeeded.
658      *
659      * Emits a {Transfer} event.
660      */
661     function transfer(address recipient, uint256 amount) external returns (bool);
662 
663     /**
664      * @dev Returns the remaining number of tokens that `spender` will be
665      * allowed to spend on behalf of `owner` through {transferFrom}. This is
666      * zero by default.
667      *
668      * This value changes when {approve} or {transferFrom} are called.
669      */
670     function allowance(address owner, address spender) external view returns (uint256);
671 
672     /**
673      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
674      *
675      * Returns a boolean value indicating whether the operation succeeded.
676      *
677      * IMPORTANT: Beware that changing an allowance with this method brings the risk
678      * that someone may use both the old and the new allowance by unfortunate
679      * transaction ordering. One possible solution to mitigate this race
680      * condition is to first reduce the spender's allowance to 0 and set the
681      * desired value afterwards:
682      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
683      *
684      * Emits an {Approval} event.
685      */
686     function approve(address spender, uint256 amount) external returns (bool);
687 
688     /**
689      * @dev Moves `amount` tokens from `sender` to `recipient` using the
690      * allowance mechanism. `amount` is then deducted from the caller's
691      * allowance.
692      *
693      * Returns a boolean value indicating whether the operation succeeded.
694      *
695      * Emits a {Transfer} event.
696      */
697     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
698 
699     /**
700      * @dev Emitted when `value` tokens are moved from one account (`from`) to
701      * another (`to`).
702      *
703      * Note that `value` may be zero.
704      */
705     event Transfer(address indexed from, address indexed to, uint256 value);
706 
707     /**
708      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
709      * a call to {approve}. `value` is the new allowance.
710      */
711     event Approval(address indexed owner, address indexed spender, uint256 value);
712 }
713 
714 // File: contracts/StableCoinInterface.sol
715 
716 
717 
718 
719 
720 interface StableCoinInterface is IERC20 {
721     event LogIsAcceptableSBT(bytes32 indexed bondID, bool isAcceptable);
722 
723     event LogMintIDOL(
724         bytes32 indexed bondID,
725         address indexed owner,
726         bytes32 poolID,
727         uint256 obtainIDOLAmount,
728         uint256 poolIDOLAmount
729     );
730 
731     event LogBurnIDOL(
732         bytes32 indexed bondID, // poolID?
733         address indexed owner,
734         uint256 burnIDOLAmount,
735         uint256 unlockSBTAmount
736     );
737 
738     event LogReturnLockedPool(
739         bytes32 indexed poolID,
740         address indexed owner,
741         uint64 backIDOLAmount
742     );
743 
744     event LogLambda(
745         bytes32 indexed poolID,
746         uint64 settledAverageAuctionPrice,
747         uint256 totalSupply,
748         uint256 lockedSBTValue
749     );
750 
751     function getPoolInfo(bytes32 poolID)
752         external
753         view
754         returns (
755             uint64 lockedSBTTotal,
756             uint64 unlockedSBTTotal,
757             uint64 lockedPoolIDOLTotal,
758             uint64 burnedIDOLTotal,
759             uint64 soldSBTTotalInAuction,
760             uint64 paidIDOLTotalInAuction,
761             uint64 settledAverageAuctionPrice,
762             bool isAllAmountSoldInAuction
763         );
764 
765     function solidValueTotal() external view returns (uint256 solidValue);
766 
767     function isAcceptableSBT(bytes32 bondID) external returns (bool ok);
768 
769     function mint(
770         bytes32 bondID,
771         address recipient,
772         uint64 lockAmount
773     )
774         external
775         returns (
776             bytes32 poolID,
777             uint64 obtainIDOLAmount,
778             uint64 poolIDOLAmount
779         );
780 
781     function burnFrom(address account, uint256 amount) external;
782 
783     function unlockSBT(bytes32 bondID, uint64 burnAmount)
784         external
785         returns (uint64 rewardSBT);
786 
787     function startAuctionOnMaturity(bytes32 bondID) external;
788 
789     function startAuctionByMarket(bytes32 bondID) external;
790 
791     function setSettledAverageAuctionPrice(
792         bytes32 bondID,
793         uint64 totalPaidIDOL,
794         uint64 SBTAmount,
795         bool isLast
796     ) external;
797 
798     function calcSBT2IDOL(uint256 solidBondAmount)
799         external
800         view
801         returns (uint256 IDOLAmount);
802 
803     function returnLockedPool(bytes32[] calldata poolIDs)
804         external
805         returns (uint64 IDOLAmount);
806 
807     function returnLockedPoolTo(bytes32[] calldata poolIDs, address account)
808         external
809         returns (uint64 IDOLAmount);
810 
811     function generatePoolID(bytes32 bondID, uint64 count)
812         external
813         pure
814         returns (bytes32 poolID);
815 
816     function getCurrentPoolID(bytes32 bondID)
817         external
818         view
819         returns (bytes32 poolID);
820 
821     function getLockedPool(address user, bytes32 poolID)
822         external
823         view
824         returns (uint64, uint64);
825 }
826 
827 // File: contracts/UseStableCoin.sol
828 
829 
830 
831 
832 
833 abstract contract UseStableCoin {
834     StableCoinInterface internal immutable _IDOLContract;
835 
836     constructor(address contractAddress) public {
837         require(
838             contractAddress != address(0),
839             "contract should be non-zero address"
840         );
841         _IDOLContract = StableCoinInterface(contractAddress);
842     }
843 
844     function _transferIDOLFrom(
845         address from,
846         address to,
847         uint256 amount
848     ) internal {
849         _IDOLContract.transferFrom(from, to, amount);
850     }
851 
852     function _transferIDOL(address to, uint256 amount) internal {
853         _IDOLContract.transfer(to, amount);
854     }
855 
856     function _transferIDOL(
857         address to,
858         uint256 amount,
859         string memory errorMessage
860     ) internal {
861         require(_IDOLContract.balanceOf(address(this)) >= amount, errorMessage);
862         _IDOLContract.transfer(to, amount);
863     }
864 }
865 
866 // File: contracts/fairswap/LBTExchangeFactoryInterface.sol
867 
868 
869 
870 
871 interface LBTExchangeFactoryInterface {
872     /**
873      * @notice Launches new exchange
874      * @param bondGroupId ID of bondgroup which target LBT belongs to
875      * @param place The place of target bond in the bondGroup
876      * @param IDOLAmount Initial liquidity of iDOL
877      * @param LBTAmount Initial liquidity of LBT
878      * @dev Get strikeprice and maturity from bond maker contract
879      **/
880     function launchExchange(
881         uint256 bondGroupId,
882         uint256 place,
883         uint256 IDOLAmount,
884         uint256 LBTAmount
885     ) external returns (address);
886 
887     /**
888      * @notice Gets exchange address from Address of LBT
889      * @param tokenAddress Address of LBT
890      **/
891     function addressToExchangeLookup(address tokenAddress)
892         external
893         view
894         returns (address exchange);
895 
896     /**
897      * @notice Gets exchange address from BondID of LBT
898      * @param bondID
899      **/
900     function bondIDToExchangeLookup(bytes32 bondID)
901         external
902         view
903         returns (address exchange);
904 
905     /**
906      * @dev Initial supply of share token is equal to amount of iDOL
907      * @dev If there is no share token, user can reinitialize exchange
908      * @param token Address of LBT
909      * @param IDOLAmount Amount of idol to be provided
910      * @param LBTAmount Amount of LBT to be provided
911      **/
912     function initializeExchange(
913         address token,
914         uint256 IDOLAmount,
915         uint256 LBTAmount
916     ) external;
917 }
918 
919 // File: contracts/WrapperInterface.sol
920 
921 
922 pragma experimental ABIEncoderV2;
923 
924 
925 interface WrapperInterface {
926     event LogRegisterBondAndBondGroup(
927         uint256 indexed bondGroupID,
928         bytes32[] bondIDs
929     );
930     event LogIssueIDOL(
931         bytes32 indexed bondID,
932         address indexed sender,
933         bytes32 poolID,
934         uint256 amount
935     );
936 
937     event LogIssueLBT(
938         bytes32 indexed bondID,
939         address indexed sender,
940         uint256 amount
941     );
942 
943     function registerBondAndBondGroup(bytes[] calldata fnMaps, uint256 maturity)
944         external
945         returns (bool);
946 
947     /**
948      * @notice swap (SBT -> LBT)
949      * @param solidBondID is a solid bond ID
950      * @param liquidBondID is a liquid bond ID
951      * @param timeout (uniswap)
952      * @param isLimit (uniswap)
953      */
954     function swapSBT2LBT(
955         bytes32 solidBondID,
956         bytes32 liquidBondID,
957         uint256 SBTAmount,
958         uint256 timeout,
959         bool isLimit
960     ) external;
961 
962     /**
963      * @notice ETH -> LBT & iDOL
964      * @param bondGroupID is a bond group ID
965      * @return poolID is a pool ID
966      * @return liquidBondAmount is LBT amount obtained
967      * @return IDOLAmount is iDOL amount obtained
968      */
969     function issueLBTAndIDOL(uint256 bondGroupID)
970         external
971         payable
972         returns (
973             bytes32 poolID,
974             uint256 liquidBondAmount,
975             uint256 IDOLAmount
976         );
977 
978     /**
979      * @notice ETH -> iDOL
980      * @param bondGroupID is a bond group ID
981      * @param timeout (uniswap)
982      * @param isLimit (uniswap)
983      */
984     function issueIDOLOnly(
985         uint256 bondGroupID,
986         uint256 timeout,
987         bool isLimit
988     ) external payable;
989 
990     /**
991      * @notice ETH -> LBT
992      * @param bondGroupID is a bond group ID
993      * @param liquidBondID is a liquid bond ID
994      * @param timeout (uniswap)
995      * @param isLimit (uniswap)
996      */
997     function issueLBTOnly(
998         uint256 bondGroupID,
999         bytes32 liquidBondID,
1000         uint256 timeout,
1001         bool isLimit
1002     ) external payable;
1003 }
1004 
1005 // File: @openzeppelin/contracts/GSN/Context.sol
1006 
1007 
1008 
1009 /*
1010  * @dev Provides information about the current execution context, including the
1011  * sender of the transaction and its data. While these are generally available
1012  * via msg.sender and msg.data, they should not be accessed in such a direct
1013  * manner, since when dealing with GSN meta-transactions the account sending and
1014  * paying for execution may not be the actual sender (as far as an application
1015  * is concerned).
1016  *
1017  * This contract is only required for intermediate, library-like contracts.
1018  */
1019 contract Context {
1020     // Empty internal constructor, to prevent people from mistakenly deploying
1021     // an instance of this contract, which should be used via inheritance.
1022     constructor () internal { }
1023 
1024     function _msgSender() internal view virtual returns (address payable) {
1025         return msg.sender;
1026     }
1027 
1028     function _msgData() internal view virtual returns (bytes memory) {
1029         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1030         return msg.data;
1031     }
1032 }
1033 
1034 // File: @openzeppelin/contracts/utils/Address.sol
1035 
1036 
1037 /**
1038  * @dev Collection of functions related to the address type
1039  */
1040 library Address {
1041     /**
1042      * @dev Returns true if `account` is a contract.
1043      *
1044      * [IMPORTANT]
1045      * ====
1046      * It is unsafe to assume that an address for which this function returns
1047      * false is an externally-owned account (EOA) and not a contract.
1048      *
1049      * Among others, `isContract` will return false for the following
1050      * types of addresses:
1051      *
1052      *  - an externally-owned account
1053      *  - a contract in construction
1054      *  - an address where a contract will be created
1055      *  - an address where a contract lived, but was destroyed
1056      * ====
1057      */
1058     function isContract(address account) internal view returns (bool) {
1059         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1060         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1061         // for accounts without code, i.e. `keccak256('')`
1062         bytes32 codehash;
1063         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1064         // solhint-disable-next-line no-inline-assembly
1065         assembly { codehash := extcodehash(account) }
1066         return (codehash != accountHash && codehash != 0x0);
1067     }
1068 
1069     /**
1070      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1071      * `recipient`, forwarding all available gas and reverting on errors.
1072      *
1073      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1074      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1075      * imposed by `transfer`, making them unable to receive funds via
1076      * `transfer`. {sendValue} removes this limitation.
1077      *
1078      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1079      *
1080      * IMPORTANT: because control is transferred to `recipient`, care must be
1081      * taken to not create reentrancy vulnerabilities. Consider using
1082      * {ReentrancyGuard} or the
1083      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1084      */
1085     function sendValue(address payable recipient, uint256 amount) internal {
1086         require(address(this).balance >= amount, "Address: insufficient balance");
1087 
1088         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1089         (bool success, ) = recipient.call{ value: amount }("");
1090         require(success, "Address: unable to send value, recipient may have reverted");
1091     }
1092 }
1093 
1094 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1095 
1096 /**
1097  * @dev Implementation of the {IERC20} interface.
1098  *
1099  * This implementation is agnostic to the way tokens are created. This means
1100  * that a supply mechanism has to be added in a derived contract using {_mint}.
1101  * For a generic mechanism see {ERC20MinterPauser}.
1102  *
1103  * TIP: For a detailed writeup see our guide
1104  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1105  * to implement supply mechanisms].
1106  *
1107  * We have followed general OpenZeppelin guidelines: functions revert instead
1108  * of returning `false` on failure. This behavior is nonetheless conventional
1109  * and does not conflict with the expectations of ERC20 applications.
1110  *
1111  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1112  * This allows applications to reconstruct the allowance for all accounts just
1113  * by listening to said events. Other implementations of the EIP may not emit
1114  * these events, as it isn't required by the specification.
1115  *
1116  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1117  * functions have been added to mitigate the well-known issues around setting
1118  * allowances. See {IERC20-approve}.
1119  */
1120 contract ERC20 is Context, IERC20 {
1121     using SafeMath for uint256;
1122     using Address for address;
1123 
1124     mapping (address => uint256) private _balances;
1125 
1126     mapping (address => mapping (address => uint256)) private _allowances;
1127 
1128     uint256 private _totalSupply;
1129 
1130     string private _name;
1131     string private _symbol;
1132     uint8 private _decimals;
1133 
1134     /**
1135      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1136      * a default value of 18.
1137      *
1138      * To select a different value for {decimals}, use {_setupDecimals}.
1139      *
1140      * All three of these values are immutable: they can only be set once during
1141      * construction.
1142      */
1143     constructor (string memory name, string memory symbol) public {
1144         _name = name;
1145         _symbol = symbol;
1146         _decimals = 18;
1147     }
1148 
1149     /**
1150      * @dev Returns the name of the token.
1151      */
1152     function name() public view returns (string memory) {
1153         return _name;
1154     }
1155 
1156     /**
1157      * @dev Returns the symbol of the token, usually a shorter version of the
1158      * name.
1159      */
1160     function symbol() public view returns (string memory) {
1161         return _symbol;
1162     }
1163 
1164     /**
1165      * @dev Returns the number of decimals used to get its user representation.
1166      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1167      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1168      *
1169      * Tokens usually opt for a value of 18, imitating the relationship between
1170      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1171      * called.
1172      *
1173      * NOTE: This information is only used for _display_ purposes: it in
1174      * no way affects any of the arithmetic of the contract, including
1175      * {IERC20-balanceOf} and {IERC20-transfer}.
1176      */
1177     function decimals() public view returns (uint8) {
1178         return _decimals;
1179     }
1180 
1181     /**
1182      * @dev See {IERC20-totalSupply}.
1183      */
1184     function totalSupply() public view override returns (uint256) {
1185         return _totalSupply;
1186     }
1187 
1188     /**
1189      * @dev See {IERC20-balanceOf}.
1190      */
1191     function balanceOf(address account) public view override returns (uint256) {
1192         return _balances[account];
1193     }
1194 
1195     /**
1196      * @dev See {IERC20-transfer}.
1197      *
1198      * Requirements:
1199      *
1200      * - `recipient` cannot be the zero address.
1201      * - the caller must have a balance of at least `amount`.
1202      */
1203     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1204         _transfer(_msgSender(), recipient, amount);
1205         return true;
1206     }
1207 
1208     /**
1209      * @dev See {IERC20-allowance}.
1210      */
1211     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1212         return _allowances[owner][spender];
1213     }
1214 
1215     /**
1216      * @dev See {IERC20-approve}.
1217      *
1218      * Requirements:
1219      *
1220      * - `spender` cannot be the zero address.
1221      */
1222     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1223         _approve(_msgSender(), spender, amount);
1224         return true;
1225     }
1226 
1227     /**
1228      * @dev See {IERC20-transferFrom}.
1229      *
1230      * Emits an {Approval} event indicating the updated allowance. This is not
1231      * required by the EIP. See the note at the beginning of {ERC20};
1232      *
1233      * Requirements:
1234      * - `sender` and `recipient` cannot be the zero address.
1235      * - `sender` must have a balance of at least `amount`.
1236      * - the caller must have allowance for ``sender``'s tokens of at least
1237      * `amount`.
1238      */
1239     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1240         _transfer(sender, recipient, amount);
1241         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1242         return true;
1243     }
1244 
1245     /**
1246      * @dev Atomically increases the allowance granted to `spender` by the caller.
1247      *
1248      * This is an alternative to {approve} that can be used as a mitigation for
1249      * problems described in {IERC20-approve}.
1250      *
1251      * Emits an {Approval} event indicating the updated allowance.
1252      *
1253      * Requirements:
1254      *
1255      * - `spender` cannot be the zero address.
1256      */
1257     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1258         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1259         return true;
1260     }
1261 
1262     /**
1263      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1264      *
1265      * This is an alternative to {approve} that can be used as a mitigation for
1266      * problems described in {IERC20-approve}.
1267      *
1268      * Emits an {Approval} event indicating the updated allowance.
1269      *
1270      * Requirements:
1271      *
1272      * - `spender` cannot be the zero address.
1273      * - `spender` must have allowance for the caller of at least
1274      * `subtractedValue`.
1275      */
1276     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1277         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1278         return true;
1279     }
1280 
1281     /**
1282      * @dev Moves tokens `amount` from `sender` to `recipient`.
1283      *
1284      * This is internal function is equivalent to {transfer}, and can be used to
1285      * e.g. implement automatic token fees, slashing mechanisms, etc.
1286      *
1287      * Emits a {Transfer} event.
1288      *
1289      * Requirements:
1290      *
1291      * - `sender` cannot be the zero address.
1292      * - `recipient` cannot be the zero address.
1293      * - `sender` must have a balance of at least `amount`.
1294      */
1295     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1296         require(sender != address(0), "ERC20: transfer from the zero address");
1297         require(recipient != address(0), "ERC20: transfer to the zero address");
1298 
1299         _beforeTokenTransfer(sender, recipient, amount);
1300 
1301         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1302         _balances[recipient] = _balances[recipient].add(amount);
1303         emit Transfer(sender, recipient, amount);
1304     }
1305 
1306     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1307      * the total supply.
1308      *
1309      * Emits a {Transfer} event with `from` set to the zero address.
1310      *
1311      * Requirements
1312      *
1313      * - `to` cannot be the zero address.
1314      */
1315     function _mint(address account, uint256 amount) internal virtual {
1316         require(account != address(0), "ERC20: mint to the zero address");
1317 
1318         _beforeTokenTransfer(address(0), account, amount);
1319 
1320         _totalSupply = _totalSupply.add(amount);
1321         _balances[account] = _balances[account].add(amount);
1322         emit Transfer(address(0), account, amount);
1323     }
1324 
1325     /**
1326      * @dev Destroys `amount` tokens from `account`, reducing the
1327      * total supply.
1328      *
1329      * Emits a {Transfer} event with `to` set to the zero address.
1330      *
1331      * Requirements
1332      *
1333      * - `account` cannot be the zero address.
1334      * - `account` must have at least `amount` tokens.
1335      */
1336     function _burn(address account, uint256 amount) internal virtual {
1337         require(account != address(0), "ERC20: burn from the zero address");
1338 
1339         _beforeTokenTransfer(account, address(0), amount);
1340 
1341         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1342         _totalSupply = _totalSupply.sub(amount);
1343         emit Transfer(account, address(0), amount);
1344     }
1345 
1346     /**
1347      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1348      *
1349      * This is internal function is equivalent to `approve`, and can be used to
1350      * e.g. set automatic allowances for certain subsystems, etc.
1351      *
1352      * Emits an {Approval} event.
1353      *
1354      * Requirements:
1355      *
1356      * - `owner` cannot be the zero address.
1357      * - `spender` cannot be the zero address.
1358      */
1359     function _approve(address owner, address spender, uint256 amount) internal virtual {
1360         require(owner != address(0), "ERC20: approve from the zero address");
1361         require(spender != address(0), "ERC20: approve to the zero address");
1362 
1363         _allowances[owner][spender] = amount;
1364         emit Approval(owner, spender, amount);
1365     }
1366 
1367     /**
1368      * @dev Sets {decimals} to a value other than the default one of 18.
1369      *
1370      * WARNING: This function should only be called from the constructor. Most
1371      * applications that interact with token contracts will not expect
1372      * {decimals} to ever change, and may work incorrectly if it does.
1373      */
1374     function _setupDecimals(uint8 decimals_) internal {
1375         _decimals = decimals_;
1376     }
1377 
1378     /**
1379      * @dev Hook that is called before any transfer of tokens. This includes
1380      * minting and burning.
1381      *
1382      * Calling conditions:
1383      *
1384      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1385      * will be to transferred to `to`.
1386      * - when `from` is zero, `amount` tokens will be minted for `to`.
1387      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1388      * - `from` and `to` are never both zero.
1389      *
1390      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1391      */
1392     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1393 }
1394 
1395 // File: contracts/util/TransferETHInterface.sol
1396 
1397 
1398 
1399 
1400 interface TransferETHInterface {
1401     receive() external payable;
1402 
1403     event LogTransferETH(
1404         address indexed from,
1405         address indexed to,
1406         uint256 value
1407     );
1408 }
1409 
1410 // File: contracts/bondToken/BondTokenInterface.sol
1411 
1412 
1413 
1414 
1415 
1416 
1417 interface BondTokenInterface is TransferETHInterface, IERC20 {
1418     event LogExpire(
1419         uint128 rateNumerator,
1420         uint128 rateDenominator,
1421         bool firstTime
1422     );
1423 
1424     function mint(address account, uint256 amount)
1425         external
1426         returns (bool success);
1427 
1428     function expire(uint128 rateNumerator, uint128 rateDenominator)
1429         external
1430         returns (bool firstTime);
1431 
1432     function burn(uint256 amount) external returns (bool success);
1433 
1434     function burnAll() external returns (uint256 amount);
1435 
1436     function isMinter(address account) external view returns (bool minter);
1437 
1438     function getRate()
1439         external
1440         view
1441         returns (uint128 rateNumerator, uint128 rateDenominator);
1442 }
1443 
1444 // File: contracts/fairswap/Libraries/Enums.sol
1445 
1446 
1447 
1448 enum Token {TOKEN0, TOKEN1}
1449 
1450 // FLEX_0_1 => Swap TOKEN0 to TOKEN1, slippage is tolerate to 5%
1451 // FLEX_1_0 => Swap TOKEN1 to TOKEN0, slippage is tolerate to 5%
1452 // STRICT_0_1 => Swap TOKEN0 to TOKEN1, slippage is limited in 0.1%
1453 // STRICT_1_0 => Swap TOKEN1 to TOKEN0, slippage is limited in 0.1%
1454 enum OrderType {FLEX_0_1, FLEX_1_0, STRICT_0_1, STRICT_1_0}
1455 
1456 
1457 library TokenLibrary {
1458     function another(Token self) internal pure returns (Token) {
1459         if (self == Token.TOKEN0) {
1460             return Token.TOKEN1;
1461         } else {
1462             return Token.TOKEN0;
1463         }
1464     }
1465 }
1466 
1467 
1468 library OrderTypeLibrary {
1469     function inToken(OrderType self) internal pure returns (Token) {
1470         if (self == OrderType.FLEX_0_1 || self == OrderType.STRICT_0_1) {
1471             return Token.TOKEN0;
1472         } else {
1473             return Token.TOKEN1;
1474         }
1475     }
1476 
1477     function isFlex(OrderType self) internal pure returns (bool) {
1478         return self == OrderType.FLEX_0_1 || self == OrderType.FLEX_1_0;
1479     }
1480 
1481     function isStrict(OrderType self) internal pure returns (bool) {
1482         return !isFlex(self);
1483     }
1484 
1485     function next(OrderType self) internal pure returns (OrderType) {
1486         return OrderType((uint256(self) + 1) % 4);
1487     }
1488 
1489     function isBuy(OrderType self) internal pure returns (bool) {
1490         return (self == OrderType.FLEX_0_1 || self == OrderType.STRICT_0_1);
1491     }
1492 }
1493 
1494 // File: contracts/fairswap/BoxExchangeInterface.sol
1495 
1496 
1497 interface BoxExchangeInterface {
1498     event AcceptOrders(
1499         address indexed recipient,
1500         bool indexed isBuy, // if true, this order is exchange from TOKEN0 to TOKEN1
1501         uint32 indexed boxNumber,
1502         bool isLimit, // if true, this order is STRICT order
1503         uint256 tokenIn
1504     );
1505 
1506     event MoveLiquidity(
1507         address indexed liquidityProvider,
1508         bool indexed isAdd, // if true, this order is addtion of liquidity
1509         uint256 movedToken0Amount,
1510         uint256 movedToken1Amount,
1511         uint256 sharesMoved // Amount of share that is minted or burned
1512     );
1513 
1514     event Execution(
1515         bool indexed isBuy, // if true, this order is exchange from TOKEN0 to TOKEN1
1516         uint32 indexed boxNumber,
1517         address indexed recipient,
1518         uint256 orderAmount, // Amount of token that is transferred when this order is added
1519         uint256 refundAmount, // In the same token as orderAmount
1520         uint256 outAmount // In the other token than orderAmount
1521     );
1522 
1523     event UpdateReserve(uint128 reserve0, uint128 reserve1, uint256 totalShare);
1524 
1525     event PayMarketFee(uint256 amount0, uint256 amount1);
1526 
1527     event ExecutionSummary(
1528         uint32 indexed boxNumber,
1529         uint8 partiallyRefundOrderType,
1530         uint256 rate,
1531         uint256 partiallyRefundRate,
1532         uint256 totalInAmountFLEX_0_1,
1533         uint256 totalInAmountFLEX_1_0,
1534         uint256 totalInAmountSTRICT_0_1,
1535         uint256 totalInAmountSTRICT_1_0
1536     );
1537 
1538     function marketFeePool0() external view returns (uint128);
1539 
1540     function marketFeePool1() external view returns (uint128);
1541 
1542     /**
1543      * @notice Shows how many boxes and orders exist before the specific order
1544      * @dev If this order does not exist, return (false, 0, 0)
1545      * @dev If this order is already executed, return (true, 0, 0)
1546      * @param recipient Recipient of this order
1547      * @param boxNumber Box ID where the order exists
1548      * @param isExecuted If true, the order is already executed
1549      * @param boxCount Counter of boxes before this order. If current executing box number is the same as boxNumber, return 1 (i.e. indexing starts from 1)
1550      * @param orderCount Counter of orders before this order. If this order is on n-th top of the queue, return n (i.e. indexing starts from 1)
1551      **/
1552     function whenToExecute(
1553         address recipient,
1554         uint256 boxNumber,
1555         bool isBuy,
1556         bool isLimit
1557     )
1558         external
1559         view
1560         returns (
1561             bool isExecuted,
1562             uint256 boxCount,
1563             uint256 orderCount
1564         );
1565 
1566     /**
1567      * @notice Returns summary of current exchange status
1568      * @param boxNumber Current open box ID
1569      * @param _reserve0 Current reserve of TOKEN0
1570      * @param _reserve1 Current reserve of TOKEN1
1571      * @param totalShare Total Supply of share token
1572      * @param latestSpreadRate Spread Rate in latest OrderBox
1573      * @param token0PerShareE18 Amount of TOKEN0 per 1 share token and has 18 decimal
1574      * @param token1PerShareE18 Amount of TOKEN1 per 1 share token and has 18 decimal
1575      **/
1576     function getExchangeData()
1577         external
1578         view
1579         returns (
1580             uint256 boxNumber,
1581             uint256 _reserve0,
1582             uint256 _reserve1,
1583             uint256 totalShare,
1584             uint256 latestSpreadRate,
1585             uint256 token0PerShareE18,
1586             uint256 token1PerShareE18
1587         );
1588 
1589     /**
1590      * @notice Gets summary of Current box information (Total order amount of each OrderTypes)
1591      * @param executionStatusNumber Status of execution of this box
1592      * @param boxNumber ID of target box.
1593      **/
1594     function getBoxSummary(uint256 boxNumber)
1595         external
1596         view
1597         returns (
1598             uint256 executionStatusNumber,
1599             uint256 flexToken0InAmount,
1600             uint256 strictToken0InAmount,
1601             uint256 flexToken1InAmount,
1602             uint256 strictToken1InAmount
1603         );
1604 
1605     /**
1606      * @notice Gets amount of order in current open box
1607      * @param account Target Address
1608      * @param orderType OrderType of target order
1609      * @return Amount of target order
1610      **/
1611     function getOrderAmount(address account, OrderType orderType)
1612         external
1613         view
1614         returns (uint256);
1615 
1616     /**
1617      * @param IDOLAmount Amount of initial liquidity of iDOL to be provided
1618      * @param settlementTokenAmount Amount of initial liquidity of the other token to be provided
1619      * @param initialShare Initial amount of share token
1620      **/
1621     function initializeExchange(
1622         uint256 IDOLAmount,
1623         uint256 settlementTokenAmount,
1624         uint256 initialShare
1625     ) external;
1626 
1627     /**
1628      * @param timeout Revert if nextBoxNumber exceeds `timeout`
1629      * @param recipient Recipient of swapped token. If `recipient` == address(0), recipient is msg.sender
1630      * @param IDOLAmount Amount of token that should be approved before executing this function
1631      * @param isLimit Whether the order restricts a large slippage
1632      * @dev if isLimit is true and reserve0/reserve1 * 1.001 >  `rate`, the order will be executed, otherwise token will be refunded
1633      * @dev if isLimit is false and reserve0/reserve1 * 1.05 > `rate`, the order will be executed, otherwise token will be refunded
1634      **/
1635     function orderBaseToSettlement(
1636         uint256 timeout,
1637         address recipient,
1638         uint256 IDOLAmount,
1639         bool isLimit
1640     ) external;
1641 
1642     /**
1643      * @param timeout Revert if nextBoxNumber exceeds `timeout`
1644      * @param recipient Recipient of swapped token. If `recipient` == address(0), recipient is msg.sender
1645      * @param settlementTokenAmount Amount of token that should be approved before executing this function
1646      * @param isLimit Whether the order restricts a large slippage
1647      * @dev if isLimit is true and reserve0/reserve1 * 0.999 > `rate`, the order will be executed, otherwise token will be refunded
1648      * @dev if isLimit is false and reserve0/reserve1 * 0.95 > `rate`, the order will be executed, otherwise token will be refunded
1649      **/
1650     function orderSettlementToBase(
1651         uint256 timeout,
1652         address recipient,
1653         uint256 settlementTokenAmount,
1654         bool isLimit
1655     ) external;
1656 
1657     /**
1658      * @notice LP provides liquidity and receives share token
1659      * @param timeout Revert if nextBoxNumber exceeds `timeout`
1660      * @param IDOLAmount Amount of iDOL to be provided. The amount of the other token required is calculated based on this amount
1661      * @param minShares Minimum amount of share token LP will receive. If amount of share token is less than `minShares`, revert the transaction
1662      **/
1663     function addLiquidity(
1664         uint256 timeout,
1665         uint256 IDOLAmount,
1666         uint256 settlementTokenAmount,
1667         uint256 minShares
1668     ) external;
1669 
1670     /**
1671      * @notice LP burns share token and receives iDOL and the other token
1672      * @param timeout Revert if nextBoxNumber exceeds `timeout`
1673      * @param minBaseTokens Minimum amount of iDOL LP will receive. If amount of iDOL is less than `minBaseTokens`, revert the transaction
1674      * @param minSettlementTokens Minimum amount of the other token LP will get. If amount is less than `minSettlementTokens`, revert the transaction
1675      * @param sharesBurned Amount of share token to be burned
1676      **/
1677     function removeLiquidity(
1678         uint256 timeout,
1679         uint256 minBaseTokens,
1680         uint256 minSettlementTokens,
1681         uint256 sharesBurned
1682     ) external;
1683 
1684     /**
1685      * @notice Executes orders that are unexecuted
1686      * @param maxOrderNum Max number of orders to be executed
1687      **/
1688     function executeUnexecutedBox(uint8 maxOrderNum) external;
1689 
1690     function sendMarketFeeToLien() external;
1691 }
1692 
1693 // File: contracts/Wrapper.sol
1694 
1695 // solium-disable security/no-low-level-calls
1696 
1697 contract Wrapper is
1698     DeployerRole,
1699     UseSafeMath,
1700     UseOracle,
1701     UseBondMaker,
1702     UseStableCoin,
1703     WrapperInterface
1704 {
1705     LBTExchangeFactoryInterface internal _exchangeLBTAndIDOLFactoryContract;
1706 
1707     modifier isNotEmptyExchangeInstance() {
1708         require(
1709             address(_exchangeLBTAndIDOLFactoryContract) != address(0),
1710             "the exchange contract is not set"
1711         );
1712         _;
1713     }
1714 
1715     constructor(
1716         address oracleAddress,
1717         address bondMakerAddress,
1718         address IDOLAddress,
1719         address exchangeLBTAndIDOLFactoryAddress
1720     )
1721         public
1722         UseOracle(oracleAddress)
1723         UseBondMaker(bondMakerAddress)
1724         UseStableCoin(IDOLAddress)
1725     {
1726         _setExchangeLBTAndIDOLFactory(exchangeLBTAndIDOLFactoryAddress);
1727     }
1728 
1729     function setExchangeLBTAndIDOLFactory(address contractAddress)
1730         public
1731         onlyDeployer
1732     {
1733         require(
1734             address(_exchangeLBTAndIDOLFactoryContract) == address(0),
1735             "contract has already given"
1736         );
1737         require(
1738             contractAddress != address(0),
1739             "contract should be non-zero address"
1740         );
1741         _setExchangeLBTAndIDOLFactory(contractAddress);
1742     }
1743 
1744     function _setExchangeLBTAndIDOLFactory(address contractAddress) internal {
1745         _exchangeLBTAndIDOLFactoryContract = LBTExchangeFactoryInterface(
1746             contractAddress
1747         );
1748     }
1749 
1750     function exchangeLBTAndIDOLFactoryAddress() public view returns (address) {
1751         return address(_exchangeLBTAndIDOLFactoryContract);
1752     }
1753 
1754     function registerBondAndBondGroup(bytes[] memory fnMaps, uint256 maturity)
1755         public
1756         override
1757         returns (bool)
1758     {
1759         bytes32[] memory bondIDs = new bytes32[](fnMaps.length);
1760         for (uint256 j = 0; j < fnMaps.length; j++) {
1761             bytes32 bondID = _bondMakerContract.generateBondID(
1762                 maturity,
1763                 fnMaps[j]
1764             );
1765             (address bondAddress, , , ) = _bondMakerContract.getBond(bondID);
1766             if (bondAddress == address(0)) {
1767                 (bytes32 returnedBondID, , , ) = _bondMakerContract
1768                     .registerNewBond(maturity, fnMaps[j]);
1769                 require(
1770                     returnedBondID == bondID,
1771                     "system error: bondID was not generated as expected"
1772                 );
1773             }
1774             bondIDs[j] = bondID;
1775         }
1776 
1777         uint256 bondGroupID = _bondMakerContract.registerNewBondGroup(
1778             bondIDs,
1779             maturity
1780         );
1781         emit LogRegisterBondAndBondGroup(bondGroupID, bondIDs);
1782     }
1783 
1784     /**
1785      * @param solidBondID is a solid bond ID
1786      * @param SBTAmount is solid bond token amount
1787      * @return poolID is a pool ID
1788      * @return IDOLAmount is iDOL amount obtained
1789      */
1790     function _swapSBT2IDOL(
1791         bytes32 solidBondID,
1792         address SBTAddress,
1793         uint256 SBTAmount
1794     ) internal returns (bytes32 poolID, uint256 IDOLAmount) {
1795         // 1. approve
1796         ERC20(SBTAddress).approve(address(_IDOLContract), SBTAmount);
1797 
1798         // 2. mint (SBT -> iDOL)
1799         (poolID, IDOLAmount, ) = _IDOLContract.mint(
1800             solidBondID,
1801             msg.sender,
1802             SBTAmount.toUint64()
1803         );
1804 
1805         emit LogIssueIDOL(solidBondID, msg.sender, poolID, IDOLAmount);
1806         return (poolID, IDOLAmount);
1807     }
1808 
1809     /**
1810      * @notice swap (LBT -> iDOL)
1811      * @param LBTAddress is liquid bond token contract address
1812      * @param LBTAmount is liquid bond amount
1813      * @param timeout (uniswap)
1814      * @param isLimit (uniswap)
1815      */
1816     function _swapLBT2IDOL(
1817         address LBTAddress,
1818         uint256 LBTAmount,
1819         uint256 timeout,
1820         bool isLimit
1821     ) internal isNotEmptyExchangeInstance {
1822         address _boxExchangeAddress = _exchangeLBTAndIDOLFactoryContract
1823             .addressToExchangeLookup(LBTAddress);
1824         // 1. approve
1825         ERC20(LBTAddress).approve(_boxExchangeAddress, LBTAmount);
1826 
1827         // 2. order(exchange)
1828         BoxExchangeInterface exchange = BoxExchangeInterface(
1829             _boxExchangeAddress
1830         );
1831         exchange.orderSettlementToBase(timeout, msg.sender, LBTAmount, isLimit);
1832     }
1833 
1834     /**
1835      * @notice swap (iDOL -> LBT)
1836      * @param LBTAddress is liquid bond token contract address
1837      * @param IDOLAmount is iDOL amount
1838      * @param timeout (uniswap)
1839      * @param isLimit (uniswap)
1840      */
1841     function _swapIDOL2LBT(
1842         address LBTAddress,
1843         uint256 IDOLAmount,
1844         uint256 timeout,
1845         bool isLimit
1846     ) internal isNotEmptyExchangeInstance {
1847         address _boxExchangeAddress = _exchangeLBTAndIDOLFactoryContract
1848             .addressToExchangeLookup(LBTAddress);
1849 
1850         // 1. approve
1851         _IDOLContract.transferFrom(msg.sender, address(this), IDOLAmount);
1852         _IDOLContract.approve(_boxExchangeAddress, IDOLAmount);
1853 
1854         // 2. order(exchange)
1855         BoxExchangeInterface exchange = BoxExchangeInterface(
1856             _boxExchangeAddress
1857         );
1858         exchange.orderBaseToSettlement(
1859             timeout,
1860             msg.sender,
1861             IDOLAmount,
1862             isLimit
1863         );
1864     }
1865 
1866     /**
1867      * @notice swap (SBT -> LBT)
1868      * @param solidBondID is a solid bond ID
1869      * @param liquidBondID is a liquid bond ID
1870      * @param timeout (uniswap)
1871      * @param isLimit (uniswap)
1872      */
1873     function swapSBT2LBT(
1874         bytes32 solidBondID,
1875         bytes32 liquidBondID,
1876         uint256 SBTAmount,
1877         uint256 timeout,
1878         bool isLimit
1879     ) public override {
1880         (address SBTAddress, , , ) = _bondMakerContract.getBond(solidBondID);
1881         require(SBTAddress != address(0), "the bond is not registered");
1882 
1883         // uses: SBT
1884         _usesERC20(SBTAddress, SBTAmount);
1885 
1886         // 1. SBT -> LBT(exchange)
1887         _swapSBT2LBT(
1888             solidBondID,
1889             SBTAddress,
1890             liquidBondID,
1891             SBTAmount,
1892             timeout,
1893             isLimit
1894         );
1895     }
1896 
1897     function _swapSBT2LBT(
1898         bytes32 solidBondID,
1899         address SBTAddress,
1900         bytes32 liquidBondID,
1901         uint256 SBTAmount,
1902         uint256 timeout,
1903         bool isLimit
1904     ) internal {
1905         // 1. swap SBT -> IDOL)
1906         (, uint256 IDOLAmount) = _swapSBT2IDOL(
1907             solidBondID,
1908             SBTAddress,
1909             SBTAmount
1910         );
1911 
1912         // 2. swap IDOL -> LBT(exchange)
1913         (address LBTAddress, , , ) = _bondMakerContract.getBond(liquidBondID);
1914         require(LBTAddress != address(0), "the bond is not registered");
1915 
1916         _swapIDOL2LBT(LBTAddress, IDOLAmount, timeout, isLimit);
1917     }
1918 
1919     /**
1920      * @notice find a solid bond in given bond group
1921      * @param bondGroupID is a bond group ID
1922      */
1923     function _findSBTAndLBTBondGroup(uint256 bondGroupID)
1924         internal
1925         view
1926         returns (bytes32 solidBondID, bytes32[] memory liquidBondIDs)
1927     {
1928         (bytes32[] memory bondIDs, ) = _bondMakerContract.getBondGroup(
1929             bondGroupID
1930         );
1931         bytes32 solidID = bytes32(0);
1932         bytes32[] memory liquidIDs = new bytes32[](bondIDs.length - 1);
1933         uint256 j = 0;
1934         for (uint256 i = 0; i < bondIDs.length; i++) {
1935             (, , uint256 solidStrikePrice, ) = _bondMakerContract.getBond(
1936                 bondIDs[i]
1937             );
1938             if (solidStrikePrice != 0) {
1939                 // A solid bond is found.
1940                 solidID = bondIDs[i];
1941             } else {
1942                 liquidIDs[j++] = bondIDs[i];
1943             }
1944         }
1945         return (solidID, liquidIDs);
1946     }
1947 
1948     function _usesERC20(address erc20Address, uint256 amount) internal {
1949         ERC20 erc20Contract = ERC20(erc20Address);
1950         erc20Contract.transferFrom(msg.sender, address(this), amount);
1951     }
1952 
1953     function _reductionERC20(address erc20Address, uint256 amount) internal {
1954         ERC20 erc20Contract = ERC20(erc20Address);
1955         erc20Contract.transfer(msg.sender, amount);
1956     }
1957 
1958     function _findBondAddressListInBondGroup(uint256 bondGroupID)
1959         internal
1960         view
1961         returns (address[] memory bondAddressList)
1962     {
1963         (bytes32[] memory bondIDs, ) = _bondMakerContract.getBondGroup(
1964             bondGroupID
1965         );
1966         address[] memory bondAddreses = new address[](bondIDs.length);
1967         for (uint256 i = 0; i < bondIDs.length; i++) {
1968             (address bondTokenAddress, , , ) = _bondMakerContract.getBond(
1969                 bondIDs[i]
1970             );
1971             bondAddreses[i] = bondTokenAddress;
1972         }
1973         return bondAddreses;
1974     }
1975 
1976     /**
1977      * @notice ETH -> LBT & iDOL
1978      * @param bondGroupID is a bond group ID
1979      * @return poolID is a pool ID
1980      * @return IDOLAmount is iDOL amount obtained
1981      */
1982     function issueLBTAndIDOL(uint256 bondGroupID)
1983         public
1984         override
1985         payable
1986         returns (
1987             bytes32,
1988             uint256,
1989             uint256
1990         )
1991     {
1992         (
1993             bytes32 solidBondID,
1994             bytes32[] memory liquidBondIDs
1995         ) = _findSBTAndLBTBondGroup(bondGroupID); // find SBT & LBT
1996         require(
1997             solidBondID != bytes32(0),
1998             "solid bond is not found in given bond group"
1999         );
2000 
2001         // 1. ETH -> SBT & LBTs
2002         uint256 bondAmount = _bondMakerContract.issueNewBonds{value: msg.value}(
2003             bondGroupID
2004         );
2005 
2006         // 2. SBT -> IDOL
2007         (address SBTAddress, , , ) = _bondMakerContract.getBond(solidBondID);
2008         (bytes32 poolID, uint256 IDOLAmount) = _swapSBT2IDOL(
2009             solidBondID,
2010             SBTAddress,
2011             bondAmount
2012         );
2013 
2014         // 3. IDOL reduction.
2015         //_reductionERC20(address(_IDOLContract), IDOLAmount);
2016 
2017         // 4. LBTs reduction.
2018         for (uint256 i = 0; i < liquidBondIDs.length; i++) {
2019             (address liquidAddress, , , ) = _bondMakerContract.getBond(
2020                 liquidBondIDs[i]
2021             );
2022             _reductionERC20(liquidAddress, bondAmount);
2023             LogIssueLBT(liquidBondIDs[i], msg.sender, bondAmount);
2024         }
2025         return (poolID, bondAmount, IDOLAmount);
2026     }
2027 
2028     /**
2029      * @notice ETH -> iDOL
2030      * @param bondGroupID is a bond group ID
2031      * @param timeout (uniswap)
2032      * @param isLimit (uniswap)
2033      */
2034     function issueIDOLOnly(
2035         uint256 bondGroupID,
2036         uint256 timeout,
2037         bool isLimit
2038     ) public override payable {
2039         // 0. uses: ETH
2040         (
2041             bytes32 solidBondID,
2042             bytes32[] memory liquidBondIDs
2043         ) = _findSBTAndLBTBondGroup(bondGroupID); // find SBT & LBT
2044         require(
2045             solidBondID != bytes32(0),
2046             "solid bond is not found in given bond group"
2047         );
2048 
2049         // 1. ETH -> SBT & LBTs
2050         uint256 bondAmount = _bondMakerContract.issueNewBonds{value: msg.value}(
2051             bondGroupID
2052         );
2053 
2054         // 2. SBT -> IDOL
2055         (address SBTAddress, , , ) = _bondMakerContract.getBond(solidBondID);
2056         _swapSBT2IDOL(solidBondID, SBTAddress, bondAmount);
2057 
2058         // 3. IDOL reduction.
2059         //_reductionERC20(address(_IDOLContract), IDOLAmount);
2060 
2061         // 4. LBTs -> IDOL(+exchange)
2062         for (uint256 i = 0; i < liquidBondIDs.length; i++) {
2063             (address liquidAddress, , , ) = _bondMakerContract.getBond(
2064                 liquidBondIDs[i]
2065             );
2066             // LBT -> IDOL(+exchange)
2067             _swapLBT2IDOL(liquidAddress, bondAmount, timeout, isLimit);
2068         }
2069     }
2070 
2071     /**
2072      * @notice ETH -> LBT
2073      * @param bondGroupID is a bond group ID
2074      * @param liquidBondID is a liquid bond ID
2075      * @param timeout (uniswap)
2076      * @param isLimit (uniswap)
2077      */
2078     function issueLBTOnly(
2079         uint256 bondGroupID,
2080         bytes32 liquidBondID,
2081         uint256 timeout,
2082         bool isLimit
2083     ) public override payable {
2084         (
2085             bytes32 solidBondID,
2086             bytes32[] memory liquidBondIDs
2087         ) = _findSBTAndLBTBondGroup(bondGroupID); // find SBT & LBT
2088         require(
2089             solidBondID != bytes32(0),
2090             "solid bond is not found in given bond group"
2091         );
2092 
2093         // 1. ETH -> SBT & LBTs
2094         uint256 bondAmount = _bondMakerContract.issueNewBonds{value: msg.value}(
2095             bondGroupID
2096         );
2097 
2098         // 2. SBT -> IDOL
2099         (address SBTAddress, , , ) = _bondMakerContract.getBond(solidBondID);
2100         (, uint256 IDOLAmount) = _swapSBT2IDOL(
2101             solidBondID,
2102             SBTAddress,
2103             bondAmount
2104         );
2105 
2106         // 3. IDOL -> LBT(+exchange)
2107         (address LBTAddress, , , ) = _bondMakerContract.getBond(liquidBondID);
2108         _swapIDOL2LBT(LBTAddress, IDOLAmount, timeout, isLimit);
2109 
2110         // 4. LBTs reduction
2111         for (uint256 i = 0; i < liquidBondIDs.length; i++) {
2112             (address liquidAddress, , , ) = _bondMakerContract.getBond(
2113                 liquidBondIDs[i]
2114             );
2115             _reductionERC20(liquidAddress, bondAmount);
2116             LogIssueLBT(liquidBondIDs[i], msg.sender, bondAmount);
2117         }
2118     }
2119 }