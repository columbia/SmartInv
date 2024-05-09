1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-13
3 */
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity >=0.6.0 <=0.8.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/utils/Pausable.sol
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
61     constructor () {
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
121 // File: @openzeppelin/contracts/access/Ownable.sol
122 
123 pragma solidity >=0.6.0 <=0.8.0;
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137  abstract contract Ownable is Pausable {
138     address private _owner;
139 
140     event OwnershipTransferred(
141         address indexed previousOwner,
142         address indexed newOwner
143     );
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor(address ownerAddress) {
149         _owner = ownerAddress;
150         emit OwnershipTransferred(address(0), _owner);
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(_owner == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public onlyOwner {
176         emit OwnershipTransferred(_owner, address(0));
177         _owner = address(0);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Can only be called by the current owner.
183      */
184     function transferOwnership(address newOwner) public virtual onlyOwner {
185         require(
186             newOwner != address(0),
187             "Ownable: new owner is the zero address"
188         );
189         emit OwnershipTransferred(_owner, newOwner);
190         _owner = newOwner;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/math/SafeMath.sol
195 
196 pragma solidity >=0.6.0 <=0.8.0;
197 
198 /**
199  * @dev Wrappers over Solidity's arithmetic operations with added overflow
200  * checks.
201  *
202  * Arithmetic operations in Solidity wrap on overflow. This can easily result
203  * in bugs, because programmers usually assume that an overflow raises an
204  * error, which is the standard behavior in high level programming languages.
205  * `SafeMath` restores this intuition by reverting the transaction when an
206  * operation overflows.
207  *
208  * Using this library instead of the unchecked operations eliminates an entire
209  * class of bugs, so it's recommended to use it always.
210  */
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `+` operator.
217      *
218      * Requirements:
219      *
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         return sub(a, b, "SafeMath: subtraction overflow");
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
245      * overflow (when the result is negative).
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(
254         uint256 a,
255         uint256 b,
256         string memory errorMessage
257     ) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         uint256 c = a - b;
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the multiplication of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `*` operator.
269      *
270      * Requirements:
271      *
272      * - Multiplication cannot overflow.
273      */
274     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
275         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
276         // benefit is lost if 'b' is also tested.
277         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
278         if (a == 0) {
279             return 0;
280         }
281 
282         uint256 c = a * b;
283         require(c / a == b, "SafeMath: multiplication overflow");
284 
285         return c;
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers. Reverts on
290      * division by zero. The result is rounded towards zero.
291      *
292      * Counterpart to Solidity's `/` operator. Note: this function uses a
293      * `revert` opcode (which leaves remaining gas untouched) while Solidity
294      * uses an invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         return div(a, b, "SafeMath: division by zero");
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function div(
317         uint256 a,
318         uint256 b,
319         string memory errorMessage
320     ) internal pure returns (uint256) {
321         require(b > 0, errorMessage);
322         uint256 c = a / b;
323 
324         return c;
325     }
326 
327     /**
328      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
329      * Reverts when dividing by zero.
330      *
331      * Counterpart to Solidity's `%` operator. This function uses a `revert`
332      * opcode (which leaves remaining gas untouched) while Solidity uses an
333      * invalid opcode to revert (consuming all remaining gas).
334      *
335      * Requirements:
336      *
337      * - The divisor cannot be zero.
338      */
339     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
340         return mod(a, b, "SafeMath: modulo by zero");
341     }
342 
343     /**
344      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
345      * Reverts with custom message when dividing by zero.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function mod(
356         uint256 a,
357         uint256 b,
358         string memory errorMessage
359     ) internal pure returns (uint256) {
360         require(b != 0, errorMessage);
361         return a % b;
362     }
363 }
364 
365 // File: \@openzeppelin\contracts\token\ERC20\IERC20.sol
366 
367 pragma solidity >=0.6.0 <=0.8.0;
368 
369 /**
370  * @dev Interface of the ERC20 standard as defined in the EIP.
371  */
372 interface IERC20 {
373     /**
374      * @dev Returns the amount of tokens in existence.
375      */
376     function totalSupply() external view returns (uint256);
377 
378     /**
379      * @dev Returns the amount of tokens owned by `account`.
380      */
381     function balanceOf(address account) external view returns (uint256);
382 
383     /**
384      * @dev Moves `amount` tokens from the caller's account to `recipient`.
385      *
386      * Returns a boolean value indicating whether the operation succeeded.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transfer(address recipient, uint256 amount)
391         external
392         returns (bool);
393 
394     /**
395      * @dev Returns the remaining number of tokens that `spender` will be
396      * allowed to spend on behalf of `owner` through {transferFrom}. This is
397      * zero by default.
398      *
399      * This value changes when {approve} or {transferFrom} are called.
400      */
401     function allowance(address owner, address spender)
402         external
403         view
404         returns (uint256);
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * IMPORTANT: Beware that changing an allowance with this method brings the risk
412      * that someone may use both the old and the new allowance by unfortunate
413      * transaction ordering. One possible solution to mitigate this race
414      * condition is to first reduce the spender's allowance to 0 and set the
415      * desired value afterwards:
416      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
417      *
418      * Emits an {Approval} event.
419      */
420     function approve(address spender, uint256 amount) external returns (bool);
421 
422     /**
423      * @dev Moves `amount` tokens from `sender` to `recipient` using the
424      * allowance mechanism. `amount` is then deducted from the caller's
425      * allowance.
426      *
427      * Returns a boolean value indicating whether the operation succeeded.
428      *
429      * Emits a {Transfer} event.
430      */
431     function transferFrom(
432         address sender,
433         address recipient,
434         uint256 amount
435     ) external returns (bool);
436 
437     /**
438      * @dev Emitted when `value` tokens are moved from one account (`from`) to
439      * another (`to`).
440      *
441      * Note that `value` may be zero.
442      */
443     event Transfer(address indexed from, address indexed to, uint256 value);
444 
445     /**
446      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
447      * a call to {approve}. `value` is the new allowance.
448      */
449     event Approval(
450         address indexed owner,
451         address indexed spender,
452         uint256 value
453     );
454 }
455 
456 // File: contracts/Admin.sol
457 
458 
459 pragma solidity >=0.6.0 <=0.8.0;
460 
461 contract Admin is Ownable {
462     struct tokenInfo {
463         bool isExist;
464         uint8 decimal;
465         uint256 userStakeLimit;
466         uint256 maxStake;
467         uint256 lockableDays;
468         bool optionableStatus;
469     }
470 
471     using SafeMath for uint256;
472     address[] public tokens;
473     mapping(address => address[]) public tokensSequenceList;
474     mapping(address => tokenInfo) public tokenDetails;
475     mapping(address => mapping(address => uint256))
476         public tokenDailyDistribution;
477     mapping(address => mapping(address => bool)) public tokenBlockedStatus;
478     uint256[] public intervalDays = [1, 8, 15, 22, 29, 36];
479     uint256 public stakeDuration = 90 days;
480     uint256 public refPercentage = 5 ether;
481     uint256 public optionableBenefit = 2;
482 
483     event TokenDetails(
484         address indexed tokenAddress,
485         uint256 userStakeimit,
486         uint256 totalStakeLimit,
487         uint256 Time
488     );
489 
490     constructor(address _owner) Ownable(_owner) {}
491 
492     function addToken(
493         address tokenAddress,
494         uint256 userMaxStake,
495         uint256 totalStake,
496         uint8 decimal
497     ) public onlyOwner returns (bool) {
498         if (tokenDetails[tokenAddress].isExist == false)
499             tokens.push(tokenAddress);
500 
501         tokenDetails[tokenAddress].isExist = true;
502         tokenDetails[tokenAddress].decimal = decimal;
503         tokenDetails[tokenAddress].userStakeLimit = userMaxStake;
504         tokenDetails[tokenAddress].maxStake = totalStake;
505 
506         emit TokenDetails(
507             tokenAddress,
508             userMaxStake,
509             totalStake,
510             block.timestamp
511         );
512         return true;
513     }
514 
515     function setDailyDistribution(
516         address[] memory stakedToken,
517         address[] memory rewardToken,
518         uint256[] memory dailyDistribution
519     ) public onlyOwner {
520         require(
521             stakedToken.length == rewardToken.length &&
522                 rewardToken.length == dailyDistribution.length,
523             "Invalid Input"
524         );
525 
526         for (uint8 i = 0; i < stakedToken.length; i++) {
527             require(
528                 tokenDetails[stakedToken[i]].isExist == true &&
529                     tokenDetails[rewardToken[i]].isExist == true,
530                 "Token not exist"
531             );
532             tokenDailyDistribution[stakedToken[i]][
533                 rewardToken[i]
534             ] = dailyDistribution[i];
535         }
536     }
537 
538     function updateSequence(
539         address stakedToken,
540         address[] memory rewardTokenSequence
541     ) public onlyOwner {
542         tokensSequenceList[stakedToken] = new address[](0);
543         require(
544             tokenDetails[stakedToken].isExist == true,
545             "Staked Token Not Exist"
546         );
547         for (uint8 i = 0; i < rewardTokenSequence.length; i++) {
548             require(
549                 rewardTokenSequence.length <= tokens.length,
550                 "Invalid Input"
551             );
552             require(
553                 tokenDetails[rewardTokenSequence[i]].isExist == true,
554                 "Reward Token Not Exist"
555             );
556             tokensSequenceList[stakedToken].push(rewardTokenSequence[i]);
557         }
558     }
559 
560     function updateToken(
561         address tokenAddress,
562         uint256 userMaxStake,
563         uint256 totalStake
564     ) public onlyOwner {
565         require(tokenDetails[tokenAddress].isExist == true, "Token Not Exist");
566         tokenDetails[tokenAddress].userStakeLimit = userMaxStake;
567         tokenDetails[tokenAddress].maxStake = totalStake;
568 
569         emit TokenDetails(
570             tokenAddress,
571             userMaxStake,
572             totalStake,
573             block.timestamp
574         );
575     }
576 
577     function lockableToken(
578         address tokenAddress,
579         uint8 lockableStatus,
580         uint256 lockedDays,
581         bool optionableStatus
582     ) public onlyOwner {
583         require(
584             lockableStatus == 1 || lockableStatus == 2 || lockableStatus == 3,
585             "Invalid Lockable Status"
586         );
587         require(tokenDetails[tokenAddress].isExist == true, "Token Not Exist");
588 
589         if (lockableStatus == 1) {
590             tokenDetails[tokenAddress].lockableDays = block.timestamp.add(
591                 lockedDays
592             );
593         } else if (lockableStatus == 2)
594             tokenDetails[tokenAddress].lockableDays = 0;
595         else if (lockableStatus == 3)
596             tokenDetails[tokenAddress].optionableStatus = optionableStatus;
597     }
598 
599     function updateStakeDuration(uint256 durationTime) public onlyOwner {
600         stakeDuration = durationTime;
601     }
602 
603     function updateOptionableBenefit(uint256 benefit) public onlyOwner {
604         optionableBenefit = benefit;
605     }
606 
607     function updateRefPercentage(uint256 refPer) public onlyOwner {
608         refPercentage = refPer;
609     }
610 
611     function updateIntervalDays(uint256[] memory _interval) public onlyOwner {
612         intervalDays = new uint256[](0);
613 
614         for (uint8 i = 0; i < _interval.length; i++) {
615             uint256 noD = stakeDuration.div(86400);
616             require(noD > _interval[i], "Invalid Interval Day");
617             intervalDays.push(_interval[i]);
618         }
619     }
620 
621     function changeTokenBlockedStatus(
622         address stakedToken,
623         address rewardToken,
624         bool status
625     ) public onlyOwner {
626         require(
627             tokenDetails[stakedToken].isExist == true &&
628                 tokenDetails[rewardToken].isExist == true,
629             "Token not exist"
630         );
631         tokenBlockedStatus[stakedToken][rewardToken] = status;
632         emit TokenDetails(
633             stakedToken,
634             tokenDetails[stakedToken].userStakeLimit,
635             tokenDetails[stakedToken].maxStake,
636             block.timestamp
637         );
638     }
639 
640     function safeWithdraw(address tokenAddress, uint256 amount)
641         public
642         onlyOwner
643     {
644         require(
645             IERC20(tokenAddress).balanceOf(address(this)) >= amount,
646             "Insufficient Balance"
647         );
648         require(
649             IERC20(tokenAddress).transfer(owner(), amount) == true,
650             "Transfer failed");
651     }
652 }
653 
654 // File: contracts/UnifarmV2.sol
655 
656 pragma solidity >=0.6.0 <=0.8.0;
657 
658 /**
659  * @title Unifarm Contract
660  * @author OroPocket
661  */
662 
663 contract UnifarmV2 is Admin {
664     // Wrappers over Solidity's arithmetic operations
665     using SafeMath for uint256;
666 
667     // Stores Stake Details
668     struct stakeInfo {
669         address user;
670         bool[] isActive;
671         address[] referrer;
672         address[] tokenAddress;
673         uint256[] stakeId;
674         uint256[] stakedAmount;
675         uint256[] startTime;
676     }
677 
678     // Mapping
679     mapping(address => stakeInfo) public stakingDetails;
680     mapping(address => mapping(address => uint256)) public userTotalStaking;
681     mapping(address => uint256) public totalStaking;
682     mapping(address => mapping(address => uint256)) public tokenRewardsEarned;
683     uint256 public constant DAYS = 1 days;
684 
685     // Events
686     event Stake(
687         address indexed userAddress,
688         address indexed tokenAddress,
689         uint256 stakedAmount,
690         uint256 Time
691     );
692     event Claim(
693         address indexed userAddress,
694         address indexed stakedTokenAddress,
695         address indexed tokenAddress,
696         uint256 claimRewards,
697         uint256 Time
698     );
699     event UnStake(
700         address indexed userAddress,
701         address indexed unStakedtokenAddress,
702         uint256 unStakedAmount,
703         uint256 Time
704     );
705 
706     constructor(address _owner) Admin(_owner) {}
707 
708     /**
709      * @notice Stake tokens to earn rewards
710      * @param tokenAddress Staking token address
711      * @param amount Amount of tokens to be staked
712      */
713     function stake(
714         address referrerAddress,
715         address tokenAddress,
716         uint256 amount
717     ) external whenNotPaused {
718         // checks
719         require(
720             tokenDetails[tokenAddress].isExist == true,
721             "STAKE : Token is not Exist"
722         );
723         require(
724             userTotalStaking[msg.sender][tokenAddress].add(amount) <=
725                 tokenDetails[tokenAddress].userStakeLimit,
726             "STAKE : Amount should be within permit"
727         );
728         require(
729             totalStaking[tokenAddress].add(amount) <=
730                 tokenDetails[tokenAddress].maxStake,
731             "STAKE : Maxlimit exceeds"
732         );
733 
734         // Storing stake details
735         stakingDetails[msg.sender].stakeId.push(
736             stakingDetails[msg.sender].stakeId.length
737         );
738         stakingDetails[msg.sender].isActive.push(true);
739         stakingDetails[msg.sender].user = msg.sender;
740         stakingDetails[msg.sender].referrer.push(referrerAddress);
741         stakingDetails[msg.sender].tokenAddress.push(tokenAddress);
742         stakingDetails[msg.sender].startTime.push(block.timestamp);
743 
744         // Update total staking amount
745         stakingDetails[msg.sender].stakedAmount.push(amount);
746         totalStaking[tokenAddress] = totalStaking[tokenAddress].add(
747             amount
748         );
749         userTotalStaking[msg.sender][tokenAddress] = userTotalStaking[
750             msg.sender
751         ][tokenAddress]
752             .add(amount);
753 
754         // Transfer tokens from userf to contract
755         require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount) == true,
756                 "Transfer Failed");
757 
758         // Emit state changes
759         emit Stake(msg.sender, tokenAddress, amount, block.timestamp);
760     }
761 
762     /**
763      * @notice Claim accumulated rewards
764      * @param stakeId Stake ID of the user
765      * @param stakedAmount Staked amount of the user
766      */
767     function claimRewards(uint256 stakeId, uint256 stakedAmount) internal {
768         // Local variables
769         uint256 interval;
770 
771         interval = stakingDetails[msg.sender].startTime[stakeId].add(
772             stakeDuration
773         );
774         // Interval calculation
775         if (interval > block.timestamp) {
776             uint256 endOfProfit = block.timestamp;
777             interval = endOfProfit.sub(
778                 stakingDetails[msg.sender].startTime[stakeId]
779             );
780         } else {
781             uint256 endOfProfit =
782                 stakingDetails[msg.sender].startTime[stakeId].add(
783                     stakeDuration
784                 );
785             interval = endOfProfit.sub(
786                 stakingDetails[msg.sender].startTime[stakeId]
787             );
788         }
789 
790         // Reward calculation
791         if (interval >= DAYS)
792             _rewardCalculation(stakeId, stakedAmount, interval);
793     }
794 
795     function _rewardCalculation(
796         uint256 stakeId,
797         uint256 stakedAmount,
798         uint256 interval
799     ) internal {
800         uint256 rewardsEarned;
801         uint256 noOfDays;
802 
803         noOfDays = interval.div(DAYS);
804         rewardsEarned = noOfDays.mul(
805             getOneDayReward(
806                 stakedAmount,
807                 stakingDetails[msg.sender].tokenAddress[stakeId],
808                 stakingDetails[msg.sender].tokenAddress[stakeId]
809             )
810         );
811 
812         // Referrer Earning
813         if (stakingDetails[msg.sender].referrer[stakeId] != address(0)) {
814             uint256 refEarned =
815                 (rewardsEarned.mul(refPercentage)).div(100 ether);
816             rewardsEarned = rewardsEarned.sub(refEarned);
817 
818             require(IERC20(stakingDetails[msg.sender].tokenAddress[stakeId]).transfer(
819                 stakingDetails[msg.sender].referrer[stakeId],
820                 refEarned) == true, "Transfer Failed");
821         }
822 
823         //  Rewards Send
824         sendToken(
825             stakingDetails[msg.sender].tokenAddress[stakeId],
826             stakingDetails[msg.sender].tokenAddress[stakeId],
827             rewardsEarned
828         );
829 
830         uint8 i = 1;
831         while (i < intervalDays.length) {
832             if (noOfDays >= intervalDays[i]) {
833                 uint256 balDays = (noOfDays.sub(intervalDays[i].sub(1)));
834 
835                 address rewardToken =
836                     tokensSequenceList[
837                         stakingDetails[msg.sender].tokenAddress[stakeId]
838                     ][i];
839 
840                 if ( rewardToken != stakingDetails[msg.sender].tokenAddress[stakeId] 
841                         && tokenBlockedStatus[stakingDetails[msg.sender].tokenAddress[stakeId]][rewardToken] ==  false) {
842                     rewardsEarned = balDays.mul(
843                         getOneDayReward(
844                             stakedAmount,
845                             stakingDetails[msg.sender].tokenAddress[stakeId],
846                             rewardToken
847                         )
848                     );
849 
850                     // Referrer Earning
851 
852                     if (
853                         stakingDetails[msg.sender].referrer[stakeId] !=
854                         address(0)
855                     ) {
856                         uint256 refEarned =
857                             (rewardsEarned.mul(refPercentage)).div(100 ether);
858                         rewardsEarned = rewardsEarned.sub(refEarned);
859 
860                         require(IERC20(rewardToken)
861                             .transfer(
862                             stakingDetails[msg.sender].referrer[stakeId],
863                             refEarned) == true, "Transfer Failed");
864                     }
865 
866                     //  Rewards Send
867                     sendToken(
868                         stakingDetails[msg.sender].tokenAddress[stakeId],
869                         rewardToken,
870                         rewardsEarned
871                     );
872                 }
873                 i = i + 1;
874             } else {
875                 break;
876             }
877         }
878     }
879 
880     /**
881      * @notice Get rewards for one day
882      * @param stakedAmount Stake amount of the user
883      * @param stakedToken Staked token address of the user
884      * @param rewardToken Reward token address
885      * @return reward One dayh reward for the user
886      */
887     function getOneDayReward(
888         uint256 stakedAmount,
889         address stakedToken,
890         address rewardToken
891     ) public view returns (uint256 reward) {
892         
893         uint256 lockBenefit;
894         
895         if (tokenDetails[stakedToken].optionableStatus == true) {
896             stakedAmount = stakedAmount.mul(optionableBenefit);
897             lockBenefit = stakedAmount.mul(optionableBenefit.sub(1));
898             reward = (stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])).div(totalStaking[stakedToken].add(lockBenefit));
899         }
900         else 
901             reward = (stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])).div(totalStaking[stakedToken]);
902         
903     }
904  
905     /**
906      * @notice Get rewards for one day
907      * @param stakedToken Stake amount of the user
908      * @param tokenAddress Reward token address
909      * @param amount Amount to be transferred as reward
910      */
911     function sendToken(
912         address stakedToken,
913         address tokenAddress,
914         uint256 amount
915     ) internal {
916         // Checks
917         if (tokenAddress != address(0)) {
918             require(
919                 IERC20(tokenAddress).balanceOf(address(this)) >= amount,
920                 "SEND : Insufficient Balance"
921             );
922             // Transfer of rewards
923             require(IERC20(tokenAddress).transfer(msg.sender, amount) == true, 
924                     "Transfer failed");
925 
926             // Emit state changes
927             emit Claim(
928                 msg.sender,
929                 stakedToken,
930                 tokenAddress,
931                 amount,
932                 block.timestamp
933             );
934         }
935     }
936 
937     /**
938      * @notice Unstake and claim rewards
939      * @param stakeId Stake ID of the user
940      */
941     function unStake(uint256 stakeId) external whenNotPaused returns (bool) {
942         
943         address stakedToken = stakingDetails[msg.sender].tokenAddress[stakeId];
944         
945         // lockableDays check
946         require(
947             tokenDetails[stakedToken].lockableDays <= block.timestamp,
948             "Token Locked"
949         );
950         
951         // optional lock check
952         if(tokenDetails[stakedToken].optionableStatus == true)
953             require(stakingDetails[msg.sender].startTime[stakeId].add(stakeDuration) <= block.timestamp, 
954             "Locked in optional lock");
955             
956         // Checks
957         require(
958             stakingDetails[msg.sender].stakedAmount[stakeId] > 0,
959             "CLAIM : Insufficient Staked Amount"
960         );
961 
962         // State updation
963         uint256 stakedAmount = stakingDetails[msg.sender].stakedAmount[stakeId];
964         stakingDetails[msg.sender].stakedAmount[stakeId] = 0;
965         stakingDetails[msg.sender].isActive[stakeId] = false;
966 
967         // Balance check
968         require(
969             IERC20(stakingDetails[msg.sender].tokenAddress[stakeId]).balanceOf(
970                 address(this)
971             ) >= stakedAmount,
972             "UNSTAKE : Insufficient Balance"
973         );
974 
975         // Transfer staked token back to user
976         IERC20(stakingDetails[msg.sender].tokenAddress[stakeId]).transfer(
977             msg.sender,
978             stakedAmount
979         );
980 
981         // Claim pending rewards
982         claimRewards(stakeId, stakedAmount);
983 
984         // Emit state changes
985         emit UnStake(
986             msg.sender,
987             stakingDetails[msg.sender].tokenAddress[stakeId],
988             stakedAmount,
989             block.timestamp
990         );
991         return true;
992     }
993 
994     /**
995      * @notice View staking details
996      * @param _user User address
997      */
998     function viewStakingDetails(address _user)
999         public
1000         view
1001         returns (
1002             address[] memory,
1003             address[] memory,
1004             bool[] memory,
1005             uint256[] memory,
1006             uint256[] memory,
1007             uint256[] memory
1008         )
1009     {
1010         return (
1011             stakingDetails[_user].referrer,
1012             stakingDetails[_user].tokenAddress,
1013             stakingDetails[_user].isActive,
1014             stakingDetails[_user].stakeId,
1015             stakingDetails[_user].stakedAmount,
1016             stakingDetails[_user].startTime
1017         );
1018     }
1019 
1020     /**
1021      * @notice View accumulated rewards for staked tokens
1022      * @param user Wallet address of th user
1023      * @param stakeId Stake ID of the user
1024      * @param rewardTokenAddress Staked token of the user
1025      * @return availableReward Returns the avilable rewards
1026      */
1027     function viewAvailableRewards(
1028         address user,
1029         uint256 stakeId,
1030         address rewardTokenAddress
1031     ) public view returns (uint256 availableReward) {
1032         // Checks
1033         require(
1034             stakingDetails[user].stakedAmount[stakeId] > 0,
1035             "CLAIM : Insufficient Staked Amount"
1036         );
1037 
1038         // Local variables
1039         uint256 rewardsEarned;
1040         uint256 interval;
1041         uint256 noOfDays;
1042 
1043         noOfDays = stakingDetails[user].startTime[stakeId].add(stakeDuration);
1044         // Interval calculation
1045         if (noOfDays > block.timestamp) {
1046             uint256 endOfProfit = block.timestamp;
1047             interval = endOfProfit.sub(stakingDetails[user].startTime[stakeId]);
1048         } else {
1049             uint256 endOfProfit = noOfDays;
1050             interval = endOfProfit.sub(stakingDetails[user].startTime[stakeId]);
1051         }
1052 
1053         if (interval >= DAYS) {
1054             noOfDays = interval.div(DAYS);
1055             rewardsEarned = noOfDays.mul(
1056                 getOneDayReward(
1057                     stakingDetails[user].stakedAmount[stakeId],
1058                     stakingDetails[user].tokenAddress[stakeId],
1059                     stakingDetails[user].tokenAddress[stakeId]
1060                 )
1061             );
1062 
1063             if (
1064                 rewardTokenAddress == stakingDetails[user].tokenAddress[stakeId]
1065             ) return rewardsEarned;
1066             else
1067                 _viewAvailableRewards(
1068                     user,
1069                     stakeId,
1070                     rewardTokenAddress,
1071                     noOfDays,
1072                     rewardsEarned
1073                 );
1074         }
1075     }
1076 
1077     function _viewAvailableRewards(
1078         address user,
1079         uint256 stakeId,
1080         address rewardTokenAddress,
1081         uint256 dayscount,
1082         uint256 rewards
1083     ) internal view returns (uint256 availableReward) {
1084         // Reward calculation for given reward token address
1085         uint8 i = 1;
1086         while (i < intervalDays.length) {
1087             if (dayscount >= intervalDays[i]) {
1088                 uint256 balDays = (dayscount.sub(intervalDays[i].sub(1)));
1089 
1090                 address rewardToken =
1091                     tokensSequenceList[
1092                         stakingDetails[user].tokenAddress[stakeId]
1093                     ][i];
1094 
1095                 if (
1096                     rewardToken != stakingDetails[user].tokenAddress[stakeId] &&
1097                     tokenBlockedStatus[
1098                         stakingDetails[user].tokenAddress[stakeId]
1099                     ][rewardToken] ==
1100                     false
1101                 ) {
1102                     if (rewardToken == rewardTokenAddress) {
1103                         rewards = balDays.mul(
1104                             getOneDayReward(
1105                                 stakingDetails[user].stakedAmount[stakeId],
1106                                 stakingDetails[user].tokenAddress[stakeId],
1107                                 rewardToken
1108                             )
1109                         );
1110                         return (rewards);
1111                     }
1112                 }
1113                 i = i + 1;
1114             } else {
1115                 break;
1116             }
1117         }
1118     }
1119 }