1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.17;
8 
9 interface IUniswapV2Router01 {
10     function factory() external pure returns (address);
11     function WETH() external pure returns (address);
12 
13     function addLiquidity(
14         address tokenA,
15         address tokenB,
16         uint amountADesired,
17         uint amountBDesired,
18         uint amountAMin,
19         uint amountBMin,
20         address to,
21         uint deadline
22     ) external returns (uint amountA, uint amountB, uint liquidity);
23     function addLiquidityETH(
24         address token,
25         uint amountTokenDesired,
26         uint amountTokenMin,
27         uint amountETHMin,
28         address to,
29         uint deadline
30     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
31     function removeLiquidity(
32         address tokenA,
33         address tokenB,
34         uint liquidity,
35         uint amountAMin,
36         uint amountBMin,
37         address to,
38         uint deadline
39     ) external returns (uint amountA, uint amountB);
40     function removeLiquidityETH(
41         address token,
42         uint liquidity,
43         uint amountTokenMin,
44         uint amountETHMin,
45         address to,
46         uint deadline
47     ) external returns (uint amountToken, uint amountETH);
48     function removeLiquidityWithPermit(
49         address tokenA,
50         address tokenB,
51         uint liquidity,
52         uint amountAMin,
53         uint amountBMin,
54         address to,
55         uint deadline,
56         bool approveMax, uint8 v, bytes32 r, bytes32 s
57     ) external returns (uint amountA, uint amountB);
58     function removeLiquidityETHWithPermit(
59         address token,
60         uint liquidity,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline,
65         bool approveMax, uint8 v, bytes32 r, bytes32 s
66     ) external returns (uint amountToken, uint amountETH);
67     function swapExactTokensForTokens(
68         uint amountIn,
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external returns (uint[] memory amounts);
74     function swapTokensForExactTokens(
75         uint amountOut,
76         uint amountInMax,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external returns (uint[] memory amounts);
81     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
82         external
83         payable
84         returns (uint[] memory amounts);
85     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
86         external
87         returns (uint[] memory amounts);
88     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
89         external
90         returns (uint[] memory amounts);
91     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
92         external
93         payable
94         returns (uint[] memory amounts);
95 
96     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
97     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
98     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
99     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
100     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
101 }
102 
103 interface IUniswapV2Router02 is IUniswapV2Router01 {
104     function removeLiquidityETHSupportingFeeOnTransferTokens(
105         address token,
106         uint liquidity,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external returns (uint amountETH);
112     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
113         address token,
114         uint liquidity,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline,
119         bool approveMax, uint8 v, bytes32 r, bytes32 s
120     ) external returns (uint amountETH);
121 
122     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external;
129     function swapExactETHForTokensSupportingFeeOnTransferTokens(
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external payable;
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142 }
143 
144 interface IUniswapV2Factory {
145     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
146 
147     function feeTo() external view returns (address);
148     function feeToSetter() external view returns (address);
149 
150     function getPair(address tokenA, address tokenB) external view returns (address pair);
151     function allPairs(uint) external view returns (address pair);
152     function allPairsLength() external view returns (uint);
153 
154     function createPair(address tokenA, address tokenB) external returns (address pair);
155 
156     function setFeeTo(address) external;
157     function setFeeToSetter(address) external;
158 }
159 
160 /**
161  * @dev Wrappers over Solidity's arithmetic operations.
162  *
163  * NOTE: `SignedSafeMath` is no longer needed starting with Solidity 0.8. The compiler
164  * now has built in overflow checking.
165  */
166 library SignedSafeMath {
167     /**
168      * @dev Returns the multiplication of two signed integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(int256 a, int256 b) internal pure returns (int256) {
178         return a * b;
179     }
180 
181     /**
182      * @dev Returns the integer division of two signed integers. Reverts on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator.
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(int256 a, int256 b) internal pure returns (int256) {
192         return a / b;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two signed integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(int256 a, int256 b) internal pure returns (int256) {
206         return a - b;
207     }
208 
209     /**
210      * @dev Returns the addition of two signed integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `+` operator.
214      *
215      * Requirements:
216      *
217      * - Addition cannot overflow.
218      */
219     function add(int256 a, int256 b) internal pure returns (int256) {
220         return a + b;
221     }
222 }
223 
224 // CAUTION
225 // This version of SafeMath should only be used with Solidity 0.8 or later,
226 // because it relies on the compiler's built in overflow checks.
227 
228 /**
229  * @dev Wrappers over Solidity's arithmetic operations.
230  *
231  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
232  * now has built in overflow checking.
233  */
234 library SafeMath {
235     /**
236      * @dev Returns the addition of two unsigned integers, with an overflow flag.
237      *
238      * _Available since v3.4._
239      */
240     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
241         unchecked {
242             uint256 c = a + b;
243             if (c < a) return (false, 0);
244             return (true, c);
245         }
246     }
247 
248     /**
249      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
250      *
251      * _Available since v3.4._
252      */
253     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b > a) return (false, 0);
256             return (true, a - b);
257         }
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
262      *
263      * _Available since v3.4._
264      */
265     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
268             // benefit is lost if 'b' is also tested.
269             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
270             if (a == 0) return (true, 0);
271             uint256 c = a * b;
272             if (c / a != b) return (false, 0);
273             return (true, c);
274         }
275     }
276 
277     /**
278      * @dev Returns the division of two unsigned integers, with a division by zero flag.
279      *
280      * _Available since v3.4._
281      */
282     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
283         unchecked {
284             if (b == 0) return (false, 0);
285             return (true, a / b);
286         }
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
291      *
292      * _Available since v3.4._
293      */
294     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         unchecked {
296             if (b == 0) return (false, 0);
297             return (true, a % b);
298         }
299     }
300 
301     /**
302      * @dev Returns the addition of two unsigned integers, reverting on
303      * overflow.
304      *
305      * Counterpart to Solidity's `+` operator.
306      *
307      * Requirements:
308      *
309      * - Addition cannot overflow.
310      */
311     function add(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a + b;
313     }
314 
315     /**
316      * @dev Returns the subtraction of two unsigned integers, reverting on
317      * overflow (when the result is negative).
318      *
319      * Counterpart to Solidity's `-` operator.
320      *
321      * Requirements:
322      *
323      * - Subtraction cannot overflow.
324      */
325     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a - b;
327     }
328 
329     /**
330      * @dev Returns the multiplication of two unsigned integers, reverting on
331      * overflow.
332      *
333      * Counterpart to Solidity's `*` operator.
334      *
335      * Requirements:
336      *
337      * - Multiplication cannot overflow.
338      */
339     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
340         return a * b;
341     }
342 
343     /**
344      * @dev Returns the integer division of two unsigned integers, reverting on
345      * division by zero. The result is rounded towards zero.
346      *
347      * Counterpart to Solidity's `/` operator.
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function div(uint256 a, uint256 b) internal pure returns (uint256) {
354         return a / b;
355     }
356 
357     /**
358      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
359      * reverting when dividing by zero.
360      *
361      * Counterpart to Solidity's `%` operator. This function uses a `revert`
362      * opcode (which leaves remaining gas untouched) while Solidity uses an
363      * invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      *
367      * - The divisor cannot be zero.
368      */
369     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
370         return a % b;
371     }
372 
373     /**
374      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
375      * overflow (when the result is negative).
376      *
377      * CAUTION: This function is deprecated because it requires allocating memory for the error
378      * message unnecessarily. For custom revert reasons use {trySub}.
379      *
380      * Counterpart to Solidity's `-` operator.
381      *
382      * Requirements:
383      *
384      * - Subtraction cannot overflow.
385      */
386     function sub(
387         uint256 a,
388         uint256 b,
389         string memory errorMessage
390     ) internal pure returns (uint256) {
391         unchecked {
392             require(b <= a, errorMessage);
393             return a - b;
394         }
395     }
396 
397     /**
398      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
399      * division by zero. The result is rounded towards zero.
400      *
401      * Counterpart to Solidity's `/` operator. Note: this function uses a
402      * `revert` opcode (which leaves remaining gas untouched) while Solidity
403      * uses an invalid opcode to revert (consuming all remaining gas).
404      *
405      * Requirements:
406      *
407      * - The divisor cannot be zero.
408      */
409     function div(
410         uint256 a,
411         uint256 b,
412         string memory errorMessage
413     ) internal pure returns (uint256) {
414         unchecked {
415             require(b > 0, errorMessage);
416             return a / b;
417         }
418     }
419 
420     /**
421      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
422      * reverting with custom message when dividing by zero.
423      *
424      * CAUTION: This function is deprecated because it requires allocating memory for the error
425      * message unnecessarily. For custom revert reasons use {tryMod}.
426      *
427      * Counterpart to Solidity's `%` operator. This function uses a `revert`
428      * opcode (which leaves remaining gas untouched) while Solidity uses an
429      * invalid opcode to revert (consuming all remaining gas).
430      *
431      * Requirements:
432      *
433      * - The divisor cannot be zero.
434      */
435     function mod(
436         uint256 a,
437         uint256 b,
438         string memory errorMessage
439     ) internal pure returns (uint256) {
440         unchecked {
441             require(b > 0, errorMessage);
442             return a % b;
443         }
444     }
445 }
446 
447 /**
448  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
449  * checks.
450  *
451  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
452  * easily result in undesired exploitation or bugs, since developers usually
453  * assume that overflows raise errors. `SafeCast` restores this intuition by
454  * reverting the transaction when such an operation overflows.
455  *
456  * Using this library instead of the unchecked operations eliminates an entire
457  * class of bugs, so it's recommended to use it always.
458  *
459  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
460  * all math on `uint256` and `int256` and then downcasting.
461  */
462 library SafeCast {
463     /**
464      * @dev Returns the downcasted uint224 from uint256, reverting on
465      * overflow (when the input is greater than largest uint224).
466      *
467      * Counterpart to Solidity's `uint224` operator.
468      *
469      * Requirements:
470      *
471      * - input must fit into 224 bits
472      */
473     function toUint224(uint256 value) internal pure returns (uint224) {
474         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
475         return uint224(value);
476     }
477 
478     /**
479      * @dev Returns the downcasted uint128 from uint256, reverting on
480      * overflow (when the input is greater than largest uint128).
481      *
482      * Counterpart to Solidity's `uint128` operator.
483      *
484      * Requirements:
485      *
486      * - input must fit into 128 bits
487      */
488     function toUint128(uint256 value) internal pure returns (uint128) {
489         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
490         return uint128(value);
491     }
492 
493     /**
494      * @dev Returns the downcasted uint96 from uint256, reverting on
495      * overflow (when the input is greater than largest uint96).
496      *
497      * Counterpart to Solidity's `uint96` operator.
498      *
499      * Requirements:
500      *
501      * - input must fit into 96 bits
502      */
503     function toUint96(uint256 value) internal pure returns (uint96) {
504         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
505         return uint96(value);
506     }
507 
508     /**
509      * @dev Returns the downcasted uint64 from uint256, reverting on
510      * overflow (when the input is greater than largest uint64).
511      *
512      * Counterpart to Solidity's `uint64` operator.
513      *
514      * Requirements:
515      *
516      * - input must fit into 64 bits
517      */
518     function toUint64(uint256 value) internal pure returns (uint64) {
519         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
520         return uint64(value);
521     }
522 
523     /**
524      * @dev Returns the downcasted uint32 from uint256, reverting on
525      * overflow (when the input is greater than largest uint32).
526      *
527      * Counterpart to Solidity's `uint32` operator.
528      *
529      * Requirements:
530      *
531      * - input must fit into 32 bits
532      */
533     function toUint32(uint256 value) internal pure returns (uint32) {
534         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
535         return uint32(value);
536     }
537 
538     /**
539      * @dev Returns the downcasted uint16 from uint256, reverting on
540      * overflow (when the input is greater than largest uint16).
541      *
542      * Counterpart to Solidity's `uint16` operator.
543      *
544      * Requirements:
545      *
546      * - input must fit into 16 bits
547      */
548     function toUint16(uint256 value) internal pure returns (uint16) {
549         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
550         return uint16(value);
551     }
552 
553     /**
554      * @dev Returns the downcasted uint8 from uint256, reverting on
555      * overflow (when the input is greater than largest uint8).
556      *
557      * Counterpart to Solidity's `uint8` operator.
558      *
559      * Requirements:
560      *
561      * - input must fit into 8 bits.
562      */
563     function toUint8(uint256 value) internal pure returns (uint8) {
564         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
565         return uint8(value);
566     }
567 
568     /**
569      * @dev Converts a signed int256 into an unsigned uint256.
570      *
571      * Requirements:
572      *
573      * - input must be greater than or equal to 0.
574      */
575     function toUint256(int256 value) internal pure returns (uint256) {
576         require(value >= 0, "SafeCast: value must be positive");
577         return uint256(value);
578     }
579 
580     /**
581      * @dev Returns the downcasted int128 from int256, reverting on
582      * overflow (when the input is less than smallest int128 or
583      * greater than largest int128).
584      *
585      * Counterpart to Solidity's `int128` operator.
586      *
587      * Requirements:
588      *
589      * - input must fit into 128 bits
590      *
591      * _Available since v3.1._
592      */
593     function toInt128(int256 value) internal pure returns (int128) {
594         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
595         return int128(value);
596     }
597 
598     /**
599      * @dev Returns the downcasted int64 from int256, reverting on
600      * overflow (when the input is less than smallest int64 or
601      * greater than largest int64).
602      *
603      * Counterpart to Solidity's `int64` operator.
604      *
605      * Requirements:
606      *
607      * - input must fit into 64 bits
608      *
609      * _Available since v3.1._
610      */
611     function toInt64(int256 value) internal pure returns (int64) {
612         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
613         return int64(value);
614     }
615 
616     /**
617      * @dev Returns the downcasted int32 from int256, reverting on
618      * overflow (when the input is less than smallest int32 or
619      * greater than largest int32).
620      *
621      * Counterpart to Solidity's `int32` operator.
622      *
623      * Requirements:
624      *
625      * - input must fit into 32 bits
626      *
627      * _Available since v3.1._
628      */
629     function toInt32(int256 value) internal pure returns (int32) {
630         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
631         return int32(value);
632     }
633 
634     /**
635      * @dev Returns the downcasted int16 from int256, reverting on
636      * overflow (when the input is less than smallest int16 or
637      * greater than largest int16).
638      *
639      * Counterpart to Solidity's `int16` operator.
640      *
641      * Requirements:
642      *
643      * - input must fit into 16 bits
644      *
645      * _Available since v3.1._
646      */
647     function toInt16(int256 value) internal pure returns (int16) {
648         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
649         return int16(value);
650     }
651 
652     /**
653      * @dev Returns the downcasted int8 from int256, reverting on
654      * overflow (when the input is less than smallest int8 or
655      * greater than largest int8).
656      *
657      * Counterpart to Solidity's `int8` operator.
658      *
659      * Requirements:
660      *
661      * - input must fit into 8 bits.
662      *
663      * _Available since v3.1._
664      */
665     function toInt8(int256 value) internal pure returns (int8) {
666         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
667         return int8(value);
668     }
669 
670     /**
671      * @dev Converts an unsigned uint256 into a signed int256.
672      *
673      * Requirements:
674      *
675      * - input must be less than or equal to maxInt256.
676      */
677     function toInt256(uint256 value) internal pure returns (int256) {
678         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
679         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
680         return int256(value);
681     }
682 }
683 
684 /*
685  * @dev Provides information about the current execution context, including the
686  * sender of the transaction and its data. While these are generally available
687  * via msg.sender and msg.data, they should not be accessed in such a direct
688  * manner, since when dealing with meta-transactions the account sending and
689  * paying for execution may not be the actual sender (as far as an application
690  * is concerned).
691  *
692  * This contract is only required for intermediate, library-like contracts.
693  */
694 abstract contract Context {
695     function _msgSender() internal view virtual returns (address) {
696         return msg.sender;
697     }
698 
699     function _msgData() internal view virtual returns (bytes calldata) {
700         return msg.data;
701     }
702 }
703 
704 /**
705  * @dev Interface of the ERC20 standard as defined in the EIP.
706  */
707 interface IERC20 {
708     /**
709      * @dev Returns the amount of tokens in existence.
710      */
711     function totalSupply() external view returns (uint256);
712 
713     /**
714      * @dev Returns the amount of tokens owned by `account`.
715      */
716     function balanceOf(address account) external view returns (uint256);
717 
718     /**
719      * @dev Moves `amount` tokens from the caller's account to `recipient`.
720      *
721      * Returns a boolean value indicating whether the operation succeeded.
722      *
723      * Emits a {Transfer} event.
724      */
725     function transfer(address recipient, uint256 amount) external returns (bool);
726 
727     /**
728      * @dev Returns the remaining number of tokens that `spender` will be
729      * allowed to spend on behalf of `owner` through {transferFrom}. This is
730      * zero by default.
731      *
732      * This value changes when {approve} or {transferFrom} are called.
733      */
734     function allowance(address owner, address spender) external view returns (uint256);
735 
736     /**
737      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
738      *
739      * Returns a boolean value indicating whether the operation succeeded.
740      *
741      * IMPORTANT: Beware that changing an allowance with this method brings the risk
742      * that someone may use both the old and the new allowance by unfortunate
743      * transaction ordering. One possible solution to mitigate this race
744      * condition is to first reduce the spender's allowance to 0 and set the
745      * desired value afterwards:
746      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
747      *
748      * Emits an {Approval} event.
749      */
750     function approve(address spender, uint256 amount) external returns (bool);
751 
752     /**
753      * @dev Moves `amount` tokens from `sender` to `recipient` using the
754      * allowance mechanism. `amount` is then deducted from the caller's
755      * allowance.
756      *
757      * Returns a boolean value indicating whether the operation succeeded.
758      *
759      * Emits a {Transfer} event.
760      */
761     function transferFrom(
762         address sender,
763         address recipient,
764         uint256 amount
765     ) external returns (bool);
766 
767     /**
768      * @dev Emitted when `value` tokens are moved from one account (`from`) to
769      * another (`to`).
770      *
771      * Note that `value` may be zero.
772      */
773     event Transfer(address indexed from, address indexed to, uint256 value);
774 
775     /**
776      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
777      * a call to {approve}. `value` is the new allowance.
778      */
779     event Approval(address indexed owner, address indexed spender, uint256 value);
780 }
781 
782 /**
783  * @dev Interface for the optional metadata functions from the ERC20 standard.
784  *
785  * _Available since v4.1._
786  */
787 interface IERC20Metadata is IERC20 {
788     /**
789      * @dev Returns the name of the token.
790      */
791     function name() external view returns (string memory);
792 
793     /**
794      * @dev Returns the symbol of the token.
795      */
796     function symbol() external view returns (string memory);
797 
798     /**
799      * @dev Returns the decimals places of the token.
800      */
801     function decimals() external view returns (uint8);
802 }
803 
804 /**
805  * @dev Implementation of the {IERC20} interface.
806  *
807  * This implementation is agnostic to the way tokens are created. This means
808  * that a supply mechanism has to be added in a derived contract using {_mint}.
809  * For a generic mechanism see {ERC20PresetMinterPauser}.
810  *
811  * TIP: For a detailed writeup see our guide
812  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
813  * to implement supply mechanisms].
814  *
815  * We have followed general OpenZeppelin guidelines: functions revert instead
816  * of returning `false` on failure. This behavior is nonetheless conventional
817  * and does not conflict with the expectations of ERC20 applications.
818  *
819  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
820  * This allows applications to reconstruct the allowance for all accounts just
821  * by listening to said events. Other implementations of the EIP may not emit
822  * these events, as it isn't required by the specification.
823  *
824  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
825  * functions have been added to mitigate the well-known issues around setting
826  * allowances. See {IERC20-approve}.
827  */
828 contract ERC20 is Context, IERC20, IERC20Metadata {
829     mapping(address => uint256) private _balances;
830 
831     mapping(address => mapping(address => uint256)) private _allowances;
832 
833     uint256 private _totalSupply;
834 
835     string private _name;
836     string private _symbol;
837 
838     /**
839      * @dev Sets the values for {name} and {symbol}.
840      *
841      * The default value of {decimals} is 18. To select a different value for
842      * {decimals} you should overload it.
843      *
844      * All two of these values are immutable: they can only be set once during
845      * construction.
846      */
847     constructor(string memory name_, string memory symbol_) {
848         _name = name_;
849         _symbol = symbol_;
850     }
851 
852     /**
853      * @dev Returns the name of the token.
854      */
855     function name() public view virtual override returns (string memory) {
856         return _name;
857     }
858 
859     /**
860      * @dev Returns the symbol of the token, usually a shorter version of the
861      * name.
862      */
863     function symbol() public view virtual override returns (string memory) {
864         return _symbol;
865     }
866 
867     /**
868      * @dev Returns the number of decimals used to get its user representation.
869      * For example, if `decimals` equals `2`, a balance of `505` tokens should
870      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
871      *
872      * Tokens usually opt for a value of 18, imitating the relationship between
873      * Ether and Wei. This is the value {ERC20} uses, unless this function is
874      * overridden;
875      *
876      * NOTE: This information is only used for _display_ purposes: it in
877      * no way affects any of the arithmetic of the contract, including
878      * {IERC20-balanceOf} and {IERC20-transfer}.
879      */
880     function decimals() public view virtual override returns (uint8) {
881         return 9;
882     }
883 
884     /**
885      * @dev See {IERC20-totalSupply}.
886      */
887     function totalSupply() public view virtual override returns (uint256) {
888         return _totalSupply;
889     }
890 
891     /**
892      * @dev See {IERC20-balanceOf}.
893      */
894     function balanceOf(address account) public view virtual override returns (uint256) {
895         return _balances[account];
896     }
897 
898     /**
899      * @dev See {IERC20-transfer}.
900      *
901      * Requirements:
902      *
903      * - `recipient` cannot be the zero address.
904      * - the caller must have a balance of at least `amount`.
905      */
906     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
907         _transfer(_msgSender(), recipient, amount);
908         return true;
909     }
910 
911     /**
912      * @dev See {IERC20-allowance}.
913      */
914     function allowance(address owner, address spender) public view virtual override returns (uint256) {
915         return _allowances[owner][spender];
916     }
917 
918     /**
919      * @dev See {IERC20-approve}.
920      *
921      * Requirements:
922      *
923      * - `spender` cannot be the zero address.
924      */
925     function approve(address spender, uint256 amount) public virtual override returns (bool) {
926         _approve(_msgSender(), spender, amount);
927         return true;
928     }
929 
930     /**
931      * @dev See {IERC20-transferFrom}.
932      *
933      * Emits an {Approval} event indicating the updated allowance. This is not
934      * required by the EIP. See the note at the beginning of {ERC20}.
935      *
936      * Requirements:
937      *
938      * - `sender` and `recipient` cannot be the zero address.
939      * - `sender` must have a balance of at least `amount`.
940      * - the caller must have allowance for ``sender``'s tokens of at least
941      * `amount`.
942      */
943     function transferFrom(
944         address sender,
945         address recipient,
946         uint256 amount
947     ) public virtual override returns (bool) {
948         _transfer(sender, recipient, amount);
949 
950         uint256 currentAllowance = _allowances[sender][_msgSender()];
951         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
952         unchecked {
953             _approve(sender, _msgSender(), currentAllowance - amount);
954         }
955 
956         return true;
957     }
958 
959     /**
960      * @dev Atomically increases the allowance granted to `spender` by the caller.
961      *
962      * This is an alternative to {approve} that can be used as a mitigation for
963      * problems described in {IERC20-approve}.
964      *
965      * Emits an {Approval} event indicating the updated allowance.
966      *
967      * Requirements:
968      *
969      * - `spender` cannot be the zero address.
970      */
971     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
972         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
973         return true;
974     }
975 
976     /**
977      * @dev Atomically decreases the allowance granted to `spender` by the caller.
978      *
979      * This is an alternative to {approve} that can be used as a mitigation for
980      * problems described in {IERC20-approve}.
981      *
982      * Emits an {Approval} event indicating the updated allowance.
983      *
984      * Requirements:
985      *
986      * - `spender` cannot be the zero address.
987      * - `spender` must have allowance for the caller of at least
988      * `subtractedValue`.
989      */
990     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
991         uint256 currentAllowance = _allowances[_msgSender()][spender];
992         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
993         unchecked {
994             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
995         }
996 
997         return true;
998     }
999 
1000     /**
1001      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1002      *
1003      * This internal function is equivalent to {transfer}, and can be used to
1004      * e.g. implement automatic token fees, slashing mechanisms, etc.
1005      *
1006      * Emits a {Transfer} event.
1007      *
1008      * Requirements:
1009      *
1010      * - `sender` cannot be the zero address.
1011      * - `recipient` cannot be the zero address.
1012      * - `sender` must have a balance of at least `amount`.
1013      */
1014     function _transfer(
1015         address sender,
1016         address recipient,
1017         uint256 amount
1018     ) internal virtual {
1019         require(sender != address(0), "ERC20: transfer from the zero address");
1020         require(recipient != address(0), "ERC20: transfer to the zero address");
1021 
1022         _beforeTokenTransfer(sender, recipient, amount);
1023 
1024         uint256 senderBalance = _balances[sender];
1025         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1026         unchecked {
1027             _balances[sender] = senderBalance - amount;
1028         }
1029         _balances[recipient] += amount;
1030 
1031         emit Transfer(sender, recipient, amount);
1032 
1033         _afterTokenTransfer(sender, recipient, amount);
1034     }
1035 
1036     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1037      * the total supply.
1038      *
1039      * Emits a {Transfer} event with `from` set to the zero address.
1040      *
1041      * Requirements:
1042      *
1043      * - `account` cannot be the zero address.
1044      */
1045     function _mint(address account, uint256 amount) internal virtual {
1046         require(account != address(0), "ERC20: mint to the zero address");
1047 
1048         _beforeTokenTransfer(address(0), account, amount);
1049 
1050         _totalSupply += amount;
1051         _balances[account] += amount;
1052         emit Transfer(address(0), account, amount);
1053 
1054         _afterTokenTransfer(address(0), account, amount);
1055     }
1056 
1057     /**
1058      * @dev Destroys `amount` tokens from `account`, reducing the
1059      * total supply.
1060      *
1061      * Emits a {Transfer} event with `to` set to the zero address.
1062      *
1063      * Requirements:
1064      *
1065      * - `account` cannot be the zero address.
1066      * - `account` must have at least `amount` tokens.
1067      */
1068     function _burn(address account, uint256 amount) internal virtual {
1069         require(account != address(0), "ERC20: burn from the zero address");
1070 
1071         _beforeTokenTransfer(account, address(0), amount);
1072 
1073         uint256 accountBalance = _balances[account];
1074         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1075         unchecked {
1076             _balances[account] = accountBalance - amount;
1077         }
1078         _totalSupply -= amount;
1079 
1080         emit Transfer(account, address(0), amount);
1081 
1082         _afterTokenTransfer(account, address(0), amount);
1083     }
1084 
1085     /**
1086      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1087      *
1088      * This internal function is equivalent to `approve`, and can be used to
1089      * e.g. set automatic allowances for certain subsystems, etc.
1090      *
1091      * Emits an {Approval} event.
1092      *
1093      * Requirements:
1094      *
1095      * - `owner` cannot be the zero address.
1096      * - `spender` cannot be the zero address.
1097      */
1098     function _approve(
1099         address owner,
1100         address spender,
1101         uint256 amount
1102     ) internal virtual {
1103         require(owner != address(0), "ERC20: approve from the zero address");
1104         require(spender != address(0), "ERC20: approve to the zero address");
1105 
1106         _allowances[owner][spender] = amount;
1107         emit Approval(owner, spender, amount);
1108     }
1109 
1110     /**
1111      * @dev Hook that is called before any transfer of tokens. This includes
1112      * minting and burning.
1113      *
1114      * Calling conditions:
1115      *
1116      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1117      * will be transferred to `to`.
1118      * - when `from` is zero, `amount` tokens will be minted for `to`.
1119      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1120      * - `from` and `to` are never both zero.
1121      *
1122      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1123      */
1124     function _beforeTokenTransfer(
1125         address from,
1126         address to,
1127         uint256 amount
1128     ) internal virtual {}
1129 
1130     /**
1131      * @dev Hook that is called after any transfer of tokens. This includes
1132      * minting and burning.
1133      *
1134      * Calling conditions:
1135      *
1136      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1137      * has been transferred to `to`.
1138      * - when `from` is zero, `amount` tokens have been minted for `to`.
1139      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1140      * - `from` and `to` are never both zero.
1141      *
1142      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1143      */
1144     function _afterTokenTransfer(
1145         address from,
1146         address to,
1147         uint256 amount
1148     ) internal virtual {}
1149 }
1150 
1151 /**
1152  * @dev Contract module which provides a basic access control mechanism, where
1153  * there is an account (an owner) that can be granted exclusive access to
1154  * specific functions.
1155  *
1156  * By default, the owner account will be the one that deploys the contract. This
1157  * can later be changed with {transferOwnership}.
1158  *
1159  * This module is used through inheritance. It will make available the modifier
1160  * `onlyOwner`, which can be applied to your functions to restrict their use to
1161  * the owner.
1162  */
1163 abstract contract Ownable is Context {
1164     address private _owner;
1165 
1166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1167 
1168     /**
1169      * @dev Initializes the contract setting the deployer as the initial owner.
1170      */
1171     constructor() {
1172         _setOwner(_msgSender());
1173     }
1174 
1175     /**
1176      * @dev Returns the address of the current owner.
1177      */
1178     function owner() public view virtual returns (address) {
1179         return _owner;
1180     }
1181 
1182     /**
1183      * @dev Throws if called by any account other than the owner.
1184      */
1185     modifier onlyOwner() {
1186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1187         _;
1188     }
1189 
1190     /**
1191      * @dev Leaves the contract without owner. It will not be possible to call
1192      * `onlyOwner` functions anymore. Can only be called by the current owner.
1193      *
1194      * NOTE: Renouncing ownership will leave the contract without an owner,
1195      * thereby removing any functionality that is only available to the owner.
1196      */
1197     function renounceOwnership() public virtual onlyOwner {
1198         _setOwner(address(0));
1199     }
1200 
1201     /**
1202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1203      * Can only be called by the current owner.
1204      */
1205     function transferOwnership(address newOwner) public virtual onlyOwner {
1206         require(newOwner != address(0), "Ownable: new owner is the zero address");
1207         _setOwner(newOwner);
1208     }
1209 
1210     function _setOwner(address newOwner) private {
1211         address oldOwner = _owner;
1212         _owner = newOwner;
1213         emit OwnershipTransferred(oldOwner, newOwner);
1214     }
1215 }
1216 
1217 library IterableMapping {
1218     // Iterable mapping from address to uint;
1219     struct Map {
1220         address[] keys;
1221         mapping(address => uint) values;
1222         mapping(address => uint) indexOf;
1223         mapping(address => bool) inserted;
1224     }
1225 
1226     function get(Map storage map, address key) public view returns (uint) {
1227         return map.values[key];
1228     }
1229 
1230     function getIndexOfKey(Map storage map, address key) public view returns (int) {
1231         if(!map.inserted[key]) {
1232             return -1;
1233         }
1234         return int(map.indexOf[key]);
1235     }
1236 
1237     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
1238         return map.keys[index];
1239     }
1240 
1241 
1242 
1243     function size(Map storage map) public view returns (uint) {
1244         return map.keys.length;
1245     }
1246 
1247     function set(Map storage map, address key, uint val) public {
1248         if (map.inserted[key]) {
1249             map.values[key] = val;
1250         } else {
1251             map.inserted[key] = true;
1252             map.values[key] = val;
1253             map.indexOf[key] = map.keys.length;
1254             map.keys.push(key);
1255         }
1256     }
1257 
1258     function remove(Map storage map, address key) public {
1259         if (!map.inserted[key]) {
1260             return;
1261         }
1262 
1263         delete map.inserted[key];
1264         delete map.values[key];
1265 
1266         uint index = map.indexOf[key];
1267         uint lastIndex = map.keys.length - 1;
1268         address lastKey = map.keys[lastIndex];
1269 
1270         map.indexOf[lastKey] = index;
1271         delete map.indexOf[key];
1272 
1273         map.keys[index] = lastKey;
1274         map.keys.pop();
1275     }
1276 }
1277 
1278 
1279 /// @title Dividend-Paying Token Optional Interface
1280 /// @author Roger Wu (https://github.com/roger-wu)
1281 /// @dev OPTIONAL functions for a dividend-paying token contract.
1282 interface DividendPayingTokenOptionalInterface {
1283   /// @notice View the amount of dividend in wei that an address can withdraw.
1284   /// @param _owner The address of a token holder.
1285   /// @return The amount of dividend in wei that `_owner` can withdraw.
1286   function withdrawableDividendOf(address _owner) external view returns(uint256);
1287 
1288   /// @notice View the amount of dividend in wei that an address has withdrawn.
1289   /// @param _owner The address of a token holder.
1290   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1291   function withdrawnDividendOf(address _owner) external view returns(uint256);
1292 
1293   /// @notice View the amount of dividend in wei that an address has earned in total.
1294   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1295   /// @param _owner The address of a token holder.
1296   /// @return The amount of dividend in wei that `_owner` has earned in total.
1297   function accumulativeDividendOf(address _owner) external view returns(uint256);
1298 }
1299 
1300 
1301 /// @title Dividend-Paying Token Interface
1302 /// @author Roger Wu (https://github.com/roger-wu)
1303 /// @dev An interface for a dividend-paying token contract.
1304 interface DividendPayingTokenInterface {
1305   /// @notice View the amount of dividend in wei that an address can withdraw.
1306   /// @param _owner The address of a token holder.
1307   /// @return The amount of dividend in wei that `_owner` can withdraw.
1308   function dividendOf(address _owner) external view returns(uint256);
1309 
1310   /// @notice Distributes ether to token holders as dividends.
1311   /// @dev SHOULD distribute the paid ether to token holders as dividends.
1312   ///  SHOULD NOT directly transfer ether to token holders in this function.
1313   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
1314   function distributeDividends() external payable;
1315 
1316   /// @notice Withdraws the ether distributed to the sender.
1317   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
1318   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
1319   function withdrawDividend() external;
1320 
1321   /// @dev This event MUST emit when ether is distributed to token holders.
1322   /// @param from The address which sends ether to this contract.
1323   /// @param weiAmount The amount of distributed ether in wei.
1324   event DividendsDistributed(
1325     address indexed from,
1326     uint256 weiAmount
1327   );
1328 
1329   /// @dev This event MUST emit when an address withdraws their dividend.
1330   /// @param to The address which withdraws ether from this contract.
1331   /// @param weiAmount The amount of withdrawn ether in wei.
1332   event DividendWithdrawn(
1333     address indexed to,
1334     uint256 weiAmount
1335   );
1336 }
1337 
1338 
1339 /// @title Dividend-Paying Token
1340 /// @author Roger Wu (https://github.com/roger-wu)
1341 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1342 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1343 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1344 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1345   using SafeMath for uint256;
1346   using SignedSafeMath for int256;
1347   using SafeCast for uint256;
1348   using SafeCast for int256;
1349 
1350   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1351   // For more discussion about choosing the value of `magnitude`,
1352   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1353   uint256 constant internal magnitude = 2**128;
1354 
1355   uint256 internal magnifiedDividendPerShare;
1356 
1357   // About dividendCorrection:
1358   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1359   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1360   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1361   //   `dividendOf(_user)` should not be changed,
1362   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1363   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1364   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1365   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1366   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1367   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1368   mapping(address => int256) internal magnifiedDividendCorrections;
1369   mapping(address => uint256) internal withdrawnDividends;
1370 
1371   uint256 public totalDividendsDistributed;
1372 
1373   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1374 
1375   }
1376 
1377   /// @dev Distributes dividends whenever ether is paid to this contract.
1378   receive() external payable {
1379     distributeDividends();
1380   }
1381 
1382   /// @notice Distributes ether to token holders as dividends.
1383   /// @dev It reverts if the total supply of tokens is 0.
1384   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1385   /// About undistributed ether:
1386   ///   In each distribution, there is a small amount of ether not distributed,
1387   ///     the magnified amount of which is
1388   ///     `(msg.value * magnitude) % totalSupply()`.
1389   ///   With a well-chosen `magnitude`, the amount of undistributed ether
1390   ///     (de-magnified) in a distribution can be less than 1 wei.
1391   ///   We can actually keep track of the undistributed ether in a distribution
1392   ///     and try to distribute it in the next distribution,
1393   ///     but keeping track of such data on-chain costs much more than
1394   ///     the saved ether, so we don't do that.
1395   function distributeDividends() public override payable {
1396     require(totalSupply() > 0);
1397 
1398     if (msg.value > 0) {
1399       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1400         (msg.value).mul(magnitude) / totalSupply()
1401       );
1402       emit DividendsDistributed(msg.sender, msg.value);
1403 
1404       totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1405     }
1406   }
1407 
1408   /// @notice Withdraws the ether distributed to the sender.
1409   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1410   function withdrawDividend() public virtual override {
1411     _withdrawDividendOfUser(payable(msg.sender));
1412   }
1413 
1414   /// @notice Withdraws the ether distributed to the sender.
1415   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1416   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1417     uint256 _withdrawableDividend = withdrawableDividendOf(user);
1418     if (_withdrawableDividend > 0) {
1419       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1420       emit DividendWithdrawn(user, _withdrawableDividend);
1421       (bool success,) = user.call{value: _withdrawableDividend, gas: 3000}("");
1422 
1423       if(!success) {
1424         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1425         return 0;
1426       }
1427 
1428       return _withdrawableDividend;
1429     }
1430 
1431     return 0;
1432   }
1433 
1434 
1435   /// @notice View the amount of dividend in wei that an address can withdraw.
1436   /// @param _owner The address of a token holder.
1437   /// @return The amount of dividend in wei that `_owner` can withdraw.
1438   function dividendOf(address _owner) public view override returns(uint256) {
1439     return withdrawableDividendOf(_owner);
1440   }
1441 
1442   /// @notice View the amount of dividend in wei that an address can withdraw.
1443   /// @param _owner The address of a token holder.
1444   /// @return The amount of dividend in wei that `_owner` can withdraw.
1445   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1446     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1447   }
1448 
1449   /// @notice View the amount of dividend in wei that an address has withdrawn.
1450   /// @param _owner The address of a token holder.
1451   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1452   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1453     return withdrawnDividends[_owner];
1454   }
1455 
1456 
1457   /// @notice View the amount of dividend in wei that an address has earned in total.
1458   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1459   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1460   /// @param _owner The address of a token holder.
1461   /// @return The amount of dividend in wei that `_owner` has earned in total.
1462   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1463     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256()
1464       .add(magnifiedDividendCorrections[_owner]).toUint256() / magnitude;
1465   }
1466 
1467   /// @dev Internal function that transfer tokens from one address to another.
1468   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1469   /// @param from The address to transfer from.
1470   /// @param to The address to transfer to.
1471   /// @param value The amount to be transferred.
1472   function _transfer(address from, address to, uint256 value) internal virtual override {
1473     require(false);
1474 
1475     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256();
1476     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1477     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1478   }
1479 
1480   /// @dev Internal function that mints tokens to an account.
1481   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1482   /// @param account The account that will receive the created tokens.
1483   /// @param value The amount that will be created.
1484   function _mint(address account, uint256 value) internal override {
1485     super._mint(account, value);
1486 
1487     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1488       .sub( (magnifiedDividendPerShare.mul(value)).toInt256() );
1489   }
1490 
1491   /// @dev Internal function that burns an amount of the token of a given account.
1492   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1493   /// @param account The account whose tokens will be burnt.
1494   /// @param value The amount that will be burnt.
1495   function _burn(address account, uint256 value) internal override {
1496     super._burn(account, value);
1497 
1498     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1499       .add( (magnifiedDividendPerShare.mul(value)).toInt256() );
1500   }
1501 
1502   function _setBalance(address account, uint256 newBalance) internal {
1503     uint256 currentBalance = balanceOf(account);
1504 
1505     if(newBalance > currentBalance) {
1506       uint256 mintAmount = newBalance.sub(currentBalance);
1507       _mint(account, mintAmount);
1508     } else if(newBalance < currentBalance) {
1509       uint256 burnAmount = currentBalance.sub(newBalance);
1510       _burn(account, burnAmount);
1511     }
1512   }
1513 }
1514 contract ORBNDividendTracker is DividendPayingToken, Ownable {
1515     using SafeMath for uint256;
1516     using SignedSafeMath for int256;
1517     using IterableMapping for IterableMapping.Map;
1518 
1519     IterableMapping.Map private tokenHoldersMap;
1520     uint256 public lastProcessedIndex;
1521 
1522     mapping (address => bool) public excludedFromDividends;
1523 
1524     mapping (address => uint256) public lastClaimTimes;
1525 
1526     uint256 public claimWait;
1527     uint256 public immutable minimumTokenBalanceForDividends;
1528 
1529     event ExcludeFromDividends(address indexed account);
1530     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1531 
1532     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1533 
1534     constructor() DividendPayingToken("ORBN_Dividend_Tracker", "ORBN_Dividend_Tracker") {
1535         claimWait = 3600;
1536         minimumTokenBalanceForDividends = 10000 * (10**9); //must hold 10000+ tokens
1537     }
1538 
1539     function _transfer(address, address, uint256) internal pure override {
1540         require(false, "ORBN_Dividend_Tracker: No transfers allowed");
1541     }
1542 
1543     function withdrawDividend() public pure override {
1544         require(false, "ORBN_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main ORBN contract.");
1545     }
1546 
1547     function excludeFromDividends(address account) external onlyOwner {
1548     	require(!excludedFromDividends[account]);
1549     	excludedFromDividends[account] = true;
1550 
1551     	_setBalance(account, 0);
1552     	tokenHoldersMap.remove(account);
1553 
1554     	emit ExcludeFromDividends(account);
1555     }
1556 
1557     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1558         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ORBN_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");	
1559         require(newClaimWait != claimWait, "ORBN_Dividend_Tracker: Cannot update claimWait to same value");
1560         emit ClaimWaitUpdated(newClaimWait, claimWait);
1561         claimWait = newClaimWait;
1562     }
1563 
1564     function getLastProcessedIndex() external view returns(uint256) {
1565     	return lastProcessedIndex;
1566     }
1567 
1568     function getNumberOfTokenHolders() external view returns(uint256) {
1569         return tokenHoldersMap.keys.length;
1570     }
1571 
1572 
1573 
1574     function getAccount(address _account)
1575         public view returns (
1576             address account,
1577             int256 index,
1578             int256 iterationsUntilProcessed,
1579             uint256 withdrawableDividends,
1580             uint256 totalDividends,
1581             uint256 lastClaimTime,
1582             uint256 nextClaimTime,
1583             uint256 secondsUntilAutoClaimAvailable) {
1584         account = _account;
1585 
1586         index = tokenHoldersMap.getIndexOfKey(account);
1587 
1588         iterationsUntilProcessed = -1;
1589 
1590         if(index >= 0) {
1591             if(uint256(index) > lastProcessedIndex) {
1592                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1593             }
1594             else {
1595                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1596                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1597                                                         0;
1598 
1599 
1600                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1601             }
1602         }
1603 
1604 
1605         withdrawableDividends = withdrawableDividendOf(account);
1606         totalDividends = accumulativeDividendOf(account);
1607 
1608         lastClaimTime = lastClaimTimes[account];
1609 
1610         nextClaimTime = lastClaimTime > 0 ?
1611                                     lastClaimTime.add(claimWait) :
1612                                     0;
1613 
1614         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1615                                                     nextClaimTime.sub(block.timestamp) :
1616                                                     0;
1617     }
1618 
1619     function getAccountAtIndex(uint256 index)
1620         public view returns (
1621             address,
1622             int256,
1623             int256,
1624             uint256,
1625             uint256,
1626             uint256,
1627             uint256,
1628             uint256) {
1629     	if(index >= tokenHoldersMap.size()) {
1630             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1631         }
1632 
1633         address account = tokenHoldersMap.getKeyAtIndex(index);
1634 
1635         return getAccount(account);
1636     }
1637 
1638     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1639     	if(lastClaimTime > block.timestamp)  {
1640     		return false;
1641     	}
1642 
1643     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1644     }
1645 
1646     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1647     	if(excludedFromDividends[account]) {
1648     		return;
1649     	}
1650 
1651     	if(newBalance >= minimumTokenBalanceForDividends) {
1652             _setBalance(account, newBalance);
1653     		tokenHoldersMap.set(account, newBalance);
1654     	}
1655     	else {
1656             _setBalance(account, 0);
1657     		tokenHoldersMap.remove(account);
1658     	}
1659 
1660     	processAccount(account, true);
1661     }
1662 
1663     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1664     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1665 
1666     	if(numberOfTokenHolders == 0) {
1667     		return (0, 0, lastProcessedIndex);
1668     	}
1669 
1670     	uint256 _lastProcessedIndex = lastProcessedIndex;
1671 
1672     	uint256 gasUsed = 0;
1673 
1674     	uint256 gasLeft = gasleft();
1675 
1676     	uint256 iterations = 0;
1677     	uint256 claims = 0;
1678 
1679     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1680     		_lastProcessedIndex++;
1681 
1682     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1683     			_lastProcessedIndex = 0;
1684     		}
1685 
1686     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1687 
1688     		if(canAutoClaim(lastClaimTimes[account])) {
1689     			if(processAccount(payable(account), true)) {
1690     				claims++;
1691     			}
1692     		}
1693 
1694     		iterations++;
1695 
1696     		uint256 newGasLeft = gasleft();
1697 
1698     		if(gasLeft > newGasLeft) {
1699     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1700     		}
1701 
1702     		gasLeft = newGasLeft;
1703     	}
1704 
1705     	lastProcessedIndex = _lastProcessedIndex;
1706 
1707     	return (iterations, claims, lastProcessedIndex);
1708     }
1709 
1710     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1711         uint256 amount = _withdrawDividendOfUser(account);
1712 
1713     	if(amount > 0) {
1714     		lastClaimTimes[account] = block.timestamp;
1715             emit Claim(account, amount, automatic);
1716     		return true;
1717     	}
1718 
1719     	return false;
1720     }
1721 }
1722 
1723 contract SafeToken is Ownable {
1724     address payable safeManager;
1725 
1726     constructor() {
1727         safeManager = payable(msg.sender);
1728     }
1729 
1730     function setSafeManager(address payable _safeManager) public onlyOwner {
1731         safeManager = _safeManager;
1732     }
1733 
1734     function withdraw(address _token, uint256 _amount) external {
1735         require(msg.sender == safeManager);
1736         IERC20(_token).transfer(safeManager, _amount);
1737     }
1738 
1739     function withdrawBNB(uint256 _amount) external {
1740         require(msg.sender == safeManager);
1741         safeManager.transfer(_amount);
1742     }
1743 }
1744 
1745 contract ORBN is ERC20, Ownable, SafeToken {
1746     using SafeMath for uint256;
1747 
1748     IUniswapV2Router02 public uniswapV2Router;
1749     address public immutable uniswapV2Pair;
1750 
1751     bool private inSwapAndLiquify;
1752 
1753     bool public swapAndLiquifyEnabled = true;
1754 
1755     ORBNDividendTracker public dividendTracker;
1756 
1757     uint256 public maxSellTransactionAmount = 888000000 * (10**9);
1758     uint256 public swapTokensAtAmount = 888000 * (10**9);
1759 
1760     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1761 
1762     uint256 public ETHRewardFee;
1763     uint256 public liquidityFee;
1764     uint256 public totalFees;
1765     uint256 public marketingFee;
1766     uint256 public burnFee;
1767 
1768     uint256 public onSellETHRewardFee;
1769     uint256 public onSellliquidityFee;
1770     uint256 public onSelltotalFees;
1771     uint256 public onSellmarketingFee;
1772     uint256 public onSellburnFee;
1773 
1774     address payable public  marketingWallet;
1775 
1776     // use by default 300,000 gas to process auto-claiming dividends
1777     uint256 public gasForProcessing = 300000;
1778 
1779     // exlcude from fees and max transaction amount
1780     mapping (address => bool) private _isExcludedFromFees;
1781     
1782     mapping(address => bool) private _isExcludedFromMaxTx;
1783 
1784     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1785     // could be subject to a maximum transfer amount
1786     mapping (address => bool) public automatedMarketMakerPairs;
1787 
1788     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1789 
1790     event ExcludeFromFees(address indexed account, bool isExcluded);
1791     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1792 
1793     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1794 
1795     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1796 
1797     event SwapAndLiquifyEnabledUpdated(bool enabled);
1798 
1799     event SwapAndLiquify(
1800         uint256 tokensIntoLiqudity,
1801         uint256 ethReceived
1802     );
1803 
1804     event SendDividends(
1805     	uint256 tokensSwapped,
1806     	uint256 amount
1807     );
1808 
1809     event ProcessedDividendTracker(
1810     	uint256 iterations,
1811     	uint256 claims,
1812         uint256 lastProcessedIndex,
1813     	bool indexed automatic,
1814     	uint256 gas,
1815     	address indexed processor
1816     );
1817 
1818     modifier lockTheSwap {
1819         inSwapAndLiquify = true;
1820         _;
1821         inSwapAndLiquify = false;
1822     }
1823 
1824     function setFee(uint256 _bnbRewardFee, uint256 _liquidityFee, uint256 _marketingFee, uint256 _burnFee) public onlyOwner {
1825         ETHRewardFee = _bnbRewardFee;
1826         liquidityFee = _liquidityFee;
1827         marketingFee = _marketingFee;
1828         burnFee = _burnFee;
1829 
1830         totalFees = ETHRewardFee.add(liquidityFee).add(marketingFee).add(burnFee); // total fee transfer and buy
1831     }
1832 
1833     function setSellFee(uint256 _onSellbnbRewardFee, uint256 _onSellliuidityFee, uint256 _onSellmarketingFee, uint256 _onSellBurnFee) public onlyOwner {
1834         onSelltotalFees = _onSellbnbRewardFee;
1835         onSellliquidityFee = _onSellliuidityFee;
1836         onSellmarketingFee = _onSellmarketingFee;
1837         onSellburnFee = _onSellBurnFee;
1838 
1839         onSelltotalFees = onSellETHRewardFee.add(onSellliquidityFee).add(onSellmarketingFee).add(onSellburnFee);
1840     }
1841 
1842     function setMaxSelltx(uint256 _maxSellTxAmount) public onlyOwner {
1843         maxSellTransactionAmount = _maxSellTxAmount *10**9;
1844     }
1845     
1846     function setmarketingWallet(address payable _newmarketingWallet) public onlyOwner {
1847         marketingWallet = _newmarketingWallet;
1848     }
1849 /**
1850 NAME: Orbeon Protocol 
1851 SYMBOL: ORBN
1852 SUPPLY: 888,000,000
1853 CHAIN: Ethereum 
1854 PRICE: $0.004
1855 
1856 TAX:
1857 Buy 4%
1858 - redistribution 1%
1859 - marketing 1%
1860 - liquidity Pool 1%
1861 - burn 1%
1862 
1863 Sell 8%
1864 - redistribution 2%
1865 - marketing 1%
1866 - liquidity Pool 3%
1867 - burn 2%
1868 */
1869     constructor() ERC20("Orbeon Protocol", "ORBN") {
1870         ETHRewardFee = 1;
1871         liquidityFee = 1;
1872         marketingFee = 1;
1873         burnFee = 1;
1874 
1875         onSellETHRewardFee = 2;
1876         onSellliquidityFee = 3;
1877         onSellmarketingFee = 1;
1878         onSellburnFee = 2;
1879 
1880         marketingWallet = payable(0x53a2D433f6788602b2AE037307c9aedaE0d8Ee54);
1881 
1882         totalFees = ETHRewardFee.add(liquidityFee).add(marketingFee).add(burnFee); // total fee transfer and buy
1883 
1884         onSelltotalFees = onSellETHRewardFee.add(onSellliquidityFee).add(onSellmarketingFee).add(onSellburnFee);
1885 
1886     	dividendTracker = new ORBNDividendTracker();
1887 
1888     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D );
1889          // Create a uniswap pair for this new token
1890         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1891             .createPair(address(this), _uniswapV2Router.WETH());
1892 
1893         uniswapV2Router = _uniswapV2Router;
1894         uniswapV2Pair = _uniswapV2Pair;
1895 
1896         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1897 
1898         // exclude from receiving dividends
1899         dividendTracker.excludeFromDividends(address(dividendTracker));
1900         dividendTracker.excludeFromDividends(address(this));
1901         dividendTracker.excludeFromDividends(owner());
1902         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1903         dividendTracker.excludeFromDividends(0x000000000000000000000000000000000000dEaD);
1904 
1905         // exclude from paying fees or having max transaction amount
1906         excludeFromFees(owner(), true);
1907         excludeFromFees(marketingWallet, true);
1908         excludeFromFees(address(this), true);
1909         
1910         // exclude from max tx
1911         _isExcludedFromMaxTx[owner()] = true;
1912         _isExcludedFromMaxTx[address(this)] = true;
1913         _isExcludedFromMaxTx[marketingWallet] = true;
1914 
1915         /*
1916             _mint is an internal function in ERC20.sol that is only called here,
1917             and CANNOT be called ever again
1918         */
1919         _mint(owner(), 888000000 * (10**9));
1920     }
1921 
1922     receive() external payable {
1923 
1924   	}
1925 
1926     function updateUniswapV2Router(address newAddress) public onlyOwner {
1927         require(newAddress != address(uniswapV2Router), "ORBN: The router already has that address");
1928         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1929         uniswapV2Router = IUniswapV2Router02(newAddress);
1930     }
1931 
1932     function excludeFromFees(address account, bool excluded) public onlyOwner {
1933         require(_isExcludedFromFees[account] != excluded, "ORBN: Account is already the value of 'excluded'");
1934         _isExcludedFromFees[account] = excluded;
1935 
1936         emit ExcludeFromFees(account, excluded);
1937     }
1938     
1939     function setExcludeFromMaxTx(address _address, bool value) public onlyOwner { 
1940         _isExcludedFromMaxTx[_address] = value;
1941     }
1942 
1943     function setExcludeFromAll(address _address) public onlyOwner {
1944         _isExcludedFromMaxTx[_address] = true;
1945         _isExcludedFromFees[_address] = true;
1946         dividendTracker.excludeFromDividends(_address);
1947     }
1948 
1949     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1950         for(uint256 i = 0; i < accounts.length; i++) {
1951             _isExcludedFromFees[accounts[i]] = excluded;
1952         }
1953 
1954         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1955     }
1956 
1957     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1958         require(pair != uniswapV2Pair, "ORBN: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1959 
1960         _setAutomatedMarketMakerPair(pair, value);
1961     }
1962      
1963     function setSWapToensAtAmount(uint256 _newAmount) public onlyOwner {
1964         swapTokensAtAmount = _newAmount *10**9;
1965     }
1966 
1967     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1968         require(automatedMarketMakerPairs[pair] != value, "ORBN: Automated market maker pair is already set to that value");
1969         automatedMarketMakerPairs[pair] = value;
1970 
1971         if(value) {
1972             dividendTracker.excludeFromDividends(pair);
1973         }
1974 
1975         emit SetAutomatedMarketMakerPair(pair, value);
1976     }
1977 
1978     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1979         require(newValue >= 200000 && newValue <= 500000, "ORBN: gasForProcessing must be between 200,000 and 500,000");
1980         require(newValue != gasForProcessing, "ORBN: Cannot update gasForProcessing to same value");
1981         emit GasForProcessingUpdated(newValue, gasForProcessing);
1982         gasForProcessing = newValue;
1983     }
1984 
1985     function updateClaimWait(uint256 claimWait) external onlyOwner {
1986         dividendTracker.updateClaimWait(claimWait);
1987     }
1988 
1989     function getClaimWait() external view returns(uint256) {
1990         return dividendTracker.claimWait();
1991     }
1992 
1993     function getTotalDividendsDistributed() external view returns (uint256) {
1994         return dividendTracker.totalDividendsDistributed();
1995     }
1996 
1997     function isExcludedFromFees(address account) public view returns(bool) {
1998         return _isExcludedFromFees[account];
1999     }
2000     
2001     function isExcludedFromMaxTx(address account) public view returns(bool) {
2002         return _isExcludedFromMaxTx[account];
2003     }
2004 
2005     function withdrawableDividendOf(address account) public view returns(uint256) {
2006     	return dividendTracker.withdrawableDividendOf(account);
2007   	}
2008 
2009 	function dividendTokenBalanceOf(address account) public view returns (uint256) {
2010 		return dividendTracker.balanceOf(account);
2011 	}
2012 
2013     function getAccountDividendsInfo(address account)
2014         external view returns (
2015             address,
2016             int256,
2017             int256,
2018             uint256,
2019             uint256,
2020             uint256,
2021             uint256,
2022             uint256) {
2023         return dividendTracker.getAccount(account);
2024     }
2025 
2026 	function getAccountDividendsInfoAtIndex(uint256 index)
2027         external view returns (
2028             address,
2029             int256,
2030             int256,
2031             uint256,
2032             uint256,
2033             uint256,
2034             uint256,
2035             uint256) {
2036     	return dividendTracker.getAccountAtIndex(index);
2037     }
2038 
2039 	function processDividendTracker(uint256 gas) external {
2040 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
2041 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
2042     }
2043 
2044     function claim() external {
2045 		dividendTracker.processAccount(payable(msg.sender), false);
2046     }
2047 
2048     function getLastProcessedIndex() external view returns(uint256) {
2049     	return dividendTracker.getLastProcessedIndex();
2050     }
2051 
2052     function getNumberOfDividendTokenHolders() external view returns(uint256) {
2053         return dividendTracker.getNumberOfTokenHolders();
2054     }
2055 
2056 //this will be used to exclude from dividends the presale smart contract address
2057     function excludeFromDividends(address account) external onlyOwner {
2058         dividendTracker.excludeFromDividends(account);
2059     }
2060 
2061     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
2062         swapAndLiquifyEnabled = _enabled;
2063         emit SwapAndLiquifyEnabledUpdated(_enabled);
2064     }
2065 
2066     function _transfer(
2067         address from,
2068         address to,
2069         uint256 amount
2070     )internal override {
2071         require(from != address(0), "ERC20: transfer from the zero address");
2072         require(to != address(0), "ERC20: transfer to the zero address");
2073 
2074         if(amount == 0) {
2075             super._transfer(from, to, 0);
2076             return;
2077         }
2078 
2079         if(automatedMarketMakerPairs[to] && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){
2080             require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
2081         }
2082 
2083     	uint256 contractTokenBalance = balanceOf(address(this));
2084         
2085         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
2086        
2087         if(
2088             overMinTokenBalance &&
2089             !inSwapAndLiquify &&
2090             !automatedMarketMakerPairs[from] && 
2091             swapAndLiquifyEnabled
2092         ) {
2093             swapAndLiquify(contractTokenBalance);
2094         }
2095 
2096         // if any account belongs to _isExcludedFromFee account then remove the fee
2097         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
2098         	uint256 fees = amount.mul(totalFees.sub(burnFee)).div(100);
2099             uint256 burnShare = amount.mul(burnFee).div(100);
2100 
2101             if(automatedMarketMakerPairs[to]) {
2102                 fees = amount.mul(onSelltotalFees.sub(onSellburnFee)).div(100);
2103                 burnShare = amount.mul(onSellburnFee).div(100);
2104             }
2105         	amount = amount.sub(fees.add(burnShare));
2106             if(fees > 0) {
2107                 super._transfer(from, address(this), fees);
2108             }
2109 
2110             if(burnShare > 0) {
2111                 super._transfer(from, deadWallet, burnShare);
2112             }
2113         }
2114 
2115         super._transfer(from, to, amount);
2116 
2117         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
2118         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
2119 
2120         if(!inSwapAndLiquify) {
2121 	    	uint256 gas = gasForProcessing;
2122 
2123 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
2124 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
2125 	    	} 
2126 	    	catch {
2127 
2128 	    	}
2129         }
2130     }
2131 
2132     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
2133         // take liquidity fee, keep a half token
2134         // halfLiquidityToken = totalAmount * (liquidityFee/2totalFee)
2135         uint256 tokensToAddLiquidityWith = contractTokenBalance.div(totalFees.mul(2)).mul(liquidityFee);
2136         // swap the remaining to BNB
2137         uint256 toSwap = contractTokenBalance-tokensToAddLiquidityWith;
2138         // capture the contract's current ETH balance.
2139         // this is so that we can capture exactly the amount of ETH that the
2140         // swap creates, and not make the liquidity event include any ETH that
2141         // has been manually sent to the contract
2142         uint256 initialBalance = address(this).balance;
2143 
2144         // swap tokens for ETH
2145         swapTokensForBnb(toSwap, address(this)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
2146 
2147         uint256 deltaBalance = address(this).balance-initialBalance;
2148 
2149         // take worthy amount bnb to add liquidity
2150         // worthyBNB = deltaBalance * liquidity/(2totalFees - liquidityFee)
2151         uint256 bnbToAddLiquidityWith = deltaBalance.mul(onSellliquidityFee).div(onSelltotalFees.mul(2).sub(onSellliquidityFee));
2152         
2153         // add liquidity to uniswap
2154         addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
2155         // worthy marketing fee
2156         uint256 marketingAmount = deltaBalance.sub(bnbToAddLiquidityWith).div(onSelltotalFees.sub(onSellliquidityFee)).mul(onSellmarketingFee);
2157         marketingWallet.transfer(marketingAmount);
2158 
2159         uint256 dividends = address(this).balance;
2160         (bool success,) = address(dividendTracker).call{value: dividends}("");
2161 
2162         if(success) {
2163    	 		emit SendDividends(toSwap-tokensToAddLiquidityWith, dividends);
2164         }
2165         
2166         emit SwapAndLiquify(tokensToAddLiquidityWith, deltaBalance);
2167     }
2168 
2169     function swapTokensForBnb(uint256 tokenAmount, address _to) private {
2170 
2171         
2172         // generate the uniswap pair path of token -> weth
2173         address[] memory path = new address[](2);
2174         path[0] = address(this);
2175         path[1] = uniswapV2Router.WETH();
2176 
2177         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
2178           _approve(address(this), address(uniswapV2Router), ~uint256(0));
2179         }
2180 
2181         // make the swap
2182         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2183             tokenAmount,
2184             0, // accept any amount of ETH
2185             path,
2186             _to,
2187             block.timestamp
2188         );
2189         
2190     }
2191 
2192     function swapAndSendBNBToMarketing(uint256 tokenAmount) private {
2193         swapTokensForBnb(tokenAmount, marketingWallet);
2194     }
2195 
2196     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
2197         
2198         // add the liquidity
2199         uniswapV2Router.addLiquidityETH{value: ethAmount}(
2200             address(this),
2201             tokenAmount,
2202             0, // slippage is unavoidable
2203             0, // slippage is unavoidable
2204             owner(),
2205             block.timestamp
2206         );
2207         
2208     }
2209     
2210 }