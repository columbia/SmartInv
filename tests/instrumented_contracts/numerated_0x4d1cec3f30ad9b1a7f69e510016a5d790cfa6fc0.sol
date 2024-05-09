1 // Sources flattened with hardhat v2.5.0 https://hardhat.org
2 
3 // File contracts/access/Context.sol
4 
5 // SPDX-License-Identifier: MIT;
6 
7 pragma solidity ^0.7.6;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20   function _msgSender()
21     internal
22     view
23     virtual
24     returns (address payable)
25   {
26     return msg.sender;
27   }
28 
29   function _msgData() internal view virtual returns (bytes memory) {
30     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31     return msg.data;
32   }
33 }
34 
35 // File contracts/access/Pausable.sol
36 
37 pragma solidity >=0.6.0 <=0.8.0;
38 
39 /**
40  * @dev Contract module which allows children to implement an emergency stop
41  * mechanism that can be triggered by an authorized account.
42  *
43  * This module is used through inheritance. It will make available the
44  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
45  * the functions of your contract. Note that they will not be pausable by
46  * simply including this module, only once the modifiers are put in place.
47  */
48 
49 abstract contract Pausable is Context {
50   /**
51    * @dev Emitted when the pause is triggered by `account`.
52    */
53   event Paused(address account);
54 
55   /**
56    * @dev Emitted when the pause is lifted by `account`.
57    */
58   event Unpaused(address account);
59 
60   bool private _paused;
61 
62   /**
63    * @dev Initializes the contract in unpaused state.
64    */
65   constructor() {
66     _paused = false;
67   }
68 
69   /**
70    * @dev Returns true if the contract is paused, and false otherwise.
71    */
72   function paused() public view virtual returns (bool) {
73     return _paused;
74   }
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is not paused.
78    *
79    * Requirements:
80    *
81    * - The contract must not be paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused(), "Pausable: paused");
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    *
91    * Requirements:
92    *
93    * - The contract must be paused.
94    */
95   modifier whenPaused() {
96     require(paused(), "Pausable: not paused");
97     _;
98   }
99 
100   /**
101    * @dev Triggers stopped state.
102    *
103    * Requirements:
104    *
105    * - The contract must not be paused.
106    */
107   function _pause() internal virtual whenNotPaused {
108     _paused = true;
109     emit Paused(_msgSender());
110   }
111 
112   /**
113    * @dev Returns to normal state.
114    *
115    * Requirements:
116    *
117    * - The contract must be paused.
118    */
119   function _unpause() internal virtual whenPaused {
120     _paused = false;
121     emit Unpaused(_msgSender());
122   }
123 }
124 
125 // File contracts/access/Ownable.sol
126 
127 pragma solidity >=0.6.0 <=0.8.0;
128 
129 abstract contract Ownable is Pausable {
130   address public _owner;
131   address public _admin;
132 
133   event OwnershipTransferred(
134     address indexed previousOwner,
135     address indexed newOwner
136   );
137 
138   /**
139    * @dev Initializes the contract setting the deployer as the initial owner.
140    */
141   constructor(address ownerAddress) {
142     _owner = ownerAddress;
143     _admin = ownerAddress;
144     emit OwnershipTransferred(address(0), _owner);
145   }
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(
152       _owner == _msgSender(),
153       "Ownable: caller is not the owner"
154     );
155     _;
156   }
157 
158   /**
159    * @dev Throws if called by any account other than the owner.
160    */
161   modifier onlyAdmin() {
162     require(
163       _admin == _msgSender(),
164       "Ownable: caller is not the Admin"
165     );
166     _;
167   }
168 
169   /**
170    * @dev Leaves the contract without owner. It will not be possible to call
171    * `onlyOwner` functions anymore. Can only be called by the current owner.
172    *
173    * NOTE: Renouncing ownership will leave the contract without an owner,
174    * thereby removing any functionality that is only available to the owner.
175    */
176   function renounceOwnership() public onlyAdmin {
177     emit OwnershipTransferred(_owner, _admin);
178     _owner = _admin;
179   }
180 
181   /**
182    * @dev Transfers ownership of the contract to a new account (`newOwner`).
183    * Can only be called by the current owner.
184    */
185   function transferOwnership(address newOwner)
186     public
187     virtual
188     onlyOwner
189   {
190     require(
191       newOwner != address(0),
192       "Ownable: new owner is the zero address"
193     );
194     emit OwnershipTransferred(_owner, newOwner);
195     _owner = newOwner;
196   }
197 }
198 
199 // File contracts/abstract/CohortStaking.sol
200 
201 pragma solidity ^0.7.6;
202 
203 abstract contract CohortStaking {
204   struct tokenInfo {
205     bool isExist;
206     uint8 decimal;
207     uint256 userMinStake;
208     uint256 userMaxStake;
209     uint256 totalMaxStake;
210     uint256 lockableDays;
211     bool optionableStatus;
212   }
213 
214   mapping(address => tokenInfo) public tokenDetails;
215   mapping(address => uint256) public totalStaking;
216   mapping(address => address[]) public tokensSequenceList;
217 
218   mapping(address => mapping(address => uint256))
219     public tokenDailyDistribution;
220 
221   mapping(address => mapping(address => bool))
222     public tokenBlockedStatus;
223 
224   uint256 public refPercentage;
225   uint256 public poolStartTime;
226   uint256 public stakeDuration;
227 
228   function viewStakingDetails(address _user)
229     public
230     view
231     virtual
232     returns (
233       address[] memory,
234       address[] memory,
235       bool[] memory,
236       uint256[] memory,
237       uint256[] memory,
238       uint256[] memory
239     );
240 
241   function safeWithdraw(address tokenAddress, uint256 amount)
242     public
243     virtual;
244 
245   function transferOwnership(address newOwner) public virtual;
246 }
247 
248 // File contracts/libraries/SafeMath.sol
249 
250 pragma solidity ^0.7.6;
251 
252 /**
253  * @dev Wrappers over Solidity's arithmetic operations with added overflow
254  * checks.
255  *
256  * Arithmetic operations in Solidity wrap on overflow. This can easily result
257  * in bugs, because programmers usually assume that an overflow raises an
258  * error, which is the standard behavior in high level programming languages.
259  * `SafeMath` restores this intuition by reverting the transaction when an
260  * operation overflows.
261  *
262  * Using this library instead of the unchecked operations eliminates an entire
263  * class of bugs, so it's recommended to use it always.
264  */
265 
266 library SafeMath {
267   /**
268    * @dev Returns the addition of two unsigned integers, reverting on
269    * overflow.
270    *
271    * Counterpart to Solidity's `+` operator.
272    *
273    * Requirements:
274    *
275    * - Addition cannot overflow.
276    */
277   function add(uint256 a, uint256 b) internal pure returns (uint256) {
278     uint256 c = a + b;
279     require(c >= a, "SafeMath: addition overflow");
280 
281     return c;
282   }
283 
284   /**
285    * @dev Returns the subtraction of two unsigned integers, reverting on
286    * overflow (when the result is negative).
287    *
288    * Counterpart to Solidity's `-` operator.
289    *
290    * Requirements:
291    *
292    * - Subtraction cannot overflow.
293    */
294   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
295     return sub(a, b, "SafeMath: subtraction overflow");
296   }
297 
298   /**
299    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
300    * overflow (when the result is negative).
301    *
302    * Counterpart to Solidity's `-` operator.
303    *
304    * Requirements:
305    *
306    * - Subtraction cannot overflow.
307    */
308   function sub(
309     uint256 a,
310     uint256 b,
311     string memory errorMessage
312   ) internal pure returns (uint256) {
313     require(b <= a, errorMessage);
314     uint256 c = a - b;
315 
316     return c;
317   }
318 
319   /**
320    * @dev Returns the multiplication of two unsigned integers, reverting on
321    * overflow.
322    *
323    * Counterpart to Solidity's `*` operator.
324    *
325    * Requirements:
326    *
327    * - Multiplication cannot overflow.
328    */
329   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
330     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
331     // benefit is lost if 'b' is also tested.
332     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
333     if (a == 0) {
334       return 0;
335     }
336 
337     uint256 c = a * b;
338     require(c / a == b, "SafeMath: multiplication overflow");
339 
340     return c;
341   }
342 
343   /**
344    * @dev Returns the integer division of two unsigned integers. Reverts on
345    * division by zero. The result is rounded towards zero.
346    *
347    * Counterpart to Solidity's `/` operator. Note: this function uses a
348    * `revert` opcode (which leaves remaining gas untouched) while Solidity
349    * uses an invalid opcode to revert (consuming all remaining gas).
350    *
351    * Requirements:
352    *
353    * - The divisor cannot be zero.
354    */
355   function div(uint256 a, uint256 b) internal pure returns (uint256) {
356     return div(a, b, "SafeMath: division by zero");
357   }
358 
359   /**
360    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
361    * division by zero. The result is rounded towards zero.
362    *
363    * Counterpart to Solidity's `/` operator. Note: this function uses a
364    * `revert` opcode (which leaves remaining gas untouched) while Solidity
365    * uses an invalid opcode to revert (consuming all remaining gas).
366    *
367    * Requirements:
368    *
369    * - The divisor cannot be zero.
370    */
371   function div(
372     uint256 a,
373     uint256 b,
374     string memory errorMessage
375   ) internal pure returns (uint256) {
376     require(b > 0, errorMessage);
377     uint256 c = a / b;
378 
379     return c;
380   }
381 
382   /**
383    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
384    * Reverts when dividing by zero.
385    *
386    * Counterpart to Solidity's `%` operator. This function uses a `revert`
387    * opcode (which leaves remaining gas untouched) while Solidity uses an
388    * invalid opcode to revert (consuming all remaining gas).
389    *
390    * Requirements:
391    *
392    * - The divisor cannot be zero.
393    */
394   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
395     return mod(a, b, "SafeMath: modulo by zero");
396   }
397 
398   /**
399    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
400    * Reverts with custom message when dividing by zero.
401    *
402    * Counterpart to Solidity's `%` operator. This function uses a `revert`
403    * opcode (which leaves remaining gas untouched) while Solidity uses an
404    * invalid opcode to revert (consuming all remaining gas).
405    *
406    * Requirements:
407    *
408    * - The divisor cannot be zero.
409    */
410   function mod(
411     uint256 a,
412     uint256 b,
413     string memory errorMessage
414   ) internal pure returns (uint256) {
415     require(b != 0, errorMessage);
416     return a % b;
417   }
418 }
419 
420 // File contracts/interfaces/IERC20.sol
421 
422 pragma solidity ^0.7.6;
423 
424 /**
425  * @dev Interface of the ERC20 standard as defined in the EIP.
426  */
427 interface IERC20 {
428   /**
429    * @dev Returns the amount of tokens in existence.
430    */
431   function totalSupply() external view returns (uint256);
432 
433   /**
434    * @dev Returns the amount of tokens owned by `account`.
435    */
436   function balanceOf(address account) external view returns (uint256);
437 
438   /**
439    * @dev Moves `amount` tokens from the caller's account to `recipient`.
440    *
441    * Returns a boolean value indicating whether the operation succeeded.
442    *
443    * Emits a {Transfer} event.
444    */
445   function transfer(address recipient, uint256 amount)
446     external
447     returns (bool);
448 
449   /**
450    * @dev Returns the remaining number of tokens that `spender` will be
451    * allowed to spend on behalf of `owner` through {transferFrom}. This is
452    * zero by default.
453    *
454    * This value changes when {approve} or {transferFrom} are called.
455    */
456   function allowance(address owner, address spender)
457     external
458     view
459     returns (uint256);
460 
461   /**
462    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
463    *
464    * Returns a boolean value indicating whether the operation succeeded.
465    *
466    * IMPORTANT: Beware that changing an allowance with this method brings the risk
467    * that someone may use both the old and the new allowance by unfortunate
468    * transaction ordering. One possible solution to mitigate this race
469    * condition is to first reduce the spender's allowance to 0 and set the
470    * desired value afterwards:
471    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
472    *
473    * Emits an {Approval} event.
474    */
475   function approve(address spender, uint256 amount)
476     external
477     returns (bool);
478 
479   /**
480    * @dev Moves `amount` tokens from `sender` to `recipient` using the
481    * allowance mechanism. `amount` is then deducted from the caller's
482    * allowance.
483    *
484    * Returns a boolean value indicating whether the operation succeeded.
485    *
486    * Emits a {Transfer} event.
487    */
488   function transferFrom(
489     address sender,
490     address recipient,
491     uint256 amount
492   ) external returns (bool);
493 
494   /**
495    * @dev Emitted when `value` tokens are moved from one account (`from`) to
496    * another (`to`).
497    *
498    * Note that `value` may be zero.
499    */
500   event Transfer(
501     address indexed from,
502     address indexed to,
503     uint256 value
504   );
505 
506   /**
507    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
508    * a call to {approve}. `value` is the new allowance.
509    */
510   event Approval(
511     address indexed owner,
512     address indexed spender,
513     uint256 value
514   );
515 }
516 
517 // File contracts/interfaces/ICohort.sol
518 
519 pragma solidity ^0.7.6;
520 
521 interface ICohort {
522   function setupCohort(uint256[] memory _intervalDays, bool _isSwapfy)
523     external
524     returns (bool);
525 }
526 
527 // File contracts/Cohort.sol
528 
529 pragma solidity ^0.7.6;
530 
531 /**
532  * @title Unifarm Cohort Unstake Handler Contract
533  * @author Opendefi by OroPocket
534  */
535 
536 contract Cohort is Ownable, ICohort {
537   /// @notice LockableToken struct for storing token lockable details
538   struct LockableTokens {
539     uint256 lockableDays;
540     bool optionableStatus;
541   }
542 
543   /// @notice Wrappers over Solidity's arithmetic operations
544   using SafeMath for uint256;
545 
546   /// @notice totalStaking of a specfic tokenAddress.
547   mapping(address => uint256) public totalUnStaking;
548 
549   /// @notice tokens old to new token swap
550   mapping(address => address) public tokens;
551 
552   /// @notice unStakeStatus of a user.
553   mapping(address => mapping(uint256 => bool)) public unStakeStatus;
554 
555   /// @notice tokenBlocked status.
556   mapping(address => bool) public tokenBlockedStatus;
557 
558   /// @notice lockable token mapping
559   mapping(address => LockableTokens) public lockableDetails;
560 
561   /// @notice cohort instance.
562   CohortStaking public cohort;
563 
564   /// @notice DAYS is equal to 86400.
565   uint256 public DAYS = 1 days;
566 
567   /// @notice HOURS is equal to 3600.
568   uint256 public HOURS = 1 hours;
569 
570   /// @notice intervalDays
571   uint256[] public intervalDays;
572 
573   /// @notice poolStartTime
574   uint256 public poolStartTime;
575 
576   /// @notice stakeDuration
577   uint256 public stakeDuration;
578 
579   /// @notice isSwapify
580   bool public swapiFy;
581 
582   /// @notice factory
583   address public factory;
584 
585   event LockableTokenDetails(
586     address indexed tokenAddress,
587     uint256 lockableDys,
588     bool optionalbleStatus,
589     uint256 updatedTime
590   );
591 
592   event WithdrawDetails(
593     address indexed tokenAddress,
594     uint256 withdrawalAmount,
595     uint256 time
596   );
597 
598   event Claim(
599     address indexed userAddress,
600     address indexed stakedTokenAddress,
601     address indexed tokenAddress,
602     uint256 claimRewards,
603     uint256 time
604   );
605 
606   event UnStake(
607     address indexed userAddress,
608     address indexed unStakedtokenAddress,
609     uint256 unStakedAmount,
610     uint256 time,
611     uint256 stakeId
612   );
613 
614   event ReferralEarn(
615     address indexed userAddress,
616     address indexed callerAddress,
617     address indexed rewardTokenAddress,
618     uint256 rewardAmount,
619     uint256 time
620   );
621 
622   event IntervalDaysDetails(uint256[] updatedIntervals, uint256 time);
623 
624   /**
625    * @notice construct the cohort unstake handler.
626    * @param cohortAddress specfic cohortAddress.
627    * @param ownerAddress owner Address of a cohort.
628    */
629 
630   constructor(
631     address cohortAddress,
632     address ownerAddress,
633     address factoryAddress
634   ) Ownable(ownerAddress) {
635     require(
636       cohortAddress != address(0),
637       "Cohort: invalid cohortAddress"
638     );
639     cohort = CohortStaking(cohortAddress);
640     factory = factoryAddress;
641   }
642 
643   function setupCohort(uint256[] memory _intervalDays, bool _isSwapfy)
644     external
645     override
646     returns (bool)
647   {
648     require(_msgSender() == factory, "Cohort: permission denied");
649     swapiFy = _isSwapfy;
650     poolStartTime = cohort.poolStartTime();
651     stakeDuration = cohort.stakeDuration();
652     updateIntervalDays(_intervalDays);
653     return true;
654   }
655 
656   function setTokenBlockedStatus(address tokenAddress, bool status)
657     external
658     onlyOwner
659     returns (bool)
660   {
661     tokenBlockedStatus[tokenAddress] = status;
662     return true;
663   }
664 
665   // make sure about ownership things before call this function.
666   function init(address[] memory tokenAddress)
667     external
668     onlyOwner
669     returns (bool)
670   {
671     for (uint256 i = 0; i < tokenAddress.length; i++) {
672       transferFromCohort(tokenAddress[i]);
673     }
674 
675     return true;
676   }
677 
678   function transferFromCohort(address tokenAddress) internal {
679     uint256 bal = IERC20(tokenAddress).balanceOf(address(cohort));
680     if (bal > 0) cohort.safeWithdraw(tokenAddress, bal);
681   }
682 
683   function updateCohort(address _newCohortAddress)
684     external
685     onlyOwner
686     returns (bool)
687   {
688     cohort = CohortStaking(_newCohortAddress);
689     return true;
690   }
691 
692   function setSwapTokens(
693     address[] memory oldTokenAddresses,
694     address[] memory newTokenAddresses
695   ) external onlyOwner returns (bool) {
696     require(
697       oldTokenAddresses.length == newTokenAddresses.length,
698       "Invalid Input Tokens"
699     );
700     for (uint8 m = 0; m < oldTokenAddresses.length; m++) {
701       tokens[oldTokenAddresses[m]] = newTokenAddresses[m];
702     }
703     return true;
704   }
705 
706   function updateTotalUnStaking(
707     address[] memory tokenAddresses,
708     uint256[] memory overAllUnStakedTokens
709   ) external onlyOwner returns (bool) {
710     require(
711       tokenAddresses.length == overAllUnStakedTokens.length,
712       "Cohort: Invalid Inputs"
713     );
714     for (uint8 n = 0; n < tokenAddresses.length; n++) {
715       require(
716         tokenAddresses[n] != address(0),
717         "Cohort: invalid poolAddress"
718       );
719       require(
720         overAllUnStakedTokens[n] > 0,
721         "Cohort: emptied overAllStaked"
722       );
723       totalUnStaking[tokenAddresses[n]] = overAllUnStakedTokens[n];
724     }
725     return true;
726   }
727 
728   function updateIntervalDays(uint256[] memory _interval) public {
729     require(
730       _msgSender() == factory || _msgSender() == _owner,
731       "Cohort: permission denied"
732     );
733     intervalDays = new uint256[](0);
734     for (uint8 i = 0; i < _interval.length; i++) {
735       uint256 noD = stakeDuration.div(DAYS);
736       require(noD > _interval[i], "Invalid Interval Day");
737       intervalDays.push(_interval[i]);
738     }
739 
740     emit IntervalDaysDetails(intervalDays, block.timestamp);
741   }
742 
743   function lockableToken(
744     address tokenAddress,
745     uint8 lockableStatus,
746     uint256 lockedDays,
747     bool optionableStatus
748   ) external onlyOwner {
749     require(
750       lockableStatus == 1 ||
751         lockableStatus == 2 ||
752         lockableStatus == 3,
753       "Invalid Lockable Status"
754     );
755 
756     (bool tokenExist, , , , , , ) = cohort.tokenDetails(tokenAddress);
757 
758     require(tokenExist == true, "Token Not Exist");
759 
760     if (lockableStatus == 1) {
761       lockableDetails[tokenAddress].lockableDays = block
762         .timestamp
763         .add(lockedDays);
764     } else if (lockableStatus == 2)
765       lockableDetails[tokenAddress].lockableDays = 0;
766     else if (lockableStatus == 3)
767       lockableDetails[tokenAddress]
768         .optionableStatus = optionableStatus;
769 
770     emit LockableTokenDetails(
771       tokenAddress,
772       lockableDetails[tokenAddress].lockableDays,
773       lockableDetails[tokenAddress].optionableStatus,
774       block.timestamp
775     );
776   }
777 
778   function reclaimOwnership(address newOwner)
779     external
780     onlyOwner
781     returns (bool)
782   {
783     cohort.transferOwnership(newOwner);
784     return true;
785   }
786 
787   function safeWithdraw(address tokenAddress, uint256 amount)
788     external
789     onlyOwner
790   {
791     require(
792       IERC20(tokenAddress).balanceOf(address(this)) >= amount,
793       "SAFEWITHDRAW: Insufficient Balance"
794     );
795 
796     require(
797       IERC20(tokenAddress).transfer(_owner, amount) == true,
798       "SAFEWITHDRAW: Transfer failed"
799     );
800 
801     emit WithdrawDetails(tokenAddress, amount, block.timestamp);
802   }
803 
804   function getTokenAddress(address tokenAddress)
805     internal
806     view
807     returns (address)
808   {
809     if (swapiFy) {
810       address newAddress = tokens[tokenAddress] == address(0)
811         ? tokenAddress
812         : tokens[tokenAddress];
813       return (newAddress);
814     } else {
815       return (tokenAddress);
816     }
817   }
818 
819   /**
820    * @notice Claim accumulated rewards
821    * @param userAddress user Address through he staked.
822    * @param stakeId Stake ID of the user
823    * @param totalStake total Staking.
824    */
825 
826   function claimRewards(
827     address userAddress,
828     uint256 stakeId,
829     uint256 totalStake
830   ) internal {
831     // Local variables
832     uint256 interval;
833     uint256 endOfProfit;
834 
835     (
836       address[] memory referrar,
837       address[] memory tokenAddresses,
838       ,
839       ,
840       uint256[] memory stakedAmount,
841       uint256[] memory startTime
842     ) = cohort.viewStakingDetails(userAddress);
843 
844     interval = poolStartTime.add(stakeDuration);
845     // Interval calculation
846     if (interval > block.timestamp) endOfProfit = block.timestamp;
847     else endOfProfit = poolStartTime.add(stakeDuration);
848 
849     interval = endOfProfit.sub(startTime[stakeId]);
850 
851     uint256 refPercentage = cohort.refPercentage();
852     uint256[3] memory stakeData;
853 
854     stakeData[0] = (stakedAmount[stakeId]);
855     stakeData[1] = (totalStake);
856     stakeData[2] = (refPercentage);
857 
858     // Reward calculation
859     if (interval >= HOURS)
860       _rewardCalculation(
861         userAddress,
862         tokenAddresses[stakeId],
863         referrar[stakeId],
864         stakeData,
865         interval
866       );
867   }
868 
869   function _rewardCalculation(
870     address userAddress,
871     address tokenAddress,
872     address referrer,
873     uint256[3] memory stakingData,
874     uint256 interval
875   ) internal {
876     uint256 rewardsEarned;
877     uint256 refEarned;
878     uint256[2] memory noOfDays;
879 
880     noOfDays[1] = interval.div(HOURS);
881     noOfDays[0] = interval.div(DAYS);
882 
883     rewardsEarned = noOfDays[1].mul(
884       getOneDayReward(
885         stakingData[0],
886         tokenAddress,
887         tokenAddress,
888         stakingData[1]
889       )
890     );
891 
892     address stakedToken = getTokenAddress(tokenAddress);
893 
894     // Referrer Earning
895     if (referrer != address(0)) {
896       refEarned = (rewardsEarned.mul(stakingData[2])).div(100 ether);
897       rewardsEarned = rewardsEarned.sub(refEarned);
898 
899       require(
900         IERC20(stakedToken).transfer(referrer, refEarned) == true,
901         "Transfer Failed"
902       );
903 
904       emit ReferralEarn(
905         referrer,
906         _msgSender(),
907         stakedToken,
908         refEarned,
909         block.timestamp
910       );
911     }
912     //  Rewards Send
913     sendToken(userAddress, stakedToken, stakedToken, rewardsEarned);
914 
915     uint8 i = 1;
916 
917     while (i < intervalDays.length) {
918       if (noOfDays[0] >= intervalDays[i]) {
919         uint256 reductionHours = (intervalDays[i].sub(1)).mul(24);
920         uint256 balHours = noOfDays[1].sub(reductionHours);
921         address rewardToken = cohort.tokensSequenceList(
922           tokenAddress,
923           i
924         );
925 
926         if (
927           rewardToken != tokenAddress &&
928           cohort.tokenBlockedStatus(tokenAddress, rewardToken) ==
929           false
930         ) {
931           rewardsEarned = balHours.mul(
932             getOneDayReward(
933               stakingData[0],
934               tokenAddress,
935               rewardToken,
936               stakingData[1]
937             )
938           );
939 
940           address rewardToken1 = getTokenAddress(rewardToken);
941           // Referrer Earning
942 
943           if (referrer != address(0)) {
944             refEarned = (rewardsEarned.mul(stakingData[2])).div(
945               100 ether
946             );
947             rewardsEarned = rewardsEarned.sub(refEarned);
948 
949             require(
950               IERC20(rewardToken1).transfer(referrer, refEarned) ==
951                 true,
952               "Transfer Failed"
953             );
954 
955             emit ReferralEarn(
956               referrer,
957               _msgSender(),
958               rewardToken1,
959               refEarned,
960               block.timestamp
961             );
962           }
963           //  Rewards Send
964           sendToken(
965             userAddress,
966             tokenAddress,
967             rewardToken1,
968             rewardsEarned
969           );
970         }
971         i = i + 1;
972       } else {
973         break;
974       }
975     }
976   }
977 
978   /**
979    * @notice Get rewards for one day
980    * @param stakedAmount Stake amount of the user
981    * @param stakedToken Staked token address of the user
982    * @param rewardToken Reward token address
983    * @return reward One dayh reward for the user
984    */
985 
986   function getOneDayReward(
987     uint256 stakedAmount,
988     address stakedToken,
989     address rewardToken,
990     uint256 totalStake
991   ) public view returns (uint256 reward) {
992     reward = (
993       stakedAmount.mul(
994         cohort.tokenDailyDistribution(stakedToken, rewardToken)
995       )
996     ).div(totalStake);
997   }
998 
999   /**
1000    * @notice Get rewards for one day
1001    * @param stakedToken Stake amount of the user
1002    * @param tokenAddress Reward token address
1003    * @param amount Amount to be transferred as reward
1004    */
1005 
1006   function sendToken(
1007     address userAddress,
1008     address stakedToken,
1009     address tokenAddress,
1010     uint256 amount
1011   ) internal {
1012     // Checks
1013     if (tokenAddress != address(0)) {
1014       require(
1015         IERC20(tokenAddress).balanceOf(address(this)) >= amount,
1016         "SEND : Insufficient Reward Balance"
1017       );
1018 
1019       require(
1020         IERC20(tokenAddress).transfer(userAddress, amount),
1021         "Transfer failed"
1022       );
1023 
1024       // Emit state changes
1025       emit Claim(
1026         userAddress,
1027         stakedToken,
1028         tokenAddress,
1029         amount,
1030         block.timestamp
1031       );
1032     }
1033   }
1034 
1035   function getTotalStaking(address tokenAddress)
1036     public
1037     view
1038     returns (uint256)
1039   {
1040     uint256 totalStaking = cohort.totalStaking(tokenAddress);
1041     uint256 actualStaking = totalStaking.add(
1042       totalUnStaking[tokenAddress]
1043     );
1044     return actualStaking;
1045   }
1046 
1047   /**
1048    * @notice Unstake and claim rewards
1049    * @param stakeId Stake ID of the user
1050    */
1051   function unStake(address userAddress, uint256 stakeId)
1052     external
1053     whenNotPaused
1054     returns (bool)
1055   {
1056     require(
1057       _msgSender() == userAddress || _msgSender() == _owner,
1058       "UNSTAKE: Invalid User Entry"
1059     );
1060 
1061     // view the staking details
1062     (
1063       ,
1064       address[] memory tokenAddress,
1065       bool[] memory isActive,
1066       ,
1067       uint256[] memory stakedAmount,
1068       uint256[] memory startTime
1069     ) = cohort.viewStakingDetails(userAddress);
1070 
1071     uint256 totalStaking = getTotalStaking(tokenAddress[stakeId]);
1072     address stakedToken = getTokenAddress(tokenAddress[stakeId]);
1073 
1074     // lockableDays check
1075     require(
1076       lockableDetails[stakedToken].lockableDays <= block.timestamp,
1077       "UNSTAKE: Token Locked"
1078     );
1079 
1080     // optional lock check
1081     if (lockableDetails[stakedToken].optionableStatus == true)
1082       require(
1083         startTime[stakeId].add(stakeDuration) <= block.timestamp,
1084         "UNSTAKE: Locked in optional lock"
1085       );
1086 
1087     // Checks
1088     require(
1089       stakedAmount[stakeId] > 0 &&
1090         isActive[stakeId] == true &&
1091         unStakeStatus[userAddress][stakeId] == false,
1092       "UNSTAKE : Already Claimed (or) Insufficient Staked"
1093     );
1094 
1095     // update the state
1096     unStakeStatus[userAddress][stakeId] = true;
1097 
1098     // Balance check
1099     require(
1100       IERC20(stakedToken).balanceOf(address(this)) >=
1101         stakedAmount[stakeId],
1102       "UNSTAKE : Insufficient Balance"
1103     );
1104 
1105     // Transfer staked token back to user
1106     if (tokenBlockedStatus[tokenAddress[stakeId]] == false) {
1107       IERC20(stakedToken).transfer(
1108         userAddress,
1109         stakedAmount[stakeId]
1110       );
1111     }
1112 
1113     claimRewards(userAddress, stakeId, totalStaking);
1114     // Emit state changes
1115     emit UnStake(
1116       userAddress,
1117       stakedToken,
1118       stakedAmount[stakeId],
1119       block.timestamp,
1120       stakeId
1121     );
1122 
1123     return true;
1124   }
1125 
1126   function emergencyUnstake(
1127     uint256 stakeId,
1128     address userAddress,
1129     address[] memory rewardtokens,
1130     uint256[] memory amount
1131   ) external onlyOwner {
1132     // view the staking details
1133     (
1134       address[] memory referrer,
1135       address[] memory tokenAddress,
1136       bool[] memory isActive,
1137       ,
1138       uint256[] memory stakedAmount,
1139 
1140     ) = cohort.viewStakingDetails(userAddress);
1141 
1142     require(
1143       stakedAmount[stakeId] > 0 &&
1144         isActive[stakeId] == true &&
1145         unStakeStatus[userAddress][stakeId] == false,
1146       "EMERGENCY : Already Claimed (or) Insufficient Staked"
1147     );
1148 
1149     address stakedToken = getTokenAddress(tokenAddress[stakeId]);
1150     // Balance check
1151     require(
1152       IERC20(stakedToken).balanceOf(address(this)) >=
1153         stakedAmount[stakeId],
1154       "EMERGENCY : Insufficient Balance"
1155     );
1156 
1157     unStakeStatus[userAddress][stakeId] = true;
1158 
1159     IERC20(stakedToken).transfer(userAddress, stakedAmount[stakeId]);
1160 
1161     uint256 refPercentage = cohort.refPercentage();
1162 
1163     for (uint256 i; i < rewardtokens.length; i++) {
1164       uint256 rewardsEarned = amount[i];
1165 
1166       if (referrer[stakeId] != address(0)) {
1167         uint256 refEarned = (rewardsEarned.mul(refPercentage)).div(
1168           100 ether
1169         );
1170         rewardsEarned = rewardsEarned.sub(refEarned);
1171 
1172         require(
1173           IERC20(rewardtokens[i]).transfer(
1174             referrer[stakeId],
1175             refEarned
1176           ),
1177           "EMERGENCY : Transfer Failed"
1178         );
1179 
1180         emit ReferralEarn(
1181           referrer[stakeId],
1182           userAddress,
1183           rewardtokens[i],
1184           refEarned,
1185           block.timestamp
1186         );
1187       }
1188 
1189       sendToken(
1190         userAddress,
1191         tokenAddress[stakeId],
1192         rewardtokens[i],
1193         rewardsEarned
1194       );
1195     }
1196 
1197     // Emit state changes
1198     emit UnStake(
1199       userAddress,
1200       tokenAddress[stakeId],
1201       stakedAmount[stakeId],
1202       block.timestamp,
1203       stakeId
1204     );
1205   }
1206 
1207   function pause() external onlyOwner returns (bool) {
1208     _pause();
1209     return true;
1210   }
1211 
1212   function unpause() external onlyOwner returns (bool) {
1213     _unpause();
1214     return true;
1215   }
1216 }