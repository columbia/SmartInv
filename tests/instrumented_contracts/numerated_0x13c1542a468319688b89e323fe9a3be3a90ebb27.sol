1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Curve sBTC/wBTC/renBTC LP StakingRewards pool
9 *
10 * Synthetix: StakingRewards.sol
11 *
12 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/StakingRewards.sol
13 * Docs: https://docs.synthetix.io/contracts/StakingRewards
14 *
15 * Contract Dependencies: 
16 *	- IERC20
17 *	- Owned
18 *	- ReentrancyGuard
19 *	- RewardsDistributionRecipient
20 *	- TokenWrapper
21 * Libraries: 
22 *	- Address
23 *	- Math
24 *	- SafeERC20
25 *	- SafeMath
26 *
27 * MIT License
28 * ===========
29 *
30 * Copyright (c) 2020 Synthetix
31 *
32 * Permission is hereby granted, free of charge, to any person obtaining a copy
33 * of this software and associated documentation files (the "Software"), to deal
34 * in the Software without restriction, including without limitation the rights
35 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
36 * copies of the Software, and to permit persons to whom the Software is
37 * furnished to do so, subject to the following conditions:
38 *
39 * The above copyright notice and this permission notice shall be included in all
40 * copies or substantial portions of the Software.
41 *
42 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
43 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
44 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
45 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
46 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
47 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
48 */
49 
50 /* ===============================================
51 * Flattened with Solidifier by Coinage
52 * 
53 * https://solidifier.coina.ge
54 * ===============================================
55 */
56 
57 
58 pragma solidity ^0.5.0;
59 
60 /**
61  * @dev Standard math utilities missing in the Solidity language.
62  */
63 library Math {
64     /**
65      * @dev Returns the largest of two numbers.
66      */
67     function max(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a >= b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the smallest of two numbers.
73      */
74     function min(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a < b ? a : b;
76     }
77 
78     /**
79      * @dev Returns the average of two numbers. The result is rounded towards
80      * zero.
81      */
82     function average(uint256 a, uint256 b) internal pure returns (uint256) {
83         // (a + b) / 2 can overflow, so we distribute
84         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
85     }
86 }
87 
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b <= a, "SafeMath: subtraction overflow");
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Solidity only automatically asserts when dividing by 0
171         require(b > 0, "SafeMath: division by zero");
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         require(b != 0, "SafeMath: modulo by zero");
191         return a % b;
192     }
193 }
194 
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
198  * the optional functions; to access them see `ERC20Detailed`.
199  */
200 interface IERC20 {
201     /**
202      * @dev Returns the amount of tokens in existence.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     /**
207      * @dev Returns the amount of tokens owned by `account`.
208      */
209     function balanceOf(address account) external view returns (uint256);
210 
211     /**
212      * @dev Moves `amount` tokens from the caller's account to `recipient`.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a `Transfer` event.
217      */
218     function transfer(address recipient, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Returns the remaining number of tokens that `spender` will be
222      * allowed to spend on behalf of `owner` through `transferFrom`. This is
223      * zero by default.
224      *
225      * This value changes when `approve` or `transferFrom` are called.
226      */
227     function allowance(address owner, address spender) external view returns (uint256);
228 
229     /**
230      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * > Beware that changing an allowance with this method brings the risk
235      * that someone may use both the old and the new allowance by unfortunate
236      * transaction ordering. One possible solution to mitigate this race
237      * condition is to first reduce the spender's allowance to 0 and set the
238      * desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      *
241      * Emits an `Approval` event.
242      */
243     function approve(address spender, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Moves `amount` tokens from `sender` to `recipient` using the
247      * allowance mechanism. `amount` is then deducted from the caller's
248      * allowance.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * Emits a `Transfer` event.
253      */
254     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Emitted when `value` tokens are moved from one account (`from`) to
258      * another (`to`).
259      *
260      * Note that `value` may be zero.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 value);
263 
264     /**
265      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
266      * a call to `approve`. `value` is the new allowance.
267      */
268     event Approval(address indexed owner, address indexed spender, uint256 value);
269 }
270 
271 
272 /**
273  * @dev Optional functions from the ERC20 standard.
274  */
275 contract ERC20Detailed is IERC20 {
276     string private _name;
277     string private _symbol;
278     uint8 private _decimals;
279 
280     /**
281      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
282      * these values are immutable: they can only be set once during
283      * construction.
284      */
285     constructor (string memory name, string memory symbol, uint8 decimals) public {
286         _name = name;
287         _symbol = symbol;
288         _decimals = decimals;
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei.
313      *
314      * > Note that this information is only used for _display_ purposes: it in
315      * no way affects any of the arithmetic of the contract, including
316      * `IERC20.balanceOf` and `IERC20.transfer`.
317      */
318     function decimals() public view returns (uint8) {
319         return _decimals;
320     }
321 }
322 
323 
324 /**
325  * @dev Collection of functions related to the address type,
326  */
327 library Address {
328     /**
329      * @dev Returns true if `account` is a contract.
330      *
331      * This test is non-exhaustive, and there may be false-negatives: during the
332      * execution of a contract's constructor, its address will be reported as
333      * not containing a contract.
334      *
335      * > It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies in extcodesize, which returns 0 for contracts in
340         // construction, since the code is only stored at the end of the
341         // constructor execution.
342 
343         uint256 size;
344         // solhint-disable-next-line no-inline-assembly
345         assembly { size := extcodesize(account) }
346         return size > 0;
347     }
348 }
349 
350 
351 /**
352  * @title SafeERC20
353  * @dev Wrappers around ERC20 operations that throw on failure (when the token
354  * contract returns false). Tokens that return no value (and instead revert or
355  * throw on failure) are also supported, non-reverting calls are assumed to be
356  * successful.
357  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
358  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
359  */
360 library SafeERC20 {
361     using SafeMath for uint256;
362     using Address for address;
363 
364     function safeTransfer(IERC20 token, address to, uint256 value) internal {
365         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
366     }
367 
368     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
369         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
370     }
371 
372     function safeApprove(IERC20 token, address spender, uint256 value) internal {
373         // safeApprove should only be called when setting an initial allowance,
374         // or when resetting it to zero. To increase and decrease it, use
375         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
376         // solhint-disable-next-line max-line-length
377         require((value == 0) || (token.allowance(address(this), spender) == 0),
378             "SafeERC20: approve from non-zero to non-zero allowance"
379         );
380         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
381     }
382 
383     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
384         uint256 newAllowance = token.allowance(address(this), spender).add(value);
385         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
386     }
387 
388     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
389         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
390         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
391     }
392 
393     /**
394      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
395      * on the return value: the return value is optional (but if data is returned, it must not be false).
396      * @param token The token targeted by the call.
397      * @param data The call data (encoded using abi.encode or one of its variants).
398      */
399     function callOptionalReturn(IERC20 token, bytes memory data) private {
400         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
401         // we're implementing it ourselves.
402 
403         // A Solidity high level call has three parts:
404         //  1. The target address is checked to verify it contains contract code
405         //  2. The call itself is made, and success asserted
406         //  3. The return value is decoded, which in turn checks the size of the returned data.
407         // solhint-disable-next-line max-line-length
408         require(address(token).isContract(), "SafeERC20: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = address(token).call(data);
412         require(success, "SafeERC20: low-level call failed");
413 
414         if (returndata.length > 0) { // Return data is optional
415             // solhint-disable-next-line max-line-length
416             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
417         }
418     }
419 }
420 
421 
422 /**
423  * @dev Contract module that helps prevent reentrant calls to a function.
424  *
425  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
426  * available, which can be aplied to functions to make sure there are no nested
427  * (reentrant) calls to them.
428  *
429  * Note that because there is a single `nonReentrant` guard, functions marked as
430  * `nonReentrant` may not call one another. This can be worked around by making
431  * those functions `private`, and then adding `external` `nonReentrant` entry
432  * points to them.
433  */
434 contract ReentrancyGuard {
435     /// @dev counter to allow mutex lock with only one SSTORE operation
436     uint256 private _guardCounter;
437 
438     constructor () internal {
439         // The counter starts at one to prevent changing it from zero to a non-zero
440         // value, which is a more expensive operation.
441         _guardCounter = 1;
442     }
443 
444     /**
445      * @dev Prevents a contract from calling itself, directly or indirectly.
446      * Calling a `nonReentrant` function from another `nonReentrant`
447      * function is not supported. It is possible to prevent this from happening
448      * by making the `nonReentrant` function external, and make it call a
449      * `private` function that does the actual work.
450      */
451     modifier nonReentrant() {
452         _guardCounter += 1;
453         uint256 localCounter = _guardCounter;
454         _;
455         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
456     }
457 }
458 
459 
460 // https://docs.synthetix.io/contracts/Owned
461 contract Owned {
462     address public owner;
463     address public nominatedOwner;
464 
465     constructor(address _owner) public {
466         require(_owner != address(0), "Owner address cannot be 0");
467         owner = _owner;
468         emit OwnerChanged(address(0), _owner);
469     }
470 
471     function nominateNewOwner(address _owner) external onlyOwner {
472         nominatedOwner = _owner;
473         emit OwnerNominated(_owner);
474     }
475 
476     function acceptOwnership() external {
477         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
478         emit OwnerChanged(owner, nominatedOwner);
479         owner = nominatedOwner;
480         nominatedOwner = address(0);
481     }
482 
483     modifier onlyOwner {
484         require(msg.sender == owner, "Only the contract owner may perform this action");
485         _;
486     }
487 
488     event OwnerNominated(address newOwner);
489     event OwnerChanged(address oldOwner, address newOwner);
490 }
491 
492 
493 // Inheritance
494 
495 
496 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
497 contract RewardsDistributionRecipient is Owned {
498     address public rewardsDistribution;
499 
500     function notifyRewardAmount(uint256 reward) external;
501 
502     modifier onlyRewardsDistribution() {
503         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
504         _;
505     }
506 
507     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
508         rewardsDistribution = _rewardsDistribution;
509     }
510 }
511 
512 
513 contract TokenWrapper is ReentrancyGuard {
514     using SafeMath for uint256;
515     using SafeERC20 for IERC20;
516 
517     IERC20 public stakingToken;
518 
519     uint256 private _totalSupply;
520     mapping(address => uint256) private _balances;
521 
522     constructor(address _stakingToken) public {
523         stakingToken = IERC20(_stakingToken);
524     }
525 
526     function totalSupply() public view returns (uint256) {
527         return _totalSupply;
528     }
529 
530     function balanceOf(address account) public view returns (uint256) {
531         return _balances[account];
532     }
533 
534     function stake(uint256 amount) public nonReentrant {
535         _totalSupply = _totalSupply.add(amount);
536         _balances[msg.sender] = _balances[msg.sender].add(amount);
537         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
538     }
539 
540     function withdraw(uint256 amount) public nonReentrant {
541         _totalSupply = _totalSupply.sub(amount);
542         _balances[msg.sender] = _balances[msg.sender].sub(amount);
543         stakingToken.safeTransfer(msg.sender, amount);
544     }
545 }
546 
547 
548 contract StakingRewards is TokenWrapper, RewardsDistributionRecipient {
549     IERC20 public rewardsToken;
550 
551     uint256 public constant DURATION = 7 days;
552 
553     uint256 public periodFinish = 0;
554     uint256 public rewardRate = 0;
555     uint256 public lastUpdateTime;
556     uint256 public rewardPerTokenStored;
557     mapping(address => uint256) public userRewardPerTokenPaid;
558     mapping(address => uint256) public rewards;
559 
560     event RewardAdded(uint256 reward);
561     event Staked(address indexed user, uint256 amount);
562     event Withdrawn(address indexed user, uint256 amount);
563     event RewardPaid(address indexed user, uint256 reward);
564     event Recovered(address indexed token, uint256 amount);
565 
566     constructor(
567         address _owner,
568         address _rewardsDistribution,
569         address _rewardsToken,
570         address _stakingToken
571     ) public TokenWrapper(_stakingToken) Owned(_owner) {
572         rewardsToken = IERC20(_rewardsToken);
573         rewardsDistribution = _rewardsDistribution;
574     }
575 
576     modifier updateReward(address account) {
577         rewardPerTokenStored = rewardPerToken();
578         lastUpdateTime = lastTimeRewardApplicable();
579         if (account != address(0)) {
580             rewards[account] = earned(account);
581             userRewardPerTokenPaid[account] = rewardPerTokenStored;
582         }
583         _;
584     }
585 
586     function lastTimeRewardApplicable() public view returns (uint256) {
587         return Math.min(block.timestamp, periodFinish);
588     }
589 
590     function rewardPerToken() public view returns (uint256) {
591         if (totalSupply() == 0) {
592             return rewardPerTokenStored;
593         }
594         return
595             rewardPerTokenStored.add(
596                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply())
597             );
598     }
599 
600     function earned(address account) public view returns (uint256) {
601         return balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
602     }
603 
604     // stake visibility is public as overriding LPTokenWrapper's stake() function
605     function stake(uint256 amount) public updateReward(msg.sender) {
606         require(amount > 0, "Cannot stake 0");
607         super.stake(amount);
608         emit Staked(msg.sender, amount);
609     }
610 
611     function withdraw(uint256 amount) public updateReward(msg.sender) {
612         require(amount > 0, "Cannot withdraw 0");
613         super.withdraw(amount);
614         emit Withdrawn(msg.sender, amount);
615     }
616 
617     function exit() external {
618         withdraw(balanceOf(msg.sender));
619         getReward();
620     }
621 
622     function getReward() public updateReward(msg.sender) {
623         uint256 reward = earned(msg.sender);
624         if (reward > 0) {
625             rewards[msg.sender] = 0;
626             rewardsToken.safeTransfer(msg.sender, reward);
627             emit RewardPaid(msg.sender, reward);
628         }
629     }
630 
631     function getRewardForDuration() public view returns (uint256) {
632         return rewardRate.mul(DURATION);
633     }
634 
635     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
636         if (block.timestamp >= periodFinish) {
637             rewardRate = reward.div(DURATION);
638         } else {
639             uint256 remaining = periodFinish.sub(block.timestamp);
640             uint256 leftover = remaining.mul(rewardRate);
641             rewardRate = reward.add(leftover).div(DURATION);
642         }
643         lastUpdateTime = block.timestamp;
644         periodFinish = block.timestamp.add(DURATION);
645         emit RewardAdded(reward);
646     }
647 
648     // Added to support recovering LP Rewards from other systems to be distributed to holders
649     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
650         // If it's SNX we have to query the token symbol to ensure its not a proxy or underlying
651         bool isSNX = (keccak256(bytes("SNX")) == keccak256(bytes(ERC20Detailed(tokenAddress).symbol())));
652         // Cannot recover the staking token or the rewards token
653         require(tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken) && !isSNX, "Cannot withdraw the staking or rewards tokens");
654         IERC20(tokenAddress).transfer(owner, tokenAmount);
655         emit Recovered(tokenAddress, tokenAmount);
656     }
657 }