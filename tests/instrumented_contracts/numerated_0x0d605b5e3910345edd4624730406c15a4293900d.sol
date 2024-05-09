1 /**
2  *Submitted for verification at Etherscan.io on      09-16
3 */
4 
5 /***
6 
7  *    
8  *    
9  * https://BDM.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 BDM
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
73 
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
284         address msgSender = _msgSender();
285         _owner = msgSender;
286         emit OwnershipTransferred(address(0), msgSender);
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
341 // File: contracts/interface/IERC20.sol
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
369     /**
370      * @dev Returns the remaining number of tokens that `spender` will be
371      * allowed to spend on behalf of `owner` through {transferFrom}. This is
372      * zero by default.
373      *
374      * This value changes when {approve} or {transferFrom} are called.
375      */
376     function allowance(address owner, address spender) external view returns (uint256);
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * IMPORTANT: Beware that changing an allowance with this method brings the risk
384      * that someone may use both the old and the new allowance by unfortunate
385      * transaction ordering. One possible solution to mitigate this race
386      * condition is to first reduce the spender's allowance to 0 and set the
387      * desired value afterwards:
388      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
389      *
390      * Emits an {Approval} event.
391      */
392     function approve(address spender, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Moves `amount` tokens from `sender` to `recipient` using the
396      * allowance mechanism. `amount` is then deducted from the caller's
397      * allowance.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * Emits a {Transfer} event.
402      */
403     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
404 
405     /**
406      * @dev Emitted when `value` tokens are moved from one account (`from`) to
407      * another (`to`).
408      *
409      * Note that `value` may be zero.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 value);
412 
413     /**
414      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
415      * a call to {approve}. `value` is the new allowance.
416      */
417     event Approval(address indexed owner, address indexed spender, uint256 value);
418 }
419 
420 // File: contracts/interface/IPlayerBook.sol
421 
422 pragma solidity ^0.5.0;
423 
424 
425 interface IPlayerBook {
426     function settleReward( address from,uint256 amount ) external returns (uint256);
427     function bindRefer( address from,string calldata  affCode )  external returns (bool);
428     function hasRefer(address from) external returns(bool);
429 
430 }
431 
432 // File: contracts/interface/IPool.sol
433 
434 pragma solidity ^0.5.0;
435 
436 
437 interface IPool {
438     function totalSupply( ) external view returns (uint256);
439     function balanceOf( address player ) external view returns (uint256);
440 }
441 
442 // File: @openzeppelin/contracts/utils/Address.sol
443 
444 pragma solidity ^0.5.5;
445 
446 /**
447  * @dev Collection of functions related to the address type
448  */
449 library Address {
450     /**
451      * @dev Returns true if `account` is a contract.
452      *
453      * [IMPORTANT]
454      * ====
455      * It is unsafe to assume that an address for which this function returns
456      * false is an externally-owned account (EOA) and not a contract.
457      *
458      * Among others, `isContract` will return false for the following 
459      * types of addresses:
460      *
461      *  - an externally-owned account
462      *  - a contract in construction
463      *  - an address where a contract will be created
464      *  - an address where a contract lived, but was destroyed
465      * ====
466      */
467     function isContract(address account) internal view returns (bool) {
468         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
469         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
470         // for accounts without code, i.e. `keccak256('')`
471         bytes32 codehash;
472         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
473         // solhint-disable-next-line no-inline-assembly
474         assembly { codehash := extcodehash(account) }
475         return (codehash != accountHash && codehash != 0x0);
476     }
477 
478     /**
479      * @dev Converts an `address` into `address payable`. Note that this is
480      * simply a type cast: the actual underlying value is not changed.
481      *
482      * _Available since v2.4.0._
483      */
484     function toPayable(address account) internal pure returns (address payable) {
485         return address(uint160(account));
486     }
487 
488     /**
489      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
490      * `recipient`, forwarding all available gas and reverting on errors.
491      *
492      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
493      * of certain opcodes, possibly making contracts go over the 2300 gas limit
494      * imposed by `transfer`, making them unable to receive funds via
495      * `transfer`. {sendValue} removes this limitation.
496      *
497      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
498      *
499      * IMPORTANT: because control is transferred to `recipient`, care must be
500      * taken to not create reentrancy vulnerabilities. Consider using
501      * {ReentrancyGuard} or the
502      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
503      *
504      * _Available since v2.4.0._
505      */
506     function sendValue(address payable recipient, uint256 amount) internal {
507         require(address(this).balance >= amount, "Address: insufficient balance");
508 
509         // solhint-disable-next-line avoid-call-value
510         (bool success, ) = recipient.call.value(amount)("");
511         require(success, "Address: unable to send value, recipient may have reverted");
512     }
513 }
514 
515 // File: contracts/library/SafeERC20.sol
516 
517 pragma solidity ^0.5.0;
518 
519 
520 
521 
522 
523 /**
524  * @title SafeERC20
525  * @dev Wrappers around ERC20 operations that throw on failure (when the token
526  * contract returns false). Tokens that return no value (and instead revert or
527  * throw on failure) are also supported, non-reverting calls are assumed to be
528  * successful.
529  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
530  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
531  */
532 library SafeERC20 {
533     using SafeMath for uint256;
534     using Address for address;
535 
536     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
537 
538     function safeTransfer(IERC20 token, address to, uint256 value) internal {
539         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SELECTOR, to, value));
540         require(success && (data.length == 0 || abi.decode(data, (bool))), 'SafeERC20: TRANSFER_FAILED');
541     }
542     // function safeTransfer(IERC20 token, address to, uint256 value) internal {
543     //     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
544     // }
545 
546     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
547         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
548     }
549 
550     function safeApprove(IERC20 token, address spender, uint256 value) internal {
551         // safeApprove should only be called when setting an initial allowance,
552         // or when resetting it to zero. To increase and decrease it, use
553         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
554         // solhint-disable-next-line max-line-length
555         require((value == 0) || (token.allowance(address(this), spender) == 0),
556             "SafeERC20: approve from non-zero to non-zero allowance"
557         );
558         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
559     }
560 
561     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
562         uint256 newAllowance = token.allowance(address(this), spender).add(value);
563         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
564     }
565 
566     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
567         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
568         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
569     }
570 
571     /**
572      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
573      * on the return value: the return value is optional (but if data is returned, it must not be false).
574      * @param token The token targeted by the call.
575      * @param data The call data (encoded using abi.encode or one of its variants).
576      */
577     function callOptionalReturn(IERC20 token, bytes memory data) private {
578         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
579         // we're implementing it ourselves.
580 
581         // A Solidity high level call has three parts:
582         //  1. The target address is checked to verify it contains contract code
583         //  2. The call itself is made, and success asserted
584         //  3. The return value is decoded, which in turn checks the size of the returned data.
585         // solhint-disable-next-line max-line-length
586         require(address(token).isContract(), "SafeERC20: call to non-contract");
587 
588         // solhint-disable-next-line avoid-low-level-calls
589         (bool success, bytes memory returndata) = address(token).call(data);
590         require(success, "SafeERC20: low-level call failed");
591 
592         if (returndata.length > 0) { // Return data is optional
593             // solhint-disable-next-line max-line-length
594             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
595         }
596     }
597 }
598 
599 // File: contracts/library/BDMMath.sol
600 
601 pragma solidity ^0.5.0;
602 
603 
604 library BDMMath {
605   /**
606    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
607    * number.
608    *
609    * @param x unsigned 256-bit integer number
610    * @return unsigned 128-bit integer number
611    */
612     function sqrt(uint256 x) public pure returns (uint256 y)  {
613         uint256 z = (x + 1) / 2;
614         y = x;
615         while (z < y) {
616             y = z;
617             z = (x / z + z) / 2;
618         }
619     }
620 
621 }
622 
623 // File: contracts/library/Governance.sol
624 
625 pragma solidity ^0.5.0;
626 
627 contract Governance {
628 
629     address public _governance;
630 
631     constructor() public {
632         _governance = tx.origin;
633     }
634 
635     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
636 
637     modifier onlyGovernance {
638         require(msg.sender == _governance, "not governance");
639         _;
640     }
641 
642     function setGovernance(address governance)  public  onlyGovernance
643     {
644         require(governance != address(0), "new governance the zero address");
645         emit GovernanceTransferred(_governance, governance);
646         _governance = governance;
647     }
648 
649 
650 }
651 
652 // File: contracts/interface/IPowerStrategy.sol
653 
654 pragma solidity ^0.5.0;
655 
656 
657 interface IPowerStrategy {
658     function lpIn(address sender, uint256 amount) external;
659     function lpOut(address sender, uint256 amount) external;
660     
661     function getPower(address sender) view  external returns (uint256);
662 }
663 
664 // File: contracts/library/LPTokenWrapper.sol
665 
666 pragma solidity ^0.5.0;
667 
668 
669 
670 
671 
672 
673 
674 
675 
676 
677 contract LPTokenWrapper is IPool,Governance {
678     using SafeMath for uint256;
679     using SafeERC20 for IERC20;
680 
681     IERC20 public _lpToken = IERC20(0xf1BA6AC65531087f39423dfc160bC0fe9A4c472A); //切换一下对应的LP_token的币地址就行
682 
683     address public _playerBook = address(0x5963D0FB9eEd284BfF6d48119269504e9E0cF582); //切换一下对应的邀请的记录
684 
685     uint256 private _totalSupply;
686     mapping(address => uint256) private _balances;
687 
688     uint256 private _totalPower;
689     mapping(address => uint256) private _powerBalances;
690     
691     address public _powerStrategy = address(0x0);//token币的地址
692 
693 
694     function totalSupply() public view returns (uint256) {
695         return _totalSupply;
696     }
697     
698     function setLp_token(address LP_token) public  onlyGovernance {
699         //return _totalSupply;
700         _lpToken = IERC20(LP_token);
701     }
702 
703     function set_playBook(address playbook) public   onlyGovernance {
704         //return _totalSupply;
705         _playerBook = playbook;
706     }
707 
708     function setPowerStragegy(address strategy)  public  onlyGovernance{
709         _powerStrategy = strategy;
710     }
711 
712     function balanceOf(address account) public view returns (uint256) {
713         return _balances[account];
714     }
715 
716     function balanceOfPower(address account) public view returns (uint256) {
717         return _powerBalances[account];
718     }
719 
720 
721 
722     function totalPower() public view returns (uint256) {
723         return _totalPower;
724     }
725 
726 
727     function stake(uint256 amount, string memory affCode) public {
728         _totalSupply = _totalSupply.add(amount);
729         _balances[msg.sender] = _balances[msg.sender].add(amount);
730 
731         if( _powerStrategy != address(0x0)){ 
732             _totalPower = _totalPower.sub(_powerBalances[msg.sender]);
733             IPowerStrategy(_powerStrategy).lpIn(msg.sender, amount);
734 
735             _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);
736             _totalPower = _totalPower.add(_powerBalances[msg.sender]);
737         }else{
738             _totalPower = _totalSupply;
739             _powerBalances[msg.sender] = _balances[msg.sender];
740         }
741 
742         _lpToken.safeTransferFrom(msg.sender, address(this), amount);
743 
744 
745         if (!IPlayerBook(_playerBook).hasRefer(msg.sender)) {
746             IPlayerBook(_playerBook).bindRefer(msg.sender, affCode);
747         }
748 
749         
750     }
751 
752     function withdraw(uint256 amount) public {
753         require(amount > 0, "amout > 0");
754 
755         _totalSupply = _totalSupply.sub(amount);
756         _balances[msg.sender] = _balances[msg.sender].sub(amount);
757         
758         if( _powerStrategy != address(0x0)){ 
759             _totalPower = _totalPower.sub(_powerBalances[msg.sender]);
760             IPowerStrategy(_powerStrategy).lpOut(msg.sender, amount);
761             _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);
762             _totalPower = _totalPower.add(_powerBalances[msg.sender]);
763 
764         }else{
765             _totalPower = _totalSupply;
766             _powerBalances[msg.sender] = _balances[msg.sender];
767         }
768 
769         _lpToken.safeTransfer( msg.sender, amount);
770     }
771 
772     
773 }
774 
775 
776 interface Day_reward{
777     function setDay() external  returns(uint256);
778 }
779 // File: contracts/reward/UniswapReward.sol
780 
781 pragma solidity ^0.5.0;
782 
783 
784 
785 
786 
787 
788 
789 
790 contract UniswapReward is LPTokenWrapper{
791     using SafeERC20 for IERC20;
792 
793     IERC20 public _BDM = IERC20(0x86F8512E6B379561accE31071F67Da5E1fF0cB9b);
794     address public _teamWallet = 0x6a4e7072376dc59bBdaea8b803772C81CC5a419d;
795     address public _rewardPool = 0x6a4e7072376dc59bBdaea8b803772C81CC5a419d;
796     address public Day_reward_address = 0xe5294b963f4918F96113c167caa13d4416F44896;
797     // uint256 public constant DURATION = 7 days;
798     // should do this ? 
799     uint256 public  DURATION = 1 days;
800     uint256 public _initReward = 10000 * 1e18;
801     //init amount should be ?
802     
803     
804     uint256 public _startTime =  now + 365 days;
805     uint256 public _periodFinish = 0;
806     uint256 public _rewardRate = 0;
807     uint256 public _lastUpdateTime;
808     uint256 public _rewardPerTokenStored;
809     
810     uint256 public _teamRewardRate = 0;
811     uint256 public _poolRewardRate = 0;
812     uint256 public _baseRate = 10000;
813     uint256 public _punishTime = 10 days;
814 
815     mapping(address => uint256) public _userRewardPerTokenPaid;
816     mapping(address => uint256) public _rewards;
817     mapping(address => uint256) public _lastStakedTime;
818 
819     bool public _hasStart = false;
820 
821     event RewardAdded(uint256 reward);
822     event Staked(address indexed user, uint256 amount);
823     event Withdrawn(address indexed user, uint256 amount);
824     event RewardPaid(address indexed user, uint256 reward);
825 
826 
827     modifier updateReward(address account) {
828         _rewardPerTokenStored = rewardPerToken();
829         _lastUpdateTime = lastTimeRewardApplicable();
830         if (account != address(0)) {
831             _rewards[account] = earned(account);
832             _userRewardPerTokenPaid[account] = _rewardPerTokenStored;
833         }
834         _;
835     }
836     
837     function set_DURATION(uint256 _DURATION) public onlyGovernance{
838         DURATION = _DURATION; 
839     }
840     
841    
842     
843     function set_BDM_address(address BDM)public onlyGovernance{
844         _BDM = IERC20(BDM);
845     }
846     function set_teamWallet(address team)public onlyGovernance{
847         _teamWallet = team;
848     }
849     function set_rewardpool(address pool)public onlyGovernance{
850         _rewardPool = pool;
851     }
852     //set the initamount for onwer
853     function set_initReward(uint256 initamount) public onlyGovernance{
854         _initReward = initamount;
855     }
856     /* Fee collection for any other token */
857     function seize(IERC20 token, uint256 amount) external onlyGovernance{
858         require(token != _BDM, "reward");
859         require(token != _lpToken, "stake");
860         token.safeTransfer(_governance, amount);
861     }
862 
863     function() external payable {
864         revert();
865     }
866     
867     function setTeamRewardRate( uint256 teamRewardRate ) public onlyGovernance{
868         _teamRewardRate = teamRewardRate;
869     }
870 
871     function setPoolRewardRate( uint256  poolRewardRate ) public onlyGovernance{
872         _poolRewardRate = poolRewardRate;
873     }
874 
875     function setWithDrawPunishTime( uint256  punishTime ) public onlyGovernance{
876         _punishTime = punishTime;
877     }
878 
879     function lastTimeRewardApplicable() public view returns (uint256) {
880         return Math.min(block.timestamp, _periodFinish);
881     }
882 
883     function rewardPerToken() public view returns (uint256) {
884         if (totalPower() == 0) {
885             return _rewardPerTokenStored;
886         }
887         return
888             _rewardPerTokenStored.add(
889                 lastTimeRewardApplicable()
890                     .sub(_lastUpdateTime)
891                     .mul(_rewardRate)
892                     .mul(1e18)
893                     .div(totalPower())
894             );
895     }
896 
897     function earned(address account) public view returns (uint256) {
898         return
899             balanceOfPower(account)
900                 .mul(rewardPerToken().sub(_userRewardPerTokenPaid[account]))
901                 .div(1e18)
902                 .add(_rewards[account]);
903     }
904 
905     // stake visibility is public as overriding LPTokenWrapper's stake() function
906     function stake(uint256 amount, string memory affCode)
907         public
908         updateReward(msg.sender)
909         checkHalve
910         checkStart
911     {
912         require(amount > 0, "Cannot stake 0");
913         super.stake(amount, affCode);
914 
915         _lastStakedTime[msg.sender] = now;
916 
917         emit Staked(msg.sender, amount);
918     }
919 
920     function withdraw(uint256 amount)
921         public
922         updateReward(msg.sender)
923         checkHalve
924         checkStart
925     {
926         require(amount > 0, "Cannot withdraw 0");
927         super.withdraw(amount);
928         emit Withdrawn(msg.sender, amount);
929     }
930 
931     function exit() external {
932         withdraw(balanceOf(msg.sender));
933         getReward();
934     }
935 
936     function getReward() public updateReward(msg.sender) checkHalve checkStart {
937         uint256 reward = earned(msg.sender);
938         if (reward > 0) {
939             _rewards[msg.sender] = 0;
940 
941             uint256 fee = IPlayerBook(_playerBook).settleReward(msg.sender, reward);
942             if(fee > 0){
943                 _BDM.safeTransfer(_playerBook, fee);
944             }
945             
946             uint256 teamReward = reward.mul(_teamRewardRate).div(_baseRate);
947             if(teamReward>0){
948                 _BDM.safeTransfer(_teamWallet, teamReward);
949             }
950             uint256 leftReward = reward.sub(fee).sub(teamReward);
951             uint256 poolReward = 0;
952 
953             //withdraw time check
954 
955             if(now  < (_lastStakedTime[msg.sender] + _punishTime) ){
956                 poolReward = leftReward.mul(_poolRewardRate).div(_baseRate);
957             }
958             if(poolReward>0){
959                 _BDM.safeTransfer(_rewardPool, poolReward);
960                 leftReward = leftReward.sub(poolReward);
961             }
962 
963             if(leftReward>0){
964                 _BDM.safeTransfer(msg.sender, leftReward );
965             }
966       
967             emit RewardPaid(msg.sender, leftReward);
968         }
969     }
970 
971     modifier checkHalve() {
972         if (block.timestamp >= _periodFinish) {
973             // _initReward = _initReward.mul(50).div(100);
974             update_initreward();
975             _BDM.mint(address(this), _initReward);
976             _rewardRate = _initReward.div(DURATION);
977             _periodFinish = block.timestamp.add(DURATION);
978             emit RewardAdded(_initReward);
979         }
980         _;
981     }
982     
983     modifier checkStart() {
984         require(block.timestamp > _startTime, "not start");
985         _;
986     }
987     
988     function update_initreward() private {
989 	   _initReward = Day_reward(Day_reward_address).setDay();
990 	}
991     
992 //     function update_initreward() private {
993 // 	    dayNums = dayNums + 1;
994 //         int128 precision = 10000000;
995 //         int256 thisreward;
996 //         int128 BASE_Rate = precision-precision*dayNums/60; 
997 //         uint256 count = 0;
998 //         int128[] memory list = new int128[](15);
999 //         int128 Yun_number = BASE_Rate;
1000 //         int128 d = 0;
1001 //         if(dayNums<=180){
1002 //         for(int128 i=0;i<15;i++){ 
1003 //         	Yun_number = Yun_number*2;
1004 //         	int128 A = 1;
1005         	
1006 //         	if(Yun_number>precision){ 
1007 //         		d = d+(A<<(63-count));
1008 //         		Yun_number-=precision;
1009 //         		list[count] = int128(1);
1010 //         		count+=1;
1011 //         	}else{
1012 //         		//d = d+(B<<(63-count));
1013 //         		list[count] = int128(0);
1014 //         		count+=1;
1015 //         	}
1016         	
1017 //         }
1018 
1019 // 		thisreward = int256(ABDKMath64x64.toInt(ABDKMath64x64.exp(d)*baseReward));
1020 
1021 // 		}else if(dayNums<=25*365){
1022 // 		    thisreward = int256(1000);
1023 // 		}
1024 // 	    thisreward = thisreward*10**18;
1025 // 	    _initReward = uint256(thisreward);
1026 // 	}
1027 
1028     // set fix time to start reward
1029     function startReward(uint256 startTime)
1030         external
1031         onlyGovernance
1032         updateReward(address(0))
1033     {
1034         require(_hasStart == false, "has started");
1035         _hasStart = true;
1036         _startTime = startTime;
1037         update_initreward();
1038         _rewardRate = _initReward.div(DURATION); 
1039         _BDM.mint(address(this), _initReward);
1040         _lastUpdateTime = _startTime;
1041         _periodFinish = _startTime.add(DURATION);
1042 
1043         emit RewardAdded(_initReward);
1044     }
1045 
1046     //
1047 
1048     //for extra reward
1049     function notifyRewardAmount(uint256 reward)
1050         external
1051         onlyGovernance
1052         updateReward(address(0))
1053     {
1054         IERC20(_BDM).safeTransferFrom(msg.sender, address(this), reward);
1055         if (block.timestamp >= _periodFinish) {
1056             _rewardRate = reward.div(DURATION);
1057         } else {
1058             uint256 remaining = _periodFinish.sub(block.timestamp);
1059             uint256 leftover = remaining.mul(_rewardRate);
1060             _rewardRate = reward.add(leftover).div(DURATION);
1061         }
1062         _lastUpdateTime = block.timestamp;
1063         _periodFinish = block.timestamp.add(DURATION);
1064         emit RewardAdded(reward);
1065     }
1066 }