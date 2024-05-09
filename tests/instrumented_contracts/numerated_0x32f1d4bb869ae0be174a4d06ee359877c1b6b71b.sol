1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-17
3 */
4 
5 // File: contracts/SafeMath.sol
6 
7 pragma solidity 0.5.17;
8 
9 // Note: This file has been modified to include the sqrt function for quadratic voting
10 /**
11  * @dev Standard math utilities missing in the Solidity language.
12  */
13 library Math {
14     /**
15      * @dev Returns the largest of two numbers.
16      */
17     function max(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a >= b ? a : b;
19     }
20 
21     /**
22      * @dev Returns the smallest of two numbers.
23      */
24     function min(uint256 a, uint256 b) internal pure returns (uint256) {
25         return a < b ? a : b;
26     }
27 
28     /**
29      * @dev Returns the average of two numbers. The result is rounded towards
30      * zero.
31      */
32     function average(uint256 a, uint256 b) internal pure returns (uint256) {
33         // (a + b) / 2 can overflow, so we distribute
34         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
35     }
36 
37     /**
38     * Imported from: https://github.com/alianse777/solidity-standard-library/blob/master/Math.sol
39     * @dev Compute square root of x
40     * @return sqrt(x)
41     */
42    function sqrt(uint256 x) internal pure returns (uint256) {
43        uint256 n = x / 2;
44        uint256 lstX = 0;
45        while (n != lstX){
46            lstX = n;
47            n = (n + x/n) / 2;
48        }
49        return uint256(n);
50    }
51 }
52 
53 /**
54  * @dev Wrappers over Solidity's arithmetic operations with added overflow
55  * checks.
56  *
57  * Arithmetic operations in Solidity wrap on overflow. This can easily result
58  * in bugs, because programmers usually assume that an overflow raises an
59  * error, which is the standard behavior in high level programming languages.
60  * `SafeMath` restores this intuition by reverting the transaction when an
61  * operation overflows.
62  *
63  * Using this library instead of the unchecked operations eliminates an entire
64  * class of bugs, so it's recommended to use it always.
65  */
66 library SafeMath {
67     /**
68      * @dev Returns the addition of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `+` operator.
72      *
73      * Requirements:
74      * - Addition cannot overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79 
80         return c;
81     }
82 
83     /**
84      * @dev Returns the subtraction of two unsigned integers, reverting on
85      * overflow (when the result is negative).
86      *
87      * Counterpart to Solidity's `-` operator.
88      *
89      * Requirements:
90      * - Subtraction cannot overflow.
91      */
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      * - Subtraction cannot overflow.
104      *
105      * _Available since v2.4.0._
106      */
107     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b <= a, errorMessage);
109         uint256 c = a - b;
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125         // benefit is lost if 'b' is also tested.
126         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
127         if (a == 0) {
128             return 0;
129         }
130 
131         uint256 c = a * b;
132         require(c / a == b, "SafeMath: multiplication overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers. Reverts on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function div(uint256 a, uint256 b) internal pure returns (uint256) {
149         return div(a, b, "SafeMath: division by zero");
150     }
151 
152     /**
153      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
154      * division by zero. The result is rounded towards zero.
155      *
156      * Counterpart to Solidity's `/` operator. Note: this function uses a
157      * `revert` opcode (which leaves remaining gas untouched) while Solidity
158      * uses an invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      * - The divisor cannot be zero.
162      *
163      * _Available since v2.4.0._
164      */
165     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         // Solidity only automatically asserts when dividing by 0
167         require(b > 0, errorMessage);
168         uint256 c = a / b;
169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
176      * Reverts when dividing by zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      * - The divisor cannot be zero.
184      */
185     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186         return mod(a, b, "SafeMath: modulo by zero");
187     }
188 
189     /**
190      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
191      * Reverts with custom message when dividing by zero.
192      *
193      * Counterpart to Solidity's `%` operator. This function uses a `revert`
194      * opcode (which leaves remaining gas untouched) while Solidity uses an
195      * invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      * - The divisor cannot be zero.
199      *
200      * _Available since v2.4.0._
201      */
202     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b != 0, errorMessage);
204         return a % b;
205     }
206 }
207 
208 // File: contracts/zeppelin/Ownable.sol
209 
210 pragma solidity 0.5.17;
211 
212 
213 /*
214  * @dev Provides information about the current execution context, including the
215  * sender of the transaction and its data. While these are generally available
216  * via msg.sender and msg.data, they should not be accessed in such a direct
217  * manner, since when dealing with GSN meta-transactions the account sending and
218  * paying for execution may not be the actual sender (as far as an application
219  * is concerned).
220  *
221  * This contract is only required for intermediate, library-like contracts.
222  */
223 contract Context {
224     // Empty internal constructor, to prevent people from mistakenly deploying
225     // an instance of this contract, which should be used via inheritance.
226     constructor () internal { }
227     // solhint-disable-previous-line no-empty-blocks
228 
229     function _msgSender() internal view returns (address payable) {
230         return msg.sender;
231     }
232 
233     function _msgData() internal view returns (bytes memory) {
234         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
235         return msg.data;
236     }
237 }
238 
239 /**
240  * @dev Contract module which provides a basic access control mechanism, where
241  * there is an account (an owner) that can be granted exclusive access to
242  * specific functions.
243  *
244  * This module is used through inheritance. It will make available the modifier
245  * `onlyOwner`, which can be applied to your functions to restrict their use to
246  * the owner.
247  */
248 contract Ownable is Context {
249     address private _owner;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     /**
254      * @dev Initializes the contract setting the deployer as the initial owner.
255      */
256     constructor () internal {
257         _owner = _msgSender();
258         emit OwnershipTransferred(address(0), _owner);
259     }
260 
261     /**
262      * @dev Returns the address of the current owner.
263      */
264     function owner() public view returns (address) {
265         return _owner;
266     }
267 
268     /**
269      * @dev Throws if called by any account other than the owner.
270      */
271     modifier onlyOwner() {
272         require(isOwner(), "Ownable: caller is not the owner");
273         _;
274     }
275 
276     /**
277      * @dev Returns true if the caller is the current owner.
278      */
279     function isOwner() public view returns (bool) {
280         return _msgSender() == _owner;
281     }
282 
283     /**
284      * @dev Leaves the contract without owner. It will not be possible to call
285      * `onlyOwner` functions anymore. Can only be called by the current owner.
286      *
287      * NOTE: Renouncing ownership will leave the contract without an owner,
288      * thereby removing any functionality that is only available to the owner.
289      */
290     function renounceOwnership() public onlyOwner {
291         emit OwnershipTransferred(_owner, address(0));
292         _owner = address(0);
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Can only be called by the current owner.
298      */
299     function transferOwnership(address newOwner) public onlyOwner {
300         _transferOwnership(newOwner);
301     }
302 
303     /**
304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
305      */
306     function _transferOwnership(address newOwner) internal {
307         require(newOwner != address(0), "Ownable: new owner is the zero address");
308         emit OwnershipTransferred(_owner, newOwner);
309         _owner = newOwner;
310     }
311 }
312 
313 // File: contracts/zeppelin/Address.sol
314 
315 pragma solidity 0.5.17;
316 
317 
318 /**
319  * @dev Collection of functions related to the address type
320  */
321 library Address {
322     /**
323      * @dev Returns true if `account` is a contract.
324      *
325      * This test is non-exhaustive, and there may be false-negatives: during the
326      * execution of a contract's constructor, its address will be reported as
327      * not containing a contract.
328      *
329      * IMPORTANT: It is unsafe to assume that an address for which this
330      * function returns false is an externally-owned account (EOA) and not a
331      * contract.
332      */
333     function isContract(address account) internal view returns (bool) {
334         // This method relies in extcodesize, which returns 0 for contracts in
335         // construction, since the code is only stored at the end of the
336         // constructor execution.
337 
338         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
339         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
340         // for accounts without code, i.e. `keccak256('')`
341         bytes32 codehash;
342         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
343         // solhint-disable-next-line no-inline-assembly
344         assembly { codehash := extcodehash(account) }
345         return (codehash != 0x0 && codehash != accountHash);
346     }
347 
348     /**
349      * @dev Converts an `address` into `address payable`. Note that this is
350      * simply a type cast: the actual underlying value is not changed.
351      *
352      * _Available since v2.4.0._
353      */
354     function toPayable(address account) internal pure returns (address payable) {
355         return address(uint160(account));
356     }
357 
358     /**
359      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
360      * `recipient`, forwarding all available gas and reverting on errors.
361      *
362      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
363      * of certain opcodes, possibly making contracts go over the 2300 gas limit
364      * imposed by `transfer`, making them unable to receive funds via
365      * `transfer`. {sendValue} removes this limitation.
366      *
367      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
368      *
369      * IMPORTANT: because control is transferred to `recipient`, care must be
370      * taken to not create reentrancy vulnerabilities. Consider using
371      * {ReentrancyGuard} or the
372      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
373      *
374      * _Available since v2.4.0._
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(address(this).balance >= amount, "Address: insufficient balance");
378 
379         // solhint-disable-next-line avoid-call-value
380         (bool success, ) = recipient.call.value(amount)("");
381         require(success, "Address: unable to send value, recipient may have reverted");
382     }
383 }
384 
385 // File: contracts/IERC20.sol
386 
387 //SPDX-License-Identifier: GPL-3.0-only
388 
389 pragma solidity 0.5.17;
390 
391 
392 /**
393  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
394  * the optional functions; to access them see {ERC20Detailed}.
395  */
396 interface IERC20 {
397     /**
398      * @dev Returns the amount of tokens in existence.
399      */
400     function totalSupply() external view returns (uint256);
401 
402     /**
403      * @dev Returns the amount of tokens owned by `account`.
404      */
405     function balanceOf(address account) external view returns (uint256);
406 
407     /**
408      * @dev Moves `amount` tokens from the caller's account to `recipient`.
409      *
410      * Returns a boolean value indicating whether the operation succeeded.
411      *
412      * Emits a {Transfer} event.
413      */
414     function transfer(address recipient, uint256 amount) external returns (bool);
415 
416     /**
417      * @dev Returns the remaining number of tokens that `spender` will be
418      * allowed to spend on behalf of `owner` through {transferFrom}. This is
419      * zero by default.
420      *
421      * This value changes when {approve} or {transferFrom} are called.
422      */
423     function allowance(address owner, address spender) external view returns (uint256);
424 
425     /**
426      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * IMPORTANT: Beware that changing an allowance with this method brings the risk
431      * that someone may use both the old and the new allowance by unfortunate
432      * transaction ordering. One possible solution to mitigate this race
433      * condition is to first reduce the spender's allowance to 0 and set the
434      * desired value afterwards:
435      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
436      *
437      * Emits an {Approval} event.
438      */
439     function approve(address spender, uint256 amount) external returns (bool);
440 
441     /**
442      * @dev Moves `amount` tokens from `sender` to `recipient` using the
443      * allowance mechanism. `amount` is then deducted from the caller's
444      * allowance.
445      *
446      * Returns a boolean value indicating whether the operation succeeded.
447      *
448      * Emits a {Transfer} event.
449      */
450     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
451 
452     /**
453      * @dev Emitted when `value` tokens are moved from one account (`from`) to
454      * another (`to`).
455      *
456      * Note that `value` may be zero.
457      */
458     event Transfer(address indexed from, address indexed to, uint256 value);
459 
460     /**
461      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
462      * a call to {approve}. `value` is the new allowance.
463      */
464     event Approval(address indexed owner, address indexed spender, uint256 value);
465 }
466 
467 // File: contracts/zeppelin/SafeERC20.sol
468 
469 pragma solidity 0.5.17;
470 
471 
472 
473 
474 /**
475  * @title SafeERC20
476  * @dev Wrappers around ERC20 operations that throw on failure (when the token
477  * contract returns false). Tokens that return no value (and instead revert or
478  * throw on failure) are also supported, non-reverting calls are assumed to be
479  * successful.
480  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
481  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
482  */
483 library SafeERC20 {
484     using SafeMath for uint256;
485     using Address for address;
486 
487     function safeTransfer(IERC20 token, address to, uint256 value) internal {
488         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
489     }
490 
491     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
492         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
493     }
494 
495     function safeApprove(IERC20 token, address spender, uint256 value) internal {
496         // safeApprove should only be called when setting an initial allowance,
497         // or when resetting it to zero. To increase and decrease it, use
498         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
499         // solhint-disable-next-line max-line-length
500         require((value == 0) || (token.allowance(address(this), spender) == 0),
501             "SafeERC20: approve from non-zero to non-zero allowance"
502         );
503         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
504     }
505 
506     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
507         uint256 newAllowance = token.allowance(address(this), spender).add(value);
508         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
509     }
510 
511     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
512         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
513         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
514     }
515 
516     /**
517      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
518      * on the return value: the return value is optional (but if data is returned, it must not be false).
519      * @param token The token targeted by the call.
520      * @param data The call data (encoded using abi.encode or one of its variants).
521      */
522     function callOptionalReturn(IERC20 token, bytes memory data) private {
523         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
524         // we're implementing it ourselves.
525 
526         // A Solidity high level call has three parts:
527         //  1. The target address is checked to verify it contains contract code
528         //  2. The call itself is made, and success asserted
529         //  3. The return value is decoded, which in turn checks the size of the returned data.
530         // solhint-disable-next-line max-line-length
531         require(address(token).isContract(), "SafeERC20: call to non-contract");
532 
533         // solhint-disable-next-line avoid-low-level-calls
534         (bool success, bytes memory returndata) = address(token).call(data);
535         require(success, "SafeERC20: low-level call failed");
536 
537         if (returndata.length > 0) { // Return data is optional
538             // solhint-disable-next-line max-line-length
539             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
540         }
541     }
542 }
543 
544 // File: contracts/IERC20Burnable.sol
545 
546 //SPDX-License-Identifier: GPL-3.0-only
547 
548 pragma solidity 0.5.17;
549 
550 
551 interface IERC20Burnable {
552     function totalSupply() external view returns (uint256);
553     function balanceOf(address account) external view returns (uint256);
554     function transfer(address recipient, uint256 amount) external returns (bool);
555     function allowance(address owner, address spender) external view returns (uint256);
556     function approve(address spender, uint256 amount) external returns (bool);
557     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
558     function burn(uint256 amount) external;
559     event Transfer(address indexed from, address indexed to, uint256 value);
560     event Approval(address indexed owner, address indexed spender, uint256 value);
561 }
562 
563 pragma solidity 0.5.17;
564 
565 
566 
567 interface IGovernance {
568     function getStablecoin() external view returns (address);
569 }
570 
571 
572 // File: contracts/ISwapRouter.sol
573 
574 //SPDX-License-Identifier: GPL-3.0-only
575 
576 pragma solidity 0.5.17;
577 
578 
579 interface SwapRouter {
580     function WETH() external pure returns (address);
581     function swapExactTokensForTokens(
582       uint amountIn,
583       uint amountOutMin,
584       address[] calldata path,
585       address to,
586       uint deadline
587     ) external returns (uint[] memory amounts);
588 }
589 
590 // File: contracts/LPTokenWrapper.sol
591 
592 //SPDX-License-Identifier: GPL-3.0-only
593 
594 
595 pragma solidity ^0.5.17;
596 
597 
598 
599 
600 contract LPTokenWrapper {
601     using SafeMath for uint256;
602     using SafeERC20 for IERC20;
603 
604     IERC20 public stakeToken;
605 
606     uint256 private _totalSupply;
607     mapping(address => uint256) private _balances;
608 
609     constructor(IERC20 _stakeToken) public {
610         stakeToken = _stakeToken;
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
624         // safeTransferFrom shifted to overriden method
625     }
626 
627     function withdraw(uint256 amount) public {
628         _totalSupply = _totalSupply.sub(amount);
629         _balances[msg.sender] = _balances[msg.sender].sub(amount);
630         // safeTransferFrom shifted to overriden method
631     }
632 }
633 
634 // File: contracts/BoostRewardsV2.sol
635 
636 //SPDX-License-Identifier: MIT
637 /*
638 * MIT License
639 * ===========
640 *
641 * Permission is hereby granted, free of charge, to any person obtaining a copy
642 * of this software and associated documentation files (the "Software"), to deal
643 * in the Software without restriction, including without limitation the rights
644 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
645 * copies of the Software, and to permit persons to whom the Software is
646 * furnished to do so, subject to the following conditions:
647 *
648 * The above copyright notice and this permission notice shall be included in all
649 * copies or substantial portions of the Software.
650 *
651 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
652 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
653 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
654 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
655 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
656 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
657 */
658 
659 pragma solidity 0.5.17;
660 
661 
662 
663 
664 
665 
666 
667 
668 
669 contract BoostRewardsV2OPES is LPTokenWrapper, Ownable {
670     IERC20 public boostToken;
671     address public governance;
672     address public governanceSetter;
673     address public partnerHold;
674     SwapRouter public swapRouter;
675     address public stablecoin;
676     address public rewardToken;
677     uint256 public tokenCapAmount;
678     uint256 public starttime;
679     uint256 public DURATION = 7 days;
680     uint256 public periodFinish = 0;
681     uint256 public rewardRate = 0;
682     uint256 public lastUpdateTime;
683     uint256 public rewardPerTokenStored;
684     mapping(address => uint256) public userRewardPerTokenPaid;
685     mapping(address => uint256) public rewards;
686 
687     // booster variables
688     // variables to keep track of totalSupply and balances (after accounting for multiplier)
689     uint256 public boostedTotalSupply;
690     uint256 public lastBoostPurchase; // timestamp of lastBoostPurchase
691     mapping(address => uint256) public boostedBalances;
692     mapping(address => uint256) public numBoostersBought; // each booster = 5% increase in stake amt
693     mapping(address => uint256) public nextBoostPurchaseTime; // timestamp for which user is eligible to purchase another booster
694     uint256 public globalBoosterPrice = 1e18;
695     uint256 public boostThreshold = 10;
696     uint256 public boostScaleFactor = 20;
697     uint256 public scaleFactor = 320;
698 
699     event RewardAdded(uint256 reward);
700     event RewardPaid(address indexed user, uint256 reward);
701 
702     modifier checkStart() {
703         require(block.timestamp >= starttime,"not start");
704         _;
705     }
706 
707     modifier updateReward(address account) {
708         rewardPerTokenStored = rewardPerToken();
709         lastUpdateTime = lastTimeRewardApplicable();
710         if (account != address(0)) {
711             rewards[account] = earned(account);
712             userRewardPerTokenPaid[account] = rewardPerTokenStored;
713         }
714         _;
715     }
716 
717     constructor(
718         uint256 _tokenCapAmount,
719         IERC20 _stakeToken,
720         IERC20 _boostToken,
721         address _governanceSetter,
722         SwapRouter _swapRouter,
723         address _partnerHold,
724         address _rewardToken,
725         uint256 _starttime
726     ) public LPTokenWrapper(_stakeToken) {
727         tokenCapAmount = _tokenCapAmount;
728         boostToken = _boostToken;
729         governanceSetter = _governanceSetter;
730         swapRouter = _swapRouter;
731         partnerHold = _partnerHold;
732         rewardToken = _rewardToken;
733         starttime = _starttime;
734         lastBoostPurchase = _starttime;
735         boostToken.safeApprove(address(_swapRouter), uint256(-1));
736     }
737 
738     function lastTimeRewardApplicable() public view returns (uint256) {
739         return Math.min(block.timestamp, periodFinish);
740     }
741 
742     function rewardPerToken() public view returns (uint256) {
743         if (boostedTotalSupply == 0) {
744             return rewardPerTokenStored;
745         }
746         return
747             rewardPerTokenStored.add(
748                 lastTimeRewardApplicable()
749                     .sub(lastUpdateTime)
750                     .mul(rewardRate)
751                     .mul(1e18)
752                     .div(boostedTotalSupply)
753             );
754     }
755 
756     function earned(address account) public view returns (uint256) {
757         return
758             boostedBalances[account]
759                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
760                 .div(1e18)
761                 .add(rewards[account]);
762     }
763 
764     function getBoosterPrice(address user)
765         public view returns (uint256 boosterPrice, uint256 newBoostBalance)
766     {
767         if (boostedTotalSupply == 0) return (0,0);
768 
769         // 5% increase for each previously user-purchased booster
770         uint256 boostersBought = numBoostersBought[user];
771         boosterPrice = globalBoosterPrice.mul(boostersBought.mul(5).add(100)).div(100);
772 
773         // increment boostersBought by 1
774         boostersBought = boostersBought.add(1);
775 
776         // if no. of boosters exceed threshold, increase booster price by boostScaleFactor;
777         if (boostersBought >= boostThreshold) {
778             boosterPrice = boosterPrice
779                 .mul((boostersBought.sub(boostThreshold)).mul(boostScaleFactor).add(100))
780                 .div(100);
781         }
782 
783         // 2.5% decrease for every 2 hour interval since last global boost purchase
784         boosterPrice = pow(boosterPrice, 975, 1000, (block.timestamp.sub(lastBoostPurchase)).div(2 hours));
785 
786         // adjust price based on expected increase in boost supply
787         // boostersBought has been incremented by 1 already
788         newBoostBalance = balanceOf(user)
789             .mul(boostersBought.mul(5).add(100))
790             .div(100);
791         uint256 boostBalanceIncrease = newBoostBalance.sub(boostedBalances[user]);
792         boosterPrice = boosterPrice
793             .mul(boostBalanceIncrease)
794             .mul(scaleFactor)
795             .div(boostedTotalSupply);
796     }
797 
798     // stake visibility is public as overriding LPTokenWrapper's stake() function
799     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
800         require(amount > 0, "Cannot stake 0");
801         super.stake(amount);
802 
803         // check user cap
804         // require(
805         //     balanceOf(msg.sender) <= tokenCapAmount || block.timestamp >= starttime.add(86400),
806         //     "token cap exceeded"
807         // );
808 
809         // boosters do not affect new amounts
810         boostedBalances[msg.sender] = boostedBalances[msg.sender].add(amount);
811         boostedTotalSupply = boostedTotalSupply.add(amount);
812 
813         _getReward(msg.sender);
814 
815         // transfer token last, to follow CEI pattern
816         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
817     }
818 
819     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
820         require(amount > 0, "Cannot withdraw 0");
821         super.withdraw(amount);
822 
823         // reset boosts :(
824         numBoostersBought[msg.sender] = 0;
825 
826         // update boosted balance and supply
827         updateBoostBalanceAndSupply(msg.sender, 0);
828 
829         // in case _getReward function fails, continue
830         (bool success, ) = address(this).call(
831             abi.encodeWithSignature(
832                 "_getReward(address)",
833                 msg.sender
834             )
835         );
836         // to remove compiler warning
837         success;
838 
839         // transfer token last, to follow CEI pattern
840         stakeToken.safeTransfer(msg.sender, amount);
841     }
842 
843     function getReward() public updateReward(msg.sender) checkStart {
844         _getReward(msg.sender);
845     }
846 
847     function exit() external {
848         withdraw(balanceOf(msg.sender));
849         _getReward(msg.sender);
850     }
851 
852     function setScaleFactorsAndThreshold(
853         uint256 _boostThreshold,
854         uint256 _boostScaleFactor,
855         uint256 _scaleFactor
856     ) external onlyOwner
857     {
858         boostThreshold = _boostThreshold;
859         boostScaleFactor = _boostScaleFactor;
860         scaleFactor = _scaleFactor;
861     }
862 
863     function boost() external updateReward(msg.sender) checkStart {
864         require(
865             block.timestamp > nextBoostPurchaseTime[msg.sender],
866             "early boost purchase"
867         );
868 
869         // save current booster price, since transfer is done last
870         // since getBoosterPrice() returns new boost balance, avoid re-calculation
871         (uint256 boosterAmount, uint256 newBoostBalance) = getBoosterPrice(msg.sender);
872         // user's balance and boostedSupply will be changed in this function
873         applyBoost(msg.sender, newBoostBalance);
874 
875         _getReward(msg.sender);
876 
877         boostToken.safeTransferFrom(msg.sender, address(this), boosterAmount);
878 
879         // Converting 100% to WPE
880         //50% OPES nodes 50% WPE Governance fund
881 
882         uint256 govAmount = boosterAmount.div(2);
883 
884         boosterAmount = boosterAmount.sub(govAmount);
885 
886         address[] memory routeDetails = new address[](3);
887         routeDetails[0] = address(boostToken);
888         routeDetails[1] = swapRouter.WETH();
889         routeDetails[2] = address(rewardToken);
890         uint[] memory amounts = swapRouter.swapExactTokensForTokens(
891             boosterAmount,
892             0,
893             routeDetails,
894             partnerHold,
895             block.timestamp + 100
896         );
897 
898         address[] memory routeDetails2 = new address[](3);
899         routeDetails2[0] = address(boostToken);
900         routeDetails2[1] = swapRouter.WETH();
901         routeDetails2[2] = address(rewardToken);
902         uint[] memory amounts2 = swapRouter.swapExactTokensForTokens(
903             govAmount,
904             0,
905             routeDetails2,
906             governance,
907             block.timestamp + 100
908         );
909 
910         // transfer to treasury
911         // index 2 = final output amt
912         //treasury.deposit(stablecoin, amounts[2]);
913     }
914 
915     // function notifyRewardAmount(uint256 reward)
916     //     external
917     //     onlyOwner
918     //     updateReward(address(0))
919     // {
920     //     rewardRate = reward.div(duration);
921     //     lastUpdateTime = starttime;
922     //     periodFinish = starttime.add(duration);
923     //     emit RewardAdded(reward);
924     // }
925 
926     function notifyRewardAmount(uint256 reward)
927         external
928         onlyOwner
929         updateReward(address(0))
930     {
931         if (periodFinish > 0){
932             require(block.timestamp >= (periodFinish-3600), "New Reward too early");
933         }
934         if (block.timestamp >= periodFinish) {
935             rewardRate = reward.div(DURATION);
936         } else {
937             uint256 remaining = periodFinish.sub(block.timestamp);
938             uint256 leftover = remaining.mul(rewardRate);
939             rewardRate = reward.add(leftover).div(DURATION);
940         }
941         //yfi.mint(address(this),reward);
942         lastUpdateTime = block.timestamp;
943         periodFinish = block.timestamp.add(DURATION);
944         emit RewardAdded(reward);
945     }
946 
947     function setGovernance(address _governance)
948         external
949     {
950         require(msg.sender == governanceSetter, "only setter");
951         governance = _governance;
952         stablecoin = IGovernance(governance).getStablecoin();
953         governanceSetter = address(0);
954     }
955 
956     function updateBoostBalanceAndSupply(address user, uint256 newBoostBalance) internal {
957         // subtract existing balance from boostedSupply
958         boostedTotalSupply = boostedTotalSupply.sub(boostedBalances[user]);
959 
960         // when applying boosts,
961         // newBoostBalance has already been calculated in getBoosterPrice()
962         if (newBoostBalance == 0) {
963             // each booster adds 5% to current stake amount
964             newBoostBalance = balanceOf(user).mul(numBoostersBought[user].mul(5).add(100)).div(100);
965         }
966 
967         // update user's boosted balance
968         boostedBalances[user] = newBoostBalance;
969 
970         // update boostedSupply
971         boostedTotalSupply = boostedTotalSupply.add(newBoostBalance);
972     }
973 
974     function applyBoost(address user, uint256 newBoostBalance) internal {
975         // increase no. of boosters bought
976         numBoostersBought[user] = numBoostersBought[user].add(1);
977 
978         updateBoostBalanceAndSupply(user, newBoostBalance);
979 
980         // increase next purchase eligibility by an hour
981 
982         // increase next boost wait period by 5%
983         nextBoostPurchaseTime[user] = block.timestamp.add(3600);
984 
985         // increase global booster price by 1%
986         globalBoosterPrice = globalBoosterPrice.mul(101).div(100);
987 
988         lastBoostPurchase = block.timestamp;
989     }
990 
991     function _getReward(address user) internal {
992         uint256 reward = earned(user);
993         if (reward > 0) {
994             rewards[user] = 0;
995             IERC20(rewardToken).safeTransfer(user, reward);
996             emit RewardPaid(user, reward);
997         }
998     }
999 
1000    /// Imported from: https://forum.openzeppelin.com/t/does-safemath-library-need-a-safe-power-function/871/7
1001    /// Modified so that it takes in 3 arguments for base
1002    /// @return a * (b / c)^exponent
1003    function pow(uint256 a, uint256 b, uint256 c, uint256 exponent) internal pure returns (uint256) {
1004         if (exponent == 0) {
1005             return a;
1006         }
1007         else if (exponent == 1) {
1008             return a.mul(b).div(c);
1009         }
1010         else if (a == 0 && exponent != 0) {
1011             return 0;
1012         }
1013         else {
1014             uint256 z = a.mul(b).div(c);
1015             for (uint256 i = 1; i < exponent; i++)
1016                 z = z.mul(b).div(c);
1017             return z;
1018         }
1019     }
1020 }