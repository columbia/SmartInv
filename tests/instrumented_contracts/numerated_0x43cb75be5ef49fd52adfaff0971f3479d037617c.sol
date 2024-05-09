1 pragma solidity ^0.5.0;
2 
3 /**
4  *
5  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.fi
6  *  
7  *           ____  _______  _____      __  _ 
8  *          |  _ \|__   __|/ ____|    / _|(_)
9  *      ___ | |_) |  | |  | |        | |_  _ 
10  *     / __||  _ <   | |  | |        |  _|| |
11  *     \__ \| |_) |  | |  | |____  _ | |  | |
12  *     |___/|____/   |_|   \_____|(_)|_|  |_|
13  *                                           
14  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.fi                                     
15  *
16 **/
17 
18 
19 /**
20  * @dev Wrappers over Solidity's arithmetic operations with added overflow
21  * checks.
22  *
23  * Arithmetic operations in Solidity wrap on overflow. This can easily result
24  * in bugs, because programmers usually assume that an overflow raises an
25  * error, which is the standard behavior in high level programming languages.
26  * `SafeMath` restores this intuition by reverting the transaction when an
27  * operation overflows.
28  *
29  * Using this library instead of the unchecked operations eliminates an entire
30  * class of bugs, so it's recommended to use it always.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, reverting on
35      * overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      * - Addition cannot overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      *
71      * _Available since v2.4.0._
72      */
73     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the multiplication of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `*` operator.
85      *
86      * Requirements:
87      * - Multiplication cannot overflow.
88      */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91         // benefit is lost if 'b' is also tested.
92         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
93         if (a == 0) {
94             return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      * - The divisor cannot be zero.
128      *
129      * _Available since v2.4.0._
130      */
131     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         // Solidity only automatically asserts when dividing by 0
133         require(b > 0, errorMessage);
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         return mod(a, b, "SafeMath: modulo by zero");
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts with custom message when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      *
166      * _Available since v2.4.0._
167      */
168     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b != 0, errorMessage);
170         return a % b;
171     }
172 }
173 
174 /**
175  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
176  * the optional functions; to access them see {ERC20Detailed}.
177  */
178 interface IERC20 {
179     /**
180      * @dev Returns the amount of tokens in existence.
181      */
182     function totalSupply() external view returns (uint256);
183 
184     /**
185      * @dev Returns the amount of tokens owned by `account`.
186      */
187     function balanceOf(address account) external view returns (uint256);
188 
189     /**
190      * @dev Moves `amount` tokens from the caller's account to `recipient`.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transfer(address recipient, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Returns the remaining number of tokens that `spender` will be
200      * allowed to spend on behalf of `owner` through {transferFrom}. This is
201      * zero by default.
202      *
203      * This value changes when {approve} or {transferFrom} are called.
204      */
205     function allowance(address owner, address spender) external view returns (uint256);
206 
207     /**
208      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * IMPORTANT: Beware that changing an allowance with this method brings the risk
213      * that someone may use both the old and the new allowance by unfortunate
214      * transaction ordering. One possible solution to mitigate this race
215      * condition is to first reduce the spender's allowance to 0 and set the
216      * desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      *
219      * Emits an {Approval} event.
220      */
221     function approve(address spender, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Moves `amount` tokens from `sender` to `recipient` using the
225      * allowance mechanism. `amount` is then deducted from the caller's
226      * allowance.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * Emits a {Transfer} event.
231      */
232     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Emitted when `value` tokens are moved from one account (`from`) to
236      * another (`to`).
237      *
238      * Note that `value` may be zero.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 value);
241 
242     /**
243      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
244      * a call to {approve}. `value` is the new allowance.
245      */
246     event Approval(address indexed owner, address indexed spender, uint256 value);
247 }
248 
249 /*
250  * @dev Provides information about the current execution context, including the
251  * sender of the transaction and its data. While these are generally available
252  * via msg.sender and msg.data, they should not be accessed in such a direct
253  * manner, since when dealing with GSN meta-transactions the account sending and
254  * paying for execution may not be the actual sender (as far as an application
255  * is concerned).
256  *
257  * This contract is only required for intermediate, library-like contracts.
258  */
259 contract Context {
260     // Empty internal constructor, to prevent people from mistakenly deploying
261     // an instance of this contract, which should be used via inheritance.
262     constructor () internal { }
263     // solhint-disable-previous-line no-empty-blocks
264 
265     function _msgSender() internal view returns (address payable) {
266         return msg.sender;
267     }
268 
269     function _msgData() internal view returns (bytes memory) {
270         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
271         return msg.data;
272     }
273 }
274 
275 /**
276  * @dev Contract module which provides a basic access control mechanism, where
277  * there is an account (an owner) that can be granted exclusive access to
278  * specific functions.
279  *
280  * This module is used through inheritance. It will make available the modifier
281  * `onlyOwner`, which can be applied to your functions to restrict their use to
282  * the owner.
283  */
284 contract Ownable is Context {
285     address private _owner;
286 
287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289     /**
290      * @dev Initializes the contract setting the deployer as the initial owner.
291      */
292     constructor () internal {
293         _owner = _msgSender();
294         emit OwnershipTransferred(address(0), _owner);
295     }
296 
297     /**
298      * @dev Returns the address of the current owner.
299      */
300     function owner() public view returns (address) {
301         return _owner;
302     }
303 
304     /**
305      * @dev Throws if called by any account other than the owner.
306      */
307     modifier onlyOwner() {
308         require(isOwner(), "Ownable: caller is not the owner");
309         _;
310     }
311 
312     /**
313      * @dev Returns true if the caller is the current owner.
314      */
315     function isOwner() public view returns (bool) {
316         return _msgSender() == _owner;
317     }
318 
319     /**
320      * @dev Leaves the contract without owner. It will not be possible to call
321      * `onlyOwner` functions anymore. Can only be called by the current owner.
322      *
323      * NOTE: Renouncing ownership will leave the contract without an owner,
324      * thereby removing any functionality that is only available to the owner.
325      */
326     function renounceOwnership() public onlyOwner {
327         emit OwnershipTransferred(_owner, address(0));
328         _owner = address(0);
329     }
330 
331     /**
332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
333      * Can only be called by the current owner.
334      */
335     function transferOwnership(address newOwner) public onlyOwner {
336         _transferOwnership(newOwner);
337     }
338 
339     /**
340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
341      */
342     function _transferOwnership(address newOwner) internal {
343         require(newOwner != address(0), "Ownable: new owner is the zero address");
344         emit OwnershipTransferred(_owner, newOwner);
345         _owner = newOwner;
346     }
347 }
348 
349 /**
350  * @title Staking interface, as defined by EIP-900.
351  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
352  */
353 contract IStaking {
354     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
355     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
356 
357     function stake(uint256 amount, bytes calldata data) external;
358     function stakeFor(address user, uint256 amount, bytes calldata data) external;
359     function unstake(uint256 amount, bytes calldata data) external;
360     function totalStakedFor(address addr) public view returns (uint256);
361     function totalStaked() public view returns (uint256);
362     function token() external view returns (address);
363 
364     /**
365      * @return False. This application does not support staking history.
366      */
367     function supportsHistory() external pure returns (bool) {
368         return false;
369     }
370 }
371 
372 /**
373  * @title A simple holder of tokens.
374  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
375  * needs to hold multiple distinct pools of the same token.
376  */
377 contract TokenPool is Ownable {
378     IERC20 public token;
379 
380     constructor(IERC20 _token) public {
381         token = _token;
382     }
383 
384     function balance() public view returns (uint256) {
385         return token.balanceOf(address(this));
386     }
387 
388     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
389         return token.transfer(to, value);
390     }
391 }
392 
393 /**
394  *
395  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.fi
396  *  
397  *           ____  _______  _____      __  _ 
398  *          |  _ \|__   __|/ ____|    / _|(_)
399  *      ___ | |_) |  | |  | |        | |_  _ 
400  *     / __||  _ <   | |  | |        |  _|| |
401  *     \__ \| |_) |  | |  | |____  _ | |  | |
402  *     |___/|____/   |_|   \_____|(_)|_|  |_|
403  *                                           
404  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.fi                                     
405  *
406 **/
407 
408 
409 
410 
411 
412 
413 /**
414  * @title Token Geyser
415  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
416  *      Compound and Uniswap.
417  *
418  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
419  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
420  *      claimed by users.
421  *
422  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
423  *      is a function of the number of tokens deposited as well as the length of time deposited.
424  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
425  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
426  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
427  *
428  *      More background and motivation available at:
429  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
430  */
431 contract TokenGeyser is IStaking, Ownable {
432     using SafeMath for uint256;
433 
434     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
435     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
436     event TokensClaimed(address indexed user, uint256 amount);
437     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
438     // amount: Unlocked tokens, total: Total locked tokens
439     event TokensUnlocked(uint256 amount, uint256 total);
440 
441     TokenPool private _stakingPool;
442     TokenPool private _unlockedPool;
443     TokenPool private _lockedPool;
444 
445     //
446     // Time-bonus params
447     //
448     uint256 public constant BONUS_DECIMALS = 2;
449     uint256 public startBonus = 0;
450     uint256 public bonusPeriodSec = 0;
451 
452     //
453     // Global accounting state
454     //
455     uint256 public totalLockedShares = 0;
456     uint256 public totalStakingShares = 0;
457     uint256 private _totalStakingShareSeconds = 0;
458     uint256 private _lastAccountingTimestampSec = now;
459     uint256 private _maxUnlockSchedules = 0;
460     uint256 private _initialSharesPerToken = 0;
461 
462     //
463     // User accounting state
464     //
465     // Represents a single stake for a user. A user may have multiple.
466     struct Stake {
467         uint256 stakingShares;
468         uint256 timestampSec;
469     }
470 
471     // Caches aggregated values from the User->Stake[] map to save computation.
472     // If lastAccountingTimestampSec is 0, there's no entry for that user.
473     struct UserTotals {
474         uint256 stakingShares;
475         uint256 stakingShareSeconds;
476         uint256 lastAccountingTimestampSec;
477     }
478 
479     // Aggregated staking values per user
480     mapping(address => UserTotals) private _userTotals;
481 
482     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
483     mapping(address => Stake[]) private _userStakes;
484 
485     //
486     // Locked/Unlocked Accounting state
487     //
488     struct UnlockSchedule {
489         uint256 initialLockedShares;
490         uint256 unlockedShares;
491         uint256 lastUnlockTimestampSec;
492         uint256 endAtSec;
493         uint256 durationSec;
494     }
495 
496     UnlockSchedule[] public unlockSchedules;
497 
498     /**
499      * @param stakingToken The token users deposit as stake.
500      * @param distributionToken The token users receive as they unstake.
501      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
502      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
503      *                    e.g. 25% means user gets 25% of max distribution tokens.
504      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
505      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
506      */
507     constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
508                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {
509         // The start bonus must be some fraction of the max. (i.e. <= 100%)
510         require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');
511         // If no period is desired, instead set startBonus = 100%
512         // and bonusPeriod to a small value like 1sec.
513         require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');
514         require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');
515 
516         _stakingPool = new TokenPool(stakingToken);
517         _unlockedPool = new TokenPool(distributionToken);
518         _lockedPool = new TokenPool(distributionToken);
519         startBonus = startBonus_;
520         bonusPeriodSec = bonusPeriodSec_;
521         _maxUnlockSchedules = maxUnlockSchedules;
522         _initialSharesPerToken = initialSharesPerToken;
523     }
524 
525     /**
526      * @return The token users deposit as stake.
527      */
528     function getStakingToken() public view returns (IERC20) {
529         return _stakingPool.token();
530     }
531 
532     /**
533      * @return The token users receive as they unstake.
534      */
535     function getDistributionToken() public view returns (IERC20) {
536         assert(_unlockedPool.token() == _lockedPool.token());
537         return _unlockedPool.token();
538     }
539 
540     /**
541      * @dev Transfers amount of deposit tokens from the user.
542      * @param amount Number of deposit tokens to stake.
543      * @param data Not used.
544      */
545     function stake(uint256 amount, bytes calldata data) external {
546         _stakeFor(msg.sender, msg.sender, amount);
547     }
548 
549     /**
550      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
551      * @param user User address who gains credit for this stake operation.
552      * @param amount Number of deposit tokens to stake.
553      * @param data Not used.
554      */
555     function stakeFor(address user, uint256 amount, bytes calldata data) external {
556         _stakeFor(msg.sender, user, amount);
557     }
558 
559     /**
560      * @dev Private implementation of staking methods.
561      * @param staker User address who deposits tokens to stake.
562      * @param beneficiary User address who gains credit for this stake operation.
563      * @param amount Number of deposit tokens to stake.
564      */
565     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
566         require(amount > 0, 'TokenGeyser: stake amount is zero');
567         require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');
568         require(totalStakingShares == 0 || totalStaked() > 0,
569                 'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');
570 
571         uint256 mintedStakingShares = (totalStakingShares > 0)
572             ? totalStakingShares.mul(amount).div(totalStaked())
573             : amount.mul(_initialSharesPerToken);
574         require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');
575 
576         updateAccounting();
577 
578         // 1. User Accounting
579         UserTotals storage totals = _userTotals[beneficiary];
580         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
581         totals.lastAccountingTimestampSec = now;
582 
583         Stake memory newStake = Stake(mintedStakingShares, now);
584         _userStakes[beneficiary].push(newStake);
585 
586         // 2. Global Accounting
587         totalStakingShares = totalStakingShares.add(mintedStakingShares);
588         // Already set in updateAccounting()
589         // _lastAccountingTimestampSec = now;
590 
591         // interactions
592         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
593             'TokenGeyser: transfer into staking pool failed');
594 
595         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
596     }
597 
598     /**
599      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
600      * alotted number of distribution tokens.
601      * @param amount Number of deposit tokens to unstake / withdraw.
602      * @param data Not used.
603      */
604     function unstake(uint256 amount, bytes calldata data) external {
605         _unstake(amount);
606     }
607 
608     /**
609      * @param amount Number of deposit tokens to unstake / withdraw.
610      * @return The total number of distribution tokens that would be rewarded.
611      */
612     function unstakeQuery(uint256 amount) public returns (uint256) {
613         return _unstake(amount);
614     }
615 
616     /**
617      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
618      * alotted number of distribution tokens.
619      * @param amount Number of deposit tokens to unstake / withdraw.
620      * @return The total number of distribution tokens rewarded.
621      */
622     function _unstake(uint256 amount) private returns (uint256) {
623         updateAccounting();
624 
625         // checks
626         require(amount > 0, 'TokenGeyser: unstake amount is zero');
627         require(totalStakedFor(msg.sender) >= amount,
628             'TokenGeyser: unstake amount is greater than total user stakes');
629         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
630         require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');
631 
632         // 1. User Accounting
633         UserTotals storage totals = _userTotals[msg.sender];
634         Stake[] storage accountStakes = _userStakes[msg.sender];
635 
636         // Redeem from most recent stake and go backwards in time.
637         uint256 stakingShareSecondsToBurn = 0;
638         uint256 sharesLeftToBurn = stakingSharesToBurn;
639         uint256 rewardAmount = 0;
640         while (sharesLeftToBurn > 0) {
641             Stake storage lastStake = accountStakes[accountStakes.length - 1];
642             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
643             uint256 newStakingShareSecondsToBurn = 0;
644             if (lastStake.stakingShares <= sharesLeftToBurn) {
645                 // fully redeem a past stake
646                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
647                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
648                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
649                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
650                 accountStakes.length--;
651             } else {
652                 // partially redeem a past stake
653                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
654                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
655                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
656                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
657                 sharesLeftToBurn = 0;
658             }
659         }
660         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
661         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
662         // Already set in updateAccounting
663         // totals.lastAccountingTimestampSec = now;
664 
665         // 2. Global Accounting
666         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
667         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
668         // Already set in updateAccounting
669         // _lastAccountingTimestampSec = now;
670 
671         // interactions
672         require(_stakingPool.transfer(msg.sender, amount),
673             'TokenGeyser: transfer out of staking pool failed');
674         require(_unlockedPool.transfer(msg.sender, rewardAmount),
675             'TokenGeyser: transfer out of unlocked pool failed');
676 
677         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
678         emit TokensClaimed(msg.sender, rewardAmount);
679 
680         require(totalStakingShares == 0 || totalStaked() > 0,
681                 "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");
682         return rewardAmount;
683     }
684 
685     /**
686      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
687      *      encourage long-term deposits instead of constant unstake/restakes.
688      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
689      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
690      * @param currentRewardTokens The current number of distribution tokens already alotted for this
691      *                            unstake op. Any bonuses are already applied.
692      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
693      *                            distribution tokens.
694      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
695      *                     the time-bonus.
696      * @return Updated amount of distribution tokens to award, with any bonus included on the
697      *         newly added tokens.
698      */
699     function computeNewReward(uint256 currentRewardTokens,
700                                 uint256 stakingShareSeconds,
701                                 uint256 stakeTimeSec) private view returns (uint256) {
702 
703         uint256 newRewardTokens =
704             totalUnlocked()
705             .mul(stakingShareSeconds)
706             .div(_totalStakingShareSeconds);
707 
708         if (stakeTimeSec >= bonusPeriodSec) {
709             return currentRewardTokens.add(newRewardTokens);
710         }
711 
712         uint256 oneHundredPct = 10**BONUS_DECIMALS;
713         uint256 bonusedReward =
714             startBonus
715             .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))
716             .mul(newRewardTokens)
717             .div(oneHundredPct);
718         return currentRewardTokens.add(bonusedReward);
719     }
720 
721     /**
722      * @param addr The user to look up staking information for.
723      * @return The number of staking tokens deposited for addr.
724      */
725     function totalStakedFor(address addr) public view returns (uint256) {
726         return totalStakingShares > 0 ?
727             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
728     }
729 
730     /**
731      * @return The total number of deposit tokens staked globally, by all users.
732      */
733     function totalStaked() public view returns (uint256) {
734         return _stakingPool.balance();
735     }
736 
737     /**
738      * @dev Note that this application has a staking token as well as a distribution token, which
739      * may be different. This function is required by EIP-900.
740      * @return The deposit token used for staking.
741      */
742     function token() external view returns (address) {
743         return address(getStakingToken());
744     }
745 
746     /**
747      * @dev A globally callable function to update the accounting state of the system.
748      *      Global state and state for the caller are updated.
749      * @return [0] balance of the locked pool
750      * @return [1] balance of the unlocked pool
751      * @return [2] caller's staking share seconds
752      * @return [3] global staking share seconds
753      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
754      * @return [5] block timestamp
755      */
756     function updateAccounting() public returns (
757         uint256, uint256, uint256, uint256, uint256, uint256) {
758 
759         unlockTokens();
760 
761         // Global accounting
762         uint256 newStakingShareSeconds =
763             now
764             .sub(_lastAccountingTimestampSec)
765             .mul(totalStakingShares);
766         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
767         _lastAccountingTimestampSec = now;
768 
769         // User Accounting
770         UserTotals storage totals = _userTotals[msg.sender];
771         uint256 newUserStakingShareSeconds =
772             now
773             .sub(totals.lastAccountingTimestampSec)
774             .mul(totals.stakingShares);
775         totals.stakingShareSeconds =
776             totals.stakingShareSeconds
777             .add(newUserStakingShareSeconds);
778         totals.lastAccountingTimestampSec = now;
779 
780         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
781             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
782             : 0;
783 
784         return (
785             totalLocked(),
786             totalUnlocked(),
787             totals.stakingShareSeconds,
788             _totalStakingShareSeconds,
789             totalUserRewards,
790             now
791         );
792     }
793 
794     /**
795      * @return Total number of locked distribution tokens.
796      */
797     function totalLocked() public view returns (uint256) {
798         return _lockedPool.balance();
799     }
800 
801     /**
802      * @return Total number of unlocked distribution tokens.
803      */
804     function totalUnlocked() public view returns (uint256) {
805         return _unlockedPool.balance();
806     }
807 
808     /**
809      * @return Number of unlock schedules.
810      */
811     function unlockScheduleCount() public view returns (uint256) {
812         return unlockSchedules.length;
813     }
814 
815     /**
816      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
817      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
818      *      linearly over the duraction of durationSec timeframe.
819      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
820      * @param durationSec Length of time to linear unlock the tokens.
821      */
822     function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {
823         require(unlockSchedules.length < _maxUnlockSchedules,
824             'TokenGeyser: reached maximum unlock schedules');
825 
826         // Update lockedTokens amount before using it in computations after.
827         updateAccounting();
828 
829         uint256 lockedTokens = totalLocked();
830         uint256 mintedLockedShares = (lockedTokens > 0)
831             ? totalLockedShares.mul(amount).div(lockedTokens)
832             : amount.mul(_initialSharesPerToken);
833 
834         UnlockSchedule memory schedule;
835         schedule.initialLockedShares = mintedLockedShares;
836         schedule.lastUnlockTimestampSec = now;
837         schedule.endAtSec = now.add(durationSec);
838         schedule.durationSec = durationSec;
839         unlockSchedules.push(schedule);
840 
841         totalLockedShares = totalLockedShares.add(mintedLockedShares);
842 
843         require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),
844             'TokenGeyser: transfer into locked pool failed');
845         emit TokensLocked(amount, durationSec, totalLocked());
846     }
847 
848     /**
849      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
850      *      previously defined unlock schedules. Publicly callable.
851      * @return Number of newly unlocked distribution tokens.
852      */
853     function unlockTokens() public returns (uint256) {
854         uint256 unlockedTokens = 0;
855         uint256 lockedTokens = totalLocked();
856 
857         if (totalLockedShares == 0) {
858             unlockedTokens = lockedTokens;
859         } else {
860             uint256 unlockedShares = 0;
861             for (uint256 s = 0; s < unlockSchedules.length; s++) {
862                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
863             }
864             unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);
865             totalLockedShares = totalLockedShares.sub(unlockedShares);
866         }
867 
868         if (unlockedTokens > 0) {
869             require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),
870                 'TokenGeyser: transfer out of locked pool failed');
871             emit TokensUnlocked(unlockedTokens, totalLocked());
872         }
873 
874         return unlockedTokens;
875     }
876 
877     /**
878      * @dev Returns the number of unlockable shares from a given schedule. The returned value
879      *      depends on the time since the last unlock. This function updates schedule accounting,
880      *      but does not actually transfer any tokens.
881      * @param s Index of the unlock schedule.
882      * @return The number of unlocked shares.
883      */
884     function unlockScheduleShares(uint256 s) private returns (uint256) {
885         UnlockSchedule storage schedule = unlockSchedules[s];
886 
887         if(schedule.unlockedShares >= schedule.initialLockedShares) {
888             return 0;
889         }
890 
891         uint256 sharesToUnlock = 0;
892         // Special case to handle any leftover dust from integer division
893         if (now >= schedule.endAtSec) {
894             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
895             schedule.lastUnlockTimestampSec = schedule.endAtSec;
896         } else {
897             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
898                 .mul(schedule.initialLockedShares)
899                 .div(schedule.durationSec);
900             schedule.lastUnlockTimestampSec = now;
901         }
902 
903         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
904         return sharesToUnlock;
905     }
906 }