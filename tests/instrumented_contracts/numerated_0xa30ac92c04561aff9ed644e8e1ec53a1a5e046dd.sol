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
404 // ABIEncoderV2 added for Flow Protocol
405 pragma experimental ABIEncoderV2;
406 
407 
408 
409 
410 
411 /**
412  * @title Token Geyser
413  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
414  *      Compound and Uniswap.
415  *
416  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
417  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
418  *      claimed by users.
419  *
420  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
421  *      is a function of the number of tokens deposited as well as the length of time deposited.
422  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
423  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
424  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
425  *
426  *      More background and motivation available at:
427  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
428  */
429 contract TokenGeyser is IStaking, Ownable {
430     using SafeMath for uint256;
431 
432     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
433     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
434     event TokensClaimed(address indexed user, uint256 amount);
435     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
436     // amount: Unlocked tokens, total: Total locked tokens
437     event TokensUnlocked(uint256 amount, uint256 total);
438 
439     TokenPool private _stakingPool;
440     TokenPool private _unlockedPool;
441     TokenPool private _lockedPool;
442 
443     //
444     // Time-bonus params
445     //
446     uint256 public constant BONUS_DECIMALS = 2;
447     uint256 public startBonus = 0;
448     uint256 public bonusPeriodSec = 0;
449 
450     //
451     // Global accounting state
452     //
453     uint256 public totalLockedShares = 0;
454     uint256 public totalStakingShares = 0;
455     uint256 private _totalStakingShareSeconds = 0;
456     uint256 private _lastAccountingTimestampSec = now;
457     uint256 private _maxUnlockSchedules = 0;
458     uint256 private _initialSharesPerToken = 0;
459 
460     //
461     // User accounting state
462     //
463     // Represents a single stake for a user. A user may have multiple.
464     struct Stake {
465         uint256 stakingShares;
466         uint256 timestampSec;
467     }
468 
469     // Caches aggregated values from the User->Stake[] map to save computation.
470     // If lastAccountingTimestampSec is 0, there's no entry for that user.
471     struct UserTotals {
472         uint256 stakingShares;
473         uint256 stakingShareSeconds;
474         uint256 lastAccountingTimestampSec;
475     }
476 
477     // Aggregated staking values per user
478     mapping(address => UserTotals) private _userTotals;
479 
480     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
481     mapping(address => Stake[]) private _userStakes;
482 
483     //
484     // Locked/Unlocked Accounting state
485     //
486     struct UnlockSchedule {
487         uint256 initialLockedShares;
488         uint256 unlockedShares;
489         uint256 lastUnlockTimestampSec;
490         uint256 endAtSec;
491         uint256 durationSec;
492     }
493 
494     UnlockSchedule[] public unlockSchedules;
495 
496     /**
497      * @param stakingToken The token users deposit as stake.
498      * @param distributionToken The token users receive as they unstake.
499      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
500      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
501      *                    e.g. 25% means user gets 25% of max distribution tokens.
502      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
503      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
504      */
505     constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
506                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {
507         // The start bonus must be some fraction of the max. (i.e. <= 100%)
508         require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');
509         // If no period is desired, instead set startBonus = 100%
510         // and bonusPeriod to a small value like 1sec.
511         require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');
512         require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');
513 
514         _stakingPool = new TokenPool(stakingToken);
515         _unlockedPool = new TokenPool(distributionToken);
516         _lockedPool = new TokenPool(distributionToken);
517         startBonus = startBonus_;
518         bonusPeriodSec = bonusPeriodSec_;
519         _maxUnlockSchedules = maxUnlockSchedules;
520         _initialSharesPerToken = initialSharesPerToken;
521     }
522 
523     /**
524      * @return The token users deposit as stake.
525      */
526     function getStakingToken() public view returns (IERC20) {
527         return _stakingPool.token();
528     }
529 
530     /**
531      * @return The token users receive as they unstake.
532      */
533     function getDistributionToken() public view returns (IERC20) {
534         assert(_unlockedPool.token() == _lockedPool.token());
535         return _unlockedPool.token();
536     }
537 
538     /**
539      * @dev Transfers amount of deposit tokens from the user.
540      * @param amount Number of deposit tokens to stake.
541      * @param data Not used.
542      */
543     function stake(uint256 amount, bytes calldata data) external {
544         _stakeFor(msg.sender, msg.sender, amount);
545     }
546 
547     /**
548      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
549      * @param user User address who gains credit for this stake operation.
550      * @param amount Number of deposit tokens to stake.
551      * @param data Not used.
552      */
553     function stakeFor(address user, uint256 amount, bytes calldata data) external onlyOwner {
554         _stakeFor(msg.sender, user, amount);
555     }
556 
557     /**
558      * @dev Private implementation of staking methods.
559      * @param staker User address who deposits tokens to stake.
560      * @param beneficiary User address who gains credit for this stake operation.
561      * @param amount Number of deposit tokens to stake.
562      */
563     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
564         require(amount > 0, 'TokenGeyser: stake amount is zero');
565         require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');
566         require(totalStakingShares == 0 || totalStaked() > 0,
567                 'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');
568 
569         uint256 mintedStakingShares = (totalStakingShares > 0)
570             ? totalStakingShares.mul(amount).div(totalStaked())
571             : amount.mul(_initialSharesPerToken);
572         require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');
573 
574         updateAccounting();
575 
576         // 1. User Accounting
577         UserTotals storage totals = _userTotals[beneficiary];
578         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
579         totals.lastAccountingTimestampSec = now;
580 
581         Stake memory newStake = Stake(mintedStakingShares, now);
582         _userStakes[beneficiary].push(newStake);
583 
584         // 2. Global Accounting
585         totalStakingShares = totalStakingShares.add(mintedStakingShares);
586         // Already set in updateAccounting()
587         // _lastAccountingTimestampSec = now;
588 
589         // interactions
590         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
591             'TokenGeyser: transfer into staking pool failed');
592 
593         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
594     }
595 
596     /**
597      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
598      * alotted number of distribution tokens.
599      * @param amount Number of deposit tokens to unstake / withdraw.
600      * @param data Not used.
601      */
602     function unstake(uint256 amount, bytes calldata data) external {
603         _unstake(amount);
604     }
605 
606     /**
607      * @param amount Number of deposit tokens to unstake / withdraw.
608      * @return The total number of distribution tokens that would be rewarded.
609      */
610     function unstakeQuery(uint256 amount) public returns (uint256) {
611         return _unstake(amount);
612     }
613 
614     /**
615      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
616      * alotted number of distribution tokens.
617      * @param amount Number of deposit tokens to unstake / withdraw.
618      * @return The total number of distribution tokens rewarded.
619      */
620     function _unstake(uint256 amount) private returns (uint256) {
621         updateAccounting();
622 
623         // checks
624         require(amount > 0, 'TokenGeyser: unstake amount is zero');
625         require(totalStakedFor(msg.sender) >= amount,
626             'TokenGeyser: unstake amount is greater than total user stakes');
627         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
628         require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');
629 
630         // 1. User Accounting
631         UserTotals storage totals = _userTotals[msg.sender];
632         Stake[] storage accountStakes = _userStakes[msg.sender];
633 
634         // Redeem from most recent stake and go backwards in time.
635         uint256 stakingShareSecondsToBurn = 0;
636         uint256 sharesLeftToBurn = stakingSharesToBurn;
637         uint256 rewardAmount = 0;
638         while (sharesLeftToBurn > 0) {
639             Stake storage lastStake = accountStakes[accountStakes.length - 1];
640             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
641             uint256 newStakingShareSecondsToBurn = 0;
642             if (lastStake.stakingShares <= sharesLeftToBurn) {
643                 // fully redeem a past stake
644                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
645                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
646                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
647                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
648                 accountStakes.length--;
649             } else {
650                 // partially redeem a past stake
651                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
652                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
653                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
654                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
655                 sharesLeftToBurn = 0;
656             }
657         }
658         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
659         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
660         // Already set in updateAccounting
661         // totals.lastAccountingTimestampSec = now;
662 
663         // 2. Global Accounting
664         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
665         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
666         // Already set in updateAccounting
667         // _lastAccountingTimestampSec = now;
668 
669         // interactions
670         require(_stakingPool.transfer(msg.sender, amount),
671             'TokenGeyser: transfer out of staking pool failed');
672         require(_unlockedPool.transfer(msg.sender, rewardAmount),
673             'TokenGeyser: transfer out of unlocked pool failed');
674 
675         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
676         emit TokensClaimed(msg.sender, rewardAmount);
677 
678         require(totalStakingShares == 0 || totalStaked() > 0,
679                 "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");
680         return rewardAmount;
681     }
682 
683     /**
684      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
685      *      encourage long-term deposits instead of constant unstake/restakes.
686      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
687      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
688      * @param currentRewardTokens The current number of distribution tokens already alotted for this
689      *                            unstake op. Any bonuses are already applied.
690      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
691      *                            distribution tokens.
692      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
693      *                     the time-bonus.
694      * @return Updated amount of distribution tokens to award, with any bonus included on the
695      *         newly added tokens.
696      */
697     function computeNewReward(uint256 currentRewardTokens,
698                                 uint256 stakingShareSeconds,
699                                 uint256 stakeTimeSec) private view returns (uint256) {
700 
701         uint256 newRewardTokens =
702             totalUnlocked()
703             .mul(stakingShareSeconds)
704             .div(_totalStakingShareSeconds);
705 
706         if (stakeTimeSec >= bonusPeriodSec) {
707             return currentRewardTokens.add(newRewardTokens);
708         }
709 
710         uint256 oneHundredPct = 10**BONUS_DECIMALS;
711         uint256 bonusedReward =
712             startBonus
713             .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))
714             .mul(newRewardTokens)
715             .div(oneHundredPct);
716         return currentRewardTokens.add(bonusedReward);
717     }
718 
719     // getUserTotals, getTotalStakingShareSeconds, getLastAccountingTimestamp functions added for Flow Protocol
720 
721     /**
722      * @param addr The user to look up staking information for.
723      * @return The UserStakes for this address.
724      */
725     function getUserStakes(address addr) public view returns (Stake[] memory){
726         Stake[] memory userStakes = _userStakes[addr];
727         return userStakes;
728     }
729 
730     /**
731      * @param addr The user to look up staking information for.
732      * @return The UserTotals for this address.
733      */
734     function getUserTotals(address addr) public view returns (UserTotals memory) {
735         UserTotals memory userTotals = _userTotals[addr];
736         return userTotals;
737     }
738 
739     /**
740      * @return The total staking share seconds.
741      */
742     function getTotalStakingShareSeconds() public view returns (uint256) {
743         return _totalStakingShareSeconds;
744     }
745 
746     /**
747      * @return The last global accounting timestamp.
748      */
749     function getLastAccountingTimestamp() public view returns (uint256) {
750         return _lastAccountingTimestampSec;
751     }
752 
753     /**
754      * @param addr The user to look up staking information for.
755      * @return The number of staking tokens deposited for addr.
756      */
757     function totalStakedFor(address addr) public view returns (uint256) {
758         return totalStakingShares > 0 ?
759             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
760     }
761 
762     /**
763      * @return The total number of deposit tokens staked globally, by all users.
764      */
765     function totalStaked() public view returns (uint256) {
766         return _stakingPool.balance();
767     }
768 
769     /**
770      * @dev Note that this application has a staking token as well as a distribution token, which
771      * may be different. This function is required by EIP-900.
772      * @return The deposit token used for staking.
773      */
774     function token() external view returns (address) {
775         return address(getStakingToken());
776     }
777 
778     /**
779      * @dev A globally callable function to update the accounting state of the system.
780      *      Global state and state for the caller are updated.
781      * @return [0] balance of the locked pool
782      * @return [1] balance of the unlocked pool
783      * @return [2] caller's staking share seconds
784      * @return [3] global staking share seconds
785      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
786      * @return [5] block timestamp
787      */
788     function updateAccounting() public returns (
789         uint256, uint256, uint256, uint256, uint256, uint256) {
790 
791         unlockTokens();
792 
793         // Global accounting
794         uint256 newStakingShareSeconds =
795             now
796             .sub(_lastAccountingTimestampSec)
797             .mul(totalStakingShares);
798         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
799         _lastAccountingTimestampSec = now;
800 
801         // User Accounting
802         UserTotals storage totals = _userTotals[msg.sender];
803         uint256 newUserStakingShareSeconds =
804             now
805             .sub(totals.lastAccountingTimestampSec)
806             .mul(totals.stakingShares);
807         totals.stakingShareSeconds =
808             totals.stakingShareSeconds
809             .add(newUserStakingShareSeconds);
810         totals.lastAccountingTimestampSec = now;
811 
812         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
813             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
814             : 0;
815 
816         return (
817             totalLocked(),
818             totalUnlocked(),
819             totals.stakingShareSeconds,
820             _totalStakingShareSeconds,
821             totalUserRewards,
822             now
823         );
824     }
825 
826     /**
827      * @return Total number of locked distribution tokens.
828      */
829     function totalLocked() public view returns (uint256) {
830         return _lockedPool.balance();
831     }
832 
833     /**
834      * @return Total number of unlocked distribution tokens.
835      */
836     function totalUnlocked() public view returns (uint256) {
837         return _unlockedPool.balance();
838     }
839 
840     /**
841      * @return Number of unlock schedules.
842      */
843     function unlockScheduleCount() public view returns (uint256) {
844         return unlockSchedules.length;
845     }
846 
847     /**
848      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
849      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
850      *      linearly over the duraction of durationSec timeframe.
851      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
852      * @param durationSec Length of time to linear unlock the tokens.
853      */
854     function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {
855         require(unlockSchedules.length < _maxUnlockSchedules,
856             'TokenGeyser: reached maximum unlock schedules');
857 
858         // Update lockedTokens amount before using it in computations after.
859         updateAccounting();
860 
861         uint256 lockedTokens = totalLocked();
862         uint256 mintedLockedShares = (lockedTokens > 0)
863             ? totalLockedShares.mul(amount).div(lockedTokens)
864             : amount.mul(_initialSharesPerToken);
865 
866         UnlockSchedule memory schedule;
867         schedule.initialLockedShares = mintedLockedShares;
868         schedule.lastUnlockTimestampSec = now;
869         schedule.endAtSec = now.add(durationSec);
870         schedule.durationSec = durationSec;
871         unlockSchedules.push(schedule);
872 
873         totalLockedShares = totalLockedShares.add(mintedLockedShares);
874 
875         require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),
876             'TokenGeyser: transfer into locked pool failed');
877         emit TokensLocked(amount, durationSec, totalLocked());
878     }
879 
880     /**
881      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
882      *      previously defined unlock schedules. Publicly callable.
883      * @return Number of newly unlocked distribution tokens.
884      */
885     function unlockTokens() public returns (uint256) {
886         uint256 unlockedTokens = 0;
887         uint256 lockedTokens = totalLocked();
888 
889         if (totalLockedShares == 0) {
890             unlockedTokens = lockedTokens;
891         } else {
892             uint256 unlockedShares = 0;
893             for (uint256 s = 0; s < unlockSchedules.length; s++) {
894                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
895             }
896             unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);
897             totalLockedShares = totalLockedShares.sub(unlockedShares);
898         }
899 
900         if (unlockedTokens > 0) {
901             require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),
902                 'TokenGeyser: transfer out of locked pool failed');
903             emit TokensUnlocked(unlockedTokens, totalLocked());
904         }
905 
906         return unlockedTokens;
907     }
908 
909     /**
910      * @dev Returns the number of unlockable shares from a given schedule. The returned value
911      *      depends on the time since the last unlock. This function updates schedule accounting,
912      *      but does not actually transfer any tokens.
913      * @param s Index of the unlock schedule.
914      * @return The number of unlocked shares.
915      */
916     function unlockScheduleShares(uint256 s) private returns (uint256) {
917         UnlockSchedule storage schedule = unlockSchedules[s];
918 
919         if(schedule.unlockedShares >= schedule.initialLockedShares) {
920             return 0;
921         }
922 
923         uint256 sharesToUnlock = 0;
924         // Special case to handle any leftover dust from integer division
925         if (now >= schedule.endAtSec) {
926             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
927             schedule.lastUnlockTimestampSec = schedule.endAtSec;
928         } else {
929             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
930                 .mul(schedule.initialLockedShares)
931                 .div(schedule.durationSec);
932             schedule.lastUnlockTimestampSec = now;
933         }
934 
935         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
936         return sharesToUnlock;
937     }
938 }