1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
6 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Library for managing
12  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
13  * types.
14  *
15  * Sets have the following properties:
16  *
17  * - Elements are added, removed, and checked for existence in constant time
18  * (O(1)).
19  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
20  *
21  * ```
22  * contract Example {
23  *     // Add the library methods
24  *     using EnumerableSet for EnumerableSet.AddressSet;
25  *
26  *     // Declare a set state variable
27  *     EnumerableSet.AddressSet private mySet;
28  * }
29  * ```
30  *
31  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
32  * and `uint256` (`UintSet`) are supported.
33  *
34  * [WARNING]
35  * ====
36  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
37  * unusable.
38  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
39  *
40  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
41  * array of EnumerableSet.
42  * ====
43  */
44 library EnumerableSet {
45     // To implement this library for multiple types with as little code
46     // repetition as possible, we write it in terms of a generic Set type with
47     // bytes32 values.
48     // The Set implementation uses private functions, and user-facing
49     // implementations (such as AddressSet) are just wrappers around the
50     // underlying Set.
51     // This means that we can only create new EnumerableSets for types that fit
52     // in bytes32.
53 
54     struct Set {
55         // Storage of set values
56         bytes32[] _values;
57         // Position of the value in the `values` array, plus 1 because index 0
58         // means a value is not in the set.
59         mapping(bytes32 => uint256) _indexes;
60     }
61 
62     /**
63      * @dev Add a value to a set. O(1).
64      *
65      * Returns true if the value was added to the set, that is if it was not
66      * already present.
67      */
68     function _add(Set storage set, bytes32 value) private returns (bool) {
69         if (!_contains(set, value)) {
70             set._values.push(value);
71             // The value is stored at length-1, but we add 1 to all indexes
72             // and use 0 as a sentinel value
73             set._indexes[value] = set._values.length;
74             return true;
75         } else {
76             return false;
77         }
78     }
79 
80     /**
81      * @dev Removes a value from a set. O(1).
82      *
83      * Returns true if the value was removed from the set, that is if it was
84      * present.
85      */
86     function _remove(Set storage set, bytes32 value) private returns (bool) {
87         // We read and store the value's index to prevent multiple reads from the same storage slot
88         uint256 valueIndex = set._indexes[value];
89 
90         if (valueIndex != 0) {
91             // Equivalent to contains(set, value)
92             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
93             // the array, and then remove the last element (sometimes called as 'swap and pop').
94             // This modifies the order of the array, as noted in {at}.
95 
96             uint256 toDeleteIndex = valueIndex - 1;
97             uint256 lastIndex = set._values.length - 1;
98 
99             if (lastIndex != toDeleteIndex) {
100                 bytes32 lastValue = set._values[lastIndex];
101 
102                 // Move the last value to the index where the value to delete is
103                 set._values[toDeleteIndex] = lastValue;
104                 // Update the index for the moved value
105                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
106             }
107 
108             // Delete the slot where the moved value was stored
109             set._values.pop();
110 
111             // Delete the index for the deleted slot
112             delete set._indexes[value];
113 
114             return true;
115         } else {
116             return false;
117         }
118     }
119 
120     /**
121      * @dev Returns true if the value is in the set. O(1).
122      */
123     function _contains(Set storage set, bytes32 value) private view returns (bool) {
124         return set._indexes[value] != 0;
125     }
126 
127     /**
128      * @dev Returns the number of values on the set. O(1).
129      */
130     function _length(Set storage set) private view returns (uint256) {
131         return set._values.length;
132     }
133 
134     /**
135      * @dev Returns the value stored at position `index` in the set. O(1).
136      *
137      * Note that there are no guarantees on the ordering of values inside the
138      * array, and it may change when more values are added or removed.
139      *
140      * Requirements:
141      *
142      * - `index` must be strictly less than {length}.
143      */
144     function _at(Set storage set, uint256 index) private view returns (bytes32) {
145         return set._values[index];
146     }
147 
148     /**
149      * @dev Return the entire set in an array
150      *
151      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
152      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
153      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
154      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
155      */
156     function _values(Set storage set) private view returns (bytes32[] memory) {
157         return set._values;
158     }
159 
160     // Bytes32Set
161 
162     struct Bytes32Set {
163         Set _inner;
164     }
165 
166     /**
167      * @dev Add a value to a set. O(1).
168      *
169      * Returns true if the value was added to the set, that is if it was not
170      * already present.
171      */
172     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
173         return _add(set._inner, value);
174     }
175 
176     /**
177      * @dev Removes a value from a set. O(1).
178      *
179      * Returns true if the value was removed from the set, that is if it was
180      * present.
181      */
182     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
183         return _remove(set._inner, value);
184     }
185 
186     /**
187      * @dev Returns true if the value is in the set. O(1).
188      */
189     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
190         return _contains(set._inner, value);
191     }
192 
193     /**
194      * @dev Returns the number of values in the set. O(1).
195      */
196     function length(Bytes32Set storage set) internal view returns (uint256) {
197         return _length(set._inner);
198     }
199 
200     /**
201      * @dev Returns the value stored at position `index` in the set. O(1).
202      *
203      * Note that there are no guarantees on the ordering of values inside the
204      * array, and it may change when more values are added or removed.
205      *
206      * Requirements:
207      *
208      * - `index` must be strictly less than {length}.
209      */
210     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
211         return _at(set._inner, index);
212     }
213 
214     /**
215      * @dev Return the entire set in an array
216      *
217      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
218      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
219      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
220      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
221      */
222     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
223         bytes32[] memory store = _values(set._inner);
224         bytes32[] memory result;
225 
226         /// @solidity memory-safe-assembly
227         assembly {
228             result := store
229         }
230 
231         return result;
232     }
233 
234     // AddressSet
235 
236     struct AddressSet {
237         Set _inner;
238     }
239 
240     /**
241      * @dev Add a value to a set. O(1).
242      *
243      * Returns true if the value was added to the set, that is if it was not
244      * already present.
245      */
246     function add(AddressSet storage set, address value) internal returns (bool) {
247         return _add(set._inner, bytes32(uint256(uint160(value))));
248     }
249 
250     /**
251      * @dev Removes a value from a set. O(1).
252      *
253      * Returns true if the value was removed from the set, that is if it was
254      * present.
255      */
256     function remove(AddressSet storage set, address value) internal returns (bool) {
257         return _remove(set._inner, bytes32(uint256(uint160(value))));
258     }
259 
260     /**
261      * @dev Returns true if the value is in the set. O(1).
262      */
263     function contains(AddressSet storage set, address value) internal view returns (bool) {
264         return _contains(set._inner, bytes32(uint256(uint160(value))));
265     }
266 
267     /**
268      * @dev Returns the number of values in the set. O(1).
269      */
270     function length(AddressSet storage set) internal view returns (uint256) {
271         return _length(set._inner);
272     }
273 
274     /**
275      * @dev Returns the value stored at position `index` in the set. O(1).
276      *
277      * Note that there are no guarantees on the ordering of values inside the
278      * array, and it may change when more values are added or removed.
279      *
280      * Requirements:
281      *
282      * - `index` must be strictly less than {length}.
283      */
284     function at(AddressSet storage set, uint256 index) internal view returns (address) {
285         return address(uint160(uint256(_at(set._inner, index))));
286     }
287 
288     /**
289      * @dev Return the entire set in an array
290      *
291      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
292      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
293      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
294      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
295      */
296     function values(AddressSet storage set) internal view returns (address[] memory) {
297         bytes32[] memory store = _values(set._inner);
298         address[] memory result;
299 
300         /// @solidity memory-safe-assembly
301         assembly {
302             result := store
303         }
304 
305         return result;
306     }
307 
308     // UintSet
309 
310     struct UintSet {
311         Set _inner;
312     }
313 
314     /**
315      * @dev Add a value to a set. O(1).
316      *
317      * Returns true if the value was added to the set, that is if it was not
318      * already present.
319      */
320     function add(UintSet storage set, uint256 value) internal returns (bool) {
321         return _add(set._inner, bytes32(value));
322     }
323 
324     /**
325      * @dev Removes a value from a set. O(1).
326      *
327      * Returns true if the value was removed from the set, that is if it was
328      * present.
329      */
330     function remove(UintSet storage set, uint256 value) internal returns (bool) {
331         return _remove(set._inner, bytes32(value));
332     }
333 
334     /**
335      * @dev Returns true if the value is in the set. O(1).
336      */
337     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
338         return _contains(set._inner, bytes32(value));
339     }
340 
341     /**
342      * @dev Returns the number of values in the set. O(1).
343      */
344     function length(UintSet storage set) internal view returns (uint256) {
345         return _length(set._inner);
346     }
347 
348     /**
349      * @dev Returns the value stored at position `index` in the set. O(1).
350      *
351      * Note that there are no guarantees on the ordering of values inside the
352      * array, and it may change when more values are added or removed.
353      *
354      * Requirements:
355      *
356      * - `index` must be strictly less than {length}.
357      */
358     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
359         return uint256(_at(set._inner, index));
360     }
361 
362     /**
363      * @dev Return the entire set in an array
364      *
365      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
366      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
367      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
368      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
369      */
370     function values(UintSet storage set) internal view returns (uint256[] memory) {
371         bytes32[] memory store = _values(set._inner);
372         uint256[] memory result;
373 
374         /// @solidity memory-safe-assembly
375         assembly {
376             result := store
377         }
378 
379         return result;
380     }
381 }
382 
383 // File: contracts/IOperatorFilterRegistry.sol
384 
385 
386 pragma solidity ^0.8.13;
387 
388 
389 interface IOperatorFilterRegistry {
390     function isOperatorAllowed(address registrant, address operator) external returns (bool);
391     function register(address registrant) external;
392     function registerAndSubscribe(address registrant, address subscription) external;
393     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
394     function updateOperator(address registrant, address operator, bool filtered) external;
395     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
396     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
397     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
398     function subscribe(address registrant, address registrantToSubscribe) external;
399     function unsubscribe(address registrant, bool copyExistingEntries) external;
400     function subscriptionOf(address addr) external returns (address registrant);
401     function subscribers(address registrant) external returns (address[] memory);
402     function subscriberAt(address registrant, uint256 index) external returns (address);
403     function copyEntriesOf(address registrant, address registrantToCopy) external;
404     function isOperatorFiltered(address registrant, address operator) external returns (bool);
405     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
406     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
407     function filteredOperators(address addr) external returns (address[] memory);
408     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
409     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
410     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
411     function isRegistered(address addr) external returns (bool);
412     function codeHashOf(address addr) external returns (bytes32);
413 }
414 // File: contracts/OperatorFilterer.sol
415 
416 
417 pragma solidity ^0.8.13;
418 
419 
420 contract OperatorFilterer {
421     error OperatorNotAllowed(address operator);
422 
423     IOperatorFilterRegistry constant operatorFilterRegistry =
424         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
425 
426     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
427         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
428         // will not revert, but the contract will need to be registered with the registry once it is deployed in
429         // order for the modifier to filter addresses.
430         if (address(operatorFilterRegistry).code.length > 0) {
431             if (subscribe) {
432                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
433             } else {
434                 if (subscriptionOrRegistrantToCopy != address(0)) {
435                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
436                 } else {
437                     operatorFilterRegistry.register(address(this));
438                 }
439             }
440         }
441     }
442 
443     modifier onlyAllowedOperator() virtual {
444         // Check registry code length to facilitate testing in environments without a deployed registry.
445         if (address(operatorFilterRegistry).code.length > 0) {
446             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
447                 revert OperatorNotAllowed(msg.sender);
448             }
449         }
450         _;
451     }
452 }
453 // File: contracts/DefaultOperatorFilterer.sol
454 
455 
456 pragma solidity ^0.8.13;
457 
458 
459 contract DefaultOperatorFilterer is OperatorFilterer {
460     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
461 
462     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
463 }
464 // File: contracts/Pokedots.sol
465 
466 /**
467  *Submitted for verification at Etherscan.io on 2023-02-23
468 */
469 
470 /**
471  *Submitted for verification at Etherscan.io on 2022-12-09
472 */
473 
474 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev Interface of the ERC165 standard, as defined in the
483  * https://eips.ethereum.org/EIPS/eip-165[EIP].
484  *
485  * Implementers can declare support of contract interfaces, which can then be
486  * queried by others ({ERC165Checker}).
487  *
488  * For an implementation, see {ERC165}.
489  */
490 interface IERC165 {
491     /**
492      * @dev Returns true if this contract implements the interface defined by
493      * `interfaceId`. See the corresponding
494      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
495      * to learn more about how these ids are created.
496      *
497      * This function call must use less than 30 000 gas.
498      */
499     function supportsInterface(bytes4 interfaceId) external view returns (bool);
500 }
501 
502 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 
510 /**
511  * @dev Implementation of the {IERC165} interface.
512  *
513  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
514  * for the additional interface id that will be supported. For example:
515  *
516  * ```solidity
517  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
519  * }
520  * ```
521  *
522  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
523  */
524 abstract contract ERC165 is IERC165 {
525     /**
526      * @dev See {IERC165-supportsInterface}.
527      */
528     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529         return interfaceId == type(IERC165).interfaceId;
530     }
531 }
532 
533 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
534 
535 
536 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Interface for the NFT Royalty Standard.
543  *
544  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
545  * support for royalty payments across all NFT marketplaces and ecosystem participants.
546  *
547  * _Available since v4.5._
548  */
549 interface IERC2981 is IERC165 {
550     /**
551      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
552      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
553      */
554     function royaltyInfo(uint256 tokenId, uint256 salePrice)
555         external
556         view
557         returns (address receiver, uint256 royaltyAmount);
558 }
559 
560 // File: @openzeppelin/contracts/token/common/ERC2981.sol
561 
562 
563 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 
569 /**
570  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
571  *
572  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
573  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
574  *
575  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
576  * fee is specified in basis points by default.
577  *
578  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
579  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
580  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
581  *
582  * _Available since v4.5._
583  */
584 abstract contract ERC2981 is IERC2981, ERC165 {
585     struct RoyaltyInfo {
586         address receiver;
587         uint96 royaltyFraction;
588     }
589 
590     RoyaltyInfo private _defaultRoyaltyInfo;
591     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
592 
593     /**
594      * @dev See {IERC165-supportsInterface}.
595      */
596     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
597         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
598     }
599 
600     /**
601      * @inheritdoc IERC2981
602      */
603     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
604         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
605 
606         if (royalty.receiver == address(0)) {
607             royalty = _defaultRoyaltyInfo;
608         }
609 
610         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
611 
612         return (royalty.receiver, royaltyAmount);
613     }
614 
615     /**
616      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
617      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
618      * override.
619      */
620     function _feeDenominator() internal pure virtual returns (uint96) {
621         return 10000;
622     }
623 
624     /**
625      * @dev Sets the royalty information that all ids in this contract will default to.
626      *
627      * Requirements:
628      *
629      * - `receiver` cannot be the zero address.
630      * - `feeNumerator` cannot be greater than the fee denominator.
631      */
632     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
633         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
634         require(receiver != address(0), "ERC2981: invalid receiver");
635 
636         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
637     }
638 
639     /**
640      * @dev Removes default royalty information.
641      */
642     function _deleteDefaultRoyalty() internal virtual {
643         delete _defaultRoyaltyInfo;
644     }
645 
646     /**
647      * @dev Sets the royalty information for a specific token id, overriding the global default.
648      *
649      * Requirements:
650      *
651      * - `receiver` cannot be the zero address.
652      * - `feeNumerator` cannot be greater than the fee denominator.
653      */
654     function _setTokenRoyalty(
655         uint256 tokenId,
656         address receiver,
657         uint96 feeNumerator
658     ) internal virtual {
659         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
660         require(receiver != address(0), "ERC2981: Invalid parameters");
661 
662         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
663     }
664 
665     /**
666      * @dev Resets royalty information for the token id back to the global default.
667      */
668     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
669         delete _tokenRoyaltyInfo[tokenId];
670     }
671 }
672 
673 // File: annunakis.sol
674 
675 /**
676  *Submitted for verification at Etherscan.io on 2022-09-13
677 */
678 
679 
680 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
681 
682 
683 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @dev These functions deal with verification of Merkle Tree proofs.
689  *
690  * The proofs can be generated using the JavaScript library
691  * https://github.com/miguelmota/merkletreejs[merkletreejs].
692  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
693  *
694  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
695  *
696  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
697  * hashing, or use a hash function other than keccak256 for hashing leaves.
698  * This is because the concatenation of a sorted pair of internal nodes in
699  * the merkle tree could be reinterpreted as a leaf value.
700  */
701 
702 // File: contracts/rose.sol
703 
704 /**
705  *Submitted for verification at Etherscan.io on 2022-07-22
706 */
707 
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 /**
715  * @dev Contract module that helps prevent reentrant calls to a function.
716  *
717  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
718  * available, which can be applied to functions to make sure there are no nested
719  * (reentrant) calls to them.
720  *
721  * Note that because there is a single `nonReentrant` guard, functions marked as
722  * `nonReentrant` may not call one another. This can be worked around by making
723  * those functions `private`, and then adding `external` `nonReentrant` entry
724  * points to them.
725  *
726  * TIP: If you would like to learn more about reentrancy and alternative ways
727  * to protect against it, check out our blog post
728  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
729  */
730 
731 abstract contract ReentrancyGuard {
732     // Booleans are more expensive than uint256 or any type that takes up a full
733     // word because each write operation emits an extra SLOAD to first read the
734     // slot's contents, replace the bits taken up by the boolean, and then write
735     // back. This is the compiler's defense against contract upgrades and
736     // pointer aliasing, and it cannot be disabled.
737 
738     // The values being non-zero value makes deployment a bit more expensive,
739     // but in exchange the refund on every call to nonReentrant will be lower in
740     // amount. Since refunds are capped to a percentage of the total
741     // transaction's gas, it is best to keep them low in cases like this one, to
742     // increase the likelihood of the full refund coming into effect.
743     uint256 private constant _NOT_ENTERED = 1;
744     uint256 private constant _ENTERED = 2;
745 
746     uint256 private _status;
747 
748     constructor() {
749         _status = _NOT_ENTERED;
750     }
751 
752     /**
753      * @dev Prevents a contract from calling itself, directly or indirectly.
754      * Calling a `nonReentrant` function from another `nonReentrant`
755      * function is not supported. It is possible to prevent this from happening
756      * by making the `nonReentrant` function external, and making it call a
757      * `private` function that does the actual work.
758      */
759     modifier nonReentrant() {
760         // On the first call to nonReentrant, _notEntered will be true
761         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
762 
763         // Any calls to nonReentrant after this point will fail
764         _status = _ENTERED;
765 
766         _;
767 
768         // By storing the original value once again, a refund is triggered (see
769         // https://eips.ethereum.org/EIPS/eip-2200)
770         _status = _NOT_ENTERED;
771     }
772 }
773 
774 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
775 
776 
777 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
778 
779 // File: @openzeppelin/contracts/utils/Strings.sol
780 
781 
782 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787  * @dev String operations.
788  */
789 library Strings {
790     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
791 
792     /**
793      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
794      */
795     function toString(uint256 value) internal pure returns (string memory) {
796         // Inspired by OraclizeAPI's implementation - MIT licence
797         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
798 
799         if (value == 0) {
800             return "0";
801         }
802         uint256 temp = value;
803         uint256 digits;
804         while (temp != 0) {
805             digits++;
806             temp /= 10;
807         }
808         bytes memory buffer = new bytes(digits);
809         while (value != 0) {
810             digits -= 1;
811             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
812             value /= 10;
813         }
814         return string(buffer);
815     }
816 
817     /**
818      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
819      */
820     function toHexString(uint256 value) internal pure returns (string memory) {
821         if (value == 0) {
822             return "0x00";
823         }
824         uint256 temp = value;
825         uint256 length = 0;
826         while (temp != 0) {
827             length++;
828             temp >>= 8;
829         }
830         return toHexString(value, length);
831     }
832 
833     /**
834      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
835      */
836     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
837         bytes memory buffer = new bytes(2 * length + 2);
838         buffer[0] = "0";
839         buffer[1] = "x";
840         for (uint256 i = 2 * length + 1; i > 1; --i) {
841             buffer[i] = _HEX_SYMBOLS[value & 0xf];
842             value >>= 4;
843         }
844         require(value == 0, "Strings: hex length insufficient");
845         return string(buffer);
846     }
847 }
848 
849 // File: @openzeppelin/contracts/utils/Context.sol
850 
851 
852 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 /**
857  * @dev Provides information about the current execution context, including the
858  * sender of the transaction and its data. While these are generally available
859  * via msg.sender and msg.data, they should not be accessed in such a direct
860  * manner, since when dealing with meta-transactions the account sending and
861  * paying for execution may not be the actual sender (as far as an application
862  * is concerned).
863  *
864  * This contract is only required for intermediate, library-like contracts.
865  */
866 abstract contract Context {
867     function _msgSender() internal view virtual returns (address) {
868         return msg.sender;
869     }
870 
871     function _msgData() internal view virtual returns (bytes calldata) {
872         return msg.data;
873     }
874 }
875 
876 // File: @openzeppelin/contracts/access/Ownable.sol
877 
878 
879 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 
884 /**
885  * @dev Contract module which provides a basic access control mechanism, where
886  * there is an account (an owner) that can be granted exclusive access to
887  * specific functions.
888  *
889  * By default, the owner account will be the one that deploys the contract. This
890  * can later be changed with {transferOwnership}.
891  *
892  * This module is used through inheritance. It will make available the modifier
893  * `onlyOwner`, which can be applied to your functions to restrict their use to
894  * the owner.
895  */
896 abstract contract Ownable is Context {
897     address private _owner;
898 
899     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
900 
901     /**
902      * @dev Initializes the contract setting the deployer as the initial owner.
903      */
904     constructor() {
905         _transferOwnership(_msgSender());
906     }
907 
908     /**
909      * @dev Returns the address of the current owner.
910      */
911     function owner() public view virtual returns (address) {
912         return _owner;
913     }
914 
915     /**
916      * @dev Throws if called by any account other than the owner.
917      */
918     modifier onlyOwner() {
919         require(owner() == _msgSender(), "Ownable: caller is not the owner");
920         _;
921     }
922 
923     /**
924      * @dev Leaves the contract without owner. It will not be possible to call
925      * `onlyOwner` functions anymore. Can only be called by the current owner.
926      *
927      * NOTE: Renouncing ownership will leave the contract without an owner,
928      * thereby removing any functionality that is only available to the owner.
929      */
930     function renounceOwnership() public virtual onlyOwner {
931         _transferOwnership(address(0));
932     }
933 
934     /**
935      * @dev Transfers ownership of the contract to a new account (`newOwner`).
936      * Can only be called by the current owner.
937      */
938     function transferOwnership(address newOwner) public virtual onlyOwner {
939         require(newOwner != address(0), "Ownable: new owner is the zero address");
940         _transferOwnership(newOwner);
941     }
942 
943     /**
944      * @dev Transfers ownership of the contract to a new account (`newOwner`).
945      * Internal function without access restriction.
946      */
947     function _transferOwnership(address newOwner) internal virtual {
948         address oldOwner = _owner;
949         _owner = newOwner;
950         emit OwnershipTransferred(oldOwner, newOwner);
951     }
952 }
953 
954 // File: @openzeppelin/contracts/utils/Address.sol
955 
956 
957 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
958 
959 pragma solidity ^0.8.1;
960 
961 /**
962  * @dev Collection of functions related to the address type
963  */
964 library Address {
965     /**
966      * @dev Returns true if `account` is a contract.
967      *
968      * [IMPORTANT]
969      * ====
970      * It is unsafe to assume that an address for which this function returns
971      * false is an externally-owned account (EOA) and not a contract.
972      *
973      * Among others, `isContract` will return false for the following
974      * types of addresses:
975      *
976      *  - an externally-owned account
977      *  - a contract in construction
978      *  - an address where a contract will be created
979      *  - an address where a contract lived, but was destroyed
980      * ====
981      *
982      * [IMPORTANT]
983      * ====
984      * You shouldn't rely on `isContract` to protect against flash loan attacks!
985      *
986      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
987      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
988      * constructor.
989      * ====
990      */
991     function isContract(address account) internal view returns (bool) {
992         // This method relies on extcodesize/address.code.length, which returns 0
993         // for contracts in construction, since the code is only stored at the end
994         // of the constructor execution.
995 
996         return account.code.length > 0;
997     }
998 
999     /**
1000      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1001      * `recipient`, forwarding all available gas and reverting on errors.
1002      *
1003      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1004      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1005      * imposed by `transfer`, making them unable to receive funds via
1006      * `transfer`. {sendValue} removes this limitation.
1007      *
1008      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1009      *
1010      * IMPORTANT: because control is transferred to `recipient`, care must be
1011      * taken to not create reentrancy vulnerabilities. Consider using
1012      * {ReentrancyGuard} or the
1013      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1014      */
1015     function sendValue(address payable recipient, uint256 amount) internal {
1016         require(address(this).balance >= amount, "Address: insufficient balance");
1017 
1018         (bool success, ) = recipient.call{value: amount}("");
1019         require(success, "Address: unable to send value, recipient may have reverted");
1020     }
1021 
1022     /**
1023      * @dev Performs a Solidity function call using a low level `call`. A
1024      * plain `call` is an unsafe replacement for a function call: use this
1025      * function instead.
1026      *
1027      * If `target` reverts with a revert reason, it is bubbled up by this
1028      * function (like regular Solidity function calls).
1029      *
1030      * Returns the raw returned data. To convert to the expected return value,
1031      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1032      *
1033      * Requirements:
1034      *
1035      * - `target` must be a contract.
1036      * - calling `target` with `data` must not revert.
1037      *
1038      * _Available since v3.1._
1039      */
1040     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1041         return functionCall(target, data, "Address: low-level call failed");
1042     }
1043 
1044     /**
1045      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1046      * `errorMessage` as a fallback revert reason when `target` reverts.
1047      *
1048      * _Available since v3.1._
1049      */
1050     function functionCall(
1051         address target,
1052         bytes memory data,
1053         string memory errorMessage
1054     ) internal returns (bytes memory) {
1055         return functionCallWithValue(target, data, 0, errorMessage);
1056     }
1057 
1058     /**
1059      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1060      * but also transferring `value` wei to `target`.
1061      *
1062      * Requirements:
1063      *
1064      * - the calling contract must have an ETH balance of at least `value`.
1065      * - the called Solidity function must be `payable`.
1066      *
1067      * _Available since v3.1._
1068      */
1069     function functionCallWithValue(
1070         address target,
1071         bytes memory data,
1072         uint256 value
1073     ) internal returns (bytes memory) {
1074         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1075     }
1076 
1077     /**
1078      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1079      * with `errorMessage` as a fallback revert reason when `target` reverts.
1080      *
1081      * _Available since v3.1._
1082      */
1083     function functionCallWithValue(
1084         address target,
1085         bytes memory data,
1086         uint256 value,
1087         string memory errorMessage
1088     ) internal returns (bytes memory) {
1089         require(address(this).balance >= value, "Address: insufficient balance for call");
1090         require(isContract(target), "Address: call to non-contract");
1091 
1092         (bool success, bytes memory returndata) = target.call{value: value}(data);
1093         return verifyCallResult(success, returndata, errorMessage);
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1098      * but performing a static call.
1099      *
1100      * _Available since v3.3._
1101      */
1102     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1103         return functionStaticCall(target, data, "Address: low-level static call failed");
1104     }
1105 
1106     /**
1107      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1108      * but performing a static call.
1109      *
1110      * _Available since v3.3._
1111      */
1112     function functionStaticCall(
1113         address target,
1114         bytes memory data,
1115         string memory errorMessage
1116     ) internal view returns (bytes memory) {
1117         require(isContract(target), "Address: static call to non-contract");
1118 
1119         (bool success, bytes memory returndata) = target.staticcall(data);
1120         return verifyCallResult(success, returndata, errorMessage);
1121     }
1122 
1123     /**
1124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1125      * but performing a delegate call.
1126      *
1127      * _Available since v3.4._
1128      */
1129     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1130         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1131     }
1132 
1133     /**
1134      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1135      * but performing a delegate call.
1136      *
1137      * _Available since v3.4._
1138      */
1139     function functionDelegateCall(
1140         address target,
1141         bytes memory data,
1142         string memory errorMessage
1143     ) internal returns (bytes memory) {
1144         require(isContract(target), "Address: delegate call to non-contract");
1145 
1146         (bool success, bytes memory returndata) = target.delegatecall(data);
1147         return verifyCallResult(success, returndata, errorMessage);
1148     }
1149 
1150     /**
1151      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1152      * revert reason using the provided one.
1153      *
1154      * _Available since v4.3._
1155      */
1156     function verifyCallResult(
1157         bool success,
1158         bytes memory returndata,
1159         string memory errorMessage
1160     ) internal pure returns (bytes memory) {
1161         if (success) {
1162             return returndata;
1163         } else {
1164             // Look for revert reason and bubble it up if present
1165             if (returndata.length > 0) {
1166                 // The easiest way to bubble the revert reason is using memory via assembly
1167 
1168                 assembly {
1169                     let returndata_size := mload(returndata)
1170                     revert(add(32, returndata), returndata_size)
1171                 }
1172             } else {
1173                 revert(errorMessage);
1174             }
1175         }
1176     }
1177 }
1178 
1179 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1180 
1181 
1182 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 /**
1187  * @title ERC721 token receiver interface
1188  * @dev Interface for any contract that wants to support safeTransfers
1189  * from ERC721 asset contracts.
1190  */
1191 interface IERC721Receiver {
1192     /**
1193      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1194      * by `operator` from `from`, this function is called.
1195      *
1196      * It must return its Solidity selector to confirm the token transfer.
1197      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1198      *
1199      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1200      */
1201     function onERC721Received(
1202         address operator,
1203         address from,
1204         uint256 tokenId,
1205         bytes calldata data
1206     ) external returns (bytes4);
1207 }
1208 
1209 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1210 
1211 
1212 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1213 
1214 pragma solidity ^0.8.0;
1215 
1216 /**
1217  * @dev Interface of the ERC165 standard, as defined in the
1218  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1219  *
1220  * Implementers can declare support of contract interfaces, which can then be
1221  * queried by others ({ERC165Checker}).
1222  *
1223  * For an implementation, see {ERC165}.
1224  */
1225 
1226 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1227 
1228 
1229 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 
1234 /**
1235  * @dev Implementation of the {IERC165} interface.
1236  *
1237  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1238  * for the additional interface id that will be supported. For example:
1239  *
1240  * ```solidity
1241  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1242  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1243  * }
1244  * ```
1245  *
1246  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1247  */
1248 
1249 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1250 
1251 
1252 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1253 
1254 pragma solidity ^0.8.0;
1255 
1256 
1257 /**
1258  * @dev Required interface of an ERC721 compliant contract.
1259  */
1260 interface IERC721 is IERC165 {
1261     /**
1262      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1263      */
1264     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1265 
1266     /**
1267      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1268      */
1269     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1270 
1271     /**
1272      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1273      */
1274     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1275 
1276     /**
1277      * @dev Returns the number of tokens in ``owner``'s account.
1278      */
1279     function balanceOf(address owner) external view returns (uint256 balance);
1280 
1281     /**
1282      * @dev Returns the owner of the `tokenId` token.
1283      *
1284      * Requirements:
1285      *
1286      * - `tokenId` must exist.
1287      */
1288     function ownerOf(uint256 tokenId) external view returns (address owner);
1289 
1290     /**
1291      * @dev Safely transfers `tokenId` token from `from` to `to`.
1292      *
1293      * Requirements:
1294      *
1295      * - `from` cannot be the zero address.
1296      * - `to` cannot be the zero address.
1297      * - `tokenId` token must exist and be owned by `from`.
1298      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1299      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function safeTransferFrom(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes calldata data
1308     ) external;
1309 
1310     /**
1311      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1312      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1313      *
1314      * Requirements:
1315      *
1316      * - `from` cannot be the zero address.
1317      * - `to` cannot be the zero address.
1318      * - `tokenId` token must exist and be owned by `from`.
1319      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1320      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function safeTransferFrom(
1325         address from,
1326         address to,
1327         uint256 tokenId
1328     ) external;
1329 
1330     /**
1331      * @dev Transfers `tokenId` token from `from` to `to`.
1332      *
1333      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1334      *
1335      * Requirements:
1336      *
1337      * - `from` cannot be the zero address.
1338      * - `to` cannot be the zero address.
1339      * - `tokenId` token must be owned by `from`.
1340      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1341      *
1342      * Emits a {Transfer} event.
1343      */
1344     function transferFrom(
1345         address from,
1346         address to,
1347         uint256 tokenId
1348     ) external;
1349 
1350     /**
1351      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1352      * The approval is cleared when the token is transferred.
1353      *
1354      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1355      *
1356      * Requirements:
1357      *
1358      * - The caller must own the token or be an approved operator.
1359      * - `tokenId` must exist.
1360      *
1361      * Emits an {Approval} event.
1362      */
1363     function approve(address to, uint256 tokenId) external;
1364 
1365     /**
1366      * @dev Approve or remove `operator` as an operator for the caller.
1367      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1368      *
1369      * Requirements:
1370      *
1371      * - The `operator` cannot be the caller.
1372      *
1373      * Emits an {ApprovalForAll} event.
1374      */
1375     function setApprovalForAll(address operator, bool _approved) external;
1376 
1377     /**
1378      * @dev Returns the account approved for `tokenId` token.
1379      *
1380      * Requirements:
1381      *
1382      * - `tokenId` must exist.
1383      */
1384     function getApproved(uint256 tokenId) external view returns (address operator);
1385 
1386     /**
1387      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1388      *
1389      * See {setApprovalForAll}
1390      */
1391     function isApprovedForAll(address owner, address operator) external view returns (bool);
1392 }
1393 
1394 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1395 
1396 
1397 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1398 
1399 pragma solidity ^0.8.0;
1400 
1401 
1402 /**
1403  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1404  * @dev See https://eips.ethereum.org/EIPS/eip-721
1405  */
1406 interface IERC721Metadata is IERC721 {
1407     /**
1408      * @dev Returns the token collection name.
1409      */
1410     function name() external view returns (string memory);
1411 
1412     /**
1413      * @dev Returns the token collection symbol.
1414      */
1415     function symbol() external view returns (string memory);
1416 
1417     /**
1418      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1419      */
1420     function tokenURI(uint256 tokenId) external view returns (string memory);
1421 }
1422 
1423 // File: ERC721A.sol
1424 
1425 
1426 // Creator: Chiru Labs
1427 
1428 pragma solidity ^0.8.4;
1429 
1430 
1431 
1432 
1433 
1434 
1435 
1436 
1437 error ApprovalCallerNotOwnerNorApproved();
1438 error ApprovalQueryForNonexistentToken();
1439 error ApproveToCaller();
1440 error ApprovalToCurrentOwner();
1441 error BalanceQueryForZeroAddress();
1442 error MintToZeroAddress();
1443 error MintZeroQuantity();
1444 error OwnerQueryForNonexistentToken();
1445 error TransferCallerNotOwnerNorApproved();
1446 error TransferFromIncorrectOwner();
1447 error TransferToNonERC721ReceiverImplementer();
1448 error TransferToZeroAddress();
1449 error URIQueryForNonexistentToken();
1450 
1451 /**
1452  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1453  * the Metadata extension. Built to optimize for lower gas during batch mints.
1454  *
1455  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1456  *
1457  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1458  *
1459  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1460  */
1461 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1462     using Address for address;
1463     using Strings for uint256;
1464 
1465     // Compiler will pack this into a single 256bit word.
1466     struct TokenOwnership {
1467         // The address of the owner.
1468         address addr;
1469         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1470         uint64 startTimestamp;
1471         // Whether the token has been burned.
1472         bool burned;
1473     }
1474 
1475     // Compiler will pack this into a single 256bit word.
1476     struct AddressData {
1477         // Realistically, 2**64-1 is more than enough.
1478         uint64 balance;
1479         // Keeps track of mint count with minimal overhead for tokenomics.
1480         uint64 numberMinted;
1481         // Keeps track of burn count with minimal overhead for tokenomics.
1482         uint64 numberBurned;
1483         // For miscellaneous variable(s) pertaining to the address
1484         // (e.g. number of whitelist mint slots used).
1485         // If there are multiple variables, please pack them into a uint64.
1486         uint64 aux;
1487     }
1488 
1489     // The tokenId of the next token to be minted.
1490     uint256 internal _currentIndex;
1491 
1492     // The number of tokens burned.
1493     uint256 internal _burnCounter;
1494 
1495     // Token name
1496     string private _name;
1497 
1498     // Token symbol
1499     string private _symbol;
1500 
1501     // Mapping from token ID to ownership details
1502     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1503     mapping(uint256 => TokenOwnership) internal _ownerships;
1504 
1505     // Mapping owner address to address data
1506     mapping(address => AddressData) private _addressData;
1507 
1508     // Mapping from token ID to approved address
1509     mapping(uint256 => address) private _tokenApprovals;
1510 
1511     // Mapping from owner to operator approvals
1512     mapping(address => mapping(address => bool)) private _operatorApprovals;
1513 
1514     constructor(string memory name_, string memory symbol_) {
1515         _name = name_;
1516         _symbol = symbol_;
1517         _currentIndex = _startTokenId();
1518     }
1519 
1520     /**
1521      * To change the starting tokenId, please override this function.
1522      */
1523     function _startTokenId() internal view virtual returns (uint256) {
1524         return 1;
1525     }
1526 
1527     /**
1528      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1529      */
1530     function totalSupply() public view returns (uint256) {
1531         // Counter underflow is impossible as _burnCounter cannot be incremented
1532         // more than _currentIndex - _startTokenId() times
1533         unchecked {
1534             return _currentIndex - _burnCounter - _startTokenId();
1535         }
1536     }
1537 
1538     /**
1539      * Returns the total amount of tokens minted in the contract.
1540      */
1541     function _totalMinted() internal view returns (uint256) {
1542         // Counter underflow is impossible as _currentIndex does not decrement,
1543         // and it is initialized to _startTokenId()
1544         unchecked {
1545             return _currentIndex - _startTokenId();
1546         }
1547     }
1548 
1549     /**
1550      * @dev See {IERC165-supportsInterface}.
1551      */
1552     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1553         return
1554             interfaceId == type(IERC721).interfaceId ||
1555             interfaceId == type(IERC721Metadata).interfaceId ||
1556             super.supportsInterface(interfaceId);
1557     }
1558 
1559     /**
1560      * @dev See {IERC721-balanceOf}.
1561      */
1562     function balanceOf(address owner) public view override returns (uint256) {
1563         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1564         return uint256(_addressData[owner].balance);
1565     }
1566 
1567     /**
1568      * Returns the number of tokens minted by `owner`.
1569      */
1570     function _numberMinted(address owner) internal view returns (uint256) {
1571         return uint256(_addressData[owner].numberMinted);
1572     }
1573 
1574     /**
1575      * Returns the number of tokens burned by or on behalf of `owner`.
1576      */
1577     function _numberBurned(address owner) internal view returns (uint256) {
1578         return uint256(_addressData[owner].numberBurned);
1579     }
1580 
1581     /**
1582      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1583      */
1584     function _getAux(address owner) internal view returns (uint64) {
1585         return _addressData[owner].aux;
1586     }
1587 
1588     /**
1589      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1590      * If there are multiple variables, please pack them into a uint64.
1591      */
1592     function _setAux(address owner, uint64 aux) internal {
1593         _addressData[owner].aux = aux;
1594     }
1595 
1596     /**
1597      * Gas spent here starts off proportional to the maximum mint batch size.
1598      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1599      */
1600     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1601         uint256 curr = tokenId;
1602 
1603         unchecked {
1604             if (_startTokenId() <= curr && curr < _currentIndex) {
1605                 TokenOwnership memory ownership = _ownerships[curr];
1606                 if (!ownership.burned) {
1607                     if (ownership.addr != address(0)) {
1608                         return ownership;
1609                     }
1610                     // Invariant:
1611                     // There will always be an ownership that has an address and is not burned
1612                     // before an ownership that does not have an address and is not burned.
1613                     // Hence, curr will not underflow.
1614                     while (true) {
1615                         curr--;
1616                         ownership = _ownerships[curr];
1617                         if (ownership.addr != address(0)) {
1618                             return ownership;
1619                         }
1620                     }
1621                 }
1622             }
1623         }
1624         revert OwnerQueryForNonexistentToken();
1625     }
1626 
1627     /**
1628      * @dev See {IERC721-ownerOf}.
1629      */
1630     function ownerOf(uint256 tokenId) public view override returns (address) {
1631         return _ownershipOf(tokenId).addr;
1632     }
1633 
1634     /**
1635      * @dev See {IERC721Metadata-name}.
1636      */
1637     function name() public view virtual override returns (string memory) {
1638         return _name;
1639     }
1640 
1641     /**
1642      * @dev See {IERC721Metadata-symbol}.
1643      */
1644     function symbol() public view virtual override returns (string memory) {
1645         return _symbol;
1646     }
1647 
1648     /**
1649      * @dev See {IERC721Metadata-tokenURI}.
1650      */
1651     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1652         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1653 
1654         string memory baseURI = _baseURI();
1655         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1656     }
1657 
1658     /**
1659      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1660      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1661      * by default, can be overriden in child contracts.
1662      */
1663     function _baseURI() internal view virtual returns (string memory) {
1664         return '';
1665     }
1666 
1667     /**
1668      * @dev See {IERC721-approve}.
1669      */
1670     function approve(address to, uint256 tokenId) public override {
1671         address owner = ERC721A.ownerOf(tokenId);
1672         if (to == owner) revert ApprovalToCurrentOwner();
1673 
1674         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1675             revert ApprovalCallerNotOwnerNorApproved();
1676         }
1677 
1678         _approve(to, tokenId, owner);
1679     }
1680 
1681     /**
1682      * @dev See {IERC721-getApproved}.
1683      */
1684     function getApproved(uint256 tokenId) public view override returns (address) {
1685         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1686 
1687         return _tokenApprovals[tokenId];
1688     }
1689 
1690     /**
1691      * @dev See {IERC721-setApprovalForAll}.
1692      */
1693     function setApprovalForAll(address operator, bool approved) public virtual override {
1694         if (operator == _msgSender()) revert ApproveToCaller();
1695 
1696         _operatorApprovals[_msgSender()][operator] = approved;
1697         emit ApprovalForAll(_msgSender(), operator, approved);
1698     }
1699 
1700     /**
1701      * @dev See {IERC721-isApprovedForAll}.
1702      */
1703     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1704         return _operatorApprovals[owner][operator];
1705     }
1706 
1707     /**
1708      * @dev See {IERC721-transferFrom}.
1709      */
1710     function transferFrom(
1711         address from,
1712         address to,
1713         uint256 tokenId
1714     ) public virtual override {
1715         _transfer(from, to, tokenId);
1716     }
1717 
1718     /**
1719      * @dev See {IERC721-safeTransferFrom}.
1720      */
1721     function safeTransferFrom(
1722         address from,
1723         address to,
1724         uint256 tokenId
1725     ) public virtual override {
1726         safeTransferFrom(from, to, tokenId, '');
1727     }
1728 
1729     /**
1730      * @dev See {IERC721-safeTransferFrom}.
1731      */
1732     function safeTransferFrom(
1733         address from,
1734         address to,
1735         uint256 tokenId,
1736         bytes memory _data
1737     ) public virtual override {
1738         _transfer(from, to, tokenId);
1739         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1740             revert TransferToNonERC721ReceiverImplementer();
1741         }
1742     }
1743 
1744     /**
1745      * @dev Returns whether `tokenId` exists.
1746      *
1747      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1748      *
1749      * Tokens start existing when they are minted (`_mint`),
1750      */
1751     function _exists(uint256 tokenId) internal view returns (bool) {
1752         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1753     }
1754 
1755     function _safeMint(address to, uint256 quantity) internal {
1756         _safeMint(to, quantity, '');
1757     }
1758 
1759     /**
1760      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1761      *
1762      * Requirements:
1763      *
1764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1765      * - `quantity` must be greater than 0.
1766      *
1767      * Emits a {Transfer} event.
1768      */
1769     function _safeMint(
1770         address to,
1771         uint256 quantity,
1772         bytes memory _data
1773     ) internal {
1774         _mint(to, quantity, _data, true);
1775     }
1776 
1777     /**
1778      * @dev Mints `quantity` tokens and transfers them to `to`.
1779      *
1780      * Requirements:
1781      *
1782      * - `to` cannot be the zero address.
1783      * - `quantity` must be greater than 0.
1784      *
1785      * Emits a {Transfer} event.
1786      */
1787     function _mint(
1788         address to,
1789         uint256 quantity,
1790         bytes memory _data,
1791         bool safe
1792     ) internal {
1793         uint256 startTokenId = _currentIndex;
1794         if (to == address(0)) revert MintToZeroAddress();
1795         if (quantity == 0) revert MintZeroQuantity();
1796 
1797         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1798 
1799         // Overflows are incredibly unrealistic.
1800         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1801         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1802         unchecked {
1803             _addressData[to].balance += uint64(quantity);
1804             _addressData[to].numberMinted += uint64(quantity);
1805 
1806             _ownerships[startTokenId].addr = to;
1807             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1808 
1809             uint256 updatedIndex = startTokenId;
1810             uint256 end = updatedIndex + quantity;
1811 
1812             if (safe && to.isContract()) {
1813                 do {
1814                     emit Transfer(address(0), to, updatedIndex);
1815                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1816                         revert TransferToNonERC721ReceiverImplementer();
1817                     }
1818                 } while (updatedIndex != end);
1819                 // Reentrancy protection
1820                 if (_currentIndex != startTokenId) revert();
1821             } else {
1822                 do {
1823                     emit Transfer(address(0), to, updatedIndex++);
1824                 } while (updatedIndex != end);
1825             }
1826             _currentIndex = updatedIndex;
1827         }
1828         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1829     }
1830 
1831     /**
1832      * @dev Transfers `tokenId` from `from` to `to`.
1833      *
1834      * Requirements:
1835      *
1836      * - `to` cannot be the zero address.
1837      * - `tokenId` token must be owned by `from`.
1838      *
1839      * Emits a {Transfer} event.
1840      */
1841     function _transfer(
1842         address from,
1843         address to,
1844         uint256 tokenId
1845     ) private {
1846         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1847 
1848         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1849 
1850         bool isApprovedOrOwner = (_msgSender() == from ||
1851             isApprovedForAll(from, _msgSender()) ||
1852             getApproved(tokenId) == _msgSender());
1853 
1854         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1855         if (to == address(0)) revert TransferToZeroAddress();
1856 
1857         _beforeTokenTransfers(from, to, tokenId, 1);
1858 
1859         // Clear approvals from the previous owner
1860         _approve(address(0), tokenId, from);
1861 
1862         // Underflow of the sender's balance is impossible because we check for
1863         // ownership above and the recipient's balance can't realistically overflow.
1864         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1865         unchecked {
1866             _addressData[from].balance -= 1;
1867             _addressData[to].balance += 1;
1868 
1869             TokenOwnership storage currSlot = _ownerships[tokenId];
1870             currSlot.addr = to;
1871             currSlot.startTimestamp = uint64(block.timestamp);
1872 
1873             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1874             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1875             uint256 nextTokenId = tokenId + 1;
1876             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1877             if (nextSlot.addr == address(0)) {
1878                 // This will suffice for checking _exists(nextTokenId),
1879                 // as a burned slot cannot contain the zero address.
1880                 if (nextTokenId != _currentIndex) {
1881                     nextSlot.addr = from;
1882                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1883                 }
1884             }
1885         }
1886 
1887         emit Transfer(from, to, tokenId);
1888         _afterTokenTransfers(from, to, tokenId, 1);
1889     }
1890 
1891     /**
1892      * @dev This is equivalent to _burn(tokenId, false)
1893      */
1894     function _burn(uint256 tokenId) internal virtual {
1895         _burn(tokenId, false);
1896     }
1897 
1898     /**
1899      * @dev Destroys `tokenId`.
1900      * The approval is cleared when the token is burned.
1901      *
1902      * Requirements:
1903      *
1904      * - `tokenId` must exist.
1905      *
1906      * Emits a {Transfer} event.
1907      */
1908     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1909         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1910 
1911         address from = prevOwnership.addr;
1912 
1913         if (approvalCheck) {
1914             bool isApprovedOrOwner = (_msgSender() == from ||
1915                 isApprovedForAll(from, _msgSender()) ||
1916                 getApproved(tokenId) == _msgSender());
1917 
1918             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1919         }
1920 
1921         _beforeTokenTransfers(from, address(0), tokenId, 1);
1922 
1923         // Clear approvals from the previous owner
1924         _approve(address(0), tokenId, from);
1925 
1926         // Underflow of the sender's balance is impossible because we check for
1927         // ownership above and the recipient's balance can't realistically overflow.
1928         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1929         unchecked {
1930             AddressData storage addressData = _addressData[from];
1931             addressData.balance -= 1;
1932             addressData.numberBurned += 1;
1933 
1934             // Keep track of who burned the token, and the timestamp of burning.
1935             TokenOwnership storage currSlot = _ownerships[tokenId];
1936             currSlot.addr = from;
1937             currSlot.startTimestamp = uint64(block.timestamp);
1938             currSlot.burned = true;
1939 
1940             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1941             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1942             uint256 nextTokenId = tokenId + 1;
1943             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1944             if (nextSlot.addr == address(0)) {
1945                 // This will suffice for checking _exists(nextTokenId),
1946                 // as a burned slot cannot contain the zero address.
1947                 if (nextTokenId != _currentIndex) {
1948                     nextSlot.addr = from;
1949                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1950                 }
1951             }
1952         }
1953 
1954         emit Transfer(from, address(0), tokenId);
1955         _afterTokenTransfers(from, address(0), tokenId, 1);
1956 
1957         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1958         unchecked {
1959             _burnCounter++;
1960         }
1961     }
1962 
1963     /**
1964      * @dev Approve `to` to operate on `tokenId`
1965      *
1966      * Emits a {Approval} event.
1967      */
1968     function _approve(
1969         address to,
1970         uint256 tokenId,
1971         address owner
1972     ) private {
1973         _tokenApprovals[tokenId] = to;
1974         emit Approval(owner, to, tokenId);
1975     }
1976 
1977     /**
1978      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1979      *
1980      * @param from address representing the previous owner of the given token ID
1981      * @param to target address that will receive the tokens
1982      * @param tokenId uint256 ID of the token to be transferred
1983      * @param _data bytes optional data to send along with the call
1984      * @return bool whether the call correctly returned the expected magic value
1985      */
1986     function _checkContractOnERC721Received(
1987         address from,
1988         address to,
1989         uint256 tokenId,
1990         bytes memory _data
1991     ) private returns (bool) {
1992         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1993             return retval == IERC721Receiver(to).onERC721Received.selector;
1994         } catch (bytes memory reason) {
1995             if (reason.length == 0) {
1996                 revert TransferToNonERC721ReceiverImplementer();
1997             } else {
1998                 assembly {
1999                     revert(add(32, reason), mload(reason))
2000                 }
2001             }
2002         }
2003     }
2004 
2005     /**
2006      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2007      * And also called before burning one token.
2008      *
2009      * startTokenId - the first token id to be transferred
2010      * quantity - the amount to be transferred
2011      *
2012      * Calling conditions:
2013      *
2014      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2015      * transferred to `to`.
2016      * - When `from` is zero, `tokenId` will be minted for `to`.
2017      * - When `to` is zero, `tokenId` will be burned by `from`.
2018      * - `from` and `to` are never both zero.
2019      */
2020     function _beforeTokenTransfers(
2021         address from,
2022         address to,
2023         uint256 startTokenId,
2024         uint256 quantity
2025     ) internal virtual {}
2026 
2027     /**
2028      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2029      * minting.
2030      * And also called after one token has been burned.
2031      *
2032      * startTokenId - the first token id to be transferred
2033      * quantity - the amount to be transferred
2034      *
2035      * Calling conditions:
2036      *
2037      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2038      * transferred to `to`.
2039      * - When `from` is zero, `tokenId` has been minted for `to`.
2040      * - When `to` is zero, `tokenId` has been burned by `from`.
2041      * - `from` and `to` are never both zero.
2042      */
2043     function _afterTokenTransfers(
2044         address from,
2045         address to,
2046         uint256 startTokenId,
2047         uint256 quantity
2048     ) internal virtual {}
2049 }
2050 // File: Contract.sol
2051 
2052 
2053 pragma solidity ^0.8.7;
2054 
2055 contract PrimApes is ERC721A, ERC2981, Ownable, ReentrancyGuard,DefaultOperatorFilterer {
2056     using Strings for uint256;
2057     mapping(address => uint256) public publicClaimed;
2058 
2059     string public baseURI = "ipfs://bafybeicqx2bhpx7nv2o4lekwy3ax2mupanzdap7i5kmz74dyu5uaayawim/";
2060     bool public paused = true;
2061     address public ROYALITY__ADDRESS;
2062     uint96 public ROYALITY__VALUE;
2063     uint256 public publicPrice = 0.0033 ether;
2064     uint256 public publicMintPerTx = 10;
2065     uint256 public maxSupply = 1111;
2066 
2067     constructor() ERC721A("PrimApes", "PA") {
2068         ROYALITY__ADDRESS = msg.sender;
2069         ROYALITY__VALUE = 550;
2070         _setDefaultRoyalty(ROYALITY__ADDRESS, ROYALITY__VALUE);
2071         
2072     }
2073 
2074      
2075 
2076     // ============ PUBLIC FUNCTIONS FOR MINTING ============
2077     function mint(uint256 quantity) external payable nonReentrant {
2078         require(!paused, "The contract is paused!");
2079         require(quantity > 0 && totalSupply() + quantity <= maxSupply, "Invalid amount!");
2080         require(publicClaimed[msg.sender] + quantity <= publicMintPerTx, "You can't mint this amount");
2081 
2082         if (publicClaimed[msg.sender] == 0)
2083             require(msg.value >= publicPrice * (quantity-1), "Insufficient Funds!");
2084         else
2085             require(msg.value >= publicPrice * quantity, "Insufficient Funds!");
2086 
2087         publicClaimed[msg.sender] += quantity;
2088         _safeMint(msg.sender, quantity);
2089     }
2090 
2091     function _baseURI() internal view virtual override returns (string memory) {
2092         return baseURI;
2093     }
2094 
2095 
2096     // ============ PUBLIC READ-ONLY FUNCTIONS ============
2097 
2098     function tokenURI(uint256 tokenId)
2099         public
2100         view
2101         virtual
2102         override
2103         returns (string memory)
2104     {
2105         require(
2106             _exists(tokenId),
2107             "ERC721Metadata: URI query for nonexistent token"
2108         );
2109         string memory currentBaseURI = _baseURI();
2110         return
2111             bytes(currentBaseURI).length > 0
2112                 ? string(
2113                     abi.encodePacked(
2114                         currentBaseURI,
2115                         tokenId.toString(),
2116                         ".json"
2117                     )
2118                 )
2119                 : "";
2120     }
2121     function supportsInterface(bytes4 interfaceId)
2122     public
2123     view
2124     override(ERC721A, ERC2981)
2125     returns (bool)
2126     {
2127         return
2128             ERC721A.supportsInterface(interfaceId)
2129             || ERC2981.supportsInterface(interfaceId);
2130     }
2131    
2132     function setRoyalties(address receiver, uint96 royaltyFraction) external onlyOwner {
2133         _setDefaultRoyalty(receiver, royaltyFraction);
2134     }
2135    
2136    
2137     function setCost(uint256 _newPublicCost) external onlyOwner {
2138         publicPrice = _newPublicCost;
2139     }
2140    
2141  
2142     function setMaxPublic(uint256 _newMaxPublic) external onlyOwner {
2143         publicMintPerTx = _newMaxPublic;
2144     }
2145 
2146     function setMaxSupply(uint256 _amount) external onlyOwner {
2147         maxSupply = _amount;
2148     }
2149 
2150     function setPaused(bool _state) external onlyOwner {
2151         paused = _state;
2152     }
2153 
2154     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2155         baseURI = _newBaseURI;
2156     }
2157    
2158     function airDrop(uint256 quantity, address _address) external onlyOwner {
2159         _safeMint(_address, quantity);
2160     }
2161     
2162 
2163     function airDropBatch(address[] memory _addresses) external onlyOwner {
2164         for(uint256 i = 0 ;i < _addresses.length; i ++) {
2165             _safeMint(_addresses[i], 1);
2166         }
2167     }
2168 
2169     function withdraw() public onlyOwner {
2170          // Do not remove this otherwise you will not be able to withdraw the funds.
2171         // =============================================================================
2172         (bool ts, ) = payable(owner()).call{value: address(this).balance}("");
2173         require(ts);
2174         // =============================================================================
2175     }
2176 
2177     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
2178         super.transferFrom(from, to, tokenId);
2179     }
2180 
2181     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
2182         super.safeTransferFrom(from, to, tokenId);
2183     }
2184 
2185     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2186         public
2187         override
2188         onlyAllowedOperator
2189     {
2190         super.safeTransferFrom(from, to, tokenId, data);
2191     }
2192 }