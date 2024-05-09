1 // SPDX-License-Identifier: MIT
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for managing
11  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
12  * types.
13  *
14  * Sets have the following properties:
15  *
16  * - Elements are added, removed, and checked for existence in constant time
17  * (O(1)).
18  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
19  *
20  * ```
21  * contract Example {
22  *     // Add the library methods
23  *     using EnumerableSet for EnumerableSet.AddressSet;
24  *
25  *     // Declare a set state variable
26  *     EnumerableSet.AddressSet private mySet;
27  * }
28  * ```
29  *
30  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
31  * and `uint256` (`UintSet`) are supported.
32  */
33 library EnumerableSet {
34     // To implement this library for multiple types with as little code
35     // repetition as possible, we write it in terms of a generic Set type with
36     // bytes32 values.
37     // The Set implementation uses private functions, and user-facing
38     // implementations (such as AddressSet) are just wrappers around the
39     // underlying Set.
40     // This means that we can only create new EnumerableSets for types that fit
41     // in bytes32.
42 
43     struct Set {
44         // Storage of set values
45         bytes32[] _values;
46         // Position of the value in the `values` array, plus 1 because index 0
47         // means a value is not in the set.
48         mapping(bytes32 => uint256) _indexes;
49     }
50 
51     /**
52      * @dev Add a value to a set. O(1).
53      *
54      * Returns true if the value was added to the set, that is if it was not
55      * already present.
56      */
57     function _add(Set storage set, bytes32 value) private returns (bool) {
58         if (!_contains(set, value)) {
59             set._values.push(value);
60             // The value is stored at length-1, but we add 1 to all indexes
61             // and use 0 as a sentinel value
62             set._indexes[value] = set._values.length;
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     /**
70      * @dev Removes a value from a set. O(1).
71      *
72      * Returns true if the value was removed from the set, that is if it was
73      * present.
74      */
75     function _remove(Set storage set, bytes32 value) private returns (bool) {
76         // We read and store the value's index to prevent multiple reads from the same storage slot
77         uint256 valueIndex = set._indexes[value];
78 
79         if (valueIndex != 0) {
80             // Equivalent to contains(set, value)
81             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
82             // the array, and then remove the last element (sometimes called as 'swap and pop').
83             // This modifies the order of the array, as noted in {at}.
84 
85             uint256 toDeleteIndex = valueIndex - 1;
86             uint256 lastIndex = set._values.length - 1;
87 
88             if (lastIndex != toDeleteIndex) {
89                 bytes32 lastValue = set._values[lastIndex];
90 
91                 // Move the last value to the index where the value to delete is
92                 set._values[toDeleteIndex] = lastValue;
93                 // Update the index for the moved value
94                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
95             }
96 
97             // Delete the slot where the moved value was stored
98             set._values.pop();
99 
100             // Delete the index for the deleted slot
101             delete set._indexes[value];
102 
103             return true;
104         } else {
105             return false;
106         }
107     }
108 
109     /**
110      * @dev Returns true if the value is in the set. O(1).
111      */
112     function _contains(Set storage set, bytes32 value) private view returns (bool) {
113         return set._indexes[value] != 0;
114     }
115 
116     /**
117      * @dev Returns the number of values on the set. O(1).
118      */
119     function _length(Set storage set) private view returns (uint256) {
120         return set._values.length;
121     }
122 
123     /**
124      * @dev Returns the value stored at position `index` in the set. O(1).
125      *
126      * Note that there are no guarantees on the ordering of values inside the
127      * array, and it may change when more values are added or removed.
128      *
129      * Requirements:
130      *
131      * - `index` must be strictly less than {length}.
132      */
133     function _at(Set storage set, uint256 index) private view returns (bytes32) {
134         return set._values[index];
135     }
136 
137     /**
138      * @dev Return the entire set in an array
139      *
140      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
141      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
142      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
143      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
144      */
145     function _values(Set storage set) private view returns (bytes32[] memory) {
146         return set._values;
147     }
148 
149     // Bytes32Set
150 
151     struct Bytes32Set {
152         Set _inner;
153     }
154 
155     /**
156      * @dev Add a value to a set. O(1).
157      *
158      * Returns true if the value was added to the set, that is if it was not
159      * already present.
160      */
161     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
162         return _add(set._inner, value);
163     }
164 
165     /**
166      * @dev Removes a value from a set. O(1).
167      *
168      * Returns true if the value was removed from the set, that is if it was
169      * present.
170      */
171     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
172         return _remove(set._inner, value);
173     }
174 
175     /**
176      * @dev Returns true if the value is in the set. O(1).
177      */
178     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
179         return _contains(set._inner, value);
180     }
181 
182     /**
183      * @dev Returns the number of values in the set. O(1).
184      */
185     function length(Bytes32Set storage set) internal view returns (uint256) {
186         return _length(set._inner);
187     }
188 
189     /**
190      * @dev Returns the value stored at position `index` in the set. O(1).
191      *
192      * Note that there are no guarantees on the ordering of values inside the
193      * array, and it may change when more values are added or removed.
194      *
195      * Requirements:
196      *
197      * - `index` must be strictly less than {length}.
198      */
199     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
200         return _at(set._inner, index);
201     }
202 
203     /**
204      * @dev Return the entire set in an array
205      *
206      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
207      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
208      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
209      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
210      */
211     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
212         return _values(set._inner);
213     }
214 
215     // AddressSet
216 
217     struct AddressSet {
218         Set _inner;
219     }
220 
221     /**
222      * @dev Add a value to a set. O(1).
223      *
224      * Returns true if the value was added to the set, that is if it was not
225      * already present.
226      */
227     function add(AddressSet storage set, address value) internal returns (bool) {
228         return _add(set._inner, bytes32(uint256(uint160(value))));
229     }
230 
231     /**
232      * @dev Removes a value from a set. O(1).
233      *
234      * Returns true if the value was removed from the set, that is if it was
235      * present.
236      */
237     function remove(AddressSet storage set, address value) internal returns (bool) {
238         return _remove(set._inner, bytes32(uint256(uint160(value))));
239     }
240 
241     /**
242      * @dev Returns true if the value is in the set. O(1).
243      */
244     function contains(AddressSet storage set, address value) internal view returns (bool) {
245         return _contains(set._inner, bytes32(uint256(uint160(value))));
246     }
247 
248     /**
249      * @dev Returns the number of values in the set. O(1).
250      */
251     function length(AddressSet storage set) internal view returns (uint256) {
252         return _length(set._inner);
253     }
254 
255     /**
256      * @dev Returns the value stored at position `index` in the set. O(1).
257      *
258      * Note that there are no guarantees on the ordering of values inside the
259      * array, and it may change when more values are added or removed.
260      *
261      * Requirements:
262      *
263      * - `index` must be strictly less than {length}.
264      */
265     function at(AddressSet storage set, uint256 index) internal view returns (address) {
266         return address(uint160(uint256(_at(set._inner, index))));
267     }
268 
269     /**
270      * @dev Return the entire set in an array
271      *
272      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
273      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
274      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
275      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
276      */
277     function values(AddressSet storage set) internal view returns (address[] memory) {
278         bytes32[] memory store = _values(set._inner);
279         address[] memory result;
280 
281         assembly {
282             result := store
283         }
284 
285         return result;
286     }
287 
288     // UintSet
289 
290     struct UintSet {
291         Set _inner;
292     }
293 
294     /**
295      * @dev Add a value to a set. O(1).
296      *
297      * Returns true if the value was added to the set, that is if it was not
298      * already present.
299      */
300     function add(UintSet storage set, uint256 value) internal returns (bool) {
301         return _add(set._inner, bytes32(value));
302     }
303 
304     /**
305      * @dev Removes a value from a set. O(1).
306      *
307      * Returns true if the value was removed from the set, that is if it was
308      * present.
309      */
310     function remove(UintSet storage set, uint256 value) internal returns (bool) {
311         return _remove(set._inner, bytes32(value));
312     }
313 
314     /**
315      * @dev Returns true if the value is in the set. O(1).
316      */
317     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
318         return _contains(set._inner, bytes32(value));
319     }
320 
321     /**
322      * @dev Returns the number of values on the set. O(1).
323      */
324     function length(UintSet storage set) internal view returns (uint256) {
325         return _length(set._inner);
326     }
327 
328     /**
329      * @dev Returns the value stored at position `index` in the set. O(1).
330      *
331      * Note that there are no guarantees on the ordering of values inside the
332      * array, and it may change when more values are added or removed.
333      *
334      * Requirements:
335      *
336      * - `index` must be strictly less than {length}.
337      */
338     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
339         return uint256(_at(set._inner, index));
340     }
341 
342     /**
343      * @dev Return the entire set in an array
344      *
345      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
346      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
347      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
348      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
349      */
350     function values(UintSet storage set) internal view returns (uint256[] memory) {
351         bytes32[] memory store = _values(set._inner);
352         uint256[] memory result;
353 
354         assembly {
355             result := store
356         }
357 
358         return result;
359     }
360 }
361 
362 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @title Counters
371  * @author Matt Condon (@shrugs)
372  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
373  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
374  *
375  * Include with `using Counters for Counters.Counter;`
376  */
377 library Counters {
378     struct Counter {
379         // This variable should never be directly accessed by users of the library: interactions must be restricted to
380         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
381         // this feature: see https://github.com/ethereum/solidity/issues/4637
382         uint256 _value; // default: 0
383     }
384 
385     function current(Counter storage counter) internal view returns (uint256) {
386         return counter._value;
387     }
388 
389     function increment(Counter storage counter) internal {
390         unchecked {
391             counter._value += 1;
392         }
393     }
394 
395     function decrement(Counter storage counter) internal {
396         uint256 value = counter._value;
397         require(value > 0, "Counter: decrement overflow");
398         unchecked {
399             counter._value = value - 1;
400         }
401     }
402 
403     function reset(Counter storage counter) internal {
404         counter._value = 0;
405     }
406 }
407 
408 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @dev String operations.
417  */
418 library Strings {
419     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
420 
421     /**
422      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
423      */
424     function toString(uint256 value) internal pure returns (string memory) {
425         // Inspired by OraclizeAPI's implementation - MIT licence
426         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
427 
428         if (value == 0) {
429             return "0";
430         }
431         uint256 temp = value;
432         uint256 digits;
433         while (temp != 0) {
434             digits++;
435             temp /= 10;
436         }
437         bytes memory buffer = new bytes(digits);
438         while (value != 0) {
439             digits -= 1;
440             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
441             value /= 10;
442         }
443         return string(buffer);
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
448      */
449     function toHexString(uint256 value) internal pure returns (string memory) {
450         if (value == 0) {
451             return "0x00";
452         }
453         uint256 temp = value;
454         uint256 length = 0;
455         while (temp != 0) {
456             length++;
457             temp >>= 8;
458         }
459         return toHexString(value, length);
460     }
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
464      */
465     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
466         bytes memory buffer = new bytes(2 * length + 2);
467         buffer[0] = "0";
468         buffer[1] = "x";
469         for (uint256 i = 2 * length + 1; i > 1; --i) {
470             buffer[i] = _HEX_SYMBOLS[value & 0xf];
471             value >>= 4;
472         }
473         require(value == 0, "Strings: hex length insufficient");
474         return string(buffer);
475     }
476 }
477 
478 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev Provides information about the current execution context, including the
487  * sender of the transaction and its data. While these are generally available
488  * via msg.sender and msg.data, they should not be accessed in such a direct
489  * manner, since when dealing with meta-transactions the account sending and
490  * paying for execution may not be the actual sender (as far as an application
491  * is concerned).
492  *
493  * This contract is only required for intermediate, library-like contracts.
494  */
495 abstract contract Context {
496     function _msgSender() internal view virtual returns (address) {
497         return msg.sender;
498     }
499 
500     function _msgData() internal view virtual returns (bytes calldata) {
501         return msg.data;
502     }
503 }
504 
505 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Contract module which provides a basic access control mechanism, where
515  * there is an account (an owner) that can be granted exclusive access to
516  * specific functions.
517  *
518  * By default, the owner account will be the one that deploys the contract. This
519  * can later be changed with {transferOwnership}.
520  *
521  * This module is used through inheritance. It will make available the modifier
522  * `onlyOwner`, which can be applied to your functions to restrict their use to
523  * the owner.
524  */
525 abstract contract Ownable is Context {
526     address private _owner;
527 
528     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
529 
530     /**
531      * @dev Initializes the contract setting the deployer as the initial owner.
532      */
533     constructor() {
534         _transferOwnership(_msgSender());
535     }
536 
537     /**
538      * @dev Returns the address of the current owner.
539      */
540     function owner() public view virtual returns (address) {
541         return _owner;
542     }
543 
544     /**
545      * @dev Throws if called by any account other than the owner.
546      */
547     modifier onlyOwner() {
548         require(owner() == _msgSender(), "Ownable: caller is not the owner");
549         _;
550     }
551 
552     /**
553      * @dev Leaves the contract without owner. It will not be possible to call
554      * `onlyOwner` functions anymore. Can only be called by the current owner.
555      *
556      * NOTE: Renouncing ownership will leave the contract without an owner,
557      * thereby removing any functionality that is only available to the owner.
558      */
559     function renounceOwnership() public virtual onlyOwner {
560         _transferOwnership(address(0));
561     }
562 
563     /**
564      * @dev Transfers ownership of the contract to a new account (`newOwner`).
565      * Can only be called by the current owner.
566      */
567     function transferOwnership(address newOwner) public virtual onlyOwner {
568         require(newOwner != address(0), "Ownable: new owner is the zero address");
569         _transferOwnership(newOwner);
570     }
571 
572     /**
573      * @dev Transfers ownership of the contract to a new account (`newOwner`).
574      * Internal function without access restriction.
575      */
576     function _transferOwnership(address newOwner) internal virtual {
577         address oldOwner = _owner;
578         _owner = newOwner;
579         emit OwnershipTransferred(oldOwner, newOwner);
580     }
581 }
582 
583 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
584 
585 
586 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
587 
588 pragma solidity ^0.8.1;
589 
590 /**
591  * @dev Collection of functions related to the address type
592  */
593 library Address {
594     /**
595      * @dev Returns true if `account` is a contract.
596      *
597      * [IMPORTANT]
598      * ====
599      * It is unsafe to assume that an address for which this function returns
600      * false is an externally-owned account (EOA) and not a contract.
601      *
602      * Among others, `isContract` will return false for the following
603      * types of addresses:
604      *
605      *  - an externally-owned account
606      *  - a contract in construction
607      *  - an address where a contract will be created
608      *  - an address where a contract lived, but was destroyed
609      * ====
610      *
611      * [IMPORTANT]
612      * ====
613      * You shouldn't rely on `isContract` to protect against flash loan attacks!
614      *
615      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
616      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
617      * constructor.
618      * ====
619      */
620     function isContract(address account) internal view returns (bool) {
621         // This method relies on extcodesize/address.code.length, which returns 0
622         // for contracts in construction, since the code is only stored at the end
623         // of the constructor execution.
624 
625         return account.code.length > 0;
626     }
627 
628     /**
629      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
630      * `recipient`, forwarding all available gas and reverting on errors.
631      *
632      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
633      * of certain opcodes, possibly making contracts go over the 2300 gas limit
634      * imposed by `transfer`, making them unable to receive funds via
635      * `transfer`. {sendValue} removes this limitation.
636      *
637      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
638      *
639      * IMPORTANT: because control is transferred to `recipient`, care must be
640      * taken to not create reentrancy vulnerabilities. Consider using
641      * {ReentrancyGuard} or the
642      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
643      */
644     function sendValue(address payable recipient, uint256 amount) internal {
645         require(address(this).balance >= amount, "Address: insufficient balance");
646 
647         (bool success, ) = recipient.call{value: amount}("");
648         require(success, "Address: unable to send value, recipient may have reverted");
649     }
650 
651     /**
652      * @dev Performs a Solidity function call using a low level `call`. A
653      * plain `call` is an unsafe replacement for a function call: use this
654      * function instead.
655      *
656      * If `target` reverts with a revert reason, it is bubbled up by this
657      * function (like regular Solidity function calls).
658      *
659      * Returns the raw returned data. To convert to the expected return value,
660      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
661      *
662      * Requirements:
663      *
664      * - `target` must be a contract.
665      * - calling `target` with `data` must not revert.
666      *
667      * _Available since v3.1._
668      */
669     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
670         return functionCall(target, data, "Address: low-level call failed");
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
675      * `errorMessage` as a fallback revert reason when `target` reverts.
676      *
677      * _Available since v3.1._
678      */
679     function functionCall(
680         address target,
681         bytes memory data,
682         string memory errorMessage
683     ) internal returns (bytes memory) {
684         return functionCallWithValue(target, data, 0, errorMessage);
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
689      * but also transferring `value` wei to `target`.
690      *
691      * Requirements:
692      *
693      * - the calling contract must have an ETH balance of at least `value`.
694      * - the called Solidity function must be `payable`.
695      *
696      * _Available since v3.1._
697      */
698     function functionCallWithValue(
699         address target,
700         bytes memory data,
701         uint256 value
702     ) internal returns (bytes memory) {
703         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
704     }
705 
706     /**
707      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
708      * with `errorMessage` as a fallback revert reason when `target` reverts.
709      *
710      * _Available since v3.1._
711      */
712     function functionCallWithValue(
713         address target,
714         bytes memory data,
715         uint256 value,
716         string memory errorMessage
717     ) internal returns (bytes memory) {
718         require(address(this).balance >= value, "Address: insufficient balance for call");
719         require(isContract(target), "Address: call to non-contract");
720 
721         (bool success, bytes memory returndata) = target.call{value: value}(data);
722         return verifyCallResult(success, returndata, errorMessage);
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
727      * but performing a static call.
728      *
729      * _Available since v3.3._
730      */
731     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
732         return functionStaticCall(target, data, "Address: low-level static call failed");
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
737      * but performing a static call.
738      *
739      * _Available since v3.3._
740      */
741     function functionStaticCall(
742         address target,
743         bytes memory data,
744         string memory errorMessage
745     ) internal view returns (bytes memory) {
746         require(isContract(target), "Address: static call to non-contract");
747 
748         (bool success, bytes memory returndata) = target.staticcall(data);
749         return verifyCallResult(success, returndata, errorMessage);
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
754      * but performing a delegate call.
755      *
756      * _Available since v3.4._
757      */
758     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
759         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
764      * but performing a delegate call.
765      *
766      * _Available since v3.4._
767      */
768     function functionDelegateCall(
769         address target,
770         bytes memory data,
771         string memory errorMessage
772     ) internal returns (bytes memory) {
773         require(isContract(target), "Address: delegate call to non-contract");
774 
775         (bool success, bytes memory returndata) = target.delegatecall(data);
776         return verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
781      * revert reason using the provided one.
782      *
783      * _Available since v4.3._
784      */
785     function verifyCallResult(
786         bool success,
787         bytes memory returndata,
788         string memory errorMessage
789     ) internal pure returns (bytes memory) {
790         if (success) {
791             return returndata;
792         } else {
793             // Look for revert reason and bubble it up if present
794             if (returndata.length > 0) {
795                 // The easiest way to bubble the revert reason is using memory via assembly
796 
797                 assembly {
798                     let returndata_size := mload(returndata)
799                     revert(add(32, returndata), returndata_size)
800                 }
801             } else {
802                 revert(errorMessage);
803             }
804         }
805     }
806 }
807 
808 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
809 
810 
811 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
812 
813 pragma solidity ^0.8.0;
814 
815 /**
816  * @title ERC721 token receiver interface
817  * @dev Interface for any contract that wants to support safeTransfers
818  * from ERC721 asset contracts.
819  */
820 interface IERC721Receiver {
821     /**
822      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
823      * by `operator` from `from`, this function is called.
824      *
825      * It must return its Solidity selector to confirm the token transfer.
826      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
827      *
828      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
829      */
830     function onERC721Received(
831         address operator,
832         address from,
833         uint256 tokenId,
834         bytes calldata data
835     ) external returns (bytes4);
836 }
837 
838 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
839 
840 
841 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
842 
843 pragma solidity ^0.8.0;
844 
845 /**
846  * @dev Interface of the ERC165 standard, as defined in the
847  * https://eips.ethereum.org/EIPS/eip-165[EIP].
848  *
849  * Implementers can declare support of contract interfaces, which can then be
850  * queried by others ({ERC165Checker}).
851  *
852  * For an implementation, see {ERC165}.
853  */
854 interface IERC165 {
855     /**
856      * @dev Returns true if this contract implements the interface defined by
857      * `interfaceId`. See the corresponding
858      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
859      * to learn more about how these ids are created.
860      *
861      * This function call must use less than 30 000 gas.
862      */
863     function supportsInterface(bytes4 interfaceId) external view returns (bool);
864 }
865 
866 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
867 
868 
869 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 
874 /**
875  * @dev Implementation of the {IERC165} interface.
876  *
877  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
878  * for the additional interface id that will be supported. For example:
879  *
880  * ```solidity
881  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
882  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
883  * }
884  * ```
885  *
886  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
887  */
888 abstract contract ERC165 is IERC165 {
889     /**
890      * @dev See {IERC165-supportsInterface}.
891      */
892     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
893         return interfaceId == type(IERC165).interfaceId;
894     }
895 }
896 
897 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
898 
899 
900 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 
905 /**
906  * @dev Required interface of an ERC721 compliant contract.
907  */
908 interface IERC721 is IERC165 {
909     /**
910      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
911      */
912     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
913 
914     /**
915      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
916      */
917     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
918 
919     /**
920      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
921      */
922     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
923 
924     /**
925      * @dev Returns the number of tokens in ``owner``'s account.
926      */
927     function balanceOf(address owner) external view returns (uint256 balance);
928 
929     /**
930      * @dev Returns the owner of the `tokenId` token.
931      *
932      * Requirements:
933      *
934      * - `tokenId` must exist.
935      */
936     function ownerOf(uint256 tokenId) external view returns (address owner);
937 
938     /**
939      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
940      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
941      *
942      * Requirements:
943      *
944      * - `from` cannot be the zero address.
945      * - `to` cannot be the zero address.
946      * - `tokenId` token must exist and be owned by `from`.
947      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) external;
957 
958     /**
959      * @dev Transfers `tokenId` token from `from` to `to`.
960      *
961      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
962      *
963      * Requirements:
964      *
965      * - `from` cannot be the zero address.
966      * - `to` cannot be the zero address.
967      * - `tokenId` token must be owned by `from`.
968      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
969      *
970      * Emits a {Transfer} event.
971      */
972     function transferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) external;
977 
978     /**
979      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
980      * The approval is cleared when the token is transferred.
981      *
982      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
983      *
984      * Requirements:
985      *
986      * - The caller must own the token or be an approved operator.
987      * - `tokenId` must exist.
988      *
989      * Emits an {Approval} event.
990      */
991     function approve(address to, uint256 tokenId) external;
992 
993     /**
994      * @dev Returns the account approved for `tokenId` token.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      */
1000     function getApproved(uint256 tokenId) external view returns (address operator);
1001 
1002     /**
1003      * @dev Approve or remove `operator` as an operator for the caller.
1004      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1005      *
1006      * Requirements:
1007      *
1008      * - The `operator` cannot be the caller.
1009      *
1010      * Emits an {ApprovalForAll} event.
1011      */
1012     function setApprovalForAll(address operator, bool _approved) external;
1013 
1014     /**
1015      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1016      *
1017      * See {setApprovalForAll}
1018      */
1019     function isApprovedForAll(address owner, address operator) external view returns (bool);
1020 
1021     /**
1022      * @dev Safely transfers `tokenId` token from `from` to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `from` cannot be the zero address.
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must exist and be owned by `from`.
1029      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1030      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes calldata data
1039     ) external;
1040 }
1041 
1042 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1043 
1044 
1045 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 
1050 /**
1051  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1052  * @dev See https://eips.ethereum.org/EIPS/eip-721
1053  */
1054 interface IERC721Metadata is IERC721 {
1055     /**
1056      * @dev Returns the token collection name.
1057      */
1058     function name() external view returns (string memory);
1059 
1060     /**
1061      * @dev Returns the token collection symbol.
1062      */
1063     function symbol() external view returns (string memory);
1064 
1065     /**
1066      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1067      */
1068     function tokenURI(uint256 tokenId) external view returns (string memory);
1069 }
1070 
1071 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1072 
1073 
1074 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1075 
1076 pragma solidity ^0.8.0;
1077 
1078 
1079 
1080 
1081 
1082 
1083 
1084 
1085 /**
1086  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1087  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1088  * {ERC721Enumerable}.
1089  */
1090 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1091     using Address for address;
1092     using Strings for uint256;
1093 
1094     // Token name
1095     string private _name;
1096 
1097     // Token symbol
1098     string private _symbol;
1099 
1100     // Mapping from token ID to owner address
1101     mapping(uint256 => address) private _owners;
1102 
1103     // Mapping owner address to token count
1104     mapping(address => uint256) private _balances;
1105 
1106     // Mapping from token ID to approved address
1107     mapping(uint256 => address) private _tokenApprovals;
1108 
1109     // Mapping from owner to operator approvals
1110     mapping(address => mapping(address => bool)) private _operatorApprovals;
1111 
1112     /**
1113      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1114      */
1115     constructor(string memory name_, string memory symbol_) {
1116         _name = name_;
1117         _symbol = symbol_;
1118     }
1119 
1120     /**
1121      * @dev See {IERC165-supportsInterface}.
1122      */
1123     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1124         return
1125             interfaceId == type(IERC721).interfaceId ||
1126             interfaceId == type(IERC721Metadata).interfaceId ||
1127             super.supportsInterface(interfaceId);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-balanceOf}.
1132      */
1133     function balanceOf(address owner) public view virtual override returns (uint256) {
1134         require(owner != address(0), "ERC721: balance query for the zero address");
1135         return _balances[owner];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-ownerOf}.
1140      */
1141     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1142         address owner = _owners[tokenId];
1143         require(owner != address(0), "ERC721: owner query for nonexistent token");
1144         return owner;
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Metadata-name}.
1149      */
1150     function name() public view virtual override returns (string memory) {
1151         return _name;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Metadata-symbol}.
1156      */
1157     function symbol() public view virtual override returns (string memory) {
1158         return _symbol;
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Metadata-tokenURI}.
1163      */
1164     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1165         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1166 
1167         string memory baseURI = _baseURI();
1168         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1169     }
1170 
1171     /**
1172      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1173      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1174      * by default, can be overridden in child contracts.
1175      */
1176     function _baseURI() internal view virtual returns (string memory) {
1177         return "";
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-approve}.
1182      */
1183     function approve(address to, uint256 tokenId) public virtual override {
1184         address owner = ERC721.ownerOf(tokenId);
1185         require(to != owner, "ERC721: approval to current owner");
1186 
1187         require(
1188             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1189             "ERC721: approve caller is not owner nor approved for all"
1190         );
1191 
1192         _approve(to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-getApproved}.
1197      */
1198     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1199         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1200 
1201         return _tokenApprovals[tokenId];
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-setApprovalForAll}.
1206      */
1207     function setApprovalForAll(address operator, bool approved) public virtual override {
1208         _setApprovalForAll(_msgSender(), operator, approved);
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-isApprovedForAll}.
1213      */
1214     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1215         return _operatorApprovals[owner][operator];
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-transferFrom}.
1220      */
1221     function transferFrom(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) public virtual override {
1226         //solhint-disable-next-line max-line-length
1227         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1228 
1229         _transfer(from, to, tokenId);
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-safeTransferFrom}.
1234      */
1235     function safeTransferFrom(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) public virtual override {
1240         safeTransferFrom(from, to, tokenId, "");
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-safeTransferFrom}.
1245      */
1246     function safeTransferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId,
1250         bytes memory _data
1251     ) public virtual override {
1252         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1253         _safeTransfer(from, to, tokenId, _data);
1254     }
1255 
1256     /**
1257      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1258      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1259      *
1260      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1261      *
1262      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1263      * implement alternative mechanisms to perform token transfer, such as signature-based.
1264      *
1265      * Requirements:
1266      *
1267      * - `from` cannot be the zero address.
1268      * - `to` cannot be the zero address.
1269      * - `tokenId` token must exist and be owned by `from`.
1270      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _safeTransfer(
1275         address from,
1276         address to,
1277         uint256 tokenId,
1278         bytes memory _data
1279     ) internal virtual {
1280         _transfer(from, to, tokenId);
1281         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1282     }
1283 
1284     /**
1285      * @dev Returns whether `tokenId` exists.
1286      *
1287      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1288      *
1289      * Tokens start existing when they are minted (`_mint`),
1290      * and stop existing when they are burned (`_burn`).
1291      */
1292     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1293         return _owners[tokenId] != address(0);
1294     }
1295 
1296     /**
1297      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1298      *
1299      * Requirements:
1300      *
1301      * - `tokenId` must exist.
1302      */
1303     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1304         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1305         address owner = ERC721.ownerOf(tokenId);
1306         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1307     }
1308 
1309     /**
1310      * @dev Safely mints `tokenId` and transfers it to `to`.
1311      *
1312      * Requirements:
1313      *
1314      * - `tokenId` must not exist.
1315      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _safeMint(address to, uint256 tokenId) internal virtual {
1320         _safeMint(to, tokenId, "");
1321     }
1322 
1323     /**
1324      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1325      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1326      */
1327     function _safeMint(
1328         address to,
1329         uint256 tokenId,
1330         bytes memory _data
1331     ) internal virtual {
1332         _mint(to, tokenId);
1333         require(
1334             _checkOnERC721Received(address(0), to, tokenId, _data),
1335             "ERC721: transfer to non ERC721Receiver implementer"
1336         );
1337     }
1338 
1339     /**
1340      * @dev Mints `tokenId` and transfers it to `to`.
1341      *
1342      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1343      *
1344      * Requirements:
1345      *
1346      * - `tokenId` must not exist.
1347      * - `to` cannot be the zero address.
1348      *
1349      * Emits a {Transfer} event.
1350      */
1351     function _mint(address to, uint256 tokenId) internal virtual {
1352         require(to != address(0), "ERC721: mint to the zero address");
1353         require(!_exists(tokenId), "ERC721: token already minted");
1354 
1355         _beforeTokenTransfer(address(0), to, tokenId);
1356 
1357         _balances[to] += 1;
1358         _owners[tokenId] = to;
1359 
1360         emit Transfer(address(0), to, tokenId);
1361 
1362         _afterTokenTransfer(address(0), to, tokenId);
1363     }
1364 
1365     /**
1366      * @dev Destroys `tokenId`.
1367      * The approval is cleared when the token is burned.
1368      *
1369      * Requirements:
1370      *
1371      * - `tokenId` must exist.
1372      *
1373      * Emits a {Transfer} event.
1374      */
1375     function _burn(uint256 tokenId) internal virtual {
1376         address owner = ERC721.ownerOf(tokenId);
1377 
1378         _beforeTokenTransfer(owner, address(0), tokenId);
1379 
1380         // Clear approvals
1381         _approve(address(0), tokenId);
1382 
1383         _balances[owner] -= 1;
1384         delete _owners[tokenId];
1385 
1386         emit Transfer(owner, address(0), tokenId);
1387 
1388         _afterTokenTransfer(owner, address(0), tokenId);
1389     }
1390 
1391     /**
1392      * @dev Transfers `tokenId` from `from` to `to`.
1393      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1394      *
1395      * Requirements:
1396      *
1397      * - `to` cannot be the zero address.
1398      * - `tokenId` token must be owned by `from`.
1399      *
1400      * Emits a {Transfer} event.
1401      */
1402     function _transfer(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) internal virtual {
1407         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1408         require(to != address(0), "ERC721: transfer to the zero address");
1409 
1410         _beforeTokenTransfer(from, to, tokenId);
1411 
1412         // Clear approvals from the previous owner
1413         _approve(address(0), tokenId);
1414 
1415         _balances[from] -= 1;
1416         _balances[to] += 1;
1417         _owners[tokenId] = to;
1418 
1419         emit Transfer(from, to, tokenId);
1420 
1421         _afterTokenTransfer(from, to, tokenId);
1422     }
1423 
1424     /**
1425      * @dev Approve `to` to operate on `tokenId`
1426      *
1427      * Emits a {Approval} event.
1428      */
1429     function _approve(address to, uint256 tokenId) internal virtual {
1430         _tokenApprovals[tokenId] = to;
1431         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1432     }
1433 
1434     /**
1435      * @dev Approve `operator` to operate on all of `owner` tokens
1436      *
1437      * Emits a {ApprovalForAll} event.
1438      */
1439     function _setApprovalForAll(
1440         address owner,
1441         address operator,
1442         bool approved
1443     ) internal virtual {
1444         require(owner != operator, "ERC721: approve to caller");
1445         _operatorApprovals[owner][operator] = approved;
1446         emit ApprovalForAll(owner, operator, approved);
1447     }
1448 
1449     /**
1450      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1451      * The call is not executed if the target address is not a contract.
1452      *
1453      * @param from address representing the previous owner of the given token ID
1454      * @param to target address that will receive the tokens
1455      * @param tokenId uint256 ID of the token to be transferred
1456      * @param _data bytes optional data to send along with the call
1457      * @return bool whether the call correctly returned the expected magic value
1458      */
1459     function _checkOnERC721Received(
1460         address from,
1461         address to,
1462         uint256 tokenId,
1463         bytes memory _data
1464     ) private returns (bool) {
1465         if (to.isContract()) {
1466             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1467                 return retval == IERC721Receiver.onERC721Received.selector;
1468             } catch (bytes memory reason) {
1469                 if (reason.length == 0) {
1470                     revert("ERC721: transfer to non ERC721Receiver implementer");
1471                 } else {
1472                     assembly {
1473                         revert(add(32, reason), mload(reason))
1474                     }
1475                 }
1476             }
1477         } else {
1478             return true;
1479         }
1480     }
1481 
1482     /**
1483      * @dev Hook that is called before any token transfer. This includes minting
1484      * and burning.
1485      *
1486      * Calling conditions:
1487      *
1488      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1489      * transferred to `to`.
1490      * - When `from` is zero, `tokenId` will be minted for `to`.
1491      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1492      * - `from` and `to` are never both zero.
1493      *
1494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1495      */
1496     function _beforeTokenTransfer(
1497         address from,
1498         address to,
1499         uint256 tokenId
1500     ) internal virtual {}
1501 
1502     /**
1503      * @dev Hook that is called after any transfer of tokens. This includes
1504      * minting and burning.
1505      *
1506      * Calling conditions:
1507      *
1508      * - when `from` and `to` are both non-zero.
1509      * - `from` and `to` are never both zero.
1510      *
1511      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1512      */
1513     function _afterTokenTransfer(
1514         address from,
1515         address to,
1516         uint256 tokenId
1517     ) internal virtual {}
1518 }
1519 
1520 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Burnable.sol
1521 
1522 
1523 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1524 
1525 pragma solidity ^0.8.0;
1526 
1527 
1528 
1529 /**
1530  * @title ERC721 Burnable Token
1531  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1532  */
1533 abstract contract ERC721Burnable is Context, ERC721 {
1534     /**
1535      * @dev Burns `tokenId`. See {ERC721-_burn}.
1536      *
1537      * Requirements:
1538      *
1539      * - The caller must own `tokenId` or be an approved operator.
1540      */
1541     function burn(uint256 tokenId) public virtual {
1542         //solhint-disable-next-line max-line-length
1543         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1544         _burn(tokenId);
1545     }
1546 }
1547 
1548 // File: wgg.sol
1549 
1550 
1551 
1552 pragma solidity 0.8.7;
1553 
1554 
1555 
1556 
1557 contract WGG is ERC721Burnable, Ownable {
1558    
1559     using Strings for uint256;
1560     using Counters for Counters.Counter;
1561     
1562     string public baseURI;
1563     string public baseExtension = ".json";
1564     uint8 public maxTx = 3;
1565     uint256 public maxSupply = 10000;
1566     uint256 public price = 0.08 ether;
1567     
1568     bool public goatPresaleOpen = true;
1569     bool public goatMainsaleOpen = false;
1570     
1571     Counters.Counter private _tokenIdTracker;
1572 
1573     mapping (address => bool) whiteListed;
1574     mapping (address => uint256) walletMinted;
1575     
1576     constructor(string memory _initBaseURI) ERC721("Wild Goat Gang", "WGG")
1577     {
1578         setBaseURI(_initBaseURI);
1579 
1580         for(uint i=0;i<10;i++)
1581         {
1582             _tokenIdTracker.increment();
1583             _safeMint(msg.sender, totalToken());
1584         }
1585     }
1586     
1587     modifier isPresaleOpen
1588     {
1589          require(goatPresaleOpen == true);
1590          _;
1591     }
1592 
1593     modifier isMainsaleOpen
1594     {
1595          require(goatMainsaleOpen == true);
1596          _;
1597     }
1598 
1599     function flipPresale() public onlyOwner
1600     {
1601         goatPresaleOpen = false;
1602         goatMainsaleOpen = true;
1603     }
1604 
1605     function changeMaxSupply(uint256 _maxSupply) public onlyOwner
1606     {
1607         maxSupply = _maxSupply;
1608     }
1609     
1610     function totalToken() public view returns (uint256) {
1611             return _tokenIdTracker.current();
1612     }
1613 
1614     function addWhiteList(address[] memory whiteListedAddresses) public onlyOwner
1615     {
1616         for(uint256 i=0; i<whiteListedAddresses.length;i++)
1617         {
1618             whiteListed[whiteListedAddresses[i]] = true;
1619         }
1620     }
1621 
1622     function isAddressWhitelisted(address whitelist) public view returns(bool)
1623     {
1624         return whiteListed[whitelist];
1625     }
1626 
1627 
1628     function preSale(uint8 mintTotal) public payable isPresaleOpen
1629     {
1630         uint256 totalMinted = mintTotal + walletMinted[msg.sender];
1631         
1632         require(whiteListed[msg.sender] == true, "You are not whitelisted!");
1633         require(totalMinted <= maxTx, "Mint exceeds limitations");
1634         require(mintTotal >= 1 , "Mint Amount Incorrect");
1635         require(msg.value >= price * mintTotal, "Minting a Wild Goat Costs 0.08 Ether Each!");
1636         require(totalToken() < maxSupply, "SOLD OUT!");
1637        
1638         for(uint i=0;i<mintTotal;i++)
1639         {
1640             require(totalToken() < maxSupply, "SOLD OUT!");
1641             _tokenIdTracker.increment();
1642             _safeMint(msg.sender, totalToken());
1643         }
1644     }
1645 
1646     
1647     function mainSale(uint8 mintTotal) public payable isMainsaleOpen
1648     {
1649         uint256 totalMinted = mintTotal + walletMinted[msg.sender];
1650 
1651         require(totalMinted <= maxTx, "Mint exceeds limitations");
1652         require(mintTotal >= 1 , "Mint Amount Incorrect");
1653         require(msg.value >= price * mintTotal, "Minting a Wild Goat Costs 0.08 Ether Each!");
1654         require(totalToken() < maxSupply, "SOLD OUT!");
1655        
1656         for(uint i=0;i<mintTotal;i++)
1657         {
1658             require(totalToken() < maxSupply, "SOLD OUT!");
1659             _tokenIdTracker.increment();
1660             _safeMint(msg.sender, totalToken());
1661         }
1662     }
1663    
1664     function withdrawContractEther() external onlyOwner
1665     {
1666         address payable teamOne = payable(0x9f199f62a1aCb6877AC6C82759Df34B24A484e9C);
1667         address payable teamTwo = payable(0x1599f9F775451DBd03a1a951d4D93107900276A4);
1668         address payable teamThree = payable(0xEEe7dB024C2c629556Df7F80f528913048f12fbc);
1669         address payable teamFour = payable(0xD43763625605fF5894100B24Db41EB19A9c0E65e);
1670         
1671         uint256 totalSplit = (getBalance() / 4);
1672 
1673         teamOne.transfer(totalSplit);
1674         teamTwo.transfer(totalSplit);
1675         teamThree.transfer(totalSplit);
1676         teamFour.transfer(totalSplit);
1677 
1678     }
1679     function getBalance() public view returns(uint)
1680     {
1681         return address(this).balance;
1682     }
1683    
1684     function _baseURI() internal view virtual override returns (string memory) {
1685         return baseURI;
1686     }
1687    
1688     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1689         baseURI = _newBaseURI;
1690     }
1691    
1692     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1693     {
1694         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1695 
1696         string memory currentBaseURI = _baseURI();
1697         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1698     }
1699 }
1700 // File: ERC20I.sol
1701 
1702 
1703 pragma solidity ^0.8.0;
1704 
1705 contract ERC20I {
1706     // Token Params
1707     string public name;
1708     string public symbol;
1709     constructor(string memory name_, string memory symbol_) {
1710         name = name_;
1711         symbol = symbol_;
1712     }
1713 
1714     // Decimals
1715     uint8 public constant decimals = 18;
1716 
1717     // Supply
1718     uint256 public totalSupply;
1719     
1720     // Mappings of Balances
1721     mapping(address => uint256) public balanceOf;
1722     mapping(address => mapping(address => uint256)) public allowance;
1723 
1724     // Events
1725     event Transfer(address indexed from, address indexed to, uint256 value);
1726     event Approval(address indexed owner, address indexed spender, uint256 value);
1727 
1728     // Internal Functions
1729     function _mint(address to_, uint256 amount_) internal virtual {
1730         totalSupply += amount_;
1731         balanceOf[to_] += amount_;
1732         emit Transfer(address(0x0), to_, amount_);
1733     }
1734     function _burn(address from_, uint256 amount_) internal virtual {
1735         balanceOf[from_] -= amount_;
1736         totalSupply -= amount_;
1737         emit Transfer(from_, address(0x0), amount_);
1738     }
1739     function _approve(address owner_, address spender_, uint256 amount_) internal virtual {
1740         allowance[owner_][spender_] = amount_;
1741         emit Approval(owner_, spender_, amount_);
1742     }
1743 
1744     // Public Functions
1745     function approve(address spender_, uint256 amount_) public virtual returns (bool) {
1746         _approve(msg.sender, spender_, amount_);
1747         return true;
1748     }
1749     function transfer(address to_, uint256 amount_) public virtual returns (bool) {
1750         balanceOf[msg.sender] -= amount_;
1751         balanceOf[to_] += amount_;
1752         emit Transfer(msg.sender, to_, amount_);
1753         return true;
1754     }
1755     function transferFrom(address from_, address to_, uint256 amount_) public virtual returns (bool) {
1756         if (allowance[from_][msg.sender] != type(uint256).max) {
1757             allowance[from_][msg.sender] -= amount_; }
1758         balanceOf[from_] -= amount_;
1759         balanceOf[to_] += amount_;
1760         emit Transfer(from_, to_, amount_);
1761         return true;
1762     }
1763 
1764     // 0xInuarashi Custom Functions
1765     function multiTransfer(address[] memory to_, uint256[] memory amounts_) public virtual {
1766         require(to_.length == amounts_.length, "ERC20I: To and Amounts length Mismatch!");
1767         for (uint256 i = 0; i < to_.length; i++) {
1768             transfer(to_[i], amounts_[i]);
1769         }
1770     }
1771     function multiTransferFrom(address[] memory from_, address[] memory to_, uint256[] memory amounts_) public virtual {
1772         require(from_.length == to_.length && from_.length == amounts_.length, "ERC20I: From, To, and Amounts length Mismatch!");
1773         for (uint256 i = 0; i < from_.length; i++) {
1774             transferFrom(from_[i], to_[i], amounts_[i]);
1775         }
1776     }
1777 }
1778 
1779 abstract contract ERC20IBurnable is ERC20I {
1780     function burn(uint256 amount_) external virtual {
1781         _burn(msg.sender, amount_);
1782     }
1783     function burnFrom(address from_, uint256 amount_) public virtual {
1784         uint256 _currentAllowance = allowance[from_][msg.sender];
1785         require(_currentAllowance >= amount_, "ERC20IBurnable: Burn amount requested exceeds allowance!");
1786 
1787         if (allowance[from_][msg.sender] != type(uint256).max) {
1788             allowance[from_][msg.sender] -= amount_; }
1789 
1790         _burn(from_, amount_);
1791     }
1792 }
1793 // File: hayy.sol
1794 
1795 
1796 pragma solidity 0.8.7;
1797 
1798 
1799 contract HAYY is ERC20IBurnable, IERC721Receiver, Ownable {
1800 
1801     constructor() ERC20I("HAYY", "HAYY") {}
1802 
1803     using EnumerableSet for EnumerableSet.UintSet;
1804 
1805     mapping(address => EnumerableSet.UintSet) private _deposits;
1806     mapping(address => bool) public addressStaked;
1807     mapping(uint256 => uint256) public tokenIDDays;
1808 
1809     WGG public wildGoat = WGG(0xd151BbC88DB8A7803a2ca7a9722037aBdAca9B8e);
1810 
1811     uint256 ratePerDay = 10 ether; 
1812     uint256 lockingPeriod = 1;
1813 
1814     uint256 tier1Hayy = 600 ether;
1815     uint256 tier1Cost = 0.5 ether;
1816 
1817     uint256 tier2Hayy = 1000 ether;
1818     uint256 tier2Cost = 1 ether;
1819 
1820     uint256 tier3Hayy = 2250 ether;
1821     uint256 tier3Cost = 2.5 ether;
1822 
1823     uint256[] public burnedTokens;
1824 
1825     function addBurnedTokens(uint256 tokenId) public onlyOwner
1826     {
1827         burnedTokens.push(tokenId);
1828     }
1829 
1830     function changeTier1(uint256 totalHayy, uint256 hayCost) public onlyOwner
1831     {
1832         tier1Hayy = (totalHayy * 10 ** 18);
1833         tier1Cost = (hayCost * 10 ** 18);
1834     }
1835 
1836     function changeTier2(uint256 totalHayy, uint256 hayCost) public onlyOwner
1837     {
1838         tier2Hayy = (totalHayy * 10 ** 18);
1839         tier2Cost = (hayCost * 10 ** 18);
1840     }
1841 
1842     function changeTier3(uint256 totalHayy, uint256 hayCost) public onlyOwner
1843     {
1844         tier3Hayy = (totalHayy * 10 ** 18);
1845         tier3Cost = (hayCost * 10 ** 18);
1846     }
1847 
1848     function devMint(uint256 amount) public onlyOwner
1849     {
1850         _mint(msg.sender, (amount * 10 ** 18));
1851     }
1852 
1853     function setWGGAddress(address incoming) public onlyOwner
1854     {
1855         wildGoat = WGG(incoming);
1856     }
1857 
1858     function buyHayy(uint256 tierLevel) public payable
1859     {
1860         require(tierLevel >= 1 && tierLevel <= 3);
1861         if(tierLevel == 1)
1862         {
1863             require(msg.value >= tier1Cost);
1864             _mint(msg.sender, tier1Hayy);
1865         }
1866         else if(tierLevel == 2)
1867         {
1868             require(msg.value >= tier2Cost);
1869             _mint(msg.sender, tier2Hayy);
1870         }
1871         else if(tierLevel == 3)
1872         {
1873             require(msg.value >= tier3Cost);
1874             _mint(msg.sender, tier3Hayy);
1875         }
1876     }
1877     
1878     function changeRatePerDay(uint256 _rate) public onlyOwner
1879     {
1880         ratePerDay = (_rate * 10 ** 18);
1881     }
1882 
1883     function changeLockingPeriod(uint256 _period) public onlyOwner
1884     {
1885         lockingPeriod = _period;
1886     }
1887 
1888     function stakeGoat(uint256[] calldata tokenIDs) external {
1889         
1890         require(wildGoat.isApprovedForAll(msg.sender, address(this)), "You are not Approved!");
1891         
1892         
1893         for (uint256 i; i < tokenIDs.length; i++) {
1894             wildGoat.safeTransferFrom(
1895                 msg.sender,
1896                 address(this),
1897                 tokenIDs[i],
1898                 ''
1899             );
1900             
1901             _deposits[msg.sender].add(tokenIDs[i]);
1902             addressStaked[msg.sender] = true;
1903             tokenIDDays[tokenIDs[i]] = block.timestamp;
1904         }
1905         
1906     }
1907 
1908     function unstakeGoat(uint256[] calldata tokenIds) external {
1909         
1910         require(wildGoat.isApprovedForAll(msg.sender, address(this)), "You are not Approved!");
1911         
1912         this.claimHayy();
1913 
1914         for (uint256 i; i < tokenIds.length; i++) {
1915             require(
1916                 _deposits[msg.sender].contains(tokenIds[i]),
1917                 'Token not deposited'
1918             );
1919 
1920             require(daysStaked(tokenIds[i]) >= lockingPeriod, "You must be staked for at least 3 days!");
1921             
1922             _deposits[msg.sender].remove(tokenIds[i]);
1923             
1924             wildGoat.safeTransferFrom(
1925                 address(this),
1926                 msg.sender,
1927                 tokenIds[i],
1928                 ''
1929             );
1930         }
1931         if(_deposits[msg.sender].length() < 1)
1932         {
1933             addressStaked[msg.sender] = false;
1934         }
1935     }
1936 
1937     function returnStakedGoats() public view returns (uint256[] memory)
1938     {
1939         return _deposits[msg.sender].values();
1940     }
1941 
1942     function claimHayy() external
1943     {
1944         uint256 totalReward = 0;
1945         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
1946         {
1947             totalReward += rewardsToPay(_deposits[msg.sender].at(i));
1948             tokenIDDays[_deposits[msg.sender].at(i)] = block.timestamp;
1949         }
1950         _mint(msg.sender, totalReward);
1951     }
1952 
1953     function rewardsToPay(uint256 tokenID) internal view returns(uint256)
1954     {
1955         uint256 earnedRewards = daysStaked(tokenID) * ratePerDay;
1956                 
1957         return earnedRewards;
1958     }
1959 
1960     function daysStaked(uint256 tokenID) public view returns(uint256)
1961     {
1962         
1963         require(
1964             _deposits[msg.sender].contains(tokenID),
1965             'Token not deposited'
1966         );
1967         
1968         uint256 returndays;
1969         uint256 timeCalc = block.timestamp - tokenIDDays[tokenID];
1970         returndays = timeCalc / 86400;
1971        
1972         return returndays;
1973     }
1974 
1975     function totalYieldEarned() public view returns(uint256)
1976     {
1977         uint256 totalReward = 0;
1978         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
1979         {
1980             totalReward += rewardsToPay(_deposits[msg.sender].at(i));
1981         }
1982         return totalReward;
1983     }
1984 
1985     function goatsStaked() public view returns (uint256[] memory)
1986     {
1987         return _deposits[msg.sender].values();
1988     }
1989 
1990     function withdrawContractEther() external onlyOwner
1991     {
1992         payable(msg.sender).transfer(address(this).balance);
1993     }
1994 
1995     function walletOfOwner(address address_) public view returns (uint256[] memory) {
1996         uint256 _balance = wildGoat.balanceOf(address_);
1997         if (_balance == 0) return new uint256[](0);
1998 
1999         uint256[] memory _tokens = new uint256[] (_balance);
2000         uint256 _index;
2001         bool burned = false;
2002         
2003         
2004         for (uint256 i = 1; i <= wildGoat.totalToken(); i++) {
2005             burned = false;
2006             
2007             for(uint256 x=0; x<burnedTokens.length;x++)
2008             {
2009                 if(i == burnedTokens[x])
2010                 {
2011                     burned = true;
2012                 }
2013             }
2014             if(!burned)
2015             {
2016                 if (wildGoat.ownerOf(i) == address_) {
2017                     _tokens[_index] = i; _index++;
2018                 }
2019             }
2020 
2021         }
2022         return _tokens;
2023     }
2024 
2025     function onERC721Received(
2026         address,
2027         address,
2028         uint256,
2029         bytes calldata
2030     ) external pure override returns (bytes4) {
2031         return IERC721Receiver.onERC721Received.selector;
2032     }
2033 
2034 }