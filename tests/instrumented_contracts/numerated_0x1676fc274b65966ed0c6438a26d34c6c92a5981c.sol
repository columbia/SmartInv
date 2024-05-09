1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-01
3 */
4 
5 /*
6    ____            __   __        __   _
7   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
8  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
9 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
10      /___/
11 
12 *
13 * Docs: https://docs.synthetix.io/
14 *
15 *
16 * MIT License
17 * ===========
18 *
19 * Copyright (c) 2020 Synthetix
20 *
21 * Permission is hereby granted, free of charge, to any person obtaining a copy
22 * of this software and associated documentation files (the "Software"), to deal
23 * in the Software without restriction, including without limitation the rights
24 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
25 * copies of the Software, and to permit persons to whom the Software is
26 * furnished to do so, subject to the following conditions:
27 *
28 * The above copyright notice and this permission notice shall be included in all
29 * copies or substantial portions of the Software.
30 *
31 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
32 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
33 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
34 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
35 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
36 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
37 */
38 
39 // File: @openzeppelin/contracts/math/Math.sol
40 
41 pragma solidity ^0.5.0;
42 
43 /**
44  * @dev Standard math utilities missing in the Solidity language.
45  */
46 library Math {
47     /**
48      * @dev Returns the largest of two numbers.
49      */
50     function max(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a >= b ? a : b;
52     }
53 
54     /**
55      * @dev Returns the smallest of two numbers.
56      */
57     function min(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a < b ? a : b;
59     }
60 
61     /**
62      * @dev Returns the average of two numbers. The result is rounded towards
63      * zero.
64      */
65     function average(uint256 a, uint256 b) internal pure returns (uint256) {
66         // (a + b) / 2 can overflow, so we distribute
67         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/math/SafeMath.sol
72 
73 pragma solidity ^0.5.0;
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations with added overflow
77  * checks.
78  *
79  * Arithmetic operations in Solidity wrap on overflow. This can easily result
80  * in bugs, because programmers usually assume that an overflow raises an
81  * error, which is the standard behavior in high level programming languages.
82  * `SafeMath` restores this intuition by reverting the transaction when an
83  * operation overflows.
84  *
85  * Using this library instead of the unchecked operations eliminates an entire
86  * class of bugs, so it's recommended to use it always.
87  */
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      * - Subtraction cannot overflow.
126      *
127      * _Available since v2.4.0._
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      * - Multiplication cannot overflow.
144      */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         return div(a, b, "SafeMath: division by zero");
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      * - The divisor cannot be zero.
184      *
185      * _Available since v2.4.0._
186      */
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         // Solidity only automatically asserts when dividing by 0
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts with custom message when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      *
222      * _Available since v2.4.0._
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 // File: @openzeppelin/contracts/GSN/Context.sol
231 
232 pragma solidity ^0.5.0;
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with GSN meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 contract Context {
245     // Empty internal constructor, to prevent people from mistakenly deploying
246     // an instance of this contract, which should be used via inheritance.
247     constructor () internal { }
248     // solhint-disable-previous-line no-empty-blocks
249 
250     function _msgSender() internal view returns (address payable) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view returns (bytes memory) {
255         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256         return msg.data;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/ownership/Ownable.sol
261 
262 pragma solidity ^0.5.0;
263 
264 /**
265  * @dev Contract module which provides a basic access control mechanism, where
266  * there is an account (an owner) that can be granted exclusive access to
267  * specific functions.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor () internal {
282         _owner = _msgSender();
283         emit OwnershipTransferred(address(0), _owner);
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(isOwner(), "Ownable: caller is not the owner");
298         _;
299     }
300 
301     /**
302      * @dev Returns true if the caller is the current owner.
303      */
304     function isOwner() public view returns (bool) {
305         return _msgSender() == _owner;
306     }
307 
308     /**
309      * @dev Leaves the contract without owner. It will not be possible to call
310      * `onlyOwner` functions anymore. Can only be called by the current owner.
311      *
312      * NOTE: Renouncing ownership will leave the contract without an owner,
313      * thereby removing any functionality that is only available to the owner.
314      */
315     function renounceOwnership() public onlyOwner {
316         emit OwnershipTransferred(_owner, address(0));
317         _owner = address(0);
318     }
319 
320     /**
321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
322      * Can only be called by the current owner.
323      */
324     function transferOwnership(address newOwner) public onlyOwner {
325         _transferOwnership(newOwner);
326     }
327 
328     /**
329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
330      */
331     function _transferOwnership(address newOwner) internal {
332         require(newOwner != address(0), "Ownable: new owner is the zero address");
333         emit OwnershipTransferred(_owner, newOwner);
334         _owner = newOwner;
335     }
336 }
337 
338 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
339 
340 pragma solidity ^0.5.0;
341 
342 /**
343  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
344  * the optional functions; to access them see {ERC20Detailed}.
345  */
346 interface IERC20 {
347     /**
348      * @dev Returns the amount of tokens in existence.
349      */
350     function totalSupply() external view returns (uint256);
351 
352     /**
353      * @dev Returns the amount of tokens owned by `account`.
354      */
355     function balanceOf(address account) external view returns (uint256);
356 
357     /**
358      * @dev Moves `amount` tokens from the caller's account to `recipient`.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * Emits a {Transfer} event.
363      */
364     function transfer(address recipient, uint256 amount) external returns (bool);
365 
366     /**
367      * @dev Returns the remaining number of tokens that `spender` will be
368      * allowed to spend on behalf of `owner` through {transferFrom}. This is
369      * zero by default.
370      *
371      * This value changes when {approve} or {transferFrom} are called.
372      */
373     function allowance(address owner, address spender) external view returns (uint256);
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * IMPORTANT: Beware that changing an allowance with this method brings the risk
381      * that someone may use both the old and the new allowance by unfortunate
382      * transaction ordering. One possible solution to mitigate this race
383      * condition is to first reduce the spender's allowance to 0 and set the
384      * desired value afterwards:
385      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
386      *
387      * Emits an {Approval} event.
388      */
389     function approve(address spender, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Moves `amount` tokens from `sender` to `recipient` using the
393      * allowance mechanism. `amount` is then deducted from the caller's
394      * allowance.
395      *
396      * Returns a boolean value indicating whether the operation succeeded.
397      *
398      * Emits a {Transfer} event.
399      */
400     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Emitted when `value` tokens are moved from one account (`from`) to
404      * another (`to`).
405      *
406      * Note that `value` may be zero.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 value);
409 
410     /**
411      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
412      * a call to {approve}. `value` is the new allowance.
413      */
414     event Approval(address indexed owner, address indexed spender, uint256 value);
415 }
416 
417 // File: @openzeppelin/contracts/utils/Address.sol
418 
419 pragma solidity ^0.5.5;
420 
421 /**
422  * @dev Collection of functions related to the address type
423  */
424 library Address {
425     /**
426      * @dev Returns true if `account` is a contract.
427      *
428      * This test is non-exhaustive, and there may be false-negatives: during the
429      * execution of a contract's constructor, its address will be reported as
430      * not containing a contract.
431      *
432      * IMPORTANT: It is unsafe to assume that an address for which this
433      * function returns false is an externally-owned account (EOA) and not a
434      * contract.
435      */
436     function isContract(address account) internal view returns (bool) {
437         // This method relies in extcodesize, which returns 0 for contracts in
438         // construction, since the code is only stored at the end of the
439         // constructor execution.
440 
441         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
442         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
443         // for accounts without code, i.e. `keccak256('')`
444         bytes32 codehash;
445         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
446         // solhint-disable-next-line no-inline-assembly
447         assembly { codehash := extcodehash(account) }
448         return (codehash != 0x0 && codehash != accountHash);
449     }
450 
451     /**
452      * @dev Converts an `address` into `address payable`. Note that this is
453      * simply a type cast: the actual underlying value is not changed.
454      *
455      * _Available since v2.4.0._
456      */
457     function toPayable(address account) internal pure returns (address payable) {
458         return address(uint160(account));
459     }
460 
461     /**
462      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
463      * `recipient`, forwarding all available gas and reverting on errors.
464      *
465      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
466      * of certain opcodes, possibly making contracts go over the 2300 gas limit
467      * imposed by `transfer`, making them unable to receive funds via
468      * `transfer`. {sendValue} removes this limitation.
469      *
470      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
471      *
472      * IMPORTANT: because control is transferred to `recipient`, care must be
473      * taken to not create reentrancy vulnerabilities. Consider using
474      * {ReentrancyGuard} or the
475      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
476      *
477      * _Available since v2.4.0._
478      */
479     function sendValue(address payable recipient, uint256 amount) internal {
480         require(address(this).balance >= amount, "Address: insufficient balance");
481 
482         // solhint-disable-next-line avoid-call-value
483         (bool success, ) = recipient.call.value(amount)("");
484         require(success, "Address: unable to send value, recipient may have reverted");
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
489 
490 pragma solidity ^0.5.0;
491 
492 
493 
494 
495 /**
496  * @title SafeERC20
497  * @dev Wrappers around ERC20 operations that throw on failure (when the token
498  * contract returns false). Tokens that return no value (and instead revert or
499  * throw on failure) are also supported, non-reverting calls are assumed to be
500  * successful.
501  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
502  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
503  */
504 library SafeERC20 {
505     using SafeMath for uint256;
506     using Address for address;
507 
508     function safeTransfer(IERC20 token, address to, uint256 value) internal {
509         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
510     }
511 
512     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
513         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
514     }
515 
516     function safeApprove(IERC20 token, address spender, uint256 value) internal {
517         // safeApprove should only be called when setting an initial allowance,
518         // or when resetting it to zero. To increase and decrease it, use
519         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
520         // solhint-disable-next-line max-line-length
521         require((value == 0) || (token.allowance(address(this), spender) == 0),
522             "SafeERC20: approve from non-zero to non-zero allowance"
523         );
524         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
525     }
526 
527     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).add(value);
529         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
530     }
531 
532     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
533         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
534         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     /**
538      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
539      * on the return value: the return value is optional (but if data is returned, it must not be false).
540      * @param token The token targeted by the call.
541      * @param data The call data (encoded using abi.encode or one of its variants).
542      */
543     function callOptionalReturn(IERC20 token, bytes memory data) private {
544         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
545         // we're implementing it ourselves.
546 
547         // A Solidity high level call has three parts:
548         //  1. The target address is checked to verify it contains contract code
549         //  2. The call itself is made, and success asserted
550         //  3. The return value is decoded, which in turn checks the size of the returned data.
551         // solhint-disable-next-line max-line-length
552         require(address(token).isContract(), "SafeERC20: call to non-contract");
553 
554         // solhint-disable-next-line avoid-low-level-calls
555         (bool success, bytes memory returndata) = address(token).call(data);
556         require(success, "SafeERC20: low-level call failed");
557 
558         if (returndata.length > 0) { // Return data is optional
559             // solhint-disable-next-line max-line-length
560             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
561         }
562     }
563 }
564 
565 // File: contracts/IRewardDistributionRecipient.sol
566 
567 pragma solidity ^0.5.0;
568 
569 
570 
571 contract IRewardDistributionRecipient is Ownable {
572     address rewardDistribution;
573 
574     function notifyRewardAmount(uint256 reward) external;
575 
576     modifier onlyRewardDistribution() {
577         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
578         _;
579     }
580 
581     function setRewardDistribution(address _rewardDistribution)
582         external
583         onlyOwner
584     {
585         rewardDistribution = _rewardDistribution;
586     }
587 }
588 
589 
590 pragma solidity ^0.5.0;
591 
592 
593 contract LPTokenWrapper {
594     using SafeMath for uint256;
595     using SafeERC20 for IERC20;
596 
597     IERC20 public lpToken;
598 
599     uint256 private _totalSupply;
600     mapping(address => uint256) private _balances;
601 
602     constructor(address _lpToken) internal {
603         lpToken = IERC20(_lpToken);
604     }
605 
606     function totalSupply() public view returns (uint256) {
607         return _totalSupply;
608     }
609 
610     function balanceOf(address account) public view returns (uint256) {
611         return _balances[account];
612     }
613 
614     function stake(uint256 amount) public {
615         _totalSupply = _totalSupply.add(amount);
616         _balances[msg.sender] = _balances[msg.sender].add(amount);
617         lpToken.safeTransferFrom(msg.sender, address(this), amount);
618     }
619 
620     function withdraw(uint256 amount) public {
621         _totalSupply = _totalSupply.sub(amount);
622         _balances[msg.sender] = _balances[msg.sender].sub(amount);
623         lpToken.safeTransfer(msg.sender, amount);
624     }
625 }
626 
627 contract StakingRewardsLock is LPTokenWrapper, IRewardDistributionRecipient {
628     IERC20 public cream = IERC20(0x2ba592F78dB6436527729929AAf6c908497cB200);
629     uint256 public constant DURATION = 7 days;
630 
631     /* Fees breaker, to protect withdraws if anything ever goes wrong */
632     bool public breaker = false;
633     mapping(address => uint) public stakeLock; // period that your sake it locked to keep it for staking
634     uint public lock = 17280; // stake lock in blocks ~ 17280 3 days for 15s/block
635     address public admin;
636 
637     uint256 public periodFinish = 0;
638     uint256 public rewardRate = 0;
639     uint256 public lastUpdateTime;
640     uint256 public rewardPerTokenStored;
641     mapping(address => uint256) public userRewardPerTokenPaid;
642     mapping(address => uint256) public rewards;
643 
644     event RewardAdded(uint256 reward);
645     event Staked(address indexed user, uint256 amount);
646     event Withdrawn(address indexed user, uint256 amount);
647     event RewardPaid(address indexed user, uint256 reward);
648 
649     constructor(address _lpToken) public LPTokenWrapper(_lpToken) {
650         admin = msg.sender;
651     }
652 
653     function setBreaker(bool _breaker) external {
654         require(msg.sender == admin, "admin only");
655         breaker = _breaker;
656     }
657 
658     modifier updateReward(address account) {
659         rewardPerTokenStored = rewardPerToken();
660         lastUpdateTime = lastTimeRewardApplicable();
661         if (account != address(0)) {
662             rewards[account] = earned(account);
663             userRewardPerTokenPaid[account] = rewardPerTokenStored;
664         }
665         _;
666     }
667 
668     function seize(IERC20 _token, uint amount) external {
669         require(msg.sender == admin, "admin only");
670         require(_token != cream, "cream");
671         require(_token != lpToken, "bpt");
672         _token.safeTransfer(admin, amount);
673     }
674 
675     function lastTimeRewardApplicable() public view returns (uint256) {
676         return Math.min(block.timestamp, periodFinish);
677     }
678 
679     function rewardPerToken() public view returns (uint256) {
680         if (totalSupply() == 0) {
681             return rewardPerTokenStored;
682         }
683         return
684             rewardPerTokenStored.add(
685                 lastTimeRewardApplicable()
686                     .sub(lastUpdateTime)
687                     .mul(rewardRate)
688                     .mul(1e18)
689                     .div(totalSupply())
690             );
691     }
692 
693     function earned(address account) public view returns (uint256) {
694         return
695             balanceOf(account)
696                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
697                 .div(1e18)
698                 .add(rewards[account]);
699     }
700 
701     // stake visibility is public as overriding LPTokenWrapper's stake() function
702     function stake(uint256 amount) public updateReward(msg.sender) {
703         require(amount > 0, "Cannot stake 0");
704         super.stake(amount);
705         stakeLock[msg.sender] = lock.add(block.number);
706         emit Staked(msg.sender, amount);
707     }
708 
709     function withdraw(uint256 amount) public updateReward(msg.sender) {
710         require(amount > 0, "Cannot withdraw 0");
711         if (breaker == false) {
712             require(stakeLock[msg.sender] < block.number,"!locked");
713         }
714         super.withdraw(amount);
715         emit Withdrawn(msg.sender, amount);
716     }
717 
718     function exit() external {
719         withdraw(balanceOf(msg.sender));
720         getReward();
721     }
722 
723     function getReward() public updateReward(msg.sender) {
724         uint256 reward = earned(msg.sender);
725         if (reward > 0) {
726             rewards[msg.sender] = 0;
727             cream.safeTransfer(msg.sender, reward);
728             emit RewardPaid(msg.sender, reward);
729         }
730     }
731 
732     function notifyRewardAmount(uint256 reward)
733         external
734         onlyRewardDistribution
735         updateReward(address(0))
736     {
737         if (block.timestamp >= periodFinish) {
738             rewardRate = reward.div(DURATION);
739         } else {
740             uint256 remaining = periodFinish.sub(block.timestamp);
741             uint256 leftover = remaining.mul(rewardRate);
742             rewardRate = reward.add(leftover).div(DURATION);
743         }
744         lastUpdateTime = block.timestamp;
745         periodFinish = block.timestamp.add(DURATION);
746         emit RewardAdded(reward);
747     }
748 }