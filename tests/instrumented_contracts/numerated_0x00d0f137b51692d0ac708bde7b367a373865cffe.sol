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
21 ///@notice This contract adds removes liquidity from Balancer Pools into ETH/ERC/Underlying Tokens.
22 // SPDX-License-Identifier: GPLv2
23 
24 // File: @openzeppelin/contracts/utils/Address.sol
25 
26 pragma solidity ^0.5.5;
27 
28 /**
29  * @dev Collection of functions related to the address type
30  */
31 library Address {
32     /**
33      * @dev Returns true if `account` is a contract.
34      *
35      * [IMPORTANT]
36      * ====
37      * It is unsafe to assume that an address for which this function returns
38      * false is an externally-owned account (EOA) and not a contract.
39      *
40      * Among others, `isContract` will return false for the following
41      * types of addresses:
42      *
43      *  - an externally-owned account
44      *  - a contract in construction
45      *  - an address where a contract will be created
46      *  - an address where a contract lived, but was destroyed
47      * ====
48      */
49     function isContract(address account) internal view returns (bool) {
50         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
51         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
52         // for accounts without code, i.e. `keccak256('')`
53         bytes32 codehash;
54 
55 
56             bytes32 accountHash
57          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
58         // solhint-disable-next-line no-inline-assembly
59         assembly {
60             codehash := extcodehash(account)
61         }
62         return (codehash != accountHash && codehash != 0x0);
63     }
64 
65     /**
66      * @dev Converts an `address` into `address payable`. Note that this is
67      * simply a type cast: the actual underlying value is not changed.
68      *
69      * _Available since v2.4.0._
70      */
71     function toPayable(address account)
72         internal
73         pure
74         returns (address payable)
75     {
76         return address(uint160(account));
77     }
78 
79     /**
80      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
81      * `recipient`, forwarding all available gas and reverting on errors.
82      *
83      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
84      * of certain opcodes, possibly making contracts go over the 2300 gas limit
85      * imposed by `transfer`, making them unable to receive funds via
86      * `transfer`. {sendValue} removes this limitation.
87      *
88      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
89      *
90      * IMPORTANT: because control is transferred to `recipient`, care must be
91      * taken to not create reentrancy vulnerabilities. Consider using
92      * {ReentrancyGuard} or the
93      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
94      *
95      * _Available since v2.4.0._
96      */
97     function sendValue(address payable recipient, uint256 amount) internal {
98         require(
99             address(this).balance >= amount,
100             "Address: insufficient balance"
101         );
102 
103         // solhint-disable-next-line avoid-call-value
104         (bool success, ) = recipient.call.value(amount)("");
105         require(
106             success,
107             "Address: unable to send value, recipient may have reverted"
108         );
109     }
110 }
111 
112 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
113 
114 pragma solidity ^0.5.0;
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
118  * the optional functions; to access them see {ERC20Detailed}.
119  */
120 interface IERC20 {
121     /**
122      * @dev Returns the amount of tokens in existence.
123      */
124     function totalSupply() external view returns (uint256);
125 
126     /**
127      * @dev Returns the amount of tokens owned by `account`.
128      */
129     function balanceOf(address account) external view returns (uint256);
130 
131     /**
132      * @dev Moves `amount` tokens from the caller's account to `recipient`.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transfer(address recipient, uint256 amount)
139         external
140         returns (bool);
141 
142     /**
143      * @dev Returns the remaining number of tokens that `spender` will be
144      * allowed to spend on behalf of `owner` through {transferFrom}. This is
145      * zero by default.
146      *
147      * This value changes when {approve} or {transferFrom} are called.
148      */
149     function allowance(address owner, address spender)
150         external
151         view
152         returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `sender` to `recipient` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(
198         address indexed owner,
199         address indexed spender,
200         uint256 value
201     );
202 }
203 
204 // File: @openzeppelin/contracts/GSN/Context.sol
205 
206 pragma solidity ^0.5.0;
207 
208 /*
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with GSN meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 contract Context {
219     // Empty internal constructor, to prevent people from mistakenly deploying
220     // an instance of this contract, which should be used via inheritance.
221     constructor() internal {}
222 
223     // solhint-disable-previous-line no-empty-blocks
224 
225     function _msgSender() internal view returns (address payable) {
226         return msg.sender;
227     }
228 
229     function _msgData() internal view returns (bytes memory) {
230         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
231         return msg.data;
232     }
233 }
234 
235 // File: @openzeppelin/contracts/ownership/Ownable.sol
236 
237 pragma solidity ^0.5.0;
238 
239 /**
240  * @dev Contract module which provides a basic access control mechanism, where
241  * there is an account (an owner) that can be granted exclusive access to
242  * specific functions.
243  *
244  * This module is used through inheritance. It will make available the modifier
245  * `onlyOwner`, which can be applied to your functions to restrict their use to
246  * the owner.
247  */
248 contract Ownable is Context {
249     address private _owner;
250 
251     event OwnershipTransferred(
252         address indexed previousOwner,
253         address indexed newOwner
254     );
255 
256     /**
257      * @dev Initializes the contract setting the deployer as the initial owner.
258      */
259     constructor() internal {
260         address msgSender = _msgSender();
261         _owner = msgSender;
262         emit OwnershipTransferred(address(0), msgSender);
263     }
264 
265     /**
266      * @dev Returns the address of the current owner.
267      */
268     function owner() public view returns (address) {
269         return _owner;
270     }
271 
272     /**
273      * @dev Throws if called by any account other than the owner.
274      */
275     modifier onlyOwner() {
276         require(isOwner(), "Ownable: caller is not the owner");
277         _;
278     }
279 
280     /**
281      * @dev Returns true if the caller is the current owner.
282      */
283     function isOwner() public view returns (bool) {
284         return _msgSender() == _owner;
285     }
286 
287     /**
288      * @dev Leaves the contract without owner. It will not be possible to call
289      * `onlyOwner` functions anymore. Can only be called by the current owner.
290      *
291      * NOTE: Renouncing ownership will leave the contract without an owner,
292      * thereby removing any functionality that is only available to the owner.
293      */
294     function renounceOwnership() public onlyOwner {
295         emit OwnershipTransferred(_owner, address(0));
296         _owner = address(0);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Can only be called by the current owner.
302      */
303     function transferOwnership(address newOwner) public onlyOwner {
304         _transferOwnership(newOwner);
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      */
310     function _transferOwnership(address newOwner) internal {
311         require(
312             newOwner != address(0),
313             "Ownable: new owner is the zero address"
314         );
315         emit OwnershipTransferred(_owner, newOwner);
316         _owner = newOwner;
317     }
318 }
319 
320 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
321 
322 pragma solidity ^0.5.0;
323 
324 /**
325  * @dev Contract module that helps prevent reentrant calls to a function.
326  *
327  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
328  * available, which can be applied to functions to make sure there are no nested
329  * (reentrant) calls to them.
330  *
331  * Note that because there is a single `nonReentrant` guard, functions marked as
332  * `nonReentrant` may not call one another. This can be worked around by making
333  * those functions `private`, and then adding `external` `nonReentrant` entry
334  * points to them.
335  *
336  * TIP: If you would like to learn more about reentrancy and alternative ways
337  * to protect against it, check out our blog post
338  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
339  *
340  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
341  * metering changes introduced in the Istanbul hardfork.
342  */
343 contract ReentrancyGuard {
344     bool private _notEntered;
345 
346     constructor() internal {
347         // Storing an initial non-zero value makes deployment a bit more
348         // expensive, but in exchange the refund on every call to nonReentrant
349         // will be lower in amount. Since refunds are capped to a percetange of
350         // the total transaction's gas, it is best to keep them low in cases
351         // like this one, to increase the likelihood of the full refund coming
352         // into effect.
353         _notEntered = true;
354     }
355 
356     /**
357      * @dev Prevents a contract from calling itself, directly or indirectly.
358      * Calling a `nonReentrant` function from another `nonReentrant`
359      * function is not supported. It is possible to prevent this from happening
360      * by making the `nonReentrant` function external, and make it call a
361      * `private` function that does the actual work.
362      */
363     modifier nonReentrant() {
364         // On the first call to nonReentrant, _notEntered will be true
365         require(_notEntered, "ReentrancyGuard: reentrant call");
366 
367         // Any calls to nonReentrant after this point will fail
368         _notEntered = false;
369 
370         _;
371 
372         // By storing the original value once again, a refund is triggered (see
373         // https://eips.ethereum.org/EIPS/eip-2200)
374         _notEntered = true;
375     }
376 }
377 
378 // File: @openzeppelin/contracts/math/SafeMath.sol
379 
380 pragma solidity ^0.5.0;
381 
382 /**
383  * @dev Wrappers over Solidity's arithmetic operations with added overflow
384  * checks.
385  *
386  * Arithmetic operations in Solidity wrap on overflow. This can easily result
387  * in bugs, because programmers usually assume that an overflow raises an
388  * error, which is the standard behavior in high level programming languages.
389  * `SafeMath` restores this intuition by reverting the transaction when an
390  * operation overflows.
391  *
392  * Using this library instead of the unchecked operations eliminates an entire
393  * class of bugs, so it's recommended to use it always.
394  */
395 library SafeMath {
396     /**
397      * @dev Returns the addition of two unsigned integers, reverting on
398      * overflow.
399      *
400      * Counterpart to Solidity's `+` operator.
401      *
402      * Requirements:
403      * - Addition cannot overflow.
404      */
405     function add(uint256 a, uint256 b) internal pure returns (uint256) {
406         uint256 c = a + b;
407         require(c >= a, "SafeMath: addition overflow");
408 
409         return c;
410     }
411 
412     /**
413      * @dev Returns the subtraction of two unsigned integers, reverting on
414      * overflow (when the result is negative).
415      *
416      * Counterpart to Solidity's `-` operator.
417      *
418      * Requirements:
419      * - Subtraction cannot overflow.
420      */
421     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422         return sub(a, b, "SafeMath: subtraction overflow");
423     }
424 
425     /**
426      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
427      * overflow (when the result is negative).
428      *
429      * Counterpart to Solidity's `-` operator.
430      *
431      * Requirements:
432      * - Subtraction cannot overflow.
433      *
434      * _Available since v2.4.0._
435      */
436     function sub(
437         uint256 a,
438         uint256 b,
439         string memory errorMessage
440     ) internal pure returns (uint256) {
441         require(b <= a, errorMessage);
442         uint256 c = a - b;
443 
444         return c;
445     }
446 
447     /**
448      * @dev Returns the multiplication of two unsigned integers, reverting on
449      * overflow.
450      *
451      * Counterpart to Solidity's `*` operator.
452      *
453      * Requirements:
454      * - Multiplication cannot overflow.
455      */
456     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
457         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
458         // benefit is lost if 'b' is also tested.
459         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
460         if (a == 0) {
461             return 0;
462         }
463 
464         uint256 c = a * b;
465         require(c / a == b, "SafeMath: multiplication overflow");
466 
467         return c;
468     }
469 
470     /**
471      * @dev Returns the integer division of two unsigned integers. Reverts on
472      * division by zero. The result is rounded towards zero.
473      *
474      * Counterpart to Solidity's `/` operator. Note: this function uses a
475      * `revert` opcode (which leaves remaining gas untouched) while Solidity
476      * uses an invalid opcode to revert (consuming all remaining gas).
477      *
478      * Requirements:
479      * - The divisor cannot be zero.
480      */
481     function div(uint256 a, uint256 b) internal pure returns (uint256) {
482         return div(a, b, "SafeMath: division by zero");
483     }
484 
485     /**
486      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
487      * division by zero. The result is rounded towards zero.
488      *
489      * Counterpart to Solidity's `/` operator. Note: this function uses a
490      * `revert` opcode (which leaves remaining gas untouched) while Solidity
491      * uses an invalid opcode to revert (consuming all remaining gas).
492      *
493      * Requirements:
494      * - The divisor cannot be zero.
495      *
496      * _Available since v2.4.0._
497      */
498     function div(
499         uint256 a,
500         uint256 b,
501         string memory errorMessage
502     ) internal pure returns (uint256) {
503         // Solidity only automatically asserts when dividing by 0
504         require(b > 0, errorMessage);
505         uint256 c = a / b;
506         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
507 
508         return c;
509     }
510 
511     /**
512      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
513      * Reverts when dividing by zero.
514      *
515      * Counterpart to Solidity's `%` operator. This function uses a `revert`
516      * opcode (which leaves remaining gas untouched) while Solidity uses an
517      * invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      * - The divisor cannot be zero.
521      */
522     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
523         return mod(a, b, "SafeMath: modulo by zero");
524     }
525 
526     /**
527      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
528      * Reverts with custom message when dividing by zero.
529      *
530      * Counterpart to Solidity's `%` operator. This function uses a `revert`
531      * opcode (which leaves remaining gas untouched) while Solidity uses an
532      * invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      * - The divisor cannot be zero.
536      *
537      * _Available since v2.4.0._
538      */
539     function mod(
540         uint256 a,
541         uint256 b,
542         string memory errorMessage
543     ) internal pure returns (uint256) {
544         require(b != 0, errorMessage);
545         return a % b;
546     }
547 }
548 
549 // File: contracts/Balancer/Balancer_ZapOut_General_V2_2.sol
550 
551 pragma solidity ^0.5.12;
552 
553 interface IBFactory_Balancer_Unzap_V1_1 {
554     function isBPool(address b) external view returns (bool);
555 }
556 
557 interface IBPool_Balancer_Unzap_V1_1 {
558     function exitswapPoolAmountIn(
559         address tokenOut,
560         uint256 poolAmountIn,
561         uint256 minAmountOut
562     ) external payable returns (uint256 tokenAmountOut);
563 
564     function totalSupply() external view returns (uint256);
565 
566     function getFinalTokens() external view returns (address[] memory tokens);
567 
568     function getDenormalizedWeight(address token)
569         external
570         view
571         returns (uint256);
572 
573     function getTotalDenormalizedWeight() external view returns (uint256);
574 
575     function getSwapFee() external view returns (uint256);
576 
577     function isBound(address t) external view returns (bool);
578 
579     function calcSingleOutGivenPoolIn(
580         uint256 tokenBalanceOut,
581         uint256 tokenWeightOut,
582         uint256 poolSupply,
583         uint256 totalWeight,
584         uint256 poolAmountIn,
585         uint256 swapFee
586     ) external pure returns (uint256 tokenAmountOut);
587 
588     function getBalance(address token) external view returns (uint256);
589 }
590 
591 interface IuniswapFactory_Balancer_Unzap_V1_1 {
592     function getExchange(address token)
593         external
594         view
595         returns (address exchange);
596 }
597 
598 interface Iuniswap_Balancer_Unzap_V1_1 {
599     // converting ERC20 to ERC20 and transfer
600     function tokenToTokenTransferInput(
601         uint256 tokens_sold,
602         uint256 min_tokens_bought,
603         uint256 min_eth_bought,
604         uint256 deadline,
605         address recipient,
606         address token_addr
607     ) external returns (uint256 tokens_bought);
608 
609     function getTokenToEthInputPrice(uint256 tokens_sold)
610         external
611         view
612         returns (uint256 eth_bought);
613 
614     function getEthToTokenInputPrice(uint256 eth_sold)
615         external
616         view
617         returns (uint256 tokens_bought);
618 
619     function tokenToEthTransferInput(
620         uint256 tokens_sold,
621         uint256 min_eth,
622         uint256 deadline,
623         address recipient
624     ) external returns (uint256 eth_bought);
625 
626     function balanceOf(address _owner) external view returns (uint256);
627 
628     function transfer(address _to, uint256 _value) external returns (bool);
629 
630     function transferFrom(
631         address from,
632         address to,
633         uint256 tokens
634     ) external returns (bool success);
635 }
636 
637 interface IWETH {
638     function deposit() external payable;
639 
640     function transfer(address to, uint256 value) external returns (bool);
641 
642     function withdraw(uint256) external;
643 }
644 
645 library TransferHelper {
646     function safeApprove(
647         address token,
648         address to,
649         uint256 value
650     ) internal {
651         // bytes4(keccak256(bytes('approve(address,uint256)')));
652         (bool success, bytes memory data) = token.call(
653             abi.encodeWithSelector(0x095ea7b3, to, value)
654         );
655         require(
656             success && (data.length == 0 || abi.decode(data, (bool))),
657             "TransferHelper: APPROVE_FAILED"
658         );
659     }
660 
661     function safeTransfer(
662         address token,
663         address to,
664         uint256 value
665     ) internal {
666         // bytes4(keccak256(bytes('transfer(address,uint256)')));
667         (bool success, bytes memory data) = token.call(
668             abi.encodeWithSelector(0xa9059cbb, to, value)
669         );
670         require(
671             success && (data.length == 0 || abi.decode(data, (bool))),
672             "TransferHelper: TRANSFER_FAILED"
673         );
674     }
675 
676     function safeTransferFrom(
677         address token,
678         address from,
679         address to,
680         uint256 value
681     ) internal {
682         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
683         (bool success, bytes memory data) = token.call(
684             abi.encodeWithSelector(0x23b872dd, from, to, value)
685         );
686         require(
687             success && (data.length == 0 || abi.decode(data, (bool))),
688             "TransferHelper: TRANSFER_FROM_FAILED"
689         );
690     }
691 }
692 
693 interface IUniswapV2Factory {
694     function getPair(address tokenA, address tokenB)
695         external
696         view
697         returns (address);
698 }
699 
700 interface IUniswapRouter02 {
701     //get estimated amountOut
702     function getAmountsOut(uint256 amountIn, address[] calldata path)
703         external
704         view
705         returns (uint256[] memory amounts);
706 
707     function getAmountsIn(uint256 amountOut, address[] calldata path)
708         external
709         view
710         returns (uint256[] memory amounts);
711 
712     //token 2 token
713     function swapExactTokensForTokens(
714         uint256 amountIn,
715         uint256 amountOutMin,
716         address[] calldata path,
717         address to,
718         uint256 deadline
719     ) external returns (uint256[] memory amounts);
720 
721     function swapTokensForExactTokens(
722         uint256 amountOut,
723         uint256 amountInMax,
724         address[] calldata path,
725         address to,
726         uint256 deadline
727     ) external returns (uint256[] memory amounts);
728 
729     //eth 2 token
730     function swapExactETHForTokens(
731         uint256 amountOutMin,
732         address[] calldata path,
733         address to,
734         uint256 deadline
735     ) external payable returns (uint256[] memory amounts);
736 
737     function swapETHForExactTokens(
738         uint256 amountOut,
739         address[] calldata path,
740         address to,
741         uint256 deadline
742     ) external payable returns (uint256[] memory amounts);
743 
744     //token 2 eth
745     function swapTokensForExactETH(
746         uint256 amountOut,
747         uint256 amountInMax,
748         address[] calldata path,
749         address to,
750         uint256 deadline
751     ) external returns (uint256[] memory amounts);
752 
753     function swapExactTokensForETH(
754         uint256 amountIn,
755         uint256 amountOutMin,
756         address[] calldata path,
757         address to,
758         uint256 deadline
759     ) external returns (uint256[] memory amounts);
760 }
761 
762 contract Balancer_ZapOut_General_V2_2 is ReentrancyGuard, Ownable {
763     using SafeMath for uint256;
764     using Address for address;
765     bool private stopped = false;
766     uint16 public goodwill;
767     address
768         private constant zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
769 
770     IUniswapV2Factory
771         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
772         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
773     );
774     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
775         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
776     );
777     IBFactory_Balancer_Unzap_V1_1
778         private constant BalancerFactory = IBFactory_Balancer_Unzap_V1_1(
779         0x9424B1412450D0f8Fc2255FAf6046b98213B76Bd
780     );
781 
782     address
783         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
784 
785     uint256
786         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
787 
788     event Zapout(
789         address _toWhomToIssue,
790         address _fromBalancerPoolAddress,
791         address _toTokenContractAddress,
792         uint256 _OutgoingAmount
793     );
794 
795     constructor(uint16 _goodwill) public {
796         goodwill = _goodwill;
797     }
798 
799     // circuit breaker modifiers
800     modifier stopInEmergency {
801         if (stopped) {
802             revert("Temporarily Paused");
803         } else {
804             _;
805         }
806     }
807 
808     /**
809     @notice This function is used for zapping out of balancer pools
810     @param _ToTokenContractAddress The token in which we want zapout (for ethers, its zero address)
811     @param _FromBalancerPoolAddress The address of balancer pool to zap out
812     @param _IncomingBPT The quantity of balancer pool tokens
813     @param _minTokensRec slippage user wants
814     @return success or failure
815     */
816     function EasyZapOut(
817         address _ToTokenContractAddress,
818         address _FromBalancerPoolAddress,
819         uint256 _IncomingBPT,
820         uint256 _minTokensRec
821     ) public payable nonReentrant stopInEmergency returns (uint256) {
822         require(
823             BalancerFactory.isBPool(_FromBalancerPoolAddress),
824             "Invalid Balancer Pool"
825         );
826 
827         address _FromTokenAddress;
828         if (
829             IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress).isBound(
830                 _ToTokenContractAddress
831             )
832         ) {
833             _FromTokenAddress = _ToTokenContractAddress;
834         } else if (
835             _ToTokenContractAddress == address(0) &&
836             IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress).isBound(
837                 wethTokenAddress
838             )
839         ) {
840             _FromTokenAddress = wethTokenAddress;
841         } else {
842             _FromTokenAddress = _getBestDeal(
843                 _FromBalancerPoolAddress,
844                 _IncomingBPT
845             );
846         }
847         return (
848             _performZapOut(
849                 msg.sender,
850                 _ToTokenContractAddress,
851                 _FromBalancerPoolAddress,
852                 _IncomingBPT,
853                 _FromTokenAddress,
854                 _minTokensRec
855             )
856         );
857     }
858 
859     /**
860     @notice This method is called by ZapOut and EasyZapOut()
861     @param _toWhomToIssue is the address of user
862     @param _ToTokenContractAddress is the address of the token to which you want to convert to
863     @param _FromBalancerPoolAddress the address of the Balancer Pool from which you want to ZapOut
864     @param _IncomingBPT is the quantity of Balancer Pool tokens that the user wants to ZapOut
865     @param _IntermediateToken is the token to which the Balancer Pool should be Zapped Out
866     @notice this is only used if the outgoing token is not amongst the Balancer Pool tokens
867     @return success or failure
868     */
869     function _performZapOut(
870         address payable _toWhomToIssue,
871         address _ToTokenContractAddress,
872         address _FromBalancerPoolAddress,
873         uint256 _IncomingBPT,
874         address _IntermediateToken,
875         uint256 _minTokensRec
876     ) internal returns (uint256) {
877         //transfer goodwill
878         uint256 goodwillPortion = _transferGoodwill(
879             _FromBalancerPoolAddress,
880             _IncomingBPT
881         );
882 
883         require(
884             IERC20(_FromBalancerPoolAddress).transferFrom(
885                 msg.sender,
886                 address(this),
887                 SafeMath.sub(_IncomingBPT, goodwillPortion)
888             )
889         );
890 
891         if (
892             IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress).isBound(
893                 _ToTokenContractAddress
894             )
895         ) {
896             return (
897                 _directZapout(
898                     _FromBalancerPoolAddress,
899                     _ToTokenContractAddress,
900                     _toWhomToIssue,
901                     SafeMath.sub(_IncomingBPT, goodwillPortion),
902                     _minTokensRec
903                 )
904             );
905         }
906 
907         //exit balancer
908         uint256 _returnedTokens = _exitBalancer(
909             _FromBalancerPoolAddress,
910             _IntermediateToken,
911             SafeMath.sub(_IncomingBPT, goodwillPortion)
912         );
913 
914         if (_ToTokenContractAddress == address(0)) {
915             uint256 ethBought = _token2Eth(
916                 _IntermediateToken,
917                 _returnedTokens,
918                 _toWhomToIssue
919             );
920 
921             require(ethBought >= _minTokensRec, "High slippage");
922             emit Zapout(
923                 _toWhomToIssue,
924                 _FromBalancerPoolAddress,
925                 _ToTokenContractAddress,
926                 ethBought
927             );
928             return ethBought;
929         } else {
930             uint256 tokenBought = _token2Token(
931                 _IntermediateToken,
932                 _toWhomToIssue,
933                 _ToTokenContractAddress,
934                 _returnedTokens
935             );
936             require(tokenBought >= _minTokensRec, "High slippage");
937 
938             emit Zapout(
939                 _toWhomToIssue,
940                 _FromBalancerPoolAddress,
941                 _ToTokenContractAddress,
942                 tokenBought
943             );
944             return tokenBought;
945         }
946     }
947 
948     /**
949     @notice This function is used for zapping out of balancer pool
950     @param _FromBalancerPoolAddress The address of balancer pool to zap out
951     @param _ToTokenContractAddress The token in which we want to zapout (for ethers, its zero address)
952     @param _toWhomToIssue The address of user
953     @param tokens2Trade The quantity of balancer pool tokens
954     @return success or failure
955     */
956     function _directZapout(
957         address _FromBalancerPoolAddress,
958         address _ToTokenContractAddress,
959         address _toWhomToIssue,
960         uint256 tokens2Trade,
961         uint256 _minTokensRec
962     ) internal returns (uint256 returnedTokens) {
963         returnedTokens = _exitBalancer(
964             _FromBalancerPoolAddress,
965             _ToTokenContractAddress,
966             tokens2Trade
967         );
968 
969         require(returnedTokens >= _minTokensRec, "High slippage");
970 
971         emit Zapout(
972             _toWhomToIssue,
973             _FromBalancerPoolAddress,
974             _ToTokenContractAddress,
975             returnedTokens
976         );
977 
978         IERC20(_ToTokenContractAddress).transfer(
979             _toWhomToIssue,
980             returnedTokens
981         );
982     }
983 
984     /**
985     @notice This function is used to calculate and transfer goodwill
986     @param _tokenContractAddress Token address in which goodwill is deducted
987     @param tokens2Trade The total amount of tokens to be zapped out
988     @return The amount of goodwill deducted
989     */
990     function _transferGoodwill(
991         address _tokenContractAddress,
992         uint256 tokens2Trade
993     ) internal returns (uint256 goodwillPortion) {
994         if (goodwill == 0) {
995             return 0;
996         }
997 
998         goodwillPortion = SafeMath.div(
999             SafeMath.mul(tokens2Trade, goodwill),
1000             10000
1001         );
1002 
1003         require(
1004             IERC20(_tokenContractAddress).transferFrom(
1005                 msg.sender,
1006                 zgoodwillAddress,
1007                 goodwillPortion
1008             ),
1009             "Error in transferring BPT:1"
1010         );
1011         return goodwillPortion;
1012     }
1013 
1014     /**
1015     @notice This function finds best token from the final tokens of balancer pool
1016     @param _FromBalancerPoolAddress The address of balancer pool to zap out
1017     @param _IncomingBPT The amount of balancer pool token to covert
1018     @return The token address having max liquidity
1019      */
1020     function _getBestDeal(
1021         address _FromBalancerPoolAddress,
1022         uint256 _IncomingBPT
1023     ) internal view returns (address _token) {
1024         //get token list
1025         address[] memory tokens = IBPool_Balancer_Unzap_V1_1(
1026             _FromBalancerPoolAddress
1027         )
1028             .getFinalTokens();
1029 
1030         uint256 maxEth;
1031 
1032         for (uint256 index = 0; index < tokens.length; index++) {
1033             //get token for given bpt amount
1034             uint256 tokensForBPT = _getBPT2Token(
1035                 _FromBalancerPoolAddress,
1036                 _IncomingBPT,
1037                 tokens[index]
1038             );
1039 
1040             //get eth value for each token
1041             if (tokens[index] != wethTokenAddress) {
1042                 if (
1043                     UniSwapV2FactoryAddress.getPair(
1044                         tokens[index],
1045                         wethTokenAddress
1046                     ) == address(0)
1047                 ) {
1048                     continue;
1049                 }
1050 
1051                 address[] memory path = new address[](2);
1052                 path[0] = tokens[index];
1053                 path[1] = wethTokenAddress;
1054                 uint256 ethReturned = uniswapRouter.getAmountsOut(
1055                     tokensForBPT,
1056                     path
1057                 )[1];
1058 
1059                 //get max eth value
1060                 if (maxEth < ethReturned) {
1061                     maxEth = ethReturned;
1062                     _token = tokens[index];
1063                 }
1064             } else {
1065                 //get max eth value
1066                 if (maxEth < tokensForBPT) {
1067                     maxEth = tokensForBPT;
1068                     _token = tokens[index];
1069                 }
1070             }
1071         }
1072     }
1073 
1074     /**
1075     @notice This function gives the amount of tokens on zapping out from given BPool
1076     @param _FromBalancerPoolAddress Address of balancer pool to zapout from
1077     @param _IncomingBPT The amount of BPT to zapout
1078     @param _toToken Address of token to zap out with
1079     @return Amount of ERC token
1080      */
1081     function _getBPT2Token(
1082         address _FromBalancerPoolAddress,
1083         uint256 _IncomingBPT,
1084         address _toToken
1085     ) internal view returns (uint256 tokensReturned) {
1086         uint256 totalSupply = IBPool_Balancer_Unzap_V1_1(
1087             _FromBalancerPoolAddress
1088         )
1089             .totalSupply();
1090         uint256 swapFee = IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress)
1091             .getSwapFee();
1092         uint256 totalWeight = IBPool_Balancer_Unzap_V1_1(
1093             _FromBalancerPoolAddress
1094         )
1095             .getTotalDenormalizedWeight();
1096         uint256 balance = IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress)
1097             .getBalance(_toToken);
1098         uint256 denorm = IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress)
1099             .getDenormalizedWeight(_toToken);
1100 
1101         tokensReturned = IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress)
1102             .calcSingleOutGivenPoolIn(
1103             balance,
1104             denorm,
1105             totalSupply,
1106             totalWeight,
1107             _IncomingBPT,
1108             swapFee
1109         );
1110     }
1111 
1112     /**
1113     @notice This function is used to zap out of the given balancer pool
1114     @param _FromBalancerPoolAddress The address of balancer pool to zap out
1115     @param _ToTokenContractAddress The Token address which will be zapped out
1116     @param _amount The amount of token for zapout
1117     @return The amount of tokens received after zap out
1118      */
1119     function _exitBalancer(
1120         address _FromBalancerPoolAddress,
1121         address _ToTokenContractAddress,
1122         uint256 _amount
1123     ) internal returns (uint256 returnedTokens) {
1124         require(
1125             IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress).isBound(
1126                 _ToTokenContractAddress
1127             ),
1128             "Token not bound"
1129         );
1130 
1131         uint256 minTokens = _getBPT2Token(
1132             _FromBalancerPoolAddress,
1133             _amount,
1134             _ToTokenContractAddress
1135         );
1136         minTokens = SafeMath.div(SafeMath.mul(minTokens, 98), 100);
1137 
1138         returnedTokens = IBPool_Balancer_Unzap_V1_1(_FromBalancerPoolAddress)
1139             .exitswapPoolAmountIn(_ToTokenContractAddress, _amount, minTokens);
1140 
1141         require(returnedTokens > 0, "Error in exiting balancer pool");
1142     }
1143 
1144     /**
1145     @notice This function is used to swap tokens
1146     @param _FromTokenContractAddress The token address to swap from
1147     @param _ToWhomToIssue The address to transfer after swap
1148     @param _ToTokenContractAddress The token address to swap to
1149     @param tokens2Trade The quantity of tokens to swap
1150     @return The amount of tokens returned after swap
1151      */
1152     function _token2Token(
1153         address _FromTokenContractAddress,
1154         address _ToWhomToIssue,
1155         address _ToTokenContractAddress,
1156         uint256 tokens2Trade
1157     ) internal returns (uint256 tokenBought) {
1158         TransferHelper.safeApprove(
1159             _FromTokenContractAddress,
1160             address(uniswapRouter),
1161             tokens2Trade
1162         );
1163 
1164         if (_FromTokenContractAddress != wethTokenAddress) {
1165             address[] memory path = new address[](3);
1166             path[0] = _FromTokenContractAddress;
1167             path[1] = wethTokenAddress;
1168             path[2] = _ToTokenContractAddress;
1169             tokenBought = uniswapRouter.swapExactTokensForTokens(
1170                 tokens2Trade,
1171                 1,
1172                 path,
1173                 _ToWhomToIssue,
1174                 deadline
1175             )[path.length - 1];
1176         } else {
1177             address[] memory path = new address[](2);
1178             path[0] = wethTokenAddress;
1179             path[1] = _ToTokenContractAddress;
1180             tokenBought = uniswapRouter.swapExactTokensForTokens(
1181                 tokens2Trade,
1182                 1,
1183                 path,
1184                 _ToWhomToIssue,
1185                 deadline
1186             )[path.length - 1];
1187         }
1188 
1189         require(tokenBought > 0, "Error in swapping ERC: 1");
1190     }
1191 
1192     /**
1193     @notice This function is used to swap tokens to eth
1194     @param _FromTokenContractAddress The token address to swap from
1195     @param tokens2Trade The quantity of tokens to swap
1196     @param _toWhomToIssue The address to transfer after swap
1197     @return The amount of ether returned after swap
1198      */
1199     function _token2Eth(
1200         address _FromTokenContractAddress,
1201         uint256 tokens2Trade,
1202         address payable _toWhomToIssue
1203     ) internal returns (uint256 ethBought) {
1204         if (_FromTokenContractAddress == wethTokenAddress) {
1205             IWETH(wethTokenAddress).withdraw(tokens2Trade);
1206             _toWhomToIssue.transfer(tokens2Trade);
1207             return tokens2Trade;
1208         }
1209 
1210         IERC20(_FromTokenContractAddress).approve(
1211             address(uniswapRouter),
1212             tokens2Trade
1213         );
1214 
1215         address[] memory path = new address[](2);
1216         path[0] = _FromTokenContractAddress;
1217         path[1] = wethTokenAddress;
1218         ethBought = uniswapRouter.swapExactTokensForETH(
1219             tokens2Trade,
1220             1,
1221             path,
1222             _toWhomToIssue,
1223             deadline
1224         )[path.length - 1];
1225 
1226         require(ethBought > 0, "Error in swapping Eth: 1");
1227     }
1228 
1229     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1230         require(
1231             _new_goodwill >= 0 && _new_goodwill < 10000,
1232             "GoodWill Value not allowed"
1233         );
1234         goodwill = _new_goodwill;
1235     }
1236 
1237     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1238         uint256 qty = _TokenAddress.balanceOf(address(this));
1239         _TokenAddress.transfer(owner(), qty);
1240     }
1241 
1242     // - to Pause the contract
1243     function toggleContractActive() public onlyOwner {
1244         stopped = !stopped;
1245     }
1246 
1247     // - to withdraw any ETH balance sitting in the contract
1248     function withdraw() public onlyOwner {
1249         uint256 contractBalance = address(this).balance;
1250         address payable _to = owner().toPayable();
1251         _to.transfer(contractBalance);
1252     }
1253 
1254     function() external payable {}
1255 }