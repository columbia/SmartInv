1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File contracts/libraries/Context.sol
4 
5 // SPDX-License-Identifier: MIT;
6 
7 pragma solidity >=0.6.0 <=0.8.0;
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
20   function _msgSender() internal view virtual returns (address payable) {
21     return msg.sender;
22   }
23 
24   function _msgData() internal view virtual returns (bytes memory) {
25     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26     return msg.data;
27   }
28 }
29 
30 // File contracts/abstract/Pausable.sol
31 
32 pragma solidity >=0.6.0 <=0.8.0;
33 
34 /**
35  * @dev Contract module which allows children to implement an emergency stop
36  * mechanism that can be triggered by an authorized account.
37  *
38  * This module is used through inheritance. It will make available the
39  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
40  * the functions of your contract. Note that they will not be pausable by
41  * simply including this module, only once the modifiers are put in place.
42  */
43 
44 abstract contract Pausable is Context {
45   /**
46    * @dev Emitted when the pause is triggered by `account`.
47    */
48   event Paused(address account);
49 
50   /**
51    * @dev Emitted when the pause is lifted by `account`.
52    */
53   event Unpaused(address account);
54 
55   bool private _paused;
56 
57   /**
58    * @dev Initializes the contract in unpaused state.
59    */
60   constructor() {
61     _paused = false;
62   }
63 
64   /**
65    * @dev Returns true if the contract is paused, and false otherwise.
66    */
67   function paused() public view virtual returns (bool) {
68     return _paused;
69   }
70 
71   /**
72    * @dev Modifier to make a function callable only when the contract is not paused.
73    *
74    * Requirements:
75    *
76    * - The contract must not be paused.
77    */
78   modifier whenNotPaused() {
79     require(!paused(), "Pausable: paused");
80     _;
81   }
82 
83   /**
84    * @dev Modifier to make a function callable only when the contract is paused.
85    *
86    * Requirements:
87    *
88    * - The contract must be paused.
89    */
90   modifier whenPaused() {
91     require(paused(), "Pausable: not paused");
92     _;
93   }
94 
95   /**
96    * @dev Triggers stopped state.
97    *
98    * Requirements:
99    *
100    * - The contract must not be paused.
101    */
102   function _pause() internal virtual whenNotPaused {
103     _paused = true;
104     emit Paused(_msgSender());
105   }
106 
107   /**
108    * @dev Returns to normal state.
109    *
110    * Requirements:
111    *
112    * - The contract must be paused.
113    */
114   function _unpause() internal virtual whenPaused {
115     _paused = false;
116     emit Unpaused(_msgSender());
117   }
118 }
119 
120 // File contracts/abstract/Ownable.sol
121 
122 pragma solidity >=0.6.0 <=0.8.0;
123 
124 abstract contract Ownable is Pausable {
125   address public _owner;
126   address public _admin;
127 
128   event OwnershipTransferred(
129     address indexed previousOwner,
130     address indexed newOwner
131   );
132 
133   /**
134    * @dev Initializes the contract setting the deployer as the initial owner.
135    */
136   constructor(address ownerAddress) {
137     _owner = msg.sender;
138     _admin = ownerAddress;
139     emit OwnershipTransferred(address(0), _owner);
140   }
141 
142   /**
143    * @dev Throws if called by any account other than the owner.
144    */
145   modifier onlyOwner() {
146     require(_owner == _msgSender(), "Ownable: caller is not the owner");
147     _;
148   }
149 
150   /**
151    * @dev Throws if called by any account other than the owner.
152    */
153   modifier onlyAdmin() {
154     require(_admin == _msgSender(), "Ownable: caller is not the Admin");
155     _;
156   }
157 
158   /**
159    * @dev Leaves the contract without owner. It will not be possible to call
160    * `onlyOwner` functions anymore. Can only be called by the current owner.
161    *
162    * NOTE: Renouncing ownership will leave the contract without an owner,
163    * thereby removing any functionality that is only available to the owner.
164    */
165   function renounceOwnership() public onlyAdmin {
166     emit OwnershipTransferred(_owner, _admin);
167     _owner = _admin;
168   }
169 
170   /**
171    * @dev Transfers ownership of the contract to a new account (`newOwner`).
172    * Can only be called by the current owner.
173    */
174   function transferOwnership(address newOwner) public virtual onlyOwner {
175     require(newOwner != address(0), "Ownable: new owner is the zero address");
176     emit OwnershipTransferred(_owner, newOwner);
177     _owner = newOwner;
178   }
179 }
180 
181 // File contracts/libraries/SafeMath.sol
182 
183 pragma solidity ^0.7.0;
184 
185 /**
186  * @dev Wrappers over Solidity's arithmetic operations with added overflow
187  * checks.
188  *
189  * Arithmetic operations in Solidity wrap on overflow. This can easily result
190  * in bugs, because programmers usually assume that an overflow raises an
191  * error, which is the standard behavior in high level programming languages.
192  * `SafeMath` restores this intuition by reverting the transaction when an
193  * operation overflows.
194  *
195  * Using this library instead of the unchecked operations eliminates an entire
196  * class of bugs, so it's recommended to use it always.
197  */
198 
199 library SafeMath {
200   /**
201    * @dev Returns the addition of two unsigned integers, reverting on
202    * overflow.
203    *
204    * Counterpart to Solidity's `+` operator.
205    *
206    * Requirements:
207    *
208    * - Addition cannot overflow.
209    */
210   function add(uint256 a, uint256 b) internal pure returns (uint256) {
211     uint256 c = a + b;
212     require(c >= a, "SafeMath: addition overflow");
213 
214     return c;
215   }
216 
217   /**
218    * @dev Returns the subtraction of two unsigned integers, reverting on
219    * overflow (when the result is negative).
220    *
221    * Counterpart to Solidity's `-` operator.
222    *
223    * Requirements:
224    *
225    * - Subtraction cannot overflow.
226    */
227   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
228     return sub(a, b, "SafeMath: subtraction overflow");
229   }
230 
231   /**
232    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
233    * overflow (when the result is negative).
234    *
235    * Counterpart to Solidity's `-` operator.
236    *
237    * Requirements:
238    *
239    * - Subtraction cannot overflow.
240    */
241   function sub(
242     uint256 a,
243     uint256 b,
244     string memory errorMessage
245   ) internal pure returns (uint256) {
246     require(b <= a, errorMessage);
247     uint256 c = a - b;
248 
249     return c;
250   }
251 
252   /**
253    * @dev Returns the multiplication of two unsigned integers, reverting on
254    * overflow.
255    *
256    * Counterpart to Solidity's `*` operator.
257    *
258    * Requirements:
259    *
260    * - Multiplication cannot overflow.
261    */
262   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
264     // benefit is lost if 'b' is also tested.
265     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
266     if (a == 0) {
267       return 0;
268     }
269 
270     uint256 c = a * b;
271     require(c / a == b, "SafeMath: multiplication overflow");
272 
273     return c;
274   }
275 
276   /**
277    * @dev Returns the integer division of two unsigned integers. Reverts on
278    * division by zero. The result is rounded towards zero.
279    *
280    * Counterpart to Solidity's `/` operator. Note: this function uses a
281    * `revert` opcode (which leaves remaining gas untouched) while Solidity
282    * uses an invalid opcode to revert (consuming all remaining gas).
283    *
284    * Requirements:
285    *
286    * - The divisor cannot be zero.
287    */
288   function div(uint256 a, uint256 b) internal pure returns (uint256) {
289     return div(a, b, "SafeMath: division by zero");
290   }
291 
292   /**
293    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294    * division by zero. The result is rounded towards zero.
295    *
296    * Counterpart to Solidity's `/` operator. Note: this function uses a
297    * `revert` opcode (which leaves remaining gas untouched) while Solidity
298    * uses an invalid opcode to revert (consuming all remaining gas).
299    *
300    * Requirements:
301    *
302    * - The divisor cannot be zero.
303    */
304   function div(
305     uint256 a,
306     uint256 b,
307     string memory errorMessage
308   ) internal pure returns (uint256) {
309     require(b > 0, errorMessage);
310     uint256 c = a / b;
311 
312     return c;
313   }
314 
315   /**
316    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317    * Reverts when dividing by zero.
318    *
319    * Counterpart to Solidity's `%` operator. This function uses a `revert`
320    * opcode (which leaves remaining gas untouched) while Solidity uses an
321    * invalid opcode to revert (consuming all remaining gas).
322    *
323    * Requirements:
324    *
325    * - The divisor cannot be zero.
326    */
327   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328     return mod(a, b, "SafeMath: modulo by zero");
329   }
330 
331   /**
332    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333    * Reverts with custom message when dividing by zero.
334    *
335    * Counterpart to Solidity's `%` operator. This function uses a `revert`
336    * opcode (which leaves remaining gas untouched) while Solidity uses an
337    * invalid opcode to revert (consuming all remaining gas).
338    *
339    * Requirements:
340    *
341    * - The divisor cannot be zero.
342    */
343   function mod(
344     uint256 a,
345     uint256 b,
346     string memory errorMessage
347   ) internal pure returns (uint256) {
348     require(b != 0, errorMessage);
349     return a % b;
350   }
351 }
352 
353 // File contracts/interfaces/IERC20.sol
354 
355 pragma solidity ^0.7.0;
356 
357 /**
358  * @dev Interface of the ERC20 standard as defined in the EIP.
359  */
360 interface IERC20 {
361   /**
362    * @dev Returns the amount of tokens in existence.
363    */
364   function totalSupply() external view returns (uint256);
365 
366   /**
367    * @dev Returns the amount of tokens owned by `account`.
368    */
369   function balanceOf(address account) external view returns (uint256);
370 
371   /**
372    * @dev Moves `amount` tokens from the caller's account to `recipient`.
373    *
374    * Returns a boolean value indicating whether the operation succeeded.
375    *
376    * Emits a {Transfer} event.
377    */
378   function transfer(address recipient, uint256 amount) external returns (bool);
379 
380   /**
381    * @dev Returns the remaining number of tokens that `spender` will be
382    * allowed to spend on behalf of `owner` through {transferFrom}. This is
383    * zero by default.
384    *
385    * This value changes when {approve} or {transferFrom} are called.
386    */
387   function allowance(address owner, address spender)
388     external
389     view
390     returns (uint256);
391 
392   /**
393    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
394    *
395    * Returns a boolean value indicating whether the operation succeeded.
396    *
397    * IMPORTANT: Beware that changing an allowance with this method brings the risk
398    * that someone may use both the old and the new allowance by unfortunate
399    * transaction ordering. One possible solution to mitigate this race
400    * condition is to first reduce the spender's allowance to 0 and set the
401    * desired value afterwards:
402    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
403    *
404    * Emits an {Approval} event.
405    */
406   function approve(address spender, uint256 amount) external returns (bool);
407 
408   /**
409    * @dev Moves `amount` tokens from `sender` to `recipient` using the
410    * allowance mechanism. `amount` is then deducted from the caller's
411    * allowance.
412    *
413    * Returns a boolean value indicating whether the operation succeeded.
414    *
415    * Emits a {Transfer} event.
416    */
417   function transferFrom(
418     address sender,
419     address recipient,
420     uint256 amount
421   ) external returns (bool);
422 
423   /**
424    * @dev Emitted when `value` tokens are moved from one account (`from`) to
425    * another (`to`).
426    *
427    * Note that `value` may be zero.
428    */
429   event Transfer(address indexed from, address indexed to, uint256 value);
430 
431   /**
432    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
433    * a call to {approve}. `value` is the new allowance.
434    */
435   event Approval(address indexed owner, address indexed spender, uint256 value);
436 }
437 
438 // File contracts/abstract/Admin.sol
439 
440 pragma solidity ^0.7.0;
441 
442 abstract contract Admin is Ownable {
443   struct tokenInfo {
444     bool isExist;
445     uint8 decimal;
446     uint256 userMinStake;
447     uint256 userMaxStake;
448     uint256 totalMaxStake;
449     uint256 lockableDays;
450     bool optionableStatus;
451   }
452 
453   using SafeMath for uint256;
454   address[] public tokens;
455   mapping(address => address[]) public tokensSequenceList;
456   mapping(address => tokenInfo) public tokenDetails;
457   mapping(address => mapping(address => uint256)) public tokenDailyDistribution;
458   mapping(address => mapping(address => bool)) public tokenBlockedStatus;
459   uint256[] public intervalDays = [1, 8, 15, 22, 29];
460   uint256 public constant DAYS = 1 days;
461   uint256 public constant HOURS = 1 hours;
462   uint256 public stakeDuration;
463   uint256 public refPercentage;
464   uint256 public optionableBenefit;
465 
466   event TokenDetails(
467     address indexed tokenAddress,
468     uint256 userMinStake,
469     uint256 userMaxStake,
470     uint256 totalMaxStake,
471     uint256 updatedTime
472   );
473 
474   event LockableTokenDetails(
475     address indexed tokenAddress,
476     uint256 lockableDys,
477     bool optionalbleStatus,
478     uint256 updatedTime
479   );
480 
481   event DailyDistributionDetails(
482     address indexed stakedTokenAddress,
483     address indexed rewardTokenAddress,
484     uint256 rewards,
485     uint256 time
486   );
487 
488   event SequenceDetails(
489     address indexed stakedTokenAddress,
490     address[] rewardTokenSequence,
491     uint256 time
492   );
493 
494   event StakeDurationDetails(uint256 updatedDuration, uint256 time);
495 
496   event OptionableBenefitDetails(uint256 updatedBenefit, uint256 time);
497 
498   event ReferrerPercentageDetails(uint256 updatedRefPercentage, uint256 time);
499 
500   event IntervalDaysDetails(uint256[] updatedIntervals, uint256 time);
501 
502   event BlockedDetails(
503     address indexed stakedTokenAddress,
504     address indexed rewardTokenAddress,
505     bool blockedStatus,
506     uint256 time
507   );
508 
509   event WithdrawDetails(
510     address indexed tokenAddress,
511     uint256 withdrawalAmount,
512     uint256 time
513   );
514 
515   constructor(address _owner) Ownable(_owner) {
516     stakeDuration = 90 days;
517     refPercentage = 2500000000000000000;
518     optionableBenefit = 2;
519   }
520 
521   function addToken(
522     address tokenAddress,
523     uint256 userMinStake,
524     uint256 userMaxStake,
525     uint256 totalStake,
526     uint8 decimal
527   ) public onlyOwner returns (bool) {
528     if (!(tokenDetails[tokenAddress].isExist)) tokens.push(tokenAddress);
529 
530     tokenDetails[tokenAddress].isExist = true;
531     tokenDetails[tokenAddress].decimal = decimal;
532     tokenDetails[tokenAddress].userMinStake = userMinStake;
533     tokenDetails[tokenAddress].userMaxStake = userMaxStake;
534     tokenDetails[tokenAddress].totalMaxStake = totalStake;
535 
536     emit TokenDetails(
537       tokenAddress,
538       userMinStake,
539       userMaxStake,
540       totalStake,
541       block.timestamp
542     );
543     return true;
544   }
545 
546   function setDailyDistribution(
547     address[] memory stakedToken,
548     address[] memory rewardToken,
549     uint256[] memory dailyDistribution
550   ) public onlyOwner {
551     require(
552       stakedToken.length == rewardToken.length &&
553         rewardToken.length == dailyDistribution.length,
554       "Invalid Input"
555     );
556 
557     for (uint8 i = 0; i < stakedToken.length; i++) {
558       require(
559         tokenDetails[stakedToken[i]].isExist &&
560           tokenDetails[rewardToken[i]].isExist,
561         "Token not exist"
562       );
563       tokenDailyDistribution[stakedToken[i]][
564         rewardToken[i]
565       ] = dailyDistribution[i];
566 
567       emit DailyDistributionDetails(
568         stakedToken[i],
569         rewardToken[i],
570         dailyDistribution[i],
571         block.timestamp
572       );
573     }
574   }
575 
576   function updateSequence(
577     address stakedToken,
578     address[] memory rewardTokenSequence
579   ) public onlyOwner {
580     tokensSequenceList[stakedToken] = new address[](0);
581     require(tokenDetails[stakedToken].isExist, "Staked Token Not Exist");
582     for (uint8 i = 0; i < rewardTokenSequence.length; i++) {
583       require(rewardTokenSequence.length <= tokens.length, "Invalid Input");
584       require(
585         tokenDetails[rewardTokenSequence[i]].isExist,
586         "Reward Token Not Exist"
587       );
588       tokensSequenceList[stakedToken].push(rewardTokenSequence[i]);
589     }
590 
591     emit SequenceDetails(
592       stakedToken,
593       tokensSequenceList[stakedToken],
594       block.timestamp
595     );
596   }
597 
598   function updateToken(
599     address tokenAddress,
600     uint256 userMinStake,
601     uint256 userMaxStake,
602     uint256 totalStake
603   ) public onlyOwner {
604     require(tokenDetails[tokenAddress].isExist, "Token Not Exist");
605     tokenDetails[tokenAddress].userMinStake = userMinStake;
606     tokenDetails[tokenAddress].userMaxStake = userMaxStake;
607     tokenDetails[tokenAddress].totalMaxStake = totalStake;
608 
609     emit TokenDetails(
610       tokenAddress,
611       userMinStake,
612       userMaxStake,
613       totalStake,
614       block.timestamp
615     );
616   }
617 
618   function lockableToken(
619     address tokenAddress,
620     uint8 lockableStatus,
621     uint256 lockedDays,
622     bool optionableStatus
623   ) public onlyOwner {
624     require(
625       lockableStatus == 1 || lockableStatus == 2 || lockableStatus == 3,
626       "Invalid Lockable Status"
627     );
628     require(tokenDetails[tokenAddress].isExist == true, "Token Not Exist");
629 
630     if (lockableStatus == 1) {
631       tokenDetails[tokenAddress].lockableDays = block.timestamp.add(lockedDays);
632     } else if (lockableStatus == 2) tokenDetails[tokenAddress].lockableDays = 0;
633     else if (lockableStatus == 3)
634       tokenDetails[tokenAddress].optionableStatus = optionableStatus;
635 
636     emit LockableTokenDetails(
637       tokenAddress,
638       tokenDetails[tokenAddress].lockableDays,
639       tokenDetails[tokenAddress].optionableStatus,
640       block.timestamp
641     );
642   }
643 
644   function updateStakeDuration(uint256 durationTime) public onlyOwner {
645     stakeDuration = durationTime;
646 
647     emit StakeDurationDetails(stakeDuration, block.timestamp);
648   }
649 
650   function updateOptionableBenefit(uint256 benefit) public onlyOwner {
651     optionableBenefit = benefit;
652 
653     emit OptionableBenefitDetails(optionableBenefit, block.timestamp);
654   }
655 
656   function updateRefPercentage(uint256 refPer) public onlyOwner {
657     refPercentage = refPer;
658 
659     emit ReferrerPercentageDetails(refPercentage, block.timestamp);
660   }
661 
662   function updateIntervalDays(uint256[] memory _interval) public onlyOwner {
663     intervalDays = new uint256[](0);
664 
665     for (uint8 i = 0; i < _interval.length; i++) {
666       uint256 noD = stakeDuration.div(DAYS);
667       require(noD > _interval[i], "Invalid Interval Day");
668       intervalDays.push(_interval[i]);
669     }
670 
671     emit IntervalDaysDetails(intervalDays, block.timestamp);
672   }
673 
674   function changeTokenBlockedStatus(
675     address stakedToken,
676     address rewardToken,
677     bool status
678   ) public onlyOwner {
679     require(
680       tokenDetails[stakedToken].isExist && tokenDetails[rewardToken].isExist,
681       "Token not exist"
682     );
683     tokenBlockedStatus[stakedToken][rewardToken] = status;
684 
685     emit BlockedDetails(
686       stakedToken,
687       rewardToken,
688       tokenBlockedStatus[stakedToken][rewardToken],
689       block.timestamp
690     );
691   }
692 
693   function safeWithdraw(address tokenAddress, uint256 amount) public onlyOwner {
694     require(
695       IERC20(tokenAddress).balanceOf(address(this)) >= amount,
696       "Insufficient Balance"
697     );
698     require(IERC20(tokenAddress).transfer(_owner, amount), "Transfer failed");
699 
700     emit WithdrawDetails(tokenAddress, amount, block.timestamp);
701   }
702 
703   function viewTokensCount() external view returns (uint256) {
704     return tokens.length;
705   }
706 }
707 
708 // File contracts/UnifarmV9.sol
709 
710 pragma solidity ^0.7.6;
711 
712 /**
713  * @title Unifarm Contract
714  * @author OroPocket
715  */
716 
717 contract UnifarmV9 is Admin {
718   // Wrappers over Solidity's arithmetic operations
719   using SafeMath for uint256;
720 
721   // Stores Stake Details
722   struct stakeInfo {
723     address user;
724     bool[] isActive;
725     address[] referrer;
726     address[] tokenAddress;
727     uint256[] stakeId;
728     uint256[] stakedAmount;
729     uint256[] startTime;
730   }
731 
732   // Mapping
733   mapping(address => stakeInfo) public stakingDetails;
734   mapping(address => mapping(address => uint256)) public userTotalStaking;
735   mapping(address => uint256) public totalStaking;
736   uint256 public poolStartTime;
737 
738   // Events
739   event Stake(
740     address indexed userAddress,
741     uint256 stakeId,
742     address indexed referrerAddress,
743     address indexed tokenAddress,
744     uint256 stakedAmount,
745     uint256 time
746   );
747 
748   event Claim(
749     address indexed userAddress,
750     address indexed stakedTokenAddress,
751     address indexed tokenAddress,
752     uint256 claimRewards,
753     uint256 time
754   );
755 
756   event UnStake(
757     address indexed userAddress,
758     address indexed unStakedtokenAddress,
759     uint256 unStakedAmount,
760     uint256 time,
761     uint256 stakeId
762   );
763 
764   event ReferralEarn(
765     address indexed userAddress,
766     address indexed callerAddress,
767     address indexed rewardTokenAddress,
768     uint256 rewardAmount,
769     uint256 time
770   );
771 
772   constructor() Admin(msg.sender) {
773     poolStartTime = block.timestamp;
774   }
775 
776   /**
777    * @notice Stake tokens to earn rewards
778    * @param tokenAddress Staking token address
779    * @param amount Amount of tokens to be staked
780    */
781 
782   function stake(
783     address referrerAddress,
784     address tokenAddress,
785     uint256 amount
786   ) external whenNotPaused {
787     // checks
788     require(msg.sender != referrerAddress, "STAKE: invalid referrer address");
789     require(tokenDetails[tokenAddress].isExist, "STAKE : Token is not Exist");
790     require(
791       userTotalStaking[msg.sender][tokenAddress].add(amount) >=
792         tokenDetails[tokenAddress].userMinStake,
793       "STAKE : Min Amount should be within permit"
794     );
795     require(
796       userTotalStaking[msg.sender][tokenAddress].add(amount) <=
797         tokenDetails[tokenAddress].userMaxStake,
798       "STAKE : Max Amount should be within permit"
799     );
800     require(
801       totalStaking[tokenAddress].add(amount) <=
802         tokenDetails[tokenAddress].totalMaxStake,
803       "STAKE : Maxlimit exceeds"
804     );
805 
806     require(
807       poolStartTime.add(stakeDuration) > block.timestamp,
808       "STAKE: Staking Time Completed"
809     );
810 
811     // Storing stake details
812     stakingDetails[msg.sender].stakeId.push(
813       stakingDetails[msg.sender].stakeId.length
814     );
815     stakingDetails[msg.sender].isActive.push(true);
816     stakingDetails[msg.sender].user = msg.sender;
817     stakingDetails[msg.sender].referrer.push(referrerAddress);
818     stakingDetails[msg.sender].tokenAddress.push(tokenAddress);
819     stakingDetails[msg.sender].startTime.push(block.timestamp);
820 
821     // Update total staking amount
822     stakingDetails[msg.sender].stakedAmount.push(amount);
823     totalStaking[tokenAddress] = totalStaking[tokenAddress].add(amount);
824     userTotalStaking[msg.sender][tokenAddress] = userTotalStaking[msg.sender][
825       tokenAddress
826     ]
827       .add(amount);
828 
829     // Transfer tokens from userf to contract
830     require(
831       IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount),
832       "Transfer Failed"
833     );
834 
835     // Emit state changes
836     emit Stake(
837       msg.sender,
838       (stakingDetails[msg.sender].stakeId.length.sub(1)),
839       referrerAddress,
840       tokenAddress,
841       amount,
842       block.timestamp
843     );
844   }
845 
846   /**
847    * @notice Claim accumulated rewards
848    * @param stakeId Stake ID of the user
849    * @param stakedAmount Staked amount of the user
850    */
851 
852   function claimRewards(
853     address userAddress,
854     uint256 stakeId,
855     uint256 stakedAmount,
856     uint256 totalStake
857   ) internal {
858     // Local variables
859     uint256 interval;
860     uint256 endOfProfit;
861 
862     interval = poolStartTime.add(stakeDuration);
863 
864     // Interval calculation
865     if (interval > block.timestamp) endOfProfit = block.timestamp;
866     else endOfProfit = poolStartTime.add(stakeDuration);
867 
868     interval = endOfProfit.sub(stakingDetails[userAddress].startTime[stakeId]);
869     uint256[2] memory stakeData;
870     stakeData[0] = (stakedAmount);
871     stakeData[1] = (totalStake);
872 
873     // Reward calculation
874     if (interval >= HOURS)
875       _rewardCalculation(userAddress, stakeId, stakeData, interval);
876   }
877 
878   function _rewardCalculation(
879     address userAddress,
880     uint256 stakeId,
881     uint256[2] memory stakingData,
882     uint256 interval
883   ) internal {
884     uint256 rewardsEarned;
885     uint256 refEarned;
886     uint256[2] memory noOfDays;
887 
888     noOfDays[1] = interval.div(HOURS);
889     noOfDays[0] = interval.div(DAYS);
890 
891     rewardsEarned = noOfDays[1].mul(
892       getOneDayReward(
893         stakingData[0],
894         stakingDetails[userAddress].tokenAddress[stakeId],
895         stakingDetails[userAddress].tokenAddress[stakeId],
896         stakingData[1]
897       )
898     );
899 
900     // Referrer Earning
901     if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
902       refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
903       rewardsEarned = rewardsEarned.sub(refEarned);
904 
905       require(
906         IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
907           stakingDetails[userAddress].referrer[stakeId],
908           refEarned
909         ) == true,
910         "Transfer Failed"
911       );
912 
913       emit ReferralEarn(
914         stakingDetails[userAddress].referrer[stakeId],
915         msg.sender,
916         stakingDetails[userAddress].tokenAddress[stakeId],
917         refEarned,
918         block.timestamp
919       );
920     }
921 
922     //  Rewards Send
923     sendToken(
924       userAddress,
925       stakingDetails[userAddress].tokenAddress[stakeId],
926       stakingDetails[userAddress].tokenAddress[stakeId],
927       rewardsEarned
928     );
929 
930     uint8 i = 1;
931 
932     while (i < intervalDays.length) {
933       if (noOfDays[0] >= intervalDays[i]) {
934         uint256 reductionHours = (intervalDays[i].sub(1)).mul(24);
935         uint256 balHours = noOfDays[1].sub(reductionHours);
936 
937         address rewardToken =
938           tokensSequenceList[stakingDetails[userAddress].tokenAddress[stakeId]][
939             i
940           ];
941 
942         if (
943           rewardToken != stakingDetails[userAddress].tokenAddress[stakeId] &&
944           tokenBlockedStatus[stakingDetails[userAddress].tokenAddress[stakeId]][
945             rewardToken
946           ] ==
947           false
948         ) {
949           rewardsEarned = balHours.mul(
950             getOneDayReward(
951               stakingData[0],
952               stakingDetails[userAddress].tokenAddress[stakeId],
953               rewardToken,
954               stakingData[1]
955             )
956           );
957 
958           // Referrer Earning
959 
960           if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
961             refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
962             rewardsEarned = rewardsEarned.sub(refEarned);
963 
964             require(
965               IERC20(rewardToken).transfer(
966                 stakingDetails[userAddress].referrer[stakeId],
967                 refEarned
968               ) == true,
969               "Transfer Failed"
970             );
971 
972             emit ReferralEarn(
973               stakingDetails[userAddress].referrer[stakeId],
974               msg.sender,
975               stakingDetails[userAddress].tokenAddress[stakeId],
976               refEarned,
977               block.timestamp
978             );
979           }
980 
981           //  Rewards Send
982           sendToken(
983             userAddress,
984             stakingDetails[userAddress].tokenAddress[stakeId],
985             rewardToken,
986             rewardsEarned
987           );
988         }
989         i = i + 1;
990       } else {
991         break;
992       }
993     }
994   }
995 
996   /**
997    * @notice Get rewards for one day
998    * @param stakedAmount Stake amount of the user
999    * @param stakedToken Staked token address of the user
1000    * @param rewardToken Reward token address
1001    * @return reward One dayh reward for the user
1002    */
1003 
1004   function getOneDayReward(
1005     uint256 stakedAmount,
1006     address stakedToken,
1007     address rewardToken,
1008     uint256 totalStake
1009   ) public view returns (uint256 reward) {
1010     uint256 lockBenefit;
1011 
1012     if (tokenDetails[stakedToken].optionableStatus) {
1013       stakedAmount = stakedAmount.mul(optionableBenefit);
1014       lockBenefit = stakedAmount.mul(optionableBenefit.sub(1));
1015       reward = (
1016         stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])
1017       )
1018         .div(totalStake.add(lockBenefit));
1019     } else
1020       reward = (
1021         stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])
1022       )
1023         .div(totalStake);
1024   }
1025 
1026   /**
1027    * @notice Get rewards for one day
1028    * @param stakedToken Stake amount of the user
1029    * @param tokenAddress Reward token address
1030    * @param amount Amount to be transferred as reward
1031    */
1032   function sendToken(
1033     address userAddress,
1034     address stakedToken,
1035     address tokenAddress,
1036     uint256 amount
1037   ) internal {
1038     // Checks
1039     if (tokenAddress != address(0)) {
1040       require(
1041         IERC20(tokenAddress).balanceOf(address(this)) >= amount,
1042         "SEND : Insufficient Balance"
1043       );
1044       // Transfer of rewards
1045       require(
1046         IERC20(tokenAddress).transfer(userAddress, amount),
1047         "Transfer failed"
1048       );
1049 
1050       // Emit state changes
1051       emit Claim(
1052         userAddress,
1053         stakedToken,
1054         tokenAddress,
1055         amount,
1056         block.timestamp
1057       );
1058     }
1059   }
1060 
1061   /**
1062    * @notice Unstake and claim rewards
1063    * @param stakeId Stake ID of the user
1064    */
1065   function unStake(address userAddress, uint256 stakeId)
1066     external
1067     whenNotPaused
1068     returns (bool)
1069   {
1070     require(
1071       msg.sender == userAddress || msg.sender == _owner,
1072       "UNSTAKE: Invalid User Entry"
1073     );
1074 
1075     address stakedToken = stakingDetails[userAddress].tokenAddress[stakeId];
1076 
1077     // lockableDays check
1078     require(
1079       tokenDetails[stakedToken].lockableDays <= block.timestamp,
1080       "UNSTAKE: Token Locked"
1081     );
1082 
1083     // optional lock check
1084     if (tokenDetails[stakedToken].optionableStatus)
1085       require(
1086         stakingDetails[userAddress].startTime[stakeId].add(stakeDuration) <=
1087           block.timestamp,
1088         "UNSTAKE: Locked in optional lock"
1089       );
1090 
1091     // Checks
1092     require(
1093       stakingDetails[userAddress].stakedAmount[stakeId] > 0 ||
1094         stakingDetails[userAddress].isActive[stakeId] == true,
1095       "UNSTAKE : Already Claimed (or) Insufficient Staked"
1096     );
1097 
1098     // State updation
1099     uint256 stakedAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1100     uint256 totalStaking1 = totalStaking[stakedToken];
1101     totalStaking[stakedToken] = totalStaking[stakedToken].sub(stakedAmount);
1102     userTotalStaking[userAddress][stakedToken] = userTotalStaking[userAddress][
1103       stakedToken
1104     ]
1105       .sub(stakedAmount);
1106     stakingDetails[userAddress].stakedAmount[stakeId] = 0;
1107     stakingDetails[userAddress].isActive[stakeId] = false;
1108 
1109     // Balance check
1110     require(
1111       IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1112         address(this)
1113       ) >= stakedAmount,
1114       "UNSTAKE : Insufficient Balance"
1115     );
1116 
1117     // Transfer staked token back to user
1118     IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1119       userAddress,
1120       stakedAmount
1121     );
1122 
1123     claimRewards(userAddress, stakeId, stakedAmount, totalStaking1);
1124 
1125     // Emit state changes
1126     emit UnStake(
1127       userAddress,
1128       stakingDetails[userAddress].tokenAddress[stakeId],
1129       stakedAmount,
1130       block.timestamp,
1131       stakeId
1132     );
1133 
1134     return true;
1135   }
1136 
1137   function emergencyUnstake(
1138     uint256 stakeId,
1139     address userAddress,
1140     address[] memory rewardtokens,
1141     uint256[] memory amount
1142   ) external onlyOwner {
1143     // Checks
1144     require(
1145       stakingDetails[userAddress].stakedAmount[stakeId] > 0 &&
1146         stakingDetails[userAddress].isActive[stakeId] == true,
1147       "EMERGENCY : Already Claimed (or) Insufficient Staked"
1148     );
1149 
1150     // Balance check
1151     require(
1152       IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1153         address(this)
1154       ) >= stakingDetails[userAddress].stakedAmount[stakeId],
1155       "EMERGENCY : Insufficient Balance"
1156     );
1157 
1158     uint256 stakeAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1159     stakingDetails[userAddress].isActive[stakeId] = false;
1160     stakingDetails[userAddress].stakedAmount[stakeId] = 0;
1161     totalStaking[
1162       stakingDetails[userAddress].tokenAddress[stakeId]
1163     ] = totalStaking[stakingDetails[userAddress].tokenAddress[stakeId]].sub(
1164       stakeAmount
1165     );
1166 
1167     IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1168       userAddress,
1169       stakeAmount
1170     );
1171 
1172     for (uint256 i; i < rewardtokens.length; i++) {
1173       require(
1174         IERC20(rewardtokens[i]).balanceOf(address(this)) >= amount[i],
1175         "EMERGENCY : Insufficient Reward Balance"
1176       );
1177       uint256 rewardsEarned = amount[i];
1178 
1179       if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
1180         uint256 refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
1181         rewardsEarned = rewardsEarned.sub(refEarned);
1182 
1183         require(
1184           IERC20(rewardtokens[i]).transfer(
1185             stakingDetails[userAddress].referrer[stakeId],
1186             refEarned
1187           ),
1188           "EMERGENCY : Transfer Failed"
1189         );
1190 
1191         emit ReferralEarn(
1192           stakingDetails[userAddress].referrer[stakeId],
1193           userAddress,
1194           rewardtokens[i],
1195           refEarned,
1196           block.timestamp
1197         );
1198       }
1199 
1200       IERC20(rewardtokens[i]).transfer(userAddress, rewardsEarned);
1201     }
1202 
1203     // Emit state changes
1204     emit UnStake(
1205       userAddress,
1206       stakingDetails[userAddress].tokenAddress[stakeId],
1207       stakeAmount,
1208       block.timestamp,
1209       stakeId
1210     );
1211   }
1212 
1213   /**
1214    * @notice View staking details
1215    * @param _user User address
1216    */
1217   function viewStakingDetails(address _user)
1218     public
1219     view
1220     returns (
1221       address[] memory,
1222       address[] memory,
1223       bool[] memory,
1224       uint256[] memory,
1225       uint256[] memory,
1226       uint256[] memory
1227     )
1228   {
1229     return (
1230       stakingDetails[_user].referrer,
1231       stakingDetails[_user].tokenAddress,
1232       stakingDetails[_user].isActive,
1233       stakingDetails[_user].stakeId,
1234       stakingDetails[_user].stakedAmount,
1235       stakingDetails[_user].startTime
1236     );
1237   }
1238 }