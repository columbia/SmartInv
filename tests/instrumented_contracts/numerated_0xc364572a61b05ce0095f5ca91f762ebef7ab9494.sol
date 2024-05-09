1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File contracts/libraries/Context.sol
4 
5 pragma solidity >=0.6.0 <=0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 // File contracts/abstract/Pausable.sol
30 
31 // SPDX-License-Identifier: MIT;
32 
33 pragma solidity >=0.6.0 <=0.8.0;
34 
35 /**
36  * @dev Contract module which allows children to implement an emergency stop
37  * mechanism that can be triggered by an authorized account.
38  *
39  * This module is used through inheritance. It will make available the
40  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
41  * the functions of your contract. Note that they will not be pausable by
42  * simply including this module, only once the modifiers are put in place.
43  */
44 
45 abstract contract Pausable is Context {
46     /**
47      * @dev Emitted when the pause is triggered by `account`.
48      */
49     event Paused(address account);
50 
51     /**
52      * @dev Emitted when the pause is lifted by `account`.
53      */
54     event Unpaused(address account);
55 
56     bool private _paused;
57 
58     /**
59      * @dev Initializes the contract in unpaused state.
60      */
61     constructor() {
62         _paused = false;
63     }
64 
65     /**
66      * @dev Returns true if the contract is paused, and false otherwise.
67      */
68     function paused() public view virtual returns (bool) {
69         return _paused;
70     }
71 
72     /**
73      * @dev Modifier to make a function callable only when the contract is not paused.
74      *
75      * Requirements:
76      *
77      * - The contract must not be paused.
78      */
79     modifier whenNotPaused() {
80         require(!paused(), "Pausable: paused");
81         _;
82     }
83 
84     /**
85      * @dev Modifier to make a function callable only when the contract is paused.
86      *
87      * Requirements:
88      *
89      * - The contract must be paused.
90      */
91     modifier whenPaused() {
92         require(paused(), "Pausable: not paused");
93         _;
94     }
95 
96     /**
97      * @dev Triggers stopped state.
98      *
99      * Requirements:
100      *
101      * - The contract must not be paused.
102      */
103     function _pause() internal virtual whenNotPaused {
104         _paused = true;
105         emit Paused(_msgSender());
106     }
107 
108     /**
109      * @dev Returns to normal state.
110      *
111      * Requirements:
112      *
113      * - The contract must be paused.
114      */
115     function _unpause() internal virtual whenPaused {
116         _paused = false;
117         emit Unpaused(_msgSender());
118     }
119 }
120 
121 
122 // File contracts/abstract/Ownable.sol
123 
124 
125 pragma solidity >=0.6.0 <=0.8.0;
126 
127 abstract contract Ownable is Pausable {
128     address public _owner;
129     address public _admin;
130 
131     event OwnershipTransferred(
132         address indexed previousOwner,
133         address indexed newOwner
134     );
135 
136     /**
137      * @dev Initializes the contract setting the deployer as the initial owner.
138      */
139     constructor(address ownerAddress) {
140         _owner = msg.sender;
141         _admin = ownerAddress;
142         emit OwnershipTransferred(address(0), _owner);
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(_owner == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Throws if called by any account other than the owner.
155      */
156     modifier onlyAdmin() {
157         require(_admin == _msgSender(), "Ownable: caller is not the Admin");
158         _;
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public onlyAdmin {
169         emit OwnershipTransferred(_owner, _admin);
170         _owner = _admin;
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Can only be called by the current owner.
176      */
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(
179             newOwner != address(0),
180             "Ownable: new owner is the zero address"
181         );
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 
188 // File contracts/libraries/SafeMath.sol
189 
190 
191 pragma solidity ^0.7.0;
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 
207 library SafeMath {
208     /**
209      * @dev Returns the addition of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `+` operator.
213      *
214      * Requirements:
215      *
216      * - Addition cannot overflow.
217      */
218     function add(uint256 a, uint256 b) internal pure returns (uint256) {
219         uint256 c = a + b;
220         require(c >= a, "SafeMath: addition overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      *
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         return sub(a, b, "SafeMath: subtraction overflow");
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * Counterpart to Solidity's `-` operator.
244      *
245      * Requirements:
246      *
247      * - Subtraction cannot overflow.
248      */
249     function sub(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         uint256 c = a - b;
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `*` operator.
265      *
266      * Requirements:
267      *
268      * - Multiplication cannot overflow.
269      */
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
272         // benefit is lost if 'b' is also tested.
273         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
274         if (a == 0) {
275             return 0;
276         }
277 
278         uint256 c = a * b;
279         require(c / a == b, "SafeMath: multiplication overflow");
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers. Reverts on
286      * division by zero. The result is rounded towards zero.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         return div(a, b, "SafeMath: division by zero");
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
302      * division by zero. The result is rounded towards zero.
303      *
304      * Counterpart to Solidity's `/` operator. Note: this function uses a
305      * `revert` opcode (which leaves remaining gas untouched) while Solidity
306      * uses an invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function div(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         require(b > 0, errorMessage);
318         uint256 c = a / b;
319 
320         return c;
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * Reverts when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return mod(a, b, "SafeMath: modulo by zero");
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts with custom message when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      *
349      * - The divisor cannot be zero.
350      */
351     function mod(
352         uint256 a,
353         uint256 b,
354         string memory errorMessage
355     ) internal pure returns (uint256) {
356         require(b != 0, errorMessage);
357         return a % b;
358     }
359 }
360 
361 
362 // File contracts/interfaces/IERC20.sol
363 
364 
365 pragma solidity ^0.7.0;
366 
367 /**
368  * @dev Interface of the ERC20 standard as defined in the EIP.
369  */
370 interface IERC20 {
371     /**
372      * @dev Returns the amount of tokens in existence.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     /**
377      * @dev Returns the amount of tokens owned by `account`.
378      */
379     function balanceOf(address account) external view returns (uint256);
380 
381     /**
382      * @dev Moves `amount` tokens from the caller's account to `recipient`.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transfer(address recipient, uint256 amount)
389         external
390         returns (bool);
391 
392     /**
393      * @dev Returns the remaining number of tokens that `spender` will be
394      * allowed to spend on behalf of `owner` through {transferFrom}. This is
395      * zero by default.
396      *
397      * This value changes when {approve} or {transferFrom} are called.
398      */
399     function allowance(address owner, address spender)
400         external
401         view
402         returns (uint256);
403 
404     /**
405      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * IMPORTANT: Beware that changing an allowance with this method brings the risk
410      * that someone may use both the old and the new allowance by unfortunate
411      * transaction ordering. One possible solution to mitigate this race
412      * condition is to first reduce the spender's allowance to 0 and set the
413      * desired value afterwards:
414      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
415      *
416      * Emits an {Approval} event.
417      */
418     function approve(address spender, uint256 amount) external returns (bool);
419 
420     /**
421      * @dev Moves `amount` tokens from `sender` to `recipient` using the
422      * allowance mechanism. `amount` is then deducted from the caller's
423      * allowance.
424      *
425      * Returns a boolean value indicating whether the operation succeeded.
426      *
427      * Emits a {Transfer} event.
428      */
429     function transferFrom(
430         address sender,
431         address recipient,
432         uint256 amount
433     ) external returns (bool);
434 
435     /**
436      * @dev Emitted when `value` tokens are moved from one account (`from`) to
437      * another (`to`).
438      *
439      * Note that `value` may be zero.
440      */
441     event Transfer(address indexed from, address indexed to, uint256 value);
442 
443     /**
444      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
445      * a call to {approve}. `value` is the new allowance.
446      */
447     event Approval(
448         address indexed owner,
449         address indexed spender,
450         uint256 value
451     );
452 }
453 
454 
455 // File contracts/abstract/Admin.sol
456 
457 
458 pragma solidity ^0.7.0;
459 
460 
461 
462 abstract contract Admin is Ownable {
463   struct tokenInfo {
464     bool isExist;
465     uint8 decimal;
466     uint256 userMinStake;
467     uint256 userMaxStake;
468     uint256 totalMaxStake;
469     uint256 lockableDays;
470     bool optionableStatus;
471   }
472 
473   using SafeMath for uint256;
474   address[] public tokens;
475   mapping(address => address[]) public tokensSequenceList;
476   mapping(address => tokenInfo) public tokenDetails;
477   mapping(address => mapping(address => uint256)) public tokenDailyDistribution;
478   mapping(address => mapping(address => bool)) public tokenBlockedStatus;
479   uint256[] public intervalDays = [1, 8, 15, 22, 29, 36];
480   uint256 public constant DAYS = 1 days;
481   uint256 public constant HOURS = 1 hours;
482   uint256 public stakeDuration;
483   uint256 public refPercentage;
484   uint256 public optionableBenefit;
485 
486   event TokenDetails(
487     address indexed tokenAddress,
488     uint256 userMinStake,
489     uint256 userMaxStake,
490     uint256 totalMaxStake,
491     uint256 updatedTime
492   );
493 
494   event LockableTokenDetails(
495     address indexed tokenAddress,
496     uint256 lockableDys,
497     bool optionalbleStatus,
498     uint256 updatedTime
499   );
500 
501   event DailyDistributionDetails(
502     address indexed stakedTokenAddress,
503     address indexed rewardTokenAddress,
504     uint256 rewards,
505     uint256 time
506   );
507 
508   event SequenceDetails(
509     address indexed stakedTokenAddress,
510     address[] rewardTokenSequence,
511     uint256 time
512   );
513 
514   event StakeDurationDetails(uint256 updatedDuration, uint256 time);
515 
516   event OptionableBenefitDetails(uint256 updatedBenefit, uint256 time);
517 
518   event ReferrerPercentageDetails(uint256 updatedRefPercentage, uint256 time);
519 
520   event IntervalDaysDetails(uint256[] updatedIntervals, uint256 time);
521 
522   event BlockedDetails(
523     address indexed stakedTokenAddress,
524     address indexed rewardTokenAddress,
525     bool blockedStatus,
526     uint256 time
527   );
528 
529   event WithdrawDetails(
530     address indexed tokenAddress,
531     uint256 withdrawalAmount,
532     uint256 time
533   );
534 
535   constructor(address _owner) Ownable(_owner) {
536     stakeDuration = 90 days;
537     refPercentage = 2500000000000000000;
538     optionableBenefit = 2;
539   }
540 
541   function addToken(
542     address tokenAddress,
543     uint256 userMinStake,
544     uint256 userMaxStake,
545     uint256 totalStake,
546     uint8 decimal
547   ) public onlyOwner returns (bool) {
548     if (!(tokenDetails[tokenAddress].isExist)) tokens.push(tokenAddress);
549 
550     tokenDetails[tokenAddress].isExist = true;
551     tokenDetails[tokenAddress].decimal = decimal;
552     tokenDetails[tokenAddress].userMinStake = userMinStake;
553     tokenDetails[tokenAddress].userMaxStake = userMaxStake;
554     tokenDetails[tokenAddress].totalMaxStake = totalStake;
555 
556     emit TokenDetails(
557       tokenAddress,
558       userMinStake,
559       userMaxStake,
560       totalStake,
561       block.timestamp
562     );
563     return true;
564   }
565 
566   function setDailyDistribution(
567     address[] memory stakedToken,
568     address[] memory rewardToken,
569     uint256[] memory dailyDistribution
570   ) public onlyOwner {
571     require(
572       stakedToken.length == rewardToken.length &&
573         rewardToken.length == dailyDistribution.length,
574       "Invalid Input"
575     );
576 
577     for (uint8 i = 0; i < stakedToken.length; i++) {
578       require(
579         tokenDetails[stakedToken[i]].isExist &&
580           tokenDetails[rewardToken[i]].isExist,
581         "Token not exist"
582       );
583       tokenDailyDistribution[stakedToken[i]][
584         rewardToken[i]
585       ] = dailyDistribution[i];
586 
587       emit DailyDistributionDetails(
588         stakedToken[i],
589         rewardToken[i],
590         dailyDistribution[i],
591         block.timestamp
592       );
593     }
594   }
595 
596   function updateSequence(
597     address stakedToken,
598     address[] memory rewardTokenSequence
599   ) public onlyOwner {
600     tokensSequenceList[stakedToken] = new address[](0);
601     require(tokenDetails[stakedToken].isExist, "Staked Token Not Exist");
602     for (uint8 i = 0; i < rewardTokenSequence.length; i++) {
603       require(rewardTokenSequence.length <= tokens.length, "Invalid Input");
604       require(
605         tokenDetails[rewardTokenSequence[i]].isExist,
606         "Reward Token Not Exist"
607       );
608       tokensSequenceList[stakedToken].push(rewardTokenSequence[i]);
609     }
610 
611     emit SequenceDetails(
612       stakedToken,
613       tokensSequenceList[stakedToken],
614       block.timestamp
615     );
616   }
617 
618   function updateToken(
619     address tokenAddress,
620     uint256 userMinStake,
621     uint256 userMaxStake,
622     uint256 totalStake
623   ) public onlyOwner {
624     require(tokenDetails[tokenAddress].isExist, "Token Not Exist");
625     tokenDetails[tokenAddress].userMinStake = userMinStake;
626     tokenDetails[tokenAddress].userMaxStake = userMaxStake;
627     tokenDetails[tokenAddress].totalMaxStake = totalStake;
628 
629     emit TokenDetails(
630       tokenAddress,
631       userMinStake,
632       userMaxStake,
633       totalStake,
634       block.timestamp
635     );
636   }
637 
638   function lockableToken(
639     address tokenAddress,
640     uint8 lockableStatus,
641     uint256 lockedDays,
642     bool optionableStatus
643   ) public onlyOwner {
644     require(
645       lockableStatus == 1 || lockableStatus == 2 || lockableStatus == 3,
646       "Invalid Lockable Status"
647     );
648     require(tokenDetails[tokenAddress].isExist == true, "Token Not Exist");
649 
650     if (lockableStatus == 1) {
651       tokenDetails[tokenAddress].lockableDays = block.timestamp.add(lockedDays);
652     } else if (lockableStatus == 2) tokenDetails[tokenAddress].lockableDays = 0;
653     else if (lockableStatus == 3)
654       tokenDetails[tokenAddress].optionableStatus = optionableStatus;
655 
656     emit LockableTokenDetails(
657       tokenAddress,
658       tokenDetails[tokenAddress].lockableDays,
659       tokenDetails[tokenAddress].optionableStatus,
660       block.timestamp
661     );
662   }
663 
664   function updateStakeDuration(uint256 durationTime) public onlyOwner {
665     stakeDuration = durationTime;
666 
667     emit StakeDurationDetails(stakeDuration, block.timestamp);
668   }
669 
670   function updateOptionableBenefit(uint256 benefit) public onlyOwner {
671     optionableBenefit = benefit;
672 
673     emit OptionableBenefitDetails(optionableBenefit, block.timestamp);
674   }
675 
676   function updateRefPercentage(uint256 refPer) public onlyOwner {
677     refPercentage = refPer;
678 
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
719 
720     emit WithdrawDetails(tokenAddress, amount, block.timestamp);
721   }
722 
723   function viewTokensCount() external view returns (uint256) {
724     return tokens.length;
725   }
726 }
727 
728 
729 // File contracts/UnifarmV11.sol
730 
731 pragma solidity ^0.7.6;
732 
733 /**
734  * @title Unifarm Contract
735  * @author OroPocket
736  */
737 
738 contract UnifarmV11 is Admin {
739   // Wrappers over Solidity's arithmetic operations
740   using SafeMath for uint256;
741 
742   // Stores Stake Details
743   struct stakeInfo {
744     address user;
745     bool[] isActive;
746     address[] referrer;
747     address[] tokenAddress;
748     uint256[] stakeId;
749     uint256[] stakedAmount;
750     uint256[] startTime;
751   }
752 
753   // Mapping
754   mapping(address => stakeInfo) public stakingDetails;
755   mapping(address => mapping(address => uint256)) public userTotalStaking;
756   mapping(address => uint256) public totalStaking;
757   uint256 public poolStartTime;
758 
759   // Events
760   event Stake(
761     address indexed userAddress,
762     uint256 stakeId,
763     address indexed referrerAddress,
764     address indexed tokenAddress,
765     uint256 stakedAmount,
766     uint256 time
767   );
768 
769   event Claim(
770     address indexed userAddress,
771     address indexed stakedTokenAddress,
772     address indexed tokenAddress,
773     uint256 claimRewards,
774     uint256 time
775   );
776 
777   event UnStake(
778     address indexed userAddress,
779     address indexed unStakedtokenAddress,
780     uint256 unStakedAmount,
781     uint256 time,
782     uint256 stakeId
783   );
784 
785   event ReferralEarn(
786     address indexed userAddress,
787     address indexed callerAddress,
788     address indexed rewardTokenAddress,
789     uint256 rewardAmount,
790     uint256 time
791   );
792 
793   constructor() Admin(msg.sender) {
794     poolStartTime = block.timestamp;
795   }
796 
797   /**
798    * @notice Stake tokens to earn rewards
799    * @param tokenAddress Staking token address
800    * @param amount Amount of tokens to be staked
801    */
802 
803   function stake(
804     address referrerAddress,
805     address tokenAddress,
806     uint256 amount
807   ) external whenNotPaused {
808     // checks
809     require(msg.sender != referrerAddress, "STAKE: invalid referrer address");
810     require(tokenDetails[tokenAddress].isExist, "STAKE : Token is not Exist");
811     require(
812       userTotalStaking[msg.sender][tokenAddress].add(amount) >=
813         tokenDetails[tokenAddress].userMinStake,
814       "STAKE : Min Amount should be within permit"
815     );
816     require(
817       userTotalStaking[msg.sender][tokenAddress].add(amount) <=
818         tokenDetails[tokenAddress].userMaxStake,
819       "STAKE : Max Amount should be within permit"
820     );
821     require(
822       totalStaking[tokenAddress].add(amount) <=
823         tokenDetails[tokenAddress].totalMaxStake,
824       "STAKE : Maxlimit exceeds"
825     );
826 
827     require(
828       poolStartTime.add(stakeDuration) > block.timestamp,
829       "STAKE: Staking Time Completed"
830     );
831 
832     // Storing stake details
833     stakingDetails[msg.sender].stakeId.push(
834       stakingDetails[msg.sender].stakeId.length
835     );
836     stakingDetails[msg.sender].isActive.push(true);
837     stakingDetails[msg.sender].user = msg.sender;
838     stakingDetails[msg.sender].referrer.push(referrerAddress);
839     stakingDetails[msg.sender].tokenAddress.push(tokenAddress);
840     stakingDetails[msg.sender].startTime.push(block.timestamp);
841 
842     // Update total staking amount
843     stakingDetails[msg.sender].stakedAmount.push(amount);
844     totalStaking[tokenAddress] = totalStaking[tokenAddress].add(amount);
845     userTotalStaking[msg.sender][tokenAddress] = userTotalStaking[msg.sender][
846       tokenAddress
847     ]
848       .add(amount);
849 
850     // Transfer tokens from userf to contract
851     require(
852       IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount),
853       "Transfer Failed"
854     );
855 
856     // Emit state changes
857     emit Stake(
858       msg.sender,
859       (stakingDetails[msg.sender].stakeId.length.sub(1)),
860       referrerAddress,
861       tokenAddress,
862       amount,
863       block.timestamp
864     );
865   }
866 
867   /**
868    * @notice Claim accumulated rewards
869    * @param stakeId Stake ID of the user
870    * @param stakedAmount Staked amount of the user
871    */
872 
873   function claimRewards(
874     address userAddress,
875     uint256 stakeId,
876     uint256 stakedAmount,
877     uint256 totalStake
878   ) internal {
879     // Local variables
880     uint256 interval;
881     uint256 endOfProfit;
882 
883     interval = poolStartTime.add(stakeDuration);
884 
885     // Interval calculation
886     if (interval > block.timestamp) endOfProfit = block.timestamp;
887     else endOfProfit = poolStartTime.add(stakeDuration);
888 
889     interval = endOfProfit.sub(stakingDetails[userAddress].startTime[stakeId]);
890     uint256[2] memory stakeData;
891     stakeData[0] = (stakedAmount);
892     stakeData[1] = (totalStake);
893 
894     // Reward calculation
895     if (interval >= HOURS)
896       _rewardCalculation(userAddress, stakeId, stakeData, interval);
897   }
898 
899   function _rewardCalculation(
900     address userAddress,
901     uint256 stakeId,
902     uint256[2] memory stakingData,
903     uint256 interval
904   ) internal {
905     uint256 rewardsEarned;
906     uint256 refEarned;
907     uint256[2] memory noOfDays;
908 
909     noOfDays[1] = interval.div(HOURS);
910     noOfDays[0] = interval.div(DAYS);
911 
912     rewardsEarned = noOfDays[1].mul(
913       getOneDayReward(
914         stakingData[0],
915         stakingDetails[userAddress].tokenAddress[stakeId],
916         stakingDetails[userAddress].tokenAddress[stakeId],
917         stakingData[1]
918       )
919     );
920 
921     // Referrer Earning
922     if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
923       refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
924       rewardsEarned = rewardsEarned.sub(refEarned);
925 
926       require(
927         IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
928           stakingDetails[userAddress].referrer[stakeId],
929           refEarned
930         ) == true,
931         "Transfer Failed"
932       );
933 
934       emit ReferralEarn(
935         stakingDetails[userAddress].referrer[stakeId],
936         msg.sender,
937         stakingDetails[userAddress].tokenAddress[stakeId],
938         refEarned,
939         block.timestamp
940       );
941     }
942 
943     //  Rewards Send
944     sendToken(
945       userAddress,
946       stakingDetails[userAddress].tokenAddress[stakeId],
947       stakingDetails[userAddress].tokenAddress[stakeId],
948       rewardsEarned
949     );
950 
951     uint8 i = 1;
952 
953     while (i < intervalDays.length) {
954       if (noOfDays[0] >= intervalDays[i]) {
955         uint256 reductionHours = (intervalDays[i].sub(1)).mul(24);
956         uint256 balHours = noOfDays[1].sub(reductionHours);
957 
958         address rewardToken =
959           tokensSequenceList[stakingDetails[userAddress].tokenAddress[stakeId]][
960             i
961           ];
962 
963         if (
964           rewardToken != stakingDetails[userAddress].tokenAddress[stakeId] &&
965           tokenBlockedStatus[stakingDetails[userAddress].tokenAddress[stakeId]][
966             rewardToken
967           ] ==
968           false
969         ) {
970           rewardsEarned = balHours.mul(
971             getOneDayReward(
972               stakingData[0],
973               stakingDetails[userAddress].tokenAddress[stakeId],
974               rewardToken,
975               stakingData[1]
976             )
977           );
978 
979           // Referrer Earning
980 
981           if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
982             refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
983             rewardsEarned = rewardsEarned.sub(refEarned);
984 
985             require(
986               IERC20(rewardToken).transfer(
987                 stakingDetails[userAddress].referrer[stakeId],
988                 refEarned
989               ) == true,
990               "Transfer Failed"
991             );
992 
993             emit ReferralEarn(
994               stakingDetails[userAddress].referrer[stakeId],
995               msg.sender,
996               stakingDetails[userAddress].tokenAddress[stakeId],
997               refEarned,
998               block.timestamp
999             );
1000           }
1001 
1002           //  Rewards Send
1003           sendToken(
1004             userAddress,
1005             stakingDetails[userAddress].tokenAddress[stakeId],
1006             rewardToken,
1007             rewardsEarned
1008           );
1009         }
1010         i = i + 1;
1011       } else {
1012         break;
1013       }
1014     }
1015   }
1016 
1017   /**
1018    * @notice Get rewards for one day
1019    * @param stakedAmount Stake amount of the user
1020    * @param stakedToken Staked token address of the user
1021    * @param rewardToken Reward token address
1022    * @return reward One dayh reward for the user
1023    */
1024 
1025   function getOneDayReward(
1026     uint256 stakedAmount,
1027     address stakedToken,
1028     address rewardToken,
1029     uint256 totalStake
1030   ) public view returns (uint256 reward) {
1031     uint256 lockBenefit;
1032 
1033     if (tokenDetails[stakedToken].optionableStatus) {
1034       stakedAmount = stakedAmount.mul(optionableBenefit);
1035       lockBenefit = stakedAmount.mul(optionableBenefit.sub(1));
1036       reward = (
1037         stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])
1038       )
1039         .div(totalStake.add(lockBenefit));
1040     } else
1041       reward = (
1042         stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])
1043       )
1044         .div(totalStake);
1045   }
1046 
1047   /**
1048    * @notice Get rewards for one day
1049    * @param stakedToken Stake amount of the user
1050    * @param tokenAddress Reward token address
1051    * @param amount Amount to be transferred as reward
1052    */
1053   function sendToken(
1054     address userAddress,
1055     address stakedToken,
1056     address tokenAddress,
1057     uint256 amount
1058   ) internal {
1059     // Checks
1060     if (tokenAddress != address(0)) {
1061       require(
1062         IERC20(tokenAddress).balanceOf(address(this)) >= amount,
1063         "SEND : Insufficient Balance"
1064       );
1065       // Transfer of rewards
1066       require(
1067         IERC20(tokenAddress).transfer(userAddress, amount),
1068         "Transfer failed"
1069       );
1070 
1071       // Emit state changes
1072       emit Claim(
1073         userAddress,
1074         stakedToken,
1075         tokenAddress,
1076         amount,
1077         block.timestamp
1078       );
1079     }
1080   }
1081 
1082   /**
1083    * @notice Unstake and claim rewards
1084    * @param stakeId Stake ID of the user
1085    */
1086   function unStake(address userAddress, uint256 stakeId)
1087     external
1088     whenNotPaused
1089     returns (bool)
1090   {
1091     require(
1092       msg.sender == userAddress || msg.sender == _owner,
1093       "UNSTAKE: Invalid User Entry"
1094     );
1095 
1096     address stakedToken = stakingDetails[userAddress].tokenAddress[stakeId];
1097 
1098     // lockableDays check
1099     require(
1100       tokenDetails[stakedToken].lockableDays <= block.timestamp,
1101       "UNSTAKE: Token Locked"
1102     );
1103 
1104     // optional lock check
1105     if (tokenDetails[stakedToken].optionableStatus)
1106       require(
1107         stakingDetails[userAddress].startTime[stakeId].add(stakeDuration) <=
1108           block.timestamp,
1109         "UNSTAKE: Locked in optional lock"
1110       );
1111 
1112     // Checks
1113     require(
1114       stakingDetails[userAddress].stakedAmount[stakeId] > 0 ||
1115         stakingDetails[userAddress].isActive[stakeId] == true,
1116       "UNSTAKE : Already Claimed (or) Insufficient Staked"
1117     );
1118 
1119     // State updation
1120     uint256 stakedAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1121     uint256 totalStaking1 = totalStaking[stakedToken];
1122     totalStaking[stakedToken] = totalStaking[stakedToken].sub(stakedAmount);
1123     userTotalStaking[userAddress][stakedToken] = userTotalStaking[userAddress][
1124       stakedToken
1125     ]
1126       .sub(stakedAmount);
1127     stakingDetails[userAddress].stakedAmount[stakeId] = 0;
1128     stakingDetails[userAddress].isActive[stakeId] = false;
1129 
1130     // Balance check
1131     require(
1132       IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1133         address(this)
1134       ) >= stakedAmount,
1135       "UNSTAKE : Insufficient Balance"
1136     );
1137 
1138     // Transfer staked token back to user
1139     IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1140       userAddress,
1141       stakedAmount
1142     );
1143 
1144     claimRewards(userAddress, stakeId, stakedAmount, totalStaking1);
1145 
1146     // Emit state changes
1147     emit UnStake(
1148       userAddress,
1149       stakingDetails[userAddress].tokenAddress[stakeId],
1150       stakedAmount,
1151       block.timestamp,
1152       stakeId
1153     );
1154 
1155     return true;
1156   }
1157 
1158   function emergencyUnstake(
1159     uint256 stakeId,
1160     address userAddress,
1161     address[] memory rewardtokens,
1162     uint256[] memory amount
1163   ) external onlyOwner {
1164     // Checks
1165     require(
1166       stakingDetails[userAddress].stakedAmount[stakeId] > 0 &&
1167         stakingDetails[userAddress].isActive[stakeId] == true,
1168       "EMERGENCY : Already Claimed (or) Insufficient Staked"
1169     );
1170 
1171     // Balance check
1172     require(
1173       IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1174         address(this)
1175       ) >= stakingDetails[userAddress].stakedAmount[stakeId],
1176       "EMERGENCY : Insufficient Balance"
1177     );
1178 
1179     uint256 stakeAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1180     stakingDetails[userAddress].isActive[stakeId] = false;
1181     stakingDetails[userAddress].stakedAmount[stakeId] = 0;
1182     totalStaking[
1183       stakingDetails[userAddress].tokenAddress[stakeId]
1184     ] = totalStaking[stakingDetails[userAddress].tokenAddress[stakeId]].sub(
1185       stakeAmount
1186     );
1187 
1188     IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1189       userAddress,
1190       stakeAmount
1191     );
1192 
1193     for (uint256 i; i < rewardtokens.length; i++) {
1194       require(
1195         IERC20(rewardtokens[i]).balanceOf(address(this)) >= amount[i],
1196         "EMERGENCY : Insufficient Reward Balance"
1197       );
1198       uint256 rewardsEarned = amount[i];
1199 
1200       if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
1201         uint256 refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
1202         rewardsEarned = rewardsEarned.sub(refEarned);
1203 
1204         require(
1205           IERC20(rewardtokens[i]).transfer(
1206             stakingDetails[userAddress].referrer[stakeId],
1207             refEarned
1208           ),
1209           "EMERGENCY : Transfer Failed"
1210         );
1211 
1212         emit ReferralEarn(
1213           stakingDetails[userAddress].referrer[stakeId],
1214           userAddress,
1215           rewardtokens[i],
1216           refEarned,
1217           block.timestamp
1218         );
1219       }
1220 
1221       IERC20(rewardtokens[i]).transfer(userAddress, rewardsEarned);
1222     }
1223 
1224     // Emit state changes
1225     emit UnStake(
1226       userAddress,
1227       stakingDetails[userAddress].tokenAddress[stakeId],
1228       stakeAmount,
1229       block.timestamp,
1230       stakeId
1231     );
1232   }
1233 
1234   /**
1235    * @notice View staking details
1236    * @param _user User address
1237    */
1238   function viewStakingDetails(address _user)
1239     public
1240     view
1241     returns (
1242       address[] memory,
1243       address[] memory,
1244       bool[] memory,
1245       uint256[] memory,
1246       uint256[] memory,
1247       uint256[] memory
1248     )
1249   {
1250     return (
1251       stakingDetails[_user].referrer,
1252       stakingDetails[_user].tokenAddress,
1253       stakingDetails[_user].isActive,
1254       stakingDetails[_user].stakeId,
1255       stakingDetails[_user].stakedAmount,
1256       stakingDetails[_user].startTime
1257     );
1258   }
1259 }