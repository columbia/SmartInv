1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
5 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
6 
7 pragma solidity ^0.8.18;
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
382 // File: contracts/artifacts/IOperatorFilterRegistry.sol
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
413 // File: contracts/artifacts/OperatorFilterer.sol
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
452 // File: contracts/artifacts/DefaultOperatorFilterer.sol
453 
454 //SPDX-License-Identifier: MIT
455 
456 pragma solidity ^0.8.13;
457 
458 
459 contract DefaultOperatorFilterer is OperatorFilterer {
460     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
461 
462     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
463 }
464 // File: contracts/NebulaGods.sol
465 
466 /**
467  *Submitted for verification at Etherscan.io on 2022-12-09
468 */
469 
470 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Interface of the ERC165 standard, as defined in the
479  * https://eips.ethereum.org/EIPS/eip-165[EIP].
480  *
481  * Implementers can declare support of contract interfaces, which can then be
482  * queried by others ({ERC165Checker}).
483  *
484  * For an implementation, see {ERC165}.
485  */
486 interface IERC165 {
487     /**
488      * @dev Returns true if this contract implements the interface defined by
489      * `interfaceId`. See the corresponding
490      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
491      * to learn more about how these ids are created.
492      *
493      * This function call must use less than 30 000 gas.
494      */
495     function supportsInterface(bytes4 interfaceId) external view returns (bool);
496 }
497 
498 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 
506 /**
507  * @dev Implementation of the {IERC165} interface.
508  *
509  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
510  * for the additional interface id that will be supported. For example:
511  *
512  * ```solidity
513  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
515  * }
516  * ```
517  *
518  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
519  */
520 abstract contract ERC165 is IERC165 {
521     /**
522      * @dev See {IERC165-supportsInterface}.
523      */
524     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525         return interfaceId == type(IERC165).interfaceId;
526     }
527 }
528 
529 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
530 
531 
532 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @dev Interface for the NFT Royalty Standard.
539  *
540  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
541  * support for royalty payments across all NFT marketplaces and ecosystem participants.
542  *
543  * _Available since v4.5._
544  */
545 interface IERC2981 is IERC165 {
546     /**
547      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
548      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
549      */
550     function royaltyInfo(uint256 tokenId, uint256 salePrice)
551         external
552         view
553         returns (address receiver, uint256 royaltyAmount);
554 }
555 
556 // File: @openzeppelin/contracts/token/common/ERC2981.sol
557 
558 
559 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 
565 /**
566  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
567  *
568  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
569  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
570  *
571  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
572  * fee is specified in basis points by default.
573  *
574  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
575  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
576  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
577  *
578  * _Available since v4.5._
579  */
580 abstract contract ERC2981 is IERC2981, ERC165 {
581     struct RoyaltyInfo {
582         address receiver;
583         uint96 royaltyFraction;
584     }
585 
586     RoyaltyInfo private _defaultRoyaltyInfo;
587     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
588 
589     /**
590      * @dev See {IERC165-supportsInterface}.
591      */
592     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
593         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
594     }
595 
596     /**
597      * @inheritdoc IERC2981
598      */
599     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
600         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
601 
602         if (royalty.receiver == address(0)) {
603             royalty = _defaultRoyaltyInfo;
604         }
605 
606         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
607 
608         return (royalty.receiver, royaltyAmount);
609     }
610 
611     /**
612      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
613      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
614      * override.
615      */
616     function _feeDenominator() internal pure virtual returns (uint96) {
617         return 10000;
618     }
619 
620     /**
621      * @dev Sets the royalty information that all ids in this contract will default to.
622      *
623      * Requirements:
624      *
625      * - `receiver` cannot be the zero address.
626      * - `feeNumerator` cannot be greater than the fee denominator.
627      */
628     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
629         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
630         require(receiver != address(0), "ERC2981: invalid receiver");
631 
632         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
633     }
634 
635     /**
636      * @dev Removes default royalty information.
637      */
638     function _deleteDefaultRoyalty() internal virtual {
639         delete _defaultRoyaltyInfo;
640     }
641 
642     /**
643      * @dev Sets the royalty information for a specific token id, overriding the global default.
644      *
645      * Requirements:
646      *
647      * - `receiver` cannot be the zero address.
648      * - `feeNumerator` cannot be greater than the fee denominator.
649      */
650     function _setTokenRoyalty(
651         uint256 tokenId,
652         address receiver,
653         uint96 feeNumerator
654     ) internal virtual {
655         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
656         require(receiver != address(0), "ERC2981: Invalid parameters");
657 
658         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
659     }
660 
661     /**
662      * @dev Resets royalty information for the token id back to the global default.
663      */
664     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
665         delete _tokenRoyaltyInfo[tokenId];
666     }
667 }
668 
669 // File: annunakis.sol
670 
671 /**
672  *Submitted for verification at Etherscan.io on 2022-09-13
673 */
674 
675 
676 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
677 
678 
679 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @dev These functions deal with verification of Merkle Tree proofs.
685  *
686  * The proofs can be generated using the JavaScript library
687  * https://github.com/miguelmota/merkletreejs[merkletreejs].
688  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
689  *
690  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
691  *
692  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
693  * hashing, or use a hash function other than keccak256 for hashing leaves.
694  * This is because the concatenation of a sorted pair of internal nodes in
695  * the merkle tree could be reinterpreted as a leaf value.
696  */
697 library MerkleProof {
698     /**
699      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
700      * defined by `root`. For this, a `proof` must be provided, containing
701      * sibling hashes on the branch from the leaf to the root of the tree. Each
702      * pair of leaves and each pair of pre-images are assumed to be sorted.
703      */
704     function verify(
705         bytes32[] memory proof,
706         bytes32 root,
707         bytes32 leaf
708     ) internal pure returns (bool) {
709         return processProof(proof, leaf) == root;
710     }
711 
712     /**
713      * @dev Calldata version of {verify}
714      *
715      * _Available since v4.7._
716      */
717     function verifyCalldata(
718         bytes32[] calldata proof,
719         bytes32 root,
720         bytes32 leaf
721     ) internal pure returns (bool) {
722         return processProofCalldata(proof, leaf) == root;
723     }
724 
725     /**
726      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
727      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
728      * hash matches the root of the tree. When processing the proof, the pairs
729      * of leafs & pre-images are assumed to be sorted.
730      *
731      * _Available since v4.4._
732      */
733     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
734         bytes32 computedHash = leaf;
735         for (uint256 i = 0; i < proof.length; i++) {
736             computedHash = _hashPair(computedHash, proof[i]);
737         }
738         return computedHash;
739     }
740 
741     /**
742      * @dev Calldata version of {processProof}
743      *
744      * _Available since v4.7._
745      */
746     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
747         bytes32 computedHash = leaf;
748         for (uint256 i = 0; i < proof.length; i++) {
749             computedHash = _hashPair(computedHash, proof[i]);
750         }
751         return computedHash;
752     }
753 
754     /**
755      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
756      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
757      *
758      * _Available since v4.7._
759      */
760     function multiProofVerify(
761         bytes32[] memory proof,
762         bool[] memory proofFlags,
763         bytes32 root,
764         bytes32[] memory leaves
765     ) internal pure returns (bool) {
766         return processMultiProof(proof, proofFlags, leaves) == root;
767     }
768 
769     /**
770      * @dev Calldata version of {multiProofVerify}
771      *
772      * _Available since v4.7._
773      */
774     function multiProofVerifyCalldata(
775         bytes32[] calldata proof,
776         bool[] calldata proofFlags,
777         bytes32 root,
778         bytes32[] memory leaves
779     ) internal pure returns (bool) {
780         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
781     }
782 
783     /**
784      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
785      * consuming from one or the other at each step according to the instructions given by
786      * `proofFlags`.
787      *
788      * _Available since v4.7._
789      */
790     function processMultiProof(
791         bytes32[] memory proof,
792         bool[] memory proofFlags,
793         bytes32[] memory leaves
794     ) internal pure returns (bytes32 merkleRoot) {
795         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
796         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
797         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
798         // the merkle tree.
799         uint256 leavesLen = leaves.length;
800         uint256 totalHashes = proofFlags.length;
801 
802         // Check proof validity.
803         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
804 
805         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
806         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
807         bytes32[] memory hashes = new bytes32[](totalHashes);
808         uint256 leafPos = 0;
809         uint256 hashPos = 0;
810         uint256 proofPos = 0;
811         // At each step, we compute the next hash using two values:
812         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
813         //   get the next hash.
814         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
815         //   `proof` array.
816         for (uint256 i = 0; i < totalHashes; i++) {
817             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
818             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
819             hashes[i] = _hashPair(a, b);
820         }
821 
822         if (totalHashes > 0) {
823             return hashes[totalHashes - 1];
824         } else if (leavesLen > 0) {
825             return leaves[0];
826         } else {
827             return proof[0];
828         }
829     }
830 
831     /**
832      * @dev Calldata version of {processMultiProof}
833      *
834      * _Available since v4.7._
835      */
836     function processMultiProofCalldata(
837         bytes32[] calldata proof,
838         bool[] calldata proofFlags,
839         bytes32[] memory leaves
840     ) internal pure returns (bytes32 merkleRoot) {
841         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
842         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
843         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
844         // the merkle tree.
845         uint256 leavesLen = leaves.length;
846         uint256 totalHashes = proofFlags.length;
847 
848         // Check proof validity.
849         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
850 
851         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
852         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
853         bytes32[] memory hashes = new bytes32[](totalHashes);
854         uint256 leafPos = 0;
855         uint256 hashPos = 0;
856         uint256 proofPos = 0;
857         // At each step, we compute the next hash using two values:
858         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
859         //   get the next hash.
860         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
861         //   `proof` array.
862         for (uint256 i = 0; i < totalHashes; i++) {
863             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
864             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
865             hashes[i] = _hashPair(a, b);
866         }
867 
868         if (totalHashes > 0) {
869             return hashes[totalHashes - 1];
870         } else if (leavesLen > 0) {
871             return leaves[0];
872         } else {
873             return proof[0];
874         }
875     }
876 
877     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
878         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
879     }
880 
881     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
882         /// @solidity memory-safe-assembly
883         assembly {
884             mstore(0x00, a)
885             mstore(0x20, b)
886             value := keccak256(0x00, 0x40)
887         }
888     }
889 }
890 
891 // File: contracts/rose.sol
892 
893 /**
894  *Submitted for verification at Etherscan.io on 2022-07-22
895 */
896 
897 
898 
899 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 /**
904  * @dev Contract module that helps prevent reentrant calls to a function.
905  *
906  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
907  * available, which can be applied to functions to make sure there are no nested
908  * (reentrant) calls to them.
909  *
910  * Note that because there is a single `nonReentrant` guard, functions marked as
911  * `nonReentrant` may not call one another. This can be worked around by making
912  * those functions `private`, and then adding `external` `nonReentrant` entry
913  * points to them.
914  *
915  * TIP: If you would like to learn more about reentrancy and alternative ways
916  * to protect against it, check out our blog post
917  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
918  */
919 
920 abstract contract ReentrancyGuard {
921     // Booleans are more expensive than uint256 or any type that takes up a full
922     // word because each write operation emits an extra SLOAD to first read the
923     // slot's contents, replace the bits taken up by the boolean, and then write
924     // back. This is the compiler's defense against contract upgrades and
925     // pointer aliasing, and it cannot be disabled.
926 
927     // The values being non-zero value makes deployment a bit more expensive,
928     // but in exchange the refund on every call to nonReentrant will be lower in
929     // amount. Since refunds are capped to a percentage of the total
930     // transaction's gas, it is best to keep them low in cases like this one, to
931     // increase the likelihood of the full refund coming into effect.
932     uint256 private constant _NOT_ENTERED = 1;
933     uint256 private constant _ENTERED = 2;
934 
935     uint256 private _status;
936 
937     constructor() {
938         _status = _NOT_ENTERED;
939     }
940 
941     /**
942      * @dev Prevents a contract from calling itself, directly or indirectly.
943      * Calling a `nonReentrant` function from another `nonReentrant`
944      * function is not supported. It is possible to prevent this from happening
945      * by making the `nonReentrant` function external, and making it call a
946      * `private` function that does the actual work.
947      */
948     modifier nonReentrant() {
949         // On the first call to nonReentrant, _notEntered will be true
950         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
951 
952         // Any calls to nonReentrant after this point will fail
953         _status = _ENTERED;
954 
955         _;
956 
957         // By storing the original value once again, a refund is triggered (see
958         // https://eips.ethereum.org/EIPS/eip-2200)
959         _status = _NOT_ENTERED;
960     }
961 }
962 
963 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
964 
965 
966 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
967 
968 // File: @openzeppelin/contracts/utils/Strings.sol
969 
970 
971 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
972 
973 pragma solidity ^0.8.0;
974 
975 /**
976  * @dev String operations.
977  */
978 library Strings {
979     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
980 
981     /**
982      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
983      */
984     function toString(uint256 value) internal pure returns (string memory) {
985         // Inspired by OraclizeAPI's implementation - MIT licence
986         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
987 
988         if (value == 0) {
989             return "0";
990         }
991         uint256 temp = value;
992         uint256 digits;
993         while (temp != 0) {
994             digits++;
995             temp /= 10;
996         }
997         bytes memory buffer = new bytes(digits);
998         while (value != 0) {
999             digits -= 1;
1000             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1001             value /= 10;
1002         }
1003         return string(buffer);
1004     }
1005 
1006     /**
1007      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1008      */
1009     function toHexString(uint256 value) internal pure returns (string memory) {
1010         if (value == 0) {
1011             return "0x00";
1012         }
1013         uint256 temp = value;
1014         uint256 length = 0;
1015         while (temp != 0) {
1016             length++;
1017             temp >>= 8;
1018         }
1019         return toHexString(value, length);
1020     }
1021 
1022     /**
1023      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1024      */
1025     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1026         bytes memory buffer = new bytes(2 * length + 2);
1027         buffer[0] = "0";
1028         buffer[1] = "x";
1029         for (uint256 i = 2 * length + 1; i > 1; --i) {
1030             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1031             value >>= 4;
1032         }
1033         require(value == 0, "Strings: hex length insufficient");
1034         return string(buffer);
1035     }
1036 }
1037 
1038 // File: @openzeppelin/contracts/utils/Context.sol
1039 
1040 
1041 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 /**
1046  * @dev Provides information about the current execution context, including the
1047  * sender of the transaction and its data. While these are generally available
1048  * via msg.sender and msg.data, they should not be accessed in such a direct
1049  * manner, since when dealing with meta-transactions the account sending and
1050  * paying for execution may not be the actual sender (as far as an application
1051  * is concerned).
1052  *
1053  * This contract is only required for intermediate, library-like contracts.
1054  */
1055 abstract contract Context {
1056     function _msgSender() internal view virtual returns (address) {
1057         return msg.sender;
1058     }
1059 
1060     function _msgData() internal view virtual returns (bytes calldata) {
1061         return msg.data;
1062     }
1063 }
1064 
1065 // File: @openzeppelin/contracts/access/Ownable.sol
1066 
1067 
1068 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 
1073 /**
1074  * @dev Contract module which provides a basic access control mechanism, where
1075  * there is an account (an owner) that can be granted exclusive access to
1076  * specific functions.
1077  *
1078  * By default, the owner account will be the one that deploys the contract. This
1079  * can later be changed with {transferOwnership}.
1080  *
1081  * This module is used through inheritance. It will make available the modifier
1082  * `onlyOwner`, which can be applied to your functions to restrict their use to
1083  * the owner.
1084  */
1085 abstract contract Ownable is Context {
1086     address private _owner;
1087 
1088     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1089 
1090     /**
1091      * @dev Initializes the contract setting the deployer as the initial owner.
1092      */
1093     constructor() {
1094         _transferOwnership(_msgSender());
1095     }
1096 
1097     /**
1098      * @dev Returns the address of the current owner.
1099      */
1100     function owner() public view virtual returns (address) {
1101         return _owner;
1102     }
1103 
1104     /**
1105      * @dev Throws if called by any account other than the owner.
1106      */
1107     modifier onlyOwner() {
1108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1109         _;
1110     }
1111 
1112     /**
1113      * @dev Leaves the contract without owner. It will not be possible to call
1114      * `onlyOwner` functions anymore. Can only be called by the current owner.
1115      *
1116      * NOTE: Renouncing ownership will leave the contract without an owner,
1117      * thereby removing any functionality that is only available to the owner.
1118      */
1119     function renounceOwnership() public virtual onlyOwner {
1120         _transferOwnership(address(0));
1121     }
1122 
1123     /**
1124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1125      * Can only be called by the current owner.
1126      */
1127     function transferOwnership(address newOwner) public virtual onlyOwner {
1128         require(newOwner != address(0), "Ownable: new owner is the zero address");
1129         _transferOwnership(newOwner);
1130     }
1131 
1132     /**
1133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1134      * Internal function without access restriction.
1135      */
1136     function _transferOwnership(address newOwner) internal virtual {
1137         address oldOwner = _owner;
1138         _owner = newOwner;
1139         emit OwnershipTransferred(oldOwner, newOwner);
1140     }
1141 }
1142 
1143 // File: @openzeppelin/contracts/utils/Address.sol
1144 
1145 
1146 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1147 
1148 pragma solidity ^0.8.1;
1149 
1150 /**
1151  * @dev Collection of functions related to the address type
1152  */
1153 library Address {
1154     /**
1155      * @dev Returns true if `account` is a contract.
1156      *
1157      * [IMPORTANT]
1158      * ====
1159      * It is unsafe to assume that an address for which this function returns
1160      * false is an externally-owned account (EOA) and not a contract.
1161      *
1162      * Among others, `isContract` will return false for the following
1163      * types of addresses:
1164      *
1165      *  - an externally-owned account
1166      *  - a contract in construction
1167      *  - an address where a contract will be created
1168      *  - an address where a contract lived, but was destroyed
1169      * ====
1170      *
1171      * [IMPORTANT]
1172      * ====
1173      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1174      *
1175      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1176      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1177      * constructor.
1178      * ====
1179      */
1180     function isContract(address account) internal view returns (bool) {
1181         // This method relies on extcodesize/address.code.length, which returns 0
1182         // for contracts in construction, since the code is only stored at the end
1183         // of the constructor execution.
1184 
1185         return account.code.length > 0;
1186     }
1187 
1188     /**
1189      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1190      * `recipient`, forwarding all available gas and reverting on errors.
1191      *
1192      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1193      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1194      * imposed by `transfer`, making them unable to receive funds via
1195      * `transfer`. {sendValue} removes this limitation.
1196      *
1197      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1198      *
1199      * IMPORTANT: because control is transferred to `recipient`, care must be
1200      * taken to not create reentrancy vulnerabilities. Consider using
1201      * {ReentrancyGuard} or the
1202      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1203      */
1204     function sendValue(address payable recipient, uint256 amount) internal {
1205         require(address(this).balance >= amount, "Address: insufficient balance");
1206 
1207         (bool success, ) = recipient.call{value: amount}("");
1208         require(success, "Address: unable to send value, recipient may have reverted");
1209     }
1210 
1211     /**
1212      * @dev Performs a Solidity function call using a low level `call`. A
1213      * plain `call` is an unsafe replacement for a function call: use this
1214      * function instead.
1215      *
1216      * If `target` reverts with a revert reason, it is bubbled up by this
1217      * function (like regular Solidity function calls).
1218      *
1219      * Returns the raw returned data. To convert to the expected return value,
1220      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1221      *
1222      * Requirements:
1223      *
1224      * - `target` must be a contract.
1225      * - calling `target` with `data` must not revert.
1226      *
1227      * _Available since v3.1._
1228      */
1229     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1230         return functionCall(target, data, "Address: low-level call failed");
1231     }
1232 
1233     /**
1234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1235      * `errorMessage` as a fallback revert reason when `target` reverts.
1236      *
1237      * _Available since v3.1._
1238      */
1239     function functionCall(
1240         address target,
1241         bytes memory data,
1242         string memory errorMessage
1243     ) internal returns (bytes memory) {
1244         return functionCallWithValue(target, data, 0, errorMessage);
1245     }
1246 
1247     /**
1248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1249      * but also transferring `value` wei to `target`.
1250      *
1251      * Requirements:
1252      *
1253      * - the calling contract must have an ETH balance of at least `value`.
1254      * - the called Solidity function must be `payable`.
1255      *
1256      * _Available since v3.1._
1257      */
1258     function functionCallWithValue(
1259         address target,
1260         bytes memory data,
1261         uint256 value
1262     ) internal returns (bytes memory) {
1263         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1264     }
1265 
1266     /**
1267      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1268      * with `errorMessage` as a fallback revert reason when `target` reverts.
1269      *
1270      * _Available since v3.1._
1271      */
1272     function functionCallWithValue(
1273         address target,
1274         bytes memory data,
1275         uint256 value,
1276         string memory errorMessage
1277     ) internal returns (bytes memory) {
1278         require(address(this).balance >= value, "Address: insufficient balance for call");
1279         require(isContract(target), "Address: call to non-contract");
1280 
1281         (bool success, bytes memory returndata) = target.call{value: value}(data);
1282         return verifyCallResult(success, returndata, errorMessage);
1283     }
1284 
1285     /**
1286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1287      * but performing a static call.
1288      *
1289      * _Available since v3.3._
1290      */
1291     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1292         return functionStaticCall(target, data, "Address: low-level static call failed");
1293     }
1294 
1295     /**
1296      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1297      * but performing a static call.
1298      *
1299      * _Available since v3.3._
1300      */
1301     function functionStaticCall(
1302         address target,
1303         bytes memory data,
1304         string memory errorMessage
1305     ) internal view returns (bytes memory) {
1306         require(isContract(target), "Address: static call to non-contract");
1307 
1308         (bool success, bytes memory returndata) = target.staticcall(data);
1309         return verifyCallResult(success, returndata, errorMessage);
1310     }
1311 
1312     /**
1313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1314      * but performing a delegate call.
1315      *
1316      * _Available since v3.4._
1317      */
1318     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1319         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1320     }
1321 
1322     /**
1323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1324      * but performing a delegate call.
1325      *
1326      * _Available since v3.4._
1327      */
1328     function functionDelegateCall(
1329         address target,
1330         bytes memory data,
1331         string memory errorMessage
1332     ) internal returns (bytes memory) {
1333         require(isContract(target), "Address: delegate call to non-contract");
1334 
1335         (bool success, bytes memory returndata) = target.delegatecall(data);
1336         return verifyCallResult(success, returndata, errorMessage);
1337     }
1338 
1339     /**
1340      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1341      * revert reason using the provided one.
1342      *
1343      * _Available since v4.3._
1344      */
1345     function verifyCallResult(
1346         bool success,
1347         bytes memory returndata,
1348         string memory errorMessage
1349     ) internal pure returns (bytes memory) {
1350         if (success) {
1351             return returndata;
1352         } else {
1353             // Look for revert reason and bubble it up if present
1354             if (returndata.length > 0) {
1355                 // The easiest way to bubble the revert reason is using memory via assembly
1356 
1357                 assembly {
1358                     let returndata_size := mload(returndata)
1359                     revert(add(32, returndata), returndata_size)
1360                 }
1361             } else {
1362                 revert(errorMessage);
1363             }
1364         }
1365     }
1366 }
1367 
1368 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1369 
1370 
1371 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 /**
1376  * @title ERC721 token receiver interface
1377  * @dev Interface for any contract that wants to support safeTransfers
1378  * from ERC721 asset contracts.
1379  */
1380 interface IERC721Receiver {
1381     /**
1382      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1383      * by `operator` from `from`, this function is called.
1384      *
1385      * It must return its Solidity selector to confirm the token transfer.
1386      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1387      *
1388      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1389      */
1390     function onERC721Received(
1391         address operator,
1392         address from,
1393         uint256 tokenId,
1394         bytes calldata data
1395     ) external returns (bytes4);
1396 }
1397 
1398 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1399 
1400 
1401 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 /**
1406  * @dev Interface of the ERC165 standard, as defined in the
1407  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1408  *
1409  * Implementers can declare support of contract interfaces, which can then be
1410  * queried by others ({ERC165Checker}).
1411  *
1412  * For an implementation, see {ERC165}.
1413  */
1414 
1415 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1416 
1417 
1418 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1419 
1420 pragma solidity ^0.8.0;
1421 
1422 
1423 /**
1424  * @dev Implementation of the {IERC165} interface.
1425  *
1426  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1427  * for the additional interface id that will be supported. For example:
1428  *
1429  * ```solidity
1430  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1431  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1432  * }
1433  * ```
1434  *
1435  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1436  */
1437 
1438 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1439 
1440 
1441 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1442 
1443 pragma solidity ^0.8.0;
1444 
1445 
1446 /**
1447  * @dev Required interface of an ERC721 compliant contract.
1448  */
1449 interface IERC721 is IERC165 {
1450     /**
1451      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1452      */
1453     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1454 
1455     /**
1456      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1457      */
1458     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1459 
1460     /**
1461      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1462      */
1463     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1464 
1465     /**
1466      * @dev Returns the number of tokens in ``owner``'s account.
1467      */
1468     function balanceOf(address owner) external view returns (uint256 balance);
1469 
1470     /**
1471      * @dev Returns the owner of the `tokenId` token.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      */
1477     function ownerOf(uint256 tokenId) external view returns (address owner);
1478 
1479     /**
1480      * @dev Safely transfers `tokenId` token from `from` to `to`.
1481      *
1482      * Requirements:
1483      *
1484      * - `from` cannot be the zero address.
1485      * - `to` cannot be the zero address.
1486      * - `tokenId` token must exist and be owned by `from`.
1487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function safeTransferFrom(
1493         address from,
1494         address to,
1495         uint256 tokenId,
1496         bytes calldata data
1497     ) external;
1498 
1499     /**
1500      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1501      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1502      *
1503      * Requirements:
1504      *
1505      * - `from` cannot be the zero address.
1506      * - `to` cannot be the zero address.
1507      * - `tokenId` token must exist and be owned by `from`.
1508      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1509      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function safeTransferFrom(
1514         address from,
1515         address to,
1516         uint256 tokenId
1517     ) external;
1518 
1519     /**
1520      * @dev Transfers `tokenId` token from `from` to `to`.
1521      *
1522      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1523      *
1524      * Requirements:
1525      *
1526      * - `from` cannot be the zero address.
1527      * - `to` cannot be the zero address.
1528      * - `tokenId` token must be owned by `from`.
1529      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1530      *
1531      * Emits a {Transfer} event.
1532      */
1533     function transferFrom(
1534         address from,
1535         address to,
1536         uint256 tokenId
1537     ) external;
1538 
1539     /**
1540      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1541      * The approval is cleared when the token is transferred.
1542      *
1543      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1544      *
1545      * Requirements:
1546      *
1547      * - The caller must own the token or be an approved operator.
1548      * - `tokenId` must exist.
1549      *
1550      * Emits an {Approval} event.
1551      */
1552     function approve(address to, uint256 tokenId) external;
1553 
1554     /**
1555      * @dev Approve or remove `operator` as an operator for the caller.
1556      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1557      *
1558      * Requirements:
1559      *
1560      * - The `operator` cannot be the caller.
1561      *
1562      * Emits an {ApprovalForAll} event.
1563      */
1564     function setApprovalForAll(address operator, bool _approved) external;
1565 
1566     /**
1567      * @dev Returns the account approved for `tokenId` token.
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must exist.
1572      */
1573     function getApproved(uint256 tokenId) external view returns (address operator);
1574 
1575     /**
1576      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1577      *
1578      * See {setApprovalForAll}
1579      */
1580     function isApprovedForAll(address owner, address operator) external view returns (bool);
1581 }
1582 
1583 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1584 
1585 
1586 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1587 
1588 pragma solidity ^0.8.0;
1589 
1590 
1591 /**
1592  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1593  * @dev See https://eips.ethereum.org/EIPS/eip-721
1594  */
1595 interface IERC721Metadata is IERC721 {
1596     /**
1597      * @dev Returns the token collection name.
1598      */
1599     function name() external view returns (string memory);
1600 
1601     /**
1602      * @dev Returns the token collection symbol.
1603      */
1604     function symbol() external view returns (string memory);
1605 
1606     /**
1607      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1608      */
1609     function tokenURI(uint256 tokenId) external view returns (string memory);
1610 }
1611 
1612 // File: ERC721A.sol
1613 
1614 
1615 // Creator: Chiru Labs
1616 
1617 pragma solidity ^0.8.4;
1618 
1619 
1620 
1621 
1622 
1623 
1624 
1625 
1626 error ApprovalCallerNotOwnerNorApproved();
1627 error ApprovalQueryForNonexistentToken();
1628 error ApproveToCaller();
1629 error ApprovalToCurrentOwner();
1630 error BalanceQueryForZeroAddress();
1631 error MintToZeroAddress();
1632 error MintZeroQuantity();
1633 error OwnerQueryForNonexistentToken();
1634 error TransferCallerNotOwnerNorApproved();
1635 error TransferFromIncorrectOwner();
1636 error TransferToNonERC721ReceiverImplementer();
1637 error TransferToZeroAddress();
1638 error URIQueryForNonexistentToken();
1639 
1640 /**
1641  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1642  * the Metadata extension. Built to optimize for lower gas during batch mints.
1643  *
1644  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1645  *
1646  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1647  *
1648  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1649  */
1650 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1651     using Address for address;
1652     using Strings for uint256;
1653 
1654     // Compiler will pack this into a single 256bit word.
1655     struct TokenOwnership {
1656         // The address of the owner.
1657         address addr;
1658         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1659         uint64 startTimestamp;
1660         // Whether the token has been burned.
1661         bool burned;
1662     }
1663 
1664     // Compiler will pack this into a single 256bit word.
1665     struct AddressData {
1666         // Realistically, 2**64-1 is more than enough.
1667         uint64 balance;
1668         // Keeps track of mint count with minimal overhead for tokenomics.
1669         uint64 numberMinted;
1670         // Keeps track of burn count with minimal overhead for tokenomics.
1671         uint64 numberBurned;
1672         // For miscellaneous variable(s) pertaining to the address
1673         // (e.g. number of whitelist mint slots used).
1674         // If there are multiple variables, please pack them into a uint64.
1675         uint64 aux;
1676     }
1677 
1678     // The tokenId of the next token to be minted.
1679     uint256 internal _currentIndex;
1680 
1681     // The number of tokens burned.
1682     uint256 internal _burnCounter;
1683 
1684     // Token name
1685     string private _name;
1686 
1687     // Token symbol
1688     string private _symbol;
1689 
1690     // Mapping from token ID to ownership details
1691     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1692     mapping(uint256 => TokenOwnership) internal _ownerships;
1693 
1694     // Mapping owner address to address data
1695     mapping(address => AddressData) private _addressData;
1696 
1697     // Mapping from token ID to approved address
1698     mapping(uint256 => address) private _tokenApprovals;
1699 
1700     // Mapping from owner to operator approvals
1701     mapping(address => mapping(address => bool)) private _operatorApprovals;
1702 
1703     constructor(string memory name_, string memory symbol_) {
1704         _name = name_;
1705         _symbol = symbol_;
1706         _currentIndex = _startTokenId();
1707     }
1708 
1709     /**
1710      * To change the starting tokenId, please override this function.
1711      */
1712     function _startTokenId() internal view virtual returns (uint256) {
1713         return 1;
1714     }
1715 
1716     /**
1717      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1718      */
1719     function totalSupply() public view returns (uint256) {
1720         // Counter underflow is impossible as _burnCounter cannot be incremented
1721         // more than _currentIndex - _startTokenId() times
1722         unchecked {
1723             return _currentIndex - _burnCounter - _startTokenId();
1724         }
1725     }
1726 
1727     /**
1728      * Returns the total amount of tokens minted in the contract.
1729      */
1730     function _totalMinted() internal view returns (uint256) {
1731         // Counter underflow is impossible as _currentIndex does not decrement,
1732         // and it is initialized to _startTokenId()
1733         unchecked {
1734             return _currentIndex - _startTokenId();
1735         }
1736     }
1737 
1738     /**
1739      * @dev See {IERC165-supportsInterface}.
1740      */
1741     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1742         return
1743             interfaceId == type(IERC721).interfaceId ||
1744             interfaceId == type(IERC721Metadata).interfaceId ||
1745             super.supportsInterface(interfaceId);
1746     }
1747 
1748     /**
1749      * @dev See {IERC721-balanceOf}.
1750      */
1751     function balanceOf(address owner) public view override returns (uint256) {
1752         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1753         return uint256(_addressData[owner].balance);
1754     }
1755 
1756     /**
1757      * Returns the number of tokens minted by `owner`.
1758      */
1759     function _numberMinted(address owner) internal view returns (uint256) {
1760         return uint256(_addressData[owner].numberMinted);
1761     }
1762 
1763     /**
1764      * Returns the number of tokens burned by or on behalf of `owner`.
1765      */
1766     function _numberBurned(address owner) internal view returns (uint256) {
1767         return uint256(_addressData[owner].numberBurned);
1768     }
1769 
1770     /**
1771      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1772      */
1773     function _getAux(address owner) internal view returns (uint64) {
1774         return _addressData[owner].aux;
1775     }
1776 
1777     /**
1778      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1779      * If there are multiple variables, please pack them into a uint64.
1780      */
1781     function _setAux(address owner, uint64 aux) internal {
1782         _addressData[owner].aux = aux;
1783     }
1784 
1785     /**
1786      * Gas spent here starts off proportional to the maximum mint batch size.
1787      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1788      */
1789     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1790         uint256 curr = tokenId;
1791 
1792         unchecked {
1793             if (_startTokenId() <= curr && curr < _currentIndex) {
1794                 TokenOwnership memory ownership = _ownerships[curr];
1795                 if (!ownership.burned) {
1796                     if (ownership.addr != address(0)) {
1797                         return ownership;
1798                     }
1799                     // Invariant:
1800                     // There will always be an ownership that has an address and is not burned
1801                     // before an ownership that does not have an address and is not burned.
1802                     // Hence, curr will not underflow.
1803                     while (true) {
1804                         curr--;
1805                         ownership = _ownerships[curr];
1806                         if (ownership.addr != address(0)) {
1807                             return ownership;
1808                         }
1809                     }
1810                 }
1811             }
1812         }
1813         revert OwnerQueryForNonexistentToken();
1814     }
1815 
1816     /**
1817      * @dev See {IERC721-ownerOf}.
1818      */
1819     function ownerOf(uint256 tokenId) public view override returns (address) {
1820         return _ownershipOf(tokenId).addr;
1821     }
1822 
1823     /**
1824      * @dev See {IERC721Metadata-name}.
1825      */
1826     function name() public view virtual override returns (string memory) {
1827         return _name;
1828     }
1829 
1830     /**
1831      * @dev See {IERC721Metadata-symbol}.
1832      */
1833     function symbol() public view virtual override returns (string memory) {
1834         return _symbol;
1835     }
1836 
1837     /**
1838      * @dev See {IERC721Metadata-tokenURI}.
1839      */
1840     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1841         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1842 
1843         string memory baseURI = _baseURI();
1844         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1845     }
1846 
1847     /**
1848      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1849      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1850      * by default, can be overriden in child contracts.
1851      */
1852     function _baseURI() internal view virtual returns (string memory) {
1853         return '';
1854     }
1855 
1856     /**
1857      * @dev See {IERC721-approve}.
1858      */
1859     function approve(address to, uint256 tokenId) public override {
1860         address owner = ERC721A.ownerOf(tokenId);
1861         if (to == owner) revert ApprovalToCurrentOwner();
1862 
1863         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1864             revert ApprovalCallerNotOwnerNorApproved();
1865         }
1866 
1867         _approve(to, tokenId, owner);
1868     }
1869 
1870     /**
1871      * @dev See {IERC721-getApproved}.
1872      */
1873     function getApproved(uint256 tokenId) public view override returns (address) {
1874         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1875 
1876         return _tokenApprovals[tokenId];
1877     }
1878 
1879     /**
1880      * @dev See {IERC721-setApprovalForAll}.
1881      */
1882     function setApprovalForAll(address operator, bool approved) public virtual override {
1883         if (operator == _msgSender()) revert ApproveToCaller();
1884 
1885         _operatorApprovals[_msgSender()][operator] = approved;
1886         emit ApprovalForAll(_msgSender(), operator, approved);
1887     }
1888 
1889     /**
1890      * @dev See {IERC721-isApprovedForAll}.
1891      */
1892     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1893         return _operatorApprovals[owner][operator];
1894     }
1895 
1896     /**
1897      * @dev See {IERC721-transferFrom}.
1898      */
1899     function transferFrom(
1900         address from,
1901         address to,
1902         uint256 tokenId
1903     ) public virtual override {
1904         _transfer(from, to, tokenId);
1905     }
1906 
1907     /**
1908      * @dev See {IERC721-safeTransferFrom}.
1909      */
1910     function safeTransferFrom(
1911         address from,
1912         address to,
1913         uint256 tokenId
1914     ) public virtual override {
1915         safeTransferFrom(from, to, tokenId, '');
1916     }
1917 
1918     /**
1919      * @dev See {IERC721-safeTransferFrom}.
1920      */
1921     function safeTransferFrom(
1922         address from,
1923         address to,
1924         uint256 tokenId,
1925         bytes memory _data
1926     ) public virtual override {
1927         _transfer(from, to, tokenId);
1928         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1929             revert TransferToNonERC721ReceiverImplementer();
1930         }
1931     }
1932 
1933     /**
1934      * @dev Returns whether `tokenId` exists.
1935      *
1936      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1937      *
1938      * Tokens start existing when they are minted (`_mint`),
1939      */
1940     function _exists(uint256 tokenId) internal view returns (bool) {
1941         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1942     }
1943 
1944     function _safeMint(address to, uint256 quantity) internal {
1945         _safeMint(to, quantity, '');
1946     }
1947 
1948     /**
1949      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1950      *
1951      * Requirements:
1952      *
1953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1954      * - `quantity` must be greater than 0.
1955      *
1956      * Emits a {Transfer} event.
1957      */
1958     function _safeMint(
1959         address to,
1960         uint256 quantity,
1961         bytes memory _data
1962     ) internal {
1963         _mint(to, quantity, _data, true);
1964     }
1965 
1966     /**
1967      * @dev Mints `quantity` tokens and transfers them to `to`.
1968      *
1969      * Requirements:
1970      *
1971      * - `to` cannot be the zero address.
1972      * - `quantity` must be greater than 0.
1973      *
1974      * Emits a {Transfer} event.
1975      */
1976     function _mint(
1977         address to,
1978         uint256 quantity,
1979         bytes memory _data,
1980         bool safe
1981     ) internal {
1982         uint256 startTokenId = _currentIndex;
1983         if (to == address(0)) revert MintToZeroAddress();
1984         if (quantity == 0) revert MintZeroQuantity();
1985 
1986         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1987 
1988         // Overflows are incredibly unrealistic.
1989         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1990         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1991         unchecked {
1992             _addressData[to].balance += uint64(quantity);
1993             _addressData[to].numberMinted += uint64(quantity);
1994 
1995             _ownerships[startTokenId].addr = to;
1996             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1997 
1998             uint256 updatedIndex = startTokenId;
1999             uint256 end = updatedIndex + quantity;
2000 
2001             if (safe && to.isContract()) {
2002                 do {
2003                     emit Transfer(address(0), to, updatedIndex);
2004                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2005                         revert TransferToNonERC721ReceiverImplementer();
2006                     }
2007                 } while (updatedIndex != end);
2008                 // Reentrancy protection
2009                 if (_currentIndex != startTokenId) revert();
2010             } else {
2011                 do {
2012                     emit Transfer(address(0), to, updatedIndex++);
2013                 } while (updatedIndex != end);
2014             }
2015             _currentIndex = updatedIndex;
2016         }
2017         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2018     }
2019 
2020     /**
2021      * @dev Transfers `tokenId` from `from` to `to`.
2022      *
2023      * Requirements:
2024      *
2025      * - `to` cannot be the zero address.
2026      * - `tokenId` token must be owned by `from`.
2027      *
2028      * Emits a {Transfer} event.
2029      */
2030     function _transfer(
2031         address from,
2032         address to,
2033         uint256 tokenId
2034     ) private {
2035         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2036 
2037         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2038 
2039         bool isApprovedOrOwner = (_msgSender() == from ||
2040             isApprovedForAll(from, _msgSender()) ||
2041             getApproved(tokenId) == _msgSender());
2042 
2043         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2044         if (to == address(0)) revert TransferToZeroAddress();
2045 
2046         _beforeTokenTransfers(from, to, tokenId, 1);
2047 
2048         // Clear approvals from the previous owner
2049         _approve(address(0), tokenId, from);
2050 
2051         // Underflow of the sender's balance is impossible because we check for
2052         // ownership above and the recipient's balance can't realistically overflow.
2053         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2054         unchecked {
2055             _addressData[from].balance -= 1;
2056             _addressData[to].balance += 1;
2057 
2058             TokenOwnership storage currSlot = _ownerships[tokenId];
2059             currSlot.addr = to;
2060             currSlot.startTimestamp = uint64(block.timestamp);
2061 
2062             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2063             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2064             uint256 nextTokenId = tokenId + 1;
2065             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2066             if (nextSlot.addr == address(0)) {
2067                 // This will suffice for checking _exists(nextTokenId),
2068                 // as a burned slot cannot contain the zero address.
2069                 if (nextTokenId != _currentIndex) {
2070                     nextSlot.addr = from;
2071                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2072                 }
2073             }
2074         }
2075 
2076         emit Transfer(from, to, tokenId);
2077         _afterTokenTransfers(from, to, tokenId, 1);
2078     }
2079 
2080     /**
2081      * @dev This is equivalent to _burn(tokenId, false)
2082      */
2083     function _burn(uint256 tokenId) internal virtual {
2084         _burn(tokenId, false);
2085     }
2086 
2087     /**
2088      * @dev Destroys `tokenId`.
2089      * The approval is cleared when the token is burned.
2090      *
2091      * Requirements:
2092      *
2093      * - `tokenId` must exist.
2094      *
2095      * Emits a {Transfer} event.
2096      */
2097     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2098         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2099 
2100         address from = prevOwnership.addr;
2101 
2102         if (approvalCheck) {
2103             bool isApprovedOrOwner = (_msgSender() == from ||
2104                 isApprovedForAll(from, _msgSender()) ||
2105                 getApproved(tokenId) == _msgSender());
2106 
2107             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2108         }
2109 
2110         _beforeTokenTransfers(from, address(0), tokenId, 1);
2111 
2112         // Clear approvals from the previous owner
2113         _approve(address(0), tokenId, from);
2114 
2115         // Underflow of the sender's balance is impossible because we check for
2116         // ownership above and the recipient's balance can't realistically overflow.
2117         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2118         unchecked {
2119             AddressData storage addressData = _addressData[from];
2120             addressData.balance -= 1;
2121             addressData.numberBurned += 1;
2122 
2123             // Keep track of who burned the token, and the timestamp of burning.
2124             TokenOwnership storage currSlot = _ownerships[tokenId];
2125             currSlot.addr = from;
2126             currSlot.startTimestamp = uint64(block.timestamp);
2127             currSlot.burned = true;
2128 
2129             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2130             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2131             uint256 nextTokenId = tokenId + 1;
2132             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2133             if (nextSlot.addr == address(0)) {
2134                 // This will suffice for checking _exists(nextTokenId),
2135                 // as a burned slot cannot contain the zero address.
2136                 if (nextTokenId != _currentIndex) {
2137                     nextSlot.addr = from;
2138                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2139                 }
2140             }
2141         }
2142 
2143         emit Transfer(from, address(0), tokenId);
2144         _afterTokenTransfers(from, address(0), tokenId, 1);
2145 
2146         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2147         unchecked {
2148             _burnCounter++;
2149         }
2150     }
2151 
2152     /**
2153      * @dev Approve `to` to operate on `tokenId`
2154      *
2155      * Emits a {Approval} event.
2156      */
2157     function _approve(
2158         address to,
2159         uint256 tokenId,
2160         address owner
2161     ) private {
2162         _tokenApprovals[tokenId] = to;
2163         emit Approval(owner, to, tokenId);
2164     }
2165 
2166     /**
2167      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2168      *
2169      * @param from address representing the previous owner of the given token ID
2170      * @param to target address that will receive the tokens
2171      * @param tokenId uint256 ID of the token to be transferred
2172      * @param _data bytes optional data to send along with the call
2173      * @return bool whether the call correctly returned the expected magic value
2174      */
2175     function _checkContractOnERC721Received(
2176         address from,
2177         address to,
2178         uint256 tokenId,
2179         bytes memory _data
2180     ) private returns (bool) {
2181         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2182             return retval == IERC721Receiver(to).onERC721Received.selector;
2183         } catch (bytes memory reason) {
2184             if (reason.length == 0) {
2185                 revert TransferToNonERC721ReceiverImplementer();
2186             } else {
2187                 assembly {
2188                     revert(add(32, reason), mload(reason))
2189                 }
2190             }
2191         }
2192     }
2193 
2194     /**
2195      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2196      * And also called before burning one token.
2197      *
2198      * startTokenId - the first token id to be transferred
2199      * quantity - the amount to be transferred
2200      *
2201      * Calling conditions:
2202      *
2203      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2204      * transferred to `to`.
2205      * - When `from` is zero, `tokenId` will be minted for `to`.
2206      * - When `to` is zero, `tokenId` will be burned by `from`.
2207      * - `from` and `to` are never both zero.
2208      */
2209     function _beforeTokenTransfers(
2210         address from,
2211         address to,
2212         uint256 startTokenId,
2213         uint256 quantity
2214     ) internal virtual {}
2215 
2216     /**
2217      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2218      * minting.
2219      * And also called after one token has been burned.
2220      *
2221      * startTokenId - the first token id to be transferred
2222      * quantity - the amount to be transferred
2223      *
2224      * Calling conditions:
2225      *
2226      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2227      * transferred to `to`.
2228      * - When `from` is zero, `tokenId` has been minted for `to`.
2229      * - When `to` is zero, `tokenId` has been burned by `from`.
2230      * - `from` and `to` are never both zero.
2231      */
2232     function _afterTokenTransfers(
2233         address from,
2234         address to,
2235         uint256 startTokenId,
2236         uint256 quantity
2237     ) internal virtual {}
2238 }
2239 // File: Contract.sol
2240 
2241 
2242 pragma solidity ^0.8.7;
2243 
2244 
2245 
2246 contract NebulaGods_Contract is ERC721A, ERC2981, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2247     using Strings for uint256;
2248     mapping(address => uint256) public publicClaimed;
2249     mapping(address => uint256) public whitelistClaimed;
2250     mapping(address => uint256) public additionalClaimed;
2251     string public baseURI;
2252     string public hiddenMetadataURI = "ipfs://bafybeiah3p42wxvh7gkzqisd26mnx5poy45wtcj6kc7o4zptwh4zfbslce/1.json";
2253     bool public revealed;
2254     bool public paused = true;
2255     address public ROYALITY__ADDRESS;
2256     uint96 public ROYALITY__VALUE;
2257     uint256 public publicPrice = 0.012 ether;
2258     uint256 public presalePrice = 0.0099 ether;
2259     uint256 public publicMintPerTx = 15;
2260     uint256 public whitelistMintPerTx = 15;
2261     uint256 public additionalMintPerTx = 15;
2262     uint256 public maxSupply = 6543;
2263     bool public whitelistStatus = true;
2264     bool public additionalStatus = false;
2265     bytes32 public root = 0x8d9bf2becb9972369e9cf2c92107323f2c89465fec847368a6d4be867159dd6c;
2266 
2267     constructor() ERC721A("Nebula Gods", "NG") {
2268         ROYALITY__ADDRESS = msg.sender;
2269         ROYALITY__VALUE = 550;
2270         _setDefaultRoyalty(ROYALITY__ADDRESS, ROYALITY__VALUE);
2271     }
2272 
2273     // ============ PUBLIC FUNCTIONS FOR MINTING ============
2274     function mint(uint256 quantity, bytes32[] calldata proofs) external payable nonReentrant {
2275         require(!paused, "The contract is paused!");
2276         require(quantity > 0 && totalSupply() + quantity <= maxSupply, "Invalid amount!");
2277         uint256 freeMint = quantity;
2278         if(whitelistStatus) {
2279             require(isValid(proofs), "You're not whitelisted");
2280             require(whitelistClaimed[msg.sender] + quantity <= whitelistMintPerTx, "You can't mint this amount");
2281             if (whitelistClaimed[msg.sender] == 0 )
2282                 freeMint--;
2283             require(msg.value >= presalePrice * freeMint, "Insufficient Funds!");
2284             whitelistClaimed[msg.sender] += quantity;
2285         } else if (additionalStatus) {
2286             require(additionalClaimed[msg.sender] + quantity <= additionalMintPerTx, "You can't mint this amount");
2287             if (additionalClaimed[msg.sender] == 0 )
2288                 freeMint--;
2289             require(msg.value >= publicPrice * freeMint, "Insufficient Funds!");
2290            additionalClaimed[msg.sender] += quantity;
2291         } else {
2292              require(publicClaimed[msg.sender] + quantity <= publicMintPerTx, "You can't mint this amount");
2293              require(msg.value >= publicPrice * quantity, "Insufficient Funds!");
2294              publicClaimed[msg.sender] +=quantity;
2295         }
2296         _safeMint(msg.sender, quantity);
2297     }
2298 
2299     function _baseURI() internal view virtual override returns (string memory) {
2300         return baseURI;
2301     }
2302 
2303 
2304     // ============ PUBLIC READ-ONLY FUNCTIONS ============
2305     function isValid(bytes32[] calldata _merkleProof) internal view returns (bool){
2306         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2307         require(MerkleProof.verify(_merkleProof, root, leaf), "Address is not whitelisted!");
2308         return true;
2309     }
2310     function tokenURI(uint256 tokenId)
2311         public
2312         view
2313         virtual
2314         override
2315         returns (string memory)
2316     {
2317         require(
2318             _exists(tokenId),
2319             "ERC721Metadata: URI query for nonexistent token"
2320         );
2321         if (revealed == false) {
2322             return hiddenMetadataURI;
2323         }
2324         string memory currentBaseURI = _baseURI();
2325         return
2326             bytes(currentBaseURI).length > 0
2327                 ? string(
2328                     abi.encodePacked(
2329                         currentBaseURI,
2330                         tokenId.toString(),
2331                         ".json"
2332                     )
2333                 )
2334                 : "";
2335     }
2336     function supportsInterface(bytes4 interfaceId)
2337     public
2338     view
2339     override(ERC721A, ERC2981)
2340     returns (bool)
2341     {
2342         return
2343             ERC721A.supportsInterface(interfaceId)
2344             || ERC2981.supportsInterface(interfaceId);
2345     }
2346     function setRoot(bytes32 _newRoot) external onlyOwner {
2347         root = _newRoot;
2348     }
2349     function setWhitelistStatus(bool _newState) external onlyOwner {
2350         whitelistStatus = _newState;
2351     }
2352     function setAdditionalStatus (bool _newState) external onlyOwner {
2353         additionalStatus = _newState;
2354     }
2355     function setRoyalties(address receiver, uint96 royaltyFraction) external onlyOwner {
2356         _setDefaultRoyalty(receiver, royaltyFraction);
2357     }
2358     function setWhitelistMintPerTx(uint256 _newState) external onlyOwner {
2359         whitelistMintPerTx = _newState;
2360     }
2361     function setPresalePrice(uint256 _newState) external onlyOwner {
2362         presalePrice = _newState;
2363     }
2364     function setCost(uint256 _newPublicCost) external onlyOwner {
2365         publicPrice = _newPublicCost;
2366     }
2367  
2368     function setMaxPublic(uint256 _newMaxPublic) external onlyOwner {
2369         publicMintPerTx = _newMaxPublic;
2370     }
2371     
2372     function setAdditionalMintPerTx (uint256 _newMaxAdditional) external onlyOwner {
2373         additionalMintPerTx = _newMaxAdditional;
2374     }
2375 
2376     function setMaxSuppy(uint256 _amount) external onlyOwner {
2377         maxSupply = _amount;
2378     }
2379 
2380     function setPaused(bool _state) external onlyOwner {
2381         paused = _state;
2382     }
2383 
2384     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2385         baseURI = _newBaseURI;
2386     }
2387     function setRevealed(bool _state) external onlyOwner {
2388         revealed = _state;
2389     }
2390 
2391     function setHiddenMetadataURI(string memory _URI) external onlyOwner {
2392         hiddenMetadataURI = _URI;
2393     }
2394 
2395     function airDrop(uint256 quantity, address _address) external onlyOwner {
2396         _safeMint(_address, quantity);
2397     }
2398     
2399 
2400     function airDropBatch(address[] memory _addresses) external onlyOwner {
2401         for(uint256 i = 0 ;i < _addresses.length; i ++) {
2402             _safeMint(_addresses[i], 1);
2403         }
2404     }
2405 
2406     function withdraw() public onlyOwner {
2407          // Do not remove this otherwise you will not be able to withdraw the funds.
2408         // =============================================================================
2409         (bool ts, ) = payable(owner()).call{value: address(this).balance}("");
2410         require(ts);
2411         // =============================================================================
2412     }
2413       function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
2414         super.transferFrom(from, to, tokenId);
2415     }
2416 
2417     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
2418         super.safeTransferFrom(from, to, tokenId);
2419     }
2420 
2421     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2422         public
2423         override
2424         onlyAllowedOperator
2425     {
2426         super.safeTransferFrom(from, to, tokenId, data);
2427     }
2428 }