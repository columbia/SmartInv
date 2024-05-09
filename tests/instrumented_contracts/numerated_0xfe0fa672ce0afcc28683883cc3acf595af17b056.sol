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
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
166  * the optional functions; to access them see {ERC20Detailed}.
167  */
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // File: openzeppelin-solidity/contracts/GSN/Context.sol
240 
241 pragma solidity ^0.5.0;
242 
243 /*
244  * @dev Provides information about the current execution context, including the
245  * sender of the transaction and its data. While these are generally available
246  * via msg.sender and msg.data, they should not be accessed in such a direct
247  * manner, since when dealing with GSN meta-transactions the account sending and
248  * paying for execution may not be the actual sender (as far as an application
249  * is concerned).
250  *
251  * This contract is only required for intermediate, library-like contracts.
252  */
253 contract Context {
254     // Empty internal constructor, to prevent people from mistakenly deploying
255     // an instance of this contract, which should be used via inheritance.
256     constructor () internal { }
257     // solhint-disable-previous-line no-empty-blocks
258 
259     function _msgSender() internal view returns (address payable) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view returns (bytes memory) {
264         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
265         return msg.data;
266     }
267 }
268 
269 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
270 
271 pragma solidity ^0.5.0;
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * This module is used through inheritance. It will make available the modifier
279  * `onlyOwner`, which can be applied to your functions to restrict their use to
280  * the owner.
281  */
282 contract Ownable is Context {
283     address private _owner;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287     /**
288      * @dev Initializes the contract setting the deployer as the initial owner.
289      */
290     constructor () internal {
291         _owner = _msgSender();
292         emit OwnershipTransferred(address(0), _owner);
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(isOwner(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Returns true if the caller is the current owner.
312      */
313     function isOwner() public view returns (bool) {
314         return _msgSender() == _owner;
315     }
316 
317     /**
318      * @dev Leaves the contract without owner. It will not be possible to call
319      * `onlyOwner` functions anymore. Can only be called by the current owner.
320      *
321      * NOTE: Renouncing ownership will leave the contract without an owner,
322      * thereby removing any functionality that is only available to the owner.
323      */
324     function renounceOwnership() public onlyOwner {
325         emit OwnershipTransferred(_owner, address(0));
326         _owner = address(0);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public onlyOwner {
334         _transferOwnership(newOwner);
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      */
340     function _transferOwnership(address newOwner) internal {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         emit OwnershipTransferred(_owner, newOwner);
343         _owner = newOwner;
344     }
345 }
346 
347 // File: contracts/IStaking.sol
348 
349 pragma solidity 0.5.0;
350 
351 /**
352  * @title Staking interface, as defined by EIP-900.
353  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
354  */
355 contract IStaking {
356     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
357     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
358 
359     function stake(uint256 amount, bytes calldata data) external;
360     function stakeFor(address user, uint256 amount, bytes calldata data) external;
361     function unstake(uint256 amount, bytes calldata data) external;
362     function totalStakedFor(address addr) public view returns (uint256);
363     function totalStaked() public view returns (uint256);
364     function token() external view returns (address);
365 
366     /**
367      * @return False. This application does not support staking history.
368      */
369     function supportsHistory() external pure returns (bool) {
370         return false;
371     }
372 }
373 
374 // File: contracts/TokenPool.sol
375 
376 pragma solidity 0.5.0;
377 
378 
379 
380 /**
381  * @title A simple holder of tokens.
382  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
383  * needs to hold multiple distinct pools of the same token.
384  */
385 contract TokenPool is Ownable {
386     IERC20 public token;
387 
388     constructor(IERC20 _token) public {
389         token = _token;
390     }
391 
392     function balance() public view returns (uint256) {
393         return token.balanceOf(address(this));
394     }
395 
396     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
397         return token.transfer(to, value);
398     }
399 
400     function rescueFunds(address tokenToRescue, address to, uint256 amount) external onlyOwner returns (bool) {
401         require(address(token) != tokenToRescue, 'TokenPool: Cannot claim token held by the contract');
402 
403         return IERC20(tokenToRescue).transfer(to, amount);
404     }
405 }
406 
407 // File: contracts/TokenGeyser.sol
408 
409 pragma solidity 0.5.0;
410 
411 
412 
413 
414 
415 
416 /**
417  * @title Token Geyser
418  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
419  *      Compound and Uniswap.
420  *
421  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
422  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
423  *      claimed by users.
424  *
425  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
426  *      is a function of the number of tokens deposited as well as the length of time deposited.
427  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
428  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
429  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
430  *
431  *      A 1% withdrawal tax is applied. This tax is sent to this contracts address to be stored permanently
432  */
433 contract TokenGeyser is IStaking, Ownable {
434     using SafeMath for uint256;
435 
436     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
437     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
438     event TokensClaimed(address indexed user, uint256 amount);
439     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
440     // amount: Unlocked tokens, total: Total locked tokens
441     event TokensUnlocked(uint256 amount, uint256 total);
442 
443     TokenPool private _stakingPool;
444     TokenPool private _unlockedPool;
445     TokenPool private _lockedPool;
446 
447     //
448     // Time-bonus params
449     //
450     uint256 public constant BONUS_DECIMALS = 2;
451     uint256 public startBonus = 0;
452     uint256 public bonusPeriodSec = 0;
453 
454     //
455     // Global accounting state
456     //
457     uint256 public totalLockedShares = 0;
458     uint256 public totalStakingShares = 0;
459     uint256 private _totalStakingShareSeconds = 0;
460     uint256 private _lastAccountingTimestampSec = now;
461     uint256 private _maxUnlockSchedules = 0;
462     uint256 private _initialSharesPerToken = 0;
463 
464     //
465     // User accounting state
466     //
467     // Represents a single stake for a user. A user may have multiple.
468     struct Stake {
469         uint256 stakingShares;
470         uint256 timestampSec;
471     }
472 
473     // Caches aggregated values from the User->Stake[] map to save computation.
474     // If lastAccountingTimestampSec is 0, there's no entry for that user.
475     struct UserTotals {
476         uint256 stakingShares;
477         uint256 stakingShareSeconds;
478         uint256 lastAccountingTimestampSec;
479     }
480 
481     // Aggregated staking values per user
482     mapping(address => UserTotals) private _userTotals;
483 
484     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
485     mapping(address => Stake[]) private _userStakes;
486 
487     //
488     // Locked/Unlocked Accounting state
489     //
490     struct UnlockSchedule {
491         uint256 initialLockedShares;
492         uint256 unlockedShares;
493         uint256 lastUnlockTimestampSec;
494         uint256 endAtSec;
495         uint256 durationSec;
496     }
497 
498     UnlockSchedule[] public unlockSchedules;
499 
500     /**
501      * @param stakingToken The token users deposit as stake.
502      * @param distributionToken The token users receive as they unstake.
503      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
504      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
505      *                    e.g. 25% means user gets 25% of max distribution tokens.
506      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
507      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
508      */
509     constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
510                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {
511         // The start bonus must be some fraction of the max. (i.e. <= 100%)
512         require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');
513         // If no period is desired, instead set startBonus = 100%
514         // and bonusPeriod to a small value like 1sec.
515         require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');
516         require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');
517 
518         _stakingPool = new TokenPool(stakingToken);
519         _unlockedPool = new TokenPool(distributionToken);
520         _lockedPool = new TokenPool(distributionToken);
521         startBonus = startBonus_;
522         bonusPeriodSec = bonusPeriodSec_;
523         _maxUnlockSchedules = maxUnlockSchedules;
524         _initialSharesPerToken = initialSharesPerToken;
525     }
526 
527     /**
528      * @return The token users deposit as stake.
529      */
530     function getStakingToken() public view returns (IERC20) {
531         return _stakingPool.token();
532     }
533 
534     /**
535      * @return The token users receive as they unstake.
536      */
537     function getDistributionToken() public view returns (IERC20) {
538         assert(_unlockedPool.token() == _lockedPool.token());
539         return _unlockedPool.token();
540     }
541 
542     /**
543      * @dev Transfers amount of deposit tokens from the user.
544      * @param amount Number of deposit tokens to stake.
545      * @param data Not used.
546      */
547     function stake(uint256 amount, bytes calldata data) external {
548         _stakeFor(msg.sender, msg.sender, amount);
549     }
550 
551     /**
552      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
553      * @param user User address who gains credit for this stake operation.
554      * @param amount Number of deposit tokens to stake.
555      * @param data Not used.
556      */
557     function stakeFor(address user, uint256 amount, bytes calldata data) external onlyOwner {
558         _stakeFor(msg.sender, user, amount);
559     }
560 
561     /**
562      * @dev Private implementation of staking methods.
563      * @param staker User address who deposits tokens to stake.
564      * @param beneficiary User address who gains credit for this stake operation.
565      * @param amount Number of deposit tokens to stake.
566      */
567     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
568         require(amount > 0, 'TokenGeyser: stake amount is zero');
569         require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');
570         require(totalStakingShares == 0 || totalStaked() > 0,
571                 'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');
572 
573         uint256 mintedStakingShares = (totalStakingShares > 0)
574             ? totalStakingShares.mul(amount).div(totalStaked())
575             : amount.mul(_initialSharesPerToken);
576         require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');
577 
578         updateAccounting();
579 
580         // 1. User Accounting
581         UserTotals storage totals = _userTotals[beneficiary];
582         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
583         totals.lastAccountingTimestampSec = now;
584 
585         Stake memory newStake = Stake(mintedStakingShares, now);
586         _userStakes[beneficiary].push(newStake);
587 
588         // 2. Global Accounting
589         totalStakingShares = totalStakingShares.add(mintedStakingShares);
590         // Already set in updateAccounting()
591         // _lastAccountingTimestampSec = now;
592 
593         // interactions
594         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
595             'TokenGeyser: transfer into staking pool failed');
596 
597         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
598     }
599 
600     /**
601      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
602      * alotted number of distribution tokens.
603      * @param amount Number of deposit tokens to unstake / withdraw.
604      * @param data Not used.
605      */
606     function unstake(uint256 amount, bytes calldata data) external {
607         _unstake(amount);
608     }
609 
610     /**
611      * @param amount Number of deposit tokens to unstake / withdraw.
612      * @return The total number of distribution tokens that would be rewarded.
613      */
614     function unstakeQuery(uint256 amount) public returns (uint256) {
615         return _unstake(amount);
616     }
617 
618     /**
619      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
620      * alotted number of distribution tokens.
621      * @param amount Number of deposit tokens to unstake / withdraw.
622      * @return The total number of distribution tokens rewarded.
623      */
624     function _unstake(uint256 amount) private returns (uint256) {
625         updateAccounting();
626 
627         // checks
628         require(amount > 0, 'TokenGeyser: unstake amount is zero');
629         require(totalStakedFor(msg.sender) >= amount,
630             'TokenGeyser: unstake amount is greater than total user stakes');
631         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
632         require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');
633 
634         // 1. User Accounting
635         UserTotals storage totals = _userTotals[msg.sender];
636         Stake[] storage accountStakes = _userStakes[msg.sender];
637 
638         // Redeem from most recent stake and go backwards in time.
639         uint256 stakingShareSecondsToBurn = 0;
640         uint256 sharesLeftToBurn = stakingSharesToBurn;
641         uint256 rewardAmount = 0;
642         while (sharesLeftToBurn > 0) {
643             Stake storage lastStake = accountStakes[accountStakes.length - 1];
644             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
645             uint256 newStakingShareSecondsToBurn = 0;
646             if (lastStake.stakingShares <= sharesLeftToBurn) {
647                 // fully redeem a past stake
648                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
649                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
650                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
651                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
652                 accountStakes.length--;
653             } else {
654                 // partially redeem a past stake
655                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
656                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
657                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
658                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
659                 sharesLeftToBurn = 0;
660             }
661         }
662         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
663         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
664         // Already set in updateAccounting
665         // totals.lastAccountingTimestampSec = now;
666 
667         // 2. Global Accounting
668         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
669         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
670         // Already set in updateAccounting
671         // _lastAccountingTimestampSec = now;
672 
673         // unlock 99% only, leave 1% locked as a liquidity tax
674         uint256 amountMinusTax = amount.mul(99).div(100);
675         uint256 amountTax = amount.sub(amountMinusTax);
676         // interactions
677         require(_stakingPool.transfer(msg.sender, amountMinusTax),
678             'TokenGeyser: transfer out of staking pool failed');
679         require(_stakingPool.transfer(address(this), amountTax),
680             'TokenGeyser: transfer out of staking pool failed');
681         require(_unlockedPool.transfer(msg.sender, rewardAmount),
682             'TokenGeyser: transfer out of unlocked pool failed');
683 
684         emit Unstaked(msg.sender, amountMinusTax, totalStakedFor(msg.sender), "");
685         emit TokensClaimed(msg.sender, rewardAmount);
686 
687         require(totalStakingShares == 0 || totalStaked() > 0,
688                 "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");
689         return rewardAmount;
690     }
691 
692     /**
693      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
694      *      encourage long-term deposits instead of constant unstake/restakes.
695      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
696      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
697      * @param currentRewardTokens The current number of distribution tokens already alotted for this
698      *                            unstake op. Any bonuses are already applied.
699      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
700      *                            distribution tokens.
701      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
702      *                     the time-bonus.
703      * @return Updated amount of distribution tokens to award, with any bonus included on the
704      *         newly added tokens.
705      */
706     function computeNewReward(uint256 currentRewardTokens,
707                                 uint256 stakingShareSeconds,
708                                 uint256 stakeTimeSec) private view returns (uint256) {
709 
710         uint256 newRewardTokens =
711             totalUnlocked()
712             .mul(stakingShareSeconds)
713             .div(_totalStakingShareSeconds);
714 
715         if (stakeTimeSec >= bonusPeriodSec) {
716             return currentRewardTokens.add(newRewardTokens);
717         }
718 
719         uint256 oneHundredPct = 10**BONUS_DECIMALS;
720         uint256 bonusedReward =
721             startBonus
722             .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))
723             .mul(newRewardTokens)
724             .div(oneHundredPct);
725         return currentRewardTokens.add(bonusedReward);
726     }
727 
728     /**
729      * @param addr The user to look up staking information for.
730      * @return The number of staking tokens deposited for addr.
731      */
732     function totalStakedFor(address addr) public view returns (uint256) {
733         return totalStakingShares > 0 ?
734             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
735     }
736 
737     /**
738      * @return The total number of deposit tokens staked globally, by all users.
739      */
740     function totalStaked() public view returns (uint256) {
741         return _stakingPool.balance();
742     }
743 
744     /**
745      * @dev Note that this application has a staking token as well as a distribution token, which
746      * may be different. This function is required by EIP-900.
747      * @return The deposit token used for staking.
748      */
749     function token() external view returns (address) {
750         return address(getStakingToken());
751     }
752 
753     /**
754      * @dev A globally callable function to update the accounting state of the system.
755      *      Global state and state for the caller are updated.
756      * @return [0] balance of the locked pool
757      * @return [1] balance of the unlocked pool
758      * @return [2] caller's staking share seconds
759      * @return [3] global staking share seconds
760      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
761      * @return [5] block timestamp
762      */
763     function updateAccounting() public returns (
764         uint256, uint256, uint256, uint256, uint256, uint256) {
765 
766         unlockTokens();
767 
768         // Global accounting
769         uint256 newStakingShareSeconds =
770             now
771             .sub(_lastAccountingTimestampSec)
772             .mul(totalStakingShares);
773         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
774         _lastAccountingTimestampSec = now;
775 
776         // User Accounting
777         UserTotals storage totals = _userTotals[msg.sender];
778         uint256 newUserStakingShareSeconds =
779             now
780             .sub(totals.lastAccountingTimestampSec)
781             .mul(totals.stakingShares);
782         totals.stakingShareSeconds =
783             totals.stakingShareSeconds
784             .add(newUserStakingShareSeconds);
785         totals.lastAccountingTimestampSec = now;
786 
787         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
788             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
789             : 0;
790 
791         return (
792             totalLocked(),
793             totalUnlocked(),
794             totals.stakingShareSeconds,
795             _totalStakingShareSeconds,
796             totalUserRewards,
797             now
798         );
799     }
800 
801     /**
802      * @return Total number of locked distribution tokens.
803      */
804     function totalLocked() public view returns (uint256) {
805         return _lockedPool.balance();
806     }
807 
808     /**
809      * @return Total number of unlocked distribution tokens.
810      */
811     function totalUnlocked() public view returns (uint256) {
812         return _unlockedPool.balance();
813     }
814 
815     /**
816      * @return Number of unlock schedules.
817      */
818     function unlockScheduleCount() public view returns (uint256) {
819         return unlockSchedules.length;
820     }
821 
822     /**
823      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
824      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
825      *      linearly over the duraction of durationSec timeframe.
826      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
827      * @param durationSec Length of time to linear unlock the tokens.
828      */
829     function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {
830         require(unlockSchedules.length < _maxUnlockSchedules,
831             'TokenGeyser: reached maximum unlock schedules');
832 
833         // Update lockedTokens amount before using it in computations after.
834         updateAccounting();
835 
836         uint256 lockedTokens = totalLocked();
837         uint256 mintedLockedShares = (lockedTokens > 0)
838             ? totalLockedShares.mul(amount).div(lockedTokens)
839             : amount.mul(_initialSharesPerToken);
840 
841         UnlockSchedule memory schedule;
842         schedule.initialLockedShares = mintedLockedShares;
843         schedule.lastUnlockTimestampSec = now;
844         schedule.endAtSec = now.add(durationSec);
845         schedule.durationSec = durationSec;
846         unlockSchedules.push(schedule);
847 
848         totalLockedShares = totalLockedShares.add(mintedLockedShares);
849 
850         require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),
851             'TokenGeyser: transfer into locked pool failed');
852         emit TokensLocked(amount, durationSec, totalLocked());
853     }
854 
855     /**
856      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
857      *      previously defined unlock schedules. Publicly callable.
858      * @return Number of newly unlocked distribution tokens.
859      */
860     function unlockTokens() public returns (uint256) {
861         uint256 unlockedTokens = 0;
862         uint256 lockedTokens = totalLocked();
863 
864         if (totalLockedShares == 0) {
865             unlockedTokens = lockedTokens;
866         } else {
867             uint256 unlockedShares = 0;
868             for (uint256 s = 0; s < unlockSchedules.length; s++) {
869                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
870             }
871             unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);
872             totalLockedShares = totalLockedShares.sub(unlockedShares);
873         }
874 
875         if (unlockedTokens > 0) {
876             require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),
877                 'TokenGeyser: transfer out of locked pool failed');
878             emit TokensUnlocked(unlockedTokens, totalLocked());
879         }
880 
881         return unlockedTokens;
882     }
883 
884     /**
885      * @dev Returns the number of unlockable shares from a given schedule. The returned value
886      *      depends on the time since the last unlock. This function updates schedule accounting,
887      *      but does not actually transfer any tokens.
888      * @param s Index of the unlock schedule.
889      * @return The number of unlocked shares.
890      */
891     function unlockScheduleShares(uint256 s) private returns (uint256) {
892         UnlockSchedule storage schedule = unlockSchedules[s];
893 
894         if(schedule.unlockedShares >= schedule.initialLockedShares) {
895             return 0;
896         }
897 
898         uint256 sharesToUnlock = 0;
899         // Special case to handle any leftover dust from integer division
900         if (now >= schedule.endAtSec) {
901             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
902             schedule.lastUnlockTimestampSec = schedule.endAtSec;
903         } else {
904             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
905                 .mul(schedule.initialLockedShares)
906                 .div(schedule.durationSec);
907             schedule.lastUnlockTimestampSec = now;
908         }
909 
910         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
911         return sharesToUnlock;
912     }
913 
914     /**
915      * @dev Lets the owner rescue funds air-dropped to the staking pool.
916      * @param tokenToRescue Address of the token to be rescued.
917      * @param to Address to which the rescued funds are to be sent.
918      * @param amount Amount of tokens to be rescued.
919      * @return Transfer success.
920      */
921     function rescueFundsFromStakingPool(address tokenToRescue, address to, uint256 amount)
922         public onlyOwner returns (bool) {
923 
924         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
925     }
926 }