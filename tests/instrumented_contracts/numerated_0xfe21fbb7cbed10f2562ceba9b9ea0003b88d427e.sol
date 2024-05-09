1 /**
2  *
3  * 
4  *  O~~~ O~~~~~~         O~~                                O~~     O~~                         
5  *      O~~              O~~                                O~~     O~~                  O~~     
6  *      O~~       O~~    O~~  O~~   O~~    O~~ O~~          O~~     O~~   O~~     O~~~~  O~~     
7  *      O~~     O~~  O~~ O~~ O~~  O~   O~~  O~~  O~~        O~~~~~~ O~~ O~~  O~~ O~~     O~ O~   
8  *      O~~    O~~    O~~O~O~~   O~~~~~ O~~ O~~  O~~        O~~     O~~O~~   O~~   O~~~  O~~  O~~
9  *      O~~     O~~  O~~ O~~ O~~ O~         O~~  O~~        O~~     O~~O~~   O~~     O~~ O~   O~~
10  *      O~~       O~~    O~~  O~~  O~~~~    O~~~  O~~       O~~     O~~  O~~ O~~~ O~~O~~ O~~  O~~
11  *                                                                                         
12  * 
13  * 
14  *  Generative on-chain NFT series
15  *  Jonathan Chomko, 2021
16 */
17 
18 
19 // File: @openzeppelin/contracts/math/SafeMath.sol
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity >=0.6.0 <0.8.0;
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations with added overflow
26  * checks.
27  *
28  * Arithmetic operations in Solidity wrap on overflow. This can easily result
29  * in bugs, because programmers usually assume that an overflow raises an
30  * error, which is the standard behavior in high level programming languages.
31  * `SafeMath` restores this intuition by reverting the transaction when an
32  * operation overflows.
33  *
34  * Using this library instead of the unchecked operations eliminates an entire
35  * class of bugs, so it's recommended to use it always.
36  */
37 library SafeMath {
38     /**
39      * @dev Returns the addition of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         uint256 c = a + b;
45         if (c < a) return (false, 0);
46         return (true, c);
47     }
48 
49     /**
50      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         if (b > a) return (false, 0);
56         return (true, a - b);
57     }
58 
59     /**
60      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) return (true, 0);
69         uint256 c = a * b;
70         if (c / a != b) return (false, 0);
71         return (true, c);
72     }
73 
74     /**
75      * @dev Returns the division of two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         if (b == 0) return (false, 0);
81         return (true, a / b);
82     }
83 
84     /**
85      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
86      *
87      * _Available since v3.4._
88      */
89     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
90         if (b == 0) return (false, 0);
91         return (true, a % b);
92     }
93 
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b <= a, "SafeMath: subtraction overflow");
122         return a - b;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         if (a == 0) return 0;
137         uint256 c = a * b;
138         require(c / a == b, "SafeMath: multiplication overflow");
139         return c;
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers, reverting on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: division by zero");
156         return a / b;
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
161      * reverting when dividing by zero.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
172         require(b > 0, "SafeMath: modulo by zero");
173         return a % b;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
178      * overflow (when the result is negative).
179      *
180      * CAUTION: This function is deprecated because it requires allocating memory for the error
181      * message unnecessarily. For custom revert reasons use {trySub}.
182      *
183      * Counterpart to Solidity's `-` operator.
184      *
185      * Requirements:
186      *
187      * - Subtraction cannot overflow.
188      */
189     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b <= a, errorMessage);
191         return a - b;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * CAUTION: This function is deprecated because it requires allocating memory for the error
199      * message unnecessarily. For custom revert reasons use {tryDiv}.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         return a / b;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * reverting with custom message when dividing by zero.
217      *
218      * CAUTION: This function is deprecated because it requires allocating memory for the error
219      * message unnecessarily. For custom revert reasons use {tryMod}.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
236 
237 
238 
239 pragma solidity >=0.6.0 <0.8.0;
240 
241 /**
242  * @dev Library for managing
243  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
244  * types.
245  *
246  * Sets have the following properties:
247  *
248  * - Elements are added, removed, and checked for existence in constant time
249  * (O(1)).
250  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
251  *
252  * ```
253  * contract Example {
254  *     // Add the library methods
255  *     using EnumerableSet for EnumerableSet.AddressSet;
256  *
257  *     // Declare a set state variable
258  *     EnumerableSet.AddressSet private mySet;
259  * }
260  * ```
261  *
262  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
263  * and `uint256` (`UintSet`) are supported.
264  */
265 library EnumerableSet {
266     // To implement this library for multiple types with as little code
267     // repetition as possible, we write it in terms of a generic Set type with
268     // bytes32 values.
269     // The Set implementation uses private functions, and user-facing
270     // implementations (such as AddressSet) are just wrappers around the
271     // underlying Set.
272     // This means that we can only create new EnumerableSets for types that fit
273     // in bytes32.
274 
275     struct Set {
276         // Storage of set values
277         bytes32[] _values;
278 
279         // Position of the value in the `values` array, plus 1 because index 0
280         // means a value is not in the set.
281         mapping (bytes32 => uint256) _indexes;
282     }
283 
284     /**
285      * @dev Add a value to a set. O(1).
286      *
287      * Returns true if the value was added to the set, that is if it was not
288      * already present.
289      */
290     function _add(Set storage set, bytes32 value) private returns (bool) {
291         if (!_contains(set, value)) {
292             set._values.push(value);
293             // The value is stored at length-1, but we add 1 to all indexes
294             // and use 0 as a sentinel value
295             set._indexes[value] = set._values.length;
296             return true;
297         } else {
298             return false;
299         }
300     }
301 
302     /**
303      * @dev Removes a value from a set. O(1).
304      *
305      * Returns true if the value was removed from the set, that is if it was
306      * present.
307      */
308     function _remove(Set storage set, bytes32 value) private returns (bool) {
309         // We read and store the value's index to prevent multiple reads from the same storage slot
310         uint256 valueIndex = set._indexes[value];
311 
312         if (valueIndex != 0) { // Equivalent to contains(set, value)
313             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
314             // the array, and then remove the last element (sometimes called as 'swap and pop').
315             // This modifies the order of the array, as noted in {at}.
316 
317             uint256 toDeleteIndex = valueIndex - 1;
318             uint256 lastIndex = set._values.length - 1;
319 
320             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
321             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
322 
323             bytes32 lastvalue = set._values[lastIndex];
324 
325             // Move the last value to the index where the value to delete is
326             set._values[toDeleteIndex] = lastvalue;
327             // Update the index for the moved value
328             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
329 
330             // Delete the slot where the moved value was stored
331             set._values.pop();
332 
333             // Delete the index for the deleted slot
334             delete set._indexes[value];
335 
336             return true;
337         } else {
338             return false;
339         }
340     }
341 
342     /**
343      * @dev Returns true if the value is in the set. O(1).
344      */
345     function _contains(Set storage set, bytes32 value) private view returns (bool) {
346         return set._indexes[value] != 0;
347     }
348 
349     /**
350      * @dev Returns the number of values on the set. O(1).
351      */
352     function _length(Set storage set) private view returns (uint256) {
353         return set._values.length;
354     }
355 
356   /**
357     * @dev Returns the value stored at position `index` in the set. O(1).
358     *
359     * Note that there are no guarantees on the ordering of values inside the
360     * array, and it may change when more values are added or removed.
361     *
362     * Requirements:
363     *
364     * - `index` must be strictly less than {length}.
365     */
366     function _at(Set storage set, uint256 index) private view returns (bytes32) {
367         require(set._values.length > index, "EnumerableSet: index out of bounds");
368         return set._values[index];
369     }
370 
371     // Bytes32Set
372 
373     struct Bytes32Set {
374         Set _inner;
375     }
376 
377     /**
378      * @dev Add a value to a set. O(1).
379      *
380      * Returns true if the value was added to the set, that is if it was not
381      * already present.
382      */
383     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
384         return _add(set._inner, value);
385     }
386 
387     /**
388      * @dev Removes a value from a set. O(1).
389      *
390      * Returns true if the value was removed from the set, that is if it was
391      * present.
392      */
393     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
394         return _remove(set._inner, value);
395     }
396 
397     /**
398      * @dev Returns true if the value is in the set. O(1).
399      */
400     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
401         return _contains(set._inner, value);
402     }
403 
404     /**
405      * @dev Returns the number of values in the set. O(1).
406      */
407     function length(Bytes32Set storage set) internal view returns (uint256) {
408         return _length(set._inner);
409     }
410 
411   /**
412     * @dev Returns the value stored at position `index` in the set. O(1).
413     *
414     * Note that there are no guarantees on the ordering of values inside the
415     * array, and it may change when more values are added or removed.
416     *
417     * Requirements:
418     *
419     * - `index` must be strictly less than {length}.
420     */
421     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
422         return _at(set._inner, index);
423     }
424 
425     // AddressSet
426 
427     struct AddressSet {
428         Set _inner;
429     }
430 
431     /**
432      * @dev Add a value to a set. O(1).
433      *
434      * Returns true if the value was added to the set, that is if it was not
435      * already present.
436      */
437     function add(AddressSet storage set, address value) internal returns (bool) {
438         return _add(set._inner, bytes32(uint256(uint160(value))));
439     }
440 
441     /**
442      * @dev Removes a value from a set. O(1).
443      *
444      * Returns true if the value was removed from the set, that is if it was
445      * present.
446      */
447     function remove(AddressSet storage set, address value) internal returns (bool) {
448         return _remove(set._inner, bytes32(uint256(uint160(value))));
449     }
450 
451     /**
452      * @dev Returns true if the value is in the set. O(1).
453      */
454     function contains(AddressSet storage set, address value) internal view returns (bool) {
455         return _contains(set._inner, bytes32(uint256(uint160(value))));
456     }
457 
458     /**
459      * @dev Returns the number of values in the set. O(1).
460      */
461     function length(AddressSet storage set) internal view returns (uint256) {
462         return _length(set._inner);
463     }
464 
465   /**
466     * @dev Returns the value stored at position `index` in the set. O(1).
467     *
468     * Note that there are no guarantees on the ordering of values inside the
469     * array, and it may change when more values are added or removed.
470     *
471     * Requirements:
472     *
473     * - `index` must be strictly less than {length}.
474     */
475     function at(AddressSet storage set, uint256 index) internal view returns (address) {
476         return address(uint160(uint256(_at(set._inner, index))));
477     }
478 
479 
480     // UintSet
481 
482     struct UintSet {
483         Set _inner;
484     }
485 
486     /**
487      * @dev Add a value to a set. O(1).
488      *
489      * Returns true if the value was added to the set, that is if it was not
490      * already present.
491      */
492     function add(UintSet storage set, uint256 value) internal returns (bool) {
493         return _add(set._inner, bytes32(value));
494     }
495 
496     /**
497      * @dev Removes a value from a set. O(1).
498      *
499      * Returns true if the value was removed from the set, that is if it was
500      * present.
501      */
502     function remove(UintSet storage set, uint256 value) internal returns (bool) {
503         return _remove(set._inner, bytes32(value));
504     }
505 
506     /**
507      * @dev Returns true if the value is in the set. O(1).
508      */
509     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
510         return _contains(set._inner, bytes32(value));
511     }
512 
513     /**
514      * @dev Returns the number of values on the set. O(1).
515      */
516     function length(UintSet storage set) internal view returns (uint256) {
517         return _length(set._inner);
518     }
519 
520   /**
521     * @dev Returns the value stored at position `index` in the set. O(1).
522     *
523     * Note that there are no guarantees on the ordering of values inside the
524     * array, and it may change when more values are added or removed.
525     *
526     * Requirements:
527     *
528     * - `index` must be strictly less than {length}.
529     */
530     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
531         return uint256(_at(set._inner, index));
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Address.sol
536 
537 
538 
539 pragma solidity >=0.6.2 <0.8.0;
540 
541 /**
542  * @dev Collection of functions related to the address type
543  */
544 library Address {
545     /**
546      * @dev Returns true if `account` is a contract.
547      *
548      * [IMPORTANT]
549      * ====
550      * It is unsafe to assume that an address for which this function returns
551      * false is an externally-owned account (EOA) and not a contract.
552      *
553      * Among others, `isContract` will return false for the following
554      * types of addresses:
555      *
556      *  - an externally-owned account
557      *  - a contract in construction
558      *  - an address where a contract will be created
559      *  - an address where a contract lived, but was destroyed
560      * ====
561      */
562     function isContract(address account) internal view returns (bool) {
563         // This method relies on extcodesize, which returns 0 for contracts in
564         // construction, since the code is only stored at the end of the
565         // constructor execution.
566 
567         uint256 size;
568         // solhint-disable-next-line no-inline-assembly
569         assembly { size := extcodesize(account) }
570         return size > 0;
571     }
572 
573     /**
574      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
575      * `recipient`, forwarding all available gas and reverting on errors.
576      *
577      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
578      * of certain opcodes, possibly making contracts go over the 2300 gas limit
579      * imposed by `transfer`, making them unable to receive funds via
580      * `transfer`. {sendValue} removes this limitation.
581      *
582      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
583      *
584      * IMPORTANT: because control is transferred to `recipient`, care must be
585      * taken to not create reentrancy vulnerabilities. Consider using
586      * {ReentrancyGuard} or the
587      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
588      */
589     function sendValue(address payable recipient, uint256 amount) internal {
590         require(address(this).balance >= amount, "Address: insufficient balance");
591 
592         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
593         (bool success, ) = recipient.call{ value: amount }("");
594         require(success, "Address: unable to send value, recipient may have reverted");
595     }
596 
597     /**
598      * @dev Performs a Solidity function call using a low level `call`. A
599      * plain`call` is an unsafe replacement for a function call: use this
600      * function instead.
601      *
602      * If `target` reverts with a revert reason, it is bubbled up by this
603      * function (like regular Solidity function calls).
604      *
605      * Returns the raw returned data. To convert to the expected return value,
606      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
607      *
608      * Requirements:
609      *
610      * - `target` must be a contract.
611      * - calling `target` with `data` must not revert.
612      *
613      * _Available since v3.1._
614      */
615     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
616       return functionCall(target, data, "Address: low-level call failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
621      * `errorMessage` as a fallback revert reason when `target` reverts.
622      *
623      * _Available since v3.1._
624      */
625     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
626         return functionCallWithValue(target, data, 0, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but also transferring `value` wei to `target`.
632      *
633      * Requirements:
634      *
635      * - the calling contract must have an ETH balance of at least `value`.
636      * - the called Solidity function must be `payable`.
637      *
638      * _Available since v3.1._
639      */
640     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
641         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
646      * with `errorMessage` as a fallback revert reason when `target` reverts.
647      *
648      * _Available since v3.1._
649      */
650     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
651         require(address(this).balance >= value, "Address: insufficient balance for call");
652         require(isContract(target), "Address: call to non-contract");
653 
654         // solhint-disable-next-line avoid-low-level-calls
655         (bool success, bytes memory returndata) = target.call{ value: value }(data);
656         return _verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
661      * but performing a static call.
662      *
663      * _Available since v3.3._
664      */
665     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
666         return functionStaticCall(target, data, "Address: low-level static call failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
671      * but performing a static call.
672      *
673      * _Available since v3.3._
674      */
675     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
676         require(isContract(target), "Address: static call to non-contract");
677 
678         // solhint-disable-next-line avoid-low-level-calls
679         (bool success, bytes memory returndata) = target.staticcall(data);
680         return _verifyCallResult(success, returndata, errorMessage);
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
690         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
695      * but performing a delegate call.
696      *
697      * _Available since v3.4._
698      */
699     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
700         require(isContract(target), "Address: delegate call to non-contract");
701 
702         // solhint-disable-next-line avoid-low-level-calls
703         (bool success, bytes memory returndata) = target.delegatecall(data);
704         return _verifyCallResult(success, returndata, errorMessage);
705     }
706 
707     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
708         if (success) {
709             return returndata;
710         } else {
711             // Look for revert reason and bubble it up if present
712             if (returndata.length > 0) {
713                 // The easiest way to bubble the revert reason is using memory via assembly
714 
715                 // solhint-disable-next-line no-inline-assembly
716                 assembly {
717                     let returndata_size := mload(returndata)
718                     revert(add(32, returndata), returndata_size)
719                 }
720             } else {
721                 revert(errorMessage);
722             }
723         }
724     }
725 }
726 
727 // File: @openzeppelin/contracts/utils/Context.sol
728 
729 
730 
731 pragma solidity >=0.6.0 <0.8.0;
732 
733 /*
734  * @dev Provides information about the current execution context, including the
735  * sender of the transaction and its data. While these are generally available
736  * via msg.sender and msg.data, they should not be accessed in such a direct
737  * manner, since when dealing with GSN meta-transactions the account sending and
738  * paying for execution may not be the actual sender (as far as an application
739  * is concerned).
740  *
741  * This contract is only required for intermediate, library-like contracts.
742  */
743 abstract contract Context {
744     function _msgSender() internal view virtual returns (address payable) {
745         return msg.sender;
746     }
747 
748     function _msgData() internal view virtual returns (bytes memory) {
749         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
750         return msg.data;
751     }
752 }
753 
754 // File: @openzeppelin/contracts/access/AccessControl.sol
755 
756 
757 
758 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
759 pragma solidity >=0.6.0 <0.8.0;
760 
761 /**
762  * @dev Contract module which provides a basic access control mechanism, where
763  * there is an account (an owner) that can be granted exclusive access to
764  * specific functions.
765  *
766  * By default, the owner account will be the one that deploys the contract. This
767  * can later be changed with {transferOwnership}.
768  *
769  * This module is used through inheritance. It will make available the modifier
770  * `onlyOwner`, which can be applied to your functions to restrict their use to
771  * the owner.
772  */
773 
774 abstract contract Ownable is Context {
775     address private _owner;
776 
777     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
778 
779     /**
780      * @dev Initializes the contract setting the deployer as the initial owner.
781      */
782     constructor() {
783         address msgSender = _msgSender();
784         _owner = msgSender;
785         emit OwnershipTransferred(address(0), msgSender);
786     }
787 
788     /**
789      * @dev Returns the address of the current owner.
790      */
791     function owner() public view virtual returns (address) {
792         return _owner;
793     }
794 
795     /**
796      * @dev Throws if called by any account other than the owner.
797      */
798     modifier onlyOwner() {
799         require(owner() == _msgSender(), "Ownable: caller is not the owner");
800         _;
801     }
802 
803     /**
804      * @dev Leaves the contract without owner. It will not be possible to call
805      * `onlyOwner` functions anymore. Can only be called by the current owner.
806      *
807      * NOTE: Renouncing ownership will leave the contract without an owner,
808      * thereby removing any functionality that is only available to the owner.
809      */
810     function renounceOwnership() public virtual onlyOwner {
811         emit OwnershipTransferred(_owner, address(0));
812         _owner = address(0);
813     }
814 
815     /**
816      * @dev Transfers ownership of the contract to a new account (`newOwner`).
817      * Can only be called by the current owner.
818      */
819     function transferOwnership(address newOwner) public virtual onlyOwner {
820         require(newOwner != address(0), "Ownable: new owner is the zero address");
821         emit OwnershipTransferred(_owner, newOwner);
822         _owner = newOwner;
823     }
824 }
825 
826 
827 // File: @openzeppelin/contracts/utils/Counters.sol
828 
829 
830 pragma solidity >=0.6.0 <0.8.0;
831 
832 
833 /**
834  * @title Counters
835  * @author Matt Condon (@shrugs)
836  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
837  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
838  *
839  * Include with `using Counters for Counters.Counter;`
840  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
841  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
842  * directly accessed.
843  */
844 library Counters {
845     using SafeMath for uint256;
846 
847     struct Counter {
848         // This variable should never be directly accessed by users of the library: interactions must be restricted to
849         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
850         // this feature: see https://github.com/ethereum/solidity/issues/4637
851         uint256 _value; // default: 0
852     }
853 
854     function current(Counter storage counter) internal view returns (uint256) {
855         return counter._value;
856     }
857 
858     function increment(Counter storage counter) internal {
859         // The {SafeMath} overflow check can be skipped here, see the comment at the top
860         counter._value += 1;
861     }
862 
863     function decrement(Counter storage counter) internal {
864         counter._value = counter._value.sub(1);
865     }
866 }
867 
868 // File: @openzeppelin/contracts/introspection/IERC165.sol
869 
870 
871 
872 pragma solidity >=0.6.0 <0.8.0;
873 
874 /**
875  * @dev Interface of the ERC165 standard, as defined in the
876  * https://eips.ethereum.org/EIPS/eip-165[EIP].
877  *
878  * Implementers can declare support of contract interfaces, which can then be
879  * queried by others ({ERC165Checker}).
880  *
881  * For an implementation, see {ERC165}.
882  */
883 interface IERC165 {
884     /**
885      * @dev Returns true if this contract implements the interface defined by
886      * `interfaceId`. See the corresponding
887      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
888      * to learn more about how these ids are created.
889      *
890      * This function call must use less than 30 000 gas.
891      */
892     function supportsInterface(bytes4 interfaceId) external view returns (bool);
893 }
894 
895 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
896 
897 
898 
899 pragma solidity >=0.6.2 <0.8.0;
900 
901 
902 /**
903  * @dev Required interface of an ERC721 compliant contract.
904  */
905 interface IERC721 is IERC165 {
906     /**
907      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
908      */
909     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
910 
911     /**
912      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
913      */
914     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
915 
916     /**
917      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
918      */
919     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
920 
921     /**
922      * @dev Returns the number of tokens in ``owner``'s account.
923      */
924     function balanceOf(address owner) external view returns (uint256 balance);
925 
926     /**
927      * @dev Returns the owner of the `tokenId` token.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      */
933     function ownerOf(uint256 tokenId) external view returns (address owner);
934 
935     /**
936      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
937      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must exist and be owned by `from`.
944      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function safeTransferFrom(address from, address to, uint256 tokenId) external;
950 
951     /**
952      * @dev Transfers `tokenId` token from `from` to `to`.
953      *
954      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
955      *
956      * Requirements:
957      *
958      * - `from` cannot be the zero address.
959      * - `to` cannot be the zero address.
960      * - `tokenId` token must be owned by `from`.
961      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
962      *
963      * Emits a {Transfer} event.
964      */
965     function transferFrom(address from, address to, uint256 tokenId) external;
966 
967     /**
968      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
969      * The approval is cleared when the token is transferred.
970      *
971      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
972      *
973      * Requirements:
974      *
975      * - The caller must own the token or be an approved operator.
976      * - `tokenId` must exist.
977      *
978      * Emits an {Approval} event.
979      */
980     function approve(address to, uint256 tokenId) external;
981 
982     /**
983      * @dev Returns the account approved for `tokenId` token.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function getApproved(uint256 tokenId) external view returns (address operator);
990 
991     /**
992      * @dev Approve or remove `operator` as an operator for the caller.
993      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
994      *
995      * Requirements:
996      *
997      * - The `operator` cannot be the caller.
998      *
999      * Emits an {ApprovalForAll} event.
1000      */
1001     function setApprovalForAll(address operator, bool _approved) external;
1002 
1003     /**
1004      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1005      *
1006      * See {setApprovalForAll}
1007      */
1008     function isApprovedForAll(address owner, address operator) external view returns (bool);
1009 
1010     /**
1011       * @dev Safely transfers `tokenId` token from `from` to `to`.
1012       *
1013       * Requirements:
1014       *
1015       * - `from` cannot be the zero address.
1016       * - `to` cannot be the zero address.
1017       * - `tokenId` token must exist and be owned by `from`.
1018       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1019       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1020       *
1021       * Emits a {Transfer} event.
1022       */
1023     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1024 }
1025 
1026 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1027 
1028 
1029 
1030 pragma solidity >=0.6.2 <0.8.0;
1031 
1032 
1033 /**
1034  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1035  * @dev See https://eips.ethereum.org/EIPS/eip-721
1036  */
1037 interface IERC721Metadata is IERC721 {
1038 
1039     /**
1040      * @dev Returns the token collection name.
1041      */
1042     function name() external view returns (string memory);
1043 
1044     /**
1045      * @dev Returns the token collection symbol.
1046      */
1047     function symbol() external view returns (string memory);
1048 
1049     /**
1050      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1051      */
1052     function tokenURI(uint256 tokenId) external view returns (string memory);
1053 }
1054 
1055 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
1056 
1057 
1058 pragma solidity >=0.6.2 <0.8.0;
1059 // /**
1060 //  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1061 //  * @dev See https://eips.ethereum.org/EIPS/eip-721
1062 //  */
1063 interface IERC721Enumerable is IERC721 {
1064 
1065     /**
1066      * @dev Returns the total amount of tokens stored by the contract.
1067      */
1068     function totalSupply() external view returns (uint256);
1069 
1070     /**
1071      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1072      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1073      */
1074     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1075 
1076     /**
1077      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1078      * Use along with {totalSupply} to enumerate all tokens.
1079      */
1080     function tokenByIndex(uint256 index) external view returns (uint256);
1081 }
1082 
1083 
1084 
1085 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1086 
1087 
1088 
1089 pragma solidity >=0.6.0 <0.8.0;
1090 
1091 /**
1092  * @title ERC721 token receiver interface
1093  * @dev Interface for any contract that wants to support safeTransfers
1094  * from ERC721 asset contracts.
1095  */
1096 interface IERC721Receiver {
1097     /**
1098      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1099      * by `operator` from `from`, this function is called.
1100      *
1101      * It must return its Solidity selector to confirm the token transfer.
1102      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1103      *
1104      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1105      */
1106     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1107 }
1108 
1109 // File: @openzeppelin/contracts/introspection/ERC165.sol
1110 
1111 
1112 
1113 pragma solidity >=0.6.0 <0.8.0;
1114 
1115 
1116 /**
1117  * @dev Implementation of the {IERC165} interface.
1118  *
1119  * Contracts may inherit from this and call {_registerInterface} to declare
1120  * their support of an interface.
1121  */
1122 abstract contract ERC165 is IERC165 {
1123     /*
1124      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1125      */
1126     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1127 
1128     /**
1129      * @dev Mapping of interface ids to whether or not it's supported.
1130      */
1131     mapping(bytes4 => bool) private _supportedInterfaces;
1132 
1133     constructor () {
1134         // Derived contracts need only register support for their own interfaces,
1135         // we register support for ERC165 itself here
1136         _registerInterface(_INTERFACE_ID_ERC165);
1137     }
1138 
1139     /**
1140      * @dev See {IERC165-supportsInterface}.
1141      *
1142      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1143      */
1144     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1145         return _supportedInterfaces[interfaceId];
1146     }
1147 
1148     /**
1149      * @dev Registers the contract as an implementer of the interface defined by
1150      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1151      * registering its interface id is not required.
1152      *
1153      * See {IERC165-supportsInterface}.
1154      *
1155      * Requirements:
1156      *
1157      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1158      */
1159     function _registerInterface(bytes4 interfaceId) internal virtual {
1160         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1161         _supportedInterfaces[interfaceId] = true;
1162     }
1163 }
1164 
1165 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1166 
1167 
1168 
1169 pragma solidity >=0.6.0 <0.8.0;
1170 
1171 /**
1172  * @dev Library for managing an enumerable variant of Solidity's
1173  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1174  * type.
1175  *
1176  * Maps have the following properties:
1177  *
1178  * - Entries are added, removed, and checked for existence in constant time
1179  * (O(1)).
1180  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1181  *
1182  * ```
1183  * contract Example {
1184  *     // Add the library methods
1185  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1186  *
1187  *     // Declare a set state variable
1188  *     EnumerableMap.UintToAddressMap private myMap;
1189  * }
1190  * ```
1191  *
1192  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1193  * supported.
1194  */
1195 library EnumerableMap {
1196     // To implement this library for multiple types with as little code
1197     // repetition as possible, we write it in terms of a generic Map type with
1198     // bytes32 keys and values.
1199     // The Map implementation uses private functions, and user-facing
1200     // implementations (such as Uint256ToAddressMap) are just wrappers around
1201     // the underlying Map.
1202     // This means that we can only create new EnumerableMaps for types that fit
1203     // in bytes32.
1204 
1205     struct MapEntry {
1206         bytes32 _key;
1207         bytes32 _value;
1208     }
1209 
1210     struct Map {
1211         // Storage of map keys and values
1212         MapEntry[] _entries;
1213 
1214         // Position of the entry defined by a key in the `entries` array, plus 1
1215         // because index 0 means a key is not in the map.
1216         mapping (bytes32 => uint256) _indexes;
1217     }
1218 
1219     /**
1220      * @dev Adds a key-value pair to a map, or updates the value for an existing
1221      * key. O(1).
1222      *
1223      * Returns true if the key was added to the map, that is if it was not
1224      * already present.
1225      */
1226     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1227         // We read and store the key's index to prevent multiple reads from the same storage slot
1228         uint256 keyIndex = map._indexes[key];
1229 
1230         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1231             map._entries.push(MapEntry({ _key: key, _value: value }));
1232             // The entry is stored at length-1, but we add 1 to all indexes
1233             // and use 0 as a sentinel value
1234             map._indexes[key] = map._entries.length;
1235             return true;
1236         } else {
1237             map._entries[keyIndex - 1]._value = value;
1238             return false;
1239         }
1240     }
1241 
1242     /**
1243      * @dev Removes a key-value pair from a map. O(1).
1244      *
1245      * Returns true if the key was removed from the map, that is if it was present.
1246      */
1247     function _remove(Map storage map, bytes32 key) private returns (bool) {
1248         // We read and store the key's index to prevent multiple reads from the same storage slot
1249         uint256 keyIndex = map._indexes[key];
1250 
1251         if (keyIndex != 0) { // Equivalent to contains(map, key)
1252             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1253             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1254             // This modifies the order of the array, as noted in {at}.
1255 
1256             uint256 toDeleteIndex = keyIndex - 1;
1257             uint256 lastIndex = map._entries.length - 1;
1258 
1259             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1260             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1261 
1262             MapEntry storage lastEntry = map._entries[lastIndex];
1263 
1264             // Move the last entry to the index where the entry to delete is
1265             map._entries[toDeleteIndex] = lastEntry;
1266             // Update the index for the moved entry
1267             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1268 
1269             // Delete the slot where the moved entry was stored
1270             map._entries.pop();
1271 
1272             // Delete the index for the deleted slot
1273             delete map._indexes[key];
1274 
1275             return true;
1276         } else {
1277             return false;
1278         }
1279     }
1280 
1281     /**
1282      * @dev Returns true if the key is in the map. O(1).
1283      */
1284     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1285         return map._indexes[key] != 0;
1286     }
1287 
1288     /**
1289      * @dev Returns the number of key-value pairs in the map. O(1).
1290      */
1291     function _length(Map storage map) private view returns (uint256) {
1292         return map._entries.length;
1293     }
1294 
1295    /**
1296     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1297     *
1298     * Note that there are no guarantees on the ordering of entries inside the
1299     * array, and it may change when more entries are added or removed.
1300     *
1301     * Requirements:
1302     *
1303     * - `index` must be strictly less than {length}.
1304     */
1305     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1306         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1307 
1308         MapEntry storage entry = map._entries[index];
1309         return (entry._key, entry._value);
1310     }
1311 
1312     /**
1313      * @dev Tries to returns the value associated with `key`.  O(1).
1314      * Does not revert if `key` is not in the map.
1315      */
1316     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1317         uint256 keyIndex = map._indexes[key];
1318         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1319         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1320     }
1321 
1322     /**
1323      * @dev Returns the value associated with `key`.  O(1).
1324      *
1325      * Requirements:
1326      *
1327      * - `key` must be in the map.
1328      */
1329     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1330         uint256 keyIndex = map._indexes[key];
1331         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1332         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1333     }
1334 
1335     /**
1336      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1337      *
1338      * CAUTION: This function is deprecated because it requires allocating memory for the error
1339      * message unnecessarily. For custom revert reasons use {_tryGet}.
1340      */
1341     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1342         uint256 keyIndex = map._indexes[key];
1343         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1344         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1345     }
1346 
1347     // UintToAddressMap
1348 
1349     struct UintToAddressMap {
1350         Map _inner;
1351     }
1352 
1353     /**
1354      * @dev Adds a key-value pair to a map, or updates the value for an existing
1355      * key. O(1).
1356      *
1357      * Returns true if the key was added to the map, that is if it was not
1358      * already present.
1359      */
1360     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1361         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1362     }
1363 
1364     /**
1365      * @dev Removes a value from a set. O(1).
1366      *
1367      * Returns true if the key was removed from the map, that is if it was present.
1368      */
1369     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1370         return _remove(map._inner, bytes32(key));
1371     }
1372 
1373     /**
1374      * @dev Returns true if the key is in the map. O(1).
1375      */
1376     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1377         return _contains(map._inner, bytes32(key));
1378     }
1379 
1380     /**
1381      * @dev Returns the number of elements in the map. O(1).
1382      */
1383     function length(UintToAddressMap storage map) internal view returns (uint256) {
1384         return _length(map._inner);
1385     }
1386 
1387    /**
1388     * @dev Returns the element stored at position `index` in the set. O(1).
1389     * Note that there are no guarantees on the ordering of values inside the
1390     * array, and it may change when more values are added or removed.
1391     *
1392     * Requirements:
1393     *
1394     * - `index` must be strictly less than {length}.
1395     */
1396     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1397         (bytes32 key, bytes32 value) = _at(map._inner, index);
1398         return (uint256(key), address(uint160(uint256(value))));
1399     }
1400 
1401     /**
1402      * @dev Tries to returns the value associated with `key`.  O(1).
1403      * Does not revert if `key` is not in the map.
1404      *
1405      * _Available since v3.4._
1406      */
1407     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1408         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1409         return (success, address(uint160(uint256(value))));
1410     }
1411 
1412     /**
1413      * @dev Returns the value associated with `key`.  O(1).
1414      *
1415      * Requirements:
1416      *
1417      * - `key` must be in the map.
1418      */
1419     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1420         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1421     }
1422 
1423     /**
1424      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1425      *
1426      * CAUTION: This function is deprecated because it requires allocating memory for the error
1427      * message unnecessarily. For custom revert reasons use {tryGet}.
1428      */
1429     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1430         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1431     }
1432 }
1433 
1434 // File: @openzeppelin/contracts/utils/Strings.sol
1435 
1436 
1437 
1438 pragma solidity >=0.6.0 <0.8.0;
1439 
1440 /**
1441  * @dev String operations.
1442  */
1443 library Strings {
1444     /**
1445      * @dev Converts a `uint256` to its ASCII `string` representation.
1446      */
1447     function toString(uint256 value) internal pure returns (string memory) {
1448         // Inspired by OraclizeAPI's implementation - MIT licence
1449         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1450 
1451         if (value == 0) {
1452             return "0";
1453         }
1454         uint256 temp = value;
1455         uint256 digits;
1456         while (temp != 0) {
1457             digits++;
1458             temp /= 10;
1459         }
1460         bytes memory buffer = new bytes(digits);
1461         uint256 index = digits - 1;
1462         temp = value;
1463         while (temp != 0) {
1464             buffer[index--] = bytes1(uint8(48 + temp % 10));
1465             temp /= 10;
1466         }
1467         return string(buffer);
1468     }
1469 }
1470 
1471 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1472 pragma solidity >=0.6.0 <0.8.0;
1473 
1474 /**
1475  * @title ERC721 Non-Fungible Token Standard basic implementation
1476  * @dev see https://eips.ethereum.org/EIPS/eip-721
1477  */
1478 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1479     using SafeMath for uint256;
1480     using Address for address;
1481     using EnumerableSet for EnumerableSet.UintSet;
1482     using EnumerableMap for EnumerableMap.UintToAddressMap;
1483     using Strings for uint256;
1484 
1485     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1486     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1487     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1488     
1489     // Mapping from holder address to their (enumerable) set of owned tokens
1490     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1491 
1492     // Enumerable mapping from token ids to their owners
1493     EnumerableMap.UintToAddressMap private _tokenOwners;
1494 
1495     // Mapping from token ID to approved address
1496     mapping (uint256 => address) private _tokenApprovals;
1497 
1498     // Mapping from owner to operator approvals
1499     mapping (address => mapping (address => bool)) private _operatorApprovals;
1500 
1501     // Token name
1502     string private _name;
1503 
1504     // Token symbol
1505     string private _symbol;
1506     
1507     
1508     // Optional mapping for token URIs - not used with on-chain
1509     // mapping (uint256 => string) private _tokenURIs;
1510 
1511     // Base URI
1512     string private _baseURI;
1513 
1514     /*
1515      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1516      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1517      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1518      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1519      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1520      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1521      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1522      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1523      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1524      *
1525      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1526      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1527      */
1528     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1529 
1530     /*
1531      *     bytes4(keccak256('name()')) == 0x06fdde03
1532      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1533      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1534      *
1535      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1536      */
1537     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1538 
1539     /*
1540      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1541      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1542      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1543      *
1544      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1545      */
1546     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1547 
1548     /**
1549      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1550      */
1551     constructor (string memory name_, string memory symbol_) {
1552         _name = name_;
1553         _symbol = symbol_;
1554 
1555         // register the supported interfaces to conform to ERC721 via ERC165
1556         _registerInterface(_INTERFACE_ID_ERC721);
1557         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1558         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1559     }
1560     
1561     
1562 
1563     /**
1564      * @dev See {IERC721-balanceOf}.
1565      */
1566     function balanceOf(address owner) public view virtual override returns (uint256) {
1567         require(owner != address(0), "ERC721: balance query for the zero address");
1568         return _holderTokens[owner].length();
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-ownerOf}.
1573      */
1574     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1575         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1576     }
1577 
1578     /**
1579      * @dev See {IERC721Metadata-name}.
1580      */
1581     function name() public view virtual override returns (string memory) {
1582         return _name;
1583     }
1584 
1585     /**
1586      * @dev See {IERC721Metadata-symbol}.
1587      */
1588     function symbol() public view virtual override returns (string memory) {
1589         return _symbol;
1590     }
1591 
1592     /**
1593      * @dev See {IERC721Metadata-tokenURI}.
1594      */
1595     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1596         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1597         // return json from folder 
1598         return string(abi.encodePacked(baseURI(), tokenId.toString(), '.json'));
1599     }
1600     
1601     
1602     //Return contract metadata for opensea view
1603     function contractURI() public pure returns (string memory) {
1604         //put something here!
1605         string memory json = Base64.encode(bytes(string(abi.encodePacked('{ "name": "Token Hash","description": "Abstract on-chain generative NFT series.", "external_link": "https://tokenhash.jonathanchomko.com/","seller_fee_basis_points": 1000, "fee_recipient": "0x8490b3dFba40B784e3a16974377c70a139306CFA" } ' ))));
1606         string memory output = string(abi.encodePacked('data:application/json;base64,', json));
1607         // return string(abi.encodePacked(baseURI(), "contract_metadata", '.json'));
1608         return output;
1609     }
1610 
1611     /**
1612     * @dev Returns the base URI set via {_setBaseURI}. This will be
1613     * automatically added as a prefix in {tokenURI} to each token's URI, or
1614     * to the token ID if no specific URI is set for that token ID.
1615     */
1616     function baseURI() public view virtual returns (string memory) {
1617         return _baseURI;
1618     }
1619     
1620      /**
1621      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1622      */
1623     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1624         return _holderTokens[owner].at(index);
1625     }
1626 
1627     /**
1628      * @dev See {IERC721Enumerable-totalSupply}.
1629      */
1630     function totalSupply() public view virtual override returns (uint256) {
1631         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1632         return _tokenOwners.length();
1633     }
1634 
1635     /**
1636      * @dev See {IERC721Enumerable-tokenByIndex}.
1637      */
1638     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1639         (uint256 tokenId, ) = _tokenOwners.at(index);
1640         return tokenId;
1641     }
1642 
1643     /**
1644      * @dev See {IERC721-approve}.
1645      */
1646     function approve(address to, uint256 tokenId) public virtual override {
1647         address owner = ERC721.ownerOf(tokenId);
1648         require(to != owner, "ERC721: approval to current owner");
1649 
1650         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1651             "ERC721: approve caller is not owner nor approved for all"
1652         );
1653 
1654         _approve(to, tokenId);
1655     }
1656 
1657     /**
1658      * @dev See {IERC721-getApproved}.
1659      */
1660     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1661         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1662 
1663         return _tokenApprovals[tokenId];
1664     }
1665 
1666     /**
1667      * @dev See {IERC721-setApprovalForAll}.
1668      */
1669     function setApprovalForAll(address operator, bool approved) public virtual override {
1670         require(operator != _msgSender(), "ERC721: approve to caller");
1671 
1672         _operatorApprovals[_msgSender()][operator] = approved;
1673         emit ApprovalForAll(_msgSender(), operator, approved);
1674     }
1675 
1676     /**
1677      * @dev See {IERC721-isApprovedForAll}.
1678      */
1679     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1680         return _operatorApprovals[owner][operator];
1681     }
1682 
1683     /**
1684      * @dev See {IERC721-transferFrom}.
1685      */
1686     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1687         //solhint-disable-next-line max-line-length
1688         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1689 
1690         _transfer(from, to, tokenId);
1691     }
1692 
1693     /**
1694      * @dev See {IERC721-safeTransferFrom}.
1695      */
1696     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1697         safeTransferFrom(from, to, tokenId, "");
1698     }
1699 
1700     /**
1701      * @dev See {IERC721-safeTransferFrom}.
1702      */
1703     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1704         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1705         _safeTransfer(from, to, tokenId, _data);
1706     }
1707 
1708     /**
1709      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1710      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1711      *
1712      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1713      *
1714      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1715      * implement alternative mechanisms to perform token transfer, such as signature-based.
1716      *
1717      * Requirements:
1718      *
1719      * - `from` cannot be the zero address.
1720      * - `to` cannot be the zero address.
1721      * - `tokenId` token must exist and be owned by `from`.
1722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1723      *
1724      * Emits a {Transfer} event.
1725      */
1726     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1727         _transfer(from, to, tokenId);
1728         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1729     }
1730 
1731     /**
1732      * @dev Returns whether `tokenId` exists.
1733      *
1734      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1735      *
1736      * Tokens start existing when they are minted (`_mint`),
1737      * and stop existing when they are burned (`_burn`).
1738      */
1739     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1740         return _tokenOwners.contains(tokenId);
1741     }
1742 
1743     /**
1744      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1745      *
1746      * Requirements:
1747      *
1748      * - `tokenId` must exist.
1749      */
1750     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1751         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1752         address owner = ERC721.ownerOf(tokenId);
1753         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1754     }
1755 
1756     /**
1757      * @dev Safely mints `tokenId` and transfers it to `to`.
1758      *
1759      * Requirements:
1760      d*
1761      * - `tokenId` must not exist.
1762      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1763      *
1764      * Emits a {Transfer} event.
1765      */
1766     function _safeMint(address to, uint256 tokenId) internal virtual {
1767         _safeMint(to, tokenId, "");
1768     }
1769 
1770     /**
1771      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1772      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1773      */
1774     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1775         _mint(to, tokenId);
1776         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1777     }
1778 
1779     /**
1780      * @dev Mints `tokenId` and transfers it to `to`.
1781      *
1782      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1783      *
1784      * Requirements:
1785      *
1786      * - `tokenId` must not exist.
1787      * - `to` cannot be the zero address.
1788      *
1789      * Emits a {Transfer} event.
1790      */
1791     function _mint(address to, uint256 tokenId) internal virtual {
1792         require(to != address(0), "ERC721: mint to the zero address");
1793         require(!_exists(tokenId), "ERC721: token already minted");
1794 
1795         _beforeTokenTransfer(address(0), to, tokenId);
1796 
1797         _holderTokens[to].add(tokenId);
1798 
1799         _tokenOwners.set(tokenId, to);
1800 
1801         emit Transfer(address(0), to, tokenId);
1802     }
1803 
1804     /**
1805      * @dev Destroys `tokenId`.
1806      * The approval is cleared when the token is burned.
1807      *
1808      * Requirements:
1809      *
1810      * - `tokenId` must exist.
1811      *
1812      * Emits a {Transfer} event.
1813      */
1814     function _burn(uint256 tokenId) internal virtual {
1815         address owner = ERC721.ownerOf(tokenId); // internal owner
1816 
1817         _beforeTokenTransfer(owner, address(0), tokenId);
1818 
1819         // Clear approvals
1820         _approve(address(0), tokenId);
1821 
1822         // Clear metadata (if any)
1823         // if (bytes(_tokenURIs[tokenId]).length != 0) {
1824         //     delete _tokenURIs[tokenId];
1825         // }
1826 
1827         _holderTokens[owner].remove(tokenId);
1828 
1829         _tokenOwners.remove(tokenId);
1830 
1831         emit Transfer(owner, address(0), tokenId);
1832     }
1833 
1834     /**
1835      * @dev Transfers `tokenId` from `from` to `to`.
1836      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1837      *
1838      * Requirements:
1839      *
1840      * - `to` cannot be the zero address.
1841      * - `tokenId` token must be owned by `from`.
1842      *
1843      * Emits a {Transfer} event.
1844      */
1845     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1846         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1847         require(to != address(0), "ERC721: transfer to the zero address");
1848 
1849         _beforeTokenTransfer(from, to, tokenId);
1850 
1851         // Clear approvals from the previous owner
1852         _approve(address(0), tokenId);
1853 
1854         _holderTokens[from].remove(tokenId);
1855         _holderTokens[to].add(tokenId);
1856 
1857         _tokenOwners.set(tokenId, to);
1858 
1859         emit Transfer(from, to, tokenId);
1860     }
1861 
1862     /**
1863      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1864      *
1865      * Requirements:
1866      *
1867      * - `tokenId` must exist.
1868      */
1869     // function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1870     //     require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1871     //     _tokenURIs[tokenId] = _tokenURI;
1872     // }
1873 
1874     /**
1875      * @dev Internal function to set the base URI for all token IDs. It is
1876      * automatically added as a prefix to the value returned in {tokenURI},
1877      * or to the token ID if {tokenURI} is empty.
1878      */
1879     function _setBaseURI(string memory baseURI_) internal virtual {
1880         _baseURI = baseURI_;
1881     }
1882 
1883     /**
1884      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1885      * The call is not executed if the target address is not a contract.
1886      *
1887      * @param from address representing the previous owner of the given token ID
1888      * @param to target address that will receive the tokens
1889      * @param tokenId uint256 ID of the token to be transferred
1890      * @param _data bytes optional data to send along with the call
1891      * @return bool whether the call correctly returned the expected magic value
1892      */
1893     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1894         private returns (bool)
1895     {
1896         if (!to.isContract()) {
1897             return true;
1898         }
1899         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1900             IERC721Receiver(to).onERC721Received.selector,
1901             _msgSender(),
1902             from,
1903             tokenId,
1904             _data
1905         ), "ERC721: transfer to non ERC721Receiver implementer");
1906         bytes4 retval = abi.decode(returndata, (bytes4));
1907         return (retval == _ERC721_RECEIVED);
1908     }
1909 
1910     function _approve(address to, uint256 tokenId) private {
1911         _tokenApprovals[tokenId] = to;
1912         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1913     }
1914 
1915     /**
1916      * @dev Hook that is called before any token transfer. This includes minting
1917      * and burning.
1918      *
1919      * Calling conditions:
1920      *
1921      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1922      * transferred to `to`.
1923      * - When `from` is zero, `tokenId` will be minted for `to`.
1924      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1925      * - `from` cannot be the zero address.
1926      * - `to` cannot be the zero address.
1927      *
1928      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1929      */
1930     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1931 }
1932 
1933 
1934 // File: contracts/ColourTime721.sol
1935 pragma solidity >=0.6.0 <0.8.0;
1936 
1937 
1938 /**
1939  * @dev {ERC721} token, including:
1940  *
1941  *  - ability for holders to burn (destroy) their tokens
1942  *  - a minter role that allows for token minting (creation)
1943  *  - token ID and URI autogeneration
1944  *
1945  * This contract uses {AccessControl} to lock permissioned functions using the
1946  * different roles - head to its documentation for details.
1947  *
1948  * The account that deploys the contract will be granted the minter and pauser
1949  * roles, as well as the default admin role, which will let it grant both minter
1950  * and pauser roles to other accounts.
1951  */
1952 
1953 contract TokenHash721 is Context, ERC721, Ownable {
1954     // using Counters for Counters.Counter;
1955     using SafeMath for uint256;
1956     
1957     address payable public withdrawalAddress;
1958     
1959     //Token sale control logic
1960     // Counters.Counter private piecesSold;
1961     uint256 public maxNumberOfPieces;
1962 
1963     //Standard sale
1964     bool public standardSaleActive;
1965     uint256 public pricePerPiece;
1966     
1967     //Presale        
1968     bool public preSaleActive;
1969     mapping (address => uint256) public whitelisted;
1970     mapping (address => uint256) public preSaleMinted;
1971 
1972     event Purchase(address buyer, uint256 price, uint256 tokenId);
1973     event MetadataUpdated(string newTokenUriBase);
1974     
1975     constructor(
1976         uint256 givenPricePerPiece,
1977         address payable givenWithdrawalAddress
1978     ) ERC721("Token Hash", "TH") {
1979         pricePerPiece = givenPricePerPiece;
1980         withdrawalAddress = givenWithdrawalAddress;
1981         maxNumberOfPieces = 1000;
1982         _setBaseURI("");
1983     }
1984     
1985     function random(string memory input) internal pure returns (uint256) {
1986         return uint256(keccak256(abi.encodePacked(input)));
1987     }
1988     
1989     function generateHash(uint256 tokenId) internal pure returns (uint256){
1990         return random(string(abi.encodePacked("RANDOM", toString(tokenId)))) % 999;
1991     }
1992    
1993     function checkSimilarity(uint256 tokenId, uint256 hashMod) private pure returns(uint256){
1994         uint256 similarity = 0;
1995         
1996         //modulo will return 0 even if no digit is present, so we exclude 0 
1997         if(tokenId % 10 == hashMod %10 && tokenId % 10 > 0 && hashMod % 10 > 0){
1998             similarity ++;
1999         }
2000         
2001         if(tokenId % 100 /10 == hashMod % 100 /10 && tokenId % 100 /10 > 0 && hashMod % 100 /10 > 0){
2002             similarity ++;
2003         }
2004         
2005         if(tokenId % 1000 /100 == hashMod % 1000 /100 && tokenId % 1000 /100 > 0 && hashMod % 1000 /100 > 0){
2006             similarity ++;
2007         }
2008         
2009         if(tokenId == hashMod){
2010             similarity ++;
2011         }
2012         
2013         return similarity;
2014     }
2015     
2016     function checkSymmetry(uint256 tokenId, uint256 hashMod) private pure returns(uint256){
2017         uint256 symmetry = 0;
2018         
2019         //Hash first and last 
2020         if(hashMod % 10 == hashMod % 1000 /100 && hashMod % 10 > 0 && hashMod % 1000 /100 > 0){
2021             symmetry ++;
2022         }
2023         
2024         //Hash first and second 
2025         if(hashMod % 10 == hashMod % 100 /10 && hashMod % 10 > 0 && hashMod % 100 /10 > 0){
2026             symmetry ++;
2027         }
2028         
2029         //Hash second and third 
2030         if(hashMod % 100/10 == hashMod % 1000 /100 && hashMod % 100/10 > 0 && hashMod % 1000 /100 > 0){
2031             symmetry ++;
2032         }
2033         
2034         //Token ID first and last
2035         if(tokenId % 10 == tokenId % 1000 /100 && tokenId % 10 > 0 && tokenId % 1000 /100 > 0){
2036             symmetry ++;
2037         }
2038         
2039         //Token Id first and second
2040         if(tokenId % 10 == tokenId % 100 /10 && tokenId % 10 > 0 && tokenId % 100 /10 > 0){
2041             symmetry ++;
2042         }
2043         
2044         //Token Id second and third
2045         if(tokenId % 100/10 == tokenId % 1000 /100 && tokenId % 100/10 > 0 && tokenId % 1000 /100 > 0){
2046             symmetry ++;
2047         }
2048         
2049         //Cross - first tokenID to last hash 
2050         if(tokenId % 10 == hashMod % 1000 /100 && tokenId % 10 > 0 && hashMod % 1000 /100 > 0){
2051             symmetry ++;
2052         }
2053         
2054         //Cross - last token ID to first hash 
2055         if(tokenId % 1000 /100 == hashMod % 10 && tokenId % 1000 /100 > 0 && hashMod % 10 > 0){
2056             symmetry ++;
2057         }
2058 
2059         //Middle to middle  
2060         if(tokenId % 100 /10 == hashMod % 100 /10 && tokenId % 100 /10 > 0 && hashMod % 100 /10 > 0){
2061             symmetry ++;
2062         }
2063         
2064         return symmetry;
2065     }
2066     
2067     //Generate svg
2068     function tokenURI(uint256 tokenId) override public view returns (string memory){
2069             
2070             require(_exists(tokenId)  || msg.sender == owner(), "ERC721Metadata: URI query for nonexistent token");
2071             
2072             uint256 hashMod = generateHash(tokenId);
2073            
2074             if(tokenId == 0x45){
2075                 hashMod = 0x1A4;
2076             }
2077             
2078             if(tokenId == 0x1A4){
2079                 hashMod = 0x45;
2080             }
2081             
2082             uint256 similarity = checkSimilarity(tokenId, hashMod);
2083             uint256 symmetry = checkSymmetry(tokenId, hashMod);
2084             
2085             string[6] memory parts;
2086             parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 30px; }</style><rect width="100%" height="100%" fill="black" />';
2087             parts[1] =  '<text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" class="base">';
2088             parts[2] =  toString(tokenId);
2089             parts[3] =  ', ';
2090             parts[4] =  toString(hashMod);
2091             parts[5] = '</text></svg>';
2092             
2093             string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]));
2094             string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Token Hash ', toString(tokenId), ', ', toString(hashMod), '", "description": "Token Hash presents the two values from which all value and variation derive in the on-chain generative NFT as an on-chain generative NFT.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '", "attributes": [ { "trait_type": "Similarity", "value": "', toString(similarity) , '" }, { "trait_type": "Symmetry", "value": "', toString(symmetry) , '" } ] } '  ))));
2095             output = string(abi.encodePacked('data:application/json;base64,', json));
2096             return output;
2097             
2098     }
2099    
2100     //Input array of addresses to whitelist and array of max mint per account 
2101     function setWhitelistAddress(address[] memory users, uint256[] memory allowedMint) public onlyOwner {
2102         for (uint256 i = 0; i < users.length; i++) {
2103             whitelisted[users[i]] = allowedMint[i];
2104         }
2105     }    
2106     
2107     //Sale logic
2108     function setPresaleActive(bool isActive) public onlyOwner{
2109         preSaleActive = isActive;
2110     }
2111     
2112     function setSaleActive(bool isActive) public onlyOwner {
2113         standardSaleActive = isActive;
2114     }
2115     
2116     //Price setting
2117     function setPrice(uint256 givenPrice) external onlyOwner {
2118         pricePerPiece = givenPrice;
2119     }
2120 
2121     function getPrice() external view returns(uint256) {
2122         return pricePerPiece;
2123     }
2124 
2125     //Withdrawal 
2126     function setWithdrawalAddress(address payable givenWithdrawalAddress) public onlyOwner {
2127         withdrawalAddress = givenWithdrawalAddress;
2128     }
2129 
2130     function withdrawEth() public onlyOwner {
2131         Address.sendValue(withdrawalAddress, address(this).balance);
2132     }
2133 
2134     //Owner info
2135     function tokenInfo(uint256 tokenId) public view returns (address) {
2136         return (ownerOf(tokenId));
2137     }
2138     
2139     function getOwners(uint256 start, uint256 end) public view returns (address[] memory){
2140         address[] memory re = new address[](end - start);
2141         for (uint256 i = start; i < end; i++) {
2142                 re[i - start] = ownerOf(i);
2143         }
2144         return re;
2145     }
2146     
2147     //Minting
2148     function preMint() public payable {
2149         require(preSaleActive, "presale not open"); 
2150         require(whitelisted[msg.sender] > 0, "address not on whitelist "); 
2151         //no limit on this pre-sale
2152         // require(whitelisted[msg.sender] > preSaleMinted[msg.sender], "exceeded mint"); 
2153         mintItem();
2154         preSaleMinted[msg.sender] += 1;
2155         
2156     }
2157     
2158     function mint() public payable {
2159         require(standardSaleActive || msg.sender == owner(), "sale must be active");
2160         require(msg.value == pricePerPiece, "must send in correct amount");
2161         mintItem();
2162     }
2163     
2164     function mintItem() private returns (uint256) {
2165         
2166         //Referencing total supply instead of keeping our own counter 
2167         require(totalSupply() < maxNumberOfPieces, "series is sold out");
2168         require(msg.value >= pricePerPiece, "not enough eth sent "); 
2169         emit Purchase(msg.sender, msg.value, totalSupply());
2170         uint256 tokenToMint = totalSupply();
2171         _safeMint(msg.sender, tokenToMint);
2172         return tokenToMint;
2173         
2174     }
2175     
2176     //Helpers
2177     function toString(uint256 value) internal pure returns (string memory) {
2178     // Inspired by OraclizeAPI's implementation - MIT license
2179     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2180 
2181         if (value == 0) {
2182             return "0";
2183         }
2184         uint256 temp = value;
2185         uint256 digits;
2186         while (temp != 0) {
2187             digits++;
2188             temp /= 10;
2189         }
2190         bytes memory buffer = new bytes(digits);
2191         while (value != 0) {
2192             digits -= 1;
2193             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2194             value /= 10;
2195         }
2196         return string(buffer);
2197     }
2198 }
2199 
2200 
2201 /// [MIT License]
2202 /// @title Base64
2203 /// @notice Provides a function for encoding some bytes in base64
2204 /// @author Brecht Devos <brecht@loopring.org>
2205 library Base64 {
2206     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2207 
2208     /// @notice Encodes some bytes to the base64 representation
2209     function encode(bytes memory data) internal pure returns (string memory) {
2210         uint256 len = data.length;
2211         if (len == 0) return "";
2212 
2213         // multiply by 4/3 rounded up
2214         uint256 encodedLen = 4 * ((len + 2) / 3);
2215 
2216         // Add some extra buffer at the end
2217         bytes memory result = new bytes(encodedLen + 32);
2218 
2219         bytes memory table = TABLE;
2220 
2221         assembly {
2222             let tablePtr := add(table, 1)
2223             let resultPtr := add(result, 32)
2224 
2225             for {
2226                 let i := 0
2227             } lt(i, len) {
2228 
2229             } {
2230                 i := add(i, 3)
2231                 let input := and(mload(add(data, i)), 0xffffff)
2232 
2233                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
2234                 out := shl(8, out)
2235                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
2236                 out := shl(8, out)
2237                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
2238                 out := shl(8, out)
2239                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
2240                 out := shl(224, out)
2241 
2242                 mstore(resultPtr, out)
2243 
2244                 resultPtr := add(resultPtr, 4)
2245             }
2246 
2247             switch mod(len, 3)
2248             case 1 {
2249                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
2250             }
2251             case 2 {
2252                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
2253             }
2254 
2255             mstore(result, encodedLen)
2256         }
2257 
2258         return string(result);
2259     }
2260 }