1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper, nodar, suhail, seb, sumit, apoorv
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
21 ///@notice this contract swaps between two assets utilizing various liquidity pools.
22 
23 // File: @openzeppelin/contracts/utils/Address.sol
24 
25 pragma solidity ^0.5.5;
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if `account` is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, `isContract` will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
50         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
51         // for accounts without code, i.e. `keccak256('')`
52         bytes32 codehash;
53 
54 
55             bytes32 accountHash
56          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
57         // solhint-disable-next-line no-inline-assembly
58         assembly {
59             codehash := extcodehash(account)
60         }
61         return (codehash != accountHash && codehash != 0x0);
62     }
63 
64     /**
65      * @dev Converts an `address` into `address payable`. Note that this is
66      * simply a type cast: the actual underlying value is not changed.
67      *
68      * _Available since v2.4.0._
69      */
70     function toPayable(address account)
71         internal
72         pure
73         returns (address payable)
74     {
75         return address(uint160(account));
76     }
77 
78     /**
79      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
80      * `recipient`, forwarding all available gas and reverting on errors.
81      *
82      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
83      * of certain opcodes, possibly making contracts go over the 2300 gas limit
84      * imposed by `transfer`, making them unable to receive funds via
85      * `transfer`. {sendValue} removes this limitation.
86      *
87      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
88      *
89      * IMPORTANT: because control is transferred to `recipient`, care must be
90      * taken to not create reentrancy vulnerabilities. Consider using
91      * {ReentrancyGuard} or the
92      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
93      *
94      * _Available since v2.4.0._
95      */
96     function sendValue(address payable recipient, uint256 amount) internal {
97         require(
98             address(this).balance >= amount,
99             "Address: insufficient balance"
100         );
101 
102         // solhint-disable-next-line avoid-call-value
103         (bool success, ) = recipient.call.value(amount)("");
104         require(
105             success,
106             "Address: unable to send value, recipient may have reverted"
107         );
108     }
109 }
110 
111 // File: @openzeppelin/contracts/GSN/Context.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /*
116  * @dev Provides information about the current execution context, including the
117  * sender of the transaction and its data. While these are generally available
118  * via msg.sender and msg.data, they should not be accessed in such a direct
119  * manner, since when dealing with GSN meta-transactions the account sending and
120  * paying for execution may not be the actual sender (as far as an application
121  * is concerned).
122  *
123  * This contract is only required for intermediate, library-like contracts.
124  */
125 contract Context {
126     // Empty internal constructor, to prevent people from mistakenly deploying
127     // an instance of this contract, which should be used via inheritance.
128     constructor() internal {}
129 
130     // solhint-disable-previous-line no-empty-blocks
131 
132     function _msgSender() internal view returns (address payable) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view returns (bytes memory) {
137         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin/contracts/ownership/Ownable.sol
143 
144 pragma solidity ^0.5.0;
145 
146 /**
147  * @dev Contract module which provides a basic access control mechanism, where
148  * there is an account (an owner) that can be granted exclusive access to
149  * specific functions.
150  *
151  * This module is used through inheritance. It will make available the modifier
152  * `onlyOwner`, which can be applied to your functions to restrict their use to
153  * the owner.
154  */
155 contract Ownable is Context {
156     address private _owner;
157 
158     event OwnershipTransferred(
159         address indexed previousOwner,
160         address indexed newOwner
161     );
162 
163     /**
164      * @dev Initializes the contract setting the deployer as the initial owner.
165      */
166     constructor() internal {
167         address msgSender = _msgSender();
168         _owner = msgSender;
169         emit OwnershipTransferred(address(0), msgSender);
170     }
171 
172     /**
173      * @dev Returns the address of the current owner.
174      */
175     function owner() public view returns (address) {
176         return _owner;
177     }
178 
179     /**
180      * @dev Throws if called by any account other than the owner.
181      */
182     modifier onlyOwner() {
183         require(isOwner(), "Ownable: caller is not the owner");
184         _;
185     }
186 
187     /**
188      * @dev Returns true if the caller is the current owner.
189      */
190     function isOwner() public view returns (bool) {
191         return _msgSender() == _owner;
192     }
193 
194     /**
195      * @dev Leaves the contract without owner. It will not be possible to call
196      * `onlyOwner` functions anymore. Can only be called by the current owner.
197      *
198      * NOTE: Renouncing ownership will leave the contract without an owner,
199      * thereby removing any functionality that is only available to the owner.
200      */
201     function renounceOwnership() public onlyOwner {
202         emit OwnershipTransferred(_owner, address(0));
203         _owner = address(0);
204     }
205 
206     /**
207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
208      * Can only be called by the current owner.
209      */
210     function transferOwnership(address newOwner) public onlyOwner {
211         _transferOwnership(newOwner);
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      */
217     function _transferOwnership(address newOwner) internal {
218         require(
219             newOwner != address(0),
220             "Ownable: new owner is the zero address"
221         );
222         emit OwnershipTransferred(_owner, newOwner);
223         _owner = newOwner;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
228 
229 pragma solidity ^0.5.0;
230 
231 /**
232  * @dev Contract module that helps prevent reentrant calls to a function.
233  *
234  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
235  * available, which can be applied to functions to make sure there are no nested
236  * (reentrant) calls to them.
237  *
238  * Note that because there is a single `nonReentrant` guard, functions marked as
239  * `nonReentrant` may not call one another. This can be worked around by making
240  * those functions `private`, and then adding `external` `nonReentrant` entry
241  * points to them.
242  *
243  * TIP: If you would like to learn more about reentrancy and alternative ways
244  * to protect against it, check out our blog post
245  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
246  *
247  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
248  * metering changes introduced in the Istanbul hardfork.
249  */
250 contract ReentrancyGuard {
251     bool private _notEntered;
252 
253     constructor() internal {
254         // Storing an initial non-zero value makes deployment a bit more
255         // expensive, but in exchange the refund on every call to nonReentrant
256         // will be lower in amount. Since refunds are capped to a percetange of
257         // the total transaction's gas, it is best to keep them low in cases
258         // like this one, to increase the likelihood of the full refund coming
259         // into effect.
260         _notEntered = true;
261     }
262 
263     /**
264      * @dev Prevents a contract from calling itself, directly or indirectly.
265      * Calling a `nonReentrant` function from another `nonReentrant`
266      * function is not supported. It is possible to prevent this from happening
267      * by making the `nonReentrant` function external, and make it call a
268      * `private` function that does the actual work.
269      */
270     modifier nonReentrant() {
271         // On the first call to nonReentrant, _notEntered will be true
272         require(_notEntered, "ReentrancyGuard: reentrant call");
273 
274         // Any calls to nonReentrant after this point will fail
275         _notEntered = false;
276 
277         _;
278 
279         // By storing the original value once again, a refund is triggered (see
280         // https://eips.ethereum.org/EIPS/eip-2200)
281         _notEntered = true;
282     }
283 }
284 
285 // File: @openzeppelin/contracts/math/SafeMath.sol
286 
287 pragma solidity ^0.5.0;
288 
289 /**
290  * @dev Wrappers over Solidity's arithmetic operations with added overflow
291  * checks.
292  *
293  * Arithmetic operations in Solidity wrap on overflow. This can easily result
294  * in bugs, because programmers usually assume that an overflow raises an
295  * error, which is the standard behavior in high level programming languages.
296  * `SafeMath` restores this intuition by reverting the transaction when an
297  * operation overflows.
298  *
299  * Using this library instead of the unchecked operations eliminates an entire
300  * class of bugs, so it's recommended to use it always.
301  */
302 library SafeMath {
303     /**
304      * @dev Returns the addition of two unsigned integers, reverting on
305      * overflow.
306      *
307      * Counterpart to Solidity's `+` operator.
308      *
309      * Requirements:
310      * - Addition cannot overflow.
311      */
312     function add(uint256 a, uint256 b) internal pure returns (uint256) {
313         uint256 c = a + b;
314         require(c >= a, "SafeMath: addition overflow");
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the subtraction of two unsigned integers, reverting on
321      * overflow (when the result is negative).
322      *
323      * Counterpart to Solidity's `-` operator.
324      *
325      * Requirements:
326      * - Subtraction cannot overflow.
327      */
328     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
329         return sub(a, b, "SafeMath: subtraction overflow");
330     }
331 
332     /**
333      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
334      * overflow (when the result is negative).
335      *
336      * Counterpart to Solidity's `-` operator.
337      *
338      * Requirements:
339      * - Subtraction cannot overflow.
340      *
341      * _Available since v2.4.0._
342      */
343     function sub(
344         uint256 a,
345         uint256 b,
346         string memory errorMessage
347     ) internal pure returns (uint256) {
348         require(b <= a, errorMessage);
349         uint256 c = a - b;
350 
351         return c;
352     }
353 
354     /**
355      * @dev Returns the multiplication of two unsigned integers, reverting on
356      * overflow.
357      *
358      * Counterpart to Solidity's `*` operator.
359      *
360      * Requirements:
361      * - Multiplication cannot overflow.
362      */
363     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
364         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
365         // benefit is lost if 'b' is also tested.
366         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
367         if (a == 0) {
368             return 0;
369         }
370 
371         uint256 c = a * b;
372         require(c / a == b, "SafeMath: multiplication overflow");
373 
374         return c;
375     }
376 
377     /**
378      * @dev Returns the integer division of two unsigned integers. Reverts on
379      * division by zero. The result is rounded towards zero.
380      *
381      * Counterpart to Solidity's `/` operator. Note: this function uses a
382      * `revert` opcode (which leaves remaining gas untouched) while Solidity
383      * uses an invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      * - The divisor cannot be zero.
387      */
388     function div(uint256 a, uint256 b) internal pure returns (uint256) {
389         return div(a, b, "SafeMath: division by zero");
390     }
391 
392     /**
393      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
394      * division by zero. The result is rounded towards zero.
395      *
396      * Counterpart to Solidity's `/` operator. Note: this function uses a
397      * `revert` opcode (which leaves remaining gas untouched) while Solidity
398      * uses an invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      * - The divisor cannot be zero.
402      *
403      * _Available since v2.4.0._
404      */
405     function div(
406         uint256 a,
407         uint256 b,
408         string memory errorMessage
409     ) internal pure returns (uint256) {
410         // Solidity only automatically asserts when dividing by 0
411         require(b > 0, errorMessage);
412         uint256 c = a / b;
413         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
414 
415         return c;
416     }
417 
418     /**
419      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
420      * Reverts when dividing by zero.
421      *
422      * Counterpart to Solidity's `%` operator. This function uses a `revert`
423      * opcode (which leaves remaining gas untouched) while Solidity uses an
424      * invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      * - The divisor cannot be zero.
428      */
429     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
430         return mod(a, b, "SafeMath: modulo by zero");
431     }
432 
433     /**
434      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
435      * Reverts with custom message when dividing by zero.
436      *
437      * Counterpart to Solidity's `%` operator. This function uses a `revert`
438      * opcode (which leaves remaining gas untouched) while Solidity uses an
439      * invalid opcode to revert (consuming all remaining gas).
440      *
441      * Requirements:
442      * - The divisor cannot be zero.
443      *
444      * _Available since v2.4.0._
445      */
446     function mod(
447         uint256 a,
448         uint256 b,
449         string memory errorMessage
450     ) internal pure returns (uint256) {
451         require(b != 0, errorMessage);
452         return a % b;
453     }
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
457 
458 pragma solidity ^0.5.0;
459 
460 /**
461  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
462  * the optional functions; to access them see {ERC20Detailed}.
463  */
464 interface IERC20 {
465     /**
466      * @dev Returns the amount of tokens in existence.
467      */
468     function totalSupply() external view returns (uint256);
469 
470     /**
471      * @dev Returns the amount of tokens owned by `account`.
472      */
473     function balanceOf(address account) external view returns (uint256);
474 
475     /**
476      * @dev Moves `amount` tokens from the caller's account to `recipient`.
477      *
478      * Returns a boolean value indicating whether the operation succeeded.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transfer(address recipient, uint256 amount)
483         external
484         returns (bool);
485 
486     /**
487      * @dev Returns the remaining number of tokens that `spender` will be
488      * allowed to spend on behalf of `owner` through {transferFrom}. This is
489      * zero by default.
490      *
491      * This value changes when {approve} or {transferFrom} are called.
492      */
493     function allowance(address owner, address spender)
494         external
495         view
496         returns (uint256);
497 
498     /**
499      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
500      *
501      * Returns a boolean value indicating whether the operation succeeded.
502      *
503      * IMPORTANT: Beware that changing an allowance with this method brings the risk
504      * that someone may use both the old and the new allowance by unfortunate
505      * transaction ordering. One possible solution to mitigate this race
506      * condition is to first reduce the spender's allowance to 0 and set the
507      * desired value afterwards:
508      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
509      *
510      * Emits an {Approval} event.
511      */
512     function approve(address spender, uint256 amount) external returns (bool);
513 
514     /**
515      * @dev Moves `amount` tokens from `sender` to `recipient` using the
516      * allowance mechanism. `amount` is then deducted from the caller's
517      * allowance.
518      *
519      * Returns a boolean value indicating whether the operation succeeded.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transferFrom(
524         address sender,
525         address recipient,
526         uint256 amount
527     ) external returns (bool);
528 
529     /**
530      * @dev Emitted when `value` tokens are moved from one account (`from`) to
531      * another (`to`).
532      *
533      * Note that `value` may be zero.
534      */
535     event Transfer(address indexed from, address indexed to, uint256 value);
536 
537     /**
538      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
539      * a call to {approve}. `value` is the new allowance.
540      */
541     event Approval(
542         address indexed owner,
543         address indexed spender,
544         uint256 value
545     );
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
549 
550 pragma solidity ^0.5.0;
551 
552 /**
553  * @title SafeERC20
554  * @dev Wrappers around ERC20 operations that throw on failure (when the token
555  * contract returns false). Tokens that return no value (and instead revert or
556  * throw on failure) are also supported, non-reverting calls are assumed to be
557  * successful.
558  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
559  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
560  */
561 library SafeERC20 {
562     using SafeMath for uint256;
563     using Address for address;
564 
565     function safeTransfer(
566         IERC20 token,
567         address to,
568         uint256 value
569     ) internal {
570         callOptionalReturn(
571             token,
572             abi.encodeWithSelector(token.transfer.selector, to, value)
573         );
574     }
575 
576     function safeTransferFrom(
577         IERC20 token,
578         address from,
579         address to,
580         uint256 value
581     ) internal {
582         callOptionalReturn(
583             token,
584             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
585         );
586     }
587 
588     function safeApprove(
589         IERC20 token,
590         address spender,
591         uint256 value
592     ) internal {
593         // safeApprove should only be called when setting an initial allowance,
594         // or when resetting it to zero. To increase and decrease it, use
595         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
596         // solhint-disable-next-line max-line-length
597         require(
598             (value == 0) || (token.allowance(address(this), spender) == 0),
599             "SafeERC20: approve from non-zero to non-zero allowance"
600         );
601         callOptionalReturn(
602             token,
603             abi.encodeWithSelector(token.approve.selector, spender, value)
604         );
605     }
606 
607     function safeIncreaseAllowance(
608         IERC20 token,
609         address spender,
610         uint256 value
611     ) internal {
612         uint256 newAllowance = token.allowance(address(this), spender).add(
613             value
614         );
615         callOptionalReturn(
616             token,
617             abi.encodeWithSelector(
618                 token.approve.selector,
619                 spender,
620                 newAllowance
621             )
622         );
623     }
624 
625     function safeDecreaseAllowance(
626         IERC20 token,
627         address spender,
628         uint256 value
629     ) internal {
630         uint256 newAllowance = token.allowance(address(this), spender).sub(
631             value,
632             "SafeERC20: decreased allowance below zero"
633         );
634         callOptionalReturn(
635             token,
636             abi.encodeWithSelector(
637                 token.approve.selector,
638                 spender,
639                 newAllowance
640             )
641         );
642     }
643 
644     /**
645      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
646      * on the return value: the return value is optional (but if data is returned, it must not be false).
647      * @param token The token targeted by the call.
648      * @param data The call data (encoded using abi.encode or one of its variants).
649      */
650     function callOptionalReturn(IERC20 token, bytes memory data) private {
651         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
652         // we're implementing it ourselves.
653 
654         // A Solidity high level call has three parts:
655         //  1. The target address is checked to verify it contains contract code
656         //  2. The call itself is made, and success asserted
657         //  3. The return value is decoded, which in turn checks the size of the returned data.
658         // solhint-disable-next-line max-line-length
659         require(address(token).isContract(), "SafeERC20: call to non-contract");
660 
661         // solhint-disable-next-line avoid-low-level-calls
662         (bool success, bytes memory returndata) = address(token).call(data);
663         require(success, "SafeERC20: low-level call failed");
664 
665         if (returndata.length > 0) {
666             // Return data is optional
667             // solhint-disable-next-line max-line-length
668             require(
669                 abi.decode(returndata, (bool)),
670                 "SafeERC20: ERC20 operation did not succeed"
671             );
672         }
673     }
674 }
675 
676 interface IBFactory {
677     function isBPool(address b) external view returns (bool);
678 }
679 
680 interface IBpool {
681     function isPublicSwap() external view returns (bool);
682 
683     function isBound(address t) external view returns (bool);
684 
685     function swapExactAmountIn(
686         address tokenIn,
687         uint256 tokenAmountIn,
688         address tokenOut,
689         uint256 minAmountOut,
690         uint256 maxPrice
691     ) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
692 
693     function swapExactAmountOut(
694         address tokenIn,
695         uint256 maxAmountIn,
696         address tokenOut,
697         uint256 tokenAmountOut,
698         uint256 maxPrice
699     ) external returns (uint256 tokenAmountIn, uint256 spotPriceAfter);
700 
701     function getSpotPrice(address tokenIn, address tokenOut)
702         external
703         view
704         returns (uint256 spotPrice);
705 }
706 
707 interface IUniswapRouter02 {
708     //get estimated amountOut
709     function getAmountsOut(uint256 amountIn, address[] calldata path)
710         external
711         view
712         returns (uint256[] memory amounts);
713 
714     function getAmountsIn(uint256 amountOut, address[] calldata path)
715         external
716         view
717         returns (uint256[] memory amounts);
718 
719     //token 2 token
720     function swapExactTokensForTokens(
721         uint256 amountIn,
722         uint256 amountOutMin,
723         address[] calldata path,
724         address to,
725         uint256 deadline
726     ) external returns (uint256[] memory amounts);
727 
728     function swapTokensForExactTokens(
729         uint256 amountOut,
730         uint256 amountInMax,
731         address[] calldata path,
732         address to,
733         uint256 deadline
734     ) external returns (uint256[] memory amounts);
735 
736     //eth 2 token
737     function swapExactETHForTokens(
738         uint256 amountOutMin,
739         address[] calldata path,
740         address to,
741         uint256 deadline
742     ) external payable returns (uint256[] memory amounts);
743 
744     function swapETHForExactTokens(
745         uint256 amountOut,
746         address[] calldata path,
747         address to,
748         uint256 deadline
749     ) external payable returns (uint256[] memory amounts);
750 
751     //token 2 eth
752     function swapTokensForExactETH(
753         uint256 amountOut,
754         uint256 amountInMax,
755         address[] calldata path,
756         address to,
757         uint256 deadline
758     ) external returns (uint256[] memory amounts);
759 
760     function swapExactTokensForETH(
761         uint256 amountIn,
762         uint256 amountOutMin,
763         address[] calldata path,
764         address to,
765         uint256 deadline
766     ) external returns (uint256[] memory amounts);
767 }
768 
769 interface ICurve {
770     function underlying_coins(int128 index) external view returns (address);
771 
772     function coins(int128 index) external view returns (address);
773 
774     function get_dy_underlying(
775         int128 i,
776         int128 j,
777         uint256 dx
778     ) external view returns (uint256 dy);
779 
780     function exchange_underlying(
781         int128 i,
782         int128 j,
783         uint256 dx,
784         uint256 minDy
785     ) external;
786 
787     function exchange(
788         int128 i,
789         int128 j,
790         uint256 dx,
791         uint256 minDy
792     ) external;
793 }
794 
795 interface IWETH {
796     function deposit() external payable;
797 
798     function withdraw(uint256 amount) external;
799 }
800 
801 interface ICompound {
802     function markets(address cToken)
803         external
804         view
805         returns (bool isListed, uint256 collateralFactorMantissa);
806 
807     function underlying() external returns (address);
808 }
809 
810 interface ICompoundToken {
811     function underlying() external view returns (address);
812 
813     function exchangeRateStored() external view returns (uint256);
814 
815     function mint(uint256 mintAmount) external returns (uint256);
816 
817     function redeem(uint256 redeemTokens) external returns (uint256);
818 }
819 
820 interface ICompoundEther {
821     function mint() external payable;
822 
823     function redeem(uint256 redeemTokens) external returns (uint256);
824 }
825 
826 interface IIearn {
827     function token() external view returns (address);
828 
829     function calcPoolValueInToken() external view returns (uint256);
830 
831     function deposit(uint256 _amount) external;
832 
833     function withdraw(uint256 _shares) external;
834 }
835 
836 interface IAToken {
837     function redeem(uint256 _amount) external;
838 
839     function underlyingAssetAddress() external returns (address);
840 }
841 
842 interface IAaveLendingPoolAddressesProvider {
843     function getLendingPool() external view returns (address);
844 
845     function getLendingPoolCore() external view returns (address payable);
846 }
847 
848 interface IAaveLendingPool {
849     function deposit(
850         address _reserve,
851         uint256 _amount,
852         uint16 _referralCode
853     ) external payable;
854 }
855 
856 contract Zapper_Swap_General_V1_3 is ReentrancyGuard, Ownable {
857     using SafeMath for uint256;
858     using Address for address;
859     using SafeERC20 for IERC20;
860 
861     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
862         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
863     );
864 
865     IAaveLendingPoolAddressesProvider
866         private constant lendingPoolAddressProvider = IAaveLendingPoolAddressesProvider(
867         0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
868     );
869 
870     IBFactory private constant BalancerFactory = IBFactory(
871         0x9424B1412450D0f8Fc2255FAf6046b98213B76Bd
872     );
873 
874     address private constant renBTCCurveSwapContract = address(
875         0x93054188d876f558f4a66B2EF1d97d16eDf0895B
876     );
877 
878     address private constant sBTCCurveSwapContract = address(
879         0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714
880     );
881 
882     IWETH private constant wethContract = IWETH(
883         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
884     );
885 
886     address private constant ETHAddress = address(
887         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
888     );
889 
890     uint256
891         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
892 
893     mapping(address => address) public cToken;
894     mapping(address => address) public yToken;
895     mapping(address => address) public aToken;
896 
897     bool public stopped = false;
898 
899     constructor() public {
900         //mapping for cETH
901         cToken[address(
902             0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5
903         )] = ETHAddress;
904     }
905 
906     /**
907 	@notice This function adds c token addresses to a mapping
908 	@dev For cETH token, mapping is already added in constructor
909     @param _cToken token address of c-token for given underlying asset
910 		 */
911     function addCToken(address[] memory _cToken) public onlyOwner {
912         for (uint256 i = 0; i < _cToken.length; i++) {
913             cToken[_cToken[i]] = ICompound(_cToken[i]).underlying();
914         }
915     }
916 
917     /**
918 	@notice This function adds y token addresses to a mapping
919     @param _yToken token address of y-token
920 		*/
921     function addYToken(address[] memory _yToken) public onlyOwner {
922         for (uint256 i = 0; i < _yToken.length; i++) {
923             yToken[_yToken[i]] = IIearn(_yToken[i]).token();
924         }
925     }
926 
927     /**
928 	@notice This function adds a token addresses to a mapping
929     @param _aToken token address of a-token for given underlying asset
930 		 */
931     function addAToken(address[] memory _aToken) public onlyOwner {
932         for (uint256 i = 0; i < _aToken.length; i++) {
933             aToken[_aToken[i]] = IAToken(_aToken[i]).underlyingAssetAddress();
934         }
935     }
936 
937     /**
938     @notice This function is used swap tokens using multiple exchanges
939     @param toWhomToIssue address to which tokens should be sent after swap
940 	@param path token addresses indicating the conversion path
941 	@param amountIn amount of tokens to swap
942     @param minTokenOut min amount of expected tokens
943     @param withPool indicates the exchange and its sequence we want to swap from
944     @param poolData pool or token addresses needed for swapping tokens according to the exchange
945 	@param starts indicates the index of path array for each swap
946     @return amount of tokens received after swap
947      */
948     function MultiExchangeSwap(
949         address payable toWhomToIssue,
950         address[] calldata path,
951         uint256 amountIn,
952         uint256 minTokenOut,
953         uint8[] calldata starts,
954         uint8[] calldata withPool,
955         address[] calldata poolData
956     )
957         external
958         payable
959         nonReentrant
960         stopInEmergency
961         returns (uint256 tokensBought)
962     {
963         require(toWhomToIssue != address(0), "Invalid receiver address");
964         require(path[0] != path[path.length - 1], "Cannot swap same tokens");
965 
966         tokensBought = _swap(
967             path,
968             _getTokens(path[0], amountIn),
969             starts,
970             withPool,
971             poolData
972         );
973 
974         require(tokensBought >= minTokenOut, "High Slippage");
975         _sendTokens(toWhomToIssue, path[path.length - 1], tokensBought);
976     }
977 
978     //swap function
979     function _swap(
980         address[] memory path,
981         uint256 tokensToSwap,
982         uint8[] memory starts,
983         uint8[] memory withPool,
984         address[] memory poolData
985     ) internal returns (uint256) {
986         address _to;
987         uint8 poolIndex = 0;
988         address[] memory _poolData;
989         address _from = path[starts[0]];
990 
991         for (uint256 index = 0; index < withPool.length; index++) {
992             uint256 endIndex = index == withPool.length.sub(1)
993                 ? path.length - 1
994                 : starts[index + 1];
995 
996             _to = path[endIndex];
997 
998             {
999                 if (withPool[index] == 2) {
1000                     _poolData = _getPath(path, starts[index], endIndex + 1);
1001                 } else {
1002                     _poolData = new address[](1);
1003                     _poolData[0] = poolData[poolIndex++];
1004                 }
1005             }
1006 
1007             tokensToSwap = _swapFromPool(
1008                 _from,
1009                 _to,
1010                 tokensToSwap,
1011                 withPool[index],
1012                 _poolData
1013             );
1014 
1015             _from = _to;
1016         }
1017         return tokensToSwap;
1018     }
1019 
1020     /**
1021     @notice This function is used swap tokens using multiple exchanges
1022     @param fromToken token addresses to swap from
1023 	@param toToken token addresses to swap into
1024 	@param amountIn amount of tokens to swap
1025     @param withPool indicates the exchange we want to swap from
1026     @param poolData pool or token addresses needed for swapping tokens according to the exchange
1027 	@return amount of tokens received after swap
1028      */
1029     function _swapFromPool(
1030         address fromToken,
1031         address toToken,
1032         uint256 amountIn,
1033         uint256 withPool,
1034         address[] memory poolData
1035     ) internal returns (uint256) {
1036         require(fromToken != toToken, "Cannot swap same tokens");
1037         require(withPool <= 3, "Invalid Exchange");
1038 
1039         if (withPool == 1) {
1040             return
1041                 _swapWithBalancer(poolData[0], fromToken, toToken, amountIn, 1);
1042         } else if (withPool == 2) {
1043             return
1044                 _swapWithUniswapV2(fromToken, toToken, poolData, amountIn, 1);
1045         } else if (withPool == 3) {
1046             return _swapWithCurve(poolData[0], fromToken, toToken, amountIn, 1);
1047         }
1048     }
1049 
1050     /**
1051 	@notice This function returns part of the given array 
1052     @param addresses address array to copy from
1053 	@param _start start index
1054 	@param _end end index
1055     @return addressArray copied from given array
1056 		 */
1057     function _getPath(
1058         address[] memory addresses,
1059         uint256 _start,
1060         uint256 _end
1061     ) internal pure returns (address[] memory addressArray) {
1062         uint256 len = _end.sub(_start);
1063         require(len > 1, "ERR_UNIV2_PATH");
1064         addressArray = new address[](len);
1065 
1066         for (uint256 i = 0; i < len; i++) {
1067             if (
1068                 addresses[_start + i] == address(0) ||
1069                 addresses[_start + i] == ETHAddress
1070             ) {
1071                 addressArray[i] = address(wethContract);
1072             } else {
1073                 addressArray[i] = addresses[_start + i];
1074             }
1075         }
1076     }
1077 
1078     function _sendTokens(
1079         address payable toWhomToIssue,
1080         address token,
1081         uint256 amount
1082     ) internal {
1083         if (token == ETHAddress || token == address(0)) {
1084             toWhomToIssue.transfer(amount);
1085         } else {
1086             IERC20(token).safeTransfer(toWhomToIssue, amount);
1087         }
1088     }
1089 
1090     function _swapWithBalancer(
1091         address bpoolAddress,
1092         address fromToken,
1093         address toToken,
1094         uint256 amountIn,
1095         uint256 minTokenOut
1096     ) internal returns (uint256 tokenBought) {
1097         require(BalancerFactory.isBPool(bpoolAddress), "Invalid balancer pool");
1098 
1099         IBpool bpool = IBpool(bpoolAddress);
1100         require(bpool.isPublicSwap(), "Swap not allowed for this pool");
1101 
1102         address _to = toToken;
1103         if (fromToken == address(0)) {
1104             wethContract.deposit.value(amountIn)();
1105             fromToken = address(wethContract);
1106         } else if (toToken == address(0)) {
1107             _to = address(wethContract);
1108         }
1109         require(bpool.isBound(fromToken), "From Token not bound");
1110         require(bpool.isBound(_to), "To Token not bound");
1111 
1112         //approve it to exchange address
1113         IERC20(fromToken).safeApprove(bpoolAddress, amountIn);
1114 
1115         //swap tokens
1116         (tokenBought, ) = bpool.swapExactAmountIn(
1117             fromToken,
1118             amountIn,
1119             _to,
1120             minTokenOut,
1121             uint256(-1)
1122         );
1123 
1124         if (toToken == address(0)) {
1125             wethContract.withdraw(tokenBought);
1126         }
1127     }
1128 
1129     function _swapWithUniswapV2(
1130         address fromToken,
1131         address toToken,
1132         address[] memory path,
1133         uint256 amountIn,
1134         uint256 minTokenOut
1135     ) internal returns (uint256 tokenBought) {
1136         //unwrap & approve it to router contract
1137         uint256 tokensUnwrapped = amountIn;
1138         address _fromToken = fromToken;
1139         if (fromToken != address(0)) {
1140             (tokensUnwrapped, _fromToken) = _unwrap(fromToken, amountIn);
1141             IERC20(_fromToken).safeApprove(
1142                 address(uniswapRouter),
1143                 tokensUnwrapped
1144             );
1145         }
1146 
1147         //swap and transfer tokens
1148         if (fromToken == address(0)) {
1149             tokenBought = uniswapRouter.swapExactETHForTokens.value(
1150                 tokensUnwrapped
1151             )(minTokenOut, path, address(this), deadline)[path.length - 1];
1152         } else if (toToken == address(0)) {
1153             tokenBought = uniswapRouter.swapExactTokensForETH(
1154                 tokensUnwrapped,
1155                 minTokenOut,
1156                 path,
1157                 address(this),
1158                 deadline
1159             )[path.length - 1];
1160         } else {
1161             tokenBought = uniswapRouter.swapExactTokensForTokens(
1162                 tokensUnwrapped,
1163                 minTokenOut,
1164                 path,
1165                 address(this),
1166                 deadline
1167             )[path.length - 1];
1168         }
1169     }
1170 
1171     function _swapWithCurve(
1172         address curveExchangeAddress,
1173         address fromToken,
1174         address toToken,
1175         uint256 amountIn,
1176         uint256 minTokenOut
1177     ) internal returns (uint256 tokenBought) {
1178         require(
1179             curveExchangeAddress != address(0),
1180             "ERR_Invaid_curve_exchange"
1181         );
1182         ICurve curveExchange = ICurve(curveExchangeAddress);
1183 
1184         (uint256 tokensUnwrapped, address _fromToken) = _unwrap(
1185             fromToken,
1186             amountIn
1187         );
1188 
1189         //approve it to exchange address
1190         IERC20(_fromToken).safeApprove(curveExchangeAddress, tokensUnwrapped);
1191 
1192         int128 i;
1193         int128 j;
1194 
1195         //swap tokens
1196         if (
1197             curveExchangeAddress == renBTCCurveSwapContract ||
1198             curveExchangeAddress == sBTCCurveSwapContract
1199         ) {
1200             int128 length = (curveExchangeAddress == renBTCCurveSwapContract)
1201                 ? 2
1202                 : 3;
1203 
1204             for (int128 index = 0; index < length; index++) {
1205                 if (curveExchange.coins(index) == _fromToken) {
1206                     i = index;
1207                 } else if (curveExchange.coins(index) == toToken) {
1208                     j = index;
1209                 }
1210             }
1211 
1212             curveExchange.exchange(i, j, tokensUnwrapped, minTokenOut);
1213         } else {
1214             address compCurveSwapContract = address(
1215                 0xA2B47E3D5c44877cca798226B7B8118F9BFb7A56
1216             );
1217             address usdtCurveSwapContract = address(
1218                 0x52EA46506B9CC5Ef470C5bf89f17Dc28bB35D85C
1219             );
1220 
1221             int128 length = 4;
1222             if (curveExchangeAddress == compCurveSwapContract) {
1223                 length = 2;
1224             } else if (curveExchangeAddress == usdtCurveSwapContract) {
1225                 length = 3;
1226             }
1227 
1228             for (int128 index = 0; index < length; index++) {
1229                 if (curveExchange.underlying_coins(index) == _fromToken) {
1230                     i = index;
1231                 } else if (curveExchange.underlying_coins(index) == toToken) {
1232                     j = index;
1233                 }
1234             }
1235 
1236             curveExchange.exchange_underlying(
1237                 i,
1238                 j,
1239                 tokensUnwrapped,
1240                 minTokenOut
1241             );
1242         }
1243 
1244         if (toToken == ETHAddress || toToken == address(0)) {
1245             tokenBought = address(this).balance;
1246         } else {
1247             tokenBought = IERC20(toToken).balanceOf(address(this));
1248         }
1249     }
1250 
1251     function unwrapWeth(
1252         address payable _toWhomToIssue,
1253         address _FromTokenContractAddress,
1254         uint256 tokens2Trade,
1255         uint256 minTokens
1256     )
1257         public
1258         stopInEmergency
1259         returns (uint256 tokensUnwrapped, address toToken)
1260     {
1261         require(_toWhomToIssue != address(0), "Invalid receiver address");
1262         require(
1263             _FromTokenContractAddress == address(wethContract),
1264             "Only unwraps WETH, use unwrap() for other tokens"
1265         );
1266 
1267         uint256 initialEthbalance = address(this).balance;
1268 
1269         uint256 tokensToSwap = _getTokens(
1270             _FromTokenContractAddress,
1271             tokens2Trade
1272         );
1273 
1274         wethContract.withdraw(tokensToSwap);
1275         tokensUnwrapped = address(this).balance.sub(initialEthbalance);
1276         toToken = address(0);
1277 
1278         require(tokensUnwrapped >= minTokens, "High Slippage");
1279 
1280         //transfer
1281         _sendTokens(_toWhomToIssue, toToken, tokensUnwrapped);
1282     }
1283 
1284     function unwrap(
1285         address payable _toWhomToIssue,
1286         address _FromTokenContractAddress,
1287         uint256 tokens2Trade,
1288         uint256 minTokens
1289     )
1290         public
1291         stopInEmergency
1292         returns (uint256 tokensUnwrapped, address toToken)
1293     {
1294         require(_toWhomToIssue != address(0), "Invalid receiver address");
1295         uint256 tokensToSwap = _getTokens(
1296             _FromTokenContractAddress,
1297             tokens2Trade
1298         );
1299 
1300         (tokensUnwrapped, toToken) = _unwrap(
1301             _FromTokenContractAddress,
1302             tokensToSwap
1303         );
1304 
1305         require(tokensUnwrapped >= minTokens, "High Slippage");
1306 
1307         //transfer
1308         _sendTokens(_toWhomToIssue, toToken, tokensUnwrapped);
1309     }
1310 
1311     function _unwrap(address _FromTokenContractAddress, uint256 tokens2Trade)
1312         internal
1313         returns (uint256 tokensUnwrapped, address toToken)
1314     {
1315         uint256 initialEthbalance = address(this).balance;
1316 
1317         if (cToken[_FromTokenContractAddress] != address(0)) {
1318             require(
1319                 ICompoundToken(_FromTokenContractAddress).redeem(
1320                     tokens2Trade
1321                 ) == 0,
1322                 "Error in unwrapping"
1323             );
1324             toToken = cToken[_FromTokenContractAddress];
1325             if (toToken == ETHAddress) {
1326                 tokensUnwrapped = address(this).balance;
1327                 tokensUnwrapped = tokensUnwrapped.sub(initialEthbalance);
1328             } else {
1329                 tokensUnwrapped = IERC20(toToken).balanceOf(address(this));
1330             }
1331         } else if (yToken[_FromTokenContractAddress] != address(0)) {
1332             IIearn(_FromTokenContractAddress).withdraw(tokens2Trade);
1333             toToken = IIearn(_FromTokenContractAddress).token();
1334             tokensUnwrapped = IERC20(toToken).balanceOf(address(this));
1335         } else if (aToken[_FromTokenContractAddress] != address(0)) {
1336             IAToken(_FromTokenContractAddress).redeem(tokens2Trade);
1337             toToken = IAToken(_FromTokenContractAddress)
1338                 .underlyingAssetAddress();
1339             if (toToken == ETHAddress) {
1340                 tokensUnwrapped = address(this).balance;
1341                 tokensUnwrapped = tokensUnwrapped.sub(initialEthbalance);
1342             } else {
1343                 tokensUnwrapped = IERC20(toToken).balanceOf(address(this));
1344             }
1345         } else {
1346             toToken = _FromTokenContractAddress;
1347             tokensUnwrapped = tokens2Trade;
1348         }
1349     }
1350 
1351     function wrap(
1352         address payable _toWhomToIssue,
1353         address _FromTokenContractAddress,
1354         address _ToTokenContractAddress,
1355         uint256 tokens2Trade,
1356         uint256 minTokens,
1357         uint256 _wrapInto
1358     ) public payable stopInEmergency returns (uint256 tokensWrapped) {
1359         require(_toWhomToIssue != address(0), "Invalid receiver address");
1360         require(_wrapInto <= 3, "Invalid to Token");
1361         uint256 tokensToSwap = _getTokens(
1362             _FromTokenContractAddress,
1363             tokens2Trade
1364         );
1365 
1366         tokensWrapped = _wrap(
1367             _FromTokenContractAddress,
1368             _ToTokenContractAddress,
1369             tokensToSwap,
1370             _wrapInto
1371         );
1372 
1373         require(tokensWrapped >= minTokens, "High Slippage");
1374 
1375         //transfer tokens
1376         _sendTokens(_toWhomToIssue, _ToTokenContractAddress, tokensWrapped);
1377     }
1378 
1379     function _wrap(
1380         address _FromTokenContractAddress,
1381         address _ToTokenContractAddress,
1382         uint256 tokens2Trade,
1383         uint256 _wrapInto
1384     ) internal returns (uint256 tokensWrapped) {
1385         //weth
1386         if (_wrapInto == 0) {
1387             require(
1388                 _FromTokenContractAddress == address(0),
1389                 "Cannot wrap into WETH"
1390             );
1391             require(
1392                 _ToTokenContractAddress == address(wethContract),
1393                 "Invalid toToken"
1394             );
1395 
1396             wethContract.deposit.value(tokens2Trade)();
1397             return tokens2Trade;
1398         } else if (_wrapInto == 1) {
1399             //Compound
1400             if (_FromTokenContractAddress == address(0)) {
1401                 ICompoundEther(_ToTokenContractAddress).mint.value(
1402                     tokens2Trade
1403                 )();
1404             } else {
1405                 IERC20(_FromTokenContractAddress).safeApprove(
1406                     address(_ToTokenContractAddress),
1407                     tokens2Trade
1408                 );
1409                 ICompoundToken(_ToTokenContractAddress).mint(tokens2Trade);
1410             }
1411         } else if (_wrapInto == 2) {
1412             //IEarn
1413             IERC20(_FromTokenContractAddress).safeApprove(
1414                 address(_ToTokenContractAddress),
1415                 tokens2Trade
1416             );
1417             IIearn(_ToTokenContractAddress).deposit(tokens2Trade);
1418         } else {
1419             // Aave
1420             if (_FromTokenContractAddress == address(0)) {
1421                 IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
1422                     .deposit
1423                     .value(tokens2Trade)(ETHAddress, tokens2Trade, 0);
1424             } else {
1425                 //approve lending pool core
1426                 IERC20(_FromTokenContractAddress).safeApprove(
1427                     address(lendingPoolAddressProvider.getLendingPoolCore()),
1428                     tokens2Trade
1429                 );
1430 
1431                 //get lending pool and call deposit
1432                 IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
1433                     .deposit(_FromTokenContractAddress, tokens2Trade, 0);
1434             }
1435         }
1436         tokensWrapped = IERC20(_ToTokenContractAddress).balanceOf(
1437             address(this)
1438         );
1439     }
1440 
1441     function _getTokens(address token, uint256 amount)
1442         internal
1443         returns (uint256)
1444     {
1445         if (token == address(0)) {
1446             require(msg.value > 0, "No eth sent");
1447             return msg.value;
1448         }
1449         require(amount > 0, "Invalid token amount");
1450         require(msg.value == 0, "Eth sent with token");
1451 
1452         //transfer token
1453         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1454         return amount;
1455     }
1456 
1457     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1458         uint256 qty = _TokenAddress.balanceOf(address(this));
1459         _TokenAddress.safeTransfer(owner(), qty);
1460     }
1461 
1462     // - to Pause the contract
1463     function toggleContractActive() public onlyOwner {
1464         stopped = !stopped;
1465     }
1466 
1467     // circuit breaker modifiers
1468     modifier stopInEmergency {
1469         if (stopped) {
1470             revert("Temporarily Paused");
1471         } else {
1472             _;
1473         }
1474     }
1475 
1476     function() external payable {
1477         require(msg.sender != tx.origin, "Do not send ETH directly");
1478     }
1479 }