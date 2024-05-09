1 //   _    _ _   _                __ _                            
2 //  | |  (_) | | |              / _(_)                           
3 //  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ 
4 //  | |/ / | __| __/ _ \ '_ \  |  _| | '_ \ / _` | '_ \ / __/ _ \
5 //  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/
6 //  |_|\_\_|\__|\__\___|_| |_(_)_| |_|_| |_|\__,_|_| |_|\___\___|
7 /*
8    ____            __   __        __   _
9   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
10  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
11 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
12      /___/
13 
14 * Synthetix: YFIRewards.sol
15 *
16 * Docs: https://docs.synthetix.io/
17 *
18 *
19 * MIT License
20 * ===========
21 *
22 * Copyright (c) 2020 Synthetix
23 *
24 * Permission is hereby granted, free of charge, to any person obtaining a copy
25 * of this software and associated documentation files (the "Software"), to deal
26 * in the Software without restriction, including without limitation the rights
27 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
28 * copies of the Software, and to permit persons to whom the Software is
29 * furnished to do so, subject to the following conditions:
30 *
31 * The above copyright notice and this permission notice shall be included in all
32 * copies or substantial portions of the Software.
33 *
34 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
35 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
36 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
37 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
38 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
39 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
40 */
41 
42 // File: @openzeppelin/contracts/math/Math.sol
43 
44 pragma solidity ^0.5.0;
45 
46 /**
47  * @dev Standard math utilities missing in the Solidity language.
48  */
49 library Math {
50     /**
51      * @dev Returns the largest of two numbers.
52      */
53     function max(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a >= b ? a : b;
55     }
56 
57     /**
58      * @dev Returns the smallest of two numbers.
59      */
60     function min(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a < b ? a : b;
62     }
63 
64     /**
65      * @dev Returns the average of two numbers. The result is rounded towards
66      * zero.
67      */
68     function average(uint256 a, uint256 b) internal pure returns (uint256) {
69         // (a + b) / 2 can overflow, so we distribute
70         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/math/SafeMath.sol
75 
76 pragma solidity ^0.5.0;
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      *
130      * _Available since v2.4.0._
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      *
188      * _Available since v2.4.0._
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         // Solidity only automatically asserts when dividing by 0
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      *
225      * _Available since v2.4.0._
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 // File: @openzeppelin/contracts/GSN/Context.sol
234 
235 pragma solidity ^0.5.0;
236 
237 /*
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with GSN meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 contract Context {
248     // Empty internal constructor, to prevent people from mistakenly deploying
249     // an instance of this contract, which should be used via inheritance.
250     constructor () internal { }
251     // solhint-disable-previous-line no-empty-blocks
252 
253     function _msgSender() internal view returns (address payable) {
254         return msg.sender;
255     }
256 
257     function _msgData() internal view returns (bytes memory) {
258         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
259         return msg.data;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/ownership/Ownable.sol
264 
265 pragma solidity ^0.5.0;
266 
267 /**
268  * @dev Contract module which provides a basic access control mechanism, where
269  * there is an account (an owner) that can be granted exclusive access to
270  * specific functions.
271  *
272  * This module is used through inheritance. It will make available the modifier
273  * `onlyOwner`, which can be applied to your functions to restrict their use to
274  * the owner.
275  */
276 contract Ownable is Context {
277     address private _owner;
278 
279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
280 
281     /**
282      * @dev Initializes the contract setting the deployer as the initial owner.
283      */
284     constructor () internal {
285         _owner = _msgSender();
286         emit OwnershipTransferred(address(0), _owner);
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         require(isOwner(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     /**
305      * @dev Returns true if the caller is the current owner.
306      */
307     function isOwner() public view returns (bool) {
308         return _msgSender() == _owner;
309     }
310 
311     /**
312      * @dev Leaves the contract without owner. It will not be possible to call
313      * `onlyOwner` functions anymore. Can only be called by the current owner.
314      *
315      * NOTE: Renouncing ownership will leave the contract without an owner,
316      * thereby removing any functionality that is only available to the owner.
317      */
318     function renounceOwnership() public onlyOwner {
319         emit OwnershipTransferred(_owner, address(0));
320         _owner = address(0);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Can only be called by the current owner.
326      */
327     function transferOwnership(address newOwner) public onlyOwner {
328         _transferOwnership(newOwner);
329     }
330 
331     /**
332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
333      */
334     function _transferOwnership(address newOwner) internal {
335         require(newOwner != address(0), "Ownable: new owner is the zero address");
336         emit OwnershipTransferred(_owner, newOwner);
337         _owner = newOwner;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
342 
343 pragma solidity ^0.5.0;
344 
345 /**
346  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
347  * the optional functions; to access them see {ERC20Detailed}.
348  */
349 interface IERC20 {
350     /**
351      * @dev Returns the amount of tokens in existence.
352      */
353     function totalSupply() external view returns (uint256);
354 
355     /**
356      * @dev Returns the amount of tokens owned by `account`.
357      */
358     function balanceOf(address account) external view returns (uint256);
359 
360     /**
361      * @dev Moves `amount` tokens from the caller's account to `recipient`.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transfer(address recipient, uint256 amount) external returns (bool);
368     function mint(address account, uint amount) external;
369 
370     /**
371      * @dev Returns the remaining number of tokens that `spender` will be
372      * allowed to spend on behalf of `owner` through {transferFrom}. This is
373      * zero by default.
374      *
375      * This value changes when {approve} or {transferFrom} are called.
376      */
377     function allowance(address owner, address spender) external view returns (uint256);
378 
379     /**
380      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
381      *
382      * Returns a boolean value indicating whether the operation succeeded.
383      *
384      * IMPORTANT: Beware that changing an allowance with this method brings the risk
385      * that someone may use both the old and the new allowance by unfortunate
386      * transaction ordering. One possible solution to mitigate this race
387      * condition is to first reduce the spender's allowance to 0 and set the
388      * desired value afterwards:
389      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
390      *
391      * Emits an {Approval} event.
392      */
393     function approve(address spender, uint256 amount) external returns (bool);
394 
395     /**
396      * @dev Moves `amount` tokens from `sender` to `recipient` using the
397      * allowance mechanism. `amount` is then deducted from the caller's
398      * allowance.
399      *
400      * Returns a boolean value indicating whether the operation succeeded.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
405 
406     /**
407      * @dev Emitted when `value` tokens are moved from one account (`from`) to
408      * another (`to`).
409      *
410      * Note that `value` may be zero.
411      */
412     event Transfer(address indexed from, address indexed to, uint256 value);
413 
414     /**
415      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
416      * a call to {approve}. `value` is the new allowance.
417      */
418     event Approval(address indexed owner, address indexed spender, uint256 value);
419 }
420 
421 // File: @openzeppelin/contracts/utils/Address.sol
422 
423 pragma solidity ^0.5.5;
424 
425 /**
426  * @dev Collection of functions related to the address type
427  */
428 library Address {
429     /**
430      * @dev Returns true if `account` is a contract.
431      *
432      * This test is non-exhaustive, and there may be false-negatives: during the
433      * execution of a contract's constructor, its address will be reported as
434      * not containing a contract.
435      *
436      * IMPORTANT: It is unsafe to assume that an address for which this
437      * function returns false is an externally-owned account (EOA) and not a
438      * contract.
439      */
440     function isContract(address account) internal view returns (bool) {
441         // This method relies in extcodesize, which returns 0 for contracts in
442         // construction, since the code is only stored at the end of the
443         // constructor execution.
444 
445         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
446         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
447         // for accounts without code, i.e. `keccak256('')`
448         bytes32 codehash;
449         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
450         // solhint-disable-next-line no-inline-assembly
451         assembly { codehash := extcodehash(account) }
452         return (codehash != 0x0 && codehash != accountHash);
453     }
454 
455     /**
456      * @dev Converts an `address` into `address payable`. Note that this is
457      * simply a type cast: the actual underlying value is not changed.
458      *
459      * _Available since v2.4.0._
460      */
461     function toPayable(address account) internal pure returns (address payable) {
462         return address(uint160(account));
463     }
464 
465     /**
466      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
467      * `recipient`, forwarding all available gas and reverting on errors.
468      *
469      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
470      * of certain opcodes, possibly making contracts go over the 2300 gas limit
471      * imposed by `transfer`, making them unable to receive funds via
472      * `transfer`. {sendValue} removes this limitation.
473      *
474      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
475      *
476      * IMPORTANT: because control is transferred to `recipient`, care must be
477      * taken to not create reentrancy vulnerabilities. Consider using
478      * {ReentrancyGuard} or the
479      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
480      *
481      * _Available since v2.4.0._
482      */
483     function sendValue(address payable recipient, uint256 amount) internal {
484         require(address(this).balance >= amount, "Address: insufficient balance");
485 
486         // solhint-disable-next-line avoid-call-value
487         (bool success, ) = recipient.call.value(amount)("");
488         require(success, "Address: unable to send value, recipient may have reverted");
489     }
490 }
491 
492 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
493 
494 pragma solidity ^0.5.0;
495 
496 /**
497  * @title SafeERC20
498  * @dev Wrappers around ERC20 operations that throw on failure (when the token
499  * contract returns false). Tokens that return no value (and instead revert or
500  * throw on failure) are also supported, non-reverting calls are assumed to be
501  * successful.
502  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
503  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
504  */
505 library SafeERC20 {
506     using SafeMath for uint256;
507     using Address for address;
508 
509     function safeTransfer(IERC20 token, address to, uint256 value) internal {
510         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
511     }
512 
513     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
514         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
515     }
516 
517     function safeApprove(IERC20 token, address spender, uint256 value) internal {
518         // safeApprove should only be called when setting an initial allowance,
519         // or when resetting it to zero. To increase and decrease it, use
520         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
521         // solhint-disable-next-line max-line-length
522         require((value == 0) || (token.allowance(address(this), spender) == 0),
523             "SafeERC20: approve from non-zero to non-zero allowance"
524         );
525         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
526     }
527 
528     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
529         uint256 newAllowance = token.allowance(address(this), spender).add(value);
530         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
531     }
532 
533     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
535         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     /**
539      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
540      * on the return value: the return value is optional (but if data is returned, it must not be false).
541      * @param token The token targeted by the call.
542      * @param data The call data (encoded using abi.encode or one of its variants).
543      */
544     function callOptionalReturn(IERC20 token, bytes memory data) private {
545         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
546         // we're implementing it ourselves.
547 
548         // A Solidity high level call has three parts:
549         //  1. The target address is checked to verify it contains contract code
550         //  2. The call itself is made, and success asserted
551         //  3. The return value is decoded, which in turn checks the size of the returned data.
552         // solhint-disable-next-line max-line-length
553         require(address(token).isContract(), "SafeERC20: call to non-contract");
554 
555         // solhint-disable-next-line avoid-low-level-calls
556         (bool success, bytes memory returndata) = address(token).call(data);
557         require(success, "SafeERC20: low-level call failed");
558 
559         if (returndata.length > 0) { // Return data is optional
560             // solhint-disable-next-line max-line-length
561             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
562         }
563     }
564 }
565 
566 // File: contracts/CurveRewards.sol
567 
568 pragma solidity ^0.5.0;
569 
570 contract LPTokenWrapper {
571     using SafeMath for uint256;
572     using SafeERC20 for IERC20;
573     using Address for address;
574 
575     IERC20 public LP_TOKEN = IERC20(0x9f11faF42A16D986F7BFd6338F41dB880da6DF39); // Stake LP token
576 
577     uint256 private _totalSupply;
578     mapping(address => uint256) private _balances;
579 
580     function totalSupply() public view returns (uint256) {
581         return _totalSupply;
582     }
583 
584     function balanceOf(address account) public view returns (uint256) {
585         return _balances[account];
586     }
587 
588     function stake(uint256 amount) public {
589         address sender = msg.sender;
590         require(!address(sender).isContract(), "plz farm by hand");
591         require(tx.origin == sender, "plz farm by hand");
592         _totalSupply = _totalSupply.add(amount);
593         _balances[sender] = _balances[sender].add(amount);
594         LP_TOKEN.safeTransferFrom(sender, address(this), amount);
595     }
596 
597     function withdraw(uint256 amount) public {
598         _totalSupply = _totalSupply.sub(amount);
599         _balances[msg.sender] = _balances[msg.sender].sub(amount);
600         LP_TOKEN.safeTransfer(msg.sender, amount);
601     }
602 }
603 
604 contract KittenRewards is LPTokenWrapper, Ownable {
605     IERC20 public KIF_TOKEN = IERC20(0x177BA0cac51bFC7eA24BAd39d81dcEFd59d74fAa); // KittenFinance token
606     uint256 public constant DURATION = 7 days;
607 
608     uint256 public initreward = 12000 * 1e18;
609     uint256 public starttime = 1599069600; // GMT September 2, 2020 6:00:00 PM
610     uint256 public periodFinish = 0;
611     uint256 public rewardRate = 0;
612     uint256 public lastUpdateTime;
613     uint256 public rewardPerTokenStored;
614     mapping(address => uint256) public userRewardPerTokenPaid;
615     mapping(address => uint256) public rewards;
616 
617     event RewardAdded(uint256 reward);
618     event Staked(address indexed user, uint256 amount);
619     event Withdrawn(address indexed user, uint256 amount);
620     event RewardPaid(address indexed user, uint256 reward);
621 
622     address public devVestingAddr;
623     uint256 public devTotalAmt = 0;
624     uint256 public devWithdrawnAmt = 0;
625     uint256 public constant VESTING_PERIOD = 365 days;
626 
627     constructor (address _devVestingAddr) public {
628         devVestingAddr = _devVestingAddr;
629     }
630 
631     function transferDevAddr(address newAddr) public {
632         require(msg.sender == devVestingAddr, "dev only");
633         require(newAddr != address(0), "zero addr");
634         devVestingAddr = newAddr;
635     }
636     function renounceDevAddr() public {
637         require(msg.sender == devVestingAddr, "dev only");
638         devVestingAddr = address(0);
639     }
640 
641     modifier updateReward(address account) {
642         rewardPerTokenStored = rewardPerToken();
643         lastUpdateTime = lastTimeRewardApplicable();
644         if (account != address(0)) {
645             rewards[account] = earned(account);
646             userRewardPerTokenPaid[account] = rewardPerTokenStored;
647         }
648         _;
649     }
650 
651     function lastTimeRewardApplicable() public view returns (uint256) {
652         return Math.min(block.timestamp, periodFinish);
653     }
654 
655     function rewardPerToken() public view returns (uint256) {
656         if (totalSupply() == 0) {
657             return rewardPerTokenStored;
658         }
659         return
660             rewardPerTokenStored.add(
661                 lastTimeRewardApplicable()
662                     .sub(lastUpdateTime)
663                     .mul(rewardRate)
664                     .mul(1e18)
665                     .div(totalSupply())
666             );
667     }
668 
669     function earned(address account) public view returns (uint256) {
670         return
671             balanceOf(account)
672                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
673                 .div(1e18)
674                 .add(rewards[account]);
675     }
676 
677     // stake visibility is public as overriding LPTokenWrapper's stake() function
678     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart { 
679         require(amount > 0, "Cannot stake 0");
680         super.stake(amount);
681         emit Staked(msg.sender, amount);
682     }
683 
684     function withdraw(uint256 amount) public updateReward(msg.sender) {
685         require(amount > 0, "Cannot withdraw 0");
686         super.withdraw(amount);
687         emit Withdrawn(msg.sender, amount);
688     }
689 
690     function exit() external {
691         withdraw(balanceOf(msg.sender));
692         getReward();
693     }
694 
695     function getReward() public updateReward(msg.sender) checkhalve {
696         uint256 reward = earned(msg.sender);
697         if (reward > 0) {
698             rewards[msg.sender] = 0;
699             KIF_TOKEN.safeTransfer(msg.sender, reward);
700             emit RewardPaid(msg.sender, reward);
701         }
702     }
703 
704     modifier checkhalve(){
705         if (block.timestamp >= periodFinish) {
706             initreward = initreward.mul(50).div(100); 
707             KIF_TOKEN.mint(address(this),initreward);
708 
709             rewardRate = initreward.div(DURATION);
710             periodFinish = block.timestamp.add(DURATION);
711             emit RewardAdded(initreward);
712         }
713         _;
714     }
715     modifier checkStart(){
716         require(block.timestamp > starttime,"not start");
717         _;
718     }
719 
720     function notifyRewardAmount(uint256 reward) external
721         onlyOwner
722         updateReward(address(0))
723     {
724         if (block.timestamp >= periodFinish) {
725             rewardRate = reward.div(DURATION);
726         } else {
727             uint256 remaining = periodFinish.sub(block.timestamp);
728             uint256 leftover = remaining.mul(rewardRate);
729             rewardRate = reward.add(leftover).div(DURATION);
730         }
731         
732         uint256 devNewAmt = reward.div(20); // 5% dev fund (vested)        
733         KIF_TOKEN.mint(address(this), reward.add(devNewAmt));
734         devTotalAmt = devTotalAmt.add(devNewAmt);
735 
736         lastUpdateTime = block.timestamp;
737         periodFinish = block.timestamp.add(DURATION);
738         emit RewardAdded(reward);
739     }
740 
741     function devWithdrawFund(uint256 amt) external
742     {
743         require(msg.sender == devVestingAddr, "dev only");
744         
745         uint256 vestingTime = block.timestamp.sub(starttime);
746         vestingTime = Math.min(vestingTime, VESTING_PERIOD);
747         
748         uint256 devWithdrawnAmtMax = devTotalAmt.mul(vestingTime).div(VESTING_PERIOD); // vesting
749 
750         uint256 devWithdrawnAmtNew = devWithdrawnAmt.add(amt);
751 
752         require(devWithdrawnAmtNew <= devWithdrawnAmtMax, "vesting");
753 
754         devWithdrawnAmt = devWithdrawnAmtNew;
755 
756         KIF_TOKEN.safeTransfer(devVestingAddr, amt);
757     }
758 }