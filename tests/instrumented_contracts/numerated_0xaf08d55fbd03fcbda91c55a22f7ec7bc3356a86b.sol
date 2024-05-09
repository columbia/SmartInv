1 // SPDX-License-Identifier: MIT
2 // File: stakinginterface.sol
3 
4 
5 pragma solidity >=0.7.0 <0.9.0;
6 
7 interface IStake { 
8     function depositsOf(address account) external view returns (uint256[] memory);
9 }
10 // File: tokeninterface.sol
11 
12 
13 pragma solidity >=0.7.0 <0.9.0;
14 
15 interface ITOKEN { 
16     function mint(address to, uint256 amount) external;
17 }
18 // File: @openzeppelin/contracts/utils/math/Math.sol
19 
20 
21 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Standard math utilities missing in the Solidity language.
27  */
28 library Math {
29     /**
30      * @dev Returns the largest of two numbers.
31      */
32     function max(uint256 a, uint256 b) internal pure returns (uint256) {
33         return a >= b ? a : b;
34     }
35 
36     /**
37      * @dev Returns the smallest of two numbers.
38      */
39     function min(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a < b ? a : b;
41     }
42 
43     /**
44      * @dev Returns the average of two numbers. The result is rounded towards
45      * zero.
46      */
47     function average(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b) / 2 can overflow.
49         return (a & b) + (a ^ b) / 2;
50     }
51 
52     /**
53      * @dev Returns the ceiling of the division of two numbers.
54      *
55      * This differs from standard division with `/` in that it rounds up instead
56      * of rounding down.
57      */
58     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
59         // (a + b - 1) / b can overflow on addition, so we distribute.
60         return a / b + (a % b == 0 ? 0 : 1);
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
65 
66 
67 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Library for managing
73  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
74  * types.
75  *
76  * Sets have the following properties:
77  *
78  * - Elements are added, removed, and checked for existence in constant time
79  * (O(1)).
80  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
81  *
82  * ```
83  * contract Example {
84  *     // Add the library methods
85  *     using EnumerableSet for EnumerableSet.AddressSet;
86  *
87  *     // Declare a set state variable
88  *     EnumerableSet.AddressSet private mySet;
89  * }
90  * ```
91  *
92  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
93  * and `uint256` (`UintSet`) are supported.
94  */
95 library EnumerableSet {
96     // To implement this library for multiple types with as little code
97     // repetition as possible, we write it in terms of a generic Set type with
98     // bytes32 values.
99     // The Set implementation uses private functions, and user-facing
100     // implementations (such as AddressSet) are just wrappers around the
101     // underlying Set.
102     // This means that we can only create new EnumerableSets for types that fit
103     // in bytes32.
104 
105     struct Set {
106         // Storage of set values
107         bytes32[] _values;
108         // Position of the value in the `values` array, plus 1 because index 0
109         // means a value is not in the set.
110         mapping(bytes32 => uint256) _indexes;
111     }
112 
113     /**
114      * @dev Add a value to a set. O(1).
115      *
116      * Returns true if the value was added to the set, that is if it was not
117      * already present.
118      */
119     function _add(Set storage set, bytes32 value) private returns (bool) {
120         if (!_contains(set, value)) {
121             set._values.push(value);
122             // The value is stored at length-1, but we add 1 to all indexes
123             // and use 0 as a sentinel value
124             set._indexes[value] = set._values.length;
125             return true;
126         } else {
127             return false;
128         }
129     }
130 
131     /**
132      * @dev Removes a value from a set. O(1).
133      *
134      * Returns true if the value was removed from the set, that is if it was
135      * present.
136      */
137     function _remove(Set storage set, bytes32 value) private returns (bool) {
138         // We read and store the value's index to prevent multiple reads from the same storage slot
139         uint256 valueIndex = set._indexes[value];
140 
141         if (valueIndex != 0) {
142             // Equivalent to contains(set, value)
143             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
144             // the array, and then remove the last element (sometimes called as 'swap and pop').
145             // This modifies the order of the array, as noted in {at}.
146 
147             uint256 toDeleteIndex = valueIndex - 1;
148             uint256 lastIndex = set._values.length - 1;
149 
150             if (lastIndex != toDeleteIndex) {
151                 bytes32 lastValue = set._values[lastIndex];
152 
153                 // Move the last value to the index where the value to delete is
154                 set._values[toDeleteIndex] = lastValue;
155                 // Update the index for the moved value
156                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
157             }
158 
159             // Delete the slot where the moved value was stored
160             set._values.pop();
161 
162             // Delete the index for the deleted slot
163             delete set._indexes[value];
164 
165             return true;
166         } else {
167             return false;
168         }
169     }
170 
171     /**
172      * @dev Returns true if the value is in the set. O(1).
173      */
174     function _contains(Set storage set, bytes32 value) private view returns (bool) {
175         return set._indexes[value] != 0;
176     }
177 
178     /**
179      * @dev Returns the number of values on the set. O(1).
180      */
181     function _length(Set storage set) private view returns (uint256) {
182         return set._values.length;
183     }
184 
185     /**
186      * @dev Returns the value stored at position `index` in the set. O(1).
187      *
188      * Note that there are no guarantees on the ordering of values inside the
189      * array, and it may change when more values are added or removed.
190      *
191      * Requirements:
192      *
193      * - `index` must be strictly less than {length}.
194      */
195     function _at(Set storage set, uint256 index) private view returns (bytes32) {
196         return set._values[index];
197     }
198 
199     /**
200      * @dev Return the entire set in an array
201      *
202      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
203      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
204      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
205      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
206      */
207     function _values(Set storage set) private view returns (bytes32[] memory) {
208         return set._values;
209     }
210 
211     // Bytes32Set
212 
213     struct Bytes32Set {
214         Set _inner;
215     }
216 
217     /**
218      * @dev Add a value to a set. O(1).
219      *
220      * Returns true if the value was added to the set, that is if it was not
221      * already present.
222      */
223     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
224         return _add(set._inner, value);
225     }
226 
227     /**
228      * @dev Removes a value from a set. O(1).
229      *
230      * Returns true if the value was removed from the set, that is if it was
231      * present.
232      */
233     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
234         return _remove(set._inner, value);
235     }
236 
237     /**
238      * @dev Returns true if the value is in the set. O(1).
239      */
240     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
241         return _contains(set._inner, value);
242     }
243 
244     /**
245      * @dev Returns the number of values in the set. O(1).
246      */
247     function length(Bytes32Set storage set) internal view returns (uint256) {
248         return _length(set._inner);
249     }
250 
251     /**
252      * @dev Returns the value stored at position `index` in the set. O(1).
253      *
254      * Note that there are no guarantees on the ordering of values inside the
255      * array, and it may change when more values are added or removed.
256      *
257      * Requirements:
258      *
259      * - `index` must be strictly less than {length}.
260      */
261     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
262         return _at(set._inner, index);
263     }
264 
265     /**
266      * @dev Return the entire set in an array
267      *
268      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
269      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
270      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
271      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
272      */
273     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
274         return _values(set._inner);
275     }
276 
277     // AddressSet
278 
279     struct AddressSet {
280         Set _inner;
281     }
282 
283     /**
284      * @dev Add a value to a set. O(1).
285      *
286      * Returns true if the value was added to the set, that is if it was not
287      * already present.
288      */
289     function add(AddressSet storage set, address value) internal returns (bool) {
290         return _add(set._inner, bytes32(uint256(uint160(value))));
291     }
292 
293     /**
294      * @dev Removes a value from a set. O(1).
295      *
296      * Returns true if the value was removed from the set, that is if it was
297      * present.
298      */
299     function remove(AddressSet storage set, address value) internal returns (bool) {
300         return _remove(set._inner, bytes32(uint256(uint160(value))));
301     }
302 
303     /**
304      * @dev Returns true if the value is in the set. O(1).
305      */
306     function contains(AddressSet storage set, address value) internal view returns (bool) {
307         return _contains(set._inner, bytes32(uint256(uint160(value))));
308     }
309 
310     /**
311      * @dev Returns the number of values in the set. O(1).
312      */
313     function length(AddressSet storage set) internal view returns (uint256) {
314         return _length(set._inner);
315     }
316 
317     /**
318      * @dev Returns the value stored at position `index` in the set. O(1).
319      *
320      * Note that there are no guarantees on the ordering of values inside the
321      * array, and it may change when more values are added or removed.
322      *
323      * Requirements:
324      *
325      * - `index` must be strictly less than {length}.
326      */
327     function at(AddressSet storage set, uint256 index) internal view returns (address) {
328         return address(uint160(uint256(_at(set._inner, index))));
329     }
330 
331     /**
332      * @dev Return the entire set in an array
333      *
334      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
335      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
336      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
337      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
338      */
339     function values(AddressSet storage set) internal view returns (address[] memory) {
340         bytes32[] memory store = _values(set._inner);
341         address[] memory result;
342 
343         assembly {
344             result := store
345         }
346 
347         return result;
348     }
349 
350     // UintSet
351 
352     struct UintSet {
353         Set _inner;
354     }
355 
356     /**
357      * @dev Add a value to a set. O(1).
358      *
359      * Returns true if the value was added to the set, that is if it was not
360      * already present.
361      */
362     function add(UintSet storage set, uint256 value) internal returns (bool) {
363         return _add(set._inner, bytes32(value));
364     }
365 
366     /**
367      * @dev Removes a value from a set. O(1).
368      *
369      * Returns true if the value was removed from the set, that is if it was
370      * present.
371      */
372     function remove(UintSet storage set, uint256 value) internal returns (bool) {
373         return _remove(set._inner, bytes32(value));
374     }
375 
376     /**
377      * @dev Returns true if the value is in the set. O(1).
378      */
379     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
380         return _contains(set._inner, bytes32(value));
381     }
382 
383     /**
384      * @dev Returns the number of values on the set. O(1).
385      */
386     function length(UintSet storage set) internal view returns (uint256) {
387         return _length(set._inner);
388     }
389 
390     /**
391      * @dev Returns the value stored at position `index` in the set. O(1).
392      *
393      * Note that there are no guarantees on the ordering of values inside the
394      * array, and it may change when more values are added or removed.
395      *
396      * Requirements:
397      *
398      * - `index` must be strictly less than {length}.
399      */
400     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
401         return uint256(_at(set._inner, index));
402     }
403 
404     /**
405      * @dev Return the entire set in an array
406      *
407      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
408      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
409      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
410      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
411      */
412     function values(UintSet storage set) internal view returns (uint256[] memory) {
413         bytes32[] memory store = _values(set._inner);
414         uint256[] memory result;
415 
416         assembly {
417             result := store
418         }
419 
420         return result;
421     }
422 }
423 
424 // File: @openzeppelin/contracts/utils/Strings.sol
425 
426 
427 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @dev String operations.
433  */
434 library Strings {
435     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
439      */
440     function toString(uint256 value) internal pure returns (string memory) {
441         // Inspired by OraclizeAPI's implementation - MIT licence
442         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
443 
444         if (value == 0) {
445             return "0";
446         }
447         uint256 temp = value;
448         uint256 digits;
449         while (temp != 0) {
450             digits++;
451             temp /= 10;
452         }
453         bytes memory buffer = new bytes(digits);
454         while (value != 0) {
455             digits -= 1;
456             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
457             value /= 10;
458         }
459         return string(buffer);
460     }
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
464      */
465     function toHexString(uint256 value) internal pure returns (string memory) {
466         if (value == 0) {
467             return "0x00";
468         }
469         uint256 temp = value;
470         uint256 length = 0;
471         while (temp != 0) {
472             length++;
473             temp >>= 8;
474         }
475         return toHexString(value, length);
476     }
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
480      */
481     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
482         bytes memory buffer = new bytes(2 * length + 2);
483         buffer[0] = "0";
484         buffer[1] = "x";
485         for (uint256 i = 2 * length + 1; i > 1; --i) {
486             buffer[i] = _HEX_SYMBOLS[value & 0xf];
487             value >>= 4;
488         }
489         require(value == 0, "Strings: hex length insufficient");
490         return string(buffer);
491     }
492 }
493 
494 // File: @openzeppelin/contracts/utils/Context.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Provides information about the current execution context, including the
503  * sender of the transaction and its data. While these are generally available
504  * via msg.sender and msg.data, they should not be accessed in such a direct
505  * manner, since when dealing with meta-transactions the account sending and
506  * paying for execution may not be the actual sender (as far as an application
507  * is concerned).
508  *
509  * This contract is only required for intermediate, library-like contracts.
510  */
511 abstract contract Context {
512     function _msgSender() internal view virtual returns (address) {
513         return msg.sender;
514     }
515 
516     function _msgData() internal view virtual returns (bytes calldata) {
517         return msg.data;
518     }
519 }
520 
521 // File: @openzeppelin/contracts/access/Ownable.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Contract module which provides a basic access control mechanism, where
531  * there is an account (an owner) that can be granted exclusive access to
532  * specific functions.
533  *
534  * By default, the owner account will be the one that deploys the contract. This
535  * can later be changed with {transferOwnership}.
536  *
537  * This module is used through inheritance. It will make available the modifier
538  * `onlyOwner`, which can be applied to your functions to restrict their use to
539  * the owner.
540  */
541 abstract contract Ownable is Context {
542     address private _owner;
543 
544     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
545 
546     /**
547      * @dev Initializes the contract setting the deployer as the initial owner.
548      */
549     constructor() {
550         _transferOwnership(_msgSender());
551     }
552 
553     /**
554      * @dev Returns the address of the current owner.
555      */
556     function owner() public view virtual returns (address) {
557         return _owner;
558     }
559 
560     /**
561      * @dev Throws if called by any account other than the owner.
562      */
563     modifier onlyOwner() {
564         require(owner() == _msgSender(), "Ownable: caller is not the owner");
565         _;
566     }
567 
568     /**
569      * @dev Leaves the contract without owner. It will not be possible to call
570      * `onlyOwner` functions anymore. Can only be called by the current owner.
571      *
572      * NOTE: Renouncing ownership will leave the contract without an owner,
573      * thereby removing any functionality that is only available to the owner.
574      */
575     function renounceOwnership() public virtual onlyOwner {
576         _transferOwnership(address(0));
577     }
578 
579     /**
580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
581      * Can only be called by the current owner.
582      */
583     function transferOwnership(address newOwner) public virtual onlyOwner {
584         require(newOwner != address(0), "Ownable: new owner is the zero address");
585         _transferOwnership(newOwner);
586     }
587 
588     /**
589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
590      * Internal function without access restriction.
591      */
592     function _transferOwnership(address newOwner) internal virtual {
593         address oldOwner = _owner;
594         _owner = newOwner;
595         emit OwnershipTransferred(oldOwner, newOwner);
596     }
597 }
598 
599 // File: @openzeppelin/contracts/utils/Address.sol
600 
601 
602 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
603 
604 pragma solidity ^0.8.1;
605 
606 /**
607  * @dev Collection of functions related to the address type
608  */
609 library Address {
610     /**
611      * @dev Returns true if `account` is a contract.
612      *
613      * [IMPORTANT]
614      * ====
615      * It is unsafe to assume that an address for which this function returns
616      * false is an externally-owned account (EOA) and not a contract.
617      *
618      * Among others, `isContract` will return false for the following
619      * types of addresses:
620      *
621      *  - an externally-owned account
622      *  - a contract in construction
623      *  - an address where a contract will be created
624      *  - an address where a contract lived, but was destroyed
625      * ====
626      *
627      * [IMPORTANT]
628      * ====
629      * You shouldn't rely on `isContract` to protect against flash loan attacks!
630      *
631      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
632      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
633      * constructor.
634      * ====
635      */
636     function isContract(address account) internal view returns (bool) {
637         // This method relies on extcodesize/address.code.length, which returns 0
638         // for contracts in construction, since the code is only stored at the end
639         // of the constructor execution.
640 
641         return account.code.length > 0;
642     }
643 
644     /**
645      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
646      * `recipient`, forwarding all available gas and reverting on errors.
647      *
648      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
649      * of certain opcodes, possibly making contracts go over the 2300 gas limit
650      * imposed by `transfer`, making them unable to receive funds via
651      * `transfer`. {sendValue} removes this limitation.
652      *
653      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
654      *
655      * IMPORTANT: because control is transferred to `recipient`, care must be
656      * taken to not create reentrancy vulnerabilities. Consider using
657      * {ReentrancyGuard} or the
658      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
659      */
660     function sendValue(address payable recipient, uint256 amount) internal {
661         require(address(this).balance >= amount, "Address: insufficient balance");
662 
663         (bool success, ) = recipient.call{value: amount}("");
664         require(success, "Address: unable to send value, recipient may have reverted");
665     }
666 
667     /**
668      * @dev Performs a Solidity function call using a low level `call`. A
669      * plain `call` is an unsafe replacement for a function call: use this
670      * function instead.
671      *
672      * If `target` reverts with a revert reason, it is bubbled up by this
673      * function (like regular Solidity function calls).
674      *
675      * Returns the raw returned data. To convert to the expected return value,
676      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
677      *
678      * Requirements:
679      *
680      * - `target` must be a contract.
681      * - calling `target` with `data` must not revert.
682      *
683      * _Available since v3.1._
684      */
685     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
686         return functionCall(target, data, "Address: low-level call failed");
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
691      * `errorMessage` as a fallback revert reason when `target` reverts.
692      *
693      * _Available since v3.1._
694      */
695     function functionCall(
696         address target,
697         bytes memory data,
698         string memory errorMessage
699     ) internal returns (bytes memory) {
700         return functionCallWithValue(target, data, 0, errorMessage);
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
705      * but also transferring `value` wei to `target`.
706      *
707      * Requirements:
708      *
709      * - the calling contract must have an ETH balance of at least `value`.
710      * - the called Solidity function must be `payable`.
711      *
712      * _Available since v3.1._
713      */
714     function functionCallWithValue(
715         address target,
716         bytes memory data,
717         uint256 value
718     ) internal returns (bytes memory) {
719         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
724      * with `errorMessage` as a fallback revert reason when `target` reverts.
725      *
726      * _Available since v3.1._
727      */
728     function functionCallWithValue(
729         address target,
730         bytes memory data,
731         uint256 value,
732         string memory errorMessage
733     ) internal returns (bytes memory) {
734         require(address(this).balance >= value, "Address: insufficient balance for call");
735         require(isContract(target), "Address: call to non-contract");
736 
737         (bool success, bytes memory returndata) = target.call{value: value}(data);
738         return verifyCallResult(success, returndata, errorMessage);
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
743      * but performing a static call.
744      *
745      * _Available since v3.3._
746      */
747     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
748         return functionStaticCall(target, data, "Address: low-level static call failed");
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
753      * but performing a static call.
754      *
755      * _Available since v3.3._
756      */
757     function functionStaticCall(
758         address target,
759         bytes memory data,
760         string memory errorMessage
761     ) internal view returns (bytes memory) {
762         require(isContract(target), "Address: static call to non-contract");
763 
764         (bool success, bytes memory returndata) = target.staticcall(data);
765         return verifyCallResult(success, returndata, errorMessage);
766     }
767 
768     /**
769      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
770      * but performing a delegate call.
771      *
772      * _Available since v3.4._
773      */
774     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
775         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
780      * but performing a delegate call.
781      *
782      * _Available since v3.4._
783      */
784     function functionDelegateCall(
785         address target,
786         bytes memory data,
787         string memory errorMessage
788     ) internal returns (bytes memory) {
789         require(isContract(target), "Address: delegate call to non-contract");
790 
791         (bool success, bytes memory returndata) = target.delegatecall(data);
792         return verifyCallResult(success, returndata, errorMessage);
793     }
794 
795     /**
796      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
797      * revert reason using the provided one.
798      *
799      * _Available since v4.3._
800      */
801     function verifyCallResult(
802         bool success,
803         bytes memory returndata,
804         string memory errorMessage
805     ) internal pure returns (bytes memory) {
806         if (success) {
807             return returndata;
808         } else {
809             // Look for revert reason and bubble it up if present
810             if (returndata.length > 0) {
811                 // The easiest way to bubble the revert reason is using memory via assembly
812 
813                 assembly {
814                     let returndata_size := mload(returndata)
815                     revert(add(32, returndata), returndata_size)
816                 }
817             } else {
818                 revert(errorMessage);
819             }
820         }
821     }
822 }
823 
824 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
825 
826 
827 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
828 
829 pragma solidity ^0.8.0;
830 
831 /**
832  * @title ERC721 token receiver interface
833  * @dev Interface for any contract that wants to support safeTransfers
834  * from ERC721 asset contracts.
835  */
836 interface IERC721Receiver {
837     /**
838      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
839      * by `operator` from `from`, this function is called.
840      *
841      * It must return its Solidity selector to confirm the token transfer.
842      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
843      *
844      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
845      */
846     function onERC721Received(
847         address operator,
848         address from,
849         uint256 tokenId,
850         bytes calldata data
851     ) external returns (bytes4);
852 }
853 
854 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
855 
856 
857 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
858 
859 pragma solidity ^0.8.0;
860 
861 /**
862  * @dev Interface of the ERC165 standard, as defined in the
863  * https://eips.ethereum.org/EIPS/eip-165[EIP].
864  *
865  * Implementers can declare support of contract interfaces, which can then be
866  * queried by others ({ERC165Checker}).
867  *
868  * For an implementation, see {ERC165}.
869  */
870 interface IERC165 {
871     /**
872      * @dev Returns true if this contract implements the interface defined by
873      * `interfaceId`. See the corresponding
874      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
875      * to learn more about how these ids are created.
876      *
877      * This function call must use less than 30 000 gas.
878      */
879     function supportsInterface(bytes4 interfaceId) external view returns (bool);
880 }
881 
882 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
883 
884 
885 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 
890 /**
891  * @dev Implementation of the {IERC165} interface.
892  *
893  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
894  * for the additional interface id that will be supported. For example:
895  *
896  * ```solidity
897  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
898  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
899  * }
900  * ```
901  *
902  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
903  */
904 abstract contract ERC165 is IERC165 {
905     /**
906      * @dev See {IERC165-supportsInterface}.
907      */
908     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
909         return interfaceId == type(IERC165).interfaceId;
910     }
911 }
912 
913 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
914 
915 
916 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
917 
918 pragma solidity ^0.8.0;
919 
920 
921 /**
922  * @dev Required interface of an ERC721 compliant contract.
923  */
924 interface IERC721 is IERC165 {
925     /**
926      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
927      */
928     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
929 
930     /**
931      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
932      */
933     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
934 
935     /**
936      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
937      */
938     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
939 
940     /**
941      * @dev Returns the number of tokens in ``owner``'s account.
942      */
943     function balanceOf(address owner) external view returns (uint256 balance);
944 
945     /**
946      * @dev Returns the owner of the `tokenId` token.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      */
952     function ownerOf(uint256 tokenId) external view returns (address owner);
953 
954     /**
955      * @dev Safely transfers `tokenId` token from `from` to `to`.
956      *
957      * Requirements:
958      *
959      * - `from` cannot be the zero address.
960      * - `to` cannot be the zero address.
961      * - `tokenId` token must exist and be owned by `from`.
962      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
963      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
964      *
965      * Emits a {Transfer} event.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes calldata data
972     ) external;
973 
974     /**
975      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
976      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
977      *
978      * Requirements:
979      *
980      * - `from` cannot be the zero address.
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must exist and be owned by `from`.
983      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
984      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
985      *
986      * Emits a {Transfer} event.
987      */
988     function safeTransferFrom(
989         address from,
990         address to,
991         uint256 tokenId
992     ) external;
993 
994     /**
995      * @dev Transfers `tokenId` token from `from` to `to`.
996      *
997      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
998      *
999      * Requirements:
1000      *
1001      * - `from` cannot be the zero address.
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must be owned by `from`.
1004      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function transferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) external;
1013 
1014     /**
1015      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1016      * The approval is cleared when the token is transferred.
1017      *
1018      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1019      *
1020      * Requirements:
1021      *
1022      * - The caller must own the token or be an approved operator.
1023      * - `tokenId` must exist.
1024      *
1025      * Emits an {Approval} event.
1026      */
1027     function approve(address to, uint256 tokenId) external;
1028 
1029     /**
1030      * @dev Approve or remove `operator` as an operator for the caller.
1031      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1032      *
1033      * Requirements:
1034      *
1035      * - The `operator` cannot be the caller.
1036      *
1037      * Emits an {ApprovalForAll} event.
1038      */
1039     function setApprovalForAll(address operator, bool _approved) external;
1040 
1041     /**
1042      * @dev Returns the account approved for `tokenId` token.
1043      *
1044      * Requirements:
1045      *
1046      * - `tokenId` must exist.
1047      */
1048     function getApproved(uint256 tokenId) external view returns (address operator);
1049 
1050     /**
1051      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1052      *
1053      * See {setApprovalForAll}
1054      */
1055     function isApprovedForAll(address owner, address operator) external view returns (bool);
1056 }
1057 
1058 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1059 
1060 
1061 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 
1066 /**
1067  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1068  * @dev See https://eips.ethereum.org/EIPS/eip-721
1069  */
1070 interface IERC721Metadata is IERC721 {
1071     /**
1072      * @dev Returns the token collection name.
1073      */
1074     function name() external view returns (string memory);
1075 
1076     /**
1077      * @dev Returns the token collection symbol.
1078      */
1079     function symbol() external view returns (string memory);
1080 
1081     /**
1082      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1083      */
1084     function tokenURI(uint256 tokenId) external view returns (string memory);
1085 }
1086 
1087 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1088 
1089 
1090 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 
1095 
1096 
1097 
1098 
1099 
1100 
1101 /**
1102  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1103  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1104  * {ERC721Enumerable}.
1105  */
1106 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1107     using Address for address;
1108     using Strings for uint256;
1109 
1110     // Token name
1111     string private _name;
1112 
1113     // Token symbol
1114     string private _symbol;
1115 
1116     // Mapping from token ID to owner address
1117     mapping(uint256 => address) private _owners;
1118 
1119     // Mapping owner address to token count
1120     mapping(address => uint256) private _balances;
1121 
1122     // Mapping from token ID to approved address
1123     mapping(uint256 => address) private _tokenApprovals;
1124 
1125     // Mapping from owner to operator approvals
1126     mapping(address => mapping(address => bool)) private _operatorApprovals;
1127 
1128     /**
1129      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1130      */
1131     constructor(string memory name_, string memory symbol_) {
1132         _name = name_;
1133         _symbol = symbol_;
1134     }
1135 
1136     /**
1137      * @dev See {IERC165-supportsInterface}.
1138      */
1139     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1140         return
1141             interfaceId == type(IERC721).interfaceId ||
1142             interfaceId == type(IERC721Metadata).interfaceId ||
1143             super.supportsInterface(interfaceId);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-balanceOf}.
1148      */
1149     function balanceOf(address owner) public view virtual override returns (uint256) {
1150         require(owner != address(0), "ERC721: balance query for the zero address");
1151         return _balances[owner];
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-ownerOf}.
1156      */
1157     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1158         address owner = _owners[tokenId];
1159         require(owner != address(0), "ERC721: owner query for nonexistent token");
1160         return owner;
1161     }
1162 
1163     /**
1164      * @dev See {IERC721Metadata-name}.
1165      */
1166     function name() public view virtual override returns (string memory) {
1167         return _name;
1168     }
1169 
1170     /**
1171      * @dev See {IERC721Metadata-symbol}.
1172      */
1173     function symbol() public view virtual override returns (string memory) {
1174         return _symbol;
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Metadata-tokenURI}.
1179      */
1180     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1181         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1182 
1183         string memory baseURI = _baseURI();
1184         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1185     }
1186 
1187     /**
1188      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1189      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1190      * by default, can be overridden in child contracts.
1191      */
1192     function _baseURI() internal view virtual returns (string memory) {
1193         return "";
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-approve}.
1198      */
1199     function approve(address to, uint256 tokenId) public virtual override {
1200         address owner = ERC721.ownerOf(tokenId);
1201         require(to != owner, "ERC721: approval to current owner");
1202 
1203         require(
1204             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1205             "ERC721: approve caller is not owner nor approved for all"
1206         );
1207 
1208         _approve(to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-getApproved}.
1213      */
1214     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1215         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1216 
1217         return _tokenApprovals[tokenId];
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-setApprovalForAll}.
1222      */
1223     function setApprovalForAll(address operator, bool approved) public virtual override {
1224         _setApprovalForAll(_msgSender(), operator, approved);
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-isApprovedForAll}.
1229      */
1230     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1231         return _operatorApprovals[owner][operator];
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-transferFrom}.
1236      */
1237     function transferFrom(
1238         address from,
1239         address to,
1240         uint256 tokenId
1241     ) public virtual override {
1242         //solhint-disable-next-line max-line-length
1243         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1244 
1245         _transfer(from, to, tokenId);
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-safeTransferFrom}.
1250      */
1251     function safeTransferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) public virtual override {
1256         safeTransferFrom(from, to, tokenId, "");
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-safeTransferFrom}.
1261      */
1262     function safeTransferFrom(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) public virtual override {
1268         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1269         _safeTransfer(from, to, tokenId, _data);
1270     }
1271 
1272     /**
1273      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1274      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1275      *
1276      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1277      *
1278      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1279      * implement alternative mechanisms to perform token transfer, such as signature-based.
1280      *
1281      * Requirements:
1282      *
1283      * - `from` cannot be the zero address.
1284      * - `to` cannot be the zero address.
1285      * - `tokenId` token must exist and be owned by `from`.
1286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _safeTransfer(
1291         address from,
1292         address to,
1293         uint256 tokenId,
1294         bytes memory _data
1295     ) internal virtual {
1296         _transfer(from, to, tokenId);
1297         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1298     }
1299 
1300     /**
1301      * @dev Returns whether `tokenId` exists.
1302      *
1303      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1304      *
1305      * Tokens start existing when they are minted (`_mint`),
1306      * and stop existing when they are burned (`_burn`).
1307      */
1308     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1309         return _owners[tokenId] != address(0);
1310     }
1311 
1312     /**
1313      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must exist.
1318      */
1319     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1320         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1321         address owner = ERC721.ownerOf(tokenId);
1322         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1323     }
1324 
1325     /**
1326      * @dev Safely mints `tokenId` and transfers it to `to`.
1327      *
1328      * Requirements:
1329      *
1330      * - `tokenId` must not exist.
1331      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function _safeMint(address to, uint256 tokenId) internal virtual {
1336         _safeMint(to, tokenId, "");
1337     }
1338 
1339     /**
1340      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1341      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1342      */
1343     function _safeMint(
1344         address to,
1345         uint256 tokenId,
1346         bytes memory _data
1347     ) internal virtual {
1348         _mint(to, tokenId);
1349         require(
1350             _checkOnERC721Received(address(0), to, tokenId, _data),
1351             "ERC721: transfer to non ERC721Receiver implementer"
1352         );
1353     }
1354 
1355     /**
1356      * @dev Mints `tokenId` and transfers it to `to`.
1357      *
1358      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1359      *
1360      * Requirements:
1361      *
1362      * - `tokenId` must not exist.
1363      * - `to` cannot be the zero address.
1364      *
1365      * Emits a {Transfer} event.
1366      */
1367     function _mint(address to, uint256 tokenId) internal virtual {
1368         require(to != address(0), "ERC721: mint to the zero address");
1369         require(!_exists(tokenId), "ERC721: token already minted");
1370 
1371         _beforeTokenTransfer(address(0), to, tokenId);
1372 
1373         _balances[to] += 1;
1374         _owners[tokenId] = to;
1375 
1376         emit Transfer(address(0), to, tokenId);
1377 
1378         _afterTokenTransfer(address(0), to, tokenId);
1379     }
1380 
1381     /**
1382      * @dev Destroys `tokenId`.
1383      * The approval is cleared when the token is burned.
1384      *
1385      * Requirements:
1386      *
1387      * - `tokenId` must exist.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function _burn(uint256 tokenId) internal virtual {
1392         address owner = ERC721.ownerOf(tokenId);
1393 
1394         _beforeTokenTransfer(owner, address(0), tokenId);
1395 
1396         // Clear approvals
1397         _approve(address(0), tokenId);
1398 
1399         _balances[owner] -= 1;
1400         delete _owners[tokenId];
1401 
1402         emit Transfer(owner, address(0), tokenId);
1403 
1404         _afterTokenTransfer(owner, address(0), tokenId);
1405     }
1406 
1407     /**
1408      * @dev Transfers `tokenId` from `from` to `to`.
1409      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1410      *
1411      * Requirements:
1412      *
1413      * - `to` cannot be the zero address.
1414      * - `tokenId` token must be owned by `from`.
1415      *
1416      * Emits a {Transfer} event.
1417      */
1418     function _transfer(
1419         address from,
1420         address to,
1421         uint256 tokenId
1422     ) internal virtual {
1423         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1424         require(to != address(0), "ERC721: transfer to the zero address");
1425 
1426         _beforeTokenTransfer(from, to, tokenId);
1427 
1428         // Clear approvals from the previous owner
1429         _approve(address(0), tokenId);
1430 
1431         _balances[from] -= 1;
1432         _balances[to] += 1;
1433         _owners[tokenId] = to;
1434 
1435         emit Transfer(from, to, tokenId);
1436 
1437         _afterTokenTransfer(from, to, tokenId);
1438     }
1439 
1440     /**
1441      * @dev Approve `to` to operate on `tokenId`
1442      *
1443      * Emits a {Approval} event.
1444      */
1445     function _approve(address to, uint256 tokenId) internal virtual {
1446         _tokenApprovals[tokenId] = to;
1447         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1448     }
1449 
1450     /**
1451      * @dev Approve `operator` to operate on all of `owner` tokens
1452      *
1453      * Emits a {ApprovalForAll} event.
1454      */
1455     function _setApprovalForAll(
1456         address owner,
1457         address operator,
1458         bool approved
1459     ) internal virtual {
1460         require(owner != operator, "ERC721: approve to caller");
1461         _operatorApprovals[owner][operator] = approved;
1462         emit ApprovalForAll(owner, operator, approved);
1463     }
1464 
1465     /**
1466      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1467      * The call is not executed if the target address is not a contract.
1468      *
1469      * @param from address representing the previous owner of the given token ID
1470      * @param to target address that will receive the tokens
1471      * @param tokenId uint256 ID of the token to be transferred
1472      * @param _data bytes optional data to send along with the call
1473      * @return bool whether the call correctly returned the expected magic value
1474      */
1475     function _checkOnERC721Received(
1476         address from,
1477         address to,
1478         uint256 tokenId,
1479         bytes memory _data
1480     ) private returns (bool) {
1481         if (to.isContract()) {
1482             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1483                 return retval == IERC721Receiver.onERC721Received.selector;
1484             } catch (bytes memory reason) {
1485                 if (reason.length == 0) {
1486                     revert("ERC721: transfer to non ERC721Receiver implementer");
1487                 } else {
1488                     assembly {
1489                         revert(add(32, reason), mload(reason))
1490                     }
1491                 }
1492             }
1493         } else {
1494             return true;
1495         }
1496     }
1497 
1498     /**
1499      * @dev Hook that is called before any token transfer. This includes minting
1500      * and burning.
1501      *
1502      * Calling conditions:
1503      *
1504      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1505      * transferred to `to`.
1506      * - When `from` is zero, `tokenId` will be minted for `to`.
1507      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1508      * - `from` and `to` are never both zero.
1509      *
1510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1511      */
1512     function _beforeTokenTransfer(
1513         address from,
1514         address to,
1515         uint256 tokenId
1516     ) internal virtual {}
1517 
1518     /**
1519      * @dev Hook that is called after any transfer of tokens. This includes
1520      * minting and burning.
1521      *
1522      * Calling conditions:
1523      *
1524      * - when `from` and `to` are both non-zero.
1525      * - `from` and `to` are never both zero.
1526      *
1527      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1528      */
1529     function _afterTokenTransfer(
1530         address from,
1531         address to,
1532         uint256 tokenId
1533     ) internal virtual {}
1534 }
1535 
1536 // File: OGMiceStake.sol
1537 
1538 
1539 
1540 pragma solidity >=0.7.0 <0.9.0;
1541 
1542 
1543 
1544 
1545 
1546 
1547 
1548 contract OGMiceStake is IERC721Receiver, Ownable {
1549     using EnumerableSet for EnumerableSet.UintSet;
1550 
1551     address public ERC20_CONTRACT = 0xC0F392CCe7a4Df620ae020C44081d04BED68cDFD;
1552     address public ERC721_CONTRACT = 0x30F055506Ba543EA0942Dc8cA03F596AB75Bc879;
1553     address public OLDSTAKE_CONTRACT = 0xa05e93EC605a605884Cf8e929a546E3F4D105891;
1554     uint256 public EXPIRATION; //expiry block number (avg 15s per block)
1555 
1556     mapping(address => EnumerableSet.UintSet) private _deposits;
1557     mapping(address => mapping(uint256 => uint256)) public depositBlocks;
1558     mapping (uint256 => uint256) public tokenRarity;
1559     mapping(address => bool) public userinit;
1560     uint256[1] public rewardRate;   
1561     bool started;
1562 
1563     constructor() {
1564         EXPIRATION = block.number + 100000000000;
1565         // number of tokens Per day
1566         rewardRate = [100];
1567         started = true;
1568     }
1569 
1570     function setRate(uint256 _rarity, uint256 _rate) public onlyOwner() {
1571         rewardRate[_rarity] = _rate;
1572     }
1573 
1574     function setRarity(uint256 _tokenId, uint256 _rarity) public onlyOwner() {
1575         tokenRarity[_tokenId] = _rarity;
1576     }
1577 
1578     function setBatchRarity(uint256[] memory _tokenIds, uint256 _rarity) public onlyOwner() {
1579         for (uint256 i; i < _tokenIds.length; i++) {
1580             uint256 tokenId = _tokenIds[i];
1581             tokenRarity[tokenId] = _rarity;
1582         }
1583     }
1584 
1585     function setExpiration(uint256 _expiration) public onlyOwner() {
1586         EXPIRATION = _expiration;
1587     }
1588 
1589     
1590     function toggleStart() public onlyOwner() {
1591         started = !started;
1592     }
1593 
1594     function setTokenAddress(address _tokenAddress) public onlyOwner() {
1595         // Used to change rewards token if needed
1596         ERC20_CONTRACT = _tokenAddress;
1597     }
1598 
1599     function onERC721Received(
1600         address,
1601         address,
1602         uint256,
1603         bytes calldata
1604     ) external pure override returns (bytes4) {
1605         return IERC721Receiver.onERC721Received.selector;
1606     }
1607 
1608     function depositsOf(address account)
1609         external
1610         view
1611         returns (uint256[] memory)
1612     {
1613         EnumerableSet.UintSet storage depositSet = _deposits[account];
1614         uint256[] memory tokenIds = new uint256[](depositSet.length());
1615 
1616         for (uint256 i; i < depositSet.length(); i++) {
1617             tokenIds[i] = depositSet.at(i);
1618         }
1619 
1620         return tokenIds;
1621     }
1622 
1623     function findRate(uint256 tokenId)
1624         public
1625         view
1626         returns (uint256 rate) 
1627     {
1628         uint256 rarity = tokenRarity[tokenId];
1629         uint256 perDay = rewardRate[rarity];
1630         
1631         // 6000 blocks per day
1632         // perDay / 6000 = reward per block
1633 
1634         rate = (perDay * 1e18) / 5800;
1635         
1636         return rate;
1637     }
1638 
1639     function calculateRewards(address account, uint256[] memory tokenIds)
1640         public
1641         view
1642         returns (uint256[] memory rewards)
1643     {
1644         rewards = new uint256[](tokenIds.length);
1645 
1646         for (uint256 i; i < tokenIds.length; i++) {
1647             uint256 tokenId = tokenIds[i];
1648             uint256 rate = findRate(tokenId);
1649             rewards[i] =
1650                 rate *
1651                 (_deposits[account].contains(tokenId) ? 1 : 0) *
1652                 (Math.min(block.number, EXPIRATION) -
1653                     depositBlocks[account][tokenId]);
1654         }
1655     }
1656 
1657         function depositsOfold()
1658         external
1659         view
1660         returns (uint256[] memory)
1661     {
1662         return IStake(OLDSTAKE_CONTRACT).depositsOf(msg.sender);
1663     }
1664     
1665         function blocknumber()
1666         external
1667         view
1668         returns (uint256)
1669     {
1670         return block.number;
1671     }
1672 
1673     function initolduser(address account, uint256[] memory tokenIds) external {
1674         require(!userinit[account], "You Already initialize your address");
1675         for (uint256 i; i < tokenIds.length; i++) {
1676         _deposits[account].add(tokenIds[i]);
1677         depositBlocks[msg.sender][tokenIds[i]] = 14837207;
1678         userinit[account] = true;
1679         }
1680     }
1681 
1682     function claimRewards(uint256[] calldata tokenIds) public {
1683         uint256 reward;
1684         uint256 curblock = Math.min(block.number, EXPIRATION);
1685 
1686         uint256[] memory rewards = calculateRewards(msg.sender, tokenIds);
1687 
1688         for (uint256 i; i < tokenIds.length; i++) {
1689             reward += rewards[i];
1690             depositBlocks[msg.sender][tokenIds[i]] = curblock;
1691         }
1692 
1693         if (reward > 0) {
1694             ITOKEN(ERC20_CONTRACT).mint(msg.sender, reward);
1695         }
1696     }
1697 
1698     function deposit(uint256[] calldata tokenIds) external {
1699         require(started, ' Staking contract not started yet');
1700 
1701         claimRewards(tokenIds);
1702         
1703 
1704         for (uint256 i; i < tokenIds.length; i++) {
1705             IERC721(ERC721_CONTRACT).safeTransferFrom(
1706                 msg.sender,
1707                 address(this),
1708                 tokenIds[i],
1709                 ''
1710             );
1711             _deposits[msg.sender].add(tokenIds[i]);
1712         }
1713     }
1714 
1715     function admin_deposit(uint256[] calldata tokenIds) onlyOwner() external {
1716         claimRewards(tokenIds);
1717         
1718 
1719         for (uint256 i; i < tokenIds.length; i++) {
1720             IERC721(ERC721_CONTRACT).safeTransferFrom(
1721                 msg.sender,
1722                 address(this),
1723                 tokenIds[i],
1724                 ''
1725             );
1726             _deposits[msg.sender].add(tokenIds[i]);
1727         }
1728     }
1729 
1730     function withdraw(uint256[] calldata tokenIds) external {
1731         claimRewards(tokenIds);
1732         for (uint256 i; i < tokenIds.length; i++) {
1733             require(
1734                 _deposits[msg.sender].contains(tokenIds[i]),
1735                 ' Token not deposited'
1736             );
1737 
1738             _deposits[msg.sender].remove(tokenIds[i]);
1739 
1740             IERC721(ERC721_CONTRACT).safeTransferFrom(
1741                 address(this),
1742                 msg.sender,
1743                 tokenIds[i],
1744                 ''
1745             );
1746         }
1747     }
1748 }