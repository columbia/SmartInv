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
399 }
400 
401 // File: contracts/TokenGeyser.sol
402 
403 pragma solidity 0.5.0;
404 
405 
406 
407 
408 
409 
410 /**
411  * @title Token Geyser
412  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
413  *      Compound and Uniswap.
414  *
415  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
416  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
417  *      claimed by users.
418  *
419  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
420  *      is a function of the number of tokens deposited as well as the length of time deposited.
421  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
422  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
423  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
424  *
425  *      More background and motivation available at:
426  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
427  */
428 contract TokenGeyser is IStaking, Ownable {
429     using SafeMath for uint256;
430 
431     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
432     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
433     event TokensClaimed(address indexed user, uint256 amount);
434     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
435     // amount: Unlocked tokens, total: Total locked tokens
436     event TokensUnlocked(uint256 amount, uint256 total);
437 
438     TokenPool private _stakingPool;
439     TokenPool private _unlockedPool;
440     TokenPool private _lockedPool;
441 
442     //
443     // Time-bonus params
444     //
445     uint256 public constant BONUS_DECIMALS = 2;
446     uint256 public startBonus = 0;
447     uint256 public bonusPeriodSec = 0;
448 
449     //
450     // Global accounting state
451     //
452     uint256 public totalLockedShares = 0;
453     uint256 public totalStakingShares = 0;
454     uint256 private _totalStakingShareSeconds = 0;
455     uint256 private _lastAccountingTimestampSec = now;
456     uint256 private _maxUnlockSchedules = 0;
457     uint256 private _initialSharesPerToken = 0;
458 
459     //
460     // User accounting state
461     //
462     // Represents a single stake for a user. A user may have multiple.
463     struct Stake {
464         uint256 stakingShares;
465         uint256 timestampSec;
466     }
467 
468     // Caches aggregated values from the User->Stake[] map to save computation.
469     // If lastAccountingTimestampSec is 0, there's no entry for that user.
470     struct UserTotals {
471         uint256 stakingShares;
472         uint256 stakingShareSeconds;
473         uint256 lastAccountingTimestampSec;
474     }
475 
476     // Aggregated staking values per user
477     mapping(address => UserTotals) private _userTotals;
478 
479     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
480     mapping(address => Stake[]) private _userStakes;
481 
482     //
483     // Locked/Unlocked Accounting state
484     //
485     struct UnlockSchedule {
486         uint256 initialLockedShares;
487         uint256 unlockedShares;
488         uint256 lastUnlockTimestampSec;
489         uint256 endAtSec;
490         uint256 durationSec;
491     }
492 
493     UnlockSchedule[] public unlockSchedules;
494 
495     /**
496      * @param stakingToken The token users deposit as stake.
497      * @param distributionToken The token users receive as they unstake.
498      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
499      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
500      *                    e.g. 25% means user gets 25% of max distribution tokens.
501      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
502      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
503      */
504     constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
505                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {
506         // The start bonus must be some fraction of the max. (i.e. <= 100%)
507         require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');
508         // If no period is desired, instead set startBonus = 100%
509         // and bonusPeriod to a small value like 1sec.
510         require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');
511         require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');
512 
513         _stakingPool = new TokenPool(stakingToken);
514         _unlockedPool = new TokenPool(distributionToken);
515         _lockedPool = new TokenPool(distributionToken);
516         startBonus = startBonus_;
517         bonusPeriodSec = bonusPeriodSec_;
518         _maxUnlockSchedules = maxUnlockSchedules;
519         _initialSharesPerToken = initialSharesPerToken;
520     }
521 
522     /**
523      * @return The token users deposit as stake.
524      */
525     function getStakingToken() public view returns (IERC20) {
526         return _stakingPool.token();
527     }
528 
529     /**
530      * @return The token users receive as they unstake.
531      */
532     function getDistributionToken() public view returns (IERC20) {
533         assert(_unlockedPool.token() == _lockedPool.token());
534         return _unlockedPool.token();
535     }
536 
537     /**
538      * @dev Transfers amount of deposit tokens from the user.
539      * @param amount Number of deposit tokens to stake.
540      * @param data Not used.
541      */
542     function stake(uint256 amount, bytes calldata data) external {
543         _stakeFor(msg.sender, msg.sender, amount);
544     }
545 
546     /**
547      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
548      * @param user User address who gains credit for this stake operation.
549      * @param amount Number of deposit tokens to stake.
550      * @param data Not used.
551      */
552     function stakeFor(address user, uint256 amount, bytes calldata data) external {
553         _stakeFor(msg.sender, user, amount);
554     }
555 
556     /**
557      * @dev Private implementation of staking methods.
558      * @param staker User address who deposits tokens to stake.
559      * @param beneficiary User address who gains credit for this stake operation.
560      * @param amount Number of deposit tokens to stake.
561      */
562     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
563         require(amount > 0, 'TokenGeyser: stake amount is zero');
564         require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');
565         require(totalStakingShares == 0 || totalStaked() > 0,
566                 'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');
567 
568         uint256 mintedStakingShares = (totalStakingShares > 0)
569             ? totalStakingShares.mul(amount).div(totalStaked())
570             : amount.mul(_initialSharesPerToken);
571         require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');
572 
573         updateAccounting();
574 
575         // 1. User Accounting
576         UserTotals storage totals = _userTotals[beneficiary];
577         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
578         totals.lastAccountingTimestampSec = now;
579 
580         Stake memory newStake = Stake(mintedStakingShares, now);
581         _userStakes[beneficiary].push(newStake);
582 
583         // 2. Global Accounting
584         totalStakingShares = totalStakingShares.add(mintedStakingShares);
585         // Already set in updateAccounting()
586         // _lastAccountingTimestampSec = now;
587 
588         // interactions
589         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
590             'TokenGeyser: transfer into staking pool failed');
591 
592         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
593     }
594 
595     /**
596      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
597      * alotted number of distribution tokens.
598      * @param amount Number of deposit tokens to unstake / withdraw.
599      * @param data Not used.
600      */
601     function unstake(uint256 amount, bytes calldata data) external {
602         _unstake(amount);
603     }
604 
605     /**
606      * @param amount Number of deposit tokens to unstake / withdraw.
607      * @return The total number of distribution tokens that would be rewarded.
608      */
609     function unstakeQuery(uint256 amount) public returns (uint256) {
610         return _unstake(amount);
611     }
612 
613     /**
614      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
615      * alotted number of distribution tokens.
616      * @param amount Number of deposit tokens to unstake / withdraw.
617      * @return The total number of distribution tokens rewarded.
618      */
619     function _unstake(uint256 amount) private returns (uint256) {
620         updateAccounting();
621 
622         // checks
623         require(amount > 0, 'TokenGeyser: unstake amount is zero');
624         require(totalStakedFor(msg.sender) >= amount,
625             'TokenGeyser: unstake amount is greater than total user stakes');
626         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
627         require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');
628 
629         // 1. User Accounting
630         UserTotals storage totals = _userTotals[msg.sender];
631         Stake[] storage accountStakes = _userStakes[msg.sender];
632 
633         // Redeem from most recent stake and go backwards in time.
634         uint256 stakingShareSecondsToBurn = 0;
635         uint256 sharesLeftToBurn = stakingSharesToBurn;
636         uint256 rewardAmount = 0;
637         while (sharesLeftToBurn > 0) {
638             Stake storage lastStake = accountStakes[accountStakes.length - 1];
639             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
640             uint256 newStakingShareSecondsToBurn = 0;
641             if (lastStake.stakingShares <= sharesLeftToBurn) {
642                 // fully redeem a past stake
643                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
644                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
645                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
646                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
647                 accountStakes.length--;
648             } else {
649                 // partially redeem a past stake
650                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
651                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
652                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
653                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
654                 sharesLeftToBurn = 0;
655             }
656         }
657         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
658         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
659         // Already set in updateAccounting
660         // totals.lastAccountingTimestampSec = now;
661 
662         // 2. Global Accounting
663         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
664         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
665         // Already set in updateAccounting
666         // _lastAccountingTimestampSec = now;
667 
668         // interactions
669         require(_stakingPool.transfer(msg.sender, amount),
670             'TokenGeyser: transfer out of staking pool failed');
671         require(_unlockedPool.transfer(msg.sender, rewardAmount),
672             'TokenGeyser: transfer out of unlocked pool failed');
673 
674         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
675         emit TokensClaimed(msg.sender, rewardAmount);
676 
677         require(totalStakingShares == 0 || totalStaked() > 0,
678                 "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");
679         return rewardAmount;
680     }
681 
682     /**
683      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
684      *      encourage long-term deposits instead of constant unstake/restakes.
685      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
686      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
687      * @param currentRewardTokens The current number of distribution tokens already alotted for this
688      *                            unstake op. Any bonuses are already applied.
689      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
690      *                            distribution tokens.
691      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
692      *                     the time-bonus.
693      * @return Updated amount of distribution tokens to award, with any bonus included on the
694      *         newly added tokens.
695      */
696     function computeNewReward(uint256 currentRewardTokens,
697                                 uint256 stakingShareSeconds,
698                                 uint256 stakeTimeSec) private view returns (uint256) {
699 
700         uint256 newRewardTokens =
701             totalUnlocked()
702             .mul(stakingShareSeconds)
703             .div(_totalStakingShareSeconds);
704 
705         if (stakeTimeSec >= bonusPeriodSec) {
706             return currentRewardTokens.add(newRewardTokens);
707         }
708 
709         uint256 oneHundredPct = 10**BONUS_DECIMALS;
710         uint256 bonusedReward =
711             startBonus
712             .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))
713             .mul(newRewardTokens)
714             .div(oneHundredPct);
715         return currentRewardTokens.add(bonusedReward);
716     }
717 
718     /**
719      * @param addr The user to look up staking information for.
720      * @return The number of staking tokens deposited for addr.
721      */
722     function totalStakedFor(address addr) public view returns (uint256) {
723         return totalStakingShares > 0 ?
724             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
725     }
726 
727     /**
728      * @return The total number of deposit tokens staked globally, by all users.
729      */
730     function totalStaked() public view returns (uint256) {
731         return _stakingPool.balance();
732     }
733 
734     /**
735      * @dev Note that this application has a staking token as well as a distribution token, which
736      * may be different. This function is required by EIP-900.
737      * @return The deposit token used for staking.
738      */
739     function token() external view returns (address) {
740         return address(getStakingToken());
741     }
742 
743     /**
744      * @dev A globally callable function to update the accounting state of the system.
745      *      Global state and state for the caller are updated.
746      * @return [0] balance of the locked pool
747      * @return [1] balance of the unlocked pool
748      * @return [2] caller's staking share seconds
749      * @return [3] global staking share seconds
750      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
751      * @return [5] block timestamp
752      */
753     function updateAccounting() public returns (
754         uint256, uint256, uint256, uint256, uint256, uint256) {
755 
756         unlockTokens();
757 
758         // Global accounting
759         uint256 newStakingShareSeconds =
760             now
761             .sub(_lastAccountingTimestampSec)
762             .mul(totalStakingShares);
763         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
764         _lastAccountingTimestampSec = now;
765 
766         // User Accounting
767         UserTotals storage totals = _userTotals[msg.sender];
768         uint256 newUserStakingShareSeconds =
769             now
770             .sub(totals.lastAccountingTimestampSec)
771             .mul(totals.stakingShares);
772         totals.stakingShareSeconds =
773             totals.stakingShareSeconds
774             .add(newUserStakingShareSeconds);
775         totals.lastAccountingTimestampSec = now;
776 
777         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
778             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
779             : 0;
780 
781         return (
782             totalLocked(),
783             totalUnlocked(),
784             totals.stakingShareSeconds,
785             _totalStakingShareSeconds,
786             totalUserRewards,
787             now
788         );
789     }
790 
791     /**
792      * @return Total number of locked distribution tokens.
793      */
794     function totalLocked() public view returns (uint256) {
795         return _lockedPool.balance();
796     }
797 
798     /**
799      * @return Total number of unlocked distribution tokens.
800      */
801     function totalUnlocked() public view returns (uint256) {
802         return _unlockedPool.balance();
803     }
804 
805     /**
806      * @return Number of unlock schedules.
807      */
808     function unlockScheduleCount() public view returns (uint256) {
809         return unlockSchedules.length;
810     }
811 
812     /**
813      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
814      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
815      *      linearly over the duraction of durationSec timeframe.
816      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
817      * @param durationSec Length of time to linear unlock the tokens.
818      */
819     function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {
820         require(unlockSchedules.length < _maxUnlockSchedules,
821             'TokenGeyser: reached maximum unlock schedules');
822 
823         // Update lockedTokens amount before using it in computations after.
824         updateAccounting();
825 
826         uint256 lockedTokens = totalLocked();
827         uint256 mintedLockedShares = (lockedTokens > 0)
828             ? totalLockedShares.mul(amount).div(lockedTokens)
829             : amount.mul(_initialSharesPerToken);
830 
831         UnlockSchedule memory schedule;
832         schedule.initialLockedShares = mintedLockedShares;
833         schedule.lastUnlockTimestampSec = now;
834         schedule.endAtSec = now.add(durationSec);
835         schedule.durationSec = durationSec;
836         unlockSchedules.push(schedule);
837 
838         totalLockedShares = totalLockedShares.add(mintedLockedShares);
839 
840         require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),
841             'TokenGeyser: transfer into locked pool failed');
842         emit TokensLocked(amount, durationSec, totalLocked());
843     }
844 
845     /**
846      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
847      *      previously defined unlock schedules. Publicly callable.
848      * @return Number of newly unlocked distribution tokens.
849      */
850     function unlockTokens() public returns (uint256) {
851         uint256 unlockedTokens = 0;
852         uint256 lockedTokens = totalLocked();
853 
854         if (totalLockedShares == 0) {
855             unlockedTokens = lockedTokens;
856         } else {
857             uint256 unlockedShares = 0;
858             for (uint256 s = 0; s < unlockSchedules.length; s++) {
859                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
860             }
861             unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);
862             totalLockedShares = totalLockedShares.sub(unlockedShares);
863         }
864 
865         if (unlockedTokens > 0) {
866             require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),
867                 'TokenGeyser: transfer out of locked pool failed');
868             emit TokensUnlocked(unlockedTokens, totalLocked());
869         }
870 
871         return unlockedTokens;
872     }
873 
874     /**
875      * @dev Returns the number of unlockable shares from a given schedule. The returned value
876      *      depends on the time since the last unlock. This function updates schedule accounting,
877      *      but does not actually transfer any tokens.
878      * @param s Index of the unlock schedule.
879      * @return The number of unlocked shares.
880      */
881     function unlockScheduleShares(uint256 s) private returns (uint256) {
882         UnlockSchedule storage schedule = unlockSchedules[s];
883 
884         if(schedule.unlockedShares >= schedule.initialLockedShares) {
885             return 0;
886         }
887 
888         uint256 sharesToUnlock = 0;
889         // Special case to handle any leftover dust from integer division
890         if (now >= schedule.endAtSec) {
891             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
892             schedule.lastUnlockTimestampSec = schedule.endAtSec;
893         } else {
894             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
895                 .mul(schedule.initialLockedShares)
896                 .div(schedule.durationSec);
897             schedule.lastUnlockTimestampSec = now;
898         }
899 
900         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
901         return sharesToUnlock;
902     }
903 }