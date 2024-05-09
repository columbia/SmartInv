1 /***
2  *    ██████╗ ███████╗ ██████╗  ██████╗ 
3  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
4  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
5  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
6  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
7  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
8  *    
9  * https://dego.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 dego
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
67 pragma solidity ^0.5.0;
68 
69 /**
70  * @dev Wrappers over Solidity's arithmetic operations with added overflow
71  * checks.
72  *
73  * Arithmetic operations in Solidity wrap on overflow. This can easily result
74  * in bugs, because programmers usually assume that an overflow raises an
75  * error, which is the standard behavior in high level programming languages.
76  * `SafeMath` restores this intuition by reverting the transaction when an
77  * operation overflows.
78  *
79  * Using this library instead of the unchecked operations eliminates an entire
80  * class of bugs, so it's recommended to use it always.
81  */
82 library SafeMath {
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a, "SafeMath: addition overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return sub(a, b, "SafeMath: subtraction overflow");
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      *
121      * _Available since v2.4.0._
122      */
123     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b <= a, errorMessage);
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         return div(a, b, "SafeMath: division by zero");
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      *
179      * _Available since v2.4.0._
180      */
181     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         // Solidity only automatically asserts when dividing by 0
183         require(b > 0, errorMessage);
184         uint256 c = a / b;
185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * Reverts when dividing by zero.
193      *
194      * Counterpart to Solidity's `%` operator. This function uses a `revert`
195      * opcode (which leaves remaining gas untouched) while Solidity uses an
196      * invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
202         return mod(a, b, "SafeMath: modulo by zero");
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts with custom message when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      *
216      * _Available since v2.4.0._
217      */
218     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b != 0, errorMessage);
220         return a % b;
221     }
222 }
223 
224 // File: @openzeppelin/contracts/GSN/Context.sol
225 
226 pragma solidity ^0.5.0;
227 
228 /*
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with GSN meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 contract Context {
239     // Empty internal constructor, to prevent people from mistakenly deploying
240     // an instance of this contract, which should be used via inheritance.
241     constructor () internal { }
242     // solhint-disable-previous-line no-empty-blocks
243 
244     function _msgSender() internal view returns (address payable) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view returns (bytes memory) {
249         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
250         return msg.data;
251     }
252 }
253 
254 // File: @openzeppelin/contracts/ownership/Ownable.sol
255 
256 pragma solidity ^0.5.0;
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor () internal {
276         address msgSender = _msgSender();
277         _owner = msgSender;
278         emit OwnershipTransferred(address(0), msgSender);
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(isOwner(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Returns true if the caller is the current owner.
298      */
299     function isOwner() public view returns (bool) {
300         return _msgSender() == _owner;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public onlyOwner {
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      */
326     function _transferOwnership(address newOwner) internal {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         emit OwnershipTransferred(_owner, newOwner);
329         _owner = newOwner;
330     }
331 }
332 
333 // File: contracts/interface/IERC20.sol
334 
335 pragma solidity ^0.5.0;
336 
337 /**
338  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
339  * the optional functions; to access them see {ERC20Detailed}.
340  */
341 interface IERC20 {
342     /**
343      * @dev Returns the amount of tokens in existence.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     /**
348      * @dev Returns the amount of tokens owned by `account`.
349      */
350     function balanceOf(address account) external view returns (uint256);
351 
352     /**
353      * @dev Moves `amount` tokens from the caller's account to `recipient`.
354      *
355      * Returns a boolean value indicating whether the operation succeeded.
356      *
357      * Emits a {Transfer} event.
358      */
359     function transfer(address recipient, uint256 amount) external returns (bool);
360     function mint(address account, uint amount) external;
361     /**
362      * @dev Returns the remaining number of tokens that `spender` will be
363      * allowed to spend on behalf of `owner` through {transferFrom}. This is
364      * zero by default.
365      *
366      * This value changes when {approve} or {transferFrom} are called.
367      */
368     function allowance(address owner, address spender) external view returns (uint256);
369 
370     /**
371      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * IMPORTANT: Beware that changing an allowance with this method brings the risk
376      * that someone may use both the old and the new allowance by unfortunate
377      * transaction ordering. One possible solution to mitigate this race
378      * condition is to first reduce the spender's allowance to 0 and set the
379      * desired value afterwards:
380      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
381      *
382      * Emits an {Approval} event.
383      */
384     function approve(address spender, uint256 amount) external returns (bool);
385 
386     /**
387      * @dev Moves `amount` tokens from `sender` to `recipient` using the
388      * allowance mechanism. `amount` is then deducted from the caller's
389      * allowance.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Emitted when `value` tokens are moved from one account (`from`) to
399      * another (`to`).
400      *
401      * Note that `value` may be zero.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 value);
404 
405     /**
406      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
407      * a call to {approve}. `value` is the new allowance.
408      */
409     event Approval(address indexed owner, address indexed spender, uint256 value);
410 }
411 
412 // File: contracts/interface/IPlayerBook.sol
413 
414 pragma solidity ^0.5.0;
415 
416 
417 interface IPlayerBook {
418     function settleReward( address from,uint256 amount ) external returns (uint256);
419     function bindRefer( address from,string calldata  affCode )  external returns (bool);
420     function hasRefer(address from) external returns(bool);
421 
422 }
423 
424 // File: contracts/interface/IPool.sol
425 
426 pragma solidity ^0.5.0;
427 
428 
429 interface IPool {
430     function totalSupply( ) external view returns (uint256);
431     function balanceOf( address player ) external view returns (uint256);
432     function updateStrategyPower( address player ) external;
433 }
434 
435 // File: @openzeppelin/contracts/utils/Address.sol
436 
437 pragma solidity ^0.5.5;
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following 
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      */
460     function isContract(address account) internal view returns (bool) {
461         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
462         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
463         // for accounts without code, i.e. `keccak256('')`
464         bytes32 codehash;
465         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
466         // solhint-disable-next-line no-inline-assembly
467         assembly { codehash := extcodehash(account) }
468         return (codehash != accountHash && codehash != 0x0);
469     }
470 
471     /**
472      * @dev Converts an `address` into `address payable`. Note that this is
473      * simply a type cast: the actual underlying value is not changed.
474      *
475      * _Available since v2.4.0._
476      */
477     function toPayable(address account) internal pure returns (address payable) {
478         return address(uint160(account));
479     }
480 
481     /**
482      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
483      * `recipient`, forwarding all available gas and reverting on errors.
484      *
485      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
486      * of certain opcodes, possibly making contracts go over the 2300 gas limit
487      * imposed by `transfer`, making them unable to receive funds via
488      * `transfer`. {sendValue} removes this limitation.
489      *
490      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
491      *
492      * IMPORTANT: because control is transferred to `recipient`, care must be
493      * taken to not create reentrancy vulnerabilities. Consider using
494      * {ReentrancyGuard} or the
495      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
496      *
497      * _Available since v2.4.0._
498      */
499     function sendValue(address payable recipient, uint256 amount) internal {
500         require(address(this).balance >= amount, "Address: insufficient balance");
501 
502         // solhint-disable-next-line avoid-call-value
503         (bool success, ) = recipient.call.value(amount)("");
504         require(success, "Address: unable to send value, recipient may have reverted");
505     }
506 }
507 
508 // File: contracts/library/SafeERC20.sol
509 
510 pragma solidity ^0.5.0;
511 
512 
513 
514 
515 
516 /**
517  * @title SafeERC20
518  * @dev Wrappers around ERC20 operations that throw on failure (when the token
519  * contract returns false). Tokens that return no value (and instead revert or
520  * throw on failure) are also supported, non-reverting calls are assumed to be
521  * successful.
522  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
523  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
524  */
525 library SafeERC20 {
526     using SafeMath for uint256;
527     using Address for address;
528 
529     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
530 
531     function safeTransfer(IERC20 token, address to, uint256 value) internal {
532         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SELECTOR, to, value));
533         require(success && (data.length == 0 || abi.decode(data, (bool))), 'SafeERC20: TRANSFER_FAILED');
534     }
535     // function safeTransfer(IERC20 token, address to, uint256 value) internal {
536     //     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
537     // }
538 
539     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
540         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
541     }
542 
543     function safeApprove(IERC20 token, address spender, uint256 value) internal {
544         // safeApprove should only be called when setting an initial allowance,
545         // or when resetting it to zero. To increase and decrease it, use
546         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
547         // solhint-disable-next-line max-line-length
548         require((value == 0) || (token.allowance(address(this), spender) == 0),
549             "SafeERC20: approve from non-zero to non-zero allowance"
550         );
551         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
552     }
553 
554     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
555         uint256 newAllowance = token.allowance(address(this), spender).add(value);
556         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
557     }
558 
559     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
560         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
561         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
562     }
563 
564     /**
565      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
566      * on the return value: the return value is optional (but if data is returned, it must not be false).
567      * @param token The token targeted by the call.
568      * @param data The call data (encoded using abi.encode or one of its variants).
569      */
570     function callOptionalReturn(IERC20 token, bytes memory data) private {
571         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
572         // we're implementing it ourselves.
573 
574         // A Solidity high level call has three parts:
575         //  1. The target address is checked to verify it contains contract code
576         //  2. The call itself is made, and success asserted
577         //  3. The return value is decoded, which in turn checks the size of the returned data.
578         // solhint-disable-next-line max-line-length
579         require(address(token).isContract(), "SafeERC20: call to non-contract");
580 
581         // solhint-disable-next-line avoid-low-level-calls
582         (bool success, bytes memory returndata) = address(token).call(data);
583         require(success, "SafeERC20: low-level call failed");
584 
585         if (returndata.length > 0) { // Return data is optional
586             // solhint-disable-next-line max-line-length
587             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
588         }
589     }
590 }
591 
592 // File: contracts/library/DegoMath.sol
593 
594 pragma solidity ^0.5.0;
595 
596 
597 library DegoMath {
598   /**
599    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
600    * number.
601    *
602    * @param x unsigned 256-bit integer number
603    * @return unsigned 128-bit integer number
604    */
605     function sqrt(uint256 x) public pure returns (uint256 y)  {
606         uint256 z = (x + 1) / 2;
607         y = x;
608         while (z < y) {
609             y = z;
610             z = (x / z + z) / 2;
611         }
612     }
613 
614 }
615 
616 // File: contracts/library/Governance.sol
617 
618 pragma solidity ^0.5.0;
619 
620 contract Governance {
621 
622     address public _governance;
623 
624     constructor() public {
625         _governance = tx.origin;
626     }
627 
628     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
629 
630     modifier onlyGovernance {
631         require(msg.sender == _governance, "not governance");
632         _;
633     }
634 
635     function setGovernance(address governance)  public  onlyGovernance
636     {
637         require(governance != address(0), "new governance the zero address");
638         emit GovernanceTransferred(_governance, governance);
639         _governance = governance;
640     }
641 
642 
643 }
644 
645 // File: contracts/interface/IPowerStrategy.sol
646 
647 pragma solidity ^0.5.0;
648 
649 
650 interface IPowerStrategy {
651     function lpIn(address sender, uint256 amount) external;
652     function lpOut(address sender, uint256 amount) external;
653     
654     function getPower(address sender) view  external returns (uint256);
655 }
656 
657 // File: contracts/library/LPTokenWrapper.sol
658 
659 pragma solidity ^0.5.0;
660 
661 
662 
663 
664 
665 
666 
667 
668 
669 
670 contract LPTokenWrapper is IPool,Governance {
671     using SafeMath for uint256;
672     using SafeERC20 for IERC20;
673 
674     IERC20 public _lpToken = IERC20(0xD1956650Ad348908Cb9381148553c941ECFaDdd0);
675 
676     address public _playerBook = address(0x4cc945E7b97fED1EAD961Cd83eD622Fe48BBf3a0);
677 
678     uint256 private _totalSupply;
679     mapping(address => uint256) private _balances;
680 
681     uint256 private _totalPower;
682     mapping(address => uint256) private _powerBalances;
683     
684     address public _powerStrategy = address(0x0);
685 
686 
687     function totalSupply() public view returns (uint256) {
688         return _totalSupply;
689     }
690 
691     function setPowerStragegy(address strategy)  public  onlyGovernance{
692         _powerStrategy = strategy;
693     }
694 
695     function balanceOf(address account) public view returns (uint256) {
696         return _balances[account];
697     }
698 
699     function balanceOfPower(address account) public view returns (uint256) {
700         return _powerBalances[account];
701     }
702 
703     function totalPower() public view returns (uint256) {
704         return _totalPower;
705     }
706 
707     function updateStrategyPower( address player ) public{
708 
709         if( _powerStrategy != address(0x0)){ 
710             _totalPower = _totalPower.sub(_powerBalances[player]);
711             _powerBalances[player] = IPowerStrategy(_powerStrategy).getPower(player);
712             _totalPower = _totalPower.add(_powerBalances[player]);
713         }
714     }
715 
716     function stake(uint256 amount, string memory affCode) public {
717         _totalSupply = _totalSupply.add(amount);
718         _balances[msg.sender] = _balances[msg.sender].add(amount);
719 
720         if( _powerStrategy != address(0x0)){ 
721             IPowerStrategy(_powerStrategy).lpIn(msg.sender, amount);
722             // _totalPower = _totalPower.sub(_powerBalances[msg.sender]);
723             // _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);
724             // _totalPower = _totalPower.add(_powerBalances[msg.sender]);
725         }else{
726             _totalPower = _totalSupply;
727             _powerBalances[msg.sender] = _balances[msg.sender];
728         }
729 
730         _lpToken.safeTransferFrom(msg.sender, address(this), amount);
731 
732         if (!IPlayerBook(_playerBook).hasRefer(msg.sender)) {
733             IPlayerBook(_playerBook).bindRefer(msg.sender, affCode);
734         }
735         
736     }
737 
738     function withdraw(uint256 amount) public {
739         require(amount > 0, "amout > 0");
740 
741         _totalSupply = _totalSupply.sub(amount);
742         _balances[msg.sender] = _balances[msg.sender].sub(amount);
743         
744         if( _powerStrategy != address(0x0)){ 
745             IPowerStrategy(_powerStrategy).lpOut(msg.sender, amount);
746             // _totalPower = _totalPower.sub(_powerBalances[msg.sender]);
747             // _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);
748             // _totalPower = _totalPower.add(_powerBalances[msg.sender]);
749 
750         }else{
751             _totalPower = _totalSupply;
752             _powerBalances[msg.sender] = _balances[msg.sender];
753         }
754 
755         _lpToken.safeTransfer( msg.sender, amount);
756     }
757 
758     
759 }
760 
761 // File: contracts/reward/UniswapReward.sol
762 
763 pragma solidity ^0.5.0;
764 
765 
766 
767 
768 
769 
770 
771 
772 contract UniswapReward is LPTokenWrapper{
773     using SafeERC20 for IERC20;
774 
775     IERC20 public _dego = IERC20(0x88EF27e69108B2633F8E1C184CC37940A075cC02);
776     address public _teamWallet = 0x3D0a845C5ef9741De999FC068f70E2048A489F2b;
777     address public _rewardPool = 0xEA6dEc98e137a87F78495a8386f7A137408f7722;
778 
779     uint256 public constant DURATION = 7 days;
780 
781     uint256 public _initReward = 262500 * 1e18;
782     uint256 public _startTime =  now + 365 days;
783     uint256 public _periodFinish = 0;
784     uint256 public _rewardRate = 0;
785     uint256 public _lastUpdateTime;
786     uint256 public _rewardPerTokenStored;
787 
788     uint256 public _teamRewardRate = 500;
789     uint256 public _poolRewardRate = 1000;
790     uint256 public _baseRate = 10000;
791     uint256 public _punishTime = 3 days;
792 
793     mapping(address => uint256) public _userRewardPerTokenPaid;
794     mapping(address => uint256) public _rewards;
795     mapping(address => uint256) public _lastStakedTime;
796 
797     bool public _hasStart = false;
798 
799     event RewardAdded(uint256 reward);
800     event Staked(address indexed user, uint256 amount);
801     event Withdrawn(address indexed user, uint256 amount);
802     event RewardPaid(address indexed user, uint256 reward);
803 
804 
805     modifier updateReward(address account) {
806         _rewardPerTokenStored = rewardPerToken();
807         _lastUpdateTime = lastTimeRewardApplicable();
808         if (account != address(0)) {
809             _rewards[account] = earned(account);
810             _userRewardPerTokenPaid[account] = _rewardPerTokenStored;
811         }
812         _;
813     }
814 
815     /* Fee collection for any other token */
816     function seize(IERC20 token, uint256 amount) external onlyGovernance{
817         require(token != _dego, "reward");
818         require(token != _lpToken, "stake");
819         token.safeTransfer(_governance, amount);
820     }
821 
822     function setTeamRewardRate( uint256 teamRewardRate ) public onlyGovernance{
823         _teamRewardRate = teamRewardRate;
824     }
825 
826     function setPoolRewardRate( uint256  poolRewardRate ) public onlyGovernance{
827         _poolRewardRate = poolRewardRate;
828     }
829 
830     function setWithDrawPunishTime( uint256  punishTime ) public onlyGovernance{
831         _punishTime = punishTime;
832     }
833 
834     function lastTimeRewardApplicable() public view returns (uint256) {
835         return Math.min(block.timestamp, _periodFinish);
836     }
837 
838     function rewardPerToken() public view returns (uint256) {
839         if (totalPower() == 0) {
840             return _rewardPerTokenStored;
841         }
842         return
843             _rewardPerTokenStored.add(
844                 lastTimeRewardApplicable()
845                     .sub(_lastUpdateTime)
846                     .mul(_rewardRate)
847                     .mul(1e18)
848                     .div(totalPower())
849             );
850     }
851 
852     function earned(address account) public view returns (uint256) {
853         return
854             balanceOfPower(account)
855                 .mul(rewardPerToken().sub(_userRewardPerTokenPaid[account]))
856                 .div(1e18)
857                 .add(_rewards[account]);
858     }
859 
860     // stake visibility is public as overriding LPTokenWrapper's stake() function
861     function stake(uint256 amount, string memory affCode)
862         public
863         updateReward(msg.sender)
864         checkHalve
865         checkStart
866     {
867         require(amount > 0, "Cannot stake 0");
868         super.stake(amount, affCode);
869 
870         _lastStakedTime[msg.sender] = now;
871 
872         emit Staked(msg.sender, amount);
873     }
874 
875     function withdraw(uint256 amount)
876         public
877         updateReward(msg.sender)
878         checkHalve
879         checkStart
880     {
881         require(amount > 0, "Cannot withdraw 0");
882         super.withdraw(amount);
883         emit Withdrawn(msg.sender, amount);
884     }
885 
886     function exit() external {
887         withdraw(balanceOf(msg.sender));
888         getReward();
889     }
890 
891     function getReward() public updateReward(msg.sender) checkHalve checkStart {
892         uint256 reward = earned(msg.sender);
893         if (reward > 0) {
894             _rewards[msg.sender] = 0;
895 
896             uint256 fee = IPlayerBook(_playerBook).settleReward(msg.sender, reward);
897             if(fee > 0){
898                 _dego.safeTransfer(_playerBook, fee);
899             }
900             
901             uint256 teamReward = reward.mul(_teamRewardRate).div(_baseRate);
902             if(teamReward>0){
903                 _dego.safeTransfer(_teamWallet, teamReward);
904             }
905             uint256 leftReward = reward.sub(fee).sub(teamReward);
906             uint256 poolReward = 0;
907 
908             //withdraw time check
909 
910             if(now  < (_lastStakedTime[msg.sender] + _punishTime) ){
911                 poolReward = leftReward.mul(_poolRewardRate).div(_baseRate);
912             }
913             if(poolReward>0){
914                 _dego.safeTransfer(_rewardPool, poolReward);
915                 leftReward = leftReward.sub(poolReward);
916             }
917 
918             if(leftReward>0){
919                 _dego.safeTransfer(msg.sender, leftReward );
920             }
921       
922             emit RewardPaid(msg.sender, leftReward);
923         }
924     }
925 
926     modifier checkHalve() {
927         if (block.timestamp >= _periodFinish) {
928             _initReward = _initReward.mul(50).div(100);
929 
930             _dego.mint(address(this), _initReward);
931 
932             _rewardRate = _initReward.div(DURATION);
933             _periodFinish = block.timestamp.add(DURATION);
934             emit RewardAdded(_initReward);
935         }
936         _;
937     }
938     
939     modifier checkStart() {
940         require(block.timestamp > _startTime, "not start");
941         _;
942     }
943 
944     // set fix time to start reward
945     function startReward(uint256 startTime)
946         external
947         onlyGovernance
948         updateReward(address(0))
949     {
950         require(_hasStart == false, "has started");
951         _hasStart = true;
952         
953         _startTime = startTime;
954 
955         _rewardRate = _initReward.div(DURATION); 
956         _dego.mint(address(this), _initReward);
957 
958         _lastUpdateTime = _startTime;
959         _periodFinish = _startTime.add(DURATION);
960 
961         emit RewardAdded(_initReward);
962     }
963 
964     //
965 
966     //for extra reward
967     function notifyRewardAmount(uint256 reward)
968         external
969         onlyGovernance
970         updateReward(address(0))
971     {
972         IERC20(_dego).safeTransferFrom(msg.sender, address(this), reward);
973         if (block.timestamp >= _periodFinish) {
974             _rewardRate = reward.div(DURATION);
975         } else {
976             uint256 remaining = _periodFinish.sub(block.timestamp);
977             uint256 leftover = remaining.mul(_rewardRate);
978             _rewardRate = reward.add(leftover).div(DURATION);
979         }
980         _lastUpdateTime = block.timestamp;
981         _periodFinish = block.timestamp.add(DURATION);
982         emit RewardAdded(reward);
983     }
984 }
