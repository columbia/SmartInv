1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         uint256 c = a + b;
30         if (c < a) return (false, 0);
31         return (true, c);
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         if (b > a) return (false, 0);
41         return (true, a - b);
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53         if (a == 0) return (true, 0);
54         uint256 c = a * b;
55         if (c / a != b) return (false, 0);
56         return (true, c);
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         if (b == 0) return (false, 0);
76         return (true, a % b);
77     }
78 
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      *
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a, "SafeMath: subtraction overflow");
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) return 0;
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b > 0, "SafeMath: division by zero");
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0, "SafeMath: modulo by zero");
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {tryDiv}.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         return a / b;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 
221 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
222 
223 // SPDX-License-Identifier: MIT
224 
225 pragma solidity >=0.6.0 <0.8.0;
226 
227 /*
228  * @dev Provides information about the current execution context, including the
229  * sender of the transaction and its data. While these are generally available
230  * via msg.sender and msg.data, they should not be accessed in such a direct
231  * manner, since when dealing with GSN meta-transactions the account sending and
232  * paying for execution may not be the actual sender (as far as an application
233  * is concerned).
234  *
235  * This contract is only required for intermediate, library-like contracts.
236  */
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address payable) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes memory) {
243         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
244         return msg.data;
245     }
246 }
247 
248 
249 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
250 
251 // SPDX-License-Identifier: MIT
252 
253 pragma solidity >=0.6.0 <0.8.0;
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * By default, the owner account will be the one that deploys the contract. This
261  * can later be changed with {transferOwnership}.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 abstract contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor () internal {
276         address msgSender = _msgSender();
277         _owner = msgSender;
278         emit OwnershipTransferred(address(0), msgSender);
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view virtual returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(owner() == _msgSender(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Leaves the contract without owner. It will not be possible to call
298      * `onlyOwner` functions anymore. Can only be called by the current owner.
299      *
300      * NOTE: Renouncing ownership will leave the contract without an owner,
301      * thereby removing any functionality that is only available to the owner.
302      */
303     function renounceOwnership() public virtual onlyOwner {
304         emit OwnershipTransferred(_owner, address(0));
305         _owner = address(0);
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Can only be called by the current owner.
311      */
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         emit OwnershipTransferred(_owner, newOwner);
315         _owner = newOwner;
316     }
317 }
318 
319 
320 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
321 
322 // SPDX-License-Identifier: MIT
323 
324 pragma solidity >=0.6.0 <0.8.0;
325 
326 /**
327  * @dev Library for managing
328  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
329  * types.
330  *
331  * Sets have the following properties:
332  *
333  * - Elements are added, removed, and checked for existence in constant time
334  * (O(1)).
335  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
336  *
337  * ```
338  * contract Example {
339  *     // Add the library methods
340  *     using EnumerableSet for EnumerableSet.AddressSet;
341  *
342  *     // Declare a set state variable
343  *     EnumerableSet.AddressSet private mySet;
344  * }
345  * ```
346  *
347  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
348  * and `uint256` (`UintSet`) are supported.
349  */
350 library EnumerableSet {
351     // To implement this library for multiple types with as little code
352     // repetition as possible, we write it in terms of a generic Set type with
353     // bytes32 values.
354     // The Set implementation uses private functions, and user-facing
355     // implementations (such as AddressSet) are just wrappers around the
356     // underlying Set.
357     // This means that we can only create new EnumerableSets for types that fit
358     // in bytes32.
359 
360     struct Set {
361         // Storage of set values
362         bytes32[] _values;
363 
364         // Position of the value in the `values` array, plus 1 because index 0
365         // means a value is not in the set.
366         mapping (bytes32 => uint256) _indexes;
367     }
368 
369     /**
370      * @dev Add a value to a set. O(1).
371      *
372      * Returns true if the value was added to the set, that is if it was not
373      * already present.
374      */
375     function _add(Set storage set, bytes32 value) private returns (bool) {
376         if (!_contains(set, value)) {
377             set._values.push(value);
378             // The value is stored at length-1, but we add 1 to all indexes
379             // and use 0 as a sentinel value
380             set._indexes[value] = set._values.length;
381             return true;
382         } else {
383             return false;
384         }
385     }
386 
387     /**
388      * @dev Removes a value from a set. O(1).
389      *
390      * Returns true if the value was removed from the set, that is if it was
391      * present.
392      */
393     function _remove(Set storage set, bytes32 value) private returns (bool) {
394         // We read and store the value's index to prevent multiple reads from the same storage slot
395         uint256 valueIndex = set._indexes[value];
396 
397         if (valueIndex != 0) { // Equivalent to contains(set, value)
398             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
399             // the array, and then remove the last element (sometimes called as 'swap and pop').
400             // This modifies the order of the array, as noted in {at}.
401 
402             uint256 toDeleteIndex = valueIndex - 1;
403             uint256 lastIndex = set._values.length - 1;
404 
405             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
406             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
407 
408             bytes32 lastvalue = set._values[lastIndex];
409 
410             // Move the last value to the index where the value to delete is
411             set._values[toDeleteIndex] = lastvalue;
412             // Update the index for the moved value
413             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
414 
415             // Delete the slot where the moved value was stored
416             set._values.pop();
417 
418             // Delete the index for the deleted slot
419             delete set._indexes[value];
420 
421             return true;
422         } else {
423             return false;
424         }
425     }
426 
427     /**
428      * @dev Returns true if the value is in the set. O(1).
429      */
430     function _contains(Set storage set, bytes32 value) private view returns (bool) {
431         return set._indexes[value] != 0;
432     }
433 
434     /**
435      * @dev Returns the number of values on the set. O(1).
436      */
437     function _length(Set storage set) private view returns (uint256) {
438         return set._values.length;
439     }
440 
441    /**
442     * @dev Returns the value stored at position `index` in the set. O(1).
443     *
444     * Note that there are no guarantees on the ordering of values inside the
445     * array, and it may change when more values are added or removed.
446     *
447     * Requirements:
448     *
449     * - `index` must be strictly less than {length}.
450     */
451     function _at(Set storage set, uint256 index) private view returns (bytes32) {
452         require(set._values.length > index, "EnumerableSet: index out of bounds");
453         return set._values[index];
454     }
455 
456     // Bytes32Set
457 
458     struct Bytes32Set {
459         Set _inner;
460     }
461 
462     /**
463      * @dev Add a value to a set. O(1).
464      *
465      * Returns true if the value was added to the set, that is if it was not
466      * already present.
467      */
468     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
469         return _add(set._inner, value);
470     }
471 
472     /**
473      * @dev Removes a value from a set. O(1).
474      *
475      * Returns true if the value was removed from the set, that is if it was
476      * present.
477      */
478     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
479         return _remove(set._inner, value);
480     }
481 
482     /**
483      * @dev Returns true if the value is in the set. O(1).
484      */
485     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
486         return _contains(set._inner, value);
487     }
488 
489     /**
490      * @dev Returns the number of values in the set. O(1).
491      */
492     function length(Bytes32Set storage set) internal view returns (uint256) {
493         return _length(set._inner);
494     }
495 
496    /**
497     * @dev Returns the value stored at position `index` in the set. O(1).
498     *
499     * Note that there are no guarantees on the ordering of values inside the
500     * array, and it may change when more values are added or removed.
501     *
502     * Requirements:
503     *
504     * - `index` must be strictly less than {length}.
505     */
506     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
507         return _at(set._inner, index);
508     }
509 
510     // AddressSet
511 
512     struct AddressSet {
513         Set _inner;
514     }
515 
516     /**
517      * @dev Add a value to a set. O(1).
518      *
519      * Returns true if the value was added to the set, that is if it was not
520      * already present.
521      */
522     function add(AddressSet storage set, address value) internal returns (bool) {
523         return _add(set._inner, bytes32(uint256(uint160(value))));
524     }
525 
526     /**
527      * @dev Removes a value from a set. O(1).
528      *
529      * Returns true if the value was removed from the set, that is if it was
530      * present.
531      */
532     function remove(AddressSet storage set, address value) internal returns (bool) {
533         return _remove(set._inner, bytes32(uint256(uint160(value))));
534     }
535 
536     /**
537      * @dev Returns true if the value is in the set. O(1).
538      */
539     function contains(AddressSet storage set, address value) internal view returns (bool) {
540         return _contains(set._inner, bytes32(uint256(uint160(value))));
541     }
542 
543     /**
544      * @dev Returns the number of values in the set. O(1).
545      */
546     function length(AddressSet storage set) internal view returns (uint256) {
547         return _length(set._inner);
548     }
549 
550    /**
551     * @dev Returns the value stored at position `index` in the set. O(1).
552     *
553     * Note that there are no guarantees on the ordering of values inside the
554     * array, and it may change when more values are added or removed.
555     *
556     * Requirements:
557     *
558     * - `index` must be strictly less than {length}.
559     */
560     function at(AddressSet storage set, uint256 index) internal view returns (address) {
561         return address(uint160(uint256(_at(set._inner, index))));
562     }
563 
564 
565     // UintSet
566 
567     struct UintSet {
568         Set _inner;
569     }
570 
571     /**
572      * @dev Add a value to a set. O(1).
573      *
574      * Returns true if the value was added to the set, that is if it was not
575      * already present.
576      */
577     function add(UintSet storage set, uint256 value) internal returns (bool) {
578         return _add(set._inner, bytes32(value));
579     }
580 
581     /**
582      * @dev Removes a value from a set. O(1).
583      *
584      * Returns true if the value was removed from the set, that is if it was
585      * present.
586      */
587     function remove(UintSet storage set, uint256 value) internal returns (bool) {
588         return _remove(set._inner, bytes32(value));
589     }
590 
591     /**
592      * @dev Returns true if the value is in the set. O(1).
593      */
594     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
595         return _contains(set._inner, bytes32(value));
596     }
597 
598     /**
599      * @dev Returns the number of values on the set. O(1).
600      */
601     function length(UintSet storage set) internal view returns (uint256) {
602         return _length(set._inner);
603     }
604 
605    /**
606     * @dev Returns the value stored at position `index` in the set. O(1).
607     *
608     * Note that there are no guarantees on the ordering of values inside the
609     * array, and it may change when more values are added or removed.
610     *
611     * Requirements:
612     *
613     * - `index` must be strictly less than {length}.
614     */
615     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
616         return uint256(_at(set._inner, index));
617     }
618 }
619 
620 
621 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
622 
623 // SPDX-License-Identifier: MIT
624 
625 pragma solidity >=0.6.2 <0.8.0;
626 
627 /**
628  * @dev Collection of functions related to the address type
629  */
630 library Address {
631     /**
632      * @dev Returns true if `account` is a contract.
633      *
634      * [IMPORTANT]
635      * ====
636      * It is unsafe to assume that an address for which this function returns
637      * false is an externally-owned account (EOA) and not a contract.
638      *
639      * Among others, `isContract` will return false for the following
640      * types of addresses:
641      *
642      *  - an externally-owned account
643      *  - a contract in construction
644      *  - an address where a contract will be created
645      *  - an address where a contract lived, but was destroyed
646      * ====
647      */
648     function isContract(address account) internal view returns (bool) {
649         // This method relies on extcodesize, which returns 0 for contracts in
650         // construction, since the code is only stored at the end of the
651         // constructor execution.
652 
653         uint256 size;
654         // solhint-disable-next-line no-inline-assembly
655         assembly { size := extcodesize(account) }
656         return size > 0;
657     }
658 
659     /**
660      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
661      * `recipient`, forwarding all available gas and reverting on errors.
662      *
663      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
664      * of certain opcodes, possibly making contracts go over the 2300 gas limit
665      * imposed by `transfer`, making them unable to receive funds via
666      * `transfer`. {sendValue} removes this limitation.
667      *
668      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
669      *
670      * IMPORTANT: because control is transferred to `recipient`, care must be
671      * taken to not create reentrancy vulnerabilities. Consider using
672      * {ReentrancyGuard} or the
673      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
674      */
675     function sendValue(address payable recipient, uint256 amount) internal {
676         require(address(this).balance >= amount, "Address: insufficient balance");
677 
678         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
679         (bool success, ) = recipient.call{ value: amount }("");
680         require(success, "Address: unable to send value, recipient may have reverted");
681     }
682 
683     /**
684      * @dev Performs a Solidity function call using a low level `call`. A
685      * plain`call` is an unsafe replacement for a function call: use this
686      * function instead.
687      *
688      * If `target` reverts with a revert reason, it is bubbled up by this
689      * function (like regular Solidity function calls).
690      *
691      * Returns the raw returned data. To convert to the expected return value,
692      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
693      *
694      * Requirements:
695      *
696      * - `target` must be a contract.
697      * - calling `target` with `data` must not revert.
698      *
699      * _Available since v3.1._
700      */
701     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
702       return functionCall(target, data, "Address: low-level call failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
707      * `errorMessage` as a fallback revert reason when `target` reverts.
708      *
709      * _Available since v3.1._
710      */
711     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
712         return functionCallWithValue(target, data, 0, errorMessage);
713     }
714 
715     /**
716      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
717      * but also transferring `value` wei to `target`.
718      *
719      * Requirements:
720      *
721      * - the calling contract must have an ETH balance of at least `value`.
722      * - the called Solidity function must be `payable`.
723      *
724      * _Available since v3.1._
725      */
726     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
727         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
728     }
729 
730     /**
731      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
732      * with `errorMessage` as a fallback revert reason when `target` reverts.
733      *
734      * _Available since v3.1._
735      */
736     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
737         require(address(this).balance >= value, "Address: insufficient balance for call");
738         require(isContract(target), "Address: call to non-contract");
739 
740         // solhint-disable-next-line avoid-low-level-calls
741         (bool success, bytes memory returndata) = target.call{ value: value }(data);
742         return _verifyCallResult(success, returndata, errorMessage);
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
747      * but performing a static call.
748      *
749      * _Available since v3.3._
750      */
751     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
752         return functionStaticCall(target, data, "Address: low-level static call failed");
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
757      * but performing a static call.
758      *
759      * _Available since v3.3._
760      */
761     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
762         require(isContract(target), "Address: static call to non-contract");
763 
764         // solhint-disable-next-line avoid-low-level-calls
765         (bool success, bytes memory returndata) = target.staticcall(data);
766         return _verifyCallResult(success, returndata, errorMessage);
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
771      * but performing a delegate call.
772      *
773      * _Available since v3.4._
774      */
775     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
776         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
781      * but performing a delegate call.
782      *
783      * _Available since v3.4._
784      */
785     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
786         require(isContract(target), "Address: delegate call to non-contract");
787 
788         // solhint-disable-next-line avoid-low-level-calls
789         (bool success, bytes memory returndata) = target.delegatecall(data);
790         return _verifyCallResult(success, returndata, errorMessage);
791     }
792 
793     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
794         if (success) {
795             return returndata;
796         } else {
797             // Look for revert reason and bubble it up if present
798             if (returndata.length > 0) {
799                 // The easiest way to bubble the revert reason is using memory via assembly
800 
801                 // solhint-disable-next-line no-inline-assembly
802                 assembly {
803                     let returndata_size := mload(returndata)
804                     revert(add(32, returndata), returndata_size)
805                 }
806             } else {
807                 revert(errorMessage);
808             }
809         }
810     }
811 }
812 
813 
814 // File @openzeppelin/contracts/access/AccessControl.sol@v3.4.1
815 
816 // SPDX-License-Identifier: MIT
817 
818 pragma solidity >=0.6.0 <0.8.0;
819 
820 
821 
822 /**
823  * @dev Contract module that allows children to implement role-based access
824  * control mechanisms.
825  *
826  * Roles are referred to by their `bytes32` identifier. These should be exposed
827  * in the external API and be unique. The best way to achieve this is by
828  * using `public constant` hash digests:
829  *
830  * ```
831  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
832  * ```
833  *
834  * Roles can be used to represent a set of permissions. To restrict access to a
835  * function call, use {hasRole}:
836  *
837  * ```
838  * function foo() public {
839  *     require(hasRole(MY_ROLE, msg.sender));
840  *     ...
841  * }
842  * ```
843  *
844  * Roles can be granted and revoked dynamically via the {grantRole} and
845  * {revokeRole} functions. Each role has an associated admin role, and only
846  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
847  *
848  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
849  * that only accounts with this role will be able to grant or revoke other
850  * roles. More complex role relationships can be created by using
851  * {_setRoleAdmin}.
852  *
853  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
854  * grant and revoke this role. Extra precautions should be taken to secure
855  * accounts that have been granted it.
856  */
857 abstract contract AccessControl is Context {
858     using EnumerableSet for EnumerableSet.AddressSet;
859     using Address for address;
860 
861     struct RoleData {
862         EnumerableSet.AddressSet members;
863         bytes32 adminRole;
864     }
865 
866     mapping (bytes32 => RoleData) private _roles;
867 
868     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
869 
870     /**
871      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
872      *
873      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
874      * {RoleAdminChanged} not being emitted signaling this.
875      *
876      * _Available since v3.1._
877      */
878     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
879 
880     /**
881      * @dev Emitted when `account` is granted `role`.
882      *
883      * `sender` is the account that originated the contract call, an admin role
884      * bearer except when using {_setupRole}.
885      */
886     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
887 
888     /**
889      * @dev Emitted when `account` is revoked `role`.
890      *
891      * `sender` is the account that originated the contract call:
892      *   - if using `revokeRole`, it is the admin role bearer
893      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
894      */
895     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
896 
897     /**
898      * @dev Returns `true` if `account` has been granted `role`.
899      */
900     function hasRole(bytes32 role, address account) public view returns (bool) {
901         return _roles[role].members.contains(account);
902     }
903 
904     /**
905      * @dev Returns the number of accounts that have `role`. Can be used
906      * together with {getRoleMember} to enumerate all bearers of a role.
907      */
908     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
909         return _roles[role].members.length();
910     }
911 
912     /**
913      * @dev Returns one of the accounts that have `role`. `index` must be a
914      * value between 0 and {getRoleMemberCount}, non-inclusive.
915      *
916      * Role bearers are not sorted in any particular way, and their ordering may
917      * change at any point.
918      *
919      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
920      * you perform all queries on the same block. See the following
921      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
922      * for more information.
923      */
924     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
925         return _roles[role].members.at(index);
926     }
927 
928     /**
929      * @dev Returns the admin role that controls `role`. See {grantRole} and
930      * {revokeRole}.
931      *
932      * To change a role's admin, use {_setRoleAdmin}.
933      */
934     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
935         return _roles[role].adminRole;
936     }
937 
938     /**
939      * @dev Grants `role` to `account`.
940      *
941      * If `account` had not been already granted `role`, emits a {RoleGranted}
942      * event.
943      *
944      * Requirements:
945      *
946      * - the caller must have ``role``'s admin role.
947      */
948     function grantRole(bytes32 role, address account) public virtual {
949         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
950 
951         _grantRole(role, account);
952     }
953 
954     /**
955      * @dev Revokes `role` from `account`.
956      *
957      * If `account` had been granted `role`, emits a {RoleRevoked} event.
958      *
959      * Requirements:
960      *
961      * - the caller must have ``role``'s admin role.
962      */
963     function revokeRole(bytes32 role, address account) public virtual {
964         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
965 
966         _revokeRole(role, account);
967     }
968 
969     /**
970      * @dev Revokes `role` from the calling account.
971      *
972      * Roles are often managed via {grantRole} and {revokeRole}: this function's
973      * purpose is to provide a mechanism for accounts to lose their privileges
974      * if they are compromised (such as when a trusted device is misplaced).
975      *
976      * If the calling account had been granted `role`, emits a {RoleRevoked}
977      * event.
978      *
979      * Requirements:
980      *
981      * - the caller must be `account`.
982      */
983     function renounceRole(bytes32 role, address account) public virtual {
984         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
985 
986         _revokeRole(role, account);
987     }
988 
989     /**
990      * @dev Grants `role` to `account`.
991      *
992      * If `account` had not been already granted `role`, emits a {RoleGranted}
993      * event. Note that unlike {grantRole}, this function doesn't perform any
994      * checks on the calling account.
995      *
996      * [WARNING]
997      * ====
998      * This function should only be called from the constructor when setting
999      * up the initial roles for the system.
1000      *
1001      * Using this function in any other way is effectively circumventing the admin
1002      * system imposed by {AccessControl}.
1003      * ====
1004      */
1005     function _setupRole(bytes32 role, address account) internal virtual {
1006         _grantRole(role, account);
1007     }
1008 
1009     /**
1010      * @dev Sets `adminRole` as ``role``'s admin role.
1011      *
1012      * Emits a {RoleAdminChanged} event.
1013      */
1014     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1015         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1016         _roles[role].adminRole = adminRole;
1017     }
1018 
1019     function _grantRole(bytes32 role, address account) private {
1020         if (_roles[role].members.add(account)) {
1021             emit RoleGranted(role, account, _msgSender());
1022         }
1023     }
1024 
1025     function _revokeRole(bytes32 role, address account) private {
1026         if (_roles[role].members.remove(account)) {
1027             emit RoleRevoked(role, account, _msgSender());
1028         }
1029     }
1030 }
1031 
1032 
1033 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
1034 
1035 // SPDX-License-Identifier: MIT
1036 
1037 pragma solidity >=0.6.0 <0.8.0;
1038 
1039 /**
1040  * @dev Interface of the ERC20 standard as defined in the EIP.
1041  */
1042 interface IERC20 {
1043     /**
1044      * @dev Returns the amount of tokens in existence.
1045      */
1046     function totalSupply() external view returns (uint256);
1047 
1048     /**
1049      * @dev Returns the amount of tokens owned by `account`.
1050      */
1051     function balanceOf(address account) external view returns (uint256);
1052 
1053     /**
1054      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1055      *
1056      * Returns a boolean value indicating whether the operation succeeded.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function transfer(address recipient, uint256 amount) external returns (bool);
1061 
1062     /**
1063      * @dev Returns the remaining number of tokens that `spender` will be
1064      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1065      * zero by default.
1066      *
1067      * This value changes when {approve} or {transferFrom} are called.
1068      */
1069     function allowance(address owner, address spender) external view returns (uint256);
1070 
1071     /**
1072      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1073      *
1074      * Returns a boolean value indicating whether the operation succeeded.
1075      *
1076      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1077      * that someone may use both the old and the new allowance by unfortunate
1078      * transaction ordering. One possible solution to mitigate this race
1079      * condition is to first reduce the spender's allowance to 0 and set the
1080      * desired value afterwards:
1081      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1082      *
1083      * Emits an {Approval} event.
1084      */
1085     function approve(address spender, uint256 amount) external returns (bool);
1086 
1087     /**
1088      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1089      * allowance mechanism. `amount` is then deducted from the caller's
1090      * allowance.
1091      *
1092      * Returns a boolean value indicating whether the operation succeeded.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1097 
1098     /**
1099      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1100      * another (`to`).
1101      *
1102      * Note that `value` may be zero.
1103      */
1104     event Transfer(address indexed from, address indexed to, uint256 value);
1105 
1106     /**
1107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1108      * a call to {approve}. `value` is the new allowance.
1109      */
1110     event Approval(address indexed owner, address indexed spender, uint256 value);
1111 }
1112 
1113 
1114 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
1115 
1116 // SPDX-License-Identifier: MIT
1117 
1118 pragma solidity >=0.6.0 <0.8.0;
1119 
1120 
1121 
1122 /**
1123  * @title SafeERC20
1124  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1125  * contract returns false). Tokens that return no value (and instead revert or
1126  * throw on failure) are also supported, non-reverting calls are assumed to be
1127  * successful.
1128  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1129  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1130  */
1131 library SafeERC20 {
1132     using SafeMath for uint256;
1133     using Address for address;
1134 
1135     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1136         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1137     }
1138 
1139     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1140         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1141     }
1142 
1143     /**
1144      * @dev Deprecated. This function has issues similar to the ones found in
1145      * {IERC20-approve}, and its usage is discouraged.
1146      *
1147      * Whenever possible, use {safeIncreaseAllowance} and
1148      * {safeDecreaseAllowance} instead.
1149      */
1150     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1151         // safeApprove should only be called when setting an initial allowance,
1152         // or when resetting it to zero. To increase and decrease it, use
1153         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1154         // solhint-disable-next-line max-line-length
1155         require((value == 0) || (token.allowance(address(this), spender) == 0),
1156             "SafeERC20: approve from non-zero to non-zero allowance"
1157         );
1158         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1159     }
1160 
1161     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1162         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1163         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1164     }
1165 
1166     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1167         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1168         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1169     }
1170 
1171     /**
1172      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1173      * on the return value: the return value is optional (but if data is returned, it must not be false).
1174      * @param token The token targeted by the call.
1175      * @param data The call data (encoded using abi.encode or one of its variants).
1176      */
1177     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1178         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1179         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1180         // the target address contains contract code and also asserts for success in the low-level call.
1181 
1182         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1183         if (returndata.length > 0) { // Return data is optional
1184             // solhint-disable-next-line max-line-length
1185             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1186         }
1187     }
1188 }
1189 
1190 
1191 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1
1192 
1193 pragma solidity >=0.5.0;
1194 
1195 interface IUniswapV2Pair {
1196     event Approval(address indexed owner, address indexed spender, uint value);
1197     event Transfer(address indexed from, address indexed to, uint value);
1198 
1199     function name() external pure returns (string memory);
1200     function symbol() external pure returns (string memory);
1201     function decimals() external pure returns (uint8);
1202     function totalSupply() external view returns (uint);
1203     function balanceOf(address owner) external view returns (uint);
1204     function allowance(address owner, address spender) external view returns (uint);
1205 
1206     function approve(address spender, uint value) external returns (bool);
1207     function transfer(address to, uint value) external returns (bool);
1208     function transferFrom(address from, address to, uint value) external returns (bool);
1209 
1210     function DOMAIN_SEPARATOR() external view returns (bytes32);
1211     function PERMIT_TYPEHASH() external pure returns (bytes32);
1212     function nonces(address owner) external view returns (uint);
1213 
1214     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1215 
1216     event Mint(address indexed sender, uint amount0, uint amount1);
1217     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1218     event Swap(
1219         address indexed sender,
1220         uint amount0In,
1221         uint amount1In,
1222         uint amount0Out,
1223         uint amount1Out,
1224         address indexed to
1225     );
1226     event Sync(uint112 reserve0, uint112 reserve1);
1227 
1228     function MINIMUM_LIQUIDITY() external pure returns (uint);
1229     function factory() external view returns (address);
1230     function token0() external view returns (address);
1231     function token1() external view returns (address);
1232     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1233     function price0CumulativeLast() external view returns (uint);
1234     function price1CumulativeLast() external view returns (uint);
1235     function kLast() external view returns (uint);
1236 
1237     function mint(address to) external returns (uint liquidity);
1238     function burn(address to) external returns (uint amount0, uint amount1);
1239     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1240     function skim(address to) external;
1241     function sync() external;
1242 
1243     function initialize(address, address) external;
1244 }
1245 
1246 
1247 // File contracts/oracle/IOracle.sol
1248 
1249 /*
1250     Copyright 2020 Cook Finance Devs, based on the works of the Cook Finance Squad
1251 
1252     Licensed under the Apache License, Version 2.0 (the "License");
1253     you may not use this file except in compliance with the License.
1254     You may obtain a copy of the License at
1255 
1256     http://www.apache.org/licenses/LICENSE-2.0
1257 
1258     Unless required by applicable law or agreed to in writing, software
1259     distributed under the License is distributed on an "AS IS" BASIS,
1260     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1261     See the License for the specific language governing permissions and
1262     limitations under the License.
1263 */
1264 
1265 pragma solidity ^0.6.2;
1266 pragma experimental ABIEncoderV2;
1267 
1268 abstract contract IOracle {
1269     function update() external virtual returns (uint256);
1270 
1271     function pairAddress() external view virtual returns (address);
1272 }
1273 
1274 
1275 // File contracts/oracle/IWETH.sol
1276 
1277 pragma solidity ^0.6.2;
1278 
1279 abstract contract IWETH {
1280     function deposit() public payable virtual;
1281 }
1282 
1283 
1284 // File contracts/oracle/IPriceConsumerV3.sol
1285 
1286 pragma solidity ^0.6.2;
1287 
1288 abstract contract IPriceConsumerV3 {
1289     function getLatestPrice() public view virtual returns (int256);
1290 }
1291 
1292 
1293 // File contracts/core/IPool.sol
1294 
1295 /*
1296     Copyright 2020 Cook Finance Devs, based on the works of the Cook Finance Squad
1297 
1298     Licensed under the Apache License, Version 2.0 (the "License");
1299     you may not use this file except in compliance with the License.
1300     You may obtain a copy of the License at
1301 
1302     http://www.apache.org/licenses/LICENSE-2.0
1303 
1304     Unless required by applicable law or agreed to in writing, software
1305     distributed under the License is distributed on an "AS IS" BASIS,
1306     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1307     See the License for the specific language governing permissions and
1308     limitations under the License.
1309 */
1310 
1311 pragma solidity ^0.6.2;
1312 
1313 abstract contract IPool {
1314     function stake(uint256 value) external virtual;
1315 
1316     function unstake(uint256 value) external virtual;
1317 
1318     function harvest(uint256 value) public virtual;
1319 
1320     function claim(uint256 value) public virtual;
1321 
1322     function zapStake(uint256 value, address userAddress) external virtual;
1323 }
1324 
1325 
1326 // File contracts/external/UniswapV2Library.sol
1327 
1328 pragma solidity >=0.5.0;
1329 
1330 
1331 library UniswapV2Library {
1332     using SafeMath for uint256;
1333 
1334     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1335     function sortTokens(address tokenA, address tokenB)
1336         internal
1337         pure
1338         returns (address token0, address token1)
1339     {
1340         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
1341         (token0, token1) = tokenA < tokenB
1342             ? (tokenA, tokenB)
1343             : (tokenB, tokenA);
1344         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
1345     }
1346 
1347     // calculates the CREATE2 address for a pair without making any external calls
1348     function pairFor(
1349         address factory,
1350         address tokenA,
1351         address tokenB
1352     ) internal pure returns (address pair) {
1353         (address token0, address token1) = sortTokens(tokenA, tokenB);
1354         pair = address(
1355             uint256(
1356                 keccak256(
1357                     abi.encodePacked(
1358                         hex"ff",
1359                         factory,
1360                         keccak256(abi.encodePacked(token0, token1)),
1361                         hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f" // init code hash
1362                     )
1363                 )
1364             )
1365         );
1366     }
1367 
1368     // fetches and sorts the reserves for a pair
1369     function getReserves(
1370         address factory,
1371         address tokenA,
1372         address tokenB
1373     ) internal view returns (uint256 reserveA, uint256 reserveB) {
1374         (address token0, ) = sortTokens(tokenA, tokenB);
1375         (uint256 reserve0, uint256 reserve1, ) =
1376             IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1377         (reserveA, reserveB) = tokenA == token0
1378             ? (reserve0, reserve1)
1379             : (reserve1, reserve0);
1380     }
1381 
1382     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1383     function quote(
1384         uint256 amountA,
1385         uint256 reserveA,
1386         uint256 reserveB
1387     ) internal pure returns (uint256 amountB) {
1388         require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
1389         require(
1390             reserveA > 0 && reserveB > 0,
1391             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
1392         );
1393         amountB = amountA.mul(reserveB) / reserveA;
1394     }
1395 
1396     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1397     function getAmountOut(
1398         uint256 amountIn,
1399         uint256 reserveIn,
1400         uint256 reserveOut
1401     ) internal pure returns (uint256 amountOut) {
1402         require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
1403         require(
1404             reserveIn > 0 && reserveOut > 0,
1405             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
1406         );
1407         uint256 amountInWithFee = amountIn.mul(997);
1408         uint256 numerator = amountInWithFee.mul(reserveOut);
1409         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
1410         amountOut = numerator / denominator;
1411     }
1412 
1413     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1414     function getAmountIn(
1415         uint256 amountOut,
1416         uint256 reserveIn,
1417         uint256 reserveOut
1418     ) internal pure returns (uint256 amountIn) {
1419         require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
1420         require(
1421             reserveIn > 0 && reserveOut > 0,
1422             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
1423         );
1424         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
1425         uint256 denominator = reserveOut.sub(amountOut).mul(997);
1426         amountIn = (numerator / denominator).add(1);
1427     }
1428 
1429     // performs chained getAmountOut calculations on any number of pairs
1430     function getAmountsOut(
1431         address factory,
1432         uint256 amountIn,
1433         address[] memory path
1434     ) internal view returns (uint256[] memory amounts) {
1435         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
1436         amounts = new uint256[](path.length);
1437         amounts[0] = amountIn;
1438         for (uint256 i; i < path.length - 1; i++) {
1439             (uint256 reserveIn, uint256 reserveOut) =
1440                 getReserves(factory, path[i], path[i + 1]);
1441             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1442         }
1443     }
1444 
1445     // performs chained getAmountIn calculations on any number of pairs
1446     function getAmountsIn(
1447         address factory,
1448         uint256 amountOut,
1449         address[] memory path
1450     ) internal view returns (uint256[] memory amounts) {
1451         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
1452         amounts = new uint256[](path.length);
1453         amounts[amounts.length - 1] = amountOut;
1454         for (uint256 i = path.length - 1; i > 0; i--) {
1455             (uint256 reserveIn, uint256 reserveOut) =
1456                 getReserves(factory, path[i - 1], path[i]);
1457             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1458         }
1459     }
1460 }
1461 
1462 
1463 // File contracts/core/CookDistribution.sol
1464 
1465 pragma solidity ^0.6.2;
1466 
1467 
1468 
1469 
1470 
1471 
1472 
1473 
1474 
1475 
1476 /**
1477  * @title TokenVesting
1478  * @dev A token holder contract that can release its token balance gradually like a
1479  * typical vesting scheme, with a cliff and vesting period.
1480  */
1481 contract CookDistribution is Ownable, AccessControl {
1482     using SafeMath for uint256;
1483     using SafeERC20 for IERC20;
1484 
1485     event AllocationRegistered(address indexed beneficiary, uint256 amount);
1486     event TokensWithdrawal(address userAddress, uint256 amount);
1487 
1488     struct Allocation {
1489         uint256 amount;
1490         uint256 released;
1491         bool blackListed;
1492         bool isRegistered;
1493     }
1494     // beneficiary of tokens after they are released
1495     mapping(address => Allocation) private _beneficiaryAllocations;
1496     // oracle price data (dayNumber => price)
1497     mapping(uint256 => uint256) private _oraclePriceFeed;
1498     // all beneficiary address1
1499     address[] private _allBeneficiary;
1500     // vesting start time unix
1501     uint256 public _start;
1502     // vesting duration in day
1503     uint256 public _duration;
1504     // vesting interval
1505     uint32 public _interval;
1506     // released percentage triggered by price, should divided by 100
1507     uint256 public _advancePercentage;
1508     // last released percentage triggered date in dayNumber
1509     uint256 public _lastPriceUnlockDay;
1510     // next step to unlock
1511     uint32 public _nextPriceUnlockStep;
1512     // Max step can be moved
1513     uint32 public _maxPriceUnlockMoveStep;
1514     IERC20 private _token;
1515     IOracle private _oracle;
1516     IPriceConsumerV3 private _priceConsumer;
1517 
1518     // Date-related constants for sanity-checking dates to reject obvious erroneous inputs
1519     // SECONDS_PER_DAY = 30 for test only
1520     uint32 private constant SECONDS_PER_DAY = 86400; /* 86400 seconds in a day */
1521 
1522     uint256[] private _priceKey;
1523     uint256[] private _percentageValue;
1524     mapping(uint256 => uint256) private _pricePercentageMapping;
1525 
1526     // Fields for Admin
1527     // stop everyone from claiming/zapping cook token due to emgergency
1528     bool public _pauseClaim;
1529 
1530     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER");
1531     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
1532 
1533     constructor(
1534         IERC20 token_,
1535         address[] memory beneficiaries_,
1536         uint256[] memory amounts_,
1537         uint256 start, // in unix
1538         uint256 duration, // in day
1539         uint32 interval, // in day
1540         address oracle_,
1541         address priceConsumer_
1542     ) public {
1543         // init beneficiaries
1544         for (uint256 i = 0; i < beneficiaries_.length; i++) {
1545             // store all beneficiaries address
1546             _allBeneficiary.push(beneficiaries_[i]);
1547             // Add new allocation to beneficiaryAllocations
1548             _beneficiaryAllocations[beneficiaries_[i]] = Allocation(amounts_[i], 0, false, true);
1549             emit AllocationRegistered(beneficiaries_[i], amounts_[i]);
1550         }
1551 
1552         _token = token_;
1553         _duration = duration;
1554         _start = start;
1555         _interval = interval;
1556         // init release percentage is 1%
1557         _advancePercentage = 1;
1558         _oracle = IOracle(oracle_);
1559         _priceConsumer = IPriceConsumerV3(priceConsumer_);
1560         _lastPriceUnlockDay = 0;
1561         _nextPriceUnlockStep = 0;
1562         _maxPriceUnlockMoveStep = 1;
1563         _pauseClaim = false;
1564 
1565         // init price percentage
1566         _priceKey = [500000, 800000, 1100000, 1400000, 1700000, 2000000, 2300000, 2600000, 2900000, 3200000, 3500000, 3800000, 4100000,
1567                     4400000, 4700000, 5000000, 5300000, 5600000, 5900000, 6200000, 6500000];
1568         _percentageValue = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100];
1569 
1570         for (uint256 i = 0; i < _priceKey.length; i++) {
1571             _pricePercentageMapping[_priceKey[i]] = _percentageValue[i];
1572         }
1573 
1574         // Make the deployer defaul admin role and manager role
1575         _setupRole(MANAGER_ROLE, msg.sender);
1576         _setupRole(ADMIN_ROLE, msg.sender);
1577         _setRoleAdmin(MANAGER_ROLE, ADMIN_ROLE);
1578     }
1579 
1580     fallback() external payable {
1581         revert();
1582     }
1583 
1584     function setStart(uint256 start) public {
1585         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1586         _start = start;
1587     }
1588 
1589     function setDuration(uint256 duration) public {
1590         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1591         _duration = duration;
1592     }
1593 
1594     function setInvertal(uint32 interval) public {
1595         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1596         _interval = interval;
1597     }
1598 
1599     function setAdvancePercentage(uint256 advancePercentage) public {
1600         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1601         _advancePercentage = advancePercentage;
1602     }
1603 
1604     function getRegisteredStatus(address userAddress) public view returns (bool) {
1605         return _beneficiaryAllocations[userAddress].isRegistered;
1606     }
1607 
1608     function getUserVestingAmount(address userAddress) public view returns (uint256) {
1609         return _beneficiaryAllocations[userAddress].amount;
1610     }
1611 
1612     function getUserAvailableAmount(address userAddress, uint256 onDayOrToday) public view returns (uint256) {
1613         uint256 avalible = _getVestedAmount(userAddress, onDayOrToday).sub(_beneficiaryAllocations[userAddress].released);
1614         return avalible;
1615     }
1616 
1617     function getUserVestedAmount(address userAddress, uint256 onDayOrToday)
1618         public
1619         view
1620         returns (uint256 amountVested)
1621     {
1622         return _getVestedAmount(userAddress, onDayOrToday);
1623     }
1624 
1625     /**
1626      * @dev returns the day number of the current day, in days since the UNIX epoch.
1627      */
1628     function today() public view virtual returns (uint256 dayNumber) {
1629         return uint256(block.timestamp / SECONDS_PER_DAY);
1630     }
1631 
1632     function startDay() public view returns (uint256) {
1633         return uint256(_start / SECONDS_PER_DAY);
1634     }
1635 
1636     function _effectiveDay(uint256 onDayOrToday) public view returns (uint256) {
1637         return onDayOrToday == 0 ? today() : onDayOrToday;
1638     }
1639 
1640     function _getVestedAmount(address userAddress, uint256 onDayOrToday) internal view returns (uint256) {
1641         uint256 onDay = _effectiveDay(onDayOrToday); // day
1642 
1643         // If after end of vesting, then the vested amount is total amount.
1644         if (onDay >= (startDay() + _duration)) {
1645             return _beneficiaryAllocations[userAddress].amount;
1646         }
1647         // If it's before the vesting then the vested amount is zero.
1648         else if (onDay < startDay()) {
1649             // All are vested (none are not vested)
1650             return 0;
1651         }
1652         // Otherwise a fractional amount is vested.
1653         else {
1654             // Compute the exact number of days vested.
1655             uint256 daysVested = onDay - startDay();
1656             // Adjust result rounding down to take into consideration the interval.
1657             uint256 effectiveDaysVested = (daysVested / _interval) * _interval;
1658             uint256 vested = 0;
1659 
1660             if (
1661                 _beneficiaryAllocations[userAddress]
1662                     .amount
1663                     .mul(effectiveDaysVested)
1664                     .div(_duration) >
1665                 _beneficiaryAllocations[userAddress]
1666                     .amount
1667                     .mul(_advancePercentage)
1668                     .div(100)
1669             ) {
1670                 // no price based percentage > date based percentage
1671                 vested = _beneficiaryAllocations[userAddress]
1672                     .amount
1673                     .mul(effectiveDaysVested)
1674                     .div(_duration);
1675             } else {
1676                 // price based percentage > date based percentage
1677                 vested = _beneficiaryAllocations[userAddress]
1678                     .amount
1679                     .mul(_advancePercentage)
1680                     .div(100);
1681             }
1682 
1683             return vested;
1684         }
1685     }
1686 
1687     /**
1688     withdraw function
1689    */
1690     function withdraw(uint256 withdrawAmount) public {
1691         address userAddress = msg.sender;
1692         require(_beneficiaryAllocations[userAddress].blackListed == false, "You're blacklisted.");
1693 
1694         require(_pauseClaim == false, "Not claimable due to emgergency");
1695 
1696         require(getUserAvailableAmount(userAddress, today()) >= withdrawAmount, "insufficient avalible cook balance");
1697 
1698         _beneficiaryAllocations[userAddress].released = _beneficiaryAllocations[userAddress].released.add(withdrawAmount);
1699 
1700         _token.safeTransfer(userAddress, withdrawAmount);
1701 
1702         emit TokensWithdrawal(userAddress, withdrawAmount);
1703     }
1704 
1705     function _calWethAmountToPairCook(uint256 cookAmount) internal returns (uint256, address) {
1706         // get pair address
1707         IUniswapV2Pair lpPair = IUniswapV2Pair(_oracle.pairAddress());
1708         uint256 reserve0;
1709         uint256 reserve1;
1710         address weth;
1711 
1712         if (lpPair.token0() == address(_token)) {
1713             (reserve0, reserve1, ) = lpPair.getReserves();
1714             weth = lpPair.token1();
1715         } else {
1716             (reserve1, reserve0, ) = lpPair.getReserves();
1717             weth = lpPair.token0();
1718         }
1719 
1720         uint256 wethAmount =
1721             (reserve0 == 0 && reserve1 == 0)
1722                 ? cookAmount
1723                 : UniswapV2Library.quote(cookAmount, reserve0, reserve1);
1724 
1725         return (wethAmount, weth);
1726     }
1727 
1728     function zapLP(uint256 cookAmount, address poolAddress) external {
1729         _zapLP(cookAmount, poolAddress, false);
1730     }
1731 
1732     function _zapLP(uint256 cookAmount, address poolAddress, bool isWithEth) internal {
1733         address userAddress = msg.sender;
1734         _checkValidZap(userAddress, cookAmount);
1735 
1736         uint256 newUniv2 = 0;
1737 
1738         (, newUniv2) = addLiquidity(cookAmount);
1739 
1740         IERC20(_oracle.pairAddress()).approve(poolAddress, newUniv2);
1741 
1742         IPool(poolAddress).zapStake(newUniv2, userAddress);
1743     }
1744 
1745     function _checkValidZap(address userAddress, uint256 cookAmount) internal {
1746         require(_beneficiaryAllocations[userAddress].isRegistered == true, "Only registered address.");
1747         require(_beneficiaryAllocations[userAddress].blackListed == false, "You're blacklisted.");
1748         require(_pauseClaim == false, "Cook token can not be zap.");
1749         require(cookAmount > 0, "zero zap amount");
1750         require(getUserAvailableAmount(userAddress, today()) >= cookAmount, "insufficient avalible cook balance");
1751 
1752         _beneficiaryAllocations[userAddress].released = _beneficiaryAllocations[userAddress].released.add(cookAmount);
1753     }
1754 
1755     function addLiquidity(uint256 cookAmount) internal returns (uint256, uint256) {
1756         // get pair address
1757         (uint256 wethAmount, ) = _calWethAmountToPairCook(cookAmount);
1758         _token.safeTransfer(_oracle.pairAddress(), cookAmount);
1759 
1760         IUniswapV2Pair lpPair = IUniswapV2Pair(_oracle.pairAddress());
1761         if (lpPair.token0() == address(_token)) {
1762             // token0 == cook, token1 == weth
1763             require(IERC20(lpPair.token1()).balanceOf(msg.sender) >= wethAmount, "insufficient weth balance");
1764             require(IERC20(lpPair.token1()).allowance(msg.sender, address(this)) >= wethAmount, "insufficient weth allowance");
1765             IERC20(lpPair.token1()).safeTransferFrom(
1766                 msg.sender,
1767                 _oracle.pairAddress(),
1768                 wethAmount
1769             );
1770         } else if (lpPair.token1() == address(_token)) {
1771             // token0 == weth, token1 == cook
1772             require(IERC20(lpPair.token0()).balanceOf(msg.sender) >= wethAmount, "insufficient weth balance");
1773             require(IERC20(lpPair.token0()).allowance(msg.sender, address(this)) >= wethAmount, "insufficient weth allowance");
1774             IERC20(lpPair.token0()).safeTransferFrom(msg.sender, _oracle.pairAddress(), wethAmount);
1775         }
1776 
1777         return (wethAmount, lpPair.mint(address(this)));
1778     }
1779 
1780     // Zap into Cook staking pool functions
1781     function zapCook(uint256 cookAmount, address cookPoolAddress) external {
1782         address userAddress = msg.sender;
1783         _checkValidZap(userAddress, cookAmount);
1784         IERC20(address(_token)).approve(cookPoolAddress, cookAmount);
1785         IPool(cookPoolAddress).zapStake(cookAmount, userAddress);
1786     }
1787 
1788     // Admin Functions
1789     function setPriceBasedMaxStep(uint32 newMaxPriceBasedStep) public {
1790         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1791         _maxPriceUnlockMoveStep = newMaxPriceBasedStep;
1792     }
1793 
1794     /**
1795      * add adddress with allocation
1796      */
1797     function addAddressWithAllocation(address beneficiaryAddress, uint256 amount, uint256 release) public  {
1798         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1799         require(_beneficiaryAllocations[beneficiaryAddress].isRegistered == false, "The address exisits.");
1800         _beneficiaryAllocations[beneficiaryAddress].isRegistered = true;
1801         _beneficiaryAllocations[beneficiaryAddress] = Allocation( amount, release, false, true
1802         );
1803 
1804         emit AllocationRegistered(beneficiaryAddress, amount);
1805     }
1806 
1807     /**
1808      * Add multiple address with multiple allocations
1809      */
1810     function addMultipleAddressWithAllocations(address[] memory beneficiaryAddresses, uint256[] memory amounts, uint256[] memory releases) public {
1811         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1812 
1813         require(beneficiaryAddresses.length > 0 && amounts.length > 0 && beneficiaryAddresses.length == amounts.length, "Inconsistent length input");
1814 
1815         for (uint256 i = 0; i < beneficiaryAddresses.length; i++) {
1816             require(_beneficiaryAllocations[beneficiaryAddresses[i]].isRegistered == false, "The address exisits.");
1817             _beneficiaryAllocations[beneficiaryAddresses[i]].isRegistered = true;
1818             _beneficiaryAllocations[beneficiaryAddresses[i]] = Allocation(amounts[i], releases[i], false, true);
1819 
1820             emit AllocationRegistered(beneficiaryAddresses[i], amounts[i]);
1821         }
1822     }
1823 
1824     function getTotalAvailable() public view returns (uint256) {uint256 totalAvailable = 0;
1825         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1826 
1827         for (uint256 i = 0; i < _allBeneficiary.length; ++i) {
1828             totalAvailable += getUserAvailableAmount(_allBeneficiary[i], today());
1829         }
1830 
1831         return totalAvailable;
1832     }
1833 
1834     function getLatestSevenSMA() public view returns (uint256) {
1835         // 7 day sma
1836         uint256 priceSum = uint256(0);
1837         uint256 priceCount = uint256(0);
1838         for (uint32 i = 0; i < 7; ++i) {
1839             if (_oraclePriceFeed[today() - i] != 0) {
1840                 priceSum = priceSum + _oraclePriceFeed[today() - i];
1841                 priceCount += 1;
1842             }
1843         }
1844 
1845         uint256 sevenSMA = 0;
1846         if (priceCount == 7) {
1847             sevenSMA = priceSum.div(priceCount);
1848         }
1849         return sevenSMA;
1850     }
1851 
1852     function updatePriceFeed() public {
1853         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1854 
1855         // oracle capture -> 900000000000000000 -> 1 cook = 0.9 ETH
1856         uint256 cookPrice = _oracle.update();
1857 
1858         // ETH/USD capture -> 127164849196 -> 1ETH = 1271.64USD
1859         uint256 ethPrice = uint256(_priceConsumer.getLatestPrice());
1860 
1861         uint256 price = cookPrice.mul(ethPrice).div(10**18);
1862 
1863         // update price to _oraclePriceFeed
1864         _oraclePriceFeed[today()] = price;
1865 
1866         if (today() >= _lastPriceUnlockDay.add(7)) {
1867             // 7 day sma
1868             uint256 sevenSMA = getLatestSevenSMA();
1869             uint256 priceRef = 0;
1870 
1871             for (uint32 i = 0; i < _priceKey.length; ++i) {
1872                 if (sevenSMA >= _priceKey[i]) {
1873                     priceRef = _pricePercentageMapping[_priceKey[i]];
1874                 }
1875             }
1876             // no lower action if the price drop after price-based unlock
1877             if (priceRef > _advancePercentage) {
1878                 // guard _nextPriceUnlockStep exceed
1879                 if (_nextPriceUnlockStep >= _percentageValue.length) {
1880                     _nextPriceUnlockStep = uint32(_percentageValue.length - 1);
1881                 }
1882                 // update _advancePercentage to nextStep percentage
1883                 _advancePercentage = _pricePercentageMapping[
1884                     _priceKey[_nextPriceUnlockStep]
1885                 ];
1886                 // update nextStep value
1887                 _nextPriceUnlockStep =
1888                     _nextPriceUnlockStep +
1889                     _maxPriceUnlockMoveStep;
1890                 // update lastUnlcokDay
1891                 _lastPriceUnlockDay = today();
1892             }
1893         }
1894     }
1895 
1896     // Put an evil address into blacklist
1897     function blacklistAddress(address userAddress) public {
1898         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1899         _beneficiaryAllocations[userAddress].blackListed = true;
1900     }
1901 
1902     //Remove an address from blacklist
1903     function removeAddressFromBlacklist(address userAddress) public {
1904         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1905         _beneficiaryAllocations[userAddress].blackListed = false;
1906     }
1907 
1908     // Pause all claim due to emergency
1909     function pauseClaim() public {
1910         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1911         _pauseClaim = true;
1912     }
1913 
1914     // resume cliamable
1915     function resumeCliam() public {
1916         require(hasRole(MANAGER_ROLE, msg.sender), "only manager");
1917         _pauseClaim = false;
1918     }
1919 
1920     // admin emergency to transfer token to owner
1921     function emergencyWithdraw(uint256 amount) public onlyOwner {
1922         _token.safeTransfer(msg.sender, amount);
1923     }
1924 
1925     function getManagerRole() public returns (bytes32) {
1926         return MANAGER_ROLE;
1927     }
1928 }