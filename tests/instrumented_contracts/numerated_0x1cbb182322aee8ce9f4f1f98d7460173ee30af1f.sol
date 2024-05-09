1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.7.0;
3 
4 
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         uint256 c = a + b;
27         if (c < a) return (false, 0);
28         return (true, c);
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         if (b > a) return (false, 0);
38         return (true, a - b);
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
50         if (a == 0) return (true, 0);
51         uint256 c = a * b;
52         if (c / a != b) return (false, 0);
53         return (true, c);
54     }
55 
56     /**
57      * @dev Returns the division of two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         if (b == 0) return (false, 0);
63         return (true, a / b);
64     }
65 
66     /**
67      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         if (b == 0) return (false, 0);
73         return (true, a % b);
74     }
75 
76     /**
77      * @dev Returns the addition of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      *
84      * - Addition cannot overflow.
85      */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      *
100      * - Subtraction cannot overflow.
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b <= a, "SafeMath: subtraction overflow");
104         return a - b;
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `*` operator.
112      *
113      * Requirements:
114      *
115      * - Multiplication cannot overflow.
116      */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         if (a == 0) return 0;
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121         return c;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator. Note: this function uses a
129      * `revert` opcode (which leaves remaining gas untouched) while Solidity
130      * uses an invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b > 0, "SafeMath: division by zero");
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         require(b > 0, "SafeMath: modulo by zero");
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         return a - b;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * CAUTION: This function is deprecated because it requires allocating memory for the error
181      * message unnecessarily. For custom revert reasons use {tryDiv}.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         return a / b;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting with custom message when dividing by zero.
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {tryMod}.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         return a % b;
214     }
215 }
216 
217 
218 /**
219  * @dev Collection of functions related to the address type
220  */
221 library Address {
222     /**
223      * @dev Returns true if `account` is a contract.
224      *
225      * [IMPORTANT]
226      * ====
227      * It is unsafe to assume that an address for which this function returns
228      * false is an externally-owned account (EOA) and not a contract.
229      *
230      * Among others, `isContract` will return false for the following
231      * types of addresses:
232      *
233      *  - an externally-owned account
234      *  - a contract in construction
235      *  - an address where a contract will be created
236      *  - an address where a contract lived, but was destroyed
237      * ====
238      */
239     function isContract(address account) internal view returns (bool) {
240         // This method relies on extcodesize, which returns 0 for contracts in
241         // construction, since the code is only stored at the end of the
242         // constructor execution.
243 
244         uint256 size;
245         // solhint-disable-next-line no-inline-assembly
246         assembly { size := extcodesize(account) }
247         return size > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
270         (bool success, ) = recipient.call{ value: amount }("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain`call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
293       return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, 0, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but also transferring `value` wei to `target`.
309      *
310      * Requirements:
311      *
312      * - the calling contract must have an ETH balance of at least `value`.
313      * - the called Solidity function must be `payable`.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
328         require(address(this).balance >= value, "Address: insufficient balance for call");
329         require(isContract(target), "Address: call to non-contract");
330 
331         // solhint-disable-next-line avoid-low-level-calls
332         (bool success, bytes memory returndata) = target.call{ value: value }(data);
333         return _verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         // solhint-disable-next-line avoid-low-level-calls
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return _verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.delegatecall(data);
381         return _verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 
405 library PolymorphGeneGenerator {
406 
407     struct Gene {
408 		uint256 lastRandom;
409     }
410 
411     function random(Gene storage g) internal returns (uint256) {
412 		g.lastRandom = uint256(keccak256(abi.encode(keccak256(abi.encodePacked(msg.sender, tx.origin, gasleft(), g.lastRandom, block.timestamp, block.number, blockhash(block.number), blockhash(block.number-100))))));
413 		return g.lastRandom;
414     }
415 
416 }
417 
418 
419 
420 /**
421  * @dev Contract module that helps prevent reentrant calls to a function.
422  *
423  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
424  * available, which can be applied to functions to make sure there are no nested
425  * (reentrant) calls to them.
426  *
427  * Note that because there is a single `nonReentrant` guard, functions marked as
428  * `nonReentrant` may not call one another. This can be worked around by making
429  * those functions `private`, and then adding `external` `nonReentrant` entry
430  * points to them.
431  *
432  * TIP: If you would like to learn more about reentrancy and alternative ways
433  * to protect against it, check out our blog post
434  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
435  */
436 abstract contract ReentrancyGuard {
437     // Booleans are more expensive than uint256 or any type that takes up a full
438     // word because each write operation emits an extra SLOAD to first read the
439     // slot's contents, replace the bits taken up by the boolean, and then write
440     // back. This is the compiler's defense against contract upgrades and
441     // pointer aliasing, and it cannot be disabled.
442 
443     // The values being non-zero value makes deployment a bit more expensive,
444     // but in exchange the refund on every call to nonReentrant will be lower in
445     // amount. Since refunds are capped to a percentage of the total
446     // transaction's gas, it is best to keep them low in cases like this one, to
447     // increase the likelihood of the full refund coming into effect.
448     uint256 private constant _NOT_ENTERED = 1;
449     uint256 private constant _ENTERED = 2;
450 
451     uint256 private _status;
452 
453     constructor () internal {
454         _status = _NOT_ENTERED;
455     }
456 
457     /**
458      * @dev Prevents a contract from calling itself, directly or indirectly.
459      * Calling a `nonReentrant` function from another `nonReentrant`
460      * function is not supported. It is possible to prevent this from happening
461      * by making the `nonReentrant` function external, and make it call a
462      * `private` function that does the actual work.
463      */
464     modifier nonReentrant() {
465         // On the first call to nonReentrant, _notEntered will be true
466         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
467 
468         // Any calls to nonReentrant after this point will fail
469         _status = _ENTERED;
470 
471         _;
472 
473         // By storing the original value once again, a refund is triggered (see
474         // https://eips.ethereum.org/EIPS/eip-2200)
475         _status = _NOT_ENTERED;
476     }
477 }
478 
479 
480 /**
481  * @title Counters
482  * @author Matt Condon (@shrugs)
483  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
484  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
485  *
486  * Include with `using Counters for Counters.Counter;`
487  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
488  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
489  * directly accessed.
490  */
491 library Counters {
492     using SafeMath for uint256;
493 
494     struct Counter {
495         // This variable should never be directly accessed by users of the library: interactions must be restricted to
496         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
497         // this feature: see https://github.com/ethereum/solidity/issues/4637
498         uint256 _value; // default: 0
499     }
500 
501     function current(Counter storage counter) internal view returns (uint256) {
502         return counter._value;
503     }
504 
505     function increment(Counter storage counter) internal {
506         // The {SafeMath} overflow check can be skipped here, see the comment at the top
507         counter._value += 1;
508     }
509 
510     function decrement(Counter storage counter) internal {
511         counter._value = counter._value.sub(1);
512     }
513 }
514 
515 
516 
517 /**
518  * @dev Library for managing
519  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
520  * types.
521  *
522  * Sets have the following properties:
523  *
524  * - Elements are added, removed, and checked for existence in constant time
525  * (O(1)).
526  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
527  *
528  * ```
529  * contract Example {
530  *     // Add the library methods
531  *     using EnumerableSet for EnumerableSet.AddressSet;
532  *
533  *     // Declare a set state variable
534  *     EnumerableSet.AddressSet private mySet;
535  * }
536  * ```
537  *
538  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
539  * and `uint256` (`UintSet`) are supported.
540  */
541 library EnumerableSet {
542     // To implement this library for multiple types with as little code
543     // repetition as possible, we write it in terms of a generic Set type with
544     // bytes32 values.
545     // The Set implementation uses private functions, and user-facing
546     // implementations (such as AddressSet) are just wrappers around the
547     // underlying Set.
548     // This means that we can only create new EnumerableSets for types that fit
549     // in bytes32.
550 
551     struct Set {
552         // Storage of set values
553         bytes32[] _values;
554 
555         // Position of the value in the `values` array, plus 1 because index 0
556         // means a value is not in the set.
557         mapping (bytes32 => uint256) _indexes;
558     }
559 
560     /**
561      * @dev Add a value to a set. O(1).
562      *
563      * Returns true if the value was added to the set, that is if it was not
564      * already present.
565      */
566     function _add(Set storage set, bytes32 value) private returns (bool) {
567         if (!_contains(set, value)) {
568             set._values.push(value);
569             // The value is stored at length-1, but we add 1 to all indexes
570             // and use 0 as a sentinel value
571             set._indexes[value] = set._values.length;
572             return true;
573         } else {
574             return false;
575         }
576     }
577 
578     /**
579      * @dev Removes a value from a set. O(1).
580      *
581      * Returns true if the value was removed from the set, that is if it was
582      * present.
583      */
584     function _remove(Set storage set, bytes32 value) private returns (bool) {
585         // We read and store the value's index to prevent multiple reads from the same storage slot
586         uint256 valueIndex = set._indexes[value];
587 
588         if (valueIndex != 0) { // Equivalent to contains(set, value)
589             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
590             // the array, and then remove the last element (sometimes called as 'swap and pop').
591             // This modifies the order of the array, as noted in {at}.
592 
593             uint256 toDeleteIndex = valueIndex - 1;
594             uint256 lastIndex = set._values.length - 1;
595 
596             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
597             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
598 
599             bytes32 lastvalue = set._values[lastIndex];
600 
601             // Move the last value to the index where the value to delete is
602             set._values[toDeleteIndex] = lastvalue;
603             // Update the index for the moved value
604             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
605 
606             // Delete the slot where the moved value was stored
607             set._values.pop();
608 
609             // Delete the index for the deleted slot
610             delete set._indexes[value];
611 
612             return true;
613         } else {
614             return false;
615         }
616     }
617 
618     /**
619      * @dev Returns true if the value is in the set. O(1).
620      */
621     function _contains(Set storage set, bytes32 value) private view returns (bool) {
622         return set._indexes[value] != 0;
623     }
624 
625     /**
626      * @dev Returns the number of values on the set. O(1).
627      */
628     function _length(Set storage set) private view returns (uint256) {
629         return set._values.length;
630     }
631 
632    /**
633     * @dev Returns the value stored at position `index` in the set. O(1).
634     *
635     * Note that there are no guarantees on the ordering of values inside the
636     * array, and it may change when more values are added or removed.
637     *
638     * Requirements:
639     *
640     * - `index` must be strictly less than {length}.
641     */
642     function _at(Set storage set, uint256 index) private view returns (bytes32) {
643         require(set._values.length > index, "EnumerableSet: index out of bounds");
644         return set._values[index];
645     }
646 
647     // Bytes32Set
648 
649     struct Bytes32Set {
650         Set _inner;
651     }
652 
653     /**
654      * @dev Add a value to a set. O(1).
655      *
656      * Returns true if the value was added to the set, that is if it was not
657      * already present.
658      */
659     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
660         return _add(set._inner, value);
661     }
662 
663     /**
664      * @dev Removes a value from a set. O(1).
665      *
666      * Returns true if the value was removed from the set, that is if it was
667      * present.
668      */
669     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
670         return _remove(set._inner, value);
671     }
672 
673     /**
674      * @dev Returns true if the value is in the set. O(1).
675      */
676     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
677         return _contains(set._inner, value);
678     }
679 
680     /**
681      * @dev Returns the number of values in the set. O(1).
682      */
683     function length(Bytes32Set storage set) internal view returns (uint256) {
684         return _length(set._inner);
685     }
686 
687    /**
688     * @dev Returns the value stored at position `index` in the set. O(1).
689     *
690     * Note that there are no guarantees on the ordering of values inside the
691     * array, and it may change when more values are added or removed.
692     *
693     * Requirements:
694     *
695     * - `index` must be strictly less than {length}.
696     */
697     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
698         return _at(set._inner, index);
699     }
700 
701     // AddressSet
702 
703     struct AddressSet {
704         Set _inner;
705     }
706 
707     /**
708      * @dev Add a value to a set. O(1).
709      *
710      * Returns true if the value was added to the set, that is if it was not
711      * already present.
712      */
713     function add(AddressSet storage set, address value) internal returns (bool) {
714         return _add(set._inner, bytes32(uint256(uint160(value))));
715     }
716 
717     /**
718      * @dev Removes a value from a set. O(1).
719      *
720      * Returns true if the value was removed from the set, that is if it was
721      * present.
722      */
723     function remove(AddressSet storage set, address value) internal returns (bool) {
724         return _remove(set._inner, bytes32(uint256(uint160(value))));
725     }
726 
727     /**
728      * @dev Returns true if the value is in the set. O(1).
729      */
730     function contains(AddressSet storage set, address value) internal view returns (bool) {
731         return _contains(set._inner, bytes32(uint256(uint160(value))));
732     }
733 
734     /**
735      * @dev Returns the number of values in the set. O(1).
736      */
737     function length(AddressSet storage set) internal view returns (uint256) {
738         return _length(set._inner);
739     }
740 
741    /**
742     * @dev Returns the value stored at position `index` in the set. O(1).
743     *
744     * Note that there are no guarantees on the ordering of values inside the
745     * array, and it may change when more values are added or removed.
746     *
747     * Requirements:
748     *
749     * - `index` must be strictly less than {length}.
750     */
751     function at(AddressSet storage set, uint256 index) internal view returns (address) {
752         return address(uint160(uint256(_at(set._inner, index))));
753     }
754 
755 
756     // UintSet
757 
758     struct UintSet {
759         Set _inner;
760     }
761 
762     /**
763      * @dev Add a value to a set. O(1).
764      *
765      * Returns true if the value was added to the set, that is if it was not
766      * already present.
767      */
768     function add(UintSet storage set, uint256 value) internal returns (bool) {
769         return _add(set._inner, bytes32(value));
770     }
771 
772     /**
773      * @dev Removes a value from a set. O(1).
774      *
775      * Returns true if the value was removed from the set, that is if it was
776      * present.
777      */
778     function remove(UintSet storage set, uint256 value) internal returns (bool) {
779         return _remove(set._inner, bytes32(value));
780     }
781 
782     /**
783      * @dev Returns true if the value is in the set. O(1).
784      */
785     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
786         return _contains(set._inner, bytes32(value));
787     }
788 
789     /**
790      * @dev Returns the number of values on the set. O(1).
791      */
792     function length(UintSet storage set) internal view returns (uint256) {
793         return _length(set._inner);
794     }
795 
796    /**
797     * @dev Returns the value stored at position `index` in the set. O(1).
798     *
799     * Note that there are no guarantees on the ordering of values inside the
800     * array, and it may change when more values are added or removed.
801     *
802     * Requirements:
803     *
804     * - `index` must be strictly less than {length}.
805     */
806     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
807         return uint256(_at(set._inner, index));
808     }
809 }
810 
811 
812 
813 /*
814  * @dev Provides information about the current execution context, including the
815  * sender of the transaction and its data. While these are generally available
816  * via msg.sender and msg.data, they should not be accessed in such a direct
817  * manner, since when dealing with GSN meta-transactions the account sending and
818  * paying for execution may not be the actual sender (as far as an application
819  * is concerned).
820  *
821  * This contract is only required for intermediate, library-like contracts.
822  */
823 abstract contract Context {
824     function _msgSender() internal view virtual returns (address payable) {
825         return msg.sender;
826     }
827 
828     function _msgData() internal view virtual returns (bytes memory) {
829         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
830         return msg.data;
831     }
832 }
833 
834 
835 
836 
837 /**
838  * @dev Contract module that allows children to implement role-based access
839  * control mechanisms.
840  *
841  * Roles are referred to by their `bytes32` identifier. These should be exposed
842  * in the external API and be unique. The best way to achieve this is by
843  * using `public constant` hash digests:
844  *
845  * ```
846  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
847  * ```
848  *
849  * Roles can be used to represent a set of permissions. To restrict access to a
850  * function call, use {hasRole}:
851  *
852  * ```
853  * function foo() public {
854  *     require(hasRole(MY_ROLE, msg.sender));
855  *     ...
856  * }
857  * ```
858  *
859  * Roles can be granted and revoked dynamically via the {grantRole} and
860  * {revokeRole} functions. Each role has an associated admin role, and only
861  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
862  *
863  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
864  * that only accounts with this role will be able to grant or revoke other
865  * roles. More complex role relationships can be created by using
866  * {_setRoleAdmin}.
867  *
868  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
869  * grant and revoke this role. Extra precautions should be taken to secure
870  * accounts that have been granted it.
871  */
872 abstract contract AccessControl is Context {
873     using EnumerableSet for EnumerableSet.AddressSet;
874     using Address for address;
875 
876     struct RoleData {
877         EnumerableSet.AddressSet members;
878         bytes32 adminRole;
879     }
880 
881     mapping (bytes32 => RoleData) private _roles;
882 
883     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
884 
885     /**
886      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
887      *
888      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
889      * {RoleAdminChanged} not being emitted signaling this.
890      *
891      * _Available since v3.1._
892      */
893     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
894 
895     /**
896      * @dev Emitted when `account` is granted `role`.
897      *
898      * `sender` is the account that originated the contract call, an admin role
899      * bearer except when using {_setupRole}.
900      */
901     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
902 
903     /**
904      * @dev Emitted when `account` is revoked `role`.
905      *
906      * `sender` is the account that originated the contract call:
907      *   - if using `revokeRole`, it is the admin role bearer
908      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
909      */
910     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
911 
912     /**
913      * @dev Returns `true` if `account` has been granted `role`.
914      */
915     function hasRole(bytes32 role, address account) public view returns (bool) {
916         return _roles[role].members.contains(account);
917     }
918 
919     /**
920      * @dev Returns the number of accounts that have `role`. Can be used
921      * together with {getRoleMember} to enumerate all bearers of a role.
922      */
923     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
924         return _roles[role].members.length();
925     }
926 
927     /**
928      * @dev Returns one of the accounts that have `role`. `index` must be a
929      * value between 0 and {getRoleMemberCount}, non-inclusive.
930      *
931      * Role bearers are not sorted in any particular way, and their ordering may
932      * change at any point.
933      *
934      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
935      * you perform all queries on the same block. See the following
936      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
937      * for more information.
938      */
939     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
940         return _roles[role].members.at(index);
941     }
942 
943     /**
944      * @dev Returns the admin role that controls `role`. See {grantRole} and
945      * {revokeRole}.
946      *
947      * To change a role's admin, use {_setRoleAdmin}.
948      */
949     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
950         return _roles[role].adminRole;
951     }
952 
953     /**
954      * @dev Grants `role` to `account`.
955      *
956      * If `account` had not been already granted `role`, emits a {RoleGranted}
957      * event.
958      *
959      * Requirements:
960      *
961      * - the caller must have ``role``'s admin role.
962      */
963     function grantRole(bytes32 role, address account) public virtual {
964         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
965 
966         _grantRole(role, account);
967     }
968 
969     /**
970      * @dev Revokes `role` from `account`.
971      *
972      * If `account` had been granted `role`, emits a {RoleRevoked} event.
973      *
974      * Requirements:
975      *
976      * - the caller must have ``role``'s admin role.
977      */
978     function revokeRole(bytes32 role, address account) public virtual {
979         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
980 
981         _revokeRole(role, account);
982     }
983 
984     /**
985      * @dev Revokes `role` from the calling account.
986      *
987      * Roles are often managed via {grantRole} and {revokeRole}: this function's
988      * purpose is to provide a mechanism for accounts to lose their privileges
989      * if they are compromised (such as when a trusted device is misplaced).
990      *
991      * If the calling account had been granted `role`, emits a {RoleRevoked}
992      * event.
993      *
994      * Requirements:
995      *
996      * - the caller must be `account`.
997      */
998     function renounceRole(bytes32 role, address account) public virtual {
999         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1000 
1001         _revokeRole(role, account);
1002     }
1003 
1004     /**
1005      * @dev Grants `role` to `account`.
1006      *
1007      * If `account` had not been already granted `role`, emits a {RoleGranted}
1008      * event. Note that unlike {grantRole}, this function doesn't perform any
1009      * checks on the calling account.
1010      *
1011      * [WARNING]
1012      * ====
1013      * This function should only be called from the constructor when setting
1014      * up the initial roles for the system.
1015      *
1016      * Using this function in any other way is effectively circumventing the admin
1017      * system imposed by {AccessControl}.
1018      * ====
1019      */
1020     function _setupRole(bytes32 role, address account) internal virtual {
1021         _grantRole(role, account);
1022     }
1023 
1024     /**
1025      * @dev Sets `adminRole` as ``role``'s admin role.
1026      *
1027      * Emits a {RoleAdminChanged} event.
1028      */
1029     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1030         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1031         _roles[role].adminRole = adminRole;
1032     }
1033 
1034     function _grantRole(bytes32 role, address account) private {
1035         if (_roles[role].members.add(account)) {
1036             emit RoleGranted(role, account, _msgSender());
1037         }
1038     }
1039 
1040     function _revokeRole(bytes32 role, address account) private {
1041         if (_roles[role].members.remove(account)) {
1042             emit RoleRevoked(role, account, _msgSender());
1043         }
1044     }
1045 }
1046 
1047 
1048 
1049 /**
1050  * @dev Interface of the ERC165 standard, as defined in the
1051  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1052  *
1053  * Implementers can declare support of contract interfaces, which can then be
1054  * queried by others ({ERC165Checker}).
1055  *
1056  * For an implementation, see {ERC165}.
1057  */
1058 interface IERC165 {
1059     /**
1060      * @dev Returns true if this contract implements the interface defined by
1061      * `interfaceId`. See the corresponding
1062      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1063      * to learn more about how these ids are created.
1064      *
1065      * This function call must use less than 30 000 gas.
1066      */
1067     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1068 }
1069 
1070 
1071 /**
1072  * @dev Required interface of an ERC721 compliant contract.
1073  */
1074 interface IERC721 is IERC165 {
1075     /**
1076      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1077      */
1078     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1079 
1080     /**
1081      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1082      */
1083     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1084 
1085     /**
1086      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1087      */
1088     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1089 
1090     /**
1091      * @dev Returns the number of tokens in ``owner``'s account.
1092      */
1093     function balanceOf(address owner) external view returns (uint256 balance);
1094 
1095     /**
1096      * @dev Returns the owner of the `tokenId` token.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      */
1102     function ownerOf(uint256 tokenId) external view returns (address owner);
1103 
1104     /**
1105      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1106      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1107      *
1108      * Requirements:
1109      *
1110      * - `from` cannot be the zero address.
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must exist and be owned by `from`.
1113      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1119 
1120     /**
1121      * @dev Transfers `tokenId` token from `from` to `to`.
1122      *
1123      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1124      *
1125      * Requirements:
1126      *
1127      * - `from` cannot be the zero address.
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function transferFrom(address from, address to, uint256 tokenId) external;
1135 
1136     /**
1137      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1138      * The approval is cleared when the token is transferred.
1139      *
1140      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1141      *
1142      * Requirements:
1143      *
1144      * - The caller must own the token or be an approved operator.
1145      * - `tokenId` must exist.
1146      *
1147      * Emits an {Approval} event.
1148      */
1149     function approve(address to, uint256 tokenId) external;
1150 
1151     /**
1152      * @dev Returns the account approved for `tokenId` token.
1153      *
1154      * Requirements:
1155      *
1156      * - `tokenId` must exist.
1157      */
1158     function getApproved(uint256 tokenId) external view returns (address operator);
1159 
1160     /**
1161      * @dev Approve or remove `operator` as an operator for the caller.
1162      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1163      *
1164      * Requirements:
1165      *
1166      * - The `operator` cannot be the caller.
1167      *
1168      * Emits an {ApprovalForAll} event.
1169      */
1170     function setApprovalForAll(address operator, bool _approved) external;
1171 
1172     /**
1173      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1174      *
1175      * See {setApprovalForAll}
1176      */
1177     function isApprovedForAll(address owner, address operator) external view returns (bool);
1178 
1179     /**
1180       * @dev Safely transfers `tokenId` token from `from` to `to`.
1181       *
1182       * Requirements:
1183       *
1184       * - `from` cannot be the zero address.
1185       * - `to` cannot be the zero address.
1186       * - `tokenId` token must exist and be owned by `from`.
1187       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1188       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1189       *
1190       * Emits a {Transfer} event.
1191       */
1192     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1193 }
1194 
1195 
1196 /**
1197  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1198  * @dev See https://eips.ethereum.org/EIPS/eip-721
1199  */
1200 interface IERC721Metadata is IERC721 {
1201 
1202     /**
1203      * @dev Returns the token collection name.
1204      */
1205     function name() external view returns (string memory);
1206 
1207     /**
1208      * @dev Returns the token collection symbol.
1209      */
1210     function symbol() external view returns (string memory);
1211 
1212     /**
1213      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1214      */
1215     function tokenURI(uint256 tokenId) external view returns (string memory);
1216 }
1217 
1218 
1219 /**
1220  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1221  * @dev See https://eips.ethereum.org/EIPS/eip-721
1222  */
1223 interface IERC721Enumerable is IERC721 {
1224 
1225     /**
1226      * @dev Returns the total amount of tokens stored by the contract.
1227      */
1228     function totalSupply() external view returns (uint256);
1229 
1230     /**
1231      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1232      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1233      */
1234     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1235 
1236     /**
1237      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1238      * Use along with {totalSupply} to enumerate all tokens.
1239      */
1240     function tokenByIndex(uint256 index) external view returns (uint256);
1241 }
1242 
1243 
1244 
1245 /**
1246  * @title ERC721 token receiver interface
1247  * @dev Interface for any contract that wants to support safeTransfers
1248  * from ERC721 asset contracts.
1249  */
1250 interface IERC721Receiver {
1251     /**
1252      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1253      * by `operator` from `from`, this function is called.
1254      *
1255      * It must return its Solidity selector to confirm the token transfer.
1256      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1257      *
1258      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1259      */
1260     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1261 }
1262 
1263 
1264 /**
1265  * @dev Implementation of the {IERC165} interface.
1266  *
1267  * Contracts may inherit from this and call {_registerInterface} to declare
1268  * their support of an interface.
1269  */
1270 abstract contract ERC165 is IERC165 {
1271     /*
1272      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1273      */
1274     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1275 
1276     /**
1277      * @dev Mapping of interface ids to whether or not it's supported.
1278      */
1279     mapping(bytes4 => bool) private _supportedInterfaces;
1280 
1281     constructor () internal {
1282         // Derived contracts need only register support for their own interfaces,
1283         // we register support for ERC165 itself here
1284         _registerInterface(_INTERFACE_ID_ERC165);
1285     }
1286 
1287     /**
1288      * @dev See {IERC165-supportsInterface}.
1289      *
1290      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1291      */
1292     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1293         return _supportedInterfaces[interfaceId];
1294     }
1295 
1296     /**
1297      * @dev Registers the contract as an implementer of the interface defined by
1298      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1299      * registering its interface id is not required.
1300      *
1301      * See {IERC165-supportsInterface}.
1302      *
1303      * Requirements:
1304      *
1305      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1306      */
1307     function _registerInterface(bytes4 interfaceId) internal virtual {
1308         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1309         _supportedInterfaces[interfaceId] = true;
1310     }
1311 }
1312 
1313 
1314 
1315 /**
1316  * @dev Library for managing an enumerable variant of Solidity's
1317  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1318  * type.
1319  *
1320  * Maps have the following properties:
1321  *
1322  * - Entries are added, removed, and checked for existence in constant time
1323  * (O(1)).
1324  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1325  *
1326  * ```
1327  * contract Example {
1328  *     // Add the library methods
1329  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1330  *
1331  *     // Declare a set state variable
1332  *     EnumerableMap.UintToAddressMap private myMap;
1333  * }
1334  * ```
1335  *
1336  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1337  * supported.
1338  */
1339 library EnumerableMap {
1340     // To implement this library for multiple types with as little code
1341     // repetition as possible, we write it in terms of a generic Map type with
1342     // bytes32 keys and values.
1343     // The Map implementation uses private functions, and user-facing
1344     // implementations (such as Uint256ToAddressMap) are just wrappers around
1345     // the underlying Map.
1346     // This means that we can only create new EnumerableMaps for types that fit
1347     // in bytes32.
1348 
1349     struct MapEntry {
1350         bytes32 _key;
1351         bytes32 _value;
1352     }
1353 
1354     struct Map {
1355         // Storage of map keys and values
1356         MapEntry[] _entries;
1357 
1358         // Position of the entry defined by a key in the `entries` array, plus 1
1359         // because index 0 means a key is not in the map.
1360         mapping (bytes32 => uint256) _indexes;
1361     }
1362 
1363     /**
1364      * @dev Adds a key-value pair to a map, or updates the value for an existing
1365      * key. O(1).
1366      *
1367      * Returns true if the key was added to the map, that is if it was not
1368      * already present.
1369      */
1370     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1371         // We read and store the key's index to prevent multiple reads from the same storage slot
1372         uint256 keyIndex = map._indexes[key];
1373 
1374         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1375             map._entries.push(MapEntry({ _key: key, _value: value }));
1376             // The entry is stored at length-1, but we add 1 to all indexes
1377             // and use 0 as a sentinel value
1378             map._indexes[key] = map._entries.length;
1379             return true;
1380         } else {
1381             map._entries[keyIndex - 1]._value = value;
1382             return false;
1383         }
1384     }
1385 
1386     /**
1387      * @dev Removes a key-value pair from a map. O(1).
1388      *
1389      * Returns true if the key was removed from the map, that is if it was present.
1390      */
1391     function _remove(Map storage map, bytes32 key) private returns (bool) {
1392         // We read and store the key's index to prevent multiple reads from the same storage slot
1393         uint256 keyIndex = map._indexes[key];
1394 
1395         if (keyIndex != 0) { // Equivalent to contains(map, key)
1396             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1397             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1398             // This modifies the order of the array, as noted in {at}.
1399 
1400             uint256 toDeleteIndex = keyIndex - 1;
1401             uint256 lastIndex = map._entries.length - 1;
1402 
1403             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1404             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1405 
1406             MapEntry storage lastEntry = map._entries[lastIndex];
1407 
1408             // Move the last entry to the index where the entry to delete is
1409             map._entries[toDeleteIndex] = lastEntry;
1410             // Update the index for the moved entry
1411             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1412 
1413             // Delete the slot where the moved entry was stored
1414             map._entries.pop();
1415 
1416             // Delete the index for the deleted slot
1417             delete map._indexes[key];
1418 
1419             return true;
1420         } else {
1421             return false;
1422         }
1423     }
1424 
1425     /**
1426      * @dev Returns true if the key is in the map. O(1).
1427      */
1428     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1429         return map._indexes[key] != 0;
1430     }
1431 
1432     /**
1433      * @dev Returns the number of key-value pairs in the map. O(1).
1434      */
1435     function _length(Map storage map) private view returns (uint256) {
1436         return map._entries.length;
1437     }
1438 
1439    /**
1440     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1441     *
1442     * Note that there are no guarantees on the ordering of entries inside the
1443     * array, and it may change when more entries are added or removed.
1444     *
1445     * Requirements:
1446     *
1447     * - `index` must be strictly less than {length}.
1448     */
1449     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1450         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1451 
1452         MapEntry storage entry = map._entries[index];
1453         return (entry._key, entry._value);
1454     }
1455 
1456     /**
1457      * @dev Tries to returns the value associated with `key`.  O(1).
1458      * Does not revert if `key` is not in the map.
1459      */
1460     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1461         uint256 keyIndex = map._indexes[key];
1462         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1463         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1464     }
1465 
1466     /**
1467      * @dev Returns the value associated with `key`.  O(1).
1468      *
1469      * Requirements:
1470      *
1471      * - `key` must be in the map.
1472      */
1473     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1474         uint256 keyIndex = map._indexes[key];
1475         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1476         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1477     }
1478 
1479     /**
1480      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1481      *
1482      * CAUTION: This function is deprecated because it requires allocating memory for the error
1483      * message unnecessarily. For custom revert reasons use {_tryGet}.
1484      */
1485     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1486         uint256 keyIndex = map._indexes[key];
1487         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1488         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1489     }
1490 
1491     // UintToAddressMap
1492 
1493     struct UintToAddressMap {
1494         Map _inner;
1495     }
1496 
1497     /**
1498      * @dev Adds a key-value pair to a map, or updates the value for an existing
1499      * key. O(1).
1500      *
1501      * Returns true if the key was added to the map, that is if it was not
1502      * already present.
1503      */
1504     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1505         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1506     }
1507 
1508     /**
1509      * @dev Removes a value from a set. O(1).
1510      *
1511      * Returns true if the key was removed from the map, that is if it was present.
1512      */
1513     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1514         return _remove(map._inner, bytes32(key));
1515     }
1516 
1517     /**
1518      * @dev Returns true if the key is in the map. O(1).
1519      */
1520     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1521         return _contains(map._inner, bytes32(key));
1522     }
1523 
1524     /**
1525      * @dev Returns the number of elements in the map. O(1).
1526      */
1527     function length(UintToAddressMap storage map) internal view returns (uint256) {
1528         return _length(map._inner);
1529     }
1530 
1531    /**
1532     * @dev Returns the element stored at position `index` in the set. O(1).
1533     * Note that there are no guarantees on the ordering of values inside the
1534     * array, and it may change when more values are added or removed.
1535     *
1536     * Requirements:
1537     *
1538     * - `index` must be strictly less than {length}.
1539     */
1540     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1541         (bytes32 key, bytes32 value) = _at(map._inner, index);
1542         return (uint256(key), address(uint160(uint256(value))));
1543     }
1544 
1545     /**
1546      * @dev Tries to returns the value associated with `key`.  O(1).
1547      * Does not revert if `key` is not in the map.
1548      *
1549      * _Available since v3.4._
1550      */
1551     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1552         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1553         return (success, address(uint160(uint256(value))));
1554     }
1555 
1556     /**
1557      * @dev Returns the value associated with `key`.  O(1).
1558      *
1559      * Requirements:
1560      *
1561      * - `key` must be in the map.
1562      */
1563     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1564         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1565     }
1566 
1567     /**
1568      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1569      *
1570      * CAUTION: This function is deprecated because it requires allocating memory for the error
1571      * message unnecessarily. For custom revert reasons use {tryGet}.
1572      */
1573     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1574         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1575     }
1576 }
1577 
1578 
1579 /**
1580  * @dev String operations.
1581  */
1582 library Strings {
1583     /**
1584      * @dev Converts a `uint256` to its ASCII `string` representation.
1585      */
1586     function toString(uint256 value) internal pure returns (string memory) {
1587         // Inspired by OraclizeAPI's implementation - MIT licence
1588         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1589 
1590         if (value == 0) {
1591             return "0";
1592         }
1593         uint256 temp = value;
1594         uint256 digits;
1595         while (temp != 0) {
1596             digits++;
1597             temp /= 10;
1598         }
1599         bytes memory buffer = new bytes(digits);
1600         uint256 index = digits - 1;
1601         temp = value;
1602         while (temp != 0) {
1603             buffer[index--] = bytes1(uint8(48 + temp % 10));
1604             temp /= 10;
1605         }
1606         return string(buffer);
1607     }
1608 }
1609 
1610 
1611 /**
1612  * @title ERC721 Non-Fungible Token Standard basic implementation
1613  * @dev see https://eips.ethereum.org/EIPS/eip-721
1614  */
1615 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1616     using SafeMath for uint256;
1617     using Address for address;
1618     using EnumerableSet for EnumerableSet.UintSet;
1619     using EnumerableMap for EnumerableMap.UintToAddressMap;
1620     using Strings for uint256;
1621 
1622     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1623     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1624     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1625 
1626     // Mapping from holder address to their (enumerable) set of owned tokens
1627     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1628 
1629     // Enumerable mapping from token ids to their owners
1630     EnumerableMap.UintToAddressMap private _tokenOwners;
1631 
1632     // Mapping from token ID to approved address
1633     mapping (uint256 => address) private _tokenApprovals;
1634 
1635     // Mapping from owner to operator approvals
1636     mapping (address => mapping (address => bool)) private _operatorApprovals;
1637 
1638     // Token name
1639     string private _name;
1640 
1641     // Token symbol
1642     string private _symbol;
1643 
1644     // Optional mapping for token URIs
1645     mapping (uint256 => string) private _tokenURIs;
1646 
1647     // Base URI
1648     string private _baseURI;
1649 
1650     /*
1651      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1652      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1653      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1654      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1655      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1656      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1657      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1658      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1659      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1660      *
1661      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1662      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1663      */
1664     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1665 
1666     /*
1667      *     bytes4(keccak256('name()')) == 0x06fdde03
1668      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1669      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1670      *
1671      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1672      */
1673     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1674 
1675     /*
1676      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1677      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1678      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1679      *
1680      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1681      */
1682     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1683 
1684     /**
1685      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1686      */
1687     constructor (string memory name_, string memory symbol_) public {
1688         _name = name_;
1689         _symbol = symbol_;
1690 
1691         // register the supported interfaces to conform to ERC721 via ERC165
1692         _registerInterface(_INTERFACE_ID_ERC721);
1693         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1694         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1695     }
1696 
1697     /**
1698      * @dev See {IERC721-balanceOf}.
1699      */
1700     function balanceOf(address owner) public view virtual override returns (uint256) {
1701         require(owner != address(0), "ERC721: balance query for the zero address");
1702         return _holderTokens[owner].length();
1703     }
1704 
1705     /**
1706      * @dev See {IERC721-ownerOf}.
1707      */
1708     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1709         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1710     }
1711 
1712     /**
1713      * @dev See {IERC721Metadata-name}.
1714      */
1715     function name() public view virtual override returns (string memory) {
1716         return _name;
1717     }
1718 
1719     /**
1720      * @dev See {IERC721Metadata-symbol}.
1721      */
1722     function symbol() public view virtual override returns (string memory) {
1723         return _symbol;
1724     }
1725 
1726     /**
1727      * @dev See {IERC721Metadata-tokenURI}.
1728      */
1729     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1730         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1731 
1732         string memory _tokenURI = _tokenURIs[tokenId];
1733         string memory base = baseURI();
1734 
1735         // If there is no base URI, return the token URI.
1736         if (bytes(base).length == 0) {
1737             return _tokenURI;
1738         }
1739         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1740         if (bytes(_tokenURI).length > 0) {
1741             return string(abi.encodePacked(base, _tokenURI));
1742         }
1743         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1744         return string(abi.encodePacked(base, tokenId.toString()));
1745     }
1746 
1747     /**
1748     * @dev Returns the base URI set via {_setBaseURI}. This will be
1749     * automatically added as a prefix in {tokenURI} to each token's URI, or
1750     * to the token ID if no specific URI is set for that token ID.
1751     */
1752     function baseURI() public view virtual returns (string memory) {
1753         return _baseURI;
1754     }
1755 
1756     /**
1757      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1758      */
1759     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1760         return _holderTokens[owner].at(index);
1761     }
1762 
1763     /**
1764      * @dev See {IERC721Enumerable-totalSupply}.
1765      */
1766     function totalSupply() public view virtual override returns (uint256) {
1767         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1768         return _tokenOwners.length();
1769     }
1770 
1771     /**
1772      * @dev See {IERC721Enumerable-tokenByIndex}.
1773      */
1774     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1775         (uint256 tokenId, ) = _tokenOwners.at(index);
1776         return tokenId;
1777     }
1778 
1779     /**
1780      * @dev See {IERC721-approve}.
1781      */
1782     function approve(address to, uint256 tokenId) public virtual override {
1783         address owner = ERC721.ownerOf(tokenId);
1784         require(to != owner, "ERC721: approval to current owner");
1785 
1786         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1787             "ERC721: approve caller is not owner nor approved for all"
1788         );
1789 
1790         _approve(to, tokenId);
1791     }
1792 
1793     /**
1794      * @dev See {IERC721-getApproved}.
1795      */
1796     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1797         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1798 
1799         return _tokenApprovals[tokenId];
1800     }
1801 
1802     /**
1803      * @dev See {IERC721-setApprovalForAll}.
1804      */
1805     function setApprovalForAll(address operator, bool approved) public virtual override {
1806         require(operator != _msgSender(), "ERC721: approve to caller");
1807 
1808         _operatorApprovals[_msgSender()][operator] = approved;
1809         emit ApprovalForAll(_msgSender(), operator, approved);
1810     }
1811 
1812     /**
1813      * @dev See {IERC721-isApprovedForAll}.
1814      */
1815     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1816         return _operatorApprovals[owner][operator];
1817     }
1818 
1819     /**
1820      * @dev See {IERC721-transferFrom}.
1821      */
1822     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1823         //solhint-disable-next-line max-line-length
1824         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1825 
1826         _transfer(from, to, tokenId);
1827     }
1828 
1829     /**
1830      * @dev See {IERC721-safeTransferFrom}.
1831      */
1832     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1833         safeTransferFrom(from, to, tokenId, "");
1834     }
1835 
1836     /**
1837      * @dev See {IERC721-safeTransferFrom}.
1838      */
1839     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1840         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1841         _safeTransfer(from, to, tokenId, _data);
1842     }
1843 
1844     /**
1845      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1846      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1847      *
1848      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1849      *
1850      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1851      * implement alternative mechanisms to perform token transfer, such as signature-based.
1852      *
1853      * Requirements:
1854      *
1855      * - `from` cannot be the zero address.
1856      * - `to` cannot be the zero address.
1857      * - `tokenId` token must exist and be owned by `from`.
1858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1859      *
1860      * Emits a {Transfer} event.
1861      */
1862     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1863         _transfer(from, to, tokenId);
1864         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1865     }
1866 
1867     /**
1868      * @dev Returns whether `tokenId` exists.
1869      *
1870      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1871      *
1872      * Tokens start existing when they are minted (`_mint`),
1873      * and stop existing when they are burned (`_burn`).
1874      */
1875     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1876         return _tokenOwners.contains(tokenId);
1877     }
1878 
1879     /**
1880      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1881      *
1882      * Requirements:
1883      *
1884      * - `tokenId` must exist.
1885      */
1886     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1887         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1888         address owner = ERC721.ownerOf(tokenId);
1889         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1890     }
1891 
1892     /**
1893      * @dev Safely mints `tokenId` and transfers it to `to`.
1894      *
1895      * Requirements:
1896      d*
1897      * - `tokenId` must not exist.
1898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1899      *
1900      * Emits a {Transfer} event.
1901      */
1902     function _safeMint(address to, uint256 tokenId) internal virtual {
1903         _safeMint(to, tokenId, "");
1904     }
1905 
1906     /**
1907      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1908      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1909      */
1910     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1911         _mint(to, tokenId);
1912         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1913     }
1914 
1915     /**
1916      * @dev Mints `tokenId` and transfers it to `to`.
1917      *
1918      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1919      *
1920      * Requirements:
1921      *
1922      * - `tokenId` must not exist.
1923      * - `to` cannot be the zero address.
1924      *
1925      * Emits a {Transfer} event.
1926      */
1927     function _mint(address to, uint256 tokenId) internal virtual {
1928         require(to != address(0), "ERC721: mint to the zero address");
1929         require(!_exists(tokenId), "ERC721: token already minted");
1930 
1931         _beforeTokenTransfer(address(0), to, tokenId);
1932 
1933         _holderTokens[to].add(tokenId);
1934 
1935         _tokenOwners.set(tokenId, to);
1936 
1937         emit Transfer(address(0), to, tokenId);
1938     }
1939 
1940     /**
1941      * @dev Destroys `tokenId`.
1942      * The approval is cleared when the token is burned.
1943      *
1944      * Requirements:
1945      *
1946      * - `tokenId` must exist.
1947      *
1948      * Emits a {Transfer} event.
1949      */
1950     function _burn(uint256 tokenId) internal virtual {
1951         address owner = ERC721.ownerOf(tokenId); // internal owner
1952 
1953         _beforeTokenTransfer(owner, address(0), tokenId);
1954 
1955         // Clear approvals
1956         _approve(address(0), tokenId);
1957 
1958         // Clear metadata (if any)
1959         if (bytes(_tokenURIs[tokenId]).length != 0) {
1960             delete _tokenURIs[tokenId];
1961         }
1962 
1963         _holderTokens[owner].remove(tokenId);
1964 
1965         _tokenOwners.remove(tokenId);
1966 
1967         emit Transfer(owner, address(0), tokenId);
1968     }
1969 
1970     /**
1971      * @dev Transfers `tokenId` from `from` to `to`.
1972      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1973      *
1974      * Requirements:
1975      *
1976      * - `to` cannot be the zero address.
1977      * - `tokenId` token must be owned by `from`.
1978      *
1979      * Emits a {Transfer} event.
1980      */
1981     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1982         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1983         require(to != address(0), "ERC721: transfer to the zero address");
1984 
1985         _beforeTokenTransfer(from, to, tokenId);
1986 
1987         // Clear approvals from the previous owner
1988         _approve(address(0), tokenId);
1989 
1990         _holderTokens[from].remove(tokenId);
1991         _holderTokens[to].add(tokenId);
1992 
1993         _tokenOwners.set(tokenId, to);
1994 
1995         emit Transfer(from, to, tokenId);
1996     }
1997 
1998     /**
1999      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2000      *
2001      * Requirements:
2002      *
2003      * - `tokenId` must exist.
2004      */
2005     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2006         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2007         _tokenURIs[tokenId] = _tokenURI;
2008     }
2009 
2010     /**
2011      * @dev Internal function to set the base URI for all token IDs. It is
2012      * automatically added as a prefix to the value returned in {tokenURI},
2013      * or to the token ID if {tokenURI} is empty.
2014      */
2015     function _setBaseURI(string memory baseURI_) internal virtual {
2016         _baseURI = baseURI_;
2017     }
2018 
2019     /**
2020      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2021      * The call is not executed if the target address is not a contract.
2022      *
2023      * @param from address representing the previous owner of the given token ID
2024      * @param to target address that will receive the tokens
2025      * @param tokenId uint256 ID of the token to be transferred
2026      * @param _data bytes optional data to send along with the call
2027      * @return bool whether the call correctly returned the expected magic value
2028      */
2029     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
2030         private returns (bool)
2031     {
2032         if (!to.isContract()) {
2033             return true;
2034         }
2035         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2036             IERC721Receiver(to).onERC721Received.selector,
2037             _msgSender(),
2038             from,
2039             tokenId,
2040             _data
2041         ), "ERC721: transfer to non ERC721Receiver implementer");
2042         bytes4 retval = abi.decode(returndata, (bytes4));
2043         return (retval == _ERC721_RECEIVED);
2044     }
2045 
2046     /**
2047      * @dev Approve `to` to operate on `tokenId`
2048      *
2049      * Emits an {Approval} event.
2050      */
2051     function _approve(address to, uint256 tokenId) internal virtual {
2052         _tokenApprovals[tokenId] = to;
2053         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2054     }
2055 
2056     /**
2057      * @dev Hook that is called before any token transfer. This includes minting
2058      * and burning.
2059      *
2060      * Calling conditions:
2061      *
2062      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2063      * transferred to `to`.
2064      * - When `from` is zero, `tokenId` will be minted for `to`.
2065      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2066      * - `from` cannot be the zero address.
2067      * - `to` cannot be the zero address.
2068      *
2069      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2070      */
2071     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2072 }
2073 
2074 
2075 
2076 /**
2077  * @title ERC721 Burnable Token
2078  * @dev ERC721 Token that can be irreversibly burned (destroyed).
2079  */
2080 abstract contract ERC721Burnable is Context, ERC721 {
2081     /**
2082      * @dev Burns `tokenId`. See {ERC721-_burn}.
2083      *
2084      * Requirements:
2085      *
2086      * - The caller must own `tokenId` or be an approved operator.
2087      */
2088     function burn(uint256 tokenId) public virtual {
2089         //solhint-disable-next-line max-line-length
2090         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
2091         _burn(tokenId);
2092     }
2093 }
2094 
2095 /**
2096  * @dev Contract module which allows children to implement an emergency stop
2097  * mechanism that can be triggered by an authorized account.
2098  *
2099  * This module is used through inheritance. It will make available the
2100  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2101  * the functions of your contract. Note that they will not be pausable by
2102  * simply including this module, only once the modifiers are put in place.
2103  */
2104 abstract contract Pausable is Context {
2105     /**
2106      * @dev Emitted when the pause is triggered by `account`.
2107      */
2108     event Paused(address account);
2109 
2110     /**
2111      * @dev Emitted when the pause is lifted by `account`.
2112      */
2113     event Unpaused(address account);
2114 
2115     bool private _paused;
2116 
2117     /**
2118      * @dev Initializes the contract in unpaused state.
2119      */
2120     constructor () internal {
2121         _paused = false;
2122     }
2123 
2124     /**
2125      * @dev Returns true if the contract is paused, and false otherwise.
2126      */
2127     function paused() public view virtual returns (bool) {
2128         return _paused;
2129     }
2130 
2131     /**
2132      * @dev Modifier to make a function callable only when the contract is not paused.
2133      *
2134      * Requirements:
2135      *
2136      * - The contract must not be paused.
2137      */
2138     modifier whenNotPaused() {
2139         require(!paused(), "Pausable: paused");
2140         _;
2141     }
2142 
2143     /**
2144      * @dev Modifier to make a function callable only when the contract is paused.
2145      *
2146      * Requirements:
2147      *
2148      * - The contract must be paused.
2149      */
2150     modifier whenPaused() {
2151         require(paused(), "Pausable: not paused");
2152         _;
2153     }
2154 
2155     /**
2156      * @dev Triggers stopped state.
2157      *
2158      * Requirements:
2159      *
2160      * - The contract must not be paused.
2161      */
2162     function _pause() internal virtual whenNotPaused {
2163         _paused = true;
2164         emit Paused(_msgSender());
2165     }
2166 
2167     /**
2168      * @dev Returns to normal state.
2169      *
2170      * Requirements:
2171      *
2172      * - The contract must be paused.
2173      */
2174     function _unpause() internal virtual whenPaused {
2175         _paused = false;
2176         emit Unpaused(_msgSender());
2177     }
2178 }
2179 
2180 
2181 /**
2182  * @dev ERC721 token with pausable token transfers, minting and burning.
2183  *
2184  * Useful for scenarios such as preventing trades until the end of an evaluation
2185  * period, or having an emergency switch for freezing all token transfers in the
2186  * event of a large bug.
2187  */
2188 abstract contract ERC721Pausable is ERC721, Pausable {
2189     /**
2190      * @dev See {ERC721-_beforeTokenTransfer}.
2191      *
2192      * Requirements:
2193      *
2194      * - the contract must not be paused.
2195      */
2196     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2197         super._beforeTokenTransfer(from, to, tokenId);
2198 
2199         require(!paused(), "ERC721Pausable: token transfer while paused");
2200     }
2201 }
2202 
2203 
2204 
2205 /**
2206  * @dev {ERC721} token, including:
2207  *
2208  *  - ability for holders to burn (destroy) their tokens
2209  *  - a minter role that allows for token minting (creation)
2210  *  - a pauser role that allows to stop all token transfers
2211  *  - token ID and URI autogeneration
2212  *
2213  * This contract uses {AccessControl} to lock permissioned functions using the
2214  * different roles - head to its documentation for details.
2215  *
2216  * The account that deploys the contract will be granted the minter and pauser
2217  * roles, as well as the default admin role, which will let it grant both minter
2218  * and pauser roles to other accounts.
2219  */
2220 contract ERC721PresetMinterPauserAutoId is Context, AccessControl, ERC721Burnable, ERC721Pausable {
2221     using Counters for Counters.Counter;
2222 
2223     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2224     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2225 
2226     Counters.Counter internal _tokenIdTracker;
2227 
2228     /**
2229      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2230      * account that deploys the contract.
2231      *
2232      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2233      * See {ERC721-tokenURI}.
2234      */
2235     constructor(string memory name, string memory symbol, string memory baseURI) public ERC721(name, symbol) {
2236         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2237 
2238         _setupRole(MINTER_ROLE, _msgSender());
2239         _setupRole(PAUSER_ROLE, _msgSender());
2240 
2241         _setBaseURI(baseURI);
2242     }
2243 
2244     /**
2245      * @dev Creates a new token for `to`. Its token ID will be automatically
2246      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2247      * URI autogenerated based on the base URI passed at construction.
2248      *
2249      * See {ERC721-_mint}.
2250      *
2251      * Requirements:
2252      *
2253      * - the caller must have the `MINTER_ROLE`.
2254      */
2255     function mint(address to) public virtual {
2256         require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");
2257 
2258         // We cannot just use balanceOf to create the new tokenId because tokens
2259         // can be burned (destroyed), so we need a separate counter.
2260         _mint(to, _tokenIdTracker.current());
2261         _tokenIdTracker.increment();
2262     }
2263 
2264     /**
2265      * @dev Pauses all token transfers.
2266      *
2267      * See {ERC721Pausable} and {Pausable-_pause}.
2268      *
2269      * Requirements:
2270      *
2271      * - the caller must have the `PAUSER_ROLE`.
2272      */
2273     function pause() public virtual {
2274         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to pause");
2275         _pause();
2276     }
2277 
2278     /**
2279      * @dev Unpauses all token transfers.
2280      *
2281      * See {ERC721Pausable} and {Pausable-_unpause}.
2282      *
2283      * Requirements:
2284      *
2285      * - the caller must have the `PAUSER_ROLE`.
2286      */
2287     function unpause() public virtual {
2288         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to unpause");
2289         _unpause();
2290     }
2291 
2292     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Pausable) {
2293         super._beforeTokenTransfer(from, to, tokenId);
2294     }
2295 }
2296 
2297 
2298 interface IPolymorph is IERC721 {
2299 
2300     function geneOf(uint256 tokenId) external view returns (uint256 gene);
2301     function mint() external payable;
2302     function bulkBuy(uint256 amount) external payable;
2303     function lastTokenId() external view returns (uint256 tokenId);
2304     function setPolymorphPrice(uint256 newPolymorphPrice) external virtual;
2305     function setMaxSupply(uint256 maxSupply) external virtual;
2306     function setBulkBuyLimit(uint256 bulkBuyLimit) external virtual;
2307 
2308 }
2309 
2310 
2311 
2312 contract Polymorph is IPolymorph, ERC721PresetMinterPauserAutoId, ReentrancyGuard {
2313     using PolymorphGeneGenerator for PolymorphGeneGenerator.Gene;
2314     using SafeMath for uint256;
2315     using Counters for Counters.Counter;
2316 
2317     PolymorphGeneGenerator.Gene internal geneGenerator;
2318 
2319     address payable public daoAddress;
2320     uint256 public polymorphPrice;
2321     uint256 public maxSupply;
2322     uint256 public bulkBuyLimit;
2323     string public arweaveAssetsJSON;
2324 
2325     event TokenMorphed(uint256 indexed tokenId, uint256 oldGene, uint256 newGene, uint256 price, Polymorph.PolymorphEventType eventType);
2326     event TokenMinted(uint256 indexed tokenId, uint256 newGene);
2327     event PolymorphPriceChanged(uint256 newPolymorphPrice);
2328     event MaxSupplyChanged(uint256 newMaxSupply);
2329     event BulkBuyLimitChanged(uint256 newBulkBuyLimit);
2330     event BaseURIChanged(string baseURI);
2331     event arweaveAssetsJSONChanged(string arweaveAssetsJSON);
2332     
2333     enum PolymorphEventType { MINT, MORPH, TRANSFER }
2334 
2335      // Optional mapping for token URIs
2336     mapping (uint256 => uint256) internal _genes;
2337 
2338     constructor(string memory name, string memory symbol, string memory baseURI, address payable _daoAddress, uint premintedTokensCount, uint256 _polymorphPrice, uint256 _maxSupply, uint256 _bulkBuyLimit, string memory _arweaveAssetsJSON) ERC721PresetMinterPauserAutoId(name, symbol, baseURI) public {
2339         daoAddress = _daoAddress;
2340         polymorphPrice = _polymorphPrice;
2341         maxSupply = _maxSupply;
2342         bulkBuyLimit = _bulkBuyLimit;
2343         arweaveAssetsJSON = _arweaveAssetsJSON;
2344         geneGenerator.random();
2345 
2346         _preMint(premintedTokensCount);
2347     }
2348 
2349     function _preMint(uint256 amountToMint) internal { 
2350         for (uint i = 0; i < amountToMint; i++) {
2351             _tokenIdTracker.increment();
2352             uint256 tokenId = _tokenIdTracker.current();
2353             _genes[tokenId] = geneGenerator.random();
2354             _mint(_msgSender(), tokenId); 
2355         }
2356     }
2357 
2358     modifier onlyDAO() {
2359         require(msg.sender == daoAddress, "Not called from the dao");
2360         _;
2361     }
2362 
2363     function geneOf(uint256 tokenId) public view virtual override returns (uint256 gene) {
2364         return _genes[tokenId];
2365     }
2366 
2367     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721PresetMinterPauserAutoId) {
2368         ERC721PresetMinterPauserAutoId._beforeTokenTransfer(from, to, tokenId);
2369         emit TokenMorphed(tokenId, _genes[tokenId], _genes[tokenId], 0, PolymorphEventType.TRANSFER);
2370     }
2371 
2372     function mint() public override payable nonReentrant {
2373         require(_tokenIdTracker.current() < maxSupply, "Total supply reached");
2374 
2375         _tokenIdTracker.increment();
2376 
2377         uint256 tokenId = _tokenIdTracker.current();
2378         _genes[tokenId] = geneGenerator.random();
2379         
2380         (bool transferToDaoStatus, ) = daoAddress.call{value:polymorphPrice}("");
2381         require(transferToDaoStatus, "Address: unable to send value, recipient may have reverted");
2382 
2383         uint256 excessAmount = msg.value.sub(polymorphPrice);
2384         if (excessAmount > 0) {
2385             (bool returnExcessStatus, ) = _msgSender().call{value: excessAmount}("");
2386             require(returnExcessStatus, "Failed to return excess.");
2387         }
2388         
2389         _mint(_msgSender(), tokenId);
2390 
2391         emit TokenMinted(tokenId, _genes[tokenId]);
2392         emit TokenMorphed(tokenId, 0, _genes[tokenId], polymorphPrice, PolymorphEventType.MINT);
2393     }
2394 
2395     function bulkBuy(uint256 amount) public override payable nonReentrant {
2396         require(amount <= bulkBuyLimit, "Cannot bulk buy more than the preset limit");
2397         require(_tokenIdTracker.current().add(amount) <= maxSupply, "Total supply reached");
2398         
2399         (bool transferToDaoStatus, ) = daoAddress.call{value:polymorphPrice.mul(amount)}("");
2400         require(transferToDaoStatus, "Address: unable to send value, recipient may have reverted");
2401 
2402         uint256 excessAmount = msg.value.sub(polymorphPrice.mul(amount));
2403         if (excessAmount > 0) {
2404             (bool returnExcessStatus, ) = _msgSender().call{value: excessAmount}("");
2405             require(returnExcessStatus, "Failed to return excess.");
2406         }
2407 
2408         for (uint256 i = 0; i < amount; i++) {
2409             _tokenIdTracker.increment();
2410             
2411             uint256 tokenId = _tokenIdTracker.current();
2412             _genes[tokenId] = geneGenerator.random();
2413             _mint(_msgSender(), tokenId);
2414             
2415             emit TokenMinted(tokenId, _genes[tokenId]);
2416             emit TokenMorphed(tokenId, 0, _genes[tokenId], polymorphPrice, PolymorphEventType.MINT); 
2417         }
2418         
2419     }
2420 
2421     function lastTokenId() public override view returns (uint256 tokenId) {
2422         return _tokenIdTracker.current();
2423     }
2424 
2425     function mint(address to) public override(ERC721PresetMinterPauserAutoId) {
2426         revert("Should not use this one");
2427     }
2428 
2429     function setPolymorphPrice(uint256 newPolymorphPrice) public override virtual onlyDAO {
2430         polymorphPrice = newPolymorphPrice;
2431 
2432         emit PolymorphPriceChanged(newPolymorphPrice);
2433     }
2434 
2435     function setMaxSupply(uint256 _maxSupply) public override virtual onlyDAO {
2436         maxSupply = _maxSupply;
2437 
2438         emit MaxSupplyChanged(maxSupply);
2439     }
2440 
2441     function setBulkBuyLimit(uint256 _bulkBuyLimit) public override virtual onlyDAO {
2442         bulkBuyLimit = _bulkBuyLimit;
2443 
2444         emit BulkBuyLimitChanged(_bulkBuyLimit);
2445     }
2446 
2447     function setBaseURI(string memory _baseURI) public virtual onlyDAO { 
2448         _setBaseURI(_baseURI);
2449 
2450         emit BaseURIChanged(_baseURI);
2451     }
2452 
2453     function setArweaveAssetsJSON(string memory _arweaveAssetsJSON) public virtual onlyDAO {
2454         arweaveAssetsJSON = _arweaveAssetsJSON;
2455 
2456         emit arweaveAssetsJSONChanged(_arweaveAssetsJSON);
2457     }
2458 
2459     receive() external payable {
2460         mint();
2461     }
2462     
2463 }
2464 
2465 
2466 
2467 interface IPolymorphWithGeneChanger is IPolymorph {
2468 
2469     function morphGene(uint256 tokenId, uint256 genePosition) external payable;
2470     function randomizeGenome(uint256 tokenId) external payable virtual;
2471     function priceForGenomeChange(uint256 tokenId) external virtual view returns(uint256 price);
2472     function changeBaseGenomeChangePrice(uint256 newGenomeChangePrice) external virtual;
2473     function changeRandomizeGenomePrice(uint256 newRandomizeGenomePrice) external virtual;
2474 
2475 }
2476 
2477 
2478 
2479 
2480 
2481 
2482 
2483 contract PolymorphWithGeneChanger is IPolymorphWithGeneChanger, Polymorph {
2484     using PolymorphGeneGenerator for PolymorphGeneGenerator.Gene;
2485     using SafeMath for uint256;
2486     using Address for address;
2487 
2488     mapping(uint256 => uint256) internal _genomeChanges;
2489     uint256 public baseGenomeChangePrice;
2490     uint256 public randomizeGenomePrice;
2491 
2492     event BaseGenomeChangePriceChanged(uint256 newGenomeChange);
2493     event RandomizeGenomePriceChanged(uint256 newRandomizeGenomePriceChange);
2494 
2495     constructor(string memory name, string memory symbol, string memory baseURI, address payable _daoAddress, uint premintedTokensCount, uint256 _baseGenomeChangePrice, uint256 _polymorphPrice, uint256 totalSupply, uint256 _randomizeGenomePrice, uint256 _bulkBuyLimit, string memory _arweaveAssetsJSON) Polymorph(name, symbol, baseURI, _daoAddress, premintedTokensCount, _polymorphPrice, totalSupply, _bulkBuyLimit, _arweaveAssetsJSON) {
2496         baseGenomeChangePrice = _baseGenomeChangePrice;
2497         randomizeGenomePrice = _randomizeGenomePrice;
2498     }
2499 
2500     function changeBaseGenomeChangePrice(uint256 newGenomeChangePrice)  public override virtual onlyDAO {
2501         baseGenomeChangePrice = newGenomeChangePrice;
2502         emit BaseGenomeChangePriceChanged(newGenomeChangePrice);
2503     }
2504 
2505     function changeRandomizeGenomePrice(uint256 newRandomizeGenomePrice)  public override virtual onlyDAO {
2506         randomizeGenomePrice = newRandomizeGenomePrice;
2507         emit RandomizeGenomePriceChanged(newRandomizeGenomePrice);
2508     }
2509 
2510     function morphGene(uint256 tokenId, uint256 genePosition) public payable virtual override nonReentrant {
2511         require(genePosition > 0, "Base character not morphable");
2512         _beforeGenomeChange(tokenId);
2513         uint256 price = priceForGenomeChange(tokenId);
2514         
2515         (bool transferToDaoStatus, ) = daoAddress.call{value:price}("");
2516         require(transferToDaoStatus, "Address: unable to send value, recipient may have reverted");
2517 
2518         uint256 excessAmount = msg.value.sub(price);
2519         if (excessAmount > 0) {
2520             (bool returnExcessStatus, ) = _msgSender().call{value: excessAmount}("");
2521             require(returnExcessStatus, "Failed to return excess.");
2522         }
2523 
2524         uint256 oldGene = _genes[tokenId];
2525         uint256 newTrait = geneGenerator.random()%100;
2526         _genes[tokenId] = replaceGene(oldGene, newTrait, genePosition);
2527         _genomeChanges[tokenId]++;
2528         emit TokenMorphed(tokenId, oldGene, oldGene, price, PolymorphEventType.MORPH);
2529     }
2530 
2531     function replaceGene(uint256 genome, uint256 replacement, uint256 genePosition) internal virtual pure returns(uint256 newGene) {
2532         require(genePosition < 38, "Bad gene position");
2533         uint256 mod = 0;
2534         if (genePosition > 0) {
2535             mod = genome.mod(10**(genePosition * 2)); // Each gene is 2 digits long
2536         }
2537         uint256 div = genome.div(10 ** ((genePosition + 1) * 2)).mul(10 ** ((genePosition + 1) * 2));
2538         uint256 insert = replacement * (10 ** (genePosition * 2));
2539         newGene = div.add(insert).add(mod);
2540         return newGene;
2541     }
2542 
2543     function randomizeGenome(uint256 tokenId) public payable override virtual nonReentrant {
2544         _beforeGenomeChange(tokenId);
2545 
2546         (bool transferToDaoStatus, ) = daoAddress.call{value:randomizeGenomePrice}("");
2547         require(transferToDaoStatus, "Address: unable to send value, recipient may have reverted");
2548 
2549         uint256 excessAmount = msg.value.sub(randomizeGenomePrice);
2550         if (excessAmount > 0) {
2551             (bool returnExcessStatus, ) = _msgSender().call{value: excessAmount}("");
2552             require(returnExcessStatus, "Failed to return excess.");
2553         }
2554         
2555         uint256 oldGene = _genes[tokenId];
2556         _genes[tokenId] = geneGenerator.random();
2557         _genomeChanges[tokenId] = 0;
2558         emit TokenMorphed(tokenId, oldGene, _genes[tokenId], randomizeGenomePrice, PolymorphEventType.MORPH);
2559     }
2560 
2561     function priceForGenomeChange(uint256 tokenId) public override virtual view returns(uint256 price) {
2562         uint256 pastChanges = _genomeChanges[tokenId];
2563 
2564         return baseGenomeChangePrice.mul(1 << pastChanges);
2565     }
2566 
2567     function _beforeGenomeChange(uint256 tokenId) internal virtual {
2568         require(!address(_msgSender()).isContract(), "Caller cannot be a contract");
2569         require(ownerOf(tokenId) == _msgSender(), "PolymorphWithGeneChanger: cannot change genome of token that is not own");
2570     }
2571     
2572 }