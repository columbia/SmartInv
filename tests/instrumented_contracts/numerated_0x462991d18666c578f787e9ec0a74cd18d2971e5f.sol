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
21 ///@notice This contract adds/removes liquidity to yEarn Vaults using ETH or ERC20 Tokens.
22 // SPDX-License-Identifier: GPLv2
23 
24 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
25 
26 pragma solidity ^0.5.5;
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
674 interface IYVault {
675     function deposit(uint256) external;
676 
677     function withdraw(uint256) external;
678 
679     function getPricePerFullShare() external view returns (uint256);
680 
681     function token() external view returns (address);
682 
683     // V2
684     function pricePerShare() external view returns (uint256);
685 }
686 
687 // -- Curve --
688 interface ICurveRegistry {
689     function getSwapAddress(address tokenAddress)
690         external
691         view
692         returns (address swapAddress);
693 }
694 
695 interface ICurveZapIn {
696     function ZapIn(
697         address _fromTokenAddress,
698         address _toTokenAddress,
699         address _swapAddress,
700         uint256 _incomingTokenQty,
701         uint256 _minPoolTokens,
702         address _swapTarget,
703         bytes calldata _swapCallData,
704         address affiliate
705     ) external payable returns (uint256 crvTokensBought);
706 }
707 
708 // -- Aave --
709 interface IAaveLendingPoolAddressesProvider {
710     function getLendingPool() external view returns (address);
711 
712     function getLendingPoolCore() external view returns (address payable);
713 }
714 
715 interface IAaveLendingPool {
716     function deposit(
717         address _reserve,
718         uint256 _amount,
719         uint16 _referralCode
720     ) external payable;
721 }
722 
723 interface IAToken {
724     function redeem(uint256 _amount) external;
725 
726     function underlyingAssetAddress() external returns (address);
727 }
728 
729 // ---
730 interface IWETH {
731     function deposit() external payable;
732 
733     function withdraw(uint256) external;
734 }
735 
736 contract yVault_ZapIn_V2_0_1 is ReentrancyGuard, Ownable {
737     using SafeMath for uint256;
738     using SafeERC20 for IERC20;
739     bool public stopped = false;
740 
741     // if true, goodwill is not deducted
742     mapping(address => bool) public feeWhitelist;
743 
744     uint256 public goodwill;
745     // % share of goodwill (0-100 %)
746     uint256 affiliateSplit;
747     // restrict affiliates
748     mapping(address => bool) public affiliates;
749     // affiliate => token => amount
750     mapping(address => mapping(address => uint256)) public affiliateBalance;
751     // token => amount
752     mapping(address => uint256) public totalAffiliateBalance;
753 
754     address
755         private constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
756 
757     IAaveLendingPoolAddressesProvider
758         private constant lendingPoolAddressProvider = IAaveLendingPoolAddressesProvider(
759         0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
760     );
761 
762     ICurveRegistry public curveReg;
763     ICurveZapIn public curveZapIn;
764 
765     event zapIn(address sender, address pool, uint256 tokensRec);
766 
767     constructor(
768         ICurveRegistry _curveReg,
769         ICurveZapIn _curveZapIn,
770         uint256 _goodwill,
771         uint256 _affiliateSplit
772     ) public {
773         curveReg = _curveReg;
774         curveZapIn = _curveZapIn;
775         goodwill = _goodwill;
776         affiliateSplit = _affiliateSplit;
777     }
778 
779     // circuit breaker modifiers
780     modifier stopInEmergency {
781         if (stopped) {
782             revert("Temporarily Paused");
783         } else {
784             _;
785         }
786     }
787 
788     /**
789     @notice This function adds liquidity to a Yearn vaults with ETH or ERC20 tokens
790     @param fromToken The token used for entry (address(0) if ether)
791     @param amountIn The amount of fromToken to invest
792     @param toVault Yearn vault address
793     @param isAaveUnderlying True is vault contains aave token
794     @param minYVTokens The minimum acceptable quantity vault tokens to receive. Reverts otherwise
795     @param _swapTarget Excecution target for the swap
796     @param swapData DEX quote data
797     @param affiliate Affiliate address
798     @return tokensReceived- Quantity of Vault tokens received
799      */
800     function ZapInTokenVault(
801         address fromToken,
802         uint256 amountIn,
803         address toVault,
804         bool isAaveUnderlying,
805         uint256 minYVTokens,
806         address _swapTarget,
807         bytes calldata swapData,
808         address affiliate
809     ) external payable stopInEmergency returns (uint256 tokensReceived) {
810         // get incoming tokens
811         uint256 toInvest = _pullTokens(fromToken, amountIn, affiliate, true);
812 
813         // swap to toToken
814         address underlyingVaultToken = IYVault(toVault).token();
815         uint256 toTokenAmt;
816         if (isAaveUnderlying) {
817             address underlyingAsset = IAToken(underlyingVaultToken)
818                 .underlyingAssetAddress();
819 
820             // aTokens are 1:1
821             toTokenAmt = _fillQuote(
822                 fromToken,
823                 underlyingAsset,
824                 toInvest,
825                 _swapTarget,
826                 swapData
827             );
828 
829             IERC20(underlyingAsset).safeApprove(
830                 lendingPoolAddressProvider.getLendingPoolCore(),
831                 toTokenAmt
832             );
833             IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
834                 .deposit(underlyingAsset, toTokenAmt, 0);
835         } else {
836             toTokenAmt = _fillQuote(
837                 fromToken,
838                 underlyingVaultToken,
839                 toInvest,
840                 _swapTarget,
841                 swapData
842             );
843         }
844 
845         // Deposit to Vault
846         tokensReceived = _vaultDeposit(
847             underlyingVaultToken,
848             toTokenAmt,
849             toVault,
850             minYVTokens
851         );
852     }
853 
854     /**
855     @notice This function adds liquidity to a Yearn Curve vaults with ETH or ERC20 tokens
856     @param fromToken The token used for entry (address(0) if ether)
857     @param amountIn The amount of fromToken to invest
858     @param toToken Intermediate token to swap to
859     @param toVault Yearn vault address
860     @param minYVTokens The minimum acceptable quantity vault tokens to receive. Reverts otherwise
861     @param _swapTarget Excecution target for the swap
862     @param swapData DEX quote data
863     @param affiliate Affiliate address
864     @return tokensReceived- Quantity of Vault tokens received
865      */
866     function ZapInCurveVault(
867         address fromToken,
868         uint256 amountIn,
869         address toToken,
870         address toVault,
871         uint256 minYVTokens,
872         address _swapTarget,
873         bytes calldata swapData,
874         address affiliate
875     ) external payable stopInEmergency returns (uint256 tokensReceived) {
876         // get incoming tokens
877         uint256 toInvest = _pullTokens(fromToken, amountIn, affiliate, true);
878 
879         // ZapIn to Curve
880         address curveDepositAddr = curveReg.getSwapAddress(
881             IYVault(toVault).token()
882         );
883 
884         uint256 curveLP;
885         if (fromToken != address(0)) {
886             IERC20(fromToken).safeApprove(address(curveZapIn), toInvest);
887             curveLP = curveZapIn.ZapIn(
888                 fromToken,
889                 toToken,
890                 curveDepositAddr,
891                 toInvest,
892                 0,
893                 _swapTarget,
894                 swapData,
895                 affiliate
896             );
897         } else {
898             curveLP = curveZapIn.ZapIn.value(toInvest)(
899                 fromToken,
900                 toToken,
901                 curveDepositAddr,
902                 toInvest,
903                 0,
904                 _swapTarget,
905                 swapData,
906                 affiliate
907             );
908         }
909 
910         // Deposit to Vault
911         tokensReceived = _vaultDeposit(
912             IYVault(toVault).token(),
913             curveLP,
914             toVault,
915             minYVTokens
916         );
917     }
918 
919     function _vaultDeposit(
920         address underlyingVaultToken,
921         uint256 amount,
922         address toVault,
923         uint256 minTokensRec
924     ) internal returns (uint256 tokensReceived) {
925         IERC20(underlyingVaultToken).safeApprove(toVault, amount);
926         uint256 iniYVaultBal = IERC20(toVault).balanceOf(address(this));
927         IYVault(toVault).deposit(amount);
928         tokensReceived = IERC20(toVault).balanceOf(address(this)).sub(
929             iniYVaultBal
930         );
931 
932         require(tokensReceived >= minTokensRec, "Err: High Slippage");
933 
934         IERC20(toVault).safeTransfer(msg.sender, tokensReceived);
935 
936         emit zapIn(msg.sender, toVault, tokensReceived);
937     }
938 
939     function _fillQuote(
940         address _fromTokenAddress,
941         address toToken,
942         uint256 _amount,
943         address _swapTarget,
944         bytes memory swapCallData
945     ) internal returns (uint256 amtBought) {
946         uint256 valueToSend;
947 
948         if (_fromTokenAddress == toToken) {
949             return _amount;
950         }
951 
952         if (_fromTokenAddress == address(0)) {
953             valueToSend = _amount;
954         } else {
955             IERC20 fromToken = IERC20(_fromTokenAddress);
956             fromToken.safeApprove(address(_swapTarget), 0);
957             fromToken.safeApprove(address(_swapTarget), _amount);
958         }
959 
960         uint256 iniBal = _getBalance(toToken);
961         (bool success, ) = _swapTarget.call.value(valueToSend)(swapCallData);
962         require(success, "Error Swapping Tokens 1");
963         uint256 finalBal = _getBalance(toToken);
964 
965         amtBought = finalBal.sub(iniBal);
966     }
967 
968     function _getBalance(address token)
969         internal
970         view
971         returns (uint256 balance)
972     {
973         if (token == address(0)) {
974             balance = address(this).balance;
975         } else {
976             balance = IERC20(token).balanceOf(address(this));
977         }
978     }
979 
980     ///@notice enableGoodwill should be false if vault contains Curve LP, otherwise true
981     function _pullTokens(
982         address token,
983         uint256 amount,
984         address affiliate,
985         bool enableGoodwill
986     ) internal returns (uint256 value) {
987         uint256 totalGoodwillPortion;
988 
989         if (token == address(0)) {
990             require(msg.value > 0, "No eth sent");
991 
992             // subtract goodwill
993             totalGoodwillPortion = _subtractGoodwill(
994                 ETHAddress,
995                 msg.value,
996                 affiliate,
997                 enableGoodwill
998             );
999 
1000             return msg.value.sub(totalGoodwillPortion);
1001         }
1002         require(amount > 0, "Invalid token amount");
1003         require(msg.value == 0, "Eth sent with token");
1004 
1005         //transfer token
1006         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1007 
1008         // subtract goodwill
1009         totalGoodwillPortion = _subtractGoodwill(
1010             token,
1011             amount,
1012             affiliate,
1013             enableGoodwill
1014         );
1015 
1016         return amount.sub(totalGoodwillPortion);
1017     }
1018 
1019     function _subtractGoodwill(
1020         address token,
1021         uint256 amount,
1022         address affiliate,
1023         bool enableGoodwill
1024     ) internal returns (uint256 totalGoodwillPortion) {
1025         bool whitelisted = feeWhitelist[msg.sender];
1026         if (enableGoodwill && !whitelisted && goodwill > 0) {
1027             totalGoodwillPortion = SafeMath.div(
1028                 SafeMath.mul(amount, goodwill),
1029                 10000
1030             );
1031 
1032             if (affiliates[affiliate]) {
1033                 uint256 affiliatePortion = totalGoodwillPortion
1034                     .mul(affiliateSplit)
1035                     .div(100);
1036                 affiliateBalance[affiliate][token] = affiliateBalance[affiliate][token]
1037                     .add(affiliatePortion);
1038                 totalAffiliateBalance[token] = totalAffiliateBalance[token].add(
1039                     affiliatePortion
1040                 );
1041             }
1042         }
1043     }
1044 
1045     function updateCurveRegistry(ICurveRegistry newCurveRegistry)
1046         external
1047         onlyOwner
1048     {
1049         require(newCurveRegistry != curveReg, "Already using this Registry");
1050         curveReg = newCurveRegistry;
1051     }
1052 
1053     function updateCurveZapIn(ICurveZapIn newCurveZapIn) external onlyOwner {
1054         require(newCurveZapIn != curveZapIn, "Already using this ZapIn");
1055         curveZapIn = newCurveZapIn;
1056     }
1057 
1058     // - to Pause the contract
1059     function toggleContractActive() public onlyOwner {
1060         stopped = !stopped;
1061     }
1062 
1063     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1064         require(
1065             _new_goodwill >= 0 && _new_goodwill <= 100,
1066             "GoodWill Value not allowed"
1067         );
1068         goodwill = _new_goodwill;
1069     }
1070 
1071     function set_feeWhitelist(address zapAddress, bool status)
1072         external
1073         onlyOwner
1074     {
1075         feeWhitelist[zapAddress] = status;
1076     }
1077 
1078     function set_new_affiliateSplit(uint16 _new_affiliateSplit)
1079         external
1080         onlyOwner
1081     {
1082         require(
1083             _new_affiliateSplit <= 100,
1084             "Affiliate Split Value not allowed"
1085         );
1086         affiliateSplit = _new_affiliateSplit;
1087     }
1088 
1089     function set_affiliate(address _affiliate, bool _status)
1090         external
1091         onlyOwner
1092     {
1093         affiliates[_affiliate] = _status;
1094     }
1095 
1096     ///@notice Withdraw goodwill share, retaining affilliate share
1097     function withdrawTokens(address[] calldata tokens) external onlyOwner {
1098         for (uint256 i = 0; i < tokens.length; i++) {
1099             uint256 qty;
1100 
1101             if (tokens[i] == ETHAddress) {
1102                 qty = address(this).balance.sub(
1103                     totalAffiliateBalance[tokens[i]]
1104                 );
1105                 Address.sendValue(Address.toPayable(owner()), qty);
1106             } else {
1107                 qty = IERC20(tokens[i]).balanceOf(address(this)).sub(
1108                     totalAffiliateBalance[tokens[i]]
1109                 );
1110                 IERC20(tokens[i]).safeTransfer(owner(), qty);
1111             }
1112         }
1113     }
1114 
1115     ///@notice Withdraw affilliate share, retaining goodwill share
1116     function affilliateWithdraw(address[] calldata tokens) external {
1117         uint256 tokenBal;
1118         for (uint256 i = 0; i < tokens.length; i++) {
1119             tokenBal = affiliateBalance[msg.sender][tokens[i]];
1120             affiliateBalance[msg.sender][tokens[i]] = 0;
1121             totalAffiliateBalance[tokens[i]] = totalAffiliateBalance[tokens[i]]
1122                 .sub(tokenBal);
1123 
1124             if (tokens[i] == ETHAddress) {
1125                 Address.sendValue(msg.sender, tokenBal);
1126             } else {
1127                 IERC20(tokens[i]).safeTransfer(msg.sender, tokenBal);
1128             }
1129         }
1130     }
1131 
1132     function() external payable {
1133         require(msg.sender != tx.origin, "Do not send ETH directly");
1134     }
1135 }