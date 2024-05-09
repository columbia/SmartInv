1 // File: @openzeppelin/contracts/utils/math/SafeCast.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SafeCast.sol)
5 // This file was procedurally generated from scripts/generate/templates/SafeCast.js.
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
11  * checks.
12  *
13  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
14  * easily result in undesired exploitation or bugs, since developers usually
15  * assume that overflows raise errors. `SafeCast` restores this intuition by
16  * reverting the transaction when such an operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  *
21  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
22  * all math on `uint256` and `int256` and then downcasting.
23  */
24 library SafeCast {
25     /**
26      * @dev Returns the downcasted uint248 from uint256, reverting on
27      * overflow (when the input is greater than largest uint248).
28      *
29      * Counterpart to Solidity's `uint248` operator.
30      *
31      * Requirements:
32      *
33      * - input must fit into 248 bits
34      *
35      * _Available since v4.7._
36      */
37     function toUint248(uint256 value) internal pure returns (uint248) {
38         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
39         return uint248(value);
40     }
41 
42     /**
43      * @dev Returns the downcasted uint240 from uint256, reverting on
44      * overflow (when the input is greater than largest uint240).
45      *
46      * Counterpart to Solidity's `uint240` operator.
47      *
48      * Requirements:
49      *
50      * - input must fit into 240 bits
51      *
52      * _Available since v4.7._
53      */
54     function toUint240(uint256 value) internal pure returns (uint240) {
55         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
56         return uint240(value);
57     }
58 
59     /**
60      * @dev Returns the downcasted uint232 from uint256, reverting on
61      * overflow (when the input is greater than largest uint232).
62      *
63      * Counterpart to Solidity's `uint232` operator.
64      *
65      * Requirements:
66      *
67      * - input must fit into 232 bits
68      *
69      * _Available since v4.7._
70      */
71     function toUint232(uint256 value) internal pure returns (uint232) {
72         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
73         return uint232(value);
74     }
75 
76     /**
77      * @dev Returns the downcasted uint224 from uint256, reverting on
78      * overflow (when the input is greater than largest uint224).
79      *
80      * Counterpart to Solidity's `uint224` operator.
81      *
82      * Requirements:
83      *
84      * - input must fit into 224 bits
85      *
86      * _Available since v4.2._
87      */
88     function toUint224(uint256 value) internal pure returns (uint224) {
89         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
90         return uint224(value);
91     }
92 
93     /**
94      * @dev Returns the downcasted uint216 from uint256, reverting on
95      * overflow (when the input is greater than largest uint216).
96      *
97      * Counterpart to Solidity's `uint216` operator.
98      *
99      * Requirements:
100      *
101      * - input must fit into 216 bits
102      *
103      * _Available since v4.7._
104      */
105     function toUint216(uint256 value) internal pure returns (uint216) {
106         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
107         return uint216(value);
108     }
109 
110     /**
111      * @dev Returns the downcasted uint208 from uint256, reverting on
112      * overflow (when the input is greater than largest uint208).
113      *
114      * Counterpart to Solidity's `uint208` operator.
115      *
116      * Requirements:
117      *
118      * - input must fit into 208 bits
119      *
120      * _Available since v4.7._
121      */
122     function toUint208(uint256 value) internal pure returns (uint208) {
123         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
124         return uint208(value);
125     }
126 
127     /**
128      * @dev Returns the downcasted uint200 from uint256, reverting on
129      * overflow (when the input is greater than largest uint200).
130      *
131      * Counterpart to Solidity's `uint200` operator.
132      *
133      * Requirements:
134      *
135      * - input must fit into 200 bits
136      *
137      * _Available since v4.7._
138      */
139     function toUint200(uint256 value) internal pure returns (uint200) {
140         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
141         return uint200(value);
142     }
143 
144     /**
145      * @dev Returns the downcasted uint192 from uint256, reverting on
146      * overflow (when the input is greater than largest uint192).
147      *
148      * Counterpart to Solidity's `uint192` operator.
149      *
150      * Requirements:
151      *
152      * - input must fit into 192 bits
153      *
154      * _Available since v4.7._
155      */
156     function toUint192(uint256 value) internal pure returns (uint192) {
157         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
158         return uint192(value);
159     }
160 
161     /**
162      * @dev Returns the downcasted uint184 from uint256, reverting on
163      * overflow (when the input is greater than largest uint184).
164      *
165      * Counterpart to Solidity's `uint184` operator.
166      *
167      * Requirements:
168      *
169      * - input must fit into 184 bits
170      *
171      * _Available since v4.7._
172      */
173     function toUint184(uint256 value) internal pure returns (uint184) {
174         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
175         return uint184(value);
176     }
177 
178     /**
179      * @dev Returns the downcasted uint176 from uint256, reverting on
180      * overflow (when the input is greater than largest uint176).
181      *
182      * Counterpart to Solidity's `uint176` operator.
183      *
184      * Requirements:
185      *
186      * - input must fit into 176 bits
187      *
188      * _Available since v4.7._
189      */
190     function toUint176(uint256 value) internal pure returns (uint176) {
191         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
192         return uint176(value);
193     }
194 
195     /**
196      * @dev Returns the downcasted uint168 from uint256, reverting on
197      * overflow (when the input is greater than largest uint168).
198      *
199      * Counterpart to Solidity's `uint168` operator.
200      *
201      * Requirements:
202      *
203      * - input must fit into 168 bits
204      *
205      * _Available since v4.7._
206      */
207     function toUint168(uint256 value) internal pure returns (uint168) {
208         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
209         return uint168(value);
210     }
211 
212     /**
213      * @dev Returns the downcasted uint160 from uint256, reverting on
214      * overflow (when the input is greater than largest uint160).
215      *
216      * Counterpart to Solidity's `uint160` operator.
217      *
218      * Requirements:
219      *
220      * - input must fit into 160 bits
221      *
222      * _Available since v4.7._
223      */
224     function toUint160(uint256 value) internal pure returns (uint160) {
225         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
226         return uint160(value);
227     }
228 
229     /**
230      * @dev Returns the downcasted uint152 from uint256, reverting on
231      * overflow (when the input is greater than largest uint152).
232      *
233      * Counterpart to Solidity's `uint152` operator.
234      *
235      * Requirements:
236      *
237      * - input must fit into 152 bits
238      *
239      * _Available since v4.7._
240      */
241     function toUint152(uint256 value) internal pure returns (uint152) {
242         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
243         return uint152(value);
244     }
245 
246     /**
247      * @dev Returns the downcasted uint144 from uint256, reverting on
248      * overflow (when the input is greater than largest uint144).
249      *
250      * Counterpart to Solidity's `uint144` operator.
251      *
252      * Requirements:
253      *
254      * - input must fit into 144 bits
255      *
256      * _Available since v4.7._
257      */
258     function toUint144(uint256 value) internal pure returns (uint144) {
259         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
260         return uint144(value);
261     }
262 
263     /**
264      * @dev Returns the downcasted uint136 from uint256, reverting on
265      * overflow (when the input is greater than largest uint136).
266      *
267      * Counterpart to Solidity's `uint136` operator.
268      *
269      * Requirements:
270      *
271      * - input must fit into 136 bits
272      *
273      * _Available since v4.7._
274      */
275     function toUint136(uint256 value) internal pure returns (uint136) {
276         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
277         return uint136(value);
278     }
279 
280     /**
281      * @dev Returns the downcasted uint128 from uint256, reverting on
282      * overflow (when the input is greater than largest uint128).
283      *
284      * Counterpart to Solidity's `uint128` operator.
285      *
286      * Requirements:
287      *
288      * - input must fit into 128 bits
289      *
290      * _Available since v2.5._
291      */
292     function toUint128(uint256 value) internal pure returns (uint128) {
293         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
294         return uint128(value);
295     }
296 
297     /**
298      * @dev Returns the downcasted uint120 from uint256, reverting on
299      * overflow (when the input is greater than largest uint120).
300      *
301      * Counterpart to Solidity's `uint120` operator.
302      *
303      * Requirements:
304      *
305      * - input must fit into 120 bits
306      *
307      * _Available since v4.7._
308      */
309     function toUint120(uint256 value) internal pure returns (uint120) {
310         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
311         return uint120(value);
312     }
313 
314     /**
315      * @dev Returns the downcasted uint112 from uint256, reverting on
316      * overflow (when the input is greater than largest uint112).
317      *
318      * Counterpart to Solidity's `uint112` operator.
319      *
320      * Requirements:
321      *
322      * - input must fit into 112 bits
323      *
324      * _Available since v4.7._
325      */
326     function toUint112(uint256 value) internal pure returns (uint112) {
327         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
328         return uint112(value);
329     }
330 
331     /**
332      * @dev Returns the downcasted uint104 from uint256, reverting on
333      * overflow (when the input is greater than largest uint104).
334      *
335      * Counterpart to Solidity's `uint104` operator.
336      *
337      * Requirements:
338      *
339      * - input must fit into 104 bits
340      *
341      * _Available since v4.7._
342      */
343     function toUint104(uint256 value) internal pure returns (uint104) {
344         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
345         return uint104(value);
346     }
347 
348     /**
349      * @dev Returns the downcasted uint96 from uint256, reverting on
350      * overflow (when the input is greater than largest uint96).
351      *
352      * Counterpart to Solidity's `uint96` operator.
353      *
354      * Requirements:
355      *
356      * - input must fit into 96 bits
357      *
358      * _Available since v4.2._
359      */
360     function toUint96(uint256 value) internal pure returns (uint96) {
361         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
362         return uint96(value);
363     }
364 
365     /**
366      * @dev Returns the downcasted uint88 from uint256, reverting on
367      * overflow (when the input is greater than largest uint88).
368      *
369      * Counterpart to Solidity's `uint88` operator.
370      *
371      * Requirements:
372      *
373      * - input must fit into 88 bits
374      *
375      * _Available since v4.7._
376      */
377     function toUint88(uint256 value) internal pure returns (uint88) {
378         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
379         return uint88(value);
380     }
381 
382     /**
383      * @dev Returns the downcasted uint80 from uint256, reverting on
384      * overflow (when the input is greater than largest uint80).
385      *
386      * Counterpart to Solidity's `uint80` operator.
387      *
388      * Requirements:
389      *
390      * - input must fit into 80 bits
391      *
392      * _Available since v4.7._
393      */
394     function toUint80(uint256 value) internal pure returns (uint80) {
395         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
396         return uint80(value);
397     }
398 
399     /**
400      * @dev Returns the downcasted uint72 from uint256, reverting on
401      * overflow (when the input is greater than largest uint72).
402      *
403      * Counterpart to Solidity's `uint72` operator.
404      *
405      * Requirements:
406      *
407      * - input must fit into 72 bits
408      *
409      * _Available since v4.7._
410      */
411     function toUint72(uint256 value) internal pure returns (uint72) {
412         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
413         return uint72(value);
414     }
415 
416     /**
417      * @dev Returns the downcasted uint64 from uint256, reverting on
418      * overflow (when the input is greater than largest uint64).
419      *
420      * Counterpart to Solidity's `uint64` operator.
421      *
422      * Requirements:
423      *
424      * - input must fit into 64 bits
425      *
426      * _Available since v2.5._
427      */
428     function toUint64(uint256 value) internal pure returns (uint64) {
429         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
430         return uint64(value);
431     }
432 
433     /**
434      * @dev Returns the downcasted uint56 from uint256, reverting on
435      * overflow (when the input is greater than largest uint56).
436      *
437      * Counterpart to Solidity's `uint56` operator.
438      *
439      * Requirements:
440      *
441      * - input must fit into 56 bits
442      *
443      * _Available since v4.7._
444      */
445     function toUint56(uint256 value) internal pure returns (uint56) {
446         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
447         return uint56(value);
448     }
449 
450     /**
451      * @dev Returns the downcasted uint48 from uint256, reverting on
452      * overflow (when the input is greater than largest uint48).
453      *
454      * Counterpart to Solidity's `uint48` operator.
455      *
456      * Requirements:
457      *
458      * - input must fit into 48 bits
459      *
460      * _Available since v4.7._
461      */
462     function toUint48(uint256 value) internal pure returns (uint48) {
463         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
464         return uint48(value);
465     }
466 
467     /**
468      * @dev Returns the downcasted uint40 from uint256, reverting on
469      * overflow (when the input is greater than largest uint40).
470      *
471      * Counterpart to Solidity's `uint40` operator.
472      *
473      * Requirements:
474      *
475      * - input must fit into 40 bits
476      *
477      * _Available since v4.7._
478      */
479     function toUint40(uint256 value) internal pure returns (uint40) {
480         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
481         return uint40(value);
482     }
483 
484     /**
485      * @dev Returns the downcasted uint32 from uint256, reverting on
486      * overflow (when the input is greater than largest uint32).
487      *
488      * Counterpart to Solidity's `uint32` operator.
489      *
490      * Requirements:
491      *
492      * - input must fit into 32 bits
493      *
494      * _Available since v2.5._
495      */
496     function toUint32(uint256 value) internal pure returns (uint32) {
497         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
498         return uint32(value);
499     }
500 
501     /**
502      * @dev Returns the downcasted uint24 from uint256, reverting on
503      * overflow (when the input is greater than largest uint24).
504      *
505      * Counterpart to Solidity's `uint24` operator.
506      *
507      * Requirements:
508      *
509      * - input must fit into 24 bits
510      *
511      * _Available since v4.7._
512      */
513     function toUint24(uint256 value) internal pure returns (uint24) {
514         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
515         return uint24(value);
516     }
517 
518     /**
519      * @dev Returns the downcasted uint16 from uint256, reverting on
520      * overflow (when the input is greater than largest uint16).
521      *
522      * Counterpart to Solidity's `uint16` operator.
523      *
524      * Requirements:
525      *
526      * - input must fit into 16 bits
527      *
528      * _Available since v2.5._
529      */
530     function toUint16(uint256 value) internal pure returns (uint16) {
531         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
532         return uint16(value);
533     }
534 
535     /**
536      * @dev Returns the downcasted uint8 from uint256, reverting on
537      * overflow (when the input is greater than largest uint8).
538      *
539      * Counterpart to Solidity's `uint8` operator.
540      *
541      * Requirements:
542      *
543      * - input must fit into 8 bits
544      *
545      * _Available since v2.5._
546      */
547     function toUint8(uint256 value) internal pure returns (uint8) {
548         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
549         return uint8(value);
550     }
551 
552     /**
553      * @dev Converts a signed int256 into an unsigned uint256.
554      *
555      * Requirements:
556      *
557      * - input must be greater than or equal to 0.
558      *
559      * _Available since v3.0._
560      */
561     function toUint256(int256 value) internal pure returns (uint256) {
562         require(value >= 0, "SafeCast: value must be positive");
563         return uint256(value);
564     }
565 
566     /**
567      * @dev Returns the downcasted int248 from int256, reverting on
568      * overflow (when the input is less than smallest int248 or
569      * greater than largest int248).
570      *
571      * Counterpart to Solidity's `int248` operator.
572      *
573      * Requirements:
574      *
575      * - input must fit into 248 bits
576      *
577      * _Available since v4.7._
578      */
579     function toInt248(int256 value) internal pure returns (int248 downcasted) {
580         downcasted = int248(value);
581         require(downcasted == value, "SafeCast: value doesn't fit in 248 bits");
582     }
583 
584     /**
585      * @dev Returns the downcasted int240 from int256, reverting on
586      * overflow (when the input is less than smallest int240 or
587      * greater than largest int240).
588      *
589      * Counterpart to Solidity's `int240` operator.
590      *
591      * Requirements:
592      *
593      * - input must fit into 240 bits
594      *
595      * _Available since v4.7._
596      */
597     function toInt240(int256 value) internal pure returns (int240 downcasted) {
598         downcasted = int240(value);
599         require(downcasted == value, "SafeCast: value doesn't fit in 240 bits");
600     }
601 
602     /**
603      * @dev Returns the downcasted int232 from int256, reverting on
604      * overflow (when the input is less than smallest int232 or
605      * greater than largest int232).
606      *
607      * Counterpart to Solidity's `int232` operator.
608      *
609      * Requirements:
610      *
611      * - input must fit into 232 bits
612      *
613      * _Available since v4.7._
614      */
615     function toInt232(int256 value) internal pure returns (int232 downcasted) {
616         downcasted = int232(value);
617         require(downcasted == value, "SafeCast: value doesn't fit in 232 bits");
618     }
619 
620     /**
621      * @dev Returns the downcasted int224 from int256, reverting on
622      * overflow (when the input is less than smallest int224 or
623      * greater than largest int224).
624      *
625      * Counterpart to Solidity's `int224` operator.
626      *
627      * Requirements:
628      *
629      * - input must fit into 224 bits
630      *
631      * _Available since v4.7._
632      */
633     function toInt224(int256 value) internal pure returns (int224 downcasted) {
634         downcasted = int224(value);
635         require(downcasted == value, "SafeCast: value doesn't fit in 224 bits");
636     }
637 
638     /**
639      * @dev Returns the downcasted int216 from int256, reverting on
640      * overflow (when the input is less than smallest int216 or
641      * greater than largest int216).
642      *
643      * Counterpart to Solidity's `int216` operator.
644      *
645      * Requirements:
646      *
647      * - input must fit into 216 bits
648      *
649      * _Available since v4.7._
650      */
651     function toInt216(int256 value) internal pure returns (int216 downcasted) {
652         downcasted = int216(value);
653         require(downcasted == value, "SafeCast: value doesn't fit in 216 bits");
654     }
655 
656     /**
657      * @dev Returns the downcasted int208 from int256, reverting on
658      * overflow (when the input is less than smallest int208 or
659      * greater than largest int208).
660      *
661      * Counterpart to Solidity's `int208` operator.
662      *
663      * Requirements:
664      *
665      * - input must fit into 208 bits
666      *
667      * _Available since v4.7._
668      */
669     function toInt208(int256 value) internal pure returns (int208 downcasted) {
670         downcasted = int208(value);
671         require(downcasted == value, "SafeCast: value doesn't fit in 208 bits");
672     }
673 
674     /**
675      * @dev Returns the downcasted int200 from int256, reverting on
676      * overflow (when the input is less than smallest int200 or
677      * greater than largest int200).
678      *
679      * Counterpart to Solidity's `int200` operator.
680      *
681      * Requirements:
682      *
683      * - input must fit into 200 bits
684      *
685      * _Available since v4.7._
686      */
687     function toInt200(int256 value) internal pure returns (int200 downcasted) {
688         downcasted = int200(value);
689         require(downcasted == value, "SafeCast: value doesn't fit in 200 bits");
690     }
691 
692     /**
693      * @dev Returns the downcasted int192 from int256, reverting on
694      * overflow (when the input is less than smallest int192 or
695      * greater than largest int192).
696      *
697      * Counterpart to Solidity's `int192` operator.
698      *
699      * Requirements:
700      *
701      * - input must fit into 192 bits
702      *
703      * _Available since v4.7._
704      */
705     function toInt192(int256 value) internal pure returns (int192 downcasted) {
706         downcasted = int192(value);
707         require(downcasted == value, "SafeCast: value doesn't fit in 192 bits");
708     }
709 
710     /**
711      * @dev Returns the downcasted int184 from int256, reverting on
712      * overflow (when the input is less than smallest int184 or
713      * greater than largest int184).
714      *
715      * Counterpart to Solidity's `int184` operator.
716      *
717      * Requirements:
718      *
719      * - input must fit into 184 bits
720      *
721      * _Available since v4.7._
722      */
723     function toInt184(int256 value) internal pure returns (int184 downcasted) {
724         downcasted = int184(value);
725         require(downcasted == value, "SafeCast: value doesn't fit in 184 bits");
726     }
727 
728     /**
729      * @dev Returns the downcasted int176 from int256, reverting on
730      * overflow (when the input is less than smallest int176 or
731      * greater than largest int176).
732      *
733      * Counterpart to Solidity's `int176` operator.
734      *
735      * Requirements:
736      *
737      * - input must fit into 176 bits
738      *
739      * _Available since v4.7._
740      */
741     function toInt176(int256 value) internal pure returns (int176 downcasted) {
742         downcasted = int176(value);
743         require(downcasted == value, "SafeCast: value doesn't fit in 176 bits");
744     }
745 
746     /**
747      * @dev Returns the downcasted int168 from int256, reverting on
748      * overflow (when the input is less than smallest int168 or
749      * greater than largest int168).
750      *
751      * Counterpart to Solidity's `int168` operator.
752      *
753      * Requirements:
754      *
755      * - input must fit into 168 bits
756      *
757      * _Available since v4.7._
758      */
759     function toInt168(int256 value) internal pure returns (int168 downcasted) {
760         downcasted = int168(value);
761         require(downcasted == value, "SafeCast: value doesn't fit in 168 bits");
762     }
763 
764     /**
765      * @dev Returns the downcasted int160 from int256, reverting on
766      * overflow (when the input is less than smallest int160 or
767      * greater than largest int160).
768      *
769      * Counterpart to Solidity's `int160` operator.
770      *
771      * Requirements:
772      *
773      * - input must fit into 160 bits
774      *
775      * _Available since v4.7._
776      */
777     function toInt160(int256 value) internal pure returns (int160 downcasted) {
778         downcasted = int160(value);
779         require(downcasted == value, "SafeCast: value doesn't fit in 160 bits");
780     }
781 
782     /**
783      * @dev Returns the downcasted int152 from int256, reverting on
784      * overflow (when the input is less than smallest int152 or
785      * greater than largest int152).
786      *
787      * Counterpart to Solidity's `int152` operator.
788      *
789      * Requirements:
790      *
791      * - input must fit into 152 bits
792      *
793      * _Available since v4.7._
794      */
795     function toInt152(int256 value) internal pure returns (int152 downcasted) {
796         downcasted = int152(value);
797         require(downcasted == value, "SafeCast: value doesn't fit in 152 bits");
798     }
799 
800     /**
801      * @dev Returns the downcasted int144 from int256, reverting on
802      * overflow (when the input is less than smallest int144 or
803      * greater than largest int144).
804      *
805      * Counterpart to Solidity's `int144` operator.
806      *
807      * Requirements:
808      *
809      * - input must fit into 144 bits
810      *
811      * _Available since v4.7._
812      */
813     function toInt144(int256 value) internal pure returns (int144 downcasted) {
814         downcasted = int144(value);
815         require(downcasted == value, "SafeCast: value doesn't fit in 144 bits");
816     }
817 
818     /**
819      * @dev Returns the downcasted int136 from int256, reverting on
820      * overflow (when the input is less than smallest int136 or
821      * greater than largest int136).
822      *
823      * Counterpart to Solidity's `int136` operator.
824      *
825      * Requirements:
826      *
827      * - input must fit into 136 bits
828      *
829      * _Available since v4.7._
830      */
831     function toInt136(int256 value) internal pure returns (int136 downcasted) {
832         downcasted = int136(value);
833         require(downcasted == value, "SafeCast: value doesn't fit in 136 bits");
834     }
835 
836     /**
837      * @dev Returns the downcasted int128 from int256, reverting on
838      * overflow (when the input is less than smallest int128 or
839      * greater than largest int128).
840      *
841      * Counterpart to Solidity's `int128` operator.
842      *
843      * Requirements:
844      *
845      * - input must fit into 128 bits
846      *
847      * _Available since v3.1._
848      */
849     function toInt128(int256 value) internal pure returns (int128 downcasted) {
850         downcasted = int128(value);
851         require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
852     }
853 
854     /**
855      * @dev Returns the downcasted int120 from int256, reverting on
856      * overflow (when the input is less than smallest int120 or
857      * greater than largest int120).
858      *
859      * Counterpart to Solidity's `int120` operator.
860      *
861      * Requirements:
862      *
863      * - input must fit into 120 bits
864      *
865      * _Available since v4.7._
866      */
867     function toInt120(int256 value) internal pure returns (int120 downcasted) {
868         downcasted = int120(value);
869         require(downcasted == value, "SafeCast: value doesn't fit in 120 bits");
870     }
871 
872     /**
873      * @dev Returns the downcasted int112 from int256, reverting on
874      * overflow (when the input is less than smallest int112 or
875      * greater than largest int112).
876      *
877      * Counterpart to Solidity's `int112` operator.
878      *
879      * Requirements:
880      *
881      * - input must fit into 112 bits
882      *
883      * _Available since v4.7._
884      */
885     function toInt112(int256 value) internal pure returns (int112 downcasted) {
886         downcasted = int112(value);
887         require(downcasted == value, "SafeCast: value doesn't fit in 112 bits");
888     }
889 
890     /**
891      * @dev Returns the downcasted int104 from int256, reverting on
892      * overflow (when the input is less than smallest int104 or
893      * greater than largest int104).
894      *
895      * Counterpart to Solidity's `int104` operator.
896      *
897      * Requirements:
898      *
899      * - input must fit into 104 bits
900      *
901      * _Available since v4.7._
902      */
903     function toInt104(int256 value) internal pure returns (int104 downcasted) {
904         downcasted = int104(value);
905         require(downcasted == value, "SafeCast: value doesn't fit in 104 bits");
906     }
907 
908     /**
909      * @dev Returns the downcasted int96 from int256, reverting on
910      * overflow (when the input is less than smallest int96 or
911      * greater than largest int96).
912      *
913      * Counterpart to Solidity's `int96` operator.
914      *
915      * Requirements:
916      *
917      * - input must fit into 96 bits
918      *
919      * _Available since v4.7._
920      */
921     function toInt96(int256 value) internal pure returns (int96 downcasted) {
922         downcasted = int96(value);
923         require(downcasted == value, "SafeCast: value doesn't fit in 96 bits");
924     }
925 
926     /**
927      * @dev Returns the downcasted int88 from int256, reverting on
928      * overflow (when the input is less than smallest int88 or
929      * greater than largest int88).
930      *
931      * Counterpart to Solidity's `int88` operator.
932      *
933      * Requirements:
934      *
935      * - input must fit into 88 bits
936      *
937      * _Available since v4.7._
938      */
939     function toInt88(int256 value) internal pure returns (int88 downcasted) {
940         downcasted = int88(value);
941         require(downcasted == value, "SafeCast: value doesn't fit in 88 bits");
942     }
943 
944     /**
945      * @dev Returns the downcasted int80 from int256, reverting on
946      * overflow (when the input is less than smallest int80 or
947      * greater than largest int80).
948      *
949      * Counterpart to Solidity's `int80` operator.
950      *
951      * Requirements:
952      *
953      * - input must fit into 80 bits
954      *
955      * _Available since v4.7._
956      */
957     function toInt80(int256 value) internal pure returns (int80 downcasted) {
958         downcasted = int80(value);
959         require(downcasted == value, "SafeCast: value doesn't fit in 80 bits");
960     }
961 
962     /**
963      * @dev Returns the downcasted int72 from int256, reverting on
964      * overflow (when the input is less than smallest int72 or
965      * greater than largest int72).
966      *
967      * Counterpart to Solidity's `int72` operator.
968      *
969      * Requirements:
970      *
971      * - input must fit into 72 bits
972      *
973      * _Available since v4.7._
974      */
975     function toInt72(int256 value) internal pure returns (int72 downcasted) {
976         downcasted = int72(value);
977         require(downcasted == value, "SafeCast: value doesn't fit in 72 bits");
978     }
979 
980     /**
981      * @dev Returns the downcasted int64 from int256, reverting on
982      * overflow (when the input is less than smallest int64 or
983      * greater than largest int64).
984      *
985      * Counterpart to Solidity's `int64` operator.
986      *
987      * Requirements:
988      *
989      * - input must fit into 64 bits
990      *
991      * _Available since v3.1._
992      */
993     function toInt64(int256 value) internal pure returns (int64 downcasted) {
994         downcasted = int64(value);
995         require(downcasted == value, "SafeCast: value doesn't fit in 64 bits");
996     }
997 
998     /**
999      * @dev Returns the downcasted int56 from int256, reverting on
1000      * overflow (when the input is less than smallest int56 or
1001      * greater than largest int56).
1002      *
1003      * Counterpart to Solidity's `int56` operator.
1004      *
1005      * Requirements:
1006      *
1007      * - input must fit into 56 bits
1008      *
1009      * _Available since v4.7._
1010      */
1011     function toInt56(int256 value) internal pure returns (int56 downcasted) {
1012         downcasted = int56(value);
1013         require(downcasted == value, "SafeCast: value doesn't fit in 56 bits");
1014     }
1015 
1016     /**
1017      * @dev Returns the downcasted int48 from int256, reverting on
1018      * overflow (when the input is less than smallest int48 or
1019      * greater than largest int48).
1020      *
1021      * Counterpart to Solidity's `int48` operator.
1022      *
1023      * Requirements:
1024      *
1025      * - input must fit into 48 bits
1026      *
1027      * _Available since v4.7._
1028      */
1029     function toInt48(int256 value) internal pure returns (int48 downcasted) {
1030         downcasted = int48(value);
1031         require(downcasted == value, "SafeCast: value doesn't fit in 48 bits");
1032     }
1033 
1034     /**
1035      * @dev Returns the downcasted int40 from int256, reverting on
1036      * overflow (when the input is less than smallest int40 or
1037      * greater than largest int40).
1038      *
1039      * Counterpart to Solidity's `int40` operator.
1040      *
1041      * Requirements:
1042      *
1043      * - input must fit into 40 bits
1044      *
1045      * _Available since v4.7._
1046      */
1047     function toInt40(int256 value) internal pure returns (int40 downcasted) {
1048         downcasted = int40(value);
1049         require(downcasted == value, "SafeCast: value doesn't fit in 40 bits");
1050     }
1051 
1052     /**
1053      * @dev Returns the downcasted int32 from int256, reverting on
1054      * overflow (when the input is less than smallest int32 or
1055      * greater than largest int32).
1056      *
1057      * Counterpart to Solidity's `int32` operator.
1058      *
1059      * Requirements:
1060      *
1061      * - input must fit into 32 bits
1062      *
1063      * _Available since v3.1._
1064      */
1065     function toInt32(int256 value) internal pure returns (int32 downcasted) {
1066         downcasted = int32(value);
1067         require(downcasted == value, "SafeCast: value doesn't fit in 32 bits");
1068     }
1069 
1070     /**
1071      * @dev Returns the downcasted int24 from int256, reverting on
1072      * overflow (when the input is less than smallest int24 or
1073      * greater than largest int24).
1074      *
1075      * Counterpart to Solidity's `int24` operator.
1076      *
1077      * Requirements:
1078      *
1079      * - input must fit into 24 bits
1080      *
1081      * _Available since v4.7._
1082      */
1083     function toInt24(int256 value) internal pure returns (int24 downcasted) {
1084         downcasted = int24(value);
1085         require(downcasted == value, "SafeCast: value doesn't fit in 24 bits");
1086     }
1087 
1088     /**
1089      * @dev Returns the downcasted int16 from int256, reverting on
1090      * overflow (when the input is less than smallest int16 or
1091      * greater than largest int16).
1092      *
1093      * Counterpart to Solidity's `int16` operator.
1094      *
1095      * Requirements:
1096      *
1097      * - input must fit into 16 bits
1098      *
1099      * _Available since v3.1._
1100      */
1101     function toInt16(int256 value) internal pure returns (int16 downcasted) {
1102         downcasted = int16(value);
1103         require(downcasted == value, "SafeCast: value doesn't fit in 16 bits");
1104     }
1105 
1106     /**
1107      * @dev Returns the downcasted int8 from int256, reverting on
1108      * overflow (when the input is less than smallest int8 or
1109      * greater than largest int8).
1110      *
1111      * Counterpart to Solidity's `int8` operator.
1112      *
1113      * Requirements:
1114      *
1115      * - input must fit into 8 bits
1116      *
1117      * _Available since v3.1._
1118      */
1119     function toInt8(int256 value) internal pure returns (int8 downcasted) {
1120         downcasted = int8(value);
1121         require(downcasted == value, "SafeCast: value doesn't fit in 8 bits");
1122     }
1123 
1124     /**
1125      * @dev Converts an unsigned uint256 into a signed int256.
1126      *
1127      * Requirements:
1128      *
1129      * - input must be less than or equal to maxInt256.
1130      *
1131      * _Available since v3.0._
1132      */
1133     function toInt256(uint256 value) internal pure returns (int256) {
1134         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1135         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1136         return int256(value);
1137     }
1138 }
1139 
1140 // File: @openzeppelin/contracts/governance/utils/IVotes.sol
1141 
1142 
1143 // OpenZeppelin Contracts (last updated v4.5.0) (governance/utils/IVotes.sol)
1144 pragma solidity ^0.8.0;
1145 
1146 /**
1147  * @dev Common interface for {ERC20Votes}, {ERC721Votes}, and other {Votes}-enabled contracts.
1148  *
1149  * _Available since v4.5._
1150  */
1151 interface IVotes {
1152     /**
1153      * @dev Emitted when an account changes their delegate.
1154      */
1155     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1156 
1157     /**
1158      * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
1159      */
1160     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1161 
1162     /**
1163      * @dev Returns the current amount of votes that `account` has.
1164      */
1165     function getVotes(address account) external view returns (uint256);
1166 
1167     /**
1168      * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
1169      */
1170     function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
1171 
1172     /**
1173      * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
1174      *
1175      * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
1176      * Votes that have not been delegated are still part of total supply, even though they would not participate in a
1177      * vote.
1178      */
1179     function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
1180 
1181     /**
1182      * @dev Returns the delegate that `account` has chosen.
1183      */
1184     function delegates(address account) external view returns (address);
1185 
1186     /**
1187      * @dev Delegates votes from the sender to `delegatee`.
1188      */
1189     function delegate(address delegatee) external;
1190 
1191     /**
1192      * @dev Delegates votes from signer to `delegatee`.
1193      */
1194     function delegateBySig(
1195         address delegatee,
1196         uint256 nonce,
1197         uint256 expiry,
1198         uint8 v,
1199         bytes32 r,
1200         bytes32 s
1201     ) external;
1202 }
1203 
1204 // File: @openzeppelin/contracts/utils/Counters.sol
1205 
1206 
1207 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 /**
1212  * @title Counters
1213  * @author Matt Condon (@shrugs)
1214  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1215  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1216  *
1217  * Include with `using Counters for Counters.Counter;`
1218  */
1219 library Counters {
1220     struct Counter {
1221         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1222         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1223         // this feature: see https://github.com/ethereum/solidity/issues/4637
1224         uint256 _value; // default: 0
1225     }
1226 
1227     function current(Counter storage counter) internal view returns (uint256) {
1228         return counter._value;
1229     }
1230 
1231     function increment(Counter storage counter) internal {
1232         unchecked {
1233             counter._value += 1;
1234         }
1235     }
1236 
1237     function decrement(Counter storage counter) internal {
1238         uint256 value = counter._value;
1239         require(value > 0, "Counter: decrement overflow");
1240         unchecked {
1241             counter._value = value - 1;
1242         }
1243     }
1244 
1245     function reset(Counter storage counter) internal {
1246         counter._value = 0;
1247     }
1248 }
1249 
1250 // File: @openzeppelin/contracts/utils/math/Math.sol
1251 
1252 
1253 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 /**
1258  * @dev Standard math utilities missing in the Solidity language.
1259  */
1260 library Math {
1261     enum Rounding {
1262         Down, // Toward negative infinity
1263         Up, // Toward infinity
1264         Zero // Toward zero
1265     }
1266 
1267     /**
1268      * @dev Returns the largest of two numbers.
1269      */
1270     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1271         return a > b ? a : b;
1272     }
1273 
1274     /**
1275      * @dev Returns the smallest of two numbers.
1276      */
1277     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1278         return a < b ? a : b;
1279     }
1280 
1281     /**
1282      * @dev Returns the average of two numbers. The result is rounded towards
1283      * zero.
1284      */
1285     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1286         // (a + b) / 2 can overflow.
1287         return (a & b) + (a ^ b) / 2;
1288     }
1289 
1290     /**
1291      * @dev Returns the ceiling of the division of two numbers.
1292      *
1293      * This differs from standard division with `/` in that it rounds up instead
1294      * of rounding down.
1295      */
1296     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1297         // (a + b - 1) / b can overflow on addition, so we distribute.
1298         return a == 0 ? 0 : (a - 1) / b + 1;
1299     }
1300 
1301     /**
1302      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1303      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1304      * with further edits by Uniswap Labs also under MIT license.
1305      */
1306     function mulDiv(
1307         uint256 x,
1308         uint256 y,
1309         uint256 denominator
1310     ) internal pure returns (uint256 result) {
1311         unchecked {
1312             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1313             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1314             // variables such that product = prod1 * 2^256 + prod0.
1315             uint256 prod0; // Least significant 256 bits of the product
1316             uint256 prod1; // Most significant 256 bits of the product
1317             assembly {
1318                 let mm := mulmod(x, y, not(0))
1319                 prod0 := mul(x, y)
1320                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1321             }
1322 
1323             // Handle non-overflow cases, 256 by 256 division.
1324             if (prod1 == 0) {
1325                 return prod0 / denominator;
1326             }
1327 
1328             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1329             require(denominator > prod1);
1330 
1331             ///////////////////////////////////////////////
1332             // 512 by 256 division.
1333             ///////////////////////////////////////////////
1334 
1335             // Make division exact by subtracting the remainder from [prod1 prod0].
1336             uint256 remainder;
1337             assembly {
1338                 // Compute remainder using mulmod.
1339                 remainder := mulmod(x, y, denominator)
1340 
1341                 // Subtract 256 bit number from 512 bit number.
1342                 prod1 := sub(prod1, gt(remainder, prod0))
1343                 prod0 := sub(prod0, remainder)
1344             }
1345 
1346             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1347             // See https://cs.stackexchange.com/q/138556/92363.
1348 
1349             // Does not overflow because the denominator cannot be zero at this stage in the function.
1350             uint256 twos = denominator & (~denominator + 1);
1351             assembly {
1352                 // Divide denominator by twos.
1353                 denominator := div(denominator, twos)
1354 
1355                 // Divide [prod1 prod0] by twos.
1356                 prod0 := div(prod0, twos)
1357 
1358                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1359                 twos := add(div(sub(0, twos), twos), 1)
1360             }
1361 
1362             // Shift in bits from prod1 into prod0.
1363             prod0 |= prod1 * twos;
1364 
1365             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1366             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1367             // four bits. That is, denominator * inv = 1 mod 2^4.
1368             uint256 inverse = (3 * denominator) ^ 2;
1369 
1370             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1371             // in modular arithmetic, doubling the correct bits in each step.
1372             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1373             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1374             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1375             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1376             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1377             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1378 
1379             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1380             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1381             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1382             // is no longer required.
1383             result = prod0 * inverse;
1384             return result;
1385         }
1386     }
1387 
1388     /**
1389      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1390      */
1391     function mulDiv(
1392         uint256 x,
1393         uint256 y,
1394         uint256 denominator,
1395         Rounding rounding
1396     ) internal pure returns (uint256) {
1397         uint256 result = mulDiv(x, y, denominator);
1398         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1399             result += 1;
1400         }
1401         return result;
1402     }
1403 
1404     /**
1405      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1406      *
1407      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1408      */
1409     function sqrt(uint256 a) internal pure returns (uint256) {
1410         if (a == 0) {
1411             return 0;
1412         }
1413 
1414         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1415         //
1416         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1417         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1418         //
1419         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1420         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1421         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1422         //
1423         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1424         uint256 result = 1 << (log2(a) >> 1);
1425 
1426         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1427         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1428         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1429         // into the expected uint128 result.
1430         unchecked {
1431             result = (result + a / result) >> 1;
1432             result = (result + a / result) >> 1;
1433             result = (result + a / result) >> 1;
1434             result = (result + a / result) >> 1;
1435             result = (result + a / result) >> 1;
1436             result = (result + a / result) >> 1;
1437             result = (result + a / result) >> 1;
1438             return min(result, a / result);
1439         }
1440     }
1441 
1442     /**
1443      * @notice Calculates sqrt(a), following the selected rounding direction.
1444      */
1445     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1446         unchecked {
1447             uint256 result = sqrt(a);
1448             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1449         }
1450     }
1451 
1452     /**
1453      * @dev Return the log in base 2, rounded down, of a positive value.
1454      * Returns 0 if given 0.
1455      */
1456     function log2(uint256 value) internal pure returns (uint256) {
1457         uint256 result = 0;
1458         unchecked {
1459             if (value >> 128 > 0) {
1460                 value >>= 128;
1461                 result += 128;
1462             }
1463             if (value >> 64 > 0) {
1464                 value >>= 64;
1465                 result += 64;
1466             }
1467             if (value >> 32 > 0) {
1468                 value >>= 32;
1469                 result += 32;
1470             }
1471             if (value >> 16 > 0) {
1472                 value >>= 16;
1473                 result += 16;
1474             }
1475             if (value >> 8 > 0) {
1476                 value >>= 8;
1477                 result += 8;
1478             }
1479             if (value >> 4 > 0) {
1480                 value >>= 4;
1481                 result += 4;
1482             }
1483             if (value >> 2 > 0) {
1484                 value >>= 2;
1485                 result += 2;
1486             }
1487             if (value >> 1 > 0) {
1488                 result += 1;
1489             }
1490         }
1491         return result;
1492     }
1493 
1494     /**
1495      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1496      * Returns 0 if given 0.
1497      */
1498     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1499         unchecked {
1500             uint256 result = log2(value);
1501             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1502         }
1503     }
1504 
1505     /**
1506      * @dev Return the log in base 10, rounded down, of a positive value.
1507      * Returns 0 if given 0.
1508      */
1509     function log10(uint256 value) internal pure returns (uint256) {
1510         uint256 result = 0;
1511         unchecked {
1512             if (value >= 10**64) {
1513                 value /= 10**64;
1514                 result += 64;
1515             }
1516             if (value >= 10**32) {
1517                 value /= 10**32;
1518                 result += 32;
1519             }
1520             if (value >= 10**16) {
1521                 value /= 10**16;
1522                 result += 16;
1523             }
1524             if (value >= 10**8) {
1525                 value /= 10**8;
1526                 result += 8;
1527             }
1528             if (value >= 10**4) {
1529                 value /= 10**4;
1530                 result += 4;
1531             }
1532             if (value >= 10**2) {
1533                 value /= 10**2;
1534                 result += 2;
1535             }
1536             if (value >= 10**1) {
1537                 result += 1;
1538             }
1539         }
1540         return result;
1541     }
1542 
1543     /**
1544      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1545      * Returns 0 if given 0.
1546      */
1547     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1548         unchecked {
1549             uint256 result = log10(value);
1550             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1551         }
1552     }
1553 
1554     /**
1555      * @dev Return the log in base 256, rounded down, of a positive value.
1556      * Returns 0 if given 0.
1557      *
1558      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1559      */
1560     function log256(uint256 value) internal pure returns (uint256) {
1561         uint256 result = 0;
1562         unchecked {
1563             if (value >> 128 > 0) {
1564                 value >>= 128;
1565                 result += 16;
1566             }
1567             if (value >> 64 > 0) {
1568                 value >>= 64;
1569                 result += 8;
1570             }
1571             if (value >> 32 > 0) {
1572                 value >>= 32;
1573                 result += 4;
1574             }
1575             if (value >> 16 > 0) {
1576                 value >>= 16;
1577                 result += 2;
1578             }
1579             if (value >> 8 > 0) {
1580                 result += 1;
1581             }
1582         }
1583         return result;
1584     }
1585 
1586     /**
1587      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1588      * Returns 0 if given 0.
1589      */
1590     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1591         unchecked {
1592             uint256 result = log256(value);
1593             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1594         }
1595     }
1596 }
1597 
1598 // File: @openzeppelin/contracts/utils/Strings.sol
1599 
1600 
1601 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 /**
1607  * @dev String operations.
1608  */
1609 library Strings {
1610     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1611     uint8 private constant _ADDRESS_LENGTH = 20;
1612 
1613     /**
1614      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1615      */
1616     function toString(uint256 value) internal pure returns (string memory) {
1617         unchecked {
1618             uint256 length = Math.log10(value) + 1;
1619             string memory buffer = new string(length);
1620             uint256 ptr;
1621             /// @solidity memory-safe-assembly
1622             assembly {
1623                 ptr := add(buffer, add(32, length))
1624             }
1625             while (true) {
1626                 ptr--;
1627                 /// @solidity memory-safe-assembly
1628                 assembly {
1629                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1630                 }
1631                 value /= 10;
1632                 if (value == 0) break;
1633             }
1634             return buffer;
1635         }
1636     }
1637 
1638     /**
1639      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1640      */
1641     function toHexString(uint256 value) internal pure returns (string memory) {
1642         unchecked {
1643             return toHexString(value, Math.log256(value) + 1);
1644         }
1645     }
1646 
1647     /**
1648      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1649      */
1650     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1651         bytes memory buffer = new bytes(2 * length + 2);
1652         buffer[0] = "0";
1653         buffer[1] = "x";
1654         for (uint256 i = 2 * length + 1; i > 1; --i) {
1655             buffer[i] = _SYMBOLS[value & 0xf];
1656             value >>= 4;
1657         }
1658         require(value == 0, "Strings: hex length insufficient");
1659         return string(buffer);
1660     }
1661 
1662     /**
1663      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1664      */
1665     function toHexString(address addr) internal pure returns (string memory) {
1666         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1667     }
1668 }
1669 
1670 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1671 
1672 
1673 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1674 
1675 pragma solidity ^0.8.0;
1676 
1677 
1678 /**
1679  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1680  *
1681  * These functions can be used to verify that a message was signed by the holder
1682  * of the private keys of a given address.
1683  */
1684 library ECDSA {
1685     enum RecoverError {
1686         NoError,
1687         InvalidSignature,
1688         InvalidSignatureLength,
1689         InvalidSignatureS,
1690         InvalidSignatureV // Deprecated in v4.8
1691     }
1692 
1693     function _throwError(RecoverError error) private pure {
1694         if (error == RecoverError.NoError) {
1695             return; // no error: do nothing
1696         } else if (error == RecoverError.InvalidSignature) {
1697             revert("ECDSA: invalid signature");
1698         } else if (error == RecoverError.InvalidSignatureLength) {
1699             revert("ECDSA: invalid signature length");
1700         } else if (error == RecoverError.InvalidSignatureS) {
1701             revert("ECDSA: invalid signature 's' value");
1702         }
1703     }
1704 
1705     /**
1706      * @dev Returns the address that signed a hashed message (`hash`) with
1707      * `signature` or error string. This address can then be used for verification purposes.
1708      *
1709      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1710      * this function rejects them by requiring the `s` value to be in the lower
1711      * half order, and the `v` value to be either 27 or 28.
1712      *
1713      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1714      * verification to be secure: it is possible to craft signatures that
1715      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1716      * this is by receiving a hash of the original message (which may otherwise
1717      * be too long), and then calling {toEthSignedMessageHash} on it.
1718      *
1719      * Documentation for signature generation:
1720      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1721      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1722      *
1723      * _Available since v4.3._
1724      */
1725     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1726         if (signature.length == 65) {
1727             bytes32 r;
1728             bytes32 s;
1729             uint8 v;
1730             // ecrecover takes the signature parameters, and the only way to get them
1731             // currently is to use assembly.
1732             /// @solidity memory-safe-assembly
1733             assembly {
1734                 r := mload(add(signature, 0x20))
1735                 s := mload(add(signature, 0x40))
1736                 v := byte(0, mload(add(signature, 0x60)))
1737             }
1738             return tryRecover(hash, v, r, s);
1739         } else {
1740             return (address(0), RecoverError.InvalidSignatureLength);
1741         }
1742     }
1743 
1744     /**
1745      * @dev Returns the address that signed a hashed message (`hash`) with
1746      * `signature`. This address can then be used for verification purposes.
1747      *
1748      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1749      * this function rejects them by requiring the `s` value to be in the lower
1750      * half order, and the `v` value to be either 27 or 28.
1751      *
1752      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1753      * verification to be secure: it is possible to craft signatures that
1754      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1755      * this is by receiving a hash of the original message (which may otherwise
1756      * be too long), and then calling {toEthSignedMessageHash} on it.
1757      */
1758     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1759         (address recovered, RecoverError error) = tryRecover(hash, signature);
1760         _throwError(error);
1761         return recovered;
1762     }
1763 
1764     /**
1765      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1766      *
1767      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1768      *
1769      * _Available since v4.3._
1770      */
1771     function tryRecover(
1772         bytes32 hash,
1773         bytes32 r,
1774         bytes32 vs
1775     ) internal pure returns (address, RecoverError) {
1776         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1777         uint8 v = uint8((uint256(vs) >> 255) + 27);
1778         return tryRecover(hash, v, r, s);
1779     }
1780 
1781     /**
1782      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1783      *
1784      * _Available since v4.2._
1785      */
1786     function recover(
1787         bytes32 hash,
1788         bytes32 r,
1789         bytes32 vs
1790     ) internal pure returns (address) {
1791         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1792         _throwError(error);
1793         return recovered;
1794     }
1795 
1796     /**
1797      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1798      * `r` and `s` signature fields separately.
1799      *
1800      * _Available since v4.3._
1801      */
1802     function tryRecover(
1803         bytes32 hash,
1804         uint8 v,
1805         bytes32 r,
1806         bytes32 s
1807     ) internal pure returns (address, RecoverError) {
1808         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1809         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1810         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1811         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1812         //
1813         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1814         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1815         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1816         // these malleable signatures as well.
1817         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1818             return (address(0), RecoverError.InvalidSignatureS);
1819         }
1820 
1821         // If the signature is valid (and not malleable), return the signer address
1822         address signer = ecrecover(hash, v, r, s);
1823         if (signer == address(0)) {
1824             return (address(0), RecoverError.InvalidSignature);
1825         }
1826 
1827         return (signer, RecoverError.NoError);
1828     }
1829 
1830     /**
1831      * @dev Overload of {ECDSA-recover} that receives the `v`,
1832      * `r` and `s` signature fields separately.
1833      */
1834     function recover(
1835         bytes32 hash,
1836         uint8 v,
1837         bytes32 r,
1838         bytes32 s
1839     ) internal pure returns (address) {
1840         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1841         _throwError(error);
1842         return recovered;
1843     }
1844 
1845     /**
1846      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1847      * produces hash corresponding to the one signed with the
1848      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1849      * JSON-RPC method as part of EIP-191.
1850      *
1851      * See {recover}.
1852      */
1853     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1854         // 32 is the length in bytes of hash,
1855         // enforced by the type signature above
1856         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1857     }
1858 
1859     /**
1860      * @dev Returns an Ethereum Signed Message, created from `s`. This
1861      * produces hash corresponding to the one signed with the
1862      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1863      * JSON-RPC method as part of EIP-191.
1864      *
1865      * See {recover}.
1866      */
1867     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1868         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1869     }
1870 
1871     /**
1872      * @dev Returns an Ethereum Signed Typed Data, created from a
1873      * `domainSeparator` and a `structHash`. This produces hash corresponding
1874      * to the one signed with the
1875      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1876      * JSON-RPC method as part of EIP-712.
1877      *
1878      * See {recover}.
1879      */
1880     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1881         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1882     }
1883 }
1884 
1885 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
1886 
1887 
1888 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
1889 
1890 pragma solidity ^0.8.0;
1891 
1892 
1893 /**
1894  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1895  *
1896  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1897  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1898  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1899  *
1900  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1901  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1902  * ({_hashTypedDataV4}).
1903  *
1904  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1905  * the chain id to protect against replay attacks on an eventual fork of the chain.
1906  *
1907  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1908  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1909  *
1910  * _Available since v3.4._
1911  */
1912 abstract contract EIP712 {
1913     /* solhint-disable var-name-mixedcase */
1914     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1915     // invalidate the cached domain separator if the chain id changes.
1916     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1917     uint256 private immutable _CACHED_CHAIN_ID;
1918     address private immutable _CACHED_THIS;
1919 
1920     bytes32 private immutable _HASHED_NAME;
1921     bytes32 private immutable _HASHED_VERSION;
1922     bytes32 private immutable _TYPE_HASH;
1923 
1924     /* solhint-enable var-name-mixedcase */
1925 
1926     /**
1927      * @dev Initializes the domain separator and parameter caches.
1928      *
1929      * The meaning of `name` and `version` is specified in
1930      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1931      *
1932      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1933      * - `version`: the current major version of the signing domain.
1934      *
1935      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1936      * contract upgrade].
1937      */
1938     constructor(string memory name, string memory version) {
1939         bytes32 hashedName = keccak256(bytes(name));
1940         bytes32 hashedVersion = keccak256(bytes(version));
1941         bytes32 typeHash = keccak256(
1942             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1943         );
1944         _HASHED_NAME = hashedName;
1945         _HASHED_VERSION = hashedVersion;
1946         _CACHED_CHAIN_ID = block.chainid;
1947         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1948         _CACHED_THIS = address(this);
1949         _TYPE_HASH = typeHash;
1950     }
1951 
1952     /**
1953      * @dev Returns the domain separator for the current chain.
1954      */
1955     function _domainSeparatorV4() internal view returns (bytes32) {
1956         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1957             return _CACHED_DOMAIN_SEPARATOR;
1958         } else {
1959             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1960         }
1961     }
1962 
1963     function _buildDomainSeparator(
1964         bytes32 typeHash,
1965         bytes32 nameHash,
1966         bytes32 versionHash
1967     ) private view returns (bytes32) {
1968         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1969     }
1970 
1971     /**
1972      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1973      * function returns the hash of the fully encoded EIP712 message for this domain.
1974      *
1975      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1976      *
1977      * ```solidity
1978      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1979      *     keccak256("Mail(address to,string contents)"),
1980      *     mailTo,
1981      *     keccak256(bytes(mailContents))
1982      * )));
1983      * address signer = ECDSA.recover(digest, signature);
1984      * ```
1985      */
1986     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1987         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1988     }
1989 }
1990 
1991 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
1992 
1993 
1994 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1995 
1996 pragma solidity ^0.8.0;
1997 
1998 /**
1999  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2000  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2001  *
2002  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2003  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
2004  * need to send a transaction, and thus is not required to hold Ether at all.
2005  */
2006 interface IERC20Permit {
2007     /**
2008      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
2009      * given ``owner``'s signed approval.
2010      *
2011      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
2012      * ordering also apply here.
2013      *
2014      * Emits an {Approval} event.
2015      *
2016      * Requirements:
2017      *
2018      * - `spender` cannot be the zero address.
2019      * - `deadline` must be a timestamp in the future.
2020      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2021      * over the EIP712-formatted function arguments.
2022      * - the signature must use ``owner``'s current nonce (see {nonces}).
2023      *
2024      * For more information on the signature format, see the
2025      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2026      * section].
2027      */
2028     function permit(
2029         address owner,
2030         address spender,
2031         uint256 value,
2032         uint256 deadline,
2033         uint8 v,
2034         bytes32 r,
2035         bytes32 s
2036     ) external;
2037 
2038     /**
2039      * @dev Returns the current nonce for `owner`. This value must be
2040      * included whenever a signature is generated for {permit}.
2041      *
2042      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2043      * prevents a signature from being used multiple times.
2044      */
2045     function nonces(address owner) external view returns (uint256);
2046 
2047     /**
2048      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2049      */
2050     // solhint-disable-next-line func-name-mixedcase
2051     function DOMAIN_SEPARATOR() external view returns (bytes32);
2052 }
2053 
2054 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2055 
2056 
2057 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2058 
2059 pragma solidity ^0.8.0;
2060 
2061 /**
2062  * @dev Interface of the ERC20 standard as defined in the EIP.
2063  */
2064 interface IERC20 {
2065     /**
2066      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2067      * another (`to`).
2068      *
2069      * Note that `value` may be zero.
2070      */
2071     event Transfer(address indexed from, address indexed to, uint256 value);
2072 
2073     /**
2074      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2075      * a call to {approve}. `value` is the new allowance.
2076      */
2077     event Approval(address indexed owner, address indexed spender, uint256 value);
2078 
2079     /**
2080      * @dev Returns the amount of tokens in existence.
2081      */
2082     function totalSupply() external view returns (uint256);
2083 
2084     /**
2085      * @dev Returns the amount of tokens owned by `account`.
2086      */
2087     function balanceOf(address account) external view returns (uint256);
2088 
2089     /**
2090      * @dev Moves `amount` tokens from the caller's account to `to`.
2091      *
2092      * Returns a boolean value indicating whether the operation succeeded.
2093      *
2094      * Emits a {Transfer} event.
2095      */
2096     function transfer(address to, uint256 amount) external returns (bool);
2097 
2098     /**
2099      * @dev Returns the remaining number of tokens that `spender` will be
2100      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2101      * zero by default.
2102      *
2103      * This value changes when {approve} or {transferFrom} are called.
2104      */
2105     function allowance(address owner, address spender) external view returns (uint256);
2106 
2107     /**
2108      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2109      *
2110      * Returns a boolean value indicating whether the operation succeeded.
2111      *
2112      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2113      * that someone may use both the old and the new allowance by unfortunate
2114      * transaction ordering. One possible solution to mitigate this race
2115      * condition is to first reduce the spender's allowance to 0 and set the
2116      * desired value afterwards:
2117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2118      *
2119      * Emits an {Approval} event.
2120      */
2121     function approve(address spender, uint256 amount) external returns (bool);
2122 
2123     /**
2124      * @dev Moves `amount` tokens from `from` to `to` using the
2125      * allowance mechanism. `amount` is then deducted from the caller's
2126      * allowance.
2127      *
2128      * Returns a boolean value indicating whether the operation succeeded.
2129      *
2130      * Emits a {Transfer} event.
2131      */
2132     function transferFrom(
2133         address from,
2134         address to,
2135         uint256 amount
2136     ) external returns (bool);
2137 }
2138 
2139 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
2140 
2141 
2142 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
2143 
2144 pragma solidity ^0.8.0;
2145 
2146 
2147 /**
2148  * @dev Interface for the optional metadata functions from the ERC20 standard.
2149  *
2150  * _Available since v4.1._
2151  */
2152 interface IERC20Metadata is IERC20 {
2153     /**
2154      * @dev Returns the name of the token.
2155      */
2156     function name() external view returns (string memory);
2157 
2158     /**
2159      * @dev Returns the symbol of the token.
2160      */
2161     function symbol() external view returns (string memory);
2162 
2163     /**
2164      * @dev Returns the decimals places of the token.
2165      */
2166     function decimals() external view returns (uint8);
2167 }
2168 
2169 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2170 
2171 
2172 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2173 
2174 pragma solidity ^0.8.0;
2175 
2176 /**
2177  * @dev Contract module that helps prevent reentrant calls to a function.
2178  *
2179  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2180  * available, which can be applied to functions to make sure there are no nested
2181  * (reentrant) calls to them.
2182  *
2183  * Note that because there is a single `nonReentrant` guard, functions marked as
2184  * `nonReentrant` may not call one another. This can be worked around by making
2185  * those functions `private`, and then adding `external` `nonReentrant` entry
2186  * points to them.
2187  *
2188  * TIP: If you would like to learn more about reentrancy and alternative ways
2189  * to protect against it, check out our blog post
2190  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2191  */
2192 abstract contract ReentrancyGuard {
2193     // Booleans are more expensive than uint256 or any type that takes up a full
2194     // word because each write operation emits an extra SLOAD to first read the
2195     // slot's contents, replace the bits taken up by the boolean, and then write
2196     // back. This is the compiler's defense against contract upgrades and
2197     // pointer aliasing, and it cannot be disabled.
2198 
2199     // The values being non-zero value makes deployment a bit more expensive,
2200     // but in exchange the refund on every call to nonReentrant will be lower in
2201     // amount. Since refunds are capped to a percentage of the total
2202     // transaction's gas, it is best to keep them low in cases like this one, to
2203     // increase the likelihood of the full refund coming into effect.
2204     uint256 private constant _NOT_ENTERED = 1;
2205     uint256 private constant _ENTERED = 2;
2206 
2207     uint256 private _status;
2208 
2209     constructor() {
2210         _status = _NOT_ENTERED;
2211     }
2212 
2213     /**
2214      * @dev Prevents a contract from calling itself, directly or indirectly.
2215      * Calling a `nonReentrant` function from another `nonReentrant`
2216      * function is not supported. It is possible to prevent this from happening
2217      * by making the `nonReentrant` function external, and making it call a
2218      * `private` function that does the actual work.
2219      */
2220     modifier nonReentrant() {
2221         _nonReentrantBefore();
2222         _;
2223         _nonReentrantAfter();
2224     }
2225 
2226     function _nonReentrantBefore() private {
2227         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2228         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2229 
2230         // Any calls to nonReentrant after this point will fail
2231         _status = _ENTERED;
2232     }
2233 
2234     function _nonReentrantAfter() private {
2235         // By storing the original value once again, a refund is triggered (see
2236         // https://eips.ethereum.org/EIPS/eip-2200)
2237         _status = _NOT_ENTERED;
2238     }
2239 }
2240 
2241 // File: @openzeppelin/contracts/utils/Context.sol
2242 
2243 
2244 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2245 
2246 pragma solidity ^0.8.0;
2247 
2248 /**
2249  * @dev Provides information about the current execution context, including the
2250  * sender of the transaction and its data. While these are generally available
2251  * via msg.sender and msg.data, they should not be accessed in such a direct
2252  * manner, since when dealing with meta-transactions the account sending and
2253  * paying for execution may not be the actual sender (as far as an application
2254  * is concerned).
2255  *
2256  * This contract is only required for intermediate, library-like contracts.
2257  */
2258 abstract contract Context {
2259     function _msgSender() internal view virtual returns (address) {
2260         return msg.sender;
2261     }
2262 
2263     function _msgData() internal view virtual returns (bytes calldata) {
2264         return msg.data;
2265     }
2266 }
2267 
2268 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
2269 
2270 
2271 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
2272 
2273 pragma solidity ^0.8.0;
2274 
2275 
2276 
2277 
2278 /**
2279  * @dev Implementation of the {IERC20} interface.
2280  *
2281  * This implementation is agnostic to the way tokens are created. This means
2282  * that a supply mechanism has to be added in a derived contract using {_mint}.
2283  * For a generic mechanism see {ERC20PresetMinterPauser}.
2284  *
2285  * TIP: For a detailed writeup see our guide
2286  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
2287  * to implement supply mechanisms].
2288  *
2289  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2290  * instead returning `false` on failure. This behavior is nonetheless
2291  * conventional and does not conflict with the expectations of ERC20
2292  * applications.
2293  *
2294  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2295  * This allows applications to reconstruct the allowance for all accounts just
2296  * by listening to said events. Other implementations of the EIP may not emit
2297  * these events, as it isn't required by the specification.
2298  *
2299  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2300  * functions have been added to mitigate the well-known issues around setting
2301  * allowances. See {IERC20-approve}.
2302  */
2303 contract ERC20 is Context, IERC20, IERC20Metadata {
2304     mapping(address => uint256) private _balances;
2305 
2306     mapping(address => mapping(address => uint256)) private _allowances;
2307 
2308     uint256 private _totalSupply;
2309 
2310     string private _name;
2311     string private _symbol;
2312 
2313     /**
2314      * @dev Sets the values for {name} and {symbol}.
2315      *
2316      * The default value of {decimals} is 18. To select a different value for
2317      * {decimals} you should overload it.
2318      *
2319      * All two of these values are immutable: they can only be set once during
2320      * construction.
2321      */
2322     constructor(string memory name_, string memory symbol_) {
2323         _name = name_;
2324         _symbol = symbol_;
2325     }
2326 
2327     /**
2328      * @dev Returns the name of the token.
2329      */
2330     function name() public view virtual override returns (string memory) {
2331         return _name;
2332     }
2333 
2334     /**
2335      * @dev Returns the symbol of the token, usually a shorter version of the
2336      * name.
2337      */
2338     function symbol() public view virtual override returns (string memory) {
2339         return _symbol;
2340     }
2341 
2342     /**
2343      * @dev Returns the number of decimals used to get its user representation.
2344      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2345      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2346      *
2347      * Tokens usually opt for a value of 18, imitating the relationship between
2348      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2349      * overridden;
2350      *
2351      * NOTE: This information is only used for _display_ purposes: it in
2352      * no way affects any of the arithmetic of the contract, including
2353      * {IERC20-balanceOf} and {IERC20-transfer}.
2354      */
2355     function decimals() public view virtual override returns (uint8) {
2356         return 18;
2357     }
2358 
2359     /**
2360      * @dev See {IERC20-totalSupply}.
2361      */
2362     function totalSupply() public view virtual override returns (uint256) {
2363         return _totalSupply;
2364     }
2365 
2366     /**
2367      * @dev See {IERC20-balanceOf}.
2368      */
2369     function balanceOf(address account) public view virtual override returns (uint256) {
2370         return _balances[account];
2371     }
2372 
2373     /**
2374      * @dev See {IERC20-transfer}.
2375      *
2376      * Requirements:
2377      *
2378      * - `to` cannot be the zero address.
2379      * - the caller must have a balance of at least `amount`.
2380      */
2381     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2382         address owner = _msgSender();
2383         _transfer(owner, to, amount);
2384         return true;
2385     }
2386 
2387     /**
2388      * @dev See {IERC20-allowance}.
2389      */
2390     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2391         return _allowances[owner][spender];
2392     }
2393 
2394     /**
2395      * @dev See {IERC20-approve}.
2396      *
2397      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2398      * `transferFrom`. This is semantically equivalent to an infinite approval.
2399      *
2400      * Requirements:
2401      *
2402      * - `spender` cannot be the zero address.
2403      */
2404     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2405         address owner = _msgSender();
2406         _approve(owner, spender, amount);
2407         return true;
2408     }
2409 
2410     /**
2411      * @dev See {IERC20-transferFrom}.
2412      *
2413      * Emits an {Approval} event indicating the updated allowance. This is not
2414      * required by the EIP. See the note at the beginning of {ERC20}.
2415      *
2416      * NOTE: Does not update the allowance if the current allowance
2417      * is the maximum `uint256`.
2418      *
2419      * Requirements:
2420      *
2421      * - `from` and `to` cannot be the zero address.
2422      * - `from` must have a balance of at least `amount`.
2423      * - the caller must have allowance for ``from``'s tokens of at least
2424      * `amount`.
2425      */
2426     function transferFrom(
2427         address from,
2428         address to,
2429         uint256 amount
2430     ) public virtual override returns (bool) {
2431         address spender = _msgSender();
2432         _spendAllowance(from, spender, amount);
2433         _transfer(from, to, amount);
2434         return true;
2435     }
2436 
2437     /**
2438      * @dev Atomically increases the allowance granted to `spender` by the caller.
2439      *
2440      * This is an alternative to {approve} that can be used as a mitigation for
2441      * problems described in {IERC20-approve}.
2442      *
2443      * Emits an {Approval} event indicating the updated allowance.
2444      *
2445      * Requirements:
2446      *
2447      * - `spender` cannot be the zero address.
2448      */
2449     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2450         address owner = _msgSender();
2451         _approve(owner, spender, allowance(owner, spender) + addedValue);
2452         return true;
2453     }
2454 
2455     /**
2456      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2457      *
2458      * This is an alternative to {approve} that can be used as a mitigation for
2459      * problems described in {IERC20-approve}.
2460      *
2461      * Emits an {Approval} event indicating the updated allowance.
2462      *
2463      * Requirements:
2464      *
2465      * - `spender` cannot be the zero address.
2466      * - `spender` must have allowance for the caller of at least
2467      * `subtractedValue`.
2468      */
2469     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2470         address owner = _msgSender();
2471         uint256 currentAllowance = allowance(owner, spender);
2472         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2473         unchecked {
2474             _approve(owner, spender, currentAllowance - subtractedValue);
2475         }
2476 
2477         return true;
2478     }
2479 
2480     /**
2481      * @dev Moves `amount` of tokens from `from` to `to`.
2482      *
2483      * This internal function is equivalent to {transfer}, and can be used to
2484      * e.g. implement automatic token fees, slashing mechanisms, etc.
2485      *
2486      * Emits a {Transfer} event.
2487      *
2488      * Requirements:
2489      *
2490      * - `from` cannot be the zero address.
2491      * - `to` cannot be the zero address.
2492      * - `from` must have a balance of at least `amount`.
2493      */
2494     function _transfer(
2495         address from,
2496         address to,
2497         uint256 amount
2498     ) internal virtual {
2499         require(from != address(0), "ERC20: transfer from the zero address");
2500         require(to != address(0), "ERC20: transfer to the zero address");
2501 
2502         _beforeTokenTransfer(from, to, amount);
2503 
2504         uint256 fromBalance = _balances[from];
2505         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2506         unchecked {
2507             _balances[from] = fromBalance - amount;
2508             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
2509             // decrementing then incrementing.
2510             _balances[to] += amount;
2511         }
2512 
2513         emit Transfer(from, to, amount);
2514 
2515         _afterTokenTransfer(from, to, amount);
2516     }
2517 
2518     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2519      * the total supply.
2520      *
2521      * Emits a {Transfer} event with `from` set to the zero address.
2522      *
2523      * Requirements:
2524      *
2525      * - `account` cannot be the zero address.
2526      */
2527     function _mint(address account, uint256 amount) internal virtual {
2528         require(account != address(0), "ERC20: mint to the zero address");
2529 
2530         _beforeTokenTransfer(address(0), account, amount);
2531 
2532         _totalSupply += amount;
2533         unchecked {
2534             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
2535             _balances[account] += amount;
2536         }
2537         emit Transfer(address(0), account, amount);
2538 
2539         _afterTokenTransfer(address(0), account, amount);
2540     }
2541 
2542     /**
2543      * @dev Destroys `amount` tokens from `account`, reducing the
2544      * total supply.
2545      *
2546      * Emits a {Transfer} event with `to` set to the zero address.
2547      *
2548      * Requirements:
2549      *
2550      * - `account` cannot be the zero address.
2551      * - `account` must have at least `amount` tokens.
2552      */
2553     function _burn(address account, uint256 amount) internal virtual {
2554         require(account != address(0), "ERC20: burn from the zero address");
2555 
2556         _beforeTokenTransfer(account, address(0), amount);
2557 
2558         uint256 accountBalance = _balances[account];
2559         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2560         unchecked {
2561             _balances[account] = accountBalance - amount;
2562             // Overflow not possible: amount <= accountBalance <= totalSupply.
2563             _totalSupply -= amount;
2564         }
2565 
2566         emit Transfer(account, address(0), amount);
2567 
2568         _afterTokenTransfer(account, address(0), amount);
2569     }
2570 
2571     /**
2572      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2573      *
2574      * This internal function is equivalent to `approve`, and can be used to
2575      * e.g. set automatic allowances for certain subsystems, etc.
2576      *
2577      * Emits an {Approval} event.
2578      *
2579      * Requirements:
2580      *
2581      * - `owner` cannot be the zero address.
2582      * - `spender` cannot be the zero address.
2583      */
2584     function _approve(
2585         address owner,
2586         address spender,
2587         uint256 amount
2588     ) internal virtual {
2589         require(owner != address(0), "ERC20: approve from the zero address");
2590         require(spender != address(0), "ERC20: approve to the zero address");
2591 
2592         _allowances[owner][spender] = amount;
2593         emit Approval(owner, spender, amount);
2594     }
2595 
2596     /**
2597      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2598      *
2599      * Does not update the allowance amount in case of infinite allowance.
2600      * Revert if not enough allowance is available.
2601      *
2602      * Might emit an {Approval} event.
2603      */
2604     function _spendAllowance(
2605         address owner,
2606         address spender,
2607         uint256 amount
2608     ) internal virtual {
2609         uint256 currentAllowance = allowance(owner, spender);
2610         if (currentAllowance != type(uint256).max) {
2611             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2612             unchecked {
2613                 _approve(owner, spender, currentAllowance - amount);
2614             }
2615         }
2616     }
2617 
2618     /**
2619      * @dev Hook that is called before any transfer of tokens. This includes
2620      * minting and burning.
2621      *
2622      * Calling conditions:
2623      *
2624      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2625      * will be transferred to `to`.
2626      * - when `from` is zero, `amount` tokens will be minted for `to`.
2627      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2628      * - `from` and `to` are never both zero.
2629      *
2630      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2631      */
2632     function _beforeTokenTransfer(
2633         address from,
2634         address to,
2635         uint256 amount
2636     ) internal virtual {}
2637 
2638     /**
2639      * @dev Hook that is called after any transfer of tokens. This includes
2640      * minting and burning.
2641      *
2642      * Calling conditions:
2643      *
2644      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2645      * has been transferred to `to`.
2646      * - when `from` is zero, `amount` tokens have been minted for `to`.
2647      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2648      * - `from` and `to` are never both zero.
2649      *
2650      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2651      */
2652     function _afterTokenTransfer(
2653         address from,
2654         address to,
2655         uint256 amount
2656     ) internal virtual {}
2657 }
2658 
2659 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
2660 
2661 
2662 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
2663 
2664 pragma solidity ^0.8.0;
2665 
2666 
2667 
2668 
2669 
2670 
2671 /**
2672  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2673  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2674  *
2675  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2676  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
2677  * need to send a transaction, and thus is not required to hold Ether at all.
2678  *
2679  * _Available since v3.4._
2680  */
2681 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
2682     using Counters for Counters.Counter;
2683 
2684     mapping(address => Counters.Counter) private _nonces;
2685 
2686     // solhint-disable-next-line var-name-mixedcase
2687     bytes32 private constant _PERMIT_TYPEHASH =
2688         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
2689     /**
2690      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
2691      * However, to ensure consistency with the upgradeable transpiler, we will continue
2692      * to reserve a slot.
2693      * @custom:oz-renamed-from _PERMIT_TYPEHASH
2694      */
2695     // solhint-disable-next-line var-name-mixedcase
2696     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
2697 
2698     /**
2699      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
2700      *
2701      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
2702      */
2703     constructor(string memory name) EIP712(name, "1") {}
2704 
2705     /**
2706      * @dev See {IERC20Permit-permit}.
2707      */
2708     function permit(
2709         address owner,
2710         address spender,
2711         uint256 value,
2712         uint256 deadline,
2713         uint8 v,
2714         bytes32 r,
2715         bytes32 s
2716     ) public virtual override {
2717         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
2718 
2719         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
2720 
2721         bytes32 hash = _hashTypedDataV4(structHash);
2722 
2723         address signer = ECDSA.recover(hash, v, r, s);
2724         require(signer == owner, "ERC20Permit: invalid signature");
2725 
2726         _approve(owner, spender, value);
2727     }
2728 
2729     /**
2730      * @dev See {IERC20Permit-nonces}.
2731      */
2732     function nonces(address owner) public view virtual override returns (uint256) {
2733         return _nonces[owner].current();
2734     }
2735 
2736     /**
2737      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
2738      */
2739     // solhint-disable-next-line func-name-mixedcase
2740     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
2741         return _domainSeparatorV4();
2742     }
2743 
2744     /**
2745      * @dev "Consume a nonce": return the current value and increment.
2746      *
2747      * _Available since v4.1._
2748      */
2749     function _useNonce(address owner) internal virtual returns (uint256 current) {
2750         Counters.Counter storage nonce = _nonces[owner];
2751         current = nonce.current();
2752         nonce.increment();
2753     }
2754 }
2755 
2756 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol
2757 
2758 
2759 // OpenZeppelin Contracts (last updated v4.8.1) (token/ERC20/extensions/ERC20Votes.sol)
2760 
2761 pragma solidity ^0.8.0;
2762 
2763 
2764 
2765 
2766 
2767 
2768 /**
2769  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
2770  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
2771  *
2772  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
2773  *
2774  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
2775  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
2776  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
2777  *
2778  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
2779  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
2780  *
2781  * _Available since v4.2._
2782  */
2783 abstract contract ERC20Votes is IVotes, ERC20Permit {
2784     struct Checkpoint {
2785         uint32 fromBlock;
2786         uint224 votes;
2787     }
2788 
2789     bytes32 private constant _DELEGATION_TYPEHASH =
2790         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
2791 
2792     mapping(address => address) private _delegates;
2793     mapping(address => Checkpoint[]) private _checkpoints;
2794     Checkpoint[] private _totalSupplyCheckpoints;
2795 
2796     /**
2797      * @dev Get the `pos`-th checkpoint for `account`.
2798      */
2799     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
2800         return _checkpoints[account][pos];
2801     }
2802 
2803     /**
2804      * @dev Get number of checkpoints for `account`.
2805      */
2806     function numCheckpoints(address account) public view virtual returns (uint32) {
2807         return SafeCast.toUint32(_checkpoints[account].length);
2808     }
2809 
2810     /**
2811      * @dev Get the address `account` is currently delegating to.
2812      */
2813     function delegates(address account) public view virtual override returns (address) {
2814         return _delegates[account];
2815     }
2816 
2817     /**
2818      * @dev Gets the current votes balance for `account`
2819      */
2820     function getVotes(address account) public view virtual override returns (uint256) {
2821         uint256 pos = _checkpoints[account].length;
2822         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
2823     }
2824 
2825     /**
2826      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
2827      *
2828      * Requirements:
2829      *
2830      * - `blockNumber` must have been already mined
2831      */
2832     function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
2833         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
2834         return _checkpointsLookup(_checkpoints[account], blockNumber);
2835     }
2836 
2837     /**
2838      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
2839      * It is but NOT the sum of all the delegated votes!
2840      *
2841      * Requirements:
2842      *
2843      * - `blockNumber` must have been already mined
2844      */
2845     function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
2846         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
2847         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
2848     }
2849 
2850     /**
2851      * @dev Lookup a value in a list of (sorted) checkpoints.
2852      */
2853     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
2854         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
2855         //
2856         // Initially we check if the block is recent to narrow the search range.
2857         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
2858         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
2859         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
2860         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
2861         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
2862         // out of bounds (in which case we're looking too far in the past and the result is 0).
2863         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
2864         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
2865         // the same.
2866         uint256 length = ckpts.length;
2867 
2868         uint256 low = 0;
2869         uint256 high = length;
2870 
2871         if (length > 5) {
2872             uint256 mid = length - Math.sqrt(length);
2873             if (_unsafeAccess(ckpts, mid).fromBlock > blockNumber) {
2874                 high = mid;
2875             } else {
2876                 low = mid + 1;
2877             }
2878         }
2879 
2880         while (low < high) {
2881             uint256 mid = Math.average(low, high);
2882             if (_unsafeAccess(ckpts, mid).fromBlock > blockNumber) {
2883                 high = mid;
2884             } else {
2885                 low = mid + 1;
2886             }
2887         }
2888 
2889         return high == 0 ? 0 : _unsafeAccess(ckpts, high - 1).votes;
2890     }
2891 
2892     /**
2893      * @dev Delegate votes from the sender to `delegatee`.
2894      */
2895     function delegate(address delegatee) public virtual override {
2896         _delegate(_msgSender(), delegatee);
2897     }
2898 
2899     /**
2900      * @dev Delegates votes from signer to `delegatee`
2901      */
2902     function delegateBySig(
2903         address delegatee,
2904         uint256 nonce,
2905         uint256 expiry,
2906         uint8 v,
2907         bytes32 r,
2908         bytes32 s
2909     ) public virtual override {
2910         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
2911         address signer = ECDSA.recover(
2912             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
2913             v,
2914             r,
2915             s
2916         );
2917         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
2918         _delegate(signer, delegatee);
2919     }
2920 
2921     /**
2922      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
2923      */
2924     function _maxSupply() internal view virtual returns (uint224) {
2925         return type(uint224).max;
2926     }
2927 
2928     /**
2929      * @dev Snapshots the totalSupply after it has been increased.
2930      */
2931     function _mint(address account, uint256 amount) internal virtual override {
2932         super._mint(account, amount);
2933         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
2934 
2935         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
2936     }
2937 
2938     /**
2939      * @dev Snapshots the totalSupply after it has been decreased.
2940      */
2941     function _burn(address account, uint256 amount) internal virtual override {
2942         super._burn(account, amount);
2943 
2944         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
2945     }
2946 
2947     /**
2948      * @dev Move voting power when tokens are transferred.
2949      *
2950      * Emits a {IVotes-DelegateVotesChanged} event.
2951      */
2952     function _afterTokenTransfer(
2953         address from,
2954         address to,
2955         uint256 amount
2956     ) internal virtual override {
2957         super._afterTokenTransfer(from, to, amount);
2958 
2959         _moveVotingPower(delegates(from), delegates(to), amount);
2960     }
2961 
2962     /**
2963      * @dev Change delegation for `delegator` to `delegatee`.
2964      *
2965      * Emits events {IVotes-DelegateChanged} and {IVotes-DelegateVotesChanged}.
2966      */
2967     function _delegate(address delegator, address delegatee) internal virtual {
2968         address currentDelegate = delegates(delegator);
2969         uint256 delegatorBalance = balanceOf(delegator);
2970         _delegates[delegator] = delegatee;
2971 
2972         emit DelegateChanged(delegator, currentDelegate, delegatee);
2973 
2974         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
2975     }
2976 
2977     function _moveVotingPower(
2978         address src,
2979         address dst,
2980         uint256 amount
2981     ) private {
2982         if (src != dst && amount > 0) {
2983             if (src != address(0)) {
2984                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
2985                 emit DelegateVotesChanged(src, oldWeight, newWeight);
2986             }
2987 
2988             if (dst != address(0)) {
2989                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
2990                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
2991             }
2992         }
2993     }
2994 
2995     function _writeCheckpoint(
2996         Checkpoint[] storage ckpts,
2997         function(uint256, uint256) view returns (uint256) op,
2998         uint256 delta
2999     ) private returns (uint256 oldWeight, uint256 newWeight) {
3000         uint256 pos = ckpts.length;
3001 
3002         Checkpoint memory oldCkpt = pos == 0 ? Checkpoint(0, 0) : _unsafeAccess(ckpts, pos - 1);
3003 
3004         oldWeight = oldCkpt.votes;
3005         newWeight = op(oldWeight, delta);
3006 
3007         if (pos > 0 && oldCkpt.fromBlock == block.number) {
3008             _unsafeAccess(ckpts, pos - 1).votes = SafeCast.toUint224(newWeight);
3009         } else {
3010             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
3011         }
3012     }
3013 
3014     function _add(uint256 a, uint256 b) private pure returns (uint256) {
3015         return a + b;
3016     }
3017 
3018     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
3019         return a - b;
3020     }
3021 
3022     /**
3023      * @dev Access an element of the array without performing bounds check. The position is assumed to be within bounds.
3024      */
3025     function _unsafeAccess(Checkpoint[] storage ckpts, uint256 pos) private pure returns (Checkpoint storage result) {
3026         assembly {
3027             mstore(0, ckpts.slot)
3028             result.slot := add(keccak256(0, 0x20), pos)
3029         }
3030     }
3031 }
3032 
3033 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
3034 
3035 
3036 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
3037 
3038 pragma solidity ^0.8.0;
3039 
3040 
3041 
3042 /**
3043  * @dev Extension of {ERC20} that allows token holders to destroy both their own
3044  * tokens and those that they have an allowance for, in a way that can be
3045  * recognized off-chain (via event analysis).
3046  */
3047 abstract contract ERC20Burnable is Context, ERC20 {
3048     /**
3049      * @dev Destroys `amount` tokens from the caller.
3050      *
3051      * See {ERC20-_burn}.
3052      */
3053     function burn(uint256 amount) public virtual {
3054         _burn(_msgSender(), amount);
3055     }
3056 
3057     /**
3058      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
3059      * allowance.
3060      *
3061      * See {ERC20-_burn} and {ERC20-allowance}.
3062      *
3063      * Requirements:
3064      *
3065      * - the caller must have allowance for ``accounts``'s tokens of at least
3066      * `amount`.
3067      */
3068     function burnFrom(address account, uint256 amount) public virtual {
3069         _spendAllowance(account, _msgSender(), amount);
3070         _burn(account, amount);
3071     }
3072 }
3073 
3074 // File: @openzeppelin/contracts/security/Pausable.sol
3075 
3076 
3077 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
3078 
3079 pragma solidity ^0.8.0;
3080 
3081 
3082 /**
3083  * @dev Contract module which allows children to implement an emergency stop
3084  * mechanism that can be triggered by an authorized account.
3085  *
3086  * This module is used through inheritance. It will make available the
3087  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
3088  * the functions of your contract. Note that they will not be pausable by
3089  * simply including this module, only once the modifiers are put in place.
3090  */
3091 abstract contract Pausable is Context {
3092     /**
3093      * @dev Emitted when the pause is triggered by `account`.
3094      */
3095     event Paused(address account);
3096 
3097     /**
3098      * @dev Emitted when the pause is lifted by `account`.
3099      */
3100     event Unpaused(address account);
3101 
3102     bool private _paused;
3103 
3104     /**
3105      * @dev Initializes the contract in unpaused state.
3106      */
3107     constructor() {
3108         _paused = false;
3109     }
3110 
3111     /**
3112      * @dev Modifier to make a function callable only when the contract is not paused.
3113      *
3114      * Requirements:
3115      *
3116      * - The contract must not be paused.
3117      */
3118     modifier whenNotPaused() {
3119         _requireNotPaused();
3120         _;
3121     }
3122 
3123     /**
3124      * @dev Modifier to make a function callable only when the contract is paused.
3125      *
3126      * Requirements:
3127      *
3128      * - The contract must be paused.
3129      */
3130     modifier whenPaused() {
3131         _requirePaused();
3132         _;
3133     }
3134 
3135     /**
3136      * @dev Returns true if the contract is paused, and false otherwise.
3137      */
3138     function paused() public view virtual returns (bool) {
3139         return _paused;
3140     }
3141 
3142     /**
3143      * @dev Throws if the contract is paused.
3144      */
3145     function _requireNotPaused() internal view virtual {
3146         require(!paused(), "Pausable: paused");
3147     }
3148 
3149     /**
3150      * @dev Throws if the contract is not paused.
3151      */
3152     function _requirePaused() internal view virtual {
3153         require(paused(), "Pausable: not paused");
3154     }
3155 
3156     /**
3157      * @dev Triggers stopped state.
3158      *
3159      * Requirements:
3160      *
3161      * - The contract must not be paused.
3162      */
3163     function _pause() internal virtual whenNotPaused {
3164         _paused = true;
3165         emit Paused(_msgSender());
3166     }
3167 
3168     /**
3169      * @dev Returns to normal state.
3170      *
3171      * Requirements:
3172      *
3173      * - The contract must be paused.
3174      */
3175     function _unpause() internal virtual whenPaused {
3176         _paused = false;
3177         emit Unpaused(_msgSender());
3178     }
3179 }
3180 
3181 // File: @openzeppelin/contracts/access/Ownable.sol
3182 
3183 
3184 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
3185 
3186 pragma solidity ^0.8.0;
3187 
3188 
3189 /**
3190  * @dev Contract module which provides a basic access control mechanism, where
3191  * there is an account (an owner) that can be granted exclusive access to
3192  * specific functions.
3193  *
3194  * By default, the owner account will be the one that deploys the contract. This
3195  * can later be changed with {transferOwnership}.
3196  *
3197  * This module is used through inheritance. It will make available the modifier
3198  * `onlyOwner`, which can be applied to your functions to restrict their use to
3199  * the owner.
3200  */
3201 abstract contract Ownable is Context {
3202     address private _owner;
3203 
3204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3205 
3206     /**
3207      * @dev Initializes the contract setting the deployer as the initial owner.
3208      */
3209     constructor() {
3210         _transferOwnership(_msgSender());
3211     }
3212 
3213     /**
3214      * @dev Throws if called by any account other than the owner.
3215      */
3216     modifier onlyOwner() {
3217         _checkOwner();
3218         _;
3219     }
3220 
3221     /**
3222      * @dev Returns the address of the current owner.
3223      */
3224     function owner() public view virtual returns (address) {
3225         return _owner;
3226     }
3227 
3228     /**
3229      * @dev Throws if the sender is not the owner.
3230      */
3231     function _checkOwner() internal view virtual {
3232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3233     }
3234 
3235     /**
3236      * @dev Leaves the contract without owner. It will not be possible to call
3237      * `onlyOwner` functions anymore. Can only be called by the current owner.
3238      *
3239      * NOTE: Renouncing ownership will leave the contract without an owner,
3240      * thereby removing any functionality that is only available to the owner.
3241      */
3242     function renounceOwnership() public virtual onlyOwner {
3243         _transferOwnership(address(0));
3244     }
3245 
3246     /**
3247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3248      * Can only be called by the current owner.
3249      */
3250     function transferOwnership(address newOwner) public virtual onlyOwner {
3251         require(newOwner != address(0), "Ownable: new owner is the zero address");
3252         _transferOwnership(newOwner);
3253     }
3254 
3255     /**
3256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3257      * Internal function without access restriction.
3258      */
3259     function _transferOwnership(address newOwner) internal virtual {
3260         address oldOwner = _owner;
3261         _owner = newOwner;
3262         emit OwnershipTransferred(oldOwner, newOwner);
3263     }
3264 }
3265 
3266 // File: @openzeppelin/contracts/access/Ownable2Step.sol
3267 
3268 
3269 // OpenZeppelin Contracts (last updated v4.8.0) (access/Ownable2Step.sol)
3270 
3271 pragma solidity ^0.8.0;
3272 
3273 
3274 /**
3275  * @dev Contract module which provides access control mechanism, where
3276  * there is an account (an owner) that can be granted exclusive access to
3277  * specific functions.
3278  *
3279  * By default, the owner account will be the one that deploys the contract. This
3280  * can later be changed with {transferOwnership} and {acceptOwnership}.
3281  *
3282  * This module is used through inheritance. It will make available all functions
3283  * from parent (Ownable).
3284  */
3285 abstract contract Ownable2Step is Ownable {
3286     address private _pendingOwner;
3287 
3288     event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
3289 
3290     /**
3291      * @dev Returns the address of the pending owner.
3292      */
3293     function pendingOwner() public view virtual returns (address) {
3294         return _pendingOwner;
3295     }
3296 
3297     /**
3298      * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
3299      * Can only be called by the current owner.
3300      */
3301     function transferOwnership(address newOwner) public virtual override onlyOwner {
3302         _pendingOwner = newOwner;
3303         emit OwnershipTransferStarted(owner(), newOwner);
3304     }
3305 
3306     /**
3307      * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
3308      * Internal function without access restriction.
3309      */
3310     function _transferOwnership(address newOwner) internal virtual override {
3311         delete _pendingOwner;
3312         super._transferOwnership(newOwner);
3313     }
3314 
3315     /**
3316      * @dev The new owner accepts the ownership transfer.
3317      */
3318     function acceptOwnership() external {
3319         address sender = _msgSender();
3320         require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
3321         _transferOwnership(sender);
3322     }
3323 }
3324 
3325 // File: vUNIFI.sol
3326 
3327 
3328 pragma solidity ^0.8.9;
3329 
3330 
3331 
3332 
3333 contract UnifiProtocolVotingToken is ERC20Burnable, ERC20Votes, Ownable2Step {
3334     /// @notice this role has rights for transfer/mint/burning tokens, such us a staking contract
3335     address private _controller = address(0);
3336     mapping(address => bool) _blacklist;
3337 
3338     event ControllerUpdated(address newController);
3339     event BlacklistUpdated(address indexed user, bool value);
3340 
3341     constructor()
3342         ERC20("Unifi Protocol Voting Token", "vUNIFI")
3343         ERC20Permit("Unifi Protocol Voting Token")
3344     {}
3345 
3346     modifier onlyOwnerOrController() {
3347         require(
3348             msg.sender == owner() || msg.sender == _controller,
3349             "UnifiProtocolVotingToken: onlyOwnerOrController"
3350         );
3351         _;
3352     }
3353 
3354     /// @notice Function to mint vUNIFI tokens. Only callable by the owner & controller.
3355     /// @param to The address to mint the tokens to.
3356     /// @param amount The amount of tokens to mint.
3357     function mint(address to, uint256 amount) public onlyOwnerOrController {
3358         require(!isBlackListed(to), "UnifiProtocolVotingToken: Blacklisted");
3359         _mint(to, amount);
3360     }
3361 
3362     /// @notice Function to burn vUNIFI tokens.
3363     /// @param from The address to burn the tokens from.
3364     /// @param amount The amount of tokens to burn.
3365     function burnFrom(address from, uint256 amount) public override {
3366         _burn(from, amount);
3367     }
3368 
3369     /// @notice Function to burn vUNIFI tokens.
3370     /// @param amount The amount of tokens to burn.
3371     function burn(uint256 amount) public override {
3372         _burn(msg.sender, amount);
3373     }
3374 
3375     /// @notice Set a new controller address.
3376     /// @param newController The new controller address.
3377     function setController(address newController) public onlyOwner {
3378         _controller = newController;
3379         emit ControllerUpdated(newController);
3380     }
3381 
3382     /// @notice Get the current controller address.
3383     function controller() public view returns (address) {
3384         return _controller;
3385     }
3386 
3387     /// @notice Function to blacklist an address. Only callable by the owner.
3388     /// @param user The address to blacklist.
3389     /// @param value The blacklist value. True to blacklist an address, false to remove an address from the blacklist.
3390     function blacklistUpdate(
3391         address user,
3392         bool value
3393     ) public virtual onlyOwner {
3394         _blacklist[user] = value;
3395         emit BlacklistUpdated(user, value);
3396     }
3397 
3398     /// @notice Function to check if an address is blacklisted.
3399     /// @param user The address to check.
3400 
3401     function isBlackListed(address user) public view returns (bool) {
3402         return _blacklist[user];
3403     }
3404 
3405     // The following functions are overrides required by Solidity.
3406     function _beforeTokenTransfer(
3407         address from,
3408         address to,
3409         uint256 amount
3410     ) internal override {
3411         super._beforeTokenTransfer(from, to, amount);
3412     }
3413 
3414     function _afterTokenTransfer(
3415         address from,
3416         address to,
3417         uint256 amount
3418     ) internal override(ERC20, ERC20Votes) {
3419         super._afterTokenTransfer(from, to, amount);
3420     }
3421 
3422     function _mint(
3423         address to,
3424         uint256 amount
3425     ) internal override(ERC20, ERC20Votes) {
3426         super._mint(to, amount);
3427     }
3428 
3429     function _burn(
3430         address account,
3431         uint256 amount
3432     ) internal override(ERC20, ERC20Votes) onlyOwnerOrController {
3433         super._burn(account, amount);
3434     }
3435 
3436     function transferFrom(
3437         address sender,
3438         address recipient,
3439         uint256 amount
3440     ) public override onlyOwnerOrController returns (bool) {
3441         return super.transferFrom(sender, recipient, amount);
3442     }
3443 
3444     function transfer(
3445         address recipient,
3446         uint256 amount
3447     ) public override onlyOwnerOrController returns (bool) {
3448         return super.transfer(recipient, amount);
3449     }
3450 }
3451 
3452 // File: vUNIFIStaking.sol
3453 
3454 
3455 pragma solidity ^0.8.9;
3456 
3457 
3458 
3459 
3460 
3461 
3462 contract UnifiStaking is Ownable2Step, Pausable, ReentrancyGuard {
3463     IERC20 public immutable token;
3464     UnifiProtocolVotingToken public immutable wrappedToken;
3465 
3466     uint256 public duration;
3467     uint256 public finishAt;
3468     uint256 public updatedAt;
3469     uint256 public rewardRate = 3858024691358024;
3470     uint256 public rewardPerTokenStored;
3471     uint256 public totalStaked;
3472     mapping(address => uint256) public userRewardPerTokenPaid;
3473     mapping(address => uint256) public rewards;
3474     mapping(address => uint256) public amountUserStaked;
3475 
3476     event Staked(address indexed user, uint256 amount);
3477     event Withdrawn(address indexed user, uint256 amount);
3478     event RewardPaid(address indexed user, uint256 reward);
3479 
3480     constructor(address baseToken, address wrapped) {
3481         token = IERC20(baseToken);
3482         wrappedToken = UnifiProtocolVotingToken(wrapped);
3483     }
3484 
3485     modifier updateReward(address _account) {
3486         rewardPerTokenStored = rewardPerToken();
3487         updatedAt = lastTimeRewardApplicable();
3488         if (_account != address(0)) {
3489             rewards[_account] = earned(_account);
3490             userRewardPerTokenPaid[_account] = rewardPerTokenStored;
3491         }
3492         _;
3493     }
3494 
3495     // WRITE FUNCTIONS
3496 
3497     /// @notice Stakes UNFI tokens. The user must first approve the contract to transfer UNFI tokens on their behalf.
3498     /// @param _amount The amount of UNFI tokens to stake.
3499     function stake(
3500         uint256 _amount
3501     ) external updateReward(msg.sender) nonReentrant whenNotPaused {
3502         require(_amount > 0, "vUNFI: NO_UNFI_TO_STAKE");
3503         token.transferFrom(msg.sender, address(this), _amount);
3504         _mint(msg.sender, _amount);
3505         amountUserStaked[msg.sender] += _amount;
3506         totalStaked += _amount;
3507         emit Staked(msg.sender, _amount);
3508     }
3509 
3510     /// @notice Withdraws UNFI tokens. The user must first approve the contract to transfer UNFI tokens on their behalf.
3511     /// @param _amount The amount of UNFI tokens to withdraw.
3512     function withdraw(
3513         uint256 _amount
3514     ) external nonReentrant updateReward(msg.sender) whenNotPaused {
3515         require(_amount > 0, "vUNFI: CANNOT_UNSTAKE_ZERO");
3516         _burn(msg.sender, _amount);
3517         amountUserStaked[msg.sender] -= _amount;
3518         totalStaked -= _amount;
3519         _getReward();
3520         token.transfer(msg.sender, _amount);
3521         emit Withdrawn(msg.sender, _amount);
3522     }
3523 
3524     /// @notice Claims rewards, protected by the nonReentrant modifier.
3525     function getReward()
3526         public
3527         updateReward(msg.sender)
3528         nonReentrant
3529         whenNotPaused
3530     {
3531         _getReward();
3532     }
3533 
3534     /// @notice Internal function to claim rewards. Is this way because we need to avoid the nonReentrant modifier.
3535     function _getReward() internal {
3536         uint256 reward = rewards[msg.sender];
3537         if (reward > 0) {
3538             rewards[msg.sender] = 0;
3539             token.transfer(msg.sender, reward);
3540         }
3541         emit RewardPaid(msg.sender, reward);
3542     }
3543 
3544     /// @notice returns of amount of UNFI tokens staked by the user.
3545     /// @param _account The address of the user.
3546     function balanceOf(address _account) external view returns (uint256) {
3547         return amountUserStaked[_account];
3548     }
3549 
3550     // @dev To update rewards, first set the duration in seconds to the setRewardsDuration.
3551     // For example, 2592000 equals 30 days.
3552     // Next, send an amount of UNFI to the contract using transfer.
3553     // Lastly, call setRewardAmount with the _rewardRate. The rewardRate is the amount of wei of the token per second.
3554     // For example, 3858024691358024 equals 10,000 UNFI per 30 days.
3555     // This will begin the reward distribution. No rewards will be distributed until the setRewardAmount function is called.
3556 
3557     /// @notice Sets the duration of the rewards.
3558     /// @param _duration The duration of the rewards in seconds.
3559     function setRewardsDuration(uint256 _duration) external onlyOwner {
3560         duration = _duration;
3561     }
3562 
3563     /// @notice Sets the reward amount.
3564     /// @param _rewardRate The reward rate in wei of the token per second.
3565     function setRewardAmount(
3566         uint256 _rewardRate
3567     ) external onlyOwner updateReward(address(0)) {
3568         rewardRate = _rewardRate;
3569         finishAt = block.timestamp + duration;
3570         updatedAt = block.timestamp;
3571     }
3572 
3573     /// @notice Mints wrapped token
3574     /// @param to The address to mint the wrapped token to.
3575     /// @param amount The amount of wrapped token to mint.
3576     function _mint(address to, uint256 amount) internal {
3577         wrappedToken.mint(to, amount);
3578     }
3579 
3580     /// @notice Burns wrapped token
3581     /// @param account The address to burn the wrapped token from.
3582     /// @param amount The amount of wrapped token to burn.
3583     function _burn(address account, uint256 amount) internal {
3584         wrappedToken.burnFrom(account, amount);
3585     }
3586 
3587     // READ FUNCTIONS
3588 
3589     ///@notice Returns the remaining rewards.
3590     function remainingRewards() external view returns (uint256) {
3591         return token.balanceOf(address(this)) - totalStaked;
3592     }
3593 
3594     function lastTimeRewardApplicable() public view returns (uint256) {
3595         return _min(finishAt, block.timestamp);
3596     }
3597 
3598     /// @notice Returns the reward per token. This is the reward per token stored plus the amount of wei of the token per second multiplied by the time since the last update.
3599     function rewardPerToken() public view returns (uint256) {
3600         if (totalStaked == 0) {
3601             return rewardPerTokenStored;
3602         }
3603 
3604         return
3605             rewardPerTokenStored +
3606             (rewardRate * (lastTimeRewardApplicable() - updatedAt) * 1e18) /
3607             totalStaked;
3608     }
3609 
3610     /// @notice Returns the amount of wei of the token that the user has earned.
3611     /// @param _account The address of the user.
3612     function earned(address _account) public view returns (uint256) {
3613         return
3614             ((amountUserStaked[_account] *
3615                 (rewardPerToken() - userRewardPerTokenPaid[_account])) / 1e18) +
3616             rewards[_account];
3617     }
3618 
3619     /// @notice Simply a helper function to calculate the minimum of two numbers.
3620     /// @param x The first number.
3621     /// @param y The second number.
3622     function _min(uint256 x, uint256 y) private pure returns (uint256) {
3623         return x <= y ? x : y;
3624     }
3625 
3626     // Emergency functions
3627     ///@notice Pauses the contract.
3628     function pause() public onlyOwner {
3629         _pause();
3630     }
3631 
3632     ///@notice Unpauses the contract.
3633     function unpause() public onlyOwner {
3634         _unpause();
3635     }
3636 
3637     ///@notice Emergency function to withdraw ETH from the contract. Only callable by the owner.
3638     function withdrawFunds() public onlyOwner {
3639         (bool sent, ) = address(msg.sender).call{value: address(this).balance}(
3640             ""
3641         );
3642         require(sent, "Failed to send Ether");
3643     }
3644 
3645     ///@notice Emergency function to withdraw ERC20 tokens from the contract. Only callable by the owner.
3646     ///@param tokenAddress The address of the ERC20 token.
3647     function withdrawFundsERC20(address tokenAddress) public onlyOwner {
3648         IERC20 tkn = IERC20(tokenAddress);
3649         tkn.transfer(msg.sender, tkn.balanceOf(address(this)));
3650     }
3651 }