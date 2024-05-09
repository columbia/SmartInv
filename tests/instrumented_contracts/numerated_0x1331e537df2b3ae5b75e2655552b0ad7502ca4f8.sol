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
21 ///@notice This contract adds liquidity to Uniswap V2 pools using ETH or any ERC20 Token.
22 // SPDX-License-Identifier: GPLv2
23 
24 pragma solidity ^0.5.5;
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
898 contract UniswapV2_ZapIn_General_V3 is ReentrancyGuard, Ownable {
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
913     IUniswapV2Router02 private constant uniswapRouter = IUniswapV2Router02(
914         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
915     );
916 
917     address
918         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
919 
920     uint256
921         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
922 
923     constructor(uint16 _goodwill) public {
924         goodwill = _goodwill;
925     }
926 
927     // circuit breaker modifiers
928     modifier stopInEmergency {
929         if (stopped) {
930             revert("Temporarily Paused");
931         } else {
932             _;
933         }
934     }
935 
936     /**
937     @notice This function is used to invest in given Uniswap V2 pair through ETH/ERC20 Tokens
938     @param _FromTokenContractAddress The ERC20 token used for investment (address(0x00) if ether)
939     @param _pairAddress The Uniswap pair address
940     @param _amount The amount of fromToken to invest
941     @param _minPoolTokens Reverts if less tokens received than this
942     @param _allowanceTarget Spender for the first swap
943     @param _swapTarget Excecution target for the first swap
944     @param swapData DEX quote data
945     @return Amount of LP bought
946      */
947     function ZapIn(
948         address _FromTokenContractAddress,
949         address _pairAddress,
950         uint256 _amount,
951         uint256 _minPoolTokens,
952         address _allowanceTarget,
953         address _swapTarget,
954         bytes calldata swapData
955     ) external payable nonReentrant stopInEmergency returns (uint256) {
956         uint256 toInvest;
957         if (_FromTokenContractAddress == address(0)) {
958             require(msg.value > 0, "Error: ETH not sent");
959             toInvest = msg.value;
960         } else {
961             require(msg.value == 0, "Error: ETH sent");
962             require(_amount > 0, "Error: Invalid ERC amount");
963             IERC20(_FromTokenContractAddress).safeTransferFrom(
964                 msg.sender,
965                 address(this),
966                 _amount
967             );
968             toInvest = _amount;
969         }
970 
971         uint256 LPBought = _performZapIn(
972             _FromTokenContractAddress,
973             _pairAddress,
974             toInvest,
975             _allowanceTarget,
976             _swapTarget,
977             swapData
978         );
979         require(LPBought >= _minPoolTokens, "ERR: High Slippage");
980 
981         //transfer goodwill
982         uint256 goodwillPortion = _transferGoodwill(_pairAddress, LPBought);
983 
984         IERC20(_pairAddress).safeTransfer(
985             msg.sender,
986             SafeMath.sub(LPBought, goodwillPortion)
987         );
988         return SafeMath.sub(LPBought, goodwillPortion);
989     }
990 
991     function _getPairTokens(address _pairAddress)
992         internal
993         pure
994         returns (address token0, address token1)
995     {
996         IUniswapV2Pair uniPair = IUniswapV2Pair(_pairAddress);
997         token0 = uniPair.token0();
998         token1 = uniPair.token1();
999     }
1000 
1001     function _performZapIn(
1002         address _FromTokenContractAddress,
1003         address _pairAddress,
1004         uint256 _amount,
1005         address _allowanceTarget,
1006         address _swapTarget,
1007         bytes memory swapData
1008     ) internal returns (uint256) {
1009         uint256 intermediateAmt;
1010         address intermediateToken;
1011         (address _ToUniswapToken0, address _ToUniswapToken1) = _getPairTokens(
1012             _pairAddress
1013         );
1014 
1015         if (
1016             _FromTokenContractAddress != _ToUniswapToken0 &&
1017             _FromTokenContractAddress != _ToUniswapToken1
1018         ) {
1019             // swap to intermediate
1020             (intermediateAmt, intermediateToken) = _fillQuote(
1021                 _FromTokenContractAddress,
1022                 _pairAddress,
1023                 _amount,
1024                 _allowanceTarget,
1025                 _swapTarget,
1026                 swapData
1027             );
1028         } else {
1029             intermediateToken = _FromTokenContractAddress;
1030             intermediateAmt = _amount;
1031         }
1032         // divide intermediate into appropriate amount to add liquidity
1033         (uint256 token0Bought, uint256 token1Bought) = _swapIntermediate(
1034             intermediateToken,
1035             _ToUniswapToken0,
1036             _ToUniswapToken1,
1037             intermediateAmt
1038         );
1039 
1040         return
1041             _uniDeposit(
1042                 _ToUniswapToken0,
1043                 _ToUniswapToken1,
1044                 token0Bought,
1045                 token1Bought
1046             );
1047     }
1048 
1049     function _uniDeposit(
1050         address _ToUnipoolToken0,
1051         address _ToUnipoolToken1,
1052         uint256 token0Bought,
1053         uint256 token1Bought
1054     ) internal returns (uint256) {
1055         IERC20(_ToUnipoolToken0).safeApprove(address(uniswapRouter), 0);
1056         IERC20(_ToUnipoolToken1).safeApprove(address(uniswapRouter), 0);
1057 
1058         IERC20(_ToUnipoolToken0).safeApprove(
1059             address(uniswapRouter),
1060             token0Bought
1061         );
1062         IERC20(_ToUnipoolToken1).safeApprove(
1063             address(uniswapRouter),
1064             token1Bought
1065         );
1066 
1067         (uint256 amountA, uint256 amountB, uint256 LP) = uniswapRouter
1068             .addLiquidity(
1069             _ToUnipoolToken0,
1070             _ToUnipoolToken1,
1071             token0Bought,
1072             token1Bought,
1073             1,
1074             1,
1075             address(this),
1076             deadline
1077         );
1078 
1079         //Returning Residue in token0, if any.
1080         if (token0Bought.sub(amountA) > 0) {
1081             IERC20(_ToUnipoolToken0).safeTransfer(
1082                 msg.sender,
1083                 token0Bought.sub(amountA)
1084             );
1085         }
1086 
1087         //Returning Residue in token1, if any
1088         if (token1Bought.sub(amountB) > 0) {
1089             IERC20(_ToUnipoolToken1).safeTransfer(
1090                 msg.sender,
1091                 token1Bought.sub(amountB)
1092             );
1093         }
1094 
1095         return LP;
1096     }
1097 
1098     function _fillQuote(
1099         address _fromTokenAddress,
1100         address _pairAddress,
1101         uint256 _amount,
1102         address _allowanceTarget,
1103         address _swapTarget,
1104         bytes memory swapCallData
1105     ) internal returns (uint256 amountBought, address intermediateToken) {
1106         uint256 valueToSend;
1107         if (_fromTokenAddress == address(0)) {
1108             valueToSend = _amount;
1109         } else {
1110             IERC20 fromToken = IERC20(_fromTokenAddress);
1111             fromToken.safeApprove(address(_allowanceTarget), 0);
1112             fromToken.safeApprove(address(_allowanceTarget), _amount);
1113         }
1114 
1115         (address _token0, address _token1) = _getPairTokens(_pairAddress);
1116         IERC20 token0 = IERC20(_token0);
1117         IERC20 token1 = IERC20(_token1);
1118         uint256 initialBalance0 = token0.balanceOf(address(this));
1119         uint256 initialBalance1 = token1.balanceOf(address(this));
1120 
1121         (bool success, ) = _swapTarget.call.value(valueToSend)(swapCallData);
1122         require(success, "Error Swapping Tokens 1");
1123 
1124         uint256 finalBalance0 = token0.balanceOf(address(this)).sub(
1125             initialBalance0
1126         );
1127         uint256 finalBalance1 = token1.balanceOf(address(this)).sub(
1128             initialBalance1
1129         );
1130 
1131         if (finalBalance0 > finalBalance1) {
1132             amountBought = finalBalance0;
1133             intermediateToken = _token0;
1134         } else {
1135             amountBought = finalBalance1;
1136             intermediateToken = _token1;
1137         }
1138 
1139         require(amountBought > 0, "Swapped to Invalid Intermediate");
1140     }
1141 
1142     function _swapIntermediate(
1143         address _toContractAddress,
1144         address _ToUnipoolToken0,
1145         address _ToUnipoolToken1,
1146         uint256 _amount
1147     ) internal returns (uint256 token0Bought, uint256 token1Bought) {
1148         IUniswapV2Pair pair = IUniswapV2Pair(
1149             UniSwapV2FactoryAddress.getPair(_ToUnipoolToken0, _ToUnipoolToken1)
1150         );
1151         (uint256 res0, uint256 res1, ) = pair.getReserves();
1152         if (_toContractAddress == _ToUnipoolToken0) {
1153             uint256 amountToSwap = calculateSwapInAmount(res0, _amount);
1154             //if no reserve or a new pair is created
1155             if (amountToSwap <= 0) amountToSwap = _amount.div(2);
1156             token1Bought = _token2Token(
1157                 _toContractAddress,
1158                 _ToUnipoolToken1,
1159                 amountToSwap
1160             );
1161             token0Bought = _amount.sub(amountToSwap);
1162         } else {
1163             uint256 amountToSwap = calculateSwapInAmount(res1, _amount);
1164             //if no reserve or a new pair is created
1165             if (amountToSwap <= 0) amountToSwap = _amount.div(2);
1166             token0Bought = _token2Token(
1167                 _toContractAddress,
1168                 _ToUnipoolToken0,
1169                 amountToSwap
1170             );
1171             token1Bought = _amount.sub(amountToSwap);
1172         }
1173     }
1174 
1175     function calculateSwapInAmount(uint256 reserveIn, uint256 userIn)
1176         internal
1177         pure
1178         returns (uint256)
1179     {
1180         return
1181             Babylonian
1182                 .sqrt(
1183                 reserveIn.mul(userIn.mul(3988000) + reserveIn.mul(3988009))
1184             )
1185                 .sub(reserveIn.mul(1997)) / 1994;
1186     }
1187 
1188     /**
1189     @notice This function is used to swap ERC20 <> ERC20
1190     @param _FromTokenContractAddress The token address to swap from.
1191     @param _ToTokenContractAddress The token address to swap to. 
1192     @param tokens2Trade The amount of tokens to swap
1193     @return tokenBought The quantity of tokens bought
1194     */
1195     function _token2Token(
1196         address _FromTokenContractAddress,
1197         address _ToTokenContractAddress,
1198         uint256 tokens2Trade
1199     ) internal returns (uint256 tokenBought) {
1200         if (_FromTokenContractAddress == _ToTokenContractAddress) {
1201             return tokens2Trade;
1202         }
1203         IERC20(_FromTokenContractAddress).safeApprove(
1204             address(uniswapRouter),
1205             0
1206         );
1207         IERC20(_FromTokenContractAddress).safeApprove(
1208             address(uniswapRouter),
1209             tokens2Trade
1210         );
1211 
1212         if (_FromTokenContractAddress != wethTokenAddress) {
1213             if (_ToTokenContractAddress != wethTokenAddress) {
1214                 // check output via tokenA -> tokenB
1215                 address pairA = UniSwapV2FactoryAddress.getPair(
1216                     _FromTokenContractAddress,
1217                     _ToTokenContractAddress
1218                 );
1219                 address[] memory pathA = new address[](2);
1220                 pathA[0] = _FromTokenContractAddress;
1221                 pathA[1] = _ToTokenContractAddress;
1222                 uint256 amtA;
1223                 if (pairA != address(0)) {
1224                     amtA = uniswapRouter.getAmountsOut(tokens2Trade, pathA)[1];
1225                 }
1226 
1227                 // check output via tokenA -> weth -> tokenB
1228                 address[] memory pathB = new address[](3);
1229                 pathB[0] = _FromTokenContractAddress;
1230                 pathB[1] = wethTokenAddress;
1231                 pathB[2] = _ToTokenContractAddress;
1232 
1233                 uint256 amtB = uniswapRouter.getAmountsOut(
1234                     tokens2Trade,
1235                     pathB
1236                 )[2];
1237 
1238                 if (amtA >= amtB) {
1239                     tokenBought = uniswapRouter.swapExactTokensForTokens(
1240                         tokens2Trade,
1241                         1,
1242                         pathA,
1243                         address(this),
1244                         deadline
1245                     )[pathA.length - 1];
1246                 } else {
1247                     tokenBought = uniswapRouter.swapExactTokensForTokens(
1248                         tokens2Trade,
1249                         1,
1250                         pathB,
1251                         address(this),
1252                         deadline
1253                     )[pathB.length - 1];
1254                 }
1255             } else {
1256                 address[] memory path = new address[](2);
1257                 path[0] = _FromTokenContractAddress;
1258                 path[1] = wethTokenAddress;
1259 
1260                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1261                     tokens2Trade,
1262                     1,
1263                     path,
1264                     address(this),
1265                     deadline
1266                 )[path.length - 1];
1267             }
1268         } else {
1269             address[] memory path = new address[](2);
1270             path[0] = wethTokenAddress;
1271             path[1] = _ToTokenContractAddress;
1272             tokenBought = uniswapRouter.swapExactTokensForTokens(
1273                 tokens2Trade,
1274                 1,
1275                 path,
1276                 address(this),
1277                 deadline
1278             )[path.length - 1];
1279         }
1280 
1281         require(tokenBought > 0, "Error Swapping Tokens 2");
1282     }
1283 
1284     /**
1285     @notice This function is used to calculate and transfer goodwill
1286     @param _tokenContractAddress Token in which goodwill is deducted
1287     @param tokens2Trade The total amount of tokens to be zapped in
1288     @return The quantity of goodwill deducted
1289      */
1290     function _transferGoodwill(
1291         address _tokenContractAddress,
1292         uint256 tokens2Trade
1293     ) internal returns (uint256 goodwillPortion) {
1294         goodwillPortion = SafeMath.div(
1295             SafeMath.mul(tokens2Trade, goodwill),
1296             10000
1297         );
1298 
1299         if (goodwillPortion == 0) {
1300             return 0;
1301         }
1302 
1303         IERC20(_tokenContractAddress).safeTransfer(
1304             zgoodwillAddress,
1305             goodwillPortion
1306         );
1307     }
1308 
1309     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1310         require(
1311             _new_goodwill >= 0 && _new_goodwill < 10000,
1312             "GoodWill Value not allowed"
1313         );
1314         goodwill = _new_goodwill;
1315     }
1316 
1317     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1318         uint256 qty = _TokenAddress.balanceOf(address(this));
1319         _TokenAddress.safeTransfer(owner(), qty);
1320     }
1321 
1322     // - to Pause the contract
1323     function toggleContractActive() public onlyOwner {
1324         stopped = !stopped;
1325     }
1326 
1327     // - to withdraw any ETH balance sitting in the contract
1328     function withdraw() public onlyOwner {
1329         uint256 contractBalance = address(this).balance;
1330         address payable _to = owner().toPayable();
1331         _to.transfer(contractBalance);
1332     }
1333 }