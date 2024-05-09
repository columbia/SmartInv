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
401 // File: contracts/MinePool.sol
402 
403 pragma solidity 0.5.0;
404 
405 
406 
407 
408 contract MinePool is Ownable {
409     IERC20 public shareToken;
410     IERC20 public dollarToken;
411 
412     constructor(IERC20 _shareToken, IERC20 _dollarToken) public {
413         shareToken = _shareToken;
414         dollarToken = _dollarToken;
415     }
416 
417     function shareBalance() public view returns (uint256) {
418         return shareToken.balanceOf(address(this));
419     }
420 
421     function shareTransfer(address to, uint256 value) external onlyOwner returns (bool) {
422         return shareToken.transfer(to, value);
423     }
424 
425     function dollarBalance() public view returns (uint256) {
426         return dollarToken.balanceOf(address(this));
427     }
428 
429     function dollarTransfer(address to, uint256 value) external onlyOwner returns (bool) {
430         return dollarToken.transfer(to, value);
431     }
432 }
433 
434 // File: contracts/SeigniorageMining.sol
435 
436 pragma solidity 0.5.0;
437 
438 
439 
440 
441 
442 
443 
444 /**
445  * @title Dollar Rewards
446  *      Forked from Ampleforth's GitHub and modified
447  *
448  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
449  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
450  *      claimed by users.
451  *      
452  *      Distribution tokens (SHARE) accrues USD as well.
453  *
454  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
455  *      is a function of the number of tokens deposited as well as the length of time deposited.
456  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
457  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
458  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
459  */
460 contract SeigniorageMining is IStaking, Ownable {
461     using SafeMath for uint256;
462 
463     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
464     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
465     
466     event TokensClaimed(address indexed user, uint256 amount);
467     event DollarsClaimed(address indexed user, uint256 amount);
468 
469     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
470     // amount: Unlocked tokens, total: Total locked tokens
471     event TokensUnlocked(uint256 amount, uint256 total);
472     event DollarsUnlocked(uint256 amount, uint256 total);
473 
474     TokenPool private _stakingPool;
475     MinePool private _unlockedPool;
476     MinePool private _lockedPool;
477 
478     //
479     // Global accounting state
480     //
481     uint256 public totalLockedShares = 0;
482     uint256 public totalStakingShares = 0;
483     uint256 private _totalStakingShareSeconds = 0;
484     uint256 private _lastAccountingTimestampSec = now;
485     uint256 private _maxUnlockSchedules = 0;
486     uint256 private _initialSharesPerToken = 0;
487 
488     //
489     // User accounting state
490     //
491     // Represents a single stake for a user. A user may have multiple.
492     struct Stake {
493         uint256 stakingShares;
494         uint256 timestampSec;
495     }
496 
497     // Caches aggregated values from the User->Stake[] map to save computation.
498     // If lastAccountingTimestampSec is 0, there's no entry for that user.
499     struct UserTotals {
500         uint256 stakingShares;
501         uint256 stakingShareSeconds;
502         uint256 lastAccountingTimestampSec;
503     }
504 
505     // Aggregated staking values per user
506     mapping(address => UserTotals) private _userTotals;
507 
508     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
509     mapping(address => Stake[]) private _userStakes;
510 
511     //
512     // Locked/Unlocked Accounting state
513     //
514     struct UnlockSchedule {
515         uint256 initialLockedShares;
516         uint256 unlockedShares;
517         uint256 lastUnlockTimestampSec;
518         uint256 startAtSec;
519         uint256 endAtSec;
520         uint256 durationSec;
521     }
522 
523     UnlockSchedule[] public unlockSchedules;
524 
525     /**
526      * @param stakingToken The token users deposit as stake.
527      * @param shareToken Token 1 users receive as they unstake.
528      * @param dollarToken Token 2 users receive as they unstake.
529      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
530      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
531      */
532     constructor(IERC20 stakingToken, IERC20 shareToken, IERC20 dollarToken, uint256 maxUnlockSchedules,
533             uint256 initialSharesPerToken) public {
534         require(initialSharesPerToken > 0, 'SeigniorageMining: initialSharesPerToken is zero');
535 
536         _stakingPool = new TokenPool(stakingToken);
537         _unlockedPool = new MinePool(shareToken, dollarToken);
538         _lockedPool = new MinePool(shareToken, dollarToken);
539         _maxUnlockSchedules = maxUnlockSchedules;
540         _initialSharesPerToken = initialSharesPerToken;
541     }
542 
543     /**
544      * @return The token users deposit as stake.
545      */
546     function getStakingToken() public view returns (IERC20) {
547         return _stakingPool.token();
548     }
549 
550     /**
551      * @return The token users receive as they unstake.
552      */
553     function getDistributionToken() public view returns (IERC20) {
554         assert(_unlockedPool.shareToken() == _lockedPool.shareToken());
555         return _unlockedPool.shareToken();
556     }
557 
558     /**
559      * @dev Transfers amount of deposit tokens from the user.
560      * @param amount Number of deposit tokens to stake.
561      * @param data Not used.
562      */
563     function stake(uint256 amount, bytes calldata data) external {
564         _stakeFor(msg.sender, msg.sender, amount);
565     }
566 
567     /**
568      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
569      * @param user User address who gains credit for this stake operation.
570      * @param amount Number of deposit tokens to stake.
571      * @param data Not used.
572      */
573     function stakeFor(address user, uint256 amount, bytes calldata data) external {
574         _stakeFor(msg.sender, user, amount);
575     }
576 
577     /**
578      * @dev Private implementation of staking methods.
579      * @param staker User address who deposits tokens to stake.
580      * @param beneficiary User address who gains credit for this stake operation.
581      * @param amount Number of deposit tokens to stake.
582      */
583     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
584         require(amount > 0, 'SeigniorageMining: stake amount is zero');
585         require(beneficiary != address(0), 'SeigniorageMining: beneficiary is zero address');
586         require(totalStakingShares == 0 || totalStaked() > 0,
587                 'SeigniorageMining: Invalid state. Staking shares exist, but no staking tokens do');
588 
589         uint256 mintedStakingShares = (totalStakingShares > 0)
590             ? totalStakingShares.mul(amount).div(totalStaked())
591             : amount.mul(_initialSharesPerToken);
592         require(mintedStakingShares > 0, 'SeigniorageMining: Stake amount is too small');
593 
594         updateAccounting();
595 
596         // 1. User Accounting
597         UserTotals storage totals = _userTotals[beneficiary];
598         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
599         totals.lastAccountingTimestampSec = now;
600 
601         Stake memory newStake = Stake(mintedStakingShares, now);
602         _userStakes[beneficiary].push(newStake);
603 
604         // 2. Global Accounting
605         totalStakingShares = totalStakingShares.add(mintedStakingShares);
606         // Already set in updateAccounting()
607         // _lastAccountingTimestampSec = now;
608 
609         // interactions
610         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
611             'SeigniorageMining: transfer into staking pool failed');
612 
613         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
614     }
615 
616     /**
617      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
618      * alotted number of distribution tokens.
619      * @param amount Number of deposit tokens to unstake / withdraw.
620      * @param data Not used.
621      */
622     function unstake(uint256 amount, bytes calldata data) external {
623         _unstake(amount);
624     }
625 
626     /**
627      * @param amount Number of deposit tokens to unstake / withdraw.
628      * @return The total number of distribution tokens that would be rewarded.
629      */
630     function unstakeQuery(uint256 amount) public returns (uint256, uint256) {
631         return _unstake(amount);
632     }
633 
634     /**
635      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
636      * alotted number of distribution tokens.
637      * @param amount Number of deposit tokens to unstake / withdraw.
638      * @return The total number of distribution tokens rewarded.
639      */
640     function _unstake(uint256 amount) private returns (uint256, uint256) {
641         updateAccounting();
642 
643         // checks
644         require(amount > 0, 'SeigniorageMining: unstake amount is zero');
645         require(totalStakedFor(msg.sender) >= amount,
646             'SeigniorageMining: unstake amount is greater than total user stakes');
647         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
648         require(stakingSharesToBurn > 0, 'SeigniorageMining: Unable to unstake amount this small');
649 
650         // 1. User Accounting
651         UserTotals storage totals = _userTotals[msg.sender];
652         Stake[] storage accountStakes = _userStakes[msg.sender];
653 
654         // Redeem from most recent stake and go backwards in time.
655         uint256 stakingShareSecondsToBurn = 0;
656         uint256 sharesLeftToBurn = stakingSharesToBurn;
657         uint256 rewardAmount = 0;
658         uint256 rewardDollarAmount = 0;
659         while (sharesLeftToBurn > 0) {
660             Stake storage lastStake = accountStakes[accountStakes.length - 1];
661             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
662             uint256 newStakingShareSecondsToBurn = 0;
663             if (lastStake.stakingShares <= sharesLeftToBurn) {
664                 // fully redeem a past stake
665                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
666                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn);
667                 rewardDollarAmount = computeNewDollarReward(rewardDollarAmount, newStakingShareSecondsToBurn);
668                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
669                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
670                 accountStakes.length--;
671             } else {
672                 // partially redeem a past stake
673                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
674                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn);
675                 rewardDollarAmount = computeNewDollarReward(rewardDollarAmount, newStakingShareSecondsToBurn);
676                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
677                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
678                 sharesLeftToBurn = 0;
679             }
680         }
681         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
682         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
683         // Already set in updateAccounting
684         // totals.lastAccountingTimestampSec = now;
685 
686         // 2. Global Accounting
687         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
688         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
689         // Already set in updateAccounting
690         // _lastAccountingTimestampSec = now;
691 
692         // interactions
693         require(_stakingPool.transfer(msg.sender, amount),
694             'SeigniorageMining: transfer out of staking pool failed');
695         require(_unlockedPool.shareTransfer(msg.sender, rewardAmount),
696             'SeigniorageMining: shareTransfer out of unlocked pool failed');
697         require(_unlockedPool.dollarTransfer(msg.sender, rewardDollarAmount),
698             'SeigniorageMining: dollarTransfer out of unlocked pool failed');
699 
700         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
701         emit TokensClaimed(msg.sender, rewardAmount);
702         emit DollarsClaimed(msg.sender, rewardDollarAmount);
703 
704         require(totalStakingShares == 0 || totalStaked() > 0,
705                 "SeigniorageMining: Error unstaking. Staking shares exist, but no staking tokens do");
706         return (rewardAmount, rewardDollarAmount);
707     }
708 
709     /**
710      * @param currentRewardTokens The current number of distribution tokens already alotted for this
711      *                            unstake op.
712      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
713      *                            distribution tokens.
714      * @return Updated amount of distribution tokens to award.
715      */
716     function computeNewReward(uint256 currentRewardTokens,
717                                 uint256 stakingShareSeconds) private view returns (uint256) {
718 
719         uint256 newRewardTokens =
720             totalUnlocked()
721             .mul(stakingShareSeconds)
722             .div(_totalStakingShareSeconds);
723 
724         return currentRewardTokens.add(newRewardTokens);
725     }
726 
727     function computeNewDollarReward(uint256 currentRewardTokens,
728                                 uint256 stakingShareSeconds) private view returns (uint256) {
729 
730         uint256 newRewardTokens =
731             totalUnlockedDollars()
732             .mul(stakingShareSeconds)
733             .div(_totalStakingShareSeconds);
734 
735         return currentRewardTokens.add(newRewardTokens);
736     }
737 
738     /**
739      * @param addr The user to look up staking information for.
740      * @return The number of staking tokens deposited for addr.
741      */
742     function totalStakedFor(address addr) public view returns (uint256) {
743         return totalStakingShares > 0 ?
744             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
745     }
746 
747     /**
748      * @return The total number of deposit tokens staked globally, by all users.
749      */
750     function totalStaked() public view returns (uint256) {
751         return _stakingPool.balance();
752     }
753 
754     /**
755      * @dev Note that this application has a staking token as well as a distribution token, which
756      * may be different. This function is required by EIP-900.
757      * @return The deposit token used for staking.
758      */
759     function token() external view returns (address) {
760         return address(getStakingToken());
761     }
762 
763     function totalUserShareRewards(address user) external view returns (uint256) {
764         UserTotals storage totals = _userTotals[user];
765 
766         return (_totalStakingShareSeconds > 0)
767             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
768             : 0;
769     }
770 
771     function totalUserDollarRewards(address user) external view returns (uint256) {
772         UserTotals storage totals = _userTotals[user];
773 
774         return (_totalStakingShareSeconds > 0)
775             ? totalLockedDollars().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
776             : 0;
777     }
778 
779     function totalUserDollarRewardsFixed(address user) external view returns (uint256) {
780         UserTotals storage totals = _userTotals[user];
781 
782         return (_totalStakingShareSeconds > 0)
783             ? totalUnlockedDollars().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
784             : 0;
785     }
786 
787     /**
788      * @dev A globally callable function to update the accounting state of the system.
789      *      Global state and state for the caller are updated.
790      * @return [0] balance of the locked pool
791      * @return [1] balance of the unlocked pool
792      * @return [2] caller's staking share seconds
793      * @return [3] global staking share seconds
794      * @return [4] Rewards caller has accumulated
795      * @return [5] Dollar Rewards caller has accumulated
796      * @return [6] block timestamp
797      */
798     function updateAccounting() public returns (
799         uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
800 
801         unlockTokens();
802 
803         // Global accounting
804         uint256 newStakingShareSeconds =
805             now
806             .sub(_lastAccountingTimestampSec)
807             .mul(totalStakingShares);
808         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
809         _lastAccountingTimestampSec = now;
810 
811         // User Accounting
812         UserTotals storage totals = _userTotals[msg.sender];
813         uint256 newUserStakingShareSeconds =
814             now
815             .sub(totals.lastAccountingTimestampSec)
816             .mul(totals.stakingShares);
817         totals.stakingShareSeconds =
818             totals.stakingShareSeconds
819             .add(newUserStakingShareSeconds);
820         totals.lastAccountingTimestampSec = now;
821 
822         uint256 totalUserShareRewards = (_totalStakingShareSeconds > 0)
823             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
824             : 0;
825     
826         uint256 totalUserDollarRewards = (_totalStakingShareSeconds > 0)
827             ? totalLockedDollars().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
828             : 0;
829 
830         return (
831             totalLocked(),
832             totalUnlocked(),
833             totals.stakingShareSeconds,
834             _totalStakingShareSeconds,
835             totalUserShareRewards,
836             totalUserDollarRewards,
837             now
838         );
839     }
840 
841     /**
842      * @return Total number of locked distribution tokens.
843      */
844     function totalLocked() public view returns (uint256) {
845         return _lockedPool.shareBalance();
846     }
847 
848     /**
849      * @return Total number of unlocked distribution tokens.
850      */
851     function totalUnlocked() public view returns (uint256) {
852         return _unlockedPool.shareBalance();
853     }
854 
855     /**
856      * @return Total number of locked distribution tokens.
857      */
858     function totalLockedDollars() public view returns (uint256) {
859         return _lockedPool.dollarBalance();
860     }
861 
862     /**
863      * @return Total number of unlocked distribution tokens.
864      */
865     function totalUnlockedDollars() public view returns (uint256) {
866         return _unlockedPool.dollarBalance();
867     }
868 
869     /**
870      * @return Number of unlock schedules.
871      */
872     function unlockScheduleCount() public view returns (uint256) {
873         return unlockSchedules.length;
874     }
875 
876     function changeStakingToken(IERC20 stakingToken) external onlyOwner {
877         _stakingPool = new TokenPool(stakingToken);
878     }
879 
880     /**
881      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
882      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
883      *      linearly over the duraction of durationSec timeframe.
884      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
885      * @param durationSec Length of time to linear unlock the tokens.
886      */
887     function lockTokens(uint256 amount, uint256 startTimeSec, uint256 durationSec) external onlyOwner {
888         require(unlockSchedules.length < _maxUnlockSchedules,
889             'SeigniorageMining: reached maximum unlock schedules');
890 
891         // Update lockedTokens amount before using it in computations after.
892         updateAccounting();
893 
894         uint256 lockedTokens = totalLocked();
895         uint256 mintedLockedShares = (lockedTokens > 0)
896             ? totalLockedShares.mul(amount).div(lockedTokens)
897             : amount.mul(_initialSharesPerToken);
898 
899         UnlockSchedule memory schedule;
900         schedule.initialLockedShares = mintedLockedShares;
901         schedule.lastUnlockTimestampSec = now;
902         schedule.startAtSec = startTimeSec;
903         schedule.endAtSec = startTimeSec.add(durationSec);
904         schedule.durationSec = durationSec;
905         unlockSchedules.push(schedule);
906 
907         totalLockedShares = totalLockedShares.add(mintedLockedShares);
908 
909         require(_lockedPool.shareToken().transferFrom(msg.sender, address(_lockedPool), amount),
910             'SeigniorageMining: transfer into locked pool failed');
911         emit TokensLocked(amount, durationSec, totalLocked());
912     }
913 
914     /**
915      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
916      *      previously defined unlock schedules. Publicly callable.
917      * @return Number of newly unlocked distribution tokens.
918      */
919     function unlockTokens() public returns (uint256) {
920         uint256 unlockedShareTokens = 0;
921         uint256 lockedShareTokens = totalLocked();
922 
923         uint256 unlockedDollars = 0;
924         uint256 lockedDollars = totalLockedDollars();
925 
926         if (totalLockedShares == 0) {
927             unlockedShareTokens = lockedShareTokens;
928             unlockedDollars = lockedDollars;
929         } else {
930             uint256 unlockedShares = 0;
931             for (uint256 s = 0; s < unlockSchedules.length; s++) {
932                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
933             }
934             unlockedShareTokens = unlockedShares.mul(lockedShareTokens).div(totalLockedShares);
935             unlockedDollars = unlockedShares.mul(lockedDollars).div(totalLockedShares);
936             totalLockedShares = totalLockedShares.sub(unlockedShares);
937         }
938 
939         if (unlockedShareTokens > 0) {
940             require(_lockedPool.shareTransfer(address(_unlockedPool), unlockedShareTokens),
941                 'SeigniorageMining: shareTransfer out of locked pool failed');
942             require(_lockedPool.dollarTransfer(address(_unlockedPool), unlockedDollars),
943                 'SeigniorageMining: dollarTransfer out of locked pool failed');
944 
945             emit TokensUnlocked(unlockedShareTokens, totalLocked());
946             emit DollarsUnlocked(unlockedDollars, totalLocked());
947         }
948 
949         return unlockedShareTokens;
950     }
951 
952     /**
953      * @dev Returns the number of unlockable shares from a given schedule. The returned value
954      *      depends on the time since the last unlock. This function updates schedule accounting,
955      *      but does not actually transfer any tokens.
956      * @param s Index of the unlock schedule.
957      * @return The number of unlocked shares.
958      */
959     function unlockScheduleShares(uint256 s) private returns (uint256) {
960         UnlockSchedule storage schedule = unlockSchedules[s];
961 
962         if(schedule.unlockedShares >= schedule.initialLockedShares) {
963             return 0;
964         }
965 
966         uint256 sharesToUnlock = 0;
967         if (now < schedule.startAtSec) {
968             // do nothing
969         } else if (now >= schedule.endAtSec) { // Special case to handle any leftover dust from integer division
970             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
971             schedule.lastUnlockTimestampSec = schedule.endAtSec;
972         } else {
973             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
974                 .mul(schedule.initialLockedShares)
975                 .div(schedule.durationSec);
976             schedule.lastUnlockTimestampSec = now;
977         }
978 
979         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
980         return sharesToUnlock;
981     }
982 }