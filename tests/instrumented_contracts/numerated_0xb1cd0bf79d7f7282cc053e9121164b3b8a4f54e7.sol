1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16   function _msgSender() internal view virtual returns (address payable) {
17     return msg.sender;
18   }
19 
20   function _msgData() internal view virtual returns (bytes memory) {
21     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22     return msg.data;
23   }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43   address private _owner;
44 
45   event OwnershipTransferred(
46     address indexed previousOwner,
47     address indexed newOwner
48   );
49 
50   /**
51    * @dev Initializes the contract setting the deployer as the initial owner.
52    */
53   constructor() internal {
54     address msgSender = _msgSender();
55     _owner = msgSender;
56     emit OwnershipTransferred(address(0), msgSender);
57   }
58 
59   /**
60    * @dev Returns the address of the current owner.
61    */
62   function owner() public view virtual returns (address) {
63     return _owner;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(owner() == _msgSender(), "Ownable: caller is not the owner");
71     _;
72   }
73 
74   /**
75    * @dev Leaves the contract without owner. It will not be possible to call
76    * `onlyOwner` functions anymore. Can only be called by the current owner.
77    *
78    * NOTE: Renouncing ownership will leave the contract without an owner,
79    * thereby removing any functionality that is only available to the owner.
80    */
81   function renounceOwnership() public virtual onlyOwner {
82     emit OwnershipTransferred(_owner, address(0));
83     _owner = address(0);
84   }
85 
86   /**
87    * @dev Transfers ownership of the contract to a new account (`newOwner`).
88    * Can only be called by the current owner.
89    */
90   function transferOwnership(address newOwner) public virtual onlyOwner {
91     require(newOwner != address(0), "Ownable: new owner is the zero address");
92     emit OwnershipTransferred(_owner, newOwner);
93     _owner = newOwner;
94   }
95 }
96 
97 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
98 
99 pragma solidity >=0.6.0 <0.8.0;
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
105   /**
106    * @dev Returns the amount of tokens in existence.
107    */
108   function totalSupply() external view returns (uint256);
109 
110   /**
111    * @dev Returns the amount of tokens owned by `account`.
112    */
113   function balanceOf(address account) external view returns (uint256);
114 
115   /**
116    * @dev Moves `amount` tokens from the caller's account to `recipient`.
117    *
118    * Returns a boolean value indicating whether the operation succeeded.
119    *
120    * Emits a {Transfer} event.
121    */
122   function transfer(address recipient, uint256 amount) external returns (bool);
123 
124   /**
125    * @dev Returns the remaining number of tokens that `spender` will be
126    * allowed to spend on behalf of `owner` through {transferFrom}. This is
127    * zero by default.
128    *
129    * This value changes when {approve} or {transferFrom} are called.
130    */
131   function allowance(address owner, address spender)
132     external
133     view
134     returns (uint256);
135 
136   /**
137    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138    *
139    * Returns a boolean value indicating whether the operation succeeded.
140    *
141    * IMPORTANT: Beware that changing an allowance with this method brings the risk
142    * that someone may use both the old and the new allowance by unfortunate
143    * transaction ordering. One possible solution to mitigate this race
144    * condition is to first reduce the spender's allowance to 0 and set the
145    * desired value afterwards:
146    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147    *
148    * Emits an {Approval} event.
149    */
150   function approve(address spender, uint256 amount) external returns (bool);
151 
152   /**
153    * @dev Moves `amount` tokens from `sender` to `recipient` using the
154    * allowance mechanism. `amount` is then deducted from the caller's
155    * allowance.
156    *
157    * Returns a boolean value indicating whether the operation succeeded.
158    *
159    * Emits a {Transfer} event.
160    */
161   function transferFrom(
162     address sender,
163     address recipient,
164     uint256 amount
165   ) external returns (bool);
166 
167   /**
168    * @dev Emitted when `value` tokens are moved from one account (`from`) to
169    * another (`to`).
170    *
171    * Note that `value` may be zero.
172    */
173   event Transfer(address indexed from, address indexed to, uint256 value);
174 
175   /**
176    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
177    * a call to {approve}. `value` is the new allowance.
178    */
179   event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 // File: @openzeppelin/contracts/math/SafeMath.sol
183 
184 /**
185  * @dev Wrappers over Solidity's arithmetic operations with added overflow
186  * checks.
187  *
188  * Arithmetic operations in Solidity wrap on overflow. This can easily result
189  * in bugs, because programmers usually assume that an overflow raises an
190  * error, which is the standard behavior in high level programming languages.
191  * `SafeMath` restores this intuition by reverting the transaction when an
192  * operation overflows.
193  *
194  * Using this library instead of the unchecked operations eliminates an entire
195  * class of bugs, so it's recommended to use it always.
196  */
197 library SafeMath {
198   /**
199    * @dev Returns the addition of two unsigned integers, with an overflow flag.
200    *
201    * _Available since v3.4._
202    */
203   function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
204     uint256 c = a + b;
205     if (c < a) return (false, 0);
206     return (true, c);
207   }
208 
209   /**
210    * @dev Returns the substraction of two unsigned integers, with an overflow flag.
211    *
212    * _Available since v3.4._
213    */
214   function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
215     if (b > a) return (false, 0);
216     return (true, a - b);
217   }
218 
219   /**
220    * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
221    *
222    * _Available since v3.4._
223    */
224   function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
226     // benefit is lost if 'b' is also tested.
227     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
228     if (a == 0) return (true, 0);
229     uint256 c = a * b;
230     if (c / a != b) return (false, 0);
231     return (true, c);
232   }
233 
234   /**
235    * @dev Returns the division of two unsigned integers, with a division by zero flag.
236    *
237    * _Available since v3.4._
238    */
239   function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240     if (b == 0) return (false, 0);
241     return (true, a / b);
242   }
243 
244   /**
245    * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
246    *
247    * _Available since v3.4._
248    */
249   function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250     if (b == 0) return (false, 0);
251     return (true, a % b);
252   }
253 
254   /**
255    * @dev Returns the addition of two unsigned integers, reverting on
256    * overflow.
257    *
258    * Counterpart to Solidity's `+` operator.
259    *
260    * Requirements:
261    *
262    * - Addition cannot overflow.
263    */
264   function add(uint256 a, uint256 b) internal pure returns (uint256) {
265     uint256 c = a + b;
266     require(c >= a, "SafeMath: addition overflow");
267     return c;
268   }
269 
270   /**
271    * @dev Returns the subtraction of two unsigned integers, reverting on
272    * overflow (when the result is negative).
273    *
274    * Counterpart to Solidity's `-` operator.
275    *
276    * Requirements:
277    *
278    * - Subtraction cannot overflow.
279    */
280   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281     require(b <= a, "SafeMath: subtraction overflow");
282     return a - b;
283   }
284 
285   /**
286    * @dev Returns the multiplication of two unsigned integers, reverting on
287    * overflow.
288    *
289    * Counterpart to Solidity's `*` operator.
290    *
291    * Requirements:
292    *
293    * - Multiplication cannot overflow.
294    */
295   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296     if (a == 0) return 0;
297     uint256 c = a * b;
298     require(c / a == b, "SafeMath: multiplication overflow");
299     return c;
300   }
301 
302   /**
303    * @dev Returns the integer division of two unsigned integers, reverting on
304    * division by zero. The result is rounded towards zero.
305    *
306    * Counterpart to Solidity's `/` operator. Note: this function uses a
307    * `revert` opcode (which leaves remaining gas untouched) while Solidity
308    * uses an invalid opcode to revert (consuming all remaining gas).
309    *
310    * Requirements:
311    *
312    * - The divisor cannot be zero.
313    */
314   function div(uint256 a, uint256 b) internal pure returns (uint256) {
315     require(b > 0, "SafeMath: division by zero");
316     return a / b;
317   }
318 
319   /**
320    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321    * reverting when dividing by zero.
322    *
323    * Counterpart to Solidity's `%` operator. This function uses a `revert`
324    * opcode (which leaves remaining gas untouched) while Solidity uses an
325    * invalid opcode to revert (consuming all remaining gas).
326    *
327    * Requirements:
328    *
329    * - The divisor cannot be zero.
330    */
331   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
332     require(b > 0, "SafeMath: modulo by zero");
333     return a % b;
334   }
335 
336   /**
337    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
338    * overflow (when the result is negative).
339    *
340    * CAUTION: This function is deprecated because it requires allocating memory for the error
341    * message unnecessarily. For custom revert reasons use {trySub}.
342    *
343    * Counterpart to Solidity's `-` operator.
344    *
345    * Requirements:
346    *
347    * - Subtraction cannot overflow.
348    */
349   function sub(
350     uint256 a,
351     uint256 b,
352     string memory errorMessage
353   ) internal pure returns (uint256) {
354     require(b <= a, errorMessage);
355     return a - b;
356   }
357 
358   /**
359    * @dev Returns the integer division of two unsigned integers, reverting with custom message on
360    * division by zero. The result is rounded towards zero.
361    *
362    * CAUTION: This function is deprecated because it requires allocating memory for the error
363    * message unnecessarily. For custom revert reasons use {tryDiv}.
364    *
365    * Counterpart to Solidity's `/` operator. Note: this function uses a
366    * `revert` opcode (which leaves remaining gas untouched) while Solidity
367    * uses an invalid opcode to revert (consuming all remaining gas).
368    *
369    * Requirements:
370    *
371    * - The divisor cannot be zero.
372    */
373   function div(
374     uint256 a,
375     uint256 b,
376     string memory errorMessage
377   ) internal pure returns (uint256) {
378     require(b > 0, errorMessage);
379     return a / b;
380   }
381 
382   /**
383    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
384    * reverting with custom message when dividing by zero.
385    *
386    * CAUTION: This function is deprecated because it requires allocating memory for the error
387    * message unnecessarily. For custom revert reasons use {tryMod}.
388    *
389    * Counterpart to Solidity's `%` operator. This function uses a `revert`
390    * opcode (which leaves remaining gas untouched) while Solidity uses an
391    * invalid opcode to revert (consuming all remaining gas).
392    *
393    * Requirements:
394    *
395    * - The divisor cannot be zero.
396    */
397   function mod(
398     uint256 a,
399     uint256 b,
400     string memory errorMessage
401   ) internal pure returns (uint256) {
402     require(b > 0, errorMessage);
403     return a % b;
404   }
405 }
406 
407 // File: contracts/Interfaces/TokenVestingInterface.sol
408 
409 pragma solidity 0.6.12;
410 
411 abstract contract TokenVestingInterface {
412   event VestingScheduleCreated(
413     address indexed vestingLocation,
414     uint32 cliffDuration,
415     uint32 duration,
416     uint32 interval,
417     bool isRevocable
418   );
419 
420   event VestingTokensGranted(
421     address indexed beneficiary,
422     uint256 vestingAmount,
423     uint32 startDay,
424     address vestingLocation
425   );
426 
427   event VestingTokensClaimed(address indexed beneficiary, uint256 amount);
428 
429   event GrantRevoked(address indexed grantHolder);
430 
431   struct vestingSchedule {
432     bool isRevocable; /* true if the vesting option is revocable (a gift), false if irrevocable (purchased) */
433     uint32 cliffDuration; /* Duration of the cliff, with respect to the grant start day, in days. */
434     uint32 duration; /* Duration of the vesting schedule, with respect to the grant start day, in days. */
435     uint32 interval; /* Duration in days of the vesting interval. */
436   }
437 
438   struct tokenGrant {
439     bool isActive; /* true if this vesting entry is active and in-effect entry. */
440     bool wasRevoked; /* true if this vesting schedule was revoked. */
441     uint32 startDay; /* Start day of the grant, in days since the UNIX epoch (start of day). */
442     uint256 amount; /* Total number of tokens that vest. */
443     address vestingLocation; /* Address of wallet that is holding the vesting schedule. */
444     uint256 claimedAmount; /* Out of vested amount, the amount that has been already transferred to beneficiary */
445   }
446 
447   function token() public view virtual returns (IERC20);
448 
449   function kill(address payable beneficiary) external virtual;
450 
451   function withdrawTokens(address beneficiary, uint256 amount) external virtual;
452 
453   // =========================================================================
454   // === Methods for claiming tokens.
455   // =========================================================================
456 
457   function claimVestingTokens(address beneficiary) external virtual;
458 
459   function claimVestingTokensForAll() external virtual;
460 
461   // =========================================================================
462   // === Methods for administratively creating a vesting schedule for an account.
463   // =========================================================================
464 
465   function setVestingSchedule(
466     address vestingLocation,
467     uint32 cliffDuration,
468     uint32 duration,
469     uint32 interval,
470     bool isRevocable
471   ) external virtual;
472 
473   // =========================================================================
474   // === Token grants (general-purpose)
475   // === Methods to be used for administratively creating one-off token grants with vesting schedules.
476   // =========================================================================
477 
478   function addGrant(
479     address beneficiary,
480     uint256 vestingAmount,
481     uint32 startDay,
482     uint32 duration,
483     uint32 cliffDuration,
484     uint32 interval,
485     bool isRevocable
486   ) public virtual;
487 
488   function addGrantWithScheduleAt(
489     address beneficiary,
490     uint256 vestingAmount,
491     uint32 startDay,
492     address vestingLocation
493   ) external virtual;
494 
495   function addGrantFromToday(
496     address beneficiary,
497     uint256 vestingAmount,
498     uint32 duration,
499     uint32 cliffDuration,
500     uint32 interval,
501     bool isRevocable
502   ) external virtual;
503 
504   // =========================================================================
505   // === Check vesting.
506   // =========================================================================
507 
508   function today() public view virtual returns (uint32 dayNumber);
509 
510   function getGrantInfo(address grantHolder, uint32 onDayOrToday)
511     external
512     view
513     virtual
514     returns (
515       uint256 amountVested,
516       uint256 amountNotVested,
517       uint256 amountOfGrant,
518       uint256 amountAvailable,
519       uint256 amountClaimed,
520       uint32 vestStartDay,
521       bool isActive,
522       bool wasRevoked
523     );
524 
525   function getScheduleAtInfo(address vestingLocation)
526     public
527     view
528     virtual
529     returns (
530       bool isRevocable,
531       uint32 vestDuration,
532       uint32 cliffDuration,
533       uint32 vestIntervalDays
534     );
535 
536   function getScheduleInfo(address grantHolder)
537     external
538     view
539     virtual
540     returns (
541       bool isRevocable,
542       uint32 vestDuration,
543       uint32 cliffDuration,
544       uint32 vestIntervalDays
545     );
546 
547   // =========================================================================
548   // === Grant revocation
549   // =========================================================================
550 
551   function revokeGrant(address grantHolder) external virtual;
552 }
553 
554 // File: contracts/Vesting/TokenVesting.sol
555 
556 // SPDX-License-Identifier: MIT
557 pragma solidity 0.6.12;
558 
559 /**
560  * @title Contract for token vesting schedules
561  *
562  * @dev Contract which gives the ability to act as a pool of funds for allocating
563  *   tokens to any number of other addresses. Token grants support the ability to vest over time in
564  *   accordance a predefined vesting schedule. A given wallet can receive no more than one token grant.
565  */
566 contract TokenVesting is TokenVestingInterface, Context, Ownable {
567   using SafeMath for uint256;
568 
569   // Date-related constants for sanity-checking dates to reject obvious erroneous inputs
570   // and conversions from seconds to days and years that are more or less leap year-aware.
571   uint32 private constant _THOUSAND_YEARS_DAYS = 365243; /* See https://www.timeanddate.com/date/durationresult.html?m1=1&d1=1&y1=2000&m2=1&d2=1&y2=3000 */
572   uint32 private constant _TEN_YEARS_DAYS = _THOUSAND_YEARS_DAYS / 100; /* Includes leap years (though it doesn't really matter) */
573   uint32 private constant _SECONDS_PER_DAY = 24 * 60 * 60; /* 86400 seconds in a day */
574   uint32 private constant _JAN_1_2000_SECONDS = 946684800; /* Saturday, January 1, 2000 0:00:00 (GMT) (see https://www.epochconverter.com/) */
575   uint32 private constant _JAN_1_2000_DAYS =
576     _JAN_1_2000_SECONDS / _SECONDS_PER_DAY;
577   uint32 private constant _JAN_1_3000_DAYS =
578     _JAN_1_2000_DAYS + _THOUSAND_YEARS_DAYS;
579 
580   modifier onlyOwnerOrSelf(address account) {
581     require(
582       _msgSender() == owner() || _msgSender() == account,
583       "onlyOwnerOrSelf"
584     );
585     _;
586   }
587 
588   mapping(address => vestingSchedule) private _vestingSchedules;
589   mapping(address => tokenGrant) private _tokenGrants;
590   address[] private _allBeneficiaries;
591   IERC20 private _token;
592 
593   constructor(IERC20 token_) public {
594     require(address(token_) != address(0), "token must be non-zero address");
595     _token = token_;
596   }
597 
598   function token() public view override returns (IERC20) {
599     return _token;
600   }
601 
602   function kill(address payable beneficiary) external override onlyOwner {
603     _withdrawTokens(beneficiary, token().balanceOf(address(this)));
604     selfdestruct(beneficiary);
605   }
606 
607   function withdrawTokens(address beneficiary, uint256 amount)
608     external
609     override
610     onlyOwner
611   {
612     _withdrawTokens(beneficiary, amount);
613   }
614 
615   function _withdrawTokens(address beneficiary, uint256 amount) internal {
616     require(amount > 0, "amount must be > 0");
617     require(
618       amount <= token().balanceOf(address(this)),
619       "amount must be <= current balance"
620     );
621 
622     require(token().transfer(beneficiary, amount));
623   }
624 
625   // =========================================================================
626   // === Methods for claiming tokens.
627   // =========================================================================
628 
629   function claimVestingTokens(address beneficiary)
630     external
631     override
632     onlyOwnerOrSelf(beneficiary)
633   {
634     _claimVestingTokens(beneficiary);
635   }
636 
637   function claimVestingTokensForAll() external override onlyOwner {
638     for (uint256 i = 0; i < _allBeneficiaries.length; i++) {
639       _claimVestingTokens(_allBeneficiaries[i]);
640     }
641   }
642 
643   function _claimVestingTokens(address beneficiary) internal {
644     uint256 amount = _getAvailableAmount(beneficiary, 0);
645     if (amount > 0) {
646       _deliverTokens(beneficiary, amount);
647       _tokenGrants[beneficiary].claimedAmount = _tokenGrants[beneficiary]
648         .claimedAmount
649         .add(amount);
650       emit VestingTokensClaimed(beneficiary, amount);
651     }
652   }
653 
654   function _deliverTokens(address beneficiary, uint256 amount) internal {
655     require(amount > 0, "amount must be > 0");
656     require(
657       amount <= token().balanceOf(address(this)),
658       "amount must be <= current balance"
659     );
660     require(
661       _tokenGrants[beneficiary].claimedAmount.add(amount) <=
662         _tokenGrants[beneficiary].amount,
663       "new claimed amount must be <= total grant amount"
664     );
665 
666     require(token().transfer(beneficiary, amount));
667   }
668 
669   // =========================================================================
670   // === Methods for administratively creating a vesting schedule for an account.
671   // =========================================================================
672 
673   /**
674    * @dev This one-time operation permanently establishes a vesting schedule in the given account.
675    *
676    * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
677    * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
678    * @param interval = Number of days between vesting increases.
679    * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
680    *   be revoked (i.e. tokens were purchased).
681    */
682   function setVestingSchedule(
683     address vestingLocation,
684     uint32 cliffDuration,
685     uint32 duration,
686     uint32 interval,
687     bool isRevocable
688   ) external override onlyOwner {
689     _setVestingSchedule(
690       vestingLocation,
691       cliffDuration,
692       duration,
693       interval,
694       isRevocable
695     );
696   }
697 
698   function _setVestingSchedule(
699     address vestingLocation,
700     uint32 cliffDuration,
701     uint32 duration,
702     uint32 interval,
703     bool isRevocable
704   ) internal {
705     // Check for a valid vesting schedule given (disallow absurd values to reject likely bad input).
706     require(
707       duration > 0 &&
708         duration <= _TEN_YEARS_DAYS &&
709         cliffDuration < duration &&
710         interval >= 1,
711       "invalid vesting schedule"
712     );
713 
714     // Make sure the duration values are in harmony with interval (both should be an exact multiple of interval).
715     require(
716       duration % interval == 0 && cliffDuration % interval == 0,
717       "invalid cliff/duration for interval"
718     );
719 
720     // Create and populate a vesting schedule.
721     _vestingSchedules[vestingLocation] = vestingSchedule(
722       isRevocable,
723       cliffDuration,
724       duration,
725       interval
726     );
727 
728     // Emit the event.
729     emit VestingScheduleCreated(
730       vestingLocation,
731       cliffDuration,
732       duration,
733       interval,
734       isRevocable
735     );
736   }
737 
738   // =========================================================================
739   // === Token grants (general-purpose)
740   // === Methods to be used for administratively creating one-off token grants with vesting schedules.
741   // =========================================================================
742 
743   /**
744    * @dev Grants tokens to an account.
745    *
746    * @param beneficiary = Address to which tokens will be granted.
747    * @param vestingAmount = The number of tokens subject to vesting.
748    * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
749    *   (start of day). The startDay may be given as a date in the future or in the past, going as far
750    *   back as year 2000.
751    * @param vestingLocation = Account where the vesting schedule is held (must already exist).
752    */
753   function _addGrant(
754     address beneficiary,
755     uint256 vestingAmount,
756     uint32 startDay,
757     address vestingLocation
758   ) internal {
759     // Make sure no prior grant is in effect.
760     require(!_tokenGrants[beneficiary].isActive, "grant already exists");
761 
762     // Check for valid vestingAmount
763     require(
764       vestingAmount > 0 &&
765         startDay >= _JAN_1_2000_DAYS &&
766         startDay < _JAN_1_3000_DAYS,
767       "invalid vesting params"
768     );
769 
770     // Create and populate a token grant, referencing vesting schedule.
771     _tokenGrants[beneficiary] = tokenGrant(
772       true, // isActive
773       false, // wasRevoked
774       startDay,
775       vestingAmount,
776       vestingLocation, // The wallet address where the vesting schedule is kept.
777       0 // claimedAmount
778     );
779     _allBeneficiaries.push(beneficiary);
780 
781     // Emit the event.
782     emit VestingTokensGranted(
783       beneficiary,
784       vestingAmount,
785       startDay,
786       vestingLocation
787     );
788   }
789 
790   /**
791    * @dev Grants tokens to an address, including a portion that will vest over time
792    * according to a set vesting schedule. The overall duration and cliff duration of the grant must
793    * be an even multiple of the vesting interval.
794    *
795    * @param beneficiary = Address to which tokens will be granted.
796    * @param vestingAmount = The number of tokens subject to vesting.
797    * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
798    *   (start of day). The startDay may be given as a date in the future or in the past, going as far
799    *   back as year 2000.
800    * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
801    * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
802    * @param interval = Number of days between vesting increases.
803    * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
804    *   be revoked (i.e. tokens were purchased).
805    */
806   function addGrant(
807     address beneficiary,
808     uint256 vestingAmount,
809     uint32 startDay,
810     uint32 duration,
811     uint32 cliffDuration,
812     uint32 interval,
813     bool isRevocable
814   ) public override onlyOwner {
815     // Make sure no prior vesting schedule has been set.
816     require(!_tokenGrants[beneficiary].isActive, "grant already exists");
817 
818     // The vesting schedule is unique to this wallet and so will be stored here,
819     _setVestingSchedule(
820       beneficiary,
821       cliffDuration,
822       duration,
823       interval,
824       isRevocable
825     );
826 
827     // Issue tokens to the beneficiary, using beneficiary's own vesting schedule.
828     _addGrant(beneficiary, vestingAmount, startDay, beneficiary);
829   }
830 
831   function addGrantWithScheduleAt(
832     address beneficiary,
833     uint256 vestingAmount,
834     uint32 startDay,
835     address vestingLocation
836   ) external override onlyOwner {
837     // Issue tokens to the beneficiary, using custom vestingLocation.
838     _addGrant(beneficiary, vestingAmount, startDay, vestingLocation);
839   }
840 
841   function addGrantFromToday(
842     address beneficiary,
843     uint256 vestingAmount,
844     uint32 duration,
845     uint32 cliffDuration,
846     uint32 interval,
847     bool isRevocable
848   ) external override onlyOwner {
849     addGrant(
850       beneficiary,
851       vestingAmount,
852       today(),
853       duration,
854       cliffDuration,
855       interval,
856       isRevocable
857     );
858   }
859 
860   // =========================================================================
861   // === Check vesting.
862   // =========================================================================
863   function today() public view virtual override returns (uint32 dayNumber) {
864     return uint32(block.timestamp / _SECONDS_PER_DAY);
865   }
866 
867   function _effectiveDay(uint32 onDayOrToday)
868     internal
869     view
870     returns (uint32 dayNumber)
871   {
872     return onDayOrToday == 0 ? today() : onDayOrToday;
873   }
874 
875   /**
876    * @dev Determines the amount of tokens that have not vested in the given account.
877    *
878    * The math is: not vested amount = vesting amount * (end date - on date)/(end date - start date)
879    *
880    * @param grantHolder = The account to check.
881    * @param onDayOrToday = The day to check for, in days since the UNIX epoch. Can pass
882    *   the special value 0 to indicate today.
883    */
884   function _getNotVestedAmount(address grantHolder, uint32 onDayOrToday)
885     internal
886     view
887     returns (uint256 amountNotVested)
888   {
889     tokenGrant storage grant = _tokenGrants[grantHolder];
890     vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
891     uint32 onDay = _effectiveDay(onDayOrToday);
892 
893     // If there's no schedule, or before the vesting cliff, then the full amount is not vested.
894     if (!grant.isActive || onDay < grant.startDay + vesting.cliffDuration) {
895       // None are vested (all are not vested)
896       return grant.amount;
897     }
898     // If after end of vesting, then the not vested amount is zero (all are vested).
899     else if (onDay >= grant.startDay + vesting.duration) {
900       // All are vested (none are not vested)
901       return uint256(0);
902     }
903     // Otherwise a fractional amount is vested.
904     else {
905       // Compute the exact number of days vested.
906       uint32 daysVested = onDay - grant.startDay;
907       // Adjust result rounding down to take into consideration the interval.
908       uint32 effectiveDaysVested = (daysVested / vesting.interval) *
909         vesting.interval;
910 
911       // Compute the fraction vested from schedule using 224.32 fixed point math for date range ratio.
912       // Note: This is safe in 256-bit math because max value of X billion tokens = X*10^27 wei, and
913       // typical token amounts can fit into 90 bits. Scaling using a 32 bits value results in only 125
914       // bits before reducing back to 90 bits by dividing. There is plenty of room left, even for token
915       // amounts many orders of magnitude greater than mere billions.
916       uint256 vested = grant.amount.mul(effectiveDaysVested).div(
917         vesting.duration
918       );
919       uint256 result = grant.amount.sub(vested);
920       require(result <= grant.amount && vested <= grant.amount);
921 
922       return result;
923     }
924   }
925 
926   /**
927    * @dev Computes the amount of funds in the given account which are available for use as of
928    * the given day, i.e. the claimable amount.
929    *
930    * The math is: available amount = totalGrantAmount - notVestedAmount - claimedAmount.
931    *
932    * @param grantHolder = The account to check.
933    * @param onDay = The day to check for, in days since the UNIX epoch.
934    */
935   function _getAvailableAmount(address grantHolder, uint32 onDay)
936     internal
937     view
938     returns (uint256 amountAvailable)
939   {
940     tokenGrant storage grant = _tokenGrants[grantHolder];
941     return
942       _getAvailableAmountImpl(grant, _getNotVestedAmount(grantHolder, onDay));
943   }
944 
945   function _getAvailableAmountImpl(
946     tokenGrant storage grant,
947     uint256 notVastedOnDay
948   ) internal view returns (uint256 amountAvailable) {
949     uint256 vested = grant.amount.sub(notVastedOnDay);
950     if (vested < grant.claimedAmount) {
951       // .sub below will fail, only possible when grant revoked
952       require(vested == 0 && grant.wasRevoked);
953       return 0;
954     }
955 
956     uint256 result = vested.sub(grant.claimedAmount);
957     require(
958       result <= grant.amount &&
959         grant.claimedAmount.add(result) <= grant.amount &&
960         result <= vested &&
961         vested <= grant.amount
962     );
963 
964     return result;
965   }
966 
967   /**
968    * @dev returns all information about the grant's vesting as of the given day
969    * for the given account. Only callable by the account holder or a contract owner.
970    *
971    * @param grantHolder = The address to do this for.
972    * @param onDayOrToday = The day to check for, in days since the UNIX epoch. Can pass
973    *   the special value 0 to indicate today.
974    * return = A tuple with the following values:
975    *   amountVested = the amount that is already vested
976    *   amountNotVested = the amount that is not yet vested (equal to vestingAmount - vestedAmount)
977    *   amountOfGrant = the total amount of tokens subject to vesting.
978    *   amountAvailable = the amount of funds in the given account which are available for use as of the given day
979    *   amountClaimed = out of amountVested, the amount that has been already transferred to beneficiary
980    *   vestStartDay = starting day of the grant (in days since the UNIX epoch).
981    *   isActive = true if the vesting schedule is currently active.
982    *   wasRevoked = true if the vesting schedule was revoked.
983    */
984   function getGrantInfo(address grantHolder, uint32 onDayOrToday)
985     external
986     view
987     override
988     returns (
989       uint256 amountVested,
990       uint256 amountNotVested,
991       uint256 amountOfGrant,
992       uint256 amountAvailable,
993       uint256 amountClaimed,
994       uint32 vestStartDay,
995       bool isActive,
996       bool wasRevoked
997     )
998   {
999     tokenGrant storage grant = _tokenGrants[grantHolder];
1000     uint256 notVestedAmount = _getNotVestedAmount(grantHolder, onDayOrToday);
1001 
1002     return (
1003       grant.amount.sub(notVestedAmount),
1004       notVestedAmount,
1005       grant.amount,
1006       _getAvailableAmountImpl(grant, notVestedAmount),
1007       grant.claimedAmount,
1008       grant.startDay,
1009       grant.isActive,
1010       grant.wasRevoked
1011     );
1012   }
1013 
1014   function getScheduleAtInfo(address vestingLocation)
1015     public
1016     view
1017     override
1018     returns (
1019       bool isRevocable,
1020       uint32 vestDuration,
1021       uint32 cliffDuration,
1022       uint32 vestIntervalDays
1023     )
1024   {
1025     vestingSchedule storage vesting = _vestingSchedules[vestingLocation];
1026 
1027     return (
1028       vesting.isRevocable,
1029       vesting.duration,
1030       vesting.cliffDuration,
1031       vesting.interval
1032     );
1033   }
1034 
1035   function getScheduleInfo(address grantHolder)
1036     external
1037     view
1038     override
1039     returns (
1040       bool isRevocable,
1041       uint32 vestDuration,
1042       uint32 cliffDuration,
1043       uint32 vestIntervalDays
1044     )
1045   {
1046     tokenGrant storage grant = _tokenGrants[grantHolder];
1047     return getScheduleAtInfo(grant.vestingLocation);
1048   }
1049 
1050   // =========================================================================
1051   // === Grant revocation
1052   // =========================================================================
1053 
1054   /**
1055    * @dev If the account has a revocable grant, this forces the grant to end immediately.
1056    * After this function is called, getGrantInfo will return incomplete data
1057    * and there will be no possibility to claim non-claimed tokens
1058    *
1059    * @param grantHolder = Address to which tokens will be granted.
1060    */
1061   function revokeGrant(address grantHolder) external override onlyOwner {
1062     tokenGrant storage grant = _tokenGrants[grantHolder];
1063     vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
1064 
1065     // Make sure a vesting schedule has previously been set.
1066     require(grant.isActive, "no active grant");
1067     // Make sure it's revocable.
1068     require(vesting.isRevocable, "irrevocable");
1069 
1070     // Kill the grant by updating wasRevoked and isActive.
1071     _tokenGrants[grantHolder].wasRevoked = true;
1072     _tokenGrants[grantHolder].isActive = false;
1073 
1074     // Emits the GrantRevoked event.
1075     emit GrantRevoked(grantHolder);
1076   }
1077 }