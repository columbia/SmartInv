1 // File: contracts/UniswapLPReward.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2020-07-17
5 */
6 
7 /*
8    ____            __   __        __   _
9   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
10  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
11 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
12      /___/
13 * Synthetix: YFIRewards.sol
14 *
15 * Docs: https://docs.synthetix.io/
16 *
17 *
18 * MIT License
19 * ===========
20 *
21 * Copyright (c) 2020 Synthetix
22 *
23 * Permission is hereby granted, free of charge, to any person obtaining a copy
24 * of this software and associated documentation files (the "Software"), to deal
25 * in the Software without restriction, including without limitation the rights
26 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
27 * copies of the Software, and to permit persons to whom the Software is
28 * furnished to do so, subject to the following conditions:
29 *
30 * The above copyright notice and this permission notice shall be included in all
31 * copies or substantial portions of the Software.
32 *
33 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
34 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
35 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
36 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
37 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
38 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
39 */
40 
41 // File: @openzeppelin/contracts/math/Math.sol
42 
43 pragma solidity ^0.5.0;
44 
45 /**
46  * @dev Standard math utilities missing in the Solidity language.
47  */
48 library Math {
49     /**
50      * @dev Returns the largest of two numbers.
51      */
52     function max(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a >= b ? a : b;
54     }
55 
56     /**
57      * @dev Returns the smallest of two numbers.
58      */
59     function min(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a < b ? a : b;
61     }
62 
63     /**
64      * @dev Returns the average of two numbers. The result is rounded towards
65      * zero.
66      */
67     function average(uint256 a, uint256 b) internal pure returns (uint256) {
68         // (a + b) / 2 can overflow, so we distribute
69         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/math/SafeMath.sol
74 
75 pragma solidity ^0.5.0;
76 
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      * - Subtraction cannot overflow.
128      *
129      * _Available since v2.4.0._
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      *
187      * _Available since v2.4.0._
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         // Solidity only automatically asserts when dividing by 0
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/GSN/Context.sol
233 
234 pragma solidity ^0.5.0;
235 
236 /*
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with GSN meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 contract Context {
247     // Empty internal constructor, to prevent people from mistakenly deploying
248     // an instance of this contract, which should be used via inheritance.
249     constructor () internal { }
250     // solhint-disable-previous-line no-empty-blocks
251 
252     function _msgSender() internal view returns (address payable) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view returns (bytes memory) {
257         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
258         return msg.data;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/ownership/Ownable.sol
263 
264 pragma solidity ^0.5.0;
265 
266 /**
267  * @dev Contract module which provides a basic access control mechanism, where
268  * there is an account (an owner) that can be granted exclusive access to
269  * specific functions.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor () internal {
284         _owner = _msgSender();
285         emit OwnershipTransferred(address(0), _owner);
286     }
287 
288     /**
289      * @dev Returns the address of the current owner.
290      */
291     function owner() public view returns (address) {
292         return _owner;
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the owner.
297      */
298     modifier onlyOwner() {
299         require(isOwner(), "Ownable: caller is not the owner");
300         _;
301     }
302 
303     /**
304      * @dev Returns true if the caller is the current owner.
305      */
306     function isOwner() public view returns (bool) {
307         return _msgSender() == _owner;
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public onlyOwner {
318         emit OwnershipTransferred(_owner, address(0));
319         _owner = address(0);
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      * Can only be called by the current owner.
325      */
326     function transferOwnership(address newOwner) public onlyOwner {
327         _transferOwnership(newOwner);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      */
333     function _transferOwnership(address newOwner) internal {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         emit OwnershipTransferred(_owner, newOwner);
336         _owner = newOwner;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
341 
342 pragma solidity ^0.5.0;
343 
344 /**
345  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
346  * the optional functions; to access them see {ERC20Detailed}.
347  */
348 interface IERC20 {
349     /**
350      * @dev Returns the amount of tokens in existence.
351      */
352     function totalSupply() external view returns (uint256);
353 
354     /**
355      * @dev Returns the amount of tokens owned by `account`.
356      */
357     function balanceOf(address account) external view returns (uint256);
358 
359     /**
360      * @dev Moves `amount` tokens from the caller's account to `recipient`.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transfer(address recipient, uint256 amount) external returns (bool);
367 
368     /**
369      * @dev Returns the remaining number of tokens that `spender` will be
370      * allowed to spend on behalf of `owner` through {transferFrom}. This is
371      * zero by default.
372      *
373      * This value changes when {approve} or {transferFrom} are called.
374      */
375     function allowance(address owner, address spender) external view returns (uint256);
376 
377     /**
378      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * IMPORTANT: Beware that changing an allowance with this method brings the risk
383      * that someone may use both the old and the new allowance by unfortunate
384      * transaction ordering. One possible solution to mitigate this race
385      * condition is to first reduce the spender's allowance to 0 and set the
386      * desired value afterwards:
387      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
388      *
389      * Emits an {Approval} event.
390      */
391     function approve(address spender, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Moves `amount` tokens from `sender` to `recipient` using the
395      * allowance mechanism. `amount` is then deducted from the caller's
396      * allowance.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Emitted when `value` tokens are moved from one account (`from`) to
406      * another (`to`).
407      *
408      * Note that `value` may be zero.
409      */
410     event Transfer(address indexed from, address indexed to, uint256 value);
411 
412     /**
413      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
414      * a call to {approve}. `value` is the new allowance.
415      */
416     event Approval(address indexed owner, address indexed spender, uint256 value);
417 }
418 
419 // File: @openzeppelin/contracts/utils/Address.sol
420 
421 pragma solidity ^0.5.5;
422 
423 /**
424  * @dev Collection of functions related to the address type
425  */
426 library Address {
427     /**
428      * @dev Returns true if `account` is a contract.
429      *
430      * This test is non-exhaustive, and there may be false-negatives: during the
431      * execution of a contract's constructor, its address will be reported as
432      * not containing a contract.
433      *
434      * IMPORTANT: It is unsafe to assume that an address for which this
435      * function returns false is an externally-owned account (EOA) and not a
436      * contract.
437      */
438     function isContract(address account) internal view returns (bool) {
439         // This method relies in extcodesize, which returns 0 for contracts in
440         // construction, since the code is only stored at the end of the
441         // constructor execution.
442 
443         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
444         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
445         // for accounts without code, i.e. `keccak256('')`
446         bytes32 codehash;
447         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
448         // solhint-disable-next-line no-inline-assembly
449         assembly { codehash := extcodehash(account) }
450         return (codehash != 0x0 && codehash != accountHash);
451     }
452 
453     /**
454      * @dev Converts an `address` into `address payable`. Note that this is
455      * simply a type cast: the actual underlying value is not changed.
456      *
457      * _Available since v2.4.0._
458      */
459     function toPayable(address account) internal pure returns (address payable) {
460         return address(uint160(account));
461     }
462 
463     /**
464      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
465      * `recipient`, forwarding all available gas and reverting on errors.
466      *
467      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
468      * of certain opcodes, possibly making contracts go over the 2300 gas limit
469      * imposed by `transfer`, making them unable to receive funds via
470      * `transfer`. {sendValue} removes this limitation.
471      *
472      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
473      *
474      * IMPORTANT: because control is transferred to `recipient`, care must be
475      * taken to not create reentrancy vulnerabilities. Consider using
476      * {ReentrancyGuard} or the
477      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
478      *
479      * _Available since v2.4.0._
480      */
481     function sendValue(address payable recipient, uint256 amount) internal {
482         require(address(this).balance >= amount, "Address: insufficient balance");
483 
484         // solhint-disable-next-line avoid-call-value
485         (bool success, ) = recipient.call.value(amount)("");
486         require(success, "Address: unable to send value, recipient may have reverted");
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
491 
492 pragma solidity ^0.5.0;
493 
494 
495 
496 
497 /**
498  * @title SafeERC20
499  * @dev Wrappers around ERC20 operations that throw on failure (when the token
500  * contract returns false). Tokens that return no value (and instead revert or
501  * throw on failure) are also supported, non-reverting calls are assumed to be
502  * successful.
503  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
504  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
505  */
506 library SafeERC20 {
507     using SafeMath for uint256;
508     using Address for address;
509 
510     function safeTransfer(IERC20 token, address to, uint256 value) internal {
511         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
512     }
513 
514     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
515         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
516     }
517 
518     function safeApprove(IERC20 token, address spender, uint256 value) internal {
519         // safeApprove should only be called when setting an initial allowance,
520         // or when resetting it to zero. To increase and decrease it, use
521         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
522         // solhint-disable-next-line max-line-length
523         require((value == 0) || (token.allowance(address(this), spender) == 0),
524             "SafeERC20: approve from non-zero to non-zero allowance"
525         );
526         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
527     }
528 
529     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).add(value);
531         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
532     }
533 
534     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
535         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
536         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
537     }
538 
539     /**
540      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
541      * on the return value: the return value is optional (but if data is returned, it must not be false).
542      * @param token The token targeted by the call.
543      * @param data The call data (encoded using abi.encode or one of its variants).
544      */
545     function callOptionalReturn(IERC20 token, bytes memory data) private {
546         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
547         // we're implementing it ourselves.
548 
549         // A Solidity high level call has three parts:
550         //  1. The target address is checked to verify it contains contract code
551         //  2. The call itself is made, and success asserted
552         //  3. The return value is decoded, which in turn checks the size of the returned data.
553         // solhint-disable-next-line max-line-length
554         require(address(token).isContract(), "SafeERC20: call to non-contract");
555 
556         // solhint-disable-next-line avoid-low-level-calls
557         (bool success, bytes memory returndata) = address(token).call(data);
558         require(success, "SafeERC20: low-level call failed");
559 
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 // File: contracts/IRewardDistributionRecipient.sol
568 
569 pragma solidity ^0.5.0;
570 
571 
572 
573 contract IRewardDistributionRecipient is Ownable {
574     address rewardDistribution;
575 
576     function notifyRewardAmount(uint256 reward) external;
577 
578     modifier onlyRewardDistribution() {
579         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
580         _;
581     }
582 
583     function setRewardDistribution(address _rewardDistribution)
584         external
585         onlyOwner
586     {
587         rewardDistribution = _rewardDistribution;
588     }
589 }
590 
591 // File: contracts/CurveRewards.sol
592 
593 pragma solidity ^0.5.0;
594 
595 
596 
597 
598 
599 
600 contract LPTokenWrapper {
601     using SafeMath for uint256;
602     using SafeERC20 for IERC20;
603 
604     IERC20 public rewardLP;
605 
606     uint256 private _totalSupply;
607     mapping(address => uint256) private _balances;
608 
609     constructor(IERC20 _rewardLP) public {
610         rewardLP = _rewardLP;
611     }
612 
613     function totalSupply() public view returns (uint256) {
614         return _totalSupply;
615     }
616 
617     function balanceOf(address account) public view returns (uint256) {
618         return _balances[account];
619     }
620 
621     function stake(uint256 amount) public {
622         _totalSupply = _totalSupply.add(amount);
623         _balances[msg.sender] = _balances[msg.sender].add(amount);
624         rewardLP.safeTransferFrom(msg.sender, address(this), amount);
625     }
626 
627     function withdraw(uint256 amount) public {
628         _totalSupply = _totalSupply.sub(amount);
629         _balances[msg.sender] = _balances[msg.sender].sub(amount);
630         rewardLP.safeTransfer(msg.sender, amount);
631     }
632 }
633 
634 contract UniswapLPReward is LPTokenWrapper, IRewardDistributionRecipient {
635     IERC20 public typhoon;
636     uint256 public constant DURATION = 28 days;
637 
638     uint256 public periodFinish = 0;
639     uint256 public rewardRate = 0;
640     uint256 public lastUpdateTime;
641     uint256 public rewardPerTokenStored;
642     mapping(address => uint256) public userRewardPerTokenPaid;
643     mapping(address => uint256) public rewards;
644 
645     event RewardAdded(uint256 reward);
646     event Staked(address indexed user, uint256 amount);
647     event Withdrawn(address indexed user, uint256 amount);
648     event RewardPaid(address indexed user, uint256 reward);
649 
650     constructor(IERC20 _typhoon, IERC20 _rewardLP) LPTokenWrapper(_rewardLP) public {
651         typhoon = _typhoon;
652     }
653 
654     modifier updateReward(address account) {
655         rewardPerTokenStored = rewardPerToken();
656         lastUpdateTime = lastTimeRewardApplicable();
657         if (account != address(0)) {
658             rewards[account] = earned(account);
659             userRewardPerTokenPaid[account] = rewardPerTokenStored;
660         }
661         _;
662     }
663 
664     function lastTimeRewardApplicable() public view returns (uint256) {
665         return Math.min(block.timestamp, periodFinish);
666     }
667 
668     function rewardPerToken() public view returns (uint256) {
669         if (totalSupply() == 0) {
670             return rewardPerTokenStored;
671         }
672         return
673             rewardPerTokenStored.add(
674                 lastTimeRewardApplicable()
675                     .sub(lastUpdateTime)
676                     .mul(rewardRate)
677                     .mul(1e18)
678                     .div(totalSupply())
679             );
680     }
681 
682     function earned(address account) public view returns (uint256) {
683         return
684             balanceOf(account)
685                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
686                 .div(1e18)
687                 .add(rewards[account]);
688     }
689 
690     // stake visibility is public as overriding LPTokenWrapper's stake() function
691     function stake(uint256 amount) public updateReward(msg.sender) {
692         require(amount > 0, "Cannot stake 0");
693         super.stake(amount);
694         emit Staked(msg.sender, amount);
695     }
696 
697     function withdraw(uint256 amount) public updateReward(msg.sender) {
698         require(amount > 0, "Cannot withdraw 0");
699         super.withdraw(amount);
700         emit Withdrawn(msg.sender, amount);
701     }
702 
703     function exit() external {
704         withdraw(balanceOf(msg.sender));
705         getReward();
706     }
707 
708     function getReward() public updateReward(msg.sender) {
709         uint256 reward = earned(msg.sender);
710         if (reward > 0) {
711             rewards[msg.sender] = 0;
712             typhoon.safeTransfer(msg.sender, reward);
713             emit RewardPaid(msg.sender, reward);
714         }
715     }
716 
717     function notifyRewardAmount(uint256 reward)
718         external
719         onlyRewardDistribution
720         updateReward(address(0))
721     {
722         if (block.timestamp >= periodFinish) {
723             rewardRate = reward.div(DURATION);
724         } else {
725             uint256 remaining = periodFinish.sub(block.timestamp);
726             uint256 leftover = remaining.mul(rewardRate);
727             rewardRate = reward.add(leftover).div(DURATION);
728         }
729         lastUpdateTime = block.timestamp;
730         periodFinish = block.timestamp.add(DURATION);
731         emit RewardAdded(reward);
732     }
733 }