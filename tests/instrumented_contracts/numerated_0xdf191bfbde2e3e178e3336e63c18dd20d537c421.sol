1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
117  * the optional functions; to access them see `ERC20Detailed`.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a `Transfer` event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through `transferFrom`. This is
142      * zero by default.
143      *
144      * This value changes when `approve` or `transferFrom` are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * > Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an `Approval` event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a `Transfer` event.
172      */
173     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to `approve`. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 // File: contracts/IStaking.sol
191 
192 pragma solidity 0.5.1;
193 
194 /**
195  * @title Staking interface, as defined by EIP-900.
196  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
197  */
198 contract IStaking {
199     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
200     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
201 
202     function stake(uint256 amount, bytes calldata data) external;
203     function unstake(uint256 amount, bytes calldata data) external;
204     function totalStakedFor(address addr) public view returns (uint256);
205     function totalStaked() public view returns (uint256);
206     function token() external view returns (address);
207 
208     /**
209      * @return False. This application does not support staking history.
210      */
211     function supportsHistory() external pure returns (bool) {
212         return false;
213     }
214 }
215 
216 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
217 
218 pragma solidity ^0.5.0;
219 
220 /**
221  * @dev Contract module which provides a basic access control mechanism, where
222  * there is an account (an owner) that can be granted exclusive access to
223  * specific functions.
224  *
225  * This module is used through inheritance. It will make available the modifier
226  * `onlyOwner`, which can be aplied to your functions to restrict their use to
227  * the owner.
228  */
229 contract Ownable {
230     address private _owner;
231 
232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234     /**
235      * @dev Initializes the contract setting the deployer as the initial owner.
236      */
237     constructor () internal {
238         _owner = msg.sender;
239         emit OwnershipTransferred(address(0), _owner);
240     }
241 
242     /**
243      * @dev Returns the address of the current owner.
244      */
245     function owner() public view returns (address) {
246         return _owner;
247     }
248 
249     /**
250      * @dev Throws if called by any account other than the owner.
251      */
252     modifier onlyOwner() {
253         require(isOwner(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     /**
258      * @dev Returns true if the caller is the current owner.
259      */
260     function isOwner() public view returns (bool) {
261         return msg.sender == _owner;
262     }
263 
264     /**
265      * @dev Leaves the contract without owner. It will not be possible to call
266      * `onlyOwner` functions anymore. Can only be called by the current owner.
267      *
268      * > Note: Renouncing ownership will leave the contract without an owner,
269      * thereby removing any functionality that is only available to the owner.
270      */
271     function renounceOwnership() public onlyOwner {
272         emit OwnershipTransferred(_owner, address(0));
273         _owner = address(0);
274     }
275 
276     /**
277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
278      * Can only be called by the current owner.
279      */
280     function transferOwnership(address newOwner) public onlyOwner {
281         _transferOwnership(newOwner);
282     }
283 
284     /**
285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
286      */
287     function _transferOwnership(address newOwner) internal {
288         require(newOwner != address(0), "Ownable: new owner is the zero address");
289         emit OwnershipTransferred(_owner, newOwner);
290         _owner = newOwner;
291     }
292 }
293 
294 // File: contracts/TokenPool.sol
295 
296 pragma solidity 0.5.1;
297 
298 
299 
300 /**
301  * @title A simple holder of tokens.
302  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
303  * needs to hold multiple distinct pools of the same token.
304  */
305 contract TokenPool is Ownable {
306     IERC20 public token;
307 
308     constructor(IERC20 _token) public {
309         token = _token;
310     }
311 
312     function balance() public view returns (uint256) {
313         return token.balanceOf(address(this));
314     }
315 
316     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
317         return token.transfer(to, value);
318     }
319 
320     function rescueFunds(address tokenToRescue, address to, uint256 amount) external onlyOwner returns (bool) {
321         require(address(token) != tokenToRescue, 'TokenPool: Cannot claim token held by the contract');
322 
323         return IERC20(tokenToRescue).transfer(to, amount);
324     }
325 }
326 
327 // File: contracts/RewardPool.sol
328 
329 pragma solidity 0.5.1;
330 
331 
332 
333 
334 
335 /**
336  * @title Reward Pool
337  * @dev A smart-contract based mechanism to distribute tokens over time. Forked from Ampleforth's
338  *      geyser contract, but utilizing a second degree polynomial curve to calculate the bonus rewards.
339  *
340  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
341  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
342  *      claimed by users.
343  *
344  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
345  *      is a function of the number of tokens deposited as well as the length of time deposited.
346  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
347  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
348  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
349  *
350  */
351 contract RewardPool is IStaking {
352     struct Accounting {
353             uint256 globalTotalStakingShareSeconds;
354             uint256 globalLastAccountingTimestampSec;
355             uint256 globalLockedPoolBalance;
356             uint256 globalUnlockedPoolBalance;
357     }
358 
359     struct RewardData {
360         uint256 stakingShareSecondsToBurn;
361         uint256 sharesLeftToBurn;
362         uint256 rewardAmount;
363     }
364         
365     using SafeMath for uint256;
366 
367     event Staked(
368         address indexed user,
369         uint256 amount,
370         uint256 total,
371         bytes data
372     );
373     event Unstaked(
374         address indexed user,
375         uint256 amount,
376         uint256 total,
377         bytes data
378     );
379     event TokensClaimed(address indexed user, uint256 amount);
380     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
381     // amount: Unlocked tokens, total: Total locked tokens
382     event TokensUnlocked(uint256 amount, uint256 total);
383     event AccountingUpdated();
384 
385     TokenPool private _stakingPool;
386     TokenPool private _unlockedPool;
387     TokenPool private _lockedPool;
388 
389     //
390     // Time-bonus params
391     //
392     uint256 public constant BONUS_DECIMALS = 4;
393     uint256 public startBonus = 0;
394     uint256 public bonusPeriodSec = 0;
395     uint256 public growthParamX;
396     uint256 public growthParamY;
397 
398     //
399     // Global accounting state
400     //
401     uint256 public totalLockedShares = 0;
402     uint256 public totalStakingShares = 0;
403     uint256 public _totalStakingShareSeconds = 0;
404     uint256 public _lastAccountingTimestampSec = now;
405     uint256 public _maxUnlockSchedules = 0;
406     uint256 public _initialSharesPerToken = 0;
407 
408     //
409     // User accounting state
410     //
411     // Represents a single stake for a user. A user may have multiple.
412     struct Stake {
413         uint256 stakingShares;
414         uint256 timestampSec;
415     }
416 
417     // Caches aggregated values from the User->Stake[] map to save computation.
418     // If lastAccountingTimestampSec is 0, there's no entry for that user.
419     struct UserTotals {
420         uint256 stakingShares;
421         uint256 stakingShareSeconds;
422         uint256 lastAccountingTimestampSec;
423     }
424 
425     // Aggregated staking values per user
426     mapping(address => UserTotals) public _userTotals;
427 
428     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
429     mapping(address => Stake[]) public _userStakes;
430 
431     //
432     // Locked/Unlocked Accounting state
433     //
434     struct UnlockSchedule {
435         uint256 initialLockedShares;
436         uint256 unlockedShares;
437         uint256 lastUnlockTimestampSec;
438         uint256 endAtSec;
439         uint256 durationSec;
440     }
441 
442     UnlockSchedule[] public unlockSchedules;
443 
444     /**
445      * @param stakingToken The token users deposit as stake.
446      * @param distributionToken The token users receive as they unstake.
447      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
448      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
449      *                    e.g. 25 means user gets 25% of max distribution tokens.
450      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
451      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
452      */
453     constructor(
454         IERC20 stakingToken,
455         IERC20 distributionToken,
456         uint256 maxUnlockSchedules,
457         uint256 startBonus_,
458         uint256 bonusPeriodSec_,
459         uint256 growthParamX_,
460         uint256 growthParamY_,
461         uint256 initialSharesPerToken
462     ) public {
463         // The start bonus must be some fraction of the max. (i.e. <= 100%)
464         require(
465             startBonus_ <= 10**BONUS_DECIMALS,
466             "TokenGeyser: start bonus too high"
467         );
468         // If no period is desired, instead set startBonus = 100%
469         // and bonusPeriod to a small value like 1sec.
470         require(bonusPeriodSec_ != 0, "TokenGeyser: bonus period is zero");
471         require(
472             initialSharesPerToken > 0,
473             "TokenGeyser: initialSharesPerToken is zero"
474         );
475 
476         _stakingPool = new TokenPool(stakingToken);
477         _unlockedPool = new TokenPool(distributionToken);
478         _lockedPool = new TokenPool(distributionToken);
479         startBonus = startBonus_;
480         bonusPeriodSec = bonusPeriodSec_;
481         growthParamX = growthParamX_;
482         growthParamY = growthParamY_;
483         _maxUnlockSchedules = maxUnlockSchedules;
484         _initialSharesPerToken = initialSharesPerToken;
485     }
486 
487     function stakeCount(address account) public view returns (uint256) {
488         return _userStakes[account].length;
489     }
490 
491     /**
492      * @return The token users deposit as stake.
493      */
494     function getStakingToken() public view returns (IERC20) {
495         return _stakingPool.token();
496     }
497 
498     /**
499      * @return The token users receive as they unstake.
500      */
501     function getDistributionToken() public view returns (IERC20) {
502         assert(_unlockedPool.token() == _lockedPool.token());
503         return _unlockedPool.token();
504     }
505 
506     /**
507      * @dev Transfers amount of deposit tokens from the user.
508      * @param amount Number of deposit tokens to stake.
509      * @param data Not used.
510      */
511     function stake(uint256 amount, bytes calldata data) external {
512         _stakeFor(msg.sender, msg.sender, amount);
513     }
514 
515     /**
516      * @dev Private implementation of staking methods.
517      * @param staker User address who deposits tokens to stake.
518      * @param beneficiary User address who gains credit for this stake operation.
519      * @param amount Number of deposit tokens to stake.
520      */
521     function _stakeFor(
522         address staker,
523         address beneficiary,
524         uint256 amount
525     ) private {
526         require(amount > 0, "TokenGeyser: stake amount is zero");
527         require(
528             beneficiary != address(0),
529             "TokenGeyser: beneficiary is zero address"
530         );
531         require(
532             totalStakingShares == 0 || totalStaked() > 0,
533             "TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do"
534         );
535 
536         uint256 mintedStakingShares = (totalStakingShares > 0)
537             ? totalStakingShares.mul(amount).div(totalStaked())
538             : amount.mul(_initialSharesPerToken);
539         require(
540             mintedStakingShares > 0,
541             "TokenGeyser: Stake amount is too small"
542         );
543 
544         updateAccounting();
545 
546         // 1. User Accounting
547         UserTotals storage totals = _userTotals[beneficiary];
548         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
549         totals.lastAccountingTimestampSec = now;
550 
551         Stake memory newStake = Stake(mintedStakingShares, now);
552         _userStakes[beneficiary].push(newStake);
553 
554         // 2. Global Accounting
555         totalStakingShares = totalStakingShares.add(mintedStakingShares);
556         // Already set in updateAccounting()
557         // _lastAccountingTimestampSec = now;
558 
559         // interactions
560         require(
561             _stakingPool.token().transferFrom(
562                 staker,
563                 address(_stakingPool),
564                 amount
565             ),
566             "TokenGeyser: transfer into staking pool failed"
567         );
568 
569         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
570     }
571 
572     /**
573      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
574      * alotted number of distribution tokens.
575      * @param amount Number of deposit tokens to unstake / withdraw.
576      * @param data Not used.
577      */
578     function unstake(uint256 amount, bytes calldata data) external {
579         _unstake(amount);
580     }
581 
582     function unlockScheduleSharesPure(uint256 s, uint256 timestamp) private view returns (uint256) {
583         UnlockSchedule memory schedule = unlockSchedules[s];
584 
585         if (schedule.unlockedShares >= schedule.initialLockedShares) {
586             return 0;
587         }
588 
589         uint256 sharesToUnlock = 0;
590         // Special case to handle any leftover dust from integer division
591         if (timestamp >= schedule.endAtSec) {
592             sharesToUnlock = (
593                 schedule.initialLockedShares.sub(schedule.unlockedShares)
594             );
595         } else {
596             sharesToUnlock = timestamp
597                 .sub(schedule.lastUnlockTimestampSec)
598                 .mul(schedule.initialLockedShares)
599                 .div(schedule.durationSec);
600         }
601 
602         return sharesToUnlock;
603     }
604 
605     function computeNewRewardPure(
606         uint256 newStakingShareSecondsToBurn,
607         uint256 stakeTimeSec,
608         uint256 rewardAmount,
609         uint256 totalUnlocked,
610         uint256 totalStakingShareSeconds,
611         bool withBonus
612     ) internal view returns (uint256) {
613         uint256 newRewardTokens = totalUnlocked
614             .mul(newStakingShareSecondsToBurn)
615             .div(totalStakingShareSeconds);
616 
617         if ((stakeTimeSec >= bonusPeriodSec) || !withBonus) {
618             return rewardAmount.add(newRewardTokens);
619         }
620 
621         uint256 oneHundredPct = 10**BONUS_DECIMALS;
622 
623         uint256 growthFactor = stakeTimeSec.mul(oneHundredPct).div(bonusPeriodSec);
624 
625         uint256 term1 = (startBonus*oneHundredPct**3).div(oneHundredPct).mul(newRewardTokens);
626         uint256 term2 = (oneHundredPct.sub(startBonus).mul(growthParamX).mul(growthFactor**2)*oneHundredPct**3).div(oneHundredPct**3).mul(newRewardTokens);
627         uint256 term3 = (oneHundredPct.sub(startBonus).mul(growthParamY).mul(growthFactor)*oneHundredPct**3).div(oneHundredPct**2).mul(newRewardTokens);
628 
629         uint256 bonusedReward = term1.add(term2).add(term3).div(oneHundredPct**3);
630 
631         return rewardAmount.add(bonusedReward);
632     }
633 
634     function unlockTokensPure(uint256 timestamp) public view returns (
635         uint256 lockedPoolBalance,
636         uint256 unlockedPoolBalance
637     ) {
638         uint256 globalTotalLockedShares = totalLockedShares;
639         unlockedPoolBalance = _unlockedPool.balance();
640         lockedPoolBalance = _lockedPool.balance();
641         uint256 unlockedTokens = 0;
642         uint256 lockedTokens = totalLocked();
643         
644         if (globalTotalLockedShares == 0) {
645             unlockedTokens = lockedTokens;
646         } else {
647             uint256 unlockedShares = 0;
648             for (uint256 s = 0; s < unlockSchedules.length; s++) {
649                 unlockedShares = unlockedShares.add(unlockScheduleSharesPure(s, timestamp));
650             }
651             unlockedTokens = unlockedShares.mul(lockedTokens).div(
652                 globalTotalLockedShares
653             );
654             globalTotalLockedShares = globalTotalLockedShares.sub(unlockedShares);
655         }
656 
657         if (unlockedTokens > 0) {
658             /*
659             require(
660                 _lockedPool.transfer(address(_unlockedPool), unlockedTokens),
661                 "TokenGeyser: transfer out of locked pool failed"
662             );
663             */
664             lockedPoolBalance -= unlockedTokens;
665             unlockedPoolBalance += unlockedTokens;
666         }
667 
668         return (
669             lockedPoolBalance,
670             unlockedPoolBalance
671         );
672     }
673 
674     function updateAccountingPure(uint256 timestamp) public view returns (
675         uint256 globalTotalStakingShareSeconds,
676         uint256 globalLastAccountingTimestampSec,
677         uint256 globalLockedPoolBalance,
678         uint256 globalUnlockedPoolBalance
679     ){
680         globalTotalStakingShareSeconds = _totalStakingShareSeconds;
681         globalLastAccountingTimestampSec = _lastAccountingTimestampSec;
682 
683         (
684             uint256 lockedPoolBalance,
685             uint256 unlockedPoolBalance
686         ) = unlockTokensPure(timestamp);
687 
688         // Global accounting
689         uint256 newStakingShareSeconds = timestamp
690             .sub(globalLastAccountingTimestampSec)
691             .mul(totalStakingShares);
692         globalTotalStakingShareSeconds = globalTotalStakingShareSeconds.add(
693             newStakingShareSeconds
694         );
695         globalLastAccountingTimestampSec = timestamp;
696 
697         return (
698             globalTotalStakingShareSeconds,
699             globalLastAccountingTimestampSec,
700             lockedPoolBalance,
701             unlockedPoolBalance
702         );
703     }
704 
705     /**
706      * @return The total number of distribution tokens that would be rewarded.
707      */
708     function unstakeQuery(uint256 amount, bool withBonus, uint256 bonusTimestamp, uint256 unlockTimestamp) public view returns (uint256) {
709         bonusTimestamp += 30;
710         unlockTimestamp += 30;
711 
712         if(bonusTimestamp == 0) {
713             bonusTimestamp = now;
714         }
715 
716         if(unlockTimestamp == 0) {
717             unlockTimestamp = now;
718         }
719 
720         Accounting memory accounting;
721 
722         (
723             accounting.globalTotalStakingShareSeconds,
724             accounting.globalLastAccountingTimestampSec,
725             accounting.globalLockedPoolBalance,
726             accounting.globalUnlockedPoolBalance
727         ) = updateAccountingPure(unlockTimestamp);  
728         
729         // checks
730         if(amount < 1) {
731             return 0;
732         }
733         
734         require(
735             totalStakedFor(msg.sender) >= amount,
736             "TokenGeyser: unstake amount is greater than total user stakes"
737         );
738 
739         // 1. User Accounting
740         Stake[] memory accountStakes = _userStakes[msg.sender];
741 
742         RewardData memory data;
743 
744         // Redeem from most recent stake and go backwards in time.
745         data.stakingShareSecondsToBurn = 0;
746         data.sharesLeftToBurn = totalStakingShares.mul(amount).div(
747             totalStaked()
748         );
749         data.rewardAmount = 0;
750 
751         uint256 i = accountStakes.length - 1;
752 
753         while (data.sharesLeftToBurn > 0) {
754             uint256 newStakingShareSecondsToBurn = 0;
755 
756             if (
757                 accountStakes[i].stakingShares <=
758                 data.sharesLeftToBurn
759             ) {
760                 // fully redeem a past stake
761                 newStakingShareSecondsToBurn = accountStakes[accountStakes
762                     .length - 1]
763                     .stakingShares
764                     .mul(
765                     unlockTimestamp.sub(
766                         accountStakes[i].timestampSec
767                     )
768                 );
769 
770                 
771                 data.rewardAmount = computeNewRewardPure(
772                     newStakingShareSecondsToBurn,
773                     bonusTimestamp.sub(
774                         accountStakes[i].timestampSec
775                     ),
776                     data.rewardAmount,
777                     accounting.globalUnlockedPoolBalance,
778                     accounting.globalTotalStakingShareSeconds,
779                     withBonus
780                 );
781                 
782                 data.stakingShareSecondsToBurn = data.stakingShareSecondsToBurn.add(
783                     newStakingShareSecondsToBurn
784                 );
785                 data.sharesLeftToBurn = data.sharesLeftToBurn.sub(
786                     accountStakes[i].stakingShares
787                 );
788                 i--;
789             } else {
790                 // partially redeem a past stake
791                 newStakingShareSecondsToBurn = data.sharesLeftToBurn.mul(
792                     unlockTimestamp.sub(
793                         accountStakes[i].timestampSec
794                     )
795                 );
796 
797                 data.rewardAmount = computeNewRewardPure(
798                     newStakingShareSecondsToBurn,
799                     unlockTimestamp.sub(
800                         accountStakes[i].timestampSec
801                     ),
802                     data.rewardAmount,
803                     accounting.globalUnlockedPoolBalance,
804                     accounting.globalTotalStakingShareSeconds,
805                     withBonus
806                 );
807 
808                 data.stakingShareSecondsToBurn = data.stakingShareSecondsToBurn.add(
809                     newStakingShareSecondsToBurn
810                 );
811                 accountStakes[i]
812                     .stakingShares = accountStakes[i]
813                     .stakingShares
814                     .sub(data.sharesLeftToBurn);
815                 data.sharesLeftToBurn = 0;
816             }
817         }
818 
819         return data.rewardAmount;
820     }
821 
822     /**
823      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
824      * alotted number of distribution tokens.
825      * @param amount Number of deposit tokens to unstake / withdraw.
826      * @return The total number of distribution tokens rewarded.
827      */
828     function _unstake(uint256 amount) private returns (uint256) {
829         updateAccounting();
830 
831         // checks
832         require(amount > 0, "TokenGeyser: unstake amount is zero");
833         require(
834             totalStakedFor(msg.sender) >= amount,
835             "TokenGeyser: unstake amount is greater than total user stakes"
836         );
837 
838         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(
839             totalStaked()
840         );
841         require(
842             stakingSharesToBurn > 0,
843             "TokenGeyser: Unable to unstake amount this small"
844         );
845 
846         // 1. User Accounting
847         UserTotals storage totals = _userTotals[msg.sender];
848         Stake[] storage accountStakes = _userStakes[msg.sender];
849 
850         // Redeem from most recent stake and go backwards in time.
851         uint256 stakingShareSecondsToBurn = 0;
852         uint256 sharesLeftToBurn = stakingSharesToBurn;
853         uint256 rewardAmount = 0;
854         while (sharesLeftToBurn > 0) {
855             Stake storage lastStake = accountStakes[accountStakes.length - 1];
856             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
857             uint256 newStakingShareSecondsToBurn = 0;
858 
859             if (lastStake.stakingShares <= sharesLeftToBurn) {
860                 // fully redeem a past stake
861                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(
862                     stakeTimeSec
863                 );
864 
865                 rewardAmount = computeNewReward(
866                     rewardAmount,
867                     newStakingShareSecondsToBurn,
868                     stakeTimeSec
869                 );
870                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
871                     newStakingShareSecondsToBurn
872                 );
873                 sharesLeftToBurn = sharesLeftToBurn.sub(
874                     lastStake.stakingShares
875                 );
876                 accountStakes.length--;
877             } else {
878                 // partially redeem a past stake
879                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(
880                     stakeTimeSec
881                 );
882                 rewardAmount = computeNewReward(
883                     rewardAmount,
884                     newStakingShareSecondsToBurn,
885                     stakeTimeSec
886                 );
887 
888                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
889                     newStakingShareSecondsToBurn
890                 );
891                 lastStake.stakingShares = lastStake.stakingShares.sub(
892                     sharesLeftToBurn
893                 );
894                 sharesLeftToBurn = 0;
895             }
896         }
897         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(
898             stakingShareSecondsToBurn
899         );
900         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
901         // Already set in updateAccounting
902         // totals.lastAccountingTimestampSec = now;
903 
904         // 2. Global Accounting
905         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(
906             stakingShareSecondsToBurn
907         );
908         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
909         // Already set in updateAccounting
910         // _lastAccountingTimestampSec = now;
911 
912         // interactions
913         require(
914             _stakingPool.transfer(msg.sender, amount),
915             "TokenGeyser: transfer out of staking pool failed"
916         );
917         require(
918             _unlockedPool.transfer(msg.sender, rewardAmount),
919             "TokenGeyser: transfer out of unlocked pool failed"
920         );
921 
922         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
923         emit TokensClaimed(msg.sender, rewardAmount);
924 
925         require(
926             totalStakingShares == 0 || totalStaked() > 0,
927             "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do"
928         );
929         return rewardAmount;
930     }
931 
932     /**
933      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
934      *      encourage long-term deposits instead of constant unstake/restakes.
935      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
936      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
937      * @param currentRewardTokens The current number of distribution tokens already alotted for this
938      *                            unstake op. Any bonuses are already applied.
939      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
940      *                            distribution tokens.
941      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
942      *                     the time-bonus.
943      * @return Updated amount of distribution tokens to award, with any bonus included on the
944      *         newly added tokens.
945      */
946     function computeNewReward(
947         uint256 currentRewardTokens,
948         uint256 stakingShareSeconds,
949         uint256 stakeTimeSec
950     ) private view returns (uint256) {
951         uint256 newRewardTokens = totalUnlocked().mul(stakingShareSeconds).div(
952             _totalStakingShareSeconds
953         );
954 
955         if (stakeTimeSec >= bonusPeriodSec) {
956             return currentRewardTokens.add(newRewardTokens);
957         }
958 
959         uint256 oneHundredPct = 10**BONUS_DECIMALS;
960 
961         uint256 growthFactor = stakeTimeSec.mul(oneHundredPct).div(bonusPeriodSec);
962 
963         uint256 term1 = (startBonus*oneHundredPct**3).div(oneHundredPct).mul(newRewardTokens);
964         uint256 term2 = (oneHundredPct.sub(startBonus).mul(growthParamX).mul(growthFactor**2)*oneHundredPct**3).div(oneHundredPct**3).mul(newRewardTokens);
965         uint256 term3 = (oneHundredPct.sub(startBonus).mul(growthParamY).mul(growthFactor)*oneHundredPct**3).div(oneHundredPct**2).mul(newRewardTokens);
966 
967         uint256 bonusedReward = term1.add(term2).add(term3).div(oneHundredPct**3);
968 
969         return currentRewardTokens.add(bonusedReward);
970     }
971 
972     /**
973      * @param addr The user to look up staking information for.
974      * @return The number of staking tokens deposited for addr.
975      */
976     function totalStakedFor(address addr) public view returns (uint256) {
977         return
978             totalStakingShares > 0
979                 ? totalStaked().mul(_userTotals[addr].stakingShares).div(
980                     totalStakingShares
981                 )
982                 : 0;
983     }
984 
985     /**
986      * @return The total number of deposit tokens staked globally, by all users.
987      */
988     function totalStaked() public view returns (uint256) {
989         return _stakingPool.balance();
990     }
991 
992     /**
993      * @dev Note that this application has a staking token as well as a distribution token, which
994      * may be different. This function is required by EIP-900.
995      * @return The deposit token used for staking.
996      */
997     function token() external view returns (address) {
998         return address(getStakingToken());
999     }
1000 
1001     /**
1002      * @dev A globally callable function to update the accounting state of the system.
1003      *      Global state and state for the caller are updated.
1004      * @return [0] balance of the locked pool
1005      * @return [1] balance of the unlocked pool
1006      * @return [2] caller's staking share seconds
1007      * @return [3] global staking share seconds
1008      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
1009      * @return [5] block timestamp
1010      */
1011     function updateAccounting()
1012         public
1013         returns (
1014             uint256,
1015             uint256,
1016             uint256,
1017             uint256,
1018             uint256,
1019             uint256
1020         )
1021     {
1022         unlockTokens();
1023 
1024         // Global accounting
1025         uint256 newStakingShareSeconds = now
1026             .sub(_lastAccountingTimestampSec)
1027             .mul(totalStakingShares);
1028         _totalStakingShareSeconds = _totalStakingShareSeconds.add(
1029             newStakingShareSeconds
1030         );
1031         _lastAccountingTimestampSec = now;
1032 
1033         // User Accounting
1034         UserTotals storage totals = _userTotals[msg.sender];
1035         uint256 newUserStakingShareSeconds = now
1036             .sub(totals.lastAccountingTimestampSec)
1037             .mul(totals.stakingShares);
1038         totals.stakingShareSeconds = totals.stakingShareSeconds.add(
1039             newUserStakingShareSeconds
1040         );
1041         totals.lastAccountingTimestampSec = now;
1042 
1043         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
1044             ? totalUnlocked().mul(totals.stakingShareSeconds).div(
1045                 _totalStakingShareSeconds
1046             )
1047             : 0;
1048 
1049         emit AccountingUpdated();
1050 
1051         return (
1052             totalLocked(),
1053             totalUnlocked(),
1054             totals.stakingShareSeconds,
1055             _totalStakingShareSeconds,
1056             totalUserRewards,
1057             now
1058         );
1059     }
1060 
1061     /**
1062      * @return Total number of locked distribution tokens.
1063      */
1064     function totalLocked() public view returns (uint256) {
1065         return _lockedPool.balance();
1066     }
1067 
1068     /**
1069      * @return Total number of unlocked distribution tokens.
1070      */
1071     function totalUnlocked() public view returns (uint256) {
1072         return _unlockedPool.balance();
1073     }
1074 
1075     /**
1076      * @return Number of unlock schedules.
1077      */
1078     function unlockScheduleCount() public view returns (uint256) {
1079         return unlockSchedules.length;
1080     }
1081 
1082     /**
1083      * @dev This function allows anyone to add more locked distribution tokens, along
1084      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
1085      *      linearly over the duration of durationSec timeframe.
1086      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
1087      * @param durationSec Length of time to linear unlock the tokens.
1088      */
1089     function lockTokens(uint256 amount, uint256 durationSec)
1090         external
1091     {
1092         require(
1093             unlockSchedules.length < _maxUnlockSchedules,
1094             "Reached maximum unlock schedules"
1095         );
1096 
1097         uint256 minTokenAmount = 1000000;
1098 
1099         require(
1100             amount >= minTokenAmount.mul((10**uint256(18))),
1101             "Amount too low for unlock schedule"
1102         );
1103 
1104         // Update lockedTokens amount before using it in computations after.
1105         updateAccounting();
1106 
1107         uint256 lockedTokens = totalLocked();
1108         uint256 mintedLockedShares = (lockedTokens > 0)
1109             ? totalLockedShares.mul(amount).div(lockedTokens)
1110             : amount.mul(_initialSharesPerToken);
1111 
1112         UnlockSchedule memory schedule;
1113         schedule.initialLockedShares = mintedLockedShares;
1114         schedule.lastUnlockTimestampSec = now;
1115         schedule.endAtSec = now.add(durationSec);
1116         schedule.durationSec = durationSec;
1117         unlockSchedules.push(schedule);
1118 
1119         totalLockedShares = totalLockedShares.add(mintedLockedShares);
1120 
1121         require(
1122             _lockedPool.token().transferFrom(
1123                 msg.sender,
1124                 address(_lockedPool),
1125                 amount
1126             ),
1127             "TokenGeyser: transfer into locked pool failed"
1128         );
1129         emit TokensLocked(amount, durationSec, totalLocked());
1130     }
1131 
1132     /**
1133      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
1134      *      previously defined unlock schedules. Publicly callable.
1135      * @return Number of newly unlocked distribution tokens.
1136      */
1137     function unlockTokens() public returns (uint256) {
1138         uint256 unlockedTokens = 0;
1139         uint256 lockedTokens = totalLocked();
1140 
1141         if (totalLockedShares == 0) {
1142             unlockedTokens = lockedTokens;
1143         } else {
1144             uint256 unlockedShares = 0;
1145             for (uint256 s = 0; s < unlockSchedules.length; s++) {
1146                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
1147             }
1148             unlockedTokens = unlockedShares.mul(lockedTokens).div(
1149                 totalLockedShares
1150             );
1151             totalLockedShares = totalLockedShares.sub(unlockedShares);
1152         }
1153 
1154         if (unlockedTokens > 0) {
1155             require(
1156                 _lockedPool.transfer(address(_unlockedPool), unlockedTokens),
1157                 "TokenGeyser: transfer out of locked pool failed"
1158             );
1159             emit TokensUnlocked(unlockedTokens, totalLocked());
1160         }
1161 
1162         return unlockedTokens;
1163     }
1164 
1165     /**
1166      * @dev Returns the number of unlockable shares from a given schedule. The returned value
1167      *      depends on the time since the last unlock. This function updates schedule accounting,
1168      *      but does not actually transfer any tokens.
1169      * @param s Index of the unlock schedule.
1170      * @return The number of unlocked shares.
1171      */
1172     function unlockScheduleShares(uint256 s) private returns (uint256) {
1173         UnlockSchedule storage schedule = unlockSchedules[s];
1174 
1175         if (schedule.unlockedShares >= schedule.initialLockedShares) {
1176             return 0;
1177         }
1178 
1179         uint256 sharesToUnlock = 0;
1180         // Special case to handle any leftover dust from integer division
1181         if (now >= schedule.endAtSec) {
1182             sharesToUnlock = (
1183                 schedule.initialLockedShares.sub(schedule.unlockedShares)
1184             );
1185             schedule.lastUnlockTimestampSec = schedule.endAtSec;
1186         } else {
1187             sharesToUnlock = now
1188                 .sub(schedule.lastUnlockTimestampSec)
1189                 .mul(schedule.initialLockedShares)
1190                 .div(schedule.durationSec);
1191             schedule.lastUnlockTimestampSec = now;
1192         }
1193 
1194         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
1195         return sharesToUnlock;
1196     }
1197 }