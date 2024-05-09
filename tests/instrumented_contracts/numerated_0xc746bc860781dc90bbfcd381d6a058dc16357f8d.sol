1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: iETHRewards.sol
9 *
10 * Docs: https://docs.synthetix.io/
11 *
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 Synthetix
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 
37 // File: @openzeppelin/contracts/math/Math.sol
38 
39 pragma solidity ^0.5.0;
40 
41 /**
42  * @dev Standard math utilities missing in the Solidity language.
43  */
44 library Math {
45     /**
46      * @dev Returns the largest of two numbers.
47      */
48     function max(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a >= b ? a : b;
50     }
51 
52     /**
53      * @dev Returns the smallest of two numbers.
54      */
55     function min(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a < b ? a : b;
57     }
58 
59     /**
60      * @dev Returns the average of two numbers. The result is rounded towards
61      * zero.
62      */
63     function average(uint256 a, uint256 b) internal pure returns (uint256) {
64         // (a + b) / 2 can overflow, so we distribute
65         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
66     }
67 }
68 
69 // File: @openzeppelin/contracts/math/SafeMath.sol
70 
71 pragma solidity ^0.5.0;
72 
73 /**
74  * @dev Wrappers over Solidity's arithmetic operations with added overflow
75  * checks.
76  *
77  * Arithmetic operations in Solidity wrap on overflow. This can easily result
78  * in bugs, because programmers usually assume that an overflow raises an
79  * error, which is the standard behavior in high level programming languages.
80  * `SafeMath` restores this intuition by reverting the transaction when an
81  * operation overflows.
82  *
83  * Using this library instead of the unchecked operations eliminates an entire
84  * class of bugs, so it's recommended to use it always.
85  */
86 library SafeMath {
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the subtraction of two unsigned integers, reverting on
105      * overflow (when the result is negative).
106      *
107      * Counterpart to Solidity's `-` operator.
108      *
109      * Requirements:
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return sub(a, b, "SafeMath: subtraction overflow");
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      * - Subtraction cannot overflow.
124      *
125      * _Available since v2.4.0._
126      */
127     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b <= a, errorMessage);
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      * - Multiplication cannot overflow.
142      */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
145         // benefit is lost if 'b' is also tested.
146         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
147         if (a == 0) {
148             return 0;
149         }
150 
151         uint256 c = a * b;
152         require(c / a == b, "SafeMath: multiplication overflow");
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         return div(a, b, "SafeMath: division by zero");
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      *
183      * _Available since v2.4.0._
184      */
185     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         // Solidity only automatically asserts when dividing by 0
187         require(b > 0, errorMessage);
188         uint256 c = a / b;
189         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206         return mod(a, b, "SafeMath: modulo by zero");
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts with custom message when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      *
220      * _Available since v2.4.0._
221      */
222     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b != 0, errorMessage);
224         return a % b;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/GSN/Context.sol
229 
230 pragma solidity ^0.5.0;
231 
232 /*
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with GSN meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 contract Context {
243     // Empty internal constructor, to prevent people from mistakenly deploying
244     // an instance of this contract, which should be used via inheritance.
245     constructor () internal { }
246     // solhint-disable-previous-line no-empty-blocks
247 
248     function _msgSender() internal view returns (address payable) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view returns (bytes memory) {
253         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
254         return msg.data;
255     }
256 }
257 
258 // File: @openzeppelin/contracts/ownership/Ownable.sol
259 
260 pragma solidity ^0.5.0;
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor () internal {
280         _owner = _msgSender();
281         emit OwnershipTransferred(address(0), _owner);
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(isOwner(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Returns true if the caller is the current owner.
301      */
302     function isOwner() public view returns (bool) {
303         return _msgSender() == _owner;
304     }
305 
306     /**
307      * @dev Leaves the contract without owner. It will not be possible to call
308      * `onlyOwner` functions anymore. Can only be called by the current owner.
309      *
310      * NOTE: Renouncing ownership will leave the contract without an owner,
311      * thereby removing any functionality that is only available to the owner.
312      */
313     function renounceOwnership() public onlyOwner {
314         emit OwnershipTransferred(_owner, address(0));
315         _owner = address(0);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public onlyOwner {
323         _transferOwnership(newOwner);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      */
329     function _transferOwnership(address newOwner) internal {
330         require(newOwner != address(0), "Ownable: new owner is the zero address");
331         emit OwnershipTransferred(_owner, newOwner);
332         _owner = newOwner;
333     }
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
337 
338 pragma solidity ^0.5.0;
339 
340 /**
341  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
342  * the optional functions; to access them see {ERC20Detailed}.
343  */
344 interface IERC20 {
345     /**
346      * @dev Returns the amount of tokens in existence.
347      */
348     function totalSupply() external view returns (uint256);
349 
350     /**
351      * @dev Returns the amount of tokens owned by `account`.
352      */
353     function balanceOf(address account) external view returns (uint256);
354 
355     /**
356      * @dev Moves `amount` tokens from the caller's account to `recipient`.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * Emits a {Transfer} event.
361      */
362     function transfer(address recipient, uint256 amount) external returns (bool);
363 
364     /**
365      * @dev Returns the remaining number of tokens that `spender` will be
366      * allowed to spend on behalf of `owner` through {transferFrom}. This is
367      * zero by default.
368      *
369      * This value changes when {approve} or {transferFrom} are called.
370      */
371     function allowance(address owner, address spender) external view returns (uint256);
372 
373     /**
374      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * IMPORTANT: Beware that changing an allowance with this method brings the risk
379      * that someone may use both the old and the new allowance by unfortunate
380      * transaction ordering. One possible solution to mitigate this race
381      * condition is to first reduce the spender's allowance to 0 and set the
382      * desired value afterwards:
383      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
384      *
385      * Emits an {Approval} event.
386      */
387     function approve(address spender, uint256 amount) external returns (bool);
388 
389     /**
390      * @dev Moves `amount` tokens from `sender` to `recipient` using the
391      * allowance mechanism. `amount` is then deducted from the caller's
392      * allowance.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * Emits a {Transfer} event.
397      */
398     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
399 
400     /**
401      * @dev Emitted when `value` tokens are moved from one account (`from`) to
402      * another (`to`).
403      *
404      * Note that `value` may be zero.
405      */
406     event Transfer(address indexed from, address indexed to, uint256 value);
407 
408     /**
409      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
410      * a call to {approve}. `value` is the new allowance.
411      */
412     event Approval(address indexed owner, address indexed spender, uint256 value);
413 }
414 
415 // File: @openzeppelin/contracts/utils/Address.sol
416 
417 pragma solidity ^0.5.5;
418 
419 /**
420  * @dev Collection of functions related to the address type
421  */
422 library Address {
423     /**
424      * @dev Returns true if `account` is a contract.
425      *
426      * This test is non-exhaustive, and there may be false-negatives: during the
427      * execution of a contract's constructor, its address will be reported as
428      * not containing a contract.
429      *
430      * IMPORTANT: It is unsafe to assume that an address for which this
431      * function returns false is an externally-owned account (EOA) and not a
432      * contract.
433      */
434     function isContract(address account) internal view returns (bool) {
435         // This method relies in extcodesize, which returns 0 for contracts in
436         // construction, since the code is only stored at the end of the
437         // constructor execution.
438 
439         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
440         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
441         // for accounts without code, i.e. `keccak256('')`
442         bytes32 codehash;
443         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
444         // solhint-disable-next-line no-inline-assembly
445         assembly { codehash := extcodehash(account) }
446         return (codehash != 0x0 && codehash != accountHash);
447     }
448 
449     /**
450      * @dev Converts an `address` into `address payable`. Note that this is
451      * simply a type cast: the actual underlying value is not changed.
452      *
453      * _Available since v2.4.0._
454      */
455     function toPayable(address account) internal pure returns (address payable) {
456         return address(uint160(account));
457     }
458 
459     /**
460      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
461      * `recipient`, forwarding all available gas and reverting on errors.
462      *
463      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
464      * of certain opcodes, possibly making contracts go over the 2300 gas limit
465      * imposed by `transfer`, making them unable to receive funds via
466      * `transfer`. {sendValue} removes this limitation.
467      *
468      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
469      *
470      * IMPORTANT: because control is transferred to `recipient`, care must be
471      * taken to not create reentrancy vulnerabilities. Consider using
472      * {ReentrancyGuard} or the
473      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
474      *
475      * _Available since v2.4.0._
476      */
477     function sendValue(address payable recipient, uint256 amount) internal {
478         require(address(this).balance >= amount, "Address: insufficient balance");
479 
480         // solhint-disable-next-line avoid-call-value
481         (bool success, ) = recipient.call.value(amount)("");
482         require(success, "Address: unable to send value, recipient may have reverted");
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
487 
488 pragma solidity ^0.5.0;
489 
490 
491 
492 
493 /**
494  * @title SafeERC20
495  * @dev Wrappers around ERC20 operations that throw on failure (when the token
496  * contract returns false). Tokens that return no value (and instead revert or
497  * throw on failure) are also supported, non-reverting calls are assumed to be
498  * successful.
499  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
500  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
501  */
502 library SafeERC20 {
503     using SafeMath for uint256;
504     using Address for address;
505 
506     function safeTransfer(IERC20 token, address to, uint256 value) internal {
507         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
508     }
509 
510     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
511         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
512     }
513 
514     function safeApprove(IERC20 token, address spender, uint256 value) internal {
515         // safeApprove should only be called when setting an initial allowance,
516         // or when resetting it to zero. To increase and decrease it, use
517         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
518         // solhint-disable-next-line max-line-length
519         require((value == 0) || (token.allowance(address(this), spender) == 0),
520             "SafeERC20: approve from non-zero to non-zero allowance"
521         );
522         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
523     }
524 
525     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
526         uint256 newAllowance = token.allowance(address(this), spender).add(value);
527         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
528     }
529 
530     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
532         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     /**
536      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
537      * on the return value: the return value is optional (but if data is returned, it must not be false).
538      * @param token The token targeted by the call.
539      * @param data The call data (encoded using abi.encode or one of its variants).
540      */
541     function callOptionalReturn(IERC20 token, bytes memory data) private {
542         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
543         // we're implementing it ourselves.
544 
545         // A Solidity high level call has three parts:
546         //  1. The target address is checked to verify it contains contract code
547         //  2. The call itself is made, and success asserted
548         //  3. The return value is decoded, which in turn checks the size of the returned data.
549         // solhint-disable-next-line max-line-length
550         require(address(token).isContract(), "SafeERC20: call to non-contract");
551 
552         // solhint-disable-next-line avoid-low-level-calls
553         (bool success, bytes memory returndata) = address(token).call(data);
554         require(success, "SafeERC20: low-level call failed");
555 
556         if (returndata.length > 0) { // Return data is optional
557             // solhint-disable-next-line max-line-length
558             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
559         }
560     }
561 }
562 
563 // File: contracts/IRewardDistributionRecipient.sol
564 
565 pragma solidity ^0.5.0;
566 
567 
568 
569 contract IRewardDistributionRecipient is Ownable {
570     address public rewardDistribution;
571 
572     function notifyRewardAmount(uint256 reward) external;
573 
574     modifier onlyRewardDistribution() {
575         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
576         _;
577     }
578 
579     function setRewardDistribution(address _rewardDistribution)
580         external
581         onlyOwner
582     {
583         rewardDistribution = _rewardDistribution;
584     }
585 }
586 
587 // File: contracts/iETHRewards.sol
588 
589 pragma solidity ^0.5.0;
590 
591 
592 
593 
594 
595 
596 contract LPTokenWrapper {
597     using SafeMath for uint256;
598     using SafeERC20 for IERC20;
599 
600     IERC20 public token = IERC20(0xA9859874e1743A32409f75bB11549892138BBA1E);
601 
602     uint256 private _totalSupply;
603     mapping(address => uint256) private _balances;
604 
605     function totalSupply() public view returns (uint256) {
606         return _totalSupply;
607     }
608 
609     function balanceOf(address account) public view returns (uint256) {
610         return _balances[account];
611     }
612 
613     function stake(uint256 amount) public {
614         _totalSupply = _totalSupply.add(amount);
615         _balances[msg.sender] = _balances[msg.sender].add(amount);
616         token.safeTransferFrom(msg.sender, address(this), amount);
617     }
618 
619     function withdraw(uint256 amount) public {
620         _totalSupply = _totalSupply.sub(amount);
621         _balances[msg.sender] = _balances[msg.sender].sub(amount);
622         token.safeTransfer(msg.sender, amount);
623     }
624 }
625 
626 contract iETHRewards is LPTokenWrapper, IRewardDistributionRecipient {
627     IERC20 public snx = IERC20(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
628     uint256 public constant DURATION = 7 days;
629 
630     uint256 public periodFinish = 0;
631     uint256 public rewardRate = 0;
632     uint256 public lastUpdateTime;
633     uint256 public rewardPerTokenStored;
634     mapping(address => uint256) public userRewardPerTokenPaid;
635     mapping(address => uint256) public rewards;
636 
637     event RewardAdded(uint256 reward);
638     event Staked(address indexed user, uint256 amount);
639     event Withdrawn(address indexed user, uint256 amount);
640     event RewardPaid(address indexed user, uint256 reward);
641 
642     modifier updateReward(address account) {
643         rewardPerTokenStored = rewardPerToken();
644         lastUpdateTime = lastTimeRewardApplicable();
645         if (account != address(0)) {
646             rewards[account] = earned(account);
647             userRewardPerTokenPaid[account] = rewardPerTokenStored;
648         }
649         _;
650     }
651 
652     function lastTimeRewardApplicable() public view returns (uint256) {
653         return Math.min(block.timestamp, periodFinish);
654     }
655 
656     function rewardPerToken() public view returns (uint256) {
657         if (totalSupply() == 0) {
658             return rewardPerTokenStored;
659         }
660         return
661             rewardPerTokenStored.add(
662                 lastTimeRewardApplicable()
663                     .sub(lastUpdateTime)
664                     .mul(rewardRate)
665                     .mul(1e18)
666                     .div(totalSupply())
667             );
668     }
669 
670     function earned(address account) public view returns (uint256) {
671         return
672             balanceOf(account)
673                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
674                 .div(1e18)
675                 .add(rewards[account]);
676     }
677 
678     // stake visibility is public as overriding LPTokenWrapper's stake() function
679     function stake(uint256 amount) public updateReward(msg.sender) {
680         require(amount > 0, "Cannot stake 0");
681         super.stake(amount);
682         emit Staked(msg.sender, amount);
683     }
684 
685     function withdraw(uint256 amount) public updateReward(msg.sender) {
686         require(amount > 0, "Cannot withdraw 0");
687         super.withdraw(amount);
688         emit Withdrawn(msg.sender, amount);
689     }
690 
691     function exit() external {
692         withdraw(balanceOf(msg.sender));
693         getReward();
694     }
695 
696     function getReward() public updateReward(msg.sender) {
697         uint256 reward = earned(msg.sender);
698         if (reward > 0) {
699             rewards[msg.sender] = 0;
700             snx.safeTransfer(msg.sender, reward);
701             emit RewardPaid(msg.sender, reward);
702         }
703     }
704 
705     function notifyRewardAmount(uint256 reward)
706         external
707         onlyRewardDistribution
708         updateReward(address(0))
709     {
710         if (block.timestamp >= periodFinish) {
711             rewardRate = reward.div(DURATION);
712         } else {
713             uint256 remaining = periodFinish.sub(block.timestamp);
714             uint256 leftover = remaining.mul(rewardRate);
715             rewardRate = reward.add(leftover).div(DURATION);
716         }
717         lastUpdateTime = block.timestamp;
718         periodFinish = block.timestamp.add(DURATION);
719         emit RewardAdded(reward);
720     }
721 }
