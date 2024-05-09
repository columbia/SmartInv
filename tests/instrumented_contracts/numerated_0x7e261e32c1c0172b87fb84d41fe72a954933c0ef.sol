1 pragma solidity 0.5.17;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      *
114      * _Available since v2.4.0._
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 /**
160  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
161  * the optional functions; to access them see {ERC20Detailed}.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 
235 /*
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with GSN meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 contract Context {
246     // Empty internal constructor, to prevent people from mistakenly deploying
247     // an instance of this contract, which should be used via inheritance.
248     constructor () internal { }
249     // solhint-disable-previous-line no-empty-blocks
250 
251     function _msgSender() internal view returns (address payable) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view returns (bytes memory) {
256         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
257         return msg.data;
258     }
259 }
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor () internal {
278         _owner = _msgSender();
279         emit OwnershipTransferred(address(0), _owner);
280     }
281 
282     /**
283      * @dev Returns the address of the current owner.
284      */
285     function owner() public view returns (address) {
286         return _owner;
287     }
288 
289     /**
290      * @dev Throws if called by any account other than the owner.
291      */
292     modifier onlyOwner() {
293         require(isOwner(), "Ownable: caller is not the owner");
294         _;
295     }
296 
297     /**
298      * @dev Returns true if the caller is the current owner.
299      */
300     function isOwner() public view returns (bool) {
301         return _msgSender() == _owner;
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public onlyOwner {
312         emit OwnershipTransferred(_owner, address(0));
313         _owner = address(0);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Can only be called by the current owner.
319      */
320     function transferOwnership(address newOwner) public onlyOwner {
321         _transferOwnership(newOwner);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      */
327     function _transferOwnership(address newOwner) internal {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333 
334 
335 /**
336  * @title Staking interface, as defined by EIP-900.
337  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
338  */
339 contract IStaking {
340     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
341     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
342 
343     function stake(uint256 amount, bytes calldata data) external;
344     function stakeFor(address user, uint256 amount, bytes calldata data) external;
345     function unstake(uint256 amount, bytes calldata data) external;
346     function totalStakedFor(address addr) public view returns (uint256);
347     function totalStaked() public view returns (uint256);
348     function token() external view returns (address);
349 
350     /**
351      * @return False. This application does not support staking history.
352      */
353     function supportsHistory() external pure returns (bool) {
354         return false;
355     }
356 }
357 
358 
359 /**
360  * @title A simple holder of tokens.
361  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
362  * needs to hold multiple distinct pools of the same token.
363  */
364 contract TokenPool is Ownable {
365     IERC20 public token;
366 
367     constructor(IERC20 _token) public {
368         token = _token;
369     }
370 
371     function balance() public view returns (uint256) {
372         return token.balanceOf(address(this));
373     }
374 
375     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
376         return token.transfer(to, value);
377     }
378 }
379 
380 /**
381  * @title Token Geyser
382  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
383  *      Compound and Uniswap.
384  *
385  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
386  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
387  *      claimed by users.
388  *
389  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
390  *      is a function of the number of tokens deposited as well as the length of time deposited.
391  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
392  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
393  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
394  *
395  *      More background and motivation available at:
396  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
397  */
398 contract TokenGeyser is IStaking, Ownable {
399     using SafeMath for uint256;
400 
401     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
402     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
403     event TokensClaimed(address indexed user, uint256 amount);
404     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
405     // amount: Unlocked tokens, total: Total locked tokens
406     event TokensUnlocked(uint256 amount, uint256 total);
407 
408     TokenPool private _lockedPool;
409     TokenPool private _unlockedPool;
410     TokenPool private _stakingPool;
411 
412     //
413     // Time-bonus params
414     //
415     uint256 public constant BONUS_DECIMALS = 2;
416     uint256 public startBonus = 0;
417     uint256 public bonusPeriodSec = 0;
418 
419     //
420     // Global accounting state
421     //
422     uint256 public totalLockedShares = 0;
423     uint256 public totalStakingShares = 0;
424     uint256 private _totalStakingShareSeconds = 0;
425     uint256 private _lastAccountingTimestampSec = now;
426     uint256 private _maxUnlockSchedules = 0;
427     uint256 private _initialSharesPerToken = 0;
428 
429     //
430     // User accounting state
431     //
432     // Represents a single stake for a user. A user may have multiple.
433     struct Stake {
434         uint256 stakingShares;
435         uint256 timestampSec;
436     }
437 
438     // Caches aggregated values from the User->Stake[] map to save computation.
439     // If lastAccountingTimestampSec is 0, there's no entry for that user.
440     struct UserTotals {
441         uint256 stakingShares;
442         uint256 stakingShareSeconds;
443         uint256 lastAccountingTimestampSec;
444     }
445 
446     // Aggregated staking values per user
447     mapping(address => UserTotals) private _userTotals;
448 
449     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
450     mapping(address => Stake[]) private _userStakes;
451 
452     //
453     // Locked/Unlocked Accounting state
454     //
455     struct UnlockSchedule {
456         uint256 initialLockedShares;
457         uint256 unlockedShares;
458         uint256 lastUnlockTimestampSec;
459         uint256 endAtSec;
460         uint256 durationSec;
461     }
462 
463     UnlockSchedule[] public unlockSchedules;
464 
465     /**
466      * @param stakingToken The token users deposit as stake.
467      * @param distributionToken The token users receive as they unstake.
468      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
469      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
470      *                    e.g. 25% means user gets 25% of max distribution tokens.
471      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
472      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
473      */
474     constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
475                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {
476         // The start bonus must be some fraction of the max. (i.e. <= 100%)
477         require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');
478         // If no period is desired, instead set startBonus = 100%
479         // and bonusPeriod to a small value like 1sec.
480         require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');
481         require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');
482 
483         _stakingPool = new TokenPool(stakingToken);
484         _unlockedPool = new TokenPool(distributionToken);
485         _lockedPool = new TokenPool(distributionToken);
486         startBonus = startBonus_;
487         bonusPeriodSec = bonusPeriodSec_;
488         _maxUnlockSchedules = maxUnlockSchedules;
489         _initialSharesPerToken = initialSharesPerToken;
490     }
491 
492     /**
493      * @return The token users deposit as stake.
494      */
495     function getStakingToken() public view returns (IERC20) {
496         return _stakingPool.token();
497     }
498 
499     /**
500      * @return The token users receive as they unstake.
501      */
502     function getDistributionToken() public view returns (IERC20) {
503         assert(_unlockedPool.token() == _lockedPool.token());
504         return _unlockedPool.token();
505     }
506 
507     /**
508      * @dev Transfers amount of deposit tokens from the user.
509      * @param amount Number of deposit tokens to stake.
510      * @param data Not used.
511      */
512     function stake(uint256 amount, bytes calldata data) external {
513         _stakeFor(msg.sender, msg.sender, amount);
514     }
515 
516     /**
517      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
518      * @param user User address who gains credit for this stake operation.
519      * @param amount Number of deposit tokens to stake.
520      * @param data Not used.
521      */
522     function stakeFor(address user, uint256 amount, bytes calldata data) external onlyOwner {
523         _stakeFor(msg.sender, user, amount);
524     }
525 
526     /**
527      * @dev Private implementation of staking methods.
528      * @param staker User address who deposits tokens to stake.
529      * @param beneficiary User address who gains credit for this stake operation.
530      * @param amount Number of deposit tokens to stake.
531      */
532     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
533         require(amount > 0, 'TokenGeyser: stake amount is zero');
534         require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');
535         require(totalStakingShares == 0 || totalStaked() > 0,
536                 'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');
537 
538         uint256 mintedStakingShares = (totalStakingShares > 0)
539             ? totalStakingShares.mul(amount).div(totalStaked())
540             : amount.mul(_initialSharesPerToken);
541         require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');
542 
543         updateAccounting();
544 
545         // 1. User Accounting
546         UserTotals storage totals = _userTotals[beneficiary];
547         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
548         totals.lastAccountingTimestampSec = now;
549 
550         Stake memory newStake = Stake(mintedStakingShares, now);
551         _userStakes[beneficiary].push(newStake);
552 
553         // 2. Global Accounting
554         totalStakingShares = totalStakingShares.add(mintedStakingShares);
555         // Already set in updateAccounting()
556         // _lastAccountingTimestampSec = now;
557 
558         // interactions
559         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
560             'TokenGeyser: transfer into staking pool failed');
561 
562         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
563     }
564 
565     /**
566      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
567      * alotted number of distribution tokens.
568      * @param amount Number of deposit tokens to unstake / withdraw.
569      * @param data Not used.
570      */
571     function unstake(uint256 amount, bytes calldata data) external {
572         _unstake(amount);
573     }
574 
575     /**
576      * @param amount Number of deposit tokens to unstake / withdraw.
577      * @return The total number of distribution tokens that would be rewarded.
578      */
579     function unstakeQuery(uint256 amount) public returns (uint256) {
580         return _unstake(amount);
581     }
582 
583     /**
584      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
585      * alotted number of distribution tokens.
586      * @param amount Number of deposit tokens to unstake / withdraw.
587      * @return The total number of distribution tokens rewarded.
588      */
589     function _unstake(uint256 amount) private returns (uint256) {
590         updateAccounting();
591 
592         // checks
593         require(amount > 0, 'TokenGeyser: unstake amount is zero');
594         require(totalStakedFor(msg.sender) >= amount,
595             'TokenGeyser: unstake amount is greater than total user stakes');
596         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
597         require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');
598 
599         // 1. User Accounting
600         UserTotals storage totals = _userTotals[msg.sender];
601         Stake[] storage accountStakes = _userStakes[msg.sender];
602 
603         // Redeem from most recent stake and go backwards in time.
604         uint256 stakingShareSecondsToBurn = 0;
605         uint256 sharesLeftToBurn = stakingSharesToBurn;
606         uint256 rewardAmount = 0;
607         while (sharesLeftToBurn > 0) {
608             Stake storage lastStake = accountStakes[accountStakes.length - 1];
609             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
610             uint256 newStakingShareSecondsToBurn = 0;
611             if (lastStake.stakingShares <= sharesLeftToBurn) {
612                 // fully redeem a past stake
613                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
614                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
615                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
616                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
617                 accountStakes.length--;
618             } else {
619                 // partially redeem a past stake
620                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
621                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
622                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
623                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
624                 sharesLeftToBurn = 0;
625             }
626         }
627         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
628         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
629         // Already set in updateAccounting
630         // totals.lastAccountingTimestampSec = now;
631 
632         // 2. Global Accounting
633         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
634         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
635         // Already set in updateAccounting
636         // _lastAccountingTimestampSec = now;
637 
638         // interactions
639         require(_stakingPool.transfer(msg.sender, amount),
640             'TokenGeyser: transfer out of staking pool failed');
641         require(_unlockedPool.transfer(msg.sender, rewardAmount),
642             'TokenGeyser: transfer out of unlocked pool failed');
643 
644         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
645         emit TokensClaimed(msg.sender, rewardAmount);
646 
647         require(totalStakingShares == 0 || totalStaked() > 0,
648                 "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");
649         return rewardAmount;
650     }
651 
652     /**
653      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
654      *      encourage long-term deposits instead of constant unstake/restakes.
655      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
656      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
657      * @param currentRewardTokens The current number of distribution tokens already alotted for this
658      *                            unstake op. Any bonuses are already applied.
659      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
660      *                            distribution tokens.
661      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
662      *                     the time-bonus.
663      * @return Updated amount of distribution tokens to award, with any bonus included on the
664      *         newly added tokens.
665      */
666     function computeNewReward(uint256 currentRewardTokens,
667                                 uint256 stakingShareSeconds,
668                                 uint256 stakeTimeSec) private view returns (uint256) {
669 
670         uint256 newRewardTokens =
671             totalUnlocked()
672             .mul(stakingShareSeconds)
673             .div(_totalStakingShareSeconds);
674 
675         if (stakeTimeSec >= bonusPeriodSec) {
676             return currentRewardTokens.add(newRewardTokens);
677         }
678 
679         uint256 oneHundredPct = 10**BONUS_DECIMALS;
680         uint256 bonusedReward =
681             startBonus
682             .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))
683             .mul(newRewardTokens)
684             .div(oneHundredPct);
685         return currentRewardTokens.add(bonusedReward);
686     }
687 
688     /**
689      * @param addr The user to look up staking information for.
690      * @return The number of staking tokens deposited for addr.
691      */
692     function totalStakedFor(address addr) public view returns (uint256) {
693         return totalStakingShares > 0 ?
694             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
695     }
696 
697     /**
698      * @return The total number of deposit tokens staked globally, by all users.
699      */
700     function totalStaked() public view returns (uint256) {
701         return _stakingPool.balance();
702     }
703 
704     /**
705      * @dev Note that this application has a staking token as well as a distribution token, which
706      * may be different. This function is required by EIP-900.
707      * @return The deposit token used for staking.
708      */
709     function token() external view returns (address) {
710         return address(getStakingToken());
711     }
712 
713     /**
714      * @dev A globally callable function to update the accounting state of the system.
715      *      Global state and state for the caller are updated.
716      * @return [0] balance of the locked pool
717      * @return [1] balance of the unlocked pool
718      * @return [2] caller's staking share seconds
719      * @return [3] global staking share seconds
720      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
721      * @return [5] block timestamp
722      */
723     function updateAccounting() public returns (
724         uint256, uint256, uint256, uint256, uint256, uint256) {
725 
726         unlockTokens();
727 
728         // Global accounting
729         uint256 newStakingShareSeconds =
730             now
731             .sub(_lastAccountingTimestampSec)
732             .mul(totalStakingShares);
733         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
734         _lastAccountingTimestampSec = now;
735 
736         // User Accounting
737         UserTotals storage totals = _userTotals[msg.sender];
738         uint256 newUserStakingShareSeconds =
739             now
740             .sub(totals.lastAccountingTimestampSec)
741             .mul(totals.stakingShares);
742         totals.stakingShareSeconds =
743             totals.stakingShareSeconds
744             .add(newUserStakingShareSeconds);
745         totals.lastAccountingTimestampSec = now;
746 
747         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
748             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
749             : 0;
750 
751         return (
752             totalLocked(),
753             totalUnlocked(),
754             totals.stakingShareSeconds,
755             _totalStakingShareSeconds,
756             totalUserRewards,
757             now
758         );
759     }
760 
761     /**
762      * @return Total number of locked distribution tokens.
763      */
764     function totalLocked() public view returns (uint256) {
765         return _lockedPool.balance();
766     }
767 
768     /**
769      * @return Total number of unlocked distribution tokens.
770      */
771     function totalUnlocked() public view returns (uint256) {
772         return _unlockedPool.balance();
773     }
774 
775     /**
776      * @return Number of unlock schedules.
777      */
778     function unlockScheduleCount() public view returns (uint256) {
779         return unlockSchedules.length;
780     }
781 
782     /**
783      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
784      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
785      *      linearly over the duraction of durationSec timeframe.
786      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
787      * @param durationSec Length of time to linear unlock the tokens.
788      */
789     function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {
790         require(unlockSchedules.length < _maxUnlockSchedules,
791             'TokenGeyser: reached maximum unlock schedules');
792 
793         // Update lockedTokens amount before using it in computations after.
794         updateAccounting();
795 
796         uint256 lockedTokens = totalLocked();
797         uint256 mintedLockedShares = (lockedTokens > 0)
798             ? totalLockedShares.mul(amount).div(lockedTokens)
799             : amount.mul(_initialSharesPerToken);
800 
801         UnlockSchedule memory schedule;
802         schedule.initialLockedShares = mintedLockedShares;
803         schedule.lastUnlockTimestampSec = now;
804         schedule.endAtSec = now.add(durationSec);
805         schedule.durationSec = durationSec;
806         unlockSchedules.push(schedule);
807 
808         totalLockedShares = totalLockedShares.add(mintedLockedShares);
809 
810         require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),
811             'TokenGeyser: transfer into locked pool failed');
812         emit TokensLocked(amount, durationSec, totalLocked());
813     }
814 
815     /**
816      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
817      *      previously defined unlock schedules. Publicly callable.
818      * @return Number of newly unlocked distribution tokens.
819      */
820     function unlockTokens() public returns (uint256) {
821         uint256 unlockedTokens = 0;
822         uint256 lockedTokens = totalLocked();
823 
824         if (totalLockedShares == 0) {
825             unlockedTokens = lockedTokens;
826         } else {
827             uint256 unlockedShares = 0;
828             for (uint256 s = 0; s < unlockSchedules.length; s++) {
829                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
830             }
831             unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);
832             totalLockedShares = totalLockedShares.sub(unlockedShares);
833         }
834 
835         if (unlockedTokens > 0) {
836             require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),
837                 'TokenGeyser: transfer out of locked pool failed');
838             emit TokensUnlocked(unlockedTokens, totalLocked());
839         }
840 
841         return unlockedTokens;
842     }
843 
844     /**
845      * @dev Returns the number of unlockable shares from a given schedule. The returned value
846      *      depends on the time since the last unlock. This function updates schedule accounting,
847      *      but does not actually transfer any tokens.
848      * @param s Index of the unlock schedule.
849      * @return The number of unlocked shares.
850      */
851     function unlockScheduleShares(uint256 s) private returns (uint256) {
852         UnlockSchedule storage schedule = unlockSchedules[s];
853 
854         if(schedule.unlockedShares >= schedule.initialLockedShares) {
855             return 0;
856         }
857 
858         uint256 sharesToUnlock = 0;
859         // Special case to handle any leftover dust from integer division
860         if (now >= schedule.endAtSec) {
861             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
862             schedule.lastUnlockTimestampSec = schedule.endAtSec;
863         } else {
864             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
865                 .mul(schedule.initialLockedShares)
866                 .div(schedule.durationSec);
867             schedule.lastUnlockTimestampSec = now;
868         }
869 
870         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
871         return sharesToUnlock;
872     }
873 }