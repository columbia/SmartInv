1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 interface IUniswapV2Router02 is IUniswapV2Router01 {
100     function removeLiquidityETHSupportingFeeOnTransferTokens(
101         address token,
102         uint liquidity,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external returns (uint amountETH);
108     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
109         address token,
110         uint liquidity,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline,
115         bool approveMax, uint8 v, bytes32 r, bytes32 s
116     ) external returns (uint amountETH);
117 
118     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125     function swapExactETHForTokensSupportingFeeOnTransferTokens(
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external payable;
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138 }
139 
140 interface IUniswapV2Factory {
141     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
142 
143     function feeTo() external view returns (address);
144     function feeToSetter() external view returns (address);
145 
146     function getPair(address tokenA, address tokenB) external view returns (address pair);
147     function allPairs(uint) external view returns (address pair);
148     function allPairsLength() external view returns (uint);
149 
150     function createPair(address tokenA, address tokenB) external returns (address pair);
151 
152     function setFeeTo(address) external;
153     function setFeeToSetter(address) external;
154 }
155 
156 /**
157  * @dev Wrappers over Solidity's arithmetic operations.
158  *
159  * NOTE: `SignedSafeMath` is no longer needed starting with Solidity 0.8. The compiler
160  * now has built in overflow checking.
161  */
162 library SignedSafeMath {
163     /**
164      * @dev Returns the multiplication of two signed integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(int256 a, int256 b) internal pure returns (int256) {
174         return a * b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two signed integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator.
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(int256 a, int256 b) internal pure returns (int256) {
188         return a / b;
189     }
190 
191     /**
192      * @dev Returns the subtraction of two signed integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      *
199      * - Subtraction cannot overflow.
200      */
201     function sub(int256 a, int256 b) internal pure returns (int256) {
202         return a - b;
203     }
204 
205     /**
206      * @dev Returns the addition of two signed integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      *
213      * - Addition cannot overflow.
214      */
215     function add(int256 a, int256 b) internal pure returns (int256) {
216         return a + b;
217     }
218 }
219 
220 // CAUTION
221 // This version of SafeMath should only be used with Solidity 0.8 or later,
222 // because it relies on the compiler's built in overflow checks.
223 
224 /**
225  * @dev Wrappers over Solidity's arithmetic operations.
226  *
227  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
228  * now has built in overflow checking.
229  */
230 library SafeMath {
231     /**
232      * @dev Returns the addition of two unsigned integers, with an overflow flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             uint256 c = a + b;
239             if (c < a) return (false, 0);
240             return (true, c);
241         }
242     }
243 
244     /**
245      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
246      *
247      * _Available since v3.4._
248      */
249     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b > a) return (false, 0);
252             return (true, a - b);
253         }
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
258      *
259      * _Available since v3.4._
260      */
261     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
264             // benefit is lost if 'b' is also tested.
265             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
266             if (a == 0) return (true, 0);
267             uint256 c = a * b;
268             if (c / a != b) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     /**
274      * @dev Returns the division of two unsigned integers, with a division by zero flag.
275      *
276      * _Available since v3.4._
277      */
278     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b == 0) return (false, 0);
281             return (true, a / b);
282         }
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
287      *
288      * _Available since v3.4._
289      */
290     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
291         unchecked {
292             if (b == 0) return (false, 0);
293             return (true, a % b);
294         }
295     }
296 
297     /**
298      * @dev Returns the addition of two unsigned integers, reverting on
299      * overflow.
300      *
301      * Counterpart to Solidity's `+` operator.
302      *
303      * Requirements:
304      *
305      * - Addition cannot overflow.
306      */
307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a + b;
309     }
310 
311     /**
312      * @dev Returns the subtraction of two unsigned integers, reverting on
313      * overflow (when the result is negative).
314      *
315      * Counterpart to Solidity's `-` operator.
316      *
317      * Requirements:
318      *
319      * - Subtraction cannot overflow.
320      */
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a - b;
323     }
324 
325     /**
326      * @dev Returns the multiplication of two unsigned integers, reverting on
327      * overflow.
328      *
329      * Counterpart to Solidity's `*` operator.
330      *
331      * Requirements:
332      *
333      * - Multiplication cannot overflow.
334      */
335     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a * b;
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers, reverting on
341      * division by zero. The result is rounded towards zero.
342      *
343      * Counterpart to Solidity's `/` operator.
344      *
345      * Requirements:
346      *
347      * - The divisor cannot be zero.
348      */
349     function div(uint256 a, uint256 b) internal pure returns (uint256) {
350         return a / b;
351     }
352 
353     /**
354      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
355      * reverting when dividing by zero.
356      *
357      * Counterpart to Solidity's `%` operator. This function uses a `revert`
358      * opcode (which leaves remaining gas untouched) while Solidity uses an
359      * invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      *
363      * - The divisor cannot be zero.
364      */
365     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
366         return a % b;
367     }
368 
369     /**
370      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
371      * overflow (when the result is negative).
372      *
373      * CAUTION: This function is deprecated because it requires allocating memory for the error
374      * message unnecessarily. For custom revert reasons use {trySub}.
375      *
376      * Counterpart to Solidity's `-` operator.
377      *
378      * Requirements:
379      *
380      * - Subtraction cannot overflow.
381      */
382     function sub(
383         uint256 a,
384         uint256 b,
385         string memory errorMessage
386     ) internal pure returns (uint256) {
387         unchecked {
388             require(b <= a, errorMessage);
389             return a - b;
390         }
391     }
392 
393     /**
394      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
395      * division by zero. The result is rounded towards zero.
396      *
397      * Counterpart to Solidity's `/` operator. Note: this function uses a
398      * `revert` opcode (which leaves remaining gas untouched) while Solidity
399      * uses an invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      *
403      * - The divisor cannot be zero.
404      */
405     function div(
406         uint256 a,
407         uint256 b,
408         string memory errorMessage
409     ) internal pure returns (uint256) {
410         unchecked {
411             require(b > 0, errorMessage);
412             return a / b;
413         }
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * reverting with custom message when dividing by zero.
419      *
420      * CAUTION: This function is deprecated because it requires allocating memory for the error
421      * message unnecessarily. For custom revert reasons use {tryMod}.
422      *
423      * Counterpart to Solidity's `%` operator. This function uses a `revert`
424      * opcode (which leaves remaining gas untouched) while Solidity uses an
425      * invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function mod(
432         uint256 a,
433         uint256 b,
434         string memory errorMessage
435     ) internal pure returns (uint256) {
436         unchecked {
437             require(b > 0, errorMessage);
438             return a % b;
439         }
440     }
441 }
442 
443 /**
444  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
445  * checks.
446  *
447  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
448  * easily result in undesired exploitation or bugs, since developers usually
449  * assume that overflows raise errors. `SafeCast` restores this intuition by
450  * reverting the transaction when such an operation overflows.
451  *
452  * Using this library instead of the unchecked operations eliminates an entire
453  * class of bugs, so it's recommended to use it always.
454  *
455  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
456  * all math on `uint256` and `int256` and then downcasting.
457  */
458 library SafeCast {
459     /**
460      * @dev Returns the downcasted uint224 from uint256, reverting on
461      * overflow (when the input is greater than largest uint224).
462      *
463      * Counterpart to Solidity's `uint224` operator.
464      *
465      * Requirements:
466      *
467      * - input must fit into 224 bits
468      */
469     function toUint224(uint256 value) internal pure returns (uint224) {
470         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
471         return uint224(value);
472     }
473 
474     /**
475      * @dev Returns the downcasted uint128 from uint256, reverting on
476      * overflow (when the input is greater than largest uint128).
477      *
478      * Counterpart to Solidity's `uint128` operator.
479      *
480      * Requirements:
481      *
482      * - input must fit into 128 bits
483      */
484     function toUint128(uint256 value) internal pure returns (uint128) {
485         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
486         return uint128(value);
487     }
488 
489     /**
490      * @dev Returns the downcasted uint96 from uint256, reverting on
491      * overflow (when the input is greater than largest uint96).
492      *
493      * Counterpart to Solidity's `uint96` operator.
494      *
495      * Requirements:
496      *
497      * - input must fit into 96 bits
498      */
499     function toUint96(uint256 value) internal pure returns (uint96) {
500         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
501         return uint96(value);
502     }
503 
504     /**
505      * @dev Returns the downcasted uint64 from uint256, reverting on
506      * overflow (when the input is greater than largest uint64).
507      *
508      * Counterpart to Solidity's `uint64` operator.
509      *
510      * Requirements:
511      *
512      * - input must fit into 64 bits
513      */
514     function toUint64(uint256 value) internal pure returns (uint64) {
515         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
516         return uint64(value);
517     }
518 
519     /**
520      * @dev Returns the downcasted uint32 from uint256, reverting on
521      * overflow (when the input is greater than largest uint32).
522      *
523      * Counterpart to Solidity's `uint32` operator.
524      *
525      * Requirements:
526      *
527      * - input must fit into 32 bits
528      */
529     function toUint32(uint256 value) internal pure returns (uint32) {
530         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
531         return uint32(value);
532     }
533 
534     /**
535      * @dev Returns the downcasted uint16 from uint256, reverting on
536      * overflow (when the input is greater than largest uint16).
537      *
538      * Counterpart to Solidity's `uint16` operator.
539      *
540      * Requirements:
541      *
542      * - input must fit into 16 bits
543      */
544     function toUint16(uint256 value) internal pure returns (uint16) {
545         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
546         return uint16(value);
547     }
548 
549     /**
550      * @dev Returns the downcasted uint8 from uint256, reverting on
551      * overflow (when the input is greater than largest uint8).
552      *
553      * Counterpart to Solidity's `uint8` operator.
554      *
555      * Requirements:
556      *
557      * - input must fit into 8 bits.
558      */
559     function toUint8(uint256 value) internal pure returns (uint8) {
560         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
561         return uint8(value);
562     }
563 
564     /**
565      * @dev Converts a signed int256 into an unsigned uint256.
566      *
567      * Requirements:
568      *
569      * - input must be greater than or equal to 0.
570      */
571     function toUint256(int256 value) internal pure returns (uint256) {
572         require(value >= 0, "SafeCast: value must be positive");
573         return uint256(value);
574     }
575 
576     /**
577      * @dev Returns the downcasted int128 from int256, reverting on
578      * overflow (when the input is less than smallest int128 or
579      * greater than largest int128).
580      *
581      * Counterpart to Solidity's `int128` operator.
582      *
583      * Requirements:
584      *
585      * - input must fit into 128 bits
586      *
587      * _Available since v3.1._
588      */
589     function toInt128(int256 value) internal pure returns (int128) {
590         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
591         return int128(value);
592     }
593 
594     /**
595      * @dev Returns the downcasted int64 from int256, reverting on
596      * overflow (when the input is less than smallest int64 or
597      * greater than largest int64).
598      *
599      * Counterpart to Solidity's `int64` operator.
600      *
601      * Requirements:
602      *
603      * - input must fit into 64 bits
604      *
605      * _Available since v3.1._
606      */
607     function toInt64(int256 value) internal pure returns (int64) {
608         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
609         return int64(value);
610     }
611 
612     /**
613      * @dev Returns the downcasted int32 from int256, reverting on
614      * overflow (when the input is less than smallest int32 or
615      * greater than largest int32).
616      *
617      * Counterpart to Solidity's `int32` operator.
618      *
619      * Requirements:
620      *
621      * - input must fit into 32 bits
622      *
623      * _Available since v3.1._
624      */
625     function toInt32(int256 value) internal pure returns (int32) {
626         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
627         return int32(value);
628     }
629 
630     /**
631      * @dev Returns the downcasted int16 from int256, reverting on
632      * overflow (when the input is less than smallest int16 or
633      * greater than largest int16).
634      *
635      * Counterpart to Solidity's `int16` operator.
636      *
637      * Requirements:
638      *
639      * - input must fit into 16 bits
640      *
641      * _Available since v3.1._
642      */
643     function toInt16(int256 value) internal pure returns (int16) {
644         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
645         return int16(value);
646     }
647 
648     /**
649      * @dev Returns the downcasted int8 from int256, reverting on
650      * overflow (when the input is less than smallest int8 or
651      * greater than largest int8).
652      *
653      * Counterpart to Solidity's `int8` operator.
654      *
655      * Requirements:
656      *
657      * - input must fit into 8 bits.
658      *
659      * _Available since v3.1._
660      */
661     function toInt8(int256 value) internal pure returns (int8) {
662         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
663         return int8(value);
664     }
665 
666     /**
667      * @dev Converts an unsigned uint256 into a signed int256.
668      *
669      * Requirements:
670      *
671      * - input must be less than or equal to maxInt256.
672      */
673     function toInt256(uint256 value) internal pure returns (int256) {
674         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
675         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
676         return int256(value);
677     }
678 }
679 
680 /*
681  * @dev Provides information about the current execution context, including the
682  * sender of the transaction and its data. While these are generally available
683  * via msg.sender and msg.data, they should not be accessed in such a direct
684  * manner, since when dealing with meta-transactions the account sending and
685  * paying for execution may not be the actual sender (as far as an application
686  * is concerned).
687  *
688  * This contract is only required for intermediate, library-like contracts.
689  */
690 abstract contract Context {
691     function _msgSender() internal view virtual returns (address) {
692         return msg.sender;
693     }
694 
695     function _msgData() internal view virtual returns (bytes calldata) {
696         return msg.data;
697     }
698 }
699 
700 /**
701  * @dev Interface of the ERC20 standard as defined in the EIP.
702  */
703 interface IERC20 {
704     /**
705      * @dev Returns the amount of tokens in existence.
706      */
707     function totalSupply() external view returns (uint256);
708 
709     /**
710      * @dev Returns the amount of tokens owned by `account`.
711      */
712     function balanceOf(address account) external view returns (uint256);
713 
714     /**
715      * @dev Moves `amount` tokens from the caller's account to `recipient`.
716      *
717      * Returns a boolean value indicating whether the operation succeeded.
718      *
719      * Emits a {Transfer} event.
720      */
721     function transfer(address recipient, uint256 amount) external returns (bool);
722 
723     /**
724      * @dev Returns the remaining number of tokens that `spender` will be
725      * allowed to spend on behalf of `owner` through {transferFrom}. This is
726      * zero by default.
727      *
728      * This value changes when {approve} or {transferFrom} are called.
729      */
730     function allowance(address owner, address spender) external view returns (uint256);
731 
732     /**
733      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
734      *
735      * Returns a boolean value indicating whether the operation succeeded.
736      *
737      * IMPORTANT: Beware that changing an allowance with this method brings the risk
738      * that someone may use both the old and the new allowance by unfortunate
739      * transaction ordering. One possible solution to mitigate this race
740      * condition is to first reduce the spender's allowance to 0 and set the
741      * desired value afterwards:
742      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
743      *
744      * Emits an {Approval} event.
745      */
746     function approve(address spender, uint256 amount) external returns (bool);
747 
748     /**
749      * @dev Moves `amount` tokens from `sender` to `recipient` using the
750      * allowance mechanism. `amount` is then deducted from the caller's
751      * allowance.
752      *
753      * Returns a boolean value indicating whether the operation succeeded.
754      *
755      * Emits a {Transfer} event.
756      */
757     function transferFrom(
758         address sender,
759         address recipient,
760         uint256 amount
761     ) external returns (bool);
762 
763     /**
764      * @dev Emitted when `value` tokens are moved from one account (`from`) to
765      * another (`to`).
766      *
767      * Note that `value` may be zero.
768      */
769     event Transfer(address indexed from, address indexed to, uint256 value);
770 
771     /**
772      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
773      * a call to {approve}. `value` is the new allowance.
774      */
775     event Approval(address indexed owner, address indexed spender, uint256 value);
776 }
777 
778 /**
779  * @dev Interface for the optional metadata functions from the ERC20 standard.
780  *
781  * _Available since v4.1._
782  */
783 interface IERC20Metadata is IERC20 {
784     /**
785      * @dev Returns the name of the token.
786      */
787     function name() external view returns (string memory);
788 
789     /**
790      * @dev Returns the symbol of the token.
791      */
792     function symbol() external view returns (string memory);
793 
794     /**
795      * @dev Returns the decimals places of the token.
796      */
797     function decimals() external view returns (uint8);
798 }
799 
800 /**
801  * @dev Implementation of the {IERC20} interface.
802  *
803  * This implementation is agnostic to the way tokens are created. This means
804  * that a supply mechanism has to be added in a derived contract using {_mint}.
805  * For a generic mechanism see {ERC20PresetMinterPauser}.
806  *
807  * TIP: For a detailed writeup see our guide
808  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
809  * to implement supply mechanisms].
810  *
811  * We have followed general OpenZeppelin guidelines: functions revert instead
812  * of returning `false` on failure. This behavior is nonetheless conventional
813  * and does not conflict with the expectations of ERC20 applications.
814  *
815  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
816  * This allows applications to reconstruct the allowance for all accounts just
817  * by listening to said events. Other implementations of the EIP may not emit
818  * these events, as it isn't required by the specification.
819  *
820  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
821  * functions have been added to mitigate the well-known issues around setting
822  * allowances. See {IERC20-approve}.
823  */
824 contract ERC20 is Context, IERC20, IERC20Metadata {
825     mapping(address => uint256) private _balances;
826 
827     mapping(address => mapping(address => uint256)) private _allowances;
828 
829     uint256 private _totalSupply;
830 
831     string private _name;
832     string private _symbol;
833 
834     /**
835      * @dev Sets the values for {name} and {symbol}.
836      *
837      * The default value of {decimals} is 18. To select a different value for
838      * {decimals} you should overload it.
839      *
840      * All two of these values are immutable: they can only be set once during
841      * construction.
842      */
843     constructor(string memory name_, string memory symbol_) {
844         _name = name_;
845         _symbol = symbol_;
846     }
847 
848     /**
849      * @dev Returns the name of the token.
850      */
851     function name() public view virtual override returns (string memory) {
852         return _name;
853     }
854 
855     /**
856      * @dev Returns the symbol of the token, usually a shorter version of the
857      * name.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev Returns the number of decimals used to get its user representation.
865      * For example, if `decimals` equals `2`, a balance of `505` tokens should
866      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
867      *
868      * Tokens usually opt for a value of 18, imitating the relationship between
869      * Ether and Wei. This is the value {ERC20} uses, unless this function is
870      * overridden;
871      *
872      * NOTE: This information is only used for _display_ purposes: it in
873      * no way affects any of the arithmetic of the contract, including
874      * {IERC20-balanceOf} and {IERC20-transfer}.
875      */
876     function decimals() public view virtual override returns (uint8) {
877         return 18;
878     }
879 
880     /**
881      * @dev See {IERC20-totalSupply}.
882      */
883     function totalSupply() public view virtual override returns (uint256) {
884         return _totalSupply;
885     }
886 
887     /**
888      * @dev See {IERC20-balanceOf}.
889      */
890     function balanceOf(address account) public view virtual override returns (uint256) {
891         return _balances[account];
892     }
893 
894     /**
895      * @dev See {IERC20-transfer}.
896      *
897      * Requirements:
898      *
899      * - `recipient` cannot be the zero address.
900      * - the caller must have a balance of at least `amount`.
901      */
902     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
903         _transfer(_msgSender(), recipient, amount);
904         return true;
905     }
906 
907     /**
908      * @dev See {IERC20-allowance}.
909      */
910     function allowance(address owner, address spender) public view virtual override returns (uint256) {
911         return _allowances[owner][spender];
912     }
913 
914     /**
915      * @dev See {IERC20-approve}.
916      *
917      * Requirements:
918      *
919      * - `spender` cannot be the zero address.
920      */
921     function approve(address spender, uint256 amount) public virtual override returns (bool) {
922         _approve(_msgSender(), spender, amount);
923         return true;
924     }
925 
926     /**
927      * @dev See {IERC20-transferFrom}.
928      *
929      * Emits an {Approval} event indicating the updated allowance. This is not
930      * required by the EIP. See the note at the beginning of {ERC20}.
931      *
932      * Requirements:
933      *
934      * - `sender` and `recipient` cannot be the zero address.
935      * - `sender` must have a balance of at least `amount`.
936      * - the caller must have allowance for ``sender``'s tokens of at least
937      * `amount`.
938      */
939     function transferFrom(
940         address sender,
941         address recipient,
942         uint256 amount
943     ) public virtual override returns (bool) {
944         _transfer(sender, recipient, amount);
945 
946         uint256 currentAllowance = _allowances[sender][_msgSender()];
947         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
948         unchecked {
949             _approve(sender, _msgSender(), currentAllowance - amount);
950         }
951 
952         return true;
953     }
954 
955     /**
956      * @dev Atomically increases the allowance granted to `spender` by the caller.
957      *
958      * This is an alternative to {approve} that can be used as a mitigation for
959      * problems described in {IERC20-approve}.
960      *
961      * Emits an {Approval} event indicating the updated allowance.
962      *
963      * Requirements:
964      *
965      * - `spender` cannot be the zero address.
966      */
967     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
968         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
969         return true;
970     }
971 
972     /**
973      * @dev Atomically decreases the allowance granted to `spender` by the caller.
974      *
975      * This is an alternative to {approve} that can be used as a mitigation for
976      * problems described in {IERC20-approve}.
977      *
978      * Emits an {Approval} event indicating the updated allowance.
979      *
980      * Requirements:
981      *
982      * - `spender` cannot be the zero address.
983      * - `spender` must have allowance for the caller of at least
984      * `subtractedValue`.
985      */
986     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
987         uint256 currentAllowance = _allowances[_msgSender()][spender];
988         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
989         unchecked {
990             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
991         }
992 
993         return true;
994     }
995 
996     /**
997      * @dev Moves `amount` of tokens from `sender` to `recipient`.
998      *
999      * This internal function is equivalent to {transfer}, and can be used to
1000      * e.g. implement automatic token fees, slashing mechanisms, etc.
1001      *
1002      * Emits a {Transfer} event.
1003      *
1004      * Requirements:
1005      *
1006      * - `sender` cannot be the zero address.
1007      * - `recipient` cannot be the zero address.
1008      * - `sender` must have a balance of at least `amount`.
1009      */
1010     function _transfer(
1011         address sender,
1012         address recipient,
1013         uint256 amount
1014     ) internal virtual {
1015         require(sender != address(0), "ERC20: transfer from the zero address");
1016         require(recipient != address(0), "ERC20: transfer to the zero address");
1017 
1018         _beforeTokenTransfer(sender, recipient, amount);
1019 
1020         uint256 senderBalance = _balances[sender];
1021         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1022         unchecked {
1023             _balances[sender] = senderBalance - amount;
1024         }
1025         _balances[recipient] += amount;
1026 
1027         emit Transfer(sender, recipient, amount);
1028 
1029         _afterTokenTransfer(sender, recipient, amount);
1030     }
1031 
1032     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1033      * the total supply.
1034      *
1035      * Emits a {Transfer} event with `from` set to the zero address.
1036      *
1037      * Requirements:
1038      *
1039      * - `account` cannot be the zero address.
1040      */
1041     function _mint(address account, uint256 amount) internal virtual {
1042         require(account != address(0), "ERC20: mint to the zero address");
1043 
1044         _beforeTokenTransfer(address(0), account, amount);
1045 
1046         _totalSupply += amount;
1047         _balances[account] += amount;
1048         emit Transfer(address(0), account, amount);
1049 
1050         _afterTokenTransfer(address(0), account, amount);
1051     }
1052 
1053     /**
1054      * @dev Destroys `amount` tokens from `account`, reducing the
1055      * total supply.
1056      *
1057      * Emits a {Transfer} event with `to` set to the zero address.
1058      *
1059      * Requirements:
1060      *
1061      * - `account` cannot be the zero address.
1062      * - `account` must have at least `amount` tokens.
1063      */
1064     function _burn(address account, uint256 amount) internal virtual {
1065         require(account != address(0), "ERC20: burn from the zero address");
1066 
1067         _beforeTokenTransfer(account, address(0), amount);
1068 
1069         uint256 accountBalance = _balances[account];
1070         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1071         unchecked {
1072             _balances[account] = accountBalance - amount;
1073         }
1074         _totalSupply -= amount;
1075 
1076         emit Transfer(account, address(0), amount);
1077 
1078         _afterTokenTransfer(account, address(0), amount);
1079     }
1080 
1081     /**
1082      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1083      *
1084      * This internal function is equivalent to `approve`, and can be used to
1085      * e.g. set automatic allowances for certain subsystems, etc.
1086      *
1087      * Emits an {Approval} event.
1088      *
1089      * Requirements:
1090      *
1091      * - `owner` cannot be the zero address.
1092      * - `spender` cannot be the zero address.
1093      */
1094     function _approve(
1095         address owner,
1096         address spender,
1097         uint256 amount
1098     ) internal virtual {
1099         require(owner != address(0), "ERC20: approve from the zero address");
1100         require(spender != address(0), "ERC20: approve to the zero address");
1101 
1102         _allowances[owner][spender] = amount;
1103         emit Approval(owner, spender, amount);
1104     }
1105 
1106     /**
1107      * @dev Hook that is called before any transfer of tokens. This includes
1108      * minting and burning.
1109      *
1110      * Calling conditions:
1111      *
1112      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1113      * will be transferred to `to`.
1114      * - when `from` is zero, `amount` tokens will be minted for `to`.
1115      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1116      * - `from` and `to` are never both zero.
1117      *
1118      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1119      */
1120     function _beforeTokenTransfer(
1121         address from,
1122         address to,
1123         uint256 amount
1124     ) internal virtual {}
1125 
1126     /**
1127      * @dev Hook that is called after any transfer of tokens. This includes
1128      * minting and burning.
1129      *
1130      * Calling conditions:
1131      *
1132      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1133      * has been transferred to `to`.
1134      * - when `from` is zero, `amount` tokens have been minted for `to`.
1135      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1136      * - `from` and `to` are never both zero.
1137      *
1138      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1139      */
1140     function _afterTokenTransfer(
1141         address from,
1142         address to,
1143         uint256 amount
1144     ) internal virtual {}
1145 }
1146 
1147 /**
1148  * @dev Contract module which provides a basic access control mechanism, where
1149  * there is an account (an owner) that can be granted exclusive access to
1150  * specific functions.
1151  *
1152  * By default, the owner account will be the one that deploys the contract. This
1153  * can later be changed with {transferOwnership}.
1154  *
1155  * This module is used through inheritance. It will make available the modifier
1156  * `onlyOwner`, which can be applied to your functions to restrict their use to
1157  * the owner.
1158  */
1159 abstract contract Ownable is Context {
1160     address private _owner;
1161 
1162     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1163 
1164     /**
1165      * @dev Initializes the contract setting the deployer as the initial owner.
1166      */
1167     constructor() {
1168         _setOwner(_msgSender());
1169     }
1170 
1171     /**
1172      * @dev Returns the address of the current owner.
1173      */
1174     function owner() public view virtual returns (address) {
1175         return _owner;
1176     }
1177 
1178     /**
1179      * @dev Throws if called by any account other than the owner.
1180      */
1181     modifier onlyOwner() {
1182         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1183         _;
1184     }
1185 
1186     /**
1187      * @dev Leaves the contract without owner. It will not be possible to call
1188      * `onlyOwner` functions anymore. Can only be called by the current owner.
1189      *
1190      * NOTE: Renouncing ownership will leave the contract without an owner,
1191      * thereby removing any functionality that is only available to the owner.
1192      */
1193     function renounceOwnership() public virtual onlyOwner {
1194         _setOwner(address(0));
1195     }
1196 
1197     /**
1198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1199      * Can only be called by the current owner.
1200      */
1201     function transferOwnership(address newOwner) public virtual onlyOwner {
1202         require(newOwner != address(0), "Ownable: new owner is the zero address");
1203         _setOwner(newOwner);
1204     }
1205 
1206     function _setOwner(address newOwner) private {
1207         address oldOwner = _owner;
1208         _owner = newOwner;
1209         emit OwnershipTransferred(oldOwner, newOwner);
1210     }
1211 }
1212 
1213 library IterableMapping {
1214     // Iterable mapping from address to uint;
1215     struct Map {
1216         address[] keys;
1217         mapping(address => uint) values;
1218         mapping(address => uint) indexOf;
1219         mapping(address => bool) inserted;
1220     }
1221 
1222     function get(Map storage map, address key) public view returns (uint) {
1223         return map.values[key];
1224     }
1225 
1226     function getIndexOfKey(Map storage map, address key) public view returns (int) {
1227         if(!map.inserted[key]) {
1228             return -1;
1229         }
1230         return int(map.indexOf[key]);
1231     }
1232 
1233     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
1234         return map.keys[index];
1235     }
1236 
1237 
1238 
1239     function size(Map storage map) public view returns (uint) {
1240         return map.keys.length;
1241     }
1242 
1243     function set(Map storage map, address key, uint val) public {
1244         if (map.inserted[key]) {
1245             map.values[key] = val;
1246         } else {
1247             map.inserted[key] = true;
1248             map.values[key] = val;
1249             map.indexOf[key] = map.keys.length;
1250             map.keys.push(key);
1251         }
1252     }
1253 
1254     function remove(Map storage map, address key) public {
1255         if (!map.inserted[key]) {
1256             return;
1257         }
1258 
1259         delete map.inserted[key];
1260         delete map.values[key];
1261 
1262         uint index = map.indexOf[key];
1263         uint lastIndex = map.keys.length - 1;
1264         address lastKey = map.keys[lastIndex];
1265 
1266         map.indexOf[lastKey] = index;
1267         delete map.indexOf[key];
1268 
1269         map.keys[index] = lastKey;
1270         map.keys.pop();
1271     }
1272 }
1273 
1274 
1275 /// @title Dividend-Paying Token Optional Interface
1276 /// @author Roger Wu (https://github.com/roger-wu)
1277 /// @dev OPTIONAL functions for a dividend-paying token contract.
1278 interface DividendPayingTokenOptionalInterface {
1279   /// @notice View the amount of dividend in wei that an address can withdraw.
1280   /// @param _owner The address of a token holder.
1281   /// @return The amount of dividend in wei that `_owner` can withdraw.
1282   function withdrawableDividendOf(address _owner) external view returns(uint256);
1283 
1284   /// @notice View the amount of dividend in wei that an address has withdrawn.
1285   /// @param _owner The address of a token holder.
1286   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1287   function withdrawnDividendOf(address _owner) external view returns(uint256);
1288 
1289   /// @notice View the amount of dividend in wei that an address has earned in total.
1290   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1291   /// @param _owner The address of a token holder.
1292   /// @return The amount of dividend in wei that `_owner` has earned in total.
1293   function accumulativeDividendOf(address _owner) external view returns(uint256);
1294 }
1295 
1296 
1297 /// @title Dividend-Paying Token Interface
1298 /// @author Roger Wu (https://github.com/roger-wu)
1299 /// @dev An interface for a dividend-paying token contract.
1300 interface DividendPayingTokenInterface {
1301   /// @notice View the amount of dividend in wei that an address can withdraw.
1302   /// @param _owner The address of a token holder.
1303   /// @return The amount of dividend in wei that `_owner` can withdraw.
1304   function dividendOf(address _owner) external view returns(uint256);
1305 
1306   /// @notice Distributes ether to token holders as dividends.
1307   /// @dev SHOULD distribute the paid ether to token holders as dividends.
1308   ///  SHOULD NOT directly transfer ether to token holders in this function.
1309   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
1310   function distributeDividends() external payable;
1311 
1312   /// @notice Withdraws the ether distributed to the sender.
1313   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
1314   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
1315   function withdrawDividend() external;
1316 
1317   /// @dev This event MUST emit when ether is distributed to token holders.
1318   /// @param from The address which sends ether to this contract.
1319   /// @param weiAmount The amount of distributed ether in wei.
1320   event DividendsDistributed(
1321     address indexed from,
1322     uint256 weiAmount
1323   );
1324 
1325   /// @dev This event MUST emit when an address withdraws their dividend.
1326   /// @param to The address which withdraws ether from this contract.
1327   /// @param weiAmount The amount of withdrawn ether in wei.
1328   event DividendWithdrawn(
1329     address indexed to,
1330     uint256 weiAmount
1331   );
1332 }
1333 
1334 
1335 /// @title Dividend-Paying Token
1336 /// @author Roger Wu (https://github.com/roger-wu)
1337 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1338 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1339 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1340 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1341   using SafeMath for uint256;
1342   using SignedSafeMath for int256;
1343   using SafeCast for uint256;
1344   using SafeCast for int256;
1345 
1346   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1347   // For more discussion about choosing the value of `magnitude`,
1348   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1349   uint256 constant internal magnitude = 2**128;
1350 
1351   uint256 internal magnifiedDividendPerShare;
1352 
1353   // About dividendCorrection:
1354   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1355   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1356   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1357   //   `dividendOf(_user)` should not be changed,
1358   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1359   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1360   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1361   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1362   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1363   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1364   mapping(address => int256) internal magnifiedDividendCorrections;
1365   mapping(address => uint256) internal withdrawnDividends;
1366 
1367   uint256 public totalDividendsDistributed;
1368 
1369   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1370 
1371   }
1372 
1373   /// @dev Distributes dividends whenever ether is paid to this contract.
1374   receive() external payable {
1375     distributeDividends();
1376   }
1377 
1378   /// @notice Distributes ether to token holders as dividends.
1379   /// @dev It reverts if the total supply of tokens is 0.
1380   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1381   /// About undistributed ether:
1382   ///   In each distribution, there is a small amount of ether not distributed,
1383   ///     the magnified amount of which is
1384   ///     `(msg.value * magnitude) % totalSupply()`.
1385   ///   With a well-chosen `magnitude`, the amount of undistributed ether
1386   ///     (de-magnified) in a distribution can be less than 1 wei.
1387   ///   We can actually keep track of the undistributed ether in a distribution
1388   ///     and try to distribute it in the next distribution,
1389   ///     but keeping track of such data on-chain costs much more than
1390   ///     the saved ether, so we don't do that.
1391   function distributeDividends() public override payable {
1392     require(totalSupply() > 0);
1393 
1394     if (msg.value > 0) {
1395       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1396         (msg.value).mul(magnitude) / totalSupply()
1397       );
1398       emit DividendsDistributed(msg.sender, msg.value);
1399 
1400       totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1401     }
1402   }
1403 
1404   /// @notice Withdraws the ether distributed to the sender.
1405   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1406   function withdrawDividend() public virtual override {
1407     _withdrawDividendOfUser(payable(msg.sender));
1408   }
1409 
1410   /// @notice Withdraws the ether distributed to the sender.
1411   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1412   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1413     uint256 _withdrawableDividend = withdrawableDividendOf(user);
1414     if (_withdrawableDividend > 0) {
1415       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1416       emit DividendWithdrawn(user, _withdrawableDividend);
1417       (bool success,) = user.call{value: _withdrawableDividend, gas: 3000}("");
1418 
1419       if(!success) {
1420         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1421         return 0;
1422       }
1423 
1424       return _withdrawableDividend;
1425     }
1426 
1427     return 0;
1428   }
1429 
1430 
1431   /// @notice View the amount of dividend in wei that an address can withdraw.
1432   /// @param _owner The address of a token holder.
1433   /// @return The amount of dividend in wei that `_owner` can withdraw.
1434   function dividendOf(address _owner) public view override returns(uint256) {
1435     return withdrawableDividendOf(_owner);
1436   }
1437 
1438   /// @notice View the amount of dividend in wei that an address can withdraw.
1439   /// @param _owner The address of a token holder.
1440   /// @return The amount of dividend in wei that `_owner` can withdraw.
1441   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1442     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1443   }
1444 
1445   /// @notice View the amount of dividend in wei that an address has withdrawn.
1446   /// @param _owner The address of a token holder.
1447   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1448   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1449     return withdrawnDividends[_owner];
1450   }
1451 
1452 
1453   /// @notice View the amount of dividend in wei that an address has earned in total.
1454   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1455   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1456   /// @param _owner The address of a token holder.
1457   /// @return The amount of dividend in wei that `_owner` has earned in total.
1458   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1459     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256()
1460       .add(magnifiedDividendCorrections[_owner]).toUint256() / magnitude;
1461   }
1462 
1463   /// @dev Internal function that transfer tokens from one address to another.
1464   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1465   /// @param from The address to transfer from.
1466   /// @param to The address to transfer to.
1467   /// @param value The amount to be transferred.
1468   function _transfer(address from, address to, uint256 value) internal virtual override {
1469     require(false);
1470 
1471     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256();
1472     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1473     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1474   }
1475 
1476   /// @dev Internal function that mints tokens to an account.
1477   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1478   /// @param account The account that will receive the created tokens.
1479   /// @param value The amount that will be created.
1480   function _mint(address account, uint256 value) internal override {
1481     super._mint(account, value);
1482 
1483     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1484       .sub( (magnifiedDividendPerShare.mul(value)).toInt256() );
1485   }
1486 
1487   /// @dev Internal function that burns an amount of the token of a given account.
1488   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1489   /// @param account The account whose tokens will be burnt.
1490   /// @param value The amount that will be burnt.
1491   function _burn(address account, uint256 value) internal override {
1492     super._burn(account, value);
1493 
1494     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1495       .add( (magnifiedDividendPerShare.mul(value)).toInt256() );
1496   }
1497 
1498   function _setBalance(address account, uint256 newBalance) internal {
1499     uint256 currentBalance = balanceOf(account);
1500 
1501     if(newBalance > currentBalance) {
1502       uint256 mintAmount = newBalance.sub(currentBalance);
1503       _mint(account, mintAmount);
1504     } else if(newBalance < currentBalance) {
1505       uint256 burnAmount = currentBalance.sub(newBalance);
1506       _burn(account, burnAmount);
1507     }
1508   }
1509 }
1510 contract $ZFGDividendTracker is DividendPayingToken, Ownable {
1511     using SafeMath for uint256;
1512     using SignedSafeMath for int256;
1513     using IterableMapping for IterableMapping.Map;
1514 
1515     IterableMapping.Map private tokenHoldersMap;
1516     uint256 public lastProcessedIndex;
1517 
1518     mapping (address => bool) public excludedFromDividends;
1519 
1520     mapping (address => uint256) public lastClaimTimes;
1521 
1522     uint256 public claimWait;
1523     uint256 public  minimumTokenBalanceForDividends;
1524 
1525     event ExcludeFromDividends(address indexed account);
1526     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1527 
1528     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1529 
1530     constructor() DividendPayingToken("$ZFG_Dividend_Tracker", "$ZFG_Dividend_Tracker") {
1531         claimWait = 172800;
1532         minimumTokenBalanceForDividends = 100000 * (10**18); //must hold 100000+ tokens
1533     }
1534 
1535     function _transfer(address, address, uint256) internal pure override {
1536         require(false, "$ZFG_Dividend_Tracker: No transfers allowed");
1537     }
1538 
1539     function withdrawDividend() public pure override {
1540         require(false, "$ZFG_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main $ZFG contract.");
1541     }
1542 
1543     function excludeFromDividends(address account) external onlyOwner {
1544     	require(!excludedFromDividends[account]);
1545     	excludedFromDividends[account] = true;
1546 
1547     	_setBalance(account, 0);
1548     	tokenHoldersMap.remove(account);
1549 
1550     	emit ExcludeFromDividends(account);
1551     }
1552 
1553     function setMinimumTokensForHolds(uint256 _amount) external onlyOwner {
1554         minimumTokenBalanceForDividends = _amount *(10**18);
1555     }
1556 
1557     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1558         require(newClaimWait >= 3600 && newClaimWait <= 604800, "$ZFG_Dividend_Tracker: claimWait must be updated to between 1 and 7 days");	
1559         require(newClaimWait != claimWait, "$ZFG_Dividend_Tracker: Cannot update claimWait to same value");
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
1723 contract ZFG is ERC20, Ownable {
1724     using SafeMath for uint256;
1725 
1726     IUniswapV2Router02 public uniswapV2Router;
1727     address public immutable uniswapV2Pair;
1728 
1729     bool private inSwapAndLiquify;
1730 
1731     // Anti-bot and anti-whale mappings and variables
1732     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1733     bool public transferDelayEnabled = true;
1734     bool public limitsInEffect = true;
1735 
1736     bool public swapAndLiquifyEnabled = true;
1737     bool public tradingActive = false;
1738 
1739     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1740     mapping(address => bool) public boughtEarly; // mapping to track addresses that buy within the first 2 blocks pay a 3x tax for 24 hours to sell
1741     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1742 
1743     $ZFGDividendTracker public dividendTracker;
1744 
1745     uint256 public maxSellTransactionAmount = 100000000 * (10**18); //1% 
1746     uint256 public maxBuyTransactionAmount = 100000000 * (10**18); //1%
1747     uint256 public swapTokensAtAmount = 10000000 * (10**18); //0.1%
1748 
1749     uint256 public maxWalletToken = 200000000 * (10**18); //2%
1750 
1751     uint256 public ETHRewardsFee;
1752     uint256 public liquidityFee;
1753     uint256 public totalFees;
1754     uint256 public marketingFee;
1755 
1756     uint256 public onSellETHRewardsFee;
1757     uint256 public onSellliquidityFee;
1758     uint256 public onSelltotalFees;
1759     uint256 public onSellmarketingFee;
1760 
1761     address payable public  marketingWallet;
1762     // use by default 300,000 gas to process auto-claiming dividends
1763     uint256 public gasForProcessing = 300000;
1764 
1765     // exlcude from fees and max transaction amount
1766     mapping (address => bool) private _isExcludedFromFees;
1767     
1768     mapping(address => bool) private _isExcludedFromMaxTx;
1769     mapping(address => bool) public _isBlacklisted;
1770 
1771     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1772     // could be subject to a maximum transfer amount
1773     mapping (address => bool) public automatedMarketMakerPairs;
1774 
1775     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1776 
1777     event ExcludeFromFees(address indexed account, bool isExcluded);
1778     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1779 
1780     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1781 
1782     event BoughtEarly(address indexed sniper);
1783 
1784     event RemovedSniper(address indexed notsnipersupposedly);
1785 
1786     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1787 
1788     event SwapAndLiquifyEnabledUpdated(bool enabled);
1789 
1790     event SwapAndLiquify(
1791         uint256 tokensIntoLiqudity,
1792         uint256 ethReceived
1793     );
1794 
1795     event SendDividends(
1796     	uint256 tokensSwapped,
1797     	uint256 amount
1798     );
1799 
1800     event ProcessedDividendTracker(
1801     	uint256 iterations,
1802     	uint256 claims,
1803         uint256 lastProcessedIndex,
1804     	bool indexed automatic,
1805     	uint256 gas,
1806     	address indexed processor
1807     );
1808 
1809     modifier lockTheSwap {
1810         inSwapAndLiquify = true;
1811         _;
1812         inSwapAndLiquify = false;
1813     }
1814 
1815     function setFee(uint256 _ethRewardFee, uint256 _liquidityFee, uint256 _marketingFee) public onlyOwner {
1816         ETHRewardsFee = _ethRewardFee;
1817         liquidityFee = _liquidityFee;
1818         marketingFee = _marketingFee;
1819 
1820         totalFees = ETHRewardsFee.add(liquidityFee).add(marketingFee); // total fee transfer and buy
1821         require(totalFees <= 20, "bUY FEE SHOULD BE 20% or less");
1822     }
1823 
1824     // remove limits after token is stable - 30-60 minutes
1825     function removeLimits() external onlyOwner returns (bool){
1826         limitsInEffect = false;
1827         transferDelayEnabled = false;
1828         return true;
1829     }
1830     
1831     // disable Transfer delay
1832     function disableTransferDelay() external onlyOwner returns (bool){
1833         transferDelayEnabled = false;
1834         return true;
1835     }
1836 
1837      function blacklistAddress(address account, bool value) external onlyOwner{
1838         _isBlacklisted[account] = value;
1839     }
1840 
1841     function setSellFee(uint256 _onSellEthRewardFee, uint256 _onSellliuidityFee, uint256 _onSellMarketingFee) public onlyOwner {
1842         onSellETHRewardsFee = _onSellEthRewardFee;
1843         onSellliquidityFee = _onSellliuidityFee;
1844         onSellmarketingFee = _onSellMarketingFee;
1845 
1846         onSelltotalFees = onSellETHRewardsFee.add(onSellliquidityFee).add(onSellmarketingFee);
1847         require(onSelltotalFees <= 30, "Buy Fee should be 30% or less");
1848     }
1849 
1850     function setMaxWalletTokens(uint256 _maxToken) external onlyOwner {
1851   	    maxWalletToken = _maxToken * (10**18);
1852   	}
1853     
1854     function setMarketingWallet(address payable _newMarketingWallet) public onlyOwner {
1855         marketingWallet = _newMarketingWallet;
1856     }
1857 
1858     constructor() ERC20("Zero Fvcks Given", "$ZFG") {
1859         ETHRewardsFee = 0;
1860         liquidityFee = 3;
1861         marketingFee = 3;
1862 
1863         onSellETHRewardsFee = 7;
1864         onSellliquidityFee = 5;
1865         onSellmarketingFee = 8;
1866 
1867         marketingWallet = payable(0x37202411d10D550e45dc4465B074A4E399Da9be9);
1868 
1869         totalFees = ETHRewardsFee.add(liquidityFee).add(marketingFee); // total fee transfer and buy
1870 
1871         onSelltotalFees = onSellETHRewardsFee.add(onSellliquidityFee).add(onSellmarketingFee);
1872 
1873     	dividendTracker = new $ZFGDividendTracker();
1874 
1875     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1876          // Create a uniswap pair for this new token
1877         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1878             .createPair(address(this), _uniswapV2Router.WETH());
1879 
1880         uniswapV2Router = _uniswapV2Router;
1881         uniswapV2Pair = _uniswapV2Pair;
1882 
1883         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1884 
1885         // exclude from receiving dividends
1886         dividendTracker.excludeFromDividends(address(dividendTracker));
1887         dividendTracker.excludeFromDividends(address(this));
1888         dividendTracker.excludeFromDividends(owner());
1889         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1890         dividendTracker.excludeFromDividends(0x000000000000000000000000000000000000dEaD);
1891 
1892         // exclude from paying fees or having max transaction amount
1893         excludeFromFees(owner(), true);
1894         excludeFromFees(0x64E69904Fc69991916AEf940A8A8Ce4799A99a4C, true);
1895         excludeFromFees(marketingWallet, true);
1896         excludeFromFees(address(this), true);
1897         
1898         // exclude from max tx
1899         _isExcludedFromMaxTx[owner()] = true;
1900         _isExcludedFromMaxTx[address(this)] = true;
1901         _isExcludedFromMaxTx[marketingWallet] = true;
1902         
1903 
1904         /*
1905             _mint is an internal function in ERC20.sol that is only called here,
1906             and CANNOT be called ever again
1907         */
1908         _mint(owner(), 10000000000 * (10**18));
1909     }
1910 
1911     receive() external payable {
1912 
1913   	}
1914 
1915     // once enabled, can never be turned off
1916     function enableTrading() external onlyOwner {
1917         tradingActive = true;
1918         swapAndLiquifyEnabled = true;
1919         tradingActiveBlock = block.number;
1920         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
1921     }
1922 
1923     function updateUniswapV2Router(address newAddress) public onlyOwner {
1924         require(newAddress != address(uniswapV2Router), "$ZFG: The router already has that address");
1925         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1926         uniswapV2Router = IUniswapV2Router02(newAddress);
1927     }
1928 
1929     function setMaxBuyTrxAmount(uint256 _amount) external onlyOwner {
1930         maxBuyTransactionAmount = _amount * (10**18);
1931 
1932     }
1933 
1934     function setMaxSellTrxAmount(uint256 _amount) external onlyOwner {
1935         maxSellTransactionAmount = _amount * (10**18);
1936 
1937     }
1938 
1939     function excludeFromFees(address account, bool excluded) public onlyOwner {
1940         require(_isExcludedFromFees[account] != excluded, "$ZFG: Account is already the value of 'excluded'");
1941         _isExcludedFromFees[account] = excluded;
1942 
1943         emit ExcludeFromFees(account, excluded);
1944     }
1945     
1946     function setExcludeFromMaxTx(address _address, bool value) public onlyOwner { 
1947         _isExcludedFromMaxTx[_address] = value;
1948     }
1949 
1950     function setExcludeFromAll(address _address) public onlyOwner {
1951         _isExcludedFromMaxTx[_address] = true;
1952         _isExcludedFromFees[_address] = true;
1953         dividendTracker.excludeFromDividends(_address);
1954     }
1955 
1956     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1957         for(uint256 i = 0; i < accounts.length; i++) {
1958             _isExcludedFromFees[accounts[i]] = excluded;
1959         }
1960 
1961         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1962     }
1963 
1964     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1965         require(pair != uniswapV2Pair, "$ZFG: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1966 
1967         _setAutomatedMarketMakerPair(pair, value);
1968     }
1969      
1970     function setSWapToensAtAmount(uint256 _newAmount) public onlyOwner {
1971         swapTokensAtAmount = _newAmount * (10**18);
1972     }
1973 
1974     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1975         require(automatedMarketMakerPairs[pair] != value, "$ZFG: Automated market maker pair is already set to that value");
1976         automatedMarketMakerPairs[pair] = value;
1977 
1978         if(value) {
1979             dividendTracker.excludeFromDividends(pair);
1980         }
1981 
1982         emit SetAutomatedMarketMakerPair(pair, value);
1983     }
1984 
1985     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1986         require(newValue >= 200000 && newValue <= 500000, "$ZFG: gasForProcessing must be between 200,000 and 500,000");
1987         require(newValue != gasForProcessing, "$ZFG: Cannot update gasForProcessing to same value");
1988         emit GasForProcessingUpdated(newValue, gasForProcessing);
1989         gasForProcessing = newValue;
1990     }
1991 
1992     function updateClaimWait(uint256 claimWait) external onlyOwner {
1993         dividendTracker.updateClaimWait(claimWait);
1994     }
1995 
1996     function getClaimWait() external view returns(uint256) {
1997         return dividendTracker.claimWait();
1998     }
1999 
2000     function getTotalDividendsDistributed() external view returns (uint256) {
2001         return dividendTracker.totalDividendsDistributed();
2002     }
2003 
2004     function isExcludedFromFees(address account) public view returns(bool) {
2005         return _isExcludedFromFees[account];
2006     }
2007     
2008     function isExcludedFromMaxTx(address account) public view returns(bool) {
2009         return _isExcludedFromMaxTx[account];
2010     }
2011 
2012     function withdrawableDividendOf(address account) public view returns(uint256) {
2013     	return dividendTracker.withdrawableDividendOf(account);
2014   	}
2015 
2016 	function dividendTokenBalanceOf(address account) public view returns (uint256) {
2017 		return dividendTracker.balanceOf(account);
2018 	}
2019 
2020     function getAccountDividendsInfo(address account)
2021         external view returns (
2022             address,
2023             int256,
2024             int256,
2025             uint256,
2026             uint256,
2027             uint256,
2028             uint256,
2029             uint256) {
2030         return dividendTracker.getAccount(account);
2031     }
2032 
2033 	function getAccountDividendsInfoAtIndex(uint256 index)
2034         external view returns (
2035             address,
2036             int256,
2037             int256,
2038             uint256,
2039             uint256,
2040             uint256,
2041             uint256,
2042             uint256) {
2043     	return dividendTracker.getAccountAtIndex(index);
2044     }
2045 
2046 	function processDividendTracker(uint256 gas) external {
2047 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
2048 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
2049     }
2050 
2051     function claim() external {
2052 		dividendTracker.processAccount(payable(msg.sender), false);
2053     }
2054 
2055     function getLastProcessedIndex() external view returns(uint256) {
2056     	return dividendTracker.getLastProcessedIndex();
2057     }
2058 
2059     function getNumberOfDividendTokenHolders() external view returns(uint256) {
2060         return dividendTracker.getNumberOfTokenHolders();
2061     }
2062 
2063 //this will be used to exclude from dividends the presale smart contract address
2064     function excludeFromDividends(address account) external onlyOwner {
2065         dividendTracker.excludeFromDividends(account);
2066     }
2067 
2068     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
2069         swapAndLiquifyEnabled = _enabled;
2070         emit SwapAndLiquifyEnabledUpdated(_enabled);
2071     }
2072 
2073     function _transfer(
2074         address from,
2075         address to,
2076         uint256 amount
2077     ) internal override {
2078         require(from != address(0), "ERC20: transfer from the zero address");
2079         require(to != address(0), "ERC20: transfer to the zero address");
2080         require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted address");
2081 
2082        if(!tradingActive){
2083             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
2084         }
2085         if(amount == 0) {
2086             super._transfer(from, to, 0);
2087             return;
2088         }
2089 
2090         if(limitsInEffect){ 
2091             if (
2092             from != owner() &&
2093             to != owner() &&
2094             to != address(0) &&
2095             to != address(0xdead) &&
2096             to != uniswapV2Pair
2097         ) {
2098 
2099              if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
2100                     boughtEarly[to] = true;
2101                     emit BoughtEarly(to);
2102                 }
2103 
2104                  // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
2105                 if (transferDelayEnabled){
2106                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
2107                         require(_holderLastTransferTimestamp[to] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
2108                         _holderLastTransferTimestamp[to] = block.number;
2109                     }
2110                 }
2111 
2112             uint256 contractBalanceRecepient = balanceOf(to);
2113             require(
2114                 contractBalanceRecepient + amount <= maxWalletToken,
2115                 "Exceeds maximum wallet token amount."
2116             );
2117             
2118         }
2119 
2120         //when sell
2121 
2122         if(automatedMarketMakerPairs[to] && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){
2123             if(balanceOf(from) >= maxSellTransactionAmount){
2124                             require(amount <= balanceOf(from)/2);
2125                         }
2126         }
2127 
2128         //when buy
2129          if(automatedMarketMakerPairs[from] && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){
2130             require(amount <= maxBuyTransactionAmount, "Sell transfer amount exceeds the maxBuyTransactionAmount.");
2131         }
2132         }   
2133 
2134     	uint256 contractTokenBalance = balanceOf(address(this));
2135         
2136         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
2137        
2138         if(
2139             overMinTokenBalance &&
2140             !inSwapAndLiquify &&
2141             !automatedMarketMakerPairs[from] && 
2142             swapAndLiquifyEnabled
2143         ) {
2144             swapAndLiquify(contractTokenBalance);
2145         }
2146 
2147         // if any account belongs to _isExcludedFromFee account then remove the fee
2148         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
2149         	uint256 fees = (amount*totalFees)/100;
2150 
2151             if(automatedMarketMakerPairs[to]) {
2152                 fees =(amount*onSelltotalFees)/100;
2153                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
2154                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
2155                     fees = fees * 2;
2156                 }
2157             }
2158         	amount = amount-fees;
2159             super._transfer(from, address(this), fees); // get total fee first
2160         }
2161 
2162         super._transfer(from, to, amount);
2163 
2164         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
2165         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
2166 
2167         if(!inSwapAndLiquify) {
2168 	    	uint256 gas = gasForProcessing;
2169 
2170 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
2171 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
2172 	    	} 
2173 	    	catch {
2174 
2175 	    	}
2176         }
2177     }
2178 
2179     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
2180         // take liquidity fee, keep a half token
2181         // halfLiquidityToken = totalAmount * (liquidityFee/2totalFee)
2182         uint256 tokensToAddLiquidityWith = contractTokenBalance.div(onSelltotalFees.mul(2)).mul(onSellliquidityFee);
2183         // swap the remaining to BNB
2184         uint256 toSwap = contractTokenBalance-tokensToAddLiquidityWith;
2185         // capture the contract's current ETH balance.
2186         // this is so that we can capture exactly the amount of ETH that the
2187         // swap creates, and not make the liquidity event include any ETH that
2188         // has been manually sent to the contract
2189         uint256 initialBalance = address(this).balance;
2190 
2191         // swap tokens for ETH
2192         swapTokensForBnb(toSwap, address(this)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
2193 
2194         uint256 deltaBalance = address(this).balance-initialBalance;
2195 
2196         // take worthy amount bnb to add liquidity
2197         // worthyBNB = deltaBalance * liquidity/(2totalFees - liquidityFee)
2198         uint256 bnbToAddLiquidityWith = deltaBalance.mul(onSellliquidityFee).div(onSelltotalFees.mul(2).sub(onSellliquidityFee));
2199         
2200         // add liquidity to uniswap
2201         addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
2202         // worthy marketing fee
2203         uint256 marketingAmount = deltaBalance.sub(bnbToAddLiquidityWith).div(onSelltotalFees.sub(onSellliquidityFee)).mul(onSellmarketingFee);
2204         marketingWallet.transfer(marketingAmount);
2205         
2206 
2207         uint256 dividends = address(this).balance;
2208         (bool success,) = address(dividendTracker).call{value: dividends}("");
2209 
2210         if(success) {
2211    	 		emit SendDividends(toSwap-tokensToAddLiquidityWith, dividends);
2212         }
2213         
2214         emit SwapAndLiquify(tokensToAddLiquidityWith, deltaBalance);
2215     }
2216 
2217     function swapTokensForBnb(uint256 tokenAmount, address _to) private {
2218 
2219         
2220         // generate the uniswap pair path of token -> weth
2221         address[] memory path = new address[](2);
2222         path[0] = address(this);
2223         path[1] = uniswapV2Router.WETH();
2224 
2225         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
2226           _approve(address(this), address(uniswapV2Router), ~uint256(0));
2227         }
2228 
2229         // make the swap
2230         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2231             tokenAmount,
2232             0, // accept any amount of ETH
2233             path,
2234             _to,
2235             block.timestamp
2236         );
2237         
2238     }
2239     
2240     
2241 
2242     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
2243         
2244         // add the liquidity
2245         uniswapV2Router.addLiquidityETH{value: ethAmount}(
2246             address(this),
2247             tokenAmount,
2248             0, // slippage is unavoidable
2249             0, // slippage is unavoidable
2250             owner(),
2251             block.timestamp
2252         );
2253         
2254     }
2255 
2256     function withdrawStuckETh() external onlyOwner{
2257         require (address(this).balance > 0, "Can't withdraw negative or zero");
2258         payable(owner()).transfer(address(this).balance);
2259     }
2260 
2261     function removeBoughtEarly(address account) external onlyOwner {
2262         boughtEarly[account] = false;
2263         emit RemovedSniper(account);
2264     }
2265 
2266     function removeStuckToken(address _address) external onlyOwner {
2267         require(_address != address(this), "Can't withdraw tokens destined for liquidity");
2268         require(IERC20(_address).balanceOf(address(this)) > 0, "Can't withdraw 0");
2269 
2270         IERC20(_address).transfer(owner(), IERC20(_address).balanceOf(address(this)));
2271     }
2272     
2273 }