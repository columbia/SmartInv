1 pragma solidity 0.6.6;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18   /**
19     * @dev Returns the addition of two unsigned integers, reverting on
20     * overflow.
21     *
22     * Counterpart to Solidity's `+` operator.
23     *
24     * Requirements:
25     * - Addition cannot overflow.
26     */
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     require(c >= a, "SafeMath: addition overflow");
30 
31     return c;
32   }
33 
34   /**
35     * @dev Returns the subtraction of two unsigned integers, reverting on
36     * overflow (when the result is negative).
37     *
38     * Counterpart to Solidity's `-` operator.
39     *
40     * Requirements:
41     * - Subtraction cannot overflow.
42     */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     require(b <= a, "SafeMath: subtraction overflow");
45     uint256 c = a - b;
46 
47     return c;
48   }
49 
50   /**
51     * @dev Returns the multiplication of two unsigned integers, reverting on
52     * overflow.
53     *
54     * Counterpart to Solidity's `*` operator.
55     *
56     * Requirements:
57     * - Multiplication cannot overflow.
58     */
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61     // benefit is lost if 'b' is also tested.
62     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63     if (a == 0) {
64       return 0;
65     }
66 
67     uint256 c = a * b;
68     require(c / a == b, "SafeMath: multiplication overflow");
69 
70     return c;
71   }
72 
73   /**
74     * @dev Returns the integer division of two unsigned integers. Reverts on
75     * division by zero. The result is rounded towards zero.
76     *
77     * Counterpart to Solidity's `/` operator. Note: this function uses a
78     * `revert` opcode (which leaves remaining gas untouched) while Solidity
79     * uses an invalid opcode to revert (consuming all remaining gas).
80     *
81     * Requirements:
82     * - The divisor cannot be zero.
83     */
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // Solidity only automatically asserts when dividing by 0
86     require(b > 0, "SafeMath: division by zero");
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89 
90     return c;
91   }
92 
93   /**
94     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
95     * Reverts when dividing by zero.
96     *
97     * Counterpart to Solidity's `%` operator. This function uses a `revert`
98     * opcode (which leaves remaining gas untouched) while Solidity uses an
99     * invalid opcode to revert (consuming all remaining gas).
100     *
101     * Requirements:
102     * - The divisor cannot be zero.
103     */
104   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b != 0, "SafeMath: modulo by zero");
106     return a % b;
107   }
108 }
109 
110 library SignedSafeMath {
111   int256 constant private _INT256_MIN = -2**255;
112 
113   /**
114    * @dev Multiplies two signed integers, reverts on overflow.
115    */
116   function mul(int256 a, int256 b) internal pure returns (int256) {
117     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118     // benefit is lost if 'b' is also tested.
119     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
120     if (a == 0) {
121       return 0;
122     }
123 
124     require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
125 
126     int256 c = a * b;
127     require(c / a == b, "SignedSafeMath: multiplication overflow");
128 
129     return c;
130   }
131 
132   /**
133    * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
134    */
135   function div(int256 a, int256 b) internal pure returns (int256) {
136     require(b != 0, "SignedSafeMath: division by zero");
137     require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
138 
139     int256 c = a / b;
140 
141     return c;
142   }
143 
144   /**
145    * @dev Subtracts two signed integers, reverts on overflow.
146    */
147   function sub(int256 a, int256 b) internal pure returns (int256) {
148     int256 c = a - b;
149     require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
150 
151     return c;
152   }
153 
154   /**
155    * @dev Adds two signed integers, reverts on overflow.
156    */
157   function add(int256 a, int256 b) internal pure returns (int256) {
158     int256 c = a + b;
159     require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
160 
161     return c;
162   }
163 
164   /**
165    * @notice Computes average of two signed integers, ensuring that the computation
166    * doesn't overflow.
167    * @dev If the result is not an integer, it is rounded towards zero. For example,
168    * avg(-3, -4) = -3
169    */
170   function avg(int256 _a, int256 _b)
171     internal
172     pure
173     returns (int256)
174   {
175     if ((_a < 0 && _b > 0) || (_a > 0 && _b < 0)) {
176       return add(_a, _b) / 2;
177     }
178     int256 remainder = (_a % 2 + _b % 2) / 2;
179     return add(add(_a / 2, _b / 2), remainder);
180   }
181 }
182 
183 library Median {
184   using SignedSafeMath for int256;
185 
186   int256 constant INT_MAX = 2**255-1;
187 
188   /**
189    * @notice Returns the sorted middle, or the average of the two middle indexed items if the
190    * array has an even number of elements.
191    * @dev The list passed as an argument isn't modified.
192    * @dev This algorithm has expected runtime O(n), but for adversarially chosen inputs
193    * the runtime is O(n^2).
194    * @param list The list of elements to compare
195    */
196   function calculate(int256[] memory list)
197     internal
198     pure
199     returns (int256)
200   {
201     return calculateInplace(copy(list));
202   }
203 
204   /**
205    * @notice See documentation for function calculate.
206    * @dev The list passed as an argument may be permuted.
207    */
208   function calculateInplace(int256[] memory list)
209     internal
210     pure
211     returns (int256)
212   {
213     require(0 < list.length, "list must not be empty");
214     uint256 len = list.length;
215     uint256 middleIndex = len / 2;
216     if (len % 2 == 0) {
217       int256 median1;
218       int256 median2;
219       (median1, median2) = quickselectTwo(list, 0, len - 1, middleIndex - 1, middleIndex);
220       return SignedSafeMath.avg(median1, median2);
221     } else {
222       return quickselect(list, 0, len - 1, middleIndex);
223     }
224   }
225 
226   /**
227    * @notice Maximum length of list that shortSelectTwo can handle
228    */
229   uint256 constant SHORTSELECTTWO_MAX_LENGTH = 7;
230 
231   /**
232    * @notice Select the k1-th and k2-th element from list of length at most 7
233    * @dev Uses an optimal sorting network
234    */
235   function shortSelectTwo(
236     int256[] memory list,
237     uint256 lo,
238     uint256 hi,
239     uint256 k1,
240     uint256 k2
241   )
242     private
243     pure
244     returns (int256 k1th, int256 k2th)
245   {
246     // Uses an optimal sorting network (https://en.wikipedia.org/wiki/Sorting_network)
247     // for lists of length 7. Network layout is taken from
248     // http://jgamble.ripco.net/cgi-bin/nw.cgi?inputs=7&algorithm=hibbard&output=svg
249 
250     uint256 len = hi + 1 - lo;
251     int256 x0 = list[lo + 0];
252     int256 x1 = 1 < len ? list[lo + 1] : INT_MAX;
253     int256 x2 = 2 < len ? list[lo + 2] : INT_MAX;
254     int256 x3 = 3 < len ? list[lo + 3] : INT_MAX;
255     int256 x4 = 4 < len ? list[lo + 4] : INT_MAX;
256     int256 x5 = 5 < len ? list[lo + 5] : INT_MAX;
257     int256 x6 = 6 < len ? list[lo + 6] : INT_MAX;
258 
259     if (x0 > x1) {(x0, x1) = (x1, x0);}
260     if (x2 > x3) {(x2, x3) = (x3, x2);}
261     if (x4 > x5) {(x4, x5) = (x5, x4);}
262     if (x0 > x2) {(x0, x2) = (x2, x0);}
263     if (x1 > x3) {(x1, x3) = (x3, x1);}
264     if (x4 > x6) {(x4, x6) = (x6, x4);}
265     if (x1 > x2) {(x1, x2) = (x2, x1);}
266     if (x5 > x6) {(x5, x6) = (x6, x5);}
267     if (x0 > x4) {(x0, x4) = (x4, x0);}
268     if (x1 > x5) {(x1, x5) = (x5, x1);}
269     if (x2 > x6) {(x2, x6) = (x6, x2);}
270     if (x1 > x4) {(x1, x4) = (x4, x1);}
271     if (x3 > x6) {(x3, x6) = (x6, x3);}
272     if (x2 > x4) {(x2, x4) = (x4, x2);}
273     if (x3 > x5) {(x3, x5) = (x5, x3);}
274     if (x3 > x4) {(x3, x4) = (x4, x3);}
275 
276     uint256 index1 = k1 - lo;
277     if (index1 == 0) {k1th = x0;}
278     else if (index1 == 1) {k1th = x1;}
279     else if (index1 == 2) {k1th = x2;}
280     else if (index1 == 3) {k1th = x3;}
281     else if (index1 == 4) {k1th = x4;}
282     else if (index1 == 5) {k1th = x5;}
283     else if (index1 == 6) {k1th = x6;}
284     else {revert("k1 out of bounds");}
285 
286     uint256 index2 = k2 - lo;
287     if (k1 == k2) {return (k1th, k1th);}
288     else if (index2 == 0) {return (k1th, x0);}
289     else if (index2 == 1) {return (k1th, x1);}
290     else if (index2 == 2) {return (k1th, x2);}
291     else if (index2 == 3) {return (k1th, x3);}
292     else if (index2 == 4) {return (k1th, x4);}
293     else if (index2 == 5) {return (k1th, x5);}
294     else if (index2 == 6) {return (k1th, x6);}
295     else {revert("k2 out of bounds");}
296   }
297 
298   /**
299    * @notice Selects the k-th ranked element from list, looking only at indices between lo and hi
300    * (inclusive). Modifies list in-place.
301    */
302   function quickselect(int256[] memory list, uint256 lo, uint256 hi, uint256 k)
303     private
304     pure
305     returns (int256 kth)
306   {
307     require(lo <= k);
308     require(k <= hi);
309     while (lo < hi) {
310       if (hi - lo < SHORTSELECTTWO_MAX_LENGTH) {
311         int256 ignore;
312         (kth, ignore) = shortSelectTwo(list, lo, hi, k, k);
313         return kth;
314       }
315       uint256 pivotIndex = partition(list, lo, hi);
316       if (k <= pivotIndex) {
317         // since pivotIndex < (original hi passed to partition),
318         // termination is guaranteed in this case
319         hi = pivotIndex;
320       } else {
321         // since (original lo passed to partition) <= pivotIndex,
322         // termination is guaranteed in this case
323         lo = pivotIndex + 1;
324       }
325     }
326     return list[lo];
327   }
328 
329   /**
330    * @notice Selects the k1-th and k2-th ranked elements from list, looking only at indices between
331    * lo and hi (inclusive). Modifies list in-place.
332    */
333   function quickselectTwo(
334     int256[] memory list,
335     uint256 lo,
336     uint256 hi,
337     uint256 k1,
338     uint256 k2
339   )
340     internal // for testing
341     pure
342     returns (int256 k1th, int256 k2th)
343   {
344     require(k1 < k2);
345     require(lo <= k1 && k1 <= hi);
346     require(lo <= k2 && k2 <= hi);
347 
348     while (true) {
349       if (hi - lo < SHORTSELECTTWO_MAX_LENGTH) {
350         return shortSelectTwo(list, lo, hi, k1, k2);
351       }
352       uint256 pivotIdx = partition(list, lo, hi);
353       if (k2 <= pivotIdx) {
354         hi = pivotIdx;
355       } else if (pivotIdx < k1) {
356         lo = pivotIdx + 1;
357       } else {
358         assert(k1 <= pivotIdx && pivotIdx < k2);
359         k1th = quickselect(list, lo, pivotIdx, k1);
360         k2th = quickselect(list, pivotIdx + 1, hi, k2);
361         return (k1th, k2th);
362       }
363     }
364   }
365 
366   /**
367    * @notice Partitions list in-place using Hoare's partitioning scheme.
368    * Only elements of list between indices lo and hi (inclusive) will be modified.
369    * Returns an index i, such that:
370    * - lo <= i < hi
371    * - forall j in [lo, i]. list[j] <= list[i]
372    * - forall j in [i, hi]. list[i] <= list[j]
373    */
374   function partition(int256[] memory list, uint256 lo, uint256 hi)
375     private
376     pure
377     returns (uint256)
378   {
379     // We don't care about overflow of the addition, because it would require a list
380     // larger than any feasible computer's memory.
381     int256 pivot = list[(lo + hi) / 2];
382     lo -= 1; // this can underflow. that's intentional.
383     hi += 1;
384     while (true) {
385       do {
386         lo += 1;
387       } while (list[lo] < pivot);
388       do {
389         hi -= 1;
390       } while (list[hi] > pivot);
391       if (lo < hi) {
392         (list[lo], list[hi]) = (list[hi], list[lo]);
393       } else {
394         // Let orig_lo and orig_hi be the original values of lo and hi passed to partition.
395         // Then, hi < orig_hi, because hi decreases *strictly* monotonically
396         // in each loop iteration and
397         // - either list[orig_hi] > pivot, in which case the first loop iteration
398         //   will achieve hi < orig_hi;
399         // - or list[orig_hi] <= pivot, in which case at least two loop iterations are
400         //   needed:
401         //   - lo will have to stop at least once in the interval
402         //     [orig_lo, (orig_lo + orig_hi)/2]
403         //   - (orig_lo + orig_hi)/2 < orig_hi
404         return hi;
405       }
406     }
407   }
408 
409   /**
410    * @notice Makes an in-memory copy of the array passed in
411    * @param list Reference to the array to be copied
412    */
413   function copy(int256[] memory list)
414     private
415     pure
416     returns(int256[] memory)
417   {
418     int256[] memory list2 = new int256[](list.length);
419     for (uint256 i = 0; i < list.length; i++) {
420       list2[i] = list[i];
421     }
422     return list2;
423   }
424 }
425 
426 /**
427  * @title The Owned contract
428  * @notice A contract with helpers for basic contract ownership.
429  */
430 contract Owned {
431 
432   address public owner;
433   address private pendingOwner;
434 
435   event OwnershipTransferRequested(
436     address indexed from,
437     address indexed to
438   );
439   event OwnershipTransferred(
440     address indexed from,
441     address indexed to
442   );
443 
444   constructor() public {
445     owner = msg.sender;
446   }
447 
448   /**
449    * @dev Allows an owner to begin transferring ownership to a new address,
450    * pending.
451    */
452   function transferOwnership(address _to)
453     external
454     onlyOwner()
455   {
456     pendingOwner = _to;
457 
458     emit OwnershipTransferRequested(owner, _to);
459   }
460 
461   /**
462    * @dev Allows an ownership transfer to be completed by the recipient.
463    */
464   function acceptOwnership()
465     external
466   {
467     require(msg.sender == pendingOwner, "Must be proposed owner");
468 
469     address oldOwner = owner;
470     owner = msg.sender;
471     pendingOwner = address(0);
472 
473     emit OwnershipTransferred(oldOwner, msg.sender);
474   }
475 
476   /**
477    * @dev Reverts if called by anyone other than the contract owner.
478    */
479   modifier onlyOwner() {
480     require(msg.sender == owner, "Only callable by owner");
481     _;
482   }
483 
484 }
485 
486 /**
487  * @dev Wrappers over Solidity's arithmetic operations with added overflow
488  * checks.
489  *
490  * Arithmetic operations in Solidity wrap on overflow. This can easily result
491  * in bugs, because programmers usually assume that an overflow raises an
492  * error, which is the standard behavior in high level programming languages.
493  * `SafeMath` restores this intuition by reverting the transaction when an
494  * operation overflows.
495  *
496  * Using this library instead of the unchecked operations eliminates an entire
497  * class of bugs, so it's recommended to use it always.
498  *
499  * This library is a version of Open Zeppelin's SafeMath, modified to support
500  * unsigned 128 bit integers.
501  */
502 library SafeMath128 {
503   /**
504     * @dev Returns the addition of two unsigned integers, reverting on
505     * overflow.
506     *
507     * Counterpart to Solidity's `+` operator.
508     *
509     * Requirements:
510     * - Addition cannot overflow.
511     */
512   function add(uint128 a, uint128 b) internal pure returns (uint128) {
513     uint128 c = a + b;
514     require(c >= a, "SafeMath: addition overflow");
515 
516     return c;
517   }
518 
519   /**
520     * @dev Returns the subtraction of two unsigned integers, reverting on
521     * overflow (when the result is negative).
522     *
523     * Counterpart to Solidity's `-` operator.
524     *
525     * Requirements:
526     * - Subtraction cannot overflow.
527     */
528   function sub(uint128 a, uint128 b) internal pure returns (uint128) {
529     require(b <= a, "SafeMath: subtraction overflow");
530     uint128 c = a - b;
531 
532     return c;
533   }
534 
535   /**
536     * @dev Returns the multiplication of two unsigned integers, reverting on
537     * overflow.
538     *
539     * Counterpart to Solidity's `*` operator.
540     *
541     * Requirements:
542     * - Multiplication cannot overflow.
543     */
544   function mul(uint128 a, uint128 b) internal pure returns (uint128) {
545     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
546     // benefit is lost if 'b' is also tested.
547     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
548     if (a == 0) {
549       return 0;
550     }
551 
552     uint128 c = a * b;
553     require(c / a == b, "SafeMath: multiplication overflow");
554 
555     return c;
556   }
557 
558   /**
559     * @dev Returns the integer division of two unsigned integers. Reverts on
560     * division by zero. The result is rounded towards zero.
561     *
562     * Counterpart to Solidity's `/` operator. Note: this function uses a
563     * `revert` opcode (which leaves remaining gas untouched) while Solidity
564     * uses an invalid opcode to revert (consuming all remaining gas).
565     *
566     * Requirements:
567     * - The divisor cannot be zero.
568     */
569   function div(uint128 a, uint128 b) internal pure returns (uint128) {
570     // Solidity only automatically asserts when dividing by 0
571     require(b > 0, "SafeMath: division by zero");
572     uint128 c = a / b;
573     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
574 
575     return c;
576   }
577 
578   /**
579     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
580     * Reverts when dividing by zero.
581     *
582     * Counterpart to Solidity's `%` operator. This function uses a `revert`
583     * opcode (which leaves remaining gas untouched) while Solidity uses an
584     * invalid opcode to revert (consuming all remaining gas).
585     *
586     * Requirements:
587     * - The divisor cannot be zero.
588     */
589   function mod(uint128 a, uint128 b) internal pure returns (uint128) {
590     require(b != 0, "SafeMath: modulo by zero");
591     return a % b;
592   }
593 }
594 
595 /**
596  * @dev Wrappers over Solidity's arithmetic operations with added overflow
597  * checks.
598  *
599  * Arithmetic operations in Solidity wrap on overflow. This can easily result
600  * in bugs, because programmers usually assume that an overflow raises an
601  * error, which is the standard behavior in high level programming languages.
602  * `SafeMath` restores this intuition by reverting the transaction when an
603  * operation overflows.
604  *
605  * Using this library instead of the unchecked operations eliminates an entire
606  * class of bugs, so it's recommended to use it always.
607  *
608  * This library is a version of Open Zeppelin's SafeMath, modified to support
609  * unsigned 32 bit integers.
610  */
611 library SafeMath32 {
612   /**
613     * @dev Returns the addition of two unsigned integers, reverting on
614     * overflow.
615     *
616     * Counterpart to Solidity's `+` operator.
617     *
618     * Requirements:
619     * - Addition cannot overflow.
620     */
621   function add(uint32 a, uint32 b) internal pure returns (uint32) {
622     uint32 c = a + b;
623     require(c >= a, "SafeMath: addition overflow");
624 
625     return c;
626   }
627 
628   /**
629     * @dev Returns the subtraction of two unsigned integers, reverting on
630     * overflow (when the result is negative).
631     *
632     * Counterpart to Solidity's `-` operator.
633     *
634     * Requirements:
635     * - Subtraction cannot overflow.
636     */
637   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
638     require(b <= a, "SafeMath: subtraction overflow");
639     uint32 c = a - b;
640 
641     return c;
642   }
643 
644   /**
645     * @dev Returns the multiplication of two unsigned integers, reverting on
646     * overflow.
647     *
648     * Counterpart to Solidity's `*` operator.
649     *
650     * Requirements:
651     * - Multiplication cannot overflow.
652     */
653   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
654     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
655     // benefit is lost if 'b' is also tested.
656     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
657     if (a == 0) {
658       return 0;
659     }
660 
661     uint32 c = a * b;
662     require(c / a == b, "SafeMath: multiplication overflow");
663 
664     return c;
665   }
666 
667   /**
668     * @dev Returns the integer division of two unsigned integers. Reverts on
669     * division by zero. The result is rounded towards zero.
670     *
671     * Counterpart to Solidity's `/` operator. Note: this function uses a
672     * `revert` opcode (which leaves remaining gas untouched) while Solidity
673     * uses an invalid opcode to revert (consuming all remaining gas).
674     *
675     * Requirements:
676     * - The divisor cannot be zero.
677     */
678   function div(uint32 a, uint32 b) internal pure returns (uint32) {
679     // Solidity only automatically asserts when dividing by 0
680     require(b > 0, "SafeMath: division by zero");
681     uint32 c = a / b;
682     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
683 
684     return c;
685   }
686 
687   /**
688     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
689     * Reverts when dividing by zero.
690     *
691     * Counterpart to Solidity's `%` operator. This function uses a `revert`
692     * opcode (which leaves remaining gas untouched) while Solidity uses an
693     * invalid opcode to revert (consuming all remaining gas).
694     *
695     * Requirements:
696     * - The divisor cannot be zero.
697     */
698   function mod(uint32 a, uint32 b) internal pure returns (uint32) {
699     require(b != 0, "SafeMath: modulo by zero");
700     return a % b;
701   }
702 }
703 
704 /**
705  * @dev Wrappers over Solidity's arithmetic operations with added overflow
706  * checks.
707  *
708  * Arithmetic operations in Solidity wrap on overflow. This can easily result
709  * in bugs, because programmers usually assume that an overflow raises an
710  * error, which is the standard behavior in high level programming languages.
711  * `SafeMath` restores this intuition by reverting the transaction when an
712  * operation overflows.
713  *
714  * Using this library instead of the unchecked operations eliminates an entire
715  * class of bugs, so it's recommended to use it always.
716  *
717  * This library is a version of Open Zeppelin's SafeMath, modified to support
718  * unsigned 64 bit integers.
719  */
720 library SafeMath64 {
721   /**
722     * @dev Returns the addition of two unsigned integers, reverting on
723     * overflow.
724     *
725     * Counterpart to Solidity's `+` operator.
726     *
727     * Requirements:
728     * - Addition cannot overflow.
729     */
730   function add(uint64 a, uint64 b) internal pure returns (uint64) {
731     uint64 c = a + b;
732     require(c >= a, "SafeMath: addition overflow");
733 
734     return c;
735   }
736 
737   /**
738     * @dev Returns the subtraction of two unsigned integers, reverting on
739     * overflow (when the result is negative).
740     *
741     * Counterpart to Solidity's `-` operator.
742     *
743     * Requirements:
744     * - Subtraction cannot overflow.
745     */
746   function sub(uint64 a, uint64 b) internal pure returns (uint64) {
747     require(b <= a, "SafeMath: subtraction overflow");
748     uint64 c = a - b;
749 
750     return c;
751   }
752 
753   /**
754     * @dev Returns the multiplication of two unsigned integers, reverting on
755     * overflow.
756     *
757     * Counterpart to Solidity's `*` operator.
758     *
759     * Requirements:
760     * - Multiplication cannot overflow.
761     */
762   function mul(uint64 a, uint64 b) internal pure returns (uint64) {
763     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
764     // benefit is lost if 'b' is also tested.
765     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
766     if (a == 0) {
767       return 0;
768     }
769 
770     uint64 c = a * b;
771     require(c / a == b, "SafeMath: multiplication overflow");
772 
773     return c;
774   }
775 
776   /**
777     * @dev Returns the integer division of two unsigned integers. Reverts on
778     * division by zero. The result is rounded towards zero.
779     *
780     * Counterpart to Solidity's `/` operator. Note: this function uses a
781     * `revert` opcode (which leaves remaining gas untouched) while Solidity
782     * uses an invalid opcode to revert (consuming all remaining gas).
783     *
784     * Requirements:
785     * - The divisor cannot be zero.
786     */
787   function div(uint64 a, uint64 b) internal pure returns (uint64) {
788     // Solidity only automatically asserts when dividing by 0
789     require(b > 0, "SafeMath: division by zero");
790     uint64 c = a / b;
791     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
792 
793     return c;
794   }
795 
796   /**
797     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
798     * Reverts when dividing by zero.
799     *
800     * Counterpart to Solidity's `%` operator. This function uses a `revert`
801     * opcode (which leaves remaining gas untouched) while Solidity uses an
802     * invalid opcode to revert (consuming all remaining gas).
803     *
804     * Requirements:
805     * - The divisor cannot be zero.
806     */
807   function mod(uint64 a, uint64 b) internal pure returns (uint64) {
808     require(b != 0, "SafeMath: modulo by zero");
809     return a % b;
810   }
811 }
812 
813 interface AggregatorInterface {
814   function latestAnswer() external view returns (int256);
815   function latestTimestamp() external view returns (uint256);
816   function latestRound() external view returns (uint256);
817   function getAnswer(uint256 roundId) external view returns (int256);
818   function getTimestamp(uint256 roundId) external view returns (uint256);
819 
820   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);
821   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
822 }
823 
824 interface AggregatorV3Interface {
825 
826   function decimals() external view returns (uint8);
827   function description() external view returns (string memory);
828   function version() external view returns (uint256);
829 
830   // getRoundData and latestRoundData should both raise "No data present"
831   // if they do not have data to report, instead of returning unset values
832   // which could be misinterpreted as actual reported values.
833   function getRoundData(uint80 _roundId)
834     external
835     view
836     returns (
837       uint80 roundId,
838       int256 answer,
839       uint256 startedAt,
840       uint256 updatedAt,
841       uint80 answeredInRound
842     );
843   function latestRoundData()
844     external
845     view
846     returns (
847       uint80 roundId,
848       int256 answer,
849       uint256 startedAt,
850       uint256 updatedAt,
851       uint80 answeredInRound
852     );
853 
854 }
855 
856 interface AggregatorV2V3Interface is AggregatorInterface, AggregatorV3Interface
857 {
858 }
859 
860 interface AggregatorValidatorInterface {
861   function validate(
862     uint256 previousRoundId,
863     int256 previousAnswer,
864     uint256 currentRoundId,
865     int256 currentAnswer
866   ) external returns (bool);
867 }
868 
869 interface LinkTokenInterface {
870   function allowance(address owner, address spender) external view returns (uint256 remaining);
871   function approve(address spender, uint256 value) external returns (bool success);
872   function balanceOf(address owner) external view returns (uint256 balance);
873   function decimals() external view returns (uint8 decimalPlaces);
874   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
875   function increaseApproval(address spender, uint256 subtractedValue) external;
876   function name() external view returns (string memory tokenName);
877   function symbol() external view returns (string memory tokenSymbol);
878   function totalSupply() external view returns (uint256 totalTokensIssued);
879   function transfer(address to, uint256 value) external returns (bool success);
880   function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);
881   function transferFrom(address from, address to, uint256 value) external returns (bool success);
882 }
883 
884 /**
885  * @title The Prepaid Aggregator contract
886  * @notice Handles aggregating data pushed in from off-chain, and unlocks
887  * payment for oracles as they report. Oracles' submissions are gathered in
888  * rounds, with each round aggregating the submissions for each oracle into a
889  * single answer. The latest aggregated answer is exposed as well as historical
890  * answers and their updated at timestamp.
891  */
892 contract FluxAggregator is AggregatorV2V3Interface, Owned {
893   using SafeMath for uint256;
894   using SafeMath128 for uint128;
895   using SafeMath64 for uint64;
896   using SafeMath32 for uint32;
897 
898   struct Round {
899     int256 answer;
900     uint64 startedAt;
901     uint64 updatedAt;
902     uint32 answeredInRound;
903   }
904 
905   struct RoundDetails {
906     int256[] submissions;
907     uint32 maxSubmissions;
908     uint32 minSubmissions;
909     uint32 timeout;
910     uint128 paymentAmount;
911   }
912 
913   struct OracleStatus {
914     uint128 withdrawable;
915     uint32 startingRound;
916     uint32 endingRound;
917     uint32 lastReportedRound;
918     uint32 lastStartedRound;
919     int256 latestSubmission;
920     uint16 index;
921     address admin;
922     address pendingAdmin;
923   }
924 
925   struct Requester {
926     bool authorized;
927     uint32 delay;
928     uint32 lastStartedRound;
929   }
930 
931   struct Funds {
932     uint128 available;
933     uint128 allocated;
934   }
935 
936   LinkTokenInterface public linkToken;
937   AggregatorValidatorInterface public validator;
938 
939   // Round related params
940   uint128 public paymentAmount;
941   uint32 public maxSubmissionCount;
942   uint32 public minSubmissionCount;
943   uint32 public restartDelay;
944   uint32 public timeout;
945   uint8 public override decimals;
946   string public override description;
947 
948   int256 immutable public minSubmissionValue;
949   int256 immutable public maxSubmissionValue;
950 
951   uint256 constant public override version = 3;
952 
953   /**
954    * @notice To ensure owner isn't withdrawing required funds as oracles are
955    * submitting updates, we enforce that the contract maintains a minimum
956    * reserve of RESERVE_ROUNDS * oracleCount() LINK earmarked for payment to
957    * oracles. (Of course, this doesn't prevent the contract from running out of
958    * funds without the owner's intervention.)
959    */
960   uint256 constant private RESERVE_ROUNDS = 2;
961   uint256 constant private MAX_ORACLE_COUNT = 77;
962   uint32 constant private ROUND_MAX = 2**32-1;
963   uint256 private constant VALIDATOR_GAS_LIMIT = 100000;
964   // An error specific to the Aggregator V3 Interface, to prevent possible
965   // confusion around accidentally reading unset values as reported values.
966   string constant private V3_NO_DATA_ERROR = "No data present";
967 
968   uint32 private reportingRoundId;
969   uint32 internal latestRoundId;
970   mapping(address => OracleStatus) private oracles;
971   mapping(uint32 => Round) internal rounds;
972   mapping(uint32 => RoundDetails) internal details;
973   mapping(address => Requester) internal requesters;
974   address[] private oracleAddresses;
975   Funds private recordedFunds;
976 
977   event AvailableFundsUpdated(
978     uint256 indexed amount
979   );
980   event RoundDetailsUpdated(
981     uint128 indexed paymentAmount,
982     uint32 indexed minSubmissionCount,
983     uint32 indexed maxSubmissionCount,
984     uint32 restartDelay,
985     uint32 timeout // measured in seconds
986   );
987   event OraclePermissionsUpdated(
988     address indexed oracle,
989     bool indexed whitelisted
990   );
991   event OracleAdminUpdated(
992     address indexed oracle,
993     address indexed newAdmin
994   );
995   event OracleAdminUpdateRequested(
996     address indexed oracle,
997     address admin,
998     address newAdmin
999   );
1000   event SubmissionReceived(
1001     int256 indexed submission,
1002     uint32 indexed round,
1003     address indexed oracle
1004   );
1005   event RequesterPermissionsSet(
1006     address indexed requester,
1007     bool authorized,
1008     uint32 delay
1009   );
1010   event ValidatorUpdated(
1011     address indexed previous,
1012     address indexed current
1013   );
1014 
1015   /**
1016    * @notice set up the aggregator with initial configuration
1017    * @param _link The address of the LINK token
1018    * @param _paymentAmount The amount paid of LINK paid to each oracle per submission, in wei (units of 10⁻¹⁸ LINK)
1019    * @param _timeout is the number of seconds after the previous round that are
1020    * allowed to lapse before allowing an oracle to skip an unfinished round
1021    * @param _validator is an optional contract address for validating
1022    * external validation of answers
1023    * @param _minSubmissionValue is an immutable check for a lower bound of what
1024    * submission values are accepted from an oracle
1025    * @param _maxSubmissionValue is an immutable check for an upper bound of what
1026    * submission values are accepted from an oracle
1027    * @param _decimals represents the number of decimals to offset the answer by
1028    * @param _description a short description of what is being reported
1029    */
1030   constructor(
1031     address _link,
1032     uint128 _paymentAmount,
1033     uint32 _timeout,
1034     address _validator,
1035     int256 _minSubmissionValue,
1036     int256 _maxSubmissionValue,
1037     uint8 _decimals,
1038     string memory _description
1039   ) public {
1040     linkToken = LinkTokenInterface(_link);
1041     updateFutureRounds(_paymentAmount, 0, 0, 0, _timeout);
1042     setValidator(_validator);
1043     minSubmissionValue = _minSubmissionValue;
1044     maxSubmissionValue = _maxSubmissionValue;
1045     decimals = _decimals;
1046     description = _description;
1047     rounds[0].updatedAt = uint64(block.timestamp.sub(uint256(_timeout)));
1048   }
1049 
1050   /**
1051    * @notice called by oracles when they have witnessed a need to update
1052    * @param _roundId is the ID of the round this submission pertains to
1053    * @param _submission is the updated data that the oracle is submitting
1054    */
1055   function submit(uint256 _roundId, int256 _submission)
1056     external
1057   {
1058     bytes memory error = validateOracleRound(msg.sender, uint32(_roundId));
1059     require(_submission >= minSubmissionValue, "value below minSubmissionValue");
1060     require(_submission <= maxSubmissionValue, "value above maxSubmissionValue");
1061     require(error.length == 0, string(error));
1062 
1063     oracleInitializeNewRound(uint32(_roundId));
1064     recordSubmission(_submission, uint32(_roundId));
1065     (bool updated, int256 newAnswer) = updateRoundAnswer(uint32(_roundId));
1066     payOracle(uint32(_roundId));
1067     deleteRoundDetails(uint32(_roundId));
1068     if (updated) {
1069       validateAnswer(uint32(_roundId), newAnswer);
1070     }
1071   }
1072 
1073   /**
1074    * @notice called by the owner to remove and add new oracles as well as
1075    * update the round related parameters that pertain to total oracle count
1076    * @param _removed is the list of addresses for the new Oracles being removed
1077    * @param _added is the list of addresses for the new Oracles being added
1078    * @param _addedAdmins is the admin addresses for the new respective _added
1079    * list. Only this address is allowed to access the respective oracle's funds
1080    * @param _minSubmissions is the new minimum submission count for each round
1081    * @param _maxSubmissions is the new maximum submission count for each round
1082    * @param _restartDelay is the number of rounds an Oracle has to wait before
1083    * they can initiate a round
1084    */
1085   function changeOracles(
1086     address[] calldata _removed,
1087     address[] calldata _added,
1088     address[] calldata _addedAdmins,
1089     uint32 _minSubmissions,
1090     uint32 _maxSubmissions,
1091     uint32 _restartDelay
1092   )
1093     external
1094     onlyOwner()
1095   {
1096     for (uint256 i = 0; i < _removed.length; i++) {
1097       removeOracle(_removed[i]);
1098     }
1099 
1100     require(_added.length == _addedAdmins.length, "need same oracle and admin count");
1101     require(uint256(oracleCount()).add(_added.length) <= MAX_ORACLE_COUNT, "max oracles allowed");
1102 
1103     for (uint256 i = 0; i < _added.length; i++) {
1104       addOracle(_added[i], _addedAdmins[i]);
1105     }
1106 
1107     updateFutureRounds(paymentAmount, _minSubmissions, _maxSubmissions, _restartDelay, timeout);
1108   }
1109 
1110   /**
1111    * @notice update the round and payment related parameters for subsequent
1112    * rounds
1113    * @param _paymentAmount is the payment amount for subsequent rounds
1114    * @param _minSubmissions is the new minimum submission count for each round
1115    * @param _maxSubmissions is the new maximum submission count for each round
1116    * @param _restartDelay is the number of rounds an Oracle has to wait before
1117    * they can initiate a round
1118    */
1119   function updateFutureRounds(
1120     uint128 _paymentAmount,
1121     uint32 _minSubmissions,
1122     uint32 _maxSubmissions,
1123     uint32 _restartDelay,
1124     uint32 _timeout
1125   )
1126     public
1127     onlyOwner()
1128   {
1129     uint32 oracleNum = oracleCount(); // Save on storage reads
1130     require(_maxSubmissions >= _minSubmissions, "max must equal/exceed min");
1131     require(oracleNum >= _maxSubmissions, "max cannot exceed total");
1132     require(oracleNum == 0 || oracleNum > _restartDelay, "delay cannot exceed total");
1133     require(recordedFunds.available >= requiredReserve(_paymentAmount), "insufficient funds for payment");
1134     if (oracleCount() > 0) {
1135       require(_minSubmissions > 0, "min must be greater than 0");
1136     }
1137 
1138     paymentAmount = _paymentAmount;
1139     minSubmissionCount = _minSubmissions;
1140     maxSubmissionCount = _maxSubmissions;
1141     restartDelay = _restartDelay;
1142     timeout = _timeout;
1143 
1144     emit RoundDetailsUpdated(
1145       paymentAmount,
1146       _minSubmissions,
1147       _maxSubmissions,
1148       _restartDelay,
1149       _timeout
1150     );
1151   }
1152 
1153   /**
1154    * @notice the amount of payment yet to be withdrawn by oracles
1155    */
1156   function allocatedFunds()
1157     external
1158     view
1159     returns (uint128)
1160   {
1161     return recordedFunds.allocated;
1162   }
1163 
1164   /**
1165    * @notice the amount of future funding available to oracles
1166    */
1167   function availableFunds()
1168     external
1169     view
1170     returns (uint128)
1171   {
1172     return recordedFunds.available;
1173   }
1174 
1175   /**
1176    * @notice recalculate the amount of LINK available for payouts
1177    */
1178   function updateAvailableFunds()
1179     public
1180   {
1181     Funds memory funds = recordedFunds;
1182 
1183     uint256 nowAvailable = linkToken.balanceOf(address(this)).sub(funds.allocated);
1184 
1185     if (funds.available != nowAvailable) {
1186       recordedFunds.available = uint128(nowAvailable);
1187       emit AvailableFundsUpdated(nowAvailable);
1188     }
1189   }
1190 
1191   /**
1192    * @notice returns the number of oracles
1193    */
1194   function oracleCount() public view returns (uint8) {
1195     return uint8(oracleAddresses.length);
1196   }
1197 
1198   /**
1199    * @notice returns an array of addresses containing the oracles on contract
1200    */
1201   function getOracles() external view returns (address[] memory) {
1202     return oracleAddresses;
1203   }
1204 
1205   /**
1206    * @notice get the most recently reported answer
1207    *
1208    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
1209    * answer has been reached, it will simply return 0. Either wait to point to
1210    * an already answered Aggregator or use the recommended latestRoundData
1211    * instead which includes better verification information.
1212    */
1213   function latestAnswer()
1214     public
1215     view
1216     virtual
1217     override
1218     returns (int256)
1219   {
1220     return rounds[latestRoundId].answer;
1221   }
1222 
1223   /**
1224    * @notice get the most recent updated at timestamp
1225    *
1226    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
1227    * answer has been reached, it will simply return 0. Either wait to point to
1228    * an already answered Aggregator or use the recommended latestRoundData
1229    * instead which includes better verification information.
1230    */
1231   function latestTimestamp()
1232     public
1233     view
1234     virtual
1235     override
1236     returns (uint256)
1237   {
1238     return rounds[latestRoundId].updatedAt;
1239   }
1240 
1241   /**
1242    * @notice get the ID of the last updated round
1243    *
1244    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
1245    * answer has been reached, it will simply return 0. Either wait to point to
1246    * an already answered Aggregator or use the recommended latestRoundData
1247    * instead which includes better verification information.
1248    */
1249   function latestRound()
1250     public
1251     view
1252     virtual
1253     override
1254     returns (uint256)
1255   {
1256     return latestRoundId;
1257   }
1258 
1259   /**
1260    * @notice get past rounds answers
1261    * @param _roundId the round number to retrieve the answer for
1262    *
1263    * @dev #[deprecated] Use getRoundData instead. This does not error if no
1264    * answer has been reached, it will simply return 0. Either wait to point to
1265    * an already answered Aggregator or use the recommended getRoundData
1266    * instead which includes better verification information.
1267    */
1268   function getAnswer(uint256 _roundId)
1269     public
1270     view
1271     virtual
1272     override
1273     returns (int256)
1274   {
1275     if (validRoundId(_roundId)) {
1276       return rounds[uint32(_roundId)].answer;
1277     }
1278     return 0;
1279   }
1280 
1281   /**
1282    * @notice get timestamp when an answer was last updated
1283    * @param _roundId the round number to retrieve the updated timestamp for
1284    *
1285    * @dev #[deprecated] Use getRoundData instead. This does not error if no
1286    * answer has been reached, it will simply return 0. Either wait to point to
1287    * an already answered Aggregator or use the recommended getRoundData
1288    * instead which includes better verification information.
1289    */
1290   function getTimestamp(uint256 _roundId)
1291     public
1292     view
1293     virtual
1294     override
1295     returns (uint256)
1296   {
1297     if (validRoundId(_roundId)) {
1298       return rounds[uint32(_roundId)].updatedAt;
1299     }
1300     return 0;
1301   }
1302 
1303   /**
1304    * @notice get data about a round. Consumers are encouraged to check
1305    * that they're receiving fresh data by inspecting the updatedAt and
1306    * answeredInRound return values.
1307    * @param _roundId the round ID to retrieve the round data for
1308    * @return roundId is the round ID for which data was retrieved
1309    * @return answer is the answer for the given round
1310    * @return startedAt is the timestamp when the round was started. This is 0
1311    * if the round hasn't been started yet.
1312    * @return updatedAt is the timestamp when the round last was updated (i.e.
1313    * answer was last computed)
1314    * @return answeredInRound is the round ID of the round in which the answer
1315    * was computed. answeredInRound may be smaller than roundId when the round
1316    * timed out. answeredInRound is equal to roundId when the round didn't time out
1317    * and was completed regularly.
1318    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet received
1319    * maxSubmissions) answer and updatedAt may change between queries.
1320    */
1321   function getRoundData(uint80 _roundId)
1322     public
1323     view
1324     virtual
1325     override
1326     returns (
1327       uint80 roundId,
1328       int256 answer,
1329       uint256 startedAt,
1330       uint256 updatedAt,
1331       uint80 answeredInRound
1332     )
1333   {
1334     Round memory r = rounds[uint32(_roundId)];
1335 
1336     require(r.answeredInRound > 0 && validRoundId(_roundId), V3_NO_DATA_ERROR);
1337 
1338     return (
1339       _roundId,
1340       r.answer,
1341       r.startedAt,
1342       r.updatedAt,
1343       r.answeredInRound
1344     );
1345   }
1346 
1347   /**
1348    * @notice get data about the latest round. Consumers are encouraged to check
1349    * that they're receiving fresh data by inspecting the updatedAt and
1350    * answeredInRound return values. Consumers are encouraged to
1351    * use this more fully featured method over the "legacy" latestRound/
1352    * latestAnswer/latestTimestamp functions. Consumers are encouraged to check
1353    * that they're receiving fresh data by inspecting the updatedAt and
1354    * answeredInRound return values.
1355    * @return roundId is the round ID for which data was retrieved
1356    * @return answer is the answer for the given round
1357    * @return startedAt is the timestamp when the round was started. This is 0
1358    * if the round hasn't been started yet.
1359    * @return updatedAt is the timestamp when the round last was updated (i.e.
1360    * answer was last computed)
1361    * @return answeredInRound is the round ID of the round in which the answer
1362    * was computed. answeredInRound may be smaller than roundId when the round
1363    * timed out. answeredInRound is equal to roundId when the round didn't time
1364    * out and was completed regularly.
1365    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet
1366    * received maxSubmissions) answer and updatedAt may change between queries.
1367    */
1368    function latestRoundData()
1369     public
1370     view
1371     virtual
1372     override
1373     returns (
1374       uint80 roundId,
1375       int256 answer,
1376       uint256 startedAt,
1377       uint256 updatedAt,
1378       uint80 answeredInRound
1379     )
1380   {
1381     return getRoundData(latestRoundId);
1382   }
1383 
1384 
1385   /**
1386    * @notice query the available amount of LINK for an oracle to withdraw
1387    */
1388   function withdrawablePayment(address _oracle)
1389     external
1390     view
1391     returns (uint256)
1392   {
1393     return oracles[_oracle].withdrawable;
1394   }
1395 
1396   /**
1397    * @notice transfers the oracle's LINK to another address. Can only be called
1398    * by the oracle's admin.
1399    * @param _oracle is the oracle whose LINK is transferred
1400    * @param _recipient is the address to send the LINK to
1401    * @param _amount is the amount of LINK to send
1402    */
1403   function withdrawPayment(address _oracle, address _recipient, uint256 _amount)
1404     external
1405   {
1406     require(oracles[_oracle].admin == msg.sender, "only callable by admin");
1407 
1408     // Safe to downcast _amount because the total amount of LINK is less than 2^128.
1409     uint128 amount = uint128(_amount);
1410     uint128 available = oracles[_oracle].withdrawable;
1411     require(available >= amount, "insufficient withdrawable funds");
1412 
1413     oracles[_oracle].withdrawable = available.sub(amount);
1414     recordedFunds.allocated = recordedFunds.allocated.sub(amount);
1415 
1416     assert(linkToken.transfer(_recipient, uint256(amount)));
1417   }
1418 
1419   /**
1420    * @notice transfers the owner's LINK to another address
1421    * @param _recipient is the address to send the LINK to
1422    * @param _amount is the amount of LINK to send
1423    */
1424   function withdrawFunds(address _recipient, uint256 _amount)
1425     external
1426     onlyOwner()
1427   {
1428     uint256 available = uint256(recordedFunds.available);
1429     require(available.sub(requiredReserve(paymentAmount)) >= _amount, "insufficient reserve funds");
1430     require(linkToken.transfer(_recipient, _amount), "token transfer failed");
1431     updateAvailableFunds();
1432   }
1433 
1434   /**
1435    * @notice get the admin address of an oracle
1436    * @param _oracle is the address of the oracle whose admin is being queried
1437    */
1438   function getAdmin(address _oracle)
1439     external
1440     view
1441     returns (address)
1442   {
1443     return oracles[_oracle].admin;
1444   }
1445 
1446   /**
1447    * @notice transfer the admin address for an oracle
1448    * @param _oracle is the address of the oracle whose admin is being transferred
1449    * @param _newAdmin is the new admin address
1450    */
1451   function transferAdmin(address _oracle, address _newAdmin)
1452     external
1453   {
1454     require(oracles[_oracle].admin == msg.sender, "only callable by admin");
1455     oracles[_oracle].pendingAdmin = _newAdmin;
1456 
1457     emit OracleAdminUpdateRequested(_oracle, msg.sender, _newAdmin);
1458   }
1459 
1460   /**
1461    * @notice accept the admin address transfer for an oracle
1462    * @param _oracle is the address of the oracle whose admin is being transferred
1463    */
1464   function acceptAdmin(address _oracle)
1465     external
1466   {
1467     require(oracles[_oracle].pendingAdmin == msg.sender, "only callable by pending admin");
1468     oracles[_oracle].pendingAdmin = address(0);
1469     oracles[_oracle].admin = msg.sender;
1470 
1471     emit OracleAdminUpdated(_oracle, msg.sender);
1472   }
1473 
1474   /**
1475    * @notice allows non-oracles to request a new round
1476    */
1477   function requestNewRound()
1478     external
1479     returns (uint80)
1480   {
1481     require(requesters[msg.sender].authorized, "not authorized requester");
1482 
1483     uint32 current = reportingRoundId;
1484     require(rounds[current].updatedAt > 0 || timedOut(current), "prev round must be supersedable");
1485 
1486     uint32 newRoundId = current.add(1);
1487     requesterInitializeNewRound(newRoundId);
1488     return newRoundId;
1489   }
1490 
1491   /**
1492    * @notice allows the owner to specify new non-oracles to start new rounds
1493    * @param _requester is the address to set permissions for
1494    * @param _authorized is a boolean specifying whether they can start new rounds or not
1495    * @param _delay is the number of rounds the requester must wait before starting another round
1496    */
1497   function setRequesterPermissions(address _requester, bool _authorized, uint32 _delay)
1498     external
1499     onlyOwner()
1500   {
1501     if (requesters[_requester].authorized == _authorized) return;
1502 
1503     if (_authorized) {
1504       requesters[_requester].authorized = _authorized;
1505       requesters[_requester].delay = _delay;
1506     } else {
1507       delete requesters[_requester];
1508     }
1509 
1510     emit RequesterPermissionsSet(_requester, _authorized, _delay);
1511   }
1512 
1513   /**
1514    * @notice called through LINK's transferAndCall to update available funds
1515    * in the same transaction as the funds were transferred to the aggregator
1516    * @param _data is mostly ignored. It is checked for length, to be sure
1517    * nothing strange is passed in.
1518    */
1519   function onTokenTransfer(address, uint256, bytes calldata _data)
1520     external
1521   {
1522     require(_data.length == 0, "transfer doesn't accept calldata");
1523     updateAvailableFunds();
1524   }
1525 
1526   /**
1527    * @notice a method to provide all current info oracles need. Intended only
1528    * only to be callable by oracles. Not for use by contracts to read state.
1529    * @param _oracle the address to look up information for.
1530    */
1531   function oracleRoundState(address _oracle, uint32 _queriedRoundId)
1532     external
1533     view
1534     returns (
1535       bool _eligibleToSubmit,
1536       uint32 _roundId,
1537       int256 _latestSubmission,
1538       uint64 _startedAt,
1539       uint64 _timeout,
1540       uint128 _availableFunds,
1541       uint8 _oracleCount,
1542       uint128 _paymentAmount
1543     )
1544   {
1545     require(msg.sender == tx.origin, "off-chain reading only");
1546 
1547     if (_queriedRoundId > 0) {
1548       Round storage round = rounds[_queriedRoundId];
1549       RoundDetails storage details = details[_queriedRoundId];
1550       return (
1551         eligibleForSpecificRound(_oracle, _queriedRoundId),
1552         _queriedRoundId,
1553         oracles[_oracle].latestSubmission,
1554         round.startedAt,
1555         details.timeout,
1556         recordedFunds.available,
1557         oracleCount(),
1558         (round.startedAt > 0 ? details.paymentAmount : paymentAmount)
1559       );
1560     } else {
1561       return oracleRoundStateSuggestRound(_oracle);
1562     }
1563   }
1564 
1565   /**
1566    * @notice method to update the address which does external data validation.
1567    * @param _newValidator designates the address of the new validation contract.
1568    */
1569   function setValidator(address _newValidator)
1570     public
1571     onlyOwner()
1572   {
1573     address previous = address(validator);
1574 
1575     if (previous != _newValidator) {
1576       validator = AggregatorValidatorInterface(_newValidator);
1577 
1578       emit ValidatorUpdated(previous, _newValidator);
1579     }
1580   }
1581 
1582 
1583   /**
1584    * Private
1585    */
1586 
1587   function initializeNewRound(uint32 _roundId)
1588     private
1589   {
1590     updateTimedOutRoundInfo(_roundId.sub(1));
1591 
1592     reportingRoundId = _roundId;
1593     RoundDetails memory nextDetails = RoundDetails(
1594       new int256[](0),
1595       maxSubmissionCount,
1596       minSubmissionCount,
1597       timeout,
1598       paymentAmount
1599     );
1600     details[_roundId] = nextDetails;
1601     rounds[_roundId].startedAt = uint64(block.timestamp);
1602 
1603     emit NewRound(_roundId, msg.sender, rounds[_roundId].startedAt);
1604   }
1605 
1606   function oracleInitializeNewRound(uint32 _roundId)
1607     private
1608   {
1609     if (!newRound(_roundId)) return;
1610     uint256 lastStarted = oracles[msg.sender].lastStartedRound; // cache storage reads
1611     if (_roundId <= lastStarted + restartDelay && lastStarted != 0) return;
1612 
1613     initializeNewRound(_roundId);
1614 
1615     oracles[msg.sender].lastStartedRound = _roundId;
1616   }
1617 
1618   function requesterInitializeNewRound(uint32 _roundId)
1619     private
1620   {
1621     if (!newRound(_roundId)) return;
1622     uint256 lastStarted = requesters[msg.sender].lastStartedRound; // cache storage reads
1623     require(_roundId > lastStarted + requesters[msg.sender].delay || lastStarted == 0, "must delay requests");
1624 
1625     initializeNewRound(_roundId);
1626 
1627     requesters[msg.sender].lastStartedRound = _roundId;
1628   }
1629 
1630   function updateTimedOutRoundInfo(uint32 _roundId)
1631     private
1632   {
1633     if (!timedOut(_roundId)) return;
1634 
1635     uint32 prevId = _roundId.sub(1);
1636     rounds[_roundId].answer = rounds[prevId].answer;
1637     rounds[_roundId].answeredInRound = rounds[prevId].answeredInRound;
1638     rounds[_roundId].updatedAt = uint64(block.timestamp);
1639 
1640     delete details[_roundId];
1641   }
1642 
1643   function eligibleForSpecificRound(address _oracle, uint32 _queriedRoundId)
1644     private
1645     view
1646     returns (bool _eligible)
1647   {
1648     if (rounds[_queriedRoundId].startedAt > 0) {
1649       return acceptingSubmissions(_queriedRoundId) && validateOracleRound(_oracle, _queriedRoundId).length == 0;
1650     } else {
1651       return delayed(_oracle, _queriedRoundId) && validateOracleRound(_oracle, _queriedRoundId).length == 0;
1652     }
1653   }
1654 
1655   function oracleRoundStateSuggestRound(address _oracle)
1656     private
1657     view
1658     returns (
1659       bool _eligibleToSubmit,
1660       uint32 _roundId,
1661       int256 _latestSubmission,
1662       uint64 _startedAt,
1663       uint64 _timeout,
1664       uint128 _availableFunds,
1665       uint8 _oracleCount,
1666       uint128 _paymentAmount
1667     )
1668   {
1669     Round storage round = rounds[0];
1670     OracleStatus storage oracle = oracles[_oracle];
1671 
1672     bool shouldSupersede = oracle.lastReportedRound == reportingRoundId || !acceptingSubmissions(reportingRoundId);
1673     // Instead of nudging oracles to submit to the next round, the inclusion of
1674     // the shouldSupersede bool in the if condition pushes them towards
1675     // submitting in a currently open round.
1676     if (supersedable(reportingRoundId) && shouldSupersede) {
1677       _roundId = reportingRoundId.add(1);
1678       round = rounds[_roundId];
1679 
1680       _paymentAmount = paymentAmount;
1681       _eligibleToSubmit = delayed(_oracle, _roundId);
1682     } else {
1683       _roundId = reportingRoundId;
1684       round = rounds[_roundId];
1685 
1686       _paymentAmount = details[_roundId].paymentAmount;
1687       _eligibleToSubmit = acceptingSubmissions(_roundId);
1688     }
1689 
1690     if (validateOracleRound(_oracle, _roundId).length != 0) {
1691       _eligibleToSubmit = false;
1692     }
1693 
1694     return (
1695       _eligibleToSubmit,
1696       _roundId,
1697       oracle.latestSubmission,
1698       round.startedAt,
1699       details[_roundId].timeout,
1700       recordedFunds.available,
1701       oracleCount(),
1702       _paymentAmount
1703     );
1704   }
1705 
1706   function updateRoundAnswer(uint32 _roundId)
1707     internal
1708     returns (bool, int256)
1709   {
1710     if (details[_roundId].submissions.length < details[_roundId].minSubmissions) {
1711       return (false, 0);
1712     }
1713 
1714     int256 newAnswer = Median.calculateInplace(details[_roundId].submissions);
1715     rounds[_roundId].answer = newAnswer;
1716     rounds[_roundId].updatedAt = uint64(block.timestamp);
1717     rounds[_roundId].answeredInRound = _roundId;
1718     latestRoundId = _roundId;
1719 
1720     emit AnswerUpdated(newAnswer, _roundId, now);
1721 
1722     return (true, newAnswer);
1723   }
1724 
1725   function validateAnswer(
1726     uint32 _roundId,
1727     int256 _newAnswer
1728   )
1729     private
1730   {
1731     AggregatorValidatorInterface av = validator; // cache storage reads
1732     if (address(av) == address(0)) return;
1733 
1734     uint32 prevRound = _roundId.sub(1);
1735     uint32 prevAnswerRoundId = rounds[prevRound].answeredInRound;
1736     int256 prevRoundAnswer = rounds[prevRound].answer;
1737     // We do not want the validator to ever prevent reporting, so we limit its
1738     // gas usage and catch any errors that may arise.
1739     try av.validate{gas: VALIDATOR_GAS_LIMIT}(
1740       prevAnswerRoundId,
1741       prevRoundAnswer,
1742       _roundId,
1743       _newAnswer
1744     ) {} catch {}
1745   }
1746 
1747   function payOracle(uint32 _roundId)
1748     private
1749   {
1750     uint128 payment = details[_roundId].paymentAmount;
1751     Funds memory funds = recordedFunds;
1752     funds.available = funds.available.sub(payment);
1753     funds.allocated = funds.allocated.add(payment);
1754     recordedFunds = funds;
1755     oracles[msg.sender].withdrawable = oracles[msg.sender].withdrawable.add(payment);
1756 
1757     emit AvailableFundsUpdated(funds.available);
1758   }
1759 
1760   function recordSubmission(int256 _submission, uint32 _roundId)
1761     private
1762   {
1763     require(acceptingSubmissions(_roundId), "round not accepting submissions");
1764 
1765     details[_roundId].submissions.push(_submission);
1766     oracles[msg.sender].lastReportedRound = _roundId;
1767     oracles[msg.sender].latestSubmission = _submission;
1768 
1769     emit SubmissionReceived(_submission, _roundId, msg.sender);
1770   }
1771 
1772   function deleteRoundDetails(uint32 _roundId)
1773     private
1774   {
1775     if (details[_roundId].submissions.length < details[_roundId].maxSubmissions) return;
1776 
1777     delete details[_roundId];
1778   }
1779 
1780   function timedOut(uint32 _roundId)
1781     private
1782     view
1783     returns (bool)
1784   {
1785     uint64 startedAt = rounds[_roundId].startedAt;
1786     uint32 roundTimeout = details[_roundId].timeout;
1787     return startedAt > 0 && roundTimeout > 0 && startedAt.add(roundTimeout) < block.timestamp;
1788   }
1789 
1790   function getStartingRound(address _oracle)
1791     private
1792     view
1793     returns (uint32)
1794   {
1795     uint32 currentRound = reportingRoundId;
1796     if (currentRound != 0 && currentRound == oracles[_oracle].endingRound) {
1797       return currentRound;
1798     }
1799     return currentRound.add(1);
1800   }
1801 
1802   function previousAndCurrentUnanswered(uint32 _roundId, uint32 _rrId)
1803     private
1804     view
1805     returns (bool)
1806   {
1807     return _roundId.add(1) == _rrId && rounds[_rrId].updatedAt == 0;
1808   }
1809 
1810   function requiredReserve(uint256 payment)
1811     private
1812     view
1813     returns (uint256)
1814   {
1815     return payment.mul(oracleCount()).mul(RESERVE_ROUNDS);
1816   }
1817 
1818   function addOracle(
1819     address _oracle,
1820     address _admin
1821   )
1822     private
1823   {
1824     require(!oracleEnabled(_oracle), "oracle already enabled");
1825 
1826     require(_admin != address(0), "cannot set admin to 0");
1827     require(oracles[_oracle].admin == address(0) || oracles[_oracle].admin == _admin, "owner cannot overwrite admin");
1828 
1829     oracles[_oracle].startingRound = getStartingRound(_oracle);
1830     oracles[_oracle].endingRound = ROUND_MAX;
1831     oracles[_oracle].index = uint16(oracleAddresses.length);
1832     oracleAddresses.push(_oracle);
1833     oracles[_oracle].admin = _admin;
1834 
1835     emit OraclePermissionsUpdated(_oracle, true);
1836     emit OracleAdminUpdated(_oracle, _admin);
1837   }
1838 
1839   function removeOracle(
1840     address _oracle
1841   )
1842     private
1843   {
1844     require(oracleEnabled(_oracle), "oracle not enabled");
1845 
1846     oracles[_oracle].endingRound = reportingRoundId.add(1);
1847     address tail = oracleAddresses[uint256(oracleCount()).sub(1)];
1848     uint16 index = oracles[_oracle].index;
1849     oracles[tail].index = index;
1850     delete oracles[_oracle].index;
1851     oracleAddresses[index] = tail;
1852     oracleAddresses.pop();
1853 
1854     emit OraclePermissionsUpdated(_oracle, false);
1855   }
1856 
1857   function validateOracleRound(address _oracle, uint32 _roundId)
1858     private
1859     view
1860     returns (bytes memory)
1861   {
1862     // cache storage reads
1863     uint32 startingRound = oracles[_oracle].startingRound;
1864     uint32 rrId = reportingRoundId;
1865 
1866     if (startingRound == 0) return "not enabled oracle";
1867     if (startingRound > _roundId) return "not yet enabled oracle";
1868     if (oracles[_oracle].endingRound < _roundId) return "no longer allowed oracle";
1869     if (oracles[_oracle].lastReportedRound >= _roundId) return "cannot report on previous rounds";
1870     if (_roundId != rrId && _roundId != rrId.add(1) && !previousAndCurrentUnanswered(_roundId, rrId)) return "invalid round to report";
1871     if (_roundId != 1 && !supersedable(_roundId.sub(1))) return "previous round not supersedable";
1872   }
1873 
1874   function supersedable(uint32 _roundId)
1875     private
1876     view
1877     returns (bool)
1878   {
1879     return rounds[_roundId].updatedAt > 0 || timedOut(_roundId);
1880   }
1881 
1882   function oracleEnabled(address _oracle)
1883     private
1884     view
1885     returns (bool)
1886   {
1887     return oracles[_oracle].endingRound == ROUND_MAX;
1888   }
1889 
1890   function acceptingSubmissions(uint32 _roundId)
1891     private
1892     view
1893     returns (bool)
1894   {
1895     return details[_roundId].maxSubmissions != 0;
1896   }
1897 
1898   function delayed(address _oracle, uint32 _roundId)
1899     private
1900     view
1901     returns (bool)
1902   {
1903     uint256 lastStarted = oracles[_oracle].lastStartedRound;
1904     return _roundId > lastStarted + restartDelay || lastStarted == 0;
1905   }
1906 
1907   function newRound(uint32 _roundId)
1908     private
1909     view
1910     returns (bool)
1911   {
1912     return _roundId == reportingRoundId.add(1);
1913   }
1914 
1915   function validRoundId(uint256 _roundId)
1916     private
1917     view
1918     returns (bool)
1919   {
1920     return _roundId <= ROUND_MAX;
1921   }
1922 
1923 }
1924 
1925 interface AccessControllerInterface {
1926   function hasAccess(address user, bytes calldata data) external view returns (bool);
1927 }
1928 
1929 /**
1930  * @title SimpleWriteAccessController
1931  * @notice Gives access to accounts explicitly added to an access list by the
1932  * controller's owner.
1933  * @dev does not make any special permissions for externally, see
1934  * SimpleReadAccessController for that.
1935  */
1936 contract SimpleWriteAccessController is AccessControllerInterface, Owned {
1937 
1938   bool public checkEnabled;
1939   mapping(address => bool) internal accessList;
1940 
1941   event AddedAccess(address user);
1942   event RemovedAccess(address user);
1943   event CheckAccessEnabled();
1944   event CheckAccessDisabled();
1945 
1946   constructor()
1947     public
1948   {
1949     checkEnabled = true;
1950   }
1951 
1952   /**
1953    * @notice Returns the access of an address
1954    * @param _user The address to query
1955    */
1956   function hasAccess(
1957     address _user,
1958     bytes memory
1959   )
1960     public
1961     view
1962     virtual
1963     override
1964     returns (bool)
1965   {
1966     return accessList[_user] || !checkEnabled;
1967   }
1968 
1969   /**
1970    * @notice Adds an address to the access list
1971    * @param _user The address to add
1972    */
1973   function addAccess(address _user)
1974     external
1975     onlyOwner()
1976   {
1977     if (!accessList[_user]) {
1978       accessList[_user] = true;
1979 
1980       emit AddedAccess(_user);
1981     }
1982   }
1983 
1984   /**
1985    * @notice Removes an address from the access list
1986    * @param _user The address to remove
1987    */
1988   function removeAccess(address _user)
1989     external
1990     onlyOwner()
1991   {
1992     if (accessList[_user]) {
1993       accessList[_user] = false;
1994 
1995       emit RemovedAccess(_user);
1996     }
1997   }
1998 
1999   /**
2000    * @notice makes the access check enforced
2001    */
2002   function enableAccessCheck()
2003     external
2004     onlyOwner()
2005   {
2006     if (!checkEnabled) {
2007       checkEnabled = true;
2008 
2009       emit CheckAccessEnabled();
2010     }
2011   }
2012 
2013   /**
2014    * @notice makes the access check unenforced
2015    */
2016   function disableAccessCheck()
2017     external
2018     onlyOwner()
2019   {
2020     if (checkEnabled) {
2021       checkEnabled = false;
2022 
2023       emit CheckAccessDisabled();
2024     }
2025   }
2026 
2027   /**
2028    * @dev reverts if the caller does not have access
2029    */
2030   modifier checkAccess() {
2031     require(hasAccess(msg.sender, msg.data), "No access");
2032     _;
2033   }
2034 }
2035 
2036 /**
2037  * @title SimpleReadAccessController
2038  * @notice Gives access to:
2039  * - any externally owned account (note that offchain actors can always read
2040  * any contract storage regardless of onchain access control measures, so this
2041  * does not weaken the access control while improving usability)
2042  * - accounts explicitly added to an access list
2043  * @dev SimpleReadAccessController is not suitable for access controlling writes
2044  * since it grants any externally owned account access! See
2045  * SimpleWriteAccessController for that.
2046  */
2047 contract SimpleReadAccessController is SimpleWriteAccessController {
2048 
2049   /**
2050    * @notice Returns the access of an address
2051    * @param _user The address to query
2052    */
2053   function hasAccess(
2054     address _user,
2055     bytes memory _calldata
2056   )
2057     public
2058     view
2059     virtual
2060     override
2061     returns (bool)
2062   {
2063     return super.hasAccess(_user, _calldata) || _user == tx.origin;
2064   }
2065 
2066 }
2067 
2068 /**
2069  * @title AccessControlled FluxAggregator contract
2070  * @notice This contract requires addresses to be added to a controller
2071  * in order to read the answers stored in the FluxAggregator contract
2072  */
2073 contract AccessControlledAggregator is FluxAggregator, SimpleReadAccessController {
2074 
2075   /**
2076    * @notice set up the aggregator with initial configuration
2077    * @param _link The address of the LINK token
2078    * @param _paymentAmount The amount paid of LINK paid to each oracle per submission, in wei (units of 10⁻¹⁸ LINK)
2079    * @param _timeout is the number of seconds after the previous round that are
2080    * allowed to lapse before allowing an oracle to skip an unfinished round
2081    * @param _validator is an optional contract address for validating
2082    * external validation of answers
2083    * @param _minSubmissionValue is an immutable check for a lower bound of what
2084    * submission values are accepted from an oracle
2085    * @param _maxSubmissionValue is an immutable check for an upper bound of what
2086    * submission values are accepted from an oracle
2087    * @param _decimals represents the number of decimals to offset the answer by
2088    * @param _description a short description of what is being reported
2089    */
2090   constructor(
2091     address _link,
2092     uint128 _paymentAmount,
2093     uint32 _timeout,
2094     address _validator,
2095     int256 _minSubmissionValue,
2096     int256 _maxSubmissionValue,
2097     uint8 _decimals,
2098     string memory _description
2099   ) public FluxAggregator(
2100     _link,
2101     _paymentAmount,
2102     _timeout,
2103     _validator,
2104     _minSubmissionValue,
2105     _maxSubmissionValue,
2106     _decimals,
2107     _description
2108   ){}
2109 
2110   /**
2111    * @notice get data about a round. Consumers are encouraged to check
2112    * that they're receiving fresh data by inspecting the updatedAt and
2113    * answeredInRound return values.
2114    * @param _roundId the round ID to retrieve the round data for
2115    * @return roundId is the round ID for which data was retrieved
2116    * @return answer is the answer for the given round
2117    * @return startedAt is the timestamp when the round was started. This is 0
2118    * if the round hasn't been started yet.
2119    * @return updatedAt is the timestamp when the round last was updated (i.e.
2120    * answer was last computed)
2121    * @return answeredInRound is the round ID of the round in which the answer
2122    * was computed. answeredInRound may be smaller than roundId when the round
2123    * timed out. answerInRound is equal to roundId when the round didn't time out
2124    * and was completed regularly.
2125    * @dev overridden funcion to add the checkAccess() modifier
2126    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet
2127    * received maxSubmissions) answer and updatedAt may change between queries.
2128    */
2129   function getRoundData(uint80 _roundId)
2130     public
2131     view
2132     override
2133     checkAccess()
2134     returns (
2135       uint80 roundId,
2136       int256 answer,
2137       uint256 startedAt,
2138       uint256 updatedAt,
2139       uint80 answeredInRound
2140     )
2141   {
2142     return super.getRoundData(_roundId);
2143   }
2144 
2145   /**
2146    * @notice get data about the latest round. Consumers are encouraged to check
2147    * that they're receiving fresh data by inspecting the updatedAt and
2148    * answeredInRound return values. Consumers are encouraged to
2149    * use this more fully featured method over the "legacy" latestAnswer
2150    * functions. Consumers are encouraged to check that they're receiving fresh
2151    * data by inspecting the updatedAt and answeredInRound return values.
2152    * @return roundId is the round ID for which data was retrieved
2153    * @return answer is the answer for the given round
2154    * @return startedAt is the timestamp when the round was started. This is 0
2155    * if the round hasn't been started yet.
2156    * @return updatedAt is the timestamp when the round last was updated (i.e.
2157    * answer was last computed)
2158    * @return answeredInRound is the round ID of the round in which the answer
2159    * was computed. answeredInRound may be smaller than roundId when the round
2160    * timed out. answerInRound is equal to roundId when the round didn't time out
2161    * and was completed regularly.
2162    * @dev overridden funcion to add the checkAccess() modifier
2163    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet
2164    * received maxSubmissions) answer and updatedAt may change between queries.
2165    */
2166   function latestRoundData()
2167     public
2168     view
2169     override
2170     checkAccess()
2171     returns (
2172       uint80 roundId,
2173       int256 answer,
2174       uint256 startedAt,
2175       uint256 updatedAt,
2176       uint80 answeredInRound
2177     )
2178   {
2179     return super.latestRoundData();
2180   }
2181 
2182   /**
2183    * @notice get the most recently reported answer
2184    * @dev overridden funcion to add the checkAccess() modifier
2185    *
2186    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
2187    * answer has been reached, it will simply return 0. Either wait to point to
2188    * an already answered Aggregator or use the recommended latestRoundData
2189    * instead which includes better verification information.
2190    */
2191   function latestAnswer()
2192     public
2193     view
2194     override
2195     checkAccess()
2196     returns (int256)
2197   {
2198     return super.latestAnswer();
2199   }
2200 
2201   /**
2202    * @notice get the most recently reported round ID
2203    * @dev overridden funcion to add the checkAccess() modifier
2204    *
2205    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
2206    * answer has been reached, it will simply return 0. Either wait to point to
2207    * an already answered Aggregator or use the recommended latestRoundData
2208    * instead which includes better verification information.
2209    */
2210   function latestRound()
2211     public
2212     view
2213     override
2214     checkAccess()
2215     returns (uint256)
2216   {
2217     return super.latestRound();
2218   }
2219 
2220   /**
2221    * @notice get the most recent updated at timestamp
2222    * @dev overridden funcion to add the checkAccess() modifier
2223    *
2224    * @dev #[deprecated] Use latestRoundData instead. This does not error if no
2225    * answer has been reached, it will simply return 0. Either wait to point to
2226    * an already answered Aggregator or use the recommended latestRoundData
2227    * instead which includes better verification information.
2228    */
2229   function latestTimestamp()
2230     public
2231     view
2232     override
2233     checkAccess()
2234     returns (uint256)
2235   {
2236     return super.latestTimestamp();
2237   }
2238 
2239   /**
2240    * @notice get past rounds answers
2241    * @dev overridden funcion to add the checkAccess() modifier
2242    * @param _roundId the round number to retrieve the answer for
2243    *
2244    * @dev #[deprecated] Use getRoundData instead. This does not error if no
2245    * answer has been reached, it will simply return 0. Either wait to point to
2246    * an already answered Aggregator or use the recommended getRoundData
2247    * instead which includes better verification information.
2248    */
2249   function getAnswer(uint256 _roundId)
2250     public
2251     view
2252     override
2253     checkAccess()
2254     returns (int256)
2255   {
2256     return super.getAnswer(_roundId);
2257   }
2258 
2259   /**
2260    * @notice get timestamp when an answer was last updated
2261    * @dev overridden funcion to add the checkAccess() modifier
2262    * @param _roundId the round number to retrieve the updated timestamp for
2263    *
2264    * @dev #[deprecated] Use getRoundData instead. This does not error if no
2265    * answer has been reached, it will simply return 0. Either wait to point to
2266    * an already answered Aggregator or use the recommended getRoundData
2267    * instead which includes better verification information.
2268    */
2269   function getTimestamp(uint256 _roundId)
2270     public
2271     view
2272     override
2273     checkAccess()
2274     returns (uint256)
2275   {
2276     return super.getTimestamp(_roundId);
2277   }
2278 
2279 }