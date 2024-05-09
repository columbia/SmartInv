1 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
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
160 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
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
239 // File: node_modules\openzeppelin-solidity\contracts\GSN\Context.sol
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
269 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
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
347 // File: contracts\IStaking.sol
348 
349 pragma solidity 0.5.16;
350 
351 /**
352  * @title Staking interface, as defined by EIP-900.
353  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
354  */
355 contract IStaking {
356     event Staked(address indexed user, uint256 amount, uint256 total, address referrer);
357     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
358 
359     function stake(uint256 amount, address referrer) external;
360     function stakeFor(address user, uint256 amount, address referrer) external;
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
374 // File: contracts\TokenPool.sol
375 
376 pragma solidity 0.5.16;
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
407 // File: contracts\IReferrerBook.sol
408 
409 pragma solidity 0.5.16;
410 
411 interface IReferrerBook {
412     function affirmReferrer(address user, address referrer) external returns (bool);
413     function getUserReferrer(address user) external view returns (address);
414     function getUserTopNode(address user) external view returns (address);
415     function getUserNormalNode(address user) external view returns (address);
416 }
417 
418 // File: contracts\TokenGeyser.sol
419 
420 pragma solidity 0.5.16;
421 
422 
423 
424 
425 
426 
427 
428 /**
429  * @title Token Geyser
430  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
431  *      Compound and Uniswap.
432  *
433  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
434  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
435  *      claimed by users.
436  *
437  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
438  *      is a function of the number of tokens deposited as well as the length of time deposited.
439  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
440  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
441  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
442  *
443  *      More background and motivation available at:
444  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
445  */
446 contract TokenGeyser is IStaking, Ownable {
447     using SafeMath for uint256;
448 
449     event Staked(
450         address indexed user,
451         uint256 amount,
452         uint256 total,
453         bytes data
454     );
455     event Unstaked(
456         address indexed user,
457         uint256 amount,
458         uint256 total,
459         bytes data
460     );
461     event TokensClaimed(address indexed user, uint256 amount);
462     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
463     // amount: Unlocked tokens, total: Total locked tokens
464     event TokensUnlocked(uint256 amount, uint256 total);
465 
466     TokenPool private _stakingPool;
467     TokenPool private _unlockedPool;
468     TokenPool private _lockedPool;
469 
470     //
471     // Time-bonus params
472     //
473     uint256 public constant BONUS_DECIMALS = 2;
474     uint256 public startBonus = 0;
475     uint256 public bonusPeriodSec = 0;
476 
477     //
478     // Global accounting state
479     //
480     uint256 public totalLockedShares = 0;
481     uint256 public totalStakingShares = 0;
482     uint256 private _totalStakingShareSeconds = 0;
483     uint256 private _lastAccountingTimestampSec = now;
484     uint256 private _maxUnlockSchedules = 0;
485     uint256 private _initialSharesPerToken = 0;
486 
487     address public referrerBook;
488 
489     //reward percent below: user + referrer + indirectReferrer + topNode + normalNode == 100% == 10000
490     uint256 public rewardUserPct;
491     uint256 public rewardRefPct;
492     uint256 public rewardIndirectRefPct;
493     uint256 public rewardTopNodePct;
494     uint256 public rewardNormalNodePct;
495 
496     //
497     // User accounting state
498     //
499     // Represents a single stake for a user. A user may have multiple.
500     struct Stake {
501         uint256 stakingShares;
502         uint256 timestampSec;
503     }
504 
505     // Caches aggregated values from the User->Stake[] map to save computation.
506     // If lastAccountingTimestampSec is 0, there's no entry for that user.
507     struct UserTotals {
508         uint256 stakingShares;
509         uint256 stakingShareSeconds;
510         uint256 lastAccountingTimestampSec;
511     }
512 
513     // Aggregated staking values per user
514     mapping(address => UserTotals) private _userTotals;
515 
516     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
517     mapping(address => Stake[]) private _userStakes;
518 
519     //
520     // Locked/Unlocked Accounting state
521     //
522     struct UnlockSchedule {
523         uint256 initialLockedShares;
524         uint256 unlockedShares;
525         uint256 lastUnlockTimestampSec;
526         uint256 endAtSec;
527         uint256 durationSec;
528     }
529 
530     UnlockSchedule[] public unlockSchedules;
531 
532     /**
533      * @param stakingToken The token users deposit as stake.
534      * @param distributionToken The token users receive as they unstake.
535      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
536      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
537      *                    e.g. 25% means user gets 25% of max distribution tokens.
538      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
539      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
540      */
541     constructor(
542         IERC20 stakingToken,
543         IERC20 distributionToken,
544         uint256 maxUnlockSchedules,
545         uint256 startBonus_,
546         uint256 bonusPeriodSec_,
547         uint256 initialSharesPerToken,
548         address referrerBook_
549     ) public {
550         // The start bonus must be some fraction of the max. (i.e. <= 100%)
551         require(
552             startBonus_ <= 10**BONUS_DECIMALS,
553             "TokenGeyser: start bonus too high"
554         );
555         // If no period is desired, instead set startBonus = 100%
556         // and bonusPeriod to a small value like 1sec.
557         require(bonusPeriodSec_ != 0, "TokenGeyser: bonus period is zero");
558         require(
559             initialSharesPerToken > 0,
560             "TokenGeyser: initialSharesPerToken is zero"
561         );
562         require(
563             referrerBook_ != address(0),
564             "TokenGeyser: referrer book is zero"
565         );
566 
567         _stakingPool = new TokenPool(stakingToken);
568         _unlockedPool = new TokenPool(distributionToken);
569         _lockedPool = new TokenPool(distributionToken);
570         startBonus = startBonus_;
571         bonusPeriodSec = bonusPeriodSec_;
572         _maxUnlockSchedules = maxUnlockSchedules;
573         _initialSharesPerToken = initialSharesPerToken;
574 
575         rewardUserPct = 10000;
576 
577         referrerBook = referrerBook_;
578     }
579 
580     /**
581      * @return The token users deposit as stake.
582      */
583     function getStakingToken() public view returns (IERC20) {
584         return _stakingPool.token();
585     }
586 
587     /**
588      * @return The token users receive as they unstake.
589      */
590     function getDistributionToken() public view returns (IERC20) {
591         assert(_unlockedPool.token() == _lockedPool.token());
592         return _unlockedPool.token();
593     }
594 
595     /**
596      * @dev Transfers amount of deposit tokens from the user.
597      * @param amount Number of deposit tokens to stake.
598      * @param referrer User's Referrer
599      */
600     function stake(uint256 amount, address referrer) external {
601         _stakeFor(msg.sender, msg.sender, amount, referrer);
602     }
603 
604     /**
605      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
606      * @param user User address who gains credit for this stake operation.
607      * @param amount Number of deposit tokens to stake.
608      * @param referrer User's Referrer
609      */
610     function stakeFor(
611         address user,
612         uint256 amount,
613         address referrer
614     ) external onlyOwner {
615         _stakeFor(msg.sender, user, amount, referrer);
616     }
617 
618     /**
619      * @dev Private implementation of staking methods.
620      * @param staker User address who deposits tokens to stake.
621      * @param beneficiary User address who gains credit for this stake operation.
622      * @param amount Number of deposit tokens to stake.
623      */
624     function _stakeFor(
625         address staker,
626         address beneficiary,
627         uint256 amount,
628         address referrer
629     ) private {
630         require(amount > 0, "TokenGeyser: stake amount is zero");
631         require(
632             beneficiary != address(0),
633             "TokenGeyser: beneficiary is zero address"
634         );
635         require(
636             totalStakingShares == 0 || totalStaked() > 0,
637             "TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do"
638         );
639 
640         uint256 mintedStakingShares = (totalStakingShares > 0)
641             ? totalStakingShares.mul(amount).div(totalStaked())
642             : amount.mul(_initialSharesPerToken);
643         require(
644             mintedStakingShares > 0,
645             "TokenGeyser: Stake amount is too small"
646         );
647 
648         updateAccounting();
649 
650         // 1. User Accounting
651         UserTotals storage totals = _userTotals[beneficiary];
652         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
653         totals.lastAccountingTimestampSec = now;
654 
655         Stake memory newStake = Stake(mintedStakingShares, now);
656         _userStakes[beneficiary].push(newStake);
657 
658         // 2. Global Accounting
659         totalStakingShares = totalStakingShares.add(mintedStakingShares);
660         // Already set in updateAccounting()
661         // _lastAccountingTimestampSec = now;
662 
663         // interactions
664         require(
665             _stakingPool.token().transferFrom(
666                 staker,
667                 address(_stakingPool),
668                 amount
669             ),
670             "TokenGeyser: transfer into staking pool failed"
671         );
672 
673         if (referrer != address(0) && referrer != staker) {
674             IReferrerBook(referrerBook).affirmReferrer(staker, referrer);
675         }
676 
677         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), referrer);
678     }
679 
680     /**
681      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
682      * alotted number of distribution tokens.
683      * @param amount Number of deposit tokens to unstake / withdraw.
684      * @param data Not used.
685      */
686     function unstake(uint256 amount, bytes calldata data) external {
687         _unstake(amount);
688     }
689 
690     /**
691      * @param amount Number of deposit tokens to unstake / withdraw.
692      * @return The total number of distribution tokens that would be rewarded.
693      */
694     function unstakeQuery(uint256 amount) public returns (uint256) {
695         return _unstake(amount);
696     }
697 
698     /**
699      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
700      * alotted number of distribution tokens.
701      * @param amount Number of deposit tokens to unstake / withdraw.
702      * @return The total number of distribution tokens rewarded.
703      */
704     function _unstake(uint256 amount) private returns (uint256) {
705         updateAccounting();
706 
707         // checks
708         require(amount > 0, "TokenGeyser: unstake amount is zero");
709         require(
710             totalStakedFor(msg.sender) >= amount,
711             "TokenGeyser: unstake amount is greater than total user stakes"
712         );
713         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(
714             totalStaked()
715         );
716         require(
717             stakingSharesToBurn > 0,
718             "TokenGeyser: Unable to unstake amount this small"
719         );
720 
721         // 1. User Accounting
722         UserTotals storage totals = _userTotals[msg.sender];
723         Stake[] storage accountStakes = _userStakes[msg.sender];
724 
725         // Redeem from most recent stake and go backwards in time.
726         uint256 stakingShareSecondsToBurn = 0;
727         uint256 sharesLeftToBurn = stakingSharesToBurn;
728         uint256 rewardAmount = 0;
729         while (sharesLeftToBurn > 0) {
730             Stake storage lastStake = accountStakes[accountStakes.length - 1];
731             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
732             uint256 newStakingShareSecondsToBurn = 0;
733             if (lastStake.stakingShares <= sharesLeftToBurn) {
734                 // fully redeem a past stake
735                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(
736                     stakeTimeSec
737                 );
738                 rewardAmount = computeNewReward(
739                     rewardAmount,
740                     newStakingShareSecondsToBurn,
741                     stakeTimeSec
742                 );
743                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
744                     newStakingShareSecondsToBurn
745                 );
746                 sharesLeftToBurn = sharesLeftToBurn.sub(
747                     lastStake.stakingShares
748                 );
749                 accountStakes.length--;
750             } else {
751                 // partially redeem a past stake
752                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(
753                     stakeTimeSec
754                 );
755                 rewardAmount = computeNewReward(
756                     rewardAmount,
757                     newStakingShareSecondsToBurn,
758                     stakeTimeSec
759                 );
760                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
761                     newStakingShareSecondsToBurn
762                 );
763                 lastStake.stakingShares = lastStake.stakingShares.sub(
764                     sharesLeftToBurn
765                 );
766                 sharesLeftToBurn = 0;
767             }
768         }
769         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(
770             stakingShareSecondsToBurn
771         );
772         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
773         // Already set in updateAccounting
774         // totals.lastAccountingTimestampSec = now;
775 
776         // 2. Global Accounting
777         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(
778             stakingShareSecondsToBurn
779         );
780         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
781         // Already set in updateAccounting
782         // _lastAccountingTimestampSec = now;
783 
784         // interactions
785         require(
786             _stakingPool.transfer(msg.sender, amount),
787             "TokenGeyser: transfer out of staking pool failed"
788         );
789 
790         uint256 userRewardAmount = _rewardUserAndReferrers(
791             msg.sender,
792             rewardAmount
793         );
794 
795         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
796         emit TokensClaimed(msg.sender, rewardAmount);
797 
798         require(
799             totalStakingShares == 0 || totalStaked() > 0,
800             "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do"
801         );
802         return userRewardAmount;
803     }
804 
805     function _rewardUserAndReferrers(address user, uint256 rewardAmount)
806         private
807         returns (uint256)
808     {
809         //0. reward user
810         uint256 userAmount = rewardAmount.mul(rewardUserPct).div(10000);
811         require(
812             _unlockedPool.transfer(user, userAmount),
813             "TokenGeyser: transfer out of unlocked pool failed(user)"
814         );
815 
816         IReferrerBook refBook = IReferrerBook(referrerBook);
817 
818         //1. reward referrer
819         uint256 amount = rewardAmount.mul(rewardRefPct).div(10000);
820         address referrer = refBook.getUserReferrer(user);
821         if (amount > 0 && referrer != address(0)) {
822             _unlockedPool.transfer(referrer, amount);
823         }
824 
825         //2. reward top node
826         amount = rewardAmount.mul(rewardTopNodePct).div(10000);
827         address topNode = refBook.getUserTopNode(user);
828         if (amount > 0 && topNode != address(0)) {
829             _unlockedPool.transfer(topNode, amount);
830         }
831 
832         //3. reward normal node
833         amount = rewardAmount.mul(rewardNormalNodePct).div(10000);
834         address normalNode = refBook.getUserNormalNode(user);
835         if (amount > 0 && normalNode != address(0)) {
836             _unlockedPool.transfer(normalNode, amount);
837         }
838 
839         //4. reward indirect referrer
840         if (referrer != address(0)) {
841             amount = rewardAmount.mul(rewardIndirectRefPct).div(10000);
842             address indirectRef = refBook.getUserReferrer(referrer);
843             if (amount > 0 && indirectRef != address(0)) {
844                 _unlockedPool.transfer(indirectRef, amount);
845             }
846         }
847 
848         return userAmount;
849     }
850 
851     function setRewardSharingParameters(
852         uint256 userPct,
853         uint256 refPct,
854         uint256 indirectRefPct,
855         uint256 topNodePct,
856         uint256 normalNodePct
857     ) external onlyOwner {
858         require(
859             userPct.add(refPct).add(indirectRefPct).add(topNodePct).add(
860                 normalNodePct
861             ) == 10000,
862             "total != 100%"
863         );
864         require(userPct > 0, "user percent cannot be 0");
865 
866         rewardUserPct = userPct;
867         rewardRefPct = refPct;
868         rewardIndirectRefPct = indirectRefPct;
869         rewardTopNodePct = topNodePct;
870         rewardNormalNodePct = normalNodePct;
871     }
872 
873     /**
874      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
875      *      encourage long-term deposits instead of constant unstake/restakes.
876      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
877      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
878      * @param currentRewardTokens The current number of distribution tokens already alotted for this
879      *                            unstake op. Any bonuses are already applied.
880      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
881      *                            distribution tokens.
882      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
883      *                     the time-bonus.
884      * @return Updated amount of distribution tokens to award, with any bonus included on the
885      *         newly added tokens.
886      */
887     function computeNewReward(
888         uint256 currentRewardTokens,
889         uint256 stakingShareSeconds,
890         uint256 stakeTimeSec
891     ) private view returns (uint256) {
892         uint256 newRewardTokens = totalUnlocked().mul(stakingShareSeconds).div(
893             _totalStakingShareSeconds
894         );
895 
896         if (stakeTimeSec >= bonusPeriodSec) {
897             return currentRewardTokens.add(newRewardTokens);
898         }
899 
900         uint256 oneHundredPct = 10**BONUS_DECIMALS;
901         uint256 bonusedReward = startBonus
902             .add(
903             oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec)
904         )
905             .mul(newRewardTokens)
906             .div(oneHundredPct);
907         return currentRewardTokens.add(bonusedReward);
908     }
909 
910     /**
911      * @param addr The user to look up staking information for.
912      * @return The number of staking tokens deposited for addr.
913      */
914     function totalStakedFor(address addr) public view returns (uint256) {
915         return
916             totalStakingShares > 0
917                 ? totalStaked().mul(_userTotals[addr].stakingShares).div(
918                     totalStakingShares
919                 )
920                 : 0;
921     }
922 
923     /**
924      * @return The total number of deposit tokens staked globally, by all users.
925      */
926     function totalStaked() public view returns (uint256) {
927         return _stakingPool.balance();
928     }
929 
930     /**
931      * @dev Note that this application has a staking token as well as a distribution token, which
932      * may be different. This function is required by EIP-900.
933      * @return The deposit token used for staking.
934      */
935     function token() external view returns (address) {
936         return address(getStakingToken());
937     }
938 
939     /**
940      * @dev A globally callable function to update the accounting state of the system.
941      *      Global state and state for the caller are updated.
942      * @return [0] balance of the locked pool
943      * @return [1] balance of the unlocked pool
944      * @return [2] caller's staking share seconds
945      * @return [3] global staking share seconds
946      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
947      * @return [5] block timestamp
948      */
949     function updateAccounting()
950         public
951         returns (
952             uint256,
953             uint256,
954             uint256,
955             uint256,
956             uint256,
957             uint256
958         )
959     {
960         unlockTokens();
961 
962         // Global accounting
963         uint256 newStakingShareSeconds = now
964             .sub(_lastAccountingTimestampSec)
965             .mul(totalStakingShares);
966         _totalStakingShareSeconds = _totalStakingShareSeconds.add(
967             newStakingShareSeconds
968         );
969         _lastAccountingTimestampSec = now;
970 
971         // User Accounting
972         UserTotals storage totals = _userTotals[msg.sender];
973         uint256 newUserStakingShareSeconds = now
974             .sub(totals.lastAccountingTimestampSec)
975             .mul(totals.stakingShares);
976         totals.stakingShareSeconds = totals.stakingShareSeconds.add(
977             newUserStakingShareSeconds
978         );
979         totals.lastAccountingTimestampSec = now;
980 
981         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
982             ? totalUnlocked().mul(totals.stakingShareSeconds).div(
983                 _totalStakingShareSeconds
984             )
985             : 0;
986 
987         return (
988             totalLocked(),
989             totalUnlocked(),
990             totals.stakingShareSeconds,
991             _totalStakingShareSeconds,
992             totalUserRewards,
993             now
994         );
995     }
996 
997     /**
998      * @return Total number of locked distribution tokens.
999      */
1000     function totalLocked() public view returns (uint256) {
1001         return _lockedPool.balance();
1002     }
1003 
1004     /**
1005      * @return Total number of unlocked distribution tokens.
1006      */
1007     function totalUnlocked() public view returns (uint256) {
1008         return _unlockedPool.balance();
1009     }
1010 
1011     /**
1012      * @return Number of unlock schedules.
1013      */
1014     function unlockScheduleCount() public view returns (uint256) {
1015         return unlockSchedules.length;
1016     }
1017 
1018     /**
1019      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
1020      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
1021      *      linearly over the duraction of durationSec timeframe.
1022      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
1023      * @param durationSec Length of time to linear unlock the tokens.
1024      */
1025     function lockTokens(uint256 amount, uint256 durationSec)
1026         external
1027         onlyOwner
1028     {
1029         require(
1030             unlockSchedules.length < _maxUnlockSchedules,
1031             "TokenGeyser: reached maximum unlock schedules"
1032         );
1033 
1034         // Update lockedTokens amount before using it in computations after.
1035         updateAccounting();
1036 
1037         uint256 lockedTokens = totalLocked();
1038         uint256 mintedLockedShares = (lockedTokens > 0)
1039             ? totalLockedShares.mul(amount).div(lockedTokens)
1040             : amount.mul(_initialSharesPerToken);
1041 
1042         UnlockSchedule memory schedule;
1043         schedule.initialLockedShares = mintedLockedShares;
1044         schedule.lastUnlockTimestampSec = now;
1045         schedule.endAtSec = now.add(durationSec);
1046         schedule.durationSec = durationSec;
1047         unlockSchedules.push(schedule);
1048 
1049         totalLockedShares = totalLockedShares.add(mintedLockedShares);
1050 
1051         require(
1052             _lockedPool.token().transferFrom(
1053                 msg.sender,
1054                 address(_lockedPool),
1055                 amount
1056             ),
1057             "TokenGeyser: transfer into locked pool failed"
1058         );
1059         emit TokensLocked(amount, durationSec, totalLocked());
1060     }
1061 
1062     /**
1063      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
1064      *      previously defined unlock schedules. Publicly callable.
1065      * @return Number of newly unlocked distribution tokens.
1066      */
1067     function unlockTokens() public returns (uint256) {
1068         uint256 unlockedTokens = 0;
1069         uint256 lockedTokens = totalLocked();
1070 
1071         if (totalLockedShares == 0) {
1072             unlockedTokens = lockedTokens;
1073         } else {
1074             uint256 unlockedShares = 0;
1075             for (uint256 s = 0; s < unlockSchedules.length; s++) {
1076                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
1077             }
1078             unlockedTokens = unlockedShares.mul(lockedTokens).div(
1079                 totalLockedShares
1080             );
1081             totalLockedShares = totalLockedShares.sub(unlockedShares);
1082         }
1083 
1084         if (unlockedTokens > 0) {
1085             require(
1086                 _lockedPool.transfer(address(_unlockedPool), unlockedTokens),
1087                 "TokenGeyser: transfer out of locked pool failed"
1088             );
1089             emit TokensUnlocked(unlockedTokens, totalLocked());
1090         }
1091 
1092         return unlockedTokens;
1093     }
1094 
1095     /**
1096      * @dev Returns the number of unlockable shares from a given schedule. The returned value
1097      *      depends on the time since the last unlock. This function updates schedule accounting,
1098      *      but does not actually transfer any tokens.
1099      * @param s Index of the unlock schedule.
1100      * @return The number of unlocked shares.
1101      */
1102     function unlockScheduleShares(uint256 s) private returns (uint256) {
1103         UnlockSchedule storage schedule = unlockSchedules[s];
1104 
1105         if (schedule.unlockedShares >= schedule.initialLockedShares) {
1106             return 0;
1107         }
1108 
1109         uint256 sharesToUnlock = 0;
1110         // Special case to handle any leftover dust from integer division
1111         if (now >= schedule.endAtSec) {
1112             sharesToUnlock = (
1113                 schedule.initialLockedShares.sub(schedule.unlockedShares)
1114             );
1115             schedule.lastUnlockTimestampSec = schedule.endAtSec;
1116         } else {
1117             sharesToUnlock = now
1118                 .sub(schedule.lastUnlockTimestampSec)
1119                 .mul(schedule.initialLockedShares)
1120                 .div(schedule.durationSec);
1121             schedule.lastUnlockTimestampSec = now;
1122         }
1123 
1124         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
1125         return sharesToUnlock;
1126     }
1127 
1128     /**
1129      * @dev Lets the owner rescue funds air-dropped to the staking pool.
1130      * @param tokenToRescue Address of the token to be rescued.
1131      * @param to Address to which the rescued funds are to be sent.
1132      * @param amount Amount of tokens to be rescued.
1133      * @return Transfer success.
1134      */
1135     function rescueFundsFromStakingPool(
1136         address tokenToRescue,
1137         address to,
1138         uint256 amount
1139     ) public onlyOwner returns (bool) {
1140         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
1141     }
1142 
1143     function setReferrerBook(address referrerBook_) external onlyOwner {
1144         require(referrerBook_ != address(0), "referrerBook == 0");
1145         referrerBook = referrerBook_;
1146     }
1147 }