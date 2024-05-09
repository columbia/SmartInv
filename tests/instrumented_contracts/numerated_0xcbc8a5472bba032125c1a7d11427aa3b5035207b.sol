1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
5 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
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
32  *
33  * [WARNING]
34  * ====
35  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
36  * unusable.
37  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
38  *
39  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
40  * array of EnumerableSet.
41  * ====
42  */
43 library EnumerableSet {
44     // To implement this library for multiple types with as little code
45     // repetition as possible, we write it in terms of a generic Set type with
46     // bytes32 values.
47     // The Set implementation uses private functions, and user-facing
48     // implementations (such as AddressSet) are just wrappers around the
49     // underlying Set.
50     // This means that we can only create new EnumerableSets for types that fit
51     // in bytes32.
52 
53     struct Set {
54         // Storage of set values
55         bytes32[] _values;
56         // Position of the value in the `values` array, plus 1 because index 0
57         // means a value is not in the set.
58         mapping(bytes32 => uint256) _indexes;
59     }
60 
61     /**
62      * @dev Add a value to a set. O(1).
63      *
64      * Returns true if the value was added to the set, that is if it was not
65      * already present.
66      */
67     function _add(Set storage set, bytes32 value) private returns (bool) {
68         if (!_contains(set, value)) {
69             set._values.push(value);
70             // The value is stored at length-1, but we add 1 to all indexes
71             // and use 0 as a sentinel value
72             set._indexes[value] = set._values.length;
73             return true;
74         } else {
75             return false;
76         }
77     }
78 
79     /**
80      * @dev Removes a value from a set. O(1).
81      *
82      * Returns true if the value was removed from the set, that is if it was
83      * present.
84      */
85     function _remove(Set storage set, bytes32 value) private returns (bool) {
86         // We read and store the value's index to prevent multiple reads from the same storage slot
87         uint256 valueIndex = set._indexes[value];
88 
89         if (valueIndex != 0) {
90             // Equivalent to contains(set, value)
91             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
92             // the array, and then remove the last element (sometimes called as 'swap and pop').
93             // This modifies the order of the array, as noted in {at}.
94 
95             uint256 toDeleteIndex = valueIndex - 1;
96             uint256 lastIndex = set._values.length - 1;
97 
98             if (lastIndex != toDeleteIndex) {
99                 bytes32 lastValue = set._values[lastIndex];
100 
101                 // Move the last value to the index where the value to delete is
102                 set._values[toDeleteIndex] = lastValue;
103                 // Update the index for the moved value
104                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
105             }
106 
107             // Delete the slot where the moved value was stored
108             set._values.pop();
109 
110             // Delete the index for the deleted slot
111             delete set._indexes[value];
112 
113             return true;
114         } else {
115             return false;
116         }
117     }
118 
119     /**
120      * @dev Returns true if the value is in the set. O(1).
121      */
122     function _contains(Set storage set, bytes32 value) private view returns (bool) {
123         return set._indexes[value] != 0;
124     }
125 
126     /**
127      * @dev Returns the number of values on the set. O(1).
128      */
129     function _length(Set storage set) private view returns (uint256) {
130         return set._values.length;
131     }
132 
133     /**
134      * @dev Returns the value stored at position `index` in the set. O(1).
135      *
136      * Note that there are no guarantees on the ordering of values inside the
137      * array, and it may change when more values are added or removed.
138      *
139      * Requirements:
140      *
141      * - `index` must be strictly less than {length}.
142      */
143     function _at(Set storage set, uint256 index) private view returns (bytes32) {
144         return set._values[index];
145     }
146 
147     /**
148      * @dev Return the entire set in an array
149      *
150      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
151      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
152      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
153      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
154      */
155     function _values(Set storage set) private view returns (bytes32[] memory) {
156         return set._values;
157     }
158 
159     // Bytes32Set
160 
161     struct Bytes32Set {
162         Set _inner;
163     }
164 
165     /**
166      * @dev Add a value to a set. O(1).
167      *
168      * Returns true if the value was added to the set, that is if it was not
169      * already present.
170      */
171     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
172         return _add(set._inner, value);
173     }
174 
175     /**
176      * @dev Removes a value from a set. O(1).
177      *
178      * Returns true if the value was removed from the set, that is if it was
179      * present.
180      */
181     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
182         return _remove(set._inner, value);
183     }
184 
185     /**
186      * @dev Returns true if the value is in the set. O(1).
187      */
188     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
189         return _contains(set._inner, value);
190     }
191 
192     /**
193      * @dev Returns the number of values in the set. O(1).
194      */
195     function length(Bytes32Set storage set) internal view returns (uint256) {
196         return _length(set._inner);
197     }
198 
199     /**
200      * @dev Returns the value stored at position `index` in the set. O(1).
201      *
202      * Note that there are no guarantees on the ordering of values inside the
203      * array, and it may change when more values are added or removed.
204      *
205      * Requirements:
206      *
207      * - `index` must be strictly less than {length}.
208      */
209     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
210         return _at(set._inner, index);
211     }
212 
213     /**
214      * @dev Return the entire set in an array
215      *
216      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
217      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
218      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
219      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
220      */
221     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
222         bytes32[] memory store = _values(set._inner);
223         bytes32[] memory result;
224 
225         /// @solidity memory-safe-assembly
226         assembly {
227             result := store
228         }
229 
230         return result;
231     }
232 
233     // AddressSet
234 
235     struct AddressSet {
236         Set _inner;
237     }
238 
239     /**
240      * @dev Add a value to a set. O(1).
241      *
242      * Returns true if the value was added to the set, that is if it was not
243      * already present.
244      */
245     function add(AddressSet storage set, address value) internal returns (bool) {
246         return _add(set._inner, bytes32(uint256(uint160(value))));
247     }
248 
249     /**
250      * @dev Removes a value from a set. O(1).
251      *
252      * Returns true if the value was removed from the set, that is if it was
253      * present.
254      */
255     function remove(AddressSet storage set, address value) internal returns (bool) {
256         return _remove(set._inner, bytes32(uint256(uint160(value))));
257     }
258 
259     /**
260      * @dev Returns true if the value is in the set. O(1).
261      */
262     function contains(AddressSet storage set, address value) internal view returns (bool) {
263         return _contains(set._inner, bytes32(uint256(uint160(value))));
264     }
265 
266     /**
267      * @dev Returns the number of values in the set. O(1).
268      */
269     function length(AddressSet storage set) internal view returns (uint256) {
270         return _length(set._inner);
271     }
272 
273     /**
274      * @dev Returns the value stored at position `index` in the set. O(1).
275      *
276      * Note that there are no guarantees on the ordering of values inside the
277      * array, and it may change when more values are added or removed.
278      *
279      * Requirements:
280      *
281      * - `index` must be strictly less than {length}.
282      */
283     function at(AddressSet storage set, uint256 index) internal view returns (address) {
284         return address(uint160(uint256(_at(set._inner, index))));
285     }
286 
287     /**
288      * @dev Return the entire set in an array
289      *
290      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
291      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
292      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
293      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
294      */
295     function values(AddressSet storage set) internal view returns (address[] memory) {
296         bytes32[] memory store = _values(set._inner);
297         address[] memory result;
298 
299         /// @solidity memory-safe-assembly
300         assembly {
301             result := store
302         }
303 
304         return result;
305     }
306 
307     // UintSet
308 
309     struct UintSet {
310         Set _inner;
311     }
312 
313     /**
314      * @dev Add a value to a set. O(1).
315      *
316      * Returns true if the value was added to the set, that is if it was not
317      * already present.
318      */
319     function add(UintSet storage set, uint256 value) internal returns (bool) {
320         return _add(set._inner, bytes32(value));
321     }
322 
323     /**
324      * @dev Removes a value from a set. O(1).
325      *
326      * Returns true if the value was removed from the set, that is if it was
327      * present.
328      */
329     function remove(UintSet storage set, uint256 value) internal returns (bool) {
330         return _remove(set._inner, bytes32(value));
331     }
332 
333     /**
334      * @dev Returns true if the value is in the set. O(1).
335      */
336     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
337         return _contains(set._inner, bytes32(value));
338     }
339 
340     /**
341      * @dev Returns the number of values in the set. O(1).
342      */
343     function length(UintSet storage set) internal view returns (uint256) {
344         return _length(set._inner);
345     }
346 
347     /**
348      * @dev Returns the value stored at position `index` in the set. O(1).
349      *
350      * Note that there are no guarantees on the ordering of values inside the
351      * array, and it may change when more values are added or removed.
352      *
353      * Requirements:
354      *
355      * - `index` must be strictly less than {length}.
356      */
357     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
358         return uint256(_at(set._inner, index));
359     }
360 
361     /**
362      * @dev Return the entire set in an array
363      *
364      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
365      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
366      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
367      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
368      */
369     function values(UintSet storage set) internal view returns (uint256[] memory) {
370         bytes32[] memory store = _values(set._inner);
371         uint256[] memory result;
372 
373         /// @solidity memory-safe-assembly
374         assembly {
375             result := store
376         }
377 
378         return result;
379     }
380 }
381 
382 // File: contracts/IOperatorFilterRegistry.sol
383 
384 
385 pragma solidity ^0.8.13;
386 
387 
388 interface IOperatorFilterRegistry {
389     function isOperatorAllowed(address registrant, address operator) external returns (bool);
390     function register(address registrant) external;
391     function registerAndSubscribe(address registrant, address subscription) external;
392     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
393     function updateOperator(address registrant, address operator, bool filtered) external;
394     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
395     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
396     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
397     function subscribe(address registrant, address registrantToSubscribe) external;
398     function unsubscribe(address registrant, bool copyExistingEntries) external;
399     function subscriptionOf(address addr) external returns (address registrant);
400     function subscribers(address registrant) external returns (address[] memory);
401     function subscriberAt(address registrant, uint256 index) external returns (address);
402     function copyEntriesOf(address registrant, address registrantToCopy) external;
403     function isOperatorFiltered(address registrant, address operator) external returns (bool);
404     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
405     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
406     function filteredOperators(address addr) external returns (address[] memory);
407     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
408     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
409     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
410     function isRegistered(address addr) external returns (bool);
411     function codeHashOf(address addr) external returns (bytes32);
412 }
413 // File: contracts/OperatorFilterer.sol
414 
415 
416 pragma solidity ^0.8.13;
417 
418 
419 contract OperatorFilterer {
420     error OperatorNotAllowed(address operator);
421 
422     IOperatorFilterRegistry constant operatorFilterRegistry =
423         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
424 
425     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
426         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
427         // will not revert, but the contract will need to be registered with the registry once it is deployed in
428         // order for the modifier to filter addresses.
429         if (address(operatorFilterRegistry).code.length > 0) {
430             if (subscribe) {
431                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
432             } else {
433                 if (subscriptionOrRegistrantToCopy != address(0)) {
434                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
435                 } else {
436                     operatorFilterRegistry.register(address(this));
437                 }
438             }
439         }
440     }
441 
442     modifier onlyAllowedOperator() virtual {
443         // Check registry code length to facilitate testing in environments without a deployed registry.
444         if (address(operatorFilterRegistry).code.length > 0) {
445             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
446                 revert OperatorNotAllowed(msg.sender);
447             }
448         }
449         _;
450     }
451 }
452 // File: contracts/DefaultOperatorFilterer.sol
453 
454 
455 pragma solidity ^0.8.13;
456 
457 
458 contract DefaultOperatorFilterer is OperatorFilterer {
459     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
460 
461     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
462 }
463 // File: @openzeppelin/contracts/utils/Strings.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev String operations.
472  */
473 library Strings {
474     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
475 
476     /**
477      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
478      */
479     function toString(uint256 value) internal pure returns (string memory) {
480         // Inspired by OraclizeAPI's implementation - MIT licence
481         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
482 
483         if (value == 0) {
484             return "0";
485         }
486         uint256 temp = value;
487         uint256 digits;
488         while (temp != 0) {
489             digits++;
490             temp /= 10;
491         }
492         bytes memory buffer = new bytes(digits);
493         while (value != 0) {
494             digits -= 1;
495             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
496             value /= 10;
497         }
498         return string(buffer);
499     }
500 
501     /**
502      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
503      */
504     function toHexString(uint256 value) internal pure returns (string memory) {
505         if (value == 0) {
506             return "0x00";
507         }
508         uint256 temp = value;
509         uint256 length = 0;
510         while (temp != 0) {
511             length++;
512             temp >>= 8;
513         }
514         return toHexString(value, length);
515     }
516 
517     /**
518      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
519      */
520     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
521         bytes memory buffer = new bytes(2 * length + 2);
522         buffer[0] = "0";
523         buffer[1] = "x";
524         for (uint256 i = 2 * length + 1; i > 1; --i) {
525             buffer[i] = _HEX_SYMBOLS[value & 0xf];
526             value >>= 4;
527         }
528         require(value == 0, "Strings: hex length insufficient");
529         return string(buffer);
530     }
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @title ERC721 token receiver interface
542  * @dev Interface for any contract that wants to support safeTransfers
543  * from ERC721 asset contracts.
544  */
545 interface IERC721Receiver {
546     /**
547      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
548      * by `operator` from `from`, this function is called.
549      *
550      * It must return its Solidity selector to confirm the token transfer.
551      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
552      *
553      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
554      */
555     function onERC721Received(
556         address operator,
557         address from,
558         uint256 tokenId,
559         bytes calldata data
560     ) external returns (bytes4);
561 }
562 
563 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
564 
565 
566 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev Interface of the ERC165 standard, as defined in the
572  * https://eips.ethereum.org/EIPS/eip-165[EIP].
573  *
574  * Implementers can declare support of contract interfaces, which can then be
575  * queried by others ({ERC165Checker}).
576  *
577  * For an implementation, see {ERC165}.
578  */
579 interface IERC165 {
580     /**
581      * @dev Returns true if this contract implements the interface defined by
582      * `interfaceId`. See the corresponding
583      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
584      * to learn more about how these ids are created.
585      *
586      * This function call must use less than 30 000 gas.
587      */
588     function supportsInterface(bytes4 interfaceId) external view returns (bool);
589 }
590 
591 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @dev Implementation of the {IERC165} interface.
601  *
602  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
603  * for the additional interface id that will be supported. For example:
604  *
605  * ```solidity
606  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
607  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
608  * }
609  * ```
610  *
611  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
612  */
613 abstract contract ERC165 is IERC165 {
614     /**
615      * @dev See {IERC165-supportsInterface}.
616      */
617     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618         return interfaceId == type(IERC165).interfaceId;
619     }
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @dev Required interface of an ERC721 compliant contract.
632  */
633 interface IERC721 is IERC165 {
634     /**
635      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
636      */
637     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
638 
639     /**
640      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
641      */
642     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
643 
644     /**
645      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
646      */
647     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
648 
649     /**
650      * @dev Returns the number of tokens in ``owner``'s account.
651      */
652     function balanceOf(address owner) external view returns (uint256 balance);
653 
654     /**
655      * @dev Returns the owner of the `tokenId` token.
656      *
657      * Requirements:
658      *
659      * - `tokenId` must exist.
660      */
661     function ownerOf(uint256 tokenId) external view returns (address owner);
662 
663     /**
664      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
665      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must exist and be owned by `from`.
672      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
674      *
675      * Emits a {Transfer} event.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) external;
682 
683     /**
684      * @dev Transfers `tokenId` token from `from` to `to`.
685      *
686      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must be owned by `from`.
693      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
694      *
695      * Emits a {Transfer} event.
696      */
697     function transferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) external;
702 
703     /**
704      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
705      * The approval is cleared when the token is transferred.
706      *
707      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
708      *
709      * Requirements:
710      *
711      * - The caller must own the token or be an approved operator.
712      * - `tokenId` must exist.
713      *
714      * Emits an {Approval} event.
715      */
716     function approve(address to, uint256 tokenId) external;
717 
718     /**
719      * @dev Returns the account approved for `tokenId` token.
720      *
721      * Requirements:
722      *
723      * - `tokenId` must exist.
724      */
725     function getApproved(uint256 tokenId) external view returns (address operator);
726 
727     /**
728      * @dev Approve or remove `operator` as an operator for the caller.
729      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
730      *
731      * Requirements:
732      *
733      * - The `operator` cannot be the caller.
734      *
735      * Emits an {ApprovalForAll} event.
736      */
737     function setApprovalForAll(address operator, bool _approved) external;
738 
739     /**
740      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
741      *
742      * See {setApprovalForAll}
743      */
744     function isApprovedForAll(address owner, address operator) external view returns (bool);
745 
746     /**
747      * @dev Safely transfers `tokenId` token from `from` to `to`.
748      *
749      * Requirements:
750      *
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must exist and be owned by `from`.
754      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
755      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes calldata data
764     ) external;
765 }
766 
767 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
768 
769 
770 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 
775 /**
776  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
777  * @dev See https://eips.ethereum.org/EIPS/eip-721
778  */
779 interface IERC721Enumerable is IERC721 {
780     /**
781      * @dev Returns the total amount of tokens stored by the contract.
782      */
783     function totalSupply() external view returns (uint256);
784 
785     /**
786      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
787      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
788      */
789     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
790 
791     /**
792      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
793      * Use along with {totalSupply} to enumerate all tokens.
794      */
795     function tokenByIndex(uint256 index) external view returns (uint256);
796 }
797 
798 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
799 
800 
801 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
802 
803 pragma solidity ^0.8.0;
804 
805 
806 /**
807  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
808  * @dev See https://eips.ethereum.org/EIPS/eip-721
809  */
810 interface IERC721Metadata is IERC721 {
811     /**
812      * @dev Returns the token collection name.
813      */
814     function name() external view returns (string memory);
815 
816     /**
817      * @dev Returns the token collection symbol.
818      */
819     function symbol() external view returns (string memory);
820 
821     /**
822      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
823      */
824     function tokenURI(uint256 tokenId) external view returns (string memory);
825 }
826 
827 // File: @openzeppelin/contracts/utils/Context.sol
828 
829 
830 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
831 
832 pragma solidity ^0.8.0;
833 
834 /**
835  * @dev Provides information about the current execution context, including the
836  * sender of the transaction and its data. While these are generally available
837  * via msg.sender and msg.data, they should not be accessed in such a direct
838  * manner, since when dealing with meta-transactions the account sending and
839  * paying for execution may not be the actual sender (as far as an application
840  * is concerned).
841  *
842  * This contract is only required for intermediate, library-like contracts.
843  */
844 abstract contract Context {
845     function _msgSender() internal view virtual returns (address) {
846         return msg.sender;
847     }
848 
849     function _msgData() internal view virtual returns (bytes calldata) {
850         return msg.data;
851     }
852 }
853 
854 // File: @openzeppelin/contracts/access/Ownable.sol
855 
856 
857 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
858 
859 pragma solidity ^0.8.0;
860 
861 
862 /**
863  * @dev Contract module which provides a basic access control mechanism, where
864  * there is an account (an owner) that can be granted exclusive access to
865  * specific functions.
866  *
867  * By default, the owner account will be the one that deploys the contract. This
868  * can later be changed with {transferOwnership}.
869  *
870  * This module is used through inheritance. It will make available the modifier
871  * `onlyOwner`, which can be applied to your functions to restrict their use to
872  * the owner.
873  */
874 abstract contract Ownable is Context {
875     address private _owner;
876 
877     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
878 
879     /**
880      * @dev Initializes the contract setting the deployer as the initial owner.
881      */
882     constructor() {
883         _transferOwnership(_msgSender());
884     }
885 
886     /**
887      * @dev Returns the address of the current owner.
888      */
889     function owner() public view virtual returns (address) {
890         return _owner;
891     }
892 
893     /**
894      * @dev Throws if called by any account other than the owner.
895      */
896     modifier onlyOwner() {
897         require(owner() == _msgSender(), "Ownable: caller is not the owner");
898         _;
899     }
900 
901     /**
902      * @dev Leaves the contract without owner. It will not be possible to call
903      * `onlyOwner` functions anymore. Can only be called by the current owner.
904      *
905      * NOTE: Renouncing ownership will leave the contract without an owner,
906      * thereby removing any functionality that is only available to the owner.
907      */
908     function renounceOwnership() public virtual onlyOwner {
909         _transferOwnership(address(0));
910     }
911 
912     /**
913      * @dev Transfers ownership of the contract to a new account (`newOwner`).
914      * Can only be called by the current owner.
915      */
916     function transferOwnership(address newOwner) public virtual onlyOwner {
917         require(newOwner != address(0), "Ownable: new owner is the zero address");
918         _transferOwnership(newOwner);
919     }
920 
921     /**
922      * @dev Transfers ownership of the contract to a new account (`newOwner`).
923      * Internal function without access restriction.
924      */
925     function _transferOwnership(address newOwner) internal virtual {
926         address oldOwner = _owner;
927         _owner = newOwner;
928         emit OwnershipTransferred(oldOwner, newOwner);
929     }
930 }
931 
932 // File: @openzeppelin/contracts/security/Pausable.sol
933 
934 
935 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 
940 /**
941  * @dev Contract module which allows children to implement an emergency stop
942  * mechanism that can be triggered by an authorized account.
943  *
944  * This module is used through inheritance. It will make available the
945  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
946  * the functions of your contract. Note that they will not be pausable by
947  * simply including this module, only once the modifiers are put in place.
948  */
949 abstract contract Pausable is Context {
950     /**
951      * @dev Emitted when the pause is triggered by `account`.
952      */
953     event Paused(address account);
954 
955     /**
956      * @dev Emitted when the pause is lifted by `account`.
957      */
958     event Unpaused(address account);
959 
960     bool private _paused;
961 
962     /**
963      * @dev Initializes the contract in unpaused state.
964      */
965     constructor() {
966         _paused = false;
967     }
968 
969     /**
970      * @dev Modifier to make a function callable only when the contract is not paused.
971      *
972      * Requirements:
973      *
974      * - The contract must not be paused.
975      */
976     modifier whenNotPaused() {
977         _requireNotPaused();
978         _;
979     }
980 
981     /**
982      * @dev Modifier to make a function callable only when the contract is paused.
983      *
984      * Requirements:
985      *
986      * - The contract must be paused.
987      */
988     modifier whenPaused() {
989         _requirePaused();
990         _;
991     }
992 
993     /**
994      * @dev Returns true if the contract is paused, and false otherwise.
995      */
996     function paused() public view virtual returns (bool) {
997         return _paused;
998     }
999 
1000     /**
1001      * @dev Throws if the contract is paused.
1002      */
1003     function _requireNotPaused() internal view virtual {
1004         require(!paused(), "Pausable: paused");
1005     }
1006 
1007     /**
1008      * @dev Throws if the contract is not paused.
1009      */
1010     function _requirePaused() internal view virtual {
1011         require(paused(), "Pausable: not paused");
1012     }
1013 
1014     /**
1015      * @dev Triggers stopped state.
1016      *
1017      * Requirements:
1018      *
1019      * - The contract must not be paused.
1020      */
1021     function _pause() internal virtual whenNotPaused {
1022         _paused = true;
1023         emit Paused(_msgSender());
1024     }
1025 
1026     /**
1027      * @dev Returns to normal state.
1028      *
1029      * Requirements:
1030      *
1031      * - The contract must be paused.
1032      */
1033     function _unpause() internal virtual whenPaused {
1034         _paused = false;
1035         emit Unpaused(_msgSender());
1036     }
1037 }
1038 
1039 // File: @openzeppelin/contracts/utils/Address.sol
1040 
1041 
1042 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 /**
1047  * @dev Collection of functions related to the address type
1048  */
1049 library Address {
1050     /**
1051      * @dev Returns true if `account` is a contract.
1052      *
1053      * [IMPORTANT]
1054      * ====
1055      * It is unsafe to assume that an address for which this function returns
1056      * false is an externally-owned account (EOA) and not a contract.
1057      *
1058      * Among others, `isContract` will return false for the following
1059      * types of addresses:
1060      *
1061      *  - an externally-owned account
1062      *  - a contract in construction
1063      *  - an address where a contract will be created
1064      *  - an address where a contract lived, but was destroyed
1065      * ====
1066      */
1067     function isContract(address account) internal view returns (bool) {
1068         // This method relies on extcodesize, which returns 0 for contracts in
1069         // construction, since the code is only stored at the end of the
1070         // constructor execution.
1071 
1072         uint256 size;
1073         assembly {
1074             size := extcodesize(account)
1075         }
1076         return size > 0;
1077     }
1078 
1079     /**
1080      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1081      * `recipient`, forwarding all available gas and reverting on errors.
1082      *
1083      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1084      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1085      * imposed by `transfer`, making them unable to receive funds via
1086      * `transfer`. {sendValue} removes this limitation.
1087      *
1088      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1089      *
1090      * IMPORTANT: because control is transferred to `recipient`, care must be
1091      * taken to not create reentrancy vulnerabilities. Consider using
1092      * {ReentrancyGuard} or the
1093      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1094      */
1095     function sendValue(address payable recipient, uint256 amount) internal {
1096         require(address(this).balance >= amount, "Address: insufficient balance");
1097 
1098         (bool success, ) = recipient.call{value: amount}("");
1099         require(success, "Address: unable to send value, recipient may have reverted");
1100     }
1101 
1102     /**
1103      * @dev Performs a Solidity function call using a low level `call`. A
1104      * plain `call` is an unsafe replacement for a function call: use this
1105      * function instead.
1106      *
1107      * If `target` reverts with a revert reason, it is bubbled up by this
1108      * function (like regular Solidity function calls).
1109      *
1110      * Returns the raw returned data. To convert to the expected return value,
1111      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1112      *
1113      * Requirements:
1114      *
1115      * - `target` must be a contract.
1116      * - calling `target` with `data` must not revert.
1117      *
1118      * _Available since v3.1._
1119      */
1120     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1121         return functionCall(target, data, "Address: low-level call failed");
1122     }
1123 
1124     /**
1125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1126      * `errorMessage` as a fallback revert reason when `target` reverts.
1127      *
1128      * _Available since v3.1._
1129      */
1130     function functionCall(
1131         address target,
1132         bytes memory data,
1133         string memory errorMessage
1134     ) internal returns (bytes memory) {
1135         return functionCallWithValue(target, data, 0, errorMessage);
1136     }
1137 
1138     /**
1139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1140      * but also transferring `value` wei to `target`.
1141      *
1142      * Requirements:
1143      *
1144      * - the calling contract must have an ETH balance of at least `value`.
1145      * - the called Solidity function must be `payable`.
1146      *
1147      * _Available since v3.1._
1148      */
1149     function functionCallWithValue(
1150         address target,
1151         bytes memory data,
1152         uint256 value
1153     ) internal returns (bytes memory) {
1154         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1155     }
1156 
1157     /**
1158      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1159      * with `errorMessage` as a fallback revert reason when `target` reverts.
1160      *
1161      * _Available since v3.1._
1162      */
1163     function functionCallWithValue(
1164         address target,
1165         bytes memory data,
1166         uint256 value,
1167         string memory errorMessage
1168     ) internal returns (bytes memory) {
1169         require(address(this).balance >= value, "Address: insufficient balance for call");
1170         require(isContract(target), "Address: call to non-contract");
1171 
1172         (bool success, bytes memory returndata) = target.call{value: value}(data);
1173         return verifyCallResult(success, returndata, errorMessage);
1174     }
1175 
1176     /**
1177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1178      * but performing a static call.
1179      *
1180      * _Available since v3.3._
1181      */
1182     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1183         return functionStaticCall(target, data, "Address: low-level static call failed");
1184     }
1185 
1186     /**
1187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1188      * but performing a static call.
1189      *
1190      * _Available since v3.3._
1191      */
1192     function functionStaticCall(
1193         address target,
1194         bytes memory data,
1195         string memory errorMessage
1196     ) internal view returns (bytes memory) {
1197         require(isContract(target), "Address: static call to non-contract");
1198 
1199         (bool success, bytes memory returndata) = target.staticcall(data);
1200         return verifyCallResult(success, returndata, errorMessage);
1201     }
1202 
1203     /**
1204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1205      * but performing a delegate call.
1206      *
1207      * _Available since v3.4._
1208      */
1209     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1210         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1211     }
1212 
1213     /**
1214      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1215      * but performing a delegate call.
1216      *
1217      * _Available since v3.4._
1218      */
1219     function functionDelegateCall(
1220         address target,
1221         bytes memory data,
1222         string memory errorMessage
1223     ) internal returns (bytes memory) {
1224         require(isContract(target), "Address: delegate call to non-contract");
1225 
1226         (bool success, bytes memory returndata) = target.delegatecall(data);
1227         return verifyCallResult(success, returndata, errorMessage);
1228     }
1229 
1230     /**
1231      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1232      * revert reason using the provided one.
1233      *
1234      * _Available since v4.3._
1235      */
1236     function verifyCallResult(
1237         bool success,
1238         bytes memory returndata,
1239         string memory errorMessage
1240     ) internal pure returns (bytes memory) {
1241         if (success) {
1242             return returndata;
1243         } else {
1244             // Look for revert reason and bubble it up if present
1245             if (returndata.length > 0) {
1246                 // The easiest way to bubble the revert reason is using memory via assembly
1247 
1248                 assembly {
1249                     let returndata_size := mload(returndata)
1250                     revert(add(32, returndata), returndata_size)
1251                 }
1252             } else {
1253                 revert(errorMessage);
1254             }
1255         }
1256     }
1257 }
1258 
1259 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1260 
1261 
1262 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 
1267 
1268 
1269 
1270 
1271 
1272 
1273 /**
1274  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1275  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1276  * {ERC721Enumerable}.
1277  */
1278 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1279     using Address for address;
1280     using Strings for uint256;
1281 
1282     // Token name
1283     string private _name;
1284 
1285     // Token symbol
1286     string private _symbol;
1287 
1288     // Mapping from token ID to owner address
1289     mapping(uint256 => address) private _owners;
1290 
1291     // Mapping owner address to token count
1292     mapping(address => uint256) private _balances;
1293 
1294     // Mapping from token ID to approved address
1295     mapping(uint256 => address) private _tokenApprovals;
1296 
1297     // Mapping from owner to operator approvals
1298     mapping(address => mapping(address => bool)) private _operatorApprovals;
1299 
1300     /**
1301      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1302      */
1303     constructor(string memory name_, string memory symbol_) {
1304         _name = name_;
1305         _symbol = symbol_;
1306     }
1307 
1308     /**
1309      * @dev See {IERC165-supportsInterface}.
1310      */
1311     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1312         return
1313             interfaceId == type(IERC721).interfaceId ||
1314             interfaceId == type(IERC721Metadata).interfaceId ||
1315             super.supportsInterface(interfaceId);
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-balanceOf}.
1320      */
1321     function balanceOf(address owner) public view virtual override returns (uint256) {
1322         require(owner != address(0), "ERC721: balance query for the zero address");
1323         return _balances[owner];
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-ownerOf}.
1328      */
1329     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1330         address owner = _owners[tokenId];
1331         require(owner != address(0), "ERC721: owner query for nonexistent token");
1332         return owner;
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Metadata-name}.
1337      */
1338     function name() public view virtual override returns (string memory) {
1339         return _name;
1340     }
1341 
1342     /**
1343      * @dev See {IERC721Metadata-symbol}.
1344      */
1345     function symbol() public view virtual override returns (string memory) {
1346         return _symbol;
1347     }
1348 
1349     /**
1350      * @dev See {IERC721Metadata-tokenURI}.
1351      */
1352     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1353         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1354 
1355         string memory baseURI = _baseURI();
1356         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1357     }
1358 
1359     /**
1360      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1361      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1362      * by default, can be overriden in child contracts.
1363      */
1364     function _baseURI() internal view virtual returns (string memory) {
1365         return "";
1366     }
1367 
1368     /**
1369      * @dev See {IERC721-approve}.
1370      */
1371     function approve(address to, uint256 tokenId) public virtual override {
1372         address owner = ERC721.ownerOf(tokenId);
1373         require(to != owner, "ERC721: approval to current owner");
1374 
1375         require(
1376             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1377             "ERC721: approve caller is not owner nor approved for all"
1378         );
1379 
1380         _approve(to, tokenId);
1381     }
1382 
1383     /**
1384      * @dev See {IERC721-getApproved}.
1385      */
1386     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1387         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1388 
1389         return _tokenApprovals[tokenId];
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-setApprovalForAll}.
1394      */
1395     function setApprovalForAll(address operator, bool approved) public virtual override {
1396         _setApprovalForAll(_msgSender(), operator, approved);
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-isApprovedForAll}.
1401      */
1402     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1403         return _operatorApprovals[owner][operator];
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-transferFrom}.
1408      */
1409     function transferFrom(
1410         address from,
1411         address to,
1412         uint256 tokenId
1413     ) public virtual override {
1414         //solhint-disable-next-line max-line-length
1415         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1416 
1417         _transfer(from, to, tokenId);
1418     }
1419 
1420     /**
1421      * @dev See {IERC721-safeTransferFrom}.
1422      */
1423     function safeTransferFrom(
1424         address from,
1425         address to,
1426         uint256 tokenId
1427     ) public virtual override {
1428         safeTransferFrom(from, to, tokenId, "");
1429     }
1430 
1431     /**
1432      * @dev See {IERC721-safeTransferFrom}.
1433      */
1434     function safeTransferFrom(
1435         address from,
1436         address to,
1437         uint256 tokenId,
1438         bytes memory _data
1439     ) public virtual override {
1440         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1441         _safeTransfer(from, to, tokenId, _data);
1442     }
1443 
1444     /**
1445      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1446      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1447      *
1448      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1449      *
1450      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1451      * implement alternative mechanisms to perform token transfer, such as signature-based.
1452      *
1453      * Requirements:
1454      *
1455      * - `from` cannot be the zero address.
1456      * - `to` cannot be the zero address.
1457      * - `tokenId` token must exist and be owned by `from`.
1458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _safeTransfer(
1463         address from,
1464         address to,
1465         uint256 tokenId,
1466         bytes memory _data
1467     ) internal virtual {
1468         _transfer(from, to, tokenId);
1469         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1470     }
1471 
1472     /**
1473      * @dev Returns whether `tokenId` exists.
1474      *
1475      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1476      *
1477      * Tokens start existing when they are minted (`_mint`),
1478      * and stop existing when they are burned (`_burn`).
1479      */
1480     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1481         return _owners[tokenId] != address(0);
1482     }
1483 
1484     /**
1485      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1486      *
1487      * Requirements:
1488      *
1489      * - `tokenId` must exist.
1490      */
1491     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1492         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1493         address owner = ERC721.ownerOf(tokenId);
1494         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1495     }
1496 
1497     /**
1498      * @dev Safely mints `tokenId` and transfers it to `to`.
1499      *
1500      * Requirements:
1501      *
1502      * - `tokenId` must not exist.
1503      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1504      *
1505      * Emits a {Transfer} event.
1506      */
1507     function _safeMint(address to, uint256 tokenId) internal virtual {
1508         _safeMint(to, tokenId, "");
1509     }
1510 
1511     /**
1512      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1513      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1514      */
1515     function _safeMint(
1516         address to,
1517         uint256 tokenId,
1518         bytes memory _data
1519     ) internal virtual {
1520         _mint(to, tokenId);
1521         require(
1522             _checkOnERC721Received(address(0), to, tokenId, _data),
1523             "ERC721: transfer to non ERC721Receiver implementer"
1524         );
1525     }
1526 
1527     /**
1528      * @dev Mints `tokenId` and transfers it to `to`.
1529      *
1530      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1531      *
1532      * Requirements:
1533      *
1534      * - `tokenId` must not exist.
1535      * - `to` cannot be the zero address.
1536      *
1537      * Emits a {Transfer} event.
1538      */
1539     function _mint(address to, uint256 tokenId) internal virtual {
1540         require(to != address(0), "ERC721: mint to the zero address");
1541         require(!_exists(tokenId), "ERC721: token already minted");
1542 
1543         _beforeTokenTransfer(address(0), to, tokenId);
1544 
1545         _balances[to] += 1;
1546         _owners[tokenId] = to;
1547 
1548         emit Transfer(address(0), to, tokenId);
1549     }
1550 
1551     /**
1552      * @dev Destroys `tokenId`.
1553      * The approval is cleared when the token is burned.
1554      *
1555      * Requirements:
1556      *
1557      * - `tokenId` must exist.
1558      *
1559      * Emits a {Transfer} event.
1560      */
1561     function _burn(uint256 tokenId) internal virtual {
1562         address owner = ERC721.ownerOf(tokenId);
1563 
1564         _beforeTokenTransfer(owner, address(0), tokenId);
1565 
1566         // Clear approvals
1567         _approve(address(0), tokenId);
1568 
1569         _balances[owner] -= 1;
1570         delete _owners[tokenId];
1571 
1572         emit Transfer(owner, address(0), tokenId);
1573     }
1574 
1575     /**
1576      * @dev Transfers `tokenId` from `from` to `to`.
1577      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1578      *
1579      * Requirements:
1580      *
1581      * - `to` cannot be the zero address.
1582      * - `tokenId` token must be owned by `from`.
1583      *
1584      * Emits a {Transfer} event.
1585      */
1586     function _transfer(
1587         address from,
1588         address to,
1589         uint256 tokenId
1590     ) internal virtual {
1591         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1592         require(to != address(0), "ERC721: transfer to the zero address");
1593 
1594         _beforeTokenTransfer(from, to, tokenId);
1595 
1596         // Clear approvals from the previous owner
1597         _approve(address(0), tokenId);
1598 
1599         _balances[from] -= 1;
1600         _balances[to] += 1;
1601         _owners[tokenId] = to;
1602 
1603         emit Transfer(from, to, tokenId);
1604     }
1605 
1606     /**
1607      * @dev Approve `to` to operate on `tokenId`
1608      *
1609      * Emits a {Approval} event.
1610      */
1611     function _approve(address to, uint256 tokenId) internal virtual {
1612         _tokenApprovals[tokenId] = to;
1613         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1614     }
1615 
1616     /**
1617      * @dev Approve `operator` to operate on all of `owner` tokens
1618      *
1619      * Emits a {ApprovalForAll} event.
1620      */
1621     function _setApprovalForAll(
1622         address owner,
1623         address operator,
1624         bool approved
1625     ) internal virtual {
1626         require(owner != operator, "ERC721: approve to caller");
1627         _operatorApprovals[owner][operator] = approved;
1628         emit ApprovalForAll(owner, operator, approved);
1629     }
1630 
1631     /**
1632      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1633      * The call is not executed if the target address is not a contract.
1634      *
1635      * @param from address representing the previous owner of the given token ID
1636      * @param to target address that will receive the tokens
1637      * @param tokenId uint256 ID of the token to be transferred
1638      * @param _data bytes optional data to send along with the call
1639      * @return bool whether the call correctly returned the expected magic value
1640      */
1641     function _checkOnERC721Received(
1642         address from,
1643         address to,
1644         uint256 tokenId,
1645         bytes memory _data
1646     ) private returns (bool) {
1647         if (to.isContract()) {
1648             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1649                 return retval == IERC721Receiver.onERC721Received.selector;
1650             } catch (bytes memory reason) {
1651                 if (reason.length == 0) {
1652                     revert("ERC721: transfer to non ERC721Receiver implementer");
1653                 } else {
1654                     assembly {
1655                         revert(add(32, reason), mload(reason))
1656                     }
1657                 }
1658             }
1659         } else {
1660             return true;
1661         }
1662     }
1663 
1664     /**
1665      * @dev Hook that is called before any token transfer. This includes minting
1666      * and burning.
1667      *
1668      * Calling conditions:
1669      *
1670      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1671      * transferred to `to`.
1672      * - When `from` is zero, `tokenId` will be minted for `to`.
1673      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1674      * - `from` and `to` are never both zero.
1675      *
1676      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1677      */
1678     function _beforeTokenTransfer(
1679         address from,
1680         address to,
1681         uint256 tokenId
1682     ) internal virtual {}
1683 }
1684 
1685 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1686 
1687 
1688 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1689 
1690 pragma solidity ^0.8.0;
1691 
1692 
1693 
1694 /**
1695  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1696  * enumerability of all the token ids in the contract as well as all token ids owned by each
1697  * account.
1698  */
1699 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1700     // Mapping from owner to list of owned token IDs
1701     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1702 
1703     // Mapping from token ID to index of the owner tokens list
1704     mapping(uint256 => uint256) private _ownedTokensIndex;
1705 
1706     // Array with all token ids, used for enumeration
1707     uint256[] private _allTokens;
1708 
1709     // Mapping from token id to position in the allTokens array
1710     mapping(uint256 => uint256) private _allTokensIndex;
1711 
1712     /**
1713      * @dev See {IERC165-supportsInterface}.
1714      */
1715     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1716         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1717     }
1718 
1719     /**
1720      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1721      */
1722     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1723         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1724         return _ownedTokens[owner][index];
1725     }
1726 
1727     /**
1728      * @dev See {IERC721Enumerable-totalSupply}.
1729      */
1730     function totalSupply() public view virtual override returns (uint256) {
1731         return _allTokens.length;
1732     }
1733 
1734     /**
1735      * @dev See {IERC721Enumerable-tokenByIndex}.
1736      */
1737     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1738         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1739         return _allTokens[index];
1740     }
1741 
1742     /**
1743      * @dev Hook that is called before any token transfer. This includes minting
1744      * and burning.
1745      *
1746      * Calling conditions:
1747      *
1748      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1749      * transferred to `to`.
1750      * - When `from` is zero, `tokenId` will be minted for `to`.
1751      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1752      * - `from` cannot be the zero address.
1753      * - `to` cannot be the zero address.
1754      *
1755      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1756      */
1757     function _beforeTokenTransfer(
1758         address from,
1759         address to,
1760         uint256 tokenId
1761     ) internal virtual override {
1762         super._beforeTokenTransfer(from, to, tokenId);
1763 
1764         if (from == address(0)) {
1765             _addTokenToAllTokensEnumeration(tokenId);
1766         } else if (from != to) {
1767             _removeTokenFromOwnerEnumeration(from, tokenId);
1768         }
1769         if (to == address(0)) {
1770             _removeTokenFromAllTokensEnumeration(tokenId);
1771         } else if (to != from) {
1772             _addTokenToOwnerEnumeration(to, tokenId);
1773         }
1774     }
1775 
1776     /**
1777      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1778      * @param to address representing the new owner of the given token ID
1779      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1780      */
1781     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1782         uint256 length = ERC721.balanceOf(to);
1783         _ownedTokens[to][length] = tokenId;
1784         _ownedTokensIndex[tokenId] = length;
1785     }
1786 
1787     /**
1788      * @dev Private function to add a token to this extension's token tracking data structures.
1789      * @param tokenId uint256 ID of the token to be added to the tokens list
1790      */
1791     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1792         _allTokensIndex[tokenId] = _allTokens.length;
1793         _allTokens.push(tokenId);
1794     }
1795 
1796     /**
1797      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1798      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1799      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1800      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1801      * @param from address representing the previous owner of the given token ID
1802      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1803      */
1804     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1805         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1806         // then delete the last slot (swap and pop).
1807 
1808         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1809         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1810 
1811         // When the token to delete is the last token, the swap operation is unnecessary
1812         if (tokenIndex != lastTokenIndex) {
1813             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1814 
1815             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1816             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1817         }
1818 
1819         // This also deletes the contents at the last position of the array
1820         delete _ownedTokensIndex[tokenId];
1821         delete _ownedTokens[from][lastTokenIndex];
1822     }
1823 
1824     /**
1825      * @dev Private function to remove a token from this extension's token tracking data structures.
1826      * This has O(1) time complexity, but alters the order of the _allTokens array.
1827      * @param tokenId uint256 ID of the token to be removed from the tokens list
1828      */
1829     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1830         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1831         // then delete the last slot (swap and pop).
1832 
1833         uint256 lastTokenIndex = _allTokens.length - 1;
1834         uint256 tokenIndex = _allTokensIndex[tokenId];
1835 
1836         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1837         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1838         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1839         uint256 lastTokenId = _allTokens[lastTokenIndex];
1840 
1841         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1842         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1843 
1844         // This also deletes the contents at the last position of the array
1845         delete _allTokensIndex[tokenId];
1846         _allTokens.pop();
1847     }
1848 }
1849 
1850 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1851 
1852 
1853 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1854 
1855 pragma solidity ^0.8.0;
1856 
1857 
1858 
1859 /**
1860  * @title ERC721 Burnable Token
1861  * @dev ERC721 Token that can be burned (destroyed).
1862  */
1863 abstract contract ERC721Burnable is Context, ERC721 {
1864     /**
1865      * @dev Burns `tokenId`. See {ERC721-_burn}.
1866      *
1867      * Requirements:
1868      *
1869      * - The caller must own `tokenId` or be an approved operator.
1870      */
1871     function burn(uint256 tokenId) public virtual {
1872         //solhint-disable-next-line max-line-length
1873         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1874         _burn(tokenId);
1875     }
1876 }
1877 
1878 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
1879 
1880 
1881 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1882 
1883 pragma solidity ^0.8.0;
1884 
1885 /**
1886  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1887  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1888  *
1889  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1890  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1891  * need to send a transaction, and thus is not required to hold Ether at all.
1892  */
1893 interface IERC20Permit {
1894     /**
1895      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1896      * given ``owner``'s signed approval.
1897      *
1898      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1899      * ordering also apply here.
1900      *
1901      * Emits an {Approval} event.
1902      *
1903      * Requirements:
1904      *
1905      * - `spender` cannot be the zero address.
1906      * - `deadline` must be a timestamp in the future.
1907      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1908      * over the EIP712-formatted function arguments.
1909      * - the signature must use ``owner``'s current nonce (see {nonces}).
1910      *
1911      * For more information on the signature format, see the
1912      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1913      * section].
1914      */
1915     function permit(
1916         address owner,
1917         address spender,
1918         uint256 value,
1919         uint256 deadline,
1920         uint8 v,
1921         bytes32 r,
1922         bytes32 s
1923     ) external;
1924 
1925     /**
1926      * @dev Returns the current nonce for `owner`. This value must be
1927      * included whenever a signature is generated for {permit}.
1928      *
1929      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1930      * prevents a signature from being used multiple times.
1931      */
1932     function nonces(address owner) external view returns (uint256);
1933 
1934     /**
1935      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1936      */
1937     // solhint-disable-next-line func-name-mixedcase
1938     function DOMAIN_SEPARATOR() external view returns (bytes32);
1939 }
1940 
1941 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1942 
1943 
1944 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1945 
1946 pragma solidity ^0.8.0;
1947 
1948 /**
1949  * @dev Interface of the ERC20 standard as defined in the EIP.
1950  */
1951 interface IERC20 {
1952     /**
1953      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1954      * another (`to`).
1955      *
1956      * Note that `value` may be zero.
1957      */
1958     event Transfer(address indexed from, address indexed to, uint256 value);
1959 
1960     /**
1961      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1962      * a call to {approve}. `value` is the new allowance.
1963      */
1964     event Approval(address indexed owner, address indexed spender, uint256 value);
1965 
1966     /**
1967      * @dev Returns the amount of tokens in existence.
1968      */
1969     function totalSupply() external view returns (uint256);
1970 
1971     /**
1972      * @dev Returns the amount of tokens owned by `account`.
1973      */
1974     function balanceOf(address account) external view returns (uint256);
1975 
1976     /**
1977      * @dev Moves `amount` tokens from the caller's account to `to`.
1978      *
1979      * Returns a boolean value indicating whether the operation succeeded.
1980      *
1981      * Emits a {Transfer} event.
1982      */
1983     function transfer(address to, uint256 amount) external returns (bool);
1984 
1985     /**
1986      * @dev Returns the remaining number of tokens that `spender` will be
1987      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1988      * zero by default.
1989      *
1990      * This value changes when {approve} or {transferFrom} are called.
1991      */
1992     function allowance(address owner, address spender) external view returns (uint256);
1993 
1994     /**
1995      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1996      *
1997      * Returns a boolean value indicating whether the operation succeeded.
1998      *
1999      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2000      * that someone may use both the old and the new allowance by unfortunate
2001      * transaction ordering. One possible solution to mitigate this race
2002      * condition is to first reduce the spender's allowance to 0 and set the
2003      * desired value afterwards:
2004      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2005      *
2006      * Emits an {Approval} event.
2007      */
2008     function approve(address spender, uint256 amount) external returns (bool);
2009 
2010     /**
2011      * @dev Moves `amount` tokens from `from` to `to` using the
2012      * allowance mechanism. `amount` is then deducted from the caller's
2013      * allowance.
2014      *
2015      * Returns a boolean value indicating whether the operation succeeded.
2016      *
2017      * Emits a {Transfer} event.
2018      */
2019     function transferFrom(
2020         address from,
2021         address to,
2022         uint256 amount
2023     ) external returns (bool);
2024 }
2025 
2026 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2027 
2028 
2029 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
2030 
2031 pragma solidity ^0.8.0;
2032 
2033 
2034 
2035 
2036 /**
2037  * @title SafeERC20
2038  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2039  * contract returns false). Tokens that return no value (and instead revert or
2040  * throw on failure) are also supported, non-reverting calls are assumed to be
2041  * successful.
2042  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2043  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2044  */
2045 library SafeERC20 {
2046     using Address for address;
2047 
2048     function safeTransfer(
2049         IERC20 token,
2050         address to,
2051         uint256 value
2052     ) internal {
2053         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2054     }
2055 
2056     function safeTransferFrom(
2057         IERC20 token,
2058         address from,
2059         address to,
2060         uint256 value
2061     ) internal {
2062         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2063     }
2064 
2065     /**
2066      * @dev Deprecated. This function has issues similar to the ones found in
2067      * {IERC20-approve}, and its usage is discouraged.
2068      *
2069      * Whenever possible, use {safeIncreaseAllowance} and
2070      * {safeDecreaseAllowance} instead.
2071      */
2072     function safeApprove(
2073         IERC20 token,
2074         address spender,
2075         uint256 value
2076     ) internal {
2077         // safeApprove should only be called when setting an initial allowance,
2078         // or when resetting it to zero. To increase and decrease it, use
2079         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2080         require(
2081             (value == 0) || (token.allowance(address(this), spender) == 0),
2082             "SafeERC20: approve from non-zero to non-zero allowance"
2083         );
2084         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2085     }
2086 
2087     function safeIncreaseAllowance(
2088         IERC20 token,
2089         address spender,
2090         uint256 value
2091     ) internal {
2092         uint256 newAllowance = token.allowance(address(this), spender) + value;
2093         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2094     }
2095 
2096     function safeDecreaseAllowance(
2097         IERC20 token,
2098         address spender,
2099         uint256 value
2100     ) internal {
2101         unchecked {
2102             uint256 oldAllowance = token.allowance(address(this), spender);
2103             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2104             uint256 newAllowance = oldAllowance - value;
2105             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2106         }
2107     }
2108 
2109     function safePermit(
2110         IERC20Permit token,
2111         address owner,
2112         address spender,
2113         uint256 value,
2114         uint256 deadline,
2115         uint8 v,
2116         bytes32 r,
2117         bytes32 s
2118     ) internal {
2119         uint256 nonceBefore = token.nonces(owner);
2120         token.permit(owner, spender, value, deadline, v, r, s);
2121         uint256 nonceAfter = token.nonces(owner);
2122         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2123     }
2124 
2125     /**
2126      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2127      * on the return value: the return value is optional (but if data is returned, it must not be false).
2128      * @param token The token targeted by the call.
2129      * @param data The call data (encoded using abi.encode or one of its variants).
2130      */
2131     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2132         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2133         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2134         // the target address contains contract code and also asserts for success in the low-level call.
2135 
2136         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2137         if (returndata.length > 0) {
2138             // Return data is optional
2139             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2140         }
2141     }
2142 }
2143 
2144 // File: contracts/BlocksNew.sol
2145 
2146 
2147 pragma solidity 0.8.13;
2148 
2149 // ██████╗░██╗░░░░░░█████╗░░█████╗░██╗░░██╗░██████╗
2150 // ██╔══██╗██║░░░░░██╔══██╗██╔══██╗██║░██╔╝██╔════╝
2151 // ██████╦╝██║░░░░░██║░░██║██║░░╚═╝█████═╝░╚█████╗░
2152 // ██╔══██╗██║░░░░░██║░░██║██║░░██╗██╔═██╗░░╚═══██╗
2153 // ██████╦╝███████╗╚█████╔╝╚█████╔╝██║░╚██╗██████╔╝
2154 // ╚═════╝░╚══════╝░╚════╝░░╚════╝░╚═╝░░╚═╝╚═════╝░
2155 
2156 
2157 
2158 
2159 
2160 
2161 
2162 
2163 contract Blocks is ERC721Enumerable, Ownable, DefaultOperatorFilterer {
2164     using SafeERC20 for IERC20;
2165 
2166 
2167     string private _tokenBaseURI;
2168 
2169     uint256 public constant MAX_Supply = 125;
2170     uint256 private scopeIndex = 0;
2171     uint256 public price = 27000000000000000; // 0.027 Eth
2172     uint256 public reservedTokens = 0; // reserve tokens go here
2173     uint256 public mintedPresaleTokens = 0;
2174     bool public flagreserve = false;
2175 
2176     bool public hasSaleStarted = false;
2177     bool public hasPresaleStarted = false;
2178 
2179     mapping(uint256 => uint256) swappedIDs;
2180     
2181     mapping(address => uint256) userCredit;
2182    
2183    // Whitelisting
2184     
2185     mapping(address => bool) private _allowList;
2186     mapping(address => uint256) private _allowListClaimed;
2187 
2188 
2189     event MetadataHashSet(bytes32 metadataHash);
2190     
2191 
2192     constructor() ERC721("Blocks","BBH")  {
2193     }
2194 
2195     //   WHITELIST FNS
2196     
2197     function addToAllowList(address[] calldata addresses) external  onlyOwner {
2198       for (uint256 i = 0; i < addresses.length; i++) {
2199       require(addresses[i] != address(0), "Can't add the null address");
2200 
2201       _allowList[addresses[i]] = true;
2202       /**
2203       * @dev We don't want to reset _allowListClaimed count
2204       * if we try to add someone more than once.
2205       */
2206       _allowListClaimed[addresses[i]] > 0 ? _allowListClaimed[addresses[i]] : 0;
2207     }
2208   }
2209 
2210   function onAllowList(address addr) external view  returns (bool) {
2211     return _allowList[addr];
2212   }
2213 
2214   function removeFromAllowList(address[] calldata addresses) external  onlyOwner {
2215     for (uint256 i = 0; i < addresses.length; i++) {
2216       require(addresses[i] != address(0), "Can't add the null address");
2217 
2218       /// @dev We don't want to reset possible _allowListClaimed numbers.
2219       _allowList[addresses[i]] = false;
2220     }
2221   }
2222 
2223   /**
2224   * @dev We want to be able to distinguish tokens bought during isAllowListActive
2225   * and tokens bought outside of isAllowListActive
2226   */
2227   function allowListClaimedBy(address owner) external view  returns (uint256){
2228     require(owner != address(0), 'Zero address not on Allow List');
2229 
2230     return _allowListClaimed[owner];
2231   }
2232 
2233 
2234 
2235     function genID() private returns(uint256) {
2236         uint256 scope = MAX_Supply-scopeIndex;
2237         uint256 swap;
2238         uint256 result;
2239 
2240         uint256 i = randomNumber() % scope;
2241 
2242         //Setup the value to swap in for the selected ID
2243         if (swappedIDs[scope-1] == 0){
2244             swap = scope-1;
2245         } else {
2246             swap = swappedIDs[scope-1];
2247         }
2248 
2249         //Select a random ID, swap it out with an unselected one then shorten the selection range by 1
2250         if (swappedIDs[i] == 0){
2251             result = i;
2252             swappedIDs[i] = swap;
2253         } else {
2254             result = swappedIDs[i];
2255             swappedIDs[i] = swap;
2256         }
2257         return result+1;
2258     }
2259 
2260     
2261     function randomNumber() private view returns(uint256){
2262         return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
2263     }
2264 
2265     function mint() public payable  {
2266         require(hasSaleStarted == true, "Sale hasn't started");
2267         require(totalSupply() + 1 < MAX_Supply, "Exceeds MAX_Supply");
2268         require(price <= msg.value, "Ether value sent is not correct");
2269         
2270         
2271         _safeMint(msg.sender, genID());
2272         scopeIndex++;
2273     }
2274     
2275     // whitelist Mint function
2276     
2277     function mintWhitelist() public payable {
2278         require(hasPresaleStarted == true, "Presale hasn't started");
2279          require(totalSupply() + 1 < MAX_Supply, "Exceeds MAX_Supply");
2280         require(price <= msg.value, "Ether value sent is not correct");
2281         require(_allowList[msg.sender], 'You are not on the White List');
2282         //require(mintedPresaleTokens + numberOfTokens <= 4000, 'Total Purchase exceeds max allowed');
2283         
2284         _allowListClaimed[msg.sender] += 1;
2285         _safeMint(msg.sender, genID());
2286         scopeIndex++;
2287         mintedPresaleTokens++;
2288     }
2289     
2290     // Mint Reserved tokens
2291     
2292     function mintReservedTokens(address user) external  onlyOwner  {
2293       
2294         require(flagreserve == false, 'Reserved Allocated tokens');
2295         
2296         for (uint i = 0; i < 5; i++) {
2297             _safeMint(user, genID());
2298             scopeIndex++;
2299            
2300         }
2301         flagreserve =true;
2302     }
2303     
2304     function getScopeIndex() public view returns(uint256) {
2305         return scopeIndex;
2306     }
2307     
2308     function mintCredit() public {
2309         require(hasSaleStarted == true, "Sale hasn't started");
2310         require(totalSupply() + 1 <= MAX_Supply, "Exceeds MAX_Supply");
2311         require(userCredit[msg.sender] >= 1, "No Credits");
2312 
2313         _safeMint(msg.sender, genID());
2314         scopeIndex++;
2315         userCredit[msg.sender] -= 1;
2316     }
2317 
2318     function balanceOfCredit(address owner) public view virtual returns (uint256) {
2319         require(owner != address(0), "ERC721: balance query for the zero address");
2320         return userCredit[owner];
2321     }
2322 
2323   // A withdraw function to avoid locking ERC20 tokens in the contract forever.
2324   // Tokens can only be withdrawn by the owner, to the owner.
2325   function transferERC20Token(IERC20 token, uint256 amount) external onlyOwner {
2326     token.safeTransfer(owner(), amount);
2327   }
2328 
2329  
2330 
2331   function setTokenBaseURI(string calldata tokenBaseURI_) external onlyOwner {
2332     _tokenBaseURI = tokenBaseURI_;
2333   }
2334 
2335   function _baseURI() internal view override returns (string memory) {
2336     return _tokenBaseURI;
2337   }
2338 
2339 
2340     function startSale() public onlyOwner {
2341         hasSaleStarted = true;
2342     }
2343     
2344     function pauseSale() public onlyOwner {
2345         hasSaleStarted = false;
2346     }
2347     
2348     function startPresale() public onlyOwner {
2349         hasPresaleStarted = true;
2350     }
2351     
2352     function pausePresale() public onlyOwner {
2353         hasPresaleStarted = false;
2354     }
2355 
2356     function withdrawAll() public onlyOwner {
2357         address payable owner_add = payable( msg.sender);
2358         owner_add.transfer(address(this).balance);
2359     }
2360 
2361     function addCredit(address owner, uint256 credits) public onlyOwner {
2362         userCredit[owner] += credits;
2363     }
2364 
2365 
2366 
2367 
2368   function _beforeTokenTransfer(
2369     address from,
2370     address to,
2371     uint256 tokenId
2372   ) internal override(ERC721Enumerable) {
2373     super._beforeTokenTransfer(from, to, tokenId);
2374   }
2375 
2376     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
2377         uint256 tokenCount = balanceOf(_owner);
2378         if (tokenCount == 0) {
2379             
2380             return new uint256[](0);
2381         } else {
2382             uint256[] memory result = new uint256[](tokenCount);
2383             uint256 index;
2384             for (index = 0; index < tokenCount; index++) {
2385                 result[index] = tokenOfOwnerByIndex(_owner, index);
2386             }
2387             return result;
2388         }
2389     }
2390 
2391     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721,IERC721 ) onlyAllowedOperator {
2392         super.transferFrom(from, to, tokenId);
2393     }
2394 
2395     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721,IERC721 ) onlyAllowedOperator {
2396         super.safeTransferFrom(from, to, tokenId);
2397     }
2398 
2399     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2400         public
2401         override(ERC721,IERC721 )
2402         onlyAllowedOperator
2403     {
2404         super.safeTransferFrom(from, to, tokenId, data);
2405     }
2406 
2407 
2408 
2409 }