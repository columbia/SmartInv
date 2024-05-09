1 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: openzeppelin-solidity\contracts\utils\ReentrancyGuard.sol
219 
220 // SPDX-License-Identifier: MIT
221 
222 pragma solidity >=0.6.0 <0.8.0;
223 
224 /**
225  * @dev Contract module that helps prevent reentrant calls to a function.
226  *
227  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
228  * available, which can be applied to functions to make sure there are no nested
229  * (reentrant) calls to them.
230  *
231  * Note that because there is a single `nonReentrant` guard, functions marked as
232  * `nonReentrant` may not call one another. This can be worked around by making
233  * those functions `private`, and then adding `external` `nonReentrant` entry
234  * points to them.
235  *
236  * TIP: If you would like to learn more about reentrancy and alternative ways
237  * to protect against it, check out our blog post
238  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
239  */
240 abstract contract ReentrancyGuard {
241     // Booleans are more expensive than uint256 or any type that takes up a full
242     // word because each write operation emits an extra SLOAD to first read the
243     // slot's contents, replace the bits taken up by the boolean, and then write
244     // back. This is the compiler's defense against contract upgrades and
245     // pointer aliasing, and it cannot be disabled.
246 
247     // The values being non-zero value makes deployment a bit more expensive,
248     // but in exchange the refund on every call to nonReentrant will be lower in
249     // amount. Since refunds are capped to a percentage of the total
250     // transaction's gas, it is best to keep them low in cases like this one, to
251     // increase the likelihood of the full refund coming into effect.
252     uint256 private constant _NOT_ENTERED = 1;
253     uint256 private constant _ENTERED = 2;
254 
255     uint256 private _status;
256 
257     constructor () internal {
258         _status = _NOT_ENTERED;
259     }
260 
261     /**
262      * @dev Prevents a contract from calling itself, directly or indirectly.
263      * Calling a `nonReentrant` function from another `nonReentrant`
264      * function is not supported. It is possible to prevent this from happening
265      * by making the `nonReentrant` function external, and make it call a
266      * `private` function that does the actual work.
267      */
268     modifier nonReentrant() {
269         // On the first call to nonReentrant, _notEntered will be true
270         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
271 
272         // Any calls to nonReentrant after this point will fail
273         _status = _ENTERED;
274 
275         _;
276 
277         // By storing the original value once again, a refund is triggered (see
278         // https://eips.ethereum.org/EIPS/eip-2200)
279         _status = _NOT_ENTERED;
280     }
281 }
282 
283 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
284 
285 // SPDX-License-Identifier: MIT
286 
287 pragma solidity >=0.6.0 <0.8.0;
288 
289 /**
290  * @dev Interface of the ERC20 standard as defined in the EIP.
291  */
292 interface IERC20 {
293     /**
294      * @dev Returns the amount of tokens in existence.
295      */
296     function totalSupply() external view returns (uint256);
297 
298     /**
299      * @dev Returns the amount of tokens owned by `account`.
300      */
301     function balanceOf(address account) external view returns (uint256);
302 
303     /**
304      * @dev Moves `amount` tokens from the caller's account to `recipient`.
305      *
306      * Returns a boolean value indicating whether the operation succeeded.
307      *
308      * Emits a {Transfer} event.
309      */
310     function transfer(address recipient, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Returns the remaining number of tokens that `spender` will be
314      * allowed to spend on behalf of `owner` through {transferFrom}. This is
315      * zero by default.
316      *
317      * This value changes when {approve} or {transferFrom} are called.
318      */
319     function allowance(address owner, address spender) external view returns (uint256);
320 
321     /**
322      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * IMPORTANT: Beware that changing an allowance with this method brings the risk
327      * that someone may use both the old and the new allowance by unfortunate
328      * transaction ordering. One possible solution to mitigate this race
329      * condition is to first reduce the spender's allowance to 0 and set the
330      * desired value afterwards:
331      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address spender, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Moves `amount` tokens from `sender` to `recipient` using the
339      * allowance mechanism. `amount` is then deducted from the caller's
340      * allowance.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Emitted when `value` tokens are moved from one account (`from`) to
350      * another (`to`).
351      *
352      * Note that `value` may be zero.
353      */
354     event Transfer(address indexed from, address indexed to, uint256 value);
355 
356     /**
357      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
358      * a call to {approve}. `value` is the new allowance.
359      */
360     event Approval(address indexed owner, address indexed spender, uint256 value);
361 }
362 
363 // File: contracts\ITREASURY.sol
364 
365 // SPDX-License-Identifier: GPL-3.0-only
366 
367 pragma solidity >=0.6.0 <0.8.0;
368 
369 
370 interface ITREASURY {
371 
372     function token() external view returns (IERC20);
373 
374     function fundsAvailable() external view returns (uint256);
375 
376     function release() external;
377 }
378 
379 // File: node_modules\openzeppelin-solidity\contracts\utils\Context.sol
380 
381 // SPDX-License-Identifier: MIT
382 
383 pragma solidity >=0.6.0 <0.8.0;
384 
385 /*
386  * @dev Provides information about the current execution context, including the
387  * sender of the transaction and its data. While these are generally available
388  * via msg.sender and msg.data, they should not be accessed in such a direct
389  * manner, since when dealing with GSN meta-transactions the account sending and
390  * paying for execution may not be the actual sender (as far as an application
391  * is concerned).
392  *
393  * This contract is only required for intermediate, library-like contracts.
394  */
395 abstract contract Context {
396     function _msgSender() internal view virtual returns (address payable) {
397         return msg.sender;
398     }
399 
400     function _msgData() internal view virtual returns (bytes memory) {
401         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
402         return msg.data;
403     }
404 }
405 
406 // File: openzeppelin-solidity\contracts\access\Ownable.sol
407 
408 // SPDX-License-Identifier: MIT
409 
410 pragma solidity >=0.6.0 <0.8.0;
411 
412 /**
413  * @dev Contract module which provides a basic access control mechanism, where
414  * there is an account (an owner) that can be granted exclusive access to
415  * specific functions.
416  *
417  * By default, the owner account will be the one that deploys the contract. This
418  * can later be changed with {transferOwnership}.
419  *
420  * This module is used through inheritance. It will make available the modifier
421  * `onlyOwner`, which can be applied to your functions to restrict their use to
422  * the owner.
423  */
424 abstract contract Ownable is Context {
425     address private _owner;
426 
427     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
428 
429     /**
430      * @dev Initializes the contract setting the deployer as the initial owner.
431      */
432     constructor () internal {
433         address msgSender = _msgSender();
434         _owner = msgSender;
435         emit OwnershipTransferred(address(0), msgSender);
436     }
437 
438     /**
439      * @dev Returns the address of the current owner.
440      */
441     function owner() public view virtual returns (address) {
442         return _owner;
443     }
444 
445     /**
446      * @dev Throws if called by any account other than the owner.
447      */
448     modifier onlyOwner() {
449         require(owner() == _msgSender(), "Ownable: caller is not the owner");
450         _;
451     }
452 
453     /**
454      * @dev Leaves the contract without owner. It will not be possible to call
455      * `onlyOwner` functions anymore. Can only be called by the current owner.
456      *
457      * NOTE: Renouncing ownership will leave the contract without an owner,
458      * thereby removing any functionality that is only available to the owner.
459      */
460     function renounceOwnership() public virtual onlyOwner {
461         emit OwnershipTransferred(_owner, address(0));
462         _owner = address(0);
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Can only be called by the current owner.
468      */
469     function transferOwnership(address newOwner) public virtual onlyOwner {
470         require(newOwner != address(0), "Ownable: new owner is the zero address");
471         emit OwnershipTransferred(_owner, newOwner);
472         _owner = newOwner;
473     }
474 }
475 
476 // File: contracts\TokenPool.sol
477 
478 // SPDX-License-Identifier: GPL-3.0-only
479 
480 pragma solidity >=0.6.0 <0.8.0;
481 
482 
483 
484 /**
485  * @title A simple holder of tokens.
486  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
487  * needs to hold multiple distinct pools of the same token.
488  */
489 contract TokenPool is Ownable {
490     IERC20 public token;
491 
492     constructor(IERC20 _token) public {
493         token = _token;
494     }
495 
496     function balance() external view returns (uint256) {
497         return token.balanceOf(address(this));
498     }
499 
500     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
501         return token.transfer(to, value);
502     }
503 }
504 
505 // File: contracts\ReflectiveStake.sol
506 
507 // SPDX-License-Identifier: GPL-3.0-only
508 
509 pragma solidity >=0.6.0 <0.8.0;
510 pragma experimental ABIEncoderV2;
511 
512 
513 
514 
515 
516 contract ReflectiveStake is ReentrancyGuard{
517     using SafeMath for uint256;
518 
519     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
520     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
521     event TokensClaimed(address indexed user, uint256 amount);
522     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
523     event TokensUnlocked(uint256 amount, uint256 total);
524 
525     TokenPool private _stakingPool;
526     TokenPool private _unlockedPool;
527     ITREASURY private _reflectiveTreasury;
528 
529     uint256 public constant BONUS_DECIMALS = 2;
530     uint256 public startBonus = 0;
531     uint256 public bonusPeriodSec = 0;
532     uint256 public lockupSec = 0;
533 
534     uint256 public totalStakingShares = 0;
535     uint256 public totalStakingShareSeconds = 0;
536     uint256 public lastAccountingTimestampSec = block.timestamp;
537     uint256 private _initialSharesPerToken = 0;
538 
539     struct Stake {
540         uint256 stakingShares;
541         uint256 timestampSec;
542     }
543 
544     struct UserTotals {
545         uint256 stakingShares;
546         uint256 stakingShareSeconds;
547         uint256 lastAccountingTimestampSec;
548     }
549 
550     mapping(address => UserTotals) private _userTotals;
551 
552     mapping(address => Stake[]) private _userStakes;
553 
554     /**
555      * @param stakingToken The token users deposit as stake.
556      * @param distributionToken The token users receive as they unstake.
557      * @param reflectiveTreasury The address of the treasury contract that will fund the rewards.
558      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
559      *                    e.g. 25% means user gets 25% of max distribution tokens.
560      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
561      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
562      * @param lockupSec_ Lockup period after staking.
563      */
564     constructor(IERC20 stakingToken, IERC20 distributionToken, ITREASURY reflectiveTreasury,
565                 uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken, uint256 lockupSec_) public {
566         // The start bonus must be some fraction of the max. (i.e. <= 100%)
567         require(startBonus_ <= 10**BONUS_DECIMALS, 'ReflectiveStake: start bonus too high');
568         // If no period is desired, instead set startBonus = 100%
569         // and bonusPeriod to a small value like 1sec.
570         require(bonusPeriodSec_ > 0, 'ReflectiveStake: bonus period is zero');
571         require(initialSharesPerToken > 0, 'ReflectiveStake: initialSharesPerToken is zero');
572 
573         _stakingPool = new TokenPool(stakingToken);
574         _unlockedPool = new TokenPool(distributionToken);
575         _reflectiveTreasury = reflectiveTreasury;
576         require(_unlockedPool.token() == _reflectiveTreasury.token(), 'ReflectiveStake: distribution token does not match treasury token');
577         startBonus = startBonus_;
578         bonusPeriodSec = bonusPeriodSec_;
579         _initialSharesPerToken = initialSharesPerToken;
580         lockupSec = lockupSec_;
581     }
582 
583     function getStakingToken() public view returns (IERC20) {
584         return _stakingPool.token();
585     }
586 
587     function getDistributionToken() external view returns (IERC20) {
588         return _unlockedPool.token();
589     }
590 
591     function stake(uint256 amount) external nonReentrant {
592         require(amount > 0, 'ReflectiveStake: stake amount is zero');
593         require(totalStakingShares == 0 || totalStaked() > 0,
594                 'ReflectiveStake: Invalid state. Staking shares exist, but no staking tokens do');
595 
596         // Get Actual Amount here minus TX fee
597         uint256 transferAmount = _applyFee(amount);
598 
599         uint256 mintedStakingShares = (totalStakingShares > 0)
600             ? totalStakingShares.mul(transferAmount).div(totalStaked())
601             : transferAmount.mul(_initialSharesPerToken);
602         require(mintedStakingShares > 0, 'ReflectiveStake: Stake amount is too small');
603 
604         updateAccounting();
605 
606         // 1. User Accounting
607         UserTotals storage totals = _userTotals[msg.sender];
608         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
609         totals.lastAccountingTimestampSec = block.timestamp;
610 
611         Stake memory newStake = Stake(mintedStakingShares, block.timestamp);
612         _userStakes[msg.sender].push(newStake);
613 
614         // 2. Global Accounting
615         totalStakingShares = totalStakingShares.add(mintedStakingShares);
616 
617         // interactions
618         require(_stakingPool.token().transferFrom(msg.sender, address(_stakingPool), amount),
619             'ReflectiveStake: transfer into staking pool failed');
620 
621         emit Staked(msg.sender, transferAmount, totalStakedFor(msg.sender), "");
622     }
623 
624     /**
625      * @notice Applies token fee.  Override for tokens other than ELE.
626      */
627     function _applyFee(uint256 amount) internal pure virtual returns (uint256) {
628         uint256 tFeeHalf = amount.div(200);
629         uint256 tFee = tFeeHalf.mul(2);
630         uint256 tTransferAmount = amount.sub(tFee); 
631         return tTransferAmount;
632     }
633 
634     function unstake(uint256 amount) external nonReentrant returns (uint256) {
635         updateAccounting();
636         return _unstake(amount);
637     }
638 
639     function unstakeMax() external nonReentrant returns (uint256) {
640         updateAccounting();
641         return _unstake(totalStakedFor(msg.sender));
642     }
643 
644     function _unstake(uint256 amount) private returns (uint256) {
645         // checks
646         require(amount > 0, 'ReflectiveStake: unstake amount is zero');
647         require(totalStakedFor(msg.sender) >= amount,
648             'ReflectiveStake: unstake amount is greater than total user stakes');
649         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());
650         require(stakingSharesToBurn > 0, 'ReflectiveStake: Unable to unstake amount this small');
651 
652         // 1. User Accounting
653         UserTotals storage totals = _userTotals[msg.sender];
654         Stake[] storage accountStakes = _userStakes[msg.sender];
655 
656         Stake memory mostRecentStake = accountStakes[accountStakes.length - 1];
657         require(block.timestamp.sub(mostRecentStake.timestampSec) > lockupSec, 'ReflectiveStake: Cannot unstake before the lockup period has expired');
658 
659         // Redeem from most recent stake and go backwards in time.
660         uint256 stakingShareSecondsToBurn = 0;
661         uint256 sharesLeftToBurn = stakingSharesToBurn;
662         uint256 rewardAmount = 0;
663         while (sharesLeftToBurn > 0) {
664             Stake storage lastStake = accountStakes[accountStakes.length - 1];
665             uint256 stakeTimeSec = block.timestamp.sub(lastStake.timestampSec);
666             uint256 newStakingShareSecondsToBurn = 0;
667             if (lastStake.stakingShares <= sharesLeftToBurn) {
668                 // fully redeem a past stake
669                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);
670                 rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);
671                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);
672                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);
673                 accountStakes.pop();
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
685 
686         // 2. Global Accounting
687         totalStakingShareSeconds = totalStakingShareSeconds.sub(stakingShareSecondsToBurn);
688         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
689 
690         // interactions
691         require(_stakingPool.transfer(msg.sender, amount),
692             'ReflectiveStake: transfer out of staking pool failed');
693 
694         if (rewardAmount > 0) {
695             require(_unlockedPool.transfer(msg.sender, rewardAmount),
696                 'ReflectiveStake: transfer out of unlocked pool failed');
697         }
698 
699 
700         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
701         emit TokensClaimed(msg.sender, rewardAmount);
702 
703         require(totalStakingShares == 0 || totalStaked() > 0,
704                 "ReflectiveStake: Error unstaking. Staking shares exist, but no staking tokens do");
705         return rewardAmount;
706     }
707 
708     function computeNewReward(uint256 currentRewardTokens,
709                                 uint256 stakingShareSeconds,
710                                 uint256 stakeTimeSec) private view returns (uint256) {
711 
712         uint256 newRewardTokens =
713             totalUnlocked()
714             .mul(stakingShareSeconds)
715             .div(totalStakingShareSeconds);
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
730     function getUserStakes(address addr) external view returns (Stake[] memory){
731         Stake[] memory userStakes = _userStakes[addr];
732         return userStakes;
733     }
734 
735     function getUserTotals(address addr) external view returns (UserTotals memory) {
736         UserTotals memory userTotals = _userTotals[addr];
737         return userTotals;
738     }
739 
740     function totalStakedFor(address addr) public view returns (uint256) {
741         return totalStakingShares > 0 ?
742             totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;
743     }
744 
745     function totalStaked() public view returns (uint256) {
746         return _stakingPool.balance();
747     }
748 
749     function token() external view returns (address) {
750         return address(getStakingToken());
751     }
752 
753     function treasuryTarget() external view returns (address) {
754         return address(_unlockedPool);
755     }
756 
757     function updateAccounting() private returns (
758         uint256, uint256, uint256, uint256, uint256, uint256) {
759 
760         unlockTokens();
761 
762         // Global accounting
763         uint256 newStakingShareSeconds =
764             block.timestamp
765             .sub(lastAccountingTimestampSec)
766             .mul(totalStakingShares);
767         totalStakingShareSeconds = totalStakingShareSeconds.add(newStakingShareSeconds);
768         lastAccountingTimestampSec = block.timestamp;
769 
770         // User Accounting
771         UserTotals storage totals = _userTotals[msg.sender];
772         uint256 newUserStakingShareSeconds =
773             block.timestamp
774             .sub(totals.lastAccountingTimestampSec)
775             .mul(totals.stakingShares);
776         totals.stakingShareSeconds =
777             totals.stakingShareSeconds
778             .add(newUserStakingShareSeconds);
779         totals.lastAccountingTimestampSec = block.timestamp;
780 
781         uint256 totalUserRewards = (totalStakingShareSeconds > 0)
782             ? totalUnlocked().mul(totals.stakingShareSeconds).div(totalStakingShareSeconds)
783             : 0;
784 
785         return (
786             totalPending(),
787             totalUnlocked(),
788             totals.stakingShareSeconds,
789             totalStakingShareSeconds,
790             totalUserRewards,
791             block.timestamp
792         );
793     }
794 
795     function isUnlocked(address account) external view returns (bool) {
796         if (totalStakedFor(account) == 0) return false;
797         Stake[] memory accountStakes = _userStakes[account];
798         Stake memory mostRecentStake = accountStakes[accountStakes.length - 1];
799         return block.timestamp.sub(mostRecentStake.timestampSec) > lockupSec;
800     }
801 
802     function totalPending() public view returns (uint256) {
803         return _reflectiveTreasury.fundsAvailable();
804     }
805 
806     function totalUnlocked() public view returns (uint256) {
807         return _unlockedPool.balance();
808     }
809 
810     function totalAvailable() external view returns (uint256) {
811         return totalUnlocked().add(totalPending());
812     }
813 
814     function unlockTokens() public {
815         if (totalPending() > 0) _reflectiveTreasury.release();
816     }
817 }
818 
819 // File: contracts\RFIStake.sol
820 
821 // SPDX-License-Identifier: GPL-3.0-only
822 
823 pragma solidity >=0.6.0 <0.8.0;
824 
825 
826 
827 contract RFIStake is ReflectiveStake {
828     using SafeMath for uint256;
829 
830     constructor(IERC20 stakingToken, IERC20 distributionToken, ITREASURY reflectiveTreasury,
831     uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken, uint256 lockupSec_)
832     ReflectiveStake(stakingToken, distributionToken, reflectiveTreasury, startBonus_, bonusPeriodSec_, initialSharesPerToken, lockupSec_)
833     public {}
834 
835     function _applyFee(uint256 amount) internal pure override returns (uint256) {
836         uint256 tFee = amount.div(100);
837         uint256 tTransferAmount = amount.sub(tFee);
838         return tTransferAmount;
839     }
840 
841 }