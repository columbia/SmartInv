1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: StakingDualRewards.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/StakingDualRewards.sol
11 * Docs: https://docs.synthetix.io/contracts/StakingDualRewards
12 *
13 * Contract Dependencies: 
14 *	- DualRewardsDistributionRecipient
15 *	- IERC20
16 *	- IStakingDualRewards
17 *	- Owned
18 *	- Pausable
19 *	- ReentrancyGuard
20 * Libraries: 
21 *	- Address
22 *	- Math
23 *	- SafeERC20
24 *	- SafeMath
25 *
26 * MIT License
27 * ===========
28 *
29 * Copyright (c) 2021 Synthetix
30 *
31 * Permission is hereby granted, free of charge, to any person obtaining a copy
32 * of this software and associated documentation files (the "Software"), to deal
33 * in the Software without restriction, including without limitation the rights
34 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
35 * copies of the Software, and to permit persons to whom the Software is
36 * furnished to do so, subject to the following conditions:
37 *
38 * The above copyright notice and this permission notice shall be included in all
39 * copies or substantial portions of the Software.
40 *
41 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
42 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
43 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
44 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
45 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
46 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
47 */
48 
49 
50 
51 pragma solidity ^0.5.0;
52 
53 /**
54  * @dev Standard math utilities missing in the Solidity language.
55  */
56 library Math {
57     /**
58      * @dev Returns the largest of two numbers.
59      */
60     function max(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a >= b ? a : b;
62     }
63 
64     /**
65      * @dev Returns the smallest of two numbers.
66      */
67     function min(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a < b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the average of two numbers. The result is rounded towards
73      * zero.
74      */
75     function average(uint256 a, uint256 b) internal pure returns (uint256) {
76         // (a + b) / 2 can overflow, so we distribute
77         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
78     }
79 }
80 
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b <= a, "SafeMath: subtraction overflow");
123         uint256 c = a - b;
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `*` operator.
133      *
134      * Requirements:
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Solidity only automatically asserts when dividing by 0
164         require(b > 0, "SafeMath: division by zero");
165         uint256 c = a / b;
166         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b != 0, "SafeMath: modulo by zero");
184         return a % b;
185     }
186 }
187 
188 
189 /**
190  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
191  * the optional functions; to access them see `ERC20Detailed`.
192  */
193 interface IERC20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a `Transfer` event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through `transferFrom`. This is
216      * zero by default.
217      *
218      * This value changes when `approve` or `transferFrom` are called.
219      */
220     function allowance(address owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * > Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an `Approval` event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a `Transfer` event.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to `approve`. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 
265 /**
266  * @dev Optional functions from the ERC20 standard.
267  */
268 contract ERC20Detailed is IERC20 {
269     string private _name;
270     string private _symbol;
271     uint8 private _decimals;
272 
273     /**
274      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
275      * these values are immutable: they can only be set once during
276      * construction.
277      */
278     constructor (string memory name, string memory symbol, uint8 decimals) public {
279         _name = name;
280         _symbol = symbol;
281         _decimals = decimals;
282     }
283 
284     /**
285      * @dev Returns the name of the token.
286      */
287     function name() public view returns (string memory) {
288         return _name;
289     }
290 
291     /**
292      * @dev Returns the symbol of the token, usually a shorter version of the
293      * name.
294      */
295     function symbol() public view returns (string memory) {
296         return _symbol;
297     }
298 
299     /**
300      * @dev Returns the number of decimals used to get its user representation.
301      * For example, if `decimals` equals `2`, a balance of `505` tokens should
302      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
303      *
304      * Tokens usually opt for a value of 18, imitating the relationship between
305      * Ether and Wei.
306      *
307      * > Note that this information is only used for _display_ purposes: it in
308      * no way affects any of the arithmetic of the contract, including
309      * `IERC20.balanceOf` and `IERC20.transfer`.
310      */
311     function decimals() public view returns (uint8) {
312         return _decimals;
313     }
314 }
315 
316 
317 /**
318  * @dev Collection of functions related to the address type,
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * This test is non-exhaustive, and there may be false-negatives: during the
325      * execution of a contract's constructor, its address will be reported as
326      * not containing a contract.
327      *
328      * > It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      */
331     function isContract(address account) internal view returns (bool) {
332         // This method relies in extcodesize, which returns 0 for contracts in
333         // construction, since the code is only stored at the end of the
334         // constructor execution.
335 
336         uint256 size;
337         // solhint-disable-next-line no-inline-assembly
338         assembly { size := extcodesize(account) }
339         return size > 0;
340     }
341 }
342 
343 
344 /**
345  * @title SafeERC20
346  * @dev Wrappers around ERC20 operations that throw on failure (when the token
347  * contract returns false). Tokens that return no value (and instead revert or
348  * throw on failure) are also supported, non-reverting calls are assumed to be
349  * successful.
350  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
351  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
352  */
353 library SafeERC20 {
354     using SafeMath for uint256;
355     using Address for address;
356 
357     function safeTransfer(IERC20 token, address to, uint256 value) internal {
358         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
359     }
360 
361     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
362         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
363     }
364 
365     function safeApprove(IERC20 token, address spender, uint256 value) internal {
366         // safeApprove should only be called when setting an initial allowance,
367         // or when resetting it to zero. To increase and decrease it, use
368         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
369         // solhint-disable-next-line max-line-length
370         require((value == 0) || (token.allowance(address(this), spender) == 0),
371             "SafeERC20: approve from non-zero to non-zero allowance"
372         );
373         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
374     }
375 
376     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
377         uint256 newAllowance = token.allowance(address(this), spender).add(value);
378         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
379     }
380 
381     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
382         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
383         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
384     }
385 
386     /**
387      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
388      * on the return value: the return value is optional (but if data is returned, it must not be false).
389      * @param token The token targeted by the call.
390      * @param data The call data (encoded using abi.encode or one of its variants).
391      */
392     function callOptionalReturn(IERC20 token, bytes memory data) private {
393         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
394         // we're implementing it ourselves.
395 
396         // A Solidity high level call has three parts:
397         //  1. The target address is checked to verify it contains contract code
398         //  2. The call itself is made, and success asserted
399         //  3. The return value is decoded, which in turn checks the size of the returned data.
400         // solhint-disable-next-line max-line-length
401         require(address(token).isContract(), "SafeERC20: call to non-contract");
402 
403         // solhint-disable-next-line avoid-low-level-calls
404         (bool success, bytes memory returndata) = address(token).call(data);
405         require(success, "SafeERC20: low-level call failed");
406 
407         if (returndata.length > 0) { // Return data is optional
408             // solhint-disable-next-line max-line-length
409             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
410         }
411     }
412 }
413 
414 
415 /**
416  * @dev Contract module that helps prevent reentrant calls to a function.
417  *
418  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
419  * available, which can be aplied to functions to make sure there are no nested
420  * (reentrant) calls to them.
421  *
422  * Note that because there is a single `nonReentrant` guard, functions marked as
423  * `nonReentrant` may not call one another. This can be worked around by making
424  * those functions `private`, and then adding `external` `nonReentrant` entry
425  * points to them.
426  */
427 contract ReentrancyGuard {
428     /// @dev counter to allow mutex lock with only one SSTORE operation
429     uint256 private _guardCounter;
430 
431     constructor () internal {
432         // The counter starts at one to prevent changing it from zero to a non-zero
433         // value, which is a more expensive operation.
434         _guardCounter = 1;
435     }
436 
437     /**
438      * @dev Prevents a contract from calling itself, directly or indirectly.
439      * Calling a `nonReentrant` function from another `nonReentrant`
440      * function is not supported. It is possible to prevent this from happening
441      * by making the `nonReentrant` function external, and make it call a
442      * `private` function that does the actual work.
443      */
444     modifier nonReentrant() {
445         _guardCounter += 1;
446         uint256 localCounter = _guardCounter;
447         _;
448         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
449     }
450 }
451 
452 
453 interface IStakingDualRewards {
454     // Views
455     function lastTimeRewardApplicable() external view returns (uint256);
456 
457     function rewardPerTokenA() external view returns (uint256);
458     function rewardPerTokenB() external view returns (uint256);
459 
460     function earnedA(address account) external view returns (uint256);
461 
462     function earnedB(address account) external view returns (uint256);
463     function getRewardAForDuration() external view returns (uint256);
464 
465     function getRewardBForDuration() external view returns (uint256);
466     function totalSupply() external view returns (uint256);
467 
468     function balanceOf(address account) external view returns (uint256);
469 
470     // Mutative
471 
472     function stake(uint256 amount) external;
473 
474     function withdraw(uint256 amount) external;
475 
476     function getReward() external;
477 
478     function exit() external;
479 }
480 
481 
482 // https://docs.synthetix.io/contracts/source/contracts/owned
483 contract Owned {
484     address public owner;
485     address public nominatedOwner;
486 
487     constructor(address _owner) public {
488         require(_owner != address(0), "Owner address cannot be 0");
489         owner = _owner;
490         emit OwnerChanged(address(0), _owner);
491     }
492 
493     function nominateNewOwner(address _owner) external onlyOwner {
494         nominatedOwner = _owner;
495         emit OwnerNominated(_owner);
496     }
497 
498     function acceptOwnership() external {
499         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
500         emit OwnerChanged(owner, nominatedOwner);
501         owner = nominatedOwner;
502         nominatedOwner = address(0);
503     }
504 
505     modifier onlyOwner {
506         _onlyOwner();
507         _;
508     }
509 
510     function _onlyOwner() private view {
511         require(msg.sender == owner, "Only the contract owner may perform this action");
512     }
513 
514     event OwnerNominated(address newOwner);
515     event OwnerChanged(address oldOwner, address newOwner);
516 }
517 
518 
519 // Inheritance
520 
521 
522 contract DualRewardsDistributionRecipient is Owned {
523     address public dualRewardsDistribution;
524 
525     function notifyRewardAmount(uint256 rewardA, uint256 rewardB) external;
526 
527     modifier onlyDualRewardsDistribution() {
528         require(msg.sender == dualRewardsDistribution, "Caller is not DualRewardsDistribution contract");
529         _;
530     }
531 
532     function setDualRewardsDistribution(address _dualRewardsDistribution) external onlyOwner {
533         dualRewardsDistribution = _dualRewardsDistribution;
534     }
535 }
536 
537 
538 // Inheritance
539 
540 
541 // https://docs.synthetix.io/contracts/source/contracts/pausable
542 contract Pausable is Owned {
543     uint public lastPauseTime;
544     bool public paused;
545 
546     constructor() internal {
547         // This contract is abstract, and thus cannot be instantiated directly
548         require(owner != address(0), "Owner must be set");
549         // Paused will be false, and lastPauseTime will be 0 upon initialisation
550     }
551 
552     /**
553      * @notice Change the paused state of the contract
554      * @dev Only the contract owner may call this.
555      */
556     function setPaused(bool _paused) external onlyOwner {
557         // Ensure we're actually changing the state before we do anything
558         if (_paused == paused) {
559             return;
560         }
561 
562         // Set our paused state.
563         paused = _paused;
564 
565         // If applicable, set the last pause time.
566         if (paused) {
567             lastPauseTime = now;
568         }
569 
570         // Let everyone know that our pause state has changed.
571         emit PauseChanged(paused);
572     }
573 
574     event PauseChanged(bool isPaused);
575 
576     modifier notPaused {
577         require(!paused, "This action cannot be performed while the contract is paused");
578         _;
579     }
580 }
581 
582 
583 // Inheritance
584 
585 
586 contract StakingDualRewards is IStakingDualRewards, DualRewardsDistributionRecipient, ReentrancyGuard, Pausable {
587     using SafeMath for uint256;
588     using SafeERC20 for IERC20;
589 
590     /* ========== STATE VARIABLES ========== */
591 
592     IERC20 public rewardsTokenA;
593     IERC20 public rewardsTokenB;
594     IERC20 public stakingToken;
595     uint256 public periodFinish = 0;
596     uint256 public rewardRateA = 0;
597     uint256 public rewardRateB = 0;
598     uint256 public rewardsDuration = 7 days;
599     uint256 public lastUpdateTime;
600     uint256 public rewardPerTokenAStored;
601     uint256 public rewardPerTokenBStored;
602 
603     mapping(address => uint256) public userRewardPerTokenAPaid;
604     mapping(address => uint256) public userRewardPerTokenBPaid;
605     mapping(address => uint256) public rewardsA;
606     mapping(address => uint256) public rewardsB;
607 
608     uint256 private _totalSupply;
609     mapping(address => uint256) private _balances;
610 
611     /* ========== CONSTRUCTOR ========== */
612 
613     constructor(
614         address _owner,
615         address _dualRewardsDistribution,
616         address _rewardsTokenA,
617         address _rewardsTokenB,
618         address _stakingToken
619     ) public Owned(_owner) {
620         require(_rewardsTokenA != _rewardsTokenB, "rewards tokens should be different");
621         rewardsTokenA = IERC20(_rewardsTokenA);
622         rewardsTokenB = IERC20(_rewardsTokenB);
623         stakingToken = IERC20(_stakingToken);
624         dualRewardsDistribution = _dualRewardsDistribution;
625     }
626 
627     /* ========== VIEWS ========== */
628 
629     function totalSupply() external view returns (uint256) {
630         return _totalSupply;
631     }
632 
633     function balanceOf(address account) external view returns (uint256) {
634         return _balances[account];
635     }
636 
637     function lastTimeRewardApplicable() public view returns (uint256) {
638         return Math.min(block.timestamp, periodFinish);
639     }
640 
641     function rewardPerTokenA() public view returns (uint256) {
642         if (_totalSupply == 0) {
643             return rewardPerTokenAStored;
644         }
645         return
646             rewardPerTokenAStored.add(
647                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRateA).mul(1e18).div(_totalSupply)
648             );
649     }
650 
651     function rewardPerTokenB() public view returns (uint256) {
652         if (_totalSupply == 0) {
653             return rewardPerTokenBStored;
654         }
655 
656         return
657             rewardPerTokenBStored.add(
658                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRateB).mul(1e18).div(_totalSupply)
659             );
660     }
661 
662     function earnedA(address account) public view returns (uint256) {
663         return _balances[account].mul(rewardPerTokenA().sub(userRewardPerTokenAPaid[account])).div(1e18).add(rewardsA[account]);
664     }
665 
666     function earnedB(address account) public view returns (uint256) {
667         return
668             _balances[account].mul(rewardPerTokenB().sub(userRewardPerTokenBPaid[account])).div(1e18).add(rewardsB[account]);
669     }
670 
671     function getRewardAForDuration() external view returns (uint256) {
672         return rewardRateA.mul(rewardsDuration);
673     }
674 
675     function getRewardBForDuration() external view returns (uint256) {
676         return rewardRateB.mul(rewardsDuration);
677     }
678 
679     /* ========== MUTATIVE FUNCTIONS ========== */
680 
681     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
682         require(amount > 0, "Cannot stake 0");
683         _totalSupply = _totalSupply.add(amount);
684         _balances[msg.sender] = _balances[msg.sender].add(amount);
685         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
686         emit Staked(msg.sender, amount);
687     }
688 
689     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
690         require(amount > 0, "Cannot withdraw 0");
691         _totalSupply = _totalSupply.sub(amount);
692         _balances[msg.sender] = _balances[msg.sender].sub(amount);
693         stakingToken.safeTransfer(msg.sender, amount);
694         emit Withdrawn(msg.sender, amount);
695     }
696 
697     function getReward() public nonReentrant updateReward(msg.sender) {
698         uint256 rewardAmountA = rewardsA[msg.sender];
699         if (rewardAmountA > 0) {
700             rewardsA[msg.sender] = 0;
701             rewardsTokenA.safeTransfer(msg.sender, rewardAmountA);
702             emit RewardPaid(msg.sender, address(rewardsTokenA), rewardAmountA);
703         }
704 
705         uint256 rewardAmountB = rewardsB[msg.sender];
706         if (rewardAmountB > 0) {
707             rewardsB[msg.sender] = 0;
708             rewardsTokenB.safeTransfer(msg.sender, rewardAmountB);
709             emit RewardPaid(msg.sender, address(rewardsTokenB), rewardAmountB);
710         }
711     }
712 
713     function exit() external {
714         withdraw(_balances[msg.sender]);
715         getReward();
716     }
717 
718     /* ========== RESTRICTED FUNCTIONS ========== */
719 
720     function notifyRewardAmount(uint256 rewardA, uint256 rewardB) external onlyDualRewardsDistribution updateReward(address(0)) {
721 
722         if (block.timestamp >= periodFinish) {
723             rewardRateA = rewardA.div(rewardsDuration);
724             rewardRateB = rewardB.div(rewardsDuration);
725         } else {
726             uint256 remaining = periodFinish.sub(block.timestamp);            
727             
728             uint256 leftoverA = remaining.mul(rewardRateA);
729             rewardRateA = rewardA.add(leftoverA).div(rewardsDuration);
730             
731             uint256 leftoverB = remaining.mul(rewardRateB);
732             rewardRateB = rewardB.add(leftoverB).div(rewardsDuration);
733           }
734 
735         // Ensure the provided reward amount is not more than the balance in the contract.
736         // This keeps the reward rate in the right range, preventing overflows due to
737         // very high values of rewardRate in the earned and rewardsPerToken functions;
738         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
739         uint balanceA = rewardsTokenA.balanceOf(address(this));
740         require(rewardRateA <= balanceA.div(rewardsDuration), "Provided reward-A too high");
741 
742         uint balanceB = rewardsTokenB.balanceOf(address(this));
743         require(rewardRateB <= balanceB.div(rewardsDuration), "Provided reward-B too high");
744 
745         lastUpdateTime = block.timestamp;
746         periodFinish = block.timestamp.add(rewardsDuration);
747         emit RewardAdded(rewardA, rewardB);
748     }
749 
750     // End rewards emission earlier
751     function updatePeriodFinish(uint timestamp) external onlyOwner updateReward(address(0)) {
752         periodFinish = timestamp;
753     }
754 
755     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
756     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
757         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
758         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
759         emit Recovered(tokenAddress, tokenAmount);
760     }
761 
762     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
763         require(
764             block.timestamp > periodFinish,
765             "Previous rewards period must be complete before changing the duration for the new period"
766         );
767         rewardsDuration = _rewardsDuration;
768         emit RewardsDurationUpdated(rewardsDuration);
769     }
770 
771     /* ========== MODIFIERS ========== */
772 
773     modifier updateReward(address account) {
774 
775         rewardPerTokenAStored = rewardPerTokenA();
776         rewardPerTokenBStored = rewardPerTokenB();
777         lastUpdateTime = lastTimeRewardApplicable();
778         if (account != address(0)) {
779             rewardsA[account] = earnedA(account);
780             userRewardPerTokenAPaid[account] = rewardPerTokenAStored;
781         }
782         
783         if (account != address(0)) {
784             rewardsB[account] = earnedB(account);
785             userRewardPerTokenBPaid[account] = rewardPerTokenBStored;
786         }
787         _;
788     }
789 
790     /* ========== EVENTS ========== */
791 
792     event RewardAdded(uint256 rewardA, uint256 rewardB);
793     event Staked(address indexed user, uint256 amount);
794     event Withdrawn(address indexed user, uint256 amount);
795     event RewardPaid(address indexed user, address rewardToken, uint256 reward);
796     event RewardsDurationUpdated(uint256 newDuration);
797     event Recovered(address token, uint256 amount);
798 }