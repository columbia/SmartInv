1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol
87 
88 
89 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 // CAUTION
94 // This version of SafeMath should only be used with Solidity 0.8 or later,
95 // because it relies on the compiler's built in overflow checks.
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations.
99  *
100  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
101  * now has built in overflow checking.
102  */
103 library SafeMathUpgradeable {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             uint256 c = a + b;
112             if (c < a) return (false, 0);
113             return (true, c);
114         }
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             if (b > a) return (false, 0);
125             return (true, a - b);
126         }
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137             // benefit is lost if 'b' is also tested.
138             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139             if (a == 0) return (true, 0);
140             uint256 c = a * b;
141             if (c / a != b) return (false, 0);
142             return (true, c);
143         }
144     }
145 
146     /**
147      * @dev Returns the division of two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             if (b == 0) return (false, 0);
154             return (true, a / b);
155         }
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
160      *
161      * _Available since v3.4._
162      */
163     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         unchecked {
165             if (b == 0) return (false, 0);
166             return (true, a % b);
167         }
168     }
169 
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      *
178      * - Addition cannot overflow.
179      */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a + b;
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a - b;
196     }
197 
198     /**
199      * @dev Returns the multiplication of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `*` operator.
203      *
204      * Requirements:
205      *
206      * - Multiplication cannot overflow.
207      */
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a * b;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers, reverting on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator.
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a / b;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * reverting when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(
256         uint256 a,
257         uint256 b,
258         string memory errorMessage
259     ) internal pure returns (uint256) {
260         unchecked {
261             require(b <= a, errorMessage);
262             return a - b;
263         }
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b > 0, errorMessage);
285             return a / b;
286         }
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * reverting with custom message when dividing by zero.
292      *
293      * CAUTION: This function is deprecated because it requires allocating memory for the error
294      * message unnecessarily. For custom revert reasons use {tryMod}.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function mod(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b > 0, errorMessage);
311             return a % b;
312         }
313     }
314 }
315 
316 // File: @openzeppelin/contracts-upgradeable/utils/math/SafeCastUpgradeable.sol
317 
318 
319 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/SafeCast.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
325  * checks.
326  *
327  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
328  * easily result in undesired exploitation or bugs, since developers usually
329  * assume that overflows raise errors. `SafeCast` restores this intuition by
330  * reverting the transaction when such an operation overflows.
331  *
332  * Using this library instead of the unchecked operations eliminates an entire
333  * class of bugs, so it's recommended to use it always.
334  *
335  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
336  * all math on `uint256` and `int256` and then downcasting.
337  */
338 library SafeCastUpgradeable {
339     /**
340      * @dev Returns the downcasted uint248 from uint256, reverting on
341      * overflow (when the input is greater than largest uint248).
342      *
343      * Counterpart to Solidity's `uint248` operator.
344      *
345      * Requirements:
346      *
347      * - input must fit into 248 bits
348      *
349      * _Available since v4.7._
350      */
351     function toUint248(uint256 value) internal pure returns (uint248) {
352         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
353         return uint248(value);
354     }
355 
356     /**
357      * @dev Returns the downcasted uint240 from uint256, reverting on
358      * overflow (when the input is greater than largest uint240).
359      *
360      * Counterpart to Solidity's `uint240` operator.
361      *
362      * Requirements:
363      *
364      * - input must fit into 240 bits
365      *
366      * _Available since v4.7._
367      */
368     function toUint240(uint256 value) internal pure returns (uint240) {
369         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
370         return uint240(value);
371     }
372 
373     /**
374      * @dev Returns the downcasted uint232 from uint256, reverting on
375      * overflow (when the input is greater than largest uint232).
376      *
377      * Counterpart to Solidity's `uint232` operator.
378      *
379      * Requirements:
380      *
381      * - input must fit into 232 bits
382      *
383      * _Available since v4.7._
384      */
385     function toUint232(uint256 value) internal pure returns (uint232) {
386         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
387         return uint232(value);
388     }
389 
390     /**
391      * @dev Returns the downcasted uint224 from uint256, reverting on
392      * overflow (when the input is greater than largest uint224).
393      *
394      * Counterpart to Solidity's `uint224` operator.
395      *
396      * Requirements:
397      *
398      * - input must fit into 224 bits
399      *
400      * _Available since v4.2._
401      */
402     function toUint224(uint256 value) internal pure returns (uint224) {
403         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
404         return uint224(value);
405     }
406 
407     /**
408      * @dev Returns the downcasted uint216 from uint256, reverting on
409      * overflow (when the input is greater than largest uint216).
410      *
411      * Counterpart to Solidity's `uint216` operator.
412      *
413      * Requirements:
414      *
415      * - input must fit into 216 bits
416      *
417      * _Available since v4.7._
418      */
419     function toUint216(uint256 value) internal pure returns (uint216) {
420         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
421         return uint216(value);
422     }
423 
424     /**
425      * @dev Returns the downcasted uint208 from uint256, reverting on
426      * overflow (when the input is greater than largest uint208).
427      *
428      * Counterpart to Solidity's `uint208` operator.
429      *
430      * Requirements:
431      *
432      * - input must fit into 208 bits
433      *
434      * _Available since v4.7._
435      */
436     function toUint208(uint256 value) internal pure returns (uint208) {
437         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
438         return uint208(value);
439     }
440 
441     /**
442      * @dev Returns the downcasted uint200 from uint256, reverting on
443      * overflow (when the input is greater than largest uint200).
444      *
445      * Counterpart to Solidity's `uint200` operator.
446      *
447      * Requirements:
448      *
449      * - input must fit into 200 bits
450      *
451      * _Available since v4.7._
452      */
453     function toUint200(uint256 value) internal pure returns (uint200) {
454         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
455         return uint200(value);
456     }
457 
458     /**
459      * @dev Returns the downcasted uint192 from uint256, reverting on
460      * overflow (when the input is greater than largest uint192).
461      *
462      * Counterpart to Solidity's `uint192` operator.
463      *
464      * Requirements:
465      *
466      * - input must fit into 192 bits
467      *
468      * _Available since v4.7._
469      */
470     function toUint192(uint256 value) internal pure returns (uint192) {
471         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
472         return uint192(value);
473     }
474 
475     /**
476      * @dev Returns the downcasted uint184 from uint256, reverting on
477      * overflow (when the input is greater than largest uint184).
478      *
479      * Counterpart to Solidity's `uint184` operator.
480      *
481      * Requirements:
482      *
483      * - input must fit into 184 bits
484      *
485      * _Available since v4.7._
486      */
487     function toUint184(uint256 value) internal pure returns (uint184) {
488         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
489         return uint184(value);
490     }
491 
492     /**
493      * @dev Returns the downcasted uint176 from uint256, reverting on
494      * overflow (when the input is greater than largest uint176).
495      *
496      * Counterpart to Solidity's `uint176` operator.
497      *
498      * Requirements:
499      *
500      * - input must fit into 176 bits
501      *
502      * _Available since v4.7._
503      */
504     function toUint176(uint256 value) internal pure returns (uint176) {
505         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
506         return uint176(value);
507     }
508 
509     /**
510      * @dev Returns the downcasted uint168 from uint256, reverting on
511      * overflow (when the input is greater than largest uint168).
512      *
513      * Counterpart to Solidity's `uint168` operator.
514      *
515      * Requirements:
516      *
517      * - input must fit into 168 bits
518      *
519      * _Available since v4.7._
520      */
521     function toUint168(uint256 value) internal pure returns (uint168) {
522         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
523         return uint168(value);
524     }
525 
526     /**
527      * @dev Returns the downcasted uint160 from uint256, reverting on
528      * overflow (when the input is greater than largest uint160).
529      *
530      * Counterpart to Solidity's `uint160` operator.
531      *
532      * Requirements:
533      *
534      * - input must fit into 160 bits
535      *
536      * _Available since v4.7._
537      */
538     function toUint160(uint256 value) internal pure returns (uint160) {
539         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
540         return uint160(value);
541     }
542 
543     /**
544      * @dev Returns the downcasted uint152 from uint256, reverting on
545      * overflow (when the input is greater than largest uint152).
546      *
547      * Counterpart to Solidity's `uint152` operator.
548      *
549      * Requirements:
550      *
551      * - input must fit into 152 bits
552      *
553      * _Available since v4.7._
554      */
555     function toUint152(uint256 value) internal pure returns (uint152) {
556         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
557         return uint152(value);
558     }
559 
560     /**
561      * @dev Returns the downcasted uint144 from uint256, reverting on
562      * overflow (when the input is greater than largest uint144).
563      *
564      * Counterpart to Solidity's `uint144` operator.
565      *
566      * Requirements:
567      *
568      * - input must fit into 144 bits
569      *
570      * _Available since v4.7._
571      */
572     function toUint144(uint256 value) internal pure returns (uint144) {
573         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
574         return uint144(value);
575     }
576 
577     /**
578      * @dev Returns the downcasted uint136 from uint256, reverting on
579      * overflow (when the input is greater than largest uint136).
580      *
581      * Counterpart to Solidity's `uint136` operator.
582      *
583      * Requirements:
584      *
585      * - input must fit into 136 bits
586      *
587      * _Available since v4.7._
588      */
589     function toUint136(uint256 value) internal pure returns (uint136) {
590         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
591         return uint136(value);
592     }
593 
594     /**
595      * @dev Returns the downcasted uint128 from uint256, reverting on
596      * overflow (when the input is greater than largest uint128).
597      *
598      * Counterpart to Solidity's `uint128` operator.
599      *
600      * Requirements:
601      *
602      * - input must fit into 128 bits
603      *
604      * _Available since v2.5._
605      */
606     function toUint128(uint256 value) internal pure returns (uint128) {
607         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
608         return uint128(value);
609     }
610 
611     /**
612      * @dev Returns the downcasted uint120 from uint256, reverting on
613      * overflow (when the input is greater than largest uint120).
614      *
615      * Counterpart to Solidity's `uint120` operator.
616      *
617      * Requirements:
618      *
619      * - input must fit into 120 bits
620      *
621      * _Available since v4.7._
622      */
623     function toUint120(uint256 value) internal pure returns (uint120) {
624         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
625         return uint120(value);
626     }
627 
628     /**
629      * @dev Returns the downcasted uint112 from uint256, reverting on
630      * overflow (when the input is greater than largest uint112).
631      *
632      * Counterpart to Solidity's `uint112` operator.
633      *
634      * Requirements:
635      *
636      * - input must fit into 112 bits
637      *
638      * _Available since v4.7._
639      */
640     function toUint112(uint256 value) internal pure returns (uint112) {
641         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
642         return uint112(value);
643     }
644 
645     /**
646      * @dev Returns the downcasted uint104 from uint256, reverting on
647      * overflow (when the input is greater than largest uint104).
648      *
649      * Counterpart to Solidity's `uint104` operator.
650      *
651      * Requirements:
652      *
653      * - input must fit into 104 bits
654      *
655      * _Available since v4.7._
656      */
657     function toUint104(uint256 value) internal pure returns (uint104) {
658         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
659         return uint104(value);
660     }
661 
662     /**
663      * @dev Returns the downcasted uint96 from uint256, reverting on
664      * overflow (when the input is greater than largest uint96).
665      *
666      * Counterpart to Solidity's `uint96` operator.
667      *
668      * Requirements:
669      *
670      * - input must fit into 96 bits
671      *
672      * _Available since v4.2._
673      */
674     function toUint96(uint256 value) internal pure returns (uint96) {
675         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
676         return uint96(value);
677     }
678 
679     /**
680      * @dev Returns the downcasted uint88 from uint256, reverting on
681      * overflow (when the input is greater than largest uint88).
682      *
683      * Counterpart to Solidity's `uint88` operator.
684      *
685      * Requirements:
686      *
687      * - input must fit into 88 bits
688      *
689      * _Available since v4.7._
690      */
691     function toUint88(uint256 value) internal pure returns (uint88) {
692         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
693         return uint88(value);
694     }
695 
696     /**
697      * @dev Returns the downcasted uint80 from uint256, reverting on
698      * overflow (when the input is greater than largest uint80).
699      *
700      * Counterpart to Solidity's `uint80` operator.
701      *
702      * Requirements:
703      *
704      * - input must fit into 80 bits
705      *
706      * _Available since v4.7._
707      */
708     function toUint80(uint256 value) internal pure returns (uint80) {
709         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
710         return uint80(value);
711     }
712 
713     /**
714      * @dev Returns the downcasted uint72 from uint256, reverting on
715      * overflow (when the input is greater than largest uint72).
716      *
717      * Counterpart to Solidity's `uint72` operator.
718      *
719      * Requirements:
720      *
721      * - input must fit into 72 bits
722      *
723      * _Available since v4.7._
724      */
725     function toUint72(uint256 value) internal pure returns (uint72) {
726         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
727         return uint72(value);
728     }
729 
730     /**
731      * @dev Returns the downcasted uint64 from uint256, reverting on
732      * overflow (when the input is greater than largest uint64).
733      *
734      * Counterpart to Solidity's `uint64` operator.
735      *
736      * Requirements:
737      *
738      * - input must fit into 64 bits
739      *
740      * _Available since v2.5._
741      */
742     function toUint64(uint256 value) internal pure returns (uint64) {
743         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
744         return uint64(value);
745     }
746 
747     /**
748      * @dev Returns the downcasted uint56 from uint256, reverting on
749      * overflow (when the input is greater than largest uint56).
750      *
751      * Counterpart to Solidity's `uint56` operator.
752      *
753      * Requirements:
754      *
755      * - input must fit into 56 bits
756      *
757      * _Available since v4.7._
758      */
759     function toUint56(uint256 value) internal pure returns (uint56) {
760         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
761         return uint56(value);
762     }
763 
764     /**
765      * @dev Returns the downcasted uint48 from uint256, reverting on
766      * overflow (when the input is greater than largest uint48).
767      *
768      * Counterpart to Solidity's `uint48` operator.
769      *
770      * Requirements:
771      *
772      * - input must fit into 48 bits
773      *
774      * _Available since v4.7._
775      */
776     function toUint48(uint256 value) internal pure returns (uint48) {
777         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
778         return uint48(value);
779     }
780 
781     /**
782      * @dev Returns the downcasted uint40 from uint256, reverting on
783      * overflow (when the input is greater than largest uint40).
784      *
785      * Counterpart to Solidity's `uint40` operator.
786      *
787      * Requirements:
788      *
789      * - input must fit into 40 bits
790      *
791      * _Available since v4.7._
792      */
793     function toUint40(uint256 value) internal pure returns (uint40) {
794         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
795         return uint40(value);
796     }
797 
798     /**
799      * @dev Returns the downcasted uint32 from uint256, reverting on
800      * overflow (when the input is greater than largest uint32).
801      *
802      * Counterpart to Solidity's `uint32` operator.
803      *
804      * Requirements:
805      *
806      * - input must fit into 32 bits
807      *
808      * _Available since v2.5._
809      */
810     function toUint32(uint256 value) internal pure returns (uint32) {
811         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
812         return uint32(value);
813     }
814 
815     /**
816      * @dev Returns the downcasted uint24 from uint256, reverting on
817      * overflow (when the input is greater than largest uint24).
818      *
819      * Counterpart to Solidity's `uint24` operator.
820      *
821      * Requirements:
822      *
823      * - input must fit into 24 bits
824      *
825      * _Available since v4.7._
826      */
827     function toUint24(uint256 value) internal pure returns (uint24) {
828         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
829         return uint24(value);
830     }
831 
832     /**
833      * @dev Returns the downcasted uint16 from uint256, reverting on
834      * overflow (when the input is greater than largest uint16).
835      *
836      * Counterpart to Solidity's `uint16` operator.
837      *
838      * Requirements:
839      *
840      * - input must fit into 16 bits
841      *
842      * _Available since v2.5._
843      */
844     function toUint16(uint256 value) internal pure returns (uint16) {
845         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
846         return uint16(value);
847     }
848 
849     /**
850      * @dev Returns the downcasted uint8 from uint256, reverting on
851      * overflow (when the input is greater than largest uint8).
852      *
853      * Counterpart to Solidity's `uint8` operator.
854      *
855      * Requirements:
856      *
857      * - input must fit into 8 bits
858      *
859      * _Available since v2.5._
860      */
861     function toUint8(uint256 value) internal pure returns (uint8) {
862         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
863         return uint8(value);
864     }
865 
866     /**
867      * @dev Converts a signed int256 into an unsigned uint256.
868      *
869      * Requirements:
870      *
871      * - input must be greater than or equal to 0.
872      *
873      * _Available since v3.0._
874      */
875     function toUint256(int256 value) internal pure returns (uint256) {
876         require(value >= 0, "SafeCast: value must be positive");
877         return uint256(value);
878     }
879 
880     /**
881      * @dev Returns the downcasted int248 from int256, reverting on
882      * overflow (when the input is less than smallest int248 or
883      * greater than largest int248).
884      *
885      * Counterpart to Solidity's `int248` operator.
886      *
887      * Requirements:
888      *
889      * - input must fit into 248 bits
890      *
891      * _Available since v4.7._
892      */
893     function toInt248(int256 value) internal pure returns (int248) {
894         require(value >= type(int248).min && value <= type(int248).max, "SafeCast: value doesn't fit in 248 bits");
895         return int248(value);
896     }
897 
898     /**
899      * @dev Returns the downcasted int240 from int256, reverting on
900      * overflow (when the input is less than smallest int240 or
901      * greater than largest int240).
902      *
903      * Counterpart to Solidity's `int240` operator.
904      *
905      * Requirements:
906      *
907      * - input must fit into 240 bits
908      *
909      * _Available since v4.7._
910      */
911     function toInt240(int256 value) internal pure returns (int240) {
912         require(value >= type(int240).min && value <= type(int240).max, "SafeCast: value doesn't fit in 240 bits");
913         return int240(value);
914     }
915 
916     /**
917      * @dev Returns the downcasted int232 from int256, reverting on
918      * overflow (when the input is less than smallest int232 or
919      * greater than largest int232).
920      *
921      * Counterpart to Solidity's `int232` operator.
922      *
923      * Requirements:
924      *
925      * - input must fit into 232 bits
926      *
927      * _Available since v4.7._
928      */
929     function toInt232(int256 value) internal pure returns (int232) {
930         require(value >= type(int232).min && value <= type(int232).max, "SafeCast: value doesn't fit in 232 bits");
931         return int232(value);
932     }
933 
934     /**
935      * @dev Returns the downcasted int224 from int256, reverting on
936      * overflow (when the input is less than smallest int224 or
937      * greater than largest int224).
938      *
939      * Counterpart to Solidity's `int224` operator.
940      *
941      * Requirements:
942      *
943      * - input must fit into 224 bits
944      *
945      * _Available since v4.7._
946      */
947     function toInt224(int256 value) internal pure returns (int224) {
948         require(value >= type(int224).min && value <= type(int224).max, "SafeCast: value doesn't fit in 224 bits");
949         return int224(value);
950     }
951 
952     /**
953      * @dev Returns the downcasted int216 from int256, reverting on
954      * overflow (when the input is less than smallest int216 or
955      * greater than largest int216).
956      *
957      * Counterpart to Solidity's `int216` operator.
958      *
959      * Requirements:
960      *
961      * - input must fit into 216 bits
962      *
963      * _Available since v4.7._
964      */
965     function toInt216(int256 value) internal pure returns (int216) {
966         require(value >= type(int216).min && value <= type(int216).max, "SafeCast: value doesn't fit in 216 bits");
967         return int216(value);
968     }
969 
970     /**
971      * @dev Returns the downcasted int208 from int256, reverting on
972      * overflow (when the input is less than smallest int208 or
973      * greater than largest int208).
974      *
975      * Counterpart to Solidity's `int208` operator.
976      *
977      * Requirements:
978      *
979      * - input must fit into 208 bits
980      *
981      * _Available since v4.7._
982      */
983     function toInt208(int256 value) internal pure returns (int208) {
984         require(value >= type(int208).min && value <= type(int208).max, "SafeCast: value doesn't fit in 208 bits");
985         return int208(value);
986     }
987 
988     /**
989      * @dev Returns the downcasted int200 from int256, reverting on
990      * overflow (when the input is less than smallest int200 or
991      * greater than largest int200).
992      *
993      * Counterpart to Solidity's `int200` operator.
994      *
995      * Requirements:
996      *
997      * - input must fit into 200 bits
998      *
999      * _Available since v4.7._
1000      */
1001     function toInt200(int256 value) internal pure returns (int200) {
1002         require(value >= type(int200).min && value <= type(int200).max, "SafeCast: value doesn't fit in 200 bits");
1003         return int200(value);
1004     }
1005 
1006     /**
1007      * @dev Returns the downcasted int192 from int256, reverting on
1008      * overflow (when the input is less than smallest int192 or
1009      * greater than largest int192).
1010      *
1011      * Counterpart to Solidity's `int192` operator.
1012      *
1013      * Requirements:
1014      *
1015      * - input must fit into 192 bits
1016      *
1017      * _Available since v4.7._
1018      */
1019     function toInt192(int256 value) internal pure returns (int192) {
1020         require(value >= type(int192).min && value <= type(int192).max, "SafeCast: value doesn't fit in 192 bits");
1021         return int192(value);
1022     }
1023 
1024     /**
1025      * @dev Returns the downcasted int184 from int256, reverting on
1026      * overflow (when the input is less than smallest int184 or
1027      * greater than largest int184).
1028      *
1029      * Counterpart to Solidity's `int184` operator.
1030      *
1031      * Requirements:
1032      *
1033      * - input must fit into 184 bits
1034      *
1035      * _Available since v4.7._
1036      */
1037     function toInt184(int256 value) internal pure returns (int184) {
1038         require(value >= type(int184).min && value <= type(int184).max, "SafeCast: value doesn't fit in 184 bits");
1039         return int184(value);
1040     }
1041 
1042     /**
1043      * @dev Returns the downcasted int176 from int256, reverting on
1044      * overflow (when the input is less than smallest int176 or
1045      * greater than largest int176).
1046      *
1047      * Counterpart to Solidity's `int176` operator.
1048      *
1049      * Requirements:
1050      *
1051      * - input must fit into 176 bits
1052      *
1053      * _Available since v4.7._
1054      */
1055     function toInt176(int256 value) internal pure returns (int176) {
1056         require(value >= type(int176).min && value <= type(int176).max, "SafeCast: value doesn't fit in 176 bits");
1057         return int176(value);
1058     }
1059 
1060     /**
1061      * @dev Returns the downcasted int168 from int256, reverting on
1062      * overflow (when the input is less than smallest int168 or
1063      * greater than largest int168).
1064      *
1065      * Counterpart to Solidity's `int168` operator.
1066      *
1067      * Requirements:
1068      *
1069      * - input must fit into 168 bits
1070      *
1071      * _Available since v4.7._
1072      */
1073     function toInt168(int256 value) internal pure returns (int168) {
1074         require(value >= type(int168).min && value <= type(int168).max, "SafeCast: value doesn't fit in 168 bits");
1075         return int168(value);
1076     }
1077 
1078     /**
1079      * @dev Returns the downcasted int160 from int256, reverting on
1080      * overflow (when the input is less than smallest int160 or
1081      * greater than largest int160).
1082      *
1083      * Counterpart to Solidity's `int160` operator.
1084      *
1085      * Requirements:
1086      *
1087      * - input must fit into 160 bits
1088      *
1089      * _Available since v4.7._
1090      */
1091     function toInt160(int256 value) internal pure returns (int160) {
1092         require(value >= type(int160).min && value <= type(int160).max, "SafeCast: value doesn't fit in 160 bits");
1093         return int160(value);
1094     }
1095 
1096     /**
1097      * @dev Returns the downcasted int152 from int256, reverting on
1098      * overflow (when the input is less than smallest int152 or
1099      * greater than largest int152).
1100      *
1101      * Counterpart to Solidity's `int152` operator.
1102      *
1103      * Requirements:
1104      *
1105      * - input must fit into 152 bits
1106      *
1107      * _Available since v4.7._
1108      */
1109     function toInt152(int256 value) internal pure returns (int152) {
1110         require(value >= type(int152).min && value <= type(int152).max, "SafeCast: value doesn't fit in 152 bits");
1111         return int152(value);
1112     }
1113 
1114     /**
1115      * @dev Returns the downcasted int144 from int256, reverting on
1116      * overflow (when the input is less than smallest int144 or
1117      * greater than largest int144).
1118      *
1119      * Counterpart to Solidity's `int144` operator.
1120      *
1121      * Requirements:
1122      *
1123      * - input must fit into 144 bits
1124      *
1125      * _Available since v4.7._
1126      */
1127     function toInt144(int256 value) internal pure returns (int144) {
1128         require(value >= type(int144).min && value <= type(int144).max, "SafeCast: value doesn't fit in 144 bits");
1129         return int144(value);
1130     }
1131 
1132     /**
1133      * @dev Returns the downcasted int136 from int256, reverting on
1134      * overflow (when the input is less than smallest int136 or
1135      * greater than largest int136).
1136      *
1137      * Counterpart to Solidity's `int136` operator.
1138      *
1139      * Requirements:
1140      *
1141      * - input must fit into 136 bits
1142      *
1143      * _Available since v4.7._
1144      */
1145     function toInt136(int256 value) internal pure returns (int136) {
1146         require(value >= type(int136).min && value <= type(int136).max, "SafeCast: value doesn't fit in 136 bits");
1147         return int136(value);
1148     }
1149 
1150     /**
1151      * @dev Returns the downcasted int128 from int256, reverting on
1152      * overflow (when the input is less than smallest int128 or
1153      * greater than largest int128).
1154      *
1155      * Counterpart to Solidity's `int128` operator.
1156      *
1157      * Requirements:
1158      *
1159      * - input must fit into 128 bits
1160      *
1161      * _Available since v3.1._
1162      */
1163     function toInt128(int256 value) internal pure returns (int128) {
1164         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1165         return int128(value);
1166     }
1167 
1168     /**
1169      * @dev Returns the downcasted int120 from int256, reverting on
1170      * overflow (when the input is less than smallest int120 or
1171      * greater than largest int120).
1172      *
1173      * Counterpart to Solidity's `int120` operator.
1174      *
1175      * Requirements:
1176      *
1177      * - input must fit into 120 bits
1178      *
1179      * _Available since v4.7._
1180      */
1181     function toInt120(int256 value) internal pure returns (int120) {
1182         require(value >= type(int120).min && value <= type(int120).max, "SafeCast: value doesn't fit in 120 bits");
1183         return int120(value);
1184     }
1185 
1186     /**
1187      * @dev Returns the downcasted int112 from int256, reverting on
1188      * overflow (when the input is less than smallest int112 or
1189      * greater than largest int112).
1190      *
1191      * Counterpart to Solidity's `int112` operator.
1192      *
1193      * Requirements:
1194      *
1195      * - input must fit into 112 bits
1196      *
1197      * _Available since v4.7._
1198      */
1199     function toInt112(int256 value) internal pure returns (int112) {
1200         require(value >= type(int112).min && value <= type(int112).max, "SafeCast: value doesn't fit in 112 bits");
1201         return int112(value);
1202     }
1203 
1204     /**
1205      * @dev Returns the downcasted int104 from int256, reverting on
1206      * overflow (when the input is less than smallest int104 or
1207      * greater than largest int104).
1208      *
1209      * Counterpart to Solidity's `int104` operator.
1210      *
1211      * Requirements:
1212      *
1213      * - input must fit into 104 bits
1214      *
1215      * _Available since v4.7._
1216      */
1217     function toInt104(int256 value) internal pure returns (int104) {
1218         require(value >= type(int104).min && value <= type(int104).max, "SafeCast: value doesn't fit in 104 bits");
1219         return int104(value);
1220     }
1221 
1222     /**
1223      * @dev Returns the downcasted int96 from int256, reverting on
1224      * overflow (when the input is less than smallest int96 or
1225      * greater than largest int96).
1226      *
1227      * Counterpart to Solidity's `int96` operator.
1228      *
1229      * Requirements:
1230      *
1231      * - input must fit into 96 bits
1232      *
1233      * _Available since v4.7._
1234      */
1235     function toInt96(int256 value) internal pure returns (int96) {
1236         require(value >= type(int96).min && value <= type(int96).max, "SafeCast: value doesn't fit in 96 bits");
1237         return int96(value);
1238     }
1239 
1240     /**
1241      * @dev Returns the downcasted int88 from int256, reverting on
1242      * overflow (when the input is less than smallest int88 or
1243      * greater than largest int88).
1244      *
1245      * Counterpart to Solidity's `int88` operator.
1246      *
1247      * Requirements:
1248      *
1249      * - input must fit into 88 bits
1250      *
1251      * _Available since v4.7._
1252      */
1253     function toInt88(int256 value) internal pure returns (int88) {
1254         require(value >= type(int88).min && value <= type(int88).max, "SafeCast: value doesn't fit in 88 bits");
1255         return int88(value);
1256     }
1257 
1258     /**
1259      * @dev Returns the downcasted int80 from int256, reverting on
1260      * overflow (when the input is less than smallest int80 or
1261      * greater than largest int80).
1262      *
1263      * Counterpart to Solidity's `int80` operator.
1264      *
1265      * Requirements:
1266      *
1267      * - input must fit into 80 bits
1268      *
1269      * _Available since v4.7._
1270      */
1271     function toInt80(int256 value) internal pure returns (int80) {
1272         require(value >= type(int80).min && value <= type(int80).max, "SafeCast: value doesn't fit in 80 bits");
1273         return int80(value);
1274     }
1275 
1276     /**
1277      * @dev Returns the downcasted int72 from int256, reverting on
1278      * overflow (when the input is less than smallest int72 or
1279      * greater than largest int72).
1280      *
1281      * Counterpart to Solidity's `int72` operator.
1282      *
1283      * Requirements:
1284      *
1285      * - input must fit into 72 bits
1286      *
1287      * _Available since v4.7._
1288      */
1289     function toInt72(int256 value) internal pure returns (int72) {
1290         require(value >= type(int72).min && value <= type(int72).max, "SafeCast: value doesn't fit in 72 bits");
1291         return int72(value);
1292     }
1293 
1294     /**
1295      * @dev Returns the downcasted int64 from int256, reverting on
1296      * overflow (when the input is less than smallest int64 or
1297      * greater than largest int64).
1298      *
1299      * Counterpart to Solidity's `int64` operator.
1300      *
1301      * Requirements:
1302      *
1303      * - input must fit into 64 bits
1304      *
1305      * _Available since v3.1._
1306      */
1307     function toInt64(int256 value) internal pure returns (int64) {
1308         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1309         return int64(value);
1310     }
1311 
1312     /**
1313      * @dev Returns the downcasted int56 from int256, reverting on
1314      * overflow (when the input is less than smallest int56 or
1315      * greater than largest int56).
1316      *
1317      * Counterpart to Solidity's `int56` operator.
1318      *
1319      * Requirements:
1320      *
1321      * - input must fit into 56 bits
1322      *
1323      * _Available since v4.7._
1324      */
1325     function toInt56(int256 value) internal pure returns (int56) {
1326         require(value >= type(int56).min && value <= type(int56).max, "SafeCast: value doesn't fit in 56 bits");
1327         return int56(value);
1328     }
1329 
1330     /**
1331      * @dev Returns the downcasted int48 from int256, reverting on
1332      * overflow (when the input is less than smallest int48 or
1333      * greater than largest int48).
1334      *
1335      * Counterpart to Solidity's `int48` operator.
1336      *
1337      * Requirements:
1338      *
1339      * - input must fit into 48 bits
1340      *
1341      * _Available since v4.7._
1342      */
1343     function toInt48(int256 value) internal pure returns (int48) {
1344         require(value >= type(int48).min && value <= type(int48).max, "SafeCast: value doesn't fit in 48 bits");
1345         return int48(value);
1346     }
1347 
1348     /**
1349      * @dev Returns the downcasted int40 from int256, reverting on
1350      * overflow (when the input is less than smallest int40 or
1351      * greater than largest int40).
1352      *
1353      * Counterpart to Solidity's `int40` operator.
1354      *
1355      * Requirements:
1356      *
1357      * - input must fit into 40 bits
1358      *
1359      * _Available since v4.7._
1360      */
1361     function toInt40(int256 value) internal pure returns (int40) {
1362         require(value >= type(int40).min && value <= type(int40).max, "SafeCast: value doesn't fit in 40 bits");
1363         return int40(value);
1364     }
1365 
1366     /**
1367      * @dev Returns the downcasted int32 from int256, reverting on
1368      * overflow (when the input is less than smallest int32 or
1369      * greater than largest int32).
1370      *
1371      * Counterpart to Solidity's `int32` operator.
1372      *
1373      * Requirements:
1374      *
1375      * - input must fit into 32 bits
1376      *
1377      * _Available since v3.1._
1378      */
1379     function toInt32(int256 value) internal pure returns (int32) {
1380         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1381         return int32(value);
1382     }
1383 
1384     /**
1385      * @dev Returns the downcasted int24 from int256, reverting on
1386      * overflow (when the input is less than smallest int24 or
1387      * greater than largest int24).
1388      *
1389      * Counterpart to Solidity's `int24` operator.
1390      *
1391      * Requirements:
1392      *
1393      * - input must fit into 24 bits
1394      *
1395      * _Available since v4.7._
1396      */
1397     function toInt24(int256 value) internal pure returns (int24) {
1398         require(value >= type(int24).min && value <= type(int24).max, "SafeCast: value doesn't fit in 24 bits");
1399         return int24(value);
1400     }
1401 
1402     /**
1403      * @dev Returns the downcasted int16 from int256, reverting on
1404      * overflow (when the input is less than smallest int16 or
1405      * greater than largest int16).
1406      *
1407      * Counterpart to Solidity's `int16` operator.
1408      *
1409      * Requirements:
1410      *
1411      * - input must fit into 16 bits
1412      *
1413      * _Available since v3.1._
1414      */
1415     function toInt16(int256 value) internal pure returns (int16) {
1416         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1417         return int16(value);
1418     }
1419 
1420     /**
1421      * @dev Returns the downcasted int8 from int256, reverting on
1422      * overflow (when the input is less than smallest int8 or
1423      * greater than largest int8).
1424      *
1425      * Counterpart to Solidity's `int8` operator.
1426      *
1427      * Requirements:
1428      *
1429      * - input must fit into 8 bits
1430      *
1431      * _Available since v3.1._
1432      */
1433     function toInt8(int256 value) internal pure returns (int8) {
1434         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1435         return int8(value);
1436     }
1437 
1438     /**
1439      * @dev Converts an unsigned uint256 into a signed int256.
1440      *
1441      * Requirements:
1442      *
1443      * - input must be less than or equal to maxInt256.
1444      *
1445      * _Available since v3.0._
1446      */
1447     function toInt256(uint256 value) internal pure returns (int256) {
1448         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1449         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1450         return int256(value);
1451     }
1452 }
1453 
1454 // File: @openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol
1455 
1456 
1457 // OpenZeppelin Contracts (last updated v4.5.0) (governance/utils/IVotes.sol)
1458 pragma solidity ^0.8.0;
1459 
1460 /**
1461  * @dev Common interface for {ERC20Votes}, {ERC721Votes}, and other {Votes}-enabled contracts.
1462  *
1463  * _Available since v4.5._
1464  */
1465 interface IVotesUpgradeable {
1466     /**
1467      * @dev Emitted when an account changes their delegate.
1468      */
1469     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1470 
1471     /**
1472      * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
1473      */
1474     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1475 
1476     /**
1477      * @dev Returns the current amount of votes that `account` has.
1478      */
1479     function getVotes(address account) external view returns (uint256);
1480 
1481     /**
1482      * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
1483      */
1484     function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
1485 
1486     /**
1487      * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
1488      *
1489      * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
1490      * Votes that have not been delegated are still part of total supply, even though they would not participate in a
1491      * vote.
1492      */
1493     function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
1494 
1495     /**
1496      * @dev Returns the delegate that `account` has chosen.
1497      */
1498     function delegates(address account) external view returns (address);
1499 
1500     /**
1501      * @dev Delegates votes from the sender to `delegatee`.
1502      */
1503     function delegate(address delegatee) external;
1504 
1505     /**
1506      * @dev Delegates votes from signer to `delegatee`.
1507      */
1508     function delegateBySig(
1509         address delegatee,
1510         uint256 nonce,
1511         uint256 expiry,
1512         uint8 v,
1513         bytes32 r,
1514         bytes32 s
1515     ) external;
1516 }
1517 
1518 // File: @openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol
1519 
1520 
1521 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
1522 
1523 pragma solidity ^0.8.0;
1524 
1525 /**
1526  * @dev Standard math utilities missing in the Solidity language.
1527  */
1528 library MathUpgradeable {
1529     enum Rounding {
1530         Down, // Toward negative infinity
1531         Up, // Toward infinity
1532         Zero // Toward zero
1533     }
1534 
1535     /**
1536      * @dev Returns the largest of two numbers.
1537      */
1538     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1539         return a >= b ? a : b;
1540     }
1541 
1542     /**
1543      * @dev Returns the smallest of two numbers.
1544      */
1545     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1546         return a < b ? a : b;
1547     }
1548 
1549     /**
1550      * @dev Returns the average of two numbers. The result is rounded towards
1551      * zero.
1552      */
1553     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1554         // (a + b) / 2 can overflow.
1555         return (a & b) + (a ^ b) / 2;
1556     }
1557 
1558     /**
1559      * @dev Returns the ceiling of the division of two numbers.
1560      *
1561      * This differs from standard division with `/` in that it rounds up instead
1562      * of rounding down.
1563      */
1564     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1565         // (a + b - 1) / b can overflow on addition, so we distribute.
1566         return a == 0 ? 0 : (a - 1) / b + 1;
1567     }
1568 
1569     /**
1570      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1571      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1572      * with further edits by Uniswap Labs also under MIT license.
1573      */
1574     function mulDiv(
1575         uint256 x,
1576         uint256 y,
1577         uint256 denominator
1578     ) internal pure returns (uint256 result) {
1579         unchecked {
1580             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1581             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1582             // variables such that product = prod1 * 2^256 + prod0.
1583             uint256 prod0; // Least significant 256 bits of the product
1584             uint256 prod1; // Most significant 256 bits of the product
1585             assembly {
1586                 let mm := mulmod(x, y, not(0))
1587                 prod0 := mul(x, y)
1588                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1589             }
1590 
1591             // Handle non-overflow cases, 256 by 256 division.
1592             if (prod1 == 0) {
1593                 return prod0 / denominator;
1594             }
1595 
1596             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1597             require(denominator > prod1);
1598 
1599             ///////////////////////////////////////////////
1600             // 512 by 256 division.
1601             ///////////////////////////////////////////////
1602 
1603             // Make division exact by subtracting the remainder from [prod1 prod0].
1604             uint256 remainder;
1605             assembly {
1606                 // Compute remainder using mulmod.
1607                 remainder := mulmod(x, y, denominator)
1608 
1609                 // Subtract 256 bit number from 512 bit number.
1610                 prod1 := sub(prod1, gt(remainder, prod0))
1611                 prod0 := sub(prod0, remainder)
1612             }
1613 
1614             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1615             // See https://cs.stackexchange.com/q/138556/92363.
1616 
1617             // Does not overflow because the denominator cannot be zero at this stage in the function.
1618             uint256 twos = denominator & (~denominator + 1);
1619             assembly {
1620                 // Divide denominator by twos.
1621                 denominator := div(denominator, twos)
1622 
1623                 // Divide [prod1 prod0] by twos.
1624                 prod0 := div(prod0, twos)
1625 
1626                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1627                 twos := add(div(sub(0, twos), twos), 1)
1628             }
1629 
1630             // Shift in bits from prod1 into prod0.
1631             prod0 |= prod1 * twos;
1632 
1633             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1634             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1635             // four bits. That is, denominator * inv = 1 mod 2^4.
1636             uint256 inverse = (3 * denominator) ^ 2;
1637 
1638             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1639             // in modular arithmetic, doubling the correct bits in each step.
1640             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1641             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1642             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1643             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1644             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1645             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1646 
1647             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1648             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1649             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1650             // is no longer required.
1651             result = prod0 * inverse;
1652             return result;
1653         }
1654     }
1655 
1656     /**
1657      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1658      */
1659     function mulDiv(
1660         uint256 x,
1661         uint256 y,
1662         uint256 denominator,
1663         Rounding rounding
1664     ) internal pure returns (uint256) {
1665         uint256 result = mulDiv(x, y, denominator);
1666         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1667             result += 1;
1668         }
1669         return result;
1670     }
1671 
1672     /**
1673      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
1674      *
1675      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1676      */
1677     function sqrt(uint256 a) internal pure returns (uint256) {
1678         if (a == 0) {
1679             return 0;
1680         }
1681 
1682         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1683         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1684         // `msb(a) <= a < 2*msb(a)`.
1685         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
1686         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
1687         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
1688         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
1689         uint256 result = 1;
1690         uint256 x = a;
1691         if (x >> 128 > 0) {
1692             x >>= 128;
1693             result <<= 64;
1694         }
1695         if (x >> 64 > 0) {
1696             x >>= 64;
1697             result <<= 32;
1698         }
1699         if (x >> 32 > 0) {
1700             x >>= 32;
1701             result <<= 16;
1702         }
1703         if (x >> 16 > 0) {
1704             x >>= 16;
1705             result <<= 8;
1706         }
1707         if (x >> 8 > 0) {
1708             x >>= 8;
1709             result <<= 4;
1710         }
1711         if (x >> 4 > 0) {
1712             x >>= 4;
1713             result <<= 2;
1714         }
1715         if (x >> 2 > 0) {
1716             result <<= 1;
1717         }
1718 
1719         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1720         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1721         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1722         // into the expected uint128 result.
1723         unchecked {
1724             result = (result + a / result) >> 1;
1725             result = (result + a / result) >> 1;
1726             result = (result + a / result) >> 1;
1727             result = (result + a / result) >> 1;
1728             result = (result + a / result) >> 1;
1729             result = (result + a / result) >> 1;
1730             result = (result + a / result) >> 1;
1731             return min(result, a / result);
1732         }
1733     }
1734 
1735     /**
1736      * @notice Calculates sqrt(a), following the selected rounding direction.
1737      */
1738     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1739         uint256 result = sqrt(a);
1740         if (rounding == Rounding.Up && result * result < a) {
1741             result += 1;
1742         }
1743         return result;
1744     }
1745 }
1746 
1747 // File: @openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol
1748 
1749 
1750 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1751 
1752 pragma solidity ^0.8.0;
1753 
1754 /**
1755  * @title Counters
1756  * @author Matt Condon (@shrugs)
1757  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1758  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1759  *
1760  * Include with `using Counters for Counters.Counter;`
1761  */
1762 library CountersUpgradeable {
1763     struct Counter {
1764         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1765         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1766         // this feature: see https://github.com/ethereum/solidity/issues/4637
1767         uint256 _value; // default: 0
1768     }
1769 
1770     function current(Counter storage counter) internal view returns (uint256) {
1771         return counter._value;
1772     }
1773 
1774     function increment(Counter storage counter) internal {
1775         unchecked {
1776             counter._value += 1;
1777         }
1778     }
1779 
1780     function decrement(Counter storage counter) internal {
1781         uint256 value = counter._value;
1782         require(value > 0, "Counter: decrement overflow");
1783         unchecked {
1784             counter._value = value - 1;
1785         }
1786     }
1787 
1788     function reset(Counter storage counter) internal {
1789         counter._value = 0;
1790     }
1791 }
1792 
1793 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
1794 
1795 
1796 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1797 
1798 pragma solidity ^0.8.0;
1799 
1800 /**
1801  * @dev String operations.
1802  */
1803 library StringsUpgradeable {
1804     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1805     uint8 private constant _ADDRESS_LENGTH = 20;
1806 
1807     /**
1808      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1809      */
1810     function toString(uint256 value) internal pure returns (string memory) {
1811         // Inspired by OraclizeAPI's implementation - MIT licence
1812         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1813 
1814         if (value == 0) {
1815             return "0";
1816         }
1817         uint256 temp = value;
1818         uint256 digits;
1819         while (temp != 0) {
1820             digits++;
1821             temp /= 10;
1822         }
1823         bytes memory buffer = new bytes(digits);
1824         while (value != 0) {
1825             digits -= 1;
1826             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1827             value /= 10;
1828         }
1829         return string(buffer);
1830     }
1831 
1832     /**
1833      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1834      */
1835     function toHexString(uint256 value) internal pure returns (string memory) {
1836         if (value == 0) {
1837             return "0x00";
1838         }
1839         uint256 temp = value;
1840         uint256 length = 0;
1841         while (temp != 0) {
1842             length++;
1843             temp >>= 8;
1844         }
1845         return toHexString(value, length);
1846     }
1847 
1848     /**
1849      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1850      */
1851     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1852         bytes memory buffer = new bytes(2 * length + 2);
1853         buffer[0] = "0";
1854         buffer[1] = "x";
1855         for (uint256 i = 2 * length + 1; i > 1; --i) {
1856             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1857             value >>= 4;
1858         }
1859         require(value == 0, "Strings: hex length insufficient");
1860         return string(buffer);
1861     }
1862 
1863     /**
1864      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1865      */
1866     function toHexString(address addr) internal pure returns (string memory) {
1867         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1868     }
1869 }
1870 
1871 // File: @openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol
1872 
1873 
1874 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
1875 
1876 pragma solidity ^0.8.0;
1877 
1878 
1879 /**
1880  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1881  *
1882  * These functions can be used to verify that a message was signed by the holder
1883  * of the private keys of a given address.
1884  */
1885 library ECDSAUpgradeable {
1886     enum RecoverError {
1887         NoError,
1888         InvalidSignature,
1889         InvalidSignatureLength,
1890         InvalidSignatureS,
1891         InvalidSignatureV
1892     }
1893 
1894     function _throwError(RecoverError error) private pure {
1895         if (error == RecoverError.NoError) {
1896             return; // no error: do nothing
1897         } else if (error == RecoverError.InvalidSignature) {
1898             revert("ECDSA: invalid signature");
1899         } else if (error == RecoverError.InvalidSignatureLength) {
1900             revert("ECDSA: invalid signature length");
1901         } else if (error == RecoverError.InvalidSignatureS) {
1902             revert("ECDSA: invalid signature 's' value");
1903         } else if (error == RecoverError.InvalidSignatureV) {
1904             revert("ECDSA: invalid signature 'v' value");
1905         }
1906     }
1907 
1908     /**
1909      * @dev Returns the address that signed a hashed message (`hash`) with
1910      * `signature` or error string. This address can then be used for verification purposes.
1911      *
1912      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1913      * this function rejects them by requiring the `s` value to be in the lower
1914      * half order, and the `v` value to be either 27 or 28.
1915      *
1916      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1917      * verification to be secure: it is possible to craft signatures that
1918      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1919      * this is by receiving a hash of the original message (which may otherwise
1920      * be too long), and then calling {toEthSignedMessageHash} on it.
1921      *
1922      * Documentation for signature generation:
1923      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1924      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1925      *
1926      * _Available since v4.3._
1927      */
1928     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1929         // Check the signature length
1930         // - case 65: r,s,v signature (standard)
1931         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1932         if (signature.length == 65) {
1933             bytes32 r;
1934             bytes32 s;
1935             uint8 v;
1936             // ecrecover takes the signature parameters, and the only way to get them
1937             // currently is to use assembly.
1938             /// @solidity memory-safe-assembly
1939             assembly {
1940                 r := mload(add(signature, 0x20))
1941                 s := mload(add(signature, 0x40))
1942                 v := byte(0, mload(add(signature, 0x60)))
1943             }
1944             return tryRecover(hash, v, r, s);
1945         } else if (signature.length == 64) {
1946             bytes32 r;
1947             bytes32 vs;
1948             // ecrecover takes the signature parameters, and the only way to get them
1949             // currently is to use assembly.
1950             /// @solidity memory-safe-assembly
1951             assembly {
1952                 r := mload(add(signature, 0x20))
1953                 vs := mload(add(signature, 0x40))
1954             }
1955             return tryRecover(hash, r, vs);
1956         } else {
1957             return (address(0), RecoverError.InvalidSignatureLength);
1958         }
1959     }
1960 
1961     /**
1962      * @dev Returns the address that signed a hashed message (`hash`) with
1963      * `signature`. This address can then be used for verification purposes.
1964      *
1965      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1966      * this function rejects them by requiring the `s` value to be in the lower
1967      * half order, and the `v` value to be either 27 or 28.
1968      *
1969      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1970      * verification to be secure: it is possible to craft signatures that
1971      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1972      * this is by receiving a hash of the original message (which may otherwise
1973      * be too long), and then calling {toEthSignedMessageHash} on it.
1974      */
1975     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1976         (address recovered, RecoverError error) = tryRecover(hash, signature);
1977         _throwError(error);
1978         return recovered;
1979     }
1980 
1981     /**
1982      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1983      *
1984      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1985      *
1986      * _Available since v4.3._
1987      */
1988     function tryRecover(
1989         bytes32 hash,
1990         bytes32 r,
1991         bytes32 vs
1992     ) internal pure returns (address, RecoverError) {
1993         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1994         uint8 v = uint8((uint256(vs) >> 255) + 27);
1995         return tryRecover(hash, v, r, s);
1996     }
1997 
1998     /**
1999      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2000      *
2001      * _Available since v4.2._
2002      */
2003     function recover(
2004         bytes32 hash,
2005         bytes32 r,
2006         bytes32 vs
2007     ) internal pure returns (address) {
2008         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2009         _throwError(error);
2010         return recovered;
2011     }
2012 
2013     /**
2014      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2015      * `r` and `s` signature fields separately.
2016      *
2017      * _Available since v4.3._
2018      */
2019     function tryRecover(
2020         bytes32 hash,
2021         uint8 v,
2022         bytes32 r,
2023         bytes32 s
2024     ) internal pure returns (address, RecoverError) {
2025         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2026         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2027         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2028         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2029         //
2030         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2031         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2032         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2033         // these malleable signatures as well.
2034         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2035             return (address(0), RecoverError.InvalidSignatureS);
2036         }
2037         if (v != 27 && v != 28) {
2038             return (address(0), RecoverError.InvalidSignatureV);
2039         }
2040 
2041         // If the signature is valid (and not malleable), return the signer address
2042         address signer = ecrecover(hash, v, r, s);
2043         if (signer == address(0)) {
2044             return (address(0), RecoverError.InvalidSignature);
2045         }
2046 
2047         return (signer, RecoverError.NoError);
2048     }
2049 
2050     /**
2051      * @dev Overload of {ECDSA-recover} that receives the `v`,
2052      * `r` and `s` signature fields separately.
2053      */
2054     function recover(
2055         bytes32 hash,
2056         uint8 v,
2057         bytes32 r,
2058         bytes32 s
2059     ) internal pure returns (address) {
2060         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2061         _throwError(error);
2062         return recovered;
2063     }
2064 
2065     /**
2066      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2067      * produces hash corresponding to the one signed with the
2068      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2069      * JSON-RPC method as part of EIP-191.
2070      *
2071      * See {recover}.
2072      */
2073     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2074         // 32 is the length in bytes of hash,
2075         // enforced by the type signature above
2076         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2077     }
2078 
2079     /**
2080      * @dev Returns an Ethereum Signed Message, created from `s`. This
2081      * produces hash corresponding to the one signed with the
2082      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2083      * JSON-RPC method as part of EIP-191.
2084      *
2085      * See {recover}.
2086      */
2087     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2088         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", StringsUpgradeable.toString(s.length), s));
2089     }
2090 
2091     /**
2092      * @dev Returns an Ethereum Signed Typed Data, created from a
2093      * `domainSeparator` and a `structHash`. This produces hash corresponding
2094      * to the one signed with the
2095      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2096      * JSON-RPC method as part of EIP-712.
2097      *
2098      * See {recover}.
2099      */
2100     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2101         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2102     }
2103 }
2104 
2105 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-IERC20PermitUpgradeable.sol
2106 
2107 
2108 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
2109 
2110 pragma solidity ^0.8.0;
2111 
2112 /**
2113  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2114  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2115  *
2116  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2117  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
2118  * need to send a transaction, and thus is not required to hold Ether at all.
2119  */
2120 interface IERC20PermitUpgradeable {
2121     /**
2122      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
2123      * given ``owner``'s signed approval.
2124      *
2125      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
2126      * ordering also apply here.
2127      *
2128      * Emits an {Approval} event.
2129      *
2130      * Requirements:
2131      *
2132      * - `spender` cannot be the zero address.
2133      * - `deadline` must be a timestamp in the future.
2134      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2135      * over the EIP712-formatted function arguments.
2136      * - the signature must use ``owner``'s current nonce (see {nonces}).
2137      *
2138      * For more information on the signature format, see the
2139      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2140      * section].
2141      */
2142     function permit(
2143         address owner,
2144         address spender,
2145         uint256 value,
2146         uint256 deadline,
2147         uint8 v,
2148         bytes32 r,
2149         bytes32 s
2150     ) external;
2151 
2152     /**
2153      * @dev Returns the current nonce for `owner`. This value must be
2154      * included whenever a signature is generated for {permit}.
2155      *
2156      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2157      * prevents a signature from being used multiple times.
2158      */
2159     function nonces(address owner) external view returns (uint256);
2160 
2161     /**
2162      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2163      */
2164     // solhint-disable-next-line func-name-mixedcase
2165     function DOMAIN_SEPARATOR() external view returns (bytes32);
2166 }
2167 
2168 // File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
2169 
2170 
2171 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2172 
2173 pragma solidity ^0.8.0;
2174 
2175 /**
2176  * @dev Interface of the ERC20 standard as defined in the EIP.
2177  */
2178 interface IERC20Upgradeable {
2179     /**
2180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2181      * another (`to`).
2182      *
2183      * Note that `value` may be zero.
2184      */
2185     event Transfer(address indexed from, address indexed to, uint256 value);
2186 
2187     /**
2188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2189      * a call to {approve}. `value` is the new allowance.
2190      */
2191     event Approval(address indexed owner, address indexed spender, uint256 value);
2192 
2193     /**
2194      * @dev Returns the amount of tokens in existence.
2195      */
2196     function totalSupply() external view returns (uint256);
2197 
2198     /**
2199      * @dev Returns the amount of tokens owned by `account`.
2200      */
2201     function balanceOf(address account) external view returns (uint256);
2202 
2203     /**
2204      * @dev Moves `amount` tokens from the caller's account to `to`.
2205      *
2206      * Returns a boolean value indicating whether the operation succeeded.
2207      *
2208      * Emits a {Transfer} event.
2209      */
2210     function transfer(address to, uint256 amount) external returns (bool);
2211 
2212     /**
2213      * @dev Returns the remaining number of tokens that `spender` will be
2214      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2215      * zero by default.
2216      *
2217      * This value changes when {approve} or {transferFrom} are called.
2218      */
2219     function allowance(address owner, address spender) external view returns (uint256);
2220 
2221     /**
2222      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2223      *
2224      * Returns a boolean value indicating whether the operation succeeded.
2225      *
2226      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2227      * that someone may use both the old and the new allowance by unfortunate
2228      * transaction ordering. One possible solution to mitigate this race
2229      * condition is to first reduce the spender's allowance to 0 and set the
2230      * desired value afterwards:
2231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2232      *
2233      * Emits an {Approval} event.
2234      */
2235     function approve(address spender, uint256 amount) external returns (bool);
2236 
2237     /**
2238      * @dev Moves `amount` tokens from `from` to `to` using the
2239      * allowance mechanism. `amount` is then deducted from the caller's
2240      * allowance.
2241      *
2242      * Returns a boolean value indicating whether the operation succeeded.
2243      *
2244      * Emits a {Transfer} event.
2245      */
2246     function transferFrom(
2247         address from,
2248         address to,
2249         uint256 amount
2250     ) external returns (bool);
2251 }
2252 
2253 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol
2254 
2255 
2256 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
2257 
2258 pragma solidity ^0.8.0;
2259 
2260 
2261 /**
2262  * @dev Interface for the optional metadata functions from the ERC20 standard.
2263  *
2264  * _Available since v4.1._
2265  */
2266 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
2267     /**
2268      * @dev Returns the name of the token.
2269      */
2270     function name() external view returns (string memory);
2271 
2272     /**
2273      * @dev Returns the symbol of the token.
2274      */
2275     function symbol() external view returns (string memory);
2276 
2277     /**
2278      * @dev Returns the decimals places of the token.
2279      */
2280     function decimals() external view returns (uint8);
2281 }
2282 
2283 // File: @openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol
2284 
2285 
2286 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
2287 
2288 pragma solidity ^0.8.0;
2289 
2290 /**
2291  * @dev Library for reading and writing primitive types to specific storage slots.
2292  *
2293  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
2294  * This library helps with reading and writing to such slots without the need for inline assembly.
2295  *
2296  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
2297  *
2298  * Example usage to set ERC1967 implementation slot:
2299  * ```
2300  * contract ERC1967 {
2301  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
2302  *
2303  *     function _getImplementation() internal view returns (address) {
2304  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
2305  *     }
2306  *
2307  *     function _setImplementation(address newImplementation) internal {
2308  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
2309  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
2310  *     }
2311  * }
2312  * ```
2313  *
2314  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
2315  */
2316 library StorageSlotUpgradeable {
2317     struct AddressSlot {
2318         address value;
2319     }
2320 
2321     struct BooleanSlot {
2322         bool value;
2323     }
2324 
2325     struct Bytes32Slot {
2326         bytes32 value;
2327     }
2328 
2329     struct Uint256Slot {
2330         uint256 value;
2331     }
2332 
2333     /**
2334      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
2335      */
2336     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
2337         /// @solidity memory-safe-assembly
2338         assembly {
2339             r.slot := slot
2340         }
2341     }
2342 
2343     /**
2344      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
2345      */
2346     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
2347         /// @solidity memory-safe-assembly
2348         assembly {
2349             r.slot := slot
2350         }
2351     }
2352 
2353     /**
2354      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
2355      */
2356     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
2357         /// @solidity memory-safe-assembly
2358         assembly {
2359             r.slot := slot
2360         }
2361     }
2362 
2363     /**
2364      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
2365      */
2366     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
2367         /// @solidity memory-safe-assembly
2368         assembly {
2369             r.slot := slot
2370         }
2371     }
2372 }
2373 
2374 // File: @openzeppelin/contracts-upgradeable/proxy/beacon/IBeaconUpgradeable.sol
2375 
2376 
2377 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
2378 
2379 pragma solidity ^0.8.0;
2380 
2381 /**
2382  * @dev This is the interface that {BeaconProxy} expects of its beacon.
2383  */
2384 interface IBeaconUpgradeable {
2385     /**
2386      * @dev Must return an address that can be used as a delegate call target.
2387      *
2388      * {BeaconProxy} will check that this address is a contract.
2389      */
2390     function implementation() external view returns (address);
2391 }
2392 
2393 // File: @openzeppelin/contracts-upgradeable/interfaces/draft-IERC1822Upgradeable.sol
2394 
2395 
2396 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
2397 
2398 pragma solidity ^0.8.0;
2399 
2400 /**
2401  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
2402  * proxy whose upgrades are fully controlled by the current implementation.
2403  */
2404 interface IERC1822ProxiableUpgradeable {
2405     /**
2406      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
2407      * address.
2408      *
2409      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
2410      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
2411      * function revert if invoked through a proxy.
2412      */
2413     function proxiableUUID() external view returns (bytes32);
2414 }
2415 
2416 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
2417 
2418 
2419 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
2420 
2421 pragma solidity ^0.8.1;
2422 
2423 /**
2424  * @dev Collection of functions related to the address type
2425  */
2426 library AddressUpgradeable {
2427     /**
2428      * @dev Returns true if `account` is a contract.
2429      *
2430      * [IMPORTANT]
2431      * ====
2432      * It is unsafe to assume that an address for which this function returns
2433      * false is an externally-owned account (EOA) and not a contract.
2434      *
2435      * Among others, `isContract` will return false for the following
2436      * types of addresses:
2437      *
2438      *  - an externally-owned account
2439      *  - a contract in construction
2440      *  - an address where a contract will be created
2441      *  - an address where a contract lived, but was destroyed
2442      * ====
2443      *
2444      * [IMPORTANT]
2445      * ====
2446      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2447      *
2448      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2449      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2450      * constructor.
2451      * ====
2452      */
2453     function isContract(address account) internal view returns (bool) {
2454         // This method relies on extcodesize/address.code.length, which returns 0
2455         // for contracts in construction, since the code is only stored at the end
2456         // of the constructor execution.
2457 
2458         return account.code.length > 0;
2459     }
2460 
2461     /**
2462      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2463      * `recipient`, forwarding all available gas and reverting on errors.
2464      *
2465      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2466      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2467      * imposed by `transfer`, making them unable to receive funds via
2468      * `transfer`. {sendValue} removes this limitation.
2469      *
2470      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2471      *
2472      * IMPORTANT: because control is transferred to `recipient`, care must be
2473      * taken to not create reentrancy vulnerabilities. Consider using
2474      * {ReentrancyGuard} or the
2475      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2476      */
2477     function sendValue(address payable recipient, uint256 amount) internal {
2478         require(address(this).balance >= amount, "Address: insufficient balance");
2479 
2480         (bool success, ) = recipient.call{value: amount}("");
2481         require(success, "Address: unable to send value, recipient may have reverted");
2482     }
2483 
2484     /**
2485      * @dev Performs a Solidity function call using a low level `call`. A
2486      * plain `call` is an unsafe replacement for a function call: use this
2487      * function instead.
2488      *
2489      * If `target` reverts with a revert reason, it is bubbled up by this
2490      * function (like regular Solidity function calls).
2491      *
2492      * Returns the raw returned data. To convert to the expected return value,
2493      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2494      *
2495      * Requirements:
2496      *
2497      * - `target` must be a contract.
2498      * - calling `target` with `data` must not revert.
2499      *
2500      * _Available since v3.1._
2501      */
2502     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2503         return functionCall(target, data, "Address: low-level call failed");
2504     }
2505 
2506     /**
2507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2508      * `errorMessage` as a fallback revert reason when `target` reverts.
2509      *
2510      * _Available since v3.1._
2511      */
2512     function functionCall(
2513         address target,
2514         bytes memory data,
2515         string memory errorMessage
2516     ) internal returns (bytes memory) {
2517         return functionCallWithValue(target, data, 0, errorMessage);
2518     }
2519 
2520     /**
2521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2522      * but also transferring `value` wei to `target`.
2523      *
2524      * Requirements:
2525      *
2526      * - the calling contract must have an ETH balance of at least `value`.
2527      * - the called Solidity function must be `payable`.
2528      *
2529      * _Available since v3.1._
2530      */
2531     function functionCallWithValue(
2532         address target,
2533         bytes memory data,
2534         uint256 value
2535     ) internal returns (bytes memory) {
2536         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2537     }
2538 
2539     /**
2540      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2541      * with `errorMessage` as a fallback revert reason when `target` reverts.
2542      *
2543      * _Available since v3.1._
2544      */
2545     function functionCallWithValue(
2546         address target,
2547         bytes memory data,
2548         uint256 value,
2549         string memory errorMessage
2550     ) internal returns (bytes memory) {
2551         require(address(this).balance >= value, "Address: insufficient balance for call");
2552         require(isContract(target), "Address: call to non-contract");
2553 
2554         (bool success, bytes memory returndata) = target.call{value: value}(data);
2555         return verifyCallResult(success, returndata, errorMessage);
2556     }
2557 
2558     /**
2559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2560      * but performing a static call.
2561      *
2562      * _Available since v3.3._
2563      */
2564     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2565         return functionStaticCall(target, data, "Address: low-level static call failed");
2566     }
2567 
2568     /**
2569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2570      * but performing a static call.
2571      *
2572      * _Available since v3.3._
2573      */
2574     function functionStaticCall(
2575         address target,
2576         bytes memory data,
2577         string memory errorMessage
2578     ) internal view returns (bytes memory) {
2579         require(isContract(target), "Address: static call to non-contract");
2580 
2581         (bool success, bytes memory returndata) = target.staticcall(data);
2582         return verifyCallResult(success, returndata, errorMessage);
2583     }
2584 
2585     /**
2586      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2587      * revert reason using the provided one.
2588      *
2589      * _Available since v4.3._
2590      */
2591     function verifyCallResult(
2592         bool success,
2593         bytes memory returndata,
2594         string memory errorMessage
2595     ) internal pure returns (bytes memory) {
2596         if (success) {
2597             return returndata;
2598         } else {
2599             // Look for revert reason and bubble it up if present
2600             if (returndata.length > 0) {
2601                 // The easiest way to bubble the revert reason is using memory via assembly
2602                 /// @solidity memory-safe-assembly
2603                 assembly {
2604                     let returndata_size := mload(returndata)
2605                     revert(add(32, returndata), returndata_size)
2606                 }
2607             } else {
2608                 revert(errorMessage);
2609             }
2610         }
2611     }
2612 }
2613 
2614 // File: @openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol
2615 
2616 
2617 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
2618 
2619 pragma solidity ^0.8.0;
2620 
2621 
2622 
2623 
2624 /**
2625  * @title SafeERC20
2626  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2627  * contract returns false). Tokens that return no value (and instead revert or
2628  * throw on failure) are also supported, non-reverting calls are assumed to be
2629  * successful.
2630  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2631  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2632  */
2633 library SafeERC20Upgradeable {
2634     using AddressUpgradeable for address;
2635 
2636     function safeTransfer(
2637         IERC20Upgradeable token,
2638         address to,
2639         uint256 value
2640     ) internal {
2641         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2642     }
2643 
2644     function safeTransferFrom(
2645         IERC20Upgradeable token,
2646         address from,
2647         address to,
2648         uint256 value
2649     ) internal {
2650         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2651     }
2652 
2653     /**
2654      * @dev Deprecated. This function has issues similar to the ones found in
2655      * {IERC20-approve}, and its usage is discouraged.
2656      *
2657      * Whenever possible, use {safeIncreaseAllowance} and
2658      * {safeDecreaseAllowance} instead.
2659      */
2660     function safeApprove(
2661         IERC20Upgradeable token,
2662         address spender,
2663         uint256 value
2664     ) internal {
2665         // safeApprove should only be called when setting an initial allowance,
2666         // or when resetting it to zero. To increase and decrease it, use
2667         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2668         require(
2669             (value == 0) || (token.allowance(address(this), spender) == 0),
2670             "SafeERC20: approve from non-zero to non-zero allowance"
2671         );
2672         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2673     }
2674 
2675     function safeIncreaseAllowance(
2676         IERC20Upgradeable token,
2677         address spender,
2678         uint256 value
2679     ) internal {
2680         uint256 newAllowance = token.allowance(address(this), spender) + value;
2681         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2682     }
2683 
2684     function safeDecreaseAllowance(
2685         IERC20Upgradeable token,
2686         address spender,
2687         uint256 value
2688     ) internal {
2689         unchecked {
2690             uint256 oldAllowance = token.allowance(address(this), spender);
2691             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2692             uint256 newAllowance = oldAllowance - value;
2693             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2694         }
2695     }
2696 
2697     function safePermit(
2698         IERC20PermitUpgradeable token,
2699         address owner,
2700         address spender,
2701         uint256 value,
2702         uint256 deadline,
2703         uint8 v,
2704         bytes32 r,
2705         bytes32 s
2706     ) internal {
2707         uint256 nonceBefore = token.nonces(owner);
2708         token.permit(owner, spender, value, deadline, v, r, s);
2709         uint256 nonceAfter = token.nonces(owner);
2710         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2711     }
2712 
2713     /**
2714      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2715      * on the return value: the return value is optional (but if data is returned, it must not be false).
2716      * @param token The token targeted by the call.
2717      * @param data The call data (encoded using abi.encode or one of its variants).
2718      */
2719     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
2720         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2721         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2722         // the target address contains contract code and also asserts for success in the low-level call.
2723 
2724         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2725         if (returndata.length > 0) {
2726             // Return data is optional
2727             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2728         }
2729     }
2730 }
2731 
2732 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
2733 
2734 
2735 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/utils/Initializable.sol)
2736 
2737 pragma solidity ^0.8.2;
2738 
2739 
2740 /**
2741  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
2742  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
2743  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
2744  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
2745  *
2746  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
2747  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
2748  * case an upgrade adds a module that needs to be initialized.
2749  *
2750  * For example:
2751  *
2752  * [.hljs-theme-light.nopadding]
2753  * ```
2754  * contract MyToken is ERC20Upgradeable {
2755  *     function initialize() initializer public {
2756  *         __ERC20_init("MyToken", "MTK");
2757  *     }
2758  * }
2759  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
2760  *     function initializeV2() reinitializer(2) public {
2761  *         __ERC20Permit_init("MyToken");
2762  *     }
2763  * }
2764  * ```
2765  *
2766  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
2767  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
2768  *
2769  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
2770  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
2771  *
2772  * [CAUTION]
2773  * ====
2774  * Avoid leaving a contract uninitialized.
2775  *
2776  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
2777  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
2778  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
2779  *
2780  * [.hljs-theme-light.nopadding]
2781  * ```
2782  * /// @custom:oz-upgrades-unsafe-allow constructor
2783  * constructor() {
2784  *     _disableInitializers();
2785  * }
2786  * ```
2787  * ====
2788  */
2789 abstract contract Initializable {
2790     /**
2791      * @dev Indicates that the contract has been initialized.
2792      * @custom:oz-retyped-from bool
2793      */
2794     uint8 private _initialized;
2795 
2796     /**
2797      * @dev Indicates that the contract is in the process of being initialized.
2798      */
2799     bool private _initializing;
2800 
2801     /**
2802      * @dev Triggered when the contract has been initialized or reinitialized.
2803      */
2804     event Initialized(uint8 version);
2805 
2806     /**
2807      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
2808      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
2809      */
2810     modifier initializer() {
2811         bool isTopLevelCall = !_initializing;
2812         require(
2813             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
2814             "Initializable: contract is already initialized"
2815         );
2816         _initialized = 1;
2817         if (isTopLevelCall) {
2818             _initializing = true;
2819         }
2820         _;
2821         if (isTopLevelCall) {
2822             _initializing = false;
2823             emit Initialized(1);
2824         }
2825     }
2826 
2827     /**
2828      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
2829      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
2830      * used to initialize parent contracts.
2831      *
2832      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
2833      * initialization step. This is essential to configure modules that are added through upgrades and that require
2834      * initialization.
2835      *
2836      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
2837      * a contract, executing them in the right order is up to the developer or operator.
2838      */
2839     modifier reinitializer(uint8 version) {
2840         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
2841         _initialized = version;
2842         _initializing = true;
2843         _;
2844         _initializing = false;
2845         emit Initialized(version);
2846     }
2847 
2848     /**
2849      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
2850      * {initializer} and {reinitializer} modifiers, directly or indirectly.
2851      */
2852     modifier onlyInitializing() {
2853         require(_initializing, "Initializable: contract is not initializing");
2854         _;
2855     }
2856 
2857     /**
2858      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
2859      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
2860      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
2861      * through proxies.
2862      */
2863     function _disableInitializers() internal virtual {
2864         require(!_initializing, "Initializable: contract is initializing");
2865         if (_initialized < type(uint8).max) {
2866             _initialized = type(uint8).max;
2867             emit Initialized(type(uint8).max);
2868         }
2869     }
2870 }
2871 
2872 // File: @openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol
2873 
2874 
2875 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
2876 
2877 pragma solidity ^0.8.0;
2878 
2879 
2880 
2881 /**
2882  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
2883  *
2884  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
2885  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
2886  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
2887  *
2888  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
2889  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
2890  * ({_hashTypedDataV4}).
2891  *
2892  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
2893  * the chain id to protect against replay attacks on an eventual fork of the chain.
2894  *
2895  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
2896  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
2897  *
2898  * _Available since v3.4._
2899  *
2900  * @custom:storage-size 52
2901  */
2902 abstract contract EIP712Upgradeable is Initializable {
2903     /* solhint-disable var-name-mixedcase */
2904     bytes32 private _HASHED_NAME;
2905     bytes32 private _HASHED_VERSION;
2906     bytes32 private constant _TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
2907 
2908     /* solhint-enable var-name-mixedcase */
2909 
2910     /**
2911      * @dev Initializes the domain separator and parameter caches.
2912      *
2913      * The meaning of `name` and `version` is specified in
2914      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
2915      *
2916      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
2917      * - `version`: the current major version of the signing domain.
2918      *
2919      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
2920      * contract upgrade].
2921      */
2922     function __EIP712_init(string memory name, string memory version) internal onlyInitializing {
2923         __EIP712_init_unchained(name, version);
2924     }
2925 
2926     function __EIP712_init_unchained(string memory name, string memory version) internal onlyInitializing {
2927         bytes32 hashedName = keccak256(bytes(name));
2928         bytes32 hashedVersion = keccak256(bytes(version));
2929         _HASHED_NAME = hashedName;
2930         _HASHED_VERSION = hashedVersion;
2931     }
2932 
2933     /**
2934      * @dev Returns the domain separator for the current chain.
2935      */
2936     function _domainSeparatorV4() internal view returns (bytes32) {
2937         return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
2938     }
2939 
2940     function _buildDomainSeparator(
2941         bytes32 typeHash,
2942         bytes32 nameHash,
2943         bytes32 versionHash
2944     ) private view returns (bytes32) {
2945         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
2946     }
2947 
2948     /**
2949      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
2950      * function returns the hash of the fully encoded EIP712 message for this domain.
2951      *
2952      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
2953      *
2954      * ```solidity
2955      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
2956      *     keccak256("Mail(address to,string contents)"),
2957      *     mailTo,
2958      *     keccak256(bytes(mailContents))
2959      * )));
2960      * address signer = ECDSA.recover(digest, signature);
2961      * ```
2962      */
2963     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
2964         return ECDSAUpgradeable.toTypedDataHash(_domainSeparatorV4(), structHash);
2965     }
2966 
2967     /**
2968      * @dev The hash of the name parameter for the EIP712 domain.
2969      *
2970      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
2971      * are a concern.
2972      */
2973     function _EIP712NameHash() internal virtual view returns (bytes32) {
2974         return _HASHED_NAME;
2975     }
2976 
2977     /**
2978      * @dev The hash of the version parameter for the EIP712 domain.
2979      *
2980      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
2981      * are a concern.
2982      */
2983     function _EIP712VersionHash() internal virtual view returns (bytes32) {
2984         return _HASHED_VERSION;
2985     }
2986 
2987     /**
2988      * @dev This empty reserved space is put in place to allow future versions to add new
2989      * variables without shifting down storage in the inheritance chain.
2990      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
2991      */
2992     uint256[50] private __gap;
2993 }
2994 
2995 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
2996 
2997 
2998 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2999 
3000 pragma solidity ^0.8.0;
3001 
3002 
3003 /**
3004  * @dev Provides information about the current execution context, including the
3005  * sender of the transaction and its data. While these are generally available
3006  * via msg.sender and msg.data, they should not be accessed in such a direct
3007  * manner, since when dealing with meta-transactions the account sending and
3008  * paying for execution may not be the actual sender (as far as an application
3009  * is concerned).
3010  *
3011  * This contract is only required for intermediate, library-like contracts.
3012  */
3013 abstract contract ContextUpgradeable is Initializable {
3014     function __Context_init() internal onlyInitializing {
3015     }
3016 
3017     function __Context_init_unchained() internal onlyInitializing {
3018     }
3019     function _msgSender() internal view virtual returns (address) {
3020         return msg.sender;
3021     }
3022 
3023     function _msgData() internal view virtual returns (bytes calldata) {
3024         return msg.data;
3025     }
3026 
3027     /**
3028      * @dev This empty reserved space is put in place to allow future versions to add new
3029      * variables without shifting down storage in the inheritance chain.
3030      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3031      */
3032     uint256[50] private __gap;
3033 }
3034 
3035 // File: @openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol
3036 
3037 
3038 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
3039 
3040 pragma solidity ^0.8.0;
3041 
3042 
3043 
3044 /**
3045  * @dev Contract module which allows children to implement an emergency stop
3046  * mechanism that can be triggered by an authorized account.
3047  *
3048  * This module is used through inheritance. It will make available the
3049  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
3050  * the functions of your contract. Note that they will not be pausable by
3051  * simply including this module, only once the modifiers are put in place.
3052  */
3053 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
3054     /**
3055      * @dev Emitted when the pause is triggered by `account`.
3056      */
3057     event Paused(address account);
3058 
3059     /**
3060      * @dev Emitted when the pause is lifted by `account`.
3061      */
3062     event Unpaused(address account);
3063 
3064     bool private _paused;
3065 
3066     /**
3067      * @dev Initializes the contract in unpaused state.
3068      */
3069     function __Pausable_init() internal onlyInitializing {
3070         __Pausable_init_unchained();
3071     }
3072 
3073     function __Pausable_init_unchained() internal onlyInitializing {
3074         _paused = false;
3075     }
3076 
3077     /**
3078      * @dev Modifier to make a function callable only when the contract is not paused.
3079      *
3080      * Requirements:
3081      *
3082      * - The contract must not be paused.
3083      */
3084     modifier whenNotPaused() {
3085         _requireNotPaused();
3086         _;
3087     }
3088 
3089     /**
3090      * @dev Modifier to make a function callable only when the contract is paused.
3091      *
3092      * Requirements:
3093      *
3094      * - The contract must be paused.
3095      */
3096     modifier whenPaused() {
3097         _requirePaused();
3098         _;
3099     }
3100 
3101     /**
3102      * @dev Returns true if the contract is paused, and false otherwise.
3103      */
3104     function paused() public view virtual returns (bool) {
3105         return _paused;
3106     }
3107 
3108     /**
3109      * @dev Throws if the contract is paused.
3110      */
3111     function _requireNotPaused() internal view virtual {
3112         require(!paused(), "Pausable: paused");
3113     }
3114 
3115     /**
3116      * @dev Throws if the contract is not paused.
3117      */
3118     function _requirePaused() internal view virtual {
3119         require(paused(), "Pausable: not paused");
3120     }
3121 
3122     /**
3123      * @dev Triggers stopped state.
3124      *
3125      * Requirements:
3126      *
3127      * - The contract must not be paused.
3128      */
3129     function _pause() internal virtual whenNotPaused {
3130         _paused = true;
3131         emit Paused(_msgSender());
3132     }
3133 
3134     /**
3135      * @dev Returns to normal state.
3136      *
3137      * Requirements:
3138      *
3139      * - The contract must be paused.
3140      */
3141     function _unpause() internal virtual whenPaused {
3142         _paused = false;
3143         emit Unpaused(_msgSender());
3144     }
3145 
3146     /**
3147      * @dev This empty reserved space is put in place to allow future versions to add new
3148      * variables without shifting down storage in the inheritance chain.
3149      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3150      */
3151     uint256[49] private __gap;
3152 }
3153 
3154 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
3155 
3156 
3157 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
3158 
3159 pragma solidity ^0.8.0;
3160 
3161 
3162 
3163 /**
3164  * @dev Contract module which provides a basic access control mechanism, where
3165  * there is an account (an owner) that can be granted exclusive access to
3166  * specific functions.
3167  *
3168  * By default, the owner account will be the one that deploys the contract. This
3169  * can later be changed with {transferOwnership}.
3170  *
3171  * This module is used through inheritance. It will make available the modifier
3172  * `onlyOwner`, which can be applied to your functions to restrict their use to
3173  * the owner.
3174  */
3175 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
3176     address private _owner;
3177 
3178     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3179 
3180     /**
3181      * @dev Initializes the contract setting the deployer as the initial owner.
3182      */
3183     function __Ownable_init() internal onlyInitializing {
3184         __Ownable_init_unchained();
3185     }
3186 
3187     function __Ownable_init_unchained() internal onlyInitializing {
3188         _transferOwnership(_msgSender());
3189     }
3190 
3191     /**
3192      * @dev Throws if called by any account other than the owner.
3193      */
3194     modifier onlyOwner() {
3195         _checkOwner();
3196         _;
3197     }
3198 
3199     /**
3200      * @dev Returns the address of the current owner.
3201      */
3202     function owner() public view virtual returns (address) {
3203         return _owner;
3204     }
3205 
3206     /**
3207      * @dev Throws if the sender is not the owner.
3208      */
3209     function _checkOwner() internal view virtual {
3210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3211     }
3212 
3213     /**
3214      * @dev Leaves the contract without owner. It will not be possible to call
3215      * `onlyOwner` functions anymore. Can only be called by the current owner.
3216      *
3217      * NOTE: Renouncing ownership will leave the contract without an owner,
3218      * thereby removing any functionality that is only available to the owner.
3219      */
3220     function renounceOwnership() public virtual onlyOwner {
3221         _transferOwnership(address(0));
3222     }
3223 
3224     /**
3225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3226      * Can only be called by the current owner.
3227      */
3228     function transferOwnership(address newOwner) public virtual onlyOwner {
3229         require(newOwner != address(0), "Ownable: new owner is the zero address");
3230         _transferOwnership(newOwner);
3231     }
3232 
3233     /**
3234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3235      * Internal function without access restriction.
3236      */
3237     function _transferOwnership(address newOwner) internal virtual {
3238         address oldOwner = _owner;
3239         _owner = newOwner;
3240         emit OwnershipTransferred(oldOwner, newOwner);
3241     }
3242 
3243     /**
3244      * @dev This empty reserved space is put in place to allow future versions to add new
3245      * variables without shifting down storage in the inheritance chain.
3246      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3247      */
3248     uint256[49] private __gap;
3249 }
3250 
3251 // File: @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
3252 
3253 
3254 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
3255 
3256 pragma solidity ^0.8.0;
3257 
3258 
3259 
3260 
3261 
3262 /**
3263  * @dev Implementation of the {IERC20} interface.
3264  *
3265  * This implementation is agnostic to the way tokens are created. This means
3266  * that a supply mechanism has to be added in a derived contract using {_mint}.
3267  * For a generic mechanism see {ERC20PresetMinterPauser}.
3268  *
3269  * TIP: For a detailed writeup see our guide
3270  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
3271  * to implement supply mechanisms].
3272  *
3273  * We have followed general OpenZeppelin Contracts guidelines: functions revert
3274  * instead returning `false` on failure. This behavior is nonetheless
3275  * conventional and does not conflict with the expectations of ERC20
3276  * applications.
3277  *
3278  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
3279  * This allows applications to reconstruct the allowance for all accounts just
3280  * by listening to said events. Other implementations of the EIP may not emit
3281  * these events, as it isn't required by the specification.
3282  *
3283  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
3284  * functions have been added to mitigate the well-known issues around setting
3285  * allowances. See {IERC20-approve}.
3286  */
3287 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
3288     mapping(address => uint256) private _balances;
3289 
3290     mapping(address => mapping(address => uint256)) private _allowances;
3291 
3292     uint256 private _totalSupply;
3293 
3294     string private _name;
3295     string private _symbol;
3296 
3297     /**
3298      * @dev Sets the values for {name} and {symbol}.
3299      *
3300      * The default value of {decimals} is 18. To select a different value for
3301      * {decimals} you should overload it.
3302      *
3303      * All two of these values are immutable: they can only be set once during
3304      * construction.
3305      */
3306     function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
3307         __ERC20_init_unchained(name_, symbol_);
3308     }
3309 
3310     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
3311         _name = name_;
3312         _symbol = symbol_;
3313     }
3314 
3315     /**
3316      * @dev Returns the name of the token.
3317      */
3318     function name() public view virtual override returns (string memory) {
3319         return _name;
3320     }
3321 
3322     /**
3323      * @dev Returns the symbol of the token, usually a shorter version of the
3324      * name.
3325      */
3326     function symbol() public view virtual override returns (string memory) {
3327         return _symbol;
3328     }
3329 
3330     /**
3331      * @dev Returns the number of decimals used to get its user representation.
3332      * For example, if `decimals` equals `2`, a balance of `505` tokens should
3333      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
3334      *
3335      * Tokens usually opt for a value of 18, imitating the relationship between
3336      * Ether and Wei. This is the value {ERC20} uses, unless this function is
3337      * overridden;
3338      *
3339      * NOTE: This information is only used for _display_ purposes: it in
3340      * no way affects any of the arithmetic of the contract, including
3341      * {IERC20-balanceOf} and {IERC20-transfer}.
3342      */
3343     function decimals() public view virtual override returns (uint8) {
3344         return 18;
3345     }
3346 
3347     /**
3348      * @dev See {IERC20-totalSupply}.
3349      */
3350     function totalSupply() public view virtual override returns (uint256) {
3351         return _totalSupply;
3352     }
3353 
3354     /**
3355      * @dev See {IERC20-balanceOf}.
3356      */
3357     function balanceOf(address account) public view virtual override returns (uint256) {
3358         return _balances[account];
3359     }
3360 
3361     /**
3362      * @dev See {IERC20-transfer}.
3363      *
3364      * Requirements:
3365      *
3366      * - `to` cannot be the zero address.
3367      * - the caller must have a balance of at least `amount`.
3368      */
3369     function transfer(address to, uint256 amount) public virtual override returns (bool) {
3370         address owner = _msgSender();
3371         _transfer(owner, to, amount);
3372         return true;
3373     }
3374 
3375     /**
3376      * @dev See {IERC20-allowance}.
3377      */
3378     function allowance(address owner, address spender) public view virtual override returns (uint256) {
3379         return _allowances[owner][spender];
3380     }
3381 
3382     /**
3383      * @dev See {IERC20-approve}.
3384      *
3385      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
3386      * `transferFrom`. This is semantically equivalent to an infinite approval.
3387      *
3388      * Requirements:
3389      *
3390      * - `spender` cannot be the zero address.
3391      */
3392     function approve(address spender, uint256 amount) public virtual override returns (bool) {
3393         address owner = _msgSender();
3394         _approve(owner, spender, amount);
3395         return true;
3396     }
3397 
3398     /**
3399      * @dev See {IERC20-transferFrom}.
3400      *
3401      * Emits an {Approval} event indicating the updated allowance. This is not
3402      * required by the EIP. See the note at the beginning of {ERC20}.
3403      *
3404      * NOTE: Does not update the allowance if the current allowance
3405      * is the maximum `uint256`.
3406      *
3407      * Requirements:
3408      *
3409      * - `from` and `to` cannot be the zero address.
3410      * - `from` must have a balance of at least `amount`.
3411      * - the caller must have allowance for ``from``'s tokens of at least
3412      * `amount`.
3413      */
3414     function transferFrom(
3415         address from,
3416         address to,
3417         uint256 amount
3418     ) public virtual override returns (bool) {
3419         address spender = _msgSender();
3420         _spendAllowance(from, spender, amount);
3421         _transfer(from, to, amount);
3422         return true;
3423     }
3424 
3425     /**
3426      * @dev Atomically increases the allowance granted to `spender` by the caller.
3427      *
3428      * This is an alternative to {approve} that can be used as a mitigation for
3429      * problems described in {IERC20-approve}.
3430      *
3431      * Emits an {Approval} event indicating the updated allowance.
3432      *
3433      * Requirements:
3434      *
3435      * - `spender` cannot be the zero address.
3436      */
3437     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
3438         address owner = _msgSender();
3439         _approve(owner, spender, allowance(owner, spender) + addedValue);
3440         return true;
3441     }
3442 
3443     /**
3444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
3445      *
3446      * This is an alternative to {approve} that can be used as a mitigation for
3447      * problems described in {IERC20-approve}.
3448      *
3449      * Emits an {Approval} event indicating the updated allowance.
3450      *
3451      * Requirements:
3452      *
3453      * - `spender` cannot be the zero address.
3454      * - `spender` must have allowance for the caller of at least
3455      * `subtractedValue`.
3456      */
3457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
3458         address owner = _msgSender();
3459         uint256 currentAllowance = allowance(owner, spender);
3460         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
3461         unchecked {
3462             _approve(owner, spender, currentAllowance - subtractedValue);
3463         }
3464 
3465         return true;
3466     }
3467 
3468     /**
3469      * @dev Moves `amount` of tokens from `from` to `to`.
3470      *
3471      * This internal function is equivalent to {transfer}, and can be used to
3472      * e.g. implement automatic token fees, slashing mechanisms, etc.
3473      *
3474      * Emits a {Transfer} event.
3475      *
3476      * Requirements:
3477      *
3478      * - `from` cannot be the zero address.
3479      * - `to` cannot be the zero address.
3480      * - `from` must have a balance of at least `amount`.
3481      */
3482     function _transfer(
3483         address from,
3484         address to,
3485         uint256 amount
3486     ) internal virtual {
3487         require(from != address(0), "ERC20: transfer from the zero address");
3488         require(to != address(0), "ERC20: transfer to the zero address");
3489 
3490         _beforeTokenTransfer(from, to, amount);
3491 
3492         uint256 fromBalance = _balances[from];
3493         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
3494         unchecked {
3495             _balances[from] = fromBalance - amount;
3496         }
3497         _balances[to] += amount;
3498 
3499         emit Transfer(from, to, amount);
3500 
3501         _afterTokenTransfer(from, to, amount);
3502     }
3503 
3504     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
3505      * the total supply.
3506      *
3507      * Emits a {Transfer} event with `from` set to the zero address.
3508      *
3509      * Requirements:
3510      *
3511      * - `account` cannot be the zero address.
3512      */
3513     function _mint(address account, uint256 amount) internal virtual {
3514         require(account != address(0), "ERC20: mint to the zero address");
3515 
3516         _beforeTokenTransfer(address(0), account, amount);
3517 
3518         _totalSupply += amount;
3519         _balances[account] += amount;
3520         emit Transfer(address(0), account, amount);
3521 
3522         _afterTokenTransfer(address(0), account, amount);
3523     }
3524 
3525     /**
3526      * @dev Destroys `amount` tokens from `account`, reducing the
3527      * total supply.
3528      *
3529      * Emits a {Transfer} event with `to` set to the zero address.
3530      *
3531      * Requirements:
3532      *
3533      * - `account` cannot be the zero address.
3534      * - `account` must have at least `amount` tokens.
3535      */
3536     function _burn(address account, uint256 amount) internal virtual {
3537         require(account != address(0), "ERC20: burn from the zero address");
3538 
3539         _beforeTokenTransfer(account, address(0), amount);
3540 
3541         uint256 accountBalance = _balances[account];
3542         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
3543         unchecked {
3544             _balances[account] = accountBalance - amount;
3545         }
3546         _totalSupply -= amount;
3547 
3548         emit Transfer(account, address(0), amount);
3549 
3550         _afterTokenTransfer(account, address(0), amount);
3551     }
3552 
3553     /**
3554      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
3555      *
3556      * This internal function is equivalent to `approve`, and can be used to
3557      * e.g. set automatic allowances for certain subsystems, etc.
3558      *
3559      * Emits an {Approval} event.
3560      *
3561      * Requirements:
3562      *
3563      * - `owner` cannot be the zero address.
3564      * - `spender` cannot be the zero address.
3565      */
3566     function _approve(
3567         address owner,
3568         address spender,
3569         uint256 amount
3570     ) internal virtual {
3571         require(owner != address(0), "ERC20: approve from the zero address");
3572         require(spender != address(0), "ERC20: approve to the zero address");
3573 
3574         _allowances[owner][spender] = amount;
3575         emit Approval(owner, spender, amount);
3576     }
3577 
3578     /**
3579      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
3580      *
3581      * Does not update the allowance amount in case of infinite allowance.
3582      * Revert if not enough allowance is available.
3583      *
3584      * Might emit an {Approval} event.
3585      */
3586     function _spendAllowance(
3587         address owner,
3588         address spender,
3589         uint256 amount
3590     ) internal virtual {
3591         uint256 currentAllowance = allowance(owner, spender);
3592         if (currentAllowance != type(uint256).max) {
3593             require(currentAllowance >= amount, "ERC20: insufficient allowance");
3594             unchecked {
3595                 _approve(owner, spender, currentAllowance - amount);
3596             }
3597         }
3598     }
3599 
3600     /**
3601      * @dev Hook that is called before any transfer of tokens. This includes
3602      * minting and burning.
3603      *
3604      * Calling conditions:
3605      *
3606      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3607      * will be transferred to `to`.
3608      * - when `from` is zero, `amount` tokens will be minted for `to`.
3609      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
3610      * - `from` and `to` are never both zero.
3611      *
3612      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3613      */
3614     function _beforeTokenTransfer(
3615         address from,
3616         address to,
3617         uint256 amount
3618     ) internal virtual {}
3619 
3620     /**
3621      * @dev Hook that is called after any transfer of tokens. This includes
3622      * minting and burning.
3623      *
3624      * Calling conditions:
3625      *
3626      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3627      * has been transferred to `to`.
3628      * - when `from` is zero, `amount` tokens have been minted for `to`.
3629      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
3630      * - `from` and `to` are never both zero.
3631      *
3632      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3633      */
3634     function _afterTokenTransfer(
3635         address from,
3636         address to,
3637         uint256 amount
3638     ) internal virtual {}
3639 
3640     /**
3641      * @dev This empty reserved space is put in place to allow future versions to add new
3642      * variables without shifting down storage in the inheritance chain.
3643      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3644      */
3645     uint256[45] private __gap;
3646 }
3647 
3648 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol
3649 
3650 
3651 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
3652 
3653 pragma solidity ^0.8.0;
3654 
3655 
3656 
3657 
3658 
3659 
3660 
3661 /**
3662  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
3663  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
3664  *
3665  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
3666  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
3667  * need to send a transaction, and thus is not required to hold Ether at all.
3668  *
3669  * _Available since v3.4._
3670  *
3671  * @custom:storage-size 51
3672  */
3673 abstract contract ERC20PermitUpgradeable is Initializable, ERC20Upgradeable, IERC20PermitUpgradeable, EIP712Upgradeable {
3674     using CountersUpgradeable for CountersUpgradeable.Counter;
3675 
3676     mapping(address => CountersUpgradeable.Counter) private _nonces;
3677 
3678     // solhint-disable-next-line var-name-mixedcase
3679     bytes32 private constant _PERMIT_TYPEHASH =
3680         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
3681     /**
3682      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
3683      * However, to ensure consistency with the upgradeable transpiler, we will continue
3684      * to reserve a slot.
3685      * @custom:oz-renamed-from _PERMIT_TYPEHASH
3686      */
3687     // solhint-disable-next-line var-name-mixedcase
3688     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
3689 
3690     /**
3691      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
3692      *
3693      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
3694      */
3695     function __ERC20Permit_init(string memory name) internal onlyInitializing {
3696         __EIP712_init_unchained(name, "1");
3697     }
3698 
3699     function __ERC20Permit_init_unchained(string memory) internal onlyInitializing {}
3700 
3701     /**
3702      * @dev See {IERC20Permit-permit}.
3703      */
3704     function permit(
3705         address owner,
3706         address spender,
3707         uint256 value,
3708         uint256 deadline,
3709         uint8 v,
3710         bytes32 r,
3711         bytes32 s
3712     ) public virtual override {
3713         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
3714 
3715         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
3716 
3717         bytes32 hash = _hashTypedDataV4(structHash);
3718 
3719         address signer = ECDSAUpgradeable.recover(hash, v, r, s);
3720         require(signer == owner, "ERC20Permit: invalid signature");
3721 
3722         _approve(owner, spender, value);
3723     }
3724 
3725     /**
3726      * @dev See {IERC20Permit-nonces}.
3727      */
3728     function nonces(address owner) public view virtual override returns (uint256) {
3729         return _nonces[owner].current();
3730     }
3731 
3732     /**
3733      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
3734      */
3735     // solhint-disable-next-line func-name-mixedcase
3736     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
3737         return _domainSeparatorV4();
3738     }
3739 
3740     /**
3741      * @dev "Consume a nonce": return the current value and increment.
3742      *
3743      * _Available since v4.1._
3744      */
3745     function _useNonce(address owner) internal virtual returns (uint256 current) {
3746         CountersUpgradeable.Counter storage nonce = _nonces[owner];
3747         current = nonce.current();
3748         nonce.increment();
3749     }
3750 
3751     /**
3752      * @dev This empty reserved space is put in place to allow future versions to add new
3753      * variables without shifting down storage in the inheritance chain.
3754      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3755      */
3756     uint256[49] private __gap;
3757 }
3758 
3759 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol
3760 
3761 
3762 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Votes.sol)
3763 
3764 pragma solidity ^0.8.0;
3765 
3766 
3767 
3768 
3769 
3770 
3771 
3772 /**
3773  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
3774  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
3775  *
3776  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
3777  *
3778  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
3779  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
3780  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
3781  *
3782  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
3783  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
3784  *
3785  * _Available since v4.2._
3786  */
3787 abstract contract ERC20VotesUpgradeable is Initializable, IVotesUpgradeable, ERC20PermitUpgradeable {
3788     function __ERC20Votes_init() internal onlyInitializing {
3789     }
3790 
3791     function __ERC20Votes_init_unchained() internal onlyInitializing {
3792     }
3793     struct Checkpoint {
3794         uint32 fromBlock;
3795         uint224 votes;
3796     }
3797 
3798     bytes32 private constant _DELEGATION_TYPEHASH =
3799         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
3800 
3801     mapping(address => address) private _delegates;
3802     mapping(address => Checkpoint[]) private _checkpoints;
3803     Checkpoint[] private _totalSupplyCheckpoints;
3804 
3805     /**
3806      * @dev Get the `pos`-th checkpoint for `account`.
3807      */
3808     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
3809         return _checkpoints[account][pos];
3810     }
3811 
3812     /**
3813      * @dev Get number of checkpoints for `account`.
3814      */
3815     function numCheckpoints(address account) public view virtual returns (uint32) {
3816         return SafeCastUpgradeable.toUint32(_checkpoints[account].length);
3817     }
3818 
3819     /**
3820      * @dev Get the address `account` is currently delegating to.
3821      */
3822     function delegates(address account) public view virtual override returns (address) {
3823         return _delegates[account];
3824     }
3825 
3826     /**
3827      * @dev Gets the current votes balance for `account`
3828      */
3829     function getVotes(address account) public view virtual override returns (uint256) {
3830         uint256 pos = _checkpoints[account].length;
3831         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
3832     }
3833 
3834     /**
3835      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
3836      *
3837      * Requirements:
3838      *
3839      * - `blockNumber` must have been already mined
3840      */
3841     function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
3842         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
3843         return _checkpointsLookup(_checkpoints[account], blockNumber);
3844     }
3845 
3846     /**
3847      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
3848      * It is but NOT the sum of all the delegated votes!
3849      *
3850      * Requirements:
3851      *
3852      * - `blockNumber` must have been already mined
3853      */
3854     function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
3855         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
3856         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
3857     }
3858 
3859     /**
3860      * @dev Lookup a value in a list of (sorted) checkpoints.
3861      */
3862     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
3863         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
3864         //
3865         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
3866         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
3867         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
3868         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
3869         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
3870         // out of bounds (in which case we're looking too far in the past and the result is 0).
3871         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
3872         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
3873         // the same.
3874         uint256 high = ckpts.length;
3875         uint256 low = 0;
3876         while (low < high) {
3877             uint256 mid = MathUpgradeable.average(low, high);
3878             if (ckpts[mid].fromBlock > blockNumber) {
3879                 high = mid;
3880             } else {
3881                 low = mid + 1;
3882             }
3883         }
3884 
3885         return high == 0 ? 0 : ckpts[high - 1].votes;
3886     }
3887 
3888     /**
3889      * @dev Delegate votes from the sender to `delegatee`.
3890      */
3891     function delegate(address delegatee) public virtual override {
3892         _delegate(_msgSender(), delegatee);
3893     }
3894 
3895     /**
3896      * @dev Delegates votes from signer to `delegatee`
3897      */
3898     function delegateBySig(
3899         address delegatee,
3900         uint256 nonce,
3901         uint256 expiry,
3902         uint8 v,
3903         bytes32 r,
3904         bytes32 s
3905     ) public virtual override {
3906         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
3907         address signer = ECDSAUpgradeable.recover(
3908             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
3909             v,
3910             r,
3911             s
3912         );
3913         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
3914         _delegate(signer, delegatee);
3915     }
3916 
3917     /**
3918      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
3919      */
3920     function _maxSupply() internal view virtual returns (uint224) {
3921         return type(uint224).max;
3922     }
3923 
3924     /**
3925      * @dev Snapshots the totalSupply after it has been increased.
3926      */
3927     function _mint(address account, uint256 amount) internal virtual override {
3928         super._mint(account, amount);
3929         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
3930 
3931         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
3932     }
3933 
3934     /**
3935      * @dev Snapshots the totalSupply after it has been decreased.
3936      */
3937     function _burn(address account, uint256 amount) internal virtual override {
3938         super._burn(account, amount);
3939 
3940         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
3941     }
3942 
3943     /**
3944      * @dev Move voting power when tokens are transferred.
3945      *
3946      * Emits a {DelegateVotesChanged} event.
3947      */
3948     function _afterTokenTransfer(
3949         address from,
3950         address to,
3951         uint256 amount
3952     ) internal virtual override {
3953         super._afterTokenTransfer(from, to, amount);
3954 
3955         _moveVotingPower(delegates(from), delegates(to), amount);
3956     }
3957 
3958     /**
3959      * @dev Change delegation for `delegator` to `delegatee`.
3960      *
3961      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
3962      */
3963     function _delegate(address delegator, address delegatee) internal virtual {
3964         address currentDelegate = delegates(delegator);
3965         uint256 delegatorBalance = balanceOf(delegator);
3966         _delegates[delegator] = delegatee;
3967 
3968         emit DelegateChanged(delegator, currentDelegate, delegatee);
3969 
3970         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
3971     }
3972 
3973     function _moveVotingPower(
3974         address src,
3975         address dst,
3976         uint256 amount
3977     ) private {
3978         if (src != dst && amount > 0) {
3979             if (src != address(0)) {
3980                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
3981                 emit DelegateVotesChanged(src, oldWeight, newWeight);
3982             }
3983 
3984             if (dst != address(0)) {
3985                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
3986                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
3987             }
3988         }
3989     }
3990 
3991     function _writeCheckpoint(
3992         Checkpoint[] storage ckpts,
3993         function(uint256, uint256) view returns (uint256) op,
3994         uint256 delta
3995     ) private returns (uint256 oldWeight, uint256 newWeight) {
3996         uint256 pos = ckpts.length;
3997         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
3998         newWeight = op(oldWeight, delta);
3999 
4000         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
4001             ckpts[pos - 1].votes = SafeCastUpgradeable.toUint224(newWeight);
4002         } else {
4003             ckpts.push(Checkpoint({fromBlock: SafeCastUpgradeable.toUint32(block.number), votes: SafeCastUpgradeable.toUint224(newWeight)}));
4004         }
4005     }
4006 
4007     function _add(uint256 a, uint256 b) private pure returns (uint256) {
4008         return a + b;
4009     }
4010 
4011     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
4012         return a - b;
4013     }
4014 
4015     /**
4016      * @dev This empty reserved space is put in place to allow future versions to add new
4017      * variables without shifting down storage in the inheritance chain.
4018      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
4019      */
4020     uint256[47] private __gap;
4021 }
4022 
4023 // File: @openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol
4024 
4025 
4026 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
4027 
4028 pragma solidity ^0.8.2;
4029 
4030 
4031 
4032 
4033 
4034 
4035 /**
4036  * @dev This abstract contract provides getters and event emitting update functions for
4037  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
4038  *
4039  * _Available since v4.1._
4040  *
4041  * @custom:oz-upgrades-unsafe-allow delegatecall
4042  */
4043 abstract contract ERC1967UpgradeUpgradeable is Initializable {
4044     function __ERC1967Upgrade_init() internal onlyInitializing {
4045     }
4046 
4047     function __ERC1967Upgrade_init_unchained() internal onlyInitializing {
4048     }
4049     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
4050     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
4051 
4052     /**
4053      * @dev Storage slot with the address of the current implementation.
4054      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
4055      * validated in the constructor.
4056      */
4057     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
4058 
4059     /**
4060      * @dev Emitted when the implementation is upgraded.
4061      */
4062     event Upgraded(address indexed implementation);
4063 
4064     /**
4065      * @dev Returns the current implementation address.
4066      */
4067     function _getImplementation() internal view returns (address) {
4068         return StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
4069     }
4070 
4071     /**
4072      * @dev Stores a new address in the EIP1967 implementation slot.
4073      */
4074     function _setImplementation(address newImplementation) private {
4075         require(AddressUpgradeable.isContract(newImplementation), "ERC1967: new implementation is not a contract");
4076         StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
4077     }
4078 
4079     /**
4080      * @dev Perform implementation upgrade
4081      *
4082      * Emits an {Upgraded} event.
4083      */
4084     function _upgradeTo(address newImplementation) internal {
4085         _setImplementation(newImplementation);
4086         emit Upgraded(newImplementation);
4087     }
4088 
4089     /**
4090      * @dev Perform implementation upgrade with additional setup call.
4091      *
4092      * Emits an {Upgraded} event.
4093      */
4094     function _upgradeToAndCall(
4095         address newImplementation,
4096         bytes memory data,
4097         bool forceCall
4098     ) internal {
4099         _upgradeTo(newImplementation);
4100         if (data.length > 0 || forceCall) {
4101             _functionDelegateCall(newImplementation, data);
4102         }
4103     }
4104 
4105     /**
4106      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
4107      *
4108      * Emits an {Upgraded} event.
4109      */
4110     function _upgradeToAndCallUUPS(
4111         address newImplementation,
4112         bytes memory data,
4113         bool forceCall
4114     ) internal {
4115         // Upgrades from old implementations will perform a rollback test. This test requires the new
4116         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
4117         // this special case will break upgrade paths from old UUPS implementation to new ones.
4118         if (StorageSlotUpgradeable.getBooleanSlot(_ROLLBACK_SLOT).value) {
4119             _setImplementation(newImplementation);
4120         } else {
4121             try IERC1822ProxiableUpgradeable(newImplementation).proxiableUUID() returns (bytes32 slot) {
4122                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
4123             } catch {
4124                 revert("ERC1967Upgrade: new implementation is not UUPS");
4125             }
4126             _upgradeToAndCall(newImplementation, data, forceCall);
4127         }
4128     }
4129 
4130     /**
4131      * @dev Storage slot with the admin of the contract.
4132      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
4133      * validated in the constructor.
4134      */
4135     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
4136 
4137     /**
4138      * @dev Emitted when the admin account has changed.
4139      */
4140     event AdminChanged(address previousAdmin, address newAdmin);
4141 
4142     /**
4143      * @dev Returns the current admin.
4144      */
4145     function _getAdmin() internal view returns (address) {
4146         return StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value;
4147     }
4148 
4149     /**
4150      * @dev Stores a new address in the EIP1967 admin slot.
4151      */
4152     function _setAdmin(address newAdmin) private {
4153         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
4154         StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
4155     }
4156 
4157     /**
4158      * @dev Changes the admin of the proxy.
4159      *
4160      * Emits an {AdminChanged} event.
4161      */
4162     function _changeAdmin(address newAdmin) internal {
4163         emit AdminChanged(_getAdmin(), newAdmin);
4164         _setAdmin(newAdmin);
4165     }
4166 
4167     /**
4168      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
4169      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
4170      */
4171     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
4172 
4173     /**
4174      * @dev Emitted when the beacon is upgraded.
4175      */
4176     event BeaconUpgraded(address indexed beacon);
4177 
4178     /**
4179      * @dev Returns the current beacon.
4180      */
4181     function _getBeacon() internal view returns (address) {
4182         return StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value;
4183     }
4184 
4185     /**
4186      * @dev Stores a new beacon in the EIP1967 beacon slot.
4187      */
4188     function _setBeacon(address newBeacon) private {
4189         require(AddressUpgradeable.isContract(newBeacon), "ERC1967: new beacon is not a contract");
4190         require(
4191             AddressUpgradeable.isContract(IBeaconUpgradeable(newBeacon).implementation()),
4192             "ERC1967: beacon implementation is not a contract"
4193         );
4194         StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value = newBeacon;
4195     }
4196 
4197     /**
4198      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
4199      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
4200      *
4201      * Emits a {BeaconUpgraded} event.
4202      */
4203     function _upgradeBeaconToAndCall(
4204         address newBeacon,
4205         bytes memory data,
4206         bool forceCall
4207     ) internal {
4208         _setBeacon(newBeacon);
4209         emit BeaconUpgraded(newBeacon);
4210         if (data.length > 0 || forceCall) {
4211             _functionDelegateCall(IBeaconUpgradeable(newBeacon).implementation(), data);
4212         }
4213     }
4214 
4215     /**
4216      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
4217      * but performing a delegate call.
4218      *
4219      * _Available since v3.4._
4220      */
4221     function _functionDelegateCall(address target, bytes memory data) private returns (bytes memory) {
4222         require(AddressUpgradeable.isContract(target), "Address: delegate call to non-contract");
4223 
4224         // solhint-disable-next-line avoid-low-level-calls
4225         (bool success, bytes memory returndata) = target.delegatecall(data);
4226         return AddressUpgradeable.verifyCallResult(success, returndata, "Address: low-level delegate call failed");
4227     }
4228 
4229     /**
4230      * @dev This empty reserved space is put in place to allow future versions to add new
4231      * variables without shifting down storage in the inheritance chain.
4232      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
4233      */
4234     uint256[50] private __gap;
4235 }
4236 
4237 // File: @openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol
4238 
4239 
4240 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/UUPSUpgradeable.sol)
4241 
4242 pragma solidity ^0.8.0;
4243 
4244 
4245 
4246 
4247 /**
4248  * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
4249  * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
4250  *
4251  * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
4252  * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
4253  * `UUPSUpgradeable` with a custom implementation of upgrades.
4254  *
4255  * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
4256  *
4257  * _Available since v4.1._
4258  */
4259 abstract contract UUPSUpgradeable is Initializable, IERC1822ProxiableUpgradeable, ERC1967UpgradeUpgradeable {
4260     function __UUPSUpgradeable_init() internal onlyInitializing {
4261     }
4262 
4263     function __UUPSUpgradeable_init_unchained() internal onlyInitializing {
4264     }
4265     /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
4266     address private immutable __self = address(this);
4267 
4268     /**
4269      * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
4270      * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
4271      * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
4272      * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
4273      * fail.
4274      */
4275     modifier onlyProxy() {
4276         require(address(this) != __self, "Function must be called through delegatecall");
4277         require(_getImplementation() == __self, "Function must be called through active proxy");
4278         _;
4279     }
4280 
4281     /**
4282      * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
4283      * callable on the implementing contract but not through proxies.
4284      */
4285     modifier notDelegated() {
4286         require(address(this) == __self, "UUPSUpgradeable: must not be called through delegatecall");
4287         _;
4288     }
4289 
4290     /**
4291      * @dev Implementation of the ERC1822 {proxiableUUID} function. This returns the storage slot used by the
4292      * implementation. It is used to validate that the this implementation remains valid after an upgrade.
4293      *
4294      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
4295      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
4296      * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
4297      */
4298     function proxiableUUID() external view virtual override notDelegated returns (bytes32) {
4299         return _IMPLEMENTATION_SLOT;
4300     }
4301 
4302     /**
4303      * @dev Upgrade the implementation of the proxy to `newImplementation`.
4304      *
4305      * Calls {_authorizeUpgrade}.
4306      *
4307      * Emits an {Upgraded} event.
4308      */
4309     function upgradeTo(address newImplementation) external virtual onlyProxy {
4310         _authorizeUpgrade(newImplementation);
4311         _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
4312     }
4313 
4314     /**
4315      * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
4316      * encoded in `data`.
4317      *
4318      * Calls {_authorizeUpgrade}.
4319      *
4320      * Emits an {Upgraded} event.
4321      */
4322     function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual onlyProxy {
4323         _authorizeUpgrade(newImplementation);
4324         _upgradeToAndCallUUPS(newImplementation, data, true);
4325     }
4326 
4327     /**
4328      * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
4329      * {upgradeTo} and {upgradeToAndCall}.
4330      *
4331      * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
4332      *
4333      * ```solidity
4334      * function _authorizeUpgrade(address) internal override onlyOwner {}
4335      * ```
4336      */
4337     function _authorizeUpgrade(address newImplementation) internal virtual;
4338 
4339     /**
4340      * @dev This empty reserved space is put in place to allow future versions to add new
4341      * variables without shifting down storage in the inheritance chain.
4342      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
4343      */
4344     uint256[50] private __gap;
4345 }
4346 
4347 // File: Maia.sol
4348 
4349 
4350 pragma solidity 0.8.2;
4351 
4352 
4353 
4354 
4355 
4356 
4357 
4358 
4359 
4360 
4361 
4362 
4363 
4364 contract Maia is Initializable, UUPSUpgradeable, ERC20Upgradeable, ERC20PermitUpgradeable, ERC20VotesUpgradeable, OwnableUpgradeable, PausableUpgradeable {
4365     using SafeMathUpgradeable for uint256;
4366 
4367     // Info of each user.
4368     struct UserInfo {
4369         uint256 amount;     // How many LP tokens the user has provided.
4370         uint256 rewardDebt; // Reward debt. See explanation below.
4371         uint256 rewargoldDebt; // Reward debt in GOLD.
4372         uint256 stakeEnd;
4373         //
4374         // We do some fancy math here. Basically, any point in time, the amount of GOLD
4375         // entitled to a user but is pending to be distributed is:
4376         //
4377         //   pending reward = (user.amount * pool.accGOLDPerShare) - user.rewardDebt
4378         //
4379         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
4380         //   1. The pool's `accGOLDPerShare` (and `lastRewardBlock`) gets updated.
4381         //   2. User receives the pending reward sent to his/her address.
4382         //   3. User's `amount` gets updated.
4383         //   4. User's `rewardDebt` gets updated.
4384     }
4385 
4386     struct ValarUserInfo {
4387         uint256 rewardDebt;
4388     }
4389 
4390     // Info of each pool.
4391     struct PoolInfo {
4392         IERC20 lpToken;           // Address of LP token contract.
4393         uint256 allocPoint;       // How many allocation points assigned to this pool. GOLDs to distribute per block.
4394         uint256 lastRewardBlock;  // Last block number that GOLDs distribution occurs.
4395         uint256 accGOLDPerShare; // Accumulated GOLDs per share, times 1e12. See below.
4396         uint256 lastTotalGOLDReward; // last total rewards
4397         uint256 lastGOLDRewardBalance; // last GOLD rewards tokens
4398         uint256 totalGOLDReward; // total GOLD rewards tokens
4399     }
4400 
4401     struct ValarPoolInfo {
4402         uint256 lastGOLDRewardBalance;
4403         uint256 totalGOLDReward;
4404         uint256 totalValar;
4405     }
4406 
4407     // The GOLD TOKEN!
4408     IERC20 public GOLD;
4409     IERC20 public Valar;
4410     // admin address.
4411     address public adminAddress;
4412     // Bonus muliplier for early GOLD makers.
4413     uint256 public constant BONUS_MULTIPLIER = 1;
4414 
4415     // Number of top staker stored
4416 
4417     uint256 public topStakerNumber;
4418 
4419     // Info of each pool.
4420     PoolInfo[] public poolInfo;
4421     ValarPoolInfo[] public valarPoolInfo;
4422     // Info of each user that stakes LP tokens.
4423     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
4424     mapping (uint256 => mapping (address => ValarUserInfo)) public valarUserInfo;
4425 
4426 
4427     // Total allocation points. Must be the sum of all allocation points in all pools.
4428     uint256 public totalAllocPoint;
4429     // The block number when reward distribution start.
4430     uint256 public startBlock;
4431     // total GOLD staked
4432     uint256 public totalGOLDStaked;
4433     // total GOLD used for purchase land
4434     uint256 public totalGOLDUsedForPurchase;
4435     // withdrawal delay
4436     uint256 public withdrawDelay;
4437 
4438     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
4439     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
4440     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
4441     event AdminUpdated(address newAdmin);
4442 
4443     function initialize(        
4444         address _GOLD,
4445         address _Valar,
4446         address _adminAddress,
4447         uint256 _startBlock
4448         ) public initializer {
4449         require(_adminAddress != address(0), "initialize: Zero address");
4450         OwnableUpgradeable.__Ownable_init();
4451         __ERC20_init_unchained("Maia", "Maia");
4452         __Pausable_init_unchained();
4453         ERC20PermitUpgradeable.__ERC20Permit_init("Maia");
4454         ERC20VotesUpgradeable.__ERC20Votes_init_unchained();
4455         GOLD = IERC20(_GOLD);
4456         Valar = IERC20(_Valar);
4457         adminAddress = _adminAddress;
4458         startBlock = _startBlock;
4459         withdrawDelay = 0;
4460     }
4461 
4462 	function decimals() public pure override returns (uint8) {
4463 		return 9;
4464 	}
4465 
4466     function poolLength() external view returns (uint256) {
4467         return poolInfo.length;
4468     }
4469 
4470     // Add a new lp to the pool. Can only be called by the owner.
4471     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
4472     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
4473         if (_withUpdate) {
4474             massUpdatePools();
4475         }
4476         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
4477         totalAllocPoint = totalAllocPoint.add(_allocPoint);
4478         poolInfo.push(PoolInfo({
4479             lpToken: _lpToken,
4480             allocPoint: _allocPoint,
4481             lastRewardBlock: lastRewardBlock,
4482             accGOLDPerShare: 0,
4483             lastTotalGOLDReward: 0,
4484             lastGOLDRewardBalance: 0,
4485             totalGOLDReward: 0
4486         }));
4487          valarPoolInfo.push(ValarPoolInfo({
4488              lastGOLDRewardBalance: 0,
4489              totalGOLDReward: 0,
4490              totalValar: 0
4491          }));
4492 
4493     }
4494 
4495     function setWithdrawDelay(uint256 _delay) external onlyOwner {
4496         withdrawDelay = _delay;
4497     }
4498 
4499     // Update the given pool's GOLD allocation point. Can only be called by the owner.
4500     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
4501         if (_withUpdate) {
4502             massUpdatePools();
4503         }
4504         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
4505         poolInfo[_pid].allocPoint = _allocPoint;
4506     }
4507     
4508     // Return reward multiplier over the given _from to _to block.
4509     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
4510         if (_to >= _from) {
4511             return _to.sub(_from).mul(BONUS_MULTIPLIER);
4512         } else {
4513             return _from.sub(_to);
4514         }
4515     }
4516     
4517     // View function to see pending GOLDs on frontend.
4518     function pendingGOLD(uint256 _pid, address _user) external view returns (uint256) {
4519         PoolInfo storage pool = poolInfo[_pid];
4520         UserInfo storage user = userInfo[_pid][_user];
4521 
4522         uint256 accGOLDPerShare = pool.accGOLDPerShare;
4523         uint256 lpSupply = totalGOLDStaked;
4524         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
4525             uint256 rewardBalance = pool.lpToken.balanceOf(address(this)).sub(totalGOLDStaked.sub(totalGOLDUsedForPurchase));
4526             uint256 _totalReward = rewardBalance.sub(pool.lastGOLDRewardBalance);
4527             accGOLDPerShare = accGOLDPerShare.add(_totalReward.mul(1e12).div(lpSupply));
4528         }
4529         uint256 reward = user.amount.mul(accGOLDPerShare).div(1e12).sub(user.rewargoldDebt);
4530 
4531         if (Valar.balanceOf(_user) == 1) {
4532             return reward;
4533         }
4534         else {
4535             return reward.mul(90).div(100);
4536         }
4537     }
4538 
4539     // Update reward variables for all pools. Be careful of gas spending!
4540     function massUpdatePools() public {
4541         uint256 length = poolInfo.length;
4542         for (uint256 pid = 0; pid < length; ++pid) {
4543             updatePool(pid);
4544         }
4545     }
4546 
4547     function updatePoolHelper(uint _pid) external view returns (uint) {
4548         PoolInfo storage pool = poolInfo[_pid];
4549         
4550         if (block.number <= pool.lastRewardBlock) {
4551             return 0;
4552         }
4553         uint256 rewardBalance = pool.lpToken.balanceOf(address(this)).sub(totalGOLDStaked.sub(totalGOLDUsedForPurchase));
4554 
4555         return rewardBalance;
4556     }
4557 
4558     // Update reward variables of the given pool to be up-to-date.
4559     function updatePool(uint256 _pid) public {
4560         PoolInfo storage pool = poolInfo[_pid];
4561         UserInfo storage user = userInfo[_pid][msg.sender];
4562 
4563         
4564         if (block.number <= pool.lastRewardBlock) {
4565             return;
4566         }
4567         uint256 rewardBalance = pool.lpToken.balanceOf(address(this)).sub(totalGOLDStaked.sub(totalGOLDUsedForPurchase));
4568         uint256 _totalReward = pool.totalGOLDReward.add(rewardBalance.sub(pool.lastGOLDRewardBalance));
4569         pool.lastGOLDRewardBalance = rewardBalance;
4570         pool.totalGOLDReward = _totalReward;
4571         
4572         uint256 lpSupply = totalGOLDStaked;
4573         if (lpSupply == 0) {
4574             pool.lastRewardBlock = block.number;
4575             pool.accGOLDPerShare = 0;
4576             pool.lastTotalGOLDReward = 0;
4577             user.rewargoldDebt = 0;
4578             pool.lastGOLDRewardBalance = 0;
4579             pool.totalGOLDReward = 0;
4580             return;
4581         }
4582         
4583         uint256 reward = _totalReward.sub(pool.lastTotalGOLDReward);
4584         pool.accGOLDPerShare = pool.accGOLDPerShare.add(reward.mul(1e12).div(lpSupply));
4585         pool.lastTotalGOLDReward = _totalReward;
4586     }
4587 
4588     // Deposit GOLD tokens to MasterChef.
4589     function deposit(uint256 _pid, uint256 _amount) public {
4590         PoolInfo storage pool = poolInfo[_pid];
4591         UserInfo storage user = userInfo[_pid][msg.sender];
4592 
4593         updatePool(_pid);
4594         if (user.amount > 0) {
4595             uint256 GOLDReward = user.amount.mul(pool.accGOLDPerShare).div(1e12).sub(user.rewargoldDebt);
4596             if (GOLDReward > 0) {
4597                 pool.lpToken.transfer(msg.sender, GOLDReward);
4598             }
4599             pool.lastGOLDRewardBalance = pool.lpToken.balanceOf(address(this)).sub(totalGOLDStaked.sub(totalGOLDUsedForPurchase));
4600         }
4601         
4602         uint256 taxAdjustedAmount = _amount.sub(_amount.mul(4).div(100));
4603 
4604         pool.lpToken.transferFrom(address(msg.sender), address(this), _amount);
4605         totalGOLDStaked = totalGOLDStaked.add(taxAdjustedAmount);
4606         user.amount = user.amount.add(taxAdjustedAmount);
4607         user.rewargoldDebt = user.amount.mul(pool.accGOLDPerShare).div(1e12);
4608         user.stakeEnd = block.timestamp + withdrawDelay;
4609         _mint(msg.sender,taxAdjustedAmount);
4610         emit Deposit(msg.sender, _pid, taxAdjustedAmount);
4611     }
4612 
4613     function getVPool(uint _pid) external view returns(ValarPoolInfo memory) {
4614         return valarPoolInfo[_pid];
4615     }
4616 
4617     function withdraw(uint256 _pid, uint256 _amount) public {
4618         PoolInfo storage pool = poolInfo[_pid];
4619         UserInfo storage user = userInfo[_pid][msg.sender];
4620 
4621         require(block.timestamp >= user.stakeEnd, "withdraw: too soon");
4622         require(user.amount >= _amount, "withdraw: too little");
4623         updatePool(_pid);
4624 
4625         uint256 GOLDReward = user.amount.mul(pool.accGOLDPerShare).div(1e12).sub(user.rewargoldDebt);
4626         if (GOLDReward > 0) pool.lpToken.transfer(msg.sender, GOLDReward);
4627         pool.lastGOLDRewardBalance = pool.lpToken.balanceOf(address(this)).sub(totalGOLDStaked.sub(totalGOLDUsedForPurchase));
4628 
4629         user.amount = user.amount.sub(_amount);
4630         totalGOLDStaked = totalGOLDStaked.sub(_amount);
4631         user.rewargoldDebt = user.amount.mul(pool.accGOLDPerShare).div(1e12);
4632         pool.lpToken.transfer(address(msg.sender), _amount);
4633         _burn(msg.sender,_amount);
4634         emit Withdraw(msg.sender, _pid, _amount);
4635     }
4636 
4637     function getPool(uint256 _pid) external view returns (PoolInfo memory) {
4638         return poolInfo[_pid]; 
4639     }
4640 
4641     function getUser(uint256 _pid, address _user) external view returns (UserInfo memory) {
4642         return userInfo[_pid][_user]; 
4643     }
4644     
4645     // Earn GOLD tokens to MasterChef.
4646     function claimGOLD(uint256 _pid) public {
4647         PoolInfo storage pool = poolInfo[_pid];
4648         UserInfo storage user = userInfo[_pid][msg.sender];
4649 
4650         updatePool(_pid);
4651         
4652         uint256 GOLDReward = user.amount.mul(pool.accGOLDPerShare).div(1e12).sub(user.rewargoldDebt);
4653         if (GOLDReward > 0) {
4654             if (Valar.balanceOf(msg.sender) == 1) {
4655                 pool.lpToken.transfer(msg.sender, GOLDReward);
4656             } else {
4657                 pool.lpToken.transfer(msg.sender, GOLDReward.mul(90).div(100));
4658             }
4659         }
4660         pool.lastGOLDRewardBalance = pool.lpToken.balanceOf(address(this)).sub(totalGOLDStaked.sub(totalGOLDUsedForPurchase));
4661 
4662         user.rewargoldDebt = user.amount.mul(pool.accGOLDPerShare).div(1e12);   
4663     }
4664     
4665     // Safe GOLD transfer function to admin.
4666     function accessGOLDTokens(uint256 _pid, address _to, uint256 _amount) public {
4667         require(msg.sender == adminAddress, "sender must be admin address");
4668         require(totalGOLDStaked.sub(totalGOLDUsedForPurchase) >= _amount, "Amount must be less than staked GOLD amount");
4669         PoolInfo storage pool = poolInfo[_pid];
4670         uint256 GOLDBal = pool.lpToken.balanceOf(address(this));
4671         if (_amount > GOLDBal) {
4672             pool.lpToken.transfer(_to, GOLDBal);
4673             totalGOLDUsedForPurchase = totalGOLDUsedForPurchase.add(GOLDBal);
4674             emit EmergencyWithdraw(_to, _pid, GOLDBal);
4675         } else {
4676             pool.lpToken.transfer(_to, _amount);
4677             totalGOLDUsedForPurchase = totalGOLDUsedForPurchase.add(_amount);
4678             emit EmergencyWithdraw(_to, _pid, _amount);
4679         }
4680     }
4681     // Update admin address by the previous admin.
4682     function admin(address _adminAddress) public {
4683         require(_adminAddress != address(0), "admin: Zero address");
4684         require(msg.sender == adminAddress, "admin: wut?");
4685         adminAddress = _adminAddress;
4686         emit AdminUpdated(_adminAddress);
4687     }
4688 
4689     function _mint(address to, uint256 amount)
4690         internal
4691         override(ERC20Upgradeable, ERC20VotesUpgradeable)
4692     {
4693         super._mint(to, amount);
4694     }
4695 
4696     function _burn(address account, uint256 amount)
4697         internal
4698         override(ERC20Upgradeable, ERC20VotesUpgradeable)
4699     {
4700         super._burn(account, amount);
4701     }
4702 
4703     function _afterTokenTransfer(address from, address to, uint256 amount)
4704         internal
4705         override(ERC20Upgradeable, ERC20VotesUpgradeable)
4706     {
4707         ERC20VotesUpgradeable._afterTokenTransfer(from, to, amount);
4708     }
4709 
4710     function _beforeTokenTransfer(
4711         address from,
4712         address to,
4713         uint256 amount
4714     ) internal virtual override {
4715         
4716         if(from == address(0) || to == address(0)){
4717             super._beforeTokenTransfer(from, to, amount);
4718         }else{
4719             revert("Non transferable token");
4720         }
4721     }
4722 
4723     function _delegate(address delegator, address delegatee) internal virtual override {
4724         super._delegate(delegator,delegatee);
4725     }
4726 
4727     function _authorizeUpgrade(address) internal view override {
4728         require(owner() == msg.sender, "Only owner can upgrade implementation");
4729     }
4730 
4731 }