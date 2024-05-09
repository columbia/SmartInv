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
21 ///@notice This contract adds/removes liquidity to/from yEarn Vaults using ETH or ERC20 Tokens.
22 // SPDX-License-Identifier: GPLv2
23 
24 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
25 
26 pragma solidity ^0.5.0;
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations with added overflow
30  * checks.
31  *
32  * Arithmetic operations in Solidity wrap on overflow. This can easily result
33  * in bugs, because programmers usually assume that an overflow raises an
34  * error, which is the standard behavior in high level programming languages.
35  * `SafeMath` restores this intuition by reverting the transaction when an
36  * operation overflows.
37  *
38  * Using this library instead of the unchecked operations eliminates an entire
39  * class of bugs, so it's recommended to use it always.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `+` operator.
47      *
48      * Requirements:
49      * - Addition cannot overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      * - Subtraction cannot overflow.
79      *
80      * _Available since v2.4.0._
81      */
82     function sub(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      *
142      * _Available since v2.4.0._
143      */
144     function div(
145         uint256 a,
146         uint256 b,
147         string memory errorMessage
148     ) internal pure returns (uint256) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      *
183      * _Available since v2.4.0._
184      */
185     function mod(
186         uint256 a,
187         uint256 b,
188         string memory errorMessage
189     ) internal pure returns (uint256) {
190         require(b != 0, errorMessage);
191         return a % b;
192     }
193 }
194 
195 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
196 
197 pragma solidity ^0.5.0;
198 
199 /**
200  * @dev Contract module that helps prevent reentrant calls to a function.
201  *
202  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
203  * available, which can be applied to functions to make sure there are no nested
204  * (reentrant) calls to them.
205  *
206  * Note that because there is a single `nonReentrant` guard, functions marked as
207  * `nonReentrant` may not call one another. This can be worked around by making
208  * those functions `private`, and then adding `external` `nonReentrant` entry
209  * points to them.
210  *
211  * TIP: If you would like to learn more about reentrancy and alternative ways
212  * to protect against it, check out our blog post
213  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
214  */
215 contract ReentrancyGuard {
216     bool private _notEntered;
217 
218     constructor() internal {
219         // Storing an initial non-zero value makes deployment a bit more
220         // expensive, but in exchange the refund on every call to nonReentrant
221         // will be lower in amount. Since refunds are capped to a percetange of
222         // the total transaction's gas, it is best to keep them low in cases
223         // like this one, to increase the likelihood of the full refund coming
224         // into effect.
225         _notEntered = true;
226     }
227 
228     /**
229      * @dev Prevents a contract from calling itself, directly or indirectly.
230      * Calling a `nonReentrant` function from another `nonReentrant`
231      * function is not supported. It is possible to prevent this from happening
232      * by making the `nonReentrant` function external, and make it call a
233      * `private` function that does the actual work.
234      */
235     modifier nonReentrant() {
236         // On the first call to nonReentrant, _notEntered will be true
237         require(_notEntered, "ReentrancyGuard: reentrant call");
238 
239         // Any calls to nonReentrant after this point will fail
240         _notEntered = false;
241 
242         _;
243 
244         // By storing the original value once again, a refund is triggered (see
245         // https://eips.ethereum.org/EIPS/eip-2200)
246         _notEntered = true;
247     }
248 }
249 
250 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
251 
252 pragma solidity ^0.5.0;
253 
254 /**
255  * @dev Interface of the ERC20 standard as defined in the EIP.
256  */
257 interface IERC20 {
258     /**
259      * @dev Returns the amount of tokens in existence.
260      */
261     function totalSupply() external view returns (uint256);
262 
263     /**
264      * @dev Returns the amount of tokens owned by `account`.
265      */
266     function balanceOf(address account) external view returns (uint256);
267 
268     /**
269      * @dev Moves `amount` tokens from the caller's account to `recipient`.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * Emits a {Transfer} event.
274      */
275     function transfer(address recipient, uint256 amount)
276         external
277         returns (bool);
278 
279     /**
280      * @dev Returns the remaining number of tokens that `spender` will be
281      * allowed to spend on behalf of `owner` through {transferFrom}. This is
282      * zero by default.
283      *
284      * This value changes when {approve} or {transferFrom} are called.
285      */
286     function allowance(address owner, address spender)
287         external
288         view
289         returns (uint256);
290 
291     /**
292      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * IMPORTANT: Beware that changing an allowance with this method brings the risk
297      * that someone may use both the old and the new allowance by unfortunate
298      * transaction ordering. One possible solution to mitigate this race
299      * condition is to first reduce the spender's allowance to 0 and set the
300      * desired value afterwards:
301      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302      *
303      * Emits an {Approval} event.
304      */
305     function approve(address spender, uint256 amount) external returns (bool);
306 
307     /**
308      * @dev Moves `amount` tokens from `sender` to `recipient` using the
309      * allowance mechanism. `amount` is then deducted from the caller's
310      * allowance.
311      *
312      * Returns a boolean value indicating whether the operation succeeded.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transferFrom(
317         address sender,
318         address recipient,
319         uint256 amount
320     ) external returns (bool);
321 
322     /**
323      * @dev Emitted when `value` tokens are moved from one account (`from`) to
324      * another (`to`).
325      *
326      * Note that `value` may be zero.
327      */
328     event Transfer(address indexed from, address indexed to, uint256 value);
329 
330     /**
331      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
332      * a call to {approve}. `value` is the new allowance.
333      */
334     event Approval(
335         address indexed owner,
336         address indexed spender,
337         uint256 value
338     );
339 }
340 
341 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
342 
343 pragma solidity ^0.5.0;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
368         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
369         // for accounts without code, i.e. `keccak256('')`
370         bytes32 codehash;
371 
372 
373             bytes32 accountHash
374          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
375         // solhint-disable-next-line no-inline-assembly
376         assembly {
377             codehash := extcodehash(account)
378         }
379         return (codehash != accountHash && codehash != 0x0);
380     }
381 
382     /**
383      * @dev Converts an `address` into `address payable`. Note that this is
384      * simply a type cast: the actual underlying value is not changed.
385      *
386      * _Available since v2.4.0._
387      */
388     function toPayable(address account)
389         internal
390         pure
391         returns (address payable)
392     {
393         return address(uint160(account));
394     }
395 
396     /**
397      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
398      * `recipient`, forwarding all available gas and reverting on errors.
399      *
400      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
401      * of certain opcodes, possibly making contracts go over the 2300 gas limit
402      * imposed by `transfer`, making them unable to receive funds via
403      * `transfer`. {sendValue} removes this limitation.
404      *
405      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
406      *
407      * IMPORTANT: because control is transferred to `recipient`, care must be
408      * taken to not create reentrancy vulnerabilities. Consider using
409      * {ReentrancyGuard} or the
410      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
411      *
412      * _Available since v2.4.0._
413      */
414     function sendValue(address payable recipient, uint256 amount) internal {
415         require(
416             address(this).balance >= amount,
417             "Address: insufficient balance"
418         );
419 
420         // solhint-disable-next-line avoid-call-value
421         (bool success, ) = recipient.call.value(amount)("");
422         require(
423             success,
424             "Address: unable to send value, recipient may have reverted"
425         );
426     }
427 }
428 
429 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
430 
431 pragma solidity ^0.5.0;
432 
433 /*
434  * @dev Provides information about the current execution context, including the
435  * sender of the transaction and its data. While these are generally available
436  * via msg.sender and msg.data, they should not be accessed in such a direct
437  * manner, since when dealing with GSN meta-transactions the account sending and
438  * paying for execution may not be the actual sender (as far as an application
439  * is concerned).
440  *
441  * This contract is only required for intermediate, library-like contracts.
442  */
443 contract Context {
444     // Empty internal constructor, to prevent people from mistakenly deploying
445     // an instance of this contract, which should be used via inheritance.
446     constructor() internal {}
447 
448     // solhint-disable-previous-line no-empty-blocks
449 
450     function _msgSender() internal view returns (address payable) {
451         return msg.sender;
452     }
453 
454     function _msgData() internal view returns (bytes memory) {
455         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
456         return msg.data;
457     }
458 }
459 
460 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
461 
462 pragma solidity ^0.5.0;
463 
464 /**
465  * @dev Contract module which provides a basic access control mechanism, where
466  * there is an account (an owner) that can be granted exclusive access to
467  * specific functions.
468  *
469  * By default, the owner account will be the one that deploys the contract. This
470  * can later be changed with {transferOwnership}.
471  *
472  * This module is used through inheritance. It will make available the modifier
473  * `onlyOwner`, which can be applied to your functions to restrict their use to
474  * the owner.
475  */
476 contract Ownable is Context {
477     address payable public _owner;
478 
479     event OwnershipTransferred(
480         address indexed previousOwner,
481         address indexed newOwner
482     );
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor() internal {
488         address payable msgSender = _msgSender();
489         _owner = msgSender;
490         emit OwnershipTransferred(address(0), msgSender);
491     }
492 
493     /**
494      * @dev Returns the address of the current owner.
495      */
496     function owner() public view returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(isOwner(), "Ownable: caller is not the owner");
505         _;
506     }
507 
508     /**
509      * @dev Returns true if the caller is the current owner.
510      */
511     function isOwner() public view returns (bool) {
512         return _msgSender() == _owner;
513     }
514 
515     /**
516      * @dev Leaves the contract without owner. It will not be possible to call
517      * `onlyOwner` functions anymore. Can only be called by the current owner.
518      *
519      * NOTE: Renouncing ownership will leave the contract without an owner,
520      * thereby removing any functionality that is only available to the owner.
521      */
522     function renounceOwnership() public onlyOwner {
523         emit OwnershipTransferred(_owner, address(0));
524         _owner = address(0);
525     }
526 
527     /**
528      * @dev Transfers ownership of the contract to a new account (`newOwner`).
529      * Can only be called by the current owner.
530      */
531     function transferOwnership(address payable newOwner) public onlyOwner {
532         _transferOwnership(newOwner);
533     }
534 
535     /**
536      * @dev Transfers ownership of the contract to a new account (`newOwner`).
537      */
538     function _transferOwnership(address payable newOwner) internal {
539         require(
540             newOwner != address(0),
541             "Ownable: new owner is the zero address"
542         );
543         emit OwnershipTransferred(_owner, newOwner);
544         _owner = newOwner;
545     }
546 }
547 
548 // File: yVault_ZapInOut_General_V1_2.sol
549 
550 /**
551  * @title SafeERC20
552  * @dev Wrappers around ERC20 operations that throw on failure (when the token
553  * contract returns false). Tokens that return no value (and instead revert or
554  * throw on failure) are also supported, non-reverting calls are assumed to be
555  * successful.
556  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
557  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
558  */
559 library SafeERC20 {
560     using SafeMath for uint256;
561     using Address for address;
562 
563     function safeTransfer(
564         IERC20 token,
565         address to,
566         uint256 value
567     ) internal {
568         callOptionalReturn(
569             token,
570             abi.encodeWithSelector(token.transfer.selector, to, value)
571         );
572     }
573 
574     function safeTransferFrom(
575         IERC20 token,
576         address from,
577         address to,
578         uint256 value
579     ) internal {
580         callOptionalReturn(
581             token,
582             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
583         );
584     }
585 
586     function safeApprove(
587         IERC20 token,
588         address spender,
589         uint256 value
590     ) internal {
591         // safeApprove should only be called when setting an initial allowance,
592         // or when resetting it to zero. To increase and decrease it, use
593         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
594         // solhint-disable-next-line max-line-length
595         require(
596             (value == 0) || (token.allowance(address(this), spender) == 0),
597             "SafeERC20: approve from non-zero to non-zero allowance"
598         );
599         callOptionalReturn(
600             token,
601             abi.encodeWithSelector(token.approve.selector, spender, value)
602         );
603     }
604 
605     function safeIncreaseAllowance(
606         IERC20 token,
607         address spender,
608         uint256 value
609     ) internal {
610         uint256 newAllowance = token.allowance(address(this), spender).add(
611             value
612         );
613         callOptionalReturn(
614             token,
615             abi.encodeWithSelector(
616                 token.approve.selector,
617                 spender,
618                 newAllowance
619             )
620         );
621     }
622 
623     function safeDecreaseAllowance(
624         IERC20 token,
625         address spender,
626         uint256 value
627     ) internal {
628         uint256 newAllowance = token.allowance(address(this), spender).sub(
629             value,
630             "SafeERC20: decreased allowance below zero"
631         );
632         callOptionalReturn(
633             token,
634             abi.encodeWithSelector(
635                 token.approve.selector,
636                 spender,
637                 newAllowance
638             )
639         );
640     }
641 
642     /**
643      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
644      * on the return value: the return value is optional (but if data is returned, it must not be false).
645      * @param token The token targeted by the call.
646      * @param data The call data (encoded using abi.encode or one of its variants).
647      */
648     function callOptionalReturn(IERC20 token, bytes memory data) private {
649         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
650         // we're implementing it ourselves.
651 
652         // A Solidity high level call has three parts:
653         //  1. The target address is checked to verify it contains contract code
654         //  2. The call itself is made, and success asserted
655         //  3. The return value is decoded, which in turn checks the size of the returned data.
656         // solhint-disable-next-line max-line-length
657         require(address(token).isContract(), "SafeERC20: call to non-contract");
658 
659         // solhint-disable-next-line avoid-low-level-calls
660         (bool success, bytes memory returndata) = address(token).call(data);
661         require(success, "SafeERC20: low-level call failed");
662 
663         if (returndata.length > 0) {
664             // Return data is optional
665             // solhint-disable-next-line max-line-length
666             require(
667                 abi.decode(returndata, (bool)),
668                 "SafeERC20: ERC20 operation did not succeed"
669             );
670         }
671     }
672 }
673 
674 interface IUniswapV2Factory {
675     function getPair(address tokenA, address tokenB)
676         external
677         view
678         returns (address);
679 }
680 
681 interface IUniswapRouter02 {
682     //get estimated amountOut
683     function getAmountsOut(uint256 amountIn, address[] calldata path)
684         external
685         view
686         returns (uint256[] memory amounts);
687 
688     function getAmountsIn(uint256 amountOut, address[] calldata path)
689         external
690         view
691         returns (uint256[] memory amounts);
692 
693     //token 2 token
694     function swapExactTokensForTokens(
695         uint256 amountIn,
696         uint256 amountOutMin,
697         address[] calldata path,
698         address to,
699         uint256 deadline
700     ) external returns (uint256[] memory amounts);
701 
702     function swapTokensForExactTokens(
703         uint256 amountOut,
704         uint256 amountInMax,
705         address[] calldata path,
706         address to,
707         uint256 deadline
708     ) external returns (uint256[] memory amounts);
709 
710     //eth 2 token
711     function swapExactETHForTokens(
712         uint256 amountOutMin,
713         address[] calldata path,
714         address to,
715         uint256 deadline
716     ) external payable returns (uint256[] memory amounts);
717 
718     function swapETHForExactTokens(
719         uint256 amountOut,
720         address[] calldata path,
721         address to,
722         uint256 deadline
723     ) external payable returns (uint256[] memory amounts);
724 
725     //token 2 eth
726     function swapTokensForExactETH(
727         uint256 amountOut,
728         uint256 amountInMax,
729         address[] calldata path,
730         address to,
731         uint256 deadline
732     ) external returns (uint256[] memory amounts);
733 
734     function swapExactTokensForETH(
735         uint256 amountIn,
736         uint256 amountOutMin,
737         address[] calldata path,
738         address to,
739         uint256 deadline
740     ) external returns (uint256[] memory amounts);
741 }
742 
743 interface yVault {
744     function deposit(uint256) external;
745 
746     function withdraw(uint256) external;
747 
748     function getPricePerFullShare() external view returns (uint256);
749 
750     function token() external view returns (address);
751 }
752 
753 interface ICurveZapInGeneral {
754     function ZapIn(
755         address toWhomToIssue,
756         address fromToken,
757         address swapAddress,
758         uint256 incomingTokenQty,
759         uint256 minPoolTokens
760     ) external payable returns (uint256 crvTokensBought);
761 }
762 
763 interface ICurveZapOutGeneral {
764     function ZapOut(
765         address payable toWhomToIssue,
766         address swapAddress,
767         uint256 incomingCrv,
768         address toToken,
769         uint256 minToTokens
770     ) external returns (uint256 ToTokensBought);
771 }
772 
773 interface IAaveLendingPoolAddressesProvider {
774     function getLendingPool() external view returns (address);
775 
776     function getLendingPoolCore() external view returns (address payable);
777 }
778 
779 interface IAaveLendingPool {
780     function deposit(
781         address _reserve,
782         uint256 _amount,
783         uint16 _referralCode
784     ) external payable;
785 }
786 
787 interface IAToken {
788     function redeem(uint256 _amount) external;
789 
790     function underlyingAssetAddress() external returns (address);
791 }
792 
793 interface IWETH {
794     function deposit() external payable;
795 
796     function withdraw(uint256) external;
797 }
798 
799 contract yVault_ZapInOut_General_V1_5 is ReentrancyGuard, Ownable {
800     using SafeMath for uint256;
801     using Address for address;
802     using SafeERC20 for IERC20;
803     bool public stopped = false;
804     uint16 public goodwill;
805 
806     IUniswapV2Factory
807         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
808         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
809     );
810     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
811         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
812     );
813 
814     ICurveZapInGeneral public CurveZapInGeneral = ICurveZapInGeneral(
815         0xf9A724c2607E5766a7Bbe530D6a7e173532F9f3a
816     );
817     ICurveZapOutGeneral public CurveZapOutGeneral = ICurveZapOutGeneral(
818         0xA3061Cf6aC1423c6F40917AD49602cBA187181Dc
819     );
820 
821     IAaveLendingPoolAddressesProvider
822         private constant lendingPoolAddressProvider = IAaveLendingPoolAddressesProvider(
823         0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
824     );
825 
826     address
827         private constant yCurveExchangeAddress = 0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3;
828     address
829         private constant sBtcCurveExchangeAddress = 0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714;
830     address
831         private constant bUSDCurveExchangeAddress = 0xb6c057591E073249F2D9D88Ba59a46CFC9B59EdB;
832     address
833         private constant threeCurveExchangeAddress = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
834     address
835         private constant cUSDCurveExchangeAddress = 0xeB21209ae4C2c9FF2a86ACA31E123764A3B6Bc06;
836 
837     address
838         private constant yCurvePoolTokenAddress = 0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8;
839     address
840         private constant sBtcCurvePoolTokenAddress = 0x075b1bb99792c9E1041bA13afEf80C91a1e70fB3;
841     address
842         private constant bUSDCurvePoolTokenAddress = 0x3B3Ac5386837Dc563660FB6a0937DFAa5924333B;
843     address
844         private constant threeCurvePoolTokenAddress = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
845     address
846         private constant cUSDCurvePoolTokenAddress = 0x845838DF265Dcd2c412A1Dc9e959c7d08537f8a2;
847 
848     mapping(address => address) public token2Exchange; //Curve token to Curve exchange
849 
850     address
851         private constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
852     address
853         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
854     address
855         private constant zgoodwillAddress = 0x3CE37278de6388532C3949ce4e886F365B14fB56;
856 
857     uint256
858         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
859 
860     event Zapin(
861         address _toWhomToIssue,
862         address _toYVaultAddress,
863         uint256 _Outgoing
864     );
865 
866     event Zapout(
867         address _toWhomToIssue,
868         address _fromYVaultAddress,
869         address _toTokenAddress,
870         uint256 _tokensRecieved
871     );
872 
873     constructor() public {
874         token2Exchange[yCurvePoolTokenAddress] = yCurveExchangeAddress;
875         token2Exchange[bUSDCurvePoolTokenAddress] = bUSDCurveExchangeAddress;
876         token2Exchange[sBtcCurvePoolTokenAddress] = sBtcCurveExchangeAddress;
877         token2Exchange[threeCurvePoolTokenAddress] = threeCurveExchangeAddress;
878         token2Exchange[cUSDCurvePoolTokenAddress] = cUSDCurveExchangeAddress;
879     }
880 
881     // circuit breaker modifiers
882     modifier stopInEmergency {
883         if (stopped) {
884             revert("Temporarily Paused");
885         } else {
886             _;
887         }
888     }
889 
890     function updateCurveZapIn(address CurveZapInGeneralAddress)
891         public
892         onlyOwner
893     {
894         require(CurveZapInGeneralAddress != address(0), "Invalid Address");
895         CurveZapInGeneral = ICurveZapInGeneral(CurveZapInGeneralAddress);
896     }
897 
898     function updateCurveZapOut(address CurveZapOutGeneralAddress)
899         public
900         onlyOwner
901     {
902         require(CurveZapOutGeneralAddress != address(0), "Invalid Address");
903         CurveZapOutGeneral = ICurveZapOutGeneral(CurveZapOutGeneralAddress);
904     }
905 
906     function addNewCurveExchange(
907         address curvePoolToken,
908         address curveExchangeAddress
909     ) public onlyOwner {
910         require(
911             curvePoolToken != address(0) && curveExchangeAddress != address(0),
912             "Invalid Address"
913         );
914         token2Exchange[curvePoolToken] = curveExchangeAddress;
915     }
916 
917     /**
918     @notice This function is used to add liquidity to yVaults
919     @param _toWhomToIssue recipient address
920     @param _toYVaultAddress The address of vault to add liquidity to
921     @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
922     @param _fromTokenAddress The token used for investment (address(0x00) if ether)
923     @param _amount The amount of ERC to invest
924     @param _minYTokens for slippage
925     @return yTokensRec
926      */
927     function ZapIn(
928         address _toWhomToIssue,
929         address _toYVaultAddress,
930         uint16 _vaultType,
931         address _fromTokenAddress,
932         uint256 _amount,
933         uint256 _minYTokens
934     ) public payable nonReentrant stopInEmergency returns (uint256) {
935         yVault vaultToEnter = yVault(_toYVaultAddress);
936         address underlyingVaultToken = vaultToEnter.token();
937 
938         if (_fromTokenAddress == address(0)) {
939             require(msg.value > 0, "ERR: No ETH sent");
940         } else {
941             require(_amount > 0, "Err: No Tokens Sent");
942             require(msg.value == 0, "ERR: ETH sent with Token");
943 
944             IERC20(_fromTokenAddress).safeTransferFrom(
945                 msg.sender,
946                 address(this),
947                 _amount
948             );
949         }
950 
951         uint256 iniYTokensBal = IERC20(address(vaultToEnter)).balanceOf(
952             address(this)
953         );
954 
955         if (underlyingVaultToken == _fromTokenAddress) {
956             IERC20(underlyingVaultToken).safeApprove(
957                 address(vaultToEnter),
958                 _amount
959             );
960             vaultToEnter.deposit(_amount);
961         } else {
962             // Curve Vaults
963             if (_vaultType == 2) {
964 
965                     address curveExchangeAddr
966                  = token2Exchange[underlyingVaultToken];
967 
968                 uint256 tokensBought;
969                 if (_fromTokenAddress == address(0)) {
970                     tokensBought = CurveZapInGeneral.ZapIn.value(msg.value)(
971                         address(this),
972                         address(0),
973                         curveExchangeAddr,
974                         msg.value,
975                         0
976                     );
977                 } else {
978                     IERC20(_fromTokenAddress).safeApprove(
979                         address(CurveZapInGeneral),
980                         _amount
981                     );
982                     tokensBought = CurveZapInGeneral.ZapIn(
983                         address(this),
984                         _fromTokenAddress,
985                         curveExchangeAddr,
986                         _amount,
987                         0
988                     );
989                 }
990 
991                 IERC20(underlyingVaultToken).safeApprove(
992                     address(vaultToEnter),
993                     tokensBought
994                 );
995                 vaultToEnter.deposit(tokensBought);
996             } else if (_vaultType == 1) {
997                 address underlyingAsset = IAToken(underlyingVaultToken)
998                     .underlyingAssetAddress();
999 
1000                 uint256 tokensBought;
1001                 if (_fromTokenAddress == address(0)) {
1002                     tokensBought = _eth2Token(underlyingAsset);
1003                 } else {
1004                     tokensBought = _token2Token(
1005                         _fromTokenAddress,
1006                         underlyingAsset,
1007                         _amount
1008                     );
1009                 }
1010 
1011                 IERC20(underlyingAsset).safeApprove(
1012                     lendingPoolAddressProvider.getLendingPoolCore(),
1013                     tokensBought
1014                 );
1015 
1016                 IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
1017                     .deposit(underlyingAsset, tokensBought, 0);
1018 
1019                 uint256 aTokensBought = IERC20(underlyingVaultToken).balanceOf(
1020                     address(this)
1021                 );
1022                 IERC20(underlyingVaultToken).safeApprove(
1023                     address(vaultToEnter),
1024                     aTokensBought
1025                 );
1026                 vaultToEnter.deposit(aTokensBought);
1027             } else {
1028                 uint256 tokensBought;
1029                 if (_fromTokenAddress == address(0)) {
1030                     tokensBought = _eth2Token(underlyingVaultToken);
1031                 } else {
1032                     tokensBought = _token2Token(
1033                         _fromTokenAddress,
1034                         underlyingVaultToken,
1035                         _amount
1036                     );
1037                 }
1038 
1039                 IERC20(underlyingVaultToken).safeApprove(
1040                     address(vaultToEnter),
1041                     tokensBought
1042                 );
1043                 vaultToEnter.deposit(tokensBought);
1044             }
1045         }
1046 
1047         uint256 yTokensRec = IERC20(address(vaultToEnter))
1048             .balanceOf(address(this))
1049             .sub(iniYTokensBal);
1050         require(yTokensRec >= _minYTokens, "High Slippage");
1051 
1052         //transfer goodwill
1053         uint256 goodwillPortion = _transferGoodwill(
1054             address(vaultToEnter),
1055             yTokensRec
1056         );
1057 
1058         IERC20(address(vaultToEnter)).safeTransfer(
1059             _toWhomToIssue,
1060             yTokensRec.sub(goodwillPortion)
1061         );
1062 
1063         emit Zapin(
1064             _toWhomToIssue,
1065             address(vaultToEnter),
1066             yTokensRec.sub(goodwillPortion)
1067         );
1068 
1069         return (yTokensRec.sub(goodwillPortion));
1070     }
1071 
1072     /**
1073     @notice This function is used to remove liquidity from yVaults
1074     @param _toWhomToIssue recipient address
1075     @param _ToTokenContractAddress The address of the token to withdraw
1076     @param _fromYVaultAddress The address of the vault to exit
1077     @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
1078     @param _IncomingAmt The amount of vault tokens removed
1079     @param _minTokensRec for slippage
1080     @return toTokensReceived
1081      */
1082     function ZapOut(
1083         address payable _toWhomToIssue,
1084         address _ToTokenContractAddress,
1085         address _fromYVaultAddress,
1086         uint16 _vaultType,
1087         uint256 _IncomingAmt,
1088         uint256 _minTokensRec
1089     ) public nonReentrant stopInEmergency returns (uint256) {
1090         yVault vaultToExit = yVault(_fromYVaultAddress);
1091         address underlyingVaultToken = vaultToExit.token();
1092 
1093         IERC20(address(vaultToExit)).safeTransferFrom(
1094             msg.sender,
1095             address(this),
1096             _IncomingAmt
1097         );
1098 
1099         uint256 goodwillPortion = _transferGoodwill(
1100             address(vaultToExit),
1101             _IncomingAmt
1102         );
1103 
1104         vaultToExit.withdraw(_IncomingAmt.sub(goodwillPortion));
1105         uint256 underlyingReceived = IERC20(underlyingVaultToken).balanceOf(
1106             address(this)
1107         );
1108 
1109         uint256 toTokensReceived;
1110         if (_ToTokenContractAddress == underlyingVaultToken) {
1111             IERC20(underlyingVaultToken).safeTransfer(
1112                 _toWhomToIssue,
1113                 underlyingReceived
1114             );
1115             toTokensReceived = underlyingReceived;
1116         } else {
1117             if (_vaultType == 2) {
1118                 toTokensReceived = _withdrawFromCurve(
1119                     underlyingVaultToken,
1120                     underlyingReceived,
1121                     _toWhomToIssue,
1122                     _ToTokenContractAddress,
1123                     0
1124                 );
1125             } else if (_vaultType == 1) {
1126                 // unwrap atoken
1127                 IAToken(underlyingVaultToken).redeem(underlyingReceived);
1128                 address underlyingAsset = IAToken(underlyingVaultToken)
1129                     .underlyingAssetAddress();
1130 
1131                 // swap
1132                 if (_ToTokenContractAddress == address(0)) {
1133                     toTokensReceived = _token2Eth(
1134                         underlyingAsset,
1135                         underlyingReceived,
1136                         _toWhomToIssue
1137                     );
1138                 } else {
1139                     toTokensReceived = _token2Token(
1140                         underlyingAsset,
1141                         _ToTokenContractAddress,
1142                         underlyingReceived
1143                     );
1144                     IERC20(_ToTokenContractAddress).safeTransfer(
1145                         _toWhomToIssue,
1146                         toTokensReceived
1147                     );
1148                 }
1149             } else {
1150                 if (_ToTokenContractAddress == address(0)) {
1151                     toTokensReceived = _token2Eth(
1152                         underlyingVaultToken,
1153                         underlyingReceived,
1154                         _toWhomToIssue
1155                     );
1156                 } else {
1157                     toTokensReceived = _token2Token(
1158                         underlyingVaultToken,
1159                         _ToTokenContractAddress,
1160                         underlyingReceived
1161                     );
1162 
1163                     IERC20(_ToTokenContractAddress).safeTransfer(
1164                         _toWhomToIssue,
1165                         toTokensReceived
1166                     );
1167                 }
1168             }
1169         }
1170 
1171         require(toTokensReceived >= _minTokensRec, "High Slippage");
1172 
1173         emit Zapout(
1174             _toWhomToIssue,
1175             _fromYVaultAddress,
1176             _ToTokenContractAddress,
1177             toTokensReceived
1178         );
1179 
1180         return toTokensReceived;
1181     }
1182 
1183     function _withdrawFromCurve(
1184         address _CurvePoolToken,
1185         uint256 _tokenAmt,
1186         address _toWhomToIssue,
1187         address _ToTokenContractAddress,
1188         uint256 _minTokensRec
1189     ) internal returns (uint256) {
1190         IERC20(_CurvePoolToken).safeApprove(
1191             address(CurveZapOutGeneral),
1192             _tokenAmt
1193         );
1194 
1195         address curveExchangeAddr = token2Exchange[_CurvePoolToken];
1196 
1197         return (
1198             CurveZapOutGeneral.ZapOut(
1199                 Address.toPayable(_toWhomToIssue),
1200                 curveExchangeAddr,
1201                 _tokenAmt,
1202                 _ToTokenContractAddress,
1203                 _minTokensRec
1204             )
1205         );
1206     }
1207 
1208     /**
1209     @notice This function is used to swap eth for tokens
1210     @param _tokenContractAddress Token address which we want to buy
1211     @return tokensBought The quantity of token bought
1212      */
1213     function _eth2Token(address _tokenContractAddress)
1214         internal
1215         returns (uint256 tokensBought)
1216     {
1217         if (_tokenContractAddress == wethTokenAddress) {
1218             IWETH(wethTokenAddress).deposit.value(msg.value)();
1219             return msg.value;
1220         }
1221 
1222         address[] memory path = new address[](2);
1223         path[0] = wethTokenAddress;
1224         path[1] = _tokenContractAddress;
1225         tokensBought = uniswapRouter.swapExactETHForTokens.value(msg.value)(
1226             1,
1227             path,
1228             address(this),
1229             deadline
1230         )[path.length - 1];
1231     }
1232 
1233     /**
1234     @notice This function is used to swap tokens
1235     @param _FromTokenContractAddress The token address to swap from
1236     @param _ToTokenContractAddress The token address to swap to
1237     @param tokens2Trade The amount of tokens to swap
1238     @return tokenBought The quantity of tokens bought
1239     */
1240     function _token2Token(
1241         address _FromTokenContractAddress,
1242         address _ToTokenContractAddress,
1243         uint256 tokens2Trade
1244     ) internal returns (uint256 tokenBought) {
1245         if (_FromTokenContractAddress == _ToTokenContractAddress) {
1246             return tokens2Trade;
1247         }
1248 
1249         IERC20(_FromTokenContractAddress).safeApprove(
1250             address(uniswapRouter),
1251             tokens2Trade
1252         );
1253 
1254         if (_FromTokenContractAddress != wethTokenAddress) {
1255             if (_ToTokenContractAddress != wethTokenAddress) {
1256                 address[] memory path = new address[](3);
1257                 path[0] = _FromTokenContractAddress;
1258                 path[1] = wethTokenAddress;
1259                 path[2] = _ToTokenContractAddress;
1260                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1261                     tokens2Trade,
1262                     1,
1263                     path,
1264                     address(this),
1265                     deadline
1266                 )[path.length - 1];
1267             } else {
1268                 address[] memory path = new address[](2);
1269                 path[0] = _FromTokenContractAddress;
1270                 path[1] = wethTokenAddress;
1271 
1272                 tokenBought = uniswapRouter.swapExactTokensForTokens(
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
1284             tokenBought = uniswapRouter.swapExactTokensForTokens(
1285                 tokens2Trade,
1286                 1,
1287                 path,
1288                 address(this),
1289                 deadline
1290             )[path.length - 1];
1291         }
1292     }
1293 
1294     function _token2Eth(
1295         address _FromTokenContractAddress,
1296         uint256 tokens2Trade,
1297         address payable _toWhomToIssue
1298     ) internal returns (uint256) {
1299         if (_FromTokenContractAddress == wethTokenAddress) {
1300             IWETH(wethTokenAddress).withdraw(tokens2Trade);
1301             _toWhomToIssue.transfer(tokens2Trade);
1302             return tokens2Trade;
1303         }
1304 
1305         IERC20(_FromTokenContractAddress).safeApprove(
1306             address(uniswapRouter),
1307             tokens2Trade
1308         );
1309 
1310         address[] memory path = new address[](2);
1311         path[0] = _FromTokenContractAddress;
1312         path[1] = wethTokenAddress;
1313         uint256 ethBought = uniswapRouter.swapExactTokensForETH(
1314             tokens2Trade,
1315             1,
1316             path,
1317             _toWhomToIssue,
1318             deadline
1319         )[path.length - 1];
1320 
1321         return ethBought;
1322     }
1323 
1324     /**
1325     @notice This function is used to calculate and transfer goodwill
1326     @param _tokenContractAddress Token in which goodwill is deducted
1327     @param tokens2Trade The total amount of tokens to be zapped in
1328     @return goodwillPortion The quantity of goodwill deducted
1329      */
1330     function _transferGoodwill(
1331         address _tokenContractAddress,
1332         uint256 tokens2Trade
1333     ) internal returns (uint256 goodwillPortion) {
1334         goodwillPortion = SafeMath.div(
1335             SafeMath.mul(tokens2Trade, goodwill),
1336             10000
1337         );
1338 
1339         if (goodwillPortion == 0) {
1340             return 0;
1341         }
1342 
1343         IERC20(_tokenContractAddress).safeTransfer(
1344             zgoodwillAddress,
1345             goodwillPortion
1346         );
1347     }
1348 
1349     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1350         require(
1351             _new_goodwill >= 0 && _new_goodwill < 10000,
1352             "GoodWill Value not allowed"
1353         );
1354         goodwill = _new_goodwill;
1355     }
1356 
1357     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1358         uint256 qty = _TokenAddress.balanceOf(address(this));
1359         IERC20(address(_TokenAddress)).safeTransfer(owner(), qty);
1360     }
1361 
1362     // - to Pause the contract
1363     function toggleContractActive() public onlyOwner {
1364         stopped = !stopped;
1365     }
1366 
1367     // - to withdraw any ETH balance sitting in the contract
1368     function withdraw() public onlyOwner {
1369         uint256 contractBalance = address(this).balance;
1370         address payable _to = Address.toPayable(owner());
1371         _to.transfer(contractBalance);
1372     }
1373 
1374     function() external payable {
1375         require(msg.sender != tx.origin, "Do not send ETH directly");
1376     }
1377 }