1 pragma solidity 0.6.6;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMathChainlink {
19   /**
20     * @dev Returns the addition of two unsigned integers, reverting on
21     * overflow.
22     *
23     * Counterpart to Solidity's `+` operator.
24     *
25     * Requirements:
26     * - Addition cannot overflow.
27     */
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     require(c >= a, "SafeMath: addition overflow");
31 
32     return c;
33   }
34 
35   /**
36     * @dev Returns the subtraction of two unsigned integers, reverting on
37     * overflow (when the result is negative).
38     *
39     * Counterpart to Solidity's `-` operator.
40     *
41     * Requirements:
42     * - Subtraction cannot overflow.
43     */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     require(b <= a, "SafeMath: subtraction overflow");
46     uint256 c = a - b;
47 
48     return c;
49   }
50 
51   /**
52     * @dev Returns the multiplication of two unsigned integers, reverting on
53     * overflow.
54     *
55     * Counterpart to Solidity's `*` operator.
56     *
57     * Requirements:
58     * - Multiplication cannot overflow.
59     */
60   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62     // benefit is lost if 'b' is also tested.
63     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64     if (a == 0) {
65       return 0;
66     }
67 
68     uint256 c = a * b;
69     require(c / a == b, "SafeMath: multiplication overflow");
70 
71     return c;
72   }
73 
74   /**
75     * @dev Returns the integer division of two unsigned integers. Reverts on
76     * division by zero. The result is rounded towards zero.
77     *
78     * Counterpart to Solidity's `/` operator. Note: this function uses a
79     * `revert` opcode (which leaves remaining gas untouched) while Solidity
80     * uses an invalid opcode to revert (consuming all remaining gas).
81     *
82     * Requirements:
83     * - The divisor cannot be zero.
84     */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // Solidity only automatically asserts when dividing by 0
87     require(b > 0, "SafeMath: division by zero");
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91     return c;
92   }
93 
94   /**
95     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96     * Reverts when dividing by zero.
97     *
98     * Counterpart to Solidity's `%` operator. This function uses a `revert`
99     * opcode (which leaves remaining gas untouched) while Solidity uses an
100     * invalid opcode to revert (consuming all remaining gas).
101     *
102     * Requirements:
103     * - The divisor cannot be zero.
104     */
105   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106     require(b != 0, "SafeMath: modulo by zero");
107     return a % b;
108   }
109 }
110 
111 // SPDX-License-Identifier: MIT
112 library SignedSafeMath {
113   int256 constant private _INT256_MIN = -2**255;
114 
115   /**
116    * @dev Multiplies two signed integers, reverts on overflow.
117    */
118   function mul(int256 a, int256 b) internal pure returns (int256) {
119     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
120     // benefit is lost if 'b' is also tested.
121     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
122     if (a == 0) {
123       return 0;
124     }
125 
126     require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
127 
128     int256 c = a * b;
129     require(c / a == b, "SignedSafeMath: multiplication overflow");
130 
131     return c;
132   }
133 
134   /**
135    * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
136    */
137   function div(int256 a, int256 b) internal pure returns (int256) {
138     require(b != 0, "SignedSafeMath: division by zero");
139     require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
140 
141     int256 c = a / b;
142 
143     return c;
144   }
145 
146   /**
147    * @dev Subtracts two signed integers, reverts on overflow.
148    */
149   function sub(int256 a, int256 b) internal pure returns (int256) {
150     int256 c = a - b;
151     require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
152 
153     return c;
154   }
155 
156   /**
157    * @dev Adds two signed integers, reverts on overflow.
158    */
159   function add(int256 a, int256 b) internal pure returns (int256) {
160     int256 c = a + b;
161     require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
162 
163     return c;
164   }
165 
166   /**
167    * @notice Computes average of two signed integers, ensuring that the computation
168    * doesn't overflow.
169    * @dev If the result is not an integer, it is rounded towards zero. For example,
170    * avg(-3, -4) = -3
171    */
172   function avg(int256 _a, int256 _b)
173     internal
174     pure
175     returns (int256)
176   {
177     if ((_a < 0 && _b > 0) || (_a > 0 && _b < 0)) {
178       return add(_a, _b) / 2;
179     }
180     int256 remainder = (_a % 2 + _b % 2) / 2;
181     return add(add(_a / 2, _b / 2), remainder);
182   }
183 }
184 
185 // SPDX-License-Identifier: MIT
186 library Median {
187   using SignedSafeMath for int256;
188 
189   int256 constant INT_MAX = 2**255-1;
190 
191   /**
192    * @notice Returns the sorted middle, or the average of the two middle indexed items if the
193    * array has an even number of elements.
194    * @dev The list passed as an argument isn't modified.
195    * @dev This algorithm has expected runtime O(n), but for adversarially chosen inputs
196    * the runtime is O(n^2).
197    * @param list The list of elements to compare
198    */
199   function calculate(int256[] memory list)
200     internal
201     pure
202     returns (int256)
203   {
204     return calculateInplace(copy(list));
205   }
206 
207   /**
208    * @notice See documentation for function calculate.
209    * @dev The list passed as an argument may be permuted.
210    */
211   function calculateInplace(int256[] memory list)
212     internal
213     pure
214     returns (int256)
215   {
216     require(0 < list.length, "list must not be empty");
217     uint256 len = list.length;
218     uint256 middleIndex = len / 2;
219     if (len % 2 == 0) {
220       int256 median1;
221       int256 median2;
222       (median1, median2) = quickselectTwo(list, 0, len - 1, middleIndex - 1, middleIndex);
223       return SignedSafeMath.avg(median1, median2);
224     } else {
225       return quickselect(list, 0, len - 1, middleIndex);
226     }
227   }
228 
229   /**
230    * @notice Maximum length of list that shortSelectTwo can handle
231    */
232   uint256 constant SHORTSELECTTWO_MAX_LENGTH = 7;
233 
234   /**
235    * @notice Select the k1-th and k2-th element from list of length at most 7
236    * @dev Uses an optimal sorting network
237    */
238   function shortSelectTwo(
239     int256[] memory list,
240     uint256 lo,
241     uint256 hi,
242     uint256 k1,
243     uint256 k2
244   )
245     private
246     pure
247     returns (int256 k1th, int256 k2th)
248   {
249     // Uses an optimal sorting network (https://en.wikipedia.org/wiki/Sorting_network)
250     // for lists of length 7. Network layout is taken from
251     // http://jgamble.ripco.net/cgi-bin/nw.cgi?inputs=7&algorithm=hibbard&output=svg
252 
253     uint256 len = hi + 1 - lo;
254     int256 x0 = list[lo + 0];
255     int256 x1 = 1 < len ? list[lo + 1] : INT_MAX;
256     int256 x2 = 2 < len ? list[lo + 2] : INT_MAX;
257     int256 x3 = 3 < len ? list[lo + 3] : INT_MAX;
258     int256 x4 = 4 < len ? list[lo + 4] : INT_MAX;
259     int256 x5 = 5 < len ? list[lo + 5] : INT_MAX;
260     int256 x6 = 6 < len ? list[lo + 6] : INT_MAX;
261 
262     if (x0 > x1) {(x0, x1) = (x1, x0);}
263     if (x2 > x3) {(x2, x3) = (x3, x2);}
264     if (x4 > x5) {(x4, x5) = (x5, x4);}
265     if (x0 > x2) {(x0, x2) = (x2, x0);}
266     if (x1 > x3) {(x1, x3) = (x3, x1);}
267     if (x4 > x6) {(x4, x6) = (x6, x4);}
268     if (x1 > x2) {(x1, x2) = (x2, x1);}
269     if (x5 > x6) {(x5, x6) = (x6, x5);}
270     if (x0 > x4) {(x0, x4) = (x4, x0);}
271     if (x1 > x5) {(x1, x5) = (x5, x1);}
272     if (x2 > x6) {(x2, x6) = (x6, x2);}
273     if (x1 > x4) {(x1, x4) = (x4, x1);}
274     if (x3 > x6) {(x3, x6) = (x6, x3);}
275     if (x2 > x4) {(x2, x4) = (x4, x2);}
276     if (x3 > x5) {(x3, x5) = (x5, x3);}
277     if (x3 > x4) {(x3, x4) = (x4, x3);}
278 
279     uint256 index1 = k1 - lo;
280     if (index1 == 0) {k1th = x0;}
281     else if (index1 == 1) {k1th = x1;}
282     else if (index1 == 2) {k1th = x2;}
283     else if (index1 == 3) {k1th = x3;}
284     else if (index1 == 4) {k1th = x4;}
285     else if (index1 == 5) {k1th = x5;}
286     else if (index1 == 6) {k1th = x6;}
287     else {revert("k1 out of bounds");}
288 
289     uint256 index2 = k2 - lo;
290     if (k1 == k2) {return (k1th, k1th);}
291     else if (index2 == 0) {return (k1th, x0);}
292     else if (index2 == 1) {return (k1th, x1);}
293     else if (index2 == 2) {return (k1th, x2);}
294     else if (index2 == 3) {return (k1th, x3);}
295     else if (index2 == 4) {return (k1th, x4);}
296     else if (index2 == 5) {return (k1th, x5);}
297     else if (index2 == 6) {return (k1th, x6);}
298     else {revert("k2 out of bounds");}
299   }
300 
301   /**
302    * @notice Selects the k-th ranked element from list, looking only at indices between lo and hi
303    * (inclusive). Modifies list in-place.
304    */
305   function quickselect(int256[] memory list, uint256 lo, uint256 hi, uint256 k)
306     private
307     pure
308     returns (int256 kth)
309   {
310     require(lo <= k);
311     require(k <= hi);
312     while (lo < hi) {
313       if (hi - lo < SHORTSELECTTWO_MAX_LENGTH) {
314         int256 ignore;
315         (kth, ignore) = shortSelectTwo(list, lo, hi, k, k);
316         return kth;
317       }
318       uint256 pivotIndex = partition(list, lo, hi);
319       if (k <= pivotIndex) {
320         // since pivotIndex < (original hi passed to partition),
321         // termination is guaranteed in this case
322         hi = pivotIndex;
323       } else {
324         // since (original lo passed to partition) <= pivotIndex,
325         // termination is guaranteed in this case
326         lo = pivotIndex + 1;
327       }
328     }
329     return list[lo];
330   }
331 
332   /**
333    * @notice Selects the k1-th and k2-th ranked elements from list, looking only at indices between
334    * lo and hi (inclusive). Modifies list in-place.
335    */
336   function quickselectTwo(
337     int256[] memory list,
338     uint256 lo,
339     uint256 hi,
340     uint256 k1,
341     uint256 k2
342   )
343     internal // for testing
344     pure
345     returns (int256 k1th, int256 k2th)
346   {
347     require(k1 < k2);
348     require(lo <= k1 && k1 <= hi);
349     require(lo <= k2 && k2 <= hi);
350 
351     while (true) {
352       if (hi - lo < SHORTSELECTTWO_MAX_LENGTH) {
353         return shortSelectTwo(list, lo, hi, k1, k2);
354       }
355       uint256 pivotIdx = partition(list, lo, hi);
356       if (k2 <= pivotIdx) {
357         hi = pivotIdx;
358       } else if (pivotIdx < k1) {
359         lo = pivotIdx + 1;
360       } else {
361         assert(k1 <= pivotIdx && pivotIdx < k2);
362         k1th = quickselect(list, lo, pivotIdx, k1);
363         k2th = quickselect(list, pivotIdx + 1, hi, k2);
364         return (k1th, k2th);
365       }
366     }
367   }
368 
369   /**
370    * @notice Partitions list in-place using Hoare's partitioning scheme.
371    * Only elements of list between indices lo and hi (inclusive) will be modified.
372    * Returns an index i, such that:
373    * - lo <= i < hi
374    * - forall j in [lo, i]. list[j] <= list[i]
375    * - forall j in [i, hi]. list[i] <= list[j]
376    */
377   function partition(int256[] memory list, uint256 lo, uint256 hi)
378     private
379     pure
380     returns (uint256)
381   {
382     // We don't care about overflow of the addition, because it would require a list
383     // larger than any feasible computer's memory.
384     int256 pivot = list[(lo + hi) / 2];
385     lo -= 1; // this can underflow. that's intentional.
386     hi += 1;
387     while (true) {
388       do {
389         lo += 1;
390       } while (list[lo] < pivot);
391       do {
392         hi -= 1;
393       } while (list[hi] > pivot);
394       if (lo < hi) {
395         (list[lo], list[hi]) = (list[hi], list[lo]);
396       } else {
397         // Let orig_lo and orig_hi be the original values of lo and hi passed to partition.
398         // Then, hi < orig_hi, because hi decreases *strictly* monotonically
399         // in each loop iteration and
400         // - either list[orig_hi] > pivot, in which case the first loop iteration
401         //   will achieve hi < orig_hi;
402         // - or list[orig_hi] <= pivot, in which case at least two loop iterations are
403         //   needed:
404         //   - lo will have to stop at least once in the interval
405         //     [orig_lo, (orig_lo + orig_hi)/2]
406         //   - (orig_lo + orig_hi)/2 < orig_hi
407         return hi;
408       }
409     }
410   }
411 
412   /**
413    * @notice Makes an in-memory copy of the array passed in
414    * @param list Reference to the array to be copied
415    */
416   function copy(int256[] memory list)
417     private
418     pure
419     returns(int256[] memory)
420   {
421     int256[] memory list2 = new int256[](list.length);
422     for (uint256 i = 0; i < list.length; i++) {
423       list2[i] = list[i];
424     }
425     return list2;
426   }
427 }
428 
429 // SPDX-License-Identifier: MIT
430 /**
431  * @title The Owned contract
432  * @notice A contract with helpers for basic contract ownership.
433  */
434 contract Owned {
435 
436   address public owner;
437   address private pendingOwner;
438 
439   event OwnershipTransferRequested(
440     address indexed from,
441     address indexed to
442   );
443   event OwnershipTransferred(
444     address indexed from,
445     address indexed to
446   );
447 
448   constructor() public {
449     owner = msg.sender;
450   }
451 
452   /**
453    * @dev Allows an owner to begin transferring ownership to a new address,
454    * pending.
455    */
456   function transferOwnership(address _to)
457     external
458     onlyOwner()
459   {
460     pendingOwner = _to;
461 
462     emit OwnershipTransferRequested(owner, _to);
463   }
464 
465   /**
466    * @dev Allows an ownership transfer to be completed by the recipient.
467    */
468   function acceptOwnership()
469     external
470   {
471     require(msg.sender == pendingOwner, "Must be proposed owner");
472 
473     address oldOwner = owner;
474     owner = msg.sender;
475     pendingOwner = address(0);
476 
477     emit OwnershipTransferred(oldOwner, msg.sender);
478   }
479 
480   /**
481    * @dev Reverts if called by anyone other than the contract owner.
482    */
483   modifier onlyOwner() {
484     require(msg.sender == owner, "Only callable by owner");
485     _;
486   }
487 
488 }
489 
490 // SPDX-License-Identifier: MIT
491 /**
492  * @dev Wrappers over Solidity's arithmetic operations with added overflow
493  * checks.
494  *
495  * Arithmetic operations in Solidity wrap on overflow. This can easily result
496  * in bugs, because programmers usually assume that an overflow raises an
497  * error, which is the standard behavior in high level programming languages.
498  * `SafeMath` restores this intuition by reverting the transaction when an
499  * operation overflows.
500  *
501  * Using this library instead of the unchecked operations eliminates an entire
502  * class of bugs, so it's recommended to use it always.
503  *
504  * This library is a version of Open Zeppelin's SafeMath, modified to support
505  * unsigned 128 bit integers.
506  */
507 library SafeMath128 {
508   /**
509     * @dev Returns the addition of two unsigned integers, reverting on
510     * overflow.
511     *
512     * Counterpart to Solidity's `+` operator.
513     *
514     * Requirements:
515     * - Addition cannot overflow.
516     */
517   function add(uint128 a, uint128 b) internal pure returns (uint128) {
518     uint128 c = a + b;
519     require(c >= a, "SafeMath: addition overflow");
520 
521     return c;
522   }
523 
524   /**
525     * @dev Returns the subtraction of two unsigned integers, reverting on
526     * overflow (when the result is negative).
527     *
528     * Counterpart to Solidity's `-` operator.
529     *
530     * Requirements:
531     * - Subtraction cannot overflow.
532     */
533   function sub(uint128 a, uint128 b) internal pure returns (uint128) {
534     require(b <= a, "SafeMath: subtraction overflow");
535     uint128 c = a - b;
536 
537     return c;
538   }
539 
540   /**
541     * @dev Returns the multiplication of two unsigned integers, reverting on
542     * overflow.
543     *
544     * Counterpart to Solidity's `*` operator.
545     *
546     * Requirements:
547     * - Multiplication cannot overflow.
548     */
549   function mul(uint128 a, uint128 b) internal pure returns (uint128) {
550     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
551     // benefit is lost if 'b' is also tested.
552     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
553     if (a == 0) {
554       return 0;
555     }
556 
557     uint128 c = a * b;
558     require(c / a == b, "SafeMath: multiplication overflow");
559 
560     return c;
561   }
562 
563   /**
564     * @dev Returns the integer division of two unsigned integers. Reverts on
565     * division by zero. The result is rounded towards zero.
566     *
567     * Counterpart to Solidity's `/` operator. Note: this function uses a
568     * `revert` opcode (which leaves remaining gas untouched) while Solidity
569     * uses an invalid opcode to revert (consuming all remaining gas).
570     *
571     * Requirements:
572     * - The divisor cannot be zero.
573     */
574   function div(uint128 a, uint128 b) internal pure returns (uint128) {
575     // Solidity only automatically asserts when dividing by 0
576     require(b > 0, "SafeMath: division by zero");
577     uint128 c = a / b;
578     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
579 
580     return c;
581   }
582 
583   /**
584     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
585     * Reverts when dividing by zero.
586     *
587     * Counterpart to Solidity's `%` operator. This function uses a `revert`
588     * opcode (which leaves remaining gas untouched) while Solidity uses an
589     * invalid opcode to revert (consuming all remaining gas).
590     *
591     * Requirements:
592     * - The divisor cannot be zero.
593     */
594   function mod(uint128 a, uint128 b) internal pure returns (uint128) {
595     require(b != 0, "SafeMath: modulo by zero");
596     return a % b;
597   }
598 }
599 
600 // SPDX-License-Identifier: MIT
601 /**
602  * @dev Wrappers over Solidity's arithmetic operations with added overflow
603  * checks.
604  *
605  * Arithmetic operations in Solidity wrap on overflow. This can easily result
606  * in bugs, because programmers usually assume that an overflow raises an
607  * error, which is the standard behavior in high level programming languages.
608  * `SafeMath` restores this intuition by reverting the transaction when an
609  * operation overflows.
610  *
611  * Using this library instead of the unchecked operations eliminates an entire
612  * class of bugs, so it's recommended to use it always.
613  *
614  * This library is a version of Open Zeppelin's SafeMath, modified to support
615  * unsigned 32 bit integers.
616  */
617 library SafeMath32 {
618   /**
619     * @dev Returns the addition of two unsigned integers, reverting on
620     * overflow.
621     *
622     * Counterpart to Solidity's `+` operator.
623     *
624     * Requirements:
625     * - Addition cannot overflow.
626     */
627   function add(uint32 a, uint32 b) internal pure returns (uint32) {
628     uint32 c = a + b;
629     require(c >= a, "SafeMath: addition overflow");
630 
631     return c;
632   }
633 
634   /**
635     * @dev Returns the subtraction of two unsigned integers, reverting on
636     * overflow (when the result is negative).
637     *
638     * Counterpart to Solidity's `-` operator.
639     *
640     * Requirements:
641     * - Subtraction cannot overflow.
642     */
643   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
644     require(b <= a, "SafeMath: subtraction overflow");
645     uint32 c = a - b;
646 
647     return c;
648   }
649 
650   /**
651     * @dev Returns the multiplication of two unsigned integers, reverting on
652     * overflow.
653     *
654     * Counterpart to Solidity's `*` operator.
655     *
656     * Requirements:
657     * - Multiplication cannot overflow.
658     */
659   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
660     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
661     // benefit is lost if 'b' is also tested.
662     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
663     if (a == 0) {
664       return 0;
665     }
666 
667     uint32 c = a * b;
668     require(c / a == b, "SafeMath: multiplication overflow");
669 
670     return c;
671   }
672 
673   /**
674     * @dev Returns the integer division of two unsigned integers. Reverts on
675     * division by zero. The result is rounded towards zero.
676     *
677     * Counterpart to Solidity's `/` operator. Note: this function uses a
678     * `revert` opcode (which leaves remaining gas untouched) while Solidity
679     * uses an invalid opcode to revert (consuming all remaining gas).
680     *
681     * Requirements:
682     * - The divisor cannot be zero.
683     */
684   function div(uint32 a, uint32 b) internal pure returns (uint32) {
685     // Solidity only automatically asserts when dividing by 0
686     require(b > 0, "SafeMath: division by zero");
687     uint32 c = a / b;
688     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
689 
690     return c;
691   }
692 
693   /**
694     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
695     * Reverts when dividing by zero.
696     *
697     * Counterpart to Solidity's `%` operator. This function uses a `revert`
698     * opcode (which leaves remaining gas untouched) while Solidity uses an
699     * invalid opcode to revert (consuming all remaining gas).
700     *
701     * Requirements:
702     * - The divisor cannot be zero.
703     */
704   function mod(uint32 a, uint32 b) internal pure returns (uint32) {
705     require(b != 0, "SafeMath: modulo by zero");
706     return a % b;
707   }
708 }
709 
710 // SPDX-License-Identifier: MIT
711 /**
712  * @dev Wrappers over Solidity's arithmetic operations with added overflow
713  * checks.
714  *
715  * Arithmetic operations in Solidity wrap on overflow. This can easily result
716  * in bugs, because programmers usually assume that an overflow raises an
717  * error, which is the standard behavior in high level programming languages.
718  * `SafeMath` restores this intuition by reverting the transaction when an
719  * operation overflows.
720  *
721  * Using this library instead of the unchecked operations eliminates an entire
722  * class of bugs, so it's recommended to use it always.
723  *
724  * This library is a version of Open Zeppelin's SafeMath, modified to support
725  * unsigned 64 bit integers.
726  */
727 library SafeMath64 {
728   /**
729     * @dev Returns the addition of two unsigned integers, reverting on
730     * overflow.
731     *
732     * Counterpart to Solidity's `+` operator.
733     *
734     * Requirements:
735     * - Addition cannot overflow.
736     */
737   function add(uint64 a, uint64 b) internal pure returns (uint64) {
738     uint64 c = a + b;
739     require(c >= a, "SafeMath: addition overflow");
740 
741     return c;
742   }
743 
744   /**
745     * @dev Returns the subtraction of two unsigned integers, reverting on
746     * overflow (when the result is negative).
747     *
748     * Counterpart to Solidity's `-` operator.
749     *
750     * Requirements:
751     * - Subtraction cannot overflow.
752     */
753   function sub(uint64 a, uint64 b) internal pure returns (uint64) {
754     require(b <= a, "SafeMath: subtraction overflow");
755     uint64 c = a - b;
756 
757     return c;
758   }
759 
760   /**
761     * @dev Returns the multiplication of two unsigned integers, reverting on
762     * overflow.
763     *
764     * Counterpart to Solidity's `*` operator.
765     *
766     * Requirements:
767     * - Multiplication cannot overflow.
768     */
769   function mul(uint64 a, uint64 b) internal pure returns (uint64) {
770     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
771     // benefit is lost if 'b' is also tested.
772     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
773     if (a == 0) {
774       return 0;
775     }
776 
777     uint64 c = a * b;
778     require(c / a == b, "SafeMath: multiplication overflow");
779 
780     return c;
781   }
782 
783   /**
784     * @dev Returns the integer division of two unsigned integers. Reverts on
785     * division by zero. The result is rounded towards zero.
786     *
787     * Counterpart to Solidity's `/` operator. Note: this function uses a
788     * `revert` opcode (which leaves remaining gas untouched) while Solidity
789     * uses an invalid opcode to revert (consuming all remaining gas).
790     *
791     * Requirements:
792     * - The divisor cannot be zero.
793     */
794   function div(uint64 a, uint64 b) internal pure returns (uint64) {
795     // Solidity only automatically asserts when dividing by 0
796     require(b > 0, "SafeMath: division by zero");
797     uint64 c = a / b;
798     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
799 
800     return c;
801   }
802 
803   /**
804     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
805     * Reverts when dividing by zero.
806     *
807     * Counterpart to Solidity's `%` operator. This function uses a `revert`
808     * opcode (which leaves remaining gas untouched) while Solidity uses an
809     * invalid opcode to revert (consuming all remaining gas).
810     *
811     * Requirements:
812     * - The divisor cannot be zero.
813     */
814   function mod(uint64 a, uint64 b) internal pure returns (uint64) {
815     require(b != 0, "SafeMath: modulo by zero");
816     return a % b;
817   }
818 }
819 
820 // SPDX-License-Identifier: MIT
821 interface AggregatorInterface {
822   function latestAnswer() external view returns (int256);
823   function latestTimestamp() external view returns (uint256);
824   function latestRound() external view returns (uint256);
825   function getAnswer(uint256 roundId) external view returns (int256);
826   function getTimestamp(uint256 roundId) external view returns (uint256);
827 
828   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);
829   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
830 }
831 
832 // SPDX-License-Identifier: MIT
833 interface AggregatorV3Interface {
834 
835   function decimals() external view returns (uint8);
836   function description() external view returns (string memory);
837   function version() external view returns (uint256);
838 
839   // getRoundData and latestRoundData should both raise "No data present"
840   // if they do not have data to report, instead of returning unset values
841   // which could be misinterpreted as actual reported values.
842   function getRoundData(uint80 _roundId)
843     external
844     view
845     returns (
846       uint80 roundId,
847       int256 answer,
848       uint256 startedAt,
849       uint256 updatedAt,
850       uint80 answeredInRound
851     );
852   function latestRoundData()
853     external
854     view
855     returns (
856       uint80 roundId,
857       int256 answer,
858       uint256 startedAt,
859       uint256 updatedAt,
860       uint80 answeredInRound
861     );
862 
863 }
864 
865 // SPDX-License-Identifier: MIT
866 interface AggregatorV2V3Interface is AggregatorInterface, AggregatorV3Interface
867 {
868 }
869 
870 // SPDX-License-Identifier: MIT
871 interface AggregatorValidatorInterface {
872   function validate(
873     uint256 previousRoundId,
874     int256 previousAnswer,
875     uint256 currentRoundId,
876     int256 currentAnswer
877   ) external returns (bool);
878 }
879 
880 // SPDX-License-Identifier: MIT
881 interface LinkTokenInterface {
882   function allowance(address owner, address spender) external view returns (uint256 remaining);
883   function approve(address spender, uint256 value) external returns (bool success);
884   function balanceOf(address owner) external view returns (uint256 balance);
885   function decimals() external view returns (uint8 decimalPlaces);
886   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
887   function increaseApproval(address spender, uint256 subtractedValue) external;
888   function name() external view returns (string memory tokenName);
889   function symbol() external view returns (string memory tokenSymbol);
890   function totalSupply() external view returns (uint256 totalTokensIssued);
891   function transfer(address to, uint256 value) external returns (bool success);
892   function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);
893   function transferFrom(address from, address to, uint256 value) external returns (bool success);
894 }
895 
896 // SPDX-License-Identifier: MIT
897 /**
898  * @title The Prepaid Aggregator contract
899  * @notice Handles aggregating data pushed in from off-chain, and unlocks
900  * payment for oracles as they report. Oracles' submissions are gathered in
901  * rounds, with each round aggregating the submissions for each oracle into a
902  * single answer. The latest aggregated answer is exposed as well as historical
903  * answers and their updated at timestamp.
904  */
905 contract FluxAggregator is AggregatorV2V3Interface, Owned {
906   using SafeMathChainlink for uint256;
907   using SafeMath128 for uint128;
908   using SafeMath64 for uint64;
909   using SafeMath32 for uint32;
910 
911   struct Round {
912     int256 answer;
913     uint64 startedAt;
914     uint64 updatedAt;
915     uint32 answeredInRound;
916   }
917 
918   struct RoundDetails {
919     int256[] submissions;
920     uint32 maxSubmissions;
921     uint32 minSubmissions;
922     uint32 timeout;
923     uint128 paymentAmount;
924   }
925 
926   struct OracleStatus {
927     uint128 withdrawable;
928     uint32 startingRound;
929     uint32 endingRound;
930     uint32 lastReportedRound;
931     uint32 lastStartedRound;
932     int256 latestSubmission;
933     uint16 index;
934     address admin;
935     address pendingAdmin;
936   }
937 
938   struct Requester {
939     bool authorized;
940     uint32 delay;
941     uint32 lastStartedRound;
942   }
943 
944   struct Funds {
945     uint128 available;
946     uint128 allocated;
947   }
948 
949   LinkTokenInterface public linkToken;
950   AggregatorValidatorInterface public validator;
951 
952   // Round related params
953   uint128 public paymentAmount;
954   uint32 public maxSubmissionCount;
955   uint32 public minSubmissionCount;
956   uint32 public restartDelay;
957   uint32 public timeout;
958   uint8 public override decimals;
959   string public override description;
960 
961   int256 immutable public minSubmissionValue;
962   int256 immutable public maxSubmissionValue;
963 
964   uint256 constant public override version = 3;
965 
966   /**
967    * @notice To ensure owner isn't withdrawing required funds as oracles are
968    * submitting updates, we enforce that the contract maintains a minimum
969    * reserve of RESERVE_ROUNDS * oracleCount() LINK earmarked for payment to
970    * oracles. (Of course, this doesn't prevent the contract from running out of
971    * funds without the owner's intervention.)
972    */
973   uint256 constant private RESERVE_ROUNDS = 2;
974   uint256 constant private MAX_ORACLE_COUNT = 77;
975   uint32 constant private ROUND_MAX = 2**32-1;
976   uint256 private constant VALIDATOR_GAS_LIMIT = 100000;
977   // An error specific to the Aggregator V3 Interface, to prevent possible
978   // confusion around accidentally reading unset values as reported values.
979   string constant private V3_NO_DATA_ERROR = "No data present";
980 
981   uint32 private reportingRoundId;
982   uint32 internal latestRoundId;
983   mapping(address => OracleStatus) private oracles;
984   mapping(uint32 => Round) internal rounds;
985   mapping(uint32 => RoundDetails) internal details;
986   mapping(address => Requester) internal requesters;
987   address[] private oracleAddresses;
988   Funds private recordedFunds;
989 
990   event AvailableFundsUpdated(
991     uint256 indexed amount
992   );
993   event RoundDetailsUpdated(
994     uint128 indexed paymentAmount,
995     uint32 indexed minSubmissionCount,
996     uint32 indexed maxSubmissionCount,
997     uint32 restartDelay,
998     uint32 timeout // measured in seconds
999   );
1000   event OraclePermissionsUpdated(
1001     address indexed oracle,
1002     bool indexed whitelisted
1003   );
1004   event OracleAdminUpdated(
1005     address indexed oracle,
1006     address indexed newAdmin
1007   );
1008   event OracleAdminUpdateRequested(
1009     address indexed oracle,
1010     address admin,
1011     address newAdmin
1012   );
1013   event SubmissionReceived(
1014     int256 indexed submission,
1015     uint32 indexed round,
1016     address indexed oracle
1017   );
1018   event RequesterPermissionsSet(
1019     address indexed requester,
1020     bool authorized,
1021     uint32 delay
1022   );
1023   event ValidatorUpdated(
1024     address indexed previous,
1025     address indexed current
1026   );
1027 
1028   /**
1029    * @notice set up the aggregator with initial configuration
1030    * @param _link The address of the LINK token
1031    * @param _paymentAmount The amount paid of LINK paid to each oracle per submission, in wei (units of 10⁻¹⁸ LINK)
1032    * @param _timeout is the number of seconds after the previous round that are
1033    * allowed to lapse before allowing an oracle to skip an unfinished round
1034    * @param _validator is an optional contract address for validating
1035    * external validation of answers
1036    * @param _minSubmissionValue is an immutable check for a lower bound of what
1037    * submission values are accepted from an oracle
1038    * @param _maxSubmissionValue is an immutable check for an upper bound of what
1039    * submission values are accepted from an oracle
1040    * @param _decimals represents the number of decimals to offset the answer by
1041    * @param _description a short description of what is being reported
1042    */
1043   constructor(
1044     address _link,
1045     uint128 _paymentAmount,
1046     uint32 _timeout,
1047     address _validator,
1048     int256 _minSubmissionValue,
1049     int256 _maxSubmissionValue,
1050     uint8 _decimals,
1051     string memory _description
1052   ) public {
1053     linkToken = LinkTokenInterface(_link);
1054     updateFutureRounds(_paymentAmount, 0, 0, 0, _timeout);
1055     setValidator(_validator);
1056     minSubmissionValue = _minSubmissionValue;
1057     maxSubmissionValue = _maxSubmissionValue;
1058     decimals = _decimals;
1059     description = _description;
1060     rounds[0].updatedAt = uint64(block.timestamp.sub(uint256(_timeout)));
1061   }
1062 
1063   /**
1064    * @notice called by oracles when they have witnessed a need to update
1065    * @param _roundId is the ID of the round this submission pertains to
1066    * @param _submission is the updated data that the oracle is submitting
1067    */
1068   function submit(uint256 _roundId, int256 _submission)
1069     external
1070   {
1071     bytes memory error = validateOracleRound(msg.sender, uint32(_roundId));
1072     require(_submission >= minSubmissionValue, "value below minSubmissionValue");
1073     require(_submission <= maxSubmissionValue, "value above maxSubmissionValue");
1074     require(error.length == 0, string(error));
1075 
1076     oracleInitializeNewRound(uint32(_roundId));
1077     recordSubmission(_submission, uint32(_roundId));
1078     (bool updated, int256 newAnswer) = updateRoundAnswer(uint32(_roundId));
1079     payOracle(uint32(_roundId));
1080     deleteRoundDetails(uint32(_roundId));
1081     if (updated) {
1082       validateAnswer(uint32(_roundId), newAnswer);
1083     }
1084   }
1085 
1086   /**
1087    * @notice called by the owner to remove and add new oracles as well as
1088    * update the round related parameters that pertain to total oracle count
1089    * @param _removed is the list of addresses for the new Oracles being removed
1090    * @param _added is the list of addresses for the new Oracles being added
1091    * @param _addedAdmins is the admin addresses for the new respective _added
1092    * list. Only this address is allowed to access the respective oracle's funds
1093    * @param _minSubmissions is the new minimum submission count for each round
1094    * @param _maxSubmissions is the new maximum submission count for each round
1095    * @param _restartDelay is the number of rounds an Oracle has to wait before
1096    * they can initiate a round
1097    */
1098   function changeOracles(
1099     address[] calldata _removed,
1100     address[] calldata _added,
1101     address[] calldata _addedAdmins,
1102     uint32 _minSubmissions,
1103     uint32 _maxSubmissions,
1104     uint32 _restartDelay
1105   )
1106     external
1107     onlyOwner()
1108   {
1109     for (uint256 i = 0; i < _removed.length; i++) {
1110       removeOracle(_removed[i]);
1111     }
1112 
1113     require(_added.length == _addedAdmins.length, "need same oracle and admin count");
1114     require(uint256(oracleCount()).add(_added.length) <= MAX_ORACLE_COUNT, "max oracles allowed");
1115 
1116     for (uint256 i = 0; i < _added.length; i++) {
1117       addOracle(_added[i], _addedAdmins[i]);
1118     }
1119 
1120     updateFutureRounds(paymentAmount, _minSubmissions, _maxSubmissions, _restartDelay, timeout);
1121   }
1122 
1123   /**
1124    * @notice update the round and payment related parameters for subsequent
1125    * rounds
1126    * @param _paymentAmount is the payment amount for subsequent rounds
1127    * @param _minSubmissions is the new minimum submission count for each round
1128    * @param _maxSubmissions is the new maximum submission count for each round
1129    * @param _restartDelay is the number of rounds an Oracle has to wait before
1130    * they can initiate a round
1131    */
1132   function updateFutureRounds(
1133     uint128 _paymentAmount,
1134     uint32 _minSubmissions,
1135     uint32 _maxSubmissions,
1136     uint32 _restartDelay,
1137     uint32 _timeout
1138   )
1139     public
1140     onlyOwner()
1141   {
1142     uint32 oracleNum = oracleCount(); // Save on storage reads
1143     require(_maxSubmissions >= _minSubmissions, "max must equal/exceed min");
1144     require(oracleNum >= _maxSubmissions, "max cannot exceed total");
1145     require(oracleNum == 0 || oracleNum > _restartDelay, "delay cannot exceed total");
1146     require(recordedFunds.available >= requiredReserve(_paymentAmount), "insufficient funds for payment");
1147     if (oracleCount() > 0) {
1148       require(_minSubmissions > 0, "min must be greater than 0");
1149     }
1150 
1151     paymentAmount = _paymentAmount;
1152     minSubmissionCount = _minSubmissions;
1153     maxSubmissionCount = _maxSubmissions;
1154     restartDelay = _restartDelay;
1155     timeout = _timeout;
1156 
1157     emit RoundDetailsUpdated(
1158       paymentAmount,
1159       _minSubmissions,
1160       _maxSubmissions,
1161       _restartDelay,
1162       _timeout
1163     );
1164   }
1165 
1166   /**
1167    * @notice the amount of payment yet to be withdrawn by oracles
1168    */
1169   function allocatedFunds()
1170     external
1171     view
1172     returns (uint128)
1173   {
1174     return recordedFunds.allocated;
1175   }
1176 
1177   /**
1178    * @notice the amount of future funding available to oracles
1179    */
1180   function availableFunds()
1181     external
1182     view
1183     returns (uint128)
1184   {
1185     return recordedFunds.available;
1186   }
1187 
1188   /**
1189    * @notice recalculate the amount of LINK available for payouts
1190    */
1191   function updateAvailableFunds()
1192     public
1193   {
1194     Funds memory funds = recordedFunds;
1195 
1196     uint256 nowAvailable = linkToken.balanceOf(address(this)).sub(funds.allocated);
1197 
1198     if (funds.available != nowAvailable) {
1199       recordedFunds.available = uint128(nowAvailable);
1200       emit AvailableFundsUpdated(nowAvailable);
1201     }
1202   }
1203 
1204   /**
1205    * @notice returns the number of oracles
1206    */
1207   function oracleCount() public view returns (uint8) {
1208     return uint8(oracleAddresses.length);
1209   }
1210 
1211   /**
1212    * @notice returns an array of addresses containing the oracles on contract
1213    */
1214   function getOracles() external view returns (address[] memory) {
1215     return oracleAddresses;
1216   }
1217 
1218   /**
1219    * @notice get the most recently reported answer
1220    *
1221    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
1222    * answer has been reached, it will simply return 0. Either wait to point to
1223    * an already answered Aggregator or use the recommended latestRoundData
1224    * instead which includes better verification information.
1225    */
1226   function latestAnswer()
1227     public
1228     view
1229     virtual
1230     override
1231     returns (int256)
1232   {
1233     return rounds[latestRoundId].answer;
1234   }
1235 
1236   /**
1237    * @notice get the most recent updated at timestamp
1238    *
1239    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
1240    * answer has been reached, it will simply return 0. Either wait to point to
1241    * an already answered Aggregator or use the recommended latestRoundData
1242    * instead which includes better verification information.
1243    */
1244   function latestTimestamp()
1245     public
1246     view
1247     virtual
1248     override
1249     returns (uint256)
1250   {
1251     return rounds[latestRoundId].updatedAt;
1252   }
1253 
1254   /**
1255    * @notice get the ID of the last updated round
1256    *
1257    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
1258    * answer has been reached, it will simply return 0. Either wait to point to
1259    * an already answered Aggregator or use the recommended latestRoundData
1260    * instead which includes better verification information.
1261    */
1262   function latestRound()
1263     public
1264     view
1265     virtual
1266     override
1267     returns (uint256)
1268   {
1269     return latestRoundId;
1270   }
1271 
1272   /**
1273    * @notice get past rounds answers
1274    * @param _roundId the round number to retrieve the answer for
1275    *
1276    * @dev #[deprecated] Use getRoundData instead. This does not error if no
1277    * answer has been reached, it will simply return 0. Either wait to point to
1278    * an already answered Aggregator or use the recommended getRoundData
1279    * instead which includes better verification information.
1280    */
1281   function getAnswer(uint256 _roundId)
1282     public
1283     view
1284     virtual
1285     override
1286     returns (int256)
1287   {
1288     if (validRoundId(_roundId)) {
1289       return rounds[uint32(_roundId)].answer;
1290     }
1291     return 0;
1292   }
1293 
1294   /**
1295    * @notice get timestamp when an answer was last updated
1296    * @param _roundId the round number to retrieve the updated timestamp for
1297    *
1298    * @dev #[deprecated] Use getRoundData instead. This does not error if no
1299    * answer has been reached, it will simply return 0. Either wait to point to
1300    * an already answered Aggregator or use the recommended getRoundData
1301    * instead which includes better verification information.
1302    */
1303   function getTimestamp(uint256 _roundId)
1304     public
1305     view
1306     virtual
1307     override
1308     returns (uint256)
1309   {
1310     if (validRoundId(_roundId)) {
1311       return rounds[uint32(_roundId)].updatedAt;
1312     }
1313     return 0;
1314   }
1315 
1316   /**
1317    * @notice get data about a round. Consumers are encouraged to check
1318    * that they're receiving fresh data by inspecting the updatedAt and
1319    * answeredInRound return values.
1320    * @param _roundId the round ID to retrieve the round data for
1321    * @return roundId is the round ID for which data was retrieved
1322    * @return answer is the answer for the given round
1323    * @return startedAt is the timestamp when the round was started. This is 0
1324    * if the round hasn't been started yet.
1325    * @return updatedAt is the timestamp when the round last was updated (i.e.
1326    * answer was last computed)
1327    * @return answeredInRound is the round ID of the round in which the answer
1328    * was computed. answeredInRound may be smaller than roundId when the round
1329    * timed out. answeredInRound is equal to roundId when the round didn't time out
1330    * and was completed regularly.
1331    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet received
1332    * maxSubmissions) answer and updatedAt may change between queries.
1333    */
1334   function getRoundData(uint80 _roundId)
1335     public
1336     view
1337     virtual
1338     override
1339     returns (
1340       uint80 roundId,
1341       int256 answer,
1342       uint256 startedAt,
1343       uint256 updatedAt,
1344       uint80 answeredInRound
1345     )
1346   {
1347     Round memory r = rounds[uint32(_roundId)];
1348 
1349     require(r.answeredInRound > 0 && validRoundId(_roundId), V3_NO_DATA_ERROR);
1350 
1351     return (
1352       _roundId,
1353       r.answer,
1354       r.startedAt,
1355       r.updatedAt,
1356       r.answeredInRound
1357     );
1358   }
1359 
1360   /**
1361    * @notice get data about the latest round. Consumers are encouraged to check
1362    * that they're receiving fresh data by inspecting the updatedAt and
1363    * answeredInRound return values. Consumers are encouraged to
1364    * use this more fully featured method over the "legacy" latestRound/
1365    * latestAnswer/latestTimestamp functions. Consumers are encouraged to check
1366    * that they're receiving fresh data by inspecting the updatedAt and
1367    * answeredInRound return values.
1368    * @return roundId is the round ID for which data was retrieved
1369    * @return answer is the answer for the given round
1370    * @return startedAt is the timestamp when the round was started. This is 0
1371    * if the round hasn't been started yet.
1372    * @return updatedAt is the timestamp when the round last was updated (i.e.
1373    * answer was last computed)
1374    * @return answeredInRound is the round ID of the round in which the answer
1375    * was computed. answeredInRound may be smaller than roundId when the round
1376    * timed out. answeredInRound is equal to roundId when the round didn't time
1377    * out and was completed regularly.
1378    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet
1379    * received maxSubmissions) answer and updatedAt may change between queries.
1380    */
1381    function latestRoundData()
1382     public
1383     view
1384     virtual
1385     override
1386     returns (
1387       uint80 roundId,
1388       int256 answer,
1389       uint256 startedAt,
1390       uint256 updatedAt,
1391       uint80 answeredInRound
1392     )
1393   {
1394     return getRoundData(latestRoundId);
1395   }
1396 
1397 
1398   /**
1399    * @notice query the available amount of LINK for an oracle to withdraw
1400    */
1401   function withdrawablePayment(address _oracle)
1402     external
1403     view
1404     returns (uint256)
1405   {
1406     return oracles[_oracle].withdrawable;
1407   }
1408 
1409   /**
1410    * @notice transfers the oracle's LINK to another address. Can only be called
1411    * by the oracle's admin.
1412    * @param _oracle is the oracle whose LINK is transferred
1413    * @param _recipient is the address to send the LINK to
1414    * @param _amount is the amount of LINK to send
1415    */
1416   function withdrawPayment(address _oracle, address _recipient, uint256 _amount)
1417     external
1418   {
1419     require(oracles[_oracle].admin == msg.sender, "only callable by admin");
1420 
1421     // Safe to downcast _amount because the total amount of LINK is less than 2^128.
1422     uint128 amount = uint128(_amount);
1423     uint128 available = oracles[_oracle].withdrawable;
1424     require(available >= amount, "insufficient withdrawable funds");
1425 
1426     oracles[_oracle].withdrawable = available.sub(amount);
1427     recordedFunds.allocated = recordedFunds.allocated.sub(amount);
1428 
1429     assert(linkToken.transfer(_recipient, uint256(amount)));
1430   }
1431 
1432   /**
1433    * @notice transfers the owner's LINK to another address
1434    * @param _recipient is the address to send the LINK to
1435    * @param _amount is the amount of LINK to send
1436    */
1437   function withdrawFunds(address _recipient, uint256 _amount)
1438     external
1439     onlyOwner()
1440   {
1441     uint256 available = uint256(recordedFunds.available);
1442     require(available.sub(requiredReserve(paymentAmount)) >= _amount, "insufficient reserve funds");
1443     require(linkToken.transfer(_recipient, _amount), "token transfer failed");
1444     updateAvailableFunds();
1445   }
1446 
1447   /**
1448    * @notice get the admin address of an oracle
1449    * @param _oracle is the address of the oracle whose admin is being queried
1450    */
1451   function getAdmin(address _oracle)
1452     external
1453     view
1454     returns (address)
1455   {
1456     return oracles[_oracle].admin;
1457   }
1458 
1459   /**
1460    * @notice transfer the admin address for an oracle
1461    * @param _oracle is the address of the oracle whose admin is being transferred
1462    * @param _newAdmin is the new admin address
1463    */
1464   function transferAdmin(address _oracle, address _newAdmin)
1465     external
1466   {
1467     require(oracles[_oracle].admin == msg.sender, "only callable by admin");
1468     oracles[_oracle].pendingAdmin = _newAdmin;
1469 
1470     emit OracleAdminUpdateRequested(_oracle, msg.sender, _newAdmin);
1471   }
1472 
1473   /**
1474    * @notice accept the admin address transfer for an oracle
1475    * @param _oracle is the address of the oracle whose admin is being transferred
1476    */
1477   function acceptAdmin(address _oracle)
1478     external
1479   {
1480     require(oracles[_oracle].pendingAdmin == msg.sender, "only callable by pending admin");
1481     oracles[_oracle].pendingAdmin = address(0);
1482     oracles[_oracle].admin = msg.sender;
1483 
1484     emit OracleAdminUpdated(_oracle, msg.sender);
1485   }
1486 
1487   /**
1488    * @notice allows non-oracles to request a new round
1489    */
1490   function requestNewRound()
1491     external
1492     returns (uint80)
1493   {
1494     require(requesters[msg.sender].authorized, "not authorized requester");
1495 
1496     uint32 current = reportingRoundId;
1497     require(rounds[current].updatedAt > 0 || timedOut(current), "prev round must be supersedable");
1498 
1499     uint32 newRoundId = current.add(1);
1500     requesterInitializeNewRound(newRoundId);
1501     return newRoundId;
1502   }
1503 
1504   /**
1505    * @notice allows the owner to specify new non-oracles to start new rounds
1506    * @param _requester is the address to set permissions for
1507    * @param _authorized is a boolean specifying whether they can start new rounds or not
1508    * @param _delay is the number of rounds the requester must wait before starting another round
1509    */
1510   function setRequesterPermissions(address _requester, bool _authorized, uint32 _delay)
1511     external
1512     onlyOwner()
1513   {
1514     if (requesters[_requester].authorized == _authorized) return;
1515 
1516     if (_authorized) {
1517       requesters[_requester].authorized = _authorized;
1518       requesters[_requester].delay = _delay;
1519     } else {
1520       delete requesters[_requester];
1521     }
1522 
1523     emit RequesterPermissionsSet(_requester, _authorized, _delay);
1524   }
1525 
1526   /**
1527    * @notice called through LINK's transferAndCall to update available funds
1528    * in the same transaction as the funds were transferred to the aggregator
1529    * @param _data is mostly ignored. It is checked for length, to be sure
1530    * nothing strange is passed in.
1531    */
1532   function onTokenTransfer(address, uint256, bytes calldata _data)
1533     external
1534   {
1535     require(_data.length == 0, "transfer doesn't accept calldata");
1536     updateAvailableFunds();
1537   }
1538 
1539   /**
1540    * @notice a method to provide all current info oracles need. Intended only
1541    * only to be callable by oracles. Not for use by contracts to read state.
1542    * @param _oracle the address to look up information for.
1543    */
1544   function oracleRoundState(address _oracle, uint32 _queriedRoundId)
1545     external
1546     view
1547     returns (
1548       bool _eligibleToSubmit,
1549       uint32 _roundId,
1550       int256 _latestSubmission,
1551       uint64 _startedAt,
1552       uint64 _timeout,
1553       uint128 _availableFunds,
1554       uint8 _oracleCount,
1555       uint128 _paymentAmount
1556     )
1557   {
1558     require(msg.sender == tx.origin, "off-chain reading only");
1559 
1560     if (_queriedRoundId > 0) {
1561       Round storage round = rounds[_queriedRoundId];
1562       RoundDetails storage details = details[_queriedRoundId];
1563       return (
1564         eligibleForSpecificRound(_oracle, _queriedRoundId),
1565         _queriedRoundId,
1566         oracles[_oracle].latestSubmission,
1567         round.startedAt,
1568         details.timeout,
1569         recordedFunds.available,
1570         oracleCount(),
1571         (round.startedAt > 0 ? details.paymentAmount : paymentAmount)
1572       );
1573     } else {
1574       return oracleRoundStateSuggestRound(_oracle);
1575     }
1576   }
1577 
1578   /**
1579    * @notice method to update the address which does external data validation.
1580    * @param _newValidator designates the address of the new validation contract.
1581    */
1582   function setValidator(address _newValidator)
1583     public
1584     onlyOwner()
1585   {
1586     address previous = address(validator);
1587 
1588     if (previous != _newValidator) {
1589       validator = AggregatorValidatorInterface(_newValidator);
1590 
1591       emit ValidatorUpdated(previous, _newValidator);
1592     }
1593   }
1594 
1595 
1596   /**
1597    * Private
1598    */
1599 
1600   function initializeNewRound(uint32 _roundId)
1601     private
1602   {
1603     updateTimedOutRoundInfo(_roundId.sub(1));
1604 
1605     reportingRoundId = _roundId;
1606     RoundDetails memory nextDetails = RoundDetails(
1607       new int256[](0),
1608       maxSubmissionCount,
1609       minSubmissionCount,
1610       timeout,
1611       paymentAmount
1612     );
1613     details[_roundId] = nextDetails;
1614     rounds[_roundId].startedAt = uint64(block.timestamp);
1615 
1616     emit NewRound(_roundId, msg.sender, rounds[_roundId].startedAt);
1617   }
1618 
1619   function oracleInitializeNewRound(uint32 _roundId)
1620     private
1621   {
1622     if (!newRound(_roundId)) return;
1623     uint256 lastStarted = oracles[msg.sender].lastStartedRound; // cache storage reads
1624     if (_roundId <= lastStarted + restartDelay && lastStarted != 0) return;
1625 
1626     initializeNewRound(_roundId);
1627 
1628     oracles[msg.sender].lastStartedRound = _roundId;
1629   }
1630 
1631   function requesterInitializeNewRound(uint32 _roundId)
1632     private
1633   {
1634     if (!newRound(_roundId)) return;
1635     uint256 lastStarted = requesters[msg.sender].lastStartedRound; // cache storage reads
1636     require(_roundId > lastStarted + requesters[msg.sender].delay || lastStarted == 0, "must delay requests");
1637 
1638     initializeNewRound(_roundId);
1639 
1640     requesters[msg.sender].lastStartedRound = _roundId;
1641   }
1642 
1643   function updateTimedOutRoundInfo(uint32 _roundId)
1644     private
1645   {
1646     if (!timedOut(_roundId)) return;
1647 
1648     uint32 prevId = _roundId.sub(1);
1649     rounds[_roundId].answer = rounds[prevId].answer;
1650     rounds[_roundId].answeredInRound = rounds[prevId].answeredInRound;
1651     rounds[_roundId].updatedAt = uint64(block.timestamp);
1652 
1653     delete details[_roundId];
1654   }
1655 
1656   function eligibleForSpecificRound(address _oracle, uint32 _queriedRoundId)
1657     private
1658     view
1659     returns (bool _eligible)
1660   {
1661     if (rounds[_queriedRoundId].startedAt > 0) {
1662       return acceptingSubmissions(_queriedRoundId) && validateOracleRound(_oracle, _queriedRoundId).length == 0;
1663     } else {
1664       return delayed(_oracle, _queriedRoundId) && validateOracleRound(_oracle, _queriedRoundId).length == 0;
1665     }
1666   }
1667 
1668   function oracleRoundStateSuggestRound(address _oracle)
1669     private
1670     view
1671     returns (
1672       bool _eligibleToSubmit,
1673       uint32 _roundId,
1674       int256 _latestSubmission,
1675       uint64 _startedAt,
1676       uint64 _timeout,
1677       uint128 _availableFunds,
1678       uint8 _oracleCount,
1679       uint128 _paymentAmount
1680     )
1681   {
1682     Round storage round = rounds[0];
1683     OracleStatus storage oracle = oracles[_oracle];
1684 
1685     bool shouldSupersede = oracle.lastReportedRound == reportingRoundId || !acceptingSubmissions(reportingRoundId);
1686     // Instead of nudging oracles to submit to the next round, the inclusion of
1687     // the shouldSupersede bool in the if condition pushes them towards
1688     // submitting in a currently open round.
1689     if (supersedable(reportingRoundId) && shouldSupersede) {
1690       _roundId = reportingRoundId.add(1);
1691       round = rounds[_roundId];
1692 
1693       _paymentAmount = paymentAmount;
1694       _eligibleToSubmit = delayed(_oracle, _roundId);
1695     } else {
1696       _roundId = reportingRoundId;
1697       round = rounds[_roundId];
1698 
1699       _paymentAmount = details[_roundId].paymentAmount;
1700       _eligibleToSubmit = acceptingSubmissions(_roundId);
1701     }
1702 
1703     if (validateOracleRound(_oracle, _roundId).length != 0) {
1704       _eligibleToSubmit = false;
1705     }
1706 
1707     return (
1708       _eligibleToSubmit,
1709       _roundId,
1710       oracle.latestSubmission,
1711       round.startedAt,
1712       details[_roundId].timeout,
1713       recordedFunds.available,
1714       oracleCount(),
1715       _paymentAmount
1716     );
1717   }
1718 
1719   function updateRoundAnswer(uint32 _roundId)
1720     internal
1721     returns (bool, int256)
1722   {
1723     if (details[_roundId].submissions.length < details[_roundId].minSubmissions) {
1724       return (false, 0);
1725     }
1726 
1727     int256 newAnswer = Median.calculateInplace(details[_roundId].submissions);
1728     rounds[_roundId].answer = newAnswer;
1729     rounds[_roundId].updatedAt = uint64(block.timestamp);
1730     rounds[_roundId].answeredInRound = _roundId;
1731     latestRoundId = _roundId;
1732 
1733     emit AnswerUpdated(newAnswer, _roundId, now);
1734 
1735     return (true, newAnswer);
1736   }
1737 
1738   function validateAnswer(
1739     uint32 _roundId,
1740     int256 _newAnswer
1741   )
1742     private
1743   {
1744     AggregatorValidatorInterface av = validator; // cache storage reads
1745     if (address(av) == address(0)) return;
1746 
1747     uint32 prevRound = _roundId.sub(1);
1748     uint32 prevAnswerRoundId = rounds[prevRound].answeredInRound;
1749     int256 prevRoundAnswer = rounds[prevRound].answer;
1750     // We do not want the validator to ever prevent reporting, so we limit its
1751     // gas usage and catch any errors that may arise.
1752     try av.validate{gas: VALIDATOR_GAS_LIMIT}(
1753       prevAnswerRoundId,
1754       prevRoundAnswer,
1755       _roundId,
1756       _newAnswer
1757     ) {} catch {}
1758   }
1759 
1760   function payOracle(uint32 _roundId)
1761     private
1762   {
1763     uint128 payment = details[_roundId].paymentAmount;
1764     Funds memory funds = recordedFunds;
1765     funds.available = funds.available.sub(payment);
1766     funds.allocated = funds.allocated.add(payment);
1767     recordedFunds = funds;
1768     oracles[msg.sender].withdrawable = oracles[msg.sender].withdrawable.add(payment);
1769 
1770     emit AvailableFundsUpdated(funds.available);
1771   }
1772 
1773   function recordSubmission(int256 _submission, uint32 _roundId)
1774     private
1775   {
1776     require(acceptingSubmissions(_roundId), "round not accepting submissions");
1777 
1778     details[_roundId].submissions.push(_submission);
1779     oracles[msg.sender].lastReportedRound = _roundId;
1780     oracles[msg.sender].latestSubmission = _submission;
1781 
1782     emit SubmissionReceived(_submission, _roundId, msg.sender);
1783   }
1784 
1785   function deleteRoundDetails(uint32 _roundId)
1786     private
1787   {
1788     if (details[_roundId].submissions.length < details[_roundId].maxSubmissions) return;
1789 
1790     delete details[_roundId];
1791   }
1792 
1793   function timedOut(uint32 _roundId)
1794     private
1795     view
1796     returns (bool)
1797   {
1798     uint64 startedAt = rounds[_roundId].startedAt;
1799     uint32 roundTimeout = details[_roundId].timeout;
1800     return startedAt > 0 && roundTimeout > 0 && startedAt.add(roundTimeout) < block.timestamp;
1801   }
1802 
1803   function getStartingRound(address _oracle)
1804     private
1805     view
1806     returns (uint32)
1807   {
1808     uint32 currentRound = reportingRoundId;
1809     if (currentRound != 0 && currentRound == oracles[_oracle].endingRound) {
1810       return currentRound;
1811     }
1812     return currentRound.add(1);
1813   }
1814 
1815   function previousAndCurrentUnanswered(uint32 _roundId, uint32 _rrId)
1816     private
1817     view
1818     returns (bool)
1819   {
1820     return _roundId.add(1) == _rrId && rounds[_rrId].updatedAt == 0;
1821   }
1822 
1823   function requiredReserve(uint256 payment)
1824     private
1825     view
1826     returns (uint256)
1827   {
1828     return payment.mul(oracleCount()).mul(RESERVE_ROUNDS);
1829   }
1830 
1831   function addOracle(
1832     address _oracle,
1833     address _admin
1834   )
1835     private
1836   {
1837     require(!oracleEnabled(_oracle), "oracle already enabled");
1838 
1839     require(_admin != address(0), "cannot set admin to 0");
1840     require(oracles[_oracle].admin == address(0) || oracles[_oracle].admin == _admin, "owner cannot overwrite admin");
1841 
1842     oracles[_oracle].startingRound = getStartingRound(_oracle);
1843     oracles[_oracle].endingRound = ROUND_MAX;
1844     oracles[_oracle].index = uint16(oracleAddresses.length);
1845     oracleAddresses.push(_oracle);
1846     oracles[_oracle].admin = _admin;
1847 
1848     emit OraclePermissionsUpdated(_oracle, true);
1849     emit OracleAdminUpdated(_oracle, _admin);
1850   }
1851 
1852   function removeOracle(
1853     address _oracle
1854   )
1855     private
1856   {
1857     require(oracleEnabled(_oracle), "oracle not enabled");
1858 
1859     oracles[_oracle].endingRound = reportingRoundId.add(1);
1860     address tail = oracleAddresses[uint256(oracleCount()).sub(1)];
1861     uint16 index = oracles[_oracle].index;
1862     oracles[tail].index = index;
1863     delete oracles[_oracle].index;
1864     oracleAddresses[index] = tail;
1865     oracleAddresses.pop();
1866 
1867     emit OraclePermissionsUpdated(_oracle, false);
1868   }
1869 
1870   function validateOracleRound(address _oracle, uint32 _roundId)
1871     private
1872     view
1873     returns (bytes memory)
1874   {
1875     // cache storage reads
1876     uint32 startingRound = oracles[_oracle].startingRound;
1877     uint32 rrId = reportingRoundId;
1878 
1879     if (startingRound == 0) return "not enabled oracle";
1880     if (startingRound > _roundId) return "not yet enabled oracle";
1881     if (oracles[_oracle].endingRound < _roundId) return "no longer allowed oracle";
1882     if (oracles[_oracle].lastReportedRound >= _roundId) return "cannot report on previous rounds";
1883     if (_roundId != rrId && _roundId != rrId.add(1) && !previousAndCurrentUnanswered(_roundId, rrId)) return "invalid round to report";
1884     if (_roundId != 1 && !supersedable(_roundId.sub(1))) return "previous round not supersedable";
1885   }
1886 
1887   function supersedable(uint32 _roundId)
1888     private
1889     view
1890     returns (bool)
1891   {
1892     return rounds[_roundId].updatedAt > 0 || timedOut(_roundId);
1893   }
1894 
1895   function oracleEnabled(address _oracle)
1896     private
1897     view
1898     returns (bool)
1899   {
1900     return oracles[_oracle].endingRound == ROUND_MAX;
1901   }
1902 
1903   function acceptingSubmissions(uint32 _roundId)
1904     private
1905     view
1906     returns (bool)
1907   {
1908     return details[_roundId].maxSubmissions != 0;
1909   }
1910 
1911   function delayed(address _oracle, uint32 _roundId)
1912     private
1913     view
1914     returns (bool)
1915   {
1916     uint256 lastStarted = oracles[_oracle].lastStartedRound;
1917     return _roundId > lastStarted + restartDelay || lastStarted == 0;
1918   }
1919 
1920   function newRound(uint32 _roundId)
1921     private
1922     view
1923     returns (bool)
1924   {
1925     return _roundId == reportingRoundId.add(1);
1926   }
1927 
1928   function validRoundId(uint256 _roundId)
1929     private
1930     view
1931     returns (bool)
1932   {
1933     return _roundId <= ROUND_MAX;
1934   }
1935 
1936 }
1937 
1938 // SPDX-License-Identifier: MIT
1939 interface AccessControllerInterface {
1940   function hasAccess(address user, bytes calldata data) external view returns (bool);
1941 }
1942 
1943 // SPDX-License-Identifier: MIT
1944 /**
1945  * @title SimpleWriteAccessController
1946  * @notice Gives access to accounts explicitly added to an access list by the
1947  * controller's owner.
1948  * @dev does not make any special permissions for externally, see
1949  * SimpleReadAccessController for that.
1950  */
1951 contract SimpleWriteAccessController is AccessControllerInterface, Owned {
1952 
1953   bool public checkEnabled;
1954   mapping(address => bool) internal accessList;
1955 
1956   event AddedAccess(address user);
1957   event RemovedAccess(address user);
1958   event CheckAccessEnabled();
1959   event CheckAccessDisabled();
1960 
1961   constructor()
1962     public
1963   {
1964     checkEnabled = true;
1965   }
1966 
1967   /**
1968    * @notice Returns the access of an address
1969    * @param _user The address to query
1970    */
1971   function hasAccess(
1972     address _user,
1973     bytes memory
1974   )
1975     public
1976     view
1977     virtual
1978     override
1979     returns (bool)
1980   {
1981     return accessList[_user] || !checkEnabled;
1982   }
1983 
1984   /**
1985    * @notice Adds an address to the access list
1986    * @param _user The address to add
1987    */
1988   function addAccess(address _user)
1989     external
1990     onlyOwner()
1991   {
1992     if (!accessList[_user]) {
1993       accessList[_user] = true;
1994 
1995       emit AddedAccess(_user);
1996     }
1997   }
1998 
1999   /**
2000    * @notice Removes an address from the access list
2001    * @param _user The address to remove
2002    */
2003   function removeAccess(address _user)
2004     external
2005     onlyOwner()
2006   {
2007     if (accessList[_user]) {
2008       accessList[_user] = false;
2009 
2010       emit RemovedAccess(_user);
2011     }
2012   }
2013 
2014   /**
2015    * @notice makes the access check enforced
2016    */
2017   function enableAccessCheck()
2018     external
2019     onlyOwner()
2020   {
2021     if (!checkEnabled) {
2022       checkEnabled = true;
2023 
2024       emit CheckAccessEnabled();
2025     }
2026   }
2027 
2028   /**
2029    * @notice makes the access check unenforced
2030    */
2031   function disableAccessCheck()
2032     external
2033     onlyOwner()
2034   {
2035     if (checkEnabled) {
2036       checkEnabled = false;
2037 
2038       emit CheckAccessDisabled();
2039     }
2040   }
2041 
2042   /**
2043    * @dev reverts if the caller does not have access
2044    */
2045   modifier checkAccess() {
2046     require(hasAccess(msg.sender, msg.data), "No access");
2047     _;
2048   }
2049 }
2050 
2051 // SPDX-License-Identifier: MIT
2052 /**
2053  * @title SimpleReadAccessController
2054  * @notice Gives access to:
2055  * - any externally owned account (note that offchain actors can always read
2056  * any contract storage regardless of onchain access control measures, so this
2057  * does not weaken the access control while improving usability)
2058  * - accounts explicitly added to an access list
2059  * @dev SimpleReadAccessController is not suitable for access controlling writes
2060  * since it grants any externally owned account access! See
2061  * SimpleWriteAccessController for that.
2062  */
2063 contract SimpleReadAccessController is SimpleWriteAccessController {
2064 
2065   /**
2066    * @notice Returns the access of an address
2067    * @param _user The address to query
2068    */
2069   function hasAccess(
2070     address _user,
2071     bytes memory _calldata
2072   )
2073     public
2074     view
2075     virtual
2076     override
2077     returns (bool)
2078   {
2079     return super.hasAccess(_user, _calldata) || _user == tx.origin;
2080   }
2081 
2082 }
2083 
2084 // SPDX-License-Identifier: MIT
2085 /**
2086  * @title AccessControlled FluxAggregator contract
2087  * @notice This contract requires addresses to be added to a controller
2088  * in order to read the answers stored in the FluxAggregator contract
2089  */
2090 contract AccessControlledAggregator is FluxAggregator, SimpleReadAccessController {
2091 
2092   /**
2093    * @notice set up the aggregator with initial configuration
2094    * @param _link The address of the LINK token
2095    * @param _paymentAmount The amount paid of LINK paid to each oracle per submission, in wei (units of 10⁻¹⁸ LINK)
2096    * @param _timeout is the number of seconds after the previous round that are
2097    * allowed to lapse before allowing an oracle to skip an unfinished round
2098    * @param _validator is an optional contract address for validating
2099    * external validation of answers
2100    * @param _minSubmissionValue is an immutable check for a lower bound of what
2101    * submission values are accepted from an oracle
2102    * @param _maxSubmissionValue is an immutable check for an upper bound of what
2103    * submission values are accepted from an oracle
2104    * @param _decimals represents the number of decimals to offset the answer by
2105    * @param _description a short description of what is being reported
2106    */
2107   constructor(
2108     address _link,
2109     uint128 _paymentAmount,
2110     uint32 _timeout,
2111     address _validator,
2112     int256 _minSubmissionValue,
2113     int256 _maxSubmissionValue,
2114     uint8 _decimals,
2115     string memory _description
2116   ) public FluxAggregator(
2117     _link,
2118     _paymentAmount,
2119     _timeout,
2120     _validator,
2121     _minSubmissionValue,
2122     _maxSubmissionValue,
2123     _decimals,
2124     _description
2125   ){}
2126 
2127   /**
2128    * @notice get data about a round. Consumers are encouraged to check
2129    * that they're receiving fresh data by inspecting the updatedAt and
2130    * answeredInRound return values.
2131    * @param _roundId the round ID to retrieve the round data for
2132    * @return roundId is the round ID for which data was retrieved
2133    * @return answer is the answer for the given round
2134    * @return startedAt is the timestamp when the round was started. This is 0
2135    * if the round hasn't been started yet.
2136    * @return updatedAt is the timestamp when the round last was updated (i.e.
2137    * answer was last computed)
2138    * @return answeredInRound is the round ID of the round in which the answer
2139    * was computed. answeredInRound may be smaller than roundId when the round
2140    * timed out. answerInRound is equal to roundId when the round didn't time out
2141    * and was completed regularly.
2142    * @dev overridden funcion to add the checkAccess() modifier
2143    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet
2144    * received maxSubmissions) answer and updatedAt may change between queries.
2145    */
2146   function getRoundData(uint80 _roundId)
2147     public
2148     view
2149     override
2150     checkAccess()
2151     returns (
2152       uint80 roundId,
2153       int256 answer,
2154       uint256 startedAt,
2155       uint256 updatedAt,
2156       uint80 answeredInRound
2157     )
2158   {
2159     return super.getRoundData(_roundId);
2160   }
2161 
2162   /**
2163    * @notice get data about the latest round. Consumers are encouraged to check
2164    * that they're receiving fresh data by inspecting the updatedAt and
2165    * answeredInRound return values. Consumers are encouraged to
2166    * use this more fully featured method over the "legacy" latestAnswer
2167    * functions. Consumers are encouraged to check that they're receiving fresh
2168    * data by inspecting the updatedAt and answeredInRound return values.
2169    * @return roundId is the round ID for which data was retrieved
2170    * @return answer is the answer for the given round
2171    * @return startedAt is the timestamp when the round was started. This is 0
2172    * if the round hasn't been started yet.
2173    * @return updatedAt is the timestamp when the round last was updated (i.e.
2174    * answer was last computed)
2175    * @return answeredInRound is the round ID of the round in which the answer
2176    * was computed. answeredInRound may be smaller than roundId when the round
2177    * timed out. answerInRound is equal to roundId when the round didn't time out
2178    * and was completed regularly.
2179    * @dev overridden funcion to add the checkAccess() modifier
2180    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet
2181    * received maxSubmissions) answer and updatedAt may change between queries.
2182    */
2183   function latestRoundData()
2184     public
2185     view
2186     override
2187     checkAccess()
2188     returns (
2189       uint80 roundId,
2190       int256 answer,
2191       uint256 startedAt,
2192       uint256 updatedAt,
2193       uint80 answeredInRound
2194     )
2195   {
2196     return super.latestRoundData();
2197   }
2198 
2199   /**
2200    * @notice get the most recently reported answer
2201    * @dev overridden funcion to add the checkAccess() modifier
2202    *
2203    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
2204    * answer has been reached, it will simply return 0. Either wait to point to
2205    * an already answered Aggregator or use the recommended latestRoundData
2206    * instead which includes better verification information.
2207    */
2208   function latestAnswer()
2209     public
2210     view
2211     override
2212     checkAccess()
2213     returns (int256)
2214   {
2215     return super.latestAnswer();
2216   }
2217 
2218   /**
2219    * @notice get the most recently reported round ID
2220    * @dev overridden funcion to add the checkAccess() modifier
2221    *
2222    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
2223    * answer has been reached, it will simply return 0. Either wait to point to
2224    * an already answered Aggregator or use the recommended latestRoundData
2225    * instead which includes better verification information.
2226    */
2227   function latestRound()
2228     public
2229     view
2230     override
2231     checkAccess()
2232     returns (uint256)
2233   {
2234     return super.latestRound();
2235   }
2236 
2237   /**
2238    * @notice get the most recent updated at timestamp
2239    * @dev overridden funcion to add the checkAccess() modifier
2240    *
2241    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
2242    * answer has been reached, it will simply return 0. Either wait to point to
2243    * an already answered Aggregator or use the recommended latestRoundData
2244    * instead which includes better verification information.
2245    */
2246   function latestTimestamp()
2247     public
2248     view
2249     override
2250     checkAccess()
2251     returns (uint256)
2252   {
2253     return super.latestTimestamp();
2254   }
2255 
2256   /**
2257    * @notice get past rounds answers
2258    * @dev overridden funcion to add the checkAccess() modifier
2259    * @param _roundId the round number to retrieve the answer for
2260    *
2261    * @dev #[deprecated] Use getRoundData instead. This does not error if no
2262    * answer has been reached, it will simply return 0. Either wait to point to
2263    * an already answered Aggregator or use the recommended getRoundData
2264    * instead which includes better verification information.
2265    */
2266   function getAnswer(uint256 _roundId)
2267     public
2268     view
2269     override
2270     checkAccess()
2271     returns (int256)
2272   {
2273     return super.getAnswer(_roundId);
2274   }
2275 
2276   /**
2277    * @notice get timestamp when an answer was last updated
2278    * @dev overridden funcion to add the checkAccess() modifier
2279    * @param _roundId the round number to retrieve the updated timestamp for
2280    *
2281    * @dev #[deprecated] Use getRoundData instead. This does not error if no
2282    * answer has been reached, it will simply return 0. Either wait to point to
2283    * an already answered Aggregator or use the recommended getRoundData
2284    * instead which includes better verification information.
2285    */
2286   function getTimestamp(uint256 _roundId)
2287     public
2288     view
2289     override
2290     checkAccess()
2291     returns (uint256)
2292   {
2293     return super.getTimestamp(_roundId);
2294   }
2295 
2296 }