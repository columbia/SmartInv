1 pragma solidity 0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 /**
159  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
160  * the optional functions; to access them see {ERC20Detailed}.
161  */
162 interface IERC20 {
163     /**
164      * @dev Returns the amount of tokens in existence.
165      */
166     function totalSupply() external view returns (uint256);
167 
168     /**
169      * @dev Returns the amount of tokens owned by `account`.
170      */
171     function balanceOf(address account) external view returns (uint256);
172 
173     /**
174      * @dev Moves `amount` tokens from the caller's account to `recipient`.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transfer(address recipient, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Returns the remaining number of tokens that `spender` will be
184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
185      * zero by default.
186      *
187      * This value changes when {approve} or {transferFrom} are called.
188      */
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `sender` to `recipient` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Emitted when `value` tokens are moved from one account (`from`) to
220      * another (`to`).
221      *
222      * Note that `value` may be zero.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 value);
225 
226     /**
227      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
228      * a call to {approve}. `value` is the new allowance.
229      */
230     event Approval(address indexed owner, address indexed spender, uint256 value);
231 }
232 
233 /*
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with GSN meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 contract Context {
244     // Empty internal constructor, to prevent people from mistakenly deploying
245     // an instance of this contract, which should be used via inheritance.
246     constructor () internal { }
247     // solhint-disable-previous-line no-empty-blocks
248 
249     function _msgSender() internal view returns (address payable) {
250         return msg.sender;
251     }
252 
253     function _msgData() internal view returns (bytes memory) {
254         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
255         return msg.data;
256     }
257 }
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * This module is used through inheritance. It will make available the modifier
265  * `onlyOwner`, which can be applied to your functions to restrict their use to
266  * the owner.
267  */
268 contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     /**
274      * @dev Initializes the contract setting the deployer as the initial owner.
275      */
276     constructor () internal {
277         _owner = _msgSender();
278         emit OwnershipTransferred(address(0), _owner);
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(isOwner(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Returns true if the caller is the current owner.
298      */
299     function isOwner() public view returns (bool) {
300         return _msgSender() == _owner;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public onlyOwner {
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      */
326     function _transferOwnership(address newOwner) internal {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         emit OwnershipTransferred(_owner, newOwner);
329         _owner = newOwner;
330     }
331 }
332 
333 /**
334  * @title Staking interface, as defined by EIP-900.
335  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
336  */
337 contract IStaking {
338     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
339     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
340 
341     function stake(uint256 amount, bytes calldata data) external;
342     function stakeFor(address user, uint256 amount, bytes calldata data) external;
343     function unstake(uint256 amount, bytes calldata data) external;
344     function totalStakedFor(address addr) public view returns (uint256);
345     function totalStaked() public view returns (uint256);
346     function token() external view returns (address);
347 
348     /**
349      * @return False. This application does not support staking history.
350      */
351     function supportsHistory() external pure returns (bool) {
352         return false;
353     }
354 }
355 
356 /**
357  * @title A simple holder of tokens.
358  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
359  * needs to hold multiple distinct pools of the same token.
360  */
361 contract TokenPool is Ownable {
362     IERC20 public token;
363 
364     constructor(IERC20 _token) public {
365         token = _token;
366     }
367 
368     function balance() public view returns (uint256) {
369         return token.balanceOf(address(this));
370     }
371 
372     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
373         return token.transfer(to, value);
374     }
375 
376     function rescueFunds(address tokenToRescue, address to, uint256 amount) external onlyOwner returns (bool) {
377         require(address(token) != tokenToRescue, 'TokenPool: Cannot claim token held by the contract');
378 
379         return IERC20(tokenToRescue).transfer(to, amount);
380     }
381 }
382 
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
413     TokenPool private _unlockedPool;
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