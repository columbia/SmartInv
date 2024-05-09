1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         _owner = _msgSender();
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Returns true if the caller is the current owner.
74      */
75     function isOwner() public view returns (bool) {
76         return _msgSender() == _owner;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
110 
111 pragma solidity ^0.5.0;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
115  * the optional functions; to access them see {ERC20Detailed}.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through {transferFrom}. This is
140      * zero by default.
141      *
142      * This value changes when {approve} or {transferFrom} are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * IMPORTANT: Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 // File: @openzeppelin/contracts/math/SafeMath.sol
189 
190 pragma solidity ^0.5.0;
191 
192 /**
193  * @dev Wrappers over Solidity's arithmetic operations with added overflow
194  * checks.
195  *
196  * Arithmetic operations in Solidity wrap on overflow. This can easily result
197  * in bugs, because programmers usually assume that an overflow raises an
198  * error, which is the standard behavior in high level programming languages.
199  * `SafeMath` restores this intuition by reverting the transaction when an
200  * operation overflows.
201  *
202  * Using this library instead of the unchecked operations eliminates an entire
203  * class of bugs, so it's recommended to use it always.
204  */
205 library SafeMath {
206     /**
207      * @dev Returns the addition of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `+` operator.
211      *
212      * Requirements:
213      * - Addition cannot overflow.
214      */
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         uint256 c = a + b;
217         require(c >= a, "SafeMath: addition overflow");
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      * - Subtraction cannot overflow.
230      */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         return sub(a, b, "SafeMath: subtraction overflow");
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      * - Subtraction cannot overflow.
243      *
244      * _Available since v2.4.0._
245      */
246     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b <= a, errorMessage);
248         uint256 c = a - b;
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the multiplication of two unsigned integers, reverting on
255      * overflow.
256      *
257      * Counterpart to Solidity's `*` operator.
258      *
259      * Requirements:
260      * - Multiplication cannot overflow.
261      */
262     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
264         // benefit is lost if 'b' is also tested.
265         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
266         if (a == 0) {
267             return 0;
268         }
269 
270         uint256 c = a * b;
271         require(c / a == b, "SafeMath: multiplication overflow");
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers. Reverts on
278      * division by zero. The result is rounded towards zero.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      * - The divisor cannot be zero.
286      */
287     function div(uint256 a, uint256 b) internal pure returns (uint256) {
288         return div(a, b, "SafeMath: division by zero");
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      *
302      * _Available since v2.4.0._
303      */
304     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         // Solidity only automatically asserts when dividing by 0
306         require(b > 0, errorMessage);
307         uint256 c = a / b;
308         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * Reverts when dividing by zero.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      * - The divisor cannot be zero.
323      */
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         return mod(a, b, "SafeMath: modulo by zero");
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * Reverts with custom message when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      * - The divisor cannot be zero.
338      *
339      * _Available since v2.4.0._
340      */
341     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         require(b != 0, errorMessage);
343         return a % b;
344     }
345 }
346 
347 // File: @openzeppelin/contracts/utils/Address.sol
348 
349 pragma solidity ^0.5.5;
350 
351 /**
352  * @dev Collection of functions related to the address type
353  */
354 library Address {
355     /**
356      * @dev Returns true if `account` is a contract.
357      *
358      * This test is non-exhaustive, and there may be false-negatives: during the
359      * execution of a contract's constructor, its address will be reported as
360      * not containing a contract.
361      *
362      * IMPORTANT: It is unsafe to assume that an address for which this
363      * function returns false is an externally-owned account (EOA) and not a
364      * contract.
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies in extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
372         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
373         // for accounts without code, i.e. `keccak256('')`
374         bytes32 codehash;
375         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
376         // solhint-disable-next-line no-inline-assembly
377         assembly { codehash := extcodehash(account) }
378         return (codehash != 0x0 && codehash != accountHash);
379     }
380 
381     /**
382      * @dev Converts an `address` into `address payable`. Note that this is
383      * simply a type cast: the actual underlying value is not changed.
384      *
385      * _Available since v2.4.0._
386      */
387     function toPayable(address account) internal pure returns (address payable) {
388         return address(uint160(account));
389     }
390 
391     /**
392      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
393      * `recipient`, forwarding all available gas and reverting on errors.
394      *
395      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
396      * of certain opcodes, possibly making contracts go over the 2300 gas limit
397      * imposed by `transfer`, making them unable to receive funds via
398      * `transfer`. {sendValue} removes this limitation.
399      *
400      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
401      *
402      * IMPORTANT: because control is transferred to `recipient`, care must be
403      * taken to not create reentrancy vulnerabilities. Consider using
404      * {ReentrancyGuard} or the
405      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
406      *
407      * _Available since v2.4.0._
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(address(this).balance >= amount, "Address: insufficient balance");
411 
412         // solhint-disable-next-line avoid-call-value
413         (bool success, ) = recipient.call.value(amount)("");
414         require(success, "Address: unable to send value, recipient may have reverted");
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
419 
420 pragma solidity ^0.5.0;
421 
422 
423 
424 
425 /**
426  * @title SafeERC20
427  * @dev Wrappers around ERC20 operations that throw on failure (when the token
428  * contract returns false). Tokens that return no value (and instead revert or
429  * throw on failure) are also supported, non-reverting calls are assumed to be
430  * successful.
431  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
432  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
433  */
434 library SafeERC20 {
435     using SafeMath for uint256;
436     using Address for address;
437 
438     function safeTransfer(IERC20 token, address to, uint256 value) internal {
439         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
440     }
441 
442     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
443         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
444     }
445 
446     function safeApprove(IERC20 token, address spender, uint256 value) internal {
447         // safeApprove should only be called when setting an initial allowance,
448         // or when resetting it to zero. To increase and decrease it, use
449         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
450         // solhint-disable-next-line max-line-length
451         require((value == 0) || (token.allowance(address(this), spender) == 0),
452             "SafeERC20: approve from non-zero to non-zero allowance"
453         );
454         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
455     }
456 
457     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
458         uint256 newAllowance = token.allowance(address(this), spender).add(value);
459         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
460     }
461 
462     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
463         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
464         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
465     }
466 
467     /**
468      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
469      * on the return value: the return value is optional (but if data is returned, it must not be false).
470      * @param token The token targeted by the call.
471      * @param data The call data (encoded using abi.encode or one of its variants).
472      */
473     function callOptionalReturn(IERC20 token, bytes memory data) private {
474         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
475         // we're implementing it ourselves.
476 
477         // A Solidity high level call has three parts:
478         //  1. The target address is checked to verify it contains contract code
479         //  2. The call itself is made, and success asserted
480         //  3. The return value is decoded, which in turn checks the size of the returned data.
481         // solhint-disable-next-line max-line-length
482         require(address(token).isContract(), "SafeERC20: call to non-contract");
483 
484         // solhint-disable-next-line avoid-low-level-calls
485         (bool success, bytes memory returndata) = address(token).call(data);
486         require(success, "SafeERC20: low-level call failed");
487 
488         if (returndata.length > 0) { // Return data is optional
489             // solhint-disable-next-line max-line-length
490             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
491         }
492     }
493 }
494 
495 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
496 
497 pragma solidity ^0.5.0;
498 
499 /**
500  * @dev Contract module that helps prevent reentrant calls to a function.
501  *
502  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
503  * available, which can be applied to functions to make sure there are no nested
504  * (reentrant) calls to them.
505  *
506  * Note that because there is a single `nonReentrant` guard, functions marked as
507  * `nonReentrant` may not call one another. This can be worked around by making
508  * those functions `private`, and then adding `external` `nonReentrant` entry
509  * points to them.
510  */
511 contract ReentrancyGuard {
512     // counter to allow mutex lock with only one SSTORE operation
513     uint256 private _guardCounter;
514 
515     constructor () internal {
516         // The counter starts at one to prevent changing it from zero to a non-zero
517         // value, which is a more expensive operation.
518         _guardCounter = 1;
519     }
520 
521     /**
522      * @dev Prevents a contract from calling itself, directly or indirectly.
523      * Calling a `nonReentrant` function from another `nonReentrant`
524      * function is not supported. It is possible to prevent this from happening
525      * by making the `nonReentrant` function external, and make it call a
526      * `private` function that does the actual work.
527      */
528     modifier nonReentrant() {
529         _guardCounter += 1;
530         uint256 localCounter = _guardCounter;
531         _;
532         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
533     }
534 }
535 
536 // File: contracts/protocol/interfaces/IWETH.sol
537 
538 /*
539  * Copyright 2020 DMM Foundation
540  *
541  * Licensed under the Apache License, Version 2.0 (the "License");
542  * you may not use this file except in compliance with the License.
543  * You may obtain a copy of the License at
544  *
545  * http://www.apache.org/licenses/LICENSE-2.0
546  *
547  * Unless required by applicable law or agreed to in writing, software
548  * distributed under the License is distributed on an "AS IS" BASIS,
549  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
550  * See the License for the specific language governing permissions and
551  * limitations under the License.
552  */
553 
554 
555 pragma solidity ^0.5.0;
556 
557 interface IWETH {
558 
559     function deposit() external payable;
560 
561     function withdraw(uint wad) external;
562 
563 }
564 
565 // File: contracts/utils/AddressUtil.sol
566 
567 /*
568 
569   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
570 
571   Licensed under the Apache License, Version 2.0 (the "License");
572   you may not use this file except in compliance with the License.
573   You may obtain a copy of the License at
574 
575   http://www.apache.org/licenses/LICENSE-2.0
576 
577   Unless required by applicable law or agreed to in writing, software
578   distributed under the License is distributed on an "AS IS" BASIS,
579   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
580   See the License for the specific language governing permissions and
581   limitations under the License.
582 */
583 
584 
585 pragma solidity ^0.5.11;
586 
587 
588 /// @title Utility Functions for addresses
589 /// @author Daniel Wang - <daniel@loopring.org>
590 /// @author Brecht Devos - <brecht@loopring.org>
591 library AddressUtil
592 {
593     using AddressUtil for *;
594 
595     function isContract(
596         address addr
597     )
598     internal
599     view
600     returns (bool)
601     {
602         uint32 size;
603         assembly {size := extcodesize(addr)}
604         return (size > 0);
605     }
606 
607     function toPayable(
608         address addr
609     )
610     internal
611     pure
612     returns (address payable)
613     {
614         return address(uint160(addr));
615     }
616 
617     // Works like address.send but with a customizable gas limit
618     // Make sure your code is safe for reentrancy when using this function!
619     function sendETH(
620         address to,
621         uint amount
622     )
623     internal
624     returns (bool success) {
625         if (amount == 0) {
626             return true;
627         }
628 
629         address payable recipient = to.toPayable();
630         require(address(this).balance >= amount, "AddressUtil::sendETH: INSUFFICIENT_BALANCE");
631 
632         /* solium-disable-next-line */
633         (success,) = recipient.call.value(amount)("");
634     }
635 
636     // Works like address.transfer but with a customizable gas limit
637     // Make sure your code is safe for reentrancy when using this function!
638     function sendETHAndVerify(
639         address to,
640         uint amount
641     )
642     internal
643     returns (bool success)
644     {
645         success = to.sendETH(amount);
646         require(success, "TRANSFER_FAILURE");
647     }
648 }
649 
650 // File: contracts/external/uniswap/interfaces/IUniswapV2Pair.sol
651 
652 pragma solidity ^0.5.0;
653 
654 interface IUniswapV2Pair {
655 
656     event Approval(address indexed owner, address indexed spender, uint value);
657     event Transfer(address indexed from, address indexed to, uint value);
658 
659     function name() external pure returns (string memory);
660 
661     function symbol() external pure returns (string memory);
662 
663     function decimals() external pure returns (uint8);
664 
665     function totalSupply() external view returns (uint);
666 
667     function balanceOf(address owner) external view returns (uint);
668 
669     function allowance(address owner, address spender) external view returns (uint);
670 
671     function approve(address spender, uint value) external returns (bool);
672 
673     function transfer(address to, uint value) external returns (bool);
674 
675     function transferFrom(address from, address to, uint value) external returns (bool);
676 
677     function DOMAIN_SEPARATOR() external view returns (bytes32);
678 
679     function PERMIT_TYPEHASH() external pure returns (bytes32);
680 
681     function nonces(address owner) external view returns (uint);
682 
683     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
684 
685     event Mint(address indexed sender, uint amount0, uint amount1);
686     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
687     event Swap(
688         address indexed sender,
689         uint amount0In,
690         uint amount1In,
691         uint amount0Out,
692         uint amount1Out,
693         address indexed to
694     );
695     event Sync(uint112 reserve0, uint112 reserve1);
696 
697     function MINIMUM_LIQUIDITY() external pure returns (uint);
698 
699     function factory() external view returns (address);
700 
701     function token0() external view returns (address);
702 
703     function token1() external view returns (address);
704 
705     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
706 
707     function price0CumulativeLast() external view returns (uint);
708 
709     function price1CumulativeLast() external view returns (uint);
710 
711     function kLast() external view returns (uint);
712 
713     function mint(address to) external returns (uint liquidity);
714 
715     function burn(address to) external returns (uint amount0, uint amount1);
716 
717     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
718 
719     function skim(address to) external;
720 
721     function sync() external;
722 
723     function initialize(address, address) external;
724 
725 }
726 
727 // File: contracts/external/uniswap/libs/UniswapV2Library.sol
728 
729 pragma solidity ^0.5.0;
730 
731 
732 
733 library UniswapV2Library {
734 
735     using SafeMath for uint;
736 
737     // returns sorted token addresses, used to handle return values from pairs sorted in this order
738     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
739         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
740         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
741         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
742     }
743 
744     // calculates the CREATE2 address for a pair without making any external calls
745     function pairFor(address factory, address tokenA, address tokenB, bytes32 initCodeHash) internal pure returns (address pair) {
746         (address token0, address token1) = sortTokens(tokenA, tokenB);
747         pair = address(uint(keccak256(abi.encodePacked(
748                 hex'ff',
749                 factory,
750                 keccak256(abi.encodePacked(token0, token1)),
751             // Taken from the UniswapV2Pair.json "bytecode" field
752             //                keccak256(hex'60806040526001600c5534801561001557600080fd5b5060405146908060526123868239604080519182900360520182208282018252600a8352692ab734b9bbb0b8102b1960b11b6020938401528151808301835260018152603160f81b908401528151808401919091527fbfcc8ef98ffbf7b6c3fec7bf5185b566b9863e35a9d83acd49ad6824b5969738818301527fc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6606082015260808101949094523060a0808601919091528151808603909101815260c09094019052825192019190912060035550600580546001600160a01b03191633179055612281806101056000396000f3fe608060405234801561001057600080fd5b50600436106101a95760003560e01c80636a627842116100f9578063ba9a7a5611610097578063d21220a711610071578063d21220a714610534578063d505accf1461053c578063dd62ed3e1461058d578063fff6cae9146105bb576101a9565b8063ba9a7a56146104fe578063bc25cf7714610506578063c45a01551461052c576101a9565b80637ecebe00116100d35780637ecebe001461046557806389afcb441461048b57806395d89b41146104ca578063a9059cbb146104d2576101a9565b80636a6278421461041157806370a08231146104375780637464fc3d1461045d576101a9565b806323b872dd116101665780633644e515116101405780633644e515146103cb578063485cc955146103d35780635909c0d5146104015780635a3d549314610409576101a9565b806323b872dd1461036f57806330adf81f146103a5578063313ce567146103ad576101a9565b8063022c0d9f146101ae57806306fdde031461023c5780630902f1ac146102b9578063095ea7b3146102f15780630dfe16811461033157806318160ddd14610355575b600080fd5b61023a600480360360808110156101c457600080fd5b8135916020810135916001600160a01b0360408301351691908101906080810160608201356401000000008111156101fb57600080fd5b82018360208201111561020d57600080fd5b8035906020019184600183028401116401000000008311171561022f57600080fd5b5090925090506105c3565b005b610244610afe565b6040805160208082528351818301528351919283929083019185019080838360005b8381101561027e578181015183820152602001610266565b50505050905090810190601f1680156102ab5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b6102c1610b24565b604080516001600160701b03948516815292909316602083015263ffffffff168183015290519081900360600190f35b61031d6004803603604081101561030757600080fd5b506001600160a01b038135169060200135610b4e565b604080519115158252519081900360200190f35b610339610b65565b604080516001600160a01b039092168252519081900360200190f35b61035d610b74565b60408051918252519081900360200190f35b61031d6004803603606081101561038557600080fd5b506001600160a01b03813581169160208101359091169060400135610b7a565b61035d610c14565b6103b5610c38565b6040805160ff9092168252519081900360200190f35b61035d610c3d565b61023a600480360360408110156103e957600080fd5b506001600160a01b0381358116916020013516610c43565b61035d610cc7565b61035d610ccd565b61035d6004803603602081101561042757600080fd5b50356001600160a01b0316610cd3565b61035d6004803603602081101561044d57600080fd5b50356001600160a01b0316610fd3565b61035d610fe5565b61035d6004803603602081101561047b57600080fd5b50356001600160a01b0316610feb565b6104b1600480360360208110156104a157600080fd5b50356001600160a01b0316610ffd565b6040805192835260208301919091528051918290030190f35b6102446113a3565b61031d600480360360408110156104e857600080fd5b506001600160a01b0381351690602001356113c5565b61035d6113d2565b61023a6004803603602081101561051c57600080fd5b50356001600160a01b03166113d8565b610339611543565b610339611552565b61023a600480360360e081101561055257600080fd5b506001600160a01b03813581169160208101359091169060408101359060608101359060ff6080820135169060a08101359060c00135611561565b61035d600480360360408110156105a357600080fd5b506001600160a01b0381358116916020013516611763565b61023a611780565b600c5460011461060e576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c55841515806106215750600084115b61065c5760405162461bcd60e51b81526004018080602001828103825260258152602001806121936025913960400191505060405180910390fd5b600080610667610b24565b5091509150816001600160701b03168710801561068c5750806001600160701b031686105b6106c75760405162461bcd60e51b81526004018080602001828103825260218152602001806121dc6021913960400191505060405180910390fd5b60065460075460009182916001600160a01b039182169190811690891682148015906107055750806001600160a01b0316896001600160a01b031614155b61074e576040805162461bcd60e51b8152602060048201526015602482015274556e697377617056323a20494e56414c49445f544f60581b604482015290519081900360640190fd5b8a1561075f5761075f828a8d6118e2565b891561077057610770818a8c6118e2565b861561082b57886001600160a01b03166310d1e85c338d8d8c8c6040518663ffffffff1660e01b815260040180866001600160a01b03166001600160a01b03168152602001858152602001848152602001806020018281038252848482818152602001925080828437600081840152601f19601f8201169050808301925050509650505050505050600060405180830381600087803b15801561081257600080fd5b505af1158015610826573d6000803e3d6000fd5b505050505b604080516370a0823160e01b815230600482015290516001600160a01b038416916370a08231916024808301926020929190829003018186803b15801561087157600080fd5b505afa158015610885573d6000803e3d6000fd5b505050506040513d602081101561089b57600080fd5b5051604080516370a0823160e01b815230600482015290519195506001600160a01b038316916370a0823191602480820192602092909190829003018186803b1580156108e757600080fd5b505afa1580156108fb573d6000803e3d6000fd5b505050506040513d602081101561091157600080fd5b5051925060009150506001600160701b0385168a90038311610934576000610943565b89856001600160701b03160383035b9050600089856001600160701b031603831161096057600061096f565b89856001600160701b03160383035b905060008211806109805750600081115b6109bb5760405162461bcd60e51b81526004018080602001828103825260248152602001806121b86024913960400191505060405180910390fd5b60006109ef6109d184600363ffffffff611a7c16565b6109e3876103e863ffffffff611a7c16565b9063ffffffff611adf16565b90506000610a076109d184600363ffffffff611a7c16565b9050610a38620f4240610a2c6001600160701b038b8116908b1663ffffffff611a7c16565b9063ffffffff611a7c16565b610a48838363ffffffff611a7c16565b1015610a8a576040805162461bcd60e51b815260206004820152600c60248201526b556e697377617056323a204b60a01b604482015290519081900360640190fd5b5050610a9884848888611b2f565b60408051838152602081018390528082018d9052606081018c905290516001600160a01b038b169133917fd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d8229181900360800190a350506001600c55505050505050505050565b6040518060400160405280600a8152602001692ab734b9bbb0b8102b1960b11b81525081565b6008546001600160701b0380821692600160701b830490911691600160e01b900463ffffffff1690565b6000610b5b338484611cf4565b5060015b92915050565b6006546001600160a01b031681565b60005481565b6001600160a01b038316600090815260026020908152604080832033845290915281205460001914610bff576001600160a01b0384166000908152600260209081526040808320338452909152902054610bda908363ffffffff611adf16565b6001600160a01b03851660009081526002602090815260408083203384529091529020555b610c0a848484611d56565b5060019392505050565b7f6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c981565b601281565b60035481565b6005546001600160a01b03163314610c99576040805162461bcd60e51b81526020600482015260146024820152732ab734b9bbb0b82b191d102327a92124a22222a760611b604482015290519081900360640190fd5b600680546001600160a01b039384166001600160a01b03199182161790915560078054929093169116179055565b60095481565b600a5481565b6000600c54600114610d20576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c81905580610d30610b24565b50600654604080516370a0823160e01b815230600482015290519395509193506000926001600160a01b03909116916370a08231916024808301926020929190829003018186803b158015610d8457600080fd5b505afa158015610d98573d6000803e3d6000fd5b505050506040513d6020811015610dae57600080fd5b5051600754604080516370a0823160e01b815230600482015290519293506000926001600160a01b03909216916370a0823191602480820192602092909190829003018186803b158015610e0157600080fd5b505afa158015610e15573d6000803e3d6000fd5b505050506040513d6020811015610e2b57600080fd5b505190506000610e4a836001600160701b03871663ffffffff611adf16565b90506000610e67836001600160701b03871663ffffffff611adf16565b90506000610e758787611e10565b60005490915080610eb257610e9e6103e86109e3610e99878763ffffffff611a7c16565b611f6e565b9850610ead60006103e8611fc0565b610f01565b610efe6001600160701b038916610ecf868463ffffffff611a7c16565b81610ed657fe5b046001600160701b038916610ef1868563ffffffff611a7c16565b81610ef857fe5b04612056565b98505b60008911610f405760405162461bcd60e51b81526004018080602001828103825260288152602001806122256028913960400191505060405180910390fd5b610f4a8a8a611fc0565b610f5686868a8a611b2f565b8115610f8657600854610f82906001600160701b0380821691600160701b90041663ffffffff611a7c16565b600b555b6040805185815260208101859052815133927f4c209b5fc8ad50758f13e2e1088ba56a560dff690a1c6fef26394f4c03821c4f928290030190a250506001600c5550949695505050505050565b60016020526000908152604090205481565b600b5481565b60046020526000908152604090205481565b600080600c5460011461104b576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c8190558061105b610b24565b50600654600754604080516370a0823160e01b815230600482015290519496509294506001600160a01b039182169391169160009184916370a08231916024808301926020929190829003018186803b1580156110b757600080fd5b505afa1580156110cb573d6000803e3d6000fd5b505050506040513d60208110156110e157600080fd5b5051604080516370a0823160e01b815230600482015290519192506000916001600160a01b038516916370a08231916024808301926020929190829003018186803b15801561112f57600080fd5b505afa158015611143573d6000803e3d6000fd5b505050506040513d602081101561115957600080fd5b5051306000908152600160205260408120549192506111788888611e10565b6000549091508061118f848763ffffffff611a7c16565b8161119657fe5b049a50806111aa848663ffffffff611a7c16565b816111b157fe5b04995060008b1180156111c4575060008a115b6111ff5760405162461bcd60e51b81526004018080602001828103825260288152602001806121fd6028913960400191505060405180910390fd5b611209308461206e565b611214878d8d6118e2565b61121f868d8c6118e2565b604080516370a0823160e01b815230600482015290516001600160a01b038916916370a08231916024808301926020929190829003018186803b15801561126557600080fd5b505afa158015611279573d6000803e3d6000fd5b505050506040513d602081101561128f57600080fd5b5051604080516370a0823160e01b815230600482015290519196506001600160a01b038816916370a0823191602480820192602092909190829003018186803b1580156112db57600080fd5b505afa1580156112ef573d6000803e3d6000fd5b505050506040513d602081101561130557600080fd5b5051935061131585858b8b611b2f565b811561134557600854611341906001600160701b0380821691600160701b90041663ffffffff611a7c16565b600b555b604080518c8152602081018c905281516001600160a01b038f169233927fdccd412f0b1252819cb1fd330b93224ca42612892bb3f4f789976e6d81936496929081900390910190a35050505050505050506001600c81905550915091565b604051806040016040528060068152602001652aa72496ab1960d11b81525081565b6000610b5b338484611d56565b6103e881565b600c54600114611423576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c55600654600754600854604080516370a0823160e01b815230600482015290516001600160a01b0394851694909316926114d292859287926114cd926001600160701b03169185916370a0823191602480820192602092909190829003018186803b15801561149557600080fd5b505afa1580156114a9573d6000803e3d6000fd5b505050506040513d60208110156114bf57600080fd5b50519063ffffffff611adf16565b6118e2565b600854604080516370a0823160e01b8152306004820152905161153992849287926114cd92600160701b90046001600160701b0316916001600160a01b038616916370a0823191602480820192602092909190829003018186803b15801561149557600080fd5b50506001600c5550565b6005546001600160a01b031681565b6007546001600160a01b031681565b428410156115ab576040805162461bcd60e51b8152602060048201526012602482015271155b9a5cddd85c158c8e881156141254915160721b604482015290519081900360640190fd5b6003546001600160a01b0380891660008181526004602090815260408083208054600180820190925582517f6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c98186015280840196909652958d166060860152608085018c905260a085019590955260c08085018b90528151808603909101815260e08501825280519083012061190160f01b6101008601526101028501969096526101228085019690965280518085039096018652610142840180825286519683019690962095839052610162840180825286905260ff89166101828501526101a284018890526101c28401879052519193926101e280820193601f1981019281900390910190855afa1580156116c6573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b038116158015906116fc5750886001600160a01b0316816001600160a01b0316145b61174d576040805162461bcd60e51b815260206004820152601c60248201527f556e697377617056323a20494e56414c49445f5349474e415455524500000000604482015290519081900360640190fd5b611758898989611cf4565b505050505050505050565b600260209081526000928352604080842090915290825290205481565b600c546001146117cb576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c55600654604080516370a0823160e01b815230600482015290516118db926001600160a01b0316916370a08231916024808301926020929190829003018186803b15801561181c57600080fd5b505afa158015611830573d6000803e3d6000fd5b505050506040513d602081101561184657600080fd5b5051600754604080516370a0823160e01b815230600482015290516001600160a01b03909216916370a0823191602480820192602092909190829003018186803b15801561189357600080fd5b505afa1580156118a7573d6000803e3d6000fd5b505050506040513d60208110156118bd57600080fd5b50516008546001600160701b0380821691600160701b900416611b2f565b6001600c55565b604080518082018252601981527f7472616e7366657228616464726573732c75696e74323536290000000000000060209182015281516001600160a01b0385811660248301526044808301869052845180840390910181526064909201845291810180516001600160e01b031663a9059cbb60e01b1781529251815160009460609489169392918291908083835b6020831061198f5780518252601f199092019160209182019101611970565b6001836020036101000a0380198251168184511680821785525050505050509050019150506000604051808303816000865af19150503d80600081146119f1576040519150601f19603f3d011682016040523d82523d6000602084013e6119f6565b606091505b5091509150818015611a24575080511580611a245750808060200190516020811015611a2157600080fd5b50515b611a75576040805162461bcd60e51b815260206004820152601a60248201527f556e697377617056323a205452414e534645525f4641494c4544000000000000604482015290519081900360640190fd5b5050505050565b6000811580611a9757505080820282828281611a9457fe5b04145b610b5f576040805162461bcd60e51b815260206004820152601460248201527364732d6d6174682d6d756c2d6f766572666c6f7760601b604482015290519081900360640190fd5b80820382811115610b5f576040805162461bcd60e51b815260206004820152601560248201527464732d6d6174682d7375622d756e646572666c6f7760581b604482015290519081900360640190fd5b6001600160701b038411801590611b4d57506001600160701b038311155b611b94576040805162461bcd60e51b8152602060048201526013602482015272556e697377617056323a204f564552464c4f5760681b604482015290519081900360640190fd5b60085463ffffffff42811691600160e01b90048116820390811615801590611bc457506001600160701b03841615155b8015611bd857506001600160701b03831615155b15611c49578063ffffffff16611c0685611bf18661210c565b6001600160e01b03169063ffffffff61211e16565b600980546001600160e01b03929092169290920201905563ffffffff8116611c3184611bf18761210c565b600a80546001600160e01b0392909216929092020190555b600880546dffffffffffffffffffffffffffff19166001600160701b03888116919091176dffffffffffffffffffffffffffff60701b1916600160701b8883168102919091176001600160e01b0316600160e01b63ffffffff871602179283905560408051848416815291909304909116602082015281517f1c411e9a96e071241c2f21f7726b17ae89e3cab4c78be50e062b03a9fffbbad1929181900390910190a1505050505050565b6001600160a01b03808416600081815260026020908152604080832094871680845294825291829020859055815185815291517f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b9259281900390910190a3505050565b6001600160a01b038316600090815260016020526040902054611d7f908263ffffffff611adf16565b6001600160a01b038085166000908152600160205260408082209390935590841681522054611db4908263ffffffff61214316565b6001600160a01b0380841660008181526001602090815260409182902094909455805185815290519193928716927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef92918290030190a3505050565b600080600560009054906101000a90046001600160a01b03166001600160a01b031663017e7e586040518163ffffffff1660e01b815260040160206040518083038186803b158015611e6157600080fd5b505afa158015611e75573d6000803e3d6000fd5b505050506040513d6020811015611e8b57600080fd5b5051600b546001600160a01b038216158015945091925090611f5a578015611f55576000611ece610e996001600160701b0388811690881663ffffffff611a7c16565b90506000611edb83611f6e565b905080821115611f52576000611f09611efa848463ffffffff611adf16565b6000549063ffffffff611a7c16565b90506000611f2e83611f2286600563ffffffff611a7c16565b9063ffffffff61214316565b90506000818381611f3b57fe5b0490508015611f4e57611f4e8782611fc0565b5050505b50505b611f66565b8015611f66576000600b555b505092915050565b60006003821115611fb1575080600160028204015b81811015611fab57809150600281828581611f9a57fe5b040181611fa357fe5b049050611f83565b50611fbb565b8115611fbb575060015b919050565b600054611fd3908263ffffffff61214316565b60009081556001600160a01b038316815260016020526040902054611ffe908263ffffffff61214316565b6001600160a01b03831660008181526001602090815260408083209490945583518581529351929391927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9281900390910190a35050565b60008183106120655781612067565b825b9392505050565b6001600160a01b038216600090815260016020526040902054612097908263ffffffff611adf16565b6001600160a01b038316600090815260016020526040812091909155546120c4908263ffffffff611adf16565b60009081556040805183815290516001600160a01b038516917fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef919081900360200190a35050565b6001600160701b0316600160701b0290565b60006001600160701b0382166001600160e01b0384168161213b57fe5b049392505050565b80820182811015610b5f576040805162461bcd60e51b815260206004820152601460248201527364732d6d6174682d6164642d6f766572666c6f7760601b604482015290519081900360640190fdfe556e697377617056323a20494e53554646494349454e545f4f55545055545f414d4f554e54556e697377617056323a20494e53554646494349454e545f494e5055545f414d4f554e54556e697377617056323a20494e53554646494349454e545f4c4951554944495459556e697377617056323a20494e53554646494349454e545f4c49515549444954595f4255524e4544556e697377617056323a20494e53554646494349454e545f4c49515549444954595f4d494e544544a265627a7a7231582082fba8557d35ae5eca98219a61e967d398ed8eaafeafa5fe5af73dd6aad9ddfd64736f6c63430005100032454950373132446f6d61696e28737472696e67206e616d652c737472696e672076657273696f6e2c75696e7432353620636861696e49642c6164647265737320766572696679696e67436f6e747261637429') // init code hash
753                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
754             ))));
755     }
756 
757     // fetches and sorts the reserves for a pair
758     function getReserves(address factory, address tokenA, address tokenB, bytes32 initCodeHash) internal view returns (uint reserveA, uint reserveB) {
759         (address token0,) = sortTokens(tokenA, tokenB);
760         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB, initCodeHash)).getReserves();
761         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
762     }
763 
764     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
765     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
766         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
767         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
768         amountB = amountA.mul(reserveB) / reserveA;
769     }
770 
771     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
772     function getAmountOut(
773         uint amountIn,
774         uint reserveIn,
775         uint reserveOut
776     ) internal pure returns (uint amountOut) {
777         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
778         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
779         uint amountInWithFee = amountIn.mul(997);
780         uint numerator = amountInWithFee.mul(reserveOut);
781         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
782         amountOut = numerator / denominator;
783     }
784 
785     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
786     function getAmountIn(
787         uint amountOut,
788         uint reserveIn,
789         uint reserveOut
790     ) internal pure returns (uint amountIn) {
791         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
792         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
793         uint numerator = reserveIn.mul(amountOut).mul(1000);
794         uint denominator = reserveOut.sub(amountOut).mul(997);
795         amountIn = (numerator / denominator).add(1);
796     }
797 
798     // performs chained getAmountOut calculations on any number of pairs
799     function getAmountsOut(
800         address factory,
801         uint amountIn,
802         address[] memory path,
803         bytes32 initCodeHash
804     ) internal view returns (uint[] memory amounts) {
805         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
806         amounts = new uint[](path.length);
807         amounts[0] = amountIn;
808         for (uint i; i < path.length - 1; i++) {
809             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1], initCodeHash);
810             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
811         }
812     }
813 
814     // performs chained getAmountIn calculations on any number of pairs
815     function getAmountsIn(
816         address factory,
817         uint amountOut,
818         address[] memory path,
819         bytes32 initCodeHash
820     ) internal view returns (uint[] memory amounts) {
821         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
822         amounts = new uint[](path.length);
823         amounts[amounts.length - 1] = amountOut;
824         for (uint i = path.length - 1; i > 0; i--) {
825             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i], initCodeHash);
826             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
827         }
828     }
829 }
830 
831 // File: contracts/external/farming/v1/IDMGYieldFarmingV1.sol
832 
833 /*
834  * Copyright 2020 DMM Foundation
835  *
836  * Licensed under the Apache License, Version 2.0 (the "License");
837  * you may not use this file except in compliance with the License.
838  * You may obtain a copy of the License at
839  *
840  * http://www.apache.org/licenses/LICENSE-2.0
841  *
842  * Unless required by applicable law or agreed to in writing, software
843  * distributed under the License is distributed on an "AS IS" BASIS,
844  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
845  * See the License for the specific language governing permissions and
846  * limitations under the License.
847  */
848 
849 
850 pragma solidity ^0.5.0;
851 
852 /**
853  * The interface for DMG "Yield Farming" - A process through which users may earn DMG by locking up their mTokens in
854  * Uniswap pools, and staking the Uniswap pool's equity token in this contract.
855  *
856  * Yield farming in the DMM Ecosystem entails "rotation periods" in which a season is active, in order to incentivize
857  * deposits of underlying tokens into the protocol.
858  */
859 interface IDMGYieldFarmingV1 {
860 
861     // ////////////////////
862     // Events
863     // ////////////////////
864 
865     event GlobalProxySet(address indexed proxy, bool isTrusted);
866 
867     event TokenAdded(address indexed token, address indexed underlyingToken, uint8 underlyingTokenDecimals, uint16 points);
868     event TokenRemoved(address indexed token);
869 
870     event FarmSeasonBegun(uint indexed seasonIndex, uint dmgAmount);
871     event FarmSeasonEnd(uint indexed seasonIndex, address dustRecipient, uint dustyDmgAmount);
872 
873     event DmgGrowthCoefficientSet(uint coefficient);
874     event RewardPointsSet(address indexed token, uint16 points);
875 
876     event Approval(address indexed user, address indexed spender, bool isTrusted);
877 
878     event BeginFarming(address indexed owner, address indexed token, uint depositedAmount);
879     event EndFarming(address indexed owner, address indexed token, uint withdrawnAmount, uint earnedDmgAmount);
880 
881     event WithdrawOutOfSeason(address indexed owner, address indexed token, address indexed recipient, uint amount);
882 
883     // ////////////////////
884     // Admin Functions
885     // ////////////////////
886 
887     /**
888      * Sets the `proxy` as a trusted contract, allowing it to interact with the user, on the user's behalf.
889      *
890      * @param proxy     The address that can interact on the user's behalf.
891      * @param isTrusted True if the proxy is trusted or false if it's not (should be removed).
892      */
893     function approveGloballyTrustedProxy(address proxy, bool isTrusted) external;
894 
895     /**
896      * @return  true if the provided `proxy` is globally trusted and may interact with the yield farming contract on a
897      *          user's behalf or false otherwise.
898      */
899     function isGloballyTrustedProxy(address proxy) external view returns (bool);
900 
901     /**
902      * @param token                     The address of the token to be supported for farming.
903      * @param underlyingToken           The token to which this token is pegged. IE a Uniswap-V2 LP equity token for
904      *                                  DAI-mDAI has an underlying token of DAI.
905      * @param underlyingTokenDecimals   The number of decimals that the `underlyingToken` has.
906      * @param points                    The amount of reward points for the provided token.
907      */
908     function addAllowableToken(address token, address underlyingToken, uint8 underlyingTokenDecimals, uint16 points) external;
909 
910     /**
911      * @param token     The address of the token that will be removed from farming.
912      */
913     function removeAllowableToken(address token) external;
914 
915     /**
916      * Changes the reward points for the provided token. Reward points are a weighting system that enables certain
917      * tokens to accrue DMG faster than others, allowing the protocol to prioritize certain deposits.
918      */
919     function setRewardPointsByToken(address token, uint16 points) external;
920 
921     /**
922      * Sets the DMG growth coefficient to use the new parameter provided. This variable is used to define how much
923      * DMG is earned every second, for each point accrued.
924      */
925     function setDmgGrowthCoefficient(uint dmgGrowthCoefficient) external;
926 
927     /**
928      * Begins the farming process so users that accumulate DMG by locking tokens can start for this rotation. Calling
929      * this function increments the currentSeasonIndex, starting a new season. This function reverts if there is
930      * already an active season.
931      *
932      * @param dmgAmount The amount of DMG that will be used to fund this campaign.
933      */
934     function beginFarmingSeason(uint dmgAmount) external;
935 
936     /**
937      * Ends the active farming process if the admin calls this function. Otherwise, anyone may call this function once
938      * all DMG have been drained from the contract.
939      *
940      * @param dustRecipient The recipient of any leftover DMG in this contract, when the campaign finishes.
941      */
942     function endActiveFarmingSeason(address dustRecipient) external;
943 
944     // ////////////////////
945     // Misc Functions
946     // ////////////////////
947 
948     /**
949      * @return  The tokens that the farm supports.
950      */
951     function getFarmTokens() external view returns (address[] memory);
952 
953     /**
954      * @return  True if the provided token is supported for farming, or false if it's not.
955      */
956     function isSupportedToken(address token) external view returns (bool);
957 
958     /**
959      * @return  True if there is an active season for farming, or false if there isn't one.
960      */
961     function isFarmActive() external view returns (bool);
962 
963     /**
964      * The address that acts as a "secondary" owner with quicker access to function calling than the owner. Typically,
965      * this is the DMMF.
966      */
967     function guardian() external view returns (address);
968 
969     /**
970      * @return The DMG token.
971      */
972     function dmgToken() external view returns (address);
973 
974     /**
975      * @return  The growth coefficient for earning DMG while farming. Each unit represents how much DMG is earned per
976      *          point
977      */
978     function dmgGrowthCoefficient() external view returns (uint);
979 
980     /**
981      * @return  The amount of points that the provided token earns for each unit of token deposited. Defaults to `1`
982      *          if the provided `token` does not exist or does not have a special weight. This number is `2` decimals.
983      */
984     function getRewardPointsByToken(address token) external view returns (uint16);
985 
986     /**
987      * @return  The number of decimals that the underlying token has.
988      */
989     function getTokenDecimalsByToken(address token) external view returns (uint8);
990 
991     /**
992      * @return  The index into the array returned from `getFarmTokens`, plus 1. 0 if the token isn't found. If the
993      *          index returned is non-zero, subtract 1 from it to get the real index into the array.
994      */
995     function getTokenIndexPlusOneByToken(address token) external view returns (uint);
996 
997     // ////////////////////
998     // User Functions
999     // ////////////////////
1000 
1001     /**
1002      * Approves the spender from `msg.sender` to transfer funds into the contract on the user's behalf. If `isTrusted`
1003      * is marked as false, removes the spender.
1004      */
1005     function approve(address spender, bool isTrusted) external;
1006 
1007     /**
1008      * True if the `spender` can transfer tokens on the user's behalf to this contract.
1009      */
1010     function isApproved(address user, address spender) external view returns (bool);
1011 
1012     /**
1013      * Begins a farm by transferring `amount` of `token` from `user` to this contract and adds it to the balance of
1014      * `user`. `user` must be either 1) msg.sender or 2) a wallet who has approved msg.sender as a proxy; else this
1015      * function reverts. `funder` must fit into the same criteria as `user`; else this function reverts
1016      */
1017     function beginFarming(address user, address funder, address token, uint amount) external;
1018 
1019     /**
1020      * Ends a farm by transferring all of `token` deposited by `from` to `recipient`, from this contract, as well as
1021      * all earned DMG for farming `token` to `recipient`. `from` must be either 1) msg.sender or 2) an approved
1022      * proxy; else this function reverts.
1023      *
1024      * @return  The amount of `token` withdrawn and the amount of DMG earned for farming. Both values are sent to
1025      *          `recipient`.
1026      */
1027     function endFarmingByToken(address from, address recipient, address token) external returns (uint, uint);
1028 
1029     /**
1030      * Withdraws all of `msg.sender`'s tokens from the farm to `recipient`. This function reverts if there is an active
1031      * farm. `user` must be either 1) msg.sender or 2) an approved proxy; else this function reverts.
1032      */
1033     function withdrawAllWhenOutOfSeason(address user, address recipient) external;
1034 
1035     /**
1036      * Withdraws all of `user` `token` from the farm to `recipient`. This function reverts if there is an active farm and the token is NOT removed.
1037      * `user` must be either 1) msg.sender or 2) an approved proxy; else this function reverts.
1038      *
1039      * @return The amount of tokens sent to `recipient`
1040      */
1041     function withdrawByTokenWhenOutOfSeason(
1042         address user,
1043         address recipient,
1044         address token
1045     ) external returns (uint);
1046 
1047     /**
1048      * @return  The amount of DMG that this owner has earned in the active farm. If there are no active season, this
1049      *          function returns `0`.
1050      */
1051     function getRewardBalanceByOwner(address owner) external view returns (uint);
1052 
1053     /**
1054      * @return  The amount of DMG that this owner has earned in the active farm for the provided token. If there is no
1055      *          active season, this function returns `0`.
1056      */
1057     function getRewardBalanceByOwnerAndToken(address owner, address token) external view returns (uint);
1058 
1059     /**
1060      * @return  The amount of `token` that this owner has deposited into this contract. The user may withdraw this
1061      *          non-zero balance by invoking `endFarming` or `endFarmingByToken` if there is an active farm. If there is
1062      *          NO active farm, the user may withdraw his/her funds by invoking
1063      */
1064     function balanceOf(address owner, address token) external view returns (uint);
1065 
1066     /**
1067      * @return  The most recent timestamp at which the `owner` deposited `token` into the yield farming contract for
1068      *          the current season. If there is no active season, this function returns `0`.
1069      */
1070     function getMostRecentDepositTimestampByOwnerAndToken(address owner, address token) external view returns (uint64);
1071 
1072     /**
1073      * @return  The most recent indexed amount of DMG earned by the `owner` for the deposited `token` which is being
1074      *          farmed for the most-recent season. If there is no active season, this function returns `0`.
1075      */
1076     function getMostRecentIndexedDmgEarnedByOwnerAndToken(address owner, address token) external view returns (uint);
1077 
1078 }
1079 
1080 // File: contracts/external/farming/DMGYieldFarmingRouter.sol
1081 
1082 /*
1083  * Copyright 2020 DMM Foundation
1084  *
1085  * Licensed under the Apache License, Version 2.0 (the "License");
1086  * you may not use this file except in compliance with the License.
1087  * You may obtain a copy of the License at
1088  *
1089  * http://www.apache.org/licenses/LICENSE-2.0
1090  *
1091  * Unless required by applicable law or agreed to in writing, software
1092  * distributed under the License is distributed on an "AS IS" BASIS,
1093  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1094  * See the License for the specific language governing permissions and
1095  * limitations under the License.
1096  */
1097 
1098 
1099 pragma solidity ^0.5.0;
1100 
1101 
1102 
1103 
1104 
1105 
1106 
1107 
1108 
1109 contract DMGYieldFarmingRouter is Ownable, ReentrancyGuard {
1110 
1111     using AddressUtil for address payable;
1112     using SafeERC20 for IERC20;
1113     using UniswapV2Library for *;
1114 
1115     address public dmgYieldFarming;
1116     address public uniswapV2Factory;
1117     address public weth;
1118     bytes32 public initCodeHash;
1119 
1120     // Used to prevent stack too deep errors.
1121     struct UniswapParams {
1122         address tokenA;
1123         address tokenB;
1124         uint liquidity;
1125         uint amountAMin;
1126         uint amountBMin;
1127     }
1128 
1129     modifier ensureDeadline(uint deadline) {
1130         require(deadline >= block.timestamp, "DMGYieldFarmingFundingProxy: EXPIRED");
1131         _;
1132     }
1133 
1134     modifier ensurePairIsSupported(address tokenA, address tokenB) {
1135         require(
1136             IDMGYieldFarmingV1(dmgYieldFarming).isSupportedToken(UniswapV2Library.pairFor(uniswapV2Factory, tokenA, tokenB, initCodeHash)),
1137             "DMGYieldFarmingFundingProxy: TOKEN_UNSUPPORTED"
1138         );
1139         _;
1140     }
1141 
1142     constructor(
1143         address _dmgYieldFarming,
1144         address _uniswapV2Factory,
1145         address _weth
1146     ) public {
1147         dmgYieldFarming = _dmgYieldFarming;
1148         uniswapV2Factory = _uniswapV2Factory;
1149         weth = _weth;
1150         initCodeHash = bytes32(0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f);
1151     }
1152 
1153     function() external payable {
1154         require(
1155             msg.sender == weth,
1156             "DMGYieldFarmingFundingProxy::default: INVALID_SENDER"
1157         );
1158     }
1159 
1160     function getPair(
1161         address tokenA,
1162         address tokenB
1163     ) public view returns (address) {
1164         return UniswapV2Library.pairFor(uniswapV2Factory, tokenA, tokenB, initCodeHash);
1165     }
1166 
1167     function setInitCodeHash(
1168         bytes32 _initCodeHash
1169     )
1170     public
1171     onlyOwner {
1172         initCodeHash = _initCodeHash;
1173     }
1174 
1175     function enableTokens(
1176         address[] calldata tokens,
1177         address[] calldata spenders
1178     )
1179     external
1180     nonReentrant {
1181         require(
1182             tokens.length == spenders.length,
1183             "DMGYieldFarmingFundingProxy::enableTokens: INVALID_LENGTH"
1184         );
1185 
1186         for (uint i = 0; i < tokens.length; i++) {
1187             IERC20(tokens[i]).safeApprove(spenders[i], uint(- 1));
1188         }
1189     }
1190 
1191     function addLiquidity(
1192         address tokenA,
1193         address tokenB,
1194         uint amountADesired,
1195         uint amountBDesired,
1196         uint amountAMin,
1197         uint amountBMin,
1198         uint deadline
1199     )
1200     public
1201     nonReentrant
1202     ensureDeadline(deadline) {
1203         _verifyTokensAreSupported(tokenA, tokenB);
1204 
1205         address _uniswapV2Factory = uniswapV2Factory;
1206 
1207         UniswapParams memory params = UniswapParams({
1208         tokenA : tokenA,
1209         tokenB : tokenB,
1210         liquidity : 0,
1211         amountAMin : amountAMin,
1212         amountBMin : amountBMin
1213         });
1214 
1215         (uint amountA, uint amountB) = _getAmounts(
1216             params,
1217             amountADesired,
1218             amountBDesired,
1219             _uniswapV2Factory
1220         );
1221 
1222         address pair = UniswapV2Library.pairFor(uniswapV2Factory, params.tokenA, params.tokenB, initCodeHash);
1223         uint liquidity = _doTokenTransfersAndMintLiquidity(params, pair, amountA, amountB);
1224 
1225         IDMGYieldFarmingV1(dmgYieldFarming).beginFarming(msg.sender, address(this), pair, liquidity);
1226     }
1227 
1228     function addLiquidityETH(
1229         address token,
1230         uint amountTokenDesired,
1231         uint amountTokenMin,
1232         uint amountETHMin,
1233         uint deadline
1234     )
1235     public payable
1236     nonReentrant
1237     ensureDeadline(deadline) {
1238         UniswapParams memory params = UniswapParams({
1239         tokenA : token,
1240         tokenB : weth,
1241         liquidity : 0,
1242         amountAMin : amountTokenMin,
1243         amountBMin : amountETHMin
1244         });
1245 
1246         _verifyTokensAreSupported(token, params.tokenB);
1247 
1248         address _uniswapV2Factory = uniswapV2Factory;
1249 
1250         (uint amountToken, uint amountETH) = _getAmounts(
1251             params,
1252             amountTokenDesired,
1253             msg.value,
1254             _uniswapV2Factory
1255         );
1256 
1257         address pair = UniswapV2Library.pairFor(_uniswapV2Factory, token, params.tokenB, initCodeHash);
1258 
1259         uint liquidity = _doTokenTransfersWithEthAndMintLiquidity(params, pair, amountToken, amountETH);
1260 
1261         // refund dust eth, if any
1262         if (msg.value > amountETH) {
1263             require(
1264                 msg.sender.sendETH(msg.value - amountETH),
1265                 "DMGYieldFarmingFundingProxy::addLiquidityETH: ETH_TRANSFER_FAILURE"
1266             );
1267         }
1268 
1269         IDMGYieldFarmingV1(dmgYieldFarming).beginFarming(msg.sender, address(this), pair, liquidity);
1270     }
1271 
1272     function removeLiquidity(
1273         address tokenA,
1274         address tokenB,
1275         uint liquidity,
1276         uint amountAMin,
1277         uint amountBMin,
1278         uint deadline,
1279         bool isInSeason
1280     )
1281     public
1282     nonReentrant
1283     ensureDeadline(deadline) {
1284         _verifyTokensAreSupported(tokenA, tokenB);
1285 
1286         UniswapParams memory params = UniswapParams({
1287         tokenA : tokenA,
1288         tokenB : tokenB,
1289         liquidity : liquidity,
1290         amountAMin : amountAMin,
1291         amountBMin : amountBMin
1292         });
1293 
1294         _removeLiquidity(params, msg.sender, msg.sender, isInSeason);
1295     }
1296 
1297     function removeLiquidityETH(
1298         address token,
1299         uint liquidity,
1300         uint amountTokenMin,
1301         uint amountETHMin,
1302         uint deadline,
1303         bool isInSeason
1304     )
1305     public
1306     nonReentrant
1307     ensureDeadline(deadline) {
1308         UniswapParams memory params = UniswapParams({
1309         tokenA : token,
1310         tokenB : weth,
1311         liquidity : liquidity,
1312         amountAMin : amountTokenMin,
1313         amountBMin : amountETHMin
1314         });
1315 
1316         _verifyTokensAreSupported(params.tokenA, params.tokenB);
1317 
1318         (uint amountToken, uint amountETH) = _removeLiquidity(params, msg.sender, address(this), isInSeason);
1319 
1320         IERC20(params.tokenA).safeTransfer(msg.sender, amountToken);
1321         IWETH(params.tokenB).withdraw(amountETH);
1322         require(
1323             msg.sender.sendETH(amountETH),
1324             "DMGYieldFarmingFundingProxy::addLiquidityETH: ETH_TRANSFER_FAILURE"
1325         );
1326     }
1327 
1328     function _verifyTokensAreSupported(
1329         address tokenA,
1330         address tokenB
1331     ) internal view {
1332         require(
1333             IDMGYieldFarmingV1(dmgYieldFarming).isSupportedToken(UniswapV2Library.pairFor(uniswapV2Factory, tokenA, tokenB, initCodeHash)),
1334             "DMGYieldFarmingFundingProxy::_verifyTokensAreSupported: TOKEN_UNSUPPORTED"
1335         );
1336     }
1337 
1338     function _removeLiquidity(
1339         UniswapParams memory params,
1340         address farmer,
1341         address liquidityRecipient,
1342         bool isInSeason
1343     )
1344     internal returns (uint amountA, uint amountB) {
1345         address pair = UniswapV2Library.pairFor(uniswapV2Factory, params.tokenA, params.tokenB, initCodeHash);
1346         uint liquidity;
1347         if (isInSeason) {
1348             (uint _liquidity, uint dmgEarned) = IDMGYieldFarmingV1(dmgYieldFarming).endFarmingByToken(farmer, address(this), pair);
1349             liquidity = _liquidity;
1350             // Forward the DMG along to the farmer
1351             IERC20(IDMGYieldFarmingV1(dmgYieldFarming).dmgToken()).safeTransfer(farmer, dmgEarned);
1352         } else {
1353             liquidity = IDMGYieldFarmingV1(dmgYieldFarming).withdrawByTokenWhenOutOfSeason(
1354                 farmer,
1355                 address(this),
1356                 pair
1357             );
1358         }
1359 
1360         IERC20(pair).safeTransfer(pair, liquidity);
1361         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(liquidityRecipient);
1362         (address token0,) = UniswapV2Library.sortTokens(params.tokenA, params.tokenB);
1363         (amountA, amountB) = params.tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
1364 
1365         require(amountA >= params.amountAMin, 'DMGYieldFarmingFundingProxy::removeLiquidity: INSUFFICIENT_A_AMOUNT');
1366         require(amountB >= params.amountBMin, 'DMGYieldFarmingFundingProxy::removeLiquidity: INSUFFICIENT_B_AMOUNT');
1367     }
1368 
1369     function _getAmounts(
1370         UniswapParams memory params,
1371         uint amountADesired,
1372         uint amountBDesired,
1373         address uniswapV2Factory
1374     )
1375     internal view returns (uint amountA, uint amountB) {
1376         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(uniswapV2Factory, params.tokenA, params.tokenB, initCodeHash);
1377         if (reserveA == 0 && reserveB == 0) {
1378             (amountA, amountB) = (amountADesired, amountBDesired);
1379         } else {
1380             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
1381             if (amountBOptimal <= amountBDesired) {
1382                 require(
1383                     amountBOptimal >= params.amountBMin,
1384                     "DMGYieldFarmingFundingProxy::_getAmounts: INSUFFICIENT_B_AMOUNT"
1385                 );
1386 
1387                 (amountA, amountB) = (amountADesired, amountBOptimal);
1388             } else {
1389                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
1390                 assert(amountAOptimal <= amountADesired);
1391                 require(
1392                     amountAOptimal >= params.amountAMin,
1393                     "DMGYieldFarmingFundingProxy::_getAmounts: INSUFFICIENT_A_AMOUNT"
1394                 );
1395 
1396                 (amountA, amountB) = (amountAOptimal, amountBDesired);
1397             }
1398         }
1399     }
1400 
1401     function _doTokenTransfersAndMintLiquidity(
1402         UniswapParams memory params,
1403         address pair,
1404         uint amountA,
1405         uint amountB
1406     ) internal returns (uint) {
1407         IERC20(params.tokenA).safeTransferFrom(msg.sender, pair, amountA);
1408         IERC20(params.tokenB).safeTransferFrom(msg.sender, pair, amountB);
1409 
1410         return IUniswapV2Pair(pair).mint(address(this));
1411     }
1412 
1413     function _doTokenTransfersWithEthAndMintLiquidity(
1414         UniswapParams memory params,
1415         address pair,
1416         uint amountToken,
1417         uint amountETH
1418     ) internal returns (uint) {
1419         IERC20(params.tokenA).safeTransferFrom(msg.sender, pair, amountToken);
1420         IWETH(params.tokenB).deposit.value(amountETH)();
1421         IERC20(params.tokenB).safeTransfer(pair, amountETH);
1422 
1423         return IUniswapV2Pair(pair).mint(address(this));
1424     }
1425 
1426 }