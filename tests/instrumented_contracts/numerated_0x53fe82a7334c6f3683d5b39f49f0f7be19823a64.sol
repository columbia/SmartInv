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
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File contracts/abstract/Pausable.sol
32 
33 
34 pragma solidity >=0.6.0 <=0.8.0;
35 
36 /**
37  * @dev Contract module which allows children to implement an emergency stop
38  * mechanism that can be triggered by an authorized account.
39  *
40  * This module is used through inheritance. It will make available the
41  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
42  * the functions of your contract. Note that they will not be pausable by
43  * simply including this module, only once the modifiers are put in place.
44  */
45 
46 abstract contract Pausable is Context {
47     /**
48      * @dev Emitted when the pause is triggered by `account`.
49      */
50     event Paused(address account);
51 
52     /**
53      * @dev Emitted when the pause is lifted by `account`.
54      */
55     event Unpaused(address account);
56 
57     bool private _paused;
58 
59     /**
60      * @dev Initializes the contract in unpaused state.
61      */
62     constructor() {
63         _paused = false;
64     }
65 
66     /**
67      * @dev Returns true if the contract is paused, and false otherwise.
68      */
69     function paused() public view virtual returns (bool) {
70         return _paused;
71     }
72 
73     /**
74      * @dev Modifier to make a function callable only when the contract is not paused.
75      *
76      * Requirements:
77      *
78      * - The contract must not be paused.
79      */
80     modifier whenNotPaused() {
81         require(!paused(), "Pausable: paused");
82         _;
83     }
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is paused.
87      *
88      * Requirements:
89      *
90      * - The contract must be paused.
91      */
92     modifier whenPaused() {
93         require(paused(), "Pausable: not paused");
94         _;
95     }
96 
97     /**
98      * @dev Triggers stopped state.
99      *
100      * Requirements:
101      *
102      * - The contract must not be paused.
103      */
104     function _pause() internal virtual whenNotPaused {
105         _paused = true;
106         emit Paused(_msgSender());
107     }
108 
109     /**
110      * @dev Returns to normal state.
111      *
112      * Requirements:
113      *
114      * - The contract must be paused.
115      */
116     function _unpause() internal virtual whenPaused {
117         _paused = false;
118         emit Unpaused(_msgSender());
119     }
120 }
121 
122 
123 // File contracts/abstract/Ownable.sol
124 
125 
126 pragma solidity >=0.6.0 <=0.8.0;
127 
128 abstract contract Ownable is Pausable {
129     address public _owner;
130     address public _admin;
131 
132     event OwnershipTransferred(
133         address indexed previousOwner,
134         address indexed newOwner
135     );
136 
137     /**
138      * @dev Initializes the contract setting the deployer as the initial owner.
139      */
140     constructor(address ownerAddress) {
141         _owner = msg.sender;
142         _admin = ownerAddress;
143         emit OwnershipTransferred(address(0), _owner);
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         require(_owner == _msgSender(), "Ownable: caller is not the owner");
151         _;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyAdmin() {
158         require(_admin == _msgSender(), "Ownable: caller is not the Admin");
159         _;
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions anymore. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby removing any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public onlyAdmin {
170         emit OwnershipTransferred(_owner, _admin);
171         _owner = _admin;
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(
180             newOwner != address(0),
181             "Ownable: new owner is the zero address"
182         );
183         emit OwnershipTransferred(_owner, newOwner);
184         _owner = newOwner;
185     }
186 }
187 
188 
189 // File contracts/libraries/SafeMath.sol
190 
191 
192 pragma solidity ^0.7.0;
193 
194 /**
195  * @dev Wrappers over Solidity's arithmetic operations with added overflow
196  * checks.
197  *
198  * Arithmetic operations in Solidity wrap on overflow. This can easily result
199  * in bugs, because programmers usually assume that an overflow raises an
200  * error, which is the standard behavior in high level programming languages.
201  * `SafeMath` restores this intuition by reverting the transaction when an
202  * operation overflows.
203  *
204  * Using this library instead of the unchecked operations eliminates an entire
205  * class of bugs, so it's recommended to use it always.
206  */
207 
208 library SafeMath {
209     /**
210      * @dev Returns the addition of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `+` operator.
214      *
215      * Requirements:
216      *
217      * - Addition cannot overflow.
218      */
219     function add(uint256 a, uint256 b) internal pure returns (uint256) {
220         uint256 c = a + b;
221         require(c >= a, "SafeMath: addition overflow");
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
237         return sub(a, b, "SafeMath: subtraction overflow");
238     }
239 
240     /**
241      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
242      * overflow (when the result is negative).
243      *
244      * Counterpart to Solidity's `-` operator.
245      *
246      * Requirements:
247      *
248      * - Subtraction cannot overflow.
249      */
250     function sub(
251         uint256 a,
252         uint256 b,
253         string memory errorMessage
254     ) internal pure returns (uint256) {
255         require(b <= a, errorMessage);
256         uint256 c = a - b;
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the multiplication of two unsigned integers, reverting on
263      * overflow.
264      *
265      * Counterpart to Solidity's `*` operator.
266      *
267      * Requirements:
268      *
269      * - Multiplication cannot overflow.
270      */
271     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
272         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
273         // benefit is lost if 'b' is also tested.
274         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
275         if (a == 0) {
276             return 0;
277         }
278 
279         uint256 c = a * b;
280         require(c / a == b, "SafeMath: multiplication overflow");
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers. Reverts on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return div(a, b, "SafeMath: division by zero");
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `/` operator. Note: this function uses a
306      * `revert` opcode (which leaves remaining gas untouched) while Solidity
307      * uses an invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function div(
314         uint256 a,
315         uint256 b,
316         string memory errorMessage
317     ) internal pure returns (uint256) {
318         require(b > 0, errorMessage);
319         uint256 c = a / b;
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
337         return mod(a, b, "SafeMath: modulo by zero");
338     }
339 
340     /**
341      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
342      * Reverts with custom message when dividing by zero.
343      *
344      * Counterpart to Solidity's `%` operator. This function uses a `revert`
345      * opcode (which leaves remaining gas untouched) while Solidity uses an
346      * invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function mod(
353         uint256 a,
354         uint256 b,
355         string memory errorMessage
356     ) internal pure returns (uint256) {
357         require(b != 0, errorMessage);
358         return a % b;
359     }
360 }
361 
362 
363 // File contracts/interfaces/IERC20.sol
364 
365 
366 pragma solidity ^0.7.0;
367 
368 /**
369  * @dev Interface of the ERC20 standard as defined in the EIP.
370  */
371 interface IERC20 {
372     /**
373      * @dev Returns the amount of tokens in existence.
374      */
375     function totalSupply() external view returns (uint256);
376 
377     /**
378      * @dev Returns the amount of tokens owned by `account`.
379      */
380     function balanceOf(address account) external view returns (uint256);
381 
382     /**
383      * @dev Moves `amount` tokens from the caller's account to `recipient`.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transfer(address recipient, uint256 amount)
390         external
391         returns (bool);
392 
393     /**
394      * @dev Returns the remaining number of tokens that `spender` will be
395      * allowed to spend on behalf of `owner` through {transferFrom}. This is
396      * zero by default.
397      *
398      * This value changes when {approve} or {transferFrom} are called.
399      */
400     function allowance(address owner, address spender)
401         external
402         view
403         returns (uint256);
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
407      *
408      * Returns a boolean value indicating whether the operation succeeded.
409      *
410      * IMPORTANT: Beware that changing an allowance with this method brings the risk
411      * that someone may use both the old and the new allowance by unfortunate
412      * transaction ordering. One possible solution to mitigate this race
413      * condition is to first reduce the spender's allowance to 0 and set the
414      * desired value afterwards:
415      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
416      *
417      * Emits an {Approval} event.
418      */
419     function approve(address spender, uint256 amount) external returns (bool);
420 
421     /**
422      * @dev Moves `amount` tokens from `sender` to `recipient` using the
423      * allowance mechanism. `amount` is then deducted from the caller's
424      * allowance.
425      *
426      * Returns a boolean value indicating whether the operation succeeded.
427      *
428      * Emits a {Transfer} event.
429      */
430     function transferFrom(
431         address sender,
432         address recipient,
433         uint256 amount
434     ) external returns (bool);
435 
436     /**
437      * @dev Emitted when `value` tokens are moved from one account (`from`) to
438      * another (`to`).
439      *
440      * Note that `value` may be zero.
441      */
442     event Transfer(address indexed from, address indexed to, uint256 value);
443 
444     /**
445      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
446      * a call to {approve}. `value` is the new allowance.
447      */
448     event Approval(
449         address indexed owner,
450         address indexed spender,
451         uint256 value
452     );
453 }
454 
455 
456 // File contracts/abstract/Admin.sol
457 
458 
459 pragma solidity ^0.7.0;
460 
461 
462 
463 abstract contract Admin is Ownable {
464   struct tokenInfo {
465     bool isExist;
466     uint8 decimal;
467     uint256 userMinStake;
468     uint256 userMaxStake;
469     uint256 totalMaxStake;
470     uint256 lockableDays;
471     bool optionableStatus;
472   }
473 
474   using SafeMath for uint256;
475   address[] public tokens;
476   mapping(address => address[]) public tokensSequenceList;
477   mapping(address => tokenInfo) public tokenDetails;
478   mapping(address => uint256) public rewardCap;
479   mapping(address => mapping(address => uint256)) public tokenDailyDistribution;
480   mapping(address => mapping(address => bool)) public tokenBlockedStatus;
481   uint256[] public intervalDays = [1, 8, 15, 22, 29];
482   uint256 public constant DAYS = 1 days;
483   uint256 public constant HOURS = 1 hours;
484   uint256 public stakeDuration;
485   uint256 public refPercentage;
486   uint256 public optionableBenefit;
487 
488   event TokenDetails(
489     address indexed tokenAddress,
490     uint256 userMinStake,
491     uint256 userMaxStake,
492     uint256 totalMaxStake,
493     uint256 updatedTime
494   );
495 
496   event LockableTokenDetails(
497     address indexed tokenAddress,
498     uint256 lockableDys,
499     bool optionalbleStatus,
500     uint256 updatedTime
501   );
502 
503   event DailyDistributionDetails(
504     address indexed stakedTokenAddress,
505     address indexed rewardTokenAddress,
506     uint256 rewards,
507     uint256 time
508   );
509 
510   event SequenceDetails(
511     address indexed stakedTokenAddress,
512     address[] rewardTokenSequence,
513     uint256 time
514   );
515 
516   event StakeDurationDetails(uint256 updatedDuration, uint256 time);
517 
518   event OptionableBenefitDetails(uint256 updatedBenefit, uint256 time);
519 
520   event ReferrerPercentageDetails(uint256 updatedRefPercentage, uint256 time);
521 
522   event IntervalDaysDetails(uint256[] updatedIntervals, uint256 time);
523 
524   event BlockedDetails(
525     address indexed stakedTokenAddress,
526     address indexed rewardTokenAddress,
527     bool blockedStatus,
528     uint256 time
529   );
530 
531   event WithdrawDetails(
532     address indexed tokenAddress,
533     uint256 withdrawalAmount,
534     uint256 time
535   );
536 
537   constructor(address _owner) Ownable(_owner) {
538     stakeDuration = 90 days;
539     refPercentage = 2500000000000000000;
540     optionableBenefit = 2;
541   }
542 
543   function addToken(
544     address tokenAddress,
545     uint256 userMinStake,
546     uint256 userMaxStake,
547     uint256 totalStake,
548     uint8 decimal
549   ) public onlyOwner returns (bool) {
550     if (!(tokenDetails[tokenAddress].isExist)) tokens.push(tokenAddress);
551 
552     tokenDetails[tokenAddress].isExist = true;
553     tokenDetails[tokenAddress].decimal = decimal;
554     tokenDetails[tokenAddress].userMinStake = userMinStake;
555     tokenDetails[tokenAddress].userMaxStake = userMaxStake;
556     tokenDetails[tokenAddress].totalMaxStake = totalStake;
557 
558     emit TokenDetails(
559       tokenAddress,
560       userMinStake,
561       userMaxStake,
562       totalStake,
563       block.timestamp
564     );
565     return true;
566   }
567 
568   function setDailyDistribution(
569     address[] memory stakedToken,
570     address[] memory rewardToken,
571     uint256[] memory dailyDistribution
572   ) public onlyOwner {
573     require(
574       stakedToken.length == rewardToken.length &&
575         rewardToken.length == dailyDistribution.length,
576       "Invalid Input"
577     );
578 
579     for (uint8 i = 0; i < stakedToken.length; i++) {
580       require(
581         tokenDetails[stakedToken[i]].isExist &&
582           tokenDetails[rewardToken[i]].isExist,
583         "Token not exist"
584       );
585       tokenDailyDistribution[stakedToken[i]][
586         rewardToken[i]
587       ] = dailyDistribution[i];
588 
589       emit DailyDistributionDetails(
590         stakedToken[i],
591         rewardToken[i],
592         dailyDistribution[i],
593         block.timestamp
594       );
595     }
596   }
597 
598   function updateSequence(
599     address stakedToken,
600     address[] memory rewardTokenSequence
601   ) public onlyOwner {
602     tokensSequenceList[stakedToken] = new address[](0);
603     require(tokenDetails[stakedToken].isExist, "Staked Token Not Exist");
604     for (uint8 i = 0; i < rewardTokenSequence.length; i++) {
605       require(rewardTokenSequence.length <= tokens.length, "Invalid Input");
606       require(
607         tokenDetails[rewardTokenSequence[i]].isExist,
608         "Reward Token Not Exist"
609       );
610       tokensSequenceList[stakedToken].push(rewardTokenSequence[i]);
611     }
612 
613     emit SequenceDetails(
614       stakedToken,
615       tokensSequenceList[stakedToken],
616       block.timestamp
617     );
618   }
619 
620   function updateToken(
621     address tokenAddress,
622     uint256 userMinStake,
623     uint256 userMaxStake,
624     uint256 totalStake
625   ) public onlyOwner {
626     require(tokenDetails[tokenAddress].isExist, "Token Not Exist");
627     tokenDetails[tokenAddress].userMinStake = userMinStake;
628     tokenDetails[tokenAddress].userMaxStake = userMaxStake;
629     tokenDetails[tokenAddress].totalMaxStake = totalStake;
630 
631     emit TokenDetails(
632       tokenAddress,
633       userMinStake,
634       userMaxStake,
635       totalStake,
636       block.timestamp
637     );
638   }
639 
640   function lockableToken(
641     address tokenAddress,
642     uint8 lockableStatus,
643     uint256 lockedDays,
644     bool optionableStatus
645   ) public onlyOwner {
646     require(
647       lockableStatus == 1 || lockableStatus == 2 || lockableStatus == 3,
648       "Invalid Lockable Status"
649     );
650     require(tokenDetails[tokenAddress].isExist == true, "Token Not Exist");
651 
652     if (lockableStatus == 1) {
653       tokenDetails[tokenAddress].lockableDays = block.timestamp.add(lockedDays);
654     } else if (lockableStatus == 2) tokenDetails[tokenAddress].lockableDays = 0;
655     else if (lockableStatus == 3)
656       tokenDetails[tokenAddress].optionableStatus = optionableStatus;
657 
658     emit LockableTokenDetails(
659       tokenAddress,
660       tokenDetails[tokenAddress].lockableDays,
661       tokenDetails[tokenAddress].optionableStatus,
662       block.timestamp
663     );
664   }
665 
666   function updateStakeDuration(uint256 durationTime) public onlyOwner {
667     stakeDuration = durationTime;
668 
669     emit StakeDurationDetails(stakeDuration, block.timestamp);
670   }
671 
672   function updateOptionableBenefit(uint256 benefit) public onlyOwner {
673     optionableBenefit = benefit;
674     emit OptionableBenefitDetails(optionableBenefit, block.timestamp);
675   }
676 
677   function updateRefPercentage(uint256 refPer) public onlyOwner {
678     refPercentage = refPer;
679     emit ReferrerPercentageDetails(refPercentage, block.timestamp);
680   }
681 
682   function updateIntervalDays(uint256[] memory _interval) public onlyOwner {
683     intervalDays = new uint256[](0);
684 
685     for (uint8 i = 0; i < _interval.length; i++) {
686       uint256 noD = stakeDuration.div(DAYS);
687       require(noD > _interval[i], "Invalid Interval Day");
688       intervalDays.push(_interval[i]);
689     }
690 
691     emit IntervalDaysDetails(intervalDays, block.timestamp);
692   }
693 
694   function changeTokenBlockedStatus(
695     address stakedToken,
696     address rewardToken,
697     bool status
698   ) public onlyOwner {
699     require(
700       tokenDetails[stakedToken].isExist && tokenDetails[rewardToken].isExist,
701       "Token not exist"
702     );
703     tokenBlockedStatus[stakedToken][rewardToken] = status;
704 
705     emit BlockedDetails(
706       stakedToken,
707       rewardToken,
708       tokenBlockedStatus[stakedToken][rewardToken],
709       block.timestamp
710     );
711   }
712 
713   function safeWithdraw(address tokenAddress, uint256 amount) public onlyOwner {
714     require(
715       IERC20(tokenAddress).balanceOf(address(this)) >= amount,
716       "Insufficient Balance"
717     );
718     require(IERC20(tokenAddress).transfer(_owner, amount), "Transfer failed");
719     emit WithdrawDetails(tokenAddress, amount, block.timestamp);
720   }
721 
722   function viewTokensCount() external view returns (uint256) {
723     return tokens.length;
724   }
725 
726   function setRewardCap(
727     address[] memory tokenAddresses,
728     uint256[] memory rewards
729   ) external onlyOwner returns (bool) {
730     require(tokenAddresses.length == rewards.length, "Invalid elements");
731     for (uint8 v = 0; v < tokenAddresses.length; v++) {
732       require(tokenDetails[tokenAddresses[v]].isExist, "Token is not exist");
733       require(rewards[v] > 0, "Invalid Reward Amount");
734       rewardCap[tokenAddresses[v]] = rewards[v];
735     }
736     return true;
737   }
738 }
739 
740 
741 // File contracts/UnifarmV16.sol
742 
743 
744 pragma solidity ^0.7.6;
745 
746 /**
747  * @title Unifarm Contract
748  * @author OroPocket
749  */
750 
751 contract UnifarmV16 is Admin {
752   // Wrappers over Solidity's arithmetic operations
753   using SafeMath for uint256;
754 
755   // Stores Stake Details
756   struct stakeInfo {
757     address user;
758     bool[] isActive;
759     address[] referrer;
760     address[] tokenAddress;
761     uint256[] stakeId;
762     uint256[] stakedAmount;
763     uint256[] startTime;
764   }
765 
766   // Mapping
767   mapping(address => stakeInfo) public stakingDetails;
768   mapping(address => mapping(address => uint256)) public userTotalStaking;
769   mapping(address => uint256) public totalStaking;
770   uint256 public poolStartTime;
771 
772   // Events
773   event Stake(
774     address indexed userAddress,
775     uint256 stakeId,
776     address indexed referrerAddress,
777     address indexed tokenAddress,
778     uint256 stakedAmount,
779     uint256 time
780   );
781 
782   event Claim(
783     address indexed userAddress,
784     address indexed stakedTokenAddress,
785     address indexed tokenAddress,
786     uint256 claimRewards,
787     uint256 time
788   );
789 
790   event UnStake(
791     address indexed userAddress,
792     address indexed unStakedtokenAddress,
793     uint256 unStakedAmount,
794     uint256 time,
795     uint256 stakeId
796   );
797 
798   event ReferralEarn(
799     address indexed userAddress,
800     address indexed callerAddress,
801     address indexed rewardTokenAddress,
802     uint256 rewardAmount,
803     uint256 time
804   );
805 
806   constructor() Admin(msg.sender) {
807     poolStartTime = block.timestamp;
808   }
809 
810   /**
811    * @notice Stake tokens to earn rewards
812    * @param tokenAddress Staking token address
813    * @param amount Amount of tokens to be staked
814    */
815 
816   function stake(
817     address referrerAddress,
818     address tokenAddress,
819     uint256 amount
820   ) external whenNotPaused {
821     // checks
822     require(msg.sender != referrerAddress, "STAKE: invalid referrer address");
823     require(tokenDetails[tokenAddress].isExist, "STAKE : Token is not Exist");
824     require(
825       userTotalStaking[msg.sender][tokenAddress].add(amount) >=
826         tokenDetails[tokenAddress].userMinStake,
827       "STAKE : Min Amount should be within permit"
828     );
829     require(
830       userTotalStaking[msg.sender][tokenAddress].add(amount) <=
831         tokenDetails[tokenAddress].userMaxStake,
832       "STAKE : Max Amount should be within permit"
833     );
834     require(
835       totalStaking[tokenAddress].add(amount) <=
836         tokenDetails[tokenAddress].totalMaxStake,
837       "STAKE : Maxlimit exceeds"
838     );
839 
840     require(
841       poolStartTime.add(stakeDuration) > block.timestamp,
842       "STAKE: Staking Time Completed"
843     );
844 
845     // Storing stake details
846     stakingDetails[msg.sender].stakeId.push(
847       stakingDetails[msg.sender].stakeId.length
848     );
849     stakingDetails[msg.sender].isActive.push(true);
850     stakingDetails[msg.sender].user = msg.sender;
851     stakingDetails[msg.sender].referrer.push(referrerAddress);
852     stakingDetails[msg.sender].tokenAddress.push(tokenAddress);
853     stakingDetails[msg.sender].startTime.push(block.timestamp);
854 
855     // Update total staking amount
856     stakingDetails[msg.sender].stakedAmount.push(amount);
857     totalStaking[tokenAddress] = totalStaking[tokenAddress].add(amount);
858     userTotalStaking[msg.sender][tokenAddress] = userTotalStaking[msg.sender][
859       tokenAddress
860     ]
861       .add(amount);
862 
863     // Transfer tokens from userf to contract
864     require(
865       IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount),
866       "Transfer Failed"
867     );
868 
869     // Emit state changes
870     emit Stake(
871       msg.sender,
872       (stakingDetails[msg.sender].stakeId.length.sub(1)),
873       referrerAddress,
874       tokenAddress,
875       amount,
876       block.timestamp
877     );
878   }
879 
880   /**
881    * @notice Claim accumulated rewards
882    * @param stakeId Stake ID of the user
883    * @param stakedAmount Staked amount of the user
884    */
885 
886   function claimRewards(
887     address userAddress,
888     uint256 stakeId,
889     uint256 stakedAmount,
890     uint256 totalStake
891   ) internal {
892     // Local variables
893     uint256 interval;
894     uint256 endOfProfit;
895 
896     interval = poolStartTime.add(stakeDuration);
897 
898     // Interval calculation
899     if (interval > block.timestamp) endOfProfit = block.timestamp;
900     else endOfProfit = poolStartTime.add(stakeDuration);
901 
902     interval = endOfProfit.sub(stakingDetails[userAddress].startTime[stakeId]);
903     uint256[2] memory stakeData;
904     stakeData[0] = (stakedAmount);
905     stakeData[1] = (totalStake);
906 
907     // Reward calculation
908     if (interval >= HOURS)
909       _rewardCalculation(userAddress, stakeId, stakeData, interval);
910   }
911 
912   function _rewardCalculation(
913     address userAddress,
914     uint256 stakeId,
915     uint256[2] memory stakingData,
916     uint256 interval
917   ) internal {
918     uint256 rewardsEarned;
919     uint256 refEarned;
920     uint256[2] memory noOfDays;
921 
922     noOfDays[1] = interval.div(HOURS);
923     noOfDays[0] = interval.div(DAYS);
924 
925     rewardsEarned = noOfDays[1].mul(
926       getOneDayReward(
927         stakingData[0],
928         stakingDetails[userAddress].tokenAddress[stakeId],
929         stakingDetails[userAddress].tokenAddress[stakeId],
930         stakingData[1]
931       )
932     );
933 
934     // Referrer Earning
935     if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
936       refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
937       rewardsEarned = rewardsEarned.sub(refEarned);
938 
939       require(
940         IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
941           stakingDetails[userAddress].referrer[stakeId],
942           refEarned
943         ) == true,
944         "Transfer Failed"
945       );
946 
947       emit ReferralEarn(
948         stakingDetails[userAddress].referrer[stakeId],
949         msg.sender,
950         stakingDetails[userAddress].tokenAddress[stakeId],
951         refEarned,
952         block.timestamp
953       );
954     }
955 
956     //  Rewards Send
957     sendToken(
958       userAddress,
959       stakingDetails[userAddress].tokenAddress[stakeId],
960       stakingDetails[userAddress].tokenAddress[stakeId],
961       rewardsEarned
962     );
963 
964     uint8 i = 1;
965 
966     while (i < intervalDays.length) {
967       if (noOfDays[0] >= intervalDays[i]) {
968         uint256 reductionHours = (intervalDays[i].sub(1)).mul(24);
969         uint256 balHours = noOfDays[1].sub(reductionHours);
970 
971         address rewardToken =
972           tokensSequenceList[stakingDetails[userAddress].tokenAddress[stakeId]][
973             i
974           ];
975 
976         if (
977           rewardToken != stakingDetails[userAddress].tokenAddress[stakeId] &&
978           tokenBlockedStatus[stakingDetails[userAddress].tokenAddress[stakeId]][
979             rewardToken
980           ] ==
981           false
982         ) {
983           rewardsEarned = balHours.mul(
984             getOneDayReward(
985               stakingData[0],
986               stakingDetails[userAddress].tokenAddress[stakeId],
987               rewardToken,
988               stakingData[1]
989             )
990           );
991 
992           // Referrer Earning
993 
994           if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
995             refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
996             rewardsEarned = rewardsEarned.sub(refEarned);
997 
998             require(
999               IERC20(rewardToken).transfer(
1000                 stakingDetails[userAddress].referrer[stakeId],
1001                 refEarned
1002               ) == true,
1003               "Transfer Failed"
1004             );
1005 
1006             emit ReferralEarn(
1007               stakingDetails[userAddress].referrer[stakeId],
1008               msg.sender,
1009               stakingDetails[userAddress].tokenAddress[stakeId],
1010               refEarned,
1011               block.timestamp
1012             );
1013           }
1014 
1015           //  Rewards Send
1016           sendToken(
1017             userAddress,
1018             stakingDetails[userAddress].tokenAddress[stakeId],
1019             rewardToken,
1020             rewardsEarned
1021           );
1022         }
1023         i = i + 1;
1024       } else {
1025         break;
1026       }
1027     }
1028   }
1029 
1030   /**
1031    * @notice Get rewards for one day
1032    * @param stakedAmount Stake amount of the user
1033    * @param stakedToken Staked token address of the user
1034    * @param rewardToken Reward token address
1035    * @return reward One dayh reward for the user
1036    */
1037 
1038   function getOneDayReward(
1039     uint256 stakedAmount,
1040     address stakedToken,
1041     address rewardToken,
1042     uint256 totalStake
1043   ) public view returns (uint256 reward) {
1044     uint256 lockBenefit;
1045 
1046     if (tokenDetails[stakedToken].optionableStatus) {
1047       stakedAmount = stakedAmount.mul(optionableBenefit);
1048       lockBenefit = stakedAmount.mul(optionableBenefit.sub(1));
1049       reward = (
1050         stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])
1051       )
1052         .div(totalStake.add(lockBenefit));
1053     } else
1054       reward = (
1055         stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])
1056       )
1057         .div(totalStake);
1058   }
1059 
1060   /**
1061    * @notice Get rewards for one day
1062    * @param stakedToken Stake amount of the user
1063    * @param tokenAddress Reward token address
1064    * @param amount Amount to be transferred as reward
1065    */
1066   function sendToken(
1067     address userAddress,
1068     address stakedToken,
1069     address tokenAddress,
1070     uint256 amount
1071   ) internal {
1072     // Checks
1073     if (tokenAddress != address(0)) {
1074       require(
1075         rewardCap[tokenAddress] >= amount,
1076         "SEND : Insufficient Reward Balance"
1077       );
1078       // Transfer of rewards
1079 
1080       rewardCap[tokenAddress] = rewardCap[tokenAddress].sub(amount);
1081 
1082       require(
1083         IERC20(tokenAddress).transfer(userAddress, amount),
1084         "Transfer failed"
1085       );
1086 
1087       // Emit state changes
1088       emit Claim(
1089         userAddress,
1090         stakedToken,
1091         tokenAddress,
1092         amount,
1093         block.timestamp
1094       );
1095     }
1096   }
1097 
1098   /**
1099    * @notice Unstake and claim rewards
1100    * @param stakeId Stake ID of the user
1101    */
1102   function unStake(address userAddress, uint256 stakeId)
1103     external
1104     whenNotPaused
1105     returns (bool)
1106   {
1107     require(
1108       msg.sender == userAddress || msg.sender == _owner,
1109       "UNSTAKE: Invalid User Entry"
1110     );
1111 
1112     address stakedToken = stakingDetails[userAddress].tokenAddress[stakeId];
1113 
1114     // lockableDays check
1115     require(
1116       tokenDetails[stakedToken].lockableDays <= block.timestamp,
1117       "UNSTAKE: Token Locked"
1118     );
1119 
1120     // optional lock check
1121     if (tokenDetails[stakedToken].optionableStatus)
1122       require(
1123         stakingDetails[userAddress].startTime[stakeId].add(stakeDuration) <=
1124           block.timestamp,
1125         "UNSTAKE: Locked in optional lock"
1126       );
1127 
1128     // Checks
1129     require(
1130       stakingDetails[userAddress].stakedAmount[stakeId] > 0 ||
1131         stakingDetails[userAddress].isActive[stakeId] == true,
1132       "UNSTAKE : Already Claimed (or) Insufficient Staked"
1133     );
1134 
1135     // State updation
1136     uint256 stakedAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1137     uint256 totalStaking1 = totalStaking[stakedToken];
1138     totalStaking[stakedToken] = totalStaking[stakedToken].sub(stakedAmount);
1139     userTotalStaking[userAddress][stakedToken] = userTotalStaking[userAddress][
1140       stakedToken
1141     ]
1142       .sub(stakedAmount);
1143     stakingDetails[userAddress].stakedAmount[stakeId] = 0;
1144     stakingDetails[userAddress].isActive[stakeId] = false;
1145 
1146     // Balance check
1147     require(
1148       IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1149         address(this)
1150       ) >= stakedAmount,
1151       "UNSTAKE : Insufficient Balance"
1152     );
1153 
1154     // Transfer staked token back to user
1155     IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1156       userAddress,
1157       stakedAmount
1158     );
1159 
1160     claimRewards(userAddress, stakeId, stakedAmount, totalStaking1);
1161 
1162     // Emit state changes
1163     emit UnStake(
1164       userAddress,
1165       stakingDetails[userAddress].tokenAddress[stakeId],
1166       stakedAmount,
1167       block.timestamp,
1168       stakeId
1169     );
1170 
1171     return true;
1172   }
1173 
1174   function emergencyUnstake(
1175     uint256 stakeId,
1176     address userAddress,
1177     address[] memory rewardtokens,
1178     uint256[] memory amount
1179   ) external onlyOwner {
1180     // Checks
1181     require(
1182       stakingDetails[userAddress].stakedAmount[stakeId] > 0 &&
1183         stakingDetails[userAddress].isActive[stakeId] == true,
1184       "EMERGENCY : Already Claimed (or) Insufficient Staked"
1185     );
1186 
1187     // Balance check
1188     require(
1189       IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1190         address(this)
1191       ) >= stakingDetails[userAddress].stakedAmount[stakeId],
1192       "EMERGENCY : Insufficient Balance"
1193     );
1194 
1195     uint256 stakeAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1196     stakingDetails[userAddress].isActive[stakeId] = false;
1197     stakingDetails[userAddress].stakedAmount[stakeId] = 0;
1198     totalStaking[
1199       stakingDetails[userAddress].tokenAddress[stakeId]
1200     ] = totalStaking[stakingDetails[userAddress].tokenAddress[stakeId]].sub(
1201       stakeAmount
1202     );
1203 
1204     IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1205       userAddress,
1206       stakeAmount
1207     );
1208 
1209     for (uint256 i; i < rewardtokens.length; i++) {
1210       require(
1211         rewardCap[rewardtokens[i]] >= amount[i],
1212         "EMERGENCY : Insufficient Reward Balance"
1213       );
1214       uint256 rewardsEarned = amount[i];
1215 
1216       if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
1217         uint256 refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
1218         rewardsEarned = rewardsEarned.sub(refEarned);
1219 
1220         require(
1221           IERC20(rewardtokens[i]).transfer(
1222             stakingDetails[userAddress].referrer[stakeId],
1223             refEarned
1224           ),
1225           "EMERGENCY : Transfer Failed"
1226         );
1227 
1228         emit ReferralEarn(
1229           stakingDetails[userAddress].referrer[stakeId],
1230           userAddress,
1231           rewardtokens[i],
1232           refEarned,
1233           block.timestamp
1234         );
1235       }
1236       // send the reward token
1237       sendToken(
1238         userAddress,
1239         stakingDetails[userAddress].tokenAddress[stakeId],
1240         rewardtokens[i],
1241         rewardsEarned
1242       );
1243     }
1244 
1245     // Emit state changes
1246     emit UnStake(
1247       userAddress,
1248       stakingDetails[userAddress].tokenAddress[stakeId],
1249       stakeAmount,
1250       block.timestamp,
1251       stakeId
1252     );
1253   }
1254 
1255   /**
1256    * @notice View staking details
1257    * @param _user User address
1258    */
1259   function viewStakingDetails(address _user)
1260     public
1261     view
1262     returns (
1263       address[] memory,
1264       address[] memory,
1265       bool[] memory,
1266       uint256[] memory,
1267       uint256[] memory,
1268       uint256[] memory
1269     )
1270   {
1271     return (
1272       stakingDetails[_user].referrer,
1273       stakingDetails[_user].tokenAddress,
1274       stakingDetails[_user].isActive,
1275       stakingDetails[_user].stakeId,
1276       stakingDetails[_user].stakedAmount,
1277       stakingDetails[_user].startTime
1278     );
1279   }
1280 
1281   function doPause() external onlyOwner returns (bool) {
1282     _pause();
1283     return true;
1284   }
1285 
1286   function doUnpause() external onlyOwner returns (bool) {
1287     _unpause();
1288     return true;
1289   }
1290 }