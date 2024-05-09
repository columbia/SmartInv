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
432 }
433 
434 // File: @openzeppelin/contracts/utils/Address.sol
435 
436 pragma solidity ^0.5.5;
437 
438 /**
439  * @dev Collection of functions related to the address type
440  */
441 library Address {
442     /**
443      * @dev Returns true if `account` is a contract.
444      *
445      * [IMPORTANT]
446      * ====
447      * It is unsafe to assume that an address for which this function returns
448      * false is an externally-owned account (EOA) and not a contract.
449      *
450      * Among others, `isContract` will return false for the following 
451      * types of addresses:
452      *
453      *  - an externally-owned account
454      *  - a contract in construction
455      *  - an address where a contract will be created
456      *  - an address where a contract lived, but was destroyed
457      * ====
458      */
459     function isContract(address account) internal view returns (bool) {
460         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
461         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
462         // for accounts without code, i.e. `keccak256('')`
463         bytes32 codehash;
464         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
465         // solhint-disable-next-line no-inline-assembly
466         assembly { codehash := extcodehash(account) }
467         return (codehash != accountHash && codehash != 0x0);
468     }
469 
470     /**
471      * @dev Converts an `address` into `address payable`. Note that this is
472      * simply a type cast: the actual underlying value is not changed.
473      *
474      * _Available since v2.4.0._
475      */
476     function toPayable(address account) internal pure returns (address payable) {
477         return address(uint160(account));
478     }
479 
480     /**
481      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
482      * `recipient`, forwarding all available gas and reverting on errors.
483      *
484      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
485      * of certain opcodes, possibly making contracts go over the 2300 gas limit
486      * imposed by `transfer`, making them unable to receive funds via
487      * `transfer`. {sendValue} removes this limitation.
488      *
489      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
490      *
491      * IMPORTANT: because control is transferred to `recipient`, care must be
492      * taken to not create reentrancy vulnerabilities. Consider using
493      * {ReentrancyGuard} or the
494      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
495      *
496      * _Available since v2.4.0._
497      */
498     function sendValue(address payable recipient, uint256 amount) internal {
499         require(address(this).balance >= amount, "Address: insufficient balance");
500 
501         // solhint-disable-next-line avoid-call-value
502         (bool success, ) = recipient.call.value(amount)("");
503         require(success, "Address: unable to send value, recipient may have reverted");
504     }
505 }
506 
507 // File: contracts/library/SafeERC20.sol
508 
509 pragma solidity ^0.5.0;
510 
511 
512 
513 
514 
515 /**
516  * @title SafeERC20
517  * @dev Wrappers around ERC20 operations that throw on failure (when the token
518  * contract returns false). Tokens that return no value (and instead revert or
519  * throw on failure) are also supported, non-reverting calls are assumed to be
520  * successful.
521  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
522  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
523  */
524 library SafeERC20 {
525     using SafeMath for uint256;
526     using Address for address;
527 
528     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
529 
530     function safeTransfer(IERC20 token, address to, uint256 value) internal {
531         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SELECTOR, to, value));
532         require(success && (data.length == 0 || abi.decode(data, (bool))), 'SafeERC20: TRANSFER_FAILED');
533     }
534     // function safeTransfer(IERC20 token, address to, uint256 value) internal {
535     //     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
536     // }
537 
538     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
539         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
540     }
541 
542     function safeApprove(IERC20 token, address spender, uint256 value) internal {
543         // safeApprove should only be called when setting an initial allowance,
544         // or when resetting it to zero. To increase and decrease it, use
545         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
546         // solhint-disable-next-line max-line-length
547         require((value == 0) || (token.allowance(address(this), spender) == 0),
548             "SafeERC20: approve from non-zero to non-zero allowance"
549         );
550         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
551     }
552 
553     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
554         uint256 newAllowance = token.allowance(address(this), spender).add(value);
555         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
556     }
557 
558     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
559         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
560         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
561     }
562 
563     /**
564      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
565      * on the return value: the return value is optional (but if data is returned, it must not be false).
566      * @param token The token targeted by the call.
567      * @param data The call data (encoded using abi.encode or one of its variants).
568      */
569     function callOptionalReturn(IERC20 token, bytes memory data) private {
570         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
571         // we're implementing it ourselves.
572 
573         // A Solidity high level call has three parts:
574         //  1. The target address is checked to verify it contains contract code
575         //  2. The call itself is made, and success asserted
576         //  3. The return value is decoded, which in turn checks the size of the returned data.
577         // solhint-disable-next-line max-line-length
578         require(address(token).isContract(), "SafeERC20: call to non-contract");
579 
580         // solhint-disable-next-line avoid-low-level-calls
581         (bool success, bytes memory returndata) = address(token).call(data);
582         require(success, "SafeERC20: low-level call failed");
583 
584         if (returndata.length > 0) { // Return data is optional
585             // solhint-disable-next-line max-line-length
586             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
587         }
588     }
589 }
590 
591 // File: contracts/library/DegoMath.sol
592 
593 pragma solidity ^0.5.0;
594 
595 
596 library DegoMath {
597   /**
598    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
599    * number.
600    *
601    * @param x unsigned 256-bit integer number
602    * @return unsigned 128-bit integer number
603    */
604     function sqrt(uint256 x) public pure returns (uint256 y)  {
605         uint256 z = (x + 1) / 2;
606         y = x;
607         while (z < y) {
608             y = z;
609             z = (x / z + z) / 2;
610         }
611     }
612 
613 }
614 
615 // File: contracts/library/Governance.sol
616 
617 pragma solidity ^0.5.0;
618 
619 contract Governance {
620 
621     address public _governance;
622 
623     constructor() public {
624         _governance = tx.origin;
625     }
626 
627     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
628 
629     modifier onlyGovernance {
630         require(msg.sender == _governance, "not governance");
631         _;
632     }
633 
634     function setGovernance(address governance)  public  onlyGovernance
635     {
636         require(governance != address(0), "new governance the zero address");
637         emit GovernanceTransferred(_governance, governance);
638         _governance = governance;
639     }
640 
641 
642 }
643 
644 // File: contracts/interface/IPowerStrategy.sol
645 
646 pragma solidity ^0.5.0;
647 
648 
649 interface IPowerStrategy {
650     function lpIn(address sender, uint256 amount) external;
651     function lpOut(address sender, uint256 amount) external;
652     
653     function getPower(address sender) view  external returns (uint256);
654 }
655 
656 // File: contracts/library/LPTokenWrapper.sol
657 
658 pragma solidity ^0.5.0;
659 
660 
661 
662 
663 
664 
665 
666 
667 
668 
669 contract LPTokenWrapper is IPool,Governance {
670     using SafeMath for uint256;
671     using SafeERC20 for IERC20;
672 
673     IERC20 public _lpToken = IERC20(0x23f7D99C169dEe26b215EdF806DA8fA0706C4EcC);
674 
675     address public _playerBook = address(0x4cc945E7b97fED1EAD961Cd83eD622Fe48BBf3a0);
676 
677     uint256 private _totalSupply;
678     mapping(address => uint256) private _balances;
679 
680     uint256 private _totalPower;
681     mapping(address => uint256) private _powerBalances;
682     
683     address public _powerStrategy = address(0x0);
684 
685 
686     function totalSupply() public view returns (uint256) {
687         return _totalSupply;
688     }
689 
690     function setPowerStragegy(address strategy)  public  onlyGovernance{
691         _powerStrategy = strategy;
692     }
693 
694     function balanceOf(address account) public view returns (uint256) {
695         return _balances[account];
696     }
697 
698     function balanceOfPower(address account) public view returns (uint256) {
699         return _powerBalances[account];
700     }
701 
702 
703 
704     function totalPower() public view returns (uint256) {
705         return _totalPower;
706     }
707 
708 
709     function stake(uint256 amount, string memory affCode) public {
710         _totalSupply = _totalSupply.add(amount);
711         _balances[msg.sender] = _balances[msg.sender].add(amount);
712 
713         if( _powerStrategy != address(0x0)){ 
714             _totalPower = _totalPower.sub(_powerBalances[msg.sender]);
715             IPowerStrategy(_powerStrategy).lpIn(msg.sender, amount);
716 
717             _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);
718             _totalPower = _totalPower.add(_powerBalances[msg.sender]);
719         }else{
720             _totalPower = _totalSupply;
721             _powerBalances[msg.sender] = _balances[msg.sender];
722         }
723 
724         _lpToken.safeTransferFrom(msg.sender, address(this), amount);
725 
726 
727         if (!IPlayerBook(_playerBook).hasRefer(msg.sender)) {
728             IPlayerBook(_playerBook).bindRefer(msg.sender, affCode);
729         }
730 
731         
732     }
733 
734     function withdraw(uint256 amount) public {
735         require(amount > 0, "amout > 0");
736 
737         _totalSupply = _totalSupply.sub(amount);
738         _balances[msg.sender] = _balances[msg.sender].sub(amount);
739         
740         if( _powerStrategy != address(0x0)){ 
741             _totalPower = _totalPower.sub(_powerBalances[msg.sender]);
742             IPowerStrategy(_powerStrategy).lpOut(msg.sender, amount);
743             _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);
744             _totalPower = _totalPower.add(_powerBalances[msg.sender]);
745 
746         }else{
747             _totalPower = _totalSupply;
748             _powerBalances[msg.sender] = _balances[msg.sender];
749         }
750 
751         _lpToken.safeTransfer( msg.sender, amount);
752     }
753 
754     
755 }
756 
757 // File: contracts/reward/UniswapReward.sol
758 
759 pragma solidity ^0.5.0;
760 
761 
762 
763 
764 
765 
766 
767 
768 contract UniswapReward is LPTokenWrapper{
769     using SafeERC20 for IERC20;
770 
771     IERC20 public _dego = IERC20(0x88EF27e69108B2633F8E1C184CC37940A075cC02);
772     address public _teamWallet = 0x3D0a845C5ef9741De999FC068f70E2048A489F2b;
773     address public _rewardPool = 0xEA6dEc98e137a87F78495a8386f7A137408f7722;
774 
775     uint256 public constant DURATION = 7 days;
776 
777     uint256 public _initReward = 2100000 * 1e18;
778     uint256 public _startTime =  now + 365 days;
779     uint256 public _periodFinish = 0;
780     uint256 public _rewardRate = 0;
781     uint256 public _lastUpdateTime;
782     uint256 public _rewardPerTokenStored;
783 
784     uint256 public _teamRewardRate = 500;
785     uint256 public _poolRewardRate = 1000;
786     uint256 public _baseRate = 10000;
787     uint256 public _punishTime = 3 days;
788 
789     mapping(address => uint256) public _userRewardPerTokenPaid;
790     mapping(address => uint256) public _rewards;
791     mapping(address => uint256) public _lastStakedTime;
792 
793     bool public _hasStart = false;
794 
795     event RewardAdded(uint256 reward);
796     event Staked(address indexed user, uint256 amount);
797     event Withdrawn(address indexed user, uint256 amount);
798     event RewardPaid(address indexed user, uint256 reward);
799 
800 
801     modifier updateReward(address account) {
802         _rewardPerTokenStored = rewardPerToken();
803         _lastUpdateTime = lastTimeRewardApplicable();
804         if (account != address(0)) {
805             _rewards[account] = earned(account);
806             _userRewardPerTokenPaid[account] = _rewardPerTokenStored;
807         }
808         _;
809     }
810 
811     /* Fee collection for any other token */
812     function seize(IERC20 token, uint256 amount) external onlyGovernance{
813         require(token != _dego, "reward");
814         require(token != _lpToken, "stake");
815         token.safeTransfer(_governance, amount);
816     }
817 
818     function setTeamRewardRate( uint256 teamRewardRate ) public onlyGovernance{
819         _teamRewardRate = teamRewardRate;
820     }
821 
822     function setPoolRewardRate( uint256  poolRewardRate ) public onlyGovernance{
823         _poolRewardRate = poolRewardRate;
824     }
825 
826     function setWithDrawPunishTime( uint256  punishTime ) public onlyGovernance{
827         _punishTime = punishTime;
828     }
829 
830     function lastTimeRewardApplicable() public view returns (uint256) {
831         return Math.min(block.timestamp, _periodFinish);
832     }
833 
834     function rewardPerToken() public view returns (uint256) {
835         if (totalPower() == 0) {
836             return _rewardPerTokenStored;
837         }
838         return
839             _rewardPerTokenStored.add(
840                 lastTimeRewardApplicable()
841                     .sub(_lastUpdateTime)
842                     .mul(_rewardRate)
843                     .mul(1e18)
844                     .div(totalPower())
845             );
846     }
847 
848     function earned(address account) public view returns (uint256) {
849         return
850             balanceOfPower(account)
851                 .mul(rewardPerToken().sub(_userRewardPerTokenPaid[account]))
852                 .div(1e18)
853                 .add(_rewards[account]);
854     }
855 
856     // stake visibility is public as overriding LPTokenWrapper's stake() function
857     function stake(uint256 amount, string memory affCode)
858         public
859         updateReward(msg.sender)
860         checkHalve
861         checkStart
862     {
863         require(amount > 0, "Cannot stake 0");
864         super.stake(amount, affCode);
865 
866         _lastStakedTime[msg.sender] = now;
867 
868         emit Staked(msg.sender, amount);
869     }
870 
871     function withdraw(uint256 amount)
872         public
873         updateReward(msg.sender)
874         checkHalve
875         checkStart
876     {
877         require(amount > 0, "Cannot withdraw 0");
878         super.withdraw(amount);
879         emit Withdrawn(msg.sender, amount);
880     }
881 
882     function exit() external {
883         withdraw(balanceOf(msg.sender));
884         getReward();
885     }
886 
887     function getReward() public updateReward(msg.sender) checkHalve checkStart {
888         uint256 reward = earned(msg.sender);
889         if (reward > 0) {
890             _rewards[msg.sender] = 0;
891 
892             uint256 fee = IPlayerBook(_playerBook).settleReward(msg.sender, reward);
893             if(fee > 0){
894                 _dego.safeTransfer(_playerBook, fee);
895             }
896             
897             uint256 teamReward = reward.mul(_teamRewardRate).div(_baseRate);
898             if(teamReward>0){
899                 _dego.safeTransfer(_teamWallet, teamReward);
900             }
901             uint256 leftReward = reward.sub(fee).sub(teamReward);
902             uint256 poolReward = 0;
903 
904             //withdraw time check
905 
906             if(now  < (_lastStakedTime[msg.sender] + _punishTime) ){
907                 poolReward = leftReward.mul(_poolRewardRate).div(_baseRate);
908             }
909             if(poolReward>0){
910                 _dego.safeTransfer(_rewardPool, poolReward);
911                 leftReward = leftReward.sub(poolReward);
912             }
913 
914             if(leftReward>0){
915                 _dego.safeTransfer(msg.sender, leftReward );
916             }
917       
918             emit RewardPaid(msg.sender, leftReward);
919         }
920     }
921 
922     modifier checkHalve() {
923         if (block.timestamp >= _periodFinish) {
924             _initReward = _initReward.mul(50).div(100);
925 
926             _dego.mint(address(this), _initReward);
927 
928             _rewardRate = _initReward.div(DURATION);
929             _periodFinish = block.timestamp.add(DURATION);
930             emit RewardAdded(_initReward);
931         }
932         _;
933     }
934     
935     modifier checkStart() {
936         require(block.timestamp > _startTime, "not start");
937         _;
938     }
939 
940     // set fix time to start reward
941     function startReward(uint256 startTime)
942         external
943         onlyGovernance
944         updateReward(address(0))
945     {
946         require(_hasStart == false, "has started");
947         _hasStart = true;
948         
949         _startTime = startTime;
950 
951         _rewardRate = _initReward.div(DURATION); 
952         _dego.mint(address(this), _initReward);
953 
954         _lastUpdateTime = _startTime;
955         _periodFinish = _startTime.add(DURATION);
956 
957         emit RewardAdded(_initReward);
958     }
959 
960     //
961 
962     //for extra reward
963     function notifyRewardAmount(uint256 reward)
964         external
965         onlyGovernance
966         updateReward(address(0))
967     {
968         IERC20(_dego).safeTransferFrom(msg.sender, address(this), reward);
969         if (block.timestamp >= _periodFinish) {
970             _rewardRate = reward.div(DURATION);
971         } else {
972             uint256 remaining = _periodFinish.sub(block.timestamp);
973             uint256 leftover = remaining.mul(_rewardRate);
974             _rewardRate = reward.add(leftover).div(DURATION);
975         }
976         _lastUpdateTime = block.timestamp;
977         _periodFinish = block.timestamp.add(DURATION);
978         emit RewardAdded(reward);
979     }
980 }
