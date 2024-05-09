1 pragma solidity 0.6.6;
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
4 
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
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
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      */
114     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         // Solidity only automatically asserts when dividing by 0
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
125      * Reverts when dividing by zero.
126      *
127      * Counterpart to Solidity's `%` operator. This function uses a `revert`
128      * opcode (which leaves remaining gas untouched) while Solidity uses an
129      * invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         return mod(a, b, "SafeMath: modulo by zero");
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts with custom message when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b != 0, errorMessage);
151         return a % b;
152     }
153 }
154 
155 // File: @openzeppelin/contracts/math/SignedSafeMath.sol
156 
157 
158 
159 /**
160  * @title SignedSafeMath
161  * @dev Signed math operations with safety checks that revert on error.
162  */
163 library SignedSafeMath {
164     int256 constant private _INT256_MIN = -2**255;
165 
166     /**
167      * @dev Multiplies two signed integers, reverts on overflow.
168      */
169     function mul(int256 a, int256 b) internal pure returns (int256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
178 
179         int256 c = a * b;
180         require(c / a == b, "SignedSafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
187      */
188     function div(int256 a, int256 b) internal pure returns (int256) {
189         require(b != 0, "SignedSafeMath: division by zero");
190         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
191 
192         int256 c = a / b;
193 
194         return c;
195     }
196 
197     /**
198      * @dev Subtracts two signed integers, reverts on overflow.
199      */
200     function sub(int256 a, int256 b) internal pure returns (int256) {
201         int256 c = a - b;
202         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Adds two signed integers, reverts on overflow.
209      */
210     function add(int256 a, int256 b) internal pure returns (int256) {
211         int256 c = a + b;
212         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
213 
214         return c;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/SafeCast.sol
219 
220 
221 
222 
223 /**
224  * @dev Wrappers over Solidity's uintXX casting operators with added overflow
225  * checks.
226  *
227  * Downcasting from uint256 in Solidity does not revert on overflow. This can
228  * easily result in undesired exploitation or bugs, since developers usually
229  * assume that overflows raise errors. `SafeCast` restores this intuition by
230  * reverting the transaction when such an operation overflows.
231  *
232  * Using this library instead of the unchecked operations eliminates an entire
233  * class of bugs, so it's recommended to use it always.
234  *
235  * Can be combined with {SafeMath} to extend it to smaller types, by performing
236  * all math on `uint256` and then downcasting.
237  */
238 library SafeCast {
239 
240     /**
241      * @dev Returns the downcasted uint128 from uint256, reverting on
242      * overflow (when the input is greater than largest uint128).
243      *
244      * Counterpart to Solidity's `uint128` operator.
245      *
246      * Requirements:
247      *
248      * - input must fit into 128 bits
249      */
250     function toUint128(uint256 value) internal pure returns (uint128) {
251         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
252         return uint128(value);
253     }
254 
255     /**
256      * @dev Returns the downcasted uint64 from uint256, reverting on
257      * overflow (when the input is greater than largest uint64).
258      *
259      * Counterpart to Solidity's `uint64` operator.
260      *
261      * Requirements:
262      *
263      * - input must fit into 64 bits
264      */
265     function toUint64(uint256 value) internal pure returns (uint64) {
266         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
267         return uint64(value);
268     }
269 
270     /**
271      * @dev Returns the downcasted uint32 from uint256, reverting on
272      * overflow (when the input is greater than largest uint32).
273      *
274      * Counterpart to Solidity's `uint32` operator.
275      *
276      * Requirements:
277      *
278      * - input must fit into 32 bits
279      */
280     function toUint32(uint256 value) internal pure returns (uint32) {
281         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
282         return uint32(value);
283     }
284 
285     /**
286      * @dev Returns the downcasted uint16 from uint256, reverting on
287      * overflow (when the input is greater than largest uint16).
288      *
289      * Counterpart to Solidity's `uint16` operator.
290      *
291      * Requirements:
292      *
293      * - input must fit into 16 bits
294      */
295     function toUint16(uint256 value) internal pure returns (uint16) {
296         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
297         return uint16(value);
298     }
299 
300     /**
301      * @dev Returns the downcasted uint8 from uint256, reverting on
302      * overflow (when the input is greater than largest uint8).
303      *
304      * Counterpart to Solidity's `uint8` operator.
305      *
306      * Requirements:
307      *
308      * - input must fit into 8 bits.
309      */
310     function toUint8(uint256 value) internal pure returns (uint8) {
311         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
312         return uint8(value);
313     }
314 
315     /**
316      * @dev Converts a signed int256 into an unsigned uint256.
317      *
318      * Requirements:
319      *
320      * - input must be greater than or equal to 0.
321      */
322     function toUint256(int256 value) internal pure returns (uint256) {
323         require(value >= 0, "SafeCast: value must be positive");
324         return uint256(value);
325     }
326 
327     /**
328      * @dev Converts an unsigned uint256 into a signed int256.
329      *
330      * Requirements:
331      *
332      * - input must be less than or equal to maxInt256.
333      */
334     function toInt256(uint256 value) internal pure returns (int256) {
335         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
336         return int256(value);
337     }
338 }
339 
340 // File: contracts/math/UseSafeMath.sol
341 
342 
343 
344 
345 
346 
347 
348 /**
349  * @notice ((a - 1) / b) + 1 = (a + b -1) / b
350  * for example a.add(10**18 -1).div(10**18) = a.sub(1).div(10**18) + 1
351  */
352 
353 library SafeMathDivRoundUp {
354     using SafeMath for uint256;
355 
356     function divRoundUp(
357         uint256 a,
358         uint256 b,
359         string memory errorMessage
360     ) internal pure returns (uint256) {
361         if (a == 0) {
362             return 0;
363         }
364         require(b > 0, errorMessage);
365         return ((a - 1) / b) + 1;
366     }
367 
368     function divRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {
369         return divRoundUp(a, b, "SafeMathDivRoundUp: modulo by zero");
370     }
371 }
372 
373 
374 /**
375  * @title UseSafeMath
376  * @dev One can use SafeMath for not only uint256 but also uin64 or uint16,
377  * and also can use SafeCast for uint256.
378  * For example:
379  *   uint64 a = 1;
380  *   uint64 b = 2;
381  *   a = a.add(b).toUint64() // `a` become 3 as uint64
382  * In additionally, one can use SignedSafeMath and SafeCast.toUint256(int256) for int256.
383  * In the case of the operation to the uint64 value, one need to cast the value into int256 in
384  * advance to use `sub` as SignedSafeMath.sub not SafeMath.sub.
385  * For example:
386  *   int256 a = 1;
387  *   uint64 b = 2;
388  *   int256 c = 3;
389  *   a = a.add(int256(b).sub(c)); // `a` become 0 as int256
390  *   b = a.toUint256().toUint64(); // `b` become 0 as uint64
391  */
392 abstract contract UseSafeMath {
393     using SafeMath for uint256;
394     using SafeMathDivRoundUp for uint256;
395     using SafeMath for uint64;
396     using SafeMathDivRoundUp for uint64;
397     using SafeMath for uint16;
398     using SignedSafeMath for int256;
399     using SafeCast for uint256;
400     using SafeCast for int256;
401 }
402 
403 // File: contracts/BondMakerInterface.sol
404 
405 
406 
407 
408 interface BondMakerInterface {
409     event LogNewBond(
410         bytes32 indexed bondID,
411         address bondTokenAddress,
412         uint64 stableStrikePrice,
413         bytes32 fnMapID
414     );
415 
416     event LogNewBondGroup(uint256 indexed bondGroupID);
417 
418     event LogIssueNewBonds(
419         uint256 indexed bondGroupID,
420         address indexed issuer,
421         uint256 amount
422     );
423 
424     event LogReverseBondToETH(
425         uint256 indexed bondGroupID,
426         address indexed owner,
427         uint256 amount
428     );
429 
430     event LogExchangeEquivalentBonds(
431         address indexed owner,
432         uint256 indexed inputBondGroupID,
433         uint256 indexed outputBondGroupID,
434         uint256 amount
435     );
436 
437     event LogTransferETH(
438         address indexed from,
439         address indexed to,
440         uint256 value
441     );
442 
443     function registerNewBond(uint256 maturity, bytes calldata fnMap)
444         external
445         returns (
446             bytes32 bondID,
447             address bondTokenAddress,
448             uint64 solidStrikePrice,
449             bytes32 fnMapID
450         );
451 
452     function registerNewBondGroup(
453         bytes32[] calldata bondIDList,
454         uint256 maturity
455     ) external returns (uint256 bondGroupID);
456 
457     function issueNewBonds(uint256 bondGroupID)
458         external
459         payable
460         returns (uint256 amount);
461 
462     function reverseBondToETH(uint256 bondGroupID, uint256 amount)
463         external
464         returns (bool success);
465 
466     function exchangeEquivalentBonds(
467         uint256 inputBondGroupID,
468         uint256 outputBondGroupID,
469         uint256 amount,
470         bytes32[] calldata exceptionBonds
471     ) external returns (bool);
472 
473     function liquidateBond(uint256 bondGroupID, uint256 oracleHintID) external;
474 
475     function getBond(bytes32 bondID)
476         external
477         view
478         returns (
479             address bondAddress,
480             uint256 maturity,
481             uint64 solidStrikePrice,
482             bytes32 fnMapID
483         );
484 
485     function getFnMap(bytes32 fnMapID)
486         external
487         view
488         returns (bytes memory fnMap);
489 
490     function getBondGroup(uint256 bondGroupID)
491         external
492         view
493         returns (bytes32[] memory bondIDs, uint256 maturity);
494 
495     function generateBondID(uint256 maturity, bytes calldata functionHash)
496         external
497         pure
498         returns (bytes32 bondID);
499 }
500 
501 // File: contracts/util/Time.sol
502 
503 
504 
505 
506 abstract contract Time {
507     function _getBlockTimestampSec()
508         internal
509         view
510         returns (uint256 unixtimesec)
511     {
512         unixtimesec = now; // solium-disable-line security/no-block-members
513     }
514 }
515 
516 // File: contracts/util/TransferETHInterface.sol
517 
518 
519 
520 
521 interface TransferETHInterface {
522     receive() external payable;
523 
524     event LogTransferETH(
525         address indexed from,
526         address indexed to,
527         uint256 value
528     );
529 }
530 
531 // File: contracts/util/TransferETH.sol
532 
533 
534 
535 
536 
537 abstract contract TransferETH is TransferETHInterface {
538     receive() external override payable {
539         emit LogTransferETH(msg.sender, address(this), msg.value);
540     }
541 
542     function _hasSufficientBalance(uint256 amount)
543         internal
544         view
545         returns (bool ok)
546     {
547         address thisContract = address(this);
548         return amount <= thisContract.balance;
549     }
550 
551     /**
552      * @notice transfer `amount` ETH to the `recipient` account with emitting log
553      */
554     function _transferETH(
555         address payable recipient,
556         uint256 amount,
557         string memory errorMessage
558     ) internal {
559         require(_hasSufficientBalance(amount), errorMessage);
560         (bool success, ) = recipient.call{value: amount}("");
561         require(success, "transferring Ether failed");
562         emit LogTransferETH(address(this), recipient, amount);
563     }
564 
565     function _transferETH(address payable recipient, uint256 amount) internal {
566         _transferETH(
567             recipient,
568             amount,
569             "TransferETH: transfer amount exceeds balance"
570         );
571     }
572 }
573 
574 // File: @openzeppelin/contracts/GSN/Context.sol
575 
576 
577 
578 /*
579  * @dev Provides information about the current execution context, including the
580  * sender of the transaction and its data. While these are generally available
581  * via msg.sender and msg.data, they should not be accessed in such a direct
582  * manner, since when dealing with GSN meta-transactions the account sending and
583  * paying for execution may not be the actual sender (as far as an application
584  * is concerned).
585  *
586  * This contract is only required for intermediate, library-like contracts.
587  */
588 contract Context {
589     // Empty internal constructor, to prevent people from mistakenly deploying
590     // an instance of this contract, which should be used via inheritance.
591     constructor () internal { }
592 
593     function _msgSender() internal view virtual returns (address payable) {
594         return msg.sender;
595     }
596 
597     function _msgData() internal view virtual returns (bytes memory) {
598         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
599         return msg.data;
600     }
601 }
602 
603 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
604 
605 
606 
607 /**
608  * @dev Interface of the ERC20 standard as defined in the EIP.
609  */
610 interface IERC20 {
611     /**
612      * @dev Returns the amount of tokens in existence.
613      */
614     function totalSupply() external view returns (uint256);
615 
616     /**
617      * @dev Returns the amount of tokens owned by `account`.
618      */
619     function balanceOf(address account) external view returns (uint256);
620 
621     /**
622      * @dev Moves `amount` tokens from the caller's account to `recipient`.
623      *
624      * Returns a boolean value indicating whether the operation succeeded.
625      *
626      * Emits a {Transfer} event.
627      */
628     function transfer(address recipient, uint256 amount) external returns (bool);
629 
630     /**
631      * @dev Returns the remaining number of tokens that `spender` will be
632      * allowed to spend on behalf of `owner` through {transferFrom}. This is
633      * zero by default.
634      *
635      * This value changes when {approve} or {transferFrom} are called.
636      */
637     function allowance(address owner, address spender) external view returns (uint256);
638 
639     /**
640      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
641      *
642      * Returns a boolean value indicating whether the operation succeeded.
643      *
644      * IMPORTANT: Beware that changing an allowance with this method brings the risk
645      * that someone may use both the old and the new allowance by unfortunate
646      * transaction ordering. One possible solution to mitigate this race
647      * condition is to first reduce the spender's allowance to 0 and set the
648      * desired value afterwards:
649      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
650      *
651      * Emits an {Approval} event.
652      */
653     function approve(address spender, uint256 amount) external returns (bool);
654 
655     /**
656      * @dev Moves `amount` tokens from `sender` to `recipient` using the
657      * allowance mechanism. `amount` is then deducted from the caller's
658      * allowance.
659      *
660      * Returns a boolean value indicating whether the operation succeeded.
661      *
662      * Emits a {Transfer} event.
663      */
664     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
665 
666     /**
667      * @dev Emitted when `value` tokens are moved from one account (`from`) to
668      * another (`to`).
669      *
670      * Note that `value` may be zero.
671      */
672     event Transfer(address indexed from, address indexed to, uint256 value);
673 
674     /**
675      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
676      * a call to {approve}. `value` is the new allowance.
677      */
678     event Approval(address indexed owner, address indexed spender, uint256 value);
679 }
680 
681 // File: @openzeppelin/contracts/utils/Address.sol
682 
683 
684 
685 /**
686  * @dev Collection of functions related to the address type
687  */
688 library Address {
689     /**
690      * @dev Returns true if `account` is a contract.
691      *
692      * [IMPORTANT]
693      * ====
694      * It is unsafe to assume that an address for which this function returns
695      * false is an externally-owned account (EOA) and not a contract.
696      *
697      * Among others, `isContract` will return false for the following
698      * types of addresses:
699      *
700      *  - an externally-owned account
701      *  - a contract in construction
702      *  - an address where a contract will be created
703      *  - an address where a contract lived, but was destroyed
704      * ====
705      */
706     function isContract(address account) internal view returns (bool) {
707         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
708         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
709         // for accounts without code, i.e. `keccak256('')`
710         bytes32 codehash;
711         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
712         // solhint-disable-next-line no-inline-assembly
713         assembly { codehash := extcodehash(account) }
714         return (codehash != accountHash && codehash != 0x0);
715     }
716 
717     /**
718      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
719      * `recipient`, forwarding all available gas and reverting on errors.
720      *
721      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
722      * of certain opcodes, possibly making contracts go over the 2300 gas limit
723      * imposed by `transfer`, making them unable to receive funds via
724      * `transfer`. {sendValue} removes this limitation.
725      *
726      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
727      *
728      * IMPORTANT: because control is transferred to `recipient`, care must be
729      * taken to not create reentrancy vulnerabilities. Consider using
730      * {ReentrancyGuard} or the
731      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
732      */
733     function sendValue(address payable recipient, uint256 amount) internal {
734         require(address(this).balance >= amount, "Address: insufficient balance");
735 
736         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
737         (bool success, ) = recipient.call{ value: amount }("");
738         require(success, "Address: unable to send value, recipient may have reverted");
739     }
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
743 
744 /**
745  * @dev Implementation of the {IERC20} interface.
746  *
747  * This implementation is agnostic to the way tokens are created. This means
748  * that a supply mechanism has to be added in a derived contract using {_mint}.
749  * For a generic mechanism see {ERC20MinterPauser}.
750  *
751  * TIP: For a detailed writeup see our guide
752  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
753  * to implement supply mechanisms].
754  *
755  * We have followed general OpenZeppelin guidelines: functions revert instead
756  * of returning `false` on failure. This behavior is nonetheless conventional
757  * and does not conflict with the expectations of ERC20 applications.
758  *
759  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
760  * This allows applications to reconstruct the allowance for all accounts just
761  * by listening to said events. Other implementations of the EIP may not emit
762  * these events, as it isn't required by the specification.
763  *
764  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
765  * functions have been added to mitigate the well-known issues around setting
766  * allowances. See {IERC20-approve}.
767  */
768 contract ERC20 is Context, IERC20 {
769     using SafeMath for uint256;
770     using Address for address;
771 
772     mapping (address => uint256) private _balances;
773 
774     mapping (address => mapping (address => uint256)) private _allowances;
775 
776     uint256 private _totalSupply;
777 
778     string private _name;
779     string private _symbol;
780     uint8 private _decimals;
781 
782     /**
783      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
784      * a default value of 18.
785      *
786      * To select a different value for {decimals}, use {_setupDecimals}.
787      *
788      * All three of these values are immutable: they can only be set once during
789      * construction.
790      */
791     constructor (string memory name, string memory symbol) public {
792         _name = name;
793         _symbol = symbol;
794         _decimals = 18;
795     }
796 
797     /**
798      * @dev Returns the name of the token.
799      */
800     function name() public view returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev Returns the symbol of the token, usually a shorter version of the
806      * name.
807      */
808     function symbol() public view returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev Returns the number of decimals used to get its user representation.
814      * For example, if `decimals` equals `2`, a balance of `505` tokens should
815      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
816      *
817      * Tokens usually opt for a value of 18, imitating the relationship between
818      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
819      * called.
820      *
821      * NOTE: This information is only used for _display_ purposes: it in
822      * no way affects any of the arithmetic of the contract, including
823      * {IERC20-balanceOf} and {IERC20-transfer}.
824      */
825     function decimals() public view returns (uint8) {
826         return _decimals;
827     }
828 
829     /**
830      * @dev See {IERC20-totalSupply}.
831      */
832     function totalSupply() public view override returns (uint256) {
833         return _totalSupply;
834     }
835 
836     /**
837      * @dev See {IERC20-balanceOf}.
838      */
839     function balanceOf(address account) public view override returns (uint256) {
840         return _balances[account];
841     }
842 
843     /**
844      * @dev See {IERC20-transfer}.
845      *
846      * Requirements:
847      *
848      * - `recipient` cannot be the zero address.
849      * - the caller must have a balance of at least `amount`.
850      */
851     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
852         _transfer(_msgSender(), recipient, amount);
853         return true;
854     }
855 
856     /**
857      * @dev See {IERC20-allowance}.
858      */
859     function allowance(address owner, address spender) public view virtual override returns (uint256) {
860         return _allowances[owner][spender];
861     }
862 
863     /**
864      * @dev See {IERC20-approve}.
865      *
866      * Requirements:
867      *
868      * - `spender` cannot be the zero address.
869      */
870     function approve(address spender, uint256 amount) public virtual override returns (bool) {
871         _approve(_msgSender(), spender, amount);
872         return true;
873     }
874 
875     /**
876      * @dev See {IERC20-transferFrom}.
877      *
878      * Emits an {Approval} event indicating the updated allowance. This is not
879      * required by the EIP. See the note at the beginning of {ERC20};
880      *
881      * Requirements:
882      * - `sender` and `recipient` cannot be the zero address.
883      * - `sender` must have a balance of at least `amount`.
884      * - the caller must have allowance for ``sender``'s tokens of at least
885      * `amount`.
886      */
887     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
888         _transfer(sender, recipient, amount);
889         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
890         return true;
891     }
892 
893     /**
894      * @dev Atomically increases the allowance granted to `spender` by the caller.
895      *
896      * This is an alternative to {approve} that can be used as a mitigation for
897      * problems described in {IERC20-approve}.
898      *
899      * Emits an {Approval} event indicating the updated allowance.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
906         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
907         return true;
908     }
909 
910     /**
911      * @dev Atomically decreases the allowance granted to `spender` by the caller.
912      *
913      * This is an alternative to {approve} that can be used as a mitigation for
914      * problems described in {IERC20-approve}.
915      *
916      * Emits an {Approval} event indicating the updated allowance.
917      *
918      * Requirements:
919      *
920      * - `spender` cannot be the zero address.
921      * - `spender` must have allowance for the caller of at least
922      * `subtractedValue`.
923      */
924     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
925         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
926         return true;
927     }
928 
929     /**
930      * @dev Moves tokens `amount` from `sender` to `recipient`.
931      *
932      * This is internal function is equivalent to {transfer}, and can be used to
933      * e.g. implement automatic token fees, slashing mechanisms, etc.
934      *
935      * Emits a {Transfer} event.
936      *
937      * Requirements:
938      *
939      * - `sender` cannot be the zero address.
940      * - `recipient` cannot be the zero address.
941      * - `sender` must have a balance of at least `amount`.
942      */
943     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
944         require(sender != address(0), "ERC20: transfer from the zero address");
945         require(recipient != address(0), "ERC20: transfer to the zero address");
946 
947         _beforeTokenTransfer(sender, recipient, amount);
948 
949         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
950         _balances[recipient] = _balances[recipient].add(amount);
951         emit Transfer(sender, recipient, amount);
952     }
953 
954     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
955      * the total supply.
956      *
957      * Emits a {Transfer} event with `from` set to the zero address.
958      *
959      * Requirements
960      *
961      * - `to` cannot be the zero address.
962      */
963     function _mint(address account, uint256 amount) internal virtual {
964         require(account != address(0), "ERC20: mint to the zero address");
965 
966         _beforeTokenTransfer(address(0), account, amount);
967 
968         _totalSupply = _totalSupply.add(amount);
969         _balances[account] = _balances[account].add(amount);
970         emit Transfer(address(0), account, amount);
971     }
972 
973     /**
974      * @dev Destroys `amount` tokens from `account`, reducing the
975      * total supply.
976      *
977      * Emits a {Transfer} event with `to` set to the zero address.
978      *
979      * Requirements
980      *
981      * - `account` cannot be the zero address.
982      * - `account` must have at least `amount` tokens.
983      */
984     function _burn(address account, uint256 amount) internal virtual {
985         require(account != address(0), "ERC20: burn from the zero address");
986 
987         _beforeTokenTransfer(account, address(0), amount);
988 
989         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
990         _totalSupply = _totalSupply.sub(amount);
991         emit Transfer(account, address(0), amount);
992     }
993 
994     /**
995      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
996      *
997      * This is internal function is equivalent to `approve`, and can be used to
998      * e.g. set automatic allowances for certain subsystems, etc.
999      *
1000      * Emits an {Approval} event.
1001      *
1002      * Requirements:
1003      *
1004      * - `owner` cannot be the zero address.
1005      * - `spender` cannot be the zero address.
1006      */
1007     function _approve(address owner, address spender, uint256 amount) internal virtual {
1008         require(owner != address(0), "ERC20: approve from the zero address");
1009         require(spender != address(0), "ERC20: approve to the zero address");
1010 
1011         _allowances[owner][spender] = amount;
1012         emit Approval(owner, spender, amount);
1013     }
1014 
1015     /**
1016      * @dev Sets {decimals} to a value other than the default one of 18.
1017      *
1018      * WARNING: This function should only be called from the constructor. Most
1019      * applications that interact with token contracts will not expect
1020      * {decimals} to ever change, and may work incorrectly if it does.
1021      */
1022     function _setupDecimals(uint8 decimals_) internal {
1023         _decimals = decimals_;
1024     }
1025 
1026     /**
1027      * @dev Hook that is called before any transfer of tokens. This includes
1028      * minting and burning.
1029      *
1030      * Calling conditions:
1031      *
1032      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1033      * will be to transferred to `to`.
1034      * - when `from` is zero, `amount` tokens will be minted for `to`.
1035      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1036      * - `from` and `to` are never both zero.
1037      *
1038      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1039      */
1040     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1041 }
1042 
1043 // File: contracts/bondToken/BondTokenInterface.sol
1044 
1045 
1046 
1047 
1048 
1049 
1050 interface BondTokenInterface is TransferETHInterface, IERC20 {
1051     event LogExpire(
1052         uint128 rateNumerator,
1053         uint128 rateDenominator,
1054         bool firstTime
1055     );
1056 
1057     function mint(address account, uint256 amount)
1058         external
1059         returns (bool success);
1060 
1061     function expire(uint128 rateNumerator, uint128 rateDenominator)
1062         external
1063         returns (bool firstTime);
1064 
1065     function burn(uint256 amount) external returns (bool success);
1066 
1067     function burnAll() external returns (uint256 amount);
1068 
1069     function isMinter(address account) external view returns (bool minter);
1070 
1071     function getRate()
1072         external
1073         view
1074         returns (uint128 rateNumerator, uint128 rateDenominator);
1075 }
1076 
1077 // File: contracts/util/DeployerRole.sol
1078 
1079 
1080 
1081 
1082 abstract contract DeployerRole {
1083     address internal immutable _deployer;
1084 
1085     modifier onlyDeployer() {
1086         require(
1087             _isDeployer(msg.sender),
1088             "only deployer is allowed to call this function"
1089         );
1090         _;
1091     }
1092 
1093     constructor() public {
1094         _deployer = msg.sender;
1095     }
1096 
1097     function _isDeployer(address account) internal view returns (bool) {
1098         return account == _deployer;
1099     }
1100 }
1101 
1102 // File: contracts/bondToken/BondToken.sol
1103 
1104 
1105 
1106 
1107 
1108 
1109 
1110 
1111 contract BondToken is DeployerRole, BondTokenInterface, TransferETH, ERC20 {
1112     struct Frac128x128 {
1113         uint128 numerator;
1114         uint128 denominator;
1115     }
1116 
1117     Frac128x128 internal _rate;
1118 
1119     constructor(string memory name, string memory symbol)
1120         public
1121         ERC20(name, symbol)
1122     {
1123         _setupDecimals(8);
1124     }
1125 
1126     function mint(address account, uint256 amount)
1127         public
1128         virtual
1129         override
1130         onlyDeployer
1131         returns (bool success)
1132     {
1133         require(!isExpired(), "this token contract has expired");
1134         _mint(account, amount);
1135         return true;
1136     }
1137 
1138     function transfer(address recipient, uint256 amount)
1139         public
1140         override(ERC20, IERC20)
1141         returns (bool success)
1142     {
1143         _transfer(msg.sender, recipient, amount);
1144         return true;
1145     }
1146 
1147     function transferFrom(
1148         address sender,
1149         address recipient,
1150         uint256 amount
1151     ) public override(ERC20, IERC20) returns (bool success) {
1152         _transfer(sender, recipient, amount);
1153         _approve(
1154             sender,
1155             msg.sender,
1156             allowance(sender, msg.sender).sub(
1157                 amount,
1158                 "ERC20: transfer amount exceeds allowance"
1159             )
1160         );
1161         return true;
1162     }
1163 
1164     /**
1165      * @dev Record the settlement price at maturity in the form of a fraction and let the bond
1166      * token expire.
1167      */
1168     function expire(uint128 rateNumerator, uint128 rateDenominator)
1169         public
1170         override
1171         onlyDeployer
1172         returns (bool isFirstTime)
1173     {
1174         isFirstTime = !isExpired();
1175         if (isFirstTime) {
1176             _setRate(Frac128x128(rateNumerator, rateDenominator));
1177         }
1178 
1179         emit LogExpire(rateNumerator, rateDenominator, isFirstTime);
1180     }
1181 
1182     function simpleBurn(address from, uint256 amount)
1183         public
1184         onlyDeployer
1185         returns (bool)
1186     {
1187         if (amount > balanceOf(from)) {
1188             return false;
1189         }
1190 
1191         _burn(from, amount);
1192         return true;
1193     }
1194 
1195     function burn(uint256 amount) public override returns (bool success) {
1196         if (!isExpired()) {
1197             return false;
1198         }
1199 
1200         _burn(msg.sender, amount);
1201 
1202         if (_rate.numerator != 0) {
1203             uint256 withdrawAmount = amount
1204                 .mul(10**(18 - 8))
1205                 .mul(_rate.numerator)
1206                 .div(_rate.denominator);
1207             _transferETH(
1208                 msg.sender,
1209                 withdrawAmount,
1210                 "system error: insufficient balance"
1211             );
1212         }
1213 
1214         return true;
1215     }
1216 
1217     function burnAll() public override returns (uint256 amount) {
1218         amount = balanceOf(msg.sender);
1219         bool success = burn(amount);
1220         if (!success) {
1221             amount = 0;
1222         }
1223     }
1224 
1225     /**
1226      * @dev rateDenominator never be zero due to div() function, thus initial _rateDenominator is 0
1227      * can be used for flag of non-expired;
1228      */
1229     function isExpired() public view returns (bool) {
1230         return _rate.denominator != 0;
1231     }
1232 
1233     function isMinter(address account) public override view returns (bool) {
1234         return _isDeployer(account);
1235     }
1236 
1237     function getRate()
1238         public
1239         override
1240         view
1241         returns (uint128 rateNumerator, uint128 rateDenominator)
1242     {
1243         rateNumerator = _rate.numerator;
1244         rateDenominator = _rate.denominator;
1245     }
1246 
1247     function _setRate(Frac128x128 memory rate) internal {
1248         require(
1249             rate.denominator != 0,
1250             "system error: the exchange rate must be non-negative number"
1251         );
1252         _rate = rate;
1253     }
1254 }
1255 
1256 // File: contracts/util/Polyline.sol
1257 
1258 
1259 
1260 
1261 
1262 contract Polyline is UseSafeMath {
1263     struct Point {
1264         uint64 x; // Value of the x-axis of the x-y plane
1265         uint64 y; // Value of the y-axis of the x-y plane
1266     }
1267 
1268     struct LineSegment {
1269         Point left; // The left end of the line definition range
1270         Point right; // The right end of the line definition range
1271     }
1272 
1273     /**
1274      * @notice Return the value of y corresponding to x on the given line line in the form of
1275      * a rational number (numerator / denominator).
1276      * If you treat a line as a line segment instead of a line, you should run
1277      * includesDomain(line, x) to check whether x is included in the line's domain or not.
1278      * @dev To guarantee accuracy, the bit length of the denominator must be greater than or equal
1279      * to the bit length of x, and the bit length of the numerator must be greater than or equal
1280      * to the sum of the bit lengths of x and y.
1281      */
1282     function _mapXtoY(LineSegment memory line, uint64 x)
1283         internal
1284         pure
1285         returns (uint128 numerator, uint64 denominator)
1286     {
1287         int256 x1 = int256(line.left.x);
1288         int256 y1 = int256(line.left.y);
1289         int256 x2 = int256(line.right.x);
1290         int256 y2 = int256(line.right.y);
1291 
1292         require(x2 > x1, "must be left.x < right.x");
1293 
1294         denominator = uint64(x2 - x1);
1295 
1296         // Calculate y = ((x2 - x) * y1 + (x - x1) * y2) / (x2 - x1)
1297         // in the form of a fraction (numerator / denominator).
1298         int256 n = (x - x1) * y2 + (x2 - x) * y1;
1299 
1300         require(n >= 0, "underflow n");
1301         require(n < 2**128, "system error: overflow n");
1302         numerator = uint128(n);
1303     }
1304 
1305     /**
1306      * @notice Checking that a line segment is a line segment of a valid format.
1307      */
1308     function assertLineSegment(LineSegment memory segment) internal pure {
1309         uint64 x1 = segment.left.x;
1310         uint64 x2 = segment.right.x;
1311         require(x1 < x2, "must be left.x < right.x");
1312     }
1313 
1314     /**
1315      * @notice Checking that a polyline is a line graph of a valid form.
1316      */
1317     function assertPolyline(LineSegment[] memory polyline) internal pure {
1318         uint256 numOfSegment = polyline.length;
1319         require(numOfSegment > 0, "polyline must not be empty array");
1320 
1321         // About the first line segment.
1322         LineSegment memory firstSegment = polyline[0];
1323 
1324         // The beginning of the first line segment's domain is 0.
1325         require(
1326             firstSegment.left.x == uint64(0),
1327             "the x coordinate of left end of the first segment is 0"
1328         );
1329         // The value of y when x is 0 is 0.
1330         require(
1331             firstSegment.left.y == uint64(0),
1332             "the y coordinate of left end of the first segment is 0"
1333         );
1334 
1335         // About the last line segment.
1336         LineSegment memory lastSegment = polyline[numOfSegment - 1];
1337 
1338         // The slope of the last line segment should be between 0 and 1.
1339         int256 gradientNumerator = int256(lastSegment.right.y).sub(
1340             lastSegment.left.y
1341         );
1342         int256 gradientDenominator = int256(lastSegment.right.x).sub(
1343             lastSegment.left.x
1344         );
1345         require(
1346             gradientNumerator >= 0 && gradientNumerator <= gradientDenominator,
1347             "the gradient of last line segment must be non-negative number equal to or less than 1"
1348         );
1349 
1350         // Making sure that the first line segment is in the correct format.
1351         assertLineSegment(firstSegment);
1352 
1353         // The end of the domain of a segment and the beginning of the domain of the adjacent
1354         // segment coincide.
1355         for (uint256 i = 1; i < numOfSegment; i++) {
1356             LineSegment memory leftSegment = polyline[i - 1];
1357             LineSegment memory rightSegment = polyline[i];
1358 
1359             // Make sure that the i-th line segment is in the correct format.
1360             assertLineSegment(rightSegment);
1361 
1362             // Checking that the x-coordinates are same.
1363             require(
1364                 leftSegment.right.x == rightSegment.left.x,
1365                 "given polyline is not single-valued function."
1366             );
1367 
1368             // Checking that the y-coordinates are same.
1369             require(
1370                 leftSegment.right.y == rightSegment.left.y,
1371                 "given polyline is not continuous function"
1372             );
1373         }
1374     }
1375 
1376     /**
1377      * @notice zip a LineSegment structure to uint256
1378      * @return zip uint256( 0 ... 0 | x1 | y1 | x2 | y2 )
1379      */
1380     function zipLineSegment(LineSegment memory segment)
1381         internal
1382         pure
1383         returns (uint256 zip)
1384     {
1385         uint256 x1U256 = uint256(segment.left.x) << (64 + 64 + 64); // uint64
1386         uint256 y1U256 = uint256(segment.left.y) << (64 + 64); // uint64
1387         uint256 x2U256 = uint256(segment.right.x) << 64; // uint64
1388         uint256 y2U256 = uint256(segment.right.y); // uint64
1389         zip = x1U256 | y1U256 | x2U256 | y2U256;
1390     }
1391 
1392     /**
1393      * @notice unzip uint256 to a LineSegment structure
1394      */
1395     function unzipLineSegment(uint256 zip)
1396         internal
1397         pure
1398         returns (LineSegment memory)
1399     {
1400         uint64 x1 = uint64(zip >> (64 + 64 + 64));
1401         uint64 y1 = uint64(zip >> (64 + 64));
1402         uint64 x2 = uint64(zip >> 64);
1403         uint64 y2 = uint64(zip);
1404         return
1405             LineSegment({
1406                 left: Point({x: x1, y: y1}),
1407                 right: Point({x: x2, y: y2})
1408             });
1409     }
1410 
1411     /**
1412      * @notice unzip the fnMap to uint256[].
1413      */
1414     function decodePolyline(bytes memory fnMap)
1415         internal
1416         pure
1417         returns (uint256[] memory)
1418     {
1419         return abi.decode(fnMap, (uint256[]));
1420     }
1421 }
1422 
1423 // File: contracts/oracle/OracleInterface.sol
1424 
1425 
1426 
1427 
1428 // Oracle referenced by OracleProxy must implement this interface.
1429 interface OracleInterface {
1430     // Returns if oracle is running.
1431     function alive() external view returns (bool);
1432 
1433     // Returns latest id.
1434     // The first id is 1 and 0 value is invalid as id.
1435     // Each price values and theirs timestamps are identified by id.
1436     // Ids are assigned incrementally to values.
1437     function latestId() external returns (uint256);
1438 
1439     // Returns latest price value.
1440     // decimal 8
1441     function latestPrice() external returns (uint256);
1442 
1443     // Returns timestamp of latest price.
1444     function latestTimestamp() external returns (uint256);
1445 
1446     // Returns price of id.
1447     function getPrice(uint256 id) external returns (uint256);
1448 
1449     // Returns timestamp of id.
1450     function getTimestamp(uint256 id) external returns (uint256);
1451 
1452     function getVolatility() external returns (uint256);
1453 }
1454 
1455 // File: contracts/oracle/UseOracle.sol
1456 
1457 
1458 
1459 
1460 
1461 abstract contract UseOracle {
1462     OracleInterface internal _oracleContract;
1463 
1464     constructor(address contractAddress) public {
1465         require(
1466             contractAddress != address(0),
1467             "contract should be non-zero address"
1468         );
1469         _oracleContract = OracleInterface(contractAddress);
1470     }
1471 
1472     /// @notice Get the latest USD/ETH price and historical volatility using oracle.
1473     /// @return rateETH2USDE8 (10^-8 USD/ETH)
1474     /// @return volatilityE8 (10^-8)
1475     function _getOracleData()
1476         internal
1477         returns (uint256 rateETH2USDE8, uint256 volatilityE8)
1478     {
1479         rateETH2USDE8 = _oracleContract.latestPrice();
1480         volatilityE8 = _oracleContract.getVolatility();
1481 
1482         return (rateETH2USDE8, volatilityE8);
1483     }
1484 
1485     /// @notice Get the price of the oracle data with a minimum timestamp that does more than input value
1486     /// when you know the ID you are looking for.
1487     /// @param timestamp is the timestamp that you want to get price.
1488     /// @param hintID is the ID of the oracle data you are looking for.
1489     /// @return rateETH2USDE8 (10^-8 USD/ETH)
1490     function _getPriceOn(uint256 timestamp, uint256 hintID)
1491         internal
1492         returns (uint256 rateETH2USDE8)
1493     {
1494         uint256 latestID = _oracleContract.latestId();
1495         require(
1496             latestID != 0,
1497             "system error: the ID of oracle data should not be zero"
1498         );
1499 
1500         require(hintID != 0, "the hint ID must not be zero");
1501         uint256 id = hintID;
1502         if (hintID > latestID) {
1503             id = latestID;
1504         }
1505 
1506         require(
1507             _oracleContract.getTimestamp(id) > timestamp,
1508             "there is no price data after maturity"
1509         );
1510 
1511         id--;
1512         while (id != 0) {
1513             if (_oracleContract.getTimestamp(id) <= timestamp) {
1514                 break;
1515             }
1516             id--;
1517         }
1518 
1519         return _oracleContract.getPrice(id + 1);
1520     }
1521 }
1522 
1523 // File: contracts/bondTokenName/BondTokenNameInterface.sol
1524 
1525 
1526 
1527 
1528 /**
1529  * @title bond token name contract interface
1530  */
1531 interface BondTokenNameInterface {
1532     function genBondTokenName(
1533         string calldata shortNamePrefix,
1534         string calldata longNamePrefix,
1535         uint256 maturity,
1536         uint256 solidStrikePriceE4
1537     ) external pure returns (string memory shortName, string memory longName);
1538 
1539     function getBondTokenName(
1540         uint256 maturity,
1541         uint256 solidStrikePriceE4,
1542         uint256 rateLBTWorthlessE4
1543     ) external pure returns (string memory shortName, string memory longName);
1544 }
1545 
1546 // File: contracts/UseBondTokenName.sol
1547 
1548 
1549 
1550 
1551 
1552 abstract contract UseBondTokenName {
1553     BondTokenNameInterface internal immutable _bondTokenNameContract;
1554 
1555     constructor(address contractAddress) public {
1556         require(
1557             contractAddress != address(0),
1558             "contract should be non-zero address"
1559         );
1560         _bondTokenNameContract = BondTokenNameInterface(contractAddress);
1561     }
1562 }
1563 
1564 // File: contracts/BondMaker.sol
1565 
1566 
1567 
1568 
1569 
1570 
1571 
1572 
1573 
1574 
1575 
1576 
1577 contract BondMaker is
1578     UseSafeMath,
1579     BondMakerInterface,
1580     Time,
1581     TransferETH,
1582     Polyline,
1583     UseOracle,
1584     UseBondTokenName
1585 {
1586     uint8 internal constant DECIMALS_OF_BOND_AMOUNT = 8;
1587 
1588     address internal immutable LIEN_TOKEN_ADDRESS;
1589     uint256 internal immutable MATURITY_SCALE;
1590 
1591     uint256 public nextBondGroupID = 1;
1592 
1593     /**
1594      * @dev The contents in this internal storage variable can be seen by getBond function.
1595      */
1596     struct BondInfo {
1597         uint256 maturity;
1598         BondToken contractInstance;
1599         uint64 solidStrikePriceE4;
1600         bytes32 fnMapID;
1601     }
1602     mapping(bytes32 => BondInfo) internal _bonds;
1603 
1604     /**
1605      * @notice mapping fnMapID to polyline
1606      * @dev The contents in this internal storage variable can be seen by getFnMap function.
1607      */
1608     mapping(bytes32 => LineSegment[]) internal _registeredFnMap;
1609 
1610     /**
1611      * @dev The contents in this internal storage variable can be seen by getBondGroup function.
1612      */
1613     struct BondGroup {
1614         bytes32[] bondIDs;
1615         uint256 maturity;
1616     }
1617     mapping(uint256 => BondGroup) internal _bondGroupList;
1618 
1619     constructor(
1620         address oracleAddress,
1621         address lienTokenAddress,
1622         address bondTokenNameAddress,
1623         uint256 maturityScale
1624     ) public UseOracle(oracleAddress) UseBondTokenName(bondTokenNameAddress) {
1625         LIEN_TOKEN_ADDRESS = lienTokenAddress;
1626         require(maturityScale != 0, "MATURITY_SCALE must be positive");
1627         MATURITY_SCALE = maturityScale;
1628     }
1629 
1630     /**
1631      * @notice Create bond token contract.
1632      * The name of this bond token is its bond ID.
1633      * @dev To convert bytes32 to string, encode its bond ID at first, then convert to string.
1634      * The symbol of any bond token with bond ID is either SBT or LBT;
1635      * As SBT is a special case of bond token, any bond token which does not match to the form of
1636      * SBT is defined as LBT.
1637      */
1638     function registerNewBond(uint256 maturity, bytes memory fnMap)
1639         public
1640         override
1641         returns (
1642             bytes32,
1643             address,
1644             uint64,
1645             bytes32
1646         )
1647     {
1648         require(
1649             maturity > _getBlockTimestampSec(),
1650             "the maturity has already expired"
1651         );
1652         require(maturity % MATURITY_SCALE == 0, "maturity must be HH:00:00");
1653 
1654         bytes32 bondID = generateBondID(maturity, fnMap);
1655 
1656         // Check if the same form of bond is already registered.
1657         // Cannot detect if the bond is described in a different polyline while two are
1658         // mathematically equivalent.
1659         require(
1660             address(_bonds[bondID].contractInstance) == address(0),
1661             "already register given bond type"
1662         );
1663 
1664         // Register function mapping if necessary.
1665         bytes32 fnMapID = generateFnMapID(fnMap);
1666         if (_registeredFnMap[fnMapID].length == 0) {
1667             uint256[] memory polyline = decodePolyline(fnMap);
1668             for (uint256 i = 0; i < polyline.length; i++) {
1669                 _registeredFnMap[fnMapID].push(unzipLineSegment(polyline[i]));
1670             }
1671 
1672             assertPolyline(_registeredFnMap[fnMapID]);
1673         }
1674 
1675         uint64 solidStrikePrice = _getSolidStrikePrice(
1676             _registeredFnMap[fnMapID]
1677         );
1678         uint64 rateLBTWorthless = _getRateLBTWorthless(
1679             _registeredFnMap[fnMapID]
1680         );
1681 
1682         (
1683             string memory shortName,
1684             string memory longName
1685         ) = _bondTokenNameContract.getBondTokenName(
1686             maturity,
1687             solidStrikePrice,
1688             rateLBTWorthless
1689         );
1690 
1691         BondToken bondTokenContract = _createNewBondToken(longName, shortName);
1692 
1693         // Set bond info to storage.
1694         _bonds[bondID] = BondInfo({
1695             maturity: maturity,
1696             contractInstance: bondTokenContract,
1697             solidStrikePriceE4: solidStrikePrice,
1698             fnMapID: fnMapID
1699         });
1700 
1701         emit LogNewBond(
1702             bondID,
1703             address(bondTokenContract),
1704             solidStrikePrice,
1705             fnMapID
1706         );
1707 
1708         return (bondID, address(bondTokenContract), solidStrikePrice, fnMapID);
1709     }
1710 
1711     function _assertBondGroup(bytes32[] memory bondIDs, uint256 maturity)
1712         internal
1713         view
1714     {
1715         /**
1716          * @dev Count the number of the end points on x axis. In the case of a simple SBT/LBT split,
1717          * 3 for SBT plus 3 for LBT equals to 6.
1718          * In the case of SBT with the strike price 100, (x,y) = (0,0), (100,100), (200,100) defines
1719          * the form of SBT on the field.
1720          * In the case of LBT with the strike price 100, (x,y) = (0,0), (100,0), (200,100) defines
1721          * the form of LBT on the field.
1722          * Right hand side area of the last grid point is expanded on the last line to the infinity.
1723          * @param nextBreakPointIndex returns the number of unique points on x axis.
1724          * In the case of SBT and LBT with the strike price 100, x = 0,100,200 are the unique points
1725          * and the number is 3.
1726          */
1727         uint256 numOfBreakPoints = 0;
1728         for (uint256 i = 0; i < bondIDs.length; i++) {
1729             BondInfo storage bond = _bonds[bondIDs[i]];
1730             require(
1731                 bond.maturity == maturity,
1732                 "the maturity of the bonds must be same"
1733             );
1734             LineSegment[] storage polyline = _registeredFnMap[bond.fnMapID];
1735             numOfBreakPoints = numOfBreakPoints.add(polyline.length);
1736         }
1737 
1738         uint256 nextBreakPointIndex = 0;
1739         uint64[] memory rateBreakPoints = new uint64[](numOfBreakPoints);
1740         for (uint256 i = 0; i < bondIDs.length; i++) {
1741             BondInfo storage bond = _bonds[bondIDs[i]];
1742             LineSegment[] storage segments = _registeredFnMap[bond.fnMapID];
1743             for (uint256 j = 0; j < segments.length; j++) {
1744                 uint64 breakPoint = segments[j].right.x;
1745                 bool ok = false;
1746 
1747                 for (uint256 k = 0; k < nextBreakPointIndex; k++) {
1748                     if (rateBreakPoints[k] == breakPoint) {
1749                         ok = true;
1750                         break;
1751                     }
1752                 }
1753 
1754                 if (ok) {
1755                     continue;
1756                 }
1757 
1758                 rateBreakPoints[nextBreakPointIndex] = breakPoint;
1759                 nextBreakPointIndex++;
1760             }
1761         }
1762 
1763         for (uint256 k = 0; k < rateBreakPoints.length; k++) {
1764             uint64 rate = rateBreakPoints[k];
1765             uint256 totalBondPriceN = 0;
1766             uint256 totalBondPriceD = 1;
1767             for (uint256 i = 0; i < bondIDs.length; i++) {
1768                 BondInfo storage bond = _bonds[bondIDs[i]];
1769                 LineSegment[] storage segments = _registeredFnMap[bond.fnMapID];
1770                 (uint256 segmentIndex, bool ok) = _correspondSegment(
1771                     segments,
1772                     rate
1773                 );
1774 
1775                 require(ok, "invalid domain expression");
1776 
1777                 (uint128 n, uint64 d) = _mapXtoY(segments[segmentIndex], rate);
1778 
1779                 if (n != 0) {
1780                     // totalBondPrice += (n / d);
1781                     // N = D*n + N*d, D = D*d
1782                     totalBondPriceN = totalBondPriceD.mul(n).add(
1783                         totalBondPriceN.mul(d)
1784                     );
1785                     totalBondPriceD = totalBondPriceD.mul(d);
1786                 }
1787             }
1788             /**
1789              * @dev Ensure that totalBondPrice (= totalBondPriceN / totalBondPriceD) is the same
1790              * with rate. Because we need 1 Ether to mint a unit of each bond token respectively,
1791              * the sum of strike price (USD) per a unit of bond token is the same with USD/ETH
1792              * rate at maturity.
1793              */
1794             require(
1795                 totalBondPriceN == totalBondPriceD.mul(rate),
1796                 "the total price at any rateBreakPoints should be the same value as the rate"
1797             );
1798         }
1799     }
1800 
1801     /**
1802      * @notice Collect bondIDs that regenerate the original ETH, and group them as a bond group.
1803      * Any bond is described as a set of linear functions(i.e. polyline),
1804      * so we can easily check if the set of bondIDs are well-formed by looking at all the end
1805      * points of the lines.
1806      */
1807     function registerNewBondGroup(bytes32[] memory bondIDs, uint256 maturity)
1808         public
1809         override
1810         returns (uint256 bondGroupID)
1811     {
1812         _assertBondGroup(bondIDs, maturity);
1813 
1814         // Get and increment next bond group ID
1815         bondGroupID = nextBondGroupID;
1816         nextBondGroupID = nextBondGroupID.add(1);
1817 
1818         _bondGroupList[bondGroupID] = BondGroup(bondIDs, maturity);
1819 
1820         emit LogNewBondGroup(bondGroupID);
1821 
1822         return bondGroupID;
1823     }
1824 
1825     /**
1826      * @notice A user needs to issue a bond via BondGroup in order to guarantee that the total value
1827      * of bonds in the bond group equals to the input Ether except for about 0.2% fee (accurately 2/1002).
1828      */
1829     function issueNewBonds(uint256 bondGroupID)
1830         public
1831         override
1832         payable
1833         returns (uint256)
1834     {
1835         BondGroup storage bondGroup = _bondGroupList[bondGroupID];
1836         bytes32[] storage bondIDs = bondGroup.bondIDs;
1837         require(
1838             _getBlockTimestampSec() < bondGroup.maturity,
1839             "the maturity has already expired"
1840         );
1841 
1842         uint256 fee = msg.value.mul(2).div(1002);
1843 
1844         uint256 amount = msg.value.sub(fee).div(10**10); // ether's decimal is 18 and that of LBT is 8;
1845 
1846         bytes32 bondID;
1847         for (
1848             uint256 bondFnMapIndex = 0;
1849             bondFnMapIndex < bondIDs.length;
1850             bondFnMapIndex++
1851         ) {
1852             bondID = bondIDs[bondFnMapIndex];
1853             _issueNewBond(bondID, msg.sender, amount);
1854         }
1855 
1856         _transferETH(payable(LIEN_TOKEN_ADDRESS), fee);
1857 
1858         emit LogIssueNewBonds(bondGroupID, msg.sender, amount);
1859 
1860         return amount;
1861     }
1862 
1863     /**
1864      * @notice redeems ETH from the total set of bonds in the bondGroupID before maturity date.
1865      */
1866     function reverseBondToETH(uint256 bondGroupID, uint256 amountE8)
1867         public
1868         override
1869         returns (bool)
1870     {
1871         BondGroup storage bondGroup = _bondGroupList[bondGroupID];
1872         bytes32[] storage bondIDs = bondGroup.bondIDs;
1873         require(
1874             _getBlockTimestampSec() < bondGroup.maturity,
1875             "the maturity has already expired"
1876         );
1877         bytes32 bondID;
1878         for (
1879             uint256 bondFnMapIndex = 0;
1880             bondFnMapIndex < bondIDs.length;
1881             bondFnMapIndex++
1882         ) {
1883             bondID = bondIDs[bondFnMapIndex];
1884             _burnBond(bondID, msg.sender, amountE8);
1885         }
1886 
1887         _transferETH(
1888             msg.sender,
1889             amountE8.mul(10**10),
1890             "system error: insufficient Ether balance"
1891         );
1892 
1893         emit LogReverseBondToETH(bondGroupID, msg.sender, amountE8.mul(10**10));
1894 
1895         return true;
1896     }
1897 
1898     /**
1899      * @notice Burns set of LBTs and mints equivalent set of LBTs that are not in the exception list.
1900      * @param inputBondGroupID is the BondGroupID of bonds which you want to burn.
1901      * @param outputBondGroupID is the BondGroupID of bonds which you want to mint.
1902      * @param exceptionBonds is the list of bondIDs that should be excluded in burn/mint process.
1903      */
1904     function exchangeEquivalentBonds(
1905         uint256 inputBondGroupID,
1906         uint256 outputBondGroupID,
1907         uint256 amount,
1908         bytes32[] memory exceptionBonds
1909     ) public override returns (bool) {
1910         (bytes32[] memory inputIDs, uint256 inputMaturity) = getBondGroup(
1911             inputBondGroupID
1912         );
1913         (bytes32[] memory outputIDs, uint256 outputMaturity) = getBondGroup(
1914             outputBondGroupID
1915         );
1916         require(
1917             inputMaturity == outputMaturity,
1918             "cannot exchange bonds with different maturities"
1919         );
1920         require(
1921             _getBlockTimestampSec() < inputMaturity,
1922             "the maturity has already expired"
1923         );
1924         bool flag;
1925 
1926         uint256 exceptionCount;
1927         for (uint256 i = 0; i < inputIDs.length; i++) {
1928             // this flag control checks whether the bond is in the scope of burn/mint
1929             flag = true;
1930             for (uint256 j = 0; j < exceptionBonds.length; j++) {
1931                 if (exceptionBonds[j] == inputIDs[i]) {
1932                     flag = false;
1933                     // this count checks if all the bondIDs in exceptionBonds are included both in inputBondGroupID and outputBondGroupID
1934                     exceptionCount = exceptionCount.add(1);
1935                 }
1936             }
1937             if (flag) {
1938                 _burnBond(inputIDs[i], msg.sender, amount);
1939             }
1940         }
1941 
1942         require(
1943             exceptionBonds.length == exceptionCount,
1944             "All the exceptionBonds need to be included in input"
1945         );
1946 
1947         for (uint256 i = 0; i < outputIDs.length; i++) {
1948             flag = true;
1949             for (uint256 j = 0; j < exceptionBonds.length; j++) {
1950                 if (exceptionBonds[j] == outputIDs[i]) {
1951                     flag = false;
1952                     exceptionCount = exceptionCount.sub(1);
1953                 }
1954             }
1955             if (flag) {
1956                 _issueNewBond(outputIDs[i], msg.sender, amount);
1957             }
1958         }
1959 
1960         require(
1961             exceptionCount == 0,
1962             "All the exceptionBonds need to be included both in input and output"
1963         );
1964 
1965         emit LogExchangeEquivalentBonds(
1966             msg.sender,
1967             inputBondGroupID,
1968             outputBondGroupID,
1969             amount
1970         );
1971 
1972         return true;
1973     }
1974 
1975     /**
1976      * @notice Distributes ETH to the bond token holders after maturity date based on the oracle price.
1977      * @param oracleHintID is manyally set to be smaller number than the oracle latestId when the caller wants to save gas.
1978      */
1979     function liquidateBond(uint256 bondGroupID, uint256 oracleHintID)
1980         public
1981         override
1982     {
1983         if (oracleHintID == 0) {
1984             _distributeETH2BondTokenContract(
1985                 bondGroupID,
1986                 _oracleContract.latestId()
1987             );
1988         } else {
1989             _distributeETH2BondTokenContract(bondGroupID, oracleHintID);
1990         }
1991     }
1992 
1993     /**
1994      * @notice Returns multiple information for the bondID.
1995      */
1996     function getBond(bytes32 bondID)
1997         public
1998         override
1999         view
2000         returns (
2001             address bondTokenAddress,
2002             uint256 maturity,
2003             uint64 solidStrikePrice,
2004             bytes32 fnMapID
2005         )
2006     {
2007         BondInfo memory bondInfo = _bonds[bondID];
2008         bondTokenAddress = address(bondInfo.contractInstance);
2009         maturity = bondInfo.maturity;
2010         solidStrikePrice = bondInfo.solidStrikePriceE4;
2011         fnMapID = bondInfo.fnMapID;
2012     }
2013 
2014     /**
2015      * @dev Returns polyline for the fnMapID.
2016      */
2017     function getFnMap(bytes32 fnMapID)
2018         public
2019         override
2020         view
2021         returns (bytes memory)
2022     {
2023         LineSegment[] storage segments = _registeredFnMap[fnMapID];
2024         uint256[] memory polyline = new uint256[](segments.length);
2025         for (uint256 i = 0; i < segments.length; i++) {
2026             polyline[i] = zipLineSegment(segments[i]);
2027         }
2028         return abi.encode(polyline);
2029     }
2030 
2031     /**
2032      * @dev Returns all the bondIDs and their maturity for the bondGroupID.
2033      */
2034     function getBondGroup(uint256 bondGroupID)
2035         public
2036         virtual
2037         override
2038         view
2039         returns (bytes32[] memory bondIDs, uint256 maturity)
2040     {
2041         BondGroup memory bondGroup = _bondGroupList[bondGroupID];
2042         bondIDs = bondGroup.bondIDs;
2043         maturity = bondGroup.maturity;
2044     }
2045 
2046     /**
2047      * @dev Returns keccak256 for the fnMap.
2048      */
2049     function generateFnMapID(bytes memory fnMap) public pure returns (bytes32) {
2050         return keccak256(fnMap);
2051     }
2052 
2053     /**
2054      * @dev Returns keccak256 for the pair of maturity and fnMap.
2055      */
2056     function generateBondID(uint256 maturity, bytes memory fnMap)
2057         public
2058         override
2059         pure
2060         returns (bytes32)
2061     {
2062         return keccak256(abi.encodePacked(maturity, fnMap));
2063     }
2064 
2065     function _createNewBondToken(string memory name, string memory symbol)
2066         internal
2067         virtual
2068         returns (BondToken)
2069     {
2070         return new BondToken(name, symbol);
2071     }
2072 
2073     function _issueNewBond(
2074         bytes32 bondID,
2075         address account,
2076         uint256 amount
2077     ) internal {
2078         BondToken bondTokenContract = _bonds[bondID].contractInstance;
2079         require(
2080             address(bondTokenContract) != address(0),
2081             "the bond is not registered"
2082         );
2083         require(
2084             bondTokenContract.mint(account, amount),
2085             "failed to mint bond token"
2086         );
2087     }
2088 
2089     function _burnBond(
2090         bytes32 bondID,
2091         address account,
2092         uint256 amount
2093     ) internal {
2094         BondToken bondTokenContract = _bonds[bondID].contractInstance;
2095         require(
2096             address(bondTokenContract) != address(0),
2097             "the bond is not registered"
2098         );
2099         require(
2100             bondTokenContract.simpleBurn(account, amount),
2101             "failed to burn bond token"
2102         );
2103     }
2104 
2105     function _distributeETH2BondTokenContract(
2106         uint256 bondGroupID,
2107         uint256 oracleHintID
2108     ) internal {
2109         BondGroup storage bondGroup = _bondGroupList[bondGroupID];
2110         require(bondGroup.bondIDs.length > 0, "the bond group does not exist");
2111         require(
2112             _getBlockTimestampSec() >= bondGroup.maturity,
2113             "the bond has not expired yet"
2114         );
2115 
2116         // rateETH2USDE8 is the USD/ETH price multiplied by 10^8 returned from the oracle.
2117         uint256 rateETH2USDE8 = _getPriceOn(bondGroup.maturity, oracleHintID);
2118 
2119         // rateETH2USDE8 needs to be converted to rateETH2USDE4 as to match the decimal of the
2120         // values in segment.
2121         uint256 rateETH2USDE4 = rateETH2USDE8.div(10000);
2122         require(
2123             rateETH2USDE4 != 0,
2124             "system error: rate should be non-zero value"
2125         );
2126         require(
2127             rateETH2USDE4 < 2**64,
2128             "system error: rate should be less than the maximum value of uint64"
2129         );
2130 
2131         for (uint256 i = 0; i < bondGroup.bondIDs.length; i++) {
2132             bytes32 bondID = bondGroup.bondIDs[i];
2133             BondToken bondTokenContract = _bonds[bondID].contractInstance;
2134             require(
2135                 address(bondTokenContract) != address(0),
2136                 "the bond is not registered"
2137             );
2138 
2139             LineSegment[] storage segments = _registeredFnMap[_bonds[bondID]
2140                 .fnMapID];
2141 
2142             (uint256 segmentIndex, bool ok) = _correspondSegment(
2143                 segments,
2144                 uint64(rateETH2USDE4)
2145             );
2146 
2147             require(
2148                 ok,
2149                 "system error: did not found a segment whose price range include USD/ETH rate"
2150             );
2151             LineSegment storage segment = segments[segmentIndex];
2152             (uint128 n, uint64 _d) = _mapXtoY(segment, uint64(rateETH2USDE4));
2153 
2154             // uint64(-1) *  uint64(-1) < uint128(-1)
2155             uint128 d = uint128(_d) * uint128(rateETH2USDE4);
2156 
2157             uint256 totalSupply = bondTokenContract.totalSupply();
2158             bool expiredFlag = bondTokenContract.expire(n, d);
2159 
2160             if (expiredFlag) {
2161                 uint256 payment = totalSupply.mul(10**(18 - 8)).mul(n).div(d);
2162                 _transferETH(
2163                     address(bondTokenContract),
2164                     payment,
2165                     "system error: BondMaker's balance is less than payment"
2166                 );
2167             }
2168         }
2169     }
2170 
2171     /**
2172      * @dev Return the strike price only when the form of polyline matches to the definition of SBT.
2173      * Check if the form is SBT even when the polyline is in a verbose style.
2174      */
2175     function _getSolidStrikePrice(LineSegment[] memory polyline)
2176         internal
2177         pure
2178         returns (uint64)
2179     {
2180         uint64 solidStrikePrice = polyline[0].right.x;
2181 
2182         if (solidStrikePrice == 0) {
2183             return 0;
2184         }
2185 
2186         for (uint256 i = 0; i < polyline.length; i++) {
2187             LineSegment memory segment = polyline[i];
2188             if (segment.right.y != solidStrikePrice) {
2189                 return 0;
2190             }
2191         }
2192 
2193         return uint64(solidStrikePrice);
2194     }
2195 
2196     /**
2197      * @dev Only when the form of polyline matches to the definition of LBT, this function returns
2198      * the minimum USD/ETH rate that LBT is not worthless.
2199      * Check if the form is LBT even when the polyline is in a verbose style.
2200      */
2201     function _getRateLBTWorthless(LineSegment[] memory polyline)
2202         internal
2203         pure
2204         returns (uint64)
2205     {
2206         uint64 rateLBTWorthless = polyline[0].right.x;
2207 
2208         if (rateLBTWorthless == 0) {
2209             return 0;
2210         }
2211 
2212         for (uint256 i = 0; i < polyline.length; i++) {
2213             LineSegment memory segment = polyline[i];
2214             if (segment.right.y.add(rateLBTWorthless) != segment.right.x) {
2215                 return 0;
2216             }
2217         }
2218 
2219         return uint64(rateLBTWorthless);
2220     }
2221 
2222     /**
2223      * @dev In order to calculate y axis value for the corresponding x axis value, we need to find
2224      * the place of domain of x value on the polyline.
2225      * As the polyline is already checked to be correctly formed, we can simply look from the right
2226      * hand side of the polyline.
2227      */
2228     function _correspondSegment(LineSegment[] memory segments, uint64 x)
2229         internal
2230         pure
2231         returns (uint256 i, bool ok)
2232     {
2233         i = segments.length;
2234         while (i > 0) {
2235             i--;
2236             if (segments[i].left.x <= x) {
2237                 ok = true;
2238                 break;
2239             }
2240         }
2241     }
2242 }