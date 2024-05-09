1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-15
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-08-15
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-07-11
11 */
12 
13 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
14 
15 pragma solidity ^0.5.0;
16 
17 /**
18  * @dev Wrappers over Solidity's arithmetic operations with added overflow
19  * checks.
20  *
21  * Arithmetic operations in Solidity wrap on overflow. This can easily result
22  * in bugs, because programmers usually assume that an overflow raises an
23  * error, which is the standard behavior in high level programming languages.
24  * `SafeMath` restores this intuition by reverting the transaction when an
25  * operation overflows.
26  *
27  * Using this library instead of the unchecked operations eliminates an entire
28  * class of bugs, so it's recommended to use it always.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, reverting on
33      * overflow.
34      *
35      * Counterpart to Solidity's `+` operator.
36      *
37      * Requirements:
38      * - Addition cannot overflow.
39      */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot overflow.
68      *
69      * _Available since v2.4.0._
70      */
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      *
127      * _Available since v2.4.0._
128      */
129     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         // Solidity only automatically asserts when dividing by 0
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, "SafeMath: modulo by zero");
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts with custom message when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      *
164      * _Available since v2.4.0._
165      */
166     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b != 0, errorMessage);
168         return a % b;
169     }
170 }
171 
172 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
173 
174 pragma solidity ^0.5.0;
175 
176 /**
177  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
178  * the optional functions; to access them see {ERC20Detailed}.
179  */
180 interface IERC20 {
181     /**
182      * @dev Returns the amount of tokens in existence.
183      */
184     function totalSupply() external view returns (uint256);
185 
186     /**
187      * @dev Returns the amount of tokens owned by `account`.
188      */
189     function balanceOf(address account) external view returns (uint256);
190 
191     /**
192      * @dev Moves `amount` tokens from the caller's account to `recipient`.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transfer(address recipient, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Returns the remaining number of tokens that `spender` will be
202      * allowed to spend on behalf of `owner` through {transferFrom}. This is
203      * zero by default.
204      *
205      * This value changes when {approve} or {transferFrom} are called.
206      */
207     function allowance(address owner, address spender) external view returns (uint256);
208 
209     /**
210      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * IMPORTANT: Beware that changing an allowance with this method brings the risk
215      * that someone may use both the old and the new allowance by unfortunate
216      * transaction ordering. One possible solution to mitigate this race
217      * condition is to first reduce the spender's allowance to 0 and set the
218      * desired value afterwards:
219      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address spender, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Moves `amount` tokens from `sender` to `recipient` using the
227      * allowance mechanism. `amount` is then deducted from the caller's
228      * allowance.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * Emits a {Transfer} event.
233      */
234     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Emitted when `value` tokens are moved from one account (`from`) to
238      * another (`to`).
239      *
240      * Note that `value` may be zero.
241      */
242     event Transfer(address indexed from, address indexed to, uint256 value);
243 
244     /**
245      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
246      * a call to {approve}. `value` is the new allowance.
247      */
248     event Approval(address indexed owner, address indexed spender, uint256 value);
249 }
250 
251 // File: openzeppelin-solidity/contracts/GSN/Context.sol
252 
253 pragma solidity ^0.5.0;
254 
255 /*
256  * @dev Provides information about the current execution context, including the
257  * sender of the transaction and its data. While these are generally available
258  * via msg.sender and msg.data, they should not be accessed in such a direct
259  * manner, since when dealing with GSN meta-transactions the account sending and
260  * paying for execution may not be the actual sender (as far as an application
261  * is concerned).
262  *
263  * This contract is only required for intermediate, library-like contracts.
264  */
265 contract Context {
266     // Empty internal constructor, to prevent people from mistakenly deploying
267     // an instance of this contract, which should be used via inheritance.
268     constructor () internal { }
269     // solhint-disable-previous-line no-empty-blocks
270 
271     function _msgSender() internal view returns (address payable) {
272         return msg.sender;
273     }
274 
275     function _msgData() internal view returns (bytes memory) {
276         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
277         return msg.data;
278     }
279 }
280 
281 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
282 
283 pragma solidity ^0.5.0;
284 
285 /**
286  * @dev Contract module which provides a basic access control mechanism, where
287  * there is an account (an owner) that can be granted exclusive access to
288  * specific functions.
289  *
290  * This module is used through inheritance. It will make available the modifier
291  * `onlyOwner`, which can be applied to your functions to restrict their use to
292  * the owner.
293  */
294 contract Ownable is Context {
295     address private _owner;
296 
297     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
298 
299     /**
300      * @dev Initializes the contract setting the deployer as the initial owner.
301      */
302     constructor () internal {
303         _owner = _msgSender();
304         emit OwnershipTransferred(address(0), _owner);
305     }
306 
307     /**
308      * @dev Returns the address of the current owner.
309      */
310     function owner() public view returns (address) {
311         return _owner;
312     }
313 
314     /**
315      * @dev Throws if called by any account other than the owner.
316      */
317     modifier onlyOwner() {
318         require(isOwner(), "Ownable: caller is not the owner");
319         _;
320     }
321 
322     /**
323      * @dev Returns true if the caller is the current owner.
324      */
325     function isOwner() public view returns (bool) {
326         return _msgSender() == _owner;
327     }
328 
329     /**
330      * @dev Leaves the contract without owner. It will not be possible to call
331      * `onlyOwner` functions anymore. Can only be called by the current owner.
332      *
333      * NOTE: Renouncing ownership will leave the contract without an owner,
334      * thereby removing any functionality that is only available to the owner.
335      */
336     function renounceOwnership() public onlyOwner {
337         emit OwnershipTransferred(_owner, address(0));
338         _owner = address(0);
339     }
340 
341     /**
342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
343      * Can only be called by the current owner.
344      */
345     function transferOwnership(address newOwner) public onlyOwner {
346         _transferOwnership(newOwner);
347     }
348 
349     /**
350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
351      */
352     function _transferOwnership(address newOwner) internal {
353         require(newOwner != address(0), "Ownable: new owner is the zero address");
354         emit OwnershipTransferred(_owner, newOwner);
355         _owner = newOwner;
356     }
357 }
358 
359 // File: contracts/IStaking.sol
360 
361 pragma solidity 0.5.0;
362 
363 /**
364  * @title Staking interface, as defined by EIP-900.
365  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
366  */
367 contract IStaking {
368     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
369     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
370 
371     function stake(uint256 amount, bytes calldata data) external;
372     function stakeFor(address user, uint256 amount, bytes calldata data) external;
373     function unstake(uint256 amount, bytes calldata data) external;
374     function totalStakedFor(address addr) public view returns (uint256);
375     function totalStaked() public view returns (uint256);
376     function token() external view returns (address);
377 
378     /**
379      * @return False. This application does not support staking history.
380      */
381     function supportsHistory() external pure returns (bool) {
382         return false;
383     }
384 }
385 
386 // File: contracts/TokenPool.sol
387 
388 pragma solidity 0.5.0;
389 
390 
391 
392 /**
393  * @title A simple holder of tokens.
394  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
395  * needs to hold multiple distinct pools of the same token.
396  */
397 contract TokenPool is Ownable {
398     IERC20 public token;
399 
400     constructor(IERC20 _token) public {
401         token = _token;
402     }
403 
404     function balance() public view returns (uint256) {
405         return token.balanceOf(address(this));
406     }
407 
408     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
409         return token.transfer(to, value);
410     }
411 }
412 
413 // File: contracts/TokenGeyser.sol
414 
415 pragma solidity 0.5.0;
416 
417 
418 
419 
420 
421 
422 /**
423  * @title Token Geyser
424  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
425  *      Compound and Uniswap.
426  *
427  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
428  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
429  *      claimed by users.
430  *
431  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
432  *      is a function of the number of tokens deposited as well as the length of time deposited.
433  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
434  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
435  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
436  *
437  *      More background and motivation available at:
438  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
439  */
440 contract TokenGeyser is IStaking, Ownable {
441     using SafeMath for uint256;
442 
443     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
444     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
445     event TokensClaimed(address indexed user, uint256 amount);
446     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
447     // amount: Unlocked tokens, total: Total locked tokens
448     event TokensUnlocked(uint256 amount, uint256 total);
449 
450     TokenPool private _stakingPool;
451     TokenPool private _unlockedPool;
452     TokenPool private _lockedPool;
453 
454     //
455     // Time-bonus params
456     //
457     uint256 public constant BONUS_DECIMALS = 2;
458     uint256 public startBonus = 0;
459     uint256 public bonusPeriodSec = 0;
460 
461     //
462     // Global accounting state
463     //
464     uint256 public totalLockedShares = 0;
465     uint256 public totalStakingShares = 0;
466     uint256 private _totalStakingShareSeconds = 0;
467     uint256 private _lastAccountingTimestampSec = now;
468     uint256 private _maxUnlockSchedules = 0;
469     uint256 private _initialSharesPerToken = 0;
470 
471     //
472     // User accounting state
473     //
474     // Represents a single stake for a user. A user may have multiple.
475     struct Stake {
476         uint256 stakingShares;
477         uint256 timestampSec;
478     }
479 
480     // Caches aggregated values from the User->Stake[] map to save computation.
481     // If lastAccountingTimestampSec is 0, there's no entry for that user.
482     struct UserTotals {
483         uint256 stakingShares;
484         uint256 stakingShareSeconds;
485         uint256 lastAccountingTimestampSec;
486     }
487 
488     // Aggregated staking values per user
489     mapping(address => UserTotals) private _userTotals;
490 
491     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
492     mapping(address => Stake[]) private _userStakes;
493 
494     //
495     // Locked/Unlocked Accounting state
496     //
497     struct UnlockSchedule {
498         uint256 initialLockedShares;
499         uint256 unlockedShares;
500         uint256 lastUnlockTimestampSec;
501         uint256 endAtSec;
502         uint256 durationSec;
503     }
504 
505     UnlockSchedule[] public unlockSchedules;
506 
507     /**
508      * @param stakingToken The token users deposit as stake.
509      * @param distributionToken The token users receive as they unstake.
510      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
511      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
512      *                    e.g. 25% means user gets 25% of max distribution tokens.
513      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
514      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
515      */
516     constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,
517                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {
518         // The start bonus must be some fraction of the max. (i.e. <= 100%)
519         require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');
520         // If no period is desired, instead set startBonus = 100%
521         // and bonusPeriod to a small value like 1sec.
522         require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');
523         require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');
524 
525         _stakingPool = new TokenPool(stakingToken);
526         _unlockedPool = new TokenPool(distributionToken);
527         _lockedPool = new TokenPool(distributionToken);
528         startBonus = startBonus_;
529         bonusPeriodSec = bonusPeriodSec_;
530         _maxUnlockSchedules = maxUnlockSchedules;
531         _initialSharesPerToken = initialSharesPerToken;
532     }
533 
534     /**
535      * @return The token users deposit as stake.
536      */
537     function getStakingToken() public view returns (IERC20) {
538         return _stakingPool.token();
539     }
540 
541     /**
542      * @return The token users receive as they unstake.
543      */
544     function getDistributionToken() public view returns (IERC20) {
545         assert(_unlockedPool.token() == _lockedPool.token());
546         return _unlockedPool.token();
547     }
548 
549     /**
550      * @dev Transfers amount of deposit tokens from the user.
551      * @param amount Number of deposit tokens to stake.
552      * @param data Not used.
553      */
554     function stake(uint256 amount, bytes calldata data) external {
555         _stakeFor(msg.sender, msg.sender, amount);
556     }
557 
558     /**
559      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
560      * @param user User address who gains credit for this stake operation.
561      * @param amount Number of deposit tokens to stake.
562      * @param data Not used.
563      */
564     function stakeFor(address user, uint256 amount, bytes calldata data) external onlyOwner {
565         _stakeFor(msg.sender, user, amount);
566     }
567 
568     /**
569      * @dev Private implementation of staking methods.
570      * @param staker User address who deposits tokens to stake.
571      * @param beneficiary User address who gains credit for this stake operation.
572      * @param amount Number of deposit tokens to stake.
573      */
574     function _stakeFor(address staker, address beneficiary, uint256 amount) private {
575         require(amount > 0, 'TokenGeyser: stake amount is zero');
576         require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');
577         require(totalStakingShares == 0 || totalStaked() > 0,
578                 'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');
579 
580         uint256 mintedStakingShares = (totalStakingShares > 0)
581             ? totalStakingShares.mul(amount).div(totalStaked())
582             : amount.mul(_initialSharesPerToken);
583         require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');
584 
585         updateAccounting();
586 
587         // 1. User Accounting
588         UserTotals storage totals = _userTotals[beneficiary];
589         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
590         totals.lastAccountingTimestampSec = now;
591 
592         Stake memory newStake = Stake(mintedStakingShares, now);
593         _userStakes[beneficiary].push(newStake);
594 
595         // 2. Global Accounting
596         totalStakingShares = totalStakingShares.add(mintedStakingShares);
597         // Already set in updateAccounting()
598         // _lastAccountingTimestampSec = now;
599 
600         // interactions
601         require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),
602             'TokenGeyser: transfer into staking pool failed');
603 
604         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
605     }
606 
607     /**
608      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
609      * alotted number of distribution tokens.
610      * @param amount Number of deposit tokens to unstake / withdraw.
611      * @param data Not used.
612      */
613     function unstake(uint256 amount, bytes calldata data) external {
614         _unstake(amount);
615     }
616 
617     /**
618      * @param amount Number of deposit tokens to unstake / withdraw.
619      * @return The total number of distribution tokens that would be rewarded.
620      */
621     function unstakeQuery(uint256 amount) public returns (uint256) {
622         return _unstake(amount);
623     }
624 
625     /**
626      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
627      * alotted number of distribution tokens.
628      * @param amount Number of deposit tokens to unstake / withdraw.
629      * @return The total number of distribution tokens rewarded.
630      */
631     function _unstake(uint256 amount) private returns (uint256) {
632         updateAccounting();
633 
634         // checks
635         require(amount > 0, 'TokenGeyser: unstake amount is zero');
636         require(totalStakedFor(msg.sender) >= amount,
637             'TokenGeyser: unstake amount is greater than total user stakes');
638         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
639         require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');
640 
641         // 1. User Accounting
642         UserTotals storage totals = _userTotals[msg.sender];
643         Stake[] storage accountStakes = _userStakes[msg.sender];
644 
645         // Redeem from most recent stake and go backwards in time.
646         uint256 stakingShareSecondsToBurn = 0;
647         uint256 sharesLeftToBurn = stakingSharesToBurn;
648         uint256 rewardAmount = 0;
649         while (sharesLeftToBurn > 0) {
650             Stake storage lastStake = accountStakes[accountStakes.length - 1];
651             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
652             uint256 newStakingShareSecondsToBurn = 0;
653             if (lastStake.stakingShares <= sharesLeftToBurn) {
654                 // fully redeem a past stake
655                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
656                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
657                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
658                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
659                 accountStakes.length--;
660             } else {
661                 // partially redeem a past stake
662                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);
663                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
664                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
665                 lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);
666                 sharesLeftToBurn = 0;
667             }
668         }
669         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);
670         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
671         // Already set in updateAccounting
672         // totals.lastAccountingTimestampSec = now;
673 
674         // 2. Global Accounting
675         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
676         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
677         // Already set in updateAccounting
678         // _lastAccountingTimestampSec = now;
679 
680         // interactions
681         require(_stakingPool.transfer(msg.sender, amount),
682             'TokenGeyser: transfer out of staking pool failed');
683         require(_unlockedPool.transfer(msg.sender, rewardAmount),
684             'TokenGeyser: transfer out of unlocked pool failed');
685 
686         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
687         emit TokensClaimed(msg.sender, rewardAmount);
688 
689         require(totalStakingShares == 0 || totalStaked() > 0,
690                 "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");
691         return rewardAmount;
692     }
693 
694     /**
695      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
696      *      encourage long-term deposits instead of constant unstake/restakes.
697      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
698      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
699      * @param currentRewardTokens The current number of distribution tokens already alotted for this
700      *                            unstake op. Any bonuses are already applied.
701      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
702      *                            distribution tokens.
703      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
704      *                     the time-bonus.
705      * @return Updated amount of distribution tokens to award, with any bonus included on the
706      *         newly added tokens.
707      */
708     function computeNewReward(uint256 currentRewardTokens,
709                                 uint256 stakingShareSeconds,
710                                 uint256 stakeTimeSec) private view returns (uint256) {
711 
712         uint256 newRewardTokens =
713             totalUnlocked()
714             .mul(stakingShareSeconds)
715             .div(_totalStakingShareSeconds);
716 
717         if (stakeTimeSec >= bonusPeriodSec) {
718             return currentRewardTokens.add(newRewardTokens);
719         }
720 
721         uint256 oneHundredPct = 10**BONUS_DECIMALS;
722         uint256 bonusedReward =
723             startBonus
724             .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))
725             .mul(newRewardTokens)
726             .div(oneHundredPct);
727         return currentRewardTokens.add(bonusedReward);
728     }
729 
730     /**
731      * @param addr The user to look up staking information for.
732      * @return The number of staking tokens deposited for addr.
733      */
734     function totalStakedFor(address addr) public view returns (uint256) {
735         return totalStakingShares > 0 ?
736             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
737     }
738 
739     /**
740      * @return The total number of deposit tokens staked globally, by all users.
741      */
742     function totalStaked() public view returns (uint256) {
743         return _stakingPool.balance();
744     }
745 
746     /**
747      * @dev Note that this application has a staking token as well as a distribution token, which
748      * may be different. This function is required by EIP-900.
749      * @return The deposit token used for staking.
750      */
751     function token() external view returns (address) {
752         return address(getStakingToken());
753     }
754 
755     /**
756      * @dev A globally callable function to update the accounting state of the system.
757      *      Global state and state for the caller are updated.
758      * @return [0] balance of the locked pool
759      * @return [1] balance of the unlocked pool
760      * @return [2] caller's staking share seconds
761      * @return [3] global staking share seconds
762      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
763      * @return [5] block timestamp
764      */
765     function updateAccounting() public returns (
766         uint256, uint256, uint256, uint256, uint256, uint256) {
767 
768         unlockTokens();
769 
770         // Global accounting
771         uint256 newStakingShareSeconds =
772             now
773             .sub(_lastAccountingTimestampSec)
774             .mul(totalStakingShares);
775         _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);
776         _lastAccountingTimestampSec = now;
777 
778         // User Accounting
779         UserTotals storage totals = _userTotals[msg.sender];
780         uint256 newUserStakingShareSeconds =
781             now
782             .sub(totals.lastAccountingTimestampSec)
783             .mul(totals.stakingShares);
784         totals.stakingShareSeconds =
785             totals.stakingShareSeconds
786             .add(newUserStakingShareSeconds);
787         totals.lastAccountingTimestampSec = now;
788 
789         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
790             ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)
791             : 0;
792 
793         return (
794             totalLocked(),
795             totalUnlocked(),
796             totals.stakingShareSeconds,
797             _totalStakingShareSeconds,
798             totalUserRewards,
799             now
800         );
801     }
802 
803     /**
804      * @return Total number of locked distribution tokens.
805      */
806     function totalLocked() public view returns (uint256) {
807         return _lockedPool.balance();
808     }
809 
810     /**
811      * @return Total number of unlocked distribution tokens.
812      */
813     function totalUnlocked() public view returns (uint256) {
814         return _unlockedPool.balance();
815     }
816 
817     /**
818      * @return Number of unlock schedules.
819      */
820     function unlockScheduleCount() public view returns (uint256) {
821         return unlockSchedules.length;
822     }
823 
824     /**
825      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
826      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
827      *      linearly over the duraction of durationSec timeframe.
828      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
829      * @param durationSec Length of time to linear unlock the tokens.
830      */
831     function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {
832         require(unlockSchedules.length < _maxUnlockSchedules,
833             'TokenGeyser: reached maximum unlock schedules');
834 
835         // Update lockedTokens amount before using it in computations after.
836         updateAccounting();
837 
838         uint256 lockedTokens = totalLocked();
839         uint256 mintedLockedShares = (lockedTokens > 0)
840             ? totalLockedShares.mul(amount).div(lockedTokens)
841             : amount.mul(_initialSharesPerToken);
842 
843         UnlockSchedule memory schedule;
844         schedule.initialLockedShares = mintedLockedShares;
845         schedule.lastUnlockTimestampSec = now;
846         schedule.endAtSec = now.add(durationSec);
847         schedule.durationSec = durationSec;
848         unlockSchedules.push(schedule);
849 
850         totalLockedShares = totalLockedShares.add(mintedLockedShares);
851 
852         require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),
853             'TokenGeyser: transfer into locked pool failed');
854         emit TokensLocked(amount, durationSec, totalLocked());
855     }
856 
857     /**
858      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
859      *      previously defined unlock schedules. Publicly callable.
860      * @return Number of newly unlocked distribution tokens.
861      */
862     function unlockTokens() public returns (uint256) {
863         uint256 unlockedTokens = 0;
864         uint256 lockedTokens = totalLocked();
865 
866         if (totalLockedShares == 0) {
867             unlockedTokens = lockedTokens;
868         } else {
869             uint256 unlockedShares = 0;
870             for (uint256 s = 0; s < unlockSchedules.length; s++) {
871                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
872             }
873             unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);
874             totalLockedShares = totalLockedShares.sub(unlockedShares);
875         }
876 
877         if (unlockedTokens > 0) {
878             require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),
879                 'TokenGeyser: transfer out of locked pool failed');
880             emit TokensUnlocked(unlockedTokens, totalLocked());
881         }
882 
883         return unlockedTokens;
884     }
885 
886     /**
887      * @dev Returns the number of unlockable shares from a given schedule. The returned value
888      *      depends on the time since the last unlock. This function updates schedule accounting,
889      *      but does not actually transfer any tokens.
890      * @param s Index of the unlock schedule.
891      * @return The number of unlocked shares.
892      */
893     function unlockScheduleShares(uint256 s) private returns (uint256) {
894         UnlockSchedule storage schedule = unlockSchedules[s];
895 
896         if(schedule.unlockedShares >= schedule.initialLockedShares) {
897             return 0;
898         }
899 
900         uint256 sharesToUnlock = 0;
901         // Special case to handle any leftover dust from integer division
902         if (now >= schedule.endAtSec) {
903             sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));
904             schedule.lastUnlockTimestampSec = schedule.endAtSec;
905         } else {
906             sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)
907                 .mul(schedule.initialLockedShares)
908                 .div(schedule.durationSec);
909             schedule.lastUnlockTimestampSec = now;
910         }
911 
912         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
913         return sharesToUnlock;
914     }
915 }