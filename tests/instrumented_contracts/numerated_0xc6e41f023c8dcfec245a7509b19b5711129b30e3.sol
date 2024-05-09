1 pragma solidity 0.6.6;
2 
3 interface AccessControllerInterface {
4   function hasAccess(address user, bytes calldata data) external view returns (bool);
5 }
6 
7 
8 /**
9  * @title The Owned contract
10  * @notice A contract with helpers for basic contract ownership.
11  */
12 contract Owned {
13 
14   address payable public owner;
15   address private pendingOwner;
16 
17   event OwnershipTransferRequested(
18     address indexed from,
19     address indexed to
20   );
21   event OwnershipTransferred(
22     address indexed from,
23     address indexed to
24   );
25 
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Allows an owner to begin transferring ownership to a new address,
32    * pending.
33    */
34   function transferOwnership(address _to)
35     external
36     onlyOwner()
37   {
38     pendingOwner = _to;
39 
40     emit OwnershipTransferRequested(owner, _to);
41   }
42 
43   /**
44    * @dev Allows an ownership transfer to be completed by the recipient.
45    */
46   function acceptOwnership()
47     external
48   {
49     require(msg.sender == pendingOwner, "Must be proposed owner");
50 
51     address oldOwner = owner;
52     owner = msg.sender;
53     pendingOwner = address(0);
54 
55     emit OwnershipTransferred(oldOwner, msg.sender);
56   }
57 
58   /**
59    * @dev Reverts if called by anyone other than the contract owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner, "Only callable by owner");
63     _;
64   }
65 
66 }
67 
68 
69 interface AggregatorV3Interface {
70   function decimals() external view returns (uint8);
71   function description() external view returns (string memory);
72   function getRoundData(uint256 _roundId)
73     external
74     view
75     returns (
76       uint256 roundId,
77       int256 answer,
78       uint256 startedAt,
79       uint256 updatedAt,
80       uint256 answeredInRound
81     );
82   function latestRoundData()
83     external
84     view
85     returns (
86       uint256 roundId,
87       int256 answer,
88       uint256 startedAt,
89       uint256 updatedAt,
90       uint256 answeredInRound
91     );
92   function version() external view returns (uint256);
93 }
94 
95 
96 interface AggregatorInterface {
97   function latestAnswer() external view returns (int256);
98   function latestTimestamp() external view returns (uint256);
99   function latestRound() external view returns (uint256);
100   function getAnswer(uint256 roundId) external view returns (int256);
101   function getTimestamp(uint256 roundId) external view returns (uint256);
102 
103   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
104   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
105 }
106 
107 
108 interface LinkTokenInterface {
109   function allowance(address owner, address spender) external view returns (uint256 remaining);
110   function approve(address spender, uint256 value) external returns (bool success);
111   function balanceOf(address owner) external view returns (uint256 balance);
112   function decimals() external view returns (uint8 decimalPlaces);
113   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
114   function increaseApproval(address spender, uint256 subtractedValue) external;
115   function name() external view returns (string memory tokenName);
116   function symbol() external view returns (string memory tokenSymbol);
117   function totalSupply() external view returns (uint256 totalTokensIssued);
118   function transfer(address to, uint256 value) external returns (bool success);
119   function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);
120   function transferFrom(address from, address to, uint256 value) external returns (bool success);
121 }
122 
123 
124 
125 
126 
127 
128 
129 
130 /**
131  * @dev Wrappers over Solidity's arithmetic operations with added overflow
132  * checks.
133  *
134  * Arithmetic operations in Solidity wrap on overflow. This can easily result
135  * in bugs, because programmers usually assume that an overflow raises an
136  * error, which is the standard behavior in high level programming languages.
137  * `SafeMath` restores this intuition by reverting the transaction when an
138  * operation overflows.
139  *
140  * Using this library instead of the unchecked operations eliminates an entire
141  * class of bugs, so it's recommended to use it always.
142  */
143 library SafeMath {
144   /**
145     * @dev Returns the addition of two unsigned integers, reverting on
146     * overflow.
147     *
148     * Counterpart to Solidity's `+` operator.
149     *
150     * Requirements:
151     * - Addition cannot overflow.
152     */
153   function add(uint256 a, uint256 b) internal pure returns (uint256) {
154     uint256 c = a + b;
155     require(c >= a, "SafeMath: addition overflow");
156 
157     return c;
158   }
159 
160   /**
161     * @dev Returns the subtraction of two unsigned integers, reverting on
162     * overflow (when the result is negative).
163     *
164     * Counterpart to Solidity's `-` operator.
165     *
166     * Requirements:
167     * - Subtraction cannot overflow.
168     */
169   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170     require(b <= a, "SafeMath: subtraction overflow");
171     uint256 c = a - b;
172 
173     return c;
174   }
175 
176   /**
177     * @dev Returns the multiplication of two unsigned integers, reverting on
178     * overflow.
179     *
180     * Counterpart to Solidity's `*` operator.
181     *
182     * Requirements:
183     * - Multiplication cannot overflow.
184     */
185   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187     // benefit is lost if 'b' is also tested.
188     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
189     if (a == 0) {
190       return 0;
191     }
192 
193     uint256 c = a * b;
194     require(c / a == b, "SafeMath: multiplication overflow");
195 
196     return c;
197   }
198 
199   /**
200     * @dev Returns the integer division of two unsigned integers. Reverts on
201     * division by zero. The result is rounded towards zero.
202     *
203     * Counterpart to Solidity's `/` operator. Note: this function uses a
204     * `revert` opcode (which leaves remaining gas untouched) while Solidity
205     * uses an invalid opcode to revert (consuming all remaining gas).
206     *
207     * Requirements:
208     * - The divisor cannot be zero.
209     */
210   function div(uint256 a, uint256 b) internal pure returns (uint256) {
211     // Solidity only automatically asserts when dividing by 0
212     require(b > 0, "SafeMath: division by zero");
213     uint256 c = a / b;
214     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216     return c;
217   }
218 
219   /**
220     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221     * Reverts when dividing by zero.
222     *
223     * Counterpart to Solidity's `%` operator. This function uses a `revert`
224     * opcode (which leaves remaining gas untouched) while Solidity uses an
225     * invalid opcode to revert (consuming all remaining gas).
226     *
227     * Requirements:
228     * - The divisor cannot be zero.
229     */
230   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231     require(b != 0, "SafeMath: modulo by zero");
232     return a % b;
233   }
234 }
235 
236 
237 
238 library SignedSafeMath {
239   int256 constant private _INT256_MIN = -2**255;
240 
241   /**
242    * @dev Multiplies two signed integers, reverts on overflow.
243    */
244   function mul(int256 a, int256 b) internal pure returns (int256) {
245     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246     // benefit is lost if 'b' is also tested.
247     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
248     if (a == 0) {
249       return 0;
250     }
251 
252     require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
253 
254     int256 c = a * b;
255     require(c / a == b, "SignedSafeMath: multiplication overflow");
256 
257     return c;
258   }
259 
260   /**
261    * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
262    */
263   function div(int256 a, int256 b) internal pure returns (int256) {
264     require(b != 0, "SignedSafeMath: division by zero");
265     require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
266 
267     int256 c = a / b;
268 
269     return c;
270   }
271 
272   /**
273    * @dev Subtracts two signed integers, reverts on overflow.
274    */
275   function sub(int256 a, int256 b) internal pure returns (int256) {
276     int256 c = a - b;
277     require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
278 
279     return c;
280   }
281 
282   /**
283    * @dev Adds two signed integers, reverts on overflow.
284    */
285   function add(int256 a, int256 b) internal pure returns (int256) {
286     int256 c = a + b;
287     require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
288 
289     return c;
290   }
291 
292   /**
293    * @notice Computes average of two signed integers, ensuring that the computation
294    * doesn't overflow.
295    * @dev If the result is not an integer, it is rounded towards zero. For example,
296    * avg(-3, -4) = -3
297    */
298   function avg(int256 _a, int256 _b)
299     internal
300     pure
301     returns (int256)
302   {
303     if ((_a < 0 && _b > 0) || (_a > 0 && _b < 0)) {
304       return add(_a, _b) / 2;
305     }
306     int256 remainder = (_a % 2 + _b % 2) / 2;
307     return add(add(_a / 2, _b / 2), remainder);
308   }
309 }
310 
311 
312 library Median {
313   using SignedSafeMath for int256;
314 
315   int256 constant INT_MAX = 2**255-1;
316 
317   /**
318    * @notice Returns the sorted middle, or the average of the two middle indexed items if the
319    * array has an even number of elements.
320    * @dev The list passed as an argument isn't modified.
321    * @dev This algorithm has expected runtime O(n), but for adversarially chosen inputs
322    * the runtime is O(n^2).
323    * @param list The list of elements to compare
324    */
325   function calculate(int256[] memory list)
326     internal
327     pure
328     returns (int256)
329   {
330     return calculateInplace(copy(list));
331   }
332 
333   /**
334    * @notice See documentation for function calculate.
335    * @dev The list passed as an argument may be permuted.
336    */
337   function calculateInplace(int256[] memory list)
338     internal
339     pure
340     returns (int256)
341   {
342     require(0 < list.length, "list must not be empty");
343     uint256 len = list.length;
344     uint256 middleIndex = len / 2;
345     if (len % 2 == 0) {
346       int256 median1;
347       int256 median2;
348       (median1, median2) = quickselectTwo(list, 0, len - 1, middleIndex - 1, middleIndex);
349       return SignedSafeMath.avg(median1, median2);
350     } else {
351       return quickselect(list, 0, len - 1, middleIndex);
352     }
353   }
354 
355   /**
356    * @notice Maximum length of list that shortSelectTwo can handle
357    */
358   uint256 constant SHORTSELECTTWO_MAX_LENGTH = 7;
359 
360   /**
361    * @notice Select the k1-th and k2-th element from list of length at most 7
362    * @dev Uses an optimal sorting network
363    */
364   function shortSelectTwo(
365     int256[] memory list,
366     uint256 lo,
367     uint256 hi,
368     uint256 k1,
369     uint256 k2
370   )
371     private
372     pure
373     returns (int256 k1th, int256 k2th)
374   {
375     // Uses an optimal sorting network (https://en.wikipedia.org/wiki/Sorting_network)
376     // for lists of length 7. Network layout is taken from
377     // http://jgamble.ripco.net/cgi-bin/nw.cgi?inputs=7&algorithm=hibbard&output=svg
378 
379     uint256 len = hi + 1 - lo;
380     int256 x0 = list[lo + 0];
381     int256 x1 = 1 < len ? list[lo + 1] : INT_MAX;
382     int256 x2 = 2 < len ? list[lo + 2] : INT_MAX;
383     int256 x3 = 3 < len ? list[lo + 3] : INT_MAX;
384     int256 x4 = 4 < len ? list[lo + 4] : INT_MAX;
385     int256 x5 = 5 < len ? list[lo + 5] : INT_MAX;
386     int256 x6 = 6 < len ? list[lo + 6] : INT_MAX;
387 
388     if (x0 > x1) {(x0, x1) = (x1, x0);}
389     if (x2 > x3) {(x2, x3) = (x3, x2);}
390     if (x4 > x5) {(x4, x5) = (x5, x4);}
391     if (x0 > x2) {(x0, x2) = (x2, x0);}
392     if (x1 > x3) {(x1, x3) = (x3, x1);}
393     if (x4 > x6) {(x4, x6) = (x6, x4);}
394     if (x1 > x2) {(x1, x2) = (x2, x1);}
395     if (x5 > x6) {(x5, x6) = (x6, x5);}
396     if (x0 > x4) {(x0, x4) = (x4, x0);}
397     if (x1 > x5) {(x1, x5) = (x5, x1);}
398     if (x2 > x6) {(x2, x6) = (x6, x2);}
399     if (x1 > x4) {(x1, x4) = (x4, x1);}
400     if (x3 > x6) {(x3, x6) = (x6, x3);}
401     if (x2 > x4) {(x2, x4) = (x4, x2);}
402     if (x3 > x5) {(x3, x5) = (x5, x3);}
403     if (x3 > x4) {(x3, x4) = (x4, x3);}
404 
405     uint256 index1 = k1 - lo;
406     if (index1 == 0) {k1th = x0;}
407     else if (index1 == 1) {k1th = x1;}
408     else if (index1 == 2) {k1th = x2;}
409     else if (index1 == 3) {k1th = x3;}
410     else if (index1 == 4) {k1th = x4;}
411     else if (index1 == 5) {k1th = x5;}
412     else if (index1 == 6) {k1th = x6;}
413     else {revert("k1 out of bounds");}
414 
415     uint256 index2 = k2 - lo;
416     if (k1 == k2) {return (k1th, k1th);}
417     else if (index2 == 0) {return (k1th, x0);}
418     else if (index2 == 1) {return (k1th, x1);}
419     else if (index2 == 2) {return (k1th, x2);}
420     else if (index2 == 3) {return (k1th, x3);}
421     else if (index2 == 4) {return (k1th, x4);}
422     else if (index2 == 5) {return (k1th, x5);}
423     else if (index2 == 6) {return (k1th, x6);}
424     else {revert("k2 out of bounds");}
425   }
426 
427   /**
428    * @notice Selects the k-th ranked element from list, looking only at indices between lo and hi
429    * (inclusive). Modifies list in-place.
430    */
431   function quickselect(int256[] memory list, uint256 lo, uint256 hi, uint256 k)
432     private
433     pure
434     returns (int256 kth)
435   {
436     require(lo <= k);
437     require(k <= hi);
438     while (lo < hi) {
439       if (hi - lo < SHORTSELECTTWO_MAX_LENGTH) {
440         int256 ignore;
441         (kth, ignore) = shortSelectTwo(list, lo, hi, k, k);
442         return kth;
443       }
444       uint256 pivotIndex = partition(list, lo, hi);
445       if (k <= pivotIndex) {
446         // since pivotIndex < (original hi passed to partition),
447         // termination is guaranteed in this case
448         hi = pivotIndex;
449       } else {
450         // since (original lo passed to partition) <= pivotIndex,
451         // termination is guaranteed in this case
452         lo = pivotIndex + 1;
453       }
454     }
455     return list[lo];
456   }
457 
458   /**
459    * @notice Selects the k1-th and k2-th ranked elements from list, looking only at indices between
460    * lo and hi (inclusive). Modifies list in-place.
461    */
462   function quickselectTwo(
463     int256[] memory list,
464     uint256 lo,
465     uint256 hi,
466     uint256 k1,
467     uint256 k2
468   )
469     internal // for testing
470     pure
471     returns (int256 k1th, int256 k2th)
472   {
473     require(k1 < k2);
474     require(lo <= k1 && k1 <= hi);
475     require(lo <= k2 && k2 <= hi);
476 
477     while (true) {
478       if (hi - lo < SHORTSELECTTWO_MAX_LENGTH) {
479         return shortSelectTwo(list, lo, hi, k1, k2);
480       }
481       uint256 pivotIdx = partition(list, lo, hi);
482       if (k2 <= pivotIdx) {
483         hi = pivotIdx;
484       } else if (pivotIdx < k1) {
485         lo = pivotIdx + 1;
486       } else {
487         assert(k1 <= pivotIdx && pivotIdx < k2);
488         k1th = quickselect(list, lo, pivotIdx, k1);
489         k2th = quickselect(list, pivotIdx + 1, hi, k2);
490         return (k1th, k2th);
491       }
492     }
493   }
494 
495   /**
496    * @notice Partitions list in-place using Hoare's partitioning scheme.
497    * Only elements of list between indices lo and hi (inclusive) will be modified.
498    * Returns an index i, such that:
499    * - lo <= i < hi
500    * - forall j in [lo, i]. list[j] <= list[i]
501    * - forall j in [i, hi]. list[i] <= list[j]
502    */
503   function partition(int256[] memory list, uint256 lo, uint256 hi)
504     private
505     pure
506     returns (uint256)
507   {
508     // We don't care about overflow of the addition, because it would require a list
509     // larger than any feasible computer's memory.
510     int256 pivot = list[(lo + hi) / 2];
511     lo -= 1; // this can underflow. that's intentional.
512     hi += 1;
513     while (true) {
514       do {
515         lo += 1;
516       } while (list[lo] < pivot);
517       do {
518         hi -= 1;
519       } while (list[hi] > pivot);
520       if (lo < hi) {
521         (list[lo], list[hi]) = (list[hi], list[lo]);
522       } else {
523         // Let orig_lo and orig_hi be the original values of lo and hi passed to partition.
524         // Then, hi < orig_hi, because hi decreases *strictly* monotonically
525         // in each loop iteration and
526         // - either list[orig_hi] > pivot, in which case the first loop iteration
527         //   will achieve hi < orig_hi;
528         // - or list[orig_hi] <= pivot, in which case at least two loop iterations are
529         //   needed:
530         //   - lo will have to stop at least once in the interval
531         //     [orig_lo, (orig_lo + orig_hi)/2]
532         //   - (orig_lo + orig_hi)/2 < orig_hi
533         return hi;
534       }
535     }
536   }
537 
538   /**
539    * @notice Makes an in-memory copy of the array passed in
540    * @param list Reference to the array to be copied
541    */
542   function copy(int256[] memory list)
543     private
544     pure
545     returns(int256[] memory)
546   {
547     int256[] memory list2 = new int256[](list.length);
548     for (uint256 i = 0; i < list.length; i++) {
549       list2[i] = list[i];
550     }
551     return list2;
552   }
553 }
554 
555 
556 
557 
558 /**
559  * @dev Wrappers over Solidity's arithmetic operations with added overflow
560  * checks.
561  *
562  * Arithmetic operations in Solidity wrap on overflow. This can easily result
563  * in bugs, because programmers usually assume that an overflow raises an
564  * error, which is the standard behavior in high level programming languages.
565  * `SafeMath` restores this intuition by reverting the transaction when an
566  * operation overflows.
567  *
568  * Using this library instead of the unchecked operations eliminates an entire
569  * class of bugs, so it's recommended to use it always.
570  *
571  * This library is a version of Open Zeppelin's SafeMath, modified to support
572  * unsigned 128 bit integers.
573  */
574 library SafeMath128 {
575   /**
576     * @dev Returns the addition of two unsigned integers, reverting on
577     * overflow.
578     *
579     * Counterpart to Solidity's `+` operator.
580     *
581     * Requirements:
582     * - Addition cannot overflow.
583     */
584   function add(uint128 a, uint128 b) internal pure returns (uint128) {
585     uint128 c = a + b;
586     require(c >= a, "SafeMath: addition overflow");
587 
588     return c;
589   }
590 
591   /**
592     * @dev Returns the subtraction of two unsigned integers, reverting on
593     * overflow (when the result is negative).
594     *
595     * Counterpart to Solidity's `-` operator.
596     *
597     * Requirements:
598     * - Subtraction cannot overflow.
599     */
600   function sub(uint128 a, uint128 b) internal pure returns (uint128) {
601     require(b <= a, "SafeMath: subtraction overflow");
602     uint128 c = a - b;
603 
604     return c;
605   }
606 
607   /**
608     * @dev Returns the multiplication of two unsigned integers, reverting on
609     * overflow.
610     *
611     * Counterpart to Solidity's `*` operator.
612     *
613     * Requirements:
614     * - Multiplication cannot overflow.
615     */
616   function mul(uint128 a, uint128 b) internal pure returns (uint128) {
617     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
618     // benefit is lost if 'b' is also tested.
619     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
620     if (a == 0) {
621       return 0;
622     }
623 
624     uint128 c = a * b;
625     require(c / a == b, "SafeMath: multiplication overflow");
626 
627     return c;
628   }
629 
630   /**
631     * @dev Returns the integer division of two unsigned integers. Reverts on
632     * division by zero. The result is rounded towards zero.
633     *
634     * Counterpart to Solidity's `/` operator. Note: this function uses a
635     * `revert` opcode (which leaves remaining gas untouched) while Solidity
636     * uses an invalid opcode to revert (consuming all remaining gas).
637     *
638     * Requirements:
639     * - The divisor cannot be zero.
640     */
641   function div(uint128 a, uint128 b) internal pure returns (uint128) {
642     // Solidity only automatically asserts when dividing by 0
643     require(b > 0, "SafeMath: division by zero");
644     uint128 c = a / b;
645     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
646 
647     return c;
648   }
649 
650   /**
651     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
652     * Reverts when dividing by zero.
653     *
654     * Counterpart to Solidity's `%` operator. This function uses a `revert`
655     * opcode (which leaves remaining gas untouched) while Solidity uses an
656     * invalid opcode to revert (consuming all remaining gas).
657     *
658     * Requirements:
659     * - The divisor cannot be zero.
660     */
661   function mod(uint128 a, uint128 b) internal pure returns (uint128) {
662     require(b != 0, "SafeMath: modulo by zero");
663     return a % b;
664   }
665 }
666 
667 
668 
669 /**
670  * @dev Wrappers over Solidity's arithmetic operations with added overflow
671  * checks.
672  *
673  * Arithmetic operations in Solidity wrap on overflow. This can easily result
674  * in bugs, because programmers usually assume that an overflow raises an
675  * error, which is the standard behavior in high level programming languages.
676  * `SafeMath` restores this intuition by reverting the transaction when an
677  * operation overflows.
678  *
679  * Using this library instead of the unchecked operations eliminates an entire
680  * class of bugs, so it's recommended to use it always.
681  *
682  * This library is a version of Open Zeppelin's SafeMath, modified to support
683  * unsigned 64 bit integers.
684  */
685 library SafeMath64 {
686   /**
687     * @dev Returns the addition of two unsigned integers, reverting on
688     * overflow.
689     *
690     * Counterpart to Solidity's `+` operator.
691     *
692     * Requirements:
693     * - Addition cannot overflow.
694     */
695   function add(uint64 a, uint64 b) internal pure returns (uint64) {
696     uint64 c = a + b;
697     require(c >= a, "SafeMath: addition overflow");
698 
699     return c;
700   }
701 
702   /**
703     * @dev Returns the subtraction of two unsigned integers, reverting on
704     * overflow (when the result is negative).
705     *
706     * Counterpart to Solidity's `-` operator.
707     *
708     * Requirements:
709     * - Subtraction cannot overflow.
710     */
711   function sub(uint64 a, uint64 b) internal pure returns (uint64) {
712     require(b <= a, "SafeMath: subtraction overflow");
713     uint64 c = a - b;
714 
715     return c;
716   }
717 
718   /**
719     * @dev Returns the multiplication of two unsigned integers, reverting on
720     * overflow.
721     *
722     * Counterpart to Solidity's `*` operator.
723     *
724     * Requirements:
725     * - Multiplication cannot overflow.
726     */
727   function mul(uint64 a, uint64 b) internal pure returns (uint64) {
728     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
729     // benefit is lost if 'b' is also tested.
730     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
731     if (a == 0) {
732       return 0;
733     }
734 
735     uint64 c = a * b;
736     require(c / a == b, "SafeMath: multiplication overflow");
737 
738     return c;
739   }
740 
741   /**
742     * @dev Returns the integer division of two unsigned integers. Reverts on
743     * division by zero. The result is rounded towards zero.
744     *
745     * Counterpart to Solidity's `/` operator. Note: this function uses a
746     * `revert` opcode (which leaves remaining gas untouched) while Solidity
747     * uses an invalid opcode to revert (consuming all remaining gas).
748     *
749     * Requirements:
750     * - The divisor cannot be zero.
751     */
752   function div(uint64 a, uint64 b) internal pure returns (uint64) {
753     // Solidity only automatically asserts when dividing by 0
754     require(b > 0, "SafeMath: division by zero");
755     uint64 c = a / b;
756     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
757 
758     return c;
759   }
760 
761   /**
762     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
763     * Reverts when dividing by zero.
764     *
765     * Counterpart to Solidity's `%` operator. This function uses a `revert`
766     * opcode (which leaves remaining gas untouched) while Solidity uses an
767     * invalid opcode to revert (consuming all remaining gas).
768     *
769     * Requirements:
770     * - The divisor cannot be zero.
771     */
772   function mod(uint64 a, uint64 b) internal pure returns (uint64) {
773     require(b != 0, "SafeMath: modulo by zero");
774     return a % b;
775   }
776 }
777 
778 
779 
780 /**
781  * @dev Wrappers over Solidity's arithmetic operations with added overflow
782  * checks.
783  *
784  * Arithmetic operations in Solidity wrap on overflow. This can easily result
785  * in bugs, because programmers usually assume that an overflow raises an
786  * error, which is the standard behavior in high level programming languages.
787  * `SafeMath` restores this intuition by reverting the transaction when an
788  * operation overflows.
789  *
790  * Using this library instead of the unchecked operations eliminates an entire
791  * class of bugs, so it's recommended to use it always.
792  *
793  * This library is a version of Open Zeppelin's SafeMath, modified to support
794  * unsigned 32 bit integers.
795  */
796 library SafeMath32 {
797   /**
798     * @dev Returns the addition of two unsigned integers, reverting on
799     * overflow.
800     *
801     * Counterpart to Solidity's `+` operator.
802     *
803     * Requirements:
804     * - Addition cannot overflow.
805     */
806   function add(uint32 a, uint32 b) internal pure returns (uint32) {
807     uint32 c = a + b;
808     require(c >= a, "SafeMath: addition overflow");
809 
810     return c;
811   }
812 
813   /**
814     * @dev Returns the subtraction of two unsigned integers, reverting on
815     * overflow (when the result is negative).
816     *
817     * Counterpart to Solidity's `-` operator.
818     *
819     * Requirements:
820     * - Subtraction cannot overflow.
821     */
822   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
823     require(b <= a, "SafeMath: subtraction overflow");
824     uint32 c = a - b;
825 
826     return c;
827   }
828 
829   /**
830     * @dev Returns the multiplication of two unsigned integers, reverting on
831     * overflow.
832     *
833     * Counterpart to Solidity's `*` operator.
834     *
835     * Requirements:
836     * - Multiplication cannot overflow.
837     */
838   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
839     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
840     // benefit is lost if 'b' is also tested.
841     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
842     if (a == 0) {
843       return 0;
844     }
845 
846     uint32 c = a * b;
847     require(c / a == b, "SafeMath: multiplication overflow");
848 
849     return c;
850   }
851 
852   /**
853     * @dev Returns the integer division of two unsigned integers. Reverts on
854     * division by zero. The result is rounded towards zero.
855     *
856     * Counterpart to Solidity's `/` operator. Note: this function uses a
857     * `revert` opcode (which leaves remaining gas untouched) while Solidity
858     * uses an invalid opcode to revert (consuming all remaining gas).
859     *
860     * Requirements:
861     * - The divisor cannot be zero.
862     */
863   function div(uint32 a, uint32 b) internal pure returns (uint32) {
864     // Solidity only automatically asserts when dividing by 0
865     require(b > 0, "SafeMath: division by zero");
866     uint32 c = a / b;
867     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
868 
869     return c;
870   }
871 
872   /**
873     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
874     * Reverts when dividing by zero.
875     *
876     * Counterpart to Solidity's `%` operator. This function uses a `revert`
877     * opcode (which leaves remaining gas untouched) while Solidity uses an
878     * invalid opcode to revert (consuming all remaining gas).
879     *
880     * Requirements:
881     * - The divisor cannot be zero.
882     */
883   function mod(uint32 a, uint32 b) internal pure returns (uint32) {
884     require(b != 0, "SafeMath: modulo by zero");
885     return a % b;
886   }
887 }
888 
889 
890 
891 
892 
893 
894 /**
895  * @title The Prepaid Aggregator contract
896  * @notice Node handles aggregating data pushed in from off-chain, and unlocks
897  * payment for oracles as they report. Oracles' submissions are gathered in
898  * rounds, with each round aggregating the submissions for each oracle into a
899  * single answer. The latest aggregated answer is exposed as well as historical
900  * answers and their updated at timestamp.
901  */
902 contract FluxAggregator is AggregatorInterface, AggregatorV3Interface, Owned {
903   using SafeMath for uint256;
904   using SafeMath128 for uint128;
905   using SafeMath64 for uint64;
906   using SafeMath32 for uint32;
907 
908   struct Round {
909     int256 answer;
910     uint64 startedAt;
911     uint64 updatedAt;
912     uint32 answeredInRound;
913     RoundDetails details;
914   }
915 
916   struct RoundDetails {
917     int256[] submissions;
918     uint32 maxSubmissions;
919     uint32 minSubmissions;
920     uint32 timeout;
921     uint128 paymentAmount;
922   }
923 
924   struct OracleStatus {
925     uint128 withdrawable;
926     uint32 startingRound;
927     uint32 endingRound;
928     uint32 lastReportedRound;
929     uint32 lastStartedRound;
930     int256 latestSubmission;
931     uint16 index;
932     address admin;
933     address pendingAdmin;
934   }
935 
936   struct Requester {
937     bool authorized;
938     uint32 delay;
939     uint32 lastStartedRound;
940   }
941 
942 
943   LinkTokenInterface public linkToken;
944   uint128 public allocatedFunds;
945   uint128 public availableFunds;
946 
947   // Round related params
948   uint128 public paymentAmount;
949   uint32 public maxSubmissionCount;
950   uint32 public minSubmissionCount;
951   uint32 public restartDelay;
952   uint32 public timeout;
953   uint8 public override decimals;
954   string public override description;
955 
956   int256 immutable public minSubmissionValue;
957   int256 immutable public maxSubmissionValue;
958 
959   uint256 constant public override version = 3;
960 
961   /**
962    * @notice To ensure owner isn't withdrawing required funds as oracles are
963    * submitting updates, we enforce that the contract maintains a minimum
964    * reserve of RESERVE_ROUNDS * oracleCount() LINK earmarked for payment to
965    * oracles. (Of course, this doesn't prevent the contract from running out of
966    * funds without the owner's intervention.)
967    */
968   uint256 constant private RESERVE_ROUNDS = 2;
969   uint256 constant private MAX_ORACLE_COUNT = 77;
970   uint32 constant private ROUND_MAX = 2**32-1;
971 
972   uint32 private reportingRoundId;
973   uint32 internal latestRoundId;
974   mapping(address => OracleStatus) private oracles;
975   mapping(uint32 => Round) internal rounds;
976   mapping(address => Requester) internal requesters;
977   address[] private oracleAddresses;
978 
979   event AvailableFundsUpdated(
980     uint256 indexed amount
981   );
982   event RoundDetailsUpdated(
983     uint128 indexed paymentAmount,
984     uint32 indexed minSubmissionCount,
985     uint32 indexed maxSubmissionCount,
986     uint32 restartDelay,
987     uint32 timeout // measured in seconds
988   );
989   event OraclePermissionsUpdated(
990     address indexed oracle,
991     bool indexed whitelisted
992   );
993   event OracleAdminUpdated(
994     address indexed oracle,
995     address indexed newAdmin
996   );
997   event OracleAdminUpdateRequested(
998     address indexed oracle,
999     address admin,
1000     address newAdmin
1001   );
1002   event SubmissionReceived(
1003     int256 indexed submission,
1004     uint32 indexed round,
1005     address indexed oracle
1006   );
1007   event RequesterPermissionsSet(
1008     address indexed requester,
1009     bool authorized,
1010     uint32 delay
1011   );
1012 
1013   /**
1014    * @notice Deploy with the address of the LINK token and initial payment amount
1015    * @dev Sets the LinkToken address and amount of LINK paid
1016    * @param _link The address of the LINK token
1017    * @param _paymentAmount The amount paid of LINK paid to each oracle per submission, in wei (units of 10⁻¹⁸ LINK)
1018    * @param _timeout is the number of seconds after the previous round that are
1019    * allowed to lapse before allowing an oracle to skip an unfinished round
1020    */
1021   constructor(
1022     address _link,
1023     uint128 _paymentAmount,
1024     uint32 _timeout,
1025     int256 _minSubmissionValue,
1026     int256 _maxSubmissionValue,
1027     uint8 _decimals,
1028     string memory _description
1029   ) public {
1030     linkToken = LinkTokenInterface(_link);
1031     paymentAmount = _paymentAmount;
1032     timeout = _timeout;
1033     minSubmissionValue = _minSubmissionValue;
1034     maxSubmissionValue = _maxSubmissionValue;
1035     decimals = _decimals;
1036     description = _description;
1037     rounds[0].updatedAt = uint64(block.timestamp.sub(uint256(_timeout)));
1038   }
1039 
1040   /**
1041    * @notice called by oracles when they have witnessed a need to update
1042    * @param _roundId is the ID of the round this submission pertains to
1043    * @param _submission is the updated data that the oracle is submitting
1044    */
1045   function submit(uint256 _roundId, int256 _submission)
1046     external
1047   {
1048     bytes memory error = validateOracleRound(msg.sender, uint32(_roundId));
1049     require(_submission >= minSubmissionValue, "value below minSubmissionValue");
1050     require(_submission <= maxSubmissionValue, "value above maxSubmissionValue");
1051     require(error.length == 0, string(error));
1052 
1053     oracleInitializeNewRound(uint32(_roundId));
1054     recordSubmission(_submission, uint32(_roundId));
1055     updateRoundAnswer(uint32(_roundId));
1056     payOracle(uint32(_roundId));
1057     deleteRoundDetails(uint32(_roundId));
1058   }
1059 
1060   /**
1061    * @notice called by the owner to add new Oracles and update the round
1062    * related parameters
1063    * @param _oracles is the list of addresses of the new Oracles being added
1064    * @param _admins is the admin addresses of the new respective _oracles list.
1065    * Only this address is allowed to access the respective oracle's funds.
1066    * @param _minSubmissions is the new minimum submission count for each round
1067    * @param _maxSubmissions is the new maximum submission count for each round
1068    * @param _restartDelay is the number of rounds an Oracle has to wait before
1069    * they can initiate a round
1070    */
1071   function addOracles(
1072     address[] calldata _oracles,
1073     address[] calldata _admins,
1074     uint32 _minSubmissions,
1075     uint32 _maxSubmissions,
1076     uint32 _restartDelay
1077   )
1078     external
1079     onlyOwner()
1080   {
1081     require(_oracles.length == _admins.length, "need same oracle and admin count");
1082     require(uint256(oracleCount()).add(_oracles.length) <= MAX_ORACLE_COUNT, "max oracles allowed");
1083 
1084     for (uint256 i = 0; i < _oracles.length; i++) {
1085       addOracle(_oracles[i], _admins[i]);
1086     }
1087 
1088     updateFutureRounds(paymentAmount, _minSubmissions, _maxSubmissions, _restartDelay, timeout);
1089   }
1090 
1091   /**
1092    * @notice called by the owner to remove Oracles and update the round
1093    * related parameters
1094    * @param _oracles is the address of the Oracles being removed
1095    * @param _minSubmissions is the new minimum submission count for each round
1096    * @param _maxSubmissions is the new maximum submission count for each round
1097    * @param _restartDelay is the number of rounds an Oracle has to wait before
1098    * they can initiate a round
1099    */
1100   function removeOracles(
1101     address[] calldata _oracles,
1102     uint32 _minSubmissions,
1103     uint32 _maxSubmissions,
1104     uint32 _restartDelay
1105   )
1106     external
1107     onlyOwner()
1108   {
1109     for (uint256 i = 0; i < _oracles.length; i++) {
1110       removeOracle(_oracles[i]);
1111     }
1112 
1113     updateFutureRounds(paymentAmount, _minSubmissions, _maxSubmissions, _restartDelay, timeout);
1114   }
1115 
1116   /**
1117    * @notice update the round and payment related parameters for subsequent
1118    * rounds
1119    * @param _paymentAmount is the payment amount for subsequent rounds
1120    * @param _minSubmissions is the new minimum submission count for each round
1121    * @param _maxSubmissions is the new maximum submission count for each round
1122    * @param _restartDelay is the number of rounds an Oracle has to wait before
1123    * they can initiate a round
1124    */
1125   function updateFutureRounds(
1126     uint128 _paymentAmount,
1127     uint32 _minSubmissions,
1128     uint32 _maxSubmissions,
1129     uint32 _restartDelay,
1130     uint32 _timeout
1131   )
1132     public
1133     onlyOwner()
1134   {
1135     uint32 oracleNum = oracleCount(); // Save on storage reads
1136     require(_maxSubmissions >= _minSubmissions, "max must equal/exceed min");
1137     require(oracleNum >= _maxSubmissions, "max cannot exceed total");
1138     require(oracleNum == 0 || oracleNum > _restartDelay, "delay cannot exceed total");
1139     require(availableFunds >= requiredReserve(_paymentAmount), "insufficient funds for payment");
1140     if (oracleCount() > 0) {
1141       require(_minSubmissions > 0, "min must be greater than 0");
1142     }
1143 
1144     paymentAmount = _paymentAmount;
1145     minSubmissionCount = _minSubmissions;
1146     maxSubmissionCount = _maxSubmissions;
1147     restartDelay = _restartDelay;
1148     timeout = _timeout;
1149 
1150     emit RoundDetailsUpdated(
1151       paymentAmount,
1152       _minSubmissions,
1153       _maxSubmissions,
1154       _restartDelay,
1155       _timeout
1156     );
1157   }
1158 
1159   /**
1160    * @notice recalculate the amount of LINK available for payouts
1161    */
1162   function updateAvailableFunds()
1163     public
1164   {
1165     uint128 pastAvailableFunds = availableFunds;
1166 
1167     uint256 available = linkToken.balanceOf(address(this)).sub(allocatedFunds);
1168     availableFunds = uint128(available);
1169 
1170     if (pastAvailableFunds != available) {
1171       emit AvailableFundsUpdated(available);
1172     }
1173   }
1174 
1175   /**
1176    * @notice returns the number of oracles
1177    */
1178   function oracleCount() public view returns (uint32) {
1179     return uint32(oracleAddresses.length);
1180   }
1181 
1182   /**
1183    * @notice returns an array of addresses containing the oracles on contract
1184    */
1185   function getOracles() external view returns (address[] memory) {
1186     return oracleAddresses;
1187   }
1188 
1189   /**
1190    * @notice get the most recently reported answer
1191    * @dev deprecated. Use latestRoundData instead.
1192    */
1193   function latestAnswer()
1194     public
1195     view
1196     virtual
1197     override
1198     returns (int256)
1199   {
1200     return rounds[latestRoundId].answer;
1201   }
1202 
1203   /**
1204    * @notice get the most recent updated at timestamp
1205    * @dev deprecated. Use latestRoundData instead.
1206    */
1207   function latestTimestamp()
1208     public
1209     view
1210     virtual
1211     override
1212     returns (uint256)
1213   {
1214     return rounds[latestRoundId].updatedAt;
1215   }
1216 
1217   /**
1218    * @notice get the ID of the last updated round
1219    * @dev deprecated. Use latestRoundData instead.
1220    */
1221   function latestRound()
1222     public
1223     view
1224     override
1225     returns (uint256)
1226   {
1227     return latestRoundId;
1228   }
1229 
1230   /**
1231    * @notice get the ID of the round most recently reported on
1232    */
1233   function reportingRound()
1234     external
1235     view
1236     returns (uint256)
1237   {
1238     return reportingRoundId;
1239   }
1240 
1241   /**
1242    * @notice get past rounds answers
1243    * @param _roundId the round number to retrieve the answer for
1244    * @dev deprecated. Use getRoundData instead.
1245    */
1246   function getAnswer(uint256 _roundId)
1247     public
1248     view
1249     virtual
1250     override
1251     returns (int256)
1252   {
1253     return rounds[uint32(_roundId)].answer;
1254   }
1255 
1256   /**
1257    * @notice get timestamp when an answer was last updated
1258    * @param _roundId the round number to retrieve the updated timestamp for
1259    * @dev deprecated. Use getRoundData instead.
1260    */
1261   function getTimestamp(uint256 _roundId)
1262     public
1263     view
1264     virtual
1265     override
1266     returns (uint256)
1267   {
1268     return rounds[uint32(_roundId)].updatedAt;
1269   }
1270 
1271   /**
1272    * @notice get data about a round. Consumers are encouraged to check
1273    * that they're receiving fresh data by inspecting the updatedAt and
1274    * answeredInRound return values.
1275    * @param _roundId the round ID to retrieve the round data for
1276    * @return roundId is the round ID for which data was retrieved
1277    * @return answer is the answer for the given round
1278    * @return startedAt is the timestamp when the round was started. This is 0
1279    * if the round hasn't been started yet.
1280    * @return updatedAt is the timestamp when the round last was updated (i.e.
1281    * answer was last computed)
1282    * @return answeredInRound is the round ID of the round in which the answer
1283    * was computed. answeredInRound may be smaller than roundId when the round
1284    * timed out. answerInRound is equal to roundId when the round didn't time out
1285    * and was completed regularly.
1286    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet received
1287    * maxSubmissions) answer and updatedAt may change between queries.
1288    */
1289   function getRoundData(uint256 _roundId)
1290     public
1291     view
1292     virtual
1293     override
1294     returns (
1295       uint256 roundId,
1296       int256 answer,
1297       uint256 startedAt,
1298       uint256 updatedAt,
1299       uint256 answeredInRound
1300     )
1301   {
1302     Round memory r = rounds[uint32(_roundId)];
1303     return (
1304       _roundId,
1305       r.answer,
1306       r.startedAt,
1307       r.updatedAt,
1308       r.answeredInRound
1309     );
1310   }
1311 
1312   /**
1313    * @notice get data about the latest round. Consumers are encouraged to check
1314    * that they're receiving fresh data by inspecting the updatedAt and
1315    * answeredInRound return values. Consumers are encouraged to
1316    * use this more fully featured method over the "legacy" getAnswer/
1317    * latestAnswer/getTimestamp/latestTimestamp functions.
1318    * @return roundId is the round ID for which data was retrieved
1319    * @return answer is the answer for the given round
1320    * @return startedAt is the timestamp when the round was started. This is 0
1321    * if the round hasn't been started yet.
1322    * @return updatedAt is the timestamp when the round last was updated (i.e.
1323    * answer was last computed)
1324    * @return answeredInRound is the round ID of the round in which the answer
1325    * was computed. answeredInRound may be smaller than roundId when the round
1326    * timed out. answerInRound is equal to roundId when the round didn't time out
1327    * and was completed regularly.
1328    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet received
1329    * maxSubmissions) answer and updatedAt may change between queries.
1330    */
1331    function latestRoundData()
1332     public
1333     view
1334     virtual
1335     override
1336     returns (
1337       uint256 roundId,
1338       int256 answer,
1339       uint256 startedAt,
1340       uint256 updatedAt,
1341       uint256 answeredInRound
1342     )
1343   {
1344     return getRoundData(latestRoundId);
1345   }
1346 
1347 
1348   /**
1349    * @notice query the available amount of LINK for an oracle to withdraw
1350    */
1351   function withdrawablePayment(address _oracle)
1352     external
1353     view
1354     returns (uint256)
1355   {
1356     return oracles[_oracle].withdrawable;
1357   }
1358 
1359   /**
1360    * @notice transfers the oracle's LINK to another address. Can only be called
1361    * by the oracle's admin.
1362    * @param _oracle is the oracle whose LINK is transferred
1363    * @param _recipient is the address to send the LINK to
1364    * @param _amount is the amount of LINK to send
1365    */
1366   function withdrawPayment(address _oracle, address _recipient, uint256 _amount)
1367     external
1368   {
1369     require(oracles[_oracle].admin == msg.sender, "only callable by admin");
1370 
1371     // Safe to downcast _amount because the total amount of LINK is less than 2^128.
1372     uint128 amount = uint128(_amount);
1373     uint128 available = oracles[_oracle].withdrawable;
1374     require(available >= amount, "insufficient withdrawable funds");
1375 
1376     oracles[_oracle].withdrawable = available.sub(amount);
1377     allocatedFunds = allocatedFunds.sub(amount);
1378 
1379     assert(linkToken.transfer(_recipient, uint256(amount)));
1380   }
1381 
1382   /**
1383    * @notice transfers the owner's LINK to another address
1384    * @param _recipient is the address to send the LINK to
1385    * @param _amount is the amount of LINK to send
1386    */
1387   function withdrawFunds(address _recipient, uint256 _amount)
1388     external
1389     onlyOwner()
1390   {
1391     require(uint256(availableFunds).sub(requiredReserve(paymentAmount)) >= _amount, "insufficient reserve funds");
1392     require(linkToken.transfer(_recipient, _amount), "token transfer failed");
1393     updateAvailableFunds();
1394   }
1395 
1396   /**
1397    * @notice get the latest submission for any oracle
1398    * @param _oracle is the address to lookup the latest submission for
1399    */
1400   function latestSubmission(address _oracle)
1401     external
1402     view
1403     returns (int256, uint256)
1404   {
1405     return (oracles[_oracle].latestSubmission, oracles[_oracle].lastReportedRound);
1406   }
1407 
1408   /**
1409    * @notice get the admin address of an oracle
1410    * @param _oracle is the address of the oracle whose admin is being queried
1411    */
1412   function getAdmin(address _oracle)
1413     external
1414     view
1415     returns (address)
1416   {
1417     return oracles[_oracle].admin;
1418   }
1419 
1420   /**
1421    * @notice transfer the admin address for an oracle
1422    * @param _oracle is the address of the oracle whose admin is being transfered
1423    * @param _newAdmin is the new admin address
1424    */
1425   function transferAdmin(address _oracle, address _newAdmin)
1426     external
1427   {
1428     require(oracles[_oracle].admin == msg.sender, "only callable by admin");
1429     oracles[_oracle].pendingAdmin = _newAdmin;
1430 
1431     emit OracleAdminUpdateRequested(_oracle, msg.sender, _newAdmin);
1432   }
1433 
1434   /**
1435    * @notice accept the admin address transfer for an oracle
1436    * @param _oracle is the address of the oracle whose admin is being transfered
1437    */
1438   function acceptAdmin(address _oracle)
1439     external
1440   {
1441     require(oracles[_oracle].pendingAdmin == msg.sender, "only callable by pending admin");
1442     oracles[_oracle].pendingAdmin = address(0);
1443     oracles[_oracle].admin = msg.sender;
1444 
1445     emit OracleAdminUpdated(_oracle, msg.sender);
1446   }
1447 
1448   /**
1449    * @notice allows non-oracles to request a new round
1450    */
1451   function requestNewRound()
1452     external
1453   {
1454     require(requesters[msg.sender].authorized, "not authorized requester");
1455 
1456     uint32 current = reportingRoundId;
1457     require(rounds[current].updatedAt > 0 || timedOut(current), "prev round must be supersedable");
1458 
1459     requesterInitializeNewRound(current.add(1));
1460   }
1461 
1462   /**
1463    * @notice allows the owner to specify new non-oracles to start new rounds
1464    * @param _requester is the address to set permissions for
1465    * @param _authorized is a boolean specifying whether they can start new rounds or not
1466    * @param _delay is the number of rounds the requester must wait before starting another round
1467    */
1468   function setRequesterPermissions(address _requester, bool _authorized, uint32 _delay)
1469     external
1470     onlyOwner()
1471   {
1472     if (requesters[_requester].authorized == _authorized) return;
1473 
1474     if (_authorized) {
1475       requesters[_requester].authorized = _authorized;
1476       requesters[_requester].delay = _delay;
1477     } else {
1478       delete requesters[_requester];
1479     }
1480 
1481     emit RequesterPermissionsSet(_requester, _authorized, _delay);
1482   }
1483 
1484   /**
1485    * @notice called through LINK's transferAndCall to update available funds
1486    * in the same transaction as the funds were transfered to the aggregator
1487    * @param _data is mostly ignored. It is checked for length, to be sure
1488    * nothing strange is passed in.
1489    */
1490   function onTokenTransfer(address, uint256, bytes calldata _data)
1491     external
1492   {
1493     require(_data.length == 0, "transfer doesn't accept calldata");
1494     updateAvailableFunds();
1495   }
1496 
1497   /**
1498    * @notice a method to provide all current info oracles need. Intended only
1499    * only to be callable by oracles. Not for use by contracts to read state.
1500    * @param _oracle the address to look up information for.
1501    */
1502   function oracleRoundState(address _oracle, uint32 _queriedRoundId)
1503     external
1504     view
1505     returns (
1506       bool _eligibleToSubmit,
1507       uint32 _roundId,
1508       int256 _latestSubmission,
1509       uint64 _startedAt,
1510       uint64 _timeout,
1511       uint128 _availableFunds,
1512       uint32 _oracleCount,
1513       uint128 _paymentAmount
1514     )
1515   {
1516     require(msg.sender == tx.origin, "off-chain reading only");
1517 
1518     if (_queriedRoundId > 0) {
1519       Round storage round = rounds[_queriedRoundId];
1520       return (
1521         eligibleForSpecificRound(_oracle, _queriedRoundId),
1522         _queriedRoundId,
1523         oracles[_oracle].latestSubmission,
1524         round.startedAt,
1525         round.details.timeout,
1526         availableFunds,
1527         oracleCount(),
1528         (round.startedAt > 0 ? round.details.paymentAmount : paymentAmount)
1529       );
1530     } else {
1531       return oracleRoundStateSuggestRound(_oracle);
1532     }
1533   }
1534 
1535   function eligibleForSpecificRound(address _oracle, uint32 _queriedRoundId)
1536     private
1537     view
1538     returns (bool _eligible)
1539   {
1540     if (rounds[_queriedRoundId].startedAt > 0) {
1541       return acceptingSubmissions(_queriedRoundId) && validateOracleRound(_oracle, _queriedRoundId).length == 0;
1542     } else {
1543       return delayed(_oracle, _queriedRoundId) && validateOracleRound(_oracle, _queriedRoundId).length == 0;
1544     }
1545   }
1546 
1547   function oracleRoundStateSuggestRound(address _oracle)
1548     private
1549     view
1550     returns (
1551       bool _eligibleToSubmit,
1552       uint32 _roundId,
1553       int256 _latestSubmission,
1554       uint64 _startedAt,
1555       uint64 _timeout,
1556       uint128 _availableFunds,
1557       uint32 _oracleCount,
1558       uint128 _paymentAmount
1559     )
1560   {
1561     Round storage round = rounds[0];
1562     OracleStatus storage oracle = oracles[_oracle];
1563 
1564     bool shouldSupersede = oracle.lastReportedRound == reportingRoundId || !acceptingSubmissions(reportingRoundId);
1565     // Instead of nudging oracles to submit to the next round, the inclusion of
1566     // the shouldSupersede bool in the if condition pushes them towards
1567     // submitting in a currently open round.
1568     if (supersedable(reportingRoundId) && shouldSupersede) {
1569       _roundId = reportingRoundId.add(1);
1570       round = rounds[_roundId];
1571 
1572       _paymentAmount = paymentAmount;
1573       _eligibleToSubmit = delayed(_oracle, _roundId);
1574     } else {
1575       _roundId = reportingRoundId;
1576       round = rounds[_roundId];
1577 
1578       _paymentAmount = round.details.paymentAmount;
1579       _eligibleToSubmit = acceptingSubmissions(_roundId);
1580     }
1581 
1582     if (validateOracleRound(_oracle, _roundId).length != 0) {
1583       _eligibleToSubmit = false;
1584     }
1585 
1586     return (
1587       _eligibleToSubmit,
1588       _roundId,
1589       oracle.latestSubmission,
1590       round.startedAt,
1591       round.details.timeout,
1592       availableFunds,
1593       oracleCount(),
1594       _paymentAmount
1595     );
1596   }
1597 
1598 
1599   /**
1600    * Private
1601    */
1602 
1603   function initializeNewRound(uint32 _roundId)
1604     private
1605   {
1606     updateTimedOutRoundInfo(_roundId.sub(1));
1607 
1608     reportingRoundId = _roundId;
1609     rounds[_roundId].details.maxSubmissions = maxSubmissionCount;
1610     rounds[_roundId].details.minSubmissions = minSubmissionCount;
1611     rounds[_roundId].details.paymentAmount = paymentAmount;
1612     rounds[_roundId].details.timeout = timeout;
1613     rounds[_roundId].startedAt = uint64(block.timestamp);
1614 
1615     emit NewRound(_roundId, msg.sender, rounds[_roundId].startedAt);
1616   }
1617 
1618   function oracleInitializeNewRound(uint32 _roundId)
1619     private
1620   {
1621     if (!newRound(_roundId)) return;
1622     uint256 lastStarted = oracles[msg.sender].lastStartedRound; // cache storage reads
1623     if (_roundId <= lastStarted + restartDelay && lastStarted != 0) return;
1624 
1625     initializeNewRound(_roundId);
1626 
1627     oracles[msg.sender].lastStartedRound = _roundId;
1628   }
1629 
1630   function requesterInitializeNewRound(uint32 _roundId)
1631     private
1632   {
1633     if (!newRound(_roundId)) return;
1634     uint256 lastStarted = requesters[msg.sender].lastStartedRound; // cache storage reads
1635     require(_roundId > lastStarted + requesters[msg.sender].delay || lastStarted == 0, "must delay requests");
1636 
1637     initializeNewRound(_roundId);
1638 
1639     requesters[msg.sender].lastStartedRound = _roundId;
1640   }
1641 
1642   function updateTimedOutRoundInfo(uint32 _roundId)
1643     private
1644   {
1645     if (!timedOut(_roundId)) return;
1646 
1647     uint32 prevId = _roundId.sub(1);
1648     rounds[_roundId].answer = rounds[prevId].answer;
1649     rounds[_roundId].answeredInRound = rounds[prevId].answeredInRound;
1650     rounds[_roundId].updatedAt = uint64(block.timestamp);
1651 
1652     delete rounds[_roundId].details;
1653   }
1654 
1655   function updateRoundAnswer(uint32 _roundId)
1656     private
1657   {
1658     if (rounds[_roundId].details.submissions.length < rounds[_roundId].details.minSubmissions) return;
1659 
1660     int256 newAnswer = Median.calculateInplace(rounds[_roundId].details.submissions);
1661     rounds[_roundId].answer = newAnswer;
1662     rounds[_roundId].updatedAt = uint64(block.timestamp);
1663     rounds[_roundId].answeredInRound = _roundId;
1664     latestRoundId = _roundId;
1665 
1666     emit AnswerUpdated(newAnswer, _roundId, now);
1667   }
1668 
1669   function payOracle(uint32 _roundId)
1670     private
1671   {
1672     uint128 payment = rounds[_roundId].details.paymentAmount;
1673     uint128 available = availableFunds.sub(payment);
1674 
1675     availableFunds = available;
1676     allocatedFunds = allocatedFunds.add(payment);
1677     oracles[msg.sender].withdrawable = oracles[msg.sender].withdrawable.add(payment);
1678 
1679     emit AvailableFundsUpdated(available);
1680   }
1681 
1682   function recordSubmission(int256 _submission, uint32 _roundId)
1683     private
1684   {
1685     require(acceptingSubmissions(_roundId), "round not accepting submissions");
1686 
1687     rounds[_roundId].details.submissions.push(_submission);
1688     oracles[msg.sender].lastReportedRound = _roundId;
1689     oracles[msg.sender].latestSubmission = _submission;
1690 
1691     emit SubmissionReceived(_submission, _roundId, msg.sender);
1692   }
1693 
1694   function deleteRoundDetails(uint32 _roundId)
1695     private
1696   {
1697     if (rounds[_roundId].details.submissions.length < rounds[_roundId].details.maxSubmissions) return;
1698 
1699     delete rounds[_roundId].details;
1700   }
1701 
1702   function timedOut(uint32 _roundId)
1703     private
1704     view
1705     returns (bool)
1706   {
1707     uint64 startedAt = rounds[_roundId].startedAt;
1708     uint32 roundTimeout = rounds[_roundId].details.timeout;
1709     return startedAt > 0 && roundTimeout > 0 && startedAt.add(roundTimeout) < block.timestamp;
1710   }
1711 
1712   function getStartingRound(address _oracle)
1713     private
1714     view
1715     returns (uint32)
1716   {
1717     uint32 currentRound = reportingRoundId;
1718     if (currentRound != 0 && currentRound == oracles[_oracle].endingRound) {
1719       return currentRound;
1720     }
1721     return currentRound.add(1);
1722   }
1723 
1724   function previousAndCurrentUnanswered(uint32 _roundId, uint32 _rrId)
1725     private
1726     view
1727     returns (bool)
1728   {
1729     return _roundId.add(1) == _rrId && rounds[_rrId].updatedAt == 0;
1730   }
1731 
1732   function requiredReserve(uint256 payment)
1733     private
1734     view
1735     returns (uint256)
1736   {
1737     return payment.mul(oracleCount()).mul(RESERVE_ROUNDS);
1738   }
1739 
1740   function addOracle(
1741     address _oracle,
1742     address _admin
1743   )
1744     private
1745   {
1746     require(!oracleEnabled(_oracle), "oracle already enabled");
1747 
1748     require(_admin != address(0), "cannot set admin to 0");
1749     require(oracles[_oracle].admin == address(0) || oracles[_oracle].admin == _admin, "owner cannot overwrite admin");
1750 
1751     oracles[_oracle].startingRound = getStartingRound(_oracle);
1752     oracles[_oracle].endingRound = ROUND_MAX;
1753     oracles[_oracle].index = uint16(oracleAddresses.length);
1754     oracleAddresses.push(_oracle);
1755     oracles[_oracle].admin = _admin;
1756 
1757     emit OraclePermissionsUpdated(_oracle, true);
1758     emit OracleAdminUpdated(_oracle, _admin);
1759   }
1760 
1761   function removeOracle(
1762     address _oracle
1763   )
1764     private
1765   {
1766     require(oracleEnabled(_oracle), "oracle not enabled");
1767 
1768     oracles[_oracle].endingRound = reportingRoundId.add(1);
1769     address tail = oracleAddresses[oracleCount().sub(1)];
1770     uint16 index = oracles[_oracle].index;
1771     oracles[tail].index = index;
1772     delete oracles[_oracle].index;
1773     oracleAddresses[index] = tail;
1774     oracleAddresses.pop();
1775 
1776     emit OraclePermissionsUpdated(_oracle, false);
1777   }
1778 
1779   function validateOracleRound(address _oracle, uint32 _roundId)
1780     private
1781     view
1782     returns (bytes memory)
1783   {
1784     // cache storage reads
1785     uint32 startingRound = oracles[_oracle].startingRound;
1786     uint32 rrId = reportingRoundId;
1787 
1788     if (startingRound == 0) return "not enabled oracle";
1789     if (startingRound > _roundId) return "not yet enabled oracle";
1790     if (oracles[_oracle].endingRound < _roundId) return "no longer allowed oracle";
1791     if (oracles[_oracle].lastReportedRound >= _roundId) return "cannot report on previous rounds";
1792     if (_roundId != rrId && _roundId != rrId.add(1) && !previousAndCurrentUnanswered(_roundId, rrId)) return "invalid round to report";
1793     if (_roundId != 1 && !supersedable(_roundId.sub(1))) return "previous round not supersedable";
1794   }
1795 
1796   function supersedable(uint32 _roundId)
1797     private
1798     view
1799     returns (bool)
1800   {
1801     return rounds[_roundId].updatedAt > 0 || timedOut(_roundId);
1802   }
1803 
1804   function oracleEnabled(address _oracle)
1805     private
1806     view
1807     returns (bool)
1808   {
1809     return oracles[_oracle].endingRound == ROUND_MAX;
1810   }
1811 
1812   function acceptingSubmissions(uint32 _roundId)
1813     private
1814     view
1815     returns (bool)
1816   {
1817     return rounds[_roundId].details.maxSubmissions != 0;
1818   }
1819 
1820   function delayed(address _oracle, uint32 _roundId)
1821     private
1822     view
1823     returns (bool)
1824   {
1825     uint256 lastStarted = oracles[_oracle].lastStartedRound;
1826     return _roundId > lastStarted + restartDelay || lastStarted == 0;
1827   }
1828 
1829   function newRound(uint32 _roundId)
1830     private
1831     view
1832     returns (bool)
1833   {
1834     return _roundId == reportingRoundId.add(1);
1835   }
1836 
1837 }
1838 
1839 
1840 
1841 
1842 
1843 
1844 /**
1845  * @title SimpleAccessControl
1846  * @notice Allows the owner to set access for addresses
1847  */
1848 contract SimpleAccessControl is AccessControllerInterface, Owned {
1849 
1850   bool public checkEnabled;
1851   mapping(address => bool) internal accessList;
1852 
1853   event AddedAccess(address user);
1854   event RemovedAccess(address user);
1855   event CheckAccessEnabled();
1856   event CheckAccessDisabled();
1857 
1858   constructor()
1859     public
1860   {
1861     checkEnabled = true;
1862   }
1863 
1864   /**
1865    * @notice Returns the access of an address
1866    * @param _user The address to query
1867    */
1868   function hasAccess(
1869     address _user,
1870     bytes memory
1871   )
1872     public
1873     view
1874     override
1875     returns (bool)
1876   {
1877     return accessList[_user] || !checkEnabled || _user == tx.origin;
1878   }
1879 
1880   /**
1881    * @notice Adds an address to the access list
1882    * @param _user The address to add
1883    */
1884   function addAccess(address _user)
1885     external
1886     onlyOwner()
1887   {
1888     accessList[_user] = true;
1889     emit AddedAccess(_user);
1890   }
1891 
1892   /**
1893    * @notice Removes an address from the access list
1894    * @param _user The address to remove
1895    */
1896   function removeAccess(address _user)
1897     external
1898     onlyOwner()
1899   {
1900     delete accessList[_user];
1901     emit RemovedAccess(_user);
1902   }
1903 
1904   /**
1905    * @notice makes the access check enforced
1906    */
1907   function enableAccessCheck()
1908     external
1909     onlyOwner()
1910   {
1911     checkEnabled = true;
1912 
1913     emit CheckAccessEnabled();
1914   }
1915 
1916   /**
1917    * @notice makes the access check unenforced
1918    */
1919   function disableAccessCheck()
1920     external
1921     onlyOwner()
1922   {
1923     checkEnabled = false;
1924 
1925     emit CheckAccessDisabled();
1926   }
1927 
1928   /**
1929    * @dev reverts if the caller does not have access
1930    * @dev WARNING: This modifier should only be used on view methods
1931    */
1932   modifier checkAccess() {
1933     require(hasAccess(msg.sender, msg.data), "No access");
1934     _;
1935   }
1936 }
1937 
1938 
1939 /**
1940  * @title AccessControlled FluxAggregator contract
1941  * @notice This contract requires addresses to be added to a controller
1942  * in order to read the answers stored in the FluxAggregator contract
1943  */
1944 contract AccessControlledAggregator is FluxAggregator, SimpleAccessControl {
1945 
1946   constructor(
1947     address _link,
1948     uint128 _paymentAmount,
1949     uint32 _timeout,
1950     int256 _minSubmissionValue,
1951     int256 _maxSubmissionValue,
1952     uint8 _decimals,
1953     string memory _description
1954   ) public FluxAggregator(
1955     _link,
1956     _paymentAmount,
1957     _timeout,
1958     _minSubmissionValue,
1959     _maxSubmissionValue,
1960     _decimals,
1961     _description
1962   ){}
1963 
1964   /**
1965    * @notice get the most recently reported answer
1966    * @dev overridden funcion to add the checkAccess() modifier
1967    * @dev deprecated. Use latestRoundData instead.
1968    */
1969   function latestAnswer()
1970     public
1971     view
1972     override
1973     checkAccess()
1974     returns (int256)
1975   {
1976     return super.latestAnswer();
1977   }
1978 
1979   /**
1980    * @notice get the most recent updated at timestamp
1981    * @dev overridden funcion to add the checkAccess() modifier
1982    * @dev deprecated. Use latestRoundData instead.
1983    */
1984   function latestTimestamp()
1985     public
1986     view
1987     override
1988     checkAccess()
1989     returns (uint256)
1990   {
1991     return super.latestTimestamp();
1992   }
1993 
1994   /**
1995    * @notice get past rounds answers
1996    * @dev overridden funcion to add the checkAccess() modifier
1997    * @param _roundId the round number to retrieve the answer for
1998    * @dev deprecated. Use getRoundData instead.
1999    */
2000   function getAnswer(uint256 _roundId)
2001     public
2002     view
2003     override
2004     checkAccess()
2005     returns (int256)
2006   {
2007     return super.getAnswer(_roundId);
2008   }
2009 
2010   /**
2011    * @notice get timestamp when an answer was last updated
2012    * @dev overridden funcion to add the checkAccess() modifier
2013    * @param _roundId the round number to retrieve the updated timestamp for
2014    * @dev deprecated. Use getRoundData instead.
2015    */
2016   function getTimestamp(uint256 _roundId)
2017     public
2018     view
2019     override
2020     checkAccess()
2021     returns (uint256)
2022   {
2023     return super.getTimestamp(_roundId);
2024   }
2025 
2026   /**
2027    * @notice get data about a round. Consumers are encouraged to check
2028    * that they're receiving fresh data by inspecting the updatedAt and
2029    * answeredInRound return values.
2030    * @param _roundId the round ID to retrieve the round data for
2031    * @return roundId is the round ID for which data was retrieved
2032    * @return answer is the answer for the given round
2033    * @return startedAt is the timestamp when the round was started. This is 0
2034    * if the round hasn't been started yet.
2035    * @return updatedAt is the timestamp when the round last was updated (i.e.
2036    * answer was last computed)
2037    * @return answeredInRound is the round ID of the round in which the answer
2038    * was computed. answeredInRound may be smaller than roundId when the round
2039    * timed out. answerInRound is equal to roundId when the round didn't time out
2040    * and was completed regularly.
2041    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet received
2042    * maxSubmissions) answer and updatedAt may change between queries.
2043    */
2044   function getRoundData(uint256 _roundId)
2045     public
2046     view
2047     override
2048     checkAccess()
2049     returns (
2050       uint256 roundId,
2051       int256 answer,
2052       uint256 startedAt,
2053       uint256 updatedAt,
2054       uint256 answeredInRound
2055     )
2056   {
2057     return super.getRoundData(_roundId);
2058   }
2059 
2060   /**
2061    * @notice get data about the latest round. Consumers are encouraged to check
2062    * that they're receiving fresh data by inspecting the updatedAt and
2063    * answeredInRound return values. Consumers are encouraged to
2064    * use this more fully featured method over the "legacy" getAnswer/
2065    * latestAnswer/getTimestamp/latestTimestamp functions. Consumers are
2066    * encouraged to check that they're receiving fresh data by inspecting the
2067    * updatedAt and answeredInRound return values.
2068    * @return roundId is the round ID for which data was retrieved
2069    * @return answer is the answer for the given round
2070    * @return startedAt is the timestamp when the round was started. This is 0
2071    * if the round hasn't been started yet.
2072    * @return updatedAt is the timestamp when the round last was updated (i.e.
2073    * answer was last computed)
2074    * @return answeredInRound is the round ID of the round in which the answer
2075    * was computed. answeredInRound may be smaller than roundId when the round
2076    * timed out. answerInRound is equal to roundId when the round didn't time out
2077    * and was completed regularly.
2078    * @dev Note that for in-progress rounds (i.e. rounds that haven't yet received
2079    * maxSubmissions) answer and updatedAt may change between queries.
2080    */
2081   function latestRoundData()
2082     public
2083     view
2084     override
2085     checkAccess()
2086     returns (
2087       uint256 roundId,
2088       int256 answer,
2089       uint256 startedAt,
2090       uint256 updatedAt,
2091       uint256 answeredInRound
2092     )
2093   {
2094     return super.latestRoundData();
2095   }
2096 }