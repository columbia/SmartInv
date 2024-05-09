1 /**
2  *Submitted for verification at Etherscan.io on      09-16
3 */
4 
5 /***
6 
7  *    
8  *    
9  * https://pros.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 pros
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 // File: @openzeppelin/contracts/math/Math.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Standard math utilities missing in the Solidity language.
39  */
40 library Math {
41     /**
42      * @dev Returns the largest of two numbers.
43      */
44     function max(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a >= b ? a : b;
46     }
47 
48     /**
49      * @dev Returns the smallest of two numbers.
50      */
51     function min(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a < b ? a : b;
53     }
54 
55     /**
56      * @dev Returns the average of two numbers. The result is rounded towards
57      * zero.
58      */
59     function average(uint256 a, uint256 b) internal pure returns (uint256) {
60         // (a + b) / 2 can overflow, so we distribute
61         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
62     }
63 }
64 
65 // File: @openzeppelin/contracts/math/SafeMath.sol
66 
67 /*
68  * ABDK Math 64.64 Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
69  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
70  */
71 
72 
73 /**
74  * Smart contract library of mathematical functions operating with signed
75  * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
76  * basically a simple fraction whose numerator is signed 128-bit integer and
77  * denominator is 2^64.  As long as denominator is always the same, there is no
78  * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
79  * represented by int128 type holding only the numerator.
80  */
81 
82 
83 
84 
85 
86 
87 pragma solidity ^0.5.0;
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
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      * - Subtraction cannot overflow.
140      *
141      * _Available since v2.4.0._
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      *
199      * _Available since v2.4.0._
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         // Solidity only automatically asserts when dividing by 0
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      *
236      * _Available since v2.4.0._
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/GSN/Context.sol
245 
246 pragma solidity ^0.5.0;
247 
248 /*
249  * @dev Provides information about the current execution context, including the
250  * sender of the transaction and its data. While these are generally available
251  * via msg.sender and msg.data, they should not be accessed in such a direct
252  * manner, since when dealing with GSN meta-transactions the account sending and
253  * paying for execution may not be the actual sender (as far as an application
254  * is concerned).
255  *
256  * This contract is only required for intermediate, library-like contracts.
257  */
258 contract Context {
259     // Empty internal constructor, to prevent people from mistakenly deploying
260     // an instance of this contract, which should be used via inheritance.
261     constructor () internal { }
262     // solhint-disable-previous-line no-empty-blocks
263 
264     function _msgSender() internal view returns (address payable) {
265         return msg.sender;
266     }
267 
268     function _msgData() internal view returns (bytes memory) {
269         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
270         return msg.data;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/ownership/Ownable.sol
275 
276 pragma solidity ^0.5.0;
277 
278 /**
279  * @dev Contract module which provides a basic access control mechanism, where
280  * there is an account (an owner) that can be granted exclusive access to
281  * specific functions.
282  *
283  * This module is used through inheritance. It will make available the modifier
284  * `onlyOwner`, which can be applied to your functions to restrict their use to
285  * the owner.
286  */
287 contract Ownable is Context {
288     address private _owner;
289 
290     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
291 
292     /**
293      * @dev Initializes the contract setting the deployer as the initial owner.
294      */
295     constructor () internal {
296         address msgSender = _msgSender();
297         _owner = msgSender;
298         emit OwnershipTransferred(address(0), msgSender);
299     }
300 
301     /**
302      * @dev Returns the address of the current owner.
303      */
304     function owner() public view returns (address) {
305         return _owner;
306     }
307 
308     /**
309      * @dev Throws if called by any account other than the owner.
310      */
311     modifier onlyOwner() {
312         require(isOwner(), "Ownable: caller is not the owner");
313         _;
314     }
315 
316     /**
317      * @dev Returns true if the caller is the current owner.
318      */
319     function isOwner() public view returns (bool) {
320         return _msgSender() == _owner;
321     }
322 
323     /**
324      * @dev Leaves the contract without owner. It will not be possible to call
325      * `onlyOwner` functions anymore. Can only be called by the current owner.
326      *
327      * NOTE: Renouncing ownership will leave the contract without an owner,
328      * thereby removing any functionality that is only available to the owner.
329      */
330     function renounceOwnership() public onlyOwner {
331         emit OwnershipTransferred(_owner, address(0));
332         _owner = address(0);
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      * Can only be called by the current owner.
338      */
339     function transferOwnership(address newOwner) public onlyOwner {
340         _transferOwnership(newOwner);
341     }
342 
343     /**
344      * @dev Transfers ownership of the contract to a new account (`newOwner`).
345      */
346     function _transferOwnership(address newOwner) internal {
347         require(newOwner != address(0), "Ownable: new owner is the zero address");
348         emit OwnershipTransferred(_owner, newOwner);
349         _owner = newOwner;
350     }
351 }
352 
353 // File: contracts/interface/IERC20.sol
354 
355 pragma solidity ^0.5.0;
356 
357 /**
358  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
359  * the optional functions; to access them see {ERC20Detailed}.
360  */
361 interface IERC20 {
362     /**
363      * @dev Returns the amount of tokens in existence.
364      */
365     function totalSupply() external view returns (uint256);
366 
367     /**
368      * @dev Returns the amount of tokens owned by `account`.
369      */
370     function balanceOf(address account) external view returns (uint256);
371 
372     /**
373      * @dev Moves `amount` tokens from the caller's account to `recipient`.
374      *
375      * Returns a boolean value indicating whether the operation succeeded.
376      *
377      * Emits a {Transfer} event.
378      */
379     function transfer(address recipient, uint256 amount) external returns (bool);
380     function mint(address account, uint amount) external;
381     /**
382      * @dev Returns the remaining number of tokens that `spender` will be
383      * allowed to spend on behalf of `owner` through {transferFrom}. This is
384      * zero by default.
385      *
386      * This value changes when {approve} or {transferFrom} are called.
387      */
388     function allowance(address owner, address spender) external view returns (uint256);
389 
390     /**
391      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * IMPORTANT: Beware that changing an allowance with this method brings the risk
396      * that someone may use both the old and the new allowance by unfortunate
397      * transaction ordering. One possible solution to mitigate this race
398      * condition is to first reduce the spender's allowance to 0 and set the
399      * desired value afterwards:
400      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
401      *
402      * Emits an {Approval} event.
403      */
404     function approve(address spender, uint256 amount) external returns (bool);
405 
406     /**
407      * @dev Moves `amount` tokens from `sender` to `recipient` using the
408      * allowance mechanism. `amount` is then deducted from the caller's
409      * allowance.
410      *
411      * Returns a boolean value indicating whether the operation succeeded.
412      *
413      * Emits a {Transfer} event.
414      */
415     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
416 
417     /**
418      * @dev Emitted when `value` tokens are moved from one account (`from`) to
419      * another (`to`).
420      *
421      * Note that `value` may be zero.
422      */
423     event Transfer(address indexed from, address indexed to, uint256 value);
424 
425     /**
426      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
427      * a call to {approve}. `value` is the new allowance.
428      */
429     event Approval(address indexed owner, address indexed spender, uint256 value);
430 }
431 
432 // File: contracts/interface/IPlayerBook.sol
433 
434 pragma solidity ^0.5.0;
435 
436 
437 interface IPlayerBook {
438     function settleReward( address from,uint256 amount ) external returns (uint256);
439     function bindRefer( address from,string calldata  affCode )  external returns (bool);
440     function hasRefer(address from) external returns(bool);
441 
442 }
443 
444 // File: contracts/interface/IPool.sol
445 
446 pragma solidity ^0.5.0;
447 
448 
449 interface IPool {
450     function totalSupply( ) external view returns (uint256);
451     function balanceOf( address player ) external view returns (uint256);
452 }
453 
454 // File: @openzeppelin/contracts/utils/Address.sol
455 
456 pragma solidity ^0.5.5;
457 
458 /**
459  * @dev Collection of functions related to the address type
460  */
461 library Address {
462     /**
463      * @dev Returns true if `account` is a contract.
464      *
465      * [IMPORTANT]
466      * ====
467      * It is unsafe to assume that an address for which this function returns
468      * false is an externally-owned account (EOA) and not a contract.
469      *
470      * Among others, `isContract` will return false for the following 
471      * types of addresses:
472      *
473      *  - an externally-owned account
474      *  - a contract in construction
475      *  - an address where a contract will be created
476      *  - an address where a contract lived, but was destroyed
477      * ====
478      */
479     function isContract(address account) internal view returns (bool) {
480         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
481         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
482         // for accounts without code, i.e. `keccak256('')`
483         bytes32 codehash;
484         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
485         // solhint-disable-next-line no-inline-assembly
486         assembly { codehash := extcodehash(account) }
487         return (codehash != accountHash && codehash != 0x0);
488     }
489 
490     /**
491      * @dev Converts an `address` into `address payable`. Note that this is
492      * simply a type cast: the actual underlying value is not changed.
493      *
494      * _Available since v2.4.0._
495      */
496     function toPayable(address account) internal pure returns (address payable) {
497         return address(uint160(account));
498     }
499 
500     /**
501      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
502      * `recipient`, forwarding all available gas and reverting on errors.
503      *
504      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
505      * of certain opcodes, possibly making contracts go over the 2300 gas limit
506      * imposed by `transfer`, making them unable to receive funds via
507      * `transfer`. {sendValue} removes this limitation.
508      *
509      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
510      *
511      * IMPORTANT: because control is transferred to `recipient`, care must be
512      * taken to not create reentrancy vulnerabilities. Consider using
513      * {ReentrancyGuard} or the
514      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
515      *
516      * _Available since v2.4.0._
517      */
518     function sendValue(address payable recipient, uint256 amount) internal {
519         require(address(this).balance >= amount, "Address: insufficient balance");
520 
521         // solhint-disable-next-line avoid-call-value
522         (bool success, ) = recipient.call.value(amount)("");
523         require(success, "Address: unable to send value, recipient may have reverted");
524     }
525 }
526 
527 // File: contracts/library/SafeERC20.sol
528 
529 pragma solidity ^0.5.0;
530 
531 
532 
533 
534 
535 /**
536  * @title SafeERC20
537  * @dev Wrappers around ERC20 operations that throw on failure (when the token
538  * contract returns false). Tokens that return no value (and instead revert or
539  * throw on failure) are also supported, non-reverting calls are assumed to be
540  * successful.
541  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
542  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
543  */
544 library SafeERC20 {
545     using SafeMath for uint256;
546     using Address for address;
547 
548     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
549 
550     function safeTransfer(IERC20 token, address to, uint256 value) internal {
551         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SELECTOR, to, value));
552         require(success && (data.length == 0 || abi.decode(data, (bool))), 'SafeERC20: TRANSFER_FAILED');
553     }
554     // function safeTransfer(IERC20 token, address to, uint256 value) internal {
555     //     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
556     // }
557 
558     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
559         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
560     }
561 
562     function safeApprove(IERC20 token, address spender, uint256 value) internal {
563         // safeApprove should only be called when setting an initial allowance,
564         // or when resetting it to zero. To increase and decrease it, use
565         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
566         // solhint-disable-next-line max-line-length
567         require((value == 0) || (token.allowance(address(this), spender) == 0),
568             "SafeERC20: approve from non-zero to non-zero allowance"
569         );
570         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
571     }
572 
573     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
574         uint256 newAllowance = token.allowance(address(this), spender).add(value);
575         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
576     }
577 
578     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
579         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
580         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
581     }
582 
583     /**
584      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
585      * on the return value: the return value is optional (but if data is returned, it must not be false).
586      * @param token The token targeted by the call.
587      * @param data The call data (encoded using abi.encode or one of its variants).
588      */
589     function callOptionalReturn(IERC20 token, bytes memory data) private {
590         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
591         // we're implementing it ourselves.
592 
593         // A Solidity high level call has three parts:
594         //  1. The target address is checked to verify it contains contract code
595         //  2. The call itself is made, and success asserted
596         //  3. The return value is decoded, which in turn checks the size of the returned data.
597         // solhint-disable-next-line max-line-length
598         require(address(token).isContract(), "SafeERC20: call to non-contract");
599 
600         // solhint-disable-next-line avoid-low-level-calls
601         (bool success, bytes memory returndata) = address(token).call(data);
602         require(success, "SafeERC20: low-level call failed");
603 
604         if (returndata.length > 0) { // Return data is optional
605             // solhint-disable-next-line max-line-length
606             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
607         }
608     }
609 }
610 
611 // File: contracts/library/priMath.sol
612 
613 pragma solidity ^0.5.0;
614 
615 
616 library prosMath {
617   /**
618    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
619    * number.
620    *
621    * @param x unsigned 256-bit integer number
622    * @return unsigned 128-bit integer number
623    */
624     function sqrt(uint256 x) public pure returns (uint256 y)  {
625         uint256 z = (x + 1) / 2;
626         y = x;
627         while (z < y) {
628             y = z;
629             z = (x / z + z) / 2;
630         }
631     }
632 
633 }
634 
635 // File: contracts/library/Governance.sol
636 
637 pragma solidity ^0.5.0;
638 
639 contract Governance {
640 
641     address public _governance;
642 
643     constructor() public {
644         _governance = tx.origin;
645     }
646 
647     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
648 
649     modifier onlyGovernance {
650         require(msg.sender == _governance, "not governance");
651         _;
652     }
653 
654     function setGovernance(address governance)  public  onlyGovernance
655     {
656         require(governance != address(0), "new governance the zero address");
657         emit GovernanceTransferred(_governance, governance);
658         _governance = governance;
659     }
660 
661 
662 }
663 
664 // File: contracts/interface/IPowerStrategy.sol
665 
666 pragma solidity ^0.5.0;
667 
668 
669 interface IPowerStrategy {
670     function lpIn(address sender, uint256 amount) external;
671     function lpOut(address sender, uint256 amount) external;
672     
673     function getPower(address sender) view  external returns (uint256);
674 }
675 
676 // File: contracts/library/LPTokenWrapper.sol
677 
678 pragma solidity ^0.5.0;
679 
680 
681 
682 
683 
684 
685 
686 
687 
688 
689 contract LPTokenWrapper is IPool,Governance {
690     using SafeMath for uint256;
691     using SafeERC20 for IERC20;
692 
693     IERC20 public _lpToken = IERC20(0x51D287C63301d574Eef7C7615bf02A19e9549B8A); //切换一下对应的LP_token的币地址就行
694 
695     address public _playerBook = address(0x21A4086a6Cdb332c851B76cccD21aCAB6428D9E4); //切换一下对应的邀请的记录
696 
697     uint256 private _totalSupply;
698     mapping(address => uint256) private _balances;
699 
700     uint256 private _totalPower;
701     mapping(address => uint256) private _powerBalances;
702     
703     address public _powerStrategy = address(0x0);//token币的地址
704 
705 
706     function totalSupply() public view returns (uint256) {
707         return _totalSupply;
708     }
709     
710     function setLp_token(address LP_token) public  onlyGovernance {
711         //return _totalSupply;
712         _lpToken = IERC20(LP_token);
713     }
714 
715     function set_playBook(address playbook) public   onlyGovernance {
716         //return _totalSupply;
717         _playerBook = playbook;
718     }
719 
720     function setPowerStragegy(address strategy)  public  onlyGovernance{
721         _powerStrategy = strategy;
722     }
723 
724     function balanceOf(address account) public view returns (uint256) {
725         return _balances[account];
726     }
727 
728     function balanceOfPower(address account) public view returns (uint256) {
729         return _powerBalances[account];
730     }
731 
732 
733 
734     function totalPower() public view returns (uint256) {
735         return _totalPower;
736     }
737 
738 
739     function stake(uint256 amount, string memory affCode) public {
740         _totalSupply = _totalSupply.add(amount);
741         _balances[msg.sender] = _balances[msg.sender].add(amount);
742 
743         if( _powerStrategy != address(0x0)){ 
744             _totalPower = _totalPower.sub(_powerBalances[msg.sender]);
745             IPowerStrategy(_powerStrategy).lpIn(msg.sender, amount);
746 
747             _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);
748             _totalPower = _totalPower.add(_powerBalances[msg.sender]);
749         }else{
750             _totalPower = _totalSupply;
751             _powerBalances[msg.sender] = _balances[msg.sender];
752         }
753 
754         _lpToken.safeTransferFrom(msg.sender, address(this), amount);
755 
756 
757         if (!IPlayerBook(_playerBook).hasRefer(msg.sender)) {
758             IPlayerBook(_playerBook).bindRefer(msg.sender, affCode);
759         }
760 
761         
762     }
763 
764     function withdraw(uint256 amount) public {
765         require(amount > 0, "amout > 0");
766 
767         _totalSupply = _totalSupply.sub(amount);
768         _balances[msg.sender] = _balances[msg.sender].sub(amount);
769         
770         if( _powerStrategy != address(0x0)){ 
771             _totalPower = _totalPower.sub(_powerBalances[msg.sender]);
772             IPowerStrategy(_powerStrategy).lpOut(msg.sender, amount);
773             _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);
774             _totalPower = _totalPower.add(_powerBalances[msg.sender]);
775 
776         }else{
777             _totalPower = _totalSupply;
778             _powerBalances[msg.sender] = _balances[msg.sender];
779         }
780 
781         _lpToken.safeTransfer( msg.sender, amount);
782     }
783 
784     
785 }
786 
787 
788 
789 interface AllPool{
790     function is_Re(address user) view external  returns(bool);
791     // function set_user_isRe(address user,address pool,string calldata name) external;
792     function get_Address_pool(address user) view external  returns(address);
793 }
794 
795 // File: contracts/reward/UniswapReward.sol
796 
797 pragma solidity ^0.5.0;
798 
799 
800 
801 
802 
803 
804 
805 
806 contract UniswapReward is LPTokenWrapper{
807     using SafeERC20 for IERC20;
808 
809     IERC20 public _pros = IERC20(0x306Dd7CD66d964f598B4D2ec92b5a9B275D7fEb3);
810     address public _teamWallet = 0xde7a7E8Db75D56B095263c63ecB4CfE8157ee3dd;
811     address public _rewardPool = 0xde7a7E8Db75D56B095263c63ecB4CfE8157ee3dd;
812     address public _allpool = 0xC682bD99eE552B6f7d931aFee2A9425806e155E9;
813     
814     
815     int128 private dayNums;
816     int128 baseReward = 8000;
817     // uint256 public constant DURATION = 7 days;
818     // should do this ? 
819     uint256 public  DURATION = 1 days;
820     uint256 public _initReward = 0;
821     
822     uint256 public base_ = 30*10e3;
823     uint256 public rate_forReward = 1;
824     uint256 public base_Rate_Reward = 100;
825     //init amount should be ?
826     
827     
828     uint256 public _startTime =  now + 365 days;
829     uint256 public _periodFinish = 0;
830     uint256 public _rewardRate = 0;
831     uint256 public _lastUpdateTime;
832     uint256 public _rewardPerTokenStored;
833 
834     uint256 public _teamRewardRate = 0;
835     uint256 public _poolRewardRate = 0;
836     uint256 public _baseRate = 10000;
837     uint256 public _punishTime = 10 days;
838 
839     mapping(address => uint256) public _userRewardPerTokenPaid;
840     mapping(address => uint256) public _rewards;
841     mapping(address => uint256) public _lastStakedTime;
842 
843     bool public _hasStart = false;
844 
845     event RewardAdded(uint256 reward);
846     event Staked(address indexed user, uint256 amount);
847     event Withdrawn(address indexed user, uint256 amount);
848     event RewardPaid(address indexed user, uint256 reward);
849 
850 
851     modifier updateReward(address account) {
852         _rewardPerTokenStored = rewardPerToken();
853         _lastUpdateTime = lastTimeRewardApplicable();
854         if (account != address(0)) {
855             _rewards[account] = earned(account);
856             _userRewardPerTokenPaid[account] = _rewardPerTokenStored;
857         }
858         _;
859     }
860     
861     function set_DURATION(uint256 _DURATION) public onlyGovernance{
862         DURATION = _DURATION; 
863     }
864     
865     function set_baseReward(int128 _baseReward) public onlyGovernance{
866         baseReward = _baseReward;
867     }
868     
869     function set_pros_address(address pri)public onlyGovernance{
870         _pros = IERC20(pri);
871     }
872     function set_teamWallet(address team)public onlyGovernance{
873         _teamWallet = team;
874     }
875     function set_rewardpool(address pool)public onlyGovernance{
876         _rewardPool = pool;
877     }
878     //set the initamount for onwer
879     function set_initReward(uint256 initamount) public onlyGovernance{
880         _initReward = initamount;
881     }
882     /* Fee collection for any other token */
883     function seize(IERC20 token, uint256 amount) external onlyGovernance{
884         require(token != _pros, "reward");
885         require(token != _lpToken, "stake");
886         token.safeTransfer(_governance, amount);
887     }
888 
889     function setTeamRewardRate( uint256 teamRewardRate ) public onlyGovernance{
890         _teamRewardRate = teamRewardRate;
891     }
892 
893     function setPoolRewardRate( uint256  poolRewardRate ) public onlyGovernance{
894         _poolRewardRate = poolRewardRate;
895     }
896 
897     function setWithDrawPunishTime( uint256  punishTime ) public onlyGovernance{
898         _punishTime = punishTime;
899     }
900 
901     function lastTimeRewardApplicable() public view returns (uint256) {
902         return Math.min(block.timestamp, _periodFinish);
903     }
904     
905     
906     function rewardPerToken() public view returns (uint256) { //to change to the address thing for dip problem 
907         if (totalPower() == 0) { //totalPower change ----- totaldipost[token] 
908             return _rewardPerTokenStored;
909         }
910         return
911             _rewardPerTokenStored.add(
912                 lastTimeRewardApplicable() 
913                     .sub(_lastUpdateTime)
914                     .mul(_rewardRate) //change for the _rewardRate[token]
915                     .mul(1e18)
916                     .div(totalPower()) //change for the totalPower[token] ---- 
917             );
918     }
919 
920     //diposit funtion should define the pri address setprice interface also 
921     //function 
922 
923     function earned(address account) public view returns (uint256) {
924         return
925             balanceOfPower(account)
926                 .mul(rewardPerToken().sub(_userRewardPerTokenPaid[account]))
927                 .div(1e18)
928                 .add(_rewards[account]);
929     }
930 
931     // stake visibility is public as overriding LPTokenWrapper's stake() function
932     function stake(uint256 amount, string memory affCode)
933         public
934         updateReward(msg.sender)
935         checkHalve
936         checkStart
937         isRegister
938     {
939         require(amount > 0, "Cannot stake 0");
940         super.stake(amount, affCode);
941 
942         _lastStakedTime[msg.sender] = now;
943 
944         emit Staked(msg.sender, amount);
945     }
946 
947     function withdraw(uint256 amount)
948         public
949         updateReward(msg.sender)
950         checkHalve
951         checkStart
952     {
953         require(amount > 0, "Cannot withdraw 0");
954         super.withdraw(amount);
955         emit Withdrawn(msg.sender, amount);
956     }
957 
958     function exit() external {
959         withdraw(balanceOf(msg.sender));
960         getReward();
961     }
962 
963     function getReward() public updateReward(msg.sender) checkHalve checkStart {
964         uint256 reward = earned(msg.sender);
965         if (reward > 0) {
966             _rewards[msg.sender] = 0;
967             
968             address set_play = AllPool(_allpool).get_Address_pool(msg.sender)==0x0000000000000000000000000000000000000000?_playerBook:AllPool(_allpool).get_Address_pool(msg.sender);
969             uint256 fee = IPlayerBook(set_play).settleReward(msg.sender,reward);
970             // uint256 fee = IPlayerBook(_playerBook).settleReward(msg.sender, reward);
971             if(fee > 0){
972                 _pros.safeTransfer(set_play, fee);
973             }
974             
975             uint256 teamReward = reward.mul(_teamRewardRate).div(_baseRate);
976             if(teamReward>0){
977                 _pros.safeTransfer(_teamWallet, teamReward);
978             }
979             uint256 leftReward = reward.sub(fee).sub(teamReward);
980             uint256 poolReward = 0;
981 
982             //withdraw time check
983 
984             if(now  < (_lastStakedTime[msg.sender] + _punishTime) ){
985                 poolReward = leftReward.mul(_poolRewardRate).div(_baseRate);
986             }
987             if(poolReward>0){
988                 _pros.safeTransfer(_rewardPool, poolReward);
989                 leftReward = leftReward.sub(poolReward);
990             }
991 
992             if(leftReward>0){
993                 _pros.safeTransfer(msg.sender, leftReward );
994             }
995       
996             emit RewardPaid(msg.sender, leftReward);
997         }
998     }
999 
1000     modifier checkHalve() {
1001         if (block.timestamp >= _periodFinish) {
1002             // _initReward = _initReward.mul(50).div(100);
1003             update_initreward();
1004             _pros.mint(address(this), _initReward);
1005             _rewardRate = _initReward.div(DURATION);
1006             _periodFinish = block.timestamp.add(DURATION);
1007             emit RewardAdded(_initReward);
1008         }
1009         _;
1010     }
1011     
1012     modifier checkStart() {
1013         require(block.timestamp > _startTime, "not start");
1014         _;
1015     }
1016     
1017     modifier isRegister(){
1018         require(AllPool(_allpool).is_Re(msg.sender)==true,"address not register or name already register");
1019         _;
1020     }
1021     
1022     function update_initreward() private {
1023 	    dayNums = dayNums + 1;
1024         uint256 thisreward = base_.mul(rate_forReward).mul(10**18).mul((base_Rate_Reward.sub(rate_forReward))**(uint256(dayNums-1))).div(base_Rate_Reward**(uint256(dayNums)));
1025 	    _initReward = uint256(thisreward);
1026 	}
1027 //     function update_initreward() private {
1028 // 	    dayNums = dayNums + 1;
1029 //         int128 precision = 10000000;
1030 //         int256 thisreward;
1031 //         int128 BASE_Rate = precision-precision*dayNums/60; 
1032 //         uint256 count = 0;
1033 //         int128[] memory list = new int128[](15);
1034 //         int128 Yun_number = BASE_Rate;
1035 //         int128 d = 0;
1036 //         if(dayNums<=180){
1037 //         for(int128 i=0;i<15;i++){ 
1038 //         	Yun_number = Yun_number*2;
1039 //         	int128 A = 1;
1040         	
1041 //         	if(Yun_number>precision){ 
1042 //         		d = d+(A<<(63-count));
1043 //         		Yun_number-=precision;
1044 //         		list[count] = int128(1);
1045 //         		count+=1;
1046 //         	}else{
1047 //         		//d = d+(B<<(63-count));
1048 //         		list[count] = int128(0);
1049 //         		count+=1;
1050 //         	}
1051         	
1052 //         }
1053 
1054 // 		thisreward = int256(ABDKMath64x64.toInt(ABDKMath64x64.exp(d)*baseReward));
1055 
1056 // 		}else if(dayNums<=25*365){
1057 // 		    thisreward = int256(1000);
1058 // 		}
1059 // 	    thisreward = thisreward*10**18;
1060 // 	    _initReward = uint256(thisreward);
1061 // 	}
1062 
1063 
1064     
1065     
1066     
1067     
1068     // set fix time to start reward
1069     function startReward(uint256 startTime)
1070         external
1071         onlyGovernance
1072         updateReward(address(0))
1073     {
1074         require(_hasStart == false, "has started");
1075         _hasStart = true;
1076         _startTime = startTime;
1077         update_initreward();
1078         _rewardRate = _initReward.div(DURATION); 
1079         _pros.mint(address(this), _initReward);
1080         _lastUpdateTime = _startTime;
1081         _periodFinish = _startTime.add(DURATION);
1082 
1083         emit RewardAdded(_initReward);
1084     }
1085 
1086     //
1087 
1088     //for extra reward
1089     function notifyRewardAmount(uint256 reward)
1090         external
1091         onlyGovernance
1092         updateReward(address(0))
1093     {
1094         IERC20(_pros).safeTransferFrom(msg.sender, address(this), reward);
1095         if (block.timestamp >= _periodFinish) {
1096             _rewardRate = reward.div(DURATION);
1097         } else {
1098             uint256 remaining = _periodFinish.sub(block.timestamp);
1099             uint256 leftover = remaining.mul(_rewardRate);
1100             _rewardRate = reward.add(leftover).div(DURATION);
1101         }
1102         _lastUpdateTime = block.timestamp;
1103         _periodFinish = block.timestamp.add(DURATION);
1104         emit RewardAdded(reward);
1105     }
1106 }