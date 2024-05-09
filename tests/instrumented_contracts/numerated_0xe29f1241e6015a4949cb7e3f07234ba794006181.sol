1 // File: contracts/IUniswapV2Router01.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 
8 
9 interface IUniswapV2Router01 {
10 
11     function factory() external pure returns (address);
12 
13     function WETH() external pure returns (address);
14 
15  
16 
17     function addLiquidity(
18 
19         address tokenA,
20 
21         address tokenB,
22 
23         uint amountADesired,
24 
25         uint amountBDesired,
26 
27         uint amountAMin,
28 
29         uint amountBMin,
30 
31         address to,
32 
33         uint deadline
34 
35     ) external returns (uint amountA, uint amountB, uint liquidity);
36 
37     function addLiquidityETH(
38 
39         address token,
40 
41         uint amountTokenDesired,
42 
43         uint amountTokenMin,
44 
45         uint amountETHMin,
46 
47         address to,
48 
49         uint deadline
50 
51     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
52 
53     function removeLiquidity(
54 
55         address tokenA,
56 
57         address tokenB,
58 
59         uint liquidity,
60 
61         uint amountAMin,
62 
63         uint amountBMin,
64 
65         address to,
66 
67         uint deadline
68 
69     ) external returns (uint amountA, uint amountB);
70 
71     function removeLiquidityETH(
72 
73         address token,
74 
75         uint liquidity,
76 
77         uint amountTokenMin,
78 
79         uint amountETHMin,
80 
81         address to,
82 
83         uint deadline
84 
85     ) external returns (uint amountToken, uint amountETH);
86 
87     function removeLiquidityWithPermit(
88 
89         address tokenA,
90 
91         address tokenB,
92 
93         uint liquidity,
94 
95         uint amountAMin,
96 
97         uint amountBMin,
98 
99         address to,
100 
101         uint deadline,
102 
103         bool approveMax, uint8 v, bytes32 r, bytes32 s
104 
105     ) external returns (uint amountA, uint amountB);
106 
107     function removeLiquidityETHWithPermit(
108 
109         address token,
110 
111         uint liquidity,
112 
113         uint amountTokenMin,
114 
115         uint amountETHMin,
116 
117         address to,
118 
119         uint deadline,
120 
121         bool approveMax, uint8 v, bytes32 r, bytes32 s
122 
123     ) external returns (uint amountToken, uint amountETH);
124 
125     function swapExactTokensForTokens(
126 
127         uint amountIn,
128 
129         uint amountOutMin,
130 
131         address[] calldata path,
132 
133         address to,
134 
135         uint deadline
136 
137     ) external returns (uint[] memory amounts);
138 
139     function swapTokensForExactTokens(
140 
141         uint amountOut,
142 
143         uint amountInMax,
144 
145         address[] calldata path,
146 
147         address to,
148 
149         uint deadline
150 
151     ) external returns (uint[] memory amounts);
152 
153     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
154 
155         external
156 
157         payable
158 
159         returns (uint[] memory amounts);
160 
161     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
162 
163         external
164 
165         returns (uint[] memory amounts);
166 
167     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
168 
169         external
170 
171         returns (uint[] memory amounts);
172 
173     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
174 
175         external
176 
177         payable
178 
179         returns (uint[] memory amounts);
180 
181  
182 
183     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
184 
185     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
186 
187     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
188 
189     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
190 
191     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
192 
193 }
194 // File: contracts/IUniswapV2Router02.sol
195 
196 
197 
198 pragma solidity ^0.8.0;
199 
200 
201 
202 
203 interface IUniswapV2Router02 is IUniswapV2Router01 {
204 
205     function removeLiquidityETHSupportingFeeOnTransferTokens(
206 
207         address token,
208 
209         uint liquidity,
210 
211         uint amountTokenMin,
212 
213         uint amountETHMin,
214 
215         address to,
216 
217         uint deadline
218 
219     ) external returns (uint amountETH);
220 
221     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
222 
223         address token,
224 
225         uint liquidity,
226 
227         uint amountTokenMin,
228 
229         uint amountETHMin,
230 
231         address to,
232 
233         uint deadline,
234 
235         bool approveMax, uint8 v, bytes32 r, bytes32 s
236 
237     ) external returns (uint amountETH);
238 
239  
240 
241     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
242 
243         uint amountIn,
244 
245         uint amountOutMin,
246 
247         address[] calldata path,
248 
249         address to,
250 
251         uint deadline
252 
253     ) external;
254 
255     function swapExactETHForTokensSupportingFeeOnTransferTokens(
256 
257         uint amountOutMin,
258 
259         address[] calldata path,
260 
261         address to,
262 
263         uint deadline
264 
265     ) external payable;
266 
267     function swapExactTokensForETHSupportingFeeOnTransferTokens(
268 
269         uint amountIn,
270 
271         uint amountOutMin,
272 
273         address[] calldata path,
274 
275         address to,
276 
277         uint deadline
278 
279     ) external;
280 
281 }
282 // File: contracts/IUniswapV2Factory.sol
283 
284 
285 
286 pragma solidity 0.8.13;
287 
288 
289 
290 interface IUniswapV2Factory {
291 
292     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
293 
294 
295 
296     function feeTo() external view returns (address);
297 
298     function feeToSetter() external view returns (address);
299 
300 
301 
302     function getPair(address tokenA, address tokenB) external view returns (address pair);
303 
304     function allPairs(uint) external view returns (address pair);
305 
306     function allPairsLength() external view returns (uint);
307 
308 
309 
310     function createPair(address tokenA, address tokenB) external returns (address pair);
311 
312 
313 
314     function setFeeTo(address) external;
315 
316     function setFeeToSetter(address) external;
317 
318 }
319 
320 
321 // File: @openzeppelin/contracts/utils/math/SafeCast.sol
322 
323 
324 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SafeCast.sol)
325 // This file was procedurally generated from scripts/generate/templates/SafeCast.js.
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
331  * checks.
332  *
333  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
334  * easily result in undesired exploitation or bugs, since developers usually
335  * assume that overflows raise errors. `SafeCast` restores this intuition by
336  * reverting the transaction when such an operation overflows.
337  *
338  * Using this library instead of the unchecked operations eliminates an entire
339  * class of bugs, so it's recommended to use it always.
340  *
341  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
342  * all math on `uint256` and `int256` and then downcasting.
343  */
344 library SafeCast {
345     /**
346      * @dev Returns the downcasted uint248 from uint256, reverting on
347      * overflow (when the input is greater than largest uint248).
348      *
349      * Counterpart to Solidity's `uint248` operator.
350      *
351      * Requirements:
352      *
353      * - input must fit into 248 bits
354      *
355      * _Available since v4.7._
356      */
357     function toUint248(uint256 value) internal pure returns (uint248) {
358         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
359         return uint248(value);
360     }
361 
362     /**
363      * @dev Returns the downcasted uint240 from uint256, reverting on
364      * overflow (when the input is greater than largest uint240).
365      *
366      * Counterpart to Solidity's `uint240` operator.
367      *
368      * Requirements:
369      *
370      * - input must fit into 240 bits
371      *
372      * _Available since v4.7._
373      */
374     function toUint240(uint256 value) internal pure returns (uint240) {
375         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
376         return uint240(value);
377     }
378 
379     /**
380      * @dev Returns the downcasted uint232 from uint256, reverting on
381      * overflow (when the input is greater than largest uint232).
382      *
383      * Counterpart to Solidity's `uint232` operator.
384      *
385      * Requirements:
386      *
387      * - input must fit into 232 bits
388      *
389      * _Available since v4.7._
390      */
391     function toUint232(uint256 value) internal pure returns (uint232) {
392         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
393         return uint232(value);
394     }
395 
396     /**
397      * @dev Returns the downcasted uint224 from uint256, reverting on
398      * overflow (when the input is greater than largest uint224).
399      *
400      * Counterpart to Solidity's `uint224` operator.
401      *
402      * Requirements:
403      *
404      * - input must fit into 224 bits
405      *
406      * _Available since v4.2._
407      */
408     function toUint224(uint256 value) internal pure returns (uint224) {
409         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
410         return uint224(value);
411     }
412 
413     /**
414      * @dev Returns the downcasted uint216 from uint256, reverting on
415      * overflow (when the input is greater than largest uint216).
416      *
417      * Counterpart to Solidity's `uint216` operator.
418      *
419      * Requirements:
420      *
421      * - input must fit into 216 bits
422      *
423      * _Available since v4.7._
424      */
425     function toUint216(uint256 value) internal pure returns (uint216) {
426         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
427         return uint216(value);
428     }
429 
430     /**
431      * @dev Returns the downcasted uint208 from uint256, reverting on
432      * overflow (when the input is greater than largest uint208).
433      *
434      * Counterpart to Solidity's `uint208` operator.
435      *
436      * Requirements:
437      *
438      * - input must fit into 208 bits
439      *
440      * _Available since v4.7._
441      */
442     function toUint208(uint256 value) internal pure returns (uint208) {
443         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
444         return uint208(value);
445     }
446 
447     /**
448      * @dev Returns the downcasted uint200 from uint256, reverting on
449      * overflow (when the input is greater than largest uint200).
450      *
451      * Counterpart to Solidity's `uint200` operator.
452      *
453      * Requirements:
454      *
455      * - input must fit into 200 bits
456      *
457      * _Available since v4.7._
458      */
459     function toUint200(uint256 value) internal pure returns (uint200) {
460         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
461         return uint200(value);
462     }
463 
464     /**
465      * @dev Returns the downcasted uint192 from uint256, reverting on
466      * overflow (when the input is greater than largest uint192).
467      *
468      * Counterpart to Solidity's `uint192` operator.
469      *
470      * Requirements:
471      *
472      * - input must fit into 192 bits
473      *
474      * _Available since v4.7._
475      */
476     function toUint192(uint256 value) internal pure returns (uint192) {
477         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
478         return uint192(value);
479     }
480 
481     /**
482      * @dev Returns the downcasted uint184 from uint256, reverting on
483      * overflow (when the input is greater than largest uint184).
484      *
485      * Counterpart to Solidity's `uint184` operator.
486      *
487      * Requirements:
488      *
489      * - input must fit into 184 bits
490      *
491      * _Available since v4.7._
492      */
493     function toUint184(uint256 value) internal pure returns (uint184) {
494         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
495         return uint184(value);
496     }
497 
498     /**
499      * @dev Returns the downcasted uint176 from uint256, reverting on
500      * overflow (when the input is greater than largest uint176).
501      *
502      * Counterpart to Solidity's `uint176` operator.
503      *
504      * Requirements:
505      *
506      * - input must fit into 176 bits
507      *
508      * _Available since v4.7._
509      */
510     function toUint176(uint256 value) internal pure returns (uint176) {
511         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
512         return uint176(value);
513     }
514 
515     /**
516      * @dev Returns the downcasted uint168 from uint256, reverting on
517      * overflow (when the input is greater than largest uint168).
518      *
519      * Counterpart to Solidity's `uint168` operator.
520      *
521      * Requirements:
522      *
523      * - input must fit into 168 bits
524      *
525      * _Available since v4.7._
526      */
527     function toUint168(uint256 value) internal pure returns (uint168) {
528         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
529         return uint168(value);
530     }
531 
532     /**
533      * @dev Returns the downcasted uint160 from uint256, reverting on
534      * overflow (when the input is greater than largest uint160).
535      *
536      * Counterpart to Solidity's `uint160` operator.
537      *
538      * Requirements:
539      *
540      * - input must fit into 160 bits
541      *
542      * _Available since v4.7._
543      */
544     function toUint160(uint256 value) internal pure returns (uint160) {
545         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
546         return uint160(value);
547     }
548 
549     /**
550      * @dev Returns the downcasted uint152 from uint256, reverting on
551      * overflow (when the input is greater than largest uint152).
552      *
553      * Counterpart to Solidity's `uint152` operator.
554      *
555      * Requirements:
556      *
557      * - input must fit into 152 bits
558      *
559      * _Available since v4.7._
560      */
561     function toUint152(uint256 value) internal pure returns (uint152) {
562         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
563         return uint152(value);
564     }
565 
566     /**
567      * @dev Returns the downcasted uint144 from uint256, reverting on
568      * overflow (when the input is greater than largest uint144).
569      *
570      * Counterpart to Solidity's `uint144` operator.
571      *
572      * Requirements:
573      *
574      * - input must fit into 144 bits
575      *
576      * _Available since v4.7._
577      */
578     function toUint144(uint256 value) internal pure returns (uint144) {
579         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
580         return uint144(value);
581     }
582 
583     /**
584      * @dev Returns the downcasted uint136 from uint256, reverting on
585      * overflow (when the input is greater than largest uint136).
586      *
587      * Counterpart to Solidity's `uint136` operator.
588      *
589      * Requirements:
590      *
591      * - input must fit into 136 bits
592      *
593      * _Available since v4.7._
594      */
595     function toUint136(uint256 value) internal pure returns (uint136) {
596         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
597         return uint136(value);
598     }
599 
600     /**
601      * @dev Returns the downcasted uint128 from uint256, reverting on
602      * overflow (when the input is greater than largest uint128).
603      *
604      * Counterpart to Solidity's `uint128` operator.
605      *
606      * Requirements:
607      *
608      * - input must fit into 128 bits
609      *
610      * _Available since v2.5._
611      */
612     function toUint128(uint256 value) internal pure returns (uint128) {
613         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
614         return uint128(value);
615     }
616 
617     /**
618      * @dev Returns the downcasted uint120 from uint256, reverting on
619      * overflow (when the input is greater than largest uint120).
620      *
621      * Counterpart to Solidity's `uint120` operator.
622      *
623      * Requirements:
624      *
625      * - input must fit into 120 bits
626      *
627      * _Available since v4.7._
628      */
629     function toUint120(uint256 value) internal pure returns (uint120) {
630         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
631         return uint120(value);
632     }
633 
634     /**
635      * @dev Returns the downcasted uint112 from uint256, reverting on
636      * overflow (when the input is greater than largest uint112).
637      *
638      * Counterpart to Solidity's `uint112` operator.
639      *
640      * Requirements:
641      *
642      * - input must fit into 112 bits
643      *
644      * _Available since v4.7._
645      */
646     function toUint112(uint256 value) internal pure returns (uint112) {
647         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
648         return uint112(value);
649     }
650 
651     /**
652      * @dev Returns the downcasted uint104 from uint256, reverting on
653      * overflow (when the input is greater than largest uint104).
654      *
655      * Counterpart to Solidity's `uint104` operator.
656      *
657      * Requirements:
658      *
659      * - input must fit into 104 bits
660      *
661      * _Available since v4.7._
662      */
663     function toUint104(uint256 value) internal pure returns (uint104) {
664         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
665         return uint104(value);
666     }
667 
668     /**
669      * @dev Returns the downcasted uint96 from uint256, reverting on
670      * overflow (when the input is greater than largest uint96).
671      *
672      * Counterpart to Solidity's `uint96` operator.
673      *
674      * Requirements:
675      *
676      * - input must fit into 96 bits
677      *
678      * _Available since v4.2._
679      */
680     function toUint96(uint256 value) internal pure returns (uint96) {
681         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
682         return uint96(value);
683     }
684 
685     /**
686      * @dev Returns the downcasted uint88 from uint256, reverting on
687      * overflow (when the input is greater than largest uint88).
688      *
689      * Counterpart to Solidity's `uint88` operator.
690      *
691      * Requirements:
692      *
693      * - input must fit into 88 bits
694      *
695      * _Available since v4.7._
696      */
697     function toUint88(uint256 value) internal pure returns (uint88) {
698         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
699         return uint88(value);
700     }
701 
702     /**
703      * @dev Returns the downcasted uint80 from uint256, reverting on
704      * overflow (when the input is greater than largest uint80).
705      *
706      * Counterpart to Solidity's `uint80` operator.
707      *
708      * Requirements:
709      *
710      * - input must fit into 80 bits
711      *
712      * _Available since v4.7._
713      */
714     function toUint80(uint256 value) internal pure returns (uint80) {
715         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
716         return uint80(value);
717     }
718 
719     /**
720      * @dev Returns the downcasted uint72 from uint256, reverting on
721      * overflow (when the input is greater than largest uint72).
722      *
723      * Counterpart to Solidity's `uint72` operator.
724      *
725      * Requirements:
726      *
727      * - input must fit into 72 bits
728      *
729      * _Available since v4.7._
730      */
731     function toUint72(uint256 value) internal pure returns (uint72) {
732         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
733         return uint72(value);
734     }
735 
736     /**
737      * @dev Returns the downcasted uint64 from uint256, reverting on
738      * overflow (when the input is greater than largest uint64).
739      *
740      * Counterpart to Solidity's `uint64` operator.
741      *
742      * Requirements:
743      *
744      * - input must fit into 64 bits
745      *
746      * _Available since v2.5._
747      */
748     function toUint64(uint256 value) internal pure returns (uint64) {
749         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
750         return uint64(value);
751     }
752 
753     /**
754      * @dev Returns the downcasted uint56 from uint256, reverting on
755      * overflow (when the input is greater than largest uint56).
756      *
757      * Counterpart to Solidity's `uint56` operator.
758      *
759      * Requirements:
760      *
761      * - input must fit into 56 bits
762      *
763      * _Available since v4.7._
764      */
765     function toUint56(uint256 value) internal pure returns (uint56) {
766         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
767         return uint56(value);
768     }
769 
770     /**
771      * @dev Returns the downcasted uint48 from uint256, reverting on
772      * overflow (when the input is greater than largest uint48).
773      *
774      * Counterpart to Solidity's `uint48` operator.
775      *
776      * Requirements:
777      *
778      * - input must fit into 48 bits
779      *
780      * _Available since v4.7._
781      */
782     function toUint48(uint256 value) internal pure returns (uint48) {
783         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
784         return uint48(value);
785     }
786 
787     /**
788      * @dev Returns the downcasted uint40 from uint256, reverting on
789      * overflow (when the input is greater than largest uint40).
790      *
791      * Counterpart to Solidity's `uint40` operator.
792      *
793      * Requirements:
794      *
795      * - input must fit into 40 bits
796      *
797      * _Available since v4.7._
798      */
799     function toUint40(uint256 value) internal pure returns (uint40) {
800         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
801         return uint40(value);
802     }
803 
804     /**
805      * @dev Returns the downcasted uint32 from uint256, reverting on
806      * overflow (when the input is greater than largest uint32).
807      *
808      * Counterpart to Solidity's `uint32` operator.
809      *
810      * Requirements:
811      *
812      * - input must fit into 32 bits
813      *
814      * _Available since v2.5._
815      */
816     function toUint32(uint256 value) internal pure returns (uint32) {
817         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
818         return uint32(value);
819     }
820 
821     /**
822      * @dev Returns the downcasted uint24 from uint256, reverting on
823      * overflow (when the input is greater than largest uint24).
824      *
825      * Counterpart to Solidity's `uint24` operator.
826      *
827      * Requirements:
828      *
829      * - input must fit into 24 bits
830      *
831      * _Available since v4.7._
832      */
833     function toUint24(uint256 value) internal pure returns (uint24) {
834         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
835         return uint24(value);
836     }
837 
838     /**
839      * @dev Returns the downcasted uint16 from uint256, reverting on
840      * overflow (when the input is greater than largest uint16).
841      *
842      * Counterpart to Solidity's `uint16` operator.
843      *
844      * Requirements:
845      *
846      * - input must fit into 16 bits
847      *
848      * _Available since v2.5._
849      */
850     function toUint16(uint256 value) internal pure returns (uint16) {
851         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
852         return uint16(value);
853     }
854 
855     /**
856      * @dev Returns the downcasted uint8 from uint256, reverting on
857      * overflow (when the input is greater than largest uint8).
858      *
859      * Counterpart to Solidity's `uint8` operator.
860      *
861      * Requirements:
862      *
863      * - input must fit into 8 bits
864      *
865      * _Available since v2.5._
866      */
867     function toUint8(uint256 value) internal pure returns (uint8) {
868         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
869         return uint8(value);
870     }
871 
872     /**
873      * @dev Converts a signed int256 into an unsigned uint256.
874      *
875      * Requirements:
876      *
877      * - input must be greater than or equal to 0.
878      *
879      * _Available since v3.0._
880      */
881     function toUint256(int256 value) internal pure returns (uint256) {
882         require(value >= 0, "SafeCast: value must be positive");
883         return uint256(value);
884     }
885 
886     /**
887      * @dev Returns the downcasted int248 from int256, reverting on
888      * overflow (when the input is less than smallest int248 or
889      * greater than largest int248).
890      *
891      * Counterpart to Solidity's `int248` operator.
892      *
893      * Requirements:
894      *
895      * - input must fit into 248 bits
896      *
897      * _Available since v4.7._
898      */
899     function toInt248(int256 value) internal pure returns (int248 downcasted) {
900         downcasted = int248(value);
901         require(downcasted == value, "SafeCast: value doesn't fit in 248 bits");
902     }
903 
904     /**
905      * @dev Returns the downcasted int240 from int256, reverting on
906      * overflow (when the input is less than smallest int240 or
907      * greater than largest int240).
908      *
909      * Counterpart to Solidity's `int240` operator.
910      *
911      * Requirements:
912      *
913      * - input must fit into 240 bits
914      *
915      * _Available since v4.7._
916      */
917     function toInt240(int256 value) internal pure returns (int240 downcasted) {
918         downcasted = int240(value);
919         require(downcasted == value, "SafeCast: value doesn't fit in 240 bits");
920     }
921 
922     /**
923      * @dev Returns the downcasted int232 from int256, reverting on
924      * overflow (when the input is less than smallest int232 or
925      * greater than largest int232).
926      *
927      * Counterpart to Solidity's `int232` operator.
928      *
929      * Requirements:
930      *
931      * - input must fit into 232 bits
932      *
933      * _Available since v4.7._
934      */
935     function toInt232(int256 value) internal pure returns (int232 downcasted) {
936         downcasted = int232(value);
937         require(downcasted == value, "SafeCast: value doesn't fit in 232 bits");
938     }
939 
940     /**
941      * @dev Returns the downcasted int224 from int256, reverting on
942      * overflow (when the input is less than smallest int224 or
943      * greater than largest int224).
944      *
945      * Counterpart to Solidity's `int224` operator.
946      *
947      * Requirements:
948      *
949      * - input must fit into 224 bits
950      *
951      * _Available since v4.7._
952      */
953     function toInt224(int256 value) internal pure returns (int224 downcasted) {
954         downcasted = int224(value);
955         require(downcasted == value, "SafeCast: value doesn't fit in 224 bits");
956     }
957 
958     /**
959      * @dev Returns the downcasted int216 from int256, reverting on
960      * overflow (when the input is less than smallest int216 or
961      * greater than largest int216).
962      *
963      * Counterpart to Solidity's `int216` operator.
964      *
965      * Requirements:
966      *
967      * - input must fit into 216 bits
968      *
969      * _Available since v4.7._
970      */
971     function toInt216(int256 value) internal pure returns (int216 downcasted) {
972         downcasted = int216(value);
973         require(downcasted == value, "SafeCast: value doesn't fit in 216 bits");
974     }
975 
976     /**
977      * @dev Returns the downcasted int208 from int256, reverting on
978      * overflow (when the input is less than smallest int208 or
979      * greater than largest int208).
980      *
981      * Counterpart to Solidity's `int208` operator.
982      *
983      * Requirements:
984      *
985      * - input must fit into 208 bits
986      *
987      * _Available since v4.7._
988      */
989     function toInt208(int256 value) internal pure returns (int208 downcasted) {
990         downcasted = int208(value);
991         require(downcasted == value, "SafeCast: value doesn't fit in 208 bits");
992     }
993 
994     /**
995      * @dev Returns the downcasted int200 from int256, reverting on
996      * overflow (when the input is less than smallest int200 or
997      * greater than largest int200).
998      *
999      * Counterpart to Solidity's `int200` operator.
1000      *
1001      * Requirements:
1002      *
1003      * - input must fit into 200 bits
1004      *
1005      * _Available since v4.7._
1006      */
1007     function toInt200(int256 value) internal pure returns (int200 downcasted) {
1008         downcasted = int200(value);
1009         require(downcasted == value, "SafeCast: value doesn't fit in 200 bits");
1010     }
1011 
1012     /**
1013      * @dev Returns the downcasted int192 from int256, reverting on
1014      * overflow (when the input is less than smallest int192 or
1015      * greater than largest int192).
1016      *
1017      * Counterpart to Solidity's `int192` operator.
1018      *
1019      * Requirements:
1020      *
1021      * - input must fit into 192 bits
1022      *
1023      * _Available since v4.7._
1024      */
1025     function toInt192(int256 value) internal pure returns (int192 downcasted) {
1026         downcasted = int192(value);
1027         require(downcasted == value, "SafeCast: value doesn't fit in 192 bits");
1028     }
1029 
1030     /**
1031      * @dev Returns the downcasted int184 from int256, reverting on
1032      * overflow (when the input is less than smallest int184 or
1033      * greater than largest int184).
1034      *
1035      * Counterpart to Solidity's `int184` operator.
1036      *
1037      * Requirements:
1038      *
1039      * - input must fit into 184 bits
1040      *
1041      * _Available since v4.7._
1042      */
1043     function toInt184(int256 value) internal pure returns (int184 downcasted) {
1044         downcasted = int184(value);
1045         require(downcasted == value, "SafeCast: value doesn't fit in 184 bits");
1046     }
1047 
1048     /**
1049      * @dev Returns the downcasted int176 from int256, reverting on
1050      * overflow (when the input is less than smallest int176 or
1051      * greater than largest int176).
1052      *
1053      * Counterpart to Solidity's `int176` operator.
1054      *
1055      * Requirements:
1056      *
1057      * - input must fit into 176 bits
1058      *
1059      * _Available since v4.7._
1060      */
1061     function toInt176(int256 value) internal pure returns (int176 downcasted) {
1062         downcasted = int176(value);
1063         require(downcasted == value, "SafeCast: value doesn't fit in 176 bits");
1064     }
1065 
1066     /**
1067      * @dev Returns the downcasted int168 from int256, reverting on
1068      * overflow (when the input is less than smallest int168 or
1069      * greater than largest int168).
1070      *
1071      * Counterpart to Solidity's `int168` operator.
1072      *
1073      * Requirements:
1074      *
1075      * - input must fit into 168 bits
1076      *
1077      * _Available since v4.7._
1078      */
1079     function toInt168(int256 value) internal pure returns (int168 downcasted) {
1080         downcasted = int168(value);
1081         require(downcasted == value, "SafeCast: value doesn't fit in 168 bits");
1082     }
1083 
1084     /**
1085      * @dev Returns the downcasted int160 from int256, reverting on
1086      * overflow (when the input is less than smallest int160 or
1087      * greater than largest int160).
1088      *
1089      * Counterpart to Solidity's `int160` operator.
1090      *
1091      * Requirements:
1092      *
1093      * - input must fit into 160 bits
1094      *
1095      * _Available since v4.7._
1096      */
1097     function toInt160(int256 value) internal pure returns (int160 downcasted) {
1098         downcasted = int160(value);
1099         require(downcasted == value, "SafeCast: value doesn't fit in 160 bits");
1100     }
1101 
1102     /**
1103      * @dev Returns the downcasted int152 from int256, reverting on
1104      * overflow (when the input is less than smallest int152 or
1105      * greater than largest int152).
1106      *
1107      * Counterpart to Solidity's `int152` operator.
1108      *
1109      * Requirements:
1110      *
1111      * - input must fit into 152 bits
1112      *
1113      * _Available since v4.7._
1114      */
1115     function toInt152(int256 value) internal pure returns (int152 downcasted) {
1116         downcasted = int152(value);
1117         require(downcasted == value, "SafeCast: value doesn't fit in 152 bits");
1118     }
1119 
1120     /**
1121      * @dev Returns the downcasted int144 from int256, reverting on
1122      * overflow (when the input is less than smallest int144 or
1123      * greater than largest int144).
1124      *
1125      * Counterpart to Solidity's `int144` operator.
1126      *
1127      * Requirements:
1128      *
1129      * - input must fit into 144 bits
1130      *
1131      * _Available since v4.7._
1132      */
1133     function toInt144(int256 value) internal pure returns (int144 downcasted) {
1134         downcasted = int144(value);
1135         require(downcasted == value, "SafeCast: value doesn't fit in 144 bits");
1136     }
1137 
1138     /**
1139      * @dev Returns the downcasted int136 from int256, reverting on
1140      * overflow (when the input is less than smallest int136 or
1141      * greater than largest int136).
1142      *
1143      * Counterpart to Solidity's `int136` operator.
1144      *
1145      * Requirements:
1146      *
1147      * - input must fit into 136 bits
1148      *
1149      * _Available since v4.7._
1150      */
1151     function toInt136(int256 value) internal pure returns (int136 downcasted) {
1152         downcasted = int136(value);
1153         require(downcasted == value, "SafeCast: value doesn't fit in 136 bits");
1154     }
1155 
1156     /**
1157      * @dev Returns the downcasted int128 from int256, reverting on
1158      * overflow (when the input is less than smallest int128 or
1159      * greater than largest int128).
1160      *
1161      * Counterpart to Solidity's `int128` operator.
1162      *
1163      * Requirements:
1164      *
1165      * - input must fit into 128 bits
1166      *
1167      * _Available since v3.1._
1168      */
1169     function toInt128(int256 value) internal pure returns (int128 downcasted) {
1170         downcasted = int128(value);
1171         require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
1172     }
1173 
1174     /**
1175      * @dev Returns the downcasted int120 from int256, reverting on
1176      * overflow (when the input is less than smallest int120 or
1177      * greater than largest int120).
1178      *
1179      * Counterpart to Solidity's `int120` operator.
1180      *
1181      * Requirements:
1182      *
1183      * - input must fit into 120 bits
1184      *
1185      * _Available since v4.7._
1186      */
1187     function toInt120(int256 value) internal pure returns (int120 downcasted) {
1188         downcasted = int120(value);
1189         require(downcasted == value, "SafeCast: value doesn't fit in 120 bits");
1190     }
1191 
1192     /**
1193      * @dev Returns the downcasted int112 from int256, reverting on
1194      * overflow (when the input is less than smallest int112 or
1195      * greater than largest int112).
1196      *
1197      * Counterpart to Solidity's `int112` operator.
1198      *
1199      * Requirements:
1200      *
1201      * - input must fit into 112 bits
1202      *
1203      * _Available since v4.7._
1204      */
1205     function toInt112(int256 value) internal pure returns (int112 downcasted) {
1206         downcasted = int112(value);
1207         require(downcasted == value, "SafeCast: value doesn't fit in 112 bits");
1208     }
1209 
1210     /**
1211      * @dev Returns the downcasted int104 from int256, reverting on
1212      * overflow (when the input is less than smallest int104 or
1213      * greater than largest int104).
1214      *
1215      * Counterpart to Solidity's `int104` operator.
1216      *
1217      * Requirements:
1218      *
1219      * - input must fit into 104 bits
1220      *
1221      * _Available since v4.7._
1222      */
1223     function toInt104(int256 value) internal pure returns (int104 downcasted) {
1224         downcasted = int104(value);
1225         require(downcasted == value, "SafeCast: value doesn't fit in 104 bits");
1226     }
1227 
1228     /**
1229      * @dev Returns the downcasted int96 from int256, reverting on
1230      * overflow (when the input is less than smallest int96 or
1231      * greater than largest int96).
1232      *
1233      * Counterpart to Solidity's `int96` operator.
1234      *
1235      * Requirements:
1236      *
1237      * - input must fit into 96 bits
1238      *
1239      * _Available since v4.7._
1240      */
1241     function toInt96(int256 value) internal pure returns (int96 downcasted) {
1242         downcasted = int96(value);
1243         require(downcasted == value, "SafeCast: value doesn't fit in 96 bits");
1244     }
1245 
1246     /**
1247      * @dev Returns the downcasted int88 from int256, reverting on
1248      * overflow (when the input is less than smallest int88 or
1249      * greater than largest int88).
1250      *
1251      * Counterpart to Solidity's `int88` operator.
1252      *
1253      * Requirements:
1254      *
1255      * - input must fit into 88 bits
1256      *
1257      * _Available since v4.7._
1258      */
1259     function toInt88(int256 value) internal pure returns (int88 downcasted) {
1260         downcasted = int88(value);
1261         require(downcasted == value, "SafeCast: value doesn't fit in 88 bits");
1262     }
1263 
1264     /**
1265      * @dev Returns the downcasted int80 from int256, reverting on
1266      * overflow (when the input is less than smallest int80 or
1267      * greater than largest int80).
1268      *
1269      * Counterpart to Solidity's `int80` operator.
1270      *
1271      * Requirements:
1272      *
1273      * - input must fit into 80 bits
1274      *
1275      * _Available since v4.7._
1276      */
1277     function toInt80(int256 value) internal pure returns (int80 downcasted) {
1278         downcasted = int80(value);
1279         require(downcasted == value, "SafeCast: value doesn't fit in 80 bits");
1280     }
1281 
1282     /**
1283      * @dev Returns the downcasted int72 from int256, reverting on
1284      * overflow (when the input is less than smallest int72 or
1285      * greater than largest int72).
1286      *
1287      * Counterpart to Solidity's `int72` operator.
1288      *
1289      * Requirements:
1290      *
1291      * - input must fit into 72 bits
1292      *
1293      * _Available since v4.7._
1294      */
1295     function toInt72(int256 value) internal pure returns (int72 downcasted) {
1296         downcasted = int72(value);
1297         require(downcasted == value, "SafeCast: value doesn't fit in 72 bits");
1298     }
1299 
1300     /**
1301      * @dev Returns the downcasted int64 from int256, reverting on
1302      * overflow (when the input is less than smallest int64 or
1303      * greater than largest int64).
1304      *
1305      * Counterpart to Solidity's `int64` operator.
1306      *
1307      * Requirements:
1308      *
1309      * - input must fit into 64 bits
1310      *
1311      * _Available since v3.1._
1312      */
1313     function toInt64(int256 value) internal pure returns (int64 downcasted) {
1314         downcasted = int64(value);
1315         require(downcasted == value, "SafeCast: value doesn't fit in 64 bits");
1316     }
1317 
1318     /**
1319      * @dev Returns the downcasted int56 from int256, reverting on
1320      * overflow (when the input is less than smallest int56 or
1321      * greater than largest int56).
1322      *
1323      * Counterpart to Solidity's `int56` operator.
1324      *
1325      * Requirements:
1326      *
1327      * - input must fit into 56 bits
1328      *
1329      * _Available since v4.7._
1330      */
1331     function toInt56(int256 value) internal pure returns (int56 downcasted) {
1332         downcasted = int56(value);
1333         require(downcasted == value, "SafeCast: value doesn't fit in 56 bits");
1334     }
1335 
1336     /**
1337      * @dev Returns the downcasted int48 from int256, reverting on
1338      * overflow (when the input is less than smallest int48 or
1339      * greater than largest int48).
1340      *
1341      * Counterpart to Solidity's `int48` operator.
1342      *
1343      * Requirements:
1344      *
1345      * - input must fit into 48 bits
1346      *
1347      * _Available since v4.7._
1348      */
1349     function toInt48(int256 value) internal pure returns (int48 downcasted) {
1350         downcasted = int48(value);
1351         require(downcasted == value, "SafeCast: value doesn't fit in 48 bits");
1352     }
1353 
1354     /**
1355      * @dev Returns the downcasted int40 from int256, reverting on
1356      * overflow (when the input is less than smallest int40 or
1357      * greater than largest int40).
1358      *
1359      * Counterpart to Solidity's `int40` operator.
1360      *
1361      * Requirements:
1362      *
1363      * - input must fit into 40 bits
1364      *
1365      * _Available since v4.7._
1366      */
1367     function toInt40(int256 value) internal pure returns (int40 downcasted) {
1368         downcasted = int40(value);
1369         require(downcasted == value, "SafeCast: value doesn't fit in 40 bits");
1370     }
1371 
1372     /**
1373      * @dev Returns the downcasted int32 from int256, reverting on
1374      * overflow (when the input is less than smallest int32 or
1375      * greater than largest int32).
1376      *
1377      * Counterpart to Solidity's `int32` operator.
1378      *
1379      * Requirements:
1380      *
1381      * - input must fit into 32 bits
1382      *
1383      * _Available since v3.1._
1384      */
1385     function toInt32(int256 value) internal pure returns (int32 downcasted) {
1386         downcasted = int32(value);
1387         require(downcasted == value, "SafeCast: value doesn't fit in 32 bits");
1388     }
1389 
1390     /**
1391      * @dev Returns the downcasted int24 from int256, reverting on
1392      * overflow (when the input is less than smallest int24 or
1393      * greater than largest int24).
1394      *
1395      * Counterpart to Solidity's `int24` operator.
1396      *
1397      * Requirements:
1398      *
1399      * - input must fit into 24 bits
1400      *
1401      * _Available since v4.7._
1402      */
1403     function toInt24(int256 value) internal pure returns (int24 downcasted) {
1404         downcasted = int24(value);
1405         require(downcasted == value, "SafeCast: value doesn't fit in 24 bits");
1406     }
1407 
1408     /**
1409      * @dev Returns the downcasted int16 from int256, reverting on
1410      * overflow (when the input is less than smallest int16 or
1411      * greater than largest int16).
1412      *
1413      * Counterpart to Solidity's `int16` operator.
1414      *
1415      * Requirements:
1416      *
1417      * - input must fit into 16 bits
1418      *
1419      * _Available since v3.1._
1420      */
1421     function toInt16(int256 value) internal pure returns (int16 downcasted) {
1422         downcasted = int16(value);
1423         require(downcasted == value, "SafeCast: value doesn't fit in 16 bits");
1424     }
1425 
1426     /**
1427      * @dev Returns the downcasted int8 from int256, reverting on
1428      * overflow (when the input is less than smallest int8 or
1429      * greater than largest int8).
1430      *
1431      * Counterpart to Solidity's `int8` operator.
1432      *
1433      * Requirements:
1434      *
1435      * - input must fit into 8 bits
1436      *
1437      * _Available since v3.1._
1438      */
1439     function toInt8(int256 value) internal pure returns (int8 downcasted) {
1440         downcasted = int8(value);
1441         require(downcasted == value, "SafeCast: value doesn't fit in 8 bits");
1442     }
1443 
1444     /**
1445      * @dev Converts an unsigned uint256 into a signed int256.
1446      *
1447      * Requirements:
1448      *
1449      * - input must be less than or equal to maxInt256.
1450      *
1451      * _Available since v3.0._
1452      */
1453     function toInt256(uint256 value) internal pure returns (int256) {
1454         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1455         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1456         return int256(value);
1457     }
1458 }
1459 
1460 // File: @openzeppelin/contracts/governance/utils/IVotes.sol
1461 
1462 
1463 // OpenZeppelin Contracts (last updated v4.5.0) (governance/utils/IVotes.sol)
1464 pragma solidity ^0.8.0;
1465 
1466 /**
1467  * @dev Common interface for {ERC20Votes}, {ERC721Votes}, and other {Votes}-enabled contracts.
1468  *
1469  * _Available since v4.5._
1470  */
1471 interface IVotes {
1472     /**
1473      * @dev Emitted when an account changes their delegate.
1474      */
1475     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1476 
1477     /**
1478      * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
1479      */
1480     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1481 
1482     /**
1483      * @dev Returns the current amount of votes that `account` has.
1484      */
1485     function getVotes(address account) external view returns (uint256);
1486 
1487     /**
1488      * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
1489      */
1490     function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
1491 
1492     /**
1493      * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
1494      *
1495      * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
1496      * Votes that have not been delegated are still part of total supply, even though they would not participate in a
1497      * vote.
1498      */
1499     function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
1500 
1501     /**
1502      * @dev Returns the delegate that `account` has chosen.
1503      */
1504     function delegates(address account) external view returns (address);
1505 
1506     /**
1507      * @dev Delegates votes from the sender to `delegatee`.
1508      */
1509     function delegate(address delegatee) external;
1510 
1511     /**
1512      * @dev Delegates votes from signer to `delegatee`.
1513      */
1514     function delegateBySig(
1515         address delegatee,
1516         uint256 nonce,
1517         uint256 expiry,
1518         uint8 v,
1519         bytes32 r,
1520         bytes32 s
1521     ) external;
1522 }
1523 
1524 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
1525 
1526 
1527 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1528 
1529 pragma solidity ^0.8.0;
1530 
1531 /**
1532  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1533  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1534  *
1535  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1536  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1537  * need to send a transaction, and thus is not required to hold Ether at all.
1538  */
1539 interface IERC20Permit {
1540     /**
1541      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1542      * given ``owner``'s signed approval.
1543      *
1544      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1545      * ordering also apply here.
1546      *
1547      * Emits an {Approval} event.
1548      *
1549      * Requirements:
1550      *
1551      * - `spender` cannot be the zero address.
1552      * - `deadline` must be a timestamp in the future.
1553      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1554      * over the EIP712-formatted function arguments.
1555      * - the signature must use ``owner``'s current nonce (see {nonces}).
1556      *
1557      * For more information on the signature format, see the
1558      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1559      * section].
1560      */
1561     function permit(
1562         address owner,
1563         address spender,
1564         uint256 value,
1565         uint256 deadline,
1566         uint8 v,
1567         bytes32 r,
1568         bytes32 s
1569     ) external;
1570 
1571     /**
1572      * @dev Returns the current nonce for `owner`. This value must be
1573      * included whenever a signature is generated for {permit}.
1574      *
1575      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1576      * prevents a signature from being used multiple times.
1577      */
1578     function nonces(address owner) external view returns (uint256);
1579 
1580     /**
1581      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1582      */
1583     // solhint-disable-next-line func-name-mixedcase
1584     function DOMAIN_SEPARATOR() external view returns (bytes32);
1585 }
1586 
1587 // File: @openzeppelin/contracts/utils/Counters.sol
1588 
1589 
1590 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1591 
1592 pragma solidity ^0.8.0;
1593 
1594 /**
1595  * @title Counters
1596  * @author Matt Condon (@shrugs)
1597  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1598  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1599  *
1600  * Include with `using Counters for Counters.Counter;`
1601  */
1602 library Counters {
1603     struct Counter {
1604         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1605         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1606         // this feature: see https://github.com/ethereum/solidity/issues/4637
1607         uint256 _value; // default: 0
1608     }
1609 
1610     function current(Counter storage counter) internal view returns (uint256) {
1611         return counter._value;
1612     }
1613 
1614     function increment(Counter storage counter) internal {
1615         unchecked {
1616             counter._value += 1;
1617         }
1618     }
1619 
1620     function decrement(Counter storage counter) internal {
1621         uint256 value = counter._value;
1622         require(value > 0, "Counter: decrement overflow");
1623         unchecked {
1624             counter._value = value - 1;
1625         }
1626     }
1627 
1628     function reset(Counter storage counter) internal {
1629         counter._value = 0;
1630     }
1631 }
1632 
1633 // File: @openzeppelin/contracts/utils/math/Math.sol
1634 
1635 
1636 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1637 
1638 pragma solidity ^0.8.0;
1639 
1640 /**
1641  * @dev Standard math utilities missing in the Solidity language.
1642  */
1643 library Math {
1644     enum Rounding {
1645         Down, // Toward negative infinity
1646         Up, // Toward infinity
1647         Zero // Toward zero
1648     }
1649 
1650     /**
1651      * @dev Returns the largest of two numbers.
1652      */
1653     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1654         return a > b ? a : b;
1655     }
1656 
1657     /**
1658      * @dev Returns the smallest of two numbers.
1659      */
1660     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1661         return a < b ? a : b;
1662     }
1663 
1664     /**
1665      * @dev Returns the average of two numbers. The result is rounded towards
1666      * zero.
1667      */
1668     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1669         // (a + b) / 2 can overflow.
1670         return (a & b) + (a ^ b) / 2;
1671     }
1672 
1673     /**
1674      * @dev Returns the ceiling of the division of two numbers.
1675      *
1676      * This differs from standard division with `/` in that it rounds up instead
1677      * of rounding down.
1678      */
1679     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1680         // (a + b - 1) / b can overflow on addition, so we distribute.
1681         return a == 0 ? 0 : (a - 1) / b + 1;
1682     }
1683 
1684     /**
1685      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1686      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1687      * with further edits by Uniswap Labs also under MIT license.
1688      */
1689     function mulDiv(
1690         uint256 x,
1691         uint256 y,
1692         uint256 denominator
1693     ) internal pure returns (uint256 result) {
1694         unchecked {
1695             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1696             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1697             // variables such that product = prod1 * 2^256 + prod0.
1698             uint256 prod0; // Least significant 256 bits of the product
1699             uint256 prod1; // Most significant 256 bits of the product
1700             assembly {
1701                 let mm := mulmod(x, y, not(0))
1702                 prod0 := mul(x, y)
1703                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1704             }
1705 
1706             // Handle non-overflow cases, 256 by 256 division.
1707             if (prod1 == 0) {
1708                 return prod0 / denominator;
1709             }
1710 
1711             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1712             require(denominator > prod1);
1713 
1714             ///////////////////////////////////////////////
1715             // 512 by 256 division.
1716             ///////////////////////////////////////////////
1717 
1718             // Make division exact by subtracting the remainder from [prod1 prod0].
1719             uint256 remainder;
1720             assembly {
1721                 // Compute remainder using mulmod.
1722                 remainder := mulmod(x, y, denominator)
1723 
1724                 // Subtract 256 bit number from 512 bit number.
1725                 prod1 := sub(prod1, gt(remainder, prod0))
1726                 prod0 := sub(prod0, remainder)
1727             }
1728 
1729             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1730             // See https://cs.stackexchange.com/q/138556/92363.
1731 
1732             // Does not overflow because the denominator cannot be zero at this stage in the function.
1733             uint256 twos = denominator & (~denominator + 1);
1734             assembly {
1735                 // Divide denominator by twos.
1736                 denominator := div(denominator, twos)
1737 
1738                 // Divide [prod1 prod0] by twos.
1739                 prod0 := div(prod0, twos)
1740 
1741                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1742                 twos := add(div(sub(0, twos), twos), 1)
1743             }
1744 
1745             // Shift in bits from prod1 into prod0.
1746             prod0 |= prod1 * twos;
1747 
1748             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1749             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1750             // four bits. That is, denominator * inv = 1 mod 2^4.
1751             uint256 inverse = (3 * denominator) ^ 2;
1752 
1753             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1754             // in modular arithmetic, doubling the correct bits in each step.
1755             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1756             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1757             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1758             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1759             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1760             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1761 
1762             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1763             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1764             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1765             // is no longer required.
1766             result = prod0 * inverse;
1767             return result;
1768         }
1769     }
1770 
1771     /**
1772      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1773      */
1774     function mulDiv(
1775         uint256 x,
1776         uint256 y,
1777         uint256 denominator,
1778         Rounding rounding
1779     ) internal pure returns (uint256) {
1780         uint256 result = mulDiv(x, y, denominator);
1781         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1782             result += 1;
1783         }
1784         return result;
1785     }
1786 
1787     /**
1788      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1789      *
1790      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1791      */
1792     function sqrt(uint256 a) internal pure returns (uint256) {
1793         if (a == 0) {
1794             return 0;
1795         }
1796 
1797         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1798         //
1799         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1800         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1801         //
1802         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1803         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1804         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1805         //
1806         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1807         uint256 result = 1 << (log2(a) >> 1);
1808 
1809         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1810         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1811         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1812         // into the expected uint128 result.
1813         unchecked {
1814             result = (result + a / result) >> 1;
1815             result = (result + a / result) >> 1;
1816             result = (result + a / result) >> 1;
1817             result = (result + a / result) >> 1;
1818             result = (result + a / result) >> 1;
1819             result = (result + a / result) >> 1;
1820             result = (result + a / result) >> 1;
1821             return min(result, a / result);
1822         }
1823     }
1824 
1825     /**
1826      * @notice Calculates sqrt(a), following the selected rounding direction.
1827      */
1828     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1829         unchecked {
1830             uint256 result = sqrt(a);
1831             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1832         }
1833     }
1834 
1835     /**
1836      * @dev Return the log in base 2, rounded down, of a positive value.
1837      * Returns 0 if given 0.
1838      */
1839     function log2(uint256 value) internal pure returns (uint256) {
1840         uint256 result = 0;
1841         unchecked {
1842             if (value >> 128 > 0) {
1843                 value >>= 128;
1844                 result += 128;
1845             }
1846             if (value >> 64 > 0) {
1847                 value >>= 64;
1848                 result += 64;
1849             }
1850             if (value >> 32 > 0) {
1851                 value >>= 32;
1852                 result += 32;
1853             }
1854             if (value >> 16 > 0) {
1855                 value >>= 16;
1856                 result += 16;
1857             }
1858             if (value >> 8 > 0) {
1859                 value >>= 8;
1860                 result += 8;
1861             }
1862             if (value >> 4 > 0) {
1863                 value >>= 4;
1864                 result += 4;
1865             }
1866             if (value >> 2 > 0) {
1867                 value >>= 2;
1868                 result += 2;
1869             }
1870             if (value >> 1 > 0) {
1871                 result += 1;
1872             }
1873         }
1874         return result;
1875     }
1876 
1877     /**
1878      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1879      * Returns 0 if given 0.
1880      */
1881     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1882         unchecked {
1883             uint256 result = log2(value);
1884             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1885         }
1886     }
1887 
1888     /**
1889      * @dev Return the log in base 10, rounded down, of a positive value.
1890      * Returns 0 if given 0.
1891      */
1892     function log10(uint256 value) internal pure returns (uint256) {
1893         uint256 result = 0;
1894         unchecked {
1895             if (value >= 10**64) {
1896                 value /= 10**64;
1897                 result += 64;
1898             }
1899             if (value >= 10**32) {
1900                 value /= 10**32;
1901                 result += 32;
1902             }
1903             if (value >= 10**16) {
1904                 value /= 10**16;
1905                 result += 16;
1906             }
1907             if (value >= 10**8) {
1908                 value /= 10**8;
1909                 result += 8;
1910             }
1911             if (value >= 10**4) {
1912                 value /= 10**4;
1913                 result += 4;
1914             }
1915             if (value >= 10**2) {
1916                 value /= 10**2;
1917                 result += 2;
1918             }
1919             if (value >= 10**1) {
1920                 result += 1;
1921             }
1922         }
1923         return result;
1924     }
1925 
1926     /**
1927      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1928      * Returns 0 if given 0.
1929      */
1930     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1931         unchecked {
1932             uint256 result = log10(value);
1933             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1934         }
1935     }
1936 
1937     /**
1938      * @dev Return the log in base 256, rounded down, of a positive value.
1939      * Returns 0 if given 0.
1940      *
1941      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1942      */
1943     function log256(uint256 value) internal pure returns (uint256) {
1944         uint256 result = 0;
1945         unchecked {
1946             if (value >> 128 > 0) {
1947                 value >>= 128;
1948                 result += 16;
1949             }
1950             if (value >> 64 > 0) {
1951                 value >>= 64;
1952                 result += 8;
1953             }
1954             if (value >> 32 > 0) {
1955                 value >>= 32;
1956                 result += 4;
1957             }
1958             if (value >> 16 > 0) {
1959                 value >>= 16;
1960                 result += 2;
1961             }
1962             if (value >> 8 > 0) {
1963                 result += 1;
1964             }
1965         }
1966         return result;
1967     }
1968 
1969     /**
1970      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1971      * Returns 0 if given 0.
1972      */
1973     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1974         unchecked {
1975             uint256 result = log256(value);
1976             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1977         }
1978     }
1979 }
1980 
1981 // File: @openzeppelin/contracts/utils/Strings.sol
1982 
1983 
1984 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1985 
1986 pragma solidity ^0.8.0;
1987 
1988 
1989 /**
1990  * @dev String operations.
1991  */
1992 library Strings {
1993     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1994     uint8 private constant _ADDRESS_LENGTH = 20;
1995 
1996     /**
1997      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1998      */
1999     function toString(uint256 value) internal pure returns (string memory) {
2000         unchecked {
2001             uint256 length = Math.log10(value) + 1;
2002             string memory buffer = new string(length);
2003             uint256 ptr;
2004             /// @solidity memory-safe-assembly
2005             assembly {
2006                 ptr := add(buffer, add(32, length))
2007             }
2008             while (true) {
2009                 ptr--;
2010                 /// @solidity memory-safe-assembly
2011                 assembly {
2012                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2013                 }
2014                 value /= 10;
2015                 if (value == 0) break;
2016             }
2017             return buffer;
2018         }
2019     }
2020 
2021     /**
2022      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2023      */
2024     function toHexString(uint256 value) internal pure returns (string memory) {
2025         unchecked {
2026             return toHexString(value, Math.log256(value) + 1);
2027         }
2028     }
2029 
2030     /**
2031      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2032      */
2033     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2034         bytes memory buffer = new bytes(2 * length + 2);
2035         buffer[0] = "0";
2036         buffer[1] = "x";
2037         for (uint256 i = 2 * length + 1; i > 1; --i) {
2038             buffer[i] = _SYMBOLS[value & 0xf];
2039             value >>= 4;
2040         }
2041         require(value == 0, "Strings: hex length insufficient");
2042         return string(buffer);
2043     }
2044 
2045     /**
2046      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2047      */
2048     function toHexString(address addr) internal pure returns (string memory) {
2049         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2050     }
2051 }
2052 
2053 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2054 
2055 
2056 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
2057 
2058 pragma solidity ^0.8.0;
2059 
2060 
2061 /**
2062  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2063  *
2064  * These functions can be used to verify that a message was signed by the holder
2065  * of the private keys of a given address.
2066  */
2067 library ECDSA {
2068     enum RecoverError {
2069         NoError,
2070         InvalidSignature,
2071         InvalidSignatureLength,
2072         InvalidSignatureS,
2073         InvalidSignatureV // Deprecated in v4.8
2074     }
2075 
2076     function _throwError(RecoverError error) private pure {
2077         if (error == RecoverError.NoError) {
2078             return; // no error: do nothing
2079         } else if (error == RecoverError.InvalidSignature) {
2080             revert("ECDSA: invalid signature");
2081         } else if (error == RecoverError.InvalidSignatureLength) {
2082             revert("ECDSA: invalid signature length");
2083         } else if (error == RecoverError.InvalidSignatureS) {
2084             revert("ECDSA: invalid signature 's' value");
2085         }
2086     }
2087 
2088     /**
2089      * @dev Returns the address that signed a hashed message (`hash`) with
2090      * `signature` or error string. This address can then be used for verification purposes.
2091      *
2092      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2093      * this function rejects them by requiring the `s` value to be in the lower
2094      * half order, and the `v` value to be either 27 or 28.
2095      *
2096      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2097      * verification to be secure: it is possible to craft signatures that
2098      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2099      * this is by receiving a hash of the original message (which may otherwise
2100      * be too long), and then calling {toEthSignedMessageHash} on it.
2101      *
2102      * Documentation for signature generation:
2103      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2104      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2105      *
2106      * _Available since v4.3._
2107      */
2108     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
2109         if (signature.length == 65) {
2110             bytes32 r;
2111             bytes32 s;
2112             uint8 v;
2113             // ecrecover takes the signature parameters, and the only way to get them
2114             // currently is to use assembly.
2115             /// @solidity memory-safe-assembly
2116             assembly {
2117                 r := mload(add(signature, 0x20))
2118                 s := mload(add(signature, 0x40))
2119                 v := byte(0, mload(add(signature, 0x60)))
2120             }
2121             return tryRecover(hash, v, r, s);
2122         } else {
2123             return (address(0), RecoverError.InvalidSignatureLength);
2124         }
2125     }
2126 
2127     /**
2128      * @dev Returns the address that signed a hashed message (`hash`) with
2129      * `signature`. This address can then be used for verification purposes.
2130      *
2131      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2132      * this function rejects them by requiring the `s` value to be in the lower
2133      * half order, and the `v` value to be either 27 or 28.
2134      *
2135      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2136      * verification to be secure: it is possible to craft signatures that
2137      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2138      * this is by receiving a hash of the original message (which may otherwise
2139      * be too long), and then calling {toEthSignedMessageHash} on it.
2140      */
2141     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2142         (address recovered, RecoverError error) = tryRecover(hash, signature);
2143         _throwError(error);
2144         return recovered;
2145     }
2146 
2147     /**
2148      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2149      *
2150      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2151      *
2152      * _Available since v4.3._
2153      */
2154     function tryRecover(
2155         bytes32 hash,
2156         bytes32 r,
2157         bytes32 vs
2158     ) internal pure returns (address, RecoverError) {
2159         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2160         uint8 v = uint8((uint256(vs) >> 255) + 27);
2161         return tryRecover(hash, v, r, s);
2162     }
2163 
2164     /**
2165      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2166      *
2167      * _Available since v4.2._
2168      */
2169     function recover(
2170         bytes32 hash,
2171         bytes32 r,
2172         bytes32 vs
2173     ) internal pure returns (address) {
2174         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2175         _throwError(error);
2176         return recovered;
2177     }
2178 
2179     /**
2180      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2181      * `r` and `s` signature fields separately.
2182      *
2183      * _Available since v4.3._
2184      */
2185     function tryRecover(
2186         bytes32 hash,
2187         uint8 v,
2188         bytes32 r,
2189         bytes32 s
2190     ) internal pure returns (address, RecoverError) {
2191         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2192         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2193         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2194         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2195         //
2196         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2197         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2198         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2199         // these malleable signatures as well.
2200         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2201             return (address(0), RecoverError.InvalidSignatureS);
2202         }
2203 
2204         // If the signature is valid (and not malleable), return the signer address
2205         address signer = ecrecover(hash, v, r, s);
2206         if (signer == address(0)) {
2207             return (address(0), RecoverError.InvalidSignature);
2208         }
2209 
2210         return (signer, RecoverError.NoError);
2211     }
2212 
2213     /**
2214      * @dev Overload of {ECDSA-recover} that receives the `v`,
2215      * `r` and `s` signature fields separately.
2216      */
2217     function recover(
2218         bytes32 hash,
2219         uint8 v,
2220         bytes32 r,
2221         bytes32 s
2222     ) internal pure returns (address) {
2223         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2224         _throwError(error);
2225         return recovered;
2226     }
2227 
2228     /**
2229      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2230      * produces hash corresponding to the one signed with the
2231      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2232      * JSON-RPC method as part of EIP-191.
2233      *
2234      * See {recover}.
2235      */
2236     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2237         // 32 is the length in bytes of hash,
2238         // enforced by the type signature above
2239         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2240     }
2241 
2242     /**
2243      * @dev Returns an Ethereum Signed Message, created from `s`. This
2244      * produces hash corresponding to the one signed with the
2245      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2246      * JSON-RPC method as part of EIP-191.
2247      *
2248      * See {recover}.
2249      */
2250     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2251         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2252     }
2253 
2254     /**
2255      * @dev Returns an Ethereum Signed Typed Data, created from a
2256      * `domainSeparator` and a `structHash`. This produces hash corresponding
2257      * to the one signed with the
2258      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2259      * JSON-RPC method as part of EIP-712.
2260      *
2261      * See {recover}.
2262      */
2263     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2264         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2265     }
2266 }
2267 
2268 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
2269 
2270 
2271 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
2272 
2273 pragma solidity ^0.8.0;
2274 
2275 
2276 /**
2277  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
2278  *
2279  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
2280  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
2281  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
2282  *
2283  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
2284  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
2285  * ({_hashTypedDataV4}).
2286  *
2287  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
2288  * the chain id to protect against replay attacks on an eventual fork of the chain.
2289  *
2290  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
2291  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
2292  *
2293  * _Available since v3.4._
2294  */
2295 abstract contract EIP712 {
2296     /* solhint-disable var-name-mixedcase */
2297     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
2298     // invalidate the cached domain separator if the chain id changes.
2299     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
2300     uint256 private immutable _CACHED_CHAIN_ID;
2301     address private immutable _CACHED_THIS;
2302 
2303     bytes32 private immutable _HASHED_NAME;
2304     bytes32 private immutable _HASHED_VERSION;
2305     bytes32 private immutable _TYPE_HASH;
2306 
2307     /* solhint-enable var-name-mixedcase */
2308 
2309     /**
2310      * @dev Initializes the domain separator and parameter caches.
2311      *
2312      * The meaning of `name` and `version` is specified in
2313      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
2314      *
2315      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
2316      * - `version`: the current major version of the signing domain.
2317      *
2318      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
2319      * contract upgrade].
2320      */
2321     constructor(string memory name, string memory version) {
2322         bytes32 hashedName = keccak256(bytes(name));
2323         bytes32 hashedVersion = keccak256(bytes(version));
2324         bytes32 typeHash = keccak256(
2325             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
2326         );
2327         _HASHED_NAME = hashedName;
2328         _HASHED_VERSION = hashedVersion;
2329         _CACHED_CHAIN_ID = block.chainid;
2330         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
2331         _CACHED_THIS = address(this);
2332         _TYPE_HASH = typeHash;
2333     }
2334 
2335     /**
2336      * @dev Returns the domain separator for the current chain.
2337      */
2338     function _domainSeparatorV4() internal view returns (bytes32) {
2339         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
2340             return _CACHED_DOMAIN_SEPARATOR;
2341         } else {
2342             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
2343         }
2344     }
2345 
2346     function _buildDomainSeparator(
2347         bytes32 typeHash,
2348         bytes32 nameHash,
2349         bytes32 versionHash
2350     ) private view returns (bytes32) {
2351         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
2352     }
2353 
2354     /**
2355      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
2356      * function returns the hash of the fully encoded EIP712 message for this domain.
2357      *
2358      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
2359      *
2360      * ```solidity
2361      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
2362      *     keccak256("Mail(address to,string contents)"),
2363      *     mailTo,
2364      *     keccak256(bytes(mailContents))
2365      * )));
2366      * address signer = ECDSA.recover(digest, signature);
2367      * ```
2368      */
2369     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
2370         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
2371     }
2372 }
2373 
2374 // File: @openzeppelin/contracts/utils/StorageSlot.sol
2375 
2376 
2377 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
2378 
2379 pragma solidity ^0.8.0;
2380 
2381 /**
2382  * @dev Library for reading and writing primitive types to specific storage slots.
2383  *
2384  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
2385  * This library helps with reading and writing to such slots without the need for inline assembly.
2386  *
2387  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
2388  *
2389  * Example usage to set ERC1967 implementation slot:
2390  * ```
2391  * contract ERC1967 {
2392  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
2393  *
2394  *     function _getImplementation() internal view returns (address) {
2395  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
2396  *     }
2397  *
2398  *     function _setImplementation(address newImplementation) internal {
2399  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
2400  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
2401  *     }
2402  * }
2403  * ```
2404  *
2405  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
2406  */
2407 library StorageSlot {
2408     struct AddressSlot {
2409         address value;
2410     }
2411 
2412     struct BooleanSlot {
2413         bool value;
2414     }
2415 
2416     struct Bytes32Slot {
2417         bytes32 value;
2418     }
2419 
2420     struct Uint256Slot {
2421         uint256 value;
2422     }
2423 
2424     /**
2425      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
2426      */
2427     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
2428         /// @solidity memory-safe-assembly
2429         assembly {
2430             r.slot := slot
2431         }
2432     }
2433 
2434     /**
2435      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
2436      */
2437     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
2438         /// @solidity memory-safe-assembly
2439         assembly {
2440             r.slot := slot
2441         }
2442     }
2443 
2444     /**
2445      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
2446      */
2447     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
2448         /// @solidity memory-safe-assembly
2449         assembly {
2450             r.slot := slot
2451         }
2452     }
2453 
2454     /**
2455      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
2456      */
2457     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
2458         /// @solidity memory-safe-assembly
2459         assembly {
2460             r.slot := slot
2461         }
2462     }
2463 }
2464 
2465 // File: @openzeppelin/contracts/utils/Arrays.sol
2466 
2467 
2468 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Arrays.sol)
2469 
2470 pragma solidity ^0.8.0;
2471 
2472 
2473 
2474 /**
2475  * @dev Collection of functions related to array types.
2476  */
2477 library Arrays {
2478     using StorageSlot for bytes32;
2479 
2480     /**
2481      * @dev Searches a sorted `array` and returns the first index that contains
2482      * a value greater or equal to `element`. If no such index exists (i.e. all
2483      * values in the array are strictly less than `element`), the array length is
2484      * returned. Time complexity O(log n).
2485      *
2486      * `array` is expected to be sorted in ascending order, and to contain no
2487      * repeated elements.
2488      */
2489     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
2490         if (array.length == 0) {
2491             return 0;
2492         }
2493 
2494         uint256 low = 0;
2495         uint256 high = array.length;
2496 
2497         while (low < high) {
2498             uint256 mid = Math.average(low, high);
2499 
2500             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
2501             // because Math.average rounds down (it does integer division with truncation).
2502             if (unsafeAccess(array, mid).value > element) {
2503                 high = mid;
2504             } else {
2505                 low = mid + 1;
2506             }
2507         }
2508 
2509         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
2510         if (low > 0 && unsafeAccess(array, low - 1).value == element) {
2511             return low - 1;
2512         } else {
2513             return low;
2514         }
2515     }
2516 
2517     /**
2518      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
2519      *
2520      * WARNING: Only use if you are certain `pos` is lower than the array length.
2521      */
2522     function unsafeAccess(address[] storage arr, uint256 pos) internal pure returns (StorageSlot.AddressSlot storage) {
2523         bytes32 slot;
2524         /// @solidity memory-safe-assembly
2525         assembly {
2526             mstore(0, arr.slot)
2527             slot := add(keccak256(0, 0x20), pos)
2528         }
2529         return slot.getAddressSlot();
2530     }
2531 
2532     /**
2533      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
2534      *
2535      * WARNING: Only use if you are certain `pos` is lower than the array length.
2536      */
2537     function unsafeAccess(bytes32[] storage arr, uint256 pos) internal pure returns (StorageSlot.Bytes32Slot storage) {
2538         bytes32 slot;
2539         /// @solidity memory-safe-assembly
2540         assembly {
2541             mstore(0, arr.slot)
2542             slot := add(keccak256(0, 0x20), pos)
2543         }
2544         return slot.getBytes32Slot();
2545     }
2546 
2547     /**
2548      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
2549      *
2550      * WARNING: Only use if you are certain `pos` is lower than the array length.
2551      */
2552     function unsafeAccess(uint256[] storage arr, uint256 pos) internal pure returns (StorageSlot.Uint256Slot storage) {
2553         bytes32 slot;
2554         /// @solidity memory-safe-assembly
2555         assembly {
2556             mstore(0, arr.slot)
2557             slot := add(keccak256(0, 0x20), pos)
2558         }
2559         return slot.getUint256Slot();
2560     }
2561 }
2562 
2563 // File: @openzeppelin/contracts/utils/Context.sol
2564 
2565 
2566 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2567 
2568 pragma solidity ^0.8.0;
2569 
2570 /**
2571  * @dev Provides information about the current execution context, including the
2572  * sender of the transaction and its data. While these are generally available
2573  * via msg.sender and msg.data, they should not be accessed in such a direct
2574  * manner, since when dealing with meta-transactions the account sending and
2575  * paying for execution may not be the actual sender (as far as an application
2576  * is concerned).
2577  *
2578  * This contract is only required for intermediate, library-like contracts.
2579  */
2580 abstract contract Context {
2581     function _msgSender() internal view virtual returns (address) {
2582         return msg.sender;
2583     }
2584 
2585     function _msgData() internal view virtual returns (bytes calldata) {
2586         return msg.data;
2587     }
2588 }
2589 
2590 // File: @openzeppelin/contracts/access/Ownable.sol
2591 
2592 
2593 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2594 
2595 pragma solidity ^0.8.0;
2596 
2597 
2598 /**
2599  * @dev Contract module which provides a basic access control mechanism, where
2600  * there is an account (an owner) that can be granted exclusive access to
2601  * specific functions.
2602  *
2603  * By default, the owner account will be the one that deploys the contract. This
2604  * can later be changed with {transferOwnership}.
2605  *
2606  * This module is used through inheritance. It will make available the modifier
2607  * `onlyOwner`, which can be applied to your functions to restrict their use to
2608  * the owner.
2609  */
2610 abstract contract Ownable is Context {
2611     address private _owner;
2612 
2613     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2614 
2615     /**
2616      * @dev Initializes the contract setting the deployer as the initial owner.
2617      */
2618     constructor() {
2619         _transferOwnership(_msgSender());
2620     }
2621 
2622     /**
2623      * @dev Throws if called by any account other than the owner.
2624      */
2625     modifier onlyOwner() {
2626         _checkOwner();
2627         _;
2628     }
2629 
2630     /**
2631      * @dev Returns the address of the current owner.
2632      */
2633     function owner() public view virtual returns (address) {
2634         return _owner;
2635     }
2636 
2637     /**
2638      * @dev Throws if the sender is not the owner.
2639      */
2640     function _checkOwner() internal view virtual {
2641         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2642     }
2643 
2644     /**
2645      * @dev Leaves the contract without owner. It will not be possible to call
2646      * `onlyOwner` functions anymore. Can only be called by the current owner.
2647      *
2648      * NOTE: Renouncing ownership will leave the contract without an owner,
2649      * thereby removing any functionality that is only available to the owner.
2650      */
2651     function renounceOwnership() public virtual onlyOwner {
2652         _transferOwnership(address(0));
2653     }
2654 
2655     /**
2656      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2657      * Can only be called by the current owner.
2658      */
2659     function transferOwnership(address newOwner) public virtual onlyOwner {
2660         require(newOwner != address(0), "Ownable: new owner is the zero address");
2661         _transferOwnership(newOwner);
2662     }
2663 
2664     /**
2665      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2666      * Internal function without access restriction.
2667      */
2668     function _transferOwnership(address newOwner) internal virtual {
2669         address oldOwner = _owner;
2670         _owner = newOwner;
2671         emit OwnershipTransferred(oldOwner, newOwner);
2672     }
2673 }
2674 
2675 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2676 
2677 
2678 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2679 
2680 pragma solidity ^0.8.0;
2681 
2682 /**
2683  * @dev Interface of the ERC20 standard as defined in the EIP.
2684  */
2685 interface IERC20 {
2686     /**
2687      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2688      * another (`to`).
2689      *
2690      * Note that `value` may be zero.
2691      */
2692     event Transfer(address indexed from, address indexed to, uint256 value);
2693 
2694     /**
2695      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2696      * a call to {approve}. `value` is the new allowance.
2697      */
2698     event Approval(address indexed owner, address indexed spender, uint256 value);
2699 
2700     /**
2701      * @dev Returns the amount of tokens in existence.
2702      */
2703     function totalSupply() external view returns (uint256);
2704 
2705     /**
2706      * @dev Returns the amount of tokens owned by `account`.
2707      */
2708     function balanceOf(address account) external view returns (uint256);
2709 
2710     /**
2711      * @dev Moves `amount` tokens from the caller's account to `to`.
2712      *
2713      * Returns a boolean value indicating whether the operation succeeded.
2714      *
2715      * Emits a {Transfer} event.
2716      */
2717     function transfer(address to, uint256 amount) external returns (bool);
2718 
2719     /**
2720      * @dev Returns the remaining number of tokens that `spender` will be
2721      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2722      * zero by default.
2723      *
2724      * This value changes when {approve} or {transferFrom} are called.
2725      */
2726     function allowance(address owner, address spender) external view returns (uint256);
2727 
2728     /**
2729      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2730      *
2731      * Returns a boolean value indicating whether the operation succeeded.
2732      *
2733      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2734      * that someone may use both the old and the new allowance by unfortunate
2735      * transaction ordering. One possible solution to mitigate this race
2736      * condition is to first reduce the spender's allowance to 0 and set the
2737      * desired value afterwards:
2738      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2739      *
2740      * Emits an {Approval} event.
2741      */
2742     function approve(address spender, uint256 amount) external returns (bool);
2743 
2744     /**
2745      * @dev Moves `amount` tokens from `from` to `to` using the
2746      * allowance mechanism. `amount` is then deducted from the caller's
2747      * allowance.
2748      *
2749      * Returns a boolean value indicating whether the operation succeeded.
2750      *
2751      * Emits a {Transfer} event.
2752      */
2753     function transferFrom(
2754         address from,
2755         address to,
2756         uint256 amount
2757     ) external returns (bool);
2758 }
2759 
2760 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
2761 
2762 
2763 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
2764 
2765 pragma solidity ^0.8.0;
2766 
2767 
2768 /**
2769  * @dev Interface for the optional metadata functions from the ERC20 standard.
2770  *
2771  * _Available since v4.1._
2772  */
2773 interface IERC20Metadata is IERC20 {
2774     /**
2775      * @dev Returns the name of the token.
2776      */
2777     function name() external view returns (string memory);
2778 
2779     /**
2780      * @dev Returns the symbol of the token.
2781      */
2782     function symbol() external view returns (string memory);
2783 
2784     /**
2785      * @dev Returns the decimals places of the token.
2786      */
2787     function decimals() external view returns (uint8);
2788 }
2789 
2790 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
2791 
2792 
2793 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
2794 
2795 pragma solidity ^0.8.0;
2796 
2797 
2798 
2799 
2800 /**
2801  * @dev Implementation of the {IERC20} interface.
2802  *
2803  * This implementation is agnostic to the way tokens are created. This means
2804  * that a supply mechanism has to be added in a derived contract using {_mint}.
2805  * For a generic mechanism see {ERC20PresetMinterPauser}.
2806  *
2807  * TIP: For a detailed writeup see our guide
2808  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
2809  * to implement supply mechanisms].
2810  *
2811  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2812  * instead returning `false` on failure. This behavior is nonetheless
2813  * conventional and does not conflict with the expectations of ERC20
2814  * applications.
2815  *
2816  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2817  * This allows applications to reconstruct the allowance for all accounts just
2818  * by listening to said events. Other implementations of the EIP may not emit
2819  * these events, as it isn't required by the specification.
2820  *
2821  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2822  * functions have been added to mitigate the well-known issues around setting
2823  * allowances. See {IERC20-approve}.
2824  */
2825 contract ERC20 is Context, IERC20, IERC20Metadata {
2826     mapping(address => uint256) private _balances;
2827 
2828     mapping(address => mapping(address => uint256)) private _allowances;
2829 
2830     uint256 private _totalSupply;
2831 
2832     string private _name;
2833     string private _symbol;
2834 
2835     /**
2836      * @dev Sets the values for {name} and {symbol}.
2837      *
2838      * The default value of {decimals} is 18. To select a different value for
2839      * {decimals} you should overload it.
2840      *
2841      * All two of these values are immutable: they can only be set once during
2842      * construction.
2843      */
2844     constructor(string memory name_, string memory symbol_) {
2845         _name = name_;
2846         _symbol = symbol_;
2847     }
2848 
2849     /**
2850      * @dev Returns the name of the token.
2851      */
2852     function name() public view virtual override returns (string memory) {
2853         return _name;
2854     }
2855 
2856     /**
2857      * @dev Returns the symbol of the token, usually a shorter version of the
2858      * name.
2859      */
2860     function symbol() public view virtual override returns (string memory) {
2861         return _symbol;
2862     }
2863 
2864     /**
2865      * @dev Returns the number of decimals used to get its user representation.
2866      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2867      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2868      *
2869      * Tokens usually opt for a value of 18, imitating the relationship between
2870      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2871      * overridden;
2872      *
2873      * NOTE: This information is only used for _display_ purposes: it in
2874      * no way affects any of the arithmetic of the contract, including
2875      * {IERC20-balanceOf} and {IERC20-transfer}.
2876      */
2877     function decimals() public view virtual override returns (uint8) {
2878         return 18;
2879     }
2880 
2881     /**
2882      * @dev See {IERC20-totalSupply}.
2883      */
2884     function totalSupply() public view virtual override returns (uint256) {
2885         return _totalSupply;
2886     }
2887 
2888     /**
2889      * @dev See {IERC20-balanceOf}.
2890      */
2891     function balanceOf(address account) public view virtual override returns (uint256) {
2892         return _balances[account];
2893     }
2894 
2895     /**
2896      * @dev See {IERC20-transfer}.
2897      *
2898      * Requirements:
2899      *
2900      * - `to` cannot be the zero address.
2901      * - the caller must have a balance of at least `amount`.
2902      */
2903     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2904         address owner = _msgSender();
2905         _transfer(owner, to, amount);
2906         return true;
2907     }
2908 
2909     /**
2910      * @dev See {IERC20-allowance}.
2911      */
2912     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2913         return _allowances[owner][spender];
2914     }
2915 
2916     /**
2917      * @dev See {IERC20-approve}.
2918      *
2919      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2920      * `transferFrom`. This is semantically equivalent to an infinite approval.
2921      *
2922      * Requirements:
2923      *
2924      * - `spender` cannot be the zero address.
2925      */
2926     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2927         address owner = _msgSender();
2928         _approve(owner, spender, amount);
2929         return true;
2930     }
2931 
2932     /**
2933      * @dev See {IERC20-transferFrom}.
2934      *
2935      * Emits an {Approval} event indicating the updated allowance. This is not
2936      * required by the EIP. See the note at the beginning of {ERC20}.
2937      *
2938      * NOTE: Does not update the allowance if the current allowance
2939      * is the maximum `uint256`.
2940      *
2941      * Requirements:
2942      *
2943      * - `from` and `to` cannot be the zero address.
2944      * - `from` must have a balance of at least `amount`.
2945      * - the caller must have allowance for ``from``'s tokens of at least
2946      * `amount`.
2947      */
2948     function transferFrom(
2949         address from,
2950         address to,
2951         uint256 amount
2952     ) public virtual override returns (bool) {
2953         address spender = _msgSender();
2954         _spendAllowance(from, spender, amount);
2955         _transfer(from, to, amount);
2956         return true;
2957     }
2958 
2959     /**
2960      * @dev Atomically increases the allowance granted to `spender` by the caller.
2961      *
2962      * This is an alternative to {approve} that can be used as a mitigation for
2963      * problems described in {IERC20-approve}.
2964      *
2965      * Emits an {Approval} event indicating the updated allowance.
2966      *
2967      * Requirements:
2968      *
2969      * - `spender` cannot be the zero address.
2970      */
2971     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2972         address owner = _msgSender();
2973         _approve(owner, spender, allowance(owner, spender) + addedValue);
2974         return true;
2975     }
2976 
2977     /**
2978      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2979      *
2980      * This is an alternative to {approve} that can be used as a mitigation for
2981      * problems described in {IERC20-approve}.
2982      *
2983      * Emits an {Approval} event indicating the updated allowance.
2984      *
2985      * Requirements:
2986      *
2987      * - `spender` cannot be the zero address.
2988      * - `spender` must have allowance for the caller of at least
2989      * `subtractedValue`.
2990      */
2991     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2992         address owner = _msgSender();
2993         uint256 currentAllowance = allowance(owner, spender);
2994         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2995         unchecked {
2996             _approve(owner, spender, currentAllowance - subtractedValue);
2997         }
2998 
2999         return true;
3000     }
3001 
3002     /**
3003      * @dev Moves `amount` of tokens from `from` to `to`.
3004      *
3005      * This internal function is equivalent to {transfer}, and can be used to
3006      * e.g. implement automatic token fees, slashing mechanisms, etc.
3007      *
3008      * Emits a {Transfer} event.
3009      *
3010      * Requirements:
3011      *
3012      * - `from` cannot be the zero address.
3013      * - `to` cannot be the zero address.
3014      * - `from` must have a balance of at least `amount`.
3015      */
3016     function _transfer(
3017         address from,
3018         address to,
3019         uint256 amount
3020     ) internal virtual {
3021         require(from != address(0), "ERC20: transfer from the zero address");
3022         require(to != address(0), "ERC20: transfer to the zero address");
3023 
3024         _beforeTokenTransfer(from, to, amount);
3025 
3026         uint256 fromBalance = _balances[from];
3027         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
3028         unchecked {
3029             _balances[from] = fromBalance - amount;
3030             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
3031             // decrementing then incrementing.
3032             _balances[to] += amount;
3033         }
3034 
3035         emit Transfer(from, to, amount);
3036 
3037         _afterTokenTransfer(from, to, amount);
3038     }
3039 
3040     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
3041      * the total supply.
3042      *
3043      * Emits a {Transfer} event with `from` set to the zero address.
3044      *
3045      * Requirements:
3046      *
3047      * - `account` cannot be the zero address.
3048      */
3049     function _mint(address account, uint256 amount) internal virtual {
3050         require(account != address(0), "ERC20: mint to the zero address");
3051 
3052         _beforeTokenTransfer(address(0), account, amount);
3053 
3054         _totalSupply += amount;
3055         unchecked {
3056             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
3057             _balances[account] += amount;
3058         }
3059         emit Transfer(address(0), account, amount);
3060 
3061         _afterTokenTransfer(address(0), account, amount);
3062     }
3063 
3064     /**
3065      * @dev Destroys `amount` tokens from `account`, reducing the
3066      * total supply.
3067      *
3068      * Emits a {Transfer} event with `to` set to the zero address.
3069      *
3070      * Requirements:
3071      *
3072      * - `account` cannot be the zero address.
3073      * - `account` must have at least `amount` tokens.
3074      */
3075     function _burn(address account, uint256 amount) internal virtual {
3076         require(account != address(0), "ERC20: burn from the zero address");
3077 
3078         _beforeTokenTransfer(account, address(0), amount);
3079 
3080         uint256 accountBalance = _balances[account];
3081         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
3082         unchecked {
3083             _balances[account] = accountBalance - amount;
3084             // Overflow not possible: amount <= accountBalance <= totalSupply.
3085             _totalSupply -= amount;
3086         }
3087 
3088         emit Transfer(account, address(0), amount);
3089 
3090         _afterTokenTransfer(account, address(0), amount);
3091     }
3092 
3093     /**
3094      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
3095      *
3096      * This internal function is equivalent to `approve`, and can be used to
3097      * e.g. set automatic allowances for certain subsystems, etc.
3098      *
3099      * Emits an {Approval} event.
3100      *
3101      * Requirements:
3102      *
3103      * - `owner` cannot be the zero address.
3104      * - `spender` cannot be the zero address.
3105      */
3106     function _approve(
3107         address owner,
3108         address spender,
3109         uint256 amount
3110     ) internal virtual {
3111         require(owner != address(0), "ERC20: approve from the zero address");
3112         require(spender != address(0), "ERC20: approve to the zero address");
3113 
3114         _allowances[owner][spender] = amount;
3115         emit Approval(owner, spender, amount);
3116     }
3117 
3118     /**
3119      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
3120      *
3121      * Does not update the allowance amount in case of infinite allowance.
3122      * Revert if not enough allowance is available.
3123      *
3124      * Might emit an {Approval} event.
3125      */
3126     function _spendAllowance(
3127         address owner,
3128         address spender,
3129         uint256 amount
3130     ) internal virtual {
3131         uint256 currentAllowance = allowance(owner, spender);
3132         if (currentAllowance != type(uint256).max) {
3133             require(currentAllowance >= amount, "ERC20: insufficient allowance");
3134             unchecked {
3135                 _approve(owner, spender, currentAllowance - amount);
3136             }
3137         }
3138     }
3139 
3140     /**
3141      * @dev Hook that is called before any transfer of tokens. This includes
3142      * minting and burning.
3143      *
3144      * Calling conditions:
3145      *
3146      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3147      * will be transferred to `to`.
3148      * - when `from` is zero, `amount` tokens will be minted for `to`.
3149      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
3150      * - `from` and `to` are never both zero.
3151      *
3152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3153      */
3154     function _beforeTokenTransfer(
3155         address from,
3156         address to,
3157         uint256 amount
3158     ) internal virtual {}
3159 
3160     /**
3161      * @dev Hook that is called after any transfer of tokens. This includes
3162      * minting and burning.
3163      *
3164      * Calling conditions:
3165      *
3166      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3167      * has been transferred to `to`.
3168      * - when `from` is zero, `amount` tokens have been minted for `to`.
3169      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
3170      * - `from` and `to` are never both zero.
3171      *
3172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3173      */
3174     function _afterTokenTransfer(
3175         address from,
3176         address to,
3177         uint256 amount
3178     ) internal virtual {}
3179 }
3180 
3181 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
3182 
3183 
3184 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
3185 
3186 pragma solidity ^0.8.0;
3187 
3188 
3189 
3190 
3191 
3192 
3193 /**
3194  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
3195  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
3196  *
3197  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
3198  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
3199  * need to send a transaction, and thus is not required to hold Ether at all.
3200  *
3201  * _Available since v3.4._
3202  */
3203 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
3204     using Counters for Counters.Counter;
3205 
3206     mapping(address => Counters.Counter) private _nonces;
3207 
3208     // solhint-disable-next-line var-name-mixedcase
3209     bytes32 private constant _PERMIT_TYPEHASH =
3210         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
3211     /**
3212      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
3213      * However, to ensure consistency with the upgradeable transpiler, we will continue
3214      * to reserve a slot.
3215      * @custom:oz-renamed-from _PERMIT_TYPEHASH
3216      */
3217     // solhint-disable-next-line var-name-mixedcase
3218     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
3219 
3220     /**
3221      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
3222      *
3223      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
3224      */
3225     constructor(string memory name) EIP712(name, "1") {}
3226 
3227     /**
3228      * @dev See {IERC20Permit-permit}.
3229      */
3230     function permit(
3231         address owner,
3232         address spender,
3233         uint256 value,
3234         uint256 deadline,
3235         uint8 v,
3236         bytes32 r,
3237         bytes32 s
3238     ) public virtual override {
3239         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
3240 
3241         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
3242 
3243         bytes32 hash = _hashTypedDataV4(structHash);
3244 
3245         address signer = ECDSA.recover(hash, v, r, s);
3246         require(signer == owner, "ERC20Permit: invalid signature");
3247 
3248         _approve(owner, spender, value);
3249     }
3250 
3251     /**
3252      * @dev See {IERC20Permit-nonces}.
3253      */
3254     function nonces(address owner) public view virtual override returns (uint256) {
3255         return _nonces[owner].current();
3256     }
3257 
3258     /**
3259      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
3260      */
3261     // solhint-disable-next-line func-name-mixedcase
3262     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
3263         return _domainSeparatorV4();
3264     }
3265 
3266     /**
3267      * @dev "Consume a nonce": return the current value and increment.
3268      *
3269      * _Available since v4.1._
3270      */
3271     function _useNonce(address owner) internal virtual returns (uint256 current) {
3272         Counters.Counter storage nonce = _nonces[owner];
3273         current = nonce.current();
3274         nonce.increment();
3275     }
3276 }
3277 
3278 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol
3279 
3280 
3281 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/ERC20Votes.sol)
3282 
3283 pragma solidity ^0.8.0;
3284 
3285 
3286 
3287 
3288 
3289 
3290 /**
3291  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
3292  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
3293  *
3294  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
3295  *
3296  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
3297  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
3298  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
3299  *
3300  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
3301  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
3302  *
3303  * _Available since v4.2._
3304  */
3305 abstract contract ERC20Votes is IVotes, ERC20Permit {
3306     struct Checkpoint {
3307         uint32 fromBlock;
3308         uint224 votes;
3309     }
3310 
3311     bytes32 private constant _DELEGATION_TYPEHASH =
3312         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
3313 
3314     mapping(address => address) private _delegates;
3315     mapping(address => Checkpoint[]) private _checkpoints;
3316     Checkpoint[] private _totalSupplyCheckpoints;
3317 
3318     /**
3319      * @dev Get the `pos`-th checkpoint for `account`.
3320      */
3321     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
3322         return _checkpoints[account][pos];
3323     }
3324 
3325     /**
3326      * @dev Get number of checkpoints for `account`.
3327      */
3328     function numCheckpoints(address account) public view virtual returns (uint32) {
3329         return SafeCast.toUint32(_checkpoints[account].length);
3330     }
3331 
3332     /**
3333      * @dev Get the address `account` is currently delegating to.
3334      */
3335     function delegates(address account) public view virtual override returns (address) {
3336         return _delegates[account];
3337     }
3338 
3339     /**
3340      * @dev Gets the current votes balance for `account`
3341      */
3342     function getVotes(address account) public view virtual override returns (uint256) {
3343         uint256 pos = _checkpoints[account].length;
3344         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
3345     }
3346 
3347     /**
3348      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
3349      *
3350      * Requirements:
3351      *
3352      * - `blockNumber` must have been already mined
3353      */
3354     function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
3355         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
3356         return _checkpointsLookup(_checkpoints[account], blockNumber);
3357     }
3358 
3359     /**
3360      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
3361      * It is but NOT the sum of all the delegated votes!
3362      *
3363      * Requirements:
3364      *
3365      * - `blockNumber` must have been already mined
3366      */
3367     function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
3368         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
3369         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
3370     }
3371 
3372     /**
3373      * @dev Lookup a value in a list of (sorted) checkpoints.
3374      */
3375     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
3376         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
3377         //
3378         // Initially we check if the block is recent to narrow the search range.
3379         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
3380         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
3381         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
3382         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
3383         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
3384         // out of bounds (in which case we're looking too far in the past and the result is 0).
3385         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
3386         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
3387         // the same.
3388         uint256 length = ckpts.length;
3389 
3390         uint256 low = 0;
3391         uint256 high = length;
3392 
3393         if (length > 5) {
3394             uint256 mid = length - Math.sqrt(length);
3395             if (_unsafeAccess(ckpts, mid).fromBlock > blockNumber) {
3396                 high = mid;
3397             } else {
3398                 low = mid + 1;
3399             }
3400         }
3401 
3402         while (low < high) {
3403             uint256 mid = Math.average(low, high);
3404             if (_unsafeAccess(ckpts, mid).fromBlock > blockNumber) {
3405                 high = mid;
3406             } else {
3407                 low = mid + 1;
3408             }
3409         }
3410 
3411         return high == 0 ? 0 : _unsafeAccess(ckpts, high - 1).votes;
3412     }
3413 
3414     /**
3415      * @dev Delegate votes from the sender to `delegatee`.
3416      */
3417     function delegate(address delegatee) public virtual override {
3418         _delegate(_msgSender(), delegatee);
3419     }
3420 
3421     /**
3422      * @dev Delegates votes from signer to `delegatee`
3423      */
3424     function delegateBySig(
3425         address delegatee,
3426         uint256 nonce,
3427         uint256 expiry,
3428         uint8 v,
3429         bytes32 r,
3430         bytes32 s
3431     ) public virtual override {
3432         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
3433         address signer = ECDSA.recover(
3434             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
3435             v,
3436             r,
3437             s
3438         );
3439         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
3440         _delegate(signer, delegatee);
3441     }
3442 
3443     /**
3444      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
3445      */
3446     function _maxSupply() internal view virtual returns (uint224) {
3447         return type(uint224).max;
3448     }
3449 
3450     /**
3451      * @dev Snapshots the totalSupply after it has been increased.
3452      */
3453     function _mint(address account, uint256 amount) internal virtual override {
3454         super._mint(account, amount);
3455         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
3456 
3457         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
3458     }
3459 
3460     /**
3461      * @dev Snapshots the totalSupply after it has been decreased.
3462      */
3463     function _burn(address account, uint256 amount) internal virtual override {
3464         super._burn(account, amount);
3465 
3466         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
3467     }
3468 
3469     /**
3470      * @dev Move voting power when tokens are transferred.
3471      *
3472      * Emits a {IVotes-DelegateVotesChanged} event.
3473      */
3474     function _afterTokenTransfer(
3475         address from,
3476         address to,
3477         uint256 amount
3478     ) internal virtual override {
3479         super._afterTokenTransfer(from, to, amount);
3480 
3481         _moveVotingPower(delegates(from), delegates(to), amount);
3482     }
3483 
3484     /**
3485      * @dev Change delegation for `delegator` to `delegatee`.
3486      *
3487      * Emits events {IVotes-DelegateChanged} and {IVotes-DelegateVotesChanged}.
3488      */
3489     function _delegate(address delegator, address delegatee) internal virtual {
3490         address currentDelegate = delegates(delegator);
3491         uint256 delegatorBalance = balanceOf(delegator);
3492         _delegates[delegator] = delegatee;
3493 
3494         emit DelegateChanged(delegator, currentDelegate, delegatee);
3495 
3496         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
3497     }
3498 
3499     function _moveVotingPower(
3500         address src,
3501         address dst,
3502         uint256 amount
3503     ) private {
3504         if (src != dst && amount > 0) {
3505             if (src != address(0)) {
3506                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
3507                 emit DelegateVotesChanged(src, oldWeight, newWeight);
3508             }
3509 
3510             if (dst != address(0)) {
3511                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
3512                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
3513             }
3514         }
3515     }
3516 
3517     function _writeCheckpoint(
3518         Checkpoint[] storage ckpts,
3519         function(uint256, uint256) view returns (uint256) op,
3520         uint256 delta
3521     ) private returns (uint256 oldWeight, uint256 newWeight) {
3522         uint256 pos = ckpts.length;
3523 
3524         Checkpoint memory oldCkpt = pos == 0 ? Checkpoint(0, 0) : _unsafeAccess(ckpts, pos - 1);
3525 
3526         oldWeight = oldCkpt.votes;
3527         newWeight = op(oldWeight, delta);
3528 
3529         if (pos > 0 && oldCkpt.fromBlock == block.number) {
3530             _unsafeAccess(ckpts, pos - 1).votes = SafeCast.toUint224(newWeight);
3531         } else {
3532             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
3533         }
3534     }
3535 
3536     function _add(uint256 a, uint256 b) private pure returns (uint256) {
3537         return a + b;
3538     }
3539 
3540     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
3541         return a - b;
3542     }
3543 
3544     function _unsafeAccess(Checkpoint[] storage ckpts, uint256 pos) private pure returns (Checkpoint storage result) {
3545         assembly {
3546             mstore(0, ckpts.slot)
3547             result.slot := add(keccak256(0, 0x20), pos)
3548         }
3549     }
3550 }
3551 
3552 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol
3553 
3554 
3555 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/extensions/ERC20Snapshot.sol)
3556 
3557 pragma solidity ^0.8.0;
3558 
3559 
3560 
3561 
3562 /**
3563  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
3564  * total supply at the time are recorded for later access.
3565  *
3566  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
3567  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
3568  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
3569  * used to create an efficient ERC20 forking mechanism.
3570  *
3571  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
3572  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
3573  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
3574  * and the account address.
3575  *
3576  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
3577  * return `block.number` will trigger the creation of snapshot at the beginning of each new block. When overriding this
3578  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
3579  *
3580  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
3581  * alternative consider {ERC20Votes}.
3582  *
3583  * ==== Gas Costs
3584  *
3585  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
3586  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
3587  * smaller since identical balances in subsequent snapshots are stored as a single entry.
3588  *
3589  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
3590  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
3591  * transfers will have normal cost until the next snapshot, and so on.
3592  */
3593 
3594 abstract contract ERC20Snapshot is ERC20 {
3595     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
3596     // https://github.com/Giveth/minime/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
3597 
3598     using Arrays for uint256[];
3599     using Counters for Counters.Counter;
3600 
3601     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
3602     // Snapshot struct, but that would impede usage of functions that work on an array.
3603     struct Snapshots {
3604         uint256[] ids;
3605         uint256[] values;
3606     }
3607 
3608     mapping(address => Snapshots) private _accountBalanceSnapshots;
3609     Snapshots private _totalSupplySnapshots;
3610 
3611     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
3612     Counters.Counter private _currentSnapshotId;
3613 
3614     /**
3615      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
3616      */
3617     event Snapshot(uint256 id);
3618 
3619     /**
3620      * @dev Creates a new snapshot and returns its snapshot id.
3621      *
3622      * Emits a {Snapshot} event that contains the same id.
3623      *
3624      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
3625      * set of accounts, for example using {AccessControl}, or it may be open to the public.
3626      *
3627      * [WARNING]
3628      * ====
3629      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
3630      * you must consider that it can potentially be used by attackers in two ways.
3631      *
3632      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
3633      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
3634      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
3635      * section above.
3636      *
3637      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
3638      * ====
3639      */
3640     function _snapshot() internal virtual returns (uint256) {
3641         _currentSnapshotId.increment();
3642 
3643         uint256 currentId = _getCurrentSnapshotId();
3644         emit Snapshot(currentId);
3645         return currentId;
3646     }
3647 
3648     /**
3649      * @dev Get the current snapshotId
3650      */
3651     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
3652         return _currentSnapshotId.current();
3653     }
3654 
3655     /**
3656      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
3657      */
3658     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
3659         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
3660 
3661         return snapshotted ? value : balanceOf(account);
3662     }
3663 
3664     /**
3665      * @dev Retrieves the total supply at the time `snapshotId` was created.
3666      */
3667     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
3668         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
3669 
3670         return snapshotted ? value : totalSupply();
3671     }
3672 
3673     // Update balance and/or total supply snapshots before the values are modified. This is implemented
3674     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
3675     function _beforeTokenTransfer(
3676         address from,
3677         address to,
3678         uint256 amount
3679     ) internal virtual override {
3680         super._beforeTokenTransfer(from, to, amount);
3681 
3682         if (from == address(0)) {
3683             // mint
3684             _updateAccountSnapshot(to);
3685             _updateTotalSupplySnapshot();
3686         } else if (to == address(0)) {
3687             // burn
3688             _updateAccountSnapshot(from);
3689             _updateTotalSupplySnapshot();
3690         } else {
3691             // transfer
3692             _updateAccountSnapshot(from);
3693             _updateAccountSnapshot(to);
3694         }
3695     }
3696 
3697     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
3698         require(snapshotId > 0, "ERC20Snapshot: id is 0");
3699         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
3700 
3701         // When a valid snapshot is queried, there are three possibilities:
3702         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
3703         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
3704         //  to this id is the current one.
3705         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
3706         //  requested id, and its value is the one to return.
3707         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
3708         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
3709         //  larger than the requested one.
3710         //
3711         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
3712         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
3713         // exactly this.
3714 
3715         uint256 index = snapshots.ids.findUpperBound(snapshotId);
3716 
3717         if (index == snapshots.ids.length) {
3718             return (false, 0);
3719         } else {
3720             return (true, snapshots.values[index]);
3721         }
3722     }
3723 
3724     function _updateAccountSnapshot(address account) private {
3725         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
3726     }
3727 
3728     function _updateTotalSupplySnapshot() private {
3729         _updateSnapshot(_totalSupplySnapshots, totalSupply());
3730     }
3731 
3732     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
3733         uint256 currentId = _getCurrentSnapshotId();
3734         if (_lastSnapshotId(snapshots.ids) < currentId) {
3735             snapshots.ids.push(currentId);
3736             snapshots.values.push(currentValue);
3737         }
3738     }
3739 
3740     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
3741         if (ids.length == 0) {
3742             return 0;
3743         } else {
3744             return ids[ids.length - 1];
3745         }
3746     }
3747 }
3748 
3749 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
3750 
3751 
3752 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
3753 
3754 pragma solidity ^0.8.0;
3755 
3756 
3757 
3758 /**
3759  * @dev Extension of {ERC20} that allows token holders to destroy both their own
3760  * tokens and those that they have an allowance for, in a way that can be
3761  * recognized off-chain (via event analysis).
3762  */
3763 abstract contract ERC20Burnable is Context, ERC20 {
3764     /**
3765      * @dev Destroys `amount` tokens from the caller.
3766      *
3767      * See {ERC20-_burn}.
3768      */
3769     function burn(uint256 amount) public virtual {
3770         _burn(_msgSender(), amount);
3771     }
3772 
3773     /**
3774      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
3775      * allowance.
3776      *
3777      * See {ERC20-_burn} and {ERC20-allowance}.
3778      *
3779      * Requirements:
3780      *
3781      * - the caller must have allowance for ``accounts``'s tokens of at least
3782      * `amount`.
3783      */
3784     function burnFrom(address account, uint256 amount) public virtual {
3785         _spendAllowance(account, _msgSender(), amount);
3786         _burn(account, amount);
3787     }
3788 }
3789 
3790 // File: contracts/bigcap.sol
3791 
3792 
3793 
3794 pragma solidity >0.8.0;
3795 
3796 pragma experimental ABIEncoderV2;
3797 
3798 
3799 
3800 
3801 
3802 
3803 
3804 
3805 
3806 
3807 
3808 
3809 contract BIGCAP is
3810 
3811     Ownable,
3812 
3813     ERC20,
3814 
3815     ERC20Burnable,
3816 
3817     ERC20Permit,
3818 
3819     ERC20Votes,
3820 
3821     ERC20Snapshot
3822 
3823 {
3824 
3825     // 5% Treasury Tax
3826 
3827     uint256 public treasuryFeeBPS = 500;
3828 
3829     // 1% Operations Tax
3830 
3831     uint256 public operationsFeeBPS = 100;
3832 
3833     // 6% Total
3834 
3835     uint256 public totalFeeBPS = 600;
3836 
3837     // Prevent small transactions from triggering swaps
3838 
3839     uint256 public swapTokensAtAmount = 100000 * (10**18);
3840 
3841     uint256 public lastSwapTime;
3842 
3843     uint8 public lastSwap;
3844 
3845 
3846 
3847     bool public treasuryTaxEnabled = true;
3848 
3849     bool public operationsTaxEnabled = true;
3850 
3851 
3852 
3853     // Reentracy protection on swaps
3854 
3855     bool private swapping;
3856 
3857     
3858 
3859     uint256 private treasuryTokens;
3860 
3861     uint256 private operationsTokens;
3862 
3863     address treasuryAddress;
3864 
3865     address operationsAddress;
3866 
3867 
3868 
3869     mapping(address => bool) private _isExcludedFromFees;
3870 
3871     mapping(address => bool) public automatedMarketMakerPairs;
3872 
3873     mapping(address => bool) public _blacklist;
3874 
3875 
3876 
3877     event ExcludeFromFees(address indexed account, bool isExcluded);
3878 
3879     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
3880 
3881     event UpdateUniswapV2Router(
3882 
3883         address indexed newAddress,
3884 
3885         address indexed oldAddress
3886 
3887     );
3888 
3889     event TreasuryTaxDisabled();
3890 
3891     event OperationsTaxDisabled();
3892 
3893     event TreasuryTaxPaid();
3894 
3895     event OperationsTaxPaid();
3896 
3897     event LogErrorString(string message);
3898 
3899     event WalletsUpdated(
3900 
3901         address indexed treasuryAddress,
3902 
3903         address indexed operationsAddress
3904 
3905     );
3906 
3907 
3908 
3909     IUniswapV2Router02 public uniswapV2Router;
3910 
3911     address public uniswapV2Pair;
3912 
3913 
3914 
3915     constructor(address _treasuryAddress, address _operationsAddress, address _uniswapRouterAddress)
3916 
3917         ERC20("BIGCAP", "BIGCAP")
3918 
3919         ERC20Permit("BIGCAP")
3920 
3921     {
3922 
3923         treasuryAddress = _treasuryAddress;
3924 
3925         operationsAddress = _operationsAddress;
3926 
3927 
3928 
3929         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_uniswapRouterAddress); // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
3930 
3931 
3932 
3933         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
3934 
3935             .createPair(address(this), _uniswapV2Router.WETH());
3936 
3937 
3938 
3939         uniswapV2Router = _uniswapV2Router;
3940 
3941         uniswapV2Pair = _uniswapV2Pair;
3942 
3943 
3944 
3945         automatedMarketMakerPairs[_uniswapV2Pair] = true;
3946 
3947         _isExcludedFromFees[msg.sender] = true;
3948 
3949         _isExcludedFromFees[address(this)] = true;
3950 
3951 
3952 
3953         super._mint(msg.sender, 100000000 * (10**18));
3954 
3955     }
3956 
3957 
3958 
3959     receive() external payable {}
3960 
3961 
3962 
3963     function _beforeTokenTransfer(
3964 
3965         address from,
3966 
3967         address to,
3968 
3969         uint256 amount
3970 
3971     ) internal override(ERC20, ERC20Snapshot) {
3972 
3973         super._beforeTokenTransfer(from, to, amount);
3974 
3975     }
3976 
3977 
3978 
3979     function _afterTokenTransfer(
3980 
3981         address from,
3982 
3983         address to,
3984 
3985         uint256 amount
3986 
3987     ) internal override(ERC20, ERC20Votes) {
3988 
3989         super._afterTokenTransfer(from, to, amount);
3990 
3991     }
3992 
3993 
3994 
3995     function _mint(address account, uint256 amount)
3996 
3997         internal
3998 
3999         override(ERC20, ERC20Votes)
4000 
4001     {
4002 
4003         super._mint(account, amount);
4004 
4005     }
4006 
4007 
4008 
4009     function _burn(address account, uint256 amount)
4010 
4011         internal
4012 
4013         override(ERC20, ERC20Votes)
4014 
4015     {
4016 
4017         super._burn(account, amount);
4018 
4019     }
4020 
4021 
4022 
4023     function _transfer(
4024 
4025         address sender,
4026 
4027         address recipient,
4028 
4029         uint256 amount
4030 
4031     ) internal override {
4032 
4033         require(!_blacklist[sender], "BIGCAP: Sender is _blacklisted");
4034 
4035         require(!_blacklist[recipient], "BIGCAP: Recipient is _blacklisted");
4036 
4037 
4038 
4039         require(sender != address(0), "BIGCAP: transfer from the zero address");
4040 
4041         require(
4042 
4043             recipient != address(0),
4044 
4045             "BIGCAP: transfer to the zero address"
4046 
4047         );
4048 
4049 
4050 
4051         uint256 contractTokenBalance = balanceOf(address(this));
4052 
4053 
4054 
4055         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
4056 
4057 
4058 
4059         if (
4060 
4061             treasuryTaxEnabled &&
4062 
4063             canSwap &&
4064 
4065             !swapping &&
4066 
4067             !automatedMarketMakerPairs[sender] &&
4068 
4069             sender != address(uniswapV2Router) &&
4070 
4071             sender != owner() &&
4072 
4073             recipient != owner()
4074 
4075         ) {
4076 
4077             swapping = true;
4078 
4079 
4080 
4081             _executeSwap();
4082 
4083 
4084 
4085             swapping = false;
4086 
4087         }
4088 
4089 
4090 
4091         bool takeFee;
4092 
4093 
4094 
4095         if (
4096 
4097             sender == address(uniswapV2Pair) ||
4098 
4099             recipient == address(uniswapV2Pair)
4100 
4101         ) {
4102 
4103             takeFee = true;
4104 
4105         }
4106 
4107 
4108 
4109         if (
4110 
4111             _isExcludedFromFees[sender] ||
4112 
4113             _isExcludedFromFees[recipient] ||
4114 
4115             swapping ||
4116 
4117             !treasuryTaxEnabled
4118 
4119         ) {
4120 
4121             takeFee = false;
4122 
4123         }
4124 
4125 
4126 
4127         if (takeFee) {
4128 
4129             uint256 fees;
4130 
4131 
4132 
4133             if (treasuryTaxEnabled) {
4134 
4135               fees += (amount * treasuryFeeBPS) / 10000;
4136 
4137               treasuryTokens += (amount * treasuryFeeBPS) / 10000;
4138 
4139             }
4140 
4141 
4142 
4143             if (operationsTaxEnabled) {
4144 
4145               fees += (amount * operationsFeeBPS) / 10000;
4146 
4147               operationsTokens += (amount * operationsFeeBPS) / 10000;
4148 
4149             }
4150 
4151 
4152 
4153             amount -= fees;
4154 
4155             super._transfer(sender, address(this), fees);
4156 
4157         }
4158 
4159         super._transfer(sender, recipient, amount);
4160 
4161     }
4162 
4163 
4164 
4165     function swapTokensForNative(uint256 tokens) private {
4166 
4167         address[] memory path = new address[](2);
4168 
4169         path[0] = address(this);
4170 
4171         path[1] = uniswapV2Router.WETH();
4172 
4173         _approve(address(this), address(uniswapV2Router), tokens);
4174 
4175         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
4176 
4177             tokens,
4178 
4179             0, // accept any amount of native
4180 
4181             path,
4182 
4183             address(this),
4184 
4185             block.timestamp
4186 
4187         );
4188 
4189     }
4190 
4191 
4192 
4193     function _executeSwap() private {
4194 
4195         if (operationsTaxEnabled && lastSwap != 1) {
4196 
4197             swapTokensForNative(operationsTokens);
4198 
4199             operationsTokens = 0;
4200 
4201             lastSwap = 1;
4202 
4203             (bool success, ) = payable(operationsAddress).call{value: address(this).balance}("");
4204 
4205             if (!success) {
4206 
4207                 emit LogErrorString("BIGCAP: Operations failed to receive native");
4208 
4209             } else {
4210 
4211                 emit OperationsTaxPaid();
4212 
4213             }
4214 
4215         } else if (treasuryTaxEnabled) {
4216 
4217             swapTokensForNative(treasuryTokens);
4218 
4219             treasuryTokens = 0;
4220 
4221             lastSwap = 0;
4222 
4223             (bool success, ) = payable(treasuryAddress).call{value: address(this).balance}("");
4224 
4225             if (!success) {
4226 
4227                 emit LogErrorString("BIGCAP: Treasury failed to receive native");
4228 
4229             } else {
4230 
4231                 emit TreasuryTaxPaid();
4232 
4233             }
4234 
4235         }
4236 
4237     }
4238 
4239 
4240 
4241     function excludeFromFees(address account, bool excluded) public onlyOwner {
4242 
4243         require(
4244 
4245             _isExcludedFromFees[account] != excluded,
4246 
4247             "BIGCAP: account is already set to requested state"
4248 
4249         );
4250 
4251         _isExcludedFromFees[account] = excluded;
4252 
4253         emit ExcludeFromFees(account, excluded);
4254 
4255     }
4256 
4257 
4258 
4259     function isExcludedFromFees(address account) public view returns (bool) {
4260 
4261         return _isExcludedFromFees[account];
4262 
4263     }
4264 
4265 
4266 
4267     function updateWallets(
4268 
4269         address payable _treasuryAddress,
4270 
4271         address payable _operationsAddress
4272 
4273     ) external onlyOwner {
4274 
4275         treasuryAddress = _treasuryAddress;
4276 
4277         operationsAddress = _operationsAddress;
4278 
4279         emit WalletsUpdated(_treasuryAddress, _operationsAddress);
4280 
4281     }
4282 
4283 
4284 
4285     function setAutomatedMarketMakerPair(address pair, bool value)
4286 
4287         public
4288 
4289         onlyOwner
4290 
4291     {
4292 
4293         require(pair != uniswapV2Pair, "BIGCAP: DEX pair can not be removed");
4294 
4295         require(
4296 
4297             automatedMarketMakerPairs[pair] != value,
4298 
4299             "BIGCAP: automated market maker pair is already set to that value"
4300 
4301         );
4302 
4303         automatedMarketMakerPairs[pair] = value;
4304 
4305         emit SetAutomatedMarketMakerPair(pair, value);
4306 
4307     }
4308 
4309 
4310 
4311     function updateUniswapV2Router(address newAddress) public onlyOwner {
4312 
4313         require(
4314 
4315             newAddress != address(uniswapV2Router),
4316 
4317             "BIGCAP: the router is already set to the new address"
4318 
4319         );
4320 
4321         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
4322 
4323         uniswapV2Router = IUniswapV2Router02(newAddress);
4324 
4325         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
4326 
4327             .createPair(address(this), uniswapV2Router.WETH());
4328 
4329         uniswapV2Pair = _uniswapV2Pair;
4330 
4331     }
4332 
4333 
4334 
4335     /**
4336 
4337       Permanently disable treasury tax. Stops both tax collection and swapping.
4338 
4339     */
4340 
4341     function disableTreasuryTax() external onlyOwner {
4342 
4343         require(treasuryTaxEnabled, "BIGCAP: Treasury Tax already disabled");
4344 
4345         treasuryTaxEnabled = false;
4346 
4347         emit TreasuryTaxDisabled();
4348 
4349     }
4350 
4351 
4352 
4353     /**
4354 
4355       Permanently disable operations tax. Stops both tax collection and swapping.
4356 
4357     */
4358 
4359     function disableOperationsTax() external onlyOwner {
4360 
4361         require(operationsTaxEnabled, "BIGCAP: Operation Tax already disabled");
4362 
4363         operationsTaxEnabled = false;
4364 
4365         emit OperationsTaxDisabled();
4366 
4367     }
4368 
4369 
4370 
4371     /**
4372 
4373       Emergency recover tokens mistakenly sent to the contract address.
4374 
4375      */
4376 
4377     function rescueToken(address _token, uint256 _amount) external onlyOwner {
4378 
4379         IERC20(_token).transfer(msg.sender, _amount);
4380 
4381     }
4382 
4383 
4384 
4385     /**
4386 
4387       Emergency recover native mistakenly sent to the contract address.
4388 
4389      */
4390 
4391     function rescueETH(uint256 _amount) external onlyOwner {
4392 
4393         payable(msg.sender).transfer(_amount);
4394 
4395     }
4396 
4397 
4398 
4399     function _blacklistAddress(address _user) public onlyOwner {
4400 
4401         require(!_blacklist[_user], "BIGCAP: user already _blacklisted");
4402 
4403         _blacklist[_user] = true;
4404 
4405         // events?
4406 
4407     }
4408 
4409 
4410 
4411     function removeFromBlacklist(address _user) public onlyOwner {
4412 
4413         require(_blacklist[_user], "BIGCAP: user already whitelisted");
4414 
4415         _blacklist[_user] = false;
4416 
4417         //events?
4418 
4419     }
4420 
4421 }