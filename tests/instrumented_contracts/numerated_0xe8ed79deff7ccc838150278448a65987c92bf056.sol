1 // File: openzeppelin-solidity/contracts/utils/structs/EnumerableSet.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
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
172         unchecked {
173             require(b <= a, errorMessage);
174             return a - b;
175         }
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
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
195         unchecked {
196             require(b > 0, errorMessage);
197             return a / b;
198         }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         unchecked {
218             require(b > 0, errorMessage);
219             return a % b;
220         }
221     }
222 }
223 
224 // File: openzeppelin-solidity/contracts/utils/Context.sol
225 
226 pragma solidity ^0.8.0;
227 
228 /*
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 abstract contract Context {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes calldata) {
244         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
245         return msg.data;
246     }
247 }
248 
249 // File: openzeppelin-solidity/contracts/access/Ownable.sol
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @dev Contract module which provides a basic access control mechanism, where
255  * there is an account (an owner) that can be granted exclusive access to
256  * specific functions.
257  *
258  * By default, the owner account will be the one that deploys the contract. This
259  * can later be changed with {transferOwnership}.
260  *
261  * This module is used through inheritance. It will make available the modifier
262  * `onlyOwner`, which can be applied to your functions to restrict their use to
263  * the owner.
264  */
265 abstract contract Ownable is Context {
266     address private _owner;
267 
268     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
269 
270     /**
271      * @dev Initializes the contract setting the deployer as the initial owner.
272      */
273     constructor () {
274         address msgSender = _msgSender();
275         _owner = msgSender;
276         emit OwnershipTransferred(address(0), msgSender);
277     }
278 
279     /**
280      * @dev Returns the address of the current owner.
281      */
282     function owner() public view virtual returns (address) {
283         return _owner;
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the owner.
288      */
289     modifier onlyOwner() {
290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
291         _;
292     }
293 
294     /**
295      * @dev Leaves the contract without owner. It will not be possible to call
296      * `onlyOwner` functions anymore. Can only be called by the current owner.
297      *
298      * NOTE: Renouncing ownership will leave the contract without an owner,
299      * thereby removing any functionality that is only available to the owner.
300      */
301     function renounceOwnership() public virtual onlyOwner {
302         emit OwnershipTransferred(_owner, address(0));
303         _owner = address(0);
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Can only be called by the current owner.
309      */
310     function transferOwnership(address newOwner) public virtual onlyOwner {
311         require(newOwner != address(0), "Ownable: new owner is the zero address");
312         emit OwnershipTransferred(_owner, newOwner);
313         _owner = newOwner;
314     }
315 }
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Library for managing
321  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
322  * types.
323  *
324  * Sets have the following properties:
325  *
326  * - Elements are added, removed, and checked for existence in constant time
327  * (O(1)).
328  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
329  *
330  * ```
331  * contract Example {
332  *     // Add the library methods
333  *     using EnumerableSet for EnumerableSet.AddressSet;
334  *
335  *     // Declare a set state variable
336  *     EnumerableSet.AddressSet private mySet;
337  * }
338  * ```
339  *
340  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
341  * and `uint256` (`UintSet`) are supported.
342  */
343 library EnumerableSet {
344     // To implement this library for multiple types with as little code
345     // repetition as possible, we write it in terms of a generic Set type with
346     // bytes32 values.
347     // The Set implementation uses private functions, and user-facing
348     // implementations (such as AddressSet) are just wrappers around the
349     // underlying Set.
350     // This means that we can only create new EnumerableSets for types that fit
351     // in bytes32.
352 
353     struct Set {
354         // Storage of set values
355         bytes32[] _values;
356 
357         // Position of the value in the `values` array, plus 1 because index 0
358         // means a value is not in the set.
359         mapping (bytes32 => uint256) _indexes;
360     }
361 
362     /**
363      * @dev Add a value to a set. O(1).
364      *
365      * Returns true if the value was added to the set, that is if it was not
366      * already present.
367      */
368     function _add(Set storage set, bytes32 value) private returns (bool) {
369         if (!_contains(set, value)) {
370             set._values.push(value);
371             // The value is stored at length-1, but we add 1 to all indexes
372             // and use 0 as a sentinel value
373             set._indexes[value] = set._values.length;
374             return true;
375         } else {
376             return false;
377         }
378     }
379 
380     /**
381      * @dev Removes a value from a set. O(1).
382      *
383      * Returns true if the value was removed from the set, that is if it was
384      * present.
385      */
386     function _remove(Set storage set, bytes32 value) private returns (bool) {
387         // We read and store the value's index to prevent multiple reads from the same storage slot
388         uint256 valueIndex = set._indexes[value];
389 
390         if (valueIndex != 0) { // Equivalent to contains(set, value)
391             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
392             // the array, and then remove the last element (sometimes called as 'swap and pop').
393             // This modifies the order of the array, as noted in {at}.
394 
395             uint256 toDeleteIndex = valueIndex - 1;
396             uint256 lastIndex = set._values.length - 1;
397 
398             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
399             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
400 
401             bytes32 lastvalue = set._values[lastIndex];
402 
403             // Move the last value to the index where the value to delete is
404             set._values[toDeleteIndex] = lastvalue;
405             // Update the index for the moved value
406             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
407 
408             // Delete the slot where the moved value was stored
409             set._values.pop();
410 
411             // Delete the index for the deleted slot
412             delete set._indexes[value];
413 
414             return true;
415         } else {
416             return false;
417         }
418     }
419 
420     /**
421      * @dev Returns true if the value is in the set. O(1).
422      */
423     function _contains(Set storage set, bytes32 value) private view returns (bool) {
424         return set._indexes[value] != 0;
425     }
426 
427     /**
428      * @dev Returns the number of values on the set. O(1).
429      */
430     function _length(Set storage set) private view returns (uint256) {
431         return set._values.length;
432     }
433 
434    /**
435     * @dev Returns the value stored at position `index` in the set. O(1).
436     *
437     * Note that there are no guarantees on the ordering of values inside the
438     * array, and it may change when more values are added or removed.
439     *
440     * Requirements:
441     *
442     * - `index` must be strictly less than {length}.
443     */
444     function _at(Set storage set, uint256 index) private view returns (bytes32) {
445         require(set._values.length > index, "EnumerableSet: index out of bounds");
446         return set._values[index];
447     }
448 
449     // Bytes32Set
450 
451     struct Bytes32Set {
452         Set _inner;
453     }
454 
455     /**
456      * @dev Add a value to a set. O(1).
457      *
458      * Returns true if the value was added to the set, that is if it was not
459      * already present.
460      */
461     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
462         return _add(set._inner, value);
463     }
464 
465     /**
466      * @dev Removes a value from a set. O(1).
467      *
468      * Returns true if the value was removed from the set, that is if it was
469      * present.
470      */
471     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
472         return _remove(set._inner, value);
473     }
474 
475     /**
476      * @dev Returns true if the value is in the set. O(1).
477      */
478     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
479         return _contains(set._inner, value);
480     }
481 
482     /**
483      * @dev Returns the number of values in the set. O(1).
484      */
485     function length(Bytes32Set storage set) internal view returns (uint256) {
486         return _length(set._inner);
487     }
488 
489    /**
490     * @dev Returns the value stored at position `index` in the set. O(1).
491     *
492     * Note that there are no guarantees on the ordering of values inside the
493     * array, and it may change when more values are added or removed.
494     *
495     * Requirements:
496     *
497     * - `index` must be strictly less than {length}.
498     */
499     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
500         return _at(set._inner, index);
501     }
502 
503     // AddressSet
504 
505     struct AddressSet {
506         Set _inner;
507     }
508 
509     /**
510      * @dev Add a value to a set. O(1).
511      *
512      * Returns true if the value was added to the set, that is if it was not
513      * already present.
514      */
515     function add(AddressSet storage set, address value) internal returns (bool) {
516         return _add(set._inner, bytes32(uint256(uint160(value))));
517     }
518 
519     /**
520      * @dev Removes a value from a set. O(1).
521      *
522      * Returns true if the value was removed from the set, that is if it was
523      * present.
524      */
525     function remove(AddressSet storage set, address value) internal returns (bool) {
526         return _remove(set._inner, bytes32(uint256(uint160(value))));
527     }
528 
529     /**
530      * @dev Returns true if the value is in the set. O(1).
531      */
532     function contains(AddressSet storage set, address value) internal view returns (bool) {
533         return _contains(set._inner, bytes32(uint256(uint160(value))));
534     }
535 
536     /**
537      * @dev Returns the number of values in the set. O(1).
538      */
539     function length(AddressSet storage set) internal view returns (uint256) {
540         return _length(set._inner);
541     }
542 
543    /**
544     * @dev Returns the value stored at position `index` in the set. O(1).
545     *
546     * Note that there are no guarantees on the ordering of values inside the
547     * array, and it may change when more values are added or removed.
548     *
549     * Requirements:
550     *
551     * - `index` must be strictly less than {length}.
552     */
553     function at(AddressSet storage set, uint256 index) internal view returns (address) {
554         return address(uint160(uint256(_at(set._inner, index))));
555     }
556 
557 
558     // UintSet
559 
560     struct UintSet {
561         Set _inner;
562     }
563 
564     /**
565      * @dev Add a value to a set. O(1).
566      *
567      * Returns true if the value was added to the set, that is if it was not
568      * already present.
569      */
570     function add(UintSet storage set, uint256 value) internal returns (bool) {
571         return _add(set._inner, bytes32(value));
572     }
573 
574     /**
575      * @dev Removes a value from a set. O(1).
576      *
577      * Returns true if the value was removed from the set, that is if it was
578      * present.
579      */
580     function remove(UintSet storage set, uint256 value) internal returns (bool) {
581         return _remove(set._inner, bytes32(value));
582     }
583 
584     /**
585      * @dev Returns true if the value is in the set. O(1).
586      */
587     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
588         return _contains(set._inner, bytes32(value));
589     }
590 
591     /**
592      * @dev Returns the number of values on the set. O(1).
593      */
594     function length(UintSet storage set) internal view returns (uint256) {
595         return _length(set._inner);
596     }
597 
598    /**
599     * @dev Returns the value stored at position `index` in the set. O(1).
600     *
601     * Note that there are no guarantees on the ordering of values inside the
602     * array, and it may change when more values are added or removed.
603     *
604     * Requirements:
605     *
606     * - `index` must be strictly less than {length}.
607     */
608     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
609         return uint256(_at(set._inner, index));
610     }
611 }
612 
613 // File: openzeppelin-solidity/contracts/utils/Address.sol
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Collection of functions related to the address type
619  */
620 library Address {
621     /**
622      * @dev Returns true if `account` is a contract.
623      *
624      * [IMPORTANT]
625      * ====
626      * It is unsafe to assume that an address for which this function returns
627      * false is an externally-owned account (EOA) and not a contract.
628      *
629      * Among others, `isContract` will return false for the following
630      * types of addresses:
631      *
632      *  - an externally-owned account
633      *  - a contract in construction
634      *  - an address where a contract will be created
635      *  - an address where a contract lived, but was destroyed
636      * ====
637      */
638     function isContract(address account) internal view returns (bool) {
639         // This method relies on extcodesize, which returns 0 for contracts in
640         // construction, since the code is only stored at the end of the
641         // constructor execution.
642 
643         uint256 size;
644         // solhint-disable-next-line no-inline-assembly
645         assembly { size := extcodesize(account) }
646         return size > 0;
647     }
648 
649     /**
650      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
651      * `recipient`, forwarding all available gas and reverting on errors.
652      *
653      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
654      * of certain opcodes, possibly making contracts go over the 2300 gas limit
655      * imposed by `transfer`, making them unable to receive funds via
656      * `transfer`. {sendValue} removes this limitation.
657      *
658      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
659      *
660      * IMPORTANT: because control is transferred to `recipient`, care must be
661      * taken to not create reentrancy vulnerabilities. Consider using
662      * {ReentrancyGuard} or the
663      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
664      */
665     function sendValue(address payable recipient, uint256 amount) internal {
666         require(address(this).balance >= amount, "Address: insufficient balance");
667 
668         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
669         (bool success, ) = recipient.call{ value: amount }("");
670         require(success, "Address: unable to send value, recipient may have reverted");
671     }
672 
673     /**
674      * @dev Performs a Solidity function call using a low level `call`. A
675      * plain`call` is an unsafe replacement for a function call: use this
676      * function instead.
677      *
678      * If `target` reverts with a revert reason, it is bubbled up by this
679      * function (like regular Solidity function calls).
680      *
681      * Returns the raw returned data. To convert to the expected return value,
682      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
683      *
684      * Requirements:
685      *
686      * - `target` must be a contract.
687      * - calling `target` with `data` must not revert.
688      *
689      * _Available since v3.1._
690      */
691     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
692       return functionCall(target, data, "Address: low-level call failed");
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
697      * `errorMessage` as a fallback revert reason when `target` reverts.
698      *
699      * _Available since v3.1._
700      */
701     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
702         return functionCallWithValue(target, data, 0, errorMessage);
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
707      * but also transferring `value` wei to `target`.
708      *
709      * Requirements:
710      *
711      * - the calling contract must have an ETH balance of at least `value`.
712      * - the called Solidity function must be `payable`.
713      *
714      * _Available since v3.1._
715      */
716     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
717         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
722      * with `errorMessage` as a fallback revert reason when `target` reverts.
723      *
724      * _Available since v3.1._
725      */
726     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
727         require(address(this).balance >= value, "Address: insufficient balance for call");
728         require(isContract(target), "Address: call to non-contract");
729 
730         // solhint-disable-next-line avoid-low-level-calls
731         (bool success, bytes memory returndata) = target.call{ value: value }(data);
732         return _verifyCallResult(success, returndata, errorMessage);
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
737      * but performing a static call.
738      *
739      * _Available since v3.3._
740      */
741     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
742         return functionStaticCall(target, data, "Address: low-level static call failed");
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
747      * but performing a static call.
748      *
749      * _Available since v3.3._
750      */
751     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
752         require(isContract(target), "Address: static call to non-contract");
753 
754         // solhint-disable-next-line avoid-low-level-calls
755         (bool success, bytes memory returndata) = target.staticcall(data);
756         return _verifyCallResult(success, returndata, errorMessage);
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
761      * but performing a delegate call.
762      *
763      * _Available since v3.4._
764      */
765     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
766         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
771      * but performing a delegate call.
772      *
773      * _Available since v3.4._
774      */
775     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
776         require(isContract(target), "Address: delegate call to non-contract");
777 
778         // solhint-disable-next-line avoid-low-level-calls
779         (bool success, bytes memory returndata) = target.delegatecall(data);
780         return _verifyCallResult(success, returndata, errorMessage);
781     }
782 
783     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
784         if (success) {
785             return returndata;
786         } else {
787             // Look for revert reason and bubble it up if present
788             if (returndata.length > 0) {
789                 // The easiest way to bubble the revert reason is using memory via assembly
790 
791                 // solhint-disable-next-line no-inline-assembly
792                 assembly {
793                     let returndata_size := mload(returndata)
794                     revert(add(32, returndata), returndata_size)
795                 }
796             } else {
797                 revert(errorMessage);
798             }
799         }
800     }
801 }
802 
803 // File: openzeppelin-solidity/contracts/token/ERC20/utils/SafeERC20.sol
804 
805 pragma solidity ^0.8.0;
806 
807 
808 
809 /**
810  * @title SafeERC20
811  * @dev Wrappers around ERC20 operations that throw on failure (when the token
812  * contract returns false). Tokens that return no value (and instead revert or
813  * throw on failure) are also supported, non-reverting calls are assumed to be
814  * successful.
815  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
816  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
817  */
818 library SafeERC20 {
819     using Address for address;
820 
821     function safeTransfer(IERC20 token, address to, uint256 value) internal {
822         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
823     }
824 
825     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
826         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
827     }
828 
829     /**
830      * @dev Deprecated. This function has issues similar to the ones found in
831      * {IERC20-approve}, and its usage is discouraged.
832      *
833      * Whenever possible, use {safeIncreaseAllowance} and
834      * {safeDecreaseAllowance} instead.
835      */
836     function safeApprove(IERC20 token, address spender, uint256 value) internal {
837         // safeApprove should only be called when setting an initial allowance,
838         // or when resetting it to zero. To increase and decrease it, use
839         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
840         // solhint-disable-next-line max-line-length
841         require((value == 0) || (token.allowance(address(this), spender) == 0),
842             "SafeERC20: approve from non-zero to non-zero allowance"
843         );
844         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
845     }
846 
847     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
848         uint256 newAllowance = token.allowance(address(this), spender) + value;
849         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
850     }
851 
852     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
853         unchecked {
854             uint256 oldAllowance = token.allowance(address(this), spender);
855             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
856             uint256 newAllowance = oldAllowance - value;
857             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
858         }
859     }
860 
861     /**
862      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
863      * on the return value: the return value is optional (but if data is returned, it must not be false).
864      * @param token The token targeted by the call.
865      * @param data The call data (encoded using abi.encode or one of its variants).
866      */
867     function _callOptionalReturn(IERC20 token, bytes memory data) private {
868         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
869         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
870         // the target address contains contract code and also asserts for success in the low-level call.
871 
872         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
873         if (returndata.length > 0) { // Return data is optional
874             // solhint-disable-next-line max-line-length
875             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
876         }
877     }
878 }
879 
880 
881 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
882 
883 pragma solidity ^0.8.0;
884 
885 /**
886  * @dev Interface of the ERC20 standard as defined in the EIP.
887  */
888 interface IERC20 {
889     /**
890      * @dev Returns the amount of tokens in existence.
891      */
892     function totalSupply() external view returns (uint256);
893 
894     /**
895      * @dev Returns the amount of tokens owned by `account`.
896      */
897     function balanceOf(address account) external view returns (uint256);
898 
899     /**
900      * @dev Moves `amount` tokens from the caller's account to `recipient`.
901      *
902      * Returns a boolean value indicating whether the operation succeeded.
903      *
904      * Emits a {Transfer} event.
905      */
906     function transfer(address recipient, uint256 amount) external returns (bool);
907 
908     /**
909      * @dev Returns the remaining number of tokens that `spender` will be
910      * allowed to spend on behalf of `owner` through {transferFrom}. This is
911      * zero by default.
912      *
913      * This value changes when {approve} or {transferFrom} are called.
914      */
915     function allowance(address owner, address spender) external view returns (uint256);
916 
917     /**
918      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
919      *
920      * Returns a boolean value indicating whether the operation succeeded.
921      *
922      * IMPORTANT: Beware that changing an allowance with this method brings the risk
923      * that someone may use both the old and the new allowance by unfortunate
924      * transaction ordering. One possible solution to mitigate this race
925      * condition is to first reduce the spender's allowance to 0 and set the
926      * desired value afterwards:
927      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
928      *
929      * Emits an {Approval} event.
930      */
931     function approve(address spender, uint256 amount) external returns (bool);
932 
933     /**
934      * @dev Moves `amount` tokens from `sender` to `recipient` using the
935      * allowance mechanism. `amount` is then deducted from the caller's
936      * allowance.
937      *
938      * Returns a boolean value indicating whether the operation succeeded.
939      *
940      * Emits a {Transfer} event.
941      */
942     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
943 
944     /**
945      * @dev Emitted when `value` tokens are moved from one account (`from`) to
946      * another (`to`).
947      *
948      * Note that `value` may be zero.
949      */
950     event Transfer(address indexed from, address indexed to, uint256 value);
951 
952     /**
953      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
954      * a call to {approve}. `value` is the new allowance.
955      */
956     event Approval(address indexed owner, address indexed spender, uint256 value);
957 }
958 
959 // File: openzeppelin-solidity/contracts/token/ERC20/extensions/IERC20Metadata.sol
960 
961 pragma solidity ^0.8.0;
962 
963 
964 /**
965  * @dev Interface for the optional metadata functions from the ERC20 standard.
966  *
967  * _Available since v4.1._
968  */
969 interface IERC20Metadata is IERC20 {
970     /**
971      * @dev Returns the name of the token.
972      */
973     function name() external view returns (string memory);
974 
975     /**
976      * @dev Returns the symbol of the token.
977      */
978     function symbol() external view returns (string memory);
979 
980     /**
981      * @dev Returns the decimals places of the token.
982      */
983     function decimals() external view returns (uint8);
984 }
985 
986 
987 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
988 
989 pragma solidity ^0.8.0;
990 
991 
992 /**
993  * @dev Implementation of the {IERC20} interface.
994  *
995  * This implementation is agnostic to the way tokens are created. This means
996  * that a supply mechanism has to be added in a derived contract using {_mint}.
997  * For a generic mechanism see {ERC20PresetMinterPauser}.
998  *
999  * TIP: For a detailed writeup see our guide
1000  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1001  * to implement supply mechanisms].
1002  *
1003  * We have followed general OpenZeppelin guidelines: functions revert instead
1004  * of returning `false` on failure. This behavior is nonetheless conventional
1005  * and does not conflict with the expectations of ERC20 applications.
1006  *
1007  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1008  * This allows applications to reconstruct the allowance for all accounts just
1009  * by listening to said events. Other implementations of the EIP may not emit
1010  * these events, as it isn't required by the specification.
1011  *
1012  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1013  * functions have been added to mitigate the well-known issues around setting
1014  * allowances. See {IERC20-approve}.
1015  */
1016 contract ERC20 is Context, IERC20, IERC20Metadata {
1017     mapping (address => uint256) private _balances;
1018 
1019     mapping (address => mapping (address => uint256)) private _allowances;
1020 
1021     uint256 private _totalSupply;
1022 
1023     string private _name;
1024     string private _symbol;
1025 
1026     /**
1027      * @dev Sets the values for {name} and {symbol}.
1028      *
1029      * The defaut value of {decimals} is 18. To select a different value for
1030      * {decimals} you should overload it.
1031      *
1032      * All two of these values are immutable: they can only be set once during
1033      * construction.
1034      */
1035     constructor (string memory name_, string memory symbol_) {
1036         _name = name_;
1037         _symbol = symbol_;
1038     }
1039 
1040     /**
1041      * @dev Returns the name of the token.
1042      */
1043     function name() public view virtual override returns (string memory) {
1044         return _name;
1045     }
1046 
1047     /**
1048      * @dev Returns the symbol of the token, usually a shorter version of the
1049      * name.
1050      */
1051     function symbol() public view virtual override returns (string memory) {
1052         return _symbol;
1053     }
1054 
1055     /**
1056      * @dev Returns the number of decimals used to get its user representation.
1057      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1058      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1059      *
1060      * Tokens usually opt for a value of 18, imitating the relationship between
1061      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1062      * overridden;
1063      *
1064      * NOTE: This information is only used for _display_ purposes: it in
1065      * no way affects any of the arithmetic of the contract, including
1066      * {IERC20-balanceOf} and {IERC20-transfer}.
1067      */
1068     function decimals() public view virtual override returns (uint8) {
1069         return 18;
1070     }
1071 
1072     /**
1073      * @dev See {IERC20-totalSupply}.
1074      */
1075     function totalSupply() public view virtual override returns (uint256) {
1076         return _totalSupply;
1077     }
1078 
1079     /**
1080      * @dev See {IERC20-balanceOf}.
1081      */
1082     function balanceOf(address account) public view virtual override returns (uint256) {
1083         return _balances[account];
1084     }
1085 
1086     /**
1087      * @dev See {IERC20-transfer}.
1088      *
1089      * Requirements:
1090      *
1091      * - `recipient` cannot be the zero address.
1092      * - the caller must have a balance of at least `amount`.
1093      */
1094     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1095         _transfer(_msgSender(), recipient, amount);
1096         return true;
1097     }
1098 
1099     /**
1100      * @dev See {IERC20-allowance}.
1101      */
1102     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1103         return _allowances[owner][spender];
1104     }
1105 
1106     /**
1107      * @dev See {IERC20-approve}.
1108      *
1109      * Requirements:
1110      *
1111      * - `spender` cannot be the zero address.
1112      */
1113     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1114         _approve(_msgSender(), spender, amount);
1115         return true;
1116     }
1117 
1118     /**
1119      * @dev See {IERC20-transferFrom}.
1120      *
1121      * Emits an {Approval} event indicating the updated allowance. This is not
1122      * required by the EIP. See the note at the beginning of {ERC20}.
1123      *
1124      * Requirements:
1125      *
1126      * - `sender` and `recipient` cannot be the zero address.
1127      * - `sender` must have a balance of at least `amount`.
1128      * - the caller must have allowance for ``sender``'s tokens of at least
1129      * `amount`.
1130      */
1131     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1132         _transfer(sender, recipient, amount);
1133 
1134         uint256 currentAllowance = _allowances[sender][_msgSender()];
1135         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1136         _approve(sender, _msgSender(), currentAllowance - amount);
1137 
1138         return true;
1139     }
1140 
1141     /**
1142      * @dev Atomically increases the allowance granted to `spender` by the caller.
1143      *
1144      * This is an alternative to {approve} that can be used as a mitigation for
1145      * problems described in {IERC20-approve}.
1146      *
1147      * Emits an {Approval} event indicating the updated allowance.
1148      *
1149      * Requirements:
1150      *
1151      * - `spender` cannot be the zero address.
1152      */
1153     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1154         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1155         return true;
1156     }
1157 
1158     /**
1159      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1160      *
1161      * This is an alternative to {approve} that can be used as a mitigation for
1162      * problems described in {IERC20-approve}.
1163      *
1164      * Emits an {Approval} event indicating the updated allowance.
1165      *
1166      * Requirements:
1167      *
1168      * - `spender` cannot be the zero address.
1169      * - `spender` must have allowance for the caller of at least
1170      * `subtractedValue`.
1171      */
1172     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1173         uint256 currentAllowance = _allowances[_msgSender()][spender];
1174         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1175         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1176 
1177         return true;
1178     }
1179 
1180     /**
1181      * @dev Moves tokens `amount` from `sender` to `recipient`.
1182      *
1183      * This is internal function is equivalent to {transfer}, and can be used to
1184      * e.g. implement automatic token fees, slashing mechanisms, etc.
1185      *
1186      * Emits a {Transfer} event.
1187      *
1188      * Requirements:
1189      *
1190      * - `sender` cannot be the zero address.
1191      * - `recipient` cannot be the zero address.
1192      * - `sender` must have a balance of at least `amount`.
1193      */
1194     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1195         require(sender != address(0), "ERC20: transfer from the zero address");
1196         require(recipient != address(0), "ERC20: transfer to the zero address");
1197 
1198         _beforeTokenTransfer(sender, recipient, amount);
1199 
1200         uint256 senderBalance = _balances[sender];
1201         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1202         _balances[sender] = senderBalance - amount;
1203         _balances[recipient] += amount;
1204 
1205         emit Transfer(sender, recipient, amount);
1206     }
1207 
1208     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1209      * the total supply.
1210      *
1211      * Emits a {Transfer} event with `from` set to the zero address.
1212      *
1213      * Requirements:
1214      *
1215      * - `to` cannot be the zero address.
1216      */
1217     function _mint(address account, uint256 amount) internal virtual {
1218         require(account != address(0), "ERC20: mint to the zero address");
1219 
1220         _beforeTokenTransfer(address(0), account, amount);
1221 
1222         _totalSupply += amount;
1223         _balances[account] += amount;
1224         emit Transfer(address(0), account, amount);
1225     }
1226 
1227     /**
1228      * @dev Destroys `amount` tokens from `account`, reducing the
1229      * total supply.
1230      *
1231      * Emits a {Transfer} event with `to` set to the zero address.
1232      *
1233      * Requirements:
1234      *
1235      * - `account` cannot be the zero address.
1236      * - `account` must have at least `amount` tokens.
1237      */
1238     function _burn(address account, uint256 amount) internal virtual {
1239         require(account != address(0), "ERC20: burn from the zero address");
1240 
1241         _beforeTokenTransfer(account, address(0), amount);
1242 
1243         uint256 accountBalance = _balances[account];
1244         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1245         _balances[account] = accountBalance - amount;
1246         _totalSupply -= amount;
1247 
1248         emit Transfer(account, address(0), amount);
1249     }
1250 
1251     /**
1252      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1253      *
1254      * This internal function is equivalent to `approve`, and can be used to
1255      * e.g. set automatic allowances for certain subsystems, etc.
1256      *
1257      * Emits an {Approval} event.
1258      *
1259      * Requirements:
1260      *
1261      * - `owner` cannot be the zero address.
1262      * - `spender` cannot be the zero address.
1263      */
1264     function _approve(address owner, address spender, uint256 amount) internal virtual {
1265         require(owner != address(0), "ERC20: approve from the zero address");
1266         require(spender != address(0), "ERC20: approve to the zero address");
1267 
1268         _allowances[owner][spender] = amount;
1269         emit Approval(owner, spender, amount);
1270     }
1271 
1272     /**
1273      * @dev Hook that is called before any transfer of tokens. This includes
1274      * minting and burning.
1275      *
1276      * Calling conditions:
1277      *
1278      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1279      * will be to transferred to `to`.
1280      * - when `from` is zero, `amount` tokens will be minted for `to`.
1281      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1282      * - `from` and `to` are never both zero.
1283      *
1284      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1285      */
1286     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1287 }
1288 
1289 // File: contracts/StakeRewarder.sol
1290 
1291 pragma solidity ^0.8.5;
1292 
1293 /**
1294  * @title StakeRewarder
1295  * @dev This contract distributes rewards to depositors of supported tokens.
1296  * It's based on Sushi's MasterChef v1, but notably only serves what's already
1297  * available: no new tokens can be created. It's just a restaurant, not a farm.
1298  */
1299 contract StakeRewarder is Ownable {
1300     using SafeMath for uint256;
1301     using SafeERC20 for IERC20;
1302     
1303     // Info of each user.
1304     struct UserInfo {
1305         uint256 amount;     // Quantity of tokens the user has staked.
1306         uint256 rewardDebt; // Reward debt. See explanation below.
1307         // We do some fancy math here. Basically, any point in time, the
1308         // amount of rewards entitled to a user but is pending to be distributed is:
1309         //
1310         //   pendingReward = (stakedAmount * pool.accPerShare) - user.rewardDebt
1311         //
1312         // Whenever a user deposits or withdraws tokens in a pool:
1313         //   1. The pool's `accPerShare` (and `lastRewardBlock`) gets updated.
1314         //   2. User receives the pending reward sent to their address.
1315         //   3. User's `amount` gets updated.
1316         //   4. User's `rewardDebt` gets updated.
1317     }
1318     
1319     /**
1320      * @dev Info of each staking token
1321      */
1322     struct PoolInfo {
1323         IERC20 token;             // Address of the token contract.
1324         uint256 allocPoint;       // Allocation points assigned to this pool.
1325         uint256 lastRewardBlock;  // Last block number rewarded.
1326         uint256 accPerShare;      // Accumulated rewards per share (times 1e12).
1327     }
1328     
1329     // The rewards token
1330     IERC20 rewardToken;
1331     
1332     // Reward tokens issued per block.
1333     uint256 public rewardPerBlock;
1334     
1335     // Info of each pool.
1336     PoolInfo[] public poolInfo;
1337     
1338     // Info of each user that stakes tokens.
1339     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1340     
1341     // Underpaid rewards owed to a user.
1342     mapping(address => uint256) public underpayment;
1343     
1344     // Total allocation points. Must be the sum of all allocation points across all staking tokens.
1345     uint256 public totalAllocPoint = 0;
1346     
1347     // The block number when staking starts.
1348     uint256 public startBlock;
1349     
1350     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1351     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1352     event EmergencyReclaimRewards(address indexed user, uint256 amount);
1353     event EmergencyWithdraw(
1354         address indexed user,
1355         uint256 indexed pid,
1356         uint256 amount
1357     );
1358 
1359     constructor(
1360         IERC20 _rewardToken,
1361         uint256 _rewardPerBlock,
1362         uint256 _startBlock
1363     ) {
1364         rewardToken = _rewardToken;
1365         rewardPerBlock = _rewardPerBlock;
1366         startBlock = _startBlock;
1367     }
1368 
1369     function poolLength() external view returns (uint256) {
1370         return poolInfo.length;
1371     }
1372 
1373     /**
1374      * @dev Adds a new token to the stack. Can only be called by the owner.
1375      * WARNING: DO NOT ADD TOKENS MORE THAN ONCE! Rewards will be messed up.
1376      */
1377     function add(
1378         uint256 _allocPoint,
1379         IERC20 _token,
1380         bool _withUpdate
1381     ) public onlyOwner {
1382         if (_withUpdate) {
1383             refreshPools();
1384         }
1385 
1386         uint256 lastRewardBlock =
1387             block.number > startBlock ? block.number : startBlock;
1388         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1389         poolInfo.push(
1390             PoolInfo({
1391                 token: _token,
1392                 allocPoint: _allocPoint,
1393                 lastRewardBlock: lastRewardBlock,
1394                 accPerShare: 0
1395             })
1396         );
1397     }
1398 
1399     /**
1400      * @dev Update the given staking pool's allocation points. Can only be called by the owner.
1401      */ 
1402     function set(
1403         uint256 _pid,
1404         uint256 _allocPoint,
1405         bool _shouldUpdate
1406     ) public onlyOwner {
1407         if (_shouldUpdate) {
1408             refreshPools();
1409         }
1410         
1411         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1412             _allocPoint
1413         );
1414 
1415         poolInfo[_pid].allocPoint = _allocPoint;
1416     }
1417     
1418     /**
1419      * @dev Update the reward per block. Can only be called by the owner.
1420      */
1421     function setRewardPerBlock(uint256 _rewardPerBlock) public onlyOwner {
1422         rewardPerBlock = _rewardPerBlock;
1423     }
1424 
1425     /**
1426      * @dev Return reward multiplier over the given _from to _to block.
1427      */
1428     function getMultiplier(uint256 _from, uint256 _to)
1429         public
1430         pure
1431         returns (uint256)
1432     {
1433         return _to.sub(_from);
1434     }
1435 
1436     /**
1437      * @dev View function to see pending rewards for an address (not for contract use).
1438      */
1439     function pendingRewards(uint256 _pid, address _user)
1440         external
1441         view
1442         returns (uint256)
1443     {
1444         PoolInfo storage pool = poolInfo[_pid];
1445         UserInfo storage user = userInfo[_pid][_user];
1446         uint256 accPerShare = pool.accPerShare;
1447         uint256 tokenSupply = pool.token.balanceOf(address(this));
1448         
1449         if (block.number > pool.lastRewardBlock && tokenSupply != 0) {
1450             uint256 multiplier =
1451                 getMultiplier(pool.lastRewardBlock, block.number);
1452             uint256 reward =
1453                 multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(
1454                     totalAllocPoint
1455                 );
1456             accPerShare = accPerShare.add(
1457                 reward.mul(1e12).div(tokenSupply)
1458             );
1459         }
1460 
1461         return user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt);
1462     }
1463 
1464     /**
1465      * @dev Update all pools. Callable by anyone. Could be gas intensive.
1466      */
1467     function refreshPools() public {
1468         uint256 length = poolInfo.length;
1469         for (uint256 pid = 0; pid < length; ++pid) {
1470             updatePool(pid);
1471         }
1472     }
1473 
1474     /**
1475      * @dev Update rewards of the given pool to be up-to-date.
1476      */
1477     function updatePool(uint256 _pid) public {
1478         PoolInfo storage pool = poolInfo[_pid];
1479 
1480         if (block.number <= pool.lastRewardBlock) {
1481             return;
1482         }
1483 
1484         uint256 tokenSupply = pool.token.balanceOf(address(this));
1485 
1486         if (tokenSupply == 0) {
1487             pool.lastRewardBlock = block.number;
1488             return;
1489         }
1490 
1491         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1492         uint256 reward =
1493             multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(
1494                 totalAllocPoint
1495             );
1496 
1497         pool.accPerShare = pool.accPerShare.add(
1498             reward.mul(1e12).div(tokenSupply)
1499         );
1500 
1501         pool.lastRewardBlock = block.number;
1502     }
1503 
1504     /**
1505      * @dev Stake tokens to earn a share of rewards.
1506      */
1507     function deposit(uint256 _pid, uint256 _amount) public {
1508         PoolInfo storage pool = poolInfo[_pid];
1509         UserInfo storage user = userInfo[_pid][msg.sender];
1510         
1511         require(_amount > 0, "deposit: only non-zero amounts allowed");
1512         
1513         // make sure the pool is up-to-date
1514         updatePool(_pid);
1515         
1516         // deliver any pending rewards
1517         if (user.amount > 0) {
1518             uint256 pending =
1519                 user.amount.mul(pool.accPerShare).div(1e12).sub(
1520                     user.rewardDebt
1521                 ).add(underpayment[msg.sender]);
1522             
1523             uint256 payout = safelyDistribute(msg.sender, pending);
1524             if (payout < pending) {
1525                 underpayment[msg.sender] = pending.sub(payout);
1526             } else {
1527                 underpayment[msg.sender] = 0;
1528             }
1529         }
1530         
1531         // pull in user's staked assets
1532         pool.token.safeTransferFrom(
1533             address(msg.sender),
1534             address(this),
1535             _amount
1536         );
1537         
1538         // update user's deposit and reward info
1539         user.amount = user.amount.add(_amount);
1540         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
1541         
1542         emit Deposit(msg.sender, _pid, _amount);
1543     }
1544 
1545     /**
1546      * @dev Withdraw staked tokens and any pending rewards.
1547      */
1548     function withdraw(uint256 _pid, uint256 _amount) public {
1549         PoolInfo storage pool = poolInfo[_pid];
1550         UserInfo storage user = userInfo[_pid][msg.sender];
1551         
1552         require(_amount > 0, "withdraw: only non-zero amounts allowed");
1553         require(user.amount >= _amount, "withdraw: amount too large");
1554         
1555         // make sure the pool is up-to-date
1556         updatePool(_pid);
1557         
1558         // calculate the pending reward
1559         uint256 pending =
1560             user.amount.mul(pool.accPerShare).div(1e12).sub(
1561                 user.rewardDebt
1562             ).add(underpayment[msg.sender]);
1563 
1564         // send the rewards out
1565         uint256 payout = safelyDistribute(msg.sender, pending);
1566         if (payout < pending) {
1567             underpayment[msg.sender] = pending.sub(payout);
1568         } else {
1569             underpayment[msg.sender] = 0;
1570         }
1571         
1572         // update the user's deposit and reward info
1573         user.amount = user.amount.sub(_amount);
1574         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
1575         
1576         // send back the staked assets
1577         pool.token.safeTransfer(address(msg.sender), _amount);
1578         
1579         emit Withdraw(msg.sender, _pid, _amount);
1580     }
1581 
1582     /**
1583      * @dev Withdraw staked tokens and forego any unclaimed rewards. This is a fail-safe.
1584      */
1585     function emergencyWithdraw(uint256 _pid) public {
1586         PoolInfo storage pool = poolInfo[_pid];
1587         UserInfo storage user = userInfo[_pid][msg.sender];
1588         uint256 amount = user.amount;
1589         
1590         // reset everything to zero
1591         user.amount = 0;
1592         user.rewardDebt = 0;
1593         underpayment[msg.sender] = 0;
1594         
1595         // send back the staked assets
1596         pool.token.safeTransfer(address(msg.sender), amount);
1597         emit EmergencyWithdraw(msg.sender, _pid, amount);
1598     }
1599 
1600     /**
1601      * @dev Safely distribute at most the amount of tokens in holding.
1602      */
1603     function safelyDistribute(address _to, uint256 _amount) internal returns (uint256 amount) {
1604         uint256 available = rewardToken.balanceOf(address(this));
1605         amount = _amount > available ? available : _amount;
1606         rewardToken.transfer(_to, amount);
1607         return amount;
1608     }
1609     
1610     /**
1611      * @dev Withdraw undisbursed rewards tokens. This is a fail-safe.
1612      */
1613     function emergencyReclaimRewards(uint256 _amount) public onlyOwner {
1614         if (_amount == 0) {
1615             _amount = rewardToken.balanceOf(address(this));
1616         }
1617         
1618         rewardToken.transfer(msg.sender, _amount);
1619         emit EmergencyReclaimRewards(msg.sender, _amount);
1620     }
1621 }