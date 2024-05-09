1 // File: @openzeppelin/contracts/GSN/Context.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity >=0.6.0 <=0.8.0;
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
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: contracts/abstract/Pausable.sol
27 
28 // File: @openzeppelin/contracts/utils/Pausable.sol
29 
30 pragma solidity >=0.6.0 <=0.8.0;
31 
32 /**
33  * @dev Contract module which allows children to implement an emergency stop
34  * mechanism that can be triggered by an authorized account.
35  *
36  * This module is used through inheritance. It will make available the
37  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
38  * the functions of your contract. Note that they will not be pausable by
39  * simply including this module, only once the modifiers are put in place.
40  */
41 abstract contract Pausable is Context {
42     /**
43      * @dev Emitted when the pause is triggered by `account`.
44      */
45     event Paused(address account);
46 
47     /**
48      * @dev Emitted when the pause is lifted by `account`.
49      */
50     event Unpaused(address account);
51 
52     bool private _paused;
53 
54     /**
55      * @dev Initializes the contract in unpaused state.
56      */
57     constructor () {
58         _paused = false;
59     }
60 
61     /**
62      * @dev Returns true if the contract is paused, and false otherwise.
63      */
64     function paused() public view virtual returns (bool) {
65         return _paused;
66     }
67 
68     /**
69      * @dev Modifier to make a function callable only when the contract is not paused.
70      *
71      * Requirements:
72      *
73      * - The contract must not be paused.
74      */
75     modifier whenNotPaused() {
76         require(!paused(), "Pausable: paused");
77         _;
78     }
79 
80     /**
81      * @dev Modifier to make a function callable only when the contract is paused.
82      *
83      * Requirements:
84      *
85      * - The contract must be paused.
86      */
87     modifier whenPaused() {
88         require(paused(), "Pausable: not paused");
89         _;
90     }
91 
92     /**
93      * @dev Triggers stopped state.
94      *
95      * Requirements:
96      *
97      * - The contract must not be paused.
98      */
99     function _pause() internal virtual whenNotPaused {
100         _paused = true;
101         emit Paused(_msgSender());
102     }
103 
104     /**
105      * @dev Returns to normal state.
106      *
107      * Requirements:
108      *
109      * - The contract must be paused.
110      */
111     function _unpause() internal virtual whenPaused {
112         _paused = false;
113         emit Unpaused(_msgSender());
114     }
115 }
116 
117 // File: contracts/abstract/Ownable.sol
118 
119 // File: @openzeppelin/contracts/access/Ownable.sol
120 
121 pragma solidity >=0.6.0 <=0.8.0;
122 
123 /**
124  * @dev Contract module which provides a basic access control mechanism, where
125  * there is an account (an owner) that can be granted exclusive access to
126  * specific functions.
127  *
128  * By default, the owner account will be the one that deploys the contract. This
129  * can later be changed with {transferOwnership}.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be applied to your functions to restrict their use to
133  * the owner.
134  */
135 abstract contract Ownable is Pausable {
136     address public _owner;
137     address public _admin;
138 
139     event OwnershipTransferred(
140         address indexed previousOwner,
141         address indexed newOwner
142     );
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor(address ownerAddress) {
148         _owner = msg.sender;
149         _admin = ownerAddress;
150         emit OwnershipTransferred(address(0), _owner);
151     }
152 
153     
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(_owner == _msgSender(), "Ownable: caller is not the owner");
159         _;
160     }
161     
162     /**
163      * @dev Throws if called by any account other than the owner.
164      */
165     modifier onlyAdmin() {
166         require(_admin == _msgSender(), "Ownable: caller is not the owner");
167         _;
168     }
169 
170     /**
171      * @dev Leaves the contract without owner. It will not be possible to call
172      * `onlyOwner` functions anymore. Can only be called by the current owner.
173      *
174      * NOTE: Renouncing ownership will leave the contract without an owner,
175      * thereby removing any functionality that is only available to the owner.
176      */
177     function renounceOwnership() public onlyAdmin {
178         emit OwnershipTransferred(_owner, _admin);
179         _owner = _admin;
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Can only be called by the current owner.
185      */
186     function transferOwnership(address newOwner) public virtual onlyOwner {
187         require(
188             newOwner != address(0),
189             "Ownable: new owner is the zero address"
190         );
191         emit OwnershipTransferred(_owner, newOwner);
192         _owner = newOwner;
193     }
194    
195 }
196 
197 // File: contracts/library/SafeMath.sol
198 
199 pragma solidity ^0.7.0;
200 
201 /**
202  * @dev Wrappers over Solidity's arithmetic operations with added overflow
203  * checks.
204  *
205  * Arithmetic operations in Solidity wrap on overflow. This can easily result
206  * in bugs, because programmers usually assume that an overflow raises an
207  * error, which is the standard behavior in high level programming languages.
208  * `SafeMath` restores this intuition by reverting the transaction when an
209  * operation overflows.
210  *
211  * Using this library instead of the unchecked operations eliminates an entire
212  * class of bugs, so it's recommended to use it always.
213  */
214 library SafeMath {
215     /**
216      * @dev Returns the addition of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `+` operator.
220      *
221      * Requirements:
222      *
223      * - Addition cannot overflow.
224      */
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a, "SafeMath: addition overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      *
240      * - Subtraction cannot overflow.
241      */
242     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243         return sub(a, b, "SafeMath: subtraction overflow");
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
248      * overflow (when the result is negative).
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      *
254      * - Subtraction cannot overflow.
255      */
256     function sub(
257         uint256 a,
258         uint256 b,
259         string memory errorMessage
260     ) internal pure returns (uint256) {
261         require(b <= a, errorMessage);
262         uint256 c = a - b;
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the multiplication of two unsigned integers, reverting on
269      * overflow.
270      *
271      * Counterpart to Solidity's `*` operator.
272      *
273      * Requirements:
274      *
275      * - Multiplication cannot overflow.
276      */
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
279         // benefit is lost if 'b' is also tested.
280         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
281         if (a == 0) {
282             return 0;
283         }
284 
285         uint256 c = a * b;
286         require(c / a == b, "SafeMath: multiplication overflow");
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers. Reverts on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(uint256 a, uint256 b) internal pure returns (uint256) {
304         return div(a, b, "SafeMath: division by zero");
305     }
306 
307     /**
308      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
309      * division by zero. The result is rounded towards zero.
310      *
311      * Counterpart to Solidity's `/` operator. Note: this function uses a
312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
313      * uses an invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function div(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         require(b > 0, errorMessage);
325         uint256 c = a / b;
326 
327         return c;
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * Reverts when dividing by zero.
333      *
334      * Counterpart to Solidity's `%` operator. This function uses a `revert`
335      * opcode (which leaves remaining gas untouched) while Solidity uses an
336      * invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      *
340      * - The divisor cannot be zero.
341      */
342     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
343         return mod(a, b, "SafeMath: modulo by zero");
344     }
345 
346     /**
347      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
348      * Reverts with custom message when dividing by zero.
349      *
350      * Counterpart to Solidity's `%` operator. This function uses a `revert`
351      * opcode (which leaves remaining gas untouched) while Solidity uses an
352      * invalid opcode to revert (consuming all remaining gas).
353      *
354      * Requirements:
355      *
356      * - The divisor cannot be zero.
357      */
358     function mod(
359         uint256 a,
360         uint256 b,
361         string memory errorMessage
362     ) internal pure returns (uint256) {
363         require(b != 0, errorMessage);
364         return a % b;
365     }
366 }
367 
368 // File: contracts/interface/IERC20.sol
369 
370 pragma solidity ^0.7.0;
371 
372 /**
373  * @dev Interface of the ERC20 standard as defined in the EIP.
374  */
375 interface IERC20 {
376     /**
377      * @dev Returns the amount of tokens in existence.
378      */
379     function totalSupply() external view returns (uint256);
380 
381     /**
382      * @dev Returns the amount of tokens owned by `account`.
383      */
384     function balanceOf(address account) external view returns (uint256);
385 
386     /**
387      * @dev Moves `amount` tokens from the caller's account to `recipient`.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transfer(address recipient, uint256 amount)
394         external
395         returns (bool);
396 
397     /**
398      * @dev Returns the remaining number of tokens that `spender` will be
399      * allowed to spend on behalf of `owner` through {transferFrom}. This is
400      * zero by default.
401      *
402      * This value changes when {approve} or {transferFrom} are called.
403      */
404     function allowance(address owner, address spender)
405         external
406         view
407         returns (uint256);
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * IMPORTANT: Beware that changing an allowance with this method brings the risk
415      * that someone may use both the old and the new allowance by unfortunate
416      * transaction ordering. One possible solution to mitigate this race
417      * condition is to first reduce the spender's allowance to 0 and set the
418      * desired value afterwards:
419      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
420      *
421      * Emits an {Approval} event.
422      */
423     function approve(address spender, uint256 amount) external returns (bool);
424 
425     /**
426      * @dev Moves `amount` tokens from `sender` to `recipient` using the
427      * allowance mechanism. `amount` is then deducted from the caller's
428      * allowance.
429      *
430      * Returns a boolean value indicating whether the operation succeeded.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address sender,
436         address recipient,
437         uint256 amount
438     ) external returns (bool);
439 
440     /**
441      * @dev Emitted when `value` tokens are moved from one account (`from`) to
442      * another (`to`).
443      *
444      * Note that `value` may be zero.
445      */
446     event Transfer(address indexed from, address indexed to, uint256 value);
447 
448     /**
449      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
450      * a call to {approve}. `value` is the new allowance.
451      */
452     event Approval(
453         address indexed owner,
454         address indexed spender,
455         uint256 value
456     );
457 }
458 
459 // File: contracts/Admin.sol
460 
461 pragma solidity ^0.7.0; 
462 
463 abstract contract Admin is Ownable {
464     struct tokenInfo {
465         bool isExist;
466         uint8 decimal;
467         uint256 userMinStake;
468         uint256 userMaxStake;
469         uint256 totalMaxStake;
470         uint256 lockableDays;
471         bool optionableStatus;
472     }
473 
474     using SafeMath for uint256;
475     address[] public tokens;
476     mapping (address => address[]) public tokensSequenceList;
477     mapping (address => tokenInfo) public tokenDetails;
478     mapping (address => mapping (address => uint256)) public tokenDailyDistribution;
479     mapping (address => mapping (address => bool)) public tokenBlockedStatus;
480     uint256[] public intervalDays = [1, 8, 15, 22, 29];
481     uint256 public constant DAYS = 1 days;
482     uint256 public constant HOURS = 1 hours;
483     uint256 public stakeDuration;
484     uint256 public refPercentage;
485     uint256 public optionableBenefit;
486 
487     event TokenDetails(
488         address indexed tokenAddress,
489         uint256 userMinStake,
490         uint256 userMaxStake,
491         uint256 totalMaxStake,
492         uint256 updatedTime
493     );
494     
495     event LockableTokenDetails(
496         address indexed tokenAddress,
497         uint256 lockableDys,
498         bool optionalbleStatus,
499         uint256 updatedTime
500     );
501     
502     event DailyDistributionDetails(
503         address indexed stakedTokenAddress,
504         address indexed rewardTokenAddress,
505         uint256 rewards,
506         uint256 time
507     );
508     
509     event SequenceDetails(
510         address indexed stakedTokenAddress,
511         address []  rewardTokenSequence,
512         uint256 time
513     );
514     
515     event StakeDurationDetails(
516         uint256 updatedDuration,
517         uint256 time
518     );
519     
520     event OptionableBenefitDetails(
521         uint256 updatedBenefit,
522         uint256 time
523     );
524     
525     event ReferrerPercentageDetails(
526         uint256 updatedRefPercentage,
527         uint256 time
528     );
529     
530     event IntervalDaysDetails(
531         uint256[] updatedIntervals,
532         uint256 time
533     );
534     
535     event BlockedDetails(
536         address indexed stakedTokenAddress,
537         address indexed rewardTokenAddress,
538         bool blockedStatus,
539         uint256 time
540     );
541     
542     event WithdrawDetails(
543         address indexed tokenAddress,
544         uint256 withdrawalAmount,
545         uint256 time
546     );
547 
548 
549     constructor(address _owner) Ownable(_owner) {
550         stakeDuration = 180 days;
551         refPercentage = 5 ether;
552         optionableBenefit = 2;
553     }
554 
555     function addToken(
556         address tokenAddress,
557         uint256 userMinStake,
558         uint256 userMaxStake,
559         uint256 totalStake,
560         uint8 decimal
561     ) public onlyOwner returns (bool) {
562         if (!(tokenDetails[tokenAddress].isExist))
563             tokens.push(tokenAddress);
564 
565         tokenDetails[tokenAddress].isExist = true;
566         tokenDetails[tokenAddress].decimal = decimal;
567         tokenDetails[tokenAddress].userMinStake = userMinStake;
568         tokenDetails[tokenAddress].userMaxStake = userMaxStake;
569         tokenDetails[tokenAddress].totalMaxStake = totalStake;
570 
571         emit TokenDetails(
572             tokenAddress,
573             userMinStake,
574             userMaxStake,
575             totalStake,
576             block.timestamp
577         );
578         return true;
579     }
580 
581     function setDailyDistribution(
582         address[] memory stakedToken,
583         address[] memory rewardToken,
584         uint256[] memory dailyDistribution
585     ) public onlyOwner {
586         require(
587             stakedToken.length == rewardToken.length &&
588                 rewardToken.length == dailyDistribution.length,
589             "Invalid Input"
590         );
591 
592         for (uint8 i = 0; i < stakedToken.length; i++) {
593             require(
594                 tokenDetails[stakedToken[i]].isExist &&
595                     tokenDetails[rewardToken[i]].isExist,
596                 "Token not exist"
597             );
598             tokenDailyDistribution[stakedToken[i]][
599                 rewardToken[i]
600             ] = dailyDistribution[i];
601             
602             emit DailyDistributionDetails(
603                 stakedToken[i],
604                 rewardToken[i],
605                 dailyDistribution[i],
606                 block.timestamp
607             );
608         }
609         
610         
611     }
612 
613     function updateSequence(
614         address stakedToken,
615         address[] memory rewardTokenSequence
616     ) public onlyOwner {
617         tokensSequenceList[stakedToken] = new address[](0);
618         require(
619             tokenDetails[stakedToken].isExist,
620             "Staked Token Not Exist"
621         );
622         for (uint8 i = 0; i < rewardTokenSequence.length; i++) {
623             require(
624                 rewardTokenSequence.length <= tokens.length,
625                 "Invalid Input"
626             );
627             require(
628                 tokenDetails[rewardTokenSequence[i]].isExist,
629                 "Reward Token Not Exist"
630             );
631             tokensSequenceList[stakedToken].push(rewardTokenSequence[i]);
632         }
633         
634         emit SequenceDetails(
635             stakedToken,
636             tokensSequenceList[stakedToken],
637             block.timestamp
638         );
639         
640         
641     }
642 
643     function updateToken(
644         address tokenAddress,
645         uint256 userMinStake,
646         uint256 userMaxStake,
647         uint256 totalStake
648     ) public onlyOwner {
649         require(tokenDetails[tokenAddress].isExist, "Token Not Exist");
650         tokenDetails[tokenAddress].userMinStake = userMinStake;
651         tokenDetails[tokenAddress].userMaxStake = userMaxStake;
652         tokenDetails[tokenAddress].totalMaxStake = totalStake;
653 
654         emit TokenDetails(
655             tokenAddress,
656             userMinStake,
657             userMaxStake,
658             totalStake,
659             block.timestamp
660         );
661     }
662 
663     function lockableToken(
664         address tokenAddress,
665         uint8 lockableStatus,
666         uint256 lockedDays,
667         bool optionableStatus
668     ) public onlyOwner {
669         require(
670             lockableStatus == 1 || lockableStatus == 2 || lockableStatus == 3,
671             "Invalid Lockable Status"
672         );
673         require(tokenDetails[tokenAddress].isExist == true, "Token Not Exist");
674 
675         if (lockableStatus == 1) {
676             tokenDetails[tokenAddress].lockableDays = block.timestamp.add(
677                 lockedDays
678             );
679         } else if (lockableStatus == 2)
680             tokenDetails[tokenAddress].lockableDays = 0;
681         else if (lockableStatus == 3)
682             tokenDetails[tokenAddress].optionableStatus = optionableStatus;
683             
684             
685         emit LockableTokenDetails (
686             tokenAddress,
687             tokenDetails[tokenAddress].lockableDays,
688             tokenDetails[tokenAddress].optionableStatus,
689             block.timestamp
690         );
691     }
692 
693     function updateStakeDuration(uint256 durationTime) public onlyOwner {
694         stakeDuration = durationTime;
695         
696         emit StakeDurationDetails(
697             stakeDuration,
698             block.timestamp
699         );
700     }
701 
702     function updateOptionableBenefit(uint256 benefit) public onlyOwner {
703         optionableBenefit = benefit;
704         
705         emit OptionableBenefitDetails(
706             optionableBenefit,
707             block.timestamp
708         );
709     }
710 
711     function updateRefPercentage(uint256 refPer) public onlyOwner {
712         refPercentage = refPer;
713         
714         emit ReferrerPercentageDetails(
715             refPercentage,
716             block.timestamp
717         );
718     }
719 
720     function updateIntervalDays(uint256[] memory _interval) public onlyOwner {
721         intervalDays = new uint256[](0);
722 
723         for (uint8 i = 0; i < _interval.length; i++) {
724             uint256 noD = stakeDuration.div(DAYS);
725             require(noD > _interval[i], "Invalid Interval Day");
726             intervalDays.push(_interval[i]);
727         }
728         
729         emit IntervalDaysDetails(
730             intervalDays,
731             block.timestamp
732         );
733         
734         
735     }
736 
737     function changeTokenBlockedStatus(
738         address stakedToken,
739         address rewardToken,
740         bool status
741     ) public onlyOwner {
742         require(
743             tokenDetails[stakedToken].isExist &&
744                 tokenDetails[rewardToken].isExist,
745             "Token not exist"
746         );
747         tokenBlockedStatus[stakedToken][rewardToken] = status;
748         
749         
750         emit BlockedDetails(
751             stakedToken,
752             rewardToken,
753             tokenBlockedStatus[stakedToken][rewardToken],
754             block.timestamp
755         );
756     }
757 
758     function safeWithdraw(address tokenAddress, uint256 amount)
759         public
760         onlyOwner
761     {
762         require(
763             IERC20(tokenAddress).balanceOf(address(this)) >= amount,
764             "Insufficient Balance"
765         );
766         require(
767             IERC20(tokenAddress).transfer(_owner, amount),
768             "Transfer failed"
769         );
770         
771         
772         emit WithdrawDetails(
773             tokenAddress,
774             amount,
775             block.timestamp
776         );
777     }
778     
779     function viewTokensCount() external view returns(uint256) {
780         return tokens.length;
781     }
782 }
783 
784 // File: contracts/UnifarmV4.sol
785 
786 pragma solidity ^0.7.0; 
787 
788 
789 /**
790  * @title Unifarm Contract
791  * @author OroPocket
792  */
793 
794 contract Unifarmv4 is Admin {
795     // Wrappers over Solidity's arithmetic operations
796     using SafeMath for uint256;
797 
798     // Stores Stake Details
799     struct stakeInfo {
800         address user;
801         bool[] isActive;
802         address[] referrer;
803         address[] tokenAddress;
804         uint256[] stakeId;
805         uint256[] stakedAmount;
806         uint256[] startTime;
807     }
808 
809     // Mapping
810     mapping(address => stakeInfo) public stakingDetails;
811     mapping(address => mapping(address => uint256)) public userTotalStaking;
812     mapping(address => uint256) public totalStaking;
813     uint256 public poolStartTime;
814 
815     // Events
816     event Stake(
817         address indexed userAddress,
818         uint256 stakeId,
819         address indexed referrerAddress,
820         address indexed tokenAddress,
821         uint256 stakedAmount,
822         uint256 time
823     );
824     event Claim(
825         address indexed userAddress,
826         address indexed stakedTokenAddress,
827         address indexed tokenAddress,
828         uint256 claimRewards,
829         uint256 time
830     );
831     event UnStake(
832         address indexed userAddress,
833         address indexed unStakedtokenAddress,
834         uint256 unStakedAmount,
835         uint256 time
836     );
837     
838      event ReferralEarn(
839         address indexed userAddress,
840         address indexed callerAddress,
841         address indexed rewardTokenAddress,	
842         uint256 rewardAmount,	
843         uint256 time	
844     );
845 
846     constructor() Admin(msg.sender) {
847         poolStartTime = block.timestamp;
848     }
849 
850     /**
851      * @notice Stake tokens to earn rewards
852      * @param tokenAddress Staking token address
853      * @param amount Amount of tokens to be staked
854      */
855     function stake(
856         address referrerAddress,
857         address tokenAddress,
858         uint256 amount
859     ) external whenNotPaused {
860         // checks
861         require(
862             tokenDetails[tokenAddress].isExist,
863             "STAKE : Token is not Exist"
864         );
865         require(
866             userTotalStaking[msg.sender][tokenAddress].add(amount) >=
867                 tokenDetails[tokenAddress].userMinStake,
868             "STAKE : Min Amount should be within permit"
869         );
870         require(
871             userTotalStaking[msg.sender][tokenAddress].add(amount) <=
872                 tokenDetails[tokenAddress].userMaxStake,
873             "STAKE : Max Amount should be within permit"
874         );
875         require(
876             totalStaking[tokenAddress].add(amount) <=
877                 tokenDetails[tokenAddress].totalMaxStake,
878             "STAKE : Maxlimit exceeds"
879         );
880 
881         require(poolStartTime.add(stakeDuration) > block.timestamp, "STAKE: Staking Time Completed");
882 
883         // Storing stake details
884         stakingDetails[msg.sender].stakeId.push(
885             stakingDetails[msg.sender].stakeId.length
886         );
887         stakingDetails[msg.sender].isActive.push(true);
888         stakingDetails[msg.sender].user = msg.sender;
889         stakingDetails[msg.sender].referrer.push(referrerAddress);
890         stakingDetails[msg.sender].tokenAddress.push(tokenAddress);
891         stakingDetails[msg.sender].startTime.push(block.timestamp);
892     
893         // Update total staking amount
894         stakingDetails[msg.sender].stakedAmount.push(amount);
895         totalStaking[tokenAddress] = totalStaking[tokenAddress].add(
896             amount
897         );
898         userTotalStaking[msg.sender][tokenAddress] = userTotalStaking[
899             msg.sender
900         ][tokenAddress]
901             .add(amount);
902 
903         // Transfer tokens from userf to contract
904         require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount),
905                 "Transfer Failed");
906 
907         // Emit state changes
908         emit Stake(msg.sender, (stakingDetails[msg.sender].stakeId.length.sub(1)), referrerAddress, tokenAddress, amount, block.timestamp);
909     }
910 
911     
912     
913     /**
914      * @notice Claim accumulated rewards
915      * @param stakeId Stake ID of the user
916      * @param stakedAmount Staked amount of the user
917      */
918     function claimRewards(address userAddress, uint256 stakeId, uint256 stakedAmount, uint256 totalStake) internal {
919         // Local variables
920         uint256  interval;
921         uint256 endOfProfit; 
922 
923         interval = poolStartTime.add(stakeDuration);
924         
925         // Interval calculation
926         if (interval > block.timestamp) 
927             endOfProfit = block.timestamp;
928            
929         else 
930             endOfProfit = poolStartTime.add(stakeDuration);
931         
932         interval = endOfProfit.sub(stakingDetails[userAddress].startTime[stakeId]); 
933         
934         uint256[2] memory stakeData;
935         stakeData[0]  = (stakedAmount);
936         stakeData[1] = (totalStake);
937 
938         // Reward calculation
939         if (interval >= HOURS) 
940             _rewardCalculation(userAddress, stakeId, stakeData, interval);
941     }
942 
943 
944      function _rewardCalculation(
945         address userAddress,
946         uint256 stakeId,
947         uint256[2] memory stakingData,
948         uint256 interval
949     ) internal {
950         uint256 rewardsEarned;
951         uint256 refEarned;
952         uint256[2] memory noOfDays;
953         
954         noOfDays[1] = interval.div(HOURS);
955         noOfDays[0] = interval.div(DAYS);
956 
957         rewardsEarned = noOfDays[1].mul(
958             getOneDayReward(
959                 stakingData[0],
960                 stakingDetails[userAddress].tokenAddress[stakeId],
961                 stakingDetails[userAddress].tokenAddress[stakeId],
962                 stakingData[1]
963             )
964         );
965 
966         // Referrer Earning
967         if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
968             refEarned =
969                 (rewardsEarned.mul(refPercentage)).div(100 ether);
970             rewardsEarned = rewardsEarned.sub(refEarned);
971 
972             require(IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
973                 stakingDetails[userAddress].referrer[stakeId],
974                 refEarned) == true, "Transfer Failed");
975 
976             emit ReferralEarn(
977                 stakingDetails[userAddress].referrer[stakeId],
978                 msg.sender,	
979                 stakingDetails[userAddress].tokenAddress[stakeId],
980                 refEarned,
981                 block.timestamp
982             );
983         }
984 
985         //  Rewards Send
986         sendToken(
987             userAddress,
988             stakingDetails[userAddress].tokenAddress[stakeId],
989             stakingDetails[userAddress].tokenAddress[stakeId],
990             rewardsEarned
991         );
992 
993         uint8 i = 1;
994         while (i < intervalDays.length) {
995             
996             if (noOfDays[0] >= intervalDays[i]) {
997                 uint256 reductionHours = (intervalDays[i].sub(1)).mul(24);
998                 uint256 balHours = noOfDays[1].sub(reductionHours);
999                 
1000 
1001                 address rewardToken =
1002                     tokensSequenceList[
1003                         stakingDetails[userAddress].tokenAddress[stakeId]][i];
1004 
1005                 if ( rewardToken != stakingDetails[userAddress].tokenAddress[stakeId] 
1006                         && tokenBlockedStatus[stakingDetails[userAddress].tokenAddress[stakeId]][rewardToken] ==  false) {
1007                     rewardsEarned = balHours.mul(
1008                         getOneDayReward(
1009                             stakingData[0],
1010                             stakingDetails[userAddress].tokenAddress[stakeId],
1011                             rewardToken,
1012                             stakingData[1]
1013                         )
1014                     );
1015 
1016                     // Referrer Earning
1017 
1018                     if (
1019                         stakingDetails[userAddress].referrer[stakeId] !=
1020                         address(0)
1021                     ) {
1022                         refEarned =
1023                             (rewardsEarned.mul(refPercentage)).div(100 ether);
1024                         rewardsEarned = rewardsEarned.sub(refEarned);
1025 
1026                         require(IERC20(rewardToken)
1027                             .transfer(
1028                             stakingDetails[userAddress].referrer[stakeId],
1029                             refEarned) == true, "Transfer Failed");
1030 
1031 
1032                         emit ReferralEarn(
1033                             stakingDetails[userAddress].referrer[stakeId],
1034                             msg.sender,	
1035                             stakingDetails[userAddress].tokenAddress[stakeId],
1036                             refEarned,
1037                             block.timestamp
1038                         );
1039                     }
1040 
1041                     //  Rewards Send
1042                     sendToken(
1043                         userAddress,
1044                         stakingDetails[userAddress].tokenAddress[stakeId],
1045                         rewardToken,
1046                         rewardsEarned
1047                     );
1048                 }
1049                 i = i + 1;
1050             } else {
1051                 break;
1052             }
1053         }
1054     }
1055     
1056     
1057     
1058 
1059 
1060     /**
1061      * @notice Get rewards for one day
1062      * @param stakedAmount Stake amount of the user
1063      * @param stakedToken Staked token address of the user
1064      * @param rewardToken Reward token address
1065      * @return reward One dayh reward for the user
1066      */
1067     function getOneDayReward(
1068         uint256 stakedAmount,
1069         address stakedToken,
1070         address rewardToken,
1071         uint256 totalStake
1072     ) public view returns (uint256 reward) {
1073         
1074         uint256 lockBenefit;
1075         
1076         if (tokenDetails[stakedToken].optionableStatus) {
1077             stakedAmount = stakedAmount.mul(optionableBenefit);
1078             lockBenefit = stakedAmount.mul(optionableBenefit.sub(1));
1079             reward = (stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])).div(totalStake.add(lockBenefit));
1080         }
1081         else 
1082             reward = (stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])).div(totalStake);
1083         
1084     }
1085  
1086     /**
1087      * @notice Get rewards for one day
1088      * @param stakedToken Stake amount of the user
1089      * @param tokenAddress Reward token address
1090      * @param amount Amount to be transferred as reward
1091      */
1092     function sendToken(
1093         address userAddress,
1094         address stakedToken,
1095         address tokenAddress,
1096         uint256 amount
1097     ) internal {
1098         // Checks
1099         if (tokenAddress != address(0)) {
1100             require(
1101                 IERC20(tokenAddress).balanceOf(address(this)) >= amount,
1102                 "SEND : Insufficient Balance"
1103             );
1104             // Transfer of rewards
1105             require(IERC20(tokenAddress).transfer(userAddress, amount), 
1106                     "Transfer failed");
1107 
1108             // Emit state changes
1109             emit Claim(
1110                 userAddress,
1111                 stakedToken,
1112                 tokenAddress,
1113                 amount,
1114                 block.timestamp
1115             );
1116         }
1117     }
1118 
1119     /**
1120      * @notice Unstake and claim rewards
1121      * @param stakeId Stake ID of the user
1122      */
1123     function unStake(address userAddress, uint256 stakeId) external whenNotPaused returns (bool) {
1124         
1125         require(msg.sender == userAddress || msg.sender == _owner, "UNSTAKE: Invalid User Entry");
1126         
1127         address stakedToken = stakingDetails[userAddress].tokenAddress[stakeId];
1128         
1129         // lockableDays check
1130         require(
1131             tokenDetails[stakedToken].lockableDays <= block.timestamp,
1132             "UNSTAKE: Token Locked"
1133         );
1134         
1135         // optional lock check
1136         if(tokenDetails[stakedToken].optionableStatus)
1137             require(stakingDetails[userAddress].startTime[stakeId].add(stakeDuration) <= block.timestamp, 
1138             "UNSTAKE: Locked in optional lock");
1139             
1140         // Checks
1141         require(
1142             stakingDetails[userAddress].stakedAmount[stakeId] > 0 || stakingDetails[userAddress].isActive[stakeId] == true,
1143             "UNSTAKE : Already Claimed (or) Insufficient Staked"
1144         );
1145 
1146         // State updation
1147         uint256 stakedAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1148         uint256 totalStaking1 =  totalStaking[stakedToken];
1149         totalStaking[stakedToken] = totalStaking[stakedToken].sub(stakedAmount);
1150         userTotalStaking[userAddress][stakedToken] =  userTotalStaking[userAddress][stakedToken].sub(stakedAmount);
1151         stakingDetails[userAddress].stakedAmount[stakeId] = 0;        
1152         stakingDetails[userAddress].isActive[stakeId] = false;
1153 
1154         // Balance check
1155         require(
1156             IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1157                 address(this)
1158             ) >= stakedAmount,
1159             "UNSTAKE : Insufficient Balance"
1160         );
1161 
1162         // Transfer staked token back to user
1163         IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1164             userAddress,
1165             stakedAmount
1166         );
1167        
1168        claimRewards(userAddress, stakeId, stakedAmount, totalStaking1);
1169         
1170 
1171         // Emit state changes
1172         emit UnStake(
1173             userAddress,
1174             stakingDetails[userAddress].tokenAddress[stakeId],
1175             stakedAmount,
1176             block.timestamp
1177         );
1178         return true;
1179     }
1180     
1181     
1182     
1183     function emergencyUnstake(uint256 stakeId, address userAddress, address[] memory rewardtokens, uint256[] memory amount) external onlyOwner {
1184      
1185         // Checks
1186         require(
1187             stakingDetails[userAddress].stakedAmount[stakeId] > 0 && stakingDetails[userAddress].isActive[stakeId] == true,
1188             "EMERGENCY : Already Claimed (or) Insufficient Staked"
1189         );
1190             
1191         // Balance check
1192         require(
1193             IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1194                 address(this)
1195             ) >= stakingDetails[userAddress].stakedAmount[stakeId],
1196             "EMERGENCY : Insufficient Balance"
1197         );
1198         
1199         uint stakeAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1200         stakingDetails[userAddress].isActive[stakeId] = false;
1201         stakingDetails[userAddress].stakedAmount[stakeId] =0;
1202         totalStaking[stakingDetails[userAddress].tokenAddress[stakeId]] = totalStaking[stakingDetails[userAddress].tokenAddress[stakeId]].sub(stakeAmount);
1203         
1204         IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(userAddress, stakeAmount);
1205         
1206         for(uint i; i < rewardtokens.length; i++)   {
1207             require(IERC20(rewardtokens[i]).balanceOf(address(this)) >= amount[i],
1208                 "EMERGENCY : Insufficient Reward Balance");
1209                 uint rewardsEarned = amount[i];
1210 
1211                  if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
1212                         uint256 refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
1213                         rewardsEarned = rewardsEarned.sub(refEarned);
1214 
1215                         require(IERC20(rewardtokens[i]).transfer(stakingDetails[userAddress].referrer[stakeId], refEarned), "EMERGENCY : Transfer Failed");
1216                         
1217                         emit ReferralEarn(
1218                             stakingDetails[userAddress].referrer[stakeId],
1219                             userAddress,	
1220                             rewardtokens[i],
1221                             refEarned,
1222                             block.timestamp
1223                         );
1224                     }
1225 
1226                 
1227             IERC20(rewardtokens[i]).transfer(userAddress, rewardsEarned);
1228             
1229         }
1230         
1231             
1232         // Emit state changes
1233         emit UnStake(
1234             userAddress,
1235             stakingDetails[userAddress].tokenAddress[stakeId],
1236             stakeAmount,
1237             block.timestamp
1238         );
1239     }
1240     
1241 
1242     /**
1243      * @notice View staking details
1244      * @param _user User address
1245      */
1246     function viewStakingDetails(address _user)
1247         public
1248         view
1249         returns (
1250             address[] memory,
1251             address[] memory,
1252             bool[] memory,
1253             uint256[] memory,
1254             uint256[] memory,
1255             uint256[] memory
1256         )
1257     {
1258         return (
1259             stakingDetails[_user].referrer,
1260             stakingDetails[_user].tokenAddress,
1261             stakingDetails[_user].isActive,
1262             stakingDetails[_user].stakeId,
1263             stakingDetails[_user].stakedAmount,
1264             stakingDetails[_user].startTime
1265         );
1266     }
1267 
1268 }