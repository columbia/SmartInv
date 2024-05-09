1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 *
9 * Docs: https://docs.synthetix.io/
10 *
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 Synthetix
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 */
34 
35 // File: @openzeppelin/contracts/math/Math.sol
36 
37 pragma solidity ^0.5.0;
38 
39 /**
40  * @dev Standard math utilities missing in the Solidity language.
41  */
42 library Math {
43     /**
44      * @dev Returns the largest of two numbers.
45      */
46     function max(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a >= b ? a : b;
48     }
49 
50     /**
51      * @dev Returns the smallest of two numbers.
52      */
53     function min(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a < b ? a : b;
55     }
56 
57     /**
58      * @dev Returns the average of two numbers. The result is rounded towards
59      * zero.
60      */
61     function average(uint256 a, uint256 b) internal pure returns (uint256) {
62         // (a + b) / 2 can overflow, so we distribute
63         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
64     }
65 }
66 
67 // File: @openzeppelin/contracts/math/SafeMath.sol
68 
69 pragma solidity ^0.5.0;
70 
71 /**
72  * @dev Wrappers over Solidity's arithmetic operations with added overflow
73  * checks.
74  *
75  * Arithmetic operations in Solidity wrap on overflow. This can easily result
76  * in bugs, because programmers usually assume that an overflow raises an
77  * error, which is the standard behavior in high level programming languages.
78  * `SafeMath` restores this intuition by reverting the transaction when an
79  * operation overflows.
80  *
81  * Using this library instead of the unchecked operations eliminates an entire
82  * class of bugs, so it's recommended to use it always.
83  */
84 library SafeMath {
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return sub(a, b, "SafeMath: subtraction overflow");
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      *
123      * _Available since v2.4.0._
124      */
125     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
126         require(b <= a, errorMessage);
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      * - Multiplication cannot overflow.
140      */
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
143         // benefit is lost if 'b' is also tested.
144         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
145         if (a == 0) {
146             return 0;
147         }
148 
149         uint256 c = a * b;
150         require(c / a == b, "SafeMath: multiplication overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers. Reverts on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's `/` operator. Note: this function uses a
160      * `revert` opcode (which leaves remaining gas untouched) while Solidity
161      * uses an invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         return div(a, b, "SafeMath: division by zero");
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      *
181      * _Available since v2.4.0._
182      */
183     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         // Solidity only automatically asserts when dividing by 0
185         require(b > 0, errorMessage);
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * Reverts when dividing by zero.
195      *
196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
197      * opcode (which leaves remaining gas untouched) while Solidity uses an
198      * invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      */
203     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
204         return mod(a, b, "SafeMath: modulo by zero");
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts with custom message when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      * - The divisor cannot be zero.
217      *
218      * _Available since v2.4.0._
219      */
220     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b != 0, errorMessage);
222         return a % b;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/GSN/Context.sol
227 
228 pragma solidity ^0.5.0;
229 
230 /*
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with GSN meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 contract Context {
241     // Empty internal constructor, to prevent people from mistakenly deploying
242     // an instance of this contract, which should be used via inheritance.
243     constructor () internal { }
244     // solhint-disable-previous-line no-empty-blocks
245 
246     function _msgSender() internal view returns (address payable) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view returns (bytes memory) {
251         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
252         return msg.data;
253     }
254 }
255 
256 // File: @openzeppelin/contracts/ownership/Ownable.sol
257 
258 pragma solidity ^0.5.0;
259 
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor () internal {
278         _owner = _msgSender();
279         emit OwnershipTransferred(address(0), _owner);
280     }
281 
282     /**
283      * @dev Returns the address of the current owner.
284      */
285     function owner() public view returns (address) {
286         return _owner;
287     }
288 
289     /**
290      * @dev Throws if called by any account other than the owner.
291      */
292     modifier onlyOwner() {
293         require(isOwner(), "Ownable: caller is not the owner");
294         _;
295     }
296 
297     /**
298      * @dev Returns true if the caller is the current owner.
299      */
300     function isOwner() public view returns (bool) {
301         return _msgSender() == _owner;
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public onlyOwner {
312         emit OwnershipTransferred(_owner, address(0));
313         _owner = address(0);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Can only be called by the current owner.
319      */
320     function transferOwnership(address newOwner) public onlyOwner {
321         _transferOwnership(newOwner);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      */
327     function _transferOwnership(address newOwner) internal {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
335 
336 pragma solidity ^0.5.0;
337 
338 /**
339  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
340  * the optional functions; to access them see {ERC20Detailed}.
341  */
342 interface IERC20 {
343     /**
344      * @dev Returns the amount of tokens in existence.
345      */
346     function totalSupply() external view returns (uint256);
347 
348     /**
349      * @dev Returns the amount of tokens owned by `account`.
350      */
351     function balanceOf(address account) external view returns (uint256);
352 
353     /**
354      * @dev Moves `amount` tokens from the caller's account to `recipient`.
355      *
356      * Returns a boolean value indicating whether the operation succeeded.
357      *
358      * Emits a {Transfer} event.
359      */
360     function transfer(address recipient, uint256 amount) external returns (bool);
361 
362     /**
363      * @dev Returns the remaining number of tokens that `spender` will be
364      * allowed to spend on behalf of `owner` through {transferFrom}. This is
365      * zero by default.
366      *
367      * This value changes when {approve} or {transferFrom} are called.
368      */
369     function allowance(address owner, address spender) external view returns (uint256);
370 
371     /**
372      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
373      *
374      * Returns a boolean value indicating whether the operation succeeded.
375      *
376      * IMPORTANT: Beware that changing an allowance with this method brings the risk
377      * that someone may use both the old and the new allowance by unfortunate
378      * transaction ordering. One possible solution to mitigate this race
379      * condition is to first reduce the spender's allowance to 0 and set the
380      * desired value afterwards:
381      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
382      *
383      * Emits an {Approval} event.
384      */
385     function approve(address spender, uint256 amount) external returns (bool);
386 
387     /**
388      * @dev Moves `amount` tokens from `sender` to `recipient` using the
389      * allowance mechanism. `amount` is then deducted from the caller's
390      * allowance.
391      *
392      * Returns a boolean value indicating whether the operation succeeded.
393      *
394      * Emits a {Transfer} event.
395      */
396     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
397 
398     /**
399      * @dev Emitted when `value` tokens are moved from one account (`from`) to
400      * another (`to`).
401      *
402      * Note that `value` may be zero.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 value);
405 
406     /**
407      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
408      * a call to {approve}. `value` is the new allowance.
409      */
410     event Approval(address indexed owner, address indexed spender, uint256 value);
411 }
412 
413 // File: @openzeppelin/contracts/utils/Address.sol
414 
415 pragma solidity ^0.5.5;
416 
417 /**
418  * @dev Collection of functions related to the address type
419  */
420 library Address {
421     /**
422      * @dev Returns true if `account` is a contract.
423      *
424      * This test is non-exhaustive, and there may be false-negatives: during the
425      * execution of a contract's constructor, its address will be reported as
426      * not containing a contract.
427      *
428      * IMPORTANT: It is unsafe to assume that an address for which this
429      * function returns false is an externally-owned account (EOA) and not a
430      * contract.
431      */
432     function isContract(address account) internal view returns (bool) {
433         // This method relies in extcodesize, which returns 0 for contracts in
434         // construction, since the code is only stored at the end of the
435         // constructor execution.
436 
437         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
438         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
439         // for accounts without code, i.e. `keccak256('')`
440         bytes32 codehash;
441         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
442         // solhint-disable-next-line no-inline-assembly
443         assembly { codehash := extcodehash(account) }
444         return (codehash != 0x0 && codehash != accountHash);
445     }
446 
447     /**
448      * @dev Converts an `address` into `address payable`. Note that this is
449      * simply a type cast: the actual underlying value is not changed.
450      *
451      * _Available since v2.4.0._
452      */
453     function toPayable(address account) internal pure returns (address payable) {
454         return address(uint160(account));
455     }
456 
457     /**
458      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
459      * `recipient`, forwarding all available gas and reverting on errors.
460      *
461      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
462      * of certain opcodes, possibly making contracts go over the 2300 gas limit
463      * imposed by `transfer`, making them unable to receive funds via
464      * `transfer`. {sendValue} removes this limitation.
465      *
466      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
467      *
468      * IMPORTANT: because control is transferred to `recipient`, care must be
469      * taken to not create reentrancy vulnerabilities. Consider using
470      * {ReentrancyGuard} or the
471      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
472      *
473      * _Available since v2.4.0._
474      */
475     function sendValue(address payable recipient, uint256 amount) internal {
476         require(address(this).balance >= amount, "Address: insufficient balance");
477 
478         // solhint-disable-next-line avoid-call-value
479         (bool success, ) = recipient.call.value(amount)("");
480         require(success, "Address: unable to send value, recipient may have reverted");
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
485 
486 pragma solidity ^0.5.0;
487 
488 
489 
490 
491 /**
492  * @title SafeERC20
493  * @dev Wrappers around ERC20 operations that throw on failure (when the token
494  * contract returns false). Tokens that return no value (and instead revert or
495  * throw on failure) are also supported, non-reverting calls are assumed to be
496  * successful.
497  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
498  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
499  */
500 library SafeERC20 {
501     using SafeMath for uint256;
502     using Address for address;
503 
504     function safeTransfer(IERC20 token, address to, uint256 value) internal {
505         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
506     }
507 
508     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
509         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
510     }
511 
512     function safeApprove(IERC20 token, address spender, uint256 value) internal {
513         // safeApprove should only be called when setting an initial allowance,
514         // or when resetting it to zero. To increase and decrease it, use
515         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
516         // solhint-disable-next-line max-line-length
517         require((value == 0) || (token.allowance(address(this), spender) == 0),
518             "SafeERC20: approve from non-zero to non-zero allowance"
519         );
520         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
521     }
522 
523     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
524         uint256 newAllowance = token.allowance(address(this), spender).add(value);
525         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
526     }
527 
528     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
529         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
530         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
531     }
532 
533     /**
534      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
535      * on the return value: the return value is optional (but if data is returned, it must not be false).
536      * @param token The token targeted by the call.
537      * @param data The call data (encoded using abi.encode or one of its variants).
538      */
539     function callOptionalReturn(IERC20 token, bytes memory data) private {
540         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
541         // we're implementing it ourselves.
542 
543         // A Solidity high level call has three parts:
544         //  1. The target address is checked to verify it contains contract code
545         //  2. The call itself is made, and success asserted
546         //  3. The return value is decoded, which in turn checks the size of the returned data.
547         // solhint-disable-next-line max-line-length
548         require(address(token).isContract(), "SafeERC20: call to non-contract");
549 
550         // solhint-disable-next-line avoid-low-level-calls
551         (bool success, bytes memory returndata) = address(token).call(data);
552         require(success, "SafeERC20: low-level call failed");
553 
554         if (returndata.length > 0) { // Return data is optional
555             // solhint-disable-next-line max-line-length
556             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
557         }
558     }
559 }
560 
561 // File: contracts/IRewardDistributionRecipient.sol
562 
563 pragma solidity ^0.5.0;
564 
565 
566 
567 contract IRewardDistributionRecipient is Ownable {
568     address rewardDistribution;
569 
570     function notifyRewardAmount(uint256 reward) external;
571 
572     modifier onlyRewardDistribution() {
573         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
574         _;
575     }
576 
577     function setRewardDistribution(address _rewardDistribution)
578         external
579         onlyOwner
580     {
581         rewardDistribution = _rewardDistribution;
582     }
583 }
584 
585 
586 pragma solidity ^0.5.0;
587 
588 
589 contract LPTokenWrapper {
590     using SafeMath for uint256;
591     using SafeERC20 for IERC20;
592 
593     IERC20 public lpToken;
594 
595     uint256 private _totalSupply;
596     mapping(address => uint256) private _balances;
597 
598     constructor(address _lpToken) internal {
599         lpToken = IERC20(_lpToken);
600     }
601 
602     function totalSupply() public view returns (uint256) {
603         return _totalSupply;
604     }
605 
606     function balanceOf(address account) public view returns (uint256) {
607         return _balances[account];
608     }
609 
610     function stake(uint256 amount) public {
611         _totalSupply = _totalSupply.add(amount);
612         _balances[msg.sender] = _balances[msg.sender].add(amount);
613         lpToken.safeTransferFrom(msg.sender, address(this), amount);
614     }
615 
616     function withdraw(uint256 amount) public {
617         _totalSupply = _totalSupply.sub(amount);
618         _balances[msg.sender] = _balances[msg.sender].sub(amount);
619         lpToken.safeTransfer(msg.sender, amount);
620     }
621 }
622 
623 contract StakingRewardsLock is LPTokenWrapper, IRewardDistributionRecipient {
624     IERC20 public cream = IERC20(0x2ba592F78dB6436527729929AAf6c908497cB200);
625     uint256 public constant DURATION = 7 days;
626 
627     /* Fees breaker, to protect withdraws if anything ever goes wrong */
628     bool public breaker = false;
629     mapping(address => uint) public stakeLock; // period that your sake it locked to keep it for staking
630     uint public lock = 17280; // stake lock in blocks ~ 17280 3 days for 15s/block
631     address public admin;
632 
633     uint256 public periodFinish = 0;
634     uint256 public rewardRate = 0;
635     uint256 public lastUpdateTime;
636     uint256 public rewardPerTokenStored;
637     mapping(address => uint256) public userRewardPerTokenPaid;
638     mapping(address => uint256) public rewards;
639 
640     event RewardAdded(uint256 reward);
641     event Staked(address indexed user, uint256 amount);
642     event Withdrawn(address indexed user, uint256 amount);
643     event RewardPaid(address indexed user, uint256 reward);
644 
645     constructor(address _lpToken) public LPTokenWrapper(_lpToken) {
646         admin = msg.sender;
647     }
648 
649     function setBreaker(bool _breaker) external {
650         require(msg.sender == admin, "admin only");
651         breaker = _breaker;
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
664     function seize(IERC20 _token, uint amount) external {
665         require(msg.sender == admin, "admin only");
666         require(_token != cream, "cream");
667         require(_token != lpToken, "bpt");
668         _token.safeTransfer(admin, amount);
669     }
670 
671     function lastTimeRewardApplicable() public view returns (uint256) {
672         return Math.min(block.timestamp, periodFinish);
673     }
674 
675     function rewardPerToken() public view returns (uint256) {
676         if (totalSupply() == 0) {
677             return rewardPerTokenStored;
678         }
679         return
680             rewardPerTokenStored.add(
681                 lastTimeRewardApplicable()
682                     .sub(lastUpdateTime)
683                     .mul(rewardRate)
684                     .mul(1e18)
685                     .div(totalSupply())
686             );
687     }
688 
689     function earned(address account) public view returns (uint256) {
690         return
691             balanceOf(account)
692                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
693                 .div(1e18)
694                 .add(rewards[account]);
695     }
696 
697     // stake visibility is public as overriding LPTokenWrapper's stake() function
698     function stake(uint256 amount) public updateReward(msg.sender) {
699         require(amount > 0, "Cannot stake 0");
700         super.stake(amount);
701         stakeLock[msg.sender] = lock.add(block.number);
702         emit Staked(msg.sender, amount);
703     }
704 
705     function withdraw(uint256 amount) public updateReward(msg.sender) {
706         require(amount > 0, "Cannot withdraw 0");
707         if (breaker == false) {
708             require(stakeLock[msg.sender] < block.number,"!locked");
709         }
710         super.withdraw(amount);
711         emit Withdrawn(msg.sender, amount);
712     }
713 
714     function exit() external {
715         withdraw(balanceOf(msg.sender));
716         getReward();
717     }
718 
719     function getReward() public updateReward(msg.sender) {
720         uint256 reward = earned(msg.sender);
721         if (reward > 0) {
722             rewards[msg.sender] = 0;
723             cream.safeTransfer(msg.sender, reward);
724             emit RewardPaid(msg.sender, reward);
725         }
726     }
727 
728     function notifyRewardAmount(uint256 reward)
729         external
730         onlyRewardDistribution
731         updateReward(address(0))
732     {
733         if (block.timestamp >= periodFinish) {
734             rewardRate = reward.div(DURATION);
735         } else {
736             uint256 remaining = periodFinish.sub(block.timestamp);
737             uint256 leftover = remaining.mul(rewardRate);
738             rewardRate = reward.add(leftover).div(DURATION);
739         }
740         lastUpdateTime = block.timestamp;
741         periodFinish = block.timestamp.add(DURATION);
742         emit RewardAdded(reward);
743     }
744 }