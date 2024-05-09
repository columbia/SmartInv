1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
219 
220 
221 
222 pragma solidity >=0.6.0 <0.8.0;
223 
224 /**
225  * @dev Library for managing
226  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
227  * types.
228  *
229  * Sets have the following properties:
230  *
231  * - Elements are added, removed, and checked for existence in constant time
232  * (O(1)).
233  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
234  *
235  * ```
236  * contract Example {
237  *     // Add the library methods
238  *     using EnumerableSet for EnumerableSet.AddressSet;
239  *
240  *     // Declare a set state variable
241  *     EnumerableSet.AddressSet private mySet;
242  * }
243  * ```
244  *
245  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
246  * and `uint256` (`UintSet`) are supported.
247  */
248 library EnumerableSet {
249     // To implement this library for multiple types with as little code
250     // repetition as possible, we write it in terms of a generic Set type with
251     // bytes32 values.
252     // The Set implementation uses private functions, and user-facing
253     // implementations (such as AddressSet) are just wrappers around the
254     // underlying Set.
255     // This means that we can only create new EnumerableSets for types that fit
256     // in bytes32.
257 
258     struct Set {
259         // Storage of set values
260         bytes32[] _values;
261 
262         // Position of the value in the `values` array, plus 1 because index 0
263         // means a value is not in the set.
264         mapping (bytes32 => uint256) _indexes;
265     }
266 
267     /**
268      * @dev Add a value to a set. O(1).
269      *
270      * Returns true if the value was added to the set, that is if it was not
271      * already present.
272      */
273     function _add(Set storage set, bytes32 value) private returns (bool) {
274         if (!_contains(set, value)) {
275             set._values.push(value);
276             // The value is stored at length-1, but we add 1 to all indexes
277             // and use 0 as a sentinel value
278             set._indexes[value] = set._values.length;
279             return true;
280         } else {
281             return false;
282         }
283     }
284 
285     /**
286      * @dev Removes a value from a set. O(1).
287      *
288      * Returns true if the value was removed from the set, that is if it was
289      * present.
290      */
291     function _remove(Set storage set, bytes32 value) private returns (bool) {
292         // We read and store the value's index to prevent multiple reads from the same storage slot
293         uint256 valueIndex = set._indexes[value];
294 
295         if (valueIndex != 0) { // Equivalent to contains(set, value)
296             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
297             // the array, and then remove the last element (sometimes called as 'swap and pop').
298             // This modifies the order of the array, as noted in {at}.
299 
300             uint256 toDeleteIndex = valueIndex - 1;
301             uint256 lastIndex = set._values.length - 1;
302 
303             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
304             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
305 
306             bytes32 lastvalue = set._values[lastIndex];
307 
308             // Move the last value to the index where the value to delete is
309             set._values[toDeleteIndex] = lastvalue;
310             // Update the index for the moved value
311             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
312 
313             // Delete the slot where the moved value was stored
314             set._values.pop();
315 
316             // Delete the index for the deleted slot
317             delete set._indexes[value];
318 
319             return true;
320         } else {
321             return false;
322         }
323     }
324 
325     /**
326      * @dev Returns true if the value is in the set. O(1).
327      */
328     function _contains(Set storage set, bytes32 value) private view returns (bool) {
329         return set._indexes[value] != 0;
330     }
331 
332     /**
333      * @dev Returns the number of values on the set. O(1).
334      */
335     function _length(Set storage set) private view returns (uint256) {
336         return set._values.length;
337     }
338 
339    /**
340     * @dev Returns the value stored at position `index` in the set. O(1).
341     *
342     * Note that there are no guarantees on the ordering of values inside the
343     * array, and it may change when more values are added or removed.
344     *
345     * Requirements:
346     *
347     * - `index` must be strictly less than {length}.
348     */
349     function _at(Set storage set, uint256 index) private view returns (bytes32) {
350         require(set._values.length > index, "EnumerableSet: index out of bounds");
351         return set._values[index];
352     }
353 
354     // Bytes32Set
355 
356     struct Bytes32Set {
357         Set _inner;
358     }
359 
360     /**
361      * @dev Add a value to a set. O(1).
362      *
363      * Returns true if the value was added to the set, that is if it was not
364      * already present.
365      */
366     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
367         return _add(set._inner, value);
368     }
369 
370     /**
371      * @dev Removes a value from a set. O(1).
372      *
373      * Returns true if the value was removed from the set, that is if it was
374      * present.
375      */
376     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
377         return _remove(set._inner, value);
378     }
379 
380     /**
381      * @dev Returns true if the value is in the set. O(1).
382      */
383     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
384         return _contains(set._inner, value);
385     }
386 
387     /**
388      * @dev Returns the number of values in the set. O(1).
389      */
390     function length(Bytes32Set storage set) internal view returns (uint256) {
391         return _length(set._inner);
392     }
393 
394    /**
395     * @dev Returns the value stored at position `index` in the set. O(1).
396     *
397     * Note that there are no guarantees on the ordering of values inside the
398     * array, and it may change when more values are added or removed.
399     *
400     * Requirements:
401     *
402     * - `index` must be strictly less than {length}.
403     */
404     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
405         return _at(set._inner, index);
406     }
407 
408     // AddressSet
409 
410     struct AddressSet {
411         Set _inner;
412     }
413 
414     /**
415      * @dev Add a value to a set. O(1).
416      *
417      * Returns true if the value was added to the set, that is if it was not
418      * already present.
419      */
420     function add(AddressSet storage set, address value) internal returns (bool) {
421         return _add(set._inner, bytes32(uint256(uint160(value))));
422     }
423 
424     /**
425      * @dev Removes a value from a set. O(1).
426      *
427      * Returns true if the value was removed from the set, that is if it was
428      * present.
429      */
430     function remove(AddressSet storage set, address value) internal returns (bool) {
431         return _remove(set._inner, bytes32(uint256(uint160(value))));
432     }
433 
434     /**
435      * @dev Returns true if the value is in the set. O(1).
436      */
437     function contains(AddressSet storage set, address value) internal view returns (bool) {
438         return _contains(set._inner, bytes32(uint256(uint160(value))));
439     }
440 
441     /**
442      * @dev Returns the number of values in the set. O(1).
443      */
444     function length(AddressSet storage set) internal view returns (uint256) {
445         return _length(set._inner);
446     }
447 
448    /**
449     * @dev Returns the value stored at position `index` in the set. O(1).
450     *
451     * Note that there are no guarantees on the ordering of values inside the
452     * array, and it may change when more values are added or removed.
453     *
454     * Requirements:
455     *
456     * - `index` must be strictly less than {length}.
457     */
458     function at(AddressSet storage set, uint256 index) internal view returns (address) {
459         return address(uint160(uint256(_at(set._inner, index))));
460     }
461 
462 
463     // UintSet
464 
465     struct UintSet {
466         Set _inner;
467     }
468 
469     /**
470      * @dev Add a value to a set. O(1).
471      *
472      * Returns true if the value was added to the set, that is if it was not
473      * already present.
474      */
475     function add(UintSet storage set, uint256 value) internal returns (bool) {
476         return _add(set._inner, bytes32(value));
477     }
478 
479     /**
480      * @dev Removes a value from a set. O(1).
481      *
482      * Returns true if the value was removed from the set, that is if it was
483      * present.
484      */
485     function remove(UintSet storage set, uint256 value) internal returns (bool) {
486         return _remove(set._inner, bytes32(value));
487     }
488 
489     /**
490      * @dev Returns true if the value is in the set. O(1).
491      */
492     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
493         return _contains(set._inner, bytes32(value));
494     }
495 
496     /**
497      * @dev Returns the number of values on the set. O(1).
498      */
499     function length(UintSet storage set) internal view returns (uint256) {
500         return _length(set._inner);
501     }
502 
503    /**
504     * @dev Returns the value stored at position `index` in the set. O(1).
505     *
506     * Note that there are no guarantees on the ordering of values inside the
507     * array, and it may change when more values are added or removed.
508     *
509     * Requirements:
510     *
511     * - `index` must be strictly less than {length}.
512     */
513     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
514         return uint256(_at(set._inner, index));
515     }
516 }
517 
518 // File: @openzeppelin/contracts/utils/Address.sol
519 
520 
521 
522 pragma solidity >=0.6.2 <0.8.0;
523 
524 /**
525  * @dev Collection of functions related to the address type
526  */
527 library Address {
528     /**
529      * @dev Returns true if `account` is a contract.
530      *
531      * [IMPORTANT]
532      * ====
533      * It is unsafe to assume that an address for which this function returns
534      * false is an externally-owned account (EOA) and not a contract.
535      *
536      * Among others, `isContract` will return false for the following
537      * types of addresses:
538      *
539      *  - an externally-owned account
540      *  - a contract in construction
541      *  - an address where a contract will be created
542      *  - an address where a contract lived, but was destroyed
543      * ====
544      */
545     function isContract(address account) internal view returns (bool) {
546         // This method relies on extcodesize, which returns 0 for contracts in
547         // construction, since the code is only stored at the end of the
548         // constructor execution.
549 
550         uint256 size;
551         // solhint-disable-next-line no-inline-assembly
552         assembly { size := extcodesize(account) }
553         return size > 0;
554     }
555 
556     /**
557      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
558      * `recipient`, forwarding all available gas and reverting on errors.
559      *
560      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
561      * of certain opcodes, possibly making contracts go over the 2300 gas limit
562      * imposed by `transfer`, making them unable to receive funds via
563      * `transfer`. {sendValue} removes this limitation.
564      *
565      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
566      *
567      * IMPORTANT: because control is transferred to `recipient`, care must be
568      * taken to not create reentrancy vulnerabilities. Consider using
569      * {ReentrancyGuard} or the
570      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
571      */
572     function sendValue(address payable recipient, uint256 amount) internal {
573         require(address(this).balance >= amount, "Address: insufficient balance");
574 
575         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
576         (bool success, ) = recipient.call{ value: amount }("");
577         require(success, "Address: unable to send value, recipient may have reverted");
578     }
579 
580     /**
581      * @dev Performs a Solidity function call using a low level `call`. A
582      * plain`call` is an unsafe replacement for a function call: use this
583      * function instead.
584      *
585      * If `target` reverts with a revert reason, it is bubbled up by this
586      * function (like regular Solidity function calls).
587      *
588      * Returns the raw returned data. To convert to the expected return value,
589      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
590      *
591      * Requirements:
592      *
593      * - `target` must be a contract.
594      * - calling `target` with `data` must not revert.
595      *
596      * _Available since v3.1._
597      */
598     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
599       return functionCall(target, data, "Address: low-level call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
604      * `errorMessage` as a fallback revert reason when `target` reverts.
605      *
606      * _Available since v3.1._
607      */
608     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
609         return functionCallWithValue(target, data, 0, errorMessage);
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
614      * but also transferring `value` wei to `target`.
615      *
616      * Requirements:
617      *
618      * - the calling contract must have an ETH balance of at least `value`.
619      * - the called Solidity function must be `payable`.
620      *
621      * _Available since v3.1._
622      */
623     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
624         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
629      * with `errorMessage` as a fallback revert reason when `target` reverts.
630      *
631      * _Available since v3.1._
632      */
633     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
634         require(address(this).balance >= value, "Address: insufficient balance for call");
635         require(isContract(target), "Address: call to non-contract");
636 
637         // solhint-disable-next-line avoid-low-level-calls
638         (bool success, bytes memory returndata) = target.call{ value: value }(data);
639         return _verifyCallResult(success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but performing a static call.
645      *
646      * _Available since v3.3._
647      */
648     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
649         return functionStaticCall(target, data, "Address: low-level static call failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
654      * but performing a static call.
655      *
656      * _Available since v3.3._
657      */
658     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
659         require(isContract(target), "Address: static call to non-contract");
660 
661         // solhint-disable-next-line avoid-low-level-calls
662         (bool success, bytes memory returndata) = target.staticcall(data);
663         return _verifyCallResult(success, returndata, errorMessage);
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
668      * but performing a delegate call.
669      *
670      * _Available since v3.4._
671      */
672     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
673         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
674     }
675 
676     /**
677      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
678      * but performing a delegate call.
679      *
680      * _Available since v3.4._
681      */
682     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
683         require(isContract(target), "Address: delegate call to non-contract");
684 
685         // solhint-disable-next-line avoid-low-level-calls
686         (bool success, bytes memory returndata) = target.delegatecall(data);
687         return _verifyCallResult(success, returndata, errorMessage);
688     }
689 
690     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
691         if (success) {
692             return returndata;
693         } else {
694             // Look for revert reason and bubble it up if present
695             if (returndata.length > 0) {
696                 // The easiest way to bubble the revert reason is using memory via assembly
697 
698                 // solhint-disable-next-line no-inline-assembly
699                 assembly {
700                     let returndata_size := mload(returndata)
701                     revert(add(32, returndata), returndata_size)
702                 }
703             } else {
704                 revert(errorMessage);
705             }
706         }
707     }
708 }
709 
710 // File: @openzeppelin/contracts/utils/Context.sol
711 
712 
713 
714 pragma solidity >=0.6.0 <0.8.0;
715 
716 /*
717  * @dev Provides information about the current execution context, including the
718  * sender of the transaction and its data. While these are generally available
719  * via msg.sender and msg.data, they should not be accessed in such a direct
720  * manner, since when dealing with GSN meta-transactions the account sending and
721  * paying for execution may not be the actual sender (as far as an application
722  * is concerned).
723  *
724  * This contract is only required for intermediate, library-like contracts.
725  */
726 abstract contract Context {
727     function _msgSender() internal view virtual returns (address payable) {
728         return msg.sender;
729     }
730 
731     function _msgData() internal view virtual returns (bytes memory) {
732         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
733         return msg.data;
734     }
735 }
736 
737 // File: @openzeppelin/contracts/access/AccessControl.sol
738 
739 
740 
741 pragma solidity >=0.6.0 <0.8.0;
742 
743 
744 
745 
746 /**
747  * @dev Contract module that allows children to implement role-based access
748  * control mechanisms.
749  *
750  * Roles are referred to by their `bytes32` identifier. These should be exposed
751  * in the external API and be unique. The best way to achieve this is by
752  * using `public constant` hash digests:
753  *
754  * ```
755  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
756  * ```
757  *
758  * Roles can be used to represent a set of permissions. To restrict access to a
759  * function call, use {hasRole}:
760  *
761  * ```
762  * function foo() public {
763  *     require(hasRole(MY_ROLE, msg.sender));
764  *     ...
765  * }
766  * ```
767  *
768  * Roles can be granted and revoked dynamically via the {grantRole} and
769  * {revokeRole} functions. Each role has an associated admin role, and only
770  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
771  *
772  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
773  * that only accounts with this role will be able to grant or revoke other
774  * roles. More complex role relationships can be created by using
775  * {_setRoleAdmin}.
776  *
777  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
778  * grant and revoke this role. Extra precautions should be taken to secure
779  * accounts that have been granted it.
780  */
781 abstract contract AccessControl is Context {
782     using EnumerableSet for EnumerableSet.AddressSet;
783     using Address for address;
784 
785     struct RoleData {
786         EnumerableSet.AddressSet members;
787         bytes32 adminRole;
788     }
789 
790     mapping (bytes32 => RoleData) private _roles;
791 
792     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
793 
794     /**
795      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
796      *
797      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
798      * {RoleAdminChanged} not being emitted signaling this.
799      *
800      * _Available since v3.1._
801      */
802     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
803 
804     /**
805      * @dev Emitted when `account` is granted `role`.
806      *
807      * `sender` is the account that originated the contract call, an admin role
808      * bearer except when using {_setupRole}.
809      */
810     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
811 
812     /**
813      * @dev Emitted when `account` is revoked `role`.
814      *
815      * `sender` is the account that originated the contract call:
816      *   - if using `revokeRole`, it is the admin role bearer
817      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
818      */
819     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
820 
821     /**
822      * @dev Returns `true` if `account` has been granted `role`.
823      */
824     function hasRole(bytes32 role, address account) public view returns (bool) {
825         return _roles[role].members.contains(account);
826     }
827 
828     /**
829      * @dev Returns the number of accounts that have `role`. Can be used
830      * together with {getRoleMember} to enumerate all bearers of a role.
831      */
832     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
833         return _roles[role].members.length();
834     }
835 
836     /**
837      * @dev Returns one of the accounts that have `role`. `index` must be a
838      * value between 0 and {getRoleMemberCount}, non-inclusive.
839      *
840      * Role bearers are not sorted in any particular way, and their ordering may
841      * change at any point.
842      *
843      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
844      * you perform all queries on the same block. See the following
845      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
846      * for more information.
847      */
848     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
849         return _roles[role].members.at(index);
850     }
851 
852     /**
853      * @dev Returns the admin role that controls `role`. See {grantRole} and
854      * {revokeRole}.
855      *
856      * To change a role's admin, use {_setRoleAdmin}.
857      */
858     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
859         return _roles[role].adminRole;
860     }
861 
862     /**
863      * @dev Grants `role` to `account`.
864      *
865      * If `account` had not been already granted `role`, emits a {RoleGranted}
866      * event.
867      *
868      * Requirements:
869      *
870      * - the caller must have ``role``'s admin role.
871      */
872     function grantRole(bytes32 role, address account) public virtual {
873         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
874 
875         _grantRole(role, account);
876     }
877 
878     /**
879      * @dev Revokes `role` from `account`.
880      *
881      * If `account` had been granted `role`, emits a {RoleRevoked} event.
882      *
883      * Requirements:
884      *
885      * - the caller must have ``role``'s admin role.
886      */
887     function revokeRole(bytes32 role, address account) public virtual {
888         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
889 
890         _revokeRole(role, account);
891     }
892 
893     /**
894      * @dev Revokes `role` from the calling account.
895      *
896      * Roles are often managed via {grantRole} and {revokeRole}: this function's
897      * purpose is to provide a mechanism for accounts to lose their privileges
898      * if they are compromised (such as when a trusted device is misplaced).
899      *
900      * If the calling account had been granted `role`, emits a {RoleRevoked}
901      * event.
902      *
903      * Requirements:
904      *
905      * - the caller must be `account`.
906      */
907     function renounceRole(bytes32 role, address account) public virtual {
908         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
909 
910         _revokeRole(role, account);
911     }
912 
913     /**
914      * @dev Grants `role` to `account`.
915      *
916      * If `account` had not been already granted `role`, emits a {RoleGranted}
917      * event. Note that unlike {grantRole}, this function doesn't perform any
918      * checks on the calling account.
919      *
920      * [WARNING]
921      * ====
922      * This function should only be called from the constructor when setting
923      * up the initial roles for the system.
924      *
925      * Using this function in any other way is effectively circumventing the admin
926      * system imposed by {AccessControl}.
927      * ====
928      */
929     function _setupRole(bytes32 role, address account) internal virtual {
930         _grantRole(role, account);
931     }
932 
933     /**
934      * @dev Sets `adminRole` as ``role``'s admin role.
935      *
936      * Emits a {RoleAdminChanged} event.
937      */
938     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
939         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
940         _roles[role].adminRole = adminRole;
941     }
942 
943     function _grantRole(bytes32 role, address account) private {
944         if (_roles[role].members.add(account)) {
945             emit RoleGranted(role, account, _msgSender());
946         }
947     }
948 
949     function _revokeRole(bytes32 role, address account) private {
950         if (_roles[role].members.remove(account)) {
951             emit RoleRevoked(role, account, _msgSender());
952         }
953     }
954 }
955 
956 // File: @openzeppelin/contracts/utils/Counters.sol
957 
958 
959 
960 pragma solidity >=0.6.0 <0.8.0;
961 
962 
963 /**
964  * @title Counters
965  * @author Matt Condon (@shrugs)
966  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
967  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
968  *
969  * Include with `using Counters for Counters.Counter;`
970  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
971  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
972  * directly accessed.
973  */
974 library Counters {
975     using SafeMath for uint256;
976 
977     struct Counter {
978         // This variable should never be directly accessed by users of the library: interactions must be restricted to
979         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
980         // this feature: see https://github.com/ethereum/solidity/issues/4637
981         uint256 _value; // default: 0
982     }
983 
984     function current(Counter storage counter) internal view returns (uint256) {
985         return counter._value;
986     }
987 
988     function increment(Counter storage counter) internal {
989         // The {SafeMath} overflow check can be skipped here, see the comment at the top
990         counter._value += 1;
991     }
992 
993     function decrement(Counter storage counter) internal {
994         counter._value = counter._value.sub(1);
995     }
996 }
997 
998 // File: @openzeppelin/contracts/introspection/IERC165.sol
999 
1000 
1001 
1002 pragma solidity >=0.6.0 <0.8.0;
1003 
1004 /**
1005  * @dev Interface of the ERC165 standard, as defined in the
1006  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1007  *
1008  * Implementers can declare support of contract interfaces, which can then be
1009  * queried by others ({ERC165Checker}).
1010  *
1011  * For an implementation, see {ERC165}.
1012  */
1013 interface IERC165 {
1014     /**
1015      * @dev Returns true if this contract implements the interface defined by
1016      * `interfaceId`. See the corresponding
1017      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1018      * to learn more about how these ids are created.
1019      *
1020      * This function call must use less than 30 000 gas.
1021      */
1022     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1023 }
1024 
1025 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1026 
1027 
1028 
1029 pragma solidity >=0.6.2 <0.8.0;
1030 
1031 
1032 /**
1033  * @dev Required interface of an ERC721 compliant contract.
1034  */
1035 interface IERC721 is IERC165 {
1036     /**
1037      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1038      */
1039     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1040 
1041     /**
1042      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1043      */
1044     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1045 
1046     /**
1047      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1048      */
1049     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1050 
1051     /**
1052      * @dev Returns the number of tokens in ``owner``'s account.
1053      */
1054     function balanceOf(address owner) external view returns (uint256 balance);
1055 
1056     /**
1057      * @dev Returns the owner of the `tokenId` token.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      */
1063     function ownerOf(uint256 tokenId) external view returns (address owner);
1064 
1065     /**
1066      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1067      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1068      *
1069      * Requirements:
1070      *
1071      * - `from` cannot be the zero address.
1072      * - `to` cannot be the zero address.
1073      * - `tokenId` token must exist and be owned by `from`.
1074      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1075      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1080 
1081     /**
1082      * @dev Transfers `tokenId` token from `from` to `to`.
1083      *
1084      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1085      *
1086      * Requirements:
1087      *
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      * - `tokenId` token must be owned by `from`.
1091      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function transferFrom(address from, address to, uint256 tokenId) external;
1096 
1097     /**
1098      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1099      * The approval is cleared when the token is transferred.
1100      *
1101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1102      *
1103      * Requirements:
1104      *
1105      * - The caller must own the token or be an approved operator.
1106      * - `tokenId` must exist.
1107      *
1108      * Emits an {Approval} event.
1109      */
1110     function approve(address to, uint256 tokenId) external;
1111 
1112     /**
1113      * @dev Returns the account approved for `tokenId` token.
1114      *
1115      * Requirements:
1116      *
1117      * - `tokenId` must exist.
1118      */
1119     function getApproved(uint256 tokenId) external view returns (address operator);
1120 
1121     /**
1122      * @dev Approve or remove `operator` as an operator for the caller.
1123      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1124      *
1125      * Requirements:
1126      *
1127      * - The `operator` cannot be the caller.
1128      *
1129      * Emits an {ApprovalForAll} event.
1130      */
1131     function setApprovalForAll(address operator, bool _approved) external;
1132 
1133     /**
1134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1135      *
1136      * See {setApprovalForAll}
1137      */
1138     function isApprovedForAll(address owner, address operator) external view returns (bool);
1139 
1140     /**
1141       * @dev Safely transfers `tokenId` token from `from` to `to`.
1142       *
1143       * Requirements:
1144       *
1145       * - `from` cannot be the zero address.
1146       * - `to` cannot be the zero address.
1147       * - `tokenId` token must exist and be owned by `from`.
1148       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1149       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1150       *
1151       * Emits a {Transfer} event.
1152       */
1153     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1154 }
1155 
1156 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1157 
1158 
1159 
1160 pragma solidity >=0.6.2 <0.8.0;
1161 
1162 
1163 /**
1164  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1165  * @dev See https://eips.ethereum.org/EIPS/eip-721
1166  */
1167 interface IERC721Metadata is IERC721 {
1168 
1169     /**
1170      * @dev Returns the token collection name.
1171      */
1172     function name() external view returns (string memory);
1173 
1174     /**
1175      * @dev Returns the token collection symbol.
1176      */
1177     function symbol() external view returns (string memory);
1178 
1179     /**
1180      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1181      */
1182     function tokenURI(uint256 tokenId) external view returns (string memory);
1183 }
1184 
1185 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
1186 
1187 
1188 
1189 pragma solidity >=0.6.2 <0.8.0;
1190 
1191 
1192 /**
1193  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1194  * @dev See https://eips.ethereum.org/EIPS/eip-721
1195  */
1196 interface IERC721Enumerable is IERC721 {
1197 
1198     /**
1199      * @dev Returns the total amount of tokens stored by the contract.
1200      */
1201     function totalSupply() external view returns (uint256);
1202 
1203     /**
1204      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1205      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1206      */
1207     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1208 
1209     /**
1210      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1211      * Use along with {totalSupply} to enumerate all tokens.
1212      */
1213     function tokenByIndex(uint256 index) external view returns (uint256);
1214 }
1215 
1216 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1217 
1218 
1219 
1220 pragma solidity >=0.6.0 <0.8.0;
1221 
1222 /**
1223  * @title ERC721 token receiver interface
1224  * @dev Interface for any contract that wants to support safeTransfers
1225  * from ERC721 asset contracts.
1226  */
1227 interface IERC721Receiver {
1228     /**
1229      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1230      * by `operator` from `from`, this function is called.
1231      *
1232      * It must return its Solidity selector to confirm the token transfer.
1233      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1234      *
1235      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1236      */
1237     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1238 }
1239 
1240 // File: @openzeppelin/contracts/introspection/ERC165.sol
1241 
1242 
1243 
1244 pragma solidity >=0.6.0 <0.8.0;
1245 
1246 
1247 /**
1248  * @dev Implementation of the {IERC165} interface.
1249  *
1250  * Contracts may inherit from this and call {_registerInterface} to declare
1251  * their support of an interface.
1252  */
1253 abstract contract ERC165 is IERC165 {
1254     /*
1255      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1256      */
1257     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1258 
1259     /**
1260      * @dev Mapping of interface ids to whether or not it's supported.
1261      */
1262     mapping(bytes4 => bool) private _supportedInterfaces;
1263 
1264     constructor () internal {
1265         // Derived contracts need only register support for their own interfaces,
1266         // we register support for ERC165 itself here
1267         _registerInterface(_INTERFACE_ID_ERC165);
1268     }
1269 
1270     /**
1271      * @dev See {IERC165-supportsInterface}.
1272      *
1273      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1274      */
1275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1276         return _supportedInterfaces[interfaceId];
1277     }
1278 
1279     /**
1280      * @dev Registers the contract as an implementer of the interface defined by
1281      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1282      * registering its interface id is not required.
1283      *
1284      * See {IERC165-supportsInterface}.
1285      *
1286      * Requirements:
1287      *
1288      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1289      */
1290     function _registerInterface(bytes4 interfaceId) internal virtual {
1291         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1292         _supportedInterfaces[interfaceId] = true;
1293     }
1294 }
1295 
1296 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1297 
1298 
1299 
1300 pragma solidity >=0.6.0 <0.8.0;
1301 
1302 /**
1303  * @dev Library for managing an enumerable variant of Solidity's
1304  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1305  * type.
1306  *
1307  * Maps have the following properties:
1308  *
1309  * - Entries are added, removed, and checked for existence in constant time
1310  * (O(1)).
1311  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1312  *
1313  * ```
1314  * contract Example {
1315  *     // Add the library methods
1316  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1317  *
1318  *     // Declare a set state variable
1319  *     EnumerableMap.UintToAddressMap private myMap;
1320  * }
1321  * ```
1322  *
1323  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1324  * supported.
1325  */
1326 library EnumerableMap {
1327     // To implement this library for multiple types with as little code
1328     // repetition as possible, we write it in terms of a generic Map type with
1329     // bytes32 keys and values.
1330     // The Map implementation uses private functions, and user-facing
1331     // implementations (such as Uint256ToAddressMap) are just wrappers around
1332     // the underlying Map.
1333     // This means that we can only create new EnumerableMaps for types that fit
1334     // in bytes32.
1335 
1336     struct MapEntry {
1337         bytes32 _key;
1338         bytes32 _value;
1339     }
1340 
1341     struct Map {
1342         // Storage of map keys and values
1343         MapEntry[] _entries;
1344 
1345         // Position of the entry defined by a key in the `entries` array, plus 1
1346         // because index 0 means a key is not in the map.
1347         mapping (bytes32 => uint256) _indexes;
1348     }
1349 
1350     /**
1351      * @dev Adds a key-value pair to a map, or updates the value for an existing
1352      * key. O(1).
1353      *
1354      * Returns true if the key was added to the map, that is if it was not
1355      * already present.
1356      */
1357     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1358         // We read and store the key's index to prevent multiple reads from the same storage slot
1359         uint256 keyIndex = map._indexes[key];
1360 
1361         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1362             map._entries.push(MapEntry({ _key: key, _value: value }));
1363             // The entry is stored at length-1, but we add 1 to all indexes
1364             // and use 0 as a sentinel value
1365             map._indexes[key] = map._entries.length;
1366             return true;
1367         } else {
1368             map._entries[keyIndex - 1]._value = value;
1369             return false;
1370         }
1371     }
1372 
1373     /**
1374      * @dev Removes a key-value pair from a map. O(1).
1375      *
1376      * Returns true if the key was removed from the map, that is if it was present.
1377      */
1378     function _remove(Map storage map, bytes32 key) private returns (bool) {
1379         // We read and store the key's index to prevent multiple reads from the same storage slot
1380         uint256 keyIndex = map._indexes[key];
1381 
1382         if (keyIndex != 0) { // Equivalent to contains(map, key)
1383             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1384             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1385             // This modifies the order of the array, as noted in {at}.
1386 
1387             uint256 toDeleteIndex = keyIndex - 1;
1388             uint256 lastIndex = map._entries.length - 1;
1389 
1390             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1391             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1392 
1393             MapEntry storage lastEntry = map._entries[lastIndex];
1394 
1395             // Move the last entry to the index where the entry to delete is
1396             map._entries[toDeleteIndex] = lastEntry;
1397             // Update the index for the moved entry
1398             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1399 
1400             // Delete the slot where the moved entry was stored
1401             map._entries.pop();
1402 
1403             // Delete the index for the deleted slot
1404             delete map._indexes[key];
1405 
1406             return true;
1407         } else {
1408             return false;
1409         }
1410     }
1411 
1412     /**
1413      * @dev Returns true if the key is in the map. O(1).
1414      */
1415     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1416         return map._indexes[key] != 0;
1417     }
1418 
1419     /**
1420      * @dev Returns the number of key-value pairs in the map. O(1).
1421      */
1422     function _length(Map storage map) private view returns (uint256) {
1423         return map._entries.length;
1424     }
1425 
1426    /**
1427     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1428     *
1429     * Note that there are no guarantees on the ordering of entries inside the
1430     * array, and it may change when more entries are added or removed.
1431     *
1432     * Requirements:
1433     *
1434     * - `index` must be strictly less than {length}.
1435     */
1436     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1437         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1438 
1439         MapEntry storage entry = map._entries[index];
1440         return (entry._key, entry._value);
1441     }
1442 
1443     /**
1444      * @dev Tries to returns the value associated with `key`.  O(1).
1445      * Does not revert if `key` is not in the map.
1446      */
1447     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1448         uint256 keyIndex = map._indexes[key];
1449         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1450         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1451     }
1452 
1453     /**
1454      * @dev Returns the value associated with `key`.  O(1).
1455      *
1456      * Requirements:
1457      *
1458      * - `key` must be in the map.
1459      */
1460     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1461         uint256 keyIndex = map._indexes[key];
1462         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1463         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1464     }
1465 
1466     /**
1467      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1468      *
1469      * CAUTION: This function is deprecated because it requires allocating memory for the error
1470      * message unnecessarily. For custom revert reasons use {_tryGet}.
1471      */
1472     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1473         uint256 keyIndex = map._indexes[key];
1474         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1475         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1476     }
1477 
1478     // UintToAddressMap
1479 
1480     struct UintToAddressMap {
1481         Map _inner;
1482     }
1483 
1484     /**
1485      * @dev Adds a key-value pair to a map, or updates the value for an existing
1486      * key. O(1).
1487      *
1488      * Returns true if the key was added to the map, that is if it was not
1489      * already present.
1490      */
1491     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1492         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1493     }
1494 
1495     /**
1496      * @dev Removes a value from a set. O(1).
1497      *
1498      * Returns true if the key was removed from the map, that is if it was present.
1499      */
1500     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1501         return _remove(map._inner, bytes32(key));
1502     }
1503 
1504     /**
1505      * @dev Returns true if the key is in the map. O(1).
1506      */
1507     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1508         return _contains(map._inner, bytes32(key));
1509     }
1510 
1511     /**
1512      * @dev Returns the number of elements in the map. O(1).
1513      */
1514     function length(UintToAddressMap storage map) internal view returns (uint256) {
1515         return _length(map._inner);
1516     }
1517 
1518    /**
1519     * @dev Returns the element stored at position `index` in the set. O(1).
1520     * Note that there are no guarantees on the ordering of values inside the
1521     * array, and it may change when more values are added or removed.
1522     *
1523     * Requirements:
1524     *
1525     * - `index` must be strictly less than {length}.
1526     */
1527     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1528         (bytes32 key, bytes32 value) = _at(map._inner, index);
1529         return (uint256(key), address(uint160(uint256(value))));
1530     }
1531 
1532     /**
1533      * @dev Tries to returns the value associated with `key`.  O(1).
1534      * Does not revert if `key` is not in the map.
1535      *
1536      * _Available since v3.4._
1537      */
1538     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1539         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1540         return (success, address(uint160(uint256(value))));
1541     }
1542 
1543     /**
1544      * @dev Returns the value associated with `key`.  O(1).
1545      *
1546      * Requirements:
1547      *
1548      * - `key` must be in the map.
1549      */
1550     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1551         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1552     }
1553 
1554     /**
1555      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1556      *
1557      * CAUTION: This function is deprecated because it requires allocating memory for the error
1558      * message unnecessarily. For custom revert reasons use {tryGet}.
1559      */
1560     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1561         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1562     }
1563 }
1564 
1565 // File: @openzeppelin/contracts/utils/Strings.sol
1566 
1567 
1568 
1569 pragma solidity >=0.6.0 <0.8.0;
1570 
1571 /**
1572  * @dev String operations.
1573  */
1574 library Strings {
1575     /**
1576      * @dev Converts a `uint256` to its ASCII `string` representation.
1577      */
1578     function toString(uint256 value) internal pure returns (string memory) {
1579         // Inspired by OraclizeAPI's implementation - MIT licence
1580         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1581 
1582         if (value == 0) {
1583             return "0";
1584         }
1585         uint256 temp = value;
1586         uint256 digits;
1587         while (temp != 0) {
1588             digits++;
1589             temp /= 10;
1590         }
1591         bytes memory buffer = new bytes(digits);
1592         uint256 index = digits - 1;
1593         temp = value;
1594         while (temp != 0) {
1595             buffer[index--] = bytes1(uint8(48 + temp % 10));
1596             temp /= 10;
1597         }
1598         return string(buffer);
1599     }
1600 }
1601 
1602 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1603 
1604 
1605 
1606 pragma solidity >=0.6.0 <0.8.0;
1607 
1608 
1609 
1610 
1611 
1612 
1613 
1614 
1615 
1616 
1617 
1618 
1619 /**
1620  * @title ERC721 Non-Fungible Token Standard basic implementation
1621  * @dev see https://eips.ethereum.org/EIPS/eip-721
1622  */
1623 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1624     using SafeMath for uint256;
1625     using Address for address;
1626     using EnumerableSet for EnumerableSet.UintSet;
1627     using EnumerableMap for EnumerableMap.UintToAddressMap;
1628     using Strings for uint256;
1629 
1630     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1631     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1632     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1633 
1634     // Mapping from holder address to their (enumerable) set of owned tokens
1635     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1636 
1637     // Enumerable mapping from token ids to their owners
1638     EnumerableMap.UintToAddressMap private _tokenOwners;
1639 
1640     // Mapping from token ID to approved address
1641     mapping (uint256 => address) private _tokenApprovals;
1642 
1643     // Mapping from owner to operator approvals
1644     mapping (address => mapping (address => bool)) private _operatorApprovals;
1645 
1646     // Token name
1647     string private _name;
1648 
1649     // Token symbol
1650     string private _symbol;
1651 
1652     // Optional mapping for token URIs
1653     mapping (uint256 => string) private _tokenURIs;
1654 
1655     // Base URI
1656     string private _baseURI;
1657 
1658     /*
1659      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1660      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1661      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1662      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1663      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1664      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1665      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1666      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1667      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1668      *
1669      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1670      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1671      */
1672     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1673 
1674     /*
1675      *     bytes4(keccak256('name()')) == 0x06fdde03
1676      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1677      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1678      *
1679      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1680      */
1681     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1682 
1683     /*
1684      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1685      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1686      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1687      *
1688      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1689      */
1690     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1691 
1692     /**
1693      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1694      */
1695     constructor (string memory name_, string memory symbol_) public {
1696         _name = name_;
1697         _symbol = symbol_;
1698 
1699         // register the supported interfaces to conform to ERC721 via ERC165
1700         _registerInterface(_INTERFACE_ID_ERC721);
1701         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1702         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1703     }
1704 
1705     /**
1706      * @dev See {IERC721-balanceOf}.
1707      */
1708     function balanceOf(address owner) public view virtual override returns (uint256) {
1709         require(owner != address(0), "ERC721: balance query for the zero address");
1710         return _holderTokens[owner].length();
1711     }
1712 
1713     /**
1714      * @dev See {IERC721-ownerOf}.
1715      */
1716     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1717         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1718     }
1719 
1720     /**
1721      * @dev See {IERC721Metadata-name}.
1722      */
1723     function name() public view virtual override returns (string memory) {
1724         return _name;
1725     }
1726 
1727     /**
1728      * @dev See {IERC721Metadata-symbol}.
1729      */
1730     function symbol() public view virtual override returns (string memory) {
1731         return _symbol;
1732     }
1733 
1734     /**
1735      * @dev See {IERC721Metadata-tokenURI}.
1736      */
1737     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1738         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1739 
1740         string memory _tokenURI = _tokenURIs[tokenId];
1741         string memory base = baseURI();
1742 
1743         // If there is no base URI, return the token URI.
1744         if (bytes(base).length == 0) {
1745             return _tokenURI;
1746         }
1747         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1748         if (bytes(_tokenURI).length > 0) {
1749             return string(abi.encodePacked(base, _tokenURI));
1750         }
1751         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1752         return string(abi.encodePacked(base, tokenId.toString()));
1753     }
1754 
1755     /**
1756     * @dev Returns the base URI set via {_setBaseURI}. This will be
1757     * automatically added as a prefix in {tokenURI} to each token's URI, or
1758     * to the token ID if no specific URI is set for that token ID.
1759     */
1760     function baseURI() public view virtual returns (string memory) {
1761         return _baseURI;
1762     }
1763 
1764     /**
1765      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1766      */
1767     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1768         return _holderTokens[owner].at(index);
1769     }
1770 
1771     /**
1772      * @dev See {IERC721Enumerable-totalSupply}.
1773      */
1774     function totalSupply() public view virtual override returns (uint256) {
1775         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1776         return _tokenOwners.length();
1777     }
1778 
1779     /**
1780      * @dev See {IERC721Enumerable-tokenByIndex}.
1781      */
1782     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1783         (uint256 tokenId, ) = _tokenOwners.at(index);
1784         return tokenId;
1785     }
1786 
1787     /**
1788      * @dev See {IERC721-approve}.
1789      */
1790     function approve(address to, uint256 tokenId) public virtual override {
1791         address owner = ERC721.ownerOf(tokenId);
1792         require(to != owner, "ERC721: approval to current owner");
1793 
1794         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1795             "ERC721: approve caller is not owner nor approved for all"
1796         );
1797 
1798         _approve(to, tokenId);
1799     }
1800 
1801     /**
1802      * @dev See {IERC721-getApproved}.
1803      */
1804     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1805         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1806 
1807         return _tokenApprovals[tokenId];
1808     }
1809 
1810     /**
1811      * @dev See {IERC721-setApprovalForAll}.
1812      */
1813     function setApprovalForAll(address operator, bool approved) public virtual override {
1814         require(operator != _msgSender(), "ERC721: approve to caller");
1815 
1816         _operatorApprovals[_msgSender()][operator] = approved;
1817         emit ApprovalForAll(_msgSender(), operator, approved);
1818     }
1819 
1820     /**
1821      * @dev See {IERC721-isApprovedForAll}.
1822      */
1823     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1824         return _operatorApprovals[owner][operator];
1825     }
1826 
1827     /**
1828      * @dev See {IERC721-transferFrom}.
1829      */
1830     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1831         //solhint-disable-next-line max-line-length
1832         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1833 
1834         _transfer(from, to, tokenId);
1835     }
1836 
1837     /**
1838      * @dev See {IERC721-safeTransferFrom}.
1839      */
1840     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1841         safeTransferFrom(from, to, tokenId, "");
1842     }
1843 
1844     /**
1845      * @dev See {IERC721-safeTransferFrom}.
1846      */
1847     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1848         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1849         _safeTransfer(from, to, tokenId, _data);
1850     }
1851 
1852     /**
1853      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1854      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1855      *
1856      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1857      *
1858      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1859      * implement alternative mechanisms to perform token transfer, such as signature-based.
1860      *
1861      * Requirements:
1862      *
1863      * - `from` cannot be the zero address.
1864      * - `to` cannot be the zero address.
1865      * - `tokenId` token must exist and be owned by `from`.
1866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1867      *
1868      * Emits a {Transfer} event.
1869      */
1870     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1871         _transfer(from, to, tokenId);
1872         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1873     }
1874 
1875     /**
1876      * @dev Returns whether `tokenId` exists.
1877      *
1878      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1879      *
1880      * Tokens start existing when they are minted (`_mint`),
1881      * and stop existing when they are burned (`_burn`).
1882      */
1883     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1884         return _tokenOwners.contains(tokenId);
1885     }
1886 
1887     /**
1888      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1889      *
1890      * Requirements:
1891      *
1892      * - `tokenId` must exist.
1893      */
1894     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1895         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1896         address owner = ERC721.ownerOf(tokenId);
1897         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1898     }
1899 
1900     /**
1901      * @dev Safely mints `tokenId` and transfers it to `to`.
1902      *
1903      * Requirements:
1904      d*
1905      * - `tokenId` must not exist.
1906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1907      *
1908      * Emits a {Transfer} event.
1909      */
1910     function _safeMint(address to, uint256 tokenId) internal virtual {
1911         _safeMint(to, tokenId, "");
1912     }
1913 
1914     /**
1915      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1916      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1917      */
1918     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1919         _mint(to, tokenId);
1920         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1921     }
1922 
1923     /**
1924      * @dev Mints `tokenId` and transfers it to `to`.
1925      *
1926      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1927      *
1928      * Requirements:
1929      *
1930      * - `tokenId` must not exist.
1931      * - `to` cannot be the zero address.
1932      *
1933      * Emits a {Transfer} event.
1934      */
1935     function _mint(address to, uint256 tokenId) internal virtual {
1936         require(to != address(0), "ERC721: mint to the zero address");
1937         require(!_exists(tokenId), "ERC721: token already minted");
1938 
1939         _beforeTokenTransfer(address(0), to, tokenId);
1940 
1941         _holderTokens[to].add(tokenId);
1942 
1943         _tokenOwners.set(tokenId, to);
1944 
1945         emit Transfer(address(0), to, tokenId);
1946     }
1947 
1948     /**
1949      * @dev Destroys `tokenId`.
1950      * The approval is cleared when the token is burned.
1951      *
1952      * Requirements:
1953      *
1954      * - `tokenId` must exist.
1955      *
1956      * Emits a {Transfer} event.
1957      */
1958     function _burn(uint256 tokenId) internal virtual {
1959         address owner = ERC721.ownerOf(tokenId); // internal owner
1960 
1961         _beforeTokenTransfer(owner, address(0), tokenId);
1962 
1963         // Clear approvals
1964         _approve(address(0), tokenId);
1965 
1966         // Clear metadata (if any)
1967         if (bytes(_tokenURIs[tokenId]).length != 0) {
1968             delete _tokenURIs[tokenId];
1969         }
1970 
1971         _holderTokens[owner].remove(tokenId);
1972 
1973         _tokenOwners.remove(tokenId);
1974 
1975         emit Transfer(owner, address(0), tokenId);
1976     }
1977 
1978     /**
1979      * @dev Transfers `tokenId` from `from` to `to`.
1980      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1981      *
1982      * Requirements:
1983      *
1984      * - `to` cannot be the zero address.
1985      * - `tokenId` token must be owned by `from`.
1986      *
1987      * Emits a {Transfer} event.
1988      */
1989     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1990         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1991         require(to != address(0), "ERC721: transfer to the zero address");
1992 
1993         _beforeTokenTransfer(from, to, tokenId);
1994 
1995         // Clear approvals from the previous owner
1996         _approve(address(0), tokenId);
1997 
1998         _holderTokens[from].remove(tokenId);
1999         _holderTokens[to].add(tokenId);
2000 
2001         _tokenOwners.set(tokenId, to);
2002 
2003         emit Transfer(from, to, tokenId);
2004     }
2005 
2006     /**
2007      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2008      *
2009      * Requirements:
2010      *
2011      * - `tokenId` must exist.
2012      */
2013     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2014         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2015         _tokenURIs[tokenId] = _tokenURI;
2016     }
2017 
2018     /**
2019      * @dev Internal function to set the base URI for all token IDs. It is
2020      * automatically added as a prefix to the value returned in {tokenURI},
2021      * or to the token ID if {tokenURI} is empty.
2022      */
2023     function _setBaseURI(string memory baseURI_) internal virtual {
2024         _baseURI = baseURI_;
2025     }
2026 
2027     /**
2028      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2029      * The call is not executed if the target address is not a contract.
2030      *
2031      * @param from address representing the previous owner of the given token ID
2032      * @param to target address that will receive the tokens
2033      * @param tokenId uint256 ID of the token to be transferred
2034      * @param _data bytes optional data to send along with the call
2035      * @return bool whether the call correctly returned the expected magic value
2036      */
2037     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
2038         private returns (bool)
2039     {
2040         if (!to.isContract()) {
2041             return true;
2042         }
2043         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2044             IERC721Receiver(to).onERC721Received.selector,
2045             _msgSender(),
2046             from,
2047             tokenId,
2048             _data
2049         ), "ERC721: transfer to non ERC721Receiver implementer");
2050         bytes4 retval = abi.decode(returndata, (bytes4));
2051         return (retval == _ERC721_RECEIVED);
2052     }
2053 
2054     function _approve(address to, uint256 tokenId) private {
2055         _tokenApprovals[tokenId] = to;
2056         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2057     }
2058 
2059     /**
2060      * @dev Hook that is called before any token transfer. This includes minting
2061      * and burning.
2062      *
2063      * Calling conditions:
2064      *
2065      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2066      * transferred to `to`.
2067      * - When `from` is zero, `tokenId` will be minted for `to`.
2068      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2069      * - `from` cannot be the zero address.
2070      * - `to` cannot be the zero address.
2071      *
2072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2073      */
2074     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2075 }
2076 
2077 // File: contracts/Deafbeef721.sol
2078 
2079 
2080 pragma solidity >=0.6.0 <0.8.0;
2081 
2082 
2083 /**
2084  * @dev {ERC721} token, including:
2085  *
2086  *  - ability for holders to burn (destroy) their tokens
2087  *  - a minter role that allows for token minting (creation)
2088  *  - token ID and URI autogeneration
2089  *
2090  * This contract uses {AccessControl} to lock permissioned functions using the
2091  * different roles - head to its documentation for details.
2092  *
2093  * The account that deploys the contract will be granted the minter and pauser
2094  * roles, as well as the default admin role, which will let it grant both minter
2095  * and pauser roles to other accounts.
2096  */
2097  
2098 contract Deafbeef721 is Context, AccessControl, ERC721 {
2099     using Counters for Counters.Counter;
2100     using SafeMath for uint256;
2101     
2102     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2103 
2104     uint256 public numSeries;
2105     bool allowInternalPurchases = true; //optional internal purchasing code. Can disable to use only an external purchasing contract
2106     
2107     struct SeriesStruct {
2108       bytes32[10] codeLocations; //transaction hash of code location. 10 slots available
2109       uint32 numCodeLocations; //maximum codes used in codes array
2110       uint32[8] p; //parameters
2111       uint256 numMint;  //number minted to date 
2112       uint256 maxMint; //maximum number of model outputs
2113       uint256 curPricePerToken; //curent token price
2114       
2115       //TODO: additional parameters for automatically changing pricing curve
2116       bool locked; //can't modify maxMint or codeLocation
2117       bool paused; //paused for purchases
2118     }
2119 
2120     struct TokenParamsStruct {
2121       bytes32 seed; //hash seed for random generation
2122       //general purpose parameters for each token.
2123       // could be parameter to the generative code
2124       uint32[8] p; //parameters
2125     }
2126     
2127     mapping(uint256 => TokenParamsStruct) tokenParams; //maps each token to set of parameters
2128     mapping(uint256 => SeriesStruct) series; //series
2129     mapping(uint256 => uint256) token2series; //maps each token to a series
2130     
2131     modifier requireAdmin() {
2132       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Requires admin privileges");
2133       _;
2134     }
2135 
2136     modifier sidInRange(uint256 sid) {
2137       require(sid < numSeries,"Series id does not exist");
2138       _;
2139     }
2140 
2141     modifier requireUnlocked(uint256 sid) {
2142       require(!series[sid].locked);
2143       _;
2144     }
2145 
2146     function owner() public view virtual returns (address) {
2147       return getRoleMember(DEFAULT_ADMIN_ROLE,0);
2148     }
2149 	
2150     function setMaxMint(uint256 sid, uint256 m) public requireAdmin sidInRange(sid) requireUnlocked(sid) {
2151       series[sid].maxMint = m;
2152     }
2153 
2154     function setNumCodeLocations(uint256 sid, uint32 n) public requireAdmin sidInRange(sid) requireUnlocked(sid) {
2155       //between 1 and 10 code locations.
2156       require(n <= 10,"Maximum 10 code locations");
2157       require(n > 0,"Minimum 1 code locations");
2158       series[sid].numCodeLocations = n;
2159     }
2160     
2161     function setCodeLocation(uint256 sid, uint256 i, bytes32 txhash) public requireAdmin sidInRange(sid) requireUnlocked(sid) {
2162       require(i < series[sid].numCodeLocations,"Index larger than numCodeLocations");
2163       //transaction hash of where code is stored. There are 5 slots indexed by i
2164       //The code is UTF-8 encoded and stored in the 'input data' field of this transaction
2165       series[sid].codeLocations[i] = txhash;
2166     }
2167 
2168     function setSeriesParam(uint256 sid, uint256 i, uint32 v) public requireAdmin sidInRange(sid) requireUnlocked(sid) {
2169       require(i<8,"Parameter index must be less than 8");
2170       //transaction hash of where code is stored.
2171       series[sid].p[i] = v;
2172     }
2173 
2174     //Require MINTER role to allow token param updates.
2175     // This will allow a separate contract with appropriate permissions
2176     // to interface with the user, about what is allowed depending on the tokens
2177     // NOTE: seed can never be updated.
2178     // also, don't allow updates to p[7], which is used to track number of transfers    
2179     function setTokenParam(uint256 tokenID, uint256 i, uint32 v) public {
2180       require(hasRole(MINTER_ROLE, _msgSender()), "Deafbeef721: must have minter role to update tokenparams");
2181       require(tokenID < _tokenIdTracker.current(),"TokenId out of range");
2182 
2183       require(i<7,"Parameter index must be less than 7");
2184       tokenParams[tokenID].p[i] = v;
2185     }
2186     
2187     function getTokenParams(uint256 i) public view returns (bytes32 seed, bytes32 codeLocation0, uint256 seriesID, uint32 p0, uint32 p1, uint32 p2, uint32 p3, uint32 p4, uint32 p5, uint32 p6, uint32 p7) {
2188       require(i < _tokenIdTracker.current(),"TokenId out of range");
2189       uint256 sid = token2series[i];
2190       codeLocation0 = series[sid].codeLocations[0];
2191       seriesID = sid;
2192       seed = tokenParams[i].seed;
2193       p0 = tokenParams[i].p[0];      
2194       p1 = tokenParams[i].p[1];
2195       p2 = tokenParams[i].p[2];
2196       p3 = tokenParams[i].p[3];
2197       p4 = tokenParams[i].p[4];
2198       p5 = tokenParams[i].p[5];
2199       p6 = tokenParams[i].p[6];
2200       p7 = tokenParams[i].p[7];                                     
2201     }
2202 
2203     function getSeriesParams(uint256 i) public view returns(uint32 p0, uint32 p1,uint32 p2, uint32 p3, uint32 p4, uint32 p5, uint32 p6, uint32 p7) {
2204       require(i < numSeries,"Series ID out of range");
2205       p0 = series[i].p[0];
2206       p1 = series[i].p[1];
2207       p2 = series[i].p[2];
2208       p3 = series[i].p[3];
2209       p4 = series[i].p[4];
2210       p5 = series[i].p[5];
2211       p6 = series[i].p[6];
2212       p7 = series[i].p[7];
2213     }
2214     
2215     function getSeries(uint256 i) public view returns (bytes32 codeLocation0, uint256 numCodeLocations, uint256 numMint, uint256 maxMint, uint256 curPricePerToken, bool paused, bool locked) {
2216       require(i < numSeries,"Series ID out of range");
2217 
2218       codeLocation0 = series[i].codeLocations[0];
2219       numCodeLocations = series[i].numCodeLocations;
2220       numMint = series[i].numMint;
2221       maxMint = series[i].maxMint;
2222       
2223       locked = series[i].locked;
2224       paused = series[i].paused;
2225       
2226       curPricePerToken = series[i].curPricePerToken;
2227     }    
2228     
2229     function getCodeLocation(uint256 sid, uint256 i) public view sidInRange(sid) returns(bytes32 txhash) {
2230       require(i < 10,"codeLocation index out of range");
2231       //transaction hash of where code is stored. 10 slots indexed by i
2232       //The code is UTF-8 encoded and stored in the 'input data' field of this transaction
2233       return series[sid].codeLocations[i];
2234     }
2235 
2236     function addSeries() public requireAdmin returns(uint256 sid) {
2237       series[numSeries].maxMint = 50; //maximum number of model outputs
2238       series[numSeries].curPricePerToken = .05e18; //curent token price
2239       series[numSeries].numCodeLocations = 1;
2240       series[numSeries].paused = true;
2241       numSeries = numSeries.add(1);
2242       return numSeries;
2243     }
2244 
2245     //allow MINTER role to change price. This is so an external minting contract
2246     // perform auto price adjustment
2247     function setPrice(uint256 sid, uint256 p) public sidInRange(sid) {
2248       require(hasRole(MINTER_ROLE, _msgSender()), "Deafbeef721: must have minter role to change price");
2249       series[sid].curPricePerToken = p;
2250     }
2251 
2252     function setAllowInternalPurchases(bool m) public requireAdmin {
2253       allowInternalPurchases = m;
2254     }
2255 
2256     //pause or unpause
2257     function setPaused(uint256 sid,bool m) public sidInRange(sid) requireAdmin {
2258       series[sid].paused = m;
2259     }
2260     
2261     function lockCodeForever(uint256 sid) public sidInRange(sid) requireAdmin {
2262       //Can no longer update max mint, code locations, or series parameters
2263       series[sid].locked = true;
2264     }
2265 
2266     function withdraw(uint256 amount) public requireAdmin {
2267       require(amount <= address(this).balance,"Insufficient funds to withdraw");	
2268       msg.sender.transfer(amount);
2269     }
2270     
2271     function setBaseURI(string memory baseURI) public requireAdmin {
2272       _setBaseURI(baseURI);      
2273     }
2274     
2275     Counters.Counter private _tokenIdTracker;
2276 
2277     /**
2278      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2279      * account that deploys the contract.
2280      *
2281      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2282      * See {ERC721-tokenURI}.
2283      */
2284     constructor(string memory name, string memory symbol, string memory baseURI) public ERC721(name, symbol) {
2285         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2286 
2287         _setupRole(MINTER_ROLE, _msgSender());
2288 
2289         _setBaseURI(baseURI);
2290 	addSeries();
2291     }
2292 
2293     /**
2294      * @dev Creates a new token for `to`. Its token ID will be automatically
2295      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2296      * URI autogenerated based on the base URI passed at construction.
2297      *
2298      * See {ERC721-_mint}.
2299      *
2300      * Requirements:
2301      *
2302      * - the caller must have the `MINTER_ROLE`.
2303      */
2304 
2305     //only addresses with MINTER_ROLE can mint
2306     //this could be an admin, or from another minter contract that controls purchasing and auto price adjustment
2307     function mint(uint256 sid, address to) public virtual returns (uint256 _tokenId) {
2308       require(hasRole(MINTER_ROLE, _msgSender()), "Deafbeef721: must have minter role to mint");
2309       return _mintInternal(sid,to);
2310     }
2311 
2312     //only accessible to contract
2313     function _mintInternal(uint256 sid, address to) internal virtual returns (uint256 _tokenId) {
2314       require(series[sid].numMint.add(1) <= series[sid].maxMint,"Maximum already minted");
2315       
2316       series[sid].numMint = series[sid].numMint.add(1);
2317       _mint(to, _tokenIdTracker.current());
2318       uint256 tokenID = _tokenIdTracker.current();
2319 
2320       bytes32 hash = keccak256(abi.encodePacked(tokenID,block.timestamp,block.difficulty,msg.sender));
2321 
2322       //store random hash
2323       tokenParams[tokenID].seed = hash;
2324       token2series[tokenID] = sid;
2325 
2326       _tokenIdTracker.increment();
2327       return tokenID;
2328     }
2329 
2330 
2331     // Allow public purchases. This can be disabled with a flag 
2332     function purchase(uint256 sid) public sidInRange(sid) payable returns (uint256 _tokenId) {
2333       require(allowInternalPurchases,"Can only purchase from external minting contract");
2334       require(!series[sid].paused,"Purchasing is paused");
2335       return purchaseTo(sid, msg.sender);
2336     }
2337 
2338     function purchaseTo(uint256 sid,address _to) public sidInRange(sid) payable returns(uint256 _tokenId){
2339       require(allowInternalPurchases,"Can only purchase from external minting contract");
2340       require(!series[sid].paused,"Purchasing is paused");      
2341       require(msg.value>=series[sid].curPricePerToken, "Must send minimum value to mint!");
2342 
2343       //send change if too much was sent
2344       if (msg.value > 0) {
2345 	uint256 diff = msg.value.sub(series[sid].curPricePerToken);
2346 	if (diff > 0) {
2347 	  msg.sender.transfer(diff);
2348 	}
2349       }
2350 
2351       uint256 tokenId = _mintInternal(sid,_to);
2352 
2353       //TODO: possibly auto adjust price
2354       return tokenId;
2355     }
2356 
2357     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2358         super._beforeTokenTransfer(from, to, tokenId);
2359 	//increase a counter each time token is transferred
2360 	//this can be used as a parameter to the generative script.
2361 	
2362 	tokenParams[tokenId].p[7]++; 
2363 
2364     }
2365     
2366 }