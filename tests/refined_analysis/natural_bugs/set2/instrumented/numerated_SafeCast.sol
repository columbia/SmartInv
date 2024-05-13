1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/SafeCast.sol)
3 // This file was procedurally generated from scripts/generate/templates/SafeCast.js.
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
9  * checks.
10  *
11  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
12  * easily result in undesired exploitation or bugs, since developers usually
13  * assume that overflows raise errors. `SafeCast` restores this intuition by
14  * reverting the transaction when such an operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  *
19  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
20  * all math on `uint256` and `int256` and then downcasting.
21  */
22 library SafeCast {
23     /**
24      * @dev Returns the downcasted uint248 from uint256, reverting on
25      * overflow (when the input is greater than largest uint248).
26      *
27      * Counterpart to Solidity's `uint248` operator.
28      *
29      * Requirements:
30      *
31      * - input must fit into 248 bits
32      *
33      * _Available since v4.7._
34      */
35     function toUint248(uint256 value) internal pure returns (uint248) {
36         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
37         return uint248(value);
38     }
39 
40     /**
41      * @dev Returns the downcasted uint240 from uint256, reverting on
42      * overflow (when the input is greater than largest uint240).
43      *
44      * Counterpart to Solidity's `uint240` operator.
45      *
46      * Requirements:
47      *
48      * - input must fit into 240 bits
49      *
50      * _Available since v4.7._
51      */
52     function toUint240(uint256 value) internal pure returns (uint240) {
53         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
54         return uint240(value);
55     }
56 
57     /**
58      * @dev Returns the downcasted uint232 from uint256, reverting on
59      * overflow (when the input is greater than largest uint232).
60      *
61      * Counterpart to Solidity's `uint232` operator.
62      *
63      * Requirements:
64      *
65      * - input must fit into 232 bits
66      *
67      * _Available since v4.7._
68      */
69     function toUint232(uint256 value) internal pure returns (uint232) {
70         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
71         return uint232(value);
72     }
73 
74     /**
75      * @dev Returns the downcasted uint224 from uint256, reverting on
76      * overflow (when the input is greater than largest uint224).
77      *
78      * Counterpart to Solidity's `uint224` operator.
79      *
80      * Requirements:
81      *
82      * - input must fit into 224 bits
83      *
84      * _Available since v4.2._
85      */
86     function toUint224(uint256 value) internal pure returns (uint224) {
87         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
88         return uint224(value);
89     }
90 
91     /**
92      * @dev Returns the downcasted uint216 from uint256, reverting on
93      * overflow (when the input is greater than largest uint216).
94      *
95      * Counterpart to Solidity's `uint216` operator.
96      *
97      * Requirements:
98      *
99      * - input must fit into 216 bits
100      *
101      * _Available since v4.7._
102      */
103     function toUint216(uint256 value) internal pure returns (uint216) {
104         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
105         return uint216(value);
106     }
107 
108     /**
109      * @dev Returns the downcasted uint208 from uint256, reverting on
110      * overflow (when the input is greater than largest uint208).
111      *
112      * Counterpart to Solidity's `uint208` operator.
113      *
114      * Requirements:
115      *
116      * - input must fit into 208 bits
117      *
118      * _Available since v4.7._
119      */
120     function toUint208(uint256 value) internal pure returns (uint208) {
121         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
122         return uint208(value);
123     }
124 
125     /**
126      * @dev Returns the downcasted uint200 from uint256, reverting on
127      * overflow (when the input is greater than largest uint200).
128      *
129      * Counterpart to Solidity's `uint200` operator.
130      *
131      * Requirements:
132      *
133      * - input must fit into 200 bits
134      *
135      * _Available since v4.7._
136      */
137     function toUint200(uint256 value) internal pure returns (uint200) {
138         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
139         return uint200(value);
140     }
141 
142     /**
143      * @dev Returns the downcasted uint192 from uint256, reverting on
144      * overflow (when the input is greater than largest uint192).
145      *
146      * Counterpart to Solidity's `uint192` operator.
147      *
148      * Requirements:
149      *
150      * - input must fit into 192 bits
151      *
152      * _Available since v4.7._
153      */
154     function toUint192(uint256 value) internal pure returns (uint192) {
155         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
156         return uint192(value);
157     }
158 
159     /**
160      * @dev Returns the downcasted uint184 from uint256, reverting on
161      * overflow (when the input is greater than largest uint184).
162      *
163      * Counterpart to Solidity's `uint184` operator.
164      *
165      * Requirements:
166      *
167      * - input must fit into 184 bits
168      *
169      * _Available since v4.7._
170      */
171     function toUint184(uint256 value) internal pure returns (uint184) {
172         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
173         return uint184(value);
174     }
175 
176     /**
177      * @dev Returns the downcasted uint176 from uint256, reverting on
178      * overflow (when the input is greater than largest uint176).
179      *
180      * Counterpart to Solidity's `uint176` operator.
181      *
182      * Requirements:
183      *
184      * - input must fit into 176 bits
185      *
186      * _Available since v4.7._
187      */
188     function toUint176(uint256 value) internal pure returns (uint176) {
189         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
190         return uint176(value);
191     }
192 
193     /**
194      * @dev Returns the downcasted uint168 from uint256, reverting on
195      * overflow (when the input is greater than largest uint168).
196      *
197      * Counterpart to Solidity's `uint168` operator.
198      *
199      * Requirements:
200      *
201      * - input must fit into 168 bits
202      *
203      * _Available since v4.7._
204      */
205     function toUint168(uint256 value) internal pure returns (uint168) {
206         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
207         return uint168(value);
208     }
209 
210     /**
211      * @dev Returns the downcasted uint160 from uint256, reverting on
212      * overflow (when the input is greater than largest uint160).
213      *
214      * Counterpart to Solidity's `uint160` operator.
215      *
216      * Requirements:
217      *
218      * - input must fit into 160 bits
219      *
220      * _Available since v4.7._
221      */
222     function toUint160(uint256 value) internal pure returns (uint160) {
223         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
224         return uint160(value);
225     }
226 
227     /**
228      * @dev Returns the downcasted uint152 from uint256, reverting on
229      * overflow (when the input is greater than largest uint152).
230      *
231      * Counterpart to Solidity's `uint152` operator.
232      *
233      * Requirements:
234      *
235      * - input must fit into 152 bits
236      *
237      * _Available since v4.7._
238      */
239     function toUint152(uint256 value) internal pure returns (uint152) {
240         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
241         return uint152(value);
242     }
243 
244     /**
245      * @dev Returns the downcasted uint144 from uint256, reverting on
246      * overflow (when the input is greater than largest uint144).
247      *
248      * Counterpart to Solidity's `uint144` operator.
249      *
250      * Requirements:
251      *
252      * - input must fit into 144 bits
253      *
254      * _Available since v4.7._
255      */
256     function toUint144(uint256 value) internal pure returns (uint144) {
257         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
258         return uint144(value);
259     }
260 
261     /**
262      * @dev Returns the downcasted uint136 from uint256, reverting on
263      * overflow (when the input is greater than largest uint136).
264      *
265      * Counterpart to Solidity's `uint136` operator.
266      *
267      * Requirements:
268      *
269      * - input must fit into 136 bits
270      *
271      * _Available since v4.7._
272      */
273     function toUint136(uint256 value) internal pure returns (uint136) {
274         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
275         return uint136(value);
276     }
277 
278     /**
279      * @dev Returns the downcasted uint128 from uint256, reverting on
280      * overflow (when the input is greater than largest uint128).
281      *
282      * Counterpart to Solidity's `uint128` operator.
283      *
284      * Requirements:
285      *
286      * - input must fit into 128 bits
287      *
288      * _Available since v2.5._
289      */
290     function toUint128(uint256 value) internal pure returns (uint128) {
291         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
292         return uint128(value);
293     }
294 
295     /**
296      * @dev Returns the downcasted uint120 from uint256, reverting on
297      * overflow (when the input is greater than largest uint120).
298      *
299      * Counterpart to Solidity's `uint120` operator.
300      *
301      * Requirements:
302      *
303      * - input must fit into 120 bits
304      *
305      * _Available since v4.7._
306      */
307     function toUint120(uint256 value) internal pure returns (uint120) {
308         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
309         return uint120(value);
310     }
311 
312     /**
313      * @dev Returns the downcasted uint112 from uint256, reverting on
314      * overflow (when the input is greater than largest uint112).
315      *
316      * Counterpart to Solidity's `uint112` operator.
317      *
318      * Requirements:
319      *
320      * - input must fit into 112 bits
321      *
322      * _Available since v4.7._
323      */
324     function toUint112(uint256 value) internal pure returns (uint112) {
325         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
326         return uint112(value);
327     }
328 
329     /**
330      * @dev Returns the downcasted uint104 from uint256, reverting on
331      * overflow (when the input is greater than largest uint104).
332      *
333      * Counterpart to Solidity's `uint104` operator.
334      *
335      * Requirements:
336      *
337      * - input must fit into 104 bits
338      *
339      * _Available since v4.7._
340      */
341     function toUint104(uint256 value) internal pure returns (uint104) {
342         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
343         return uint104(value);
344     }
345 
346     /**
347      * @dev Returns the downcasted uint96 from uint256, reverting on
348      * overflow (when the input is greater than largest uint96).
349      *
350      * Counterpart to Solidity's `uint96` operator.
351      *
352      * Requirements:
353      *
354      * - input must fit into 96 bits
355      *
356      * _Available since v4.2._
357      */
358     function toUint96(uint256 value) internal pure returns (uint96) {
359         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
360         return uint96(value);
361     }
362 
363     /**
364      * @dev Returns the downcasted uint88 from uint256, reverting on
365      * overflow (when the input is greater than largest uint88).
366      *
367      * Counterpart to Solidity's `uint88` operator.
368      *
369      * Requirements:
370      *
371      * - input must fit into 88 bits
372      *
373      * _Available since v4.7._
374      */
375     function toUint88(uint256 value) internal pure returns (uint88) {
376         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
377         return uint88(value);
378     }
379 
380     /**
381      * @dev Returns the downcasted uint80 from uint256, reverting on
382      * overflow (when the input is greater than largest uint80).
383      *
384      * Counterpart to Solidity's `uint80` operator.
385      *
386      * Requirements:
387      *
388      * - input must fit into 80 bits
389      *
390      * _Available since v4.7._
391      */
392     function toUint80(uint256 value) internal pure returns (uint80) {
393         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
394         return uint80(value);
395     }
396 
397     /**
398      * @dev Returns the downcasted uint72 from uint256, reverting on
399      * overflow (when the input is greater than largest uint72).
400      *
401      * Counterpart to Solidity's `uint72` operator.
402      *
403      * Requirements:
404      *
405      * - input must fit into 72 bits
406      *
407      * _Available since v4.7._
408      */
409     function toUint72(uint256 value) internal pure returns (uint72) {
410         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
411         return uint72(value);
412     }
413 
414     /**
415      * @dev Returns the downcasted uint64 from uint256, reverting on
416      * overflow (when the input is greater than largest uint64).
417      *
418      * Counterpart to Solidity's `uint64` operator.
419      *
420      * Requirements:
421      *
422      * - input must fit into 64 bits
423      *
424      * _Available since v2.5._
425      */
426     function toUint64(uint256 value) internal pure returns (uint64) {
427         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
428         return uint64(value);
429     }
430 
431     /**
432      * @dev Returns the downcasted uint56 from uint256, reverting on
433      * overflow (when the input is greater than largest uint56).
434      *
435      * Counterpart to Solidity's `uint56` operator.
436      *
437      * Requirements:
438      *
439      * - input must fit into 56 bits
440      *
441      * _Available since v4.7._
442      */
443     function toUint56(uint256 value) internal pure returns (uint56) {
444         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
445         return uint56(value);
446     }
447 
448     /**
449      * @dev Returns the downcasted uint48 from uint256, reverting on
450      * overflow (when the input is greater than largest uint48).
451      *
452      * Counterpart to Solidity's `uint48` operator.
453      *
454      * Requirements:
455      *
456      * - input must fit into 48 bits
457      *
458      * _Available since v4.7._
459      */
460     function toUint48(uint256 value) internal pure returns (uint48) {
461         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
462         return uint48(value);
463     }
464 
465     /**
466      * @dev Returns the downcasted uint40 from uint256, reverting on
467      * overflow (when the input is greater than largest uint40).
468      *
469      * Counterpart to Solidity's `uint40` operator.
470      *
471      * Requirements:
472      *
473      * - input must fit into 40 bits
474      *
475      * _Available since v4.7._
476      */
477     function toUint40(uint256 value) internal pure returns (uint40) {
478         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
479         return uint40(value);
480     }
481 
482     /**
483      * @dev Returns the downcasted uint32 from uint256, reverting on
484      * overflow (when the input is greater than largest uint32).
485      *
486      * Counterpart to Solidity's `uint32` operator.
487      *
488      * Requirements:
489      *
490      * - input must fit into 32 bits
491      *
492      * _Available since v2.5._
493      */
494     function toUint32(uint256 value) internal pure returns (uint32) {
495         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
496         return uint32(value);
497     }
498 
499     /**
500      * @dev Returns the downcasted uint24 from uint256, reverting on
501      * overflow (when the input is greater than largest uint24).
502      *
503      * Counterpart to Solidity's `uint24` operator.
504      *
505      * Requirements:
506      *
507      * - input must fit into 24 bits
508      *
509      * _Available since v4.7._
510      */
511     function toUint24(uint256 value) internal pure returns (uint24) {
512         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
513         return uint24(value);
514     }
515 
516     /**
517      * @dev Returns the downcasted uint16 from uint256, reverting on
518      * overflow (when the input is greater than largest uint16).
519      *
520      * Counterpart to Solidity's `uint16` operator.
521      *
522      * Requirements:
523      *
524      * - input must fit into 16 bits
525      *
526      * _Available since v2.5._
527      */
528     function toUint16(uint256 value) internal pure returns (uint16) {
529         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
530         return uint16(value);
531     }
532 
533     /**
534      * @dev Returns the downcasted uint8 from uint256, reverting on
535      * overflow (when the input is greater than largest uint8).
536      *
537      * Counterpart to Solidity's `uint8` operator.
538      *
539      * Requirements:
540      *
541      * - input must fit into 8 bits
542      *
543      * _Available since v2.5._
544      */
545     function toUint8(uint256 value) internal pure returns (uint8) {
546         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
547         return uint8(value);
548     }
549 
550     /**
551      * @dev Converts a signed int256 into an unsigned uint256.
552      *
553      * Requirements:
554      *
555      * - input must be greater than or equal to 0.
556      *
557      * _Available since v3.0._
558      */
559     function toUint256(int256 value) internal pure returns (uint256) {
560         require(value >= 0, "SafeCast: value must be positive");
561         return uint256(value);
562     }
563 
564     /**
565      * @dev Returns the downcasted int248 from int256, reverting on
566      * overflow (when the input is less than smallest int248 or
567      * greater than largest int248).
568      *
569      * Counterpart to Solidity's `int248` operator.
570      *
571      * Requirements:
572      *
573      * - input must fit into 248 bits
574      *
575      * _Available since v4.7._
576      */
577     function toInt248(int256 value) internal pure returns (int248 downcasted) {
578         downcasted = int248(value);
579         require(downcasted == value, "SafeCast: value doesn't fit in 248 bits");
580     }
581 
582     /**
583      * @dev Returns the downcasted int240 from int256, reverting on
584      * overflow (when the input is less than smallest int240 or
585      * greater than largest int240).
586      *
587      * Counterpart to Solidity's `int240` operator.
588      *
589      * Requirements:
590      *
591      * - input must fit into 240 bits
592      *
593      * _Available since v4.7._
594      */
595     function toInt240(int256 value) internal pure returns (int240 downcasted) {
596         downcasted = int240(value);
597         require(downcasted == value, "SafeCast: value doesn't fit in 240 bits");
598     }
599 
600     /**
601      * @dev Returns the downcasted int232 from int256, reverting on
602      * overflow (when the input is less than smallest int232 or
603      * greater than largest int232).
604      *
605      * Counterpart to Solidity's `int232` operator.
606      *
607      * Requirements:
608      *
609      * - input must fit into 232 bits
610      *
611      * _Available since v4.7._
612      */
613     function toInt232(int256 value) internal pure returns (int232 downcasted) {
614         downcasted = int232(value);
615         require(downcasted == value, "SafeCast: value doesn't fit in 232 bits");
616     }
617 
618     /**
619      * @dev Returns the downcasted int224 from int256, reverting on
620      * overflow (when the input is less than smallest int224 or
621      * greater than largest int224).
622      *
623      * Counterpart to Solidity's `int224` operator.
624      *
625      * Requirements:
626      *
627      * - input must fit into 224 bits
628      *
629      * _Available since v4.7._
630      */
631     function toInt224(int256 value) internal pure returns (int224 downcasted) {
632         downcasted = int224(value);
633         require(downcasted == value, "SafeCast: value doesn't fit in 224 bits");
634     }
635 
636     /**
637      * @dev Returns the downcasted int216 from int256, reverting on
638      * overflow (when the input is less than smallest int216 or
639      * greater than largest int216).
640      *
641      * Counterpart to Solidity's `int216` operator.
642      *
643      * Requirements:
644      *
645      * - input must fit into 216 bits
646      *
647      * _Available since v4.7._
648      */
649     function toInt216(int256 value) internal pure returns (int216 downcasted) {
650         downcasted = int216(value);
651         require(downcasted == value, "SafeCast: value doesn't fit in 216 bits");
652     }
653 
654     /**
655      * @dev Returns the downcasted int208 from int256, reverting on
656      * overflow (when the input is less than smallest int208 or
657      * greater than largest int208).
658      *
659      * Counterpart to Solidity's `int208` operator.
660      *
661      * Requirements:
662      *
663      * - input must fit into 208 bits
664      *
665      * _Available since v4.7._
666      */
667     function toInt208(int256 value) internal pure returns (int208 downcasted) {
668         downcasted = int208(value);
669         require(downcasted == value, "SafeCast: value doesn't fit in 208 bits");
670     }
671 
672     /**
673      * @dev Returns the downcasted int200 from int256, reverting on
674      * overflow (when the input is less than smallest int200 or
675      * greater than largest int200).
676      *
677      * Counterpart to Solidity's `int200` operator.
678      *
679      * Requirements:
680      *
681      * - input must fit into 200 bits
682      *
683      * _Available since v4.7._
684      */
685     function toInt200(int256 value) internal pure returns (int200 downcasted) {
686         downcasted = int200(value);
687         require(downcasted == value, "SafeCast: value doesn't fit in 200 bits");
688     }
689 
690     /**
691      * @dev Returns the downcasted int192 from int256, reverting on
692      * overflow (when the input is less than smallest int192 or
693      * greater than largest int192).
694      *
695      * Counterpart to Solidity's `int192` operator.
696      *
697      * Requirements:
698      *
699      * - input must fit into 192 bits
700      *
701      * _Available since v4.7._
702      */
703     function toInt192(int256 value) internal pure returns (int192 downcasted) {
704         downcasted = int192(value);
705         require(downcasted == value, "SafeCast: value doesn't fit in 192 bits");
706     }
707 
708     /**
709      * @dev Returns the downcasted int184 from int256, reverting on
710      * overflow (when the input is less than smallest int184 or
711      * greater than largest int184).
712      *
713      * Counterpart to Solidity's `int184` operator.
714      *
715      * Requirements:
716      *
717      * - input must fit into 184 bits
718      *
719      * _Available since v4.7._
720      */
721     function toInt184(int256 value) internal pure returns (int184 downcasted) {
722         downcasted = int184(value);
723         require(downcasted == value, "SafeCast: value doesn't fit in 184 bits");
724     }
725 
726     /**
727      * @dev Returns the downcasted int176 from int256, reverting on
728      * overflow (when the input is less than smallest int176 or
729      * greater than largest int176).
730      *
731      * Counterpart to Solidity's `int176` operator.
732      *
733      * Requirements:
734      *
735      * - input must fit into 176 bits
736      *
737      * _Available since v4.7._
738      */
739     function toInt176(int256 value) internal pure returns (int176 downcasted) {
740         downcasted = int176(value);
741         require(downcasted == value, "SafeCast: value doesn't fit in 176 bits");
742     }
743 
744     /**
745      * @dev Returns the downcasted int168 from int256, reverting on
746      * overflow (when the input is less than smallest int168 or
747      * greater than largest int168).
748      *
749      * Counterpart to Solidity's `int168` operator.
750      *
751      * Requirements:
752      *
753      * - input must fit into 168 bits
754      *
755      * _Available since v4.7._
756      */
757     function toInt168(int256 value) internal pure returns (int168 downcasted) {
758         downcasted = int168(value);
759         require(downcasted == value, "SafeCast: value doesn't fit in 168 bits");
760     }
761 
762     /**
763      * @dev Returns the downcasted int160 from int256, reverting on
764      * overflow (when the input is less than smallest int160 or
765      * greater than largest int160).
766      *
767      * Counterpart to Solidity's `int160` operator.
768      *
769      * Requirements:
770      *
771      * - input must fit into 160 bits
772      *
773      * _Available since v4.7._
774      */
775     function toInt160(int256 value) internal pure returns (int160 downcasted) {
776         downcasted = int160(value);
777         require(downcasted == value, "SafeCast: value doesn't fit in 160 bits");
778     }
779 
780     /**
781      * @dev Returns the downcasted int152 from int256, reverting on
782      * overflow (when the input is less than smallest int152 or
783      * greater than largest int152).
784      *
785      * Counterpart to Solidity's `int152` operator.
786      *
787      * Requirements:
788      *
789      * - input must fit into 152 bits
790      *
791      * _Available since v4.7._
792      */
793     function toInt152(int256 value) internal pure returns (int152 downcasted) {
794         downcasted = int152(value);
795         require(downcasted == value, "SafeCast: value doesn't fit in 152 bits");
796     }
797 
798     /**
799      * @dev Returns the downcasted int144 from int256, reverting on
800      * overflow (when the input is less than smallest int144 or
801      * greater than largest int144).
802      *
803      * Counterpart to Solidity's `int144` operator.
804      *
805      * Requirements:
806      *
807      * - input must fit into 144 bits
808      *
809      * _Available since v4.7._
810      */
811     function toInt144(int256 value) internal pure returns (int144 downcasted) {
812         downcasted = int144(value);
813         require(downcasted == value, "SafeCast: value doesn't fit in 144 bits");
814     }
815 
816     /**
817      * @dev Returns the downcasted int136 from int256, reverting on
818      * overflow (when the input is less than smallest int136 or
819      * greater than largest int136).
820      *
821      * Counterpart to Solidity's `int136` operator.
822      *
823      * Requirements:
824      *
825      * - input must fit into 136 bits
826      *
827      * _Available since v4.7._
828      */
829     function toInt136(int256 value) internal pure returns (int136 downcasted) {
830         downcasted = int136(value);
831         require(downcasted == value, "SafeCast: value doesn't fit in 136 bits");
832     }
833 
834     /**
835      * @dev Returns the downcasted int128 from int256, reverting on
836      * overflow (when the input is less than smallest int128 or
837      * greater than largest int128).
838      *
839      * Counterpart to Solidity's `int128` operator.
840      *
841      * Requirements:
842      *
843      * - input must fit into 128 bits
844      *
845      * _Available since v3.1._
846      */
847     function toInt128(int256 value) internal pure returns (int128 downcasted) {
848         downcasted = int128(value);
849         require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
850     }
851 
852     /**
853      * @dev Returns the downcasted int120 from int256, reverting on
854      * overflow (when the input is less than smallest int120 or
855      * greater than largest int120).
856      *
857      * Counterpart to Solidity's `int120` operator.
858      *
859      * Requirements:
860      *
861      * - input must fit into 120 bits
862      *
863      * _Available since v4.7._
864      */
865     function toInt120(int256 value) internal pure returns (int120 downcasted) {
866         downcasted = int120(value);
867         require(downcasted == value, "SafeCast: value doesn't fit in 120 bits");
868     }
869 
870     /**
871      * @dev Returns the downcasted int112 from int256, reverting on
872      * overflow (when the input is less than smallest int112 or
873      * greater than largest int112).
874      *
875      * Counterpart to Solidity's `int112` operator.
876      *
877      * Requirements:
878      *
879      * - input must fit into 112 bits
880      *
881      * _Available since v4.7._
882      */
883     function toInt112(int256 value) internal pure returns (int112 downcasted) {
884         downcasted = int112(value);
885         require(downcasted == value, "SafeCast: value doesn't fit in 112 bits");
886     }
887 
888     /**
889      * @dev Returns the downcasted int104 from int256, reverting on
890      * overflow (when the input is less than smallest int104 or
891      * greater than largest int104).
892      *
893      * Counterpart to Solidity's `int104` operator.
894      *
895      * Requirements:
896      *
897      * - input must fit into 104 bits
898      *
899      * _Available since v4.7._
900      */
901     function toInt104(int256 value) internal pure returns (int104 downcasted) {
902         downcasted = int104(value);
903         require(downcasted == value, "SafeCast: value doesn't fit in 104 bits");
904     }
905 
906     /**
907      * @dev Returns the downcasted int96 from int256, reverting on
908      * overflow (when the input is less than smallest int96 or
909      * greater than largest int96).
910      *
911      * Counterpart to Solidity's `int96` operator.
912      *
913      * Requirements:
914      *
915      * - input must fit into 96 bits
916      *
917      * _Available since v4.7._
918      */
919     function toInt96(int256 value) internal pure returns (int96 downcasted) {
920         downcasted = int96(value);
921         require(downcasted == value, "SafeCast: value doesn't fit in 96 bits");
922     }
923 
924     /**
925      * @dev Returns the downcasted int88 from int256, reverting on
926      * overflow (when the input is less than smallest int88 or
927      * greater than largest int88).
928      *
929      * Counterpart to Solidity's `int88` operator.
930      *
931      * Requirements:
932      *
933      * - input must fit into 88 bits
934      *
935      * _Available since v4.7._
936      */
937     function toInt88(int256 value) internal pure returns (int88 downcasted) {
938         downcasted = int88(value);
939         require(downcasted == value, "SafeCast: value doesn't fit in 88 bits");
940     }
941 
942     /**
943      * @dev Returns the downcasted int80 from int256, reverting on
944      * overflow (when the input is less than smallest int80 or
945      * greater than largest int80).
946      *
947      * Counterpart to Solidity's `int80` operator.
948      *
949      * Requirements:
950      *
951      * - input must fit into 80 bits
952      *
953      * _Available since v4.7._
954      */
955     function toInt80(int256 value) internal pure returns (int80 downcasted) {
956         downcasted = int80(value);
957         require(downcasted == value, "SafeCast: value doesn't fit in 80 bits");
958     }
959 
960     /**
961      * @dev Returns the downcasted int72 from int256, reverting on
962      * overflow (when the input is less than smallest int72 or
963      * greater than largest int72).
964      *
965      * Counterpart to Solidity's `int72` operator.
966      *
967      * Requirements:
968      *
969      * - input must fit into 72 bits
970      *
971      * _Available since v4.7._
972      */
973     function toInt72(int256 value) internal pure returns (int72 downcasted) {
974         downcasted = int72(value);
975         require(downcasted == value, "SafeCast: value doesn't fit in 72 bits");
976     }
977 
978     /**
979      * @dev Returns the downcasted int64 from int256, reverting on
980      * overflow (when the input is less than smallest int64 or
981      * greater than largest int64).
982      *
983      * Counterpart to Solidity's `int64` operator.
984      *
985      * Requirements:
986      *
987      * - input must fit into 64 bits
988      *
989      * _Available since v3.1._
990      */
991     function toInt64(int256 value) internal pure returns (int64 downcasted) {
992         downcasted = int64(value);
993         require(downcasted == value, "SafeCast: value doesn't fit in 64 bits");
994     }
995 
996     /**
997      * @dev Returns the downcasted int56 from int256, reverting on
998      * overflow (when the input is less than smallest int56 or
999      * greater than largest int56).
1000      *
1001      * Counterpart to Solidity's `int56` operator.
1002      *
1003      * Requirements:
1004      *
1005      * - input must fit into 56 bits
1006      *
1007      * _Available since v4.7._
1008      */
1009     function toInt56(int256 value) internal pure returns (int56 downcasted) {
1010         downcasted = int56(value);
1011         require(downcasted == value, "SafeCast: value doesn't fit in 56 bits");
1012     }
1013 
1014     /**
1015      * @dev Returns the downcasted int48 from int256, reverting on
1016      * overflow (when the input is less than smallest int48 or
1017      * greater than largest int48).
1018      *
1019      * Counterpart to Solidity's `int48` operator.
1020      *
1021      * Requirements:
1022      *
1023      * - input must fit into 48 bits
1024      *
1025      * _Available since v4.7._
1026      */
1027     function toInt48(int256 value) internal pure returns (int48 downcasted) {
1028         downcasted = int48(value);
1029         require(downcasted == value, "SafeCast: value doesn't fit in 48 bits");
1030     }
1031 
1032     /**
1033      * @dev Returns the downcasted int40 from int256, reverting on
1034      * overflow (when the input is less than smallest int40 or
1035      * greater than largest int40).
1036      *
1037      * Counterpart to Solidity's `int40` operator.
1038      *
1039      * Requirements:
1040      *
1041      * - input must fit into 40 bits
1042      *
1043      * _Available since v4.7._
1044      */
1045     function toInt40(int256 value) internal pure returns (int40 downcasted) {
1046         downcasted = int40(value);
1047         require(downcasted == value, "SafeCast: value doesn't fit in 40 bits");
1048     }
1049 
1050     /**
1051      * @dev Returns the downcasted int32 from int256, reverting on
1052      * overflow (when the input is less than smallest int32 or
1053      * greater than largest int32).
1054      *
1055      * Counterpart to Solidity's `int32` operator.
1056      *
1057      * Requirements:
1058      *
1059      * - input must fit into 32 bits
1060      *
1061      * _Available since v3.1._
1062      */
1063     function toInt32(int256 value) internal pure returns (int32 downcasted) {
1064         downcasted = int32(value);
1065         require(downcasted == value, "SafeCast: value doesn't fit in 32 bits");
1066     }
1067 
1068     /**
1069      * @dev Returns the downcasted int24 from int256, reverting on
1070      * overflow (when the input is less than smallest int24 or
1071      * greater than largest int24).
1072      *
1073      * Counterpart to Solidity's `int24` operator.
1074      *
1075      * Requirements:
1076      *
1077      * - input must fit into 24 bits
1078      *
1079      * _Available since v4.7._
1080      */
1081     function toInt24(int256 value) internal pure returns (int24 downcasted) {
1082         downcasted = int24(value);
1083         require(downcasted == value, "SafeCast: value doesn't fit in 24 bits");
1084     }
1085 
1086     /**
1087      * @dev Returns the downcasted int16 from int256, reverting on
1088      * overflow (when the input is less than smallest int16 or
1089      * greater than largest int16).
1090      *
1091      * Counterpart to Solidity's `int16` operator.
1092      *
1093      * Requirements:
1094      *
1095      * - input must fit into 16 bits
1096      *
1097      * _Available since v3.1._
1098      */
1099     function toInt16(int256 value) internal pure returns (int16 downcasted) {
1100         downcasted = int16(value);
1101         require(downcasted == value, "SafeCast: value doesn't fit in 16 bits");
1102     }
1103 
1104     /**
1105      * @dev Returns the downcasted int8 from int256, reverting on
1106      * overflow (when the input is less than smallest int8 or
1107      * greater than largest int8).
1108      *
1109      * Counterpart to Solidity's `int8` operator.
1110      *
1111      * Requirements:
1112      *
1113      * - input must fit into 8 bits
1114      *
1115      * _Available since v3.1._
1116      */
1117     function toInt8(int256 value) internal pure returns (int8 downcasted) {
1118         downcasted = int8(value);
1119         require(downcasted == value, "SafeCast: value doesn't fit in 8 bits");
1120     }
1121 
1122     /**
1123      * @dev Converts an unsigned uint256 into a signed int256.
1124      *
1125      * Requirements:
1126      *
1127      * - input must be less than or equal to maxInt256.
1128      *
1129      * _Available since v3.0._
1130      */
1131     function toInt256(uint256 value) internal pure returns (int256) {
1132         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1133         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1134         return int256(value);
1135     }
1136 }
