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
21 ///@notice This contract adds liquidity to Uniswap V2 pools using ETH or any ERC20 Token.
22 // SPDX-License-Identifier: GPLv2
23 
24 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
25 
26 pragma solidity ^0.5.0;
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
30  * the optional functions; to access them see {ERC20Detailed}.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount)
51         external
52         returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender)
62         external
63         view
64         returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address sender,
93         address recipient,
94         uint256 amount
95     ) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(
110         address indexed owner,
111         address indexed spender,
112         uint256 value
113     );
114 }
115 
116 // File: @openzeppelin/contracts/math/SafeMath.sol
117 
118 pragma solidity ^0.5.0;
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134     /**
135      * @dev Returns the addition of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `+` operator.
139      *
140      * Requirements:
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      * - Subtraction cannot overflow.
171      *
172      * _Available since v2.4.0._
173      */
174     function sub(
175         uint256 a,
176         uint256 b,
177         string memory errorMessage
178     ) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         uint256 c = a - b;
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      * - The divisor cannot be zero.
233      *
234      * _Available since v2.4.0._
235      */
236     function div(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         // Solidity only automatically asserts when dividing by 0
242         require(b > 0, errorMessage);
243         uint256 c = a / b;
244         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts with custom message when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      * - The divisor cannot be zero.
274      *
275      * _Available since v2.4.0._
276      */
277     function mod(
278         uint256 a,
279         uint256 b,
280         string memory errorMessage
281     ) internal pure returns (uint256) {
282         require(b != 0, errorMessage);
283         return a % b;
284     }
285 }
286 
287 // File: @openzeppelin/contracts/utils/Address.sol
288 
289 pragma solidity ^0.5.5;
290 
291 /**
292  * @dev Collection of functions related to the address type
293  */
294 library Address {
295     /**
296      * @dev Returns true if `account` is a contract.
297      *
298      * [IMPORTANT]
299      * ====
300      * It is unsafe to assume that an address for which this function returns
301      * false is an externally-owned account (EOA) and not a contract.
302      *
303      * Among others, `isContract` will return false for the following
304      * types of addresses:
305      *
306      *  - an externally-owned account
307      *  - a contract in construction
308      *  - an address where a contract will be created
309      *  - an address where a contract lived, but was destroyed
310      * ====
311      */
312     function isContract(address account) internal view returns (bool) {
313         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
314         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
315         // for accounts without code, i.e. `keccak256('')`
316         bytes32 codehash;
317 
318 
319             bytes32 accountHash
320          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
321         // solhint-disable-next-line no-inline-assembly
322         assembly {
323             codehash := extcodehash(account)
324         }
325         return (codehash != accountHash && codehash != 0x0);
326     }
327 
328     /**
329      * @dev Converts an `address` into `address payable`. Note that this is
330      * simply a type cast: the actual underlying value is not changed.
331      *
332      * _Available since v2.4.0._
333      */
334     function toPayable(address account)
335         internal
336         pure
337         returns (address payable)
338     {
339         return address(uint160(account));
340     }
341 
342     /**
343      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
344      * `recipient`, forwarding all available gas and reverting on errors.
345      *
346      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
347      * of certain opcodes, possibly making contracts go over the 2300 gas limit
348      * imposed by `transfer`, making them unable to receive funds via
349      * `transfer`. {sendValue} removes this limitation.
350      *
351      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
352      *
353      * IMPORTANT: because control is transferred to `recipient`, care must be
354      * taken to not create reentrancy vulnerabilities. Consider using
355      * {ReentrancyGuard} or the
356      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
357      *
358      * _Available since v2.4.0._
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(
362             address(this).balance >= amount,
363             "Address: insufficient balance"
364         );
365 
366         // solhint-disable-next-line avoid-call-value
367         (bool success, ) = recipient.call.value(amount)("");
368         require(
369             success,
370             "Address: unable to send value, recipient may have reverted"
371         );
372     }
373 }
374 
375 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
376 
377 pragma solidity ^0.5.0;
378 
379 /**
380  * @title SafeERC20
381  * @dev Wrappers around ERC20 operations that throw on failure (when the token
382  * contract returns false). Tokens that return no value (and instead revert or
383  * throw on failure) are also supported, non-reverting calls are assumed to be
384  * successful.
385  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
386  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
387  */
388 library SafeERC20 {
389     using SafeMath for uint256;
390     using Address for address;
391 
392     function safeTransfer(
393         IERC20 token,
394         address to,
395         uint256 value
396     ) internal {
397         callOptionalReturn(
398             token,
399             abi.encodeWithSelector(token.transfer.selector, to, value)
400         );
401     }
402 
403     function safeTransferFrom(
404         IERC20 token,
405         address from,
406         address to,
407         uint256 value
408     ) internal {
409         callOptionalReturn(
410             token,
411             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
412         );
413     }
414 
415     function safeApprove(
416         IERC20 token,
417         address spender,
418         uint256 value
419     ) internal {
420         // safeApprove should only be called when setting an initial allowance,
421         // or when resetting it to zero. To increase and decrease it, use
422         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
423         // solhint-disable-next-line max-line-length
424         require(
425             (value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         callOptionalReturn(
429             token,
430             abi.encodeWithSelector(token.approve.selector, spender, value)
431         );
432     }
433 
434     function safeIncreaseAllowance(
435         IERC20 token,
436         address spender,
437         uint256 value
438     ) internal {
439         uint256 newAllowance = token.allowance(address(this), spender).add(
440             value
441         );
442         callOptionalReturn(
443             token,
444             abi.encodeWithSelector(
445                 token.approve.selector,
446                 spender,
447                 newAllowance
448             )
449         );
450     }
451 
452     function safeDecreaseAllowance(
453         IERC20 token,
454         address spender,
455         uint256 value
456     ) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).sub(
458             value,
459             "SafeERC20: decreased allowance below zero"
460         );
461         callOptionalReturn(
462             token,
463             abi.encodeWithSelector(
464                 token.approve.selector,
465                 spender,
466                 newAllowance
467             )
468         );
469     }
470 
471     /**
472      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
473      * on the return value: the return value is optional (but if data is returned, it must not be false).
474      * @param token The token targeted by the call.
475      * @param data The call data (encoded using abi.encode or one of its variants).
476      */
477     function callOptionalReturn(IERC20 token, bytes memory data) private {
478         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
479         // we're implementing it ourselves.
480 
481         // A Solidity high level call has three parts:
482         //  1. The target address is checked to verify it contains contract code
483         //  2. The call itself is made, and success asserted
484         //  3. The return value is decoded, which in turn checks the size of the returned data.
485         // solhint-disable-next-line max-line-length
486         require(address(token).isContract(), "SafeERC20: call to non-contract");
487 
488         // solhint-disable-next-line avoid-low-level-calls
489         (bool success, bytes memory returndata) = address(token).call(data);
490         require(success, "SafeERC20: low-level call failed");
491 
492         if (returndata.length > 0) {
493             // Return data is optional
494             // solhint-disable-next-line max-line-length
495             require(
496                 abi.decode(returndata, (bool)),
497                 "SafeERC20: ERC20 operation did not succeed"
498             );
499         }
500     }
501 }
502 
503 // File: contracts\UniswapV2\UniswapV2_ETH_ERC_Zap_In_V3.sol
504 
505 // File: UniswapV2Router.sol
506 
507 pragma solidity 0.5.12;
508 
509 interface IUniswapV2Router02 {
510     function factory() external pure returns (address);
511 
512     function WETH() external pure returns (address);
513 
514     function addLiquidity(
515         address tokenA,
516         address tokenB,
517         uint256 amountADesired,
518         uint256 amountBDesired,
519         uint256 amountAMin,
520         uint256 amountBMin,
521         address to,
522         uint256 deadline
523     )
524         external
525         returns (
526             uint256 amountA,
527             uint256 amountB,
528             uint256 liquidity
529         );
530 
531     function addLiquidityETH(
532         address token,
533         uint256 amountTokenDesired,
534         uint256 amountTokenMin,
535         uint256 amountETHMin,
536         address to,
537         uint256 deadline
538     )
539         external
540         payable
541         returns (
542             uint256 amountToken,
543             uint256 amountETH,
544             uint256 liquidity
545         );
546 
547     function removeLiquidity(
548         address tokenA,
549         address tokenB,
550         uint256 liquidity,
551         uint256 amountAMin,
552         uint256 amountBMin,
553         address to,
554         uint256 deadline
555     ) external returns (uint256 amountA, uint256 amountB);
556 
557     function removeLiquidityETH(
558         address token,
559         uint256 liquidity,
560         uint256 amountTokenMin,
561         uint256 amountETHMin,
562         address to,
563         uint256 deadline
564     ) external returns (uint256 amountToken, uint256 amountETH);
565 
566     function removeLiquidityWithPermit(
567         address tokenA,
568         address tokenB,
569         uint256 liquidity,
570         uint256 amountAMin,
571         uint256 amountBMin,
572         address to,
573         uint256 deadline,
574         bool approveMax,
575         uint8 v,
576         bytes32 r,
577         bytes32 s
578     ) external returns (uint256 amountA, uint256 amountB);
579 
580     function removeLiquidityETHWithPermit(
581         address token,
582         uint256 liquidity,
583         uint256 amountTokenMin,
584         uint256 amountETHMin,
585         address to,
586         uint256 deadline,
587         bool approveMax,
588         uint8 v,
589         bytes32 r,
590         bytes32 s
591     ) external returns (uint256 amountToken, uint256 amountETH);
592 
593     function swapExactTokensForTokens(
594         uint256 amountIn,
595         uint256 amountOutMin,
596         address[] calldata path,
597         address to,
598         uint256 deadline
599     ) external returns (uint256[] memory amounts);
600 
601     function swapTokensForExactTokens(
602         uint256 amountOut,
603         uint256 amountInMax,
604         address[] calldata path,
605         address to,
606         uint256 deadline
607     ) external returns (uint256[] memory amounts);
608 
609     function swapExactETHForTokens(
610         uint256 amountOutMin,
611         address[] calldata path,
612         address to,
613         uint256 deadline
614     ) external payable returns (uint256[] memory amounts);
615 
616     function swapTokensForExactETH(
617         uint256 amountOut,
618         uint256 amountInMax,
619         address[] calldata path,
620         address to,
621         uint256 deadline
622     ) external returns (uint256[] memory amounts);
623 
624     function swapExactTokensForETH(
625         uint256 amountIn,
626         uint256 amountOutMin,
627         address[] calldata path,
628         address to,
629         uint256 deadline
630     ) external returns (uint256[] memory amounts);
631 
632     function swapETHForExactTokens(
633         uint256 amountOut,
634         address[] calldata path,
635         address to,
636         uint256 deadline
637     ) external payable returns (uint256[] memory amounts);
638 
639     function removeLiquidityETHSupportingFeeOnTransferTokens(
640         address token,
641         uint256 liquidity,
642         uint256 amountTokenMin,
643         uint256 amountETHMin,
644         address to,
645         uint256 deadline
646     ) external returns (uint256 amountETH);
647 
648     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
649         address token,
650         uint256 liquidity,
651         uint256 amountTokenMin,
652         uint256 amountETHMin,
653         address to,
654         uint256 deadline,
655         bool approveMax,
656         uint8 v,
657         bytes32 r,
658         bytes32 s
659     ) external returns (uint256 amountETH);
660 
661     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
662         uint256 amountIn,
663         uint256 amountOutMin,
664         address[] calldata path,
665         address to,
666         uint256 deadline
667     ) external;
668 
669     function swapExactETHForTokensSupportingFeeOnTransferTokens(
670         uint256 amountOutMin,
671         address[] calldata path,
672         address to,
673         uint256 deadline
674     ) external payable;
675 
676     function swapExactTokensForETHSupportingFeeOnTransferTokens(
677         uint256 amountIn,
678         uint256 amountOutMin,
679         address[] calldata path,
680         address to,
681         uint256 deadline
682     ) external;
683 
684     function quote(
685         uint256 amountA,
686         uint256 reserveA,
687         uint256 reserveB
688     ) external pure returns (uint256 amountB);
689 
690     function getAmountOut(
691         uint256 amountIn,
692         uint256 reserveIn,
693         uint256 reserveOut
694     ) external pure returns (uint256 amountOut);
695 
696     function getAmountIn(
697         uint256 amountOut,
698         uint256 reserveIn,
699         uint256 reserveOut
700     ) external pure returns (uint256 amountIn);
701 
702     function getAmountsOut(uint256 amountIn, address[] calldata path)
703         external
704         view
705         returns (uint256[] memory amounts);
706 
707     function getAmountsIn(uint256 amountOut, address[] calldata path)
708         external
709         view
710         returns (uint256[] memory amounts);
711 }
712 // File: OpenZepplinReentrancyGuard.sol
713 
714 pragma solidity ^0.5.0;
715 
716 /**
717  * @dev Contract module that helps prevent reentrant calls to a function.
718  *
719  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
720  * available, which can be applied to functions to make sure there are no nested
721  * (reentrant) calls to them.
722  *
723  * Note that because there is a single `nonReentrant` guard, functions marked as
724  * `nonReentrant` may not call one another. This can be worked around by making
725  * those functions `private`, and then adding `external` `nonReentrant` entry
726  * points to them.
727  *
728  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
729  * metering changes introduced in the Istanbul hardfork.
730  */
731 contract ReentrancyGuard {
732     bool private _notEntered;
733 
734     constructor() internal {
735         // Storing an initial non-zero value makes deployment a bit more
736         // expensive, but in exchange the refund on every call to nonReentrant
737         // will be lower in amount. Since refunds are capped to a percetange of
738         // the total transaction's gas, it is best to keep them low in cases
739         // like this one, to increase the likelihood of the full refund coming
740         // into effect.
741         _notEntered = true;
742     }
743 
744     /**
745      * @dev Prevents a contract from calling itself, directly or indirectly.
746      * Calling a `nonReentrant` function from another `nonReentrant`
747      * function is not supported. It is possible to prevent this from happening
748      * by making the `nonReentrant` function external, and make it call a
749      * `private` function that does the actual work.
750      */
751     modifier nonReentrant() {
752         // On the first call to nonReentrant, _notEntered will be true
753         require(_notEntered, "ReentrancyGuard: reentrant call");
754 
755         // Any calls to nonReentrant after this point will fail
756         _notEntered = false;
757 
758         _;
759 
760         // By storing the original value once again, a refund is triggered (see
761         // https://eips.ethereum.org/EIPS/eip-2200)
762         _notEntered = true;
763     }
764 }
765 
766 // File: Context.sol
767 
768 pragma solidity ^0.5.0;
769 
770 /*
771  * @dev Provides information about the current execution context, including the
772  * sender of the transaction and its data. While these are generally available
773  * via msg.sender and msg.data, they should not be accessed in such a direct
774  * manner, since when dealing with GSN meta-transactions the account sending and
775  * paying for execution may not be the actual sender (as far as an application
776  * is concerned).
777  *
778  * This contract is only required for intermediate, library-like contracts.
779  */
780 contract Context {
781     // Empty internal constructor, to prevent people from mistakenly deploying
782     // an instance of this contract, which should be used via inheritance.
783     constructor() internal {}
784 
785     // solhint-disable-previous-line no-empty-blocks
786 
787     function _msgSender() internal view returns (address payable) {
788         return msg.sender;
789     }
790 
791     function _msgData() internal view returns (bytes memory) {
792         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
793         return msg.data;
794     }
795 }
796 // File: OpenZepplinOwnable.sol
797 
798 pragma solidity ^0.5.0;
799 
800 /**
801  * @dev Contract module which provides a basic access control mechanism, where
802  * there is an account (an owner) that can be granted exclusive access to
803  * specific functions.
804  *
805  * This module is used through inheritance. It will make available the modifier
806  * `onlyOwner`, which can be applied to your functions to restrict their use to
807  * the owner.
808  */
809 contract Ownable is Context {
810     address payable public _owner;
811 
812     event OwnershipTransferred(
813         address indexed previousOwner,
814         address indexed newOwner
815     );
816 
817     /**
818      * @dev Initializes the contract setting the deployer as the initial owner.
819      */
820     constructor() internal {
821         address payable msgSender = _msgSender();
822         _owner = msgSender;
823         emit OwnershipTransferred(address(0), msgSender);
824     }
825 
826     /**
827      * @dev Returns the address of the current owner.
828      */
829     function owner() public view returns (address) {
830         return _owner;
831     }
832 
833     /**
834      * @dev Throws if called by any account other than the owner.
835      */
836     modifier onlyOwner() {
837         require(isOwner(), "Ownable: caller is not the owner");
838         _;
839     }
840 
841     /**
842      * @dev Returns true if the caller is the current owner.
843      */
844     function isOwner() public view returns (bool) {
845         return _msgSender() == _owner;
846     }
847 
848     /**
849      * @dev Leaves the contract without owner. It will not be possible to call
850      * `onlyOwner` functions anymore. Can only be called by the current owner.
851      *
852      * NOTE: Renouncing ownership will leave the contract without an owner,
853      * thereby removing any functionality that is only available to the owner.
854      */
855     function renounceOwnership() public onlyOwner {
856         emit OwnershipTransferred(_owner, address(0));
857         _owner = address(0);
858     }
859 
860     /**
861      * @dev Transfers ownership of the contract to a new account (`newOwner`).
862      * Can only be called by the current owner.
863      */
864     function transferOwnership(address payable newOwner) public onlyOwner {
865         _transferOwnership(newOwner);
866     }
867 
868     /**
869      * @dev Transfers ownership of the contract to a new account (`newOwner`).
870      */
871     function _transferOwnership(address payable newOwner) internal {
872         require(
873             newOwner != address(0),
874             "Ownable: new owner is the zero address"
875         );
876         emit OwnershipTransferred(_owner, newOwner);
877         _owner = newOwner;
878     }
879 }
880 
881 // import "@uniswap/lib/contracts/libraries/Babylonian.sol";
882 library Babylonian {
883     function sqrt(uint256 y) internal pure returns (uint256 z) {
884         if (y > 3) {
885             z = y;
886             uint256 x = y / 2 + 1;
887             while (x < z) {
888                 z = x;
889                 x = (y / x + x) / 2;
890             }
891         } else if (y != 0) {
892             z = 1;
893         }
894         // else z = 0
895     }
896 }
897 
898 interface IWETH {
899     function deposit() external payable;
900 
901     function transfer(address to, uint256 value) external returns (bool);
902 
903     function withdraw(uint256) external;
904 }
905 
906 interface IUniswapV1Factory {
907     function getExchange(address token)
908         external
909         view
910         returns (address exchange);
911 }
912 
913 interface IUniswapV2Factory {
914     function getPair(address tokenA, address tokenB)
915         external
916         view
917         returns (address);
918 }
919 
920 interface IUniswapExchange {
921     // converting ERC20 to ERC20 and transfer
922     function tokenToTokenTransferInput(
923         uint256 tokens_sold,
924         uint256 min_tokens_bought,
925         uint256 min_eth_bought,
926         uint256 deadline,
927         address recipient,
928         address token_addr
929     ) external returns (uint256 tokens_bought);
930 
931     function tokenToTokenSwapInput(
932         uint256 tokens_sold,
933         uint256 min_tokens_bought,
934         uint256 min_eth_bought,
935         uint256 deadline,
936         address token_addr
937     ) external returns (uint256 tokens_bought);
938 
939     function getEthToTokenInputPrice(uint256 eth_sold)
940         external
941         view
942         returns (uint256 tokens_bought);
943 
944     function getTokenToEthInputPrice(uint256 tokens_sold)
945         external
946         view
947         returns (uint256 eth_bought);
948 
949     function tokenToEthTransferInput(
950         uint256 tokens_sold,
951         uint256 min_eth,
952         uint256 deadline,
953         address recipient
954     ) external returns (uint256 eth_bought);
955 
956     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
957         external
958         payable
959         returns (uint256 tokens_bought);
960 
961     function ethToTokenTransferInput(
962         uint256 min_tokens,
963         uint256 deadline,
964         address recipient
965     ) external payable returns (uint256 tokens_bought);
966 
967     function balanceOf(address _owner) external view returns (uint256);
968 
969     function transfer(address _to, uint256 _value) external returns (bool);
970 
971     function transferFrom(
972         address from,
973         address to,
974         uint256 tokens
975     ) external returns (bool success);
976 }
977 
978 interface IUniswapV2Pair {
979     function token0() external pure returns (address);
980 
981     function token1() external pure returns (address);
982 
983     function getReserves()
984         external
985         view
986         returns (
987             uint112 _reserve0,
988             uint112 _reserve1,
989             uint32 _blockTimestampLast
990         );
991 }
992 
993 contract UniswapV2_ZapIn_General_V2_3 is ReentrancyGuard, Ownable {
994     using SafeMath for uint256;
995     using Address for address;
996     using SafeERC20 for IERC20;
997 
998     bool public stopped = false;
999     uint16 public goodwill;
1000     address
1001         private constant zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
1002 
1003     IUniswapV2Router02 private constant uniswapV2Router = IUniswapV2Router02(
1004         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1005     );
1006 
1007     IUniswapV1Factory
1008         private constant UniSwapV1FactoryAddress = IUniswapV1Factory(
1009         0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95
1010     );
1011 
1012     IUniswapV2Factory
1013         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
1014         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
1015     );
1016 
1017     address
1018         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1019 
1020     constructor(uint16 _goodwill) public {
1021         goodwill = _goodwill;
1022     }
1023 
1024     // circuit breaker modifiers
1025     modifier stopInEmergency {
1026         if (stopped) {
1027             revert("Temporarily Paused");
1028         } else {
1029             _;
1030         }
1031     }
1032 
1033     /**
1034     @notice This function is used to invest in given Uniswap V2 pair through ETH/ERC20 Tokens
1035     @param _FromTokenContractAddress The ERC20 token used for investment (address(0x00) if ether)
1036     @param _ToUnipoolToken0 The Uniswap V2 pair token0 address
1037     @param _ToUnipoolToken1 The Uniswap V2 pair token1 address
1038     @param _amount The amount of fromToken to invest
1039     @param _minPoolTokens Reverts if less tokens received than this
1040     @return Amount of LP bought
1041      */
1042     function ZapIn(
1043         address _toWhomToIssue,
1044         address _FromTokenContractAddress,
1045         address _ToUnipoolToken0,
1046         address _ToUnipoolToken1,
1047         uint256 _amount,
1048         uint256 _minPoolTokens
1049     ) public payable nonReentrant stopInEmergency returns (uint256) {
1050         uint256 toInvest;
1051         if (_FromTokenContractAddress == address(0)) {
1052             require(msg.value > 0, "Error: ETH not sent");
1053             toInvest = msg.value;
1054         } else {
1055             require(msg.value == 0, "Error: ETH sent");
1056             require(_amount > 0, "Error: Invalid ERC amount");
1057             IERC20(_FromTokenContractAddress).safeTransferFrom(
1058                 msg.sender,
1059                 address(this),
1060                 _amount
1061             );
1062             toInvest = _amount;
1063         }
1064 
1065         uint256 LPBought = _performZapIn(
1066             _toWhomToIssue,
1067             _FromTokenContractAddress,
1068             _ToUnipoolToken0,
1069             _ToUnipoolToken1,
1070             toInvest
1071         );
1072 
1073         require(LPBought >= _minPoolTokens, "ERR: High Slippage");
1074 
1075         //get pair address
1076         address _ToUniPoolAddress = UniSwapV2FactoryAddress.getPair(
1077             _ToUnipoolToken0,
1078             _ToUnipoolToken1
1079         );
1080 
1081         //transfer goodwill
1082         uint256 goodwillPortion = _transferGoodwill(
1083             _ToUniPoolAddress,
1084             LPBought
1085         );
1086 
1087         IERC20(_ToUniPoolAddress).safeTransfer(
1088             _toWhomToIssue,
1089             SafeMath.sub(LPBought, goodwillPortion)
1090         );
1091         return SafeMath.sub(LPBought, goodwillPortion);
1092     }
1093 
1094     function _performZapIn(
1095         address _toWhomToIssue,
1096         address _FromTokenContractAddress,
1097         address _ToUnipoolToken0,
1098         address _ToUnipoolToken1,
1099         uint256 _amount
1100     ) internal returns (uint256) {
1101         uint256 token0Bought;
1102         uint256 token1Bought;
1103 
1104         if (canSwapFromV2(_ToUnipoolToken0, _ToUnipoolToken1)) {
1105             (token0Bought, token1Bought) = exchangeTokensV2(
1106                 _FromTokenContractAddress,
1107                 _ToUnipoolToken0,
1108                 _ToUnipoolToken1,
1109                 _amount
1110             );
1111         } else if (
1112             canSwapFromV1(_ToUnipoolToken0, _ToUnipoolToken1, _amount, _amount)
1113         ) {
1114             (token0Bought, token1Bought) = exchangeTokensV1(
1115                 _FromTokenContractAddress,
1116                 _ToUnipoolToken0,
1117                 _ToUnipoolToken1,
1118                 _amount
1119             );
1120         }
1121 
1122         require(token0Bought > 0 && token1Bought > 0, "Could not exchange");
1123 
1124         IERC20(_ToUnipoolToken0).safeApprove(
1125             address(uniswapV2Router),
1126             token0Bought
1127         );
1128 
1129         IERC20(_ToUnipoolToken1).safeApprove(
1130             address(uniswapV2Router),
1131             token1Bought
1132         );
1133 
1134         (uint256 amountA, uint256 amountB, uint256 LP) = uniswapV2Router
1135             .addLiquidity(
1136             _ToUnipoolToken0,
1137             _ToUnipoolToken1,
1138             token0Bought,
1139             token1Bought,
1140             1,
1141             1,
1142             address(this),
1143             now + 60
1144         );
1145 
1146         //Reset allowance to zero
1147         IERC20(_ToUnipoolToken0).safeApprove(address(uniswapV2Router), 0);
1148         IERC20(_ToUnipoolToken1).safeApprove(address(uniswapV2Router), 0);
1149 
1150         uint256 residue;
1151         if (SafeMath.sub(token0Bought, amountA) > 0) {
1152             if (canSwapFromV2(_ToUnipoolToken0, _FromTokenContractAddress)) {
1153                 residue = swapFromV2(
1154                     _ToUnipoolToken0,
1155                     _FromTokenContractAddress,
1156                     SafeMath.sub(token0Bought, amountA)
1157                 );
1158             } else {
1159                 IERC20(_ToUnipoolToken0).safeTransfer(
1160                     _toWhomToIssue,
1161                     SafeMath.sub(token0Bought, amountA)
1162                 );
1163             }
1164         }
1165 
1166         if (SafeMath.sub(token1Bought, amountB) > 0) {
1167             if (canSwapFromV2(_ToUnipoolToken1, _FromTokenContractAddress)) {
1168                 residue += swapFromV2(
1169                     _ToUnipoolToken1,
1170                     _FromTokenContractAddress,
1171                     SafeMath.sub(token1Bought, amountB)
1172                 );
1173             } else {
1174                 IERC20(_ToUnipoolToken1).safeTransfer(
1175                     _toWhomToIssue,
1176                     SafeMath.sub(token1Bought, amountB)
1177                 );
1178             }
1179         }
1180 
1181         if (residue > 0) {
1182             if (_FromTokenContractAddress != address(0)) {
1183                 IERC20(_FromTokenContractAddress).safeTransfer(
1184                     _toWhomToIssue,
1185                     residue
1186                 );
1187             } else {
1188                 (bool success, ) = _toWhomToIssue.call.value(residue)("");
1189                 require(success, "Residual ETH Transfer failed.");
1190             }
1191         }
1192 
1193         return LP;
1194     }
1195 
1196     function exchangeTokensV1(
1197         address _FromTokenContractAddress,
1198         address _ToUnipoolToken0,
1199         address _ToUnipoolToken1,
1200         uint256 _amount
1201     ) internal returns (uint256 token0Bought, uint256 token1Bought) {
1202         IUniswapV2Pair pair = IUniswapV2Pair(
1203             UniSwapV2FactoryAddress.getPair(_ToUnipoolToken0, _ToUnipoolToken1)
1204         );
1205         (uint256 res0, uint256 res1, ) = pair.getReserves();
1206         if (_FromTokenContractAddress == address(0)) {
1207             token0Bought = _eth2Token(_ToUnipoolToken0, _amount);
1208             uint256 amountToSwap = calculateSwapInAmount(res0, token0Bought);
1209             //if no reserve or a new pair is created
1210             if (amountToSwap <= 0) amountToSwap = SafeMath.div(token0Bought, 2);
1211             token1Bought = _eth2Token(_ToUnipoolToken1, amountToSwap);
1212             token0Bought = SafeMath.sub(token0Bought, amountToSwap);
1213         } else {
1214             if (_ToUnipoolToken0 == _FromTokenContractAddress) {
1215                 uint256 amountToSwap = calculateSwapInAmount(res0, _amount);
1216                 //if no reserve or a new pair is created
1217                 if (amountToSwap <= 0) amountToSwap = SafeMath.div(_amount, 2);
1218                 token1Bought = _token2Token(
1219                     _FromTokenContractAddress,
1220                     address(this),
1221                     _ToUnipoolToken1,
1222                     amountToSwap
1223                 );
1224 
1225                 token0Bought = SafeMath.sub(_amount, amountToSwap);
1226             } else if (_ToUnipoolToken1 == _FromTokenContractAddress) {
1227                 uint256 amountToSwap = calculateSwapInAmount(res1, _amount);
1228                 //if no reserve or a new pair is created
1229                 if (amountToSwap <= 0) amountToSwap = SafeMath.div(_amount, 2);
1230                 token0Bought = _token2Token(
1231                     _FromTokenContractAddress,
1232                     address(this),
1233                     _ToUnipoolToken0,
1234                     amountToSwap
1235                 );
1236 
1237                 token1Bought = SafeMath.sub(_amount, amountToSwap);
1238             } else {
1239                 token0Bought = _token2Token(
1240                     _FromTokenContractAddress,
1241                     address(this),
1242                     _ToUnipoolToken0,
1243                     _amount
1244                 );
1245                 uint256 amountToSwap = calculateSwapInAmount(
1246                     res0,
1247                     token0Bought
1248                 );
1249                 //if no reserve or a new pair is created
1250                 if (amountToSwap <= 0) amountToSwap = SafeMath.div(_amount, 2);
1251 
1252                 token1Bought = _token2Token(
1253                     _FromTokenContractAddress,
1254                     address(this),
1255                     _ToUnipoolToken1,
1256                     amountToSwap
1257                 );
1258                 token0Bought = SafeMath.sub(token0Bought, amountToSwap);
1259             }
1260         }
1261     }
1262 
1263     function exchangeTokensV2(
1264         address _FromTokenContractAddress,
1265         address _ToUnipoolToken0,
1266         address _ToUnipoolToken1,
1267         uint256 _amount
1268     ) internal returns (uint256 token0Bought, uint256 token1Bought) {
1269         IUniswapV2Pair pair = IUniswapV2Pair(
1270             UniSwapV2FactoryAddress.getPair(_ToUnipoolToken0, _ToUnipoolToken1)
1271         );
1272         (uint256 res0, uint256 res1, ) = pair.getReserves();
1273         if (
1274             canSwapFromV2(_FromTokenContractAddress, _ToUnipoolToken0) &&
1275             canSwapFromV2(_ToUnipoolToken0, _ToUnipoolToken1)
1276         ) {
1277             token0Bought = swapFromV2(
1278                 _FromTokenContractAddress,
1279                 _ToUnipoolToken0,
1280                 _amount
1281             );
1282             uint256 amountToSwap = calculateSwapInAmount(res0, token0Bought);
1283             //if no reserve or a new pair is created
1284             if (amountToSwap <= 0) amountToSwap = SafeMath.div(token0Bought, 2);
1285             token1Bought = swapFromV2(
1286                 _ToUnipoolToken0,
1287                 _ToUnipoolToken1,
1288                 amountToSwap
1289             );
1290             token0Bought = SafeMath.sub(token0Bought, amountToSwap);
1291         } else if (
1292             canSwapFromV2(_FromTokenContractAddress, _ToUnipoolToken1) &&
1293             canSwapFromV2(_ToUnipoolToken0, _ToUnipoolToken1)
1294         ) {
1295             token1Bought = swapFromV2(
1296                 _FromTokenContractAddress,
1297                 _ToUnipoolToken1,
1298                 _amount
1299             );
1300             uint256 amountToSwap = calculateSwapInAmount(res1, token1Bought);
1301             //if no reserve or a new pair is created
1302             if (amountToSwap <= 0) amountToSwap = SafeMath.div(token1Bought, 2);
1303             token0Bought = swapFromV2(
1304                 _ToUnipoolToken1,
1305                 _ToUnipoolToken0,
1306                 amountToSwap
1307             );
1308             token1Bought = SafeMath.sub(token1Bought, amountToSwap);
1309         }
1310     }
1311 
1312     //checks if tokens can be exchanged with UniV1
1313     function canSwapFromV1(
1314         address _fromToken,
1315         address _toToken,
1316         uint256 fromAmount,
1317         uint256 toAmount
1318     ) public view returns (bool) {
1319         require(
1320             _fromToken != address(0) || _toToken != address(0),
1321             "Invalid Exchange values"
1322         );
1323 
1324         if (_fromToken == address(0)) {
1325             IUniswapExchange toExchange = IUniswapExchange(
1326                 UniSwapV1FactoryAddress.getExchange(_toToken)
1327             );
1328             uint256 tokenBalance = IERC20(_toToken).balanceOf(
1329                 address(toExchange)
1330             );
1331             uint256 ethBalance = address(toExchange).balance;
1332             if (tokenBalance > toAmount && ethBalance > fromAmount) return true;
1333         } else if (_toToken == address(0)) {
1334             IUniswapExchange fromExchange = IUniswapExchange(
1335                 UniSwapV1FactoryAddress.getExchange(_fromToken)
1336             );
1337             uint256 tokenBalance = IERC20(_fromToken).balanceOf(
1338                 address(fromExchange)
1339             );
1340             uint256 ethBalance = address(fromExchange).balance;
1341             if (tokenBalance > fromAmount && ethBalance > toAmount) return true;
1342         } else {
1343             IUniswapExchange toExchange = IUniswapExchange(
1344                 UniSwapV1FactoryAddress.getExchange(_toToken)
1345             );
1346             IUniswapExchange fromExchange = IUniswapExchange(
1347                 UniSwapV1FactoryAddress.getExchange(_fromToken)
1348             );
1349             uint256 balance1 = IERC20(_fromToken).balanceOf(
1350                 address(fromExchange)
1351             );
1352             uint256 balance2 = IERC20(_toToken).balanceOf(address(toExchange));
1353             if (balance1 > fromAmount && balance2 > toAmount) return true;
1354         }
1355         return false;
1356     }
1357 
1358     //checks if tokens can be exchanged with UniV2
1359     function canSwapFromV2(address _fromToken, address _toToken)
1360         public
1361         view
1362         returns (bool)
1363     {
1364         require(
1365             _fromToken != address(0) || _toToken != address(0),
1366             "Invalid Exchange values"
1367         );
1368 
1369         if (_fromToken == _toToken) return true;
1370 
1371         if (_fromToken == address(0) || _fromToken == wethTokenAddress) {
1372             if (_toToken == wethTokenAddress || _toToken == address(0))
1373                 return true;
1374             IUniswapV2Pair pair = IUniswapV2Pair(
1375                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1376             );
1377             if (_haveReserve(pair)) return true;
1378         } else if (_toToken == address(0) || _toToken == wethTokenAddress) {
1379             if (_fromToken == wethTokenAddress || _fromToken == address(0))
1380                 return true;
1381             IUniswapV2Pair pair = IUniswapV2Pair(
1382                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1383             );
1384             if (_haveReserve(pair)) return true;
1385         } else {
1386             IUniswapV2Pair pair1 = IUniswapV2Pair(
1387                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1388             );
1389             IUniswapV2Pair pair2 = IUniswapV2Pair(
1390                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1391             );
1392             IUniswapV2Pair pair3 = IUniswapV2Pair(
1393                 UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1394             );
1395             if (_haveReserve(pair1) && _haveReserve(pair2)) return true;
1396             if (_haveReserve(pair3)) return true;
1397         }
1398         return false;
1399     }
1400 
1401     //checks if the UNI v2 contract have reserves to swap tokens
1402     function _haveReserve(IUniswapV2Pair pair) internal view returns (bool) {
1403         if (address(pair) != address(0)) {
1404             (uint256 res0, uint256 res1, ) = pair.getReserves();
1405             if (res0 > 0 && res1 > 0) {
1406                 return true;
1407             }
1408         }
1409     }
1410 
1411     function calculateSwapInAmount(uint256 reserveIn, uint256 userIn)
1412         public
1413         pure
1414         returns (uint256)
1415     {
1416         return
1417             Babylonian
1418                 .sqrt(
1419                 reserveIn.mul(userIn.mul(3988000) + reserveIn.mul(3988009))
1420             )
1421                 .sub(reserveIn.mul(1997)) / 1994;
1422     }
1423 
1424     //swaps _fromToken for _toToken
1425     //for eth, address(0) otherwise ERC token address
1426     function swapFromV2(
1427         address _fromToken,
1428         address _toToken,
1429         uint256 amount
1430     ) internal returns (uint256) {
1431         require(
1432             _fromToken != address(0) || _toToken != address(0),
1433             "Invalid Exchange values"
1434         );
1435         if (_fromToken == _toToken) return amount;
1436 
1437         require(canSwapFromV2(_fromToken, _toToken), "Cannot be exchanged");
1438         require(amount > 0, "Invalid amount");
1439 
1440         if (_fromToken == address(0)) {
1441             if (_toToken == wethTokenAddress) {
1442                 IWETH(wethTokenAddress).deposit.value(amount)();
1443                 return amount;
1444             }
1445             address[] memory path = new address[](2);
1446             path[0] = wethTokenAddress;
1447             path[1] = _toToken;
1448 
1449             uint256[] memory amounts = uniswapV2Router
1450                 .swapExactETHForTokens
1451                 .value(amount)(0, path, address(this), now + 180);
1452             return amounts[1];
1453         } else if (_toToken == address(0)) {
1454             if (_fromToken == wethTokenAddress) {
1455                 IWETH(wethTokenAddress).withdraw(amount);
1456                 return amount;
1457             }
1458             address[] memory path = new address[](2);
1459             IERC20(_fromToken).safeApprove(address(uniswapV2Router), amount);
1460             path[0] = _fromToken;
1461             path[1] = wethTokenAddress;
1462 
1463             uint256[] memory amounts = uniswapV2Router.swapExactTokensForETH(
1464                 amount,
1465                 0,
1466                 path,
1467                 address(this),
1468                 now + 180
1469             );
1470             IERC20(_fromToken).safeApprove(address(uniswapV2Router), 0);
1471             return amounts[1];
1472         } else {
1473             IERC20(_fromToken).safeApprove(address(uniswapV2Router), amount);
1474             uint256 returnedAmount = _swapTokenToTokenV2(
1475                 _fromToken,
1476                 _toToken,
1477                 amount
1478             );
1479             IERC20(_fromToken).safeApprove(address(uniswapV2Router), 0);
1480             require(returnedAmount > 0, "Error in swap");
1481             return returnedAmount;
1482         }
1483     }
1484 
1485     //swaps 2 ERC tokens (UniV2)
1486     function _swapTokenToTokenV2(
1487         address _fromToken,
1488         address _toToken,
1489         uint256 amount
1490     ) internal returns (uint256) {
1491         IUniswapV2Pair pair1 = IUniswapV2Pair(
1492             UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1493         );
1494         IUniswapV2Pair pair2 = IUniswapV2Pair(
1495             UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1496         );
1497         IUniswapV2Pair pair3 = IUniswapV2Pair(
1498             UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1499         );
1500 
1501         uint256[] memory amounts;
1502 
1503         if (_haveReserve(pair3)) {
1504             address[] memory path = new address[](2);
1505             path[0] = _fromToken;
1506             path[1] = _toToken;
1507 
1508             amounts = uniswapV2Router.swapExactTokensForTokens(
1509                 amount,
1510                 0,
1511                 path,
1512                 address(this),
1513                 now + 180
1514             );
1515             return amounts[1];
1516         } else if (_haveReserve(pair1) && _haveReserve(pair2)) {
1517             address[] memory path = new address[](3);
1518             path[0] = _fromToken;
1519             path[1] = wethTokenAddress;
1520             path[2] = _toToken;
1521 
1522             amounts = uniswapV2Router.swapExactTokensForTokens(
1523                 amount,
1524                 0,
1525                 path,
1526                 address(this),
1527                 now + 180
1528             );
1529             return amounts[2];
1530         }
1531         return 0;
1532     }
1533 
1534     /**
1535     @notice This function is used to buy tokens from eth
1536     @param _tokenContractAddress Token address which we want to buy
1537     @param _amount The amount of eth we want to exchange
1538     @return The quantity of token bought
1539      */
1540     function _eth2Token(address _tokenContractAddress, uint256 _amount)
1541         internal
1542         returns (uint256 tokenBought)
1543     {
1544         IUniswapExchange FromUniSwapExchangeContractAddress = IUniswapExchange(
1545             UniSwapV1FactoryAddress.getExchange(_tokenContractAddress)
1546         );
1547 
1548         tokenBought = FromUniSwapExchangeContractAddress
1549             .ethToTokenSwapInput
1550             .value(_amount)(0, SafeMath.add(now, 300));
1551     }
1552 
1553     /**
1554     @notice This function is used to swap token with ETH
1555     @param _FromTokenContractAddress The token address to swap from
1556     @param tokens2Trade The quantity of tokens to swap
1557     @return The amount of eth bought
1558      */
1559     function _token2Eth(
1560         address _FromTokenContractAddress,
1561         uint256 tokens2Trade,
1562         address _toWhomToIssue
1563     ) internal returns (uint256 ethBought) {
1564         IUniswapExchange FromUniSwapExchangeContractAddress = IUniswapExchange(
1565             UniSwapV1FactoryAddress.getExchange(_FromTokenContractAddress)
1566         );
1567 
1568         IERC20(_FromTokenContractAddress).safeApprove(
1569             address(FromUniSwapExchangeContractAddress),
1570             tokens2Trade
1571         );
1572 
1573         ethBought = FromUniSwapExchangeContractAddress.tokenToEthTransferInput(
1574             tokens2Trade,
1575             0,
1576             SafeMath.add(now, 300),
1577             _toWhomToIssue
1578         );
1579         require(ethBought > 0, "Error in swapping Eth: 1");
1580 
1581         IERC20(_FromTokenContractAddress).safeApprove(
1582             address(FromUniSwapExchangeContractAddress),
1583             0
1584         );
1585     }
1586 
1587     /**
1588     @notice This function is used to swap tokens
1589     @param _FromTokenContractAddress The token address to swap from
1590     @param _ToWhomToIssue The address to transfer after swap
1591     @param _ToTokenContractAddress The token address to swap to
1592     @param tokens2Trade The quantity of tokens to swap
1593     @return The amount of tokens returned after swap
1594      */
1595     function _token2Token(
1596         address _FromTokenContractAddress,
1597         address _ToWhomToIssue,
1598         address _ToTokenContractAddress,
1599         uint256 tokens2Trade
1600     ) internal returns (uint256 tokenBought) {
1601         IUniswapExchange FromUniSwapExchangeContractAddress = IUniswapExchange(
1602             UniSwapV1FactoryAddress.getExchange(_FromTokenContractAddress)
1603         );
1604 
1605         IERC20(_FromTokenContractAddress).safeApprove(
1606             address(FromUniSwapExchangeContractAddress),
1607             tokens2Trade
1608         );
1609 
1610         tokenBought = FromUniSwapExchangeContractAddress
1611             .tokenToTokenTransferInput(
1612             tokens2Trade,
1613             0,
1614             0,
1615             SafeMath.add(now, 300),
1616             _ToWhomToIssue,
1617             _ToTokenContractAddress
1618         );
1619         require(tokenBought > 0, "Error in swapping ERC: 1");
1620 
1621         IERC20(_FromTokenContractAddress).safeApprove(
1622             address(FromUniSwapExchangeContractAddress),
1623             0
1624         );
1625     }
1626 
1627     /**
1628     @notice This function is used to calculate and transfer goodwill
1629     @param _tokenContractAddress Token in which goodwill is deducted
1630     @param tokens2Trade The total amount of tokens to be zapped in
1631     @return The quantity of goodwill deducted
1632      */
1633     function _transferGoodwill(
1634         address _tokenContractAddress,
1635         uint256 tokens2Trade
1636     ) internal returns (uint256 goodwillPortion) {
1637         goodwillPortion = SafeMath.div(
1638             SafeMath.mul(tokens2Trade, goodwill),
1639             10000
1640         );
1641 
1642         if (goodwillPortion == 0) {
1643             return 0;
1644         }
1645 
1646         IERC20(_tokenContractAddress).safeTransfer(
1647             zgoodwillAddress,
1648             goodwillPortion
1649         );
1650     }
1651 
1652     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1653         require(
1654             _new_goodwill >= 0 && _new_goodwill < 10000,
1655             "GoodWill Value not allowed"
1656         );
1657         goodwill = _new_goodwill;
1658     }
1659 
1660     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1661         uint256 qty = _TokenAddress.balanceOf(address(this));
1662         _TokenAddress.safeTransfer(owner(), qty);
1663     }
1664 
1665     // - to Pause the contract
1666     function toggleContractActive() public onlyOwner {
1667         stopped = !stopped;
1668     }
1669 
1670     // - to withdraw any ETH balance sitting in the contract
1671     function withdraw() public onlyOwner {
1672         uint256 contractBalance = address(this).balance;
1673         address payable _to = owner().toPayable();
1674         _to.transfer(contractBalance);
1675     }
1676 
1677     function() external payable {}
1678 }