1 // File: contracts/SafeMath.sol
2 
3 pragma solidity 0.5.17;
4 
5 // Note: This file has been modified to include the sqrt function for quadratic voting
6 /**
7  * @dev Standard math utilities missing in the Solidity language.
8  */
9 library Math {
10     /**
11      * @dev Returns the largest of two numbers.
12      */
13     function max(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a >= b ? a : b;
15     }
16 
17     /**
18      * @dev Returns the smallest of two numbers.
19      */
20     function min(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a < b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the average of two numbers. The result is rounded towards
26      * zero.
27      */
28     function average(uint256 a, uint256 b) internal pure returns (uint256) {
29         // (a + b) / 2 can overflow, so we distribute
30         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
31     }
32 
33     /**
34     * Imported from: https://github.com/alianse777/solidity-standard-library/blob/master/Math.sol
35     * @dev Compute square root of x
36     * @return sqrt(x)
37     */
38    function sqrt(uint256 x) internal pure returns (uint256) {
39        uint256 n = x / 2;
40        uint256 lstX = 0;
41        while (n != lstX){
42            lstX = n;
43            n = (n + x/n) / 2; 
44        }
45        return uint256(n);
46    }
47 }
48 
49 /**
50  * @dev Wrappers over Solidity's arithmetic operations with added overflow
51  * checks.
52  *
53  * Arithmetic operations in Solidity wrap on overflow. This can easily result
54  * in bugs, because programmers usually assume that an overflow raises an
55  * error, which is the standard behavior in high level programming languages.
56  * `SafeMath` restores this intuition by reverting the transaction when an
57  * operation overflows.
58  *
59  * Using this library instead of the unchecked operations eliminates an entire
60  * class of bugs, so it's recommended to use it always.
61  */
62 library SafeMath {
63     /**
64      * @dev Returns the addition of two unsigned integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `+` operator.
68      *
69      * Requirements:
70      * - Addition cannot overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the subtraction of two unsigned integers, reverting on
81      * overflow (when the result is negative).
82      *
83      * Counterpart to Solidity's `-` operator.
84      *
85      * Requirements:
86      * - Subtraction cannot overflow.
87      */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         return sub(a, b, "SafeMath: subtraction overflow");
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      * - Subtraction cannot overflow.
100      *
101      * _Available since v2.4.0._
102      */
103     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b <= a, errorMessage);
105         uint256 c = a - b;
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      * - Multiplication cannot overflow.
118      */
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
121         // benefit is lost if 'b' is also tested.
122         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
123         if (a == 0) {
124             return 0;
125         }
126 
127         uint256 c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      * - The divisor cannot be zero.
143      */
144     function div(uint256 a, uint256 b) internal pure returns (uint256) {
145         return div(a, b, "SafeMath: division by zero");
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      *
159      * _Available since v2.4.0._
160      */
161     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         // Solidity only automatically asserts when dividing by 0
163         require(b > 0, errorMessage);
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
182         return mod(a, b, "SafeMath: modulo by zero");
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * Reverts with custom message when dividing by zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      * - The divisor cannot be zero.
195      *
196      * _Available since v2.4.0._
197      */
198     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b != 0, errorMessage);
200         return a % b;
201     }
202 }
203 
204 // File: contracts/zeppelin/Ownable.sol
205 
206 pragma solidity 0.5.17;
207 
208 
209 /*
210  * @dev Provides information about the current execution context, including the
211  * sender of the transaction and its data. While these are generally available
212  * via msg.sender and msg.data, they should not be accessed in such a direct
213  * manner, since when dealing with GSN meta-transactions the account sending and
214  * paying for execution may not be the actual sender (as far as an application
215  * is concerned).
216  *
217  * This contract is only required for intermediate, library-like contracts.
218  */
219 contract Context {
220     // Empty internal constructor, to prevent people from mistakenly deploying
221     // an instance of this contract, which should be used via inheritance.
222     constructor () internal { }
223     // solhint-disable-previous-line no-empty-blocks
224 
225     function _msgSender() internal view returns (address payable) {
226         return msg.sender;
227     }
228 
229     function _msgData() internal view returns (bytes memory) {
230         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
231         return msg.data;
232     }
233 }
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * This module is used through inheritance. It will make available the modifier
241  * `onlyOwner`, which can be applied to your functions to restrict their use to
242  * the owner.
243  */
244 contract Ownable is Context {
245     address private _owner;
246 
247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249     /**
250      * @dev Initializes the contract setting the deployer as the initial owner.
251      */
252     constructor () internal {
253         _owner = _msgSender();
254         emit OwnershipTransferred(address(0), _owner);
255     }
256 
257     /**
258      * @dev Returns the address of the current owner.
259      */
260     function owner() public view returns (address) {
261         return _owner;
262     }
263 
264     /**
265      * @dev Throws if called by any account other than the owner.
266      */
267     modifier onlyOwner() {
268         require(isOwner(), "Ownable: caller is not the owner");
269         _;
270     }
271 
272     /**
273      * @dev Returns true if the caller is the current owner.
274      */
275     function isOwner() public view returns (bool) {
276         return _msgSender() == _owner;
277     }
278 
279     /**
280      * @dev Leaves the contract without owner. It will not be possible to call
281      * `onlyOwner` functions anymore. Can only be called by the current owner.
282      *
283      * NOTE: Renouncing ownership will leave the contract without an owner,
284      * thereby removing any functionality that is only available to the owner.
285      */
286     function renounceOwnership() public onlyOwner {
287         emit OwnershipTransferred(_owner, address(0));
288         _owner = address(0);
289     }
290 
291     /**
292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
293      * Can only be called by the current owner.
294      */
295     function transferOwnership(address newOwner) public onlyOwner {
296         _transferOwnership(newOwner);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      */
302     function _transferOwnership(address newOwner) internal {
303         require(newOwner != address(0), "Ownable: new owner is the zero address");
304         emit OwnershipTransferred(_owner, newOwner);
305         _owner = newOwner;
306     }
307 }
308 
309 // File: contracts/zeppelin/Address.sol
310 
311 pragma solidity 0.5.17;
312 
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319      * @dev Returns true if `account` is a contract.
320      *
321      * This test is non-exhaustive, and there may be false-negatives: during the
322      * execution of a contract's constructor, its address will be reported as
323      * not containing a contract.
324      *
325      * IMPORTANT: It is unsafe to assume that an address for which this
326      * function returns false is an externally-owned account (EOA) and not a
327      * contract.
328      */
329     function isContract(address account) internal view returns (bool) {
330         // This method relies in extcodesize, which returns 0 for contracts in
331         // construction, since the code is only stored at the end of the
332         // constructor execution.
333 
334         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
335         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
336         // for accounts without code, i.e. `keccak256('')`
337         bytes32 codehash;
338         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
339         // solhint-disable-next-line no-inline-assembly
340         assembly { codehash := extcodehash(account) }
341         return (codehash != 0x0 && codehash != accountHash);
342     }
343 
344     /**
345      * @dev Converts an `address` into `address payable`. Note that this is
346      * simply a type cast: the actual underlying value is not changed.
347      *
348      * _Available since v2.4.0._
349      */
350     function toPayable(address account) internal pure returns (address payable) {
351         return address(uint160(account));
352     }
353 
354     /**
355      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
356      * `recipient`, forwarding all available gas and reverting on errors.
357      *
358      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
359      * of certain opcodes, possibly making contracts go over the 2300 gas limit
360      * imposed by `transfer`, making them unable to receive funds via
361      * `transfer`. {sendValue} removes this limitation.
362      *
363      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
364      *
365      * IMPORTANT: because control is transferred to `recipient`, care must be
366      * taken to not create reentrancy vulnerabilities. Consider using
367      * {ReentrancyGuard} or the
368      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
369      *
370      * _Available since v2.4.0._
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(address(this).balance >= amount, "Address: insufficient balance");
374 
375         // solhint-disable-next-line avoid-call-value
376         (bool success, ) = recipient.call.value(amount)("");
377         require(success, "Address: unable to send value, recipient may have reverted");
378     }
379 }
380 
381 // File: contracts/IERC20.sol
382 
383 //SPDX-License-Identifier: GPL-3.0-only
384 
385 pragma solidity 0.5.17;
386 
387 
388 /**
389  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
390  * the optional functions; to access them see {ERC20Detailed}.
391  */
392 interface IERC20 {
393     /**
394      * @dev Returns the amount of tokens in existence.
395      */
396     function totalSupply() external view returns (uint256);
397 
398     /**
399      * @dev Returns the amount of tokens owned by `account`.
400      */
401     function balanceOf(address account) external view returns (uint256);
402 
403     /**
404      * @dev Moves `amount` tokens from the caller's account to `recipient`.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transfer(address recipient, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Returns the remaining number of tokens that `spender` will be
414      * allowed to spend on behalf of `owner` through {transferFrom}. This is
415      * zero by default.
416      *
417      * This value changes when {approve} or {transferFrom} are called.
418      */
419     function allowance(address owner, address spender) external view returns (uint256);
420 
421     /**
422      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
423      *
424      * Returns a boolean value indicating whether the operation succeeded.
425      *
426      * IMPORTANT: Beware that changing an allowance with this method brings the risk
427      * that someone may use both the old and the new allowance by unfortunate
428      * transaction ordering. One possible solution to mitigate this race
429      * condition is to first reduce the spender's allowance to 0 and set the
430      * desired value afterwards:
431      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
432      *
433      * Emits an {Approval} event.
434      */
435     function approve(address spender, uint256 amount) external returns (bool);
436 
437     /**
438      * @dev Moves `amount` tokens from `sender` to `recipient` using the
439      * allowance mechanism. `amount` is then deducted from the caller's
440      * allowance.
441      *
442      * Returns a boolean value indicating whether the operation succeeded.
443      *
444      * Emits a {Transfer} event.
445      */
446     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
447 
448     /**
449      * @dev Emitted when `value` tokens are moved from one account (`from`) to
450      * another (`to`).
451      *
452      * Note that `value` may be zero.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 value);
455 
456     /**
457      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
458      * a call to {approve}. `value` is the new allowance.
459      */
460     event Approval(address indexed owner, address indexed spender, uint256 value);
461 }
462 
463 // File: contracts/zeppelin/SafeERC20.sol
464 
465 pragma solidity 0.5.17;
466 
467 
468 
469 
470 /**
471  * @title SafeERC20
472  * @dev Wrappers around ERC20 operations that throw on failure (when the token
473  * contract returns false). Tokens that return no value (and instead revert or
474  * throw on failure) are also supported, non-reverting calls are assumed to be
475  * successful.
476  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
477  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
478  */
479 library SafeERC20 {
480     using SafeMath for uint256;
481     using Address for address;
482 
483     function safeTransfer(IERC20 token, address to, uint256 value) internal {
484         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
485     }
486 
487     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
488         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
489     }
490 
491     function safeApprove(IERC20 token, address spender, uint256 value) internal {
492         // safeApprove should only be called when setting an initial allowance,
493         // or when resetting it to zero. To increase and decrease it, use
494         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
495         // solhint-disable-next-line max-line-length
496         require((value == 0) || (token.allowance(address(this), spender) == 0),
497             "SafeERC20: approve from non-zero to non-zero allowance"
498         );
499         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
500     }
501 
502     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
503         uint256 newAllowance = token.allowance(address(this), spender).add(value);
504         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
505     }
506 
507     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
508         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
509         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
510     }
511 
512     /**
513      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
514      * on the return value: the return value is optional (but if data is returned, it must not be false).
515      * @param token The token targeted by the call.
516      * @param data The call data (encoded using abi.encode or one of its variants).
517      */
518     function callOptionalReturn(IERC20 token, bytes memory data) private {
519         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
520         // we're implementing it ourselves.
521 
522         // A Solidity high level call has three parts:
523         //  1. The target address is checked to verify it contains contract code
524         //  2. The call itself is made, and success asserted
525         //  3. The return value is decoded, which in turn checks the size of the returned data.
526         // solhint-disable-next-line max-line-length
527         require(address(token).isContract(), "SafeERC20: call to non-contract");
528 
529         // solhint-disable-next-line avoid-low-level-calls
530         (bool success, bytes memory returndata) = address(token).call(data);
531         require(success, "SafeERC20: low-level call failed");
532 
533         if (returndata.length > 0) { // Return data is optional
534             // solhint-disable-next-line max-line-length
535             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
536         }
537     }
538 }
539 
540 // File: contracts/IERC20Burnable.sol
541 
542 //SPDX-License-Identifier: GPL-3.0-only
543 
544 pragma solidity 0.5.17;
545 
546 
547 interface IERC20Burnable {
548     function totalSupply() external view returns (uint256);
549     function balanceOf(address account) external view returns (uint256);
550     function transfer(address recipient, uint256 amount) external returns (bool);
551     function allowance(address owner, address spender) external view returns (uint256);
552     function approve(address spender, uint256 amount) external returns (bool);
553     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
554     function burn(uint256 amount) external;
555     event Transfer(address indexed from, address indexed to, uint256 value);
556     event Approval(address indexed owner, address indexed spender, uint256 value);
557 }
558 
559 // File: contracts/ITreasury.sol
560 
561 pragma solidity 0.5.17;
562 
563 
564 
565 interface ITreasury {
566     function defaultToken() external view returns (IERC20);
567     function deposit(IERC20 token, uint256 amount) external;
568     function withdraw(uint256 amount, address withdrawAddress) external;
569 }
570 
571 // File: contracts/ISwapRouter.sol
572 
573 //SPDX-License-Identifier: GPL-3.0-only
574 
575 pragma solidity 0.5.17;
576 
577 
578 interface SwapRouter {
579     function WETH() external pure returns (address);
580     function swapExactTokensForTokens(
581       uint amountIn,
582       uint amountOutMin,
583       address[] calldata path,
584       address to,
585       uint deadline
586     ) external returns (uint[] memory amounts);
587 }
588 
589 // File: contracts/LPTokenWrapper.sol
590 
591 //SPDX-License-Identifier: GPL-3.0-only
592 
593 
594 pragma solidity ^0.5.17;
595 
596 
597 
598 
599 contract LPTokenWrapper {
600     using SafeMath for uint256;
601     using SafeERC20 for IERC20;
602 
603     IERC20 public stakeToken;
604 
605     uint256 private _totalSupply;
606     mapping(address => uint256) private _balances;
607 
608     constructor(IERC20 _stakeToken) public {
609         stakeToken = _stakeToken;
610     }
611 
612     function totalSupply() public view returns (uint256) {
613         return _totalSupply;
614     }
615 
616     function balanceOf(address account) public view returns (uint256) {
617         return _balances[account];
618     }
619 
620     function stake(uint256 amount) public {
621         _totalSupply = _totalSupply.add(amount);
622         _balances[msg.sender] = _balances[msg.sender].add(amount);
623         // safeTransferFrom shifted to overriden method
624     }
625 
626     function withdraw(uint256 amount) public {
627         _totalSupply = _totalSupply.sub(amount);
628         _balances[msg.sender] = _balances[msg.sender].sub(amount);
629         // safeTransferFrom shifted to overriden method
630     }
631 }
632 
633 // File: contracts/BoostRewardsV2.sol
634 
635 //SPDX-License-Identifier: MIT
636 /*
637 * MIT License
638 * ===========
639 *
640 * Permission is hereby granted, free of charge, to any person obtaining a copy
641 * of this software and associated documentation files (the "Software"), to deal
642 * in the Software without restriction, including without limitation the rights
643 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
644 * copies of the Software, and to permit persons to whom the Software is
645 * furnished to do so, subject to the following conditions:
646 *
647 * The above copyright notice and this permission notice shall be included in all
648 * copies or substantial portions of the Software.
649 *
650 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
651 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
652 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
653 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
654 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
655 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
656 */
657 
658 pragma solidity 0.5.17;
659 
660 
661 
662 
663 
664 
665 
666 
667 
668 contract BoostRewardsV2 is LPTokenWrapper, Ownable {
669     IERC20 public boostToken;
670     ITreasury public treasury;
671     SwapRouter public swapRouter;
672     IERC20 public stablecoin;
673     
674     uint256 public tokenCapAmount;
675     uint256 public starttime;
676     uint256 public duration;
677     uint256 public periodFinish = 0;
678     uint256 public rewardRate = 0;
679     uint256 public lastUpdateTime;
680     uint256 public rewardPerTokenStored;
681     mapping(address => uint256) public userRewardPerTokenPaid;
682     mapping(address => uint256) public rewards;
683     
684     // booster variables
685     // variables to keep track of totalSupply and balances (after accounting for multiplier)
686     uint256 public boostedTotalSupply;
687     uint256 public lastBoostPurchase; // timestamp of lastBoostPurchase
688     mapping(address => uint256) public boostedBalances;
689     mapping(address => uint256) public numBoostersBought; // each booster = 5% increase in stake amt
690     mapping(address => uint256) public nextBoostPurchaseTime; // timestamp for which user is eligible to purchase another booster
691     uint256 public globalBoosterPrice = 1e18;
692     uint256 public boostThreshold = 10;
693     uint256 public boostScaleFactor = 20;
694     uint256 public scaleFactor = 320;
695 
696     event RewardAdded(uint256 reward);
697     event RewardPaid(address indexed user, uint256 reward);
698 
699     modifier checkStart() {
700         require(block.timestamp >= starttime,"not start");
701         _;
702     }
703 
704     modifier updateReward(address account) {
705         rewardPerTokenStored = rewardPerToken();
706         lastUpdateTime = lastTimeRewardApplicable();
707         if (account != address(0)) {
708             rewards[account] = earned(account);
709             userRewardPerTokenPaid[account] = rewardPerTokenStored;
710         }
711         _;
712     }
713 
714     constructor(
715         uint256 _tokenCapAmount,
716         IERC20 _stakeToken,
717         IERC20 _boostToken,
718         address _treasury,
719         SwapRouter _swapRouter,
720         uint256 _starttime,
721         uint256 _duration
722     ) public LPTokenWrapper(_stakeToken) {
723         tokenCapAmount = _tokenCapAmount;
724         boostToken = _boostToken;
725         treasury = ITreasury(_treasury);
726         stablecoin = treasury.defaultToken();
727         swapRouter = _swapRouter;
728         starttime = _starttime;
729         lastBoostPurchase = _starttime;
730         duration = _duration;
731         boostToken.safeApprove(address(_swapRouter), uint256(-1));
732         stablecoin.safeApprove(address(treasury), uint256(-1));
733     }
734     
735     function lastTimeRewardApplicable() public view returns (uint256) {
736         return Math.min(block.timestamp, periodFinish);
737     }
738 
739     function rewardPerToken() public view returns (uint256) {
740         if (boostedTotalSupply == 0) {
741             return rewardPerTokenStored;
742         }
743         return
744             rewardPerTokenStored.add(
745                 lastTimeRewardApplicable()
746                     .sub(lastUpdateTime)
747                     .mul(rewardRate)
748                     .mul(1e18)
749                     .div(boostedTotalSupply)
750             );
751     }
752 
753     function earned(address account) public view returns (uint256) {
754         return
755             boostedBalances[account]
756                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
757                 .div(1e18)
758                 .add(rewards[account]);
759     }
760 
761     function getBoosterPrice(address user)
762         public view returns (uint256 boosterPrice, uint256 newBoostBalance)
763     {
764         if (boostedTotalSupply == 0) return (0,0);
765 
766         // 5% increase for each previously user-purchased booster
767         uint256 boostersBought = numBoostersBought[user];
768         boosterPrice = globalBoosterPrice.mul(boostersBought.mul(5).add(100)).div(100);
769 
770         // increment boostersBought by 1
771         boostersBought = boostersBought.add(1);
772 
773         // if no. of boosters exceed threshold, increase booster price by boostScaleFactor;
774         if (boostersBought >= boostThreshold) {
775             boosterPrice = boosterPrice
776                 .mul((boostersBought.sub(boostThreshold)).mul(boostScaleFactor).add(100))
777                 .div(100);
778         }
779 
780         // 2.5% decrease for every 2 hour interval since last global boost purchase
781         boosterPrice = pow(boosterPrice, 975, 1000, (block.timestamp.sub(lastBoostPurchase)).div(2 hours));
782 
783         // adjust price based on expected increase in boost supply
784         // boostersBought has been incremented by 1 already
785         newBoostBalance = balanceOf(user)
786             .mul(boostersBought.mul(5).add(100))
787             .div(100);
788         uint256 boostBalanceIncrease = newBoostBalance.sub(boostedBalances[user]);
789         boosterPrice = boosterPrice
790             .mul(boostBalanceIncrease)
791             .mul(scaleFactor)
792             .div(boostedTotalSupply);
793     }
794 
795     // stake visibility is public as overriding LPTokenWrapper's stake() function
796     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
797         require(amount > 0, "Cannot stake 0");
798         super.stake(amount);
799 
800         // check user cap
801         require(
802             balanceOf(msg.sender) <= tokenCapAmount || block.timestamp >= starttime.add(86400),
803             "token cap exceeded"
804         );
805 
806         // boosters do not affect new amounts
807         boostedBalances[msg.sender] = boostedBalances[msg.sender].add(amount);
808         boostedTotalSupply = boostedTotalSupply.add(amount);
809 
810         _getReward(msg.sender);
811 
812         // transfer token last, to follow CEI pattern
813         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
814     }
815 
816     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
817         require(amount > 0, "Cannot withdraw 0");
818         super.withdraw(amount);
819         
820         // reset boosts :(
821         numBoostersBought[msg.sender] = 0;
822 
823         // update boosted balance and supply
824         updateBoostBalanceAndSupply(msg.sender, 0);
825 
826         // in case _getReward function fails, continue
827         (bool success, ) = address(this).call(
828             abi.encodeWithSignature(
829                 "_getReward(address)",
830                 msg.sender
831             )
832         );
833         // to remove compiler warning
834         success;
835 
836         // transfer token last, to follow CEI pattern
837         stakeToken.safeTransfer(msg.sender, amount);
838     }
839 
840     function getReward() public updateReward(msg.sender) checkStart {
841         _getReward(msg.sender);
842     }
843 
844     function exit() external {
845         withdraw(balanceOf(msg.sender));
846     }
847 
848     function setScaleFactorsAndThreshold(
849         uint256 _boostThreshold,
850         uint256 _boostScaleFactor,
851         uint256 _scaleFactor
852     ) external onlyOwner
853     {
854         boostThreshold = _boostThreshold;
855         boostScaleFactor = _boostScaleFactor;
856         scaleFactor = _scaleFactor;
857     }
858     
859     function boost() external updateReward(msg.sender) checkStart {
860         require(
861             block.timestamp > nextBoostPurchaseTime[msg.sender],
862             "early boost purchase"
863         );
864 
865         // save current booster price, since transfer is done last
866         // since getBoosterPrice() returns new boost balance, avoid re-calculation
867         (uint256 boosterAmount, uint256 newBoostBalance) = getBoosterPrice(msg.sender);
868         // user's balance and boostedSupply will be changed in this function
869         applyBoost(msg.sender, newBoostBalance);
870         
871         _getReward(msg.sender);
872 
873         boostToken.safeTransferFrom(msg.sender, address(this), boosterAmount);
874         
875         IERC20Burnable burnableBoostToken = IERC20Burnable(address(boostToken));
876 
877         // burn 25%
878         uint256 burnAmount = boosterAmount.div(4);
879         burnableBoostToken.burn(burnAmount);
880         boosterAmount = boosterAmount.sub(burnAmount);
881         
882         // swap to stablecoin
883         address[] memory routeDetails = new address[](3);
884         routeDetails[0] = address(boostToken);
885         routeDetails[1] = swapRouter.WETH();
886         routeDetails[2] = address(stablecoin);
887         uint[] memory amounts = swapRouter.swapExactTokensForTokens(
888             boosterAmount,
889             0,
890             routeDetails,
891             address(this),
892             block.timestamp + 100
893         );
894 
895         // transfer to treasury
896         // index 2 = final output amt
897         treasury.deposit(stablecoin, amounts[2]);
898     }
899 
900     function notifyRewardAmount(uint256 reward)
901         external
902         onlyOwner
903         updateReward(address(0))
904     {
905         rewardRate = reward.div(duration);
906         lastUpdateTime = starttime;
907         periodFinish = starttime.add(duration);
908         emit RewardAdded(reward);
909     }
910     
911     function updateBoostBalanceAndSupply(address user, uint256 newBoostBalance) internal {
912         // subtract existing balance from boostedSupply
913         boostedTotalSupply = boostedTotalSupply.sub(boostedBalances[user]);
914     
915         // when applying boosts,
916         // newBoostBalance has already been calculated in getBoosterPrice()
917         if (newBoostBalance == 0) {
918             // each booster adds 5% to current stake amount
919             newBoostBalance = balanceOf(user).mul(numBoostersBought[user].mul(5).add(100)).div(100);
920         }
921 
922         // update user's boosted balance
923         boostedBalances[user] = newBoostBalance;
924     
925         // update boostedSupply
926         boostedTotalSupply = boostedTotalSupply.add(newBoostBalance);
927     }
928 
929     function applyBoost(address user, uint256 newBoostBalance) internal {
930         // increase no. of boosters bought
931         numBoostersBought[user] = numBoostersBought[user].add(1);
932 
933         updateBoostBalanceAndSupply(user, newBoostBalance);
934         
935         // increase next purchase eligibility by an hour
936         nextBoostPurchaseTime[user] = block.timestamp.add(3600);
937 
938         // increase global booster price by 1%
939         globalBoosterPrice = globalBoosterPrice.mul(101).div(100);
940 
941         lastBoostPurchase = block.timestamp;
942     }
943 
944     function _getReward(address user) internal {
945         uint256 reward = earned(user);
946         if (reward > 0) {
947             rewards[user] = 0;
948             boostToken.safeTransfer(user, reward);
949             emit RewardPaid(user, reward);
950         }
951     }
952 
953    /// Imported from: https://forum.openzeppelin.com/t/does-safemath-library-need-a-safe-power-function/871/7
954    /// Modified so that it takes in 3 arguments for base
955    /// @return a * (b / c)^exponent 
956    function pow(uint256 a, uint256 b, uint256 c, uint256 exponent) internal pure returns (uint256) {
957         if (exponent == 0) {
958             return a;
959         }
960         else if (exponent == 1) {
961             return a.mul(b).div(c);
962         }
963         else if (a == 0 && exponent != 0) {
964             return 0;
965         }
966         else {
967             uint256 z = a.mul(b).div(c);
968             for (uint256 i = 1; i < exponent; i++)
969                 z = z.mul(b).div(c);
970             return z;
971         }
972     }
973 }