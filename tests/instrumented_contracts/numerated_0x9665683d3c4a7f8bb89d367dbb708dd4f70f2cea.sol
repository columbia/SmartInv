1 pragma solidity 0.5.0;
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
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with GSN meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 contract Context {
245     // Empty internal constructor, to prevent people from mistakenly deploying
246     // an instance of this contract, which should be used via inheritance.
247     constructor () internal { }
248     // solhint-disable-previous-line no-empty-blocks
249 
250     function _msgSender() internal view returns (address payable) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view returns (bytes memory) {
255         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256         return msg.data;
257     }
258 }
259 
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
334 /**
335  * @title Staking interface, as defined by EIP-900.
336  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
337  */
338 contract IStaking {
339     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
340     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
341 
342     function stake(uint256 amount, bytes calldata data) external;
343     function stakeFor(address user, uint256 amount, bytes calldata data) external;
344     function unstake(uint256 amount, bytes calldata data) external;
345     function totalStakedFor(address addr) public view returns (uint256);
346     function totalStaked() public view returns (uint256);
347     function token() external view returns (address);
348 
349     /**
350      * @return False. This application does not support staking history.
351      */
352     function supportsHistory() external pure returns (bool) {
353         return false;
354     }
355 }
356 
357 /**
358  * @title A simple holder of tokens.
359  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
360  * needs to hold multiple distinct pools of the same token.
361  */
362 contract TokenPool is Ownable {
363     IERC20 public token;
364 
365     constructor(IERC20 _token) public {
366         token = _token;
367     }
368 
369     function balance() public view returns (uint256) {
370         return token.balanceOf(address(this));
371     }
372 
373     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
374         return token.transfer(to, value);
375     }
376 
377     function rescueFunds(address tokenToRescue, address to, uint256 amount) external onlyOwner returns (bool) {
378         require(address(token) != tokenToRescue, 'TokenPool: Cannot claim token held by the contract');
379 
380         return IERC20(tokenToRescue).transfer(to, amount);
381     }
382 }
383 
384 /**
385  * @title Token Geyser
386  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
387  *      Compound and Uniswap.
388  *
389  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
390  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
391  *      claimed by users.
392  *
393  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
394  *      is a function of the number of tokens deposited as well as the length of time deposited.
395  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
396  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
397  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
398  *
399  *      More background and motivation available at:
400  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
401  */
402 contract TokenGeyser is IStaking, Ownable {
403     using SafeMath for uint256;
404 
405     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
406     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
407     event TokensClaimed(address indexed user, uint256 amount);
408     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
409     // amount: Unlocked tokens, total: Total locked tokens
410     event TokensUnlocked(uint256 amount, uint256 total);
411 
412     TokenPool private _stakingPool;
413     TokenPool public _unlockedPool;
414     TokenPool private _lockedPool;
415 
416     //
417     // Time-bonus params
418     //
419     uint256 public constant BONUS_DECIMALS = 2;
420     uint256 public startBonus = 0;
421     uint256 public bonusPeriodSec = 0;
422 
423     //
424     // Global accounting state
425     //
426     uint256 public totalLockedShares = 0;
427     uint256 public totalStakingShares = 0;
428     uint256 private _totalStakingShareSeconds = 0;
429     uint256 private _lastAccountingTimestampSec = now;
430     uint256 private _maxUnlockSchedules = 0;
431     uint256 private _initialSharesPerToken = 0;
432 
433     //
434     // User accounting state
435     //
436     // Represents a single stake for a user. A user may have multiple.
437     struct Stake {
438         uint256 stakingShares;
439         uint256 timestampSec;
440     }
441 
442     // Caches aggregated values from the User->Stake[] map to save computation.
443     // If lastAccountingTimestampSec is 0, there's no entry for that user.
444     struct UserTotals {
445         uint256 stakingShares;
446         uint256 stakingShareSeconds;
447         uint256 lastAccountingTimestampSec;
448     }
449 
450     // Aggregated staking values per user
451     mapping(address => UserTotals) private _userTotals;
452 
453     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
454     mapping(address => Stake[]) private _userStakes;
455 
456     //
457     // Locked/Unlocked Accounting state
458     //
459     struct UnlockSchedule {
460         uint256 initialLockedShares;
461         uint256 unlockedShares;
462         uint256 lastUnlockTimestampSec;
463         uint256 endAtSec;
464         uint256 durationSec;
465     }
466 
467     UnlockSchedule[] public unlockSchedules;
468 
469     /**
470      * @param stakingToken The token users deposit as stake.
471      * @param distributionToken The token users receive as they unstake.
472      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
473      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
474      *                    e.g. 25% means user gets 25% of max distribution tokens.
475      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
476      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
477      */
478     constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
479                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {
480         // The start bonus must be some fraction of the max. (i.e. <= 100%)
481         require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');
482         // If no period is desired, instead set startBonus = 100%
483         // and bonusPeriod to a small value like 1sec.
484         require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');
485         require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');
486 
487         _stakingPool = new TokenPool(stakingToken);
488         _unlockedPool = new TokenPool(distributionToken);
489         _lockedPool = new TokenPool(distributionToken);
490         startBonus = startBonus_;
491         bonusPeriodSec = bonusPeriodSec_;
492         _maxUnlockSchedules = maxUnlockSchedules;
493         _initialSharesPerToken = initialSharesPerToken;
494     }
495 
496     /**
497      * @return The token users deposit as stake.
498      */
499     function getStakingToken() public view returns (IERC20) {
500         return _stakingPool.token();
501     }
502 
503     /**
504      * @return The token users receive as they unstake.
505      */
506     function getDistributionToken() public view returns (IERC20) {
507         assert(_unlockedPool.token() == _lockedPool.token());
508         return _unlockedPool.token();
509     }
510 
511     /**
512      * @dev Transfers amount of deposit tokens from the user.
513      * @param amount Number of deposit tokens to stake.
514      * @param data Not used.
515      */
516     function stake(uint256 amount, bytes calldata data) external {
517         _stakeFor(msg.sender, msg.sender, amount);
518     }
519 
520     /**
521      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
522      * @param user User address who gains credit for this stake operation.
523      * @param amount Number of deposit tokens to stake.
524      * @param data Not used.
525      */
526     function stakeFor(address user, uint256 amount, bytes calldata data) external onlyOwner {
527         _stakeFor(msg.sender, user, amount);
528     }
529 
530     /**
531      * @dev Private implementation of staking methods.
532      * @param staker User address who deposits tokens to stake.
533      * @param beneficiary User address who gains credit for this stake operation.
534      * @param amount Number of deposit tokens to stake.
535      */
536     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
537         require(amount > 0, 'TokenGeyser: stake amount is zero');
538         require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');
539         require(totalStakingShares == 0 || totalStaked() > 0,
540                 'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');
541 
542         uint256 mintedStakingShares = (totalStakingShares > 0)
543             ? totalStakingShares.mul(amount).div(totalStaked())
544             : amount.mul(_initialSharesPerToken);
545         require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');
546 
547         updateAccounting();
548 
549         // 1. User Accounting
550         UserTotals storage totals = _userTotals[beneficiary];
551         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
552         totals.lastAccountingTimestampSec = now;
553 
554         Stake memory newStake = Stake(mintedStakingShares, now);
555         _userStakes[beneficiary].push(newStake);
556 
557         // 2. Global Accounting
558         totalStakingShares = totalStakingShares.add(mintedStakingShares);
559         // Already set in updateAccounting()
560         // _lastAccountingTimestampSec = now;
561 
562         // interactions
563         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
564             'TokenGeyser: transfer into staking pool failed');
565 
566         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
567     }
568 
569     /**
570      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
571      * alotted number of distribution tokens.
572      * @param amount Number of deposit tokens to unstake / withdraw.
573      * @param data Not used.
574      */
575     function unstake(uint256 amount, bytes calldata data) external {
576         _unstake(amount);
577     }
578 
579     /**
580      * @param amount Number of deposit tokens to unstake / withdraw.
581      * @return The total number of distribution tokens that would be rewarded.
582      */
583     function unstakeQuery(uint256 amount) public returns (uint256) {
584         return _unstake(amount);
585     }
586 
587     /**
588      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
589      * alotted number of distribution tokens.
590      * @param amount Number of deposit tokens to unstake / withdraw.
591      * @return The total number of distribution tokens rewarded.
592      */
593     function _unstake(uint256 amount) private returns (uint256) {
594         updateAccounting();
595 
596         // checks
597         require(amount > 0, 'TokenGeyser: unstake amount is zero');
598         require(totalStakedFor(msg.sender) >= amount,
599             'TokenGeyser: unstake amount is greater than total user stakes');
600         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
601         require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');
602 
603         // 1. User Accounting
604         UserTotals storage totals = _userTotals[msg.sender];
605         Stake[] storage accountStakes = _userStakes[msg.sender];
606 
607         // Redeem from most recent stake and go backwards in time.
608         uint256 stakingShareSecondsToBurn = 0;
609         uint256 sharesLeftToBurn = stakingSharesToBurn;
610         uint256 rewardAmount = 0;
611         while (sharesLeftToBurn > 0) {
612             Stake storage lastStake = accountStakes[accountStakes.length - 1];
613             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
614             uint256 newStakingShareSecondsToBurn = 0;
615             if (lastStake.stakingShares <= sharesLeftToBurn) {
616                 // fully redeem a past stake
617                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
618                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
619                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
620                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
621                 accountStakes.length--;
622             } else {
623                 // partially redeem a past stake
624                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
625                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
626                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
627                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
628                 sharesLeftToBurn = 0;
629             }
630         }
631         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
632         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
633         // Already set in updateAccounting
634         // totals.lastAccountingTimestampSec = now;
635 
636         // 2. Global Accounting
637         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
638         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
639         // Already set in updateAccounting
640         // _lastAccountingTimestampSec = now;
641 
642         // interactions
643         require(_stakingPool.transfer(msg.sender, amount),
644             'TokenGeyser: transfer out of staking pool failed');
645         require(_unlockedPool.transfer(msg.sender, rewardAmount),
646             'TokenGeyser: transfer out of unlocked pool failed');
647 
648         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
649         emit TokensClaimed(msg.sender, rewardAmount);
650 
651         require(totalStakingShares == 0 || totalStaked() > 0,
652                 "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");
653         return rewardAmount;
654     }
655 
656     /**
657      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
658      *      encourage long-term deposits instead of constant unstake/restakes.
659      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
660      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
661      * @param currentRewardTokens The current number of distribution tokens already alotted for this
662      *                            unstake op. Any bonuses are already applied.
663      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
664      *                            distribution tokens.
665      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
666      *                     the time-bonus.
667      * @return Updated amount of distribution tokens to award, with any bonus included on the
668      *         newly added tokens.
669      */
670     function computeNewReward(uint256 currentRewardTokens,
671                                 uint256 stakingShareSeconds,
672                                 uint256 stakeTimeSec) private view returns (uint256) {
673 
674         uint256 newRewardTokens =
675             totalUnlocked()
676             .mul(stakingShareSeconds)
677             .div(_totalStakingShareSeconds);
678 
679         if (stakeTimeSec >= bonusPeriodSec) {
680             return currentRewardTokens.add(newRewardTokens);
681         }
682 
683         uint256 oneHundredPct = 10**BONUS_DECIMALS;
684         uint256 bonusedReward =
685             startBonus
686             .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))
687             .mul(newRewardTokens)
688             .div(oneHundredPct);
689         return currentRewardTokens.add(bonusedReward);
690     }
691 
692     /**
693      * @param addr The user to look up staking information for.
694      * @return The number of staking tokens deposited for addr.
695      */
696     function totalStakedFor(address addr) public view returns (uint256) {
697         return totalStakingShares > 0 ?
698             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
699     }
700 
701     /**
702      * @return The total number of deposit tokens staked globally, by all users.
703      */
704     function totalStaked() public view returns (uint256) {
705         return _stakingPool.balance();
706     }
707 
708     /**
709      * @dev Note that this application has a staking token as well as a distribution token, which
710      * may be different. This function is required by EIP-900.
711      * @return The deposit token used for staking.
712      */
713     function token() external view returns (address) {
714         return address(getStakingToken());
715     }
716 
717     /**
718      * @dev A globally callable function to update the accounting state of the system.
719      *      Global state and state for the caller are updated.
720      * @return [0] balance of the locked pool
721      * @return [1] balance of the unlocked pool
722      * @return [2] caller's staking share seconds
723      * @return [3] global staking share seconds
724      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
725      * @return [5] block timestamp
726      */
727     function updateAccounting() public returns (
728         uint256, uint256, uint256, uint256, uint256, uint256) {
729 
730         unlockTokens();
731 
732         // Global accounting
733         uint256 newStakingShareSeconds =
734             now
735             .sub(_lastAccountingTimestampSec)
736             .mul(totalStakingShares);
737         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
738         _lastAccountingTimestampSec = now;
739 
740         // User Accounting
741         UserTotals storage totals = _userTotals[msg.sender];
742         uint256 newUserStakingShareSeconds =
743             now
744             .sub(totals.lastAccountingTimestampSec)
745             .mul(totals.stakingShares);
746         totals.stakingShareSeconds =
747             totals.stakingShareSeconds
748             .add(newUserStakingShareSeconds);
749         totals.lastAccountingTimestampSec = now;
750 
751         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
752             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
753             : 0;
754 
755         return (
756             totalLocked(),
757             totalUnlocked(),
758             totals.stakingShareSeconds,
759             _totalStakingShareSeconds,
760             totalUserRewards,
761             now
762         );
763     }
764 
765     /**
766      * @return Total number of locked distribution tokens.
767      */
768     function totalLocked() public view returns (uint256) {
769         return _lockedPool.balance();
770     }
771 
772     /**
773      * @return Total number of unlocked distribution tokens.
774      */
775     function totalUnlocked() public view returns (uint256) {
776         return _unlockedPool.balance();
777     }
778 
779     /**
780      * @return Number of unlock schedules.
781      */
782     function unlockScheduleCount() public view returns (uint256) {
783         return unlockSchedules.length;
784     }
785 
786     /**
787      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
788      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
789      *      linearly over the duraction of durationSec timeframe.
790      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
791      * @param durationSec Length of time to linear unlock the tokens.
792      */
793     function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {
794         require(unlockSchedules.length < _maxUnlockSchedules,
795             'TokenGeyser: reached maximum unlock schedules');
796 
797         // Update lockedTokens amount before using it in computations after.
798         updateAccounting();
799 
800         uint256 lockedTokens = totalLocked();
801         uint256 mintedLockedShares = (lockedTokens > 0)
802             ? totalLockedShares.mul(amount).div(lockedTokens)
803             : amount.mul(_initialSharesPerToken);
804 
805         UnlockSchedule memory schedule;
806         schedule.initialLockedShares = mintedLockedShares;
807         schedule.lastUnlockTimestampSec = now;
808         schedule.endAtSec = now.add(durationSec);
809         schedule.durationSec = durationSec;
810         unlockSchedules.push(schedule);
811 
812         totalLockedShares = totalLockedShares.add(mintedLockedShares);
813 
814         require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),
815             'TokenGeyser: transfer into locked pool failed');
816         emit TokensLocked(amount, durationSec, totalLocked());
817     }
818 
819     /**
820      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
821      *      previously defined unlock schedules. Publicly callable.
822      * @return Number of newly unlocked distribution tokens.
823      */
824     function unlockTokens() public returns (uint256) {
825         uint256 unlockedTokens = 0;
826         uint256 lockedTokens = totalLocked();
827 
828         if (totalLockedShares == 0) {
829             unlockedTokens = lockedTokens;
830         } else {
831             uint256 unlockedShares = 0;
832             for (uint256 s = 0; s < unlockSchedules.length; s++) {
833                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
834             }
835             unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);
836             totalLockedShares = totalLockedShares.sub(unlockedShares);
837         }
838 
839         if (unlockedTokens > 0) {
840             require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),
841                 'TokenGeyser: transfer out of locked pool failed');
842             emit TokensUnlocked(unlockedTokens, totalLocked());
843         }
844 
845         return unlockedTokens;
846     }
847 
848     /**
849      * @dev Returns the number of unlockable shares from a given schedule. The returned value
850      *      depends on the time since the last unlock. This function updates schedule accounting,
851      *      but does not actually transfer any tokens.
852      * @param s Index of the unlock schedule.
853      * @return The number of unlocked shares.
854      */
855     function unlockScheduleShares(uint256 s) private returns (uint256) {
856         UnlockSchedule storage schedule = unlockSchedules[s];
857 
858         if(schedule.unlockedShares >= schedule.initialLockedShares) {
859             return 0;
860         }
861 
862         uint256 sharesToUnlock = 0;
863         // Special case to handle any leftover dust from integer division
864         if (now >= schedule.endAtSec) {
865             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
866             schedule.lastUnlockTimestampSec = schedule.endAtSec;
867         } else {
868             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
869                 .mul(schedule.initialLockedShares)
870                 .div(schedule.durationSec);
871             schedule.lastUnlockTimestampSec = now;
872         }
873 
874         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
875         return sharesToUnlock;
876     }
877 
878     /**
879      * @dev Lets the owner rescue funds air-dropped to the staking pool.
880      * @param tokenToRescue Address of the token to be rescued.
881      * @param to Address to which the rescued funds are to be sent.
882      * @param amount Amount of tokens to be rescued.
883      * @return Transfer success.
884      */
885     function rescueFundsFromStakingPool(address tokenToRescue, address to, uint256 amount)
886         public onlyOwner returns (bool) {
887 
888         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
889     }
890 }
891 
892 contract AmpleSenseGeyser is TokenGeyser {
893     using SafeMath for uint256;
894 
895     event RebaseReward(uint256 amount, uint256 total);
896 
897     TokenPool private _rewardPool;
898 
899     //
900     // Rebase-bonus params
901     //
902     uint256 public constant REBASE_BONUS_DECIMALS = 3;
903     uint256 public bonusPositiveRebase = 0;
904     uint256 public bonusNegativeRebase = 0;
905 
906     uint256 public totalRewardTokens = 0;
907     
908     //
909     // Address of the AMPL contract
910     //
911     IERC20 public AMPLContract;
912 
913     //
914     // Last AMPL total supply
915     //
916     uint256 public lastAMPLTotalSupply;
917 
918     /**
919      * @param stakingToken The token users deposit as stake.
920      * @param distributionToken The token users receive as they unstake.
921      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
922      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
923      *                    e.g. 25% means user gets 25% of max distribution tokens.
924      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
925      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
926      * @param AMPLContractAddress Address of the uFragments Ampleforth ERC20
927      * @param bonusPositiveRebase_ Bonus to apply on positive rebase
928      * @param bonusNegativeRebase_ Bonus to apply on negative rebase
929      */
930     constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
931                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken,
932                 address AMPLContractAddress, uint256 bonusPositiveRebase_, uint256 bonusNegativeRebase_) public
933         TokenGeyser(stakingToken, distributionToken, maxUnlockSchedules,
934         startBonus_, bonusPeriodSec_, initialSharesPerToken) {
935         require(bonusPositiveRebase_ <= 10**REBASE_BONUS_DECIMALS, 'TokenGeyser: rebase bonus too high');
936         require(bonusNegativeRebase_ <= 10**REBASE_BONUS_DECIMALS, 'TokenGeyser: rebase bonus too high');
937         require(AMPLContractAddress != address(0), "AMPLContractAddress cannot be the zero address");
938 
939         bonusPositiveRebase = bonusPositiveRebase_;
940         bonusNegativeRebase = bonusNegativeRebase_;
941         AMPLContract = IERC20(AMPLContractAddress);
942         //init the last total supply to the AMPL total supply on creation
943         lastAMPLTotalSupply = AMPLContract.totalSupply();
944         _rewardPool = new TokenPool(distributionToken);
945     }
946 
947     /**
948     * Allows to add new reward tokens to the reward pool
949     * Contract must be allowed to transfer this amount from the caller
950     */
951     function addRewardRebase(uint256 amount) external onlyOwner {
952         totalRewardTokens = totalRewardTokens.add(amount);
953         require(getDistributionToken().transferFrom(msg.sender, address(_rewardPool), amount),
954             'TokenGeyser: transfer into reward pool failed');
955     }
956 
957     /**
958     * Public function to call after an Ampleforth AMPL token rebase
959     * The function throws if the total supply of AMPL hasn't changed since the last call.
960     */
961     function rewardRebase() public {
962         uint256 newTotalSupply = AMPLContract.totalSupply();
963         require(newTotalSupply != lastAMPLTotalSupply, "Total supply of AMPL not changed");
964         uint256 toTransfer = 0;
965         if(newTotalSupply > lastAMPLTotalSupply) {
966             toTransfer = totalRewardTokens.mul(bonusPositiveRebase).div(10**REBASE_BONUS_DECIMALS);
967             
968         } else {
969             toTransfer = totalRewardTokens.mul(bonusNegativeRebase).div(10**REBASE_BONUS_DECIMALS);
970         }
971         //handle the last reward
972         if(toTransfer > _rewardPool.balance())
973             toTransfer = _rewardPool.balance();
974         require(_rewardPool.transfer(address(_unlockedPool), toTransfer), 'TokenGeyser: transfer out of reward pool failed');
975         lastAMPLTotalSupply = newTotalSupply;
976         emit RebaseReward(toTransfer, _rewardPool.balance());
977     }
978 
979     function rewardLeft() view public returns (uint256) {
980         return _rewardPool.balance();
981     }
982 }