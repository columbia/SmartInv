1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU Affero General Public License as published by
11 // the Free Software Foundation, either version 2 of the License, or
12 // (at your option) any later version.
13 //
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU Affero General Public License for more details.
18 //
19 
20 ///@author Zapper
21 ///@notice This contract adds liquidity to Sushiswap pools using ETH or any ERC20 Token.
22 // SPDX-License-Identifier: GPLv2
23 
24 pragma solidity ^0.5.0;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
28  * the optional functions; to access them see {ERC20Detailed}.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount)
49         external
50         returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender)
60         external
61         view
62         returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address sender,
91         address recipient,
92         uint256 amount
93     ) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(
108         address indexed owner,
109         address indexed spender,
110         uint256 value
111     );
112 }
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      *
228      * _Available since v2.4.0._
229      */
230     function div(
231         uint256 a,
232         uint256 b,
233         string memory errorMessage
234     ) internal pure returns (uint256) {
235         // Solidity only automatically asserts when dividing by 0
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         return mod(a, b, "SafeMath: modulo by zero");
256     }
257 
258     /**
259      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
260      * Reverts with custom message when dividing by zero.
261      *
262      * Counterpart to Solidity's `%` operator. This function uses a `revert`
263      * opcode (which leaves remaining gas untouched) while Solidity uses an
264      * invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      * - The divisor cannot be zero.
268      *
269      * _Available since v2.4.0._
270      */
271     function mod(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
304         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
305         // for accounts without code, i.e. `keccak256('')`
306         bytes32 codehash;
307 
308 
309             bytes32 accountHash
310          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
311         // solhint-disable-next-line no-inline-assembly
312         assembly {
313             codehash := extcodehash(account)
314         }
315         return (codehash != accountHash && codehash != 0x0);
316     }
317 
318     /**
319      * @dev Converts an `address` into `address payable`. Note that this is
320      * simply a type cast: the actual underlying value is not changed.
321      *
322      * _Available since v2.4.0._
323      */
324     function toPayable(address account)
325         internal
326         pure
327         returns (address payable)
328     {
329         return address(uint160(account));
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      *
348      * _Available since v2.4.0._
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(
352             address(this).balance >= amount,
353             "Address: insufficient balance"
354         );
355 
356         // solhint-disable-next-line avoid-call-value
357         (bool success, ) = recipient.call.value(amount)("");
358         require(
359             success,
360             "Address: unable to send value, recipient may have reverted"
361         );
362     }
363 }
364 
365 /**
366  * @title SafeERC20
367  * @dev Wrappers around ERC20 operations that throw on failure (when the token
368  * contract returns false). Tokens that return no value (and instead revert or
369  * throw on failure) are also supported, non-reverting calls are assumed to be
370  * successful.
371  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
372  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
373  */
374 library SafeERC20 {
375     using SafeMath for uint256;
376     using Address for address;
377 
378     function safeTransfer(
379         IERC20 token,
380         address to,
381         uint256 value
382     ) internal {
383         callOptionalReturn(
384             token,
385             abi.encodeWithSelector(token.transfer.selector, to, value)
386         );
387     }
388 
389     function safeTransferFrom(
390         IERC20 token,
391         address from,
392         address to,
393         uint256 value
394     ) internal {
395         callOptionalReturn(
396             token,
397             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
398         );
399     }
400 
401     function safeApprove(
402         IERC20 token,
403         address spender,
404         uint256 value
405     ) internal {
406         // safeApprove should only be called when setting an initial allowance,
407         // or when resetting it to zero. To increase and decrease it, use
408         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
409         // solhint-disable-next-line max-line-length
410         require(
411             (value == 0) || (token.allowance(address(this), spender) == 0),
412             "SafeERC20: approve from non-zero to non-zero allowance"
413         );
414         callOptionalReturn(
415             token,
416             abi.encodeWithSelector(token.approve.selector, spender, value)
417         );
418     }
419 
420     function safeIncreaseAllowance(
421         IERC20 token,
422         address spender,
423         uint256 value
424     ) internal {
425         uint256 newAllowance = token.allowance(address(this), spender).add(
426             value
427         );
428         callOptionalReturn(
429             token,
430             abi.encodeWithSelector(
431                 token.approve.selector,
432                 spender,
433                 newAllowance
434             )
435         );
436     }
437 
438     function safeDecreaseAllowance(
439         IERC20 token,
440         address spender,
441         uint256 value
442     ) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).sub(
444             value,
445             "SafeERC20: decreased allowance below zero"
446         );
447         callOptionalReturn(
448             token,
449             abi.encodeWithSelector(
450                 token.approve.selector,
451                 spender,
452                 newAllowance
453             )
454         );
455     }
456 
457     /**
458      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
459      * on the return value: the return value is optional (but if data is returned, it must not be false).
460      * @param token The token targeted by the call.
461      * @param data The call data (encoded using abi.encode or one of its variants).
462      */
463     function callOptionalReturn(IERC20 token, bytes memory data) private {
464         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
465         // we're implementing it ourselves.
466 
467         // A Solidity high level call has three parts:
468         //  1. The target address is checked to verify it contains contract code
469         //  2. The call itself is made, and success asserted
470         //  3. The return value is decoded, which in turn checks the size of the returned data.
471         // solhint-disable-next-line max-line-length
472         require(address(token).isContract(), "SafeERC20: call to non-contract");
473 
474         // solhint-disable-next-line avoid-low-level-calls
475         (bool success, bytes memory returndata) = address(token).call(data);
476         require(success, "SafeERC20: low-level call failed");
477 
478         if (returndata.length > 0) {
479             // Return data is optional
480             // solhint-disable-next-line max-line-length
481             require(
482                 abi.decode(returndata, (bool)),
483                 "SafeERC20: ERC20 operation did not succeed"
484             );
485         }
486     }
487 }
488 
489 /**
490  * @dev Contract module that helps prevent reentrant calls to a function.
491  *
492  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
493  * available, which can be applied to functions to make sure there are no nested
494  * (reentrant) calls to them.
495  *
496  * Note that because there is a single `nonReentrant` guard, functions marked as
497  * `nonReentrant` may not call one another. This can be worked around by making
498  * those functions `private`, and then adding `external` `nonReentrant` entry
499  * points to them.
500  *
501  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
502  * metering changes introduced in the Istanbul hardfork.
503  */
504 contract ReentrancyGuard {
505     bool private _notEntered;
506 
507     constructor() internal {
508         // Storing an initial non-zero value makes deployment a bit more
509         // expensive, but in exchange the refund on every call to nonReentrant
510         // will be lower in amount. Since refunds are capped to a percetange of
511         // the total transaction's gas, it is best to keep them low in cases
512         // like this one, to increase the likelihood of the full refund coming
513         // into effect.
514         _notEntered = true;
515     }
516 
517     /**
518      * @dev Prevents a contract from calling itself, directly or indirectly.
519      * Calling a `nonReentrant` function from another `nonReentrant`
520      * function is not supported. It is possible to prevent this from happening
521      * by making the `nonReentrant` function external, and make it call a
522      * `private` function that does the actual work.
523      */
524     modifier nonReentrant() {
525         // On the first call to nonReentrant, _notEntered will be true
526         require(_notEntered, "ReentrancyGuard: reentrant call");
527 
528         // Any calls to nonReentrant after this point will fail
529         _notEntered = false;
530 
531         _;
532 
533         // By storing the original value once again, a refund is triggered (see
534         // https://eips.ethereum.org/EIPS/eip-2200)
535         _notEntered = true;
536     }
537 }
538 
539 /*
540  * @dev Provides information about the current execution context, including the
541  * sender of the transaction and its data. While these are generally available
542  * via msg.sender and msg.data, they should not be accessed in such a direct
543  * manner, since when dealing with GSN meta-transactions the account sending and
544  * paying for execution may not be the actual sender (as far as an application
545  * is concerned).
546  *
547  * This contract is only required for intermediate, library-like contracts.
548  */
549 contract Context {
550     // Empty internal constructor, to prevent people from mistakenly deploying
551     // an instance of this contract, which should be used via inheritance.
552     constructor() internal {}
553 
554     // solhint-disable-previous-line no-empty-blocks
555 
556     function _msgSender() internal view returns (address payable) {
557         return msg.sender;
558     }
559 
560     function _msgData() internal view returns (bytes memory) {
561         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
562         return msg.data;
563     }
564 }
565 
566 /**
567  * @dev Contract module which provides a basic access control mechanism, where
568  * there is an account (an owner) that can be granted exclusive access to
569  * specific functions.
570  *
571  * This module is used through inheritance. It will make available the modifier
572  * `onlyOwner`, which can be applied to your functions to restrict their use to
573  * the owner.
574  */
575 contract Ownable is Context {
576     address payable public _owner;
577 
578     event OwnershipTransferred(
579         address indexed previousOwner,
580         address indexed newOwner
581     );
582 
583     /**
584      * @dev Initializes the contract setting the deployer as the initial owner.
585      */
586     constructor() internal {
587         address payable msgSender = _msgSender();
588         _owner = msgSender;
589         emit OwnershipTransferred(address(0), msgSender);
590     }
591 
592     /**
593      * @dev Returns the address of the current owner.
594      */
595     function owner() public view returns (address) {
596         return _owner;
597     }
598 
599     /**
600      * @dev Throws if called by any account other than the owner.
601      */
602     modifier onlyOwner() {
603         require(isOwner(), "Ownable: caller is not the owner");
604         _;
605     }
606 
607     /**
608      * @dev Returns true if the caller is the current owner.
609      */
610     function isOwner() public view returns (bool) {
611         return _msgSender() == _owner;
612     }
613 
614     /**
615      * @dev Leaves the contract without owner. It will not be possible to call
616      * `onlyOwner` functions anymore. Can only be called by the current owner.
617      *
618      * NOTE: Renouncing ownership will leave the contract without an owner,
619      * thereby removing any functionality that is only available to the owner.
620      */
621     function renounceOwnership() public onlyOwner {
622         emit OwnershipTransferred(_owner, address(0));
623         _owner = address(0);
624     }
625 
626     /**
627      * @dev Transfers ownership of the contract to a new account (`newOwner`).
628      * Can only be called by the current owner.
629      */
630     function transferOwnership(address payable newOwner) public onlyOwner {
631         _transferOwnership(newOwner);
632     }
633 
634     /**
635      * @dev Transfers ownership of the contract to a new account (`newOwner`).
636      */
637     function _transferOwnership(address payable newOwner) internal {
638         require(
639             newOwner != address(0),
640             "Ownable: new owner is the zero address"
641         );
642         emit OwnershipTransferred(_owner, newOwner);
643         _owner = newOwner;
644     }
645 }
646 
647 // import "@uniswap/lib/contracts/libraries/Babylonian.sol";
648 library Babylonian {
649     function sqrt(uint256 y) internal pure returns (uint256 z) {
650         if (y > 3) {
651             z = y;
652             uint256 x = y / 2 + 1;
653             while (x < z) {
654                 z = x;
655                 x = (y / x + x) / 2;
656             }
657         } else if (y != 0) {
658             z = 1;
659         }
660         // else z = 0
661     }
662 }
663 
664 interface IWETH {
665     function deposit() external payable;
666 
667     function transfer(address to, uint256 value) external returns (bool);
668 
669     function withdraw(uint256) external;
670 }
671 
672 interface IUniswapV2Factory {
673     function getPair(address tokenA, address tokenB)
674         external
675         view
676         returns (address);
677 }
678 
679 interface IUniswapV2Router02 {
680     function factory() external pure returns (address);
681 
682     function WETH() external pure returns (address);
683 
684     function addLiquidity(
685         address tokenA,
686         address tokenB,
687         uint256 amountADesired,
688         uint256 amountBDesired,
689         uint256 amountAMin,
690         uint256 amountBMin,
691         address to,
692         uint256 deadline
693     )
694         external
695         returns (
696             uint256 amountA,
697             uint256 amountB,
698             uint256 liquidity
699         );
700 
701     function addLiquidityETH(
702         address token,
703         uint256 amountTokenDesired,
704         uint256 amountTokenMin,
705         uint256 amountETHMin,
706         address to,
707         uint256 deadline
708     )
709         external
710         payable
711         returns (
712             uint256 amountToken,
713             uint256 amountETH,
714             uint256 liquidity
715         );
716 
717     function removeLiquidity(
718         address tokenA,
719         address tokenB,
720         uint256 liquidity,
721         uint256 amountAMin,
722         uint256 amountBMin,
723         address to,
724         uint256 deadline
725     ) external returns (uint256 amountA, uint256 amountB);
726 
727     function removeLiquidityETH(
728         address token,
729         uint256 liquidity,
730         uint256 amountTokenMin,
731         uint256 amountETHMin,
732         address to,
733         uint256 deadline
734     ) external returns (uint256 amountToken, uint256 amountETH);
735 
736     function removeLiquidityWithPermit(
737         address tokenA,
738         address tokenB,
739         uint256 liquidity,
740         uint256 amountAMin,
741         uint256 amountBMin,
742         address to,
743         uint256 deadline,
744         bool approveMax,
745         uint8 v,
746         bytes32 r,
747         bytes32 s
748     ) external returns (uint256 amountA, uint256 amountB);
749 
750     function removeLiquidityETHWithPermit(
751         address token,
752         uint256 liquidity,
753         uint256 amountTokenMin,
754         uint256 amountETHMin,
755         address to,
756         uint256 deadline,
757         bool approveMax,
758         uint8 v,
759         bytes32 r,
760         bytes32 s
761     ) external returns (uint256 amountToken, uint256 amountETH);
762 
763     function swapExactTokensForTokens(
764         uint256 amountIn,
765         uint256 amountOutMin,
766         address[] calldata path,
767         address to,
768         uint256 deadline
769     ) external returns (uint256[] memory amounts);
770 
771     function swapTokensForExactTokens(
772         uint256 amountOut,
773         uint256 amountInMax,
774         address[] calldata path,
775         address to,
776         uint256 deadline
777     ) external returns (uint256[] memory amounts);
778 
779     function swapExactETHForTokens(
780         uint256 amountOutMin,
781         address[] calldata path,
782         address to,
783         uint256 deadline
784     ) external payable returns (uint256[] memory amounts);
785 
786     function swapTokensForExactETH(
787         uint256 amountOut,
788         uint256 amountInMax,
789         address[] calldata path,
790         address to,
791         uint256 deadline
792     ) external returns (uint256[] memory amounts);
793 
794     function swapExactTokensForETH(
795         uint256 amountIn,
796         uint256 amountOutMin,
797         address[] calldata path,
798         address to,
799         uint256 deadline
800     ) external returns (uint256[] memory amounts);
801 
802     function swapETHForExactTokens(
803         uint256 amountOut,
804         address[] calldata path,
805         address to,
806         uint256 deadline
807     ) external payable returns (uint256[] memory amounts);
808 
809     function removeLiquidityETHSupportingFeeOnTransferTokens(
810         address token,
811         uint256 liquidity,
812         uint256 amountTokenMin,
813         uint256 amountETHMin,
814         address to,
815         uint256 deadline
816     ) external returns (uint256 amountETH);
817 
818     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
819         address token,
820         uint256 liquidity,
821         uint256 amountTokenMin,
822         uint256 amountETHMin,
823         address to,
824         uint256 deadline,
825         bool approveMax,
826         uint8 v,
827         bytes32 r,
828         bytes32 s
829     ) external returns (uint256 amountETH);
830 
831     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
832         uint256 amountIn,
833         uint256 amountOutMin,
834         address[] calldata path,
835         address to,
836         uint256 deadline
837     ) external;
838 
839     function swapExactETHForTokensSupportingFeeOnTransferTokens(
840         uint256 amountOutMin,
841         address[] calldata path,
842         address to,
843         uint256 deadline
844     ) external payable;
845 
846     function swapExactTokensForETHSupportingFeeOnTransferTokens(
847         uint256 amountIn,
848         uint256 amountOutMin,
849         address[] calldata path,
850         address to,
851         uint256 deadline
852     ) external;
853 
854     function quote(
855         uint256 amountA,
856         uint256 reserveA,
857         uint256 reserveB
858     ) external pure returns (uint256 amountB);
859 
860     function getAmountOut(
861         uint256 amountIn,
862         uint256 reserveIn,
863         uint256 reserveOut
864     ) external pure returns (uint256 amountOut);
865 
866     function getAmountIn(
867         uint256 amountOut,
868         uint256 reserveIn,
869         uint256 reserveOut
870     ) external pure returns (uint256 amountIn);
871 
872     function getAmountsOut(uint256 amountIn, address[] calldata path)
873         external
874         view
875         returns (uint256[] memory amounts);
876 
877     function getAmountsIn(uint256 amountOut, address[] calldata path)
878         external
879         view
880         returns (uint256[] memory amounts);
881 }
882 
883 interface IUniswapV2Pair {
884     function token0() external pure returns (address);
885 
886     function token1() external pure returns (address);
887 
888     function getReserves()
889         external
890         view
891         returns (
892             uint112 _reserve0,
893             uint112 _reserve1,
894             uint32 _blockTimestampLast
895         );
896 }
897 
898 contract Sushiswap_ZapIn_General_V2 is ReentrancyGuard, Ownable {
899     using SafeMath for uint256;
900     using Address for address;
901     using SafeERC20 for IERC20;
902 
903     bool public stopped = false;
904     uint16 public goodwill;
905     address
906         private constant zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
907 
908     IUniswapV2Factory
909         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
910         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
911     );
912 
913     // sushiSwap
914     IUniswapV2Router02 private constant sushiSwapRouter = IUniswapV2Router02(
915         0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F
916     );
917     IUniswapV2Factory
918         private constant sushiSwapFactoryAddress = IUniswapV2Factory(
919         0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac
920     );
921 
922     address
923         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
924 
925     uint256
926         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
927 
928     constructor(uint16 _goodwill) public {
929         goodwill = _goodwill;
930     }
931 
932     // circuit breaker modifiers
933     modifier stopInEmergency {
934         if (stopped) {
935             revert("Temporarily Paused");
936         } else {
937             _;
938         }
939     }
940 
941     /**
942     @notice This function is used to invest in given Sushiswap pair through ETH/ERC20 Tokens
943     @param _FromTokenContractAddress The ERC20 token used for investment (address(0x00) if ether)
944     @param _pairAddress The Sushiswap pair address
945     @param _amount The amount of fromToken to invest
946     @param _minPoolTokens Reverts if less tokens received than this
947     @param _allowanceTarget Spender for the first swap
948     @param _swapTarget Excecution target for the first swap
949     @param swapData Dex quote data
950     @return Amount of LP bought
951      */
952     function ZapIn(
953         address _FromTokenContractAddress,
954         address _pairAddress,
955         uint256 _amount,
956         uint256 _minPoolTokens,
957         address _allowanceTarget,
958         address _swapTarget,
959         bytes calldata swapData
960     ) external payable nonReentrant stopInEmergency returns (uint256) {
961         uint256 toInvest;
962         if (_FromTokenContractAddress == address(0)) {
963             require(msg.value > 0, "Error: ETH not sent");
964             toInvest = msg.value;
965         } else {
966             require(msg.value == 0, "Error: ETH sent");
967             require(_amount > 0, "Error: Invalid ERC amount");
968             IERC20(_FromTokenContractAddress).safeTransferFrom(
969                 msg.sender,
970                 address(this),
971                 _amount
972             );
973             toInvest = _amount;
974         }
975 
976         uint256 LPBought = _performZapIn(
977             _FromTokenContractAddress,
978             _pairAddress,
979             toInvest,
980             _allowanceTarget,
981             _swapTarget,
982             swapData
983         );
984         require(LPBought >= _minPoolTokens, "ERR: High Slippage");
985 
986         //transfer goodwill
987         uint256 goodwillPortion = _transferGoodwill(_pairAddress, LPBought);
988 
989         IERC20(_pairAddress).safeTransfer(
990             msg.sender,
991             SafeMath.sub(LPBought, goodwillPortion)
992         );
993         return SafeMath.sub(LPBought, goodwillPortion);
994     }
995 
996     function _getPairTokens(address _pairAddress)
997         internal
998         pure
999         returns (address token0, address token1)
1000     {
1001         IUniswapV2Pair sushiPair = IUniswapV2Pair(_pairAddress);
1002         token0 = sushiPair.token0();
1003         token1 = sushiPair.token1();
1004     }
1005 
1006     function _performZapIn(
1007         address _FromTokenContractAddress,
1008         address _pairAddress,
1009         uint256 _amount,
1010         address _allowanceTarget,
1011         address _swapTarget,
1012         bytes memory swapData
1013     ) internal returns (uint256) {
1014         uint256 intermediateAmt;
1015         address intermediateToken;
1016         (
1017             address _ToSushipoolToken0,
1018             address _ToSushipoolToken1
1019         ) = _getPairTokens(_pairAddress);
1020 
1021         if (
1022             _FromTokenContractAddress != _ToSushipoolToken0 &&
1023             _FromTokenContractAddress != _ToSushipoolToken1
1024         ) {
1025             // swap to intermediate
1026             (intermediateAmt, intermediateToken) = _fillQuote(
1027                 _FromTokenContractAddress,
1028                 _pairAddress,
1029                 _amount,
1030                 _allowanceTarget,
1031                 _swapTarget,
1032                 swapData
1033             );
1034         } else {
1035             intermediateToken = _FromTokenContractAddress;
1036             intermediateAmt = _amount;
1037         }
1038         // divide intermediate into appropriate amount to add liquidity
1039         (uint256 token0Bought, uint256 token1Bought) = _swapIntermediate(
1040             intermediateToken,
1041             _ToSushipoolToken0,
1042             _ToSushipoolToken1,
1043             intermediateAmt
1044         );
1045 
1046         return
1047             _sushiDeposit(
1048                 _ToSushipoolToken0,
1049                 _ToSushipoolToken1,
1050                 token0Bought,
1051                 token1Bought
1052             );
1053     }
1054 
1055     function _sushiDeposit(
1056         address _ToUnipoolToken0,
1057         address _ToUnipoolToken1,
1058         uint256 token0Bought,
1059         uint256 token1Bought
1060     ) internal returns (uint256) {
1061         IERC20(_ToUnipoolToken0).safeApprove(address(sushiSwapRouter), 0);
1062         IERC20(_ToUnipoolToken1).safeApprove(address(sushiSwapRouter), 0);
1063 
1064         IERC20(_ToUnipoolToken0).safeApprove(
1065             address(sushiSwapRouter),
1066             token0Bought
1067         );
1068         IERC20(_ToUnipoolToken1).safeApprove(
1069             address(sushiSwapRouter),
1070             token1Bought
1071         );
1072 
1073         (uint256 amountA, uint256 amountB, uint256 LP) = sushiSwapRouter
1074             .addLiquidity(
1075             _ToUnipoolToken0,
1076             _ToUnipoolToken1,
1077             token0Bought,
1078             token1Bought,
1079             1,
1080             1,
1081             address(this),
1082             deadline
1083         );
1084 
1085         //Returning Residue in token0, if any.
1086         if (token0Bought.sub(amountA) > 0) {
1087             IERC20(_ToUnipoolToken0).safeTransfer(
1088                 msg.sender,
1089                 token0Bought.sub(amountA)
1090             );
1091         }
1092 
1093         //Returning Residue in token1, if any
1094         if (token1Bought.sub(amountB) > 0) {
1095             IERC20(_ToUnipoolToken1).safeTransfer(
1096                 msg.sender,
1097                 token1Bought.sub(amountB)
1098             );
1099         }
1100 
1101         return LP;
1102     }
1103 
1104     function _fillQuote(
1105         address _fromTokenAddress,
1106         address _pairAddress,
1107         uint256 _amount,
1108         address _allowanceTarget,
1109         address _swapTarget,
1110         bytes memory swapCallData
1111     ) internal returns (uint256 amountBought, address intermediateToken) {
1112         uint256 valueToSend;
1113         if (_fromTokenAddress == address(0)) {
1114             valueToSend = _amount;
1115         } else {
1116             IERC20 fromToken = IERC20(_fromTokenAddress);
1117             fromToken.safeApprove(address(_allowanceTarget), 0);
1118             fromToken.safeApprove(address(_allowanceTarget), _amount);
1119         }
1120 
1121         (address _token0, address _token1) = _getPairTokens(_pairAddress);
1122         IERC20 token0 = IERC20(_token0);
1123         IERC20 token1 = IERC20(_token1);
1124         uint256 initialBalance0 = token0.balanceOf(address(this));
1125         uint256 initialBalance1 = token1.balanceOf(address(this));
1126 
1127         (bool success, ) = _swapTarget.call.value(valueToSend)(swapCallData);
1128         require(success, "Error Swapping Tokens 1");
1129 
1130         uint256 finalBalance0 = token0.balanceOf(address(this)).sub(
1131             initialBalance0
1132         );
1133         uint256 finalBalance1 = token1.balanceOf(address(this)).sub(
1134             initialBalance1
1135         );
1136 
1137         if (finalBalance0 > finalBalance1) {
1138             amountBought = finalBalance0;
1139             intermediateToken = _token0;
1140         } else {
1141             amountBought = finalBalance1;
1142             intermediateToken = _token1;
1143         }
1144 
1145         require(amountBought > 0, "Swapped to Invalid Intermediate");
1146     }
1147 
1148     function _swapIntermediate(
1149         address _toContractAddress,
1150         address _ToSushipoolToken0,
1151         address _ToSushipoolToken1,
1152         uint256 _amount
1153     ) internal returns (uint256 token0Bought, uint256 token1Bought) {
1154         IUniswapV2Pair pair = IUniswapV2Pair(
1155             sushiSwapFactoryAddress.getPair(
1156                 _ToSushipoolToken0,
1157                 _ToSushipoolToken1
1158             )
1159         );
1160         (uint256 res0, uint256 res1, ) = pair.getReserves();
1161         if (_toContractAddress == _ToSushipoolToken0) {
1162             uint256 amountToSwap = calculateSwapInAmount(res0, _amount);
1163             //if no reserve or a new pair is created
1164             if (amountToSwap <= 0) amountToSwap = _amount.div(2);
1165             token1Bought = _token2Token(
1166                 _toContractAddress,
1167                 _ToSushipoolToken1,
1168                 amountToSwap
1169             );
1170             token0Bought = _amount.sub(amountToSwap);
1171         } else {
1172             uint256 amountToSwap = calculateSwapInAmount(res1, _amount);
1173             //if no reserve or a new pair is created
1174             if (amountToSwap <= 0) amountToSwap = _amount.div(2);
1175             token0Bought = _token2Token(
1176                 _toContractAddress,
1177                 _ToSushipoolToken0,
1178                 amountToSwap
1179             );
1180             token1Bought = _amount.sub(amountToSwap);
1181         }
1182     }
1183 
1184     function calculateSwapInAmount(uint256 reserveIn, uint256 userIn)
1185         internal
1186         pure
1187         returns (uint256)
1188     {
1189         return
1190             Babylonian
1191                 .sqrt(
1192                 reserveIn.mul(userIn.mul(3988000) + reserveIn.mul(3988009))
1193             )
1194                 .sub(reserveIn.mul(1997)) / 1994;
1195     }
1196 
1197     /**
1198     @notice This function is used to swap ERC20 <> ERC20
1199     @param _FromTokenContractAddress The token address to swap from.
1200     @param _ToTokenContractAddress The token address to swap to. 
1201     @param tokens2Trade The amount of tokens to swap
1202     @return tokenBought The quantity of tokens bought
1203     */
1204     function _token2Token(
1205         address _FromTokenContractAddress,
1206         address _ToTokenContractAddress,
1207         uint256 tokens2Trade
1208     ) internal returns (uint256 tokenBought) {
1209         if (_FromTokenContractAddress == _ToTokenContractAddress) {
1210             return tokens2Trade;
1211         }
1212         IERC20(_FromTokenContractAddress).safeApprove(
1213             address(sushiSwapRouter),
1214             0
1215         );
1216         IERC20(_FromTokenContractAddress).safeApprove(
1217             address(sushiSwapRouter),
1218             tokens2Trade
1219         );
1220 
1221         if (_FromTokenContractAddress != wethTokenAddress) {
1222             if (_ToTokenContractAddress != wethTokenAddress) {
1223                 // check output via tokenA -> tokenB
1224                 address pairA = UniSwapV2FactoryAddress.getPair(
1225                     _FromTokenContractAddress,
1226                     _ToTokenContractAddress
1227                 );
1228                 address[] memory pathA = new address[](2);
1229                 pathA[0] = _FromTokenContractAddress;
1230                 pathA[1] = _ToTokenContractAddress;
1231                 uint256 amtA;
1232                 if (pairA != address(0)) {
1233                     amtA = sushiSwapRouter.getAmountsOut(
1234                         tokens2Trade,
1235                         pathA
1236                     )[1];
1237                 }
1238 
1239                 // check output via tokenA -> weth -> tokenB
1240                 address[] memory pathB = new address[](3);
1241                 pathB[0] = _FromTokenContractAddress;
1242                 pathB[1] = wethTokenAddress;
1243                 pathB[2] = _ToTokenContractAddress;
1244 
1245                 uint256 amtB = sushiSwapRouter.getAmountsOut(
1246                     tokens2Trade,
1247                     pathB
1248                 )[2];
1249 
1250                 if (amtA >= amtB) {
1251                     tokenBought = sushiSwapRouter.swapExactTokensForTokens(
1252                         tokens2Trade,
1253                         1,
1254                         pathA,
1255                         address(this),
1256                         deadline
1257                     )[pathA.length - 1];
1258                 } else {
1259                     tokenBought = sushiSwapRouter.swapExactTokensForTokens(
1260                         tokens2Trade,
1261                         1,
1262                         pathB,
1263                         address(this),
1264                         deadline
1265                     )[pathB.length - 1];
1266                 }
1267             } else {
1268                 address[] memory path = new address[](2);
1269                 path[0] = _FromTokenContractAddress;
1270                 path[1] = wethTokenAddress;
1271 
1272                 tokenBought = sushiSwapRouter.swapExactTokensForTokens(
1273                     tokens2Trade,
1274                     1,
1275                     path,
1276                     address(this),
1277                     deadline
1278                 )[path.length - 1];
1279             }
1280         } else {
1281             address[] memory path = new address[](2);
1282             path[0] = wethTokenAddress;
1283             path[1] = _ToTokenContractAddress;
1284             tokenBought = sushiSwapRouter.swapExactTokensForTokens(
1285                 tokens2Trade,
1286                 1,
1287                 path,
1288                 address(this),
1289                 deadline
1290             )[path.length - 1];
1291         }
1292 
1293         require(tokenBought > 0, "Error Swapping Tokens 2");
1294     }
1295 
1296     /**
1297     @notice This function is used to calculate and transfer goodwill
1298     @param _tokenContractAddress Token in which goodwill is deducted
1299     @param tokens2Trade The total amount of tokens to be zapped in
1300     @return The quantity of goodwill deducted
1301      */
1302     function _transferGoodwill(
1303         address _tokenContractAddress,
1304         uint256 tokens2Trade
1305     ) internal returns (uint256 goodwillPortion) {
1306         goodwillPortion = SafeMath.div(
1307             SafeMath.mul(tokens2Trade, goodwill),
1308             10000
1309         );
1310 
1311         if (goodwillPortion == 0) {
1312             return 0;
1313         }
1314 
1315         IERC20(_tokenContractAddress).safeTransfer(
1316             zgoodwillAddress,
1317             goodwillPortion
1318         );
1319     }
1320 
1321     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1322         require(
1323             _new_goodwill >= 0 && _new_goodwill < 10000,
1324             "GoodWill Value not allowed"
1325         );
1326         goodwill = _new_goodwill;
1327     }
1328 
1329     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1330         uint256 qty = _TokenAddress.balanceOf(address(this));
1331         _TokenAddress.safeTransfer(owner(), qty);
1332     }
1333 
1334     // - to Pause the contract
1335     function toggleContractActive() public onlyOwner {
1336         stopped = !stopped;
1337     }
1338 
1339     // - to withdraw any ETH balance sitting in the contract
1340     function withdraw() public onlyOwner {
1341         uint256 contractBalance = address(this).balance;
1342         address payable _to = owner().toPayable();
1343         _to.transfer(contractBalance);
1344     }
1345 }