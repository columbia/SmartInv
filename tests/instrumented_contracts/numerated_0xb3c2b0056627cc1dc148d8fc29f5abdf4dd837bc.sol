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
431  *      More background and motivation available at:
432  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
433  */
434 contract TokenGeyser is IStaking, Ownable {
435     using SafeMath for uint256;
436 
437     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
438     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
439     event TokensClaimed(address indexed user, uint256 amount);
440     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
441     // amount: Unlocked tokens, total: Total locked tokens
442     event TokensUnlocked(uint256 amount, uint256 total);
443 
444     TokenPool private _stakingPool;
445     TokenPool private _unlockedPool;
446     TokenPool private _lockedPool;
447 
448     //
449     // Time-bonus params
450     //
451     uint256 public constant BONUS_DECIMALS = 2;
452     uint256 public startBonus = 0;
453     uint256 public bonusPeriodSec = 0;
454 
455     //
456     // Global accounting state
457     //
458     uint256 public totalLockedShares = 0;
459     uint256 public totalStakingShares = 0;
460     uint256 private _totalStakingShareSeconds = 0;
461     uint256 private _lastAccountingTimestampSec = now;
462     uint256 private _maxUnlockSchedules = 0;
463     uint256 private _initialSharesPerToken = 0;
464 
465     //
466     // User accounting state
467     //
468     // Represents a single stake for a user. A user may have multiple.
469     struct Stake {
470         uint256 stakingShares;
471         uint256 timestampSec;
472     }
473 
474     // Caches aggregated values from the User->Stake[] map to save computation.
475     // If lastAccountingTimestampSec is 0, there's no entry for that user.
476     struct UserTotals {
477         uint256 stakingShares;
478         uint256 stakingShareSeconds;
479         uint256 lastAccountingTimestampSec;
480     }
481 
482     // Aggregated staking values per user
483     mapping(address => UserTotals) private _userTotals;
484 
485     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
486     mapping(address => Stake[]) private _userStakes;
487 
488     //
489     // Locked/Unlocked Accounting state
490     //
491     struct UnlockSchedule {
492         uint256 initialLockedShares;
493         uint256 unlockedShares;
494         uint256 lastUnlockTimestampSec;
495         uint256 endAtSec;
496         uint256 durationSec;
497     }
498 
499     UnlockSchedule[] public unlockSchedules;
500 
501     bool public initialized;
502 
503     /**
504      * @param stakingToken The token users deposit as stake.
505      * @param distributionToken The token users receive as they unstake.
506      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
507      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
508      *                    e.g. 25% means user gets 25% of max distribution tokens.
509      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
510      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
511      */
512     function init(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
513                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {
514         require(!initialized, "Already initialized");
515         initialized = true;
516         // The start bonus must be some fraction of the max. (i.e. <= 100%)
517         require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');
518         // If no period is desired, instead set startBonus = 100%
519         // and bonusPeriod to a small value like 1sec.
520         require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');
521         require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');
522 
523         _stakingPool = new TokenPool(stakingToken);
524         _unlockedPool = new TokenPool(distributionToken);
525         _lockedPool = new TokenPool(distributionToken);
526         startBonus = startBonus_;
527         bonusPeriodSec = bonusPeriodSec_;
528         _maxUnlockSchedules = maxUnlockSchedules;
529         _initialSharesPerToken = initialSharesPerToken;
530     }
531 
532     /**
533      * @return The token users deposit as stake.
534      */
535     function getStakingToken() public view returns (IERC20) {
536         return _stakingPool.token();
537     }
538 
539     /**
540      * @return The token users receive as they unstake.
541      */
542     function getDistributionToken() public view returns (IERC20) {
543         assert(_unlockedPool.token() == _lockedPool.token());
544         return _unlockedPool.token();
545     }
546 
547     /**
548      * @dev Transfers amount of deposit tokens from the user.
549      * @param amount Number of deposit tokens to stake.
550      * @param data Not used.
551      */
552     function stake(uint256 amount, bytes calldata data) external {
553         _stakeFor(msg.sender, msg.sender, amount);
554     }
555 
556     /** 
557      * @dev Created for compatibility with UniPool staking contract
558      * @param amount Amount to stake
559     */
560     function stake(uint256 amount) external {
561         _stakeFor(msg.sender, msg.sender, amount);
562     }
563 
564     /**
565      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
566      * @param user User address who gains credit for this stake operation.
567      * @param amount Number of deposit tokens to stake.
568      * @param data Not used.
569      */
570     function stakeFor(address user, uint256 amount, bytes calldata data) external onlyOwner {
571         _stakeFor(msg.sender, user, amount);
572     }
573 
574     /**
575      * @dev Private implementation of staking methods.
576      * @param staker User address who deposits tokens to stake.
577      * @param beneficiary User address who gains credit for this stake operation.
578      * @param amount Number of deposit tokens to stake.
579      */
580     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
581         require(amount > 0, 'TokenGeyser: stake amount is zero');
582         require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');
583         require(totalStakingShares == 0 || totalStaked() > 0,
584                 'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');
585 
586         uint256 mintedStakingShares = (totalStakingShares > 0)
587             ? totalStakingShares.mul(amount).div(totalStaked())
588             : amount.mul(_initialSharesPerToken);
589         require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');
590 
591         updateAccounting();
592 
593         // 1. User Accounting
594         UserTotals storage totals = _userTotals[beneficiary];
595         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
596         totals.lastAccountingTimestampSec = now;
597 
598         Stake memory newStake = Stake(mintedStakingShares, now);
599         _userStakes[beneficiary].push(newStake);
600 
601         // 2. Global Accounting
602         totalStakingShares = totalStakingShares.add(mintedStakingShares);
603         // Already set in updateAccounting()
604         // _lastAccountingTimestampSec = now;
605 
606         // interactions
607         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
608             'TokenGeyser: transfer into staking pool failed');
609 
610         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
611     }
612 
613     /**
614      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
615      * alotted number of distribution tokens.
616      * @param amount Number of deposit tokens to unstake / withdraw.
617      * @param data Not used.
618      */
619     function unstake(uint256 amount, bytes calldata data) external {
620         _unstake(amount);
621     }
622 
623     /**
624      * @dev Created for compatibility with UniPool contract
625      * @param amount Number of tokens to withdraw
626     */
627     function withdraw(uint256 amount) external {
628         _unstake(amount);
629     }
630 
631     /**
632      * @param amount Number of deposit tokens to unstake / withdraw.
633      * @return The total number of distribution tokens that would be rewarded.
634      */
635     function unstakeQuery(uint256 amount) public returns (uint256) {
636         return _unstake(amount);
637     }
638 
639     /**
640      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
641      * alotted number of distribution tokens.
642      * @param amount Number of deposit tokens to unstake / withdraw.
643      * @return The total number of distribution tokens rewarded.
644      */
645     function _unstake(uint256 amount) private returns (uint256) {
646         updateAccounting();
647 
648         // checks
649         require(amount > 0, 'TokenGeyser: unstake amount is zero');
650         require(totalStakedFor(msg.sender) >= amount,
651             'TokenGeyser: unstake amount is greater than total user stakes');
652         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
653         require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');
654 
655         // 1. User Accounting
656         UserTotals storage totals = _userTotals[msg.sender];
657         Stake[] storage accountStakes = _userStakes[msg.sender];
658 
659         // Redeem from most recent stake and go backwards in time.
660         uint256 stakingShareSecondsToBurn = 0;
661         uint256 sharesLeftToBurn = stakingSharesToBurn;
662         uint256 rewardAmount = 0;
663         while (sharesLeftToBurn > 0) {
664             Stake storage lastStake = accountStakes[accountStakes.length - 1];
665             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
666             uint256 newStakingShareSecondsToBurn = 0;
667             if (lastStake.stakingShares <= sharesLeftToBurn) {
668                 // fully redeem a past stake
669                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
670                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
671                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
672                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
673                 accountStakes.length--;
674             } else {
675                 // partially redeem a past stake
676                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
677                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
678                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
679                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
680                 sharesLeftToBurn = 0;
681             }
682         }
683         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
684         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
685         // Already set in updateAccounting
686         // totals.lastAccountingTimestampSec = now;
687 
688         // 2. Global Accounting
689         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
690         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
691         // Already set in updateAccounting
692         // _lastAccountingTimestampSec = now;
693 
694         // interactions
695         require(_stakingPool.transfer(msg.sender, amount),
696             'TokenGeyser: transfer out of staking pool failed');
697         require(_unlockedPool.transfer(msg.sender, rewardAmount),
698             'TokenGeyser: transfer out of unlocked pool failed');
699 
700         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
701         emit TokensClaimed(msg.sender, rewardAmount);
702 
703         require(totalStakingShares == 0 || totalStaked() > 0,
704                 "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");
705         return rewardAmount;
706     }
707 
708     /**
709      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
710      *      encourage long-term deposits instead of constant unstake/restakes.
711      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
712      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
713      * @param currentRewardTokens The current number of distribution tokens already alotted for this
714      *                            unstake op. Any bonuses are already applied.
715      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
716      *                            distribution tokens.
717      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
718      *                     the time-bonus.
719      * @return Updated amount of distribution tokens to award, with any bonus included on the
720      *         newly added tokens.
721      */
722     function computeNewReward(uint256 currentRewardTokens,
723                                 uint256 stakingShareSeconds,
724                                 uint256 stakeTimeSec) private view returns (uint256) {
725 
726         uint256 newRewardTokens =
727             totalUnlocked()
728             .mul(stakingShareSeconds)
729             .div(_totalStakingShareSeconds);
730 
731         if (stakeTimeSec >= bonusPeriodSec) {
732             return currentRewardTokens.add(newRewardTokens);
733         }
734 
735         uint256 oneHundredPct = 10**BONUS_DECIMALS;
736         uint256 bonusedReward =
737             startBonus
738             .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))
739             .mul(newRewardTokens)
740             .div(oneHundredPct);
741         return currentRewardTokens.add(bonusedReward);
742     }
743 
744     /**
745      * @param addr The user to look up staking information for.
746      * @return The number of staking tokens deposited for addr.
747      */
748     function totalStakedFor(address addr) public view returns (uint256) {
749         return totalStakingShares > 0 ?
750             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
751     }
752 
753     /**
754      * @dev Created for compatibility with UniPool staking contract
755      * @return The number of staking tokens deposited for addr.
756     */
757     function balanceOf(address addr) external view returns (uint256) {
758         return totalStakedFor(addr);
759     }
760 
761     /**
762      * @return The total number of deposit tokens staked globally, by all users.
763      */
764     function totalStaked() public view returns (uint256) {
765         return _stakingPool.balance();
766     }
767 
768     /** 
769      * @dev Created for compatibility with UniPool staking contract
770      * @return The total number of staked tokens
771     */
772     function totalSupply() external view returns (uint256) {
773         return totalStaked();
774     }
775 
776     /**
777      * @dev Note that this application has a staking token as well as a distribution token, which
778      * may be different. This function is required by EIP-900.
779      * @return The deposit token used for staking.
780      */
781     function token() external view returns (address) {
782         return address(getStakingToken());
783     }
784 
785     /**
786      * @dev A globally callable function to update the accounting state of the system.
787      *      Global state and state for the caller are updated.
788      * @return [0] balance of the locked pool
789      * @return [1] balance of the unlocked pool
790      * @return [2] caller's staking share seconds
791      * @return [3] global staking share seconds
792      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
793      * @return [5] block timestamp
794      */
795     function updateAccounting() public returns (
796         uint256, uint256, uint256, uint256, uint256, uint256) {
797 
798         unlockTokens();
799 
800         // Global accounting
801         uint256 newStakingShareSeconds =
802             now
803             .sub(_lastAccountingTimestampSec)
804             .mul(totalStakingShares);
805         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
806         _lastAccountingTimestampSec = now;
807 
808         // User Accounting
809         UserTotals storage totals = _userTotals[msg.sender];
810         uint256 newUserStakingShareSeconds =
811             now
812             .sub(totals.lastAccountingTimestampSec)
813             .mul(totals.stakingShares);
814         totals.stakingShareSeconds =
815             totals.stakingShareSeconds
816             .add(newUserStakingShareSeconds);
817         totals.lastAccountingTimestampSec = now;
818 
819         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
820             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
821             : 0;
822 
823         return (
824             totalLocked(),
825             totalUnlocked(),
826             totals.stakingShareSeconds,
827             _totalStakingShareSeconds,
828             totalUserRewards,
829             now
830         );
831     }
832 
833     /**
834      * @return Total number of locked distribution tokens.
835      */
836     function totalLocked() public view returns (uint256) {
837         return _lockedPool.balance();
838     }
839 
840     /**
841      * @return Total number of unlocked distribution tokens.
842      */
843     function totalUnlocked() public view returns (uint256) {
844         return _unlockedPool.balance();
845     }
846 
847     /**
848      * @return Number of unlock schedules.
849      */
850     function unlockScheduleCount() public view returns (uint256) {
851         return unlockSchedules.length;
852     }
853 
854     /**
855      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
856      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
857      *      linearly over the duraction of durationSec timeframe.
858      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
859      * @param durationSec Length of time to linear unlock the tokens.
860      */
861     function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {
862         require(unlockSchedules.length < _maxUnlockSchedules,
863             'TokenGeyser: reached maximum unlock schedules');
864 
865         // Update lockedTokens amount before using it in computations after.
866         updateAccounting();
867 
868         uint256 lockedTokens = totalLocked();
869         uint256 mintedLockedShares = (lockedTokens > 0)
870             ? totalLockedShares.mul(amount).div(lockedTokens)
871             : amount.mul(_initialSharesPerToken);
872 
873         UnlockSchedule memory schedule;
874         schedule.initialLockedShares = mintedLockedShares;
875         schedule.lastUnlockTimestampSec = now;
876         schedule.endAtSec = now.add(durationSec);
877         schedule.durationSec = durationSec;
878         unlockSchedules.push(schedule);
879 
880         totalLockedShares = totalLockedShares.add(mintedLockedShares);
881 
882         require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),
883             'TokenGeyser: transfer into locked pool failed');
884         emit TokensLocked(amount, durationSec, totalLocked());
885     }
886 
887     /**
888      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
889      *      previously defined unlock schedules. Publicly callable.
890      * @return Number of newly unlocked distribution tokens.
891      */
892     function unlockTokens() public returns (uint256) {
893         uint256 unlockedTokens = 0;
894         uint256 lockedTokens = totalLocked();
895 
896         if (totalLockedShares == 0) {
897             unlockedTokens = lockedTokens;
898         } else {
899             uint256 unlockedShares = 0;
900             for (uint256 s = 0; s < unlockSchedules.length; s++) {
901                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
902             }
903             unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);
904             totalLockedShares = totalLockedShares.sub(unlockedShares);
905         }
906 
907         if (unlockedTokens > 0) {
908             require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),
909                 'TokenGeyser: transfer out of locked pool failed');
910             emit TokensUnlocked(unlockedTokens, totalLocked());
911         }
912 
913         return unlockedTokens;
914     }
915 
916     /**
917      * @dev Returns the number of unlockable shares from a given schedule. The returned value
918      *      depends on the time since the last unlock. This function updates schedule accounting,
919      *      but does not actually transfer any tokens.
920      * @param s Index of the unlock schedule.
921      * @return The number of unlocked shares.
922      */
923     function unlockScheduleShares(uint256 s) private returns (uint256) {
924         UnlockSchedule storage schedule = unlockSchedules[s];
925 
926         if(schedule.unlockedShares >= schedule.initialLockedShares) {
927             return 0;
928         }
929 
930         uint256 sharesToUnlock = 0;
931         // Special case to handle any leftover dust from integer division
932         if (now >= schedule.endAtSec) {
933             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
934             schedule.lastUnlockTimestampSec = schedule.endAtSec;
935         } else {
936             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
937                 .mul(schedule.initialLockedShares)
938                 .div(schedule.durationSec);
939             schedule.lastUnlockTimestampSec = now;
940         }
941 
942         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
943         return sharesToUnlock;
944     }
945 
946     /**
947      * @dev Lets the owner rescue funds air-dropped to the staking pool.
948      * @param tokenToRescue Address of the token to be rescued.
949      * @param to Address to which the rescued funds are to be sent.
950      * @param amount Amount of tokens to be rescued.
951      * @return Transfer success.
952      */
953     function rescueFundsFromStakingPool(address tokenToRescue, address to, uint256 amount)
954         public onlyOwner returns (bool) {
955 
956         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
957     }
958 }