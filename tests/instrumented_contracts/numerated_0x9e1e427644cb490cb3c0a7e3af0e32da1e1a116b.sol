1 // Modified for use with SYNC, modifications not made by Zapper
2 
3 // Copyright (C) 2020 zapper, nodar, suhail, seb, sumit, apoorv
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU Affero General Public License as published by
7 // the Free Software Foundation, either version 2 of the License, or
8 // (at your option) any later version.
9 //
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU Affero General Public License for more details.
14 //
15 
16 ///@author Zapper
17 ///@notice This contract adds liquidity to Uniswap V2 pools using ETH or any ERC20 Token.
18 // SPDX-License-Identifier: GPLv2
19 
20 pragma solidity ^0.6.0;
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
24  * the optional functions; to access them see {ERC20Detailed}.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount)
45         external
46         returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender)
56         external
57         view
58         returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(
104         address indexed owner,
105         address indexed spender,
106         uint256 value
107     );
108 }
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      * - Subtraction cannot overflow.
161      *
162      * _Available since v2.4.0._
163      */
164     function sub(
165         uint256 a,
166         uint256 b,
167         string memory errorMessage
168     ) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(
227         uint256 a,
228         uint256 b,
229         string memory errorMessage
230     ) internal pure returns (uint256) {
231         // Solidity only automatically asserts when dividing by 0
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      *
265      * _Available since v2.4.0._
266      */
267     function mod(
268         uint256 a,
269         uint256 b,
270         string memory errorMessage
271     ) internal pure returns (uint256) {
272         require(b != 0, errorMessage);
273         return a % b;
274     }
275 }
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303 
304 
305             bytes32 accountHash
306          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
307         // solhint-disable-next-line no-inline-assembly
308         assembly {
309             codehash := extcodehash(account)
310         }
311         return (codehash != accountHash && codehash != 0x0);
312     }
313 
314     /**
315      * @dev Converts an `address` into `address payable`. Note that this is
316      * simply a type cast: the actual underlying value is not changed.
317      *
318      * _Available since v2.4.0._
319      */
320     function toPayable(address account)
321         internal
322         pure
323         returns (address payable)
324     {
325         return address(uint160(account));
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      *
344      * _Available since v2.4.0._
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(
348             address(this).balance >= amount,
349             "Address: insufficient balance"
350         );
351 
352         // solhint-disable-next-line avoid-call-value
353         (bool success, ) = recipient.call.value(amount)("");
354         require(
355             success,
356             "Address: unable to send value, recipient may have reverted"
357         );
358     }
359 }
360 
361 /**
362  * @title SafeERC20
363  * @dev Wrappers around ERC20 operations that throw on failure (when the token
364  * contract returns false). Tokens that return no value (and instead revert or
365  * throw on failure) are also supported, non-reverting calls are assumed to be
366  * successful.
367  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
368  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
369  */
370 library SafeERC20 {
371     using SafeMath for uint256;
372     using Address for address;
373 
374     function safeTransfer(
375         IERC20 token,
376         address to,
377         uint256 value
378     ) internal {
379         callOptionalReturn(
380             token,
381             abi.encodeWithSelector(token.transfer.selector, to, value)
382         );
383     }
384 
385     function safeTransferFrom(
386         IERC20 token,
387         address from,
388         address to,
389         uint256 value
390     ) internal {
391         callOptionalReturn(
392             token,
393             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
394         );
395     }
396 
397     function safeApprove(
398         IERC20 token,
399         address spender,
400         uint256 value
401     ) internal {
402         // safeApprove should only be called when setting an initial allowance,
403         // or when resetting it to zero. To increase and decrease it, use
404         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
405         // solhint-disable-next-line max-line-length
406         require(
407             (value == 0) || (token.allowance(address(this), spender) == 0),
408             "SafeERC20: approve from non-zero to non-zero allowance"
409         );
410         callOptionalReturn(
411             token,
412             abi.encodeWithSelector(token.approve.selector, spender, value)
413         );
414     }
415 
416     function safeIncreaseAllowance(
417         IERC20 token,
418         address spender,
419         uint256 value
420     ) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).add(
422             value
423         );
424         callOptionalReturn(
425             token,
426             abi.encodeWithSelector(
427                 token.approve.selector,
428                 spender,
429                 newAllowance
430             )
431         );
432     }
433 
434     function safeDecreaseAllowance(
435         IERC20 token,
436         address spender,
437         uint256 value
438     ) internal {
439         uint256 newAllowance = token.allowance(address(this), spender).sub(
440             value,
441             "SafeERC20: decreased allowance below zero"
442         );
443         callOptionalReturn(
444             token,
445             abi.encodeWithSelector(
446                 token.approve.selector,
447                 spender,
448                 newAllowance
449             )
450         );
451     }
452 
453     /**
454      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
455      * on the return value: the return value is optional (but if data is returned, it must not be false).
456      * @param token The token targeted by the call.
457      * @param data The call data (encoded using abi.encode or one of its variants).
458      */
459     function callOptionalReturn(IERC20 token, bytes memory data) private {
460         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
461         // we're implementing it ourselves.
462 
463         // A Solidity high level call has three parts:
464         //  1. The target address is checked to verify it contains contract code
465         //  2. The call itself is made, and success asserted
466         //  3. The return value is decoded, which in turn checks the size of the returned data.
467         // solhint-disable-next-line max-line-length
468         require(address(token).isContract(), "SafeERC20: call to non-contract");
469 
470         // solhint-disable-next-line avoid-low-level-calls
471         (bool success, bytes memory returndata) = address(token).call(data);
472         require(success, "SafeERC20: low-level call failed");
473 
474         if (returndata.length > 0) {
475             // Return data is optional
476             // solhint-disable-next-line max-line-length
477             require(
478                 abi.decode(returndata, (bool)),
479                 "SafeERC20: ERC20 operation did not succeed"
480             );
481         }
482     }
483 }
484 
485 /**
486  * @dev Contract module that helps prevent reentrant calls to a function.
487  *
488  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
489  * available, which can be applied to functions to make sure there are no nested
490  * (reentrant) calls to them.
491  *
492  * Note that because there is a single `nonReentrant` guard, functions marked as
493  * `nonReentrant` may not call one another. This can be worked around by making
494  * those functions `private`, and then adding `external` `nonReentrant` entry
495  * points to them.
496  *
497  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
498  * metering changes introduced in the Istanbul hardfork.
499  */
500 contract ReentrancyGuard {
501     bool private _notEntered;
502 
503     constructor() internal {
504         // Storing an initial non-zero value makes deployment a bit more
505         // expensive, but in exchange the refund on every call to nonReentrant
506         // will be lower in amount. Since refunds are capped to a percetange of
507         // the total transaction's gas, it is best to keep them low in cases
508         // like this one, to increase the likelihood of the full refund coming
509         // into effect.
510         _notEntered = true;
511     }
512 
513     /**
514      * @dev Prevents a contract from calling itself, directly or indirectly.
515      * Calling a `nonReentrant` function from another `nonReentrant`
516      * function is not supported. It is possible to prevent this from happening
517      * by making the `nonReentrant` function external, and make it call a
518      * `private` function that does the actual work.
519      */
520     modifier nonReentrant() {
521         // On the first call to nonReentrant, _notEntered will be true
522         require(_notEntered, "ReentrancyGuard: reentrant call");
523 
524         // Any calls to nonReentrant after this point will fail
525         _notEntered = false;
526 
527         _;
528 
529         // By storing the original value once again, a refund is triggered (see
530         // https://eips.ethereum.org/EIPS/eip-2200)
531         _notEntered = true;
532     }
533 }
534 
535 /*
536  * @dev Provides information about the current execution context, including the
537  * sender of the transaction and its data. While these are generally available
538  * via msg.sender and msg.data, they should not be accessed in such a direct
539  * manner, since when dealing with GSN meta-transactions the account sending and
540  * paying for execution may not be the actual sender (as far as an application
541  * is concerned).
542  *
543  * This contract is only required for intermediate, library-like contracts.
544  */
545 contract Context {
546     // Empty internal constructor, to prevent people from mistakenly deploying
547     // an instance of this contract, which should be used via inheritance.
548     constructor() internal {}
549 
550     // solhint-disable-previous-line no-empty-blocks
551 
552     function _msgSender() internal view returns (address payable) {
553         return msg.sender;
554     }
555 
556     function _msgData() internal view returns (bytes memory) {
557         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
558         return msg.data;
559     }
560 }
561 
562 /**
563  * @dev Contract module which provides a basic access control mechanism, where
564  * there is an account (an owner) that can be granted exclusive access to
565  * specific functions.
566  *
567  * This module is used through inheritance. It will make available the modifier
568  * `onlyOwner`, which can be applied to your functions to restrict their use to
569  * the owner.
570  */
571 contract Ownable is Context {
572     address payable public _owner;
573 
574     event OwnershipTransferred(
575         address indexed previousOwner,
576         address indexed newOwner
577     );
578 
579     /**
580      * @dev Initializes the contract setting the deployer as the initial owner.
581      */
582     constructor() internal {
583         address payable msgSender = _msgSender();
584         _owner = msgSender;
585         emit OwnershipTransferred(address(0), msgSender);
586     }
587 
588     /**
589      * @dev Returns the address of the current owner.
590      */
591     function owner() public view returns (address) {
592         return _owner;
593     }
594 
595     /**
596      * @dev Throws if called by any account other than the owner.
597      */
598     modifier onlyOwner() {
599         require(isOwner(), "Ownable: caller is not the owner");
600         _;
601     }
602 
603     /**
604      * @dev Returns true if the caller is the current owner.
605      */
606     function isOwner() public view returns (bool) {
607         return _msgSender() == _owner;
608     }
609 
610     /**
611      * @dev Leaves the contract without owner. It will not be possible to call
612      * `onlyOwner` functions anymore. Can only be called by the current owner.
613      *
614      * NOTE: Renouncing ownership will leave the contract without an owner,
615      * thereby removing any functionality that is only available to the owner.
616      */
617     function renounceOwnership() public onlyOwner {
618         emit OwnershipTransferred(_owner, address(0));
619         _owner = address(0);
620     }
621 
622     /**
623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
624      * Can only be called by the current owner.
625      */
626     function transferOwnership(address payable newOwner) public onlyOwner {
627         _transferOwnership(newOwner);
628     }
629 
630     /**
631      * @dev Transfers ownership of the contract to a new account (`newOwner`).
632      */
633     function _transferOwnership(address payable newOwner) internal {
634         require(
635             newOwner != address(0),
636             "Ownable: new owner is the zero address"
637         );
638         emit OwnershipTransferred(_owner, newOwner);
639         _owner = newOwner;
640     }
641 }
642 
643 // import "@uniswap/lib/contracts/libraries/Babylonian.sol";
644 library Babylonian {
645     function sqrt(uint256 y) internal pure returns (uint256 z) {
646         if (y > 3) {
647             z = y;
648             uint256 x = y / 2 + 1;
649             while (x < z) {
650                 z = x;
651                 x = (y / x + x) / 2;
652             }
653         } else if (y != 0) {
654             z = 1;
655         }
656         // else z = 0
657     }
658 }
659 
660 interface IWETH {
661     function deposit() external payable;
662 
663     function transfer(address to, uint256 value) external returns (bool);
664 
665     function withdraw(uint256) external;
666 }
667 
668 interface IUniswapV2Factory {
669     function getPair(address tokenA, address tokenB)
670         external
671         view
672         returns (address);
673 }
674 
675 interface IUniswapV2Router02 {
676     function factory() external pure returns (address);
677 
678     function WETH() external pure returns (address);
679 
680     function addLiquidity(
681         address tokenA,
682         address tokenB,
683         uint256 amountADesired,
684         uint256 amountBDesired,
685         uint256 amountAMin,
686         uint256 amountBMin,
687         address to,
688         uint256 deadline
689     )
690         external
691         returns (
692             uint256 amountA,
693             uint256 amountB,
694             uint256 liquidity
695         );
696 
697     function addLiquidityETH(
698         address token,
699         uint256 amountTokenDesired,
700         uint256 amountTokenMin,
701         uint256 amountETHMin,
702         address to,
703         uint256 deadline
704     )
705         external
706         payable
707         returns (
708             uint256 amountToken,
709             uint256 amountETH,
710             uint256 liquidity
711         );
712 
713     function removeLiquidity(
714         address tokenA,
715         address tokenB,
716         uint256 liquidity,
717         uint256 amountAMin,
718         uint256 amountBMin,
719         address to,
720         uint256 deadline
721     ) external returns (uint256 amountA, uint256 amountB);
722 
723     function removeLiquidityETH(
724         address token,
725         uint256 liquidity,
726         uint256 amountTokenMin,
727         uint256 amountETHMin,
728         address to,
729         uint256 deadline
730     ) external returns (uint256 amountToken, uint256 amountETH);
731 
732     function removeLiquidityWithPermit(
733         address tokenA,
734         address tokenB,
735         uint256 liquidity,
736         uint256 amountAMin,
737         uint256 amountBMin,
738         address to,
739         uint256 deadline,
740         bool approveMax,
741         uint8 v,
742         bytes32 r,
743         bytes32 s
744     ) external returns (uint256 amountA, uint256 amountB);
745 
746     function removeLiquidityETHWithPermit(
747         address token,
748         uint256 liquidity,
749         uint256 amountTokenMin,
750         uint256 amountETHMin,
751         address to,
752         uint256 deadline,
753         bool approveMax,
754         uint8 v,
755         bytes32 r,
756         bytes32 s
757     ) external returns (uint256 amountToken, uint256 amountETH);
758 
759     function swapExactTokensForTokens(
760         uint256 amountIn,
761         uint256 amountOutMin,
762         address[] calldata path,
763         address to,
764         uint256 deadline
765     ) external returns (uint256[] memory amounts);
766 
767     function swapTokensForExactTokens(
768         uint256 amountOut,
769         uint256 amountInMax,
770         address[] calldata path,
771         address to,
772         uint256 deadline
773     ) external returns (uint256[] memory amounts);
774 
775     function swapExactETHForTokens(
776         uint256 amountOutMin,
777         address[] calldata path,
778         address to,
779         uint256 deadline
780     ) external payable returns (uint256[] memory amounts);
781 
782     function swapTokensForExactETH(
783         uint256 amountOut,
784         uint256 amountInMax,
785         address[] calldata path,
786         address to,
787         uint256 deadline
788     ) external returns (uint256[] memory amounts);
789 
790     function swapExactTokensForETH(
791         uint256 amountIn,
792         uint256 amountOutMin,
793         address[] calldata path,
794         address to,
795         uint256 deadline
796     ) external returns (uint256[] memory amounts);
797 
798     function swapETHForExactTokens(
799         uint256 amountOut,
800         address[] calldata path,
801         address to,
802         uint256 deadline
803     ) external payable returns (uint256[] memory amounts);
804 
805     function removeLiquidityETHSupportingFeeOnTransferTokens(
806         address token,
807         uint256 liquidity,
808         uint256 amountTokenMin,
809         uint256 amountETHMin,
810         address to,
811         uint256 deadline
812     ) external returns (uint256 amountETH);
813 
814     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
815         address token,
816         uint256 liquidity,
817         uint256 amountTokenMin,
818         uint256 amountETHMin,
819         address to,
820         uint256 deadline,
821         bool approveMax,
822         uint8 v,
823         bytes32 r,
824         bytes32 s
825     ) external returns (uint256 amountETH);
826 
827     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
828         uint256 amountIn,
829         uint256 amountOutMin,
830         address[] calldata path,
831         address to,
832         uint256 deadline
833     ) external;
834 
835     function swapExactETHForTokensSupportingFeeOnTransferTokens(
836         uint256 amountOutMin,
837         address[] calldata path,
838         address to,
839         uint256 deadline
840     ) external payable;
841 
842     function swapExactTokensForETHSupportingFeeOnTransferTokens(
843         uint256 amountIn,
844         uint256 amountOutMin,
845         address[] calldata path,
846         address to,
847         uint256 deadline
848     ) external;
849 
850     function quote(
851         uint256 amountA,
852         uint256 reserveA,
853         uint256 reserveB
854     ) external pure returns (uint256 amountB);
855 
856     function getAmountOut(
857         uint256 amountIn,
858         uint256 reserveIn,
859         uint256 reserveOut
860     ) external pure returns (uint256 amountOut);
861 
862     function getAmountIn(
863         uint256 amountOut,
864         uint256 reserveIn,
865         uint256 reserveOut
866     ) external pure returns (uint256 amountIn);
867 
868     function getAmountsOut(uint256 amountIn, address[] calldata path)
869         external
870         view
871         returns (uint256[] memory amounts);
872 
873     function getAmountsIn(uint256 amountOut, address[] calldata path)
874         external
875         view
876         returns (uint256[] memory amounts);
877 }
878 
879 interface IUniswapV2Pair {
880     function token0() external pure returns (address);
881 
882     function token1() external pure returns (address);
883 
884     function getReserves()
885         external
886         view
887         returns (
888             uint112 _reserve0,
889             uint112 _reserve1,
890             uint32 _blockTimestampLast
891         );
892 }
893 
894 contract ZapInModified is ReentrancyGuard, Ownable {
895     using SafeMath for uint256;
896     using Address for address;
897     using SafeERC20 for IERC20;
898 
899     bool public stopped = false;
900 
901     IUniswapV2Router02 private constant uniswapRouter = IUniswapV2Router02(
902         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
903     );
904 
905     IUniswapV2Factory
906         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
907         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
908     );
909 
910     address
911         private wethTokenAddress;
912 
913     uint256
914         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
915 
916     constructor() public {
917         wethTokenAddress=uniswapRouter.WETH();
918     }
919 
920     // circuit breaker modifiers
921     modifier stopInEmergency {
922         if (stopped) {
923             revert("Temporarily Paused");
924         } else {
925             _;
926         }
927     }
928 
929     /**
930     @notice This function is used to invest in given Uniswap V2 pair through ETH/ERC20 Tokens
931     @param _FromTokenContractAddress The ERC20 token used for investment (address(0x00) if ether)
932     @param _ToUnipoolToken0 The Uniswap V2 pair token0 address
933     @param _ToUnipoolToken1 The Uniswap V2 pair token1 address
934     @param _amount The amount of fromToken to invest
935     @param _minPoolTokens Reverts if less tokens received than this
936     @return Amount of LP bought
937      */
938     function ZapIn(
939         address _toWhomToIssue,
940         address _FromTokenContractAddress,
941         address _ToUnipoolToken0,
942         address _ToUnipoolToken1,
943         uint256 _amount,
944         uint256 _minPoolTokens
945     ) public payable nonReentrant stopInEmergency returns (uint256) {
946         uint256 toInvest;
947         if (_FromTokenContractAddress == address(0)) {
948             require(msg.value > 0, "Error: ETH not sent");
949             toInvest = msg.value;
950         } else {
951             require(msg.value == 0, "Error: ETH sent");
952             require(_amount > 0, "Error: Invalid ERC amount");
953             IERC20(_FromTokenContractAddress).safeTransferFrom(
954                 msg.sender,
955                 address(this),
956                 _amount
957             );
958             toInvest = _amount;
959         }
960 
961         uint256 LPBought = _performZapIn(
962             _toWhomToIssue,
963             _FromTokenContractAddress,
964             _ToUnipoolToken0,
965             _ToUnipoolToken1,
966             toInvest
967         );
968         require(LPBought >= _minPoolTokens, "ERR: High Slippage");
969 
970         //get pair address
971         address _ToUniPoolAddress = UniSwapV2FactoryAddress.getPair(
972             _ToUnipoolToken0,
973             _ToUnipoolToken1
974         );
975 
976         IERC20(_ToUniPoolAddress).safeTransfer(
977             _toWhomToIssue,
978             LPBought
979         );
980         return LPBought;
981     }
982     event DebugZap(uint256 ethToTrade,uint256 tokens0,uint256 tokens1,uint256 liquidityObtained);
983     function _performZapIn(
984         address _toWhomToIssue,
985         address _FromTokenContractAddress,
986         address _ToUnipoolToken0,
987         address _ToUnipoolToken1,
988         uint256 _amount
989     ) internal returns (uint256) {
990         address intermediate = _getIntermediate(
991             _FromTokenContractAddress,
992             _amount,
993             _ToUnipoolToken0,
994             _ToUnipoolToken1
995         );
996 
997         // swap to intermediate
998         uint256 interAmt = _token2Token(
999             _FromTokenContractAddress,
1000             intermediate,
1001             _amount
1002         );
1003 
1004         // divide to swap in amounts
1005         uint256 token0Bought;
1006         uint256 token1Bought;
1007 
1008         IUniswapV2Pair pair = IUniswapV2Pair(
1009             UniSwapV2FactoryAddress.getPair(_ToUnipoolToken0, _ToUnipoolToken1)
1010         );
1011         (uint256 res0, uint256 res1, ) = pair.getReserves();
1012         uint256 amountToSwap;
1013         if (intermediate == _ToUnipoolToken0) {
1014             amountToSwap = calculateSwapInAmount(res0, interAmt);
1015             //if no reserve or a new pair is created
1016             if (amountToSwap <= 0) amountToSwap = interAmt.div(2);
1017             token1Bought = _token2Token(
1018                 intermediate,
1019                 _ToUnipoolToken1,
1020                 amountToSwap
1021             );
1022             token0Bought = interAmt.sub(amountToSwap);
1023         } else {
1024             amountToSwap = calculateSwapInAmount(res1, interAmt);
1025             //if no reserve or a new pair is created
1026             if (amountToSwap <= 0) amountToSwap = interAmt.div(2);
1027             token0Bought = _token2Token(
1028                 intermediate,
1029                 _ToUnipoolToken0,
1030                 amountToSwap
1031             );
1032             token1Bought = interAmt.sub(amountToSwap);
1033         }
1034 
1035         uint256 lobt=_uniDeposit(
1036             _toWhomToIssue,
1037             _ToUnipoolToken0,
1038             _ToUnipoolToken1,
1039             token0Bought,
1040             token1Bought
1041         );
1042         emit DebugZap(amountToSwap,token0Bought,token1Bought,lobt);
1043         return
1044             lobt;
1045     }
1046 
1047     function _uniDeposit(
1048         address _toWhomToIssue,
1049         address _ToUnipoolToken0,
1050         address _ToUnipoolToken1,
1051         uint256 token0Bought,
1052         uint256 token1Bought
1053     ) internal returns (uint256) {
1054         IERC20(_ToUnipoolToken0).safeApprove(
1055             address(uniswapRouter),
1056             token0Bought
1057         );
1058         IERC20(_ToUnipoolToken1).safeApprove(
1059             address(uniswapRouter),
1060             token1Bought
1061         );
1062 
1063         (uint256 amountA, uint256 amountB, uint256 LP) = uniswapRouter
1064             .addLiquidity(
1065             _ToUnipoolToken0,
1066             _ToUnipoolToken1,
1067             token0Bought,
1068             token1Bought,
1069             1,
1070             1,
1071             address(this),
1072             deadline
1073         );
1074 
1075         IERC20(_ToUnipoolToken0).safeApprove(
1076             address(uniswapRouter),
1077             0
1078         );
1079         IERC20(_ToUnipoolToken1).safeApprove(
1080             address(uniswapRouter),
1081             0
1082         );
1083 
1084         //Returning Residue in token0, if any.
1085         if (token0Bought.sub(amountA) > 0) {
1086             IERC20(_ToUnipoolToken0).safeTransfer(
1087                 _toWhomToIssue,
1088                 token0Bought.sub(amountA)
1089             );
1090         }
1091 
1092         //Returning Residue in token1, if any
1093         if (token1Bought.sub(amountB) > 0) {
1094             IERC20(_ToUnipoolToken1).safeTransfer(
1095                 _toWhomToIssue,
1096                 token1Bought.sub(amountB)
1097             );
1098         }
1099 
1100         return LP;
1101     }
1102 
1103     function _getIntermediate(
1104         address _FromTokenContractAddress,
1105         uint256 _amount,
1106         address _ToUnipoolToken0,
1107         address _ToUnipoolToken1
1108     ) internal view returns (address) {
1109         // set from to weth for eth input
1110         if (_FromTokenContractAddress == address(0)) {
1111             _FromTokenContractAddress = wethTokenAddress;
1112         }
1113 
1114         if (_FromTokenContractAddress == _ToUnipoolToken0) {
1115             return _ToUnipoolToken0;
1116         } else if (_FromTokenContractAddress == _ToUnipoolToken1) {
1117             return _ToUnipoolToken1;
1118         } else if(_ToUnipoolToken0 == wethTokenAddress || _ToUnipoolToken1 == wethTokenAddress) {
1119             return wethTokenAddress;
1120         } else {
1121             IUniswapV2Pair pair = IUniswapV2Pair(
1122                 UniSwapV2FactoryAddress.getPair(
1123                     _ToUnipoolToken0,
1124                     _ToUnipoolToken1
1125                 )
1126             );
1127             (uint256 res0, uint256 res1, ) = pair.getReserves();
1128 
1129             uint256 ratio;
1130             bool isToken0Numerator;
1131             if (res0 >= res1) {
1132                 ratio = res0 / res1;
1133                 isToken0Numerator = true;
1134             } else {
1135                 ratio = res1 / res0;
1136             }
1137 
1138             //find outputs on swap
1139             uint256 output0 = _calculateSwapOutput(
1140                 _FromTokenContractAddress,
1141                 _amount,
1142                 _ToUnipoolToken0
1143             );
1144             uint256 output1 = _calculateSwapOutput(
1145                 _FromTokenContractAddress,
1146                 _amount,
1147                 _ToUnipoolToken1
1148             );
1149 
1150             if (isToken0Numerator) {
1151                 if (output1 * ratio >= output0) return _ToUnipoolToken1;
1152                 else return _ToUnipoolToken0;
1153             } else {
1154                 if (output0 * ratio >= output1) return _ToUnipoolToken0;
1155                 else return _ToUnipoolToken1;
1156             }
1157         }
1158     }
1159 
1160     function _calculateSwapOutput(
1161         address _from,
1162         uint256 _amt,
1163         address _to
1164     ) internal view returns (uint256) {
1165         // check output via tokenA -> tokenB
1166         address pairA = UniSwapV2FactoryAddress.getPair(_from, _to);
1167 
1168         uint256 amtA;
1169         if (pairA != address(0)) {
1170             address[] memory pathA = new address[](2);
1171             pathA[0] = _from;
1172             pathA[1] = _to;
1173 
1174             amtA = uniswapRouter.getAmountsOut(_amt, pathA)[1];
1175         }
1176 
1177         uint256 amtB;
1178         // check output via tokenA -> weth -> tokenB
1179         if ((_from != wethTokenAddress) && _to != wethTokenAddress) {
1180             address[] memory pathB = new address[](3);
1181             pathB[0] = _from;
1182             pathB[1] = wethTokenAddress;
1183             pathB[2] = _to;
1184 
1185             amtB = uniswapRouter.getAmountsOut(_amt, pathB)[2];
1186         }
1187 
1188         if (amtA >= amtB) {
1189             return amtA;
1190         } else {
1191             return amtB;
1192         }
1193     }
1194 
1195     /*
1196     */
1197     function zapInSimple(
1198       address _lptaddress,
1199       uint256 _minPoolTokens
1200     ) public payable{
1201       IUniswapV2Pair pair = IUniswapV2Pair(_lptaddress);
1202       ZapIn(
1203           msg.sender,
1204           address(0),
1205           pair.token0(),
1206           pair.token1(),
1207           0,
1208           _minPoolTokens
1209       );
1210     }
1211 
1212     /*
1213       Calculates the value to put in for minpooltokens. Should not be used in the same transaction as zapIn. Slippage as a fraction of 10000 (1% -> 100, 15% -> 1500, etc.).
1214     */
1215     function calculateMinPoolTokens(
1216     address _pair,
1217     uint256 _amount,
1218     uint256 _slippage) external view returns(uint256){
1219       uint256 numTokens=getResultingTokens(_pair,_amount);
1220       return numTokens.sub(numTokens.mul(_slippage).div(10000));
1221     }
1222 
1223     function getResultingTokens(
1224     address _pair,
1225     uint256 _amount) public view returns(uint256){
1226       IUniswapV2Pair pair = IUniswapV2Pair(
1227           _pair//UniSwapV2FactoryAddress.getPair(_ToUnipoolToken0, _ToUnipoolToken1)
1228       );
1229 
1230       address intermediate = _getIntermediate(
1231           address(0),
1232           _amount,
1233           pair.token0(),
1234           pair.token1()
1235       );
1236 
1237       uint256 interAmount=_amount;
1238       if(intermediate != wethTokenAddress){
1239         IUniswapV2Pair pairUpstream = IUniswapV2Pair(
1240             UniSwapV2FactoryAddress.getPair(wethTokenAddress, intermediate)
1241         );
1242         (uint256 resu0, uint256 resu1, ) = pairUpstream.getReserves();
1243         interAmount=uniswapRouter.getAmountOut(
1244           _amount,
1245           pairUpstream.token0()==wethTokenAddress ? resu0 : resu1,
1246           pairUpstream.token0()==wethTokenAddress ? resu1 : resu0
1247         );
1248       }
1249 
1250       (uint256 res0, uint256 res1, ) = pair.getReserves();
1251 
1252       if(pair.token0()==intermediate){
1253         uint256 toSwapAmount=calculateSwapInAmount(res0, interAmount);
1254         return getTokensAcquired(res0,IERC20(address(pair)).totalSupply(),interAmount.sub(toSwapAmount));
1255       }
1256       else{
1257         uint256 toSwapAmount=calculateSwapInAmount(res1, interAmount);
1258         return getTokensAcquired(res1,IERC20(address(pair)).totalSupply(),interAmount.sub(toSwapAmount));
1259       }
1260     }
1261 
1262     function getTokensAcquired(uint256 reserve,uint256 totalSupply,uint256 amount) public view returns(uint256){
1263       return totalSupply.mul(amount).div(reserve.add(amount));
1264     }
1265 
1266     function calculateSwapInAmount(uint256 reserveIn, uint256 userIn)
1267         public
1268         pure
1269         returns (uint256)
1270     {
1271         return
1272             Babylonian
1273                 .sqrt(
1274                 reserveIn.mul(userIn.mul(3988000) + reserveIn.mul(3988009))
1275             )
1276                 .sub(reserveIn.mul(1997)) / 1994;
1277     }
1278 
1279     event DebugTokenSwap(address from, address to,uint256 totrade,uint256 bought);
1280     /**
1281     @notice This function is used to swap ETH/ERC20 <> ETH/ERC20
1282     @param _FromTokenContractAddress The token address to swap from. (0x00 for ETH)
1283     @param _ToTokenContractAddress The token address to swap to. (0x00 for ETH)
1284     @param tokens2Trade The amount of tokens to swap
1285     @return tokenBought The quantity of tokens bought
1286     */
1287     function _token2Token(
1288         address _FromTokenContractAddress,
1289         address _ToTokenContractAddress,
1290         uint256 tokens2Trade
1291     ) internal returns (uint256 tokenBought) {
1292         if (_FromTokenContractAddress == _ToTokenContractAddress) {
1293             return tokens2Trade;
1294         }
1295 
1296         if (_FromTokenContractAddress == address(0)) {
1297             if (_ToTokenContractAddress == wethTokenAddress) {
1298                 IWETH(wethTokenAddress).deposit.value(tokens2Trade)();
1299                 return tokens2Trade;
1300             }
1301 
1302             address[] memory path = new address[](2);
1303             path[0] = wethTokenAddress;
1304             path[1] = _ToTokenContractAddress;
1305             tokenBought = uniswapRouter.swapExactETHForTokens.value(
1306                 tokens2Trade
1307             )(1, path, address(this), deadline)[path.length - 1];
1308         } else if (_ToTokenContractAddress == address(0)) {
1309             if (_FromTokenContractAddress == wethTokenAddress) {
1310                 IWETH(wethTokenAddress).withdraw(tokens2Trade);
1311                 return tokens2Trade;
1312             }
1313 
1314             IERC20(_FromTokenContractAddress).safeApprove(
1315                 address(uniswapRouter),
1316                 tokens2Trade
1317             );
1318 
1319             address[] memory path = new address[](2);
1320             path[0] = _FromTokenContractAddress;
1321             path[1] = wethTokenAddress;
1322             tokenBought = uniswapRouter.swapExactTokensForETH(
1323                 tokens2Trade,
1324                 1,
1325                 path,
1326                 address(this),
1327                 deadline
1328             )[path.length - 1];
1329         } else {
1330             IERC20(_FromTokenContractAddress).safeApprove(
1331                 address(uniswapRouter),
1332                 tokens2Trade
1333             );
1334 
1335             if (_FromTokenContractAddress != wethTokenAddress) {
1336                 if (_ToTokenContractAddress != wethTokenAddress) {
1337                     // check output via tokenA -> tokenB
1338                     address pairA = UniSwapV2FactoryAddress.getPair(
1339                         _FromTokenContractAddress,
1340                         _ToTokenContractAddress
1341                     );
1342                     address[] memory pathA = new address[](2);
1343                     pathA[0] = _FromTokenContractAddress;
1344                     pathA[1] = _ToTokenContractAddress;
1345                     uint256 amtA;
1346                     if (pairA != address(0)) {
1347                         amtA = uniswapRouter.getAmountsOut(
1348                             tokens2Trade,
1349                             pathA
1350                         )[1];
1351                     }
1352 
1353                     // check output via tokenA -> weth -> tokenB
1354                     address[] memory pathB = new address[](3);
1355                     pathB[0] = _FromTokenContractAddress;
1356                     pathB[1] = wethTokenAddress;
1357                     pathB[2] = _ToTokenContractAddress;
1358 
1359                     uint256 amtB = uniswapRouter.getAmountsOut(
1360                         tokens2Trade,
1361                         pathB
1362                     )[2];
1363 
1364                     if (amtA >= amtB) {
1365                         tokenBought = uniswapRouter.swapExactTokensForTokens(
1366                             tokens2Trade,
1367                             1,
1368                             pathA,
1369                             address(this),
1370                             deadline
1371                         )[pathA.length - 1];
1372                     } else {
1373                         tokenBought = uniswapRouter.swapExactTokensForTokens(
1374                             tokens2Trade,
1375                             1,
1376                             pathB,
1377                             address(this),
1378                             deadline
1379                         )[pathB.length - 1];
1380                     }
1381                 } else {
1382                     address[] memory path = new address[](2);
1383                     path[0] = _FromTokenContractAddress;
1384                     path[1] = wethTokenAddress;
1385 
1386                     tokenBought = uniswapRouter.swapExactTokensForTokens(
1387                         tokens2Trade,
1388                         1,
1389                         path,
1390                         address(this),
1391                         deadline
1392                     )[path.length - 1];
1393                 }
1394             } else {
1395                 address[] memory path = new address[](2);
1396                 path[0] = wethTokenAddress;
1397                 path[1] = _ToTokenContractAddress;
1398                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1399                     tokens2Trade,
1400                     1,
1401                     path,
1402                     address(this),
1403                     deadline
1404                 )[path.length - 1];
1405             }
1406         }
1407         require(tokenBought > 0, "Error Swapping Tokens");
1408 
1409         emit DebugTokenSwap(_FromTokenContractAddress, _ToTokenContractAddress,tokens2Trade,tokenBought);
1410     }
1411 
1412     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1413         uint256 qty = _TokenAddress.balanceOf(address(this));
1414         _TokenAddress.safeTransfer(owner(), qty);
1415     }
1416 
1417     // - to Pause the contract
1418     function toggleContractActive() public onlyOwner {
1419         stopped = !stopped;
1420     }
1421 
1422     // - to withdraw any ETH balance sitting in the contract
1423     function withdraw() public onlyOwner {
1424         uint256 contractBalance = address(this).balance;
1425         address payable _to = owner().toPayable();
1426         _to.transfer(contractBalance);
1427     }
1428 
1429 }