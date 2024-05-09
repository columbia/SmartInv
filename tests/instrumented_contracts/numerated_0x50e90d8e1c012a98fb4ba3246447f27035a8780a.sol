1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
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
476     mapping(address => address[]) public tokensSequenceList;
477     mapping(address => tokenInfo) public tokenDetails;
478     mapping(address => mapping(address => uint256))
479         public tokenDailyDistribution;
480     mapping(address => mapping(address => bool)) public tokenBlockedStatus;
481     uint256[] public intervalDays = [1, 8, 15, 22, 29, 36, 43, 50];
482     uint256 public constant DAYS = 1 days;
483     uint256 public constant HOURS = 1 hours;
484     uint256 public stakeDuration;
485     uint256 public refPercentage;
486     uint256 public optionableBenefit;
487 
488     event TokenDetails(
489         address indexed tokenAddress,
490         uint256 userMinStake,
491         uint256 userMaxStake,
492         uint256 totalMaxStake,
493         uint256 updatedTime
494     );
495 
496     event LockableTokenDetails(
497         address indexed tokenAddress,
498         uint256 lockableDys,
499         bool optionalbleStatus,
500         uint256 updatedTime
501     );
502 
503     event DailyDistributionDetails(
504         address indexed stakedTokenAddress,
505         address indexed rewardTokenAddress,
506         uint256 rewards,
507         uint256 time
508     );
509 
510     event SequenceDetails(
511         address indexed stakedTokenAddress,
512         address[] rewardTokenSequence,
513         uint256 time
514     );
515 
516     event StakeDurationDetails(uint256 updatedDuration, uint256 time);
517 
518     event OptionableBenefitDetails(uint256 updatedBenefit, uint256 time);
519 
520     event ReferrerPercentageDetails(uint256 updatedRefPercentage, uint256 time);
521 
522     event IntervalDaysDetails(uint256[] updatedIntervals, uint256 time);
523 
524     event BlockedDetails(
525         address indexed stakedTokenAddress,
526         address indexed rewardTokenAddress,
527         bool blockedStatus,
528         uint256 time
529     );
530 
531     event WithdrawDetails(
532         address indexed tokenAddress,
533         uint256 withdrawalAmount,
534         uint256 time
535     );
536 
537     constructor(address _owner) Ownable(_owner) {
538         stakeDuration = 90 days;
539         refPercentage = 2500000000000000000;
540         optionableBenefit = 2;
541     }
542 
543     function addToken(
544         address tokenAddress,
545         uint256 userMinStake,
546         uint256 userMaxStake,
547         uint256 totalStake,
548         uint8 decimal
549     ) public onlyOwner returns (bool) {
550         if (!(tokenDetails[tokenAddress].isExist)) tokens.push(tokenAddress);
551 
552         tokenDetails[tokenAddress].isExist = true;
553         tokenDetails[tokenAddress].decimal = decimal;
554         tokenDetails[tokenAddress].userMinStake = userMinStake;
555         tokenDetails[tokenAddress].userMaxStake = userMaxStake;
556         tokenDetails[tokenAddress].totalMaxStake = totalStake;
557 
558         emit TokenDetails(
559             tokenAddress,
560             userMinStake,
561             userMaxStake,
562             totalStake,
563             block.timestamp
564         );
565         return true;
566     }
567 
568     function setDailyDistribution(
569         address[] memory stakedToken,
570         address[] memory rewardToken,
571         uint256[] memory dailyDistribution
572     ) public onlyOwner {
573         require(
574             stakedToken.length == rewardToken.length &&
575                 rewardToken.length == dailyDistribution.length,
576             "Invalid Input"
577         );
578 
579         for (uint8 i = 0; i < stakedToken.length; i++) {
580             require(
581                 tokenDetails[stakedToken[i]].isExist &&
582                     tokenDetails[rewardToken[i]].isExist,
583                 "Token not exist"
584             );
585             tokenDailyDistribution[stakedToken[i]][
586                 rewardToken[i]
587             ] = dailyDistribution[i];
588 
589             emit DailyDistributionDetails(
590                 stakedToken[i],
591                 rewardToken[i],
592                 dailyDistribution[i],
593                 block.timestamp
594             );
595         }
596     }
597 
598     function updateSequence(
599         address stakedToken,
600         address[] memory rewardTokenSequence
601     ) public onlyOwner {
602         tokensSequenceList[stakedToken] = new address[](0);
603         require(tokenDetails[stakedToken].isExist, "Staked Token Not Exist");
604         for (uint8 i = 0; i < rewardTokenSequence.length; i++) {
605             require(
606                 rewardTokenSequence.length <= tokens.length,
607                 "Invalid Input"
608             );
609             require(
610                 tokenDetails[rewardTokenSequence[i]].isExist,
611                 "Reward Token Not Exist"
612             );
613             tokensSequenceList[stakedToken].push(rewardTokenSequence[i]);
614         }
615 
616         emit SequenceDetails(
617             stakedToken,
618             tokensSequenceList[stakedToken],
619             block.timestamp
620         );
621     }
622 
623     function updateToken(
624         address tokenAddress,
625         uint256 userMinStake,
626         uint256 userMaxStake,
627         uint256 totalStake
628     ) public onlyOwner {
629         require(tokenDetails[tokenAddress].isExist, "Token Not Exist");
630         tokenDetails[tokenAddress].userMinStake = userMinStake;
631         tokenDetails[tokenAddress].userMaxStake = userMaxStake;
632         tokenDetails[tokenAddress].totalMaxStake = totalStake;
633 
634         emit TokenDetails(
635             tokenAddress,
636             userMinStake,
637             userMaxStake,
638             totalStake,
639             block.timestamp
640         );
641     }
642 
643     function lockableToken(
644         address tokenAddress,
645         uint8 lockableStatus,
646         uint256 lockedDays,
647         bool optionableStatus
648     ) public onlyOwner {
649         require(
650             lockableStatus == 1 || lockableStatus == 2 || lockableStatus == 3,
651             "Invalid Lockable Status"
652         );
653         require(tokenDetails[tokenAddress].isExist == true, "Token Not Exist");
654 
655         if (lockableStatus == 1) {
656             tokenDetails[tokenAddress].lockableDays = block.timestamp.add(
657                 lockedDays
658             );
659         } else if (lockableStatus == 2)
660             tokenDetails[tokenAddress].lockableDays = 0;
661         else if (lockableStatus == 3)
662             tokenDetails[tokenAddress].optionableStatus = optionableStatus;
663 
664         emit LockableTokenDetails(
665             tokenAddress,
666             tokenDetails[tokenAddress].lockableDays,
667             tokenDetails[tokenAddress].optionableStatus,
668             block.timestamp
669         );
670     }
671 
672     function updateStakeDuration(uint256 durationTime) public onlyOwner {
673         stakeDuration = durationTime;
674 
675         emit StakeDurationDetails(stakeDuration, block.timestamp);
676     }
677 
678     function updateOptionableBenefit(uint256 benefit) public onlyOwner {
679         optionableBenefit = benefit;
680 
681         emit OptionableBenefitDetails(optionableBenefit, block.timestamp);
682     }
683 
684     function updateRefPercentage(uint256 refPer) public onlyOwner {
685         refPercentage = refPer;
686 
687         emit ReferrerPercentageDetails(refPercentage, block.timestamp);
688     }
689 
690     function updateIntervalDays(uint256[] memory _interval) public onlyOwner {
691         intervalDays = new uint256[](0);
692 
693         for (uint8 i = 0; i < _interval.length; i++) {
694             uint256 noD = stakeDuration.div(DAYS);
695             require(noD > _interval[i], "Invalid Interval Day");
696             intervalDays.push(_interval[i]);
697         }
698 
699         emit IntervalDaysDetails(intervalDays, block.timestamp);
700     }
701 
702     function changeTokenBlockedStatus(
703         address stakedToken,
704         address rewardToken,
705         bool status
706     ) public onlyOwner {
707         require(
708             tokenDetails[stakedToken].isExist &&
709                 tokenDetails[rewardToken].isExist,
710             "Token not exist"
711         );
712         tokenBlockedStatus[stakedToken][rewardToken] = status;
713 
714         emit BlockedDetails(
715             stakedToken,
716             rewardToken,
717             tokenBlockedStatus[stakedToken][rewardToken],
718             block.timestamp
719         );
720     }
721 
722     function safeWithdraw(address tokenAddress, uint256 amount)
723         public
724         onlyOwner
725     {
726         require(
727             IERC20(tokenAddress).balanceOf(address(this)) >= amount,
728             "Insufficient Balance"
729         );
730         require(
731             IERC20(tokenAddress).transfer(_owner, amount),
732             "Transfer failed"
733         );
734 
735         emit WithdrawDetails(tokenAddress, amount, block.timestamp);
736     }
737 
738     function viewTokensCount() external view returns (uint256) {
739         return tokens.length;
740     }
741 }
742 
743 
744 // File contracts/UnifarmV8.sol
745 
746 
747 pragma solidity ^0.7.0;
748 
749 /**
750  * @title Unifarm Contract
751  * @author OroPocket
752  */
753 
754 contract UnifarmV8 is Admin {
755     // Wrappers over Solidity's arithmetic operations
756     using SafeMath for uint256;
757 
758     // Stores Stake Details
759     struct stakeInfo {
760         address user;
761         bool[] isActive;
762         address[] referrer;
763         address[] tokenAddress;
764         uint256[] stakeId;
765         uint256[] stakedAmount;
766         uint256[] startTime;
767     }
768 
769     // Mapping
770     mapping(address => stakeInfo) public stakingDetails;
771     mapping(address => mapping(address => uint256)) public userTotalStaking;
772     mapping(address => uint256) public totalStaking;
773     uint256 public poolStartTime;
774 
775     // Events
776     event Stake(
777         address indexed userAddress,
778         uint256 stakeId,
779         address indexed referrerAddress,
780         address indexed tokenAddress,
781         uint256 stakedAmount,
782         uint256 time
783     );
784 
785     event Claim(
786         address indexed userAddress,
787         address indexed stakedTokenAddress,
788         address indexed tokenAddress,
789         uint256 claimRewards,
790         uint256 time
791     );
792 
793     event UnStake(
794         address indexed userAddress,
795         address indexed unStakedtokenAddress,
796         uint256 unStakedAmount,
797         uint256 time,
798         uint256 stakeId
799     );
800 
801     event ReferralEarn(
802         address indexed userAddress,
803         address indexed callerAddress,
804         address indexed rewardTokenAddress,
805         uint256 rewardAmount,
806         uint256 time
807     );
808 
809     constructor() Admin(msg.sender) {
810         poolStartTime = block.timestamp;
811     }
812 
813     /**
814      * @notice Stake tokens to earn rewards
815      * @param tokenAddress Staking token address
816      * @param amount Amount of tokens to be staked
817      */
818 
819     function stake(
820         address referrerAddress,
821         address tokenAddress,
822         uint256 amount
823     ) external whenNotPaused {
824         // checks
825         require(
826             msg.sender != referrerAddress,
827             "STAKE: invalid referrer address"
828         );
829         require(
830             tokenDetails[tokenAddress].isExist,
831             "STAKE : Token is not Exist"
832         );
833         require(
834             userTotalStaking[msg.sender][tokenAddress].add(amount) >=
835                 tokenDetails[tokenAddress].userMinStake,
836             "STAKE : Min Amount should be within permit"
837         );
838         require(
839             userTotalStaking[msg.sender][tokenAddress].add(amount) <=
840                 tokenDetails[tokenAddress].userMaxStake,
841             "STAKE : Max Amount should be within permit"
842         );
843         require(
844             totalStaking[tokenAddress].add(amount) <=
845                 tokenDetails[tokenAddress].totalMaxStake,
846             "STAKE : Maxlimit exceeds"
847         );
848 
849         require(
850             poolStartTime.add(stakeDuration) > block.timestamp,
851             "STAKE: Staking Time Completed"
852         );
853 
854         // Storing stake details
855         stakingDetails[msg.sender].stakeId.push(
856             stakingDetails[msg.sender].stakeId.length
857         );
858         stakingDetails[msg.sender].isActive.push(true);
859         stakingDetails[msg.sender].user = msg.sender;
860         stakingDetails[msg.sender].referrer.push(referrerAddress);
861         stakingDetails[msg.sender].tokenAddress.push(tokenAddress);
862         stakingDetails[msg.sender].startTime.push(block.timestamp);
863 
864         // Update total staking amount
865         stakingDetails[msg.sender].stakedAmount.push(amount);
866         totalStaking[tokenAddress] = totalStaking[tokenAddress].add(amount);
867         userTotalStaking[msg.sender][tokenAddress] = userTotalStaking[
868             msg.sender
869         ][tokenAddress]
870             .add(amount);
871 
872         // Transfer tokens from userf to contract
873         require(
874             IERC20(tokenAddress).transferFrom(
875                 msg.sender,
876                 address(this),
877                 amount
878             ),
879             "Transfer Failed"
880         );
881 
882         // Emit state changes
883         emit Stake(
884             msg.sender,
885             (stakingDetails[msg.sender].stakeId.length.sub(1)),
886             referrerAddress,
887             tokenAddress,
888             amount,
889             block.timestamp
890         );
891     }
892 
893     /**
894      * @notice Claim accumulated rewards
895      * @param stakeId Stake ID of the user
896      * @param stakedAmount Staked amount of the user
897      */
898 
899     function claimRewards(
900         address userAddress,
901         uint256 stakeId,
902         uint256 stakedAmount,
903         uint256 totalStake
904     ) internal {
905         // Local variables
906         uint256 interval;
907         uint256 endOfProfit;
908 
909         interval = poolStartTime.add(stakeDuration);
910 
911         // Interval calculation
912         if (interval > block.timestamp) endOfProfit = block.timestamp;
913         else endOfProfit = poolStartTime.add(stakeDuration);
914 
915         interval = endOfProfit.sub(
916             stakingDetails[userAddress].startTime[stakeId]
917         );
918         uint256[2] memory stakeData;
919         stakeData[0] = (stakedAmount);
920         stakeData[1] = (totalStake);
921 
922         // Reward calculation
923         if (interval >= HOURS)
924             _rewardCalculation(userAddress, stakeId, stakeData, interval);
925     }
926 
927     function _rewardCalculation(
928         address userAddress,
929         uint256 stakeId,
930         uint256[2] memory stakingData,
931         uint256 interval
932     ) internal {
933         uint256 rewardsEarned;
934         uint256 refEarned;
935         uint256[2] memory noOfDays;
936 
937         noOfDays[1] = interval.div(HOURS);
938         noOfDays[0] = interval.div(DAYS);
939 
940         rewardsEarned = noOfDays[1].mul(
941             getOneDayReward(
942                 stakingData[0],
943                 stakingDetails[userAddress].tokenAddress[stakeId],
944                 stakingDetails[userAddress].tokenAddress[stakeId],
945                 stakingData[1]
946             )
947         );
948 
949         // Referrer Earning
950         if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
951             refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
952             rewardsEarned = rewardsEarned.sub(refEarned);
953 
954             require(
955                 IERC20(stakingDetails[userAddress].tokenAddress[stakeId])
956                     .transfer(
957                     stakingDetails[userAddress].referrer[stakeId],
958                     refEarned
959                 ) == true,
960                 "Transfer Failed"
961             );
962 
963             emit ReferralEarn(
964                 stakingDetails[userAddress].referrer[stakeId],
965                 msg.sender,
966                 stakingDetails[userAddress].tokenAddress[stakeId],
967                 refEarned,
968                 block.timestamp
969             );
970         }
971 
972         //  Rewards Send
973         sendToken(
974             userAddress,
975             stakingDetails[userAddress].tokenAddress[stakeId],
976             stakingDetails[userAddress].tokenAddress[stakeId],
977             rewardsEarned
978         );
979 
980         uint8 i = 1;
981 
982         while (i < intervalDays.length) {
983             if (noOfDays[0] >= intervalDays[i]) {
984                 uint256 reductionHours = (intervalDays[i].sub(1)).mul(24);
985                 uint256 balHours = noOfDays[1].sub(reductionHours);
986 
987                 address rewardToken =
988                     tokensSequenceList[
989                         stakingDetails[userAddress].tokenAddress[stakeId]
990                     ][i];
991 
992                 if (
993                     rewardToken !=
994                     stakingDetails[userAddress].tokenAddress[stakeId] &&
995                     tokenBlockedStatus[
996                         stakingDetails[userAddress].tokenAddress[stakeId]
997                     ][rewardToken] ==
998                     false
999                 ) {
1000                     rewardsEarned = balHours.mul(
1001                         getOneDayReward(
1002                             stakingData[0],
1003                             stakingDetails[userAddress].tokenAddress[stakeId],
1004                             rewardToken,
1005                             stakingData[1]
1006                         )
1007                     );
1008 
1009                     // Referrer Earning
1010 
1011                     if (
1012                         stakingDetails[userAddress].referrer[stakeId] !=
1013                         address(0)
1014                     ) {
1015                         refEarned = (rewardsEarned.mul(refPercentage)).div(
1016                             100 ether
1017                         );
1018                         rewardsEarned = rewardsEarned.sub(refEarned);
1019 
1020                         require(
1021                             IERC20(rewardToken).transfer(
1022                                 stakingDetails[userAddress].referrer[stakeId],
1023                                 refEarned
1024                             ) == true,
1025                             "Transfer Failed"
1026                         );
1027 
1028                         emit ReferralEarn(
1029                             stakingDetails[userAddress].referrer[stakeId],
1030                             msg.sender,
1031                             stakingDetails[userAddress].tokenAddress[stakeId],
1032                             refEarned,
1033                             block.timestamp
1034                         );
1035                     }
1036 
1037                     //  Rewards Send
1038                     sendToken(
1039                         userAddress,
1040                         stakingDetails[userAddress].tokenAddress[stakeId],
1041                         rewardToken,
1042                         rewardsEarned
1043                     );
1044                 }
1045                 i = i + 1;
1046             } else {
1047                 break;
1048             }
1049         }
1050     }
1051 
1052     /**
1053      * @notice Get rewards for one day
1054      * @param stakedAmount Stake amount of the user
1055      * @param stakedToken Staked token address of the user
1056      * @param rewardToken Reward token address
1057      * @return reward One dayh reward for the user
1058      */
1059 
1060     function getOneDayReward(
1061         uint256 stakedAmount,
1062         address stakedToken,
1063         address rewardToken,
1064         uint256 totalStake
1065     ) public view returns (uint256 reward) {
1066         uint256 lockBenefit;
1067 
1068         if (tokenDetails[stakedToken].optionableStatus) {
1069             stakedAmount = stakedAmount.mul(optionableBenefit);
1070             lockBenefit = stakedAmount.mul(optionableBenefit.sub(1));
1071             reward = (
1072                 stakedAmount.mul(
1073                     tokenDailyDistribution[stakedToken][rewardToken]
1074                 )
1075             )
1076                 .div(totalStake.add(lockBenefit));
1077         } else
1078             reward = (
1079                 stakedAmount.mul(
1080                     tokenDailyDistribution[stakedToken][rewardToken]
1081                 )
1082             )
1083                 .div(totalStake);
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
1105             require(
1106                 IERC20(tokenAddress).transfer(userAddress, amount),
1107                 "Transfer failed"
1108             );
1109 
1110             // Emit state changes
1111             emit Claim(
1112                 userAddress,
1113                 stakedToken,
1114                 tokenAddress,
1115                 amount,
1116                 block.timestamp
1117             );
1118         }
1119     }
1120 
1121     /**
1122      * @notice Unstake and claim rewards
1123      * @param stakeId Stake ID of the user
1124      */
1125     function unStake(address userAddress, uint256 stakeId)
1126         external
1127         whenNotPaused
1128         returns (bool)
1129     {
1130         require(
1131             msg.sender == userAddress || msg.sender == _owner,
1132             "UNSTAKE: Invalid User Entry"
1133         );
1134 
1135         address stakedToken = stakingDetails[userAddress].tokenAddress[stakeId];
1136 
1137         // lockableDays check
1138         require(
1139             tokenDetails[stakedToken].lockableDays <= block.timestamp,
1140             "UNSTAKE: Token Locked"
1141         );
1142 
1143         // optional lock check
1144         if (tokenDetails[stakedToken].optionableStatus)
1145             require(
1146                 stakingDetails[userAddress].startTime[stakeId].add(
1147                     stakeDuration
1148                 ) <= block.timestamp,
1149                 "UNSTAKE: Locked in optional lock"
1150             );
1151 
1152         // Checks
1153         require(
1154             stakingDetails[userAddress].stakedAmount[stakeId] > 0 ||
1155                 stakingDetails[userAddress].isActive[stakeId] == true,
1156             "UNSTAKE : Already Claimed (or) Insufficient Staked"
1157         );
1158 
1159         // State updation
1160         uint256 stakedAmount =
1161             stakingDetails[userAddress].stakedAmount[stakeId];
1162         uint256 totalStaking1 = totalStaking[stakedToken];
1163         totalStaking[stakedToken] = totalStaking[stakedToken].sub(stakedAmount);
1164         userTotalStaking[userAddress][stakedToken] = userTotalStaking[
1165             userAddress
1166         ][stakedToken]
1167             .sub(stakedAmount);
1168         stakingDetails[userAddress].stakedAmount[stakeId] = 0;
1169         stakingDetails[userAddress].isActive[stakeId] = false;
1170 
1171         // Balance check
1172         require(
1173             IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1174                 address(this)
1175             ) >= stakedAmount,
1176             "UNSTAKE : Insufficient Balance"
1177         );
1178 
1179         // Transfer staked token back to user
1180         IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1181             userAddress,
1182             stakedAmount
1183         );
1184 
1185         claimRewards(userAddress, stakeId, stakedAmount, totalStaking1);
1186 
1187         // Emit state changes
1188         emit UnStake(
1189             userAddress,
1190             stakingDetails[userAddress].tokenAddress[stakeId],
1191             stakedAmount,
1192             block.timestamp,
1193             stakeId
1194         );
1195 
1196         return true;
1197     }
1198 
1199     function emergencyUnstake(
1200         uint256 stakeId,
1201         address userAddress,
1202         address[] memory rewardtokens,
1203         uint256[] memory amount
1204     ) external onlyOwner {
1205         // Checks
1206         require(
1207             stakingDetails[userAddress].stakedAmount[stakeId] > 0 &&
1208                 stakingDetails[userAddress].isActive[stakeId] == true,
1209             "EMERGENCY : Already Claimed (or) Insufficient Staked"
1210         );
1211 
1212         // Balance check
1213         require(
1214             IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).balanceOf(
1215                 address(this)
1216             ) >= stakingDetails[userAddress].stakedAmount[stakeId],
1217             "EMERGENCY : Insufficient Balance"
1218         );
1219 
1220         uint256 stakeAmount = stakingDetails[userAddress].stakedAmount[stakeId];
1221         stakingDetails[userAddress].isActive[stakeId] = false;
1222         stakingDetails[userAddress].stakedAmount[stakeId] = 0;
1223         totalStaking[
1224             stakingDetails[userAddress].tokenAddress[stakeId]
1225         ] = totalStaking[stakingDetails[userAddress].tokenAddress[stakeId]].sub(
1226             stakeAmount
1227         );
1228 
1229         IERC20(stakingDetails[userAddress].tokenAddress[stakeId]).transfer(
1230             userAddress,
1231             stakeAmount
1232         );
1233 
1234         for (uint256 i; i < rewardtokens.length; i++) {
1235             require(
1236                 IERC20(rewardtokens[i]).balanceOf(address(this)) >= amount[i],
1237                 "EMERGENCY : Insufficient Reward Balance"
1238             );
1239             uint256 rewardsEarned = amount[i];
1240 
1241             if (stakingDetails[userAddress].referrer[stakeId] != address(0)) {
1242                 uint256 refEarned =
1243                     (rewardsEarned.mul(refPercentage)).div(100 ether);
1244                 rewardsEarned = rewardsEarned.sub(refEarned);
1245 
1246                 require(
1247                     IERC20(rewardtokens[i]).transfer(
1248                         stakingDetails[userAddress].referrer[stakeId],
1249                         refEarned
1250                     ),
1251                     "EMERGENCY : Transfer Failed"
1252                 );
1253 
1254                 emit ReferralEarn(
1255                     stakingDetails[userAddress].referrer[stakeId],
1256                     userAddress,
1257                     rewardtokens[i],
1258                     refEarned,
1259                     block.timestamp
1260                 );
1261             }
1262 
1263             IERC20(rewardtokens[i]).transfer(userAddress, rewardsEarned);
1264         }
1265 
1266         // Emit state changes
1267         emit UnStake(
1268             userAddress,
1269             stakingDetails[userAddress].tokenAddress[stakeId],
1270             stakeAmount,
1271             block.timestamp,
1272             stakeId
1273         );
1274     }
1275 
1276     /**
1277      * @notice View staking details
1278      * @param _user User address
1279      */
1280     function viewStakingDetails(address _user)
1281         public
1282         view
1283         returns (
1284             address[] memory,
1285             address[] memory,
1286             bool[] memory,
1287             uint256[] memory,
1288             uint256[] memory,
1289             uint256[] memory
1290         )
1291     {
1292         return (
1293             stakingDetails[_user].referrer,
1294             stakingDetails[_user].tokenAddress,
1295             stakingDetails[_user].isActive,
1296             stakingDetails[_user].stakeId,
1297             stakingDetails[_user].stakedAmount,
1298             stakingDetails[_user].startTime
1299         );
1300     }
1301 }