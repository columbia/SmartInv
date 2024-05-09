1 // File: contracts/abstract/Context.sol
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 // SPDX-License-Identifier: MIT
5 pragma solidity ^0.7.0;
6 
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: contracts/abstract/Pausable.sol
30 
31 // File: @openzeppelin/contracts/utils/Pausable.sol
32 
33 pragma solidity ^0.7.0;
34 
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
47 
48      bool private _paused;
49 
50     /**
51      * @dev Emitted when the pause is triggered by `account`.
52      */
53     event Paused(address account);
54 
55     /**
56      * @dev Emitted when the pause is lifted by `account`.
57      */
58     event Unpaused(address account);   
59 
60     /**
61      * @dev Initializes the contract in unpaused state.
62      */
63     constructor ()  {
64         _paused = false;
65     }
66 
67     /**
68      * @dev Returns true if the contract is paused, and false otherwise.
69      */
70     function paused() public view virtual returns (bool) {
71         return _paused;
72     }
73 
74     /**
75      * @dev Modifier to make a function callable only when the contract is not paused.
76      *
77      * Requirements:
78      *
79      * - The contract must not be paused.
80      */
81     modifier whenNotPaused() {
82         require(!paused(), "Pausable: paused");
83         _;
84     }
85 
86     /**
87      * @dev Modifier to make a function callable only when the contract is paused.
88      *
89      * Requirements:
90      *
91      * - The contract must be paused.
92      */
93     modifier whenPaused() {
94         require(paused(), "Pausable: not paused");
95         _;
96     }
97 
98     /**
99      * @dev Triggers stopped state.
100      *
101      * Requirements:
102      *
103      * - The contract must not be paused.
104      */
105     function _pause() internal virtual whenNotPaused {
106         _paused = true;
107         emit Paused(_msgSender());
108     }
109 
110     /**
111      * @dev Returns to normal state.
112      *
113      * Requirements:
114      *
115      * - The contract must be paused.
116      */
117     function _unpause() internal virtual whenPaused {
118         _paused = false;
119         emit Unpaused(_msgSender());
120     }
121 }
122 
123 // File: contracts/abstract/Ownable.sol
124 
125 // File: @openzeppelin/contracts/access/Ownable.sol
126 
127 pragma solidity ^0.7.0;
128 
129 
130 /**
131  * @dev Contract module which provides a basic access control mechanism, where
132  * there is an account (an owner) that can be granted exclusive access to
133  * specific functions.
134  *
135  * By default, the owner account will be the one that deploys the contract. This
136  * can later be changed with {transferOwnership}.
137  *
138  * This module is used through inheritance. It will make available the modifier
139  * `onlyOwner`, which can be applied to your functions to restrict their use to
140  * the owner.
141  */
142  abstract contract Ownable is Pausable {
143     address private _owner;
144 
145     event OwnershipTransferred(
146         address indexed previousOwner,
147         address indexed newOwner
148     );
149 
150     /**
151      * @dev Initializes the contract setting the deployer as the initial owner.
152      */
153     constructor(address ownerAddress)  {
154         _owner = ownerAddress;
155         emit OwnershipTransferred(address(0), _owner);
156     }
157 
158     /**
159      * @dev Returns the address of the current owner.
160      */
161     function owner() public view returns (address) {
162         return _owner;
163     }
164 
165     /**
166      * @dev Throws if called by any account other than the owner.
167      */
168     modifier onlyOwner() {
169         require(_owner == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     /**
174      * @dev Leaves the contract without owner. It will not be possible to call
175      * `onlyOwner` functions anymore. Can only be called by the current owner.
176      *
177      * NOTE: Renouncing ownership will leave the contract without an owner,
178      * thereby removing any functionality that is only available to the owner.
179      */
180     function renounceOwnership() external onlyOwner {
181         emit OwnershipTransferred(_owner, address(0));
182         _owner = address(0);
183     }
184 
185     /**
186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
187      * Can only be called by the current owner.
188      */
189     function transferOwnership(address newOwner) external virtual onlyOwner {
190         require(
191             newOwner != address(0),
192             "Ownable: new owner is the zero address"
193         );
194         emit OwnershipTransferred(_owner, newOwner);
195         _owner = newOwner;
196     }
197 }
198 
199 // File: contracts/library/SafeMath.sol
200 
201 // File: @openzeppelin/contracts/math/SafeMath.sol
202 
203 pragma solidity ^0.7.0;
204 
205 
206 /**
207  * @dev Wrappers over Solidity's arithmetic operations with added overflow
208  * checks.
209  *
210  * Arithmetic operations in Solidity wrap on overflow. This can easily result
211  * in bugs, because programmers usually assume that an overflow raises an
212  * error, which is the standard behavior in high level programming languages.
213  * `SafeMath` restores this intuition by reverting the transaction when an
214  * operation overflows.
215  *
216  * Using this library instead of the unchecked operations eliminates an entire
217  * class of bugs, so it's recommended to use it always.
218  */
219 library SafeMath {
220     /**
221      * @dev Returns the addition of two unsigned integers, reverting on
222      * overflow.
223      *
224      * Counterpart to Solidity's `+` operator.
225      *
226      * Requirements:
227      *
228      * - Addition cannot overflow.
229      */
230     function add(uint256 a, uint256 b) internal pure returns (uint256) {
231         uint256 c = a + b;
232         require(c >= a, "SafeMath: addition overflow");
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the subtraction of two unsigned integers, reverting on
239      * overflow (when the result is negative).
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      *
245      * - Subtraction cannot overflow.
246      */
247     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248         return sub(a, b, "SafeMath: subtraction overflow");
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
253      * overflow (when the result is negative).
254      *
255      * Counterpart to Solidity's `-` operator.
256      *
257      * Requirements:
258      *
259      * - Subtraction cannot overflow.
260      */
261     function sub(
262         uint256 a,
263         uint256 b,
264         string memory errorMessage
265     ) internal pure returns (uint256) {
266         require(b <= a, errorMessage);
267         uint256 c = a - b;
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the multiplication of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `*` operator.
277      *
278      * Requirements:
279      *
280      * - Multiplication cannot overflow.
281      */
282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
284         // benefit is lost if 'b' is also tested.
285         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
286         if (a == 0) {
287             return 0;
288         }
289 
290         uint256 c = a * b;
291         require(c / a == b, "SafeMath: multiplication overflow");
292 
293         return c;
294     }
295 
296     /**
297      * @dev Returns the integer division of two unsigned integers. Reverts on
298      * division by zero. The result is rounded towards zero.
299      *
300      * Counterpart to Solidity's `/` operator. Note: this function uses a
301      * `revert` opcode (which leaves remaining gas untouched) while Solidity
302      * uses an invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b) internal pure returns (uint256) {
309         return div(a, b, "SafeMath: division by zero");
310     }
311 
312     /**
313      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
314      * division by zero. The result is rounded towards zero.
315      *
316      * Counterpart to Solidity's `/` operator. Note: this function uses a
317      * `revert` opcode (which leaves remaining gas untouched) while Solidity
318      * uses an invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(
325         uint256 a,
326         uint256 b,
327         string memory errorMessage
328     ) internal pure returns (uint256) {
329         require(b > 0, errorMessage);
330         uint256 c = a / b;
331 
332         return c;
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
337      * Reverts when dividing by zero.
338      *
339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
340      * opcode (which leaves remaining gas untouched) while Solidity uses an
341      * invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      *
345      * - The divisor cannot be zero.
346      */
347     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
348         return mod(a, b, "SafeMath: modulo by zero");
349     }
350 
351     /**
352      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
353      * Reverts with custom message when dividing by zero.
354      *
355      * Counterpart to Solidity's `%` operator. This function uses a `revert`
356      * opcode (which leaves remaining gas untouched) while Solidity uses an
357      * invalid opcode to revert (consuming all remaining gas).
358      *
359      * Requirements:
360      *
361      * - The divisor cannot be zero.
362      */
363     function mod(
364         uint256 a,
365         uint256 b,
366         string memory errorMessage
367     ) internal pure returns (uint256) {
368         require(b != 0, errorMessage);
369         return a % b;
370     }
371 }
372 
373 // File: contracts/interface/IERC20.sol
374 
375 // File: \@openzeppelin\contracts\token\ERC20\IERC20.sol
376 
377 pragma solidity ^0.7.0;
378 
379 
380 /**
381  * @dev Interface of the ERC20 standard as defined in the EIP.
382  */
383 interface IERC20 {
384     /**
385      * @dev Returns the amount of tokens in existence.
386      */
387     function totalSupply() external view returns (uint256);
388 
389     /**
390      * @dev Returns the amount of tokens owned by `account`.
391      */
392     function balanceOf(address account) external view returns (uint256);
393 
394     /**
395      * @dev Moves `amount` tokens from the caller's account to `recipient`.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * Emits a {Transfer} event.
400      */
401     function transfer(address recipient, uint256 amount)
402         external
403         returns (bool);
404 
405     /**
406      * @dev Returns the remaining number of tokens that `spender` will be
407      * allowed to spend on behalf of `owner` through {transferFrom}. This is
408      * zero by default.
409      *
410      * This value changes when {approve} or {transferFrom} are called.
411      */
412     function allowance(address owner, address spender)
413         external
414         view
415         returns (uint256);
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * IMPORTANT: Beware that changing an allowance with this method brings the risk
423      * that someone may use both the old and the new allowance by unfortunate
424      * transaction ordering. One possible solution to mitigate this race
425      * condition is to first reduce the spender's allowance to 0 and set the
426      * desired value afterwards:
427      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address spender, uint256 amount) external returns (bool);
432 
433     /**
434      * @dev Moves `amount` tokens from `sender` to `recipient` using the
435      * allowance mechanism. `amount` is then deducted from the caller's
436      * allowance.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * Emits a {Transfer} event.
441      */
442     function transferFrom(
443         address sender,
444         address recipient,
445         uint256 amount
446     ) external returns (bool);
447 
448     /**
449      * @dev Emitted when `value` tokens are moved from one account (`from`) to
450      * another (`to`).
451      *
452      * Note that `value` may be zero.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 value);
455 
456     /**
457      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
458      * a call to {approve}. `value` is the new allowance.
459      */
460     event Approval(
461         address indexed owner,
462         address indexed spender,
463         uint256 value
464     );
465 }
466 
467 // File: contracts/Admin.sol
468 
469 pragma solidity ^0.7.0;
470 
471 
472 
473 
474 
475 
476 
477 // File: contracts/Admin.sol
478 
479 
480 abstract contract Admin is Ownable {
481     struct tokenInfo {
482         bool isExist;
483         uint8 decimal;
484         uint256 userMinStake;
485         uint256 userMaxStake;
486         uint256 totalMaxStake;
487         uint256 lockableDays;
488         bool optionableStatus;
489     }
490 
491     using SafeMath for uint256;
492     address[] public tokens;
493     mapping(address => address[]) public tokensSequenceList;
494     mapping(address => tokenInfo) public tokenDetails;
495     mapping(address => mapping(address => uint256)) public tokenDailyDistribution;
496     mapping(address => mapping(address => bool)) public tokenBlockedStatus;
497     uint256[] public intervalDays = [1, 8, 15, 22, 29, 36];
498     uint256 public constant DAYS = 1 days;
499     uint256 public constant HOURS = 1 hours;
500     uint256 public stakeDuration;
501     uint256 public refPercentage;
502     uint256 public optionableBenefit;
503 
504     event TokenDetails(
505         address indexed tokenAddress,
506         uint256 userMinStake,
507         uint256 userMaxStake,
508         uint256 totalMaxStake,
509         uint256 updatedTime
510     );
511     
512     event LockableTokenDetails(
513         address indexed tokenAddress,
514         uint256 lockableDys,
515         bool optionalbleStatus,
516         uint256 updatedTime
517     );
518     
519     event DailyDistributionDetails(
520         address indexed stakedTokenAddress,
521         address indexed rewardTokenAddress,
522         uint256 rewards,
523         uint256 time
524     );
525     
526     event SequenceDetails(
527         address indexed stakedTokenAddress,
528         address []  rewardTokenSequence,
529         uint256 time
530     );
531     
532     event StakeDurationDetails(
533         uint256 updatedDuration,
534         uint256 time
535     );
536     
537     event OptionableBenefitDetails(
538         uint256 updatedBenefit,
539         uint256 time
540     );
541     
542     event ReferrerPercentageDetails(
543         uint256 updatedRefPercentage,
544         uint256 time
545     );
546     
547     event IntervalDaysDetails(
548         uint256[] updatedIntervals,
549         uint256 time
550     );
551     
552     event BlockedDetails(
553         address indexed stakedTokenAddress,
554         address indexed rewardTokenAddress,
555         bool blockedStatus,
556         uint256 time
557     );
558     
559     event WithdrawDetails(
560         address indexed tokenAddress,
561         uint256 withdrawalAmount,
562         uint256 time
563     );
564 
565 
566     constructor(address _owner) Ownable(_owner) {
567         stakeDuration = 90 days;
568         optionableBenefit = 2;
569     }
570 
571     function addToken(
572         address tokenAddress,
573         uint256 userMinStake,
574         uint256 userMaxStake,
575         uint256 totalStake,
576         uint8 decimal
577     ) public onlyOwner returns (bool) {
578         if (!(tokenDetails[tokenAddress].isExist))
579             tokens.push(tokenAddress);
580 
581         tokenDetails[tokenAddress].isExist = true;
582         tokenDetails[tokenAddress].decimal = decimal;
583         tokenDetails[tokenAddress].userMinStake = userMinStake;
584         tokenDetails[tokenAddress].userMaxStake = userMaxStake;
585         tokenDetails[tokenAddress].totalMaxStake = totalStake;
586 
587         emit TokenDetails(
588             tokenAddress,
589             userMinStake,
590             userMaxStake,
591             totalStake,
592             block.timestamp
593         );
594         return true;
595     }
596 
597     function setDailyDistribution(
598         address[] memory stakedToken,
599         address[] memory rewardToken,
600         uint256[] memory dailyDistribution
601     ) public onlyOwner {
602         require(
603             stakedToken.length == rewardToken.length &&
604                 rewardToken.length == dailyDistribution.length,
605             "Invalid Input"
606         );
607 
608         for (uint8 i = 0; i < stakedToken.length; i++) {
609             require(
610                 tokenDetails[stakedToken[i]].isExist &&
611                     tokenDetails[rewardToken[i]].isExist,
612                 "Token not exist"
613             );
614             tokenDailyDistribution[stakedToken[i]][
615                 rewardToken[i]
616             ] = dailyDistribution[i];
617             
618             emit DailyDistributionDetails(
619                 stakedToken[i],
620                 rewardToken[i],
621                 dailyDistribution[i],
622                 block.timestamp
623             );
624         }
625         
626         
627     }
628 
629     function updateSequence(
630         address stakedToken,
631         address[] memory rewardTokenSequence
632     ) public onlyOwner {
633         tokensSequenceList[stakedToken] = new address[](0);
634         require(
635             tokenDetails[stakedToken].isExist,
636             "Staked Token Not Exist"
637         );
638         for (uint8 i = 0; i < rewardTokenSequence.length; i++) {
639             require(
640                 rewardTokenSequence.length <= tokens.length,
641                 "Invalid Input"
642             );
643             require(
644                 tokenDetails[rewardTokenSequence[i]].isExist,
645                 "Reward Token Not Exist"
646             );
647             tokensSequenceList[stakedToken].push(rewardTokenSequence[i]);
648         }
649         
650         emit SequenceDetails(
651             stakedToken,
652             tokensSequenceList[stakedToken],
653             block.timestamp
654         );
655         
656         
657     }
658 
659     function updateToken(
660         address tokenAddress,
661         uint256 userMinStake,
662         uint256 userMaxStake,
663         uint256 totalStake
664     ) public onlyOwner {
665         require(tokenDetails[tokenAddress].isExist, "Token Not Exist");
666         tokenDetails[tokenAddress].userMinStake = userMinStake;
667         tokenDetails[tokenAddress].userMaxStake = userMaxStake;
668         tokenDetails[tokenAddress].totalMaxStake = totalStake;
669 
670         emit TokenDetails(
671             tokenAddress,
672             userMinStake,
673             userMaxStake,
674             totalStake,
675             block.timestamp
676         );
677     }
678 
679     function lockableToken(
680         address tokenAddress,
681         uint8 lockableStatus,
682         uint256 lockedDays,
683         bool optionableStatus
684     ) public onlyOwner {
685         require(
686             lockableStatus == 1 || lockableStatus == 2 || lockableStatus == 3,
687             "Invalid Lockable Status"
688         );
689         require(tokenDetails[tokenAddress].isExist == true, "Token Not Exist");
690 
691         if (lockableStatus == 1) {
692             tokenDetails[tokenAddress].lockableDays = block.timestamp.add(
693                 lockedDays
694             );
695         } else if (lockableStatus == 2)
696             tokenDetails[tokenAddress].lockableDays = 0;
697         else if (lockableStatus == 3)
698             tokenDetails[tokenAddress].optionableStatus = optionableStatus;
699             
700             
701         emit LockableTokenDetails (
702             tokenAddress,
703             tokenDetails[tokenAddress].lockableDays,
704             tokenDetails[tokenAddress].optionableStatus,
705             block.timestamp
706         );
707     }
708 
709     function updateStakeDuration(uint256 durationTime) public onlyOwner {
710         stakeDuration = durationTime;
711         
712         emit StakeDurationDetails(
713             stakeDuration,
714             block.timestamp
715         );
716     }
717 
718     function updateOptionableBenefit(uint256 benefit) public onlyOwner {
719         optionableBenefit = benefit;
720         
721         emit OptionableBenefitDetails(
722             optionableBenefit,
723             block.timestamp
724         );
725     }
726 
727     function updateRefPercentage(uint256 refPer) public onlyOwner {
728         refPercentage = refPer;
729         
730         emit ReferrerPercentageDetails(
731             refPercentage,
732             block.timestamp
733         );
734     }
735 
736     function updateIntervalDays(uint256[] memory _interval) public onlyOwner {
737         intervalDays = new uint256[](0);
738 
739         for (uint8 i = 0; i < _interval.length; i++) {
740             uint256 noD = stakeDuration.div(DAYS);
741             require(noD > _interval[i], "Invalid Interval Day");
742             intervalDays.push(_interval[i]);
743         }
744         
745         emit IntervalDaysDetails(
746             intervalDays,
747             block.timestamp
748         );
749         
750         
751     }
752 
753     function changeTokenBlockedStatus(
754         address stakedToken,
755         address rewardToken,
756         bool status
757     ) public onlyOwner {
758         require(
759             tokenDetails[stakedToken].isExist &&
760                 tokenDetails[rewardToken].isExist,
761             "Token not exist"
762         );
763         tokenBlockedStatus[stakedToken][rewardToken] = status;
764         
765         
766         emit BlockedDetails(
767             stakedToken,
768             rewardToken,
769             tokenBlockedStatus[stakedToken][rewardToken],
770             block.timestamp
771         );
772     }
773 
774     function safeWithdraw(address tokenAddress, uint256 amount)
775         public
776         onlyOwner
777     {
778         require(
779             IERC20(tokenAddress).balanceOf(address(this)) >= amount,
780             "Insufficient Balance"
781         );
782         require(
783             IERC20(tokenAddress).transfer(owner(), amount),
784             "Transfer failed"
785         );
786         
787         
788         emit WithdrawDetails(
789             tokenAddress,
790             amount,
791             block.timestamp
792         );
793     }
794     
795     function viewTokensCount() external view returns(uint256) {
796         return tokens.length;
797     }
798 }
799 
800 // File: contracts/Unifarm.sol
801 
802 // File: contracts/Unifarm.sol
803 
804 
805 pragma solidity ^0.7.0;
806 
807 
808 /**
809  * @title Unifarm Contract
810  * @author OroPocket
811  */
812 
813 contract Unifarmv3 is Admin {
814     // Wrappers over Solidity's arithmetic operations
815     using SafeMath for uint256;
816 
817     // Stores Stake Details
818     struct stakeInfo {
819         address user;
820         uint8[] stakeOption;
821         bool[] isActive;
822         address[] referrer;
823         address[] tokenAddress;
824         uint256[] stakeId;
825         uint256[] stakedAmount;
826         uint256[] startTime;
827     }
828 
829     // Mapping
830     mapping(address => stakeInfo) public stakingDetails;
831     mapping(address => mapping(address => uint256)) public userTotalStaking;
832     mapping(address => uint256) public totalStaking;
833     uint256 public poolStartTime;
834 
835     // Events
836     event Stake(
837         address indexed userAddress,
838         address indexed tokenAddress,
839         uint256 stakedAmount,
840         uint256 time
841     );
842     event Claim(
843         address indexed userAddress,
844         address indexed stakedTokenAddress,
845         address indexed tokenAddress,
846         uint256 claimRewards,
847         uint256 time
848     );
849     event UnStake(
850         address indexed userAddress,
851         address indexed unStakedtokenAddress,
852         uint256 unStakedAmount,
853         uint256 time
854     );
855 
856     constructor(address _owner) Admin(_owner) {
857         poolStartTime = block.timestamp;
858     }
859 
860     /**
861      * @notice Stake tokens to earn rewards
862      * @param tokenAddress Staking token address
863      * @param amount Amount of tokens to be staked
864      */
865     function stake(
866         address referrerAddress,
867         address tokenAddress,
868         uint8 stakeOption,
869         uint256 amount
870     ) external whenNotPaused {
871         // checks
872         require(
873             tokenDetails[tokenAddress].isExist,
874             "STAKE : Token is not Exist"
875         );
876         require(
877             userTotalStaking[msg.sender][tokenAddress].add(amount) >=
878                 tokenDetails[tokenAddress].userMinStake,
879             "STAKE : Min Amount should be within permit"
880         );
881         require(
882             userTotalStaking[msg.sender][tokenAddress].add(amount) <=
883                 tokenDetails[tokenAddress].userMaxStake,
884             "STAKE : Max Amount should be within permit"
885         );
886         require(
887             totalStaking[tokenAddress].add(amount) <=
888                 tokenDetails[tokenAddress].totalMaxStake,
889             "STAKE : Maxlimit exceeds"
890         );
891 
892         // Storing stake details
893         stakingDetails[msg.sender].stakeId.push(
894             stakingDetails[msg.sender].stakeId.length
895         );
896         stakingDetails[msg.sender].isActive.push(true);
897         stakingDetails[msg.sender].user = msg.sender;
898         stakingDetails[msg.sender].referrer.push(referrerAddress);
899         stakingDetails[msg.sender].tokenAddress.push(tokenAddress);
900         stakingDetails[msg.sender].stakeOption.push(stakeOption);
901         stakingDetails[msg.sender].startTime.push(block.timestamp);
902     
903         // Update total staking amount
904         stakingDetails[msg.sender].stakedAmount.push(amount);
905         totalStaking[tokenAddress] = totalStaking[tokenAddress].add(
906             amount
907         );
908         userTotalStaking[msg.sender][tokenAddress] = userTotalStaking[
909             msg.sender
910         ][tokenAddress]
911             .add(amount);
912 
913         // Transfer tokens from userf to contract
914         require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount),
915                 "Transfer Failed");
916 
917         // Emit state changes
918         emit Stake(msg.sender, tokenAddress, amount, block.timestamp);
919     }
920 
921     /**
922      * @notice Claim accumulated rewards
923      * @param stakeId Stake ID of the user
924      * @param stakedAmount Staked amount of the user
925      */
926     function claimRewards1(uint256 stakeId, uint256 stakedAmount, uint256 totalStake) internal {
927         // Local variables
928         uint256 interval;
929 
930         interval = stakingDetails[msg.sender].startTime[stakeId].add(
931             stakeDuration
932         );
933         // Interval calculation
934         if (interval > block.timestamp) {
935             uint256 endOfProfit = block.timestamp;
936             interval = endOfProfit.sub(
937                 stakingDetails[msg.sender].startTime[stakeId]
938             );
939         } else {
940             uint256 endOfProfit =
941                 stakingDetails[msg.sender].startTime[stakeId].add(
942                     stakeDuration
943                 );
944             interval = endOfProfit.sub(
945                 stakingDetails[msg.sender].startTime[stakeId]
946             );
947         }
948 
949         // Reward calculation
950         if (interval >= HOURS)
951             _rewardCalculation(stakeId, stakedAmount, interval, totalStake);
952     }
953     
954     
955     /**
956      * @notice Claim accumulated rewards
957      * @param stakeId Stake ID of the user
958      * @param stakedAmount Staked amount of the user
959      */
960     function claimRewards2(uint256 stakeId, uint256 stakedAmount, uint256 totalStake) internal {
961         // Local variables
962         uint256 interval;
963         uint256 contractInterval;
964         uint256 endOfProfit; 
965 
966         interval = poolStartTime.add(stakeDuration);
967         
968         // Interval calculation
969         if (interval > block.timestamp) 
970             endOfProfit = block.timestamp;
971            
972         else 
973             endOfProfit = poolStartTime.add(stakeDuration);
974         
975         interval = endOfProfit.sub(stakingDetails[msg.sender].startTime[stakeId]); 
976         contractInterval = endOfProfit.sub(poolStartTime);
977 
978         // Reward calculation
979         if (interval >= HOURS) 
980             _rewardCalculation2(stakeId, stakedAmount, interval, contractInterval, totalStake);
981     }
982 
983 
984     function _rewardCalculation(
985         uint256 stakeId,
986         uint256 stakedAmount,
987         uint256 interval, 
988         uint256 totalStake
989     ) internal {
990         uint256 rewardsEarned;
991         uint256 noOfDays;
992         uint256 noOfHours;
993         
994         noOfHours = interval.div(HOURS);
995         noOfDays = interval.div(DAYS);
996         rewardsEarned = noOfHours.mul(
997             getOneDayReward(
998                 stakedAmount,
999                 stakingDetails[msg.sender].tokenAddress[stakeId],
1000                 stakingDetails[msg.sender].tokenAddress[stakeId],
1001                 totalStake
1002             )
1003         );
1004 
1005         // Referrer Earning
1006         if (stakingDetails[msg.sender].referrer[stakeId] != address(0)) {
1007             uint256 refEarned =
1008                 (rewardsEarned.mul(refPercentage)).div(100 ether);
1009             rewardsEarned = rewardsEarned.sub(refEarned);
1010 
1011             require(IERC20(stakingDetails[msg.sender].tokenAddress[stakeId]).transfer(
1012                 stakingDetails[msg.sender].referrer[stakeId],
1013                 refEarned) == true, "Transfer Failed");
1014         }
1015 
1016         //  Rewards Send
1017         sendToken(
1018             stakingDetails[msg.sender].tokenAddress[stakeId],
1019             stakingDetails[msg.sender].tokenAddress[stakeId],
1020             rewardsEarned
1021         );
1022 
1023         uint8 i = 1;
1024         while (i < intervalDays.length) {
1025             
1026             if (noOfDays >= intervalDays[i]) {
1027                 uint256 balHours = noOfHours.sub((intervalDays[i].sub(1)).mul(24));
1028                 
1029 
1030                 address rewardToken =
1031                     tokensSequenceList[
1032                         stakingDetails[msg.sender].tokenAddress[stakeId]][i];
1033 
1034                 if ( rewardToken != stakingDetails[msg.sender].tokenAddress[stakeId] 
1035                         && tokenBlockedStatus[stakingDetails[msg.sender].tokenAddress[stakeId]][rewardToken] ==  false) {
1036                     rewardsEarned = balHours.mul(
1037                         getOneDayReward(
1038                             stakedAmount,
1039                             stakingDetails[msg.sender].tokenAddress[stakeId],
1040                             rewardToken,
1041                             totalStake
1042                         )
1043                     );
1044 
1045                     // Referrer Earning
1046 
1047                     if (
1048                         stakingDetails[msg.sender].referrer[stakeId] !=
1049                         address(0)
1050                     ) {
1051                         uint256 refEarned =
1052                             (rewardsEarned.mul(refPercentage)).div(100 ether);
1053                         rewardsEarned = rewardsEarned.sub(refEarned);
1054 
1055                         require(IERC20(rewardToken)
1056                             .transfer(
1057                             stakingDetails[msg.sender].referrer[stakeId],
1058                             refEarned) == true, "Transfer Failed");
1059                     }
1060 
1061                     //  Rewards Send
1062                     sendToken(
1063                         stakingDetails[msg.sender].tokenAddress[stakeId],
1064                         rewardToken,
1065                         rewardsEarned
1066                     );
1067                 }
1068                 i = i + 1;
1069             } else {
1070                 break;
1071             }
1072         }
1073     }
1074     
1075     
1076     function _rewardCalculation2(
1077         uint256 stakeId,
1078         uint256 stakedAmount,
1079         uint256 interval,
1080         uint256 contractInterval,
1081         uint256 totalStake
1082     ) internal {
1083         uint256 rewardsEarned;
1084         uint256[2] memory count;
1085         uint256[2] memory conCount;
1086 
1087         count[0] = interval.div(DAYS); 
1088         conCount[0] = contractInterval.div(DAYS); 
1089         
1090         count[1] = interval.div(HOURS);
1091         conCount[1] = contractInterval.div(HOURS);
1092         
1093         rewardsEarned = count[1].mul(
1094             getOneDayReward(
1095                 stakedAmount,
1096                 stakingDetails[msg.sender].tokenAddress[stakeId],
1097                 stakingDetails[msg.sender].tokenAddress[stakeId],
1098                 totalStake
1099             )
1100         );
1101 
1102         // Referrer Earning
1103         if (stakingDetails[msg.sender].referrer[stakeId] != address(0)) {
1104             uint256 refEarned =
1105                 (rewardsEarned.mul(refPercentage)).div(100 ether);
1106             rewardsEarned = rewardsEarned.sub(refEarned);
1107 
1108             require(IERC20(stakingDetails[msg.sender].tokenAddress[stakeId]).transfer(
1109                 stakingDetails[msg.sender].referrer[stakeId],
1110                 refEarned) == true, "Transfer Failed");
1111         }
1112 
1113         //  Rewards Send
1114         sendToken(
1115             stakingDetails[msg.sender].tokenAddress[stakeId],
1116             stakingDetails[msg.sender].tokenAddress[stakeId],
1117             rewardsEarned
1118         );
1119 
1120         uint8 i = 1;
1121         while (i < intervalDays.length) {
1122             uint256 userStakingDuration = stakingDetails[msg.sender].startTime[stakeId].sub(poolStartTime); 
1123             
1124             if (conCount[0] >= intervalDays[i] && intervalDays[i] >= userStakingDuration.div(DAYS)) {
1125                 uint256 balHours = conCount[1].sub((intervalDays[i].sub(1)).mul(24));
1126                 address rewardToken = tokensSequenceList[stakingDetails[msg.sender].tokenAddress[stakeId]][i];
1127 
1128                 if ( rewardToken != stakingDetails[msg.sender].tokenAddress[stakeId] 
1129                         && tokenBlockedStatus[stakingDetails[msg.sender].tokenAddress[stakeId]][rewardToken] ==  false) {
1130                     
1131                     rewardsEarned = balHours.mul(getOneDayReward(stakedAmount, stakingDetails[msg.sender].tokenAddress[stakeId], rewardToken, totalStake));
1132 
1133                     // Referrer Earning
1134 
1135                     if (
1136                         stakingDetails[msg.sender].referrer[stakeId] != address(0)) {
1137                         uint256 refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
1138                         rewardsEarned = rewardsEarned.sub(refEarned);
1139 
1140                         require(IERC20(rewardToken).transfer(stakingDetails[msg.sender].referrer[stakeId],refEarned), "Transfer Failed");
1141                     }
1142 
1143                     //  Rewards Send
1144                     sendToken(
1145                         stakingDetails[msg.sender].tokenAddress[stakeId],
1146                         rewardToken,
1147                         rewardsEarned
1148                     );
1149                 }               
1150             
1151             }
1152             else {
1153 
1154                 address rewardToken = tokensSequenceList[stakingDetails[msg.sender].tokenAddress[stakeId]][i];
1155 
1156                 if ( rewardToken != stakingDetails[msg.sender].tokenAddress[stakeId] 
1157                         && tokenBlockedStatus[stakingDetails[msg.sender].tokenAddress[stakeId]][rewardToken] ==  false) {
1158                     
1159                     rewardsEarned = count[1].mul(getOneDayReward(stakedAmount, stakingDetails[msg.sender].tokenAddress[stakeId], rewardToken, totalStake));
1160                     // Referrer Earning
1161 
1162                     if (
1163                         stakingDetails[msg.sender].referrer[stakeId] != address(0)) {
1164                         uint256 refEarned = (rewardsEarned.mul(refPercentage)).div(100 ether);
1165                         rewardsEarned = rewardsEarned.sub(refEarned);
1166 
1167                         require(IERC20(rewardToken).transfer(stakingDetails[msg.sender].referrer[stakeId],refEarned), "Transfer Failed");
1168                     }
1169 
1170                     //  Rewards Send
1171                     sendToken(
1172                         stakingDetails[msg.sender].tokenAddress[stakeId],
1173                         rewardToken,
1174                         rewardsEarned
1175                     );
1176                 }               
1177                
1178             }
1179             i = i + 1;
1180         }
1181     }
1182 
1183 
1184     /**
1185      * @notice Get rewards for one day
1186      * @param stakedAmount Stake amount of the user
1187      * @param stakedToken Staked token address of the user
1188      * @param rewardToken Reward token address
1189      * @return reward One dayh reward for the user
1190      */
1191     function getOneDayReward(
1192         uint256 stakedAmount,
1193         address stakedToken,
1194         address rewardToken,
1195         uint256 totalStake
1196     ) public view returns (uint256 reward) {
1197         
1198         uint256 lockBenefit;
1199         
1200         if (tokenDetails[stakedToken].optionableStatus) {
1201             stakedAmount = stakedAmount.mul(optionableBenefit);
1202             lockBenefit = stakedAmount.mul(optionableBenefit.sub(1));
1203             reward = (stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])).div(totalStake.add(lockBenefit));
1204         }
1205         else 
1206             reward = (stakedAmount.mul(tokenDailyDistribution[stakedToken][rewardToken])).div(totalStake);
1207         
1208     }
1209  
1210     /**
1211      * @notice Get rewards for one day
1212      * @param stakedToken Stake amount of the user
1213      * @param tokenAddress Reward token address
1214      * @param amount Amount to be transferred as reward
1215      */
1216     function sendToken(
1217         address stakedToken,
1218         address tokenAddress,
1219         uint256 amount
1220     ) internal {
1221         // Checks
1222         if (tokenAddress != address(0)) {
1223             require(
1224                 IERC20(tokenAddress).balanceOf(address(this)) >= amount,
1225                 "SEND : Insufficient Balance"
1226             );
1227             // Transfer of rewards
1228             require(IERC20(tokenAddress).transfer(msg.sender, amount), 
1229                     "Transfer failed");
1230 
1231             // Emit state changes
1232             emit Claim(
1233                 msg.sender,
1234                 stakedToken,
1235                 tokenAddress,
1236                 amount,
1237                 block.timestamp
1238             );
1239         }
1240     }
1241 
1242     /**
1243      * @notice Unstake and claim rewards
1244      * @param stakeId Stake ID of the user
1245      */
1246     function unStake(uint256 stakeId) external whenNotPaused returns (bool) {
1247         
1248         address stakedToken = stakingDetails[msg.sender].tokenAddress[stakeId];
1249         
1250         // lockableDays check
1251         require(
1252             tokenDetails[stakedToken].lockableDays <= block.timestamp,
1253             "Token Locked"
1254         );
1255         
1256         // optional lock check
1257         if(tokenDetails[stakedToken].optionableStatus)
1258             require(stakingDetails[msg.sender].startTime[stakeId].add(stakeDuration) <= block.timestamp, 
1259             "Locked in optional lock");
1260             
1261         // Checks
1262         require(
1263             stakingDetails[msg.sender].stakedAmount[stakeId] > 0,
1264             "CLAIM : Insufficient Staked Amount"
1265         );
1266 
1267         // State updation
1268         uint256 stakedAmount = stakingDetails[msg.sender].stakedAmount[stakeId];
1269         uint256 totalStaking1 =  totalStaking[stakedToken];
1270         totalStaking[stakedToken] = totalStaking[stakedToken].sub(stakedAmount);
1271         userTotalStaking[msg.sender][stakedToken] =  userTotalStaking[msg.sender][stakedToken].sub(stakedAmount);
1272         stakingDetails[msg.sender].stakedAmount[stakeId] = 0;        
1273         stakingDetails[msg.sender].isActive[stakeId] = false;
1274 
1275         // Balance check
1276         require(
1277             IERC20(stakingDetails[msg.sender].tokenAddress[stakeId]).balanceOf(
1278                 address(this)
1279             ) >= stakedAmount,
1280             "UNSTAKE : Insufficient Balance"
1281         );
1282 
1283         // Transfer staked token back to user
1284         IERC20(stakingDetails[msg.sender].tokenAddress[stakeId]).transfer(
1285             msg.sender,
1286             stakedAmount
1287         );
1288 
1289         // Claim pending rewards
1290         
1291         if(stakingDetails[msg.sender].stakeOption[stakeId] == 1) 
1292             claimRewards1(stakeId, stakedAmount, totalStaking1);
1293 
1294         else if(stakingDetails[msg.sender].stakeOption[stakeId] == 2) 
1295             claimRewards2(stakeId, stakedAmount, totalStaking1);
1296         
1297 
1298         // Emit state changes
1299         emit UnStake(
1300             msg.sender,
1301             stakingDetails[msg.sender].tokenAddress[stakeId],
1302             stakedAmount,
1303             block.timestamp
1304         );
1305         return true;
1306     }
1307 
1308     /**
1309      * @notice View staking details
1310      * @param _user User address
1311      */
1312     function viewStakingDetails(address _user)
1313         public
1314         view
1315         returns (
1316             address[] memory,
1317             address[] memory,
1318             bool[] memory,
1319             uint8[] memory,
1320             uint256[] memory,
1321             uint256[] memory,
1322             uint256[] memory
1323         )
1324     {
1325         return (
1326             stakingDetails[_user].referrer,
1327             stakingDetails[_user].tokenAddress,
1328             stakingDetails[_user].isActive,
1329             stakingDetails[_user].stakeOption,
1330             stakingDetails[_user].stakeId,
1331             stakingDetails[_user].stakedAmount,
1332             stakingDetails[_user].startTime
1333         );
1334     }
1335 
1336 }