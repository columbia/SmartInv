1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Library for managing
10  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
11  * types.
12  *
13  * Sets have the following properties:
14  *
15  * - Elements are added, removed, and checked for existence in constant time
16  * (O(1)).
17  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
18  *
19  * ```
20  * contract Example {
21  *     // Add the library methods
22  *     using EnumerableSet for EnumerableSet.AddressSet;
23  *
24  *     // Declare a set state variable
25  *     EnumerableSet.AddressSet private mySet;
26  * }
27  * ```
28  *
29  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
30  * and `uint256` (`UintSet`) are supported.
31  *
32  * [WARNING]
33  * ====
34  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
35  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
36  *
37  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
38  * ====
39  */
40 library EnumerableSet {
41     // To implement this library for multiple types with as little code
42     // repetition as possible, we write it in terms of a generic Set type with
43     // bytes32 values.
44     // The Set implementation uses private functions, and user-facing
45     // implementations (such as AddressSet) are just wrappers around the
46     // underlying Set.
47     // This means that we can only create new EnumerableSets for types that fit
48     // in bytes32.
49 
50     struct Set {
51         // Storage of set values
52         bytes32[] _values;
53         // Position of the value in the `values` array, plus 1 because index 0
54         // means a value is not in the set.
55         mapping(bytes32 => uint256) _indexes;
56     }
57 
58     /**
59      * @dev Add a value to a set. O(1).
60      *
61      * Returns true if the value was added to the set, that is if it was not
62      * already present.
63      */
64     function _add(Set storage set, bytes32 value) private returns (bool) {
65         if (!_contains(set, value)) {
66             set._values.push(value);
67             // The value is stored at length-1, but we add 1 to all indexes
68             // and use 0 as a sentinel value
69             set._indexes[value] = set._values.length;
70             return true;
71         } else {
72             return false;
73         }
74     }
75 
76     /**
77      * @dev Removes a value from a set. O(1).
78      *
79      * Returns true if the value was removed from the set, that is if it was
80      * present.
81      */
82     function _remove(Set storage set, bytes32 value) private returns (bool) {
83         // We read and store the value's index to prevent multiple reads from the same storage slot
84         uint256 valueIndex = set._indexes[value];
85 
86         if (valueIndex != 0) {
87             // Equivalent to contains(set, value)
88             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
89             // the array, and then remove the last element (sometimes called as 'swap and pop').
90             // This modifies the order of the array, as noted in {at}.
91 
92             uint256 toDeleteIndex = valueIndex - 1;
93             uint256 lastIndex = set._values.length - 1;
94 
95             if (lastIndex != toDeleteIndex) {
96                 bytes32 lastValue = set._values[lastIndex];
97 
98                 // Move the last value to the index where the value to delete is
99                 set._values[toDeleteIndex] = lastValue;
100                 // Update the index for the moved value
101                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
102             }
103 
104             // Delete the slot where the moved value was stored
105             set._values.pop();
106 
107             // Delete the index for the deleted slot
108             delete set._indexes[value];
109 
110             return true;
111         } else {
112             return false;
113         }
114     }
115 
116     /**
117      * @dev Returns true if the value is in the set. O(1).
118      */
119     function _contains(Set storage set, bytes32 value) private view returns (bool) {
120         return set._indexes[value] != 0;
121     }
122 
123     /**
124      * @dev Returns the number of values on the set. O(1).
125      */
126     function _length(Set storage set) private view returns (uint256) {
127         return set._values.length;
128     }
129 
130     /**
131      * @dev Returns the value stored at position `index` in the set. O(1).
132      *
133      * Note that there are no guarantees on the ordering of values inside the
134      * array, and it may change when more values are added or removed.
135      *
136      * Requirements:
137      *
138      * - `index` must be strictly less than {length}.
139      */
140     function _at(Set storage set, uint256 index) private view returns (bytes32) {
141         return set._values[index];
142     }
143 
144     /**
145      * @dev Return the entire set in an array
146      *
147      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
148      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
149      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
150      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
151      */
152     function _values(Set storage set) private view returns (bytes32[] memory) {
153         return set._values;
154     }
155 
156     // Bytes32Set
157 
158     struct Bytes32Set {
159         Set _inner;
160     }
161 
162     /**
163      * @dev Add a value to a set. O(1).
164      *
165      * Returns true if the value was added to the set, that is if it was not
166      * already present.
167      */
168     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
169         return _add(set._inner, value);
170     }
171 
172     /**
173      * @dev Removes a value from a set. O(1).
174      *
175      * Returns true if the value was removed from the set, that is if it was
176      * present.
177      */
178     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
179         return _remove(set._inner, value);
180     }
181 
182     /**
183      * @dev Returns true if the value is in the set. O(1).
184      */
185     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
186         return _contains(set._inner, value);
187     }
188 
189     /**
190      * @dev Returns the number of values in the set. O(1).
191      */
192     function length(Bytes32Set storage set) internal view returns (uint256) {
193         return _length(set._inner);
194     }
195 
196     /**
197      * @dev Returns the value stored at position `index` in the set. O(1).
198      *
199      * Note that there are no guarantees on the ordering of values inside the
200      * array, and it may change when more values are added or removed.
201      *
202      * Requirements:
203      *
204      * - `index` must be strictly less than {length}.
205      */
206     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
207         return _at(set._inner, index);
208     }
209 
210     /**
211      * @dev Return the entire set in an array
212      *
213      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
214      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
215      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
216      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
217      */
218     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
219         return _values(set._inner);
220     }
221 
222     // AddressSet
223 
224     struct AddressSet {
225         Set _inner;
226     }
227 
228     /**
229      * @dev Add a value to a set. O(1).
230      *
231      * Returns true if the value was added to the set, that is if it was not
232      * already present.
233      */
234     function add(AddressSet storage set, address value) internal returns (bool) {
235         return _add(set._inner, bytes32(uint256(uint160(value))));
236     }
237 
238     /**
239      * @dev Removes a value from a set. O(1).
240      *
241      * Returns true if the value was removed from the set, that is if it was
242      * present.
243      */
244     function remove(AddressSet storage set, address value) internal returns (bool) {
245         return _remove(set._inner, bytes32(uint256(uint160(value))));
246     }
247 
248     /**
249      * @dev Returns true if the value is in the set. O(1).
250      */
251     function contains(AddressSet storage set, address value) internal view returns (bool) {
252         return _contains(set._inner, bytes32(uint256(uint160(value))));
253     }
254 
255     /**
256      * @dev Returns the number of values in the set. O(1).
257      */
258     function length(AddressSet storage set) internal view returns (uint256) {
259         return _length(set._inner);
260     }
261 
262     /**
263      * @dev Returns the value stored at position `index` in the set. O(1).
264      *
265      * Note that there are no guarantees on the ordering of values inside the
266      * array, and it may change when more values are added or removed.
267      *
268      * Requirements:
269      *
270      * - `index` must be strictly less than {length}.
271      */
272     function at(AddressSet storage set, uint256 index) internal view returns (address) {
273         return address(uint160(uint256(_at(set._inner, index))));
274     }
275 
276     /**
277      * @dev Return the entire set in an array
278      *
279      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
280      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
281      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
282      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
283      */
284     function values(AddressSet storage set) internal view returns (address[] memory) {
285         bytes32[] memory store = _values(set._inner);
286         address[] memory result;
287 
288         /// @solidity memory-safe-assembly
289         assembly {
290             result := store
291         }
292 
293         return result;
294     }
295 
296     // UintSet
297 
298     struct UintSet {
299         Set _inner;
300     }
301 
302     /**
303      * @dev Add a value to a set. O(1).
304      *
305      * Returns true if the value was added to the set, that is if it was not
306      * already present.
307      */
308     function add(UintSet storage set, uint256 value) internal returns (bool) {
309         return _add(set._inner, bytes32(value));
310     }
311 
312     /**
313      * @dev Removes a value from a set. O(1).
314      *
315      * Returns true if the value was removed from the set, that is if it was
316      * present.
317      */
318     function remove(UintSet storage set, uint256 value) internal returns (bool) {
319         return _remove(set._inner, bytes32(value));
320     }
321 
322     /**
323      * @dev Returns true if the value is in the set. O(1).
324      */
325     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
326         return _contains(set._inner, bytes32(value));
327     }
328 
329     /**
330      * @dev Returns the number of values on the set. O(1).
331      */
332     function length(UintSet storage set) internal view returns (uint256) {
333         return _length(set._inner);
334     }
335 
336     /**
337      * @dev Returns the value stored at position `index` in the set. O(1).
338      *
339      * Note that there are no guarantees on the ordering of values inside the
340      * array, and it may change when more values are added or removed.
341      *
342      * Requirements:
343      *
344      * - `index` must be strictly less than {length}.
345      */
346     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
347         return uint256(_at(set._inner, index));
348     }
349 
350     /**
351      * @dev Return the entire set in an array
352      *
353      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
354      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
355      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
356      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
357      */
358     function values(UintSet storage set) internal view returns (uint256[] memory) {
359         bytes32[] memory store = _values(set._inner);
360         uint256[] memory result;
361 
362         /// @solidity memory-safe-assembly
363         assembly {
364             result := store
365         }
366 
367         return result;
368     }
369 }
370 
371 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Interface of the ERC165 standard, as defined in the
380  * https://eips.ethereum.org/EIPS/eip-165[EIP].
381  *
382  * Implementers can declare support of contract interfaces, which can then be
383  * queried by others ({ERC165Checker}).
384  *
385  * For an implementation, see {ERC165}.
386  */
387 interface IERC165 {
388     /**
389      * @dev Returns true if this contract implements the interface defined by
390      * `interfaceId`. See the corresponding
391      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
392      * to learn more about how these ids are created.
393      *
394      * This function call must use less than 30 000 gas.
395      */
396     function supportsInterface(bytes4 interfaceId) external view returns (bool);
397 }
398 
399 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev Implementation of the {IERC165} interface.
409  *
410  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
411  * for the additional interface id that will be supported. For example:
412  *
413  * ```solidity
414  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
415  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
416  * }
417  * ```
418  *
419  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
420  */
421 abstract contract ERC165 is IERC165 {
422     /**
423      * @dev See {IERC165-supportsInterface}.
424      */
425     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
426         return interfaceId == type(IERC165).interfaceId;
427     }
428 }
429 
430 // File: @openzeppelin/contracts/utils/Strings.sol
431 
432 
433 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev String operations.
439  */
440 library Strings {
441     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
442     uint8 private constant _ADDRESS_LENGTH = 20;
443 
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
446      */
447     function toString(uint256 value) internal pure returns (string memory) {
448         // Inspired by OraclizeAPI's implementation - MIT licence
449         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
450 
451         if (value == 0) {
452             return "0";
453         }
454         uint256 temp = value;
455         uint256 digits;
456         while (temp != 0) {
457             digits++;
458             temp /= 10;
459         }
460         bytes memory buffer = new bytes(digits);
461         while (value != 0) {
462             digits -= 1;
463             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
464             value /= 10;
465         }
466         return string(buffer);
467     }
468 
469     /**
470      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
471      */
472     function toHexString(uint256 value) internal pure returns (string memory) {
473         if (value == 0) {
474             return "0x00";
475         }
476         uint256 temp = value;
477         uint256 length = 0;
478         while (temp != 0) {
479             length++;
480             temp >>= 8;
481         }
482         return toHexString(value, length);
483     }
484 
485     /**
486      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
487      */
488     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
489         bytes memory buffer = new bytes(2 * length + 2);
490         buffer[0] = "0";
491         buffer[1] = "x";
492         for (uint256 i = 2 * length + 1; i > 1; --i) {
493             buffer[i] = _HEX_SYMBOLS[value & 0xf];
494             value >>= 4;
495         }
496         require(value == 0, "Strings: hex length insufficient");
497         return string(buffer);
498     }
499 
500     /**
501      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
502      */
503     function toHexString(address addr) internal pure returns (string memory) {
504         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
505     }
506 }
507 
508 // File: @openzeppelin/contracts/access/IAccessControl.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev External interface of AccessControl declared to support ERC165 detection.
517  */
518 interface IAccessControl {
519     /**
520      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
521      *
522      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
523      * {RoleAdminChanged} not being emitted signaling this.
524      *
525      * _Available since v3.1._
526      */
527     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
528 
529     /**
530      * @dev Emitted when `account` is granted `role`.
531      *
532      * `sender` is the account that originated the contract call, an admin role
533      * bearer except when using {AccessControl-_setupRole}.
534      */
535     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
536 
537     /**
538      * @dev Emitted when `account` is revoked `role`.
539      *
540      * `sender` is the account that originated the contract call:
541      *   - if using `revokeRole`, it is the admin role bearer
542      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
543      */
544     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
545 
546     /**
547      * @dev Returns `true` if `account` has been granted `role`.
548      */
549     function hasRole(bytes32 role, address account) external view returns (bool);
550 
551     /**
552      * @dev Returns the admin role that controls `role`. See {grantRole} and
553      * {revokeRole}.
554      *
555      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
556      */
557     function getRoleAdmin(bytes32 role) external view returns (bytes32);
558 
559     /**
560      * @dev Grants `role` to `account`.
561      *
562      * If `account` had not been already granted `role`, emits a {RoleGranted}
563      * event.
564      *
565      * Requirements:
566      *
567      * - the caller must have ``role``'s admin role.
568      */
569     function grantRole(bytes32 role, address account) external;
570 
571     /**
572      * @dev Revokes `role` from `account`.
573      *
574      * If `account` had been granted `role`, emits a {RoleRevoked} event.
575      *
576      * Requirements:
577      *
578      * - the caller must have ``role``'s admin role.
579      */
580     function revokeRole(bytes32 role, address account) external;
581 
582     /**
583      * @dev Revokes `role` from the calling account.
584      *
585      * Roles are often managed via {grantRole} and {revokeRole}: this function's
586      * purpose is to provide a mechanism for accounts to lose their privileges
587      * if they are compromised (such as when a trusted device is misplaced).
588      *
589      * If the calling account had been granted `role`, emits a {RoleRevoked}
590      * event.
591      *
592      * Requirements:
593      *
594      * - the caller must be `account`.
595      */
596     function renounceRole(bytes32 role, address account) external;
597 }
598 
599 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
609  */
610 interface IAccessControlEnumerable is IAccessControl {
611     /**
612      * @dev Returns one of the accounts that have `role`. `index` must be a
613      * value between 0 and {getRoleMemberCount}, non-inclusive.
614      *
615      * Role bearers are not sorted in any particular way, and their ordering may
616      * change at any point.
617      *
618      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
619      * you perform all queries on the same block. See the following
620      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
621      * for more information.
622      */
623     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
624 
625     /**
626      * @dev Returns the number of accounts that have `role`. Can be used
627      * together with {getRoleMember} to enumerate all bearers of a role.
628      */
629     function getRoleMemberCount(bytes32 role) external view returns (uint256);
630 }
631 
632 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
633 
634 
635 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev These functions deal with verification of Merkle Tree proofs.
641  *
642  * The proofs can be generated using the JavaScript library
643  * https://github.com/miguelmota/merkletreejs[merkletreejs].
644  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
645  *
646  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
647  *
648  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
649  * hashing, or use a hash function other than keccak256 for hashing leaves.
650  * This is because the concatenation of a sorted pair of internal nodes in
651  * the merkle tree could be reinterpreted as a leaf value.
652  */
653 library MerkleProof {
654     /**
655      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
656      * defined by `root`. For this, a `proof` must be provided, containing
657      * sibling hashes on the branch from the leaf to the root of the tree. Each
658      * pair of leaves and each pair of pre-images are assumed to be sorted.
659      */
660     function verify(
661         bytes32[] memory proof,
662         bytes32 root,
663         bytes32 leaf
664     ) internal pure returns (bool) {
665         return processProof(proof, leaf) == root;
666     }
667 
668     /**
669      * @dev Calldata version of {verify}
670      *
671      * _Available since v4.7._
672      */
673     function verifyCalldata(
674         bytes32[] calldata proof,
675         bytes32 root,
676         bytes32 leaf
677     ) internal pure returns (bool) {
678         return processProofCalldata(proof, leaf) == root;
679     }
680 
681     /**
682      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
683      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
684      * hash matches the root of the tree. When processing the proof, the pairs
685      * of leafs & pre-images are assumed to be sorted.
686      *
687      * _Available since v4.4._
688      */
689     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
690         bytes32 computedHash = leaf;
691         for (uint256 i = 0; i < proof.length; i++) {
692             computedHash = _hashPair(computedHash, proof[i]);
693         }
694         return computedHash;
695     }
696 
697     /**
698      * @dev Calldata version of {processProof}
699      *
700      * _Available since v4.7._
701      */
702     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
703         bytes32 computedHash = leaf;
704         for (uint256 i = 0; i < proof.length; i++) {
705             computedHash = _hashPair(computedHash, proof[i]);
706         }
707         return computedHash;
708     }
709 
710     /**
711      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
712      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
713      *
714      * _Available since v4.7._
715      */
716     function multiProofVerify(
717         bytes32[] memory proof,
718         bool[] memory proofFlags,
719         bytes32 root,
720         bytes32[] memory leaves
721     ) internal pure returns (bool) {
722         return processMultiProof(proof, proofFlags, leaves) == root;
723     }
724 
725     /**
726      * @dev Calldata version of {multiProofVerify}
727      *
728      * _Available since v4.7._
729      */
730     function multiProofVerifyCalldata(
731         bytes32[] calldata proof,
732         bool[] calldata proofFlags,
733         bytes32 root,
734         bytes32[] memory leaves
735     ) internal pure returns (bool) {
736         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
737     }
738 
739     /**
740      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
741      * consuming from one or the other at each step according to the instructions given by
742      * `proofFlags`.
743      *
744      * _Available since v4.7._
745      */
746     function processMultiProof(
747         bytes32[] memory proof,
748         bool[] memory proofFlags,
749         bytes32[] memory leaves
750     ) internal pure returns (bytes32 merkleRoot) {
751         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
752         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
753         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
754         // the merkle tree.
755         uint256 leavesLen = leaves.length;
756         uint256 totalHashes = proofFlags.length;
757 
758         // Check proof validity.
759         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
760 
761         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
762         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
763         bytes32[] memory hashes = new bytes32[](totalHashes);
764         uint256 leafPos = 0;
765         uint256 hashPos = 0;
766         uint256 proofPos = 0;
767         // At each step, we compute the next hash using two values:
768         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
769         //   get the next hash.
770         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
771         //   `proof` array.
772         for (uint256 i = 0; i < totalHashes; i++) {
773             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
774             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
775             hashes[i] = _hashPair(a, b);
776         }
777 
778         if (totalHashes > 0) {
779             return hashes[totalHashes - 1];
780         } else if (leavesLen > 0) {
781             return leaves[0];
782         } else {
783             return proof[0];
784         }
785     }
786 
787     /**
788      * @dev Calldata version of {processMultiProof}
789      *
790      * _Available since v4.7._
791      */
792     function processMultiProofCalldata(
793         bytes32[] calldata proof,
794         bool[] calldata proofFlags,
795         bytes32[] memory leaves
796     ) internal pure returns (bytes32 merkleRoot) {
797         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
798         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
799         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
800         // the merkle tree.
801         uint256 leavesLen = leaves.length;
802         uint256 totalHashes = proofFlags.length;
803 
804         // Check proof validity.
805         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
806 
807         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
808         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
809         bytes32[] memory hashes = new bytes32[](totalHashes);
810         uint256 leafPos = 0;
811         uint256 hashPos = 0;
812         uint256 proofPos = 0;
813         // At each step, we compute the next hash using two values:
814         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
815         //   get the next hash.
816         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
817         //   `proof` array.
818         for (uint256 i = 0; i < totalHashes; i++) {
819             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
820             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
821             hashes[i] = _hashPair(a, b);
822         }
823 
824         if (totalHashes > 0) {
825             return hashes[totalHashes - 1];
826         } else if (leavesLen > 0) {
827             return leaves[0];
828         } else {
829             return proof[0];
830         }
831     }
832 
833     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
834         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
835     }
836 
837     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
838         /// @solidity memory-safe-assembly
839         assembly {
840             mstore(0x00, a)
841             mstore(0x20, b)
842             value := keccak256(0x00, 0x40)
843         }
844     }
845 }
846 
847 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
848 
849 
850 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
851 
852 pragma solidity ^0.8.0;
853 
854 /**
855  * @dev Interface of the ERC20 standard as defined in the EIP.
856  */
857 interface IERC20 {
858     /**
859      * @dev Emitted when `value` tokens are moved from one account (`from`) to
860      * another (`to`).
861      *
862      * Note that `value` may be zero.
863      */
864     event Transfer(address indexed from, address indexed to, uint256 value);
865 
866     /**
867      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
868      * a call to {approve}. `value` is the new allowance.
869      */
870     event Approval(address indexed owner, address indexed spender, uint256 value);
871 
872     /**
873      * @dev Returns the amount of tokens in existence.
874      */
875     function totalSupply() external view returns (uint256);
876 
877     /**
878      * @dev Returns the amount of tokens owned by `account`.
879      */
880     function balanceOf(address account) external view returns (uint256);
881 
882     /**
883      * @dev Moves `amount` tokens from the caller's account to `to`.
884      *
885      * Returns a boolean value indicating whether the operation succeeded.
886      *
887      * Emits a {Transfer} event.
888      */
889     function transfer(address to, uint256 amount) external returns (bool);
890 
891     /**
892      * @dev Returns the remaining number of tokens that `spender` will be
893      * allowed to spend on behalf of `owner` through {transferFrom}. This is
894      * zero by default.
895      *
896      * This value changes when {approve} or {transferFrom} are called.
897      */
898     function allowance(address owner, address spender) external view returns (uint256);
899 
900     /**
901      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
902      *
903      * Returns a boolean value indicating whether the operation succeeded.
904      *
905      * IMPORTANT: Beware that changing an allowance with this method brings the risk
906      * that someone may use both the old and the new allowance by unfortunate
907      * transaction ordering. One possible solution to mitigate this race
908      * condition is to first reduce the spender's allowance to 0 and set the
909      * desired value afterwards:
910      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
911      *
912      * Emits an {Approval} event.
913      */
914     function approve(address spender, uint256 amount) external returns (bool);
915 
916     /**
917      * @dev Moves `amount` tokens from `from` to `to` using the
918      * allowance mechanism. `amount` is then deducted from the caller's
919      * allowance.
920      *
921      * Returns a boolean value indicating whether the operation succeeded.
922      *
923      * Emits a {Transfer} event.
924      */
925     function transferFrom(
926         address from,
927         address to,
928         uint256 amount
929     ) external returns (bool);
930 }
931 
932 // File: @openzeppelin/contracts/utils/Context.sol
933 
934 
935 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 /**
940  * @dev Provides information about the current execution context, including the
941  * sender of the transaction and its data. While these are generally available
942  * via msg.sender and msg.data, they should not be accessed in such a direct
943  * manner, since when dealing with meta-transactions the account sending and
944  * paying for execution may not be the actual sender (as far as an application
945  * is concerned).
946  *
947  * This contract is only required for intermediate, library-like contracts.
948  */
949 abstract contract Context {
950     function _msgSender() internal view virtual returns (address) {
951         return msg.sender;
952     }
953 
954     function _msgData() internal view virtual returns (bytes calldata) {
955         return msg.data;
956     }
957 }
958 
959 // File: @openzeppelin/contracts/access/AccessControl.sol
960 
961 
962 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
963 
964 pragma solidity ^0.8.0;
965 
966 
967 
968 
969 
970 /**
971  * @dev Contract module that allows children to implement role-based access
972  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
973  * members except through off-chain means by accessing the contract event logs. Some
974  * applications may benefit from on-chain enumerability, for those cases see
975  * {AccessControlEnumerable}.
976  *
977  * Roles are referred to by their `bytes32` identifier. These should be exposed
978  * in the external API and be unique. The best way to achieve this is by
979  * using `public constant` hash digests:
980  *
981  * ```
982  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
983  * ```
984  *
985  * Roles can be used to represent a set of permissions. To restrict access to a
986  * function call, use {hasRole}:
987  *
988  * ```
989  * function foo() public {
990  *     require(hasRole(MY_ROLE, msg.sender));
991  *     ...
992  * }
993  * ```
994  *
995  * Roles can be granted and revoked dynamically via the {grantRole} and
996  * {revokeRole} functions. Each role has an associated admin role, and only
997  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
998  *
999  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1000  * that only accounts with this role will be able to grant or revoke other
1001  * roles. More complex role relationships can be created by using
1002  * {_setRoleAdmin}.
1003  *
1004  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1005  * grant and revoke this role. Extra precautions should be taken to secure
1006  * accounts that have been granted it.
1007  */
1008 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1009     struct RoleData {
1010         mapping(address => bool) members;
1011         bytes32 adminRole;
1012     }
1013 
1014     mapping(bytes32 => RoleData) private _roles;
1015 
1016     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1017 
1018     /**
1019      * @dev Modifier that checks that an account has a specific role. Reverts
1020      * with a standardized message including the required role.
1021      *
1022      * The format of the revert reason is given by the following regular expression:
1023      *
1024      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1025      *
1026      * _Available since v4.1._
1027      */
1028     modifier onlyRole(bytes32 role) {
1029         _checkRole(role);
1030         _;
1031     }
1032 
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1037         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev Returns `true` if `account` has been granted `role`.
1042      */
1043     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1044         return _roles[role].members[account];
1045     }
1046 
1047     /**
1048      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1049      * Overriding this function changes the behavior of the {onlyRole} modifier.
1050      *
1051      * Format of the revert message is described in {_checkRole}.
1052      *
1053      * _Available since v4.6._
1054      */
1055     function _checkRole(bytes32 role) internal view virtual {
1056         _checkRole(role, _msgSender());
1057     }
1058 
1059     /**
1060      * @dev Revert with a standard message if `account` is missing `role`.
1061      *
1062      * The format of the revert reason is given by the following regular expression:
1063      *
1064      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1065      */
1066     function _checkRole(bytes32 role, address account) internal view virtual {
1067         if (!hasRole(role, account)) {
1068             revert(
1069                 string(
1070                     abi.encodePacked(
1071                         "AccessControl: account ",
1072                         Strings.toHexString(uint160(account), 20),
1073                         " is missing role ",
1074                         Strings.toHexString(uint256(role), 32)
1075                     )
1076                 )
1077             );
1078         }
1079     }
1080 
1081     /**
1082      * @dev Returns the admin role that controls `role`. See {grantRole} and
1083      * {revokeRole}.
1084      *
1085      * To change a role's admin, use {_setRoleAdmin}.
1086      */
1087     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1088         return _roles[role].adminRole;
1089     }
1090 
1091     /**
1092      * @dev Grants `role` to `account`.
1093      *
1094      * If `account` had not been already granted `role`, emits a {RoleGranted}
1095      * event.
1096      *
1097      * Requirements:
1098      *
1099      * - the caller must have ``role``'s admin role.
1100      *
1101      * May emit a {RoleGranted} event.
1102      */
1103     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1104         _grantRole(role, account);
1105     }
1106 
1107     /**
1108      * @dev Revokes `role` from `account`.
1109      *
1110      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1111      *
1112      * Requirements:
1113      *
1114      * - the caller must have ``role``'s admin role.
1115      *
1116      * May emit a {RoleRevoked} event.
1117      */
1118     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1119         _revokeRole(role, account);
1120     }
1121 
1122     /**
1123      * @dev Revokes `role` from the calling account.
1124      *
1125      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1126      * purpose is to provide a mechanism for accounts to lose their privileges
1127      * if they are compromised (such as when a trusted device is misplaced).
1128      *
1129      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1130      * event.
1131      *
1132      * Requirements:
1133      *
1134      * - the caller must be `account`.
1135      *
1136      * May emit a {RoleRevoked} event.
1137      */
1138     function renounceRole(bytes32 role, address account) public virtual override {
1139         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1140 
1141         _revokeRole(role, account);
1142     }
1143 
1144     /**
1145      * @dev Grants `role` to `account`.
1146      *
1147      * If `account` had not been already granted `role`, emits a {RoleGranted}
1148      * event. Note that unlike {grantRole}, this function doesn't perform any
1149      * checks on the calling account.
1150      *
1151      * May emit a {RoleGranted} event.
1152      *
1153      * [WARNING]
1154      * ====
1155      * This function should only be called from the constructor when setting
1156      * up the initial roles for the system.
1157      *
1158      * Using this function in any other way is effectively circumventing the admin
1159      * system imposed by {AccessControl}.
1160      * ====
1161      *
1162      * NOTE: This function is deprecated in favor of {_grantRole}.
1163      */
1164     function _setupRole(bytes32 role, address account) internal virtual {
1165         _grantRole(role, account);
1166     }
1167 
1168     /**
1169      * @dev Sets `adminRole` as ``role``'s admin role.
1170      *
1171      * Emits a {RoleAdminChanged} event.
1172      */
1173     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1174         bytes32 previousAdminRole = getRoleAdmin(role);
1175         _roles[role].adminRole = adminRole;
1176         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1177     }
1178 
1179     /**
1180      * @dev Grants `role` to `account`.
1181      *
1182      * Internal function without access restriction.
1183      *
1184      * May emit a {RoleGranted} event.
1185      */
1186     function _grantRole(bytes32 role, address account) internal virtual {
1187         if (!hasRole(role, account)) {
1188             _roles[role].members[account] = true;
1189             emit RoleGranted(role, account, _msgSender());
1190         }
1191     }
1192 
1193     /**
1194      * @dev Revokes `role` from `account`.
1195      *
1196      * Internal function without access restriction.
1197      *
1198      * May emit a {RoleRevoked} event.
1199      */
1200     function _revokeRole(bytes32 role, address account) internal virtual {
1201         if (hasRole(role, account)) {
1202             _roles[role].members[account] = false;
1203             emit RoleRevoked(role, account, _msgSender());
1204         }
1205     }
1206 }
1207 
1208 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1209 
1210 
1211 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 
1216 
1217 
1218 /**
1219  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1220  */
1221 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1222     using EnumerableSet for EnumerableSet.AddressSet;
1223 
1224     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1225 
1226     /**
1227      * @dev See {IERC165-supportsInterface}.
1228      */
1229     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1230         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1231     }
1232 
1233     /**
1234      * @dev Returns one of the accounts that have `role`. `index` must be a
1235      * value between 0 and {getRoleMemberCount}, non-inclusive.
1236      *
1237      * Role bearers are not sorted in any particular way, and their ordering may
1238      * change at any point.
1239      *
1240      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1241      * you perform all queries on the same block. See the following
1242      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1243      * for more information.
1244      */
1245     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1246         return _roleMembers[role].at(index);
1247     }
1248 
1249     /**
1250      * @dev Returns the number of accounts that have `role`. Can be used
1251      * together with {getRoleMember} to enumerate all bearers of a role.
1252      */
1253     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1254         return _roleMembers[role].length();
1255     }
1256 
1257     /**
1258      * @dev Overload {_grantRole} to track enumerable memberships
1259      */
1260     function _grantRole(bytes32 role, address account) internal virtual override {
1261         super._grantRole(role, account);
1262         _roleMembers[role].add(account);
1263     }
1264 
1265     /**
1266      * @dev Overload {_revokeRole} to track enumerable memberships
1267      */
1268     function _revokeRole(bytes32 role, address account) internal virtual override {
1269         super._revokeRole(role, account);
1270         _roleMembers[role].remove(account);
1271     }
1272 }
1273 
1274 // File: @openzeppelin/contracts/access/Ownable.sol
1275 
1276 
1277 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1278 
1279 pragma solidity ^0.8.0;
1280 
1281 
1282 /**
1283  * @dev Contract module which provides a basic access control mechanism, where
1284  * there is an account (an owner) that can be granted exclusive access to
1285  * specific functions.
1286  *
1287  * By default, the owner account will be the one that deploys the contract. This
1288  * can later be changed with {transferOwnership}.
1289  *
1290  * This module is used through inheritance. It will make available the modifier
1291  * `onlyOwner`, which can be applied to your functions to restrict their use to
1292  * the owner.
1293  */
1294 abstract contract Ownable is Context {
1295     address private _owner;
1296 
1297     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1298 
1299     /**
1300      * @dev Initializes the contract setting the deployer as the initial owner.
1301      */
1302     constructor() {
1303         _transferOwnership(_msgSender());
1304     }
1305 
1306     /**
1307      * @dev Throws if called by any account other than the owner.
1308      */
1309     modifier onlyOwner() {
1310         _checkOwner();
1311         _;
1312     }
1313 
1314     /**
1315      * @dev Returns the address of the current owner.
1316      */
1317     function owner() public view virtual returns (address) {
1318         return _owner;
1319     }
1320 
1321     /**
1322      * @dev Throws if the sender is not the owner.
1323      */
1324     function _checkOwner() internal view virtual {
1325         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1326     }
1327 
1328     /**
1329      * @dev Leaves the contract without owner. It will not be possible to call
1330      * `onlyOwner` functions anymore. Can only be called by the current owner.
1331      *
1332      * NOTE: Renouncing ownership will leave the contract without an owner,
1333      * thereby removing any functionality that is only available to the owner.
1334      */
1335     function renounceOwnership() public virtual onlyOwner {
1336         _transferOwnership(address(0));
1337     }
1338 
1339     /**
1340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1341      * Can only be called by the current owner.
1342      */
1343     function transferOwnership(address newOwner) public virtual onlyOwner {
1344         require(newOwner != address(0), "Ownable: new owner is the zero address");
1345         _transferOwnership(newOwner);
1346     }
1347 
1348     /**
1349      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1350      * Internal function without access restriction.
1351      */
1352     function _transferOwnership(address newOwner) internal virtual {
1353         address oldOwner = _owner;
1354         _owner = newOwner;
1355         emit OwnershipTransferred(oldOwner, newOwner);
1356     }
1357 }
1358 
1359 // File: erc721a/contracts/IERC721A.sol
1360 
1361 
1362 // ERC721A Contracts v4.2.3
1363 // Creator: Chiru Labs
1364 
1365 pragma solidity ^0.8.4;
1366 
1367 /**
1368  * @dev Interface of ERC721A.
1369  */
1370 interface IERC721A {
1371     /**
1372      * The caller must own the token or be an approved operator.
1373      */
1374     error ApprovalCallerNotOwnerNorApproved();
1375 
1376     /**
1377      * The token does not exist.
1378      */
1379     error ApprovalQueryForNonexistentToken();
1380 
1381     /**
1382      * Cannot query the balance for the zero address.
1383      */
1384     error BalanceQueryForZeroAddress();
1385 
1386     /**
1387      * Cannot mint to the zero address.
1388      */
1389     error MintToZeroAddress();
1390 
1391     /**
1392      * The quantity of tokens minted must be more than zero.
1393      */
1394     error MintZeroQuantity();
1395 
1396     /**
1397      * The token does not exist.
1398      */
1399     error OwnerQueryForNonexistentToken();
1400 
1401     /**
1402      * The caller must own the token or be an approved operator.
1403      */
1404     error TransferCallerNotOwnerNorApproved();
1405 
1406     /**
1407      * The token must be owned by `from`.
1408      */
1409     error TransferFromIncorrectOwner();
1410 
1411     /**
1412      * Cannot safely transfer to a contract that does not implement the
1413      * ERC721Receiver interface.
1414      */
1415     error TransferToNonERC721ReceiverImplementer();
1416 
1417     /**
1418      * Cannot transfer to the zero address.
1419      */
1420     error TransferToZeroAddress();
1421 
1422     /**
1423      * The token does not exist.
1424      */
1425     error URIQueryForNonexistentToken();
1426 
1427     /**
1428      * The `quantity` minted with ERC2309 exceeds the safety limit.
1429      */
1430     error MintERC2309QuantityExceedsLimit();
1431 
1432     /**
1433      * The `extraData` cannot be set on an unintialized ownership slot.
1434      */
1435     error OwnershipNotInitializedForExtraData();
1436 
1437     // =============================================================
1438     //                            STRUCTS
1439     // =============================================================
1440 
1441     struct TokenOwnership {
1442         // The address of the owner.
1443         address addr;
1444         // Stores the start time of ownership with minimal overhead for tokenomics.
1445         uint64 startTimestamp;
1446         // Whether the token has been burned.
1447         bool burned;
1448         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1449         uint24 extraData;
1450     }
1451 
1452     // =============================================================
1453     //                         TOKEN COUNTERS
1454     // =============================================================
1455 
1456     /**
1457      * @dev Returns the total number of tokens in existence.
1458      * Burned tokens will reduce the count.
1459      * To get the total number of tokens minted, please see {_totalMinted}.
1460      */
1461     function totalSupply() external view returns (uint256);
1462 
1463     // =============================================================
1464     //                            IERC165
1465     // =============================================================
1466 
1467     /**
1468      * @dev Returns true if this contract implements the interface defined by
1469      * `interfaceId`. See the corresponding
1470      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1471      * to learn more about how these ids are created.
1472      *
1473      * This function call must use less than 30000 gas.
1474      */
1475     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1476 
1477     // =============================================================
1478     //                            IERC721
1479     // =============================================================
1480 
1481     /**
1482      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1483      */
1484     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1485 
1486     /**
1487      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1488      */
1489     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1490 
1491     /**
1492      * @dev Emitted when `owner` enables or disables
1493      * (`approved`) `operator` to manage all of its assets.
1494      */
1495     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1496 
1497     /**
1498      * @dev Returns the number of tokens in `owner`'s account.
1499      */
1500     function balanceOf(address owner) external view returns (uint256 balance);
1501 
1502     /**
1503      * @dev Returns the owner of the `tokenId` token.
1504      *
1505      * Requirements:
1506      *
1507      * - `tokenId` must exist.
1508      */
1509     function ownerOf(uint256 tokenId) external view returns (address owner);
1510 
1511     /**
1512      * @dev Safely transfers `tokenId` token from `from` to `to`,
1513      * checking first that contract recipients are aware of the ERC721 protocol
1514      * to prevent tokens from being forever locked.
1515      *
1516      * Requirements:
1517      *
1518      * - `from` cannot be the zero address.
1519      * - `to` cannot be the zero address.
1520      * - `tokenId` token must exist and be owned by `from`.
1521      * - If the caller is not `from`, it must be have been allowed to move
1522      * this token by either {approve} or {setApprovalForAll}.
1523      * - If `to` refers to a smart contract, it must implement
1524      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1525      *
1526      * Emits a {Transfer} event.
1527      */
1528     function safeTransferFrom(
1529         address from,
1530         address to,
1531         uint256 tokenId,
1532         bytes calldata data
1533     ) external payable;
1534 
1535     /**
1536      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1537      */
1538     function safeTransferFrom(
1539         address from,
1540         address to,
1541         uint256 tokenId
1542     ) external payable;
1543 
1544     /**
1545      * @dev Transfers `tokenId` from `from` to `to`.
1546      *
1547      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1548      * whenever possible.
1549      *
1550      * Requirements:
1551      *
1552      * - `from` cannot be the zero address.
1553      * - `to` cannot be the zero address.
1554      * - `tokenId` token must be owned by `from`.
1555      * - If the caller is not `from`, it must be approved to move this token
1556      * by either {approve} or {setApprovalForAll}.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function transferFrom(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) external payable;
1565 
1566     /**
1567      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1568      * The approval is cleared when the token is transferred.
1569      *
1570      * Only a single account can be approved at a time, so approving the
1571      * zero address clears previous approvals.
1572      *
1573      * Requirements:
1574      *
1575      * - The caller must own the token or be an approved operator.
1576      * - `tokenId` must exist.
1577      *
1578      * Emits an {Approval} event.
1579      */
1580     function approve(address to, uint256 tokenId) external payable;
1581 
1582     /**
1583      * @dev Approve or remove `operator` as an operator for the caller.
1584      * Operators can call {transferFrom} or {safeTransferFrom}
1585      * for any token owned by the caller.
1586      *
1587      * Requirements:
1588      *
1589      * - The `operator` cannot be the caller.
1590      *
1591      * Emits an {ApprovalForAll} event.
1592      */
1593     function setApprovalForAll(address operator, bool _approved) external;
1594 
1595     /**
1596      * @dev Returns the account approved for `tokenId` token.
1597      *
1598      * Requirements:
1599      *
1600      * - `tokenId` must exist.
1601      */
1602     function getApproved(uint256 tokenId) external view returns (address operator);
1603 
1604     /**
1605      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1606      *
1607      * See {setApprovalForAll}.
1608      */
1609     function isApprovedForAll(address owner, address operator) external view returns (bool);
1610 
1611     // =============================================================
1612     //                        IERC721Metadata
1613     // =============================================================
1614 
1615     /**
1616      * @dev Returns the token collection name.
1617      */
1618     function name() external view returns (string memory);
1619 
1620     /**
1621      * @dev Returns the token collection symbol.
1622      */
1623     function symbol() external view returns (string memory);
1624 
1625     /**
1626      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1627      */
1628     function tokenURI(uint256 tokenId) external view returns (string memory);
1629 
1630     // =============================================================
1631     //                           IERC2309
1632     // =============================================================
1633 
1634     /**
1635      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1636      * (inclusive) is transferred from `from` to `to`, as defined in the
1637      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1638      *
1639      * See {_mintERC2309} for more details.
1640      */
1641     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1642 }
1643 
1644 // File: erc721a/contracts/ERC721A.sol
1645 
1646 
1647 // ERC721A Contracts v4.2.3
1648 // Creator: Chiru Labs
1649 
1650 pragma solidity ^0.8.4;
1651 
1652 
1653 /**
1654  * @dev Interface of ERC721 token receiver.
1655  */
1656 interface ERC721A__IERC721Receiver {
1657     function onERC721Received(
1658         address operator,
1659         address from,
1660         uint256 tokenId,
1661         bytes calldata data
1662     ) external returns (bytes4);
1663 }
1664 
1665 /**
1666  * @title ERC721A
1667  *
1668  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1669  * Non-Fungible Token Standard, including the Metadata extension.
1670  * Optimized for lower gas during batch mints.
1671  *
1672  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1673  * starting from `_startTokenId()`.
1674  *
1675  * Assumptions:
1676  *
1677  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1678  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1679  */
1680 contract ERC721A is IERC721A {
1681     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1682     struct TokenApprovalRef {
1683         address value;
1684     }
1685 
1686     // =============================================================
1687     //                           CONSTANTS
1688     // =============================================================
1689 
1690     // Mask of an entry in packed address data.
1691     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1692 
1693     // The bit position of `numberMinted` in packed address data.
1694     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1695 
1696     // The bit position of `numberBurned` in packed address data.
1697     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1698 
1699     // The bit position of `aux` in packed address data.
1700     uint256 private constant _BITPOS_AUX = 192;
1701 
1702     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1703     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1704 
1705     // The bit position of `startTimestamp` in packed ownership.
1706     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1707 
1708     // The bit mask of the `burned` bit in packed ownership.
1709     uint256 private constant _BITMASK_BURNED = 1 << 224;
1710 
1711     // The bit position of the `nextInitialized` bit in packed ownership.
1712     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1713 
1714     // The bit mask of the `nextInitialized` bit in packed ownership.
1715     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1716 
1717     // The bit position of `extraData` in packed ownership.
1718     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1719 
1720     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1721     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1722 
1723     // The mask of the lower 160 bits for addresses.
1724     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1725 
1726     // The maximum `quantity` that can be minted with {_mintERC2309}.
1727     // This limit is to prevent overflows on the address data entries.
1728     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1729     // is required to cause an overflow, which is unrealistic.
1730     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1731 
1732     // The `Transfer` event signature is given by:
1733     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1734     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1735         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1736 
1737     // =============================================================
1738     //                            STORAGE
1739     // =============================================================
1740 
1741     // The next token ID to be minted.
1742     uint256 private _currentIndex;
1743 
1744     // The number of tokens burned.
1745     uint256 private _burnCounter;
1746 
1747     // Token name
1748     string private _name;
1749 
1750     // Token symbol
1751     string private _symbol;
1752 
1753     // Mapping from token ID to ownership details
1754     // An empty struct value does not necessarily mean the token is unowned.
1755     // See {_packedOwnershipOf} implementation for details.
1756     //
1757     // Bits Layout:
1758     // - [0..159]   `addr`
1759     // - [160..223] `startTimestamp`
1760     // - [224]      `burned`
1761     // - [225]      `nextInitialized`
1762     // - [232..255] `extraData`
1763     mapping(uint256 => uint256) private _packedOwnerships;
1764 
1765     // Mapping owner address to address data.
1766     //
1767     // Bits Layout:
1768     // - [0..63]    `balance`
1769     // - [64..127]  `numberMinted`
1770     // - [128..191] `numberBurned`
1771     // - [192..255] `aux`
1772     mapping(address => uint256) private _packedAddressData;
1773 
1774     // Mapping from token ID to approved address.
1775     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1776 
1777     // Mapping from owner to operator approvals
1778     mapping(address => mapping(address => bool)) private _operatorApprovals;
1779 
1780     // =============================================================
1781     //                          CONSTRUCTOR
1782     // =============================================================
1783 
1784     constructor(string memory name_, string memory symbol_) {
1785         _name = name_;
1786         _symbol = symbol_;
1787         _currentIndex = _startTokenId();
1788     }
1789 
1790     // =============================================================
1791     //                   TOKEN COUNTING OPERATIONS
1792     // =============================================================
1793 
1794     /**
1795      * @dev Returns the starting token ID.
1796      * To change the starting token ID, please override this function.
1797      */
1798     function _startTokenId() internal view virtual returns (uint256) {
1799         return 0;
1800     }
1801 
1802     /**
1803      * @dev Returns the next token ID to be minted.
1804      */
1805     function _nextTokenId() internal view virtual returns (uint256) {
1806         return _currentIndex;
1807     }
1808 
1809     /**
1810      * @dev Returns the total number of tokens in existence.
1811      * Burned tokens will reduce the count.
1812      * To get the total number of tokens minted, please see {_totalMinted}.
1813      */
1814     function totalSupply() public view virtual override returns (uint256) {
1815         // Counter underflow is impossible as _burnCounter cannot be incremented
1816         // more than `_currentIndex - _startTokenId()` times.
1817         unchecked {
1818             return _currentIndex - _burnCounter - _startTokenId();
1819         }
1820     }
1821 
1822     /**
1823      * @dev Returns the total amount of tokens minted in the contract.
1824      */
1825     function _totalMinted() internal view virtual returns (uint256) {
1826         // Counter underflow is impossible as `_currentIndex` does not decrement,
1827         // and it is initialized to `_startTokenId()`.
1828         unchecked {
1829             return _currentIndex - _startTokenId();
1830         }
1831     }
1832 
1833     /**
1834      * @dev Returns the total number of tokens burned.
1835      */
1836     function _totalBurned() internal view virtual returns (uint256) {
1837         return _burnCounter;
1838     }
1839 
1840     // =============================================================
1841     //                    ADDRESS DATA OPERATIONS
1842     // =============================================================
1843 
1844     /**
1845      * @dev Returns the number of tokens in `owner`'s account.
1846      */
1847     function balanceOf(address owner) public view virtual override returns (uint256) {
1848         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1849         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1850     }
1851 
1852     /**
1853      * Returns the number of tokens minted by `owner`.
1854      */
1855     function _numberMinted(address owner) internal view returns (uint256) {
1856         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1857     }
1858 
1859     /**
1860      * Returns the number of tokens burned by or on behalf of `owner`.
1861      */
1862     function _numberBurned(address owner) internal view returns (uint256) {
1863         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1864     }
1865 
1866     /**
1867      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1868      */
1869     function _getAux(address owner) internal view returns (uint64) {
1870         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1871     }
1872 
1873     /**
1874      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1875      * If there are multiple variables, please pack them into a uint64.
1876      */
1877     function _setAux(address owner, uint64 aux) internal virtual {
1878         uint256 packed = _packedAddressData[owner];
1879         uint256 auxCasted;
1880         // Cast `aux` with assembly to avoid redundant masking.
1881         assembly {
1882             auxCasted := aux
1883         }
1884         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1885         _packedAddressData[owner] = packed;
1886     }
1887 
1888     // =============================================================
1889     //                            IERC165
1890     // =============================================================
1891 
1892     /**
1893      * @dev Returns true if this contract implements the interface defined by
1894      * `interfaceId`. See the corresponding
1895      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1896      * to learn more about how these ids are created.
1897      *
1898      * This function call must use less than 30000 gas.
1899      */
1900     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1901         // The interface IDs are constants representing the first 4 bytes
1902         // of the XOR of all function selectors in the interface.
1903         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1904         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1905         return
1906             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1907             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1908             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1909     }
1910 
1911     // =============================================================
1912     //                        IERC721Metadata
1913     // =============================================================
1914 
1915     /**
1916      * @dev Returns the token collection name.
1917      */
1918     function name() public view virtual override returns (string memory) {
1919         return _name;
1920     }
1921 
1922     /**
1923      * @dev Returns the token collection symbol.
1924      */
1925     function symbol() public view virtual override returns (string memory) {
1926         return _symbol;
1927     }
1928 
1929     /**
1930      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1931      */
1932     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1933         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1934 
1935         string memory baseURI = _baseURI();
1936         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1937     }
1938 
1939     /**
1940      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1941      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1942      * by default, it can be overridden in child contracts.
1943      */
1944     function _baseURI() internal view virtual returns (string memory) {
1945         return '';
1946     }
1947 
1948     // =============================================================
1949     //                     OWNERSHIPS OPERATIONS
1950     // =============================================================
1951 
1952     /**
1953      * @dev Returns the owner of the `tokenId` token.
1954      *
1955      * Requirements:
1956      *
1957      * - `tokenId` must exist.
1958      */
1959     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1960         return address(uint160(_packedOwnershipOf(tokenId)));
1961     }
1962 
1963     /**
1964      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1965      * It gradually moves to O(1) as tokens get transferred around over time.
1966      */
1967     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1968         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1969     }
1970 
1971     /**
1972      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1973      */
1974     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1975         return _unpackedOwnership(_packedOwnerships[index]);
1976     }
1977 
1978     /**
1979      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1980      */
1981     function _initializeOwnershipAt(uint256 index) internal virtual {
1982         if (_packedOwnerships[index] == 0) {
1983             _packedOwnerships[index] = _packedOwnershipOf(index);
1984         }
1985     }
1986 
1987     /**
1988      * Returns the packed ownership data of `tokenId`.
1989      */
1990     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1991         uint256 curr = tokenId;
1992 
1993         unchecked {
1994             if (_startTokenId() <= curr)
1995                 if (curr < _currentIndex) {
1996                     uint256 packed = _packedOwnerships[curr];
1997                     // If not burned.
1998                     if (packed & _BITMASK_BURNED == 0) {
1999                         // Invariant:
2000                         // There will always be an initialized ownership slot
2001                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2002                         // before an unintialized ownership slot
2003                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2004                         // Hence, `curr` will not underflow.
2005                         //
2006                         // We can directly compare the packed value.
2007                         // If the address is zero, packed will be zero.
2008                         while (packed == 0) {
2009                             packed = _packedOwnerships[--curr];
2010                         }
2011                         return packed;
2012                     }
2013                 }
2014         }
2015         revert OwnerQueryForNonexistentToken();
2016     }
2017 
2018     /**
2019      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2020      */
2021     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2022         ownership.addr = address(uint160(packed));
2023         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2024         ownership.burned = packed & _BITMASK_BURNED != 0;
2025         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2026     }
2027 
2028     /**
2029      * @dev Packs ownership data into a single uint256.
2030      */
2031     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2032         assembly {
2033             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2034             owner := and(owner, _BITMASK_ADDRESS)
2035             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2036             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2037         }
2038     }
2039 
2040     /**
2041      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2042      */
2043     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2044         // For branchless setting of the `nextInitialized` flag.
2045         assembly {
2046             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2047             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2048         }
2049     }
2050 
2051     // =============================================================
2052     //                      APPROVAL OPERATIONS
2053     // =============================================================
2054 
2055     /**
2056      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2057      * The approval is cleared when the token is transferred.
2058      *
2059      * Only a single account can be approved at a time, so approving the
2060      * zero address clears previous approvals.
2061      *
2062      * Requirements:
2063      *
2064      * - The caller must own the token or be an approved operator.
2065      * - `tokenId` must exist.
2066      *
2067      * Emits an {Approval} event.
2068      */
2069     function approve(address to, uint256 tokenId) public payable virtual override {
2070         address owner = ownerOf(tokenId);
2071 
2072         if (_msgSenderERC721A() != owner)
2073             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2074                 revert ApprovalCallerNotOwnerNorApproved();
2075             }
2076 
2077         _tokenApprovals[tokenId].value = to;
2078         emit Approval(owner, to, tokenId);
2079     }
2080 
2081     /**
2082      * @dev Returns the account approved for `tokenId` token.
2083      *
2084      * Requirements:
2085      *
2086      * - `tokenId` must exist.
2087      */
2088     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2089         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2090 
2091         return _tokenApprovals[tokenId].value;
2092     }
2093 
2094     /**
2095      * @dev Approve or remove `operator` as an operator for the caller.
2096      * Operators can call {transferFrom} or {safeTransferFrom}
2097      * for any token owned by the caller.
2098      *
2099      * Requirements:
2100      *
2101      * - The `operator` cannot be the caller.
2102      *
2103      * Emits an {ApprovalForAll} event.
2104      */
2105     function setApprovalForAll(address operator, bool approved) public virtual override {
2106         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2107         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2108     }
2109 
2110     /**
2111      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2112      *
2113      * See {setApprovalForAll}.
2114      */
2115     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2116         return _operatorApprovals[owner][operator];
2117     }
2118 
2119     /**
2120      * @dev Returns whether `tokenId` exists.
2121      *
2122      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2123      *
2124      * Tokens start existing when they are minted. See {_mint}.
2125      */
2126     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2127         return
2128             _startTokenId() <= tokenId &&
2129             tokenId < _currentIndex && // If within bounds,
2130             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2131     }
2132 
2133     /**
2134      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2135      */
2136     function _isSenderApprovedOrOwner(
2137         address approvedAddress,
2138         address owner,
2139         address msgSender
2140     ) private pure returns (bool result) {
2141         assembly {
2142             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2143             owner := and(owner, _BITMASK_ADDRESS)
2144             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2145             msgSender := and(msgSender, _BITMASK_ADDRESS)
2146             // `msgSender == owner || msgSender == approvedAddress`.
2147             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2148         }
2149     }
2150 
2151     /**
2152      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2153      */
2154     function _getApprovedSlotAndAddress(uint256 tokenId)
2155         private
2156         view
2157         returns (uint256 approvedAddressSlot, address approvedAddress)
2158     {
2159         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2160         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2161         assembly {
2162             approvedAddressSlot := tokenApproval.slot
2163             approvedAddress := sload(approvedAddressSlot)
2164         }
2165     }
2166 
2167     // =============================================================
2168     //                      TRANSFER OPERATIONS
2169     // =============================================================
2170 
2171     /**
2172      * @dev Transfers `tokenId` from `from` to `to`.
2173      *
2174      * Requirements:
2175      *
2176      * - `from` cannot be the zero address.
2177      * - `to` cannot be the zero address.
2178      * - `tokenId` token must be owned by `from`.
2179      * - If the caller is not `from`, it must be approved to move this token
2180      * by either {approve} or {setApprovalForAll}.
2181      *
2182      * Emits a {Transfer} event.
2183      */
2184     function transferFrom(
2185         address from,
2186         address to,
2187         uint256 tokenId
2188     ) public payable virtual override {
2189         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2190 
2191         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2192 
2193         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2194 
2195         // The nested ifs save around 20+ gas over a compound boolean condition.
2196         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2197             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2198 
2199         if (to == address(0)) revert TransferToZeroAddress();
2200 
2201         _beforeTokenTransfers(from, to, tokenId, 1);
2202 
2203         // Clear approvals from the previous owner.
2204         assembly {
2205             if approvedAddress {
2206                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2207                 sstore(approvedAddressSlot, 0)
2208             }
2209         }
2210 
2211         // Underflow of the sender's balance is impossible because we check for
2212         // ownership above and the recipient's balance can't realistically overflow.
2213         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2214         unchecked {
2215             // We can directly increment and decrement the balances.
2216             --_packedAddressData[from]; // Updates: `balance -= 1`.
2217             ++_packedAddressData[to]; // Updates: `balance += 1`.
2218 
2219             // Updates:
2220             // - `address` to the next owner.
2221             // - `startTimestamp` to the timestamp of transfering.
2222             // - `burned` to `false`.
2223             // - `nextInitialized` to `true`.
2224             _packedOwnerships[tokenId] = _packOwnershipData(
2225                 to,
2226                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2227             );
2228 
2229             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2230             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2231                 uint256 nextTokenId = tokenId + 1;
2232                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2233                 if (_packedOwnerships[nextTokenId] == 0) {
2234                     // If the next slot is within bounds.
2235                     if (nextTokenId != _currentIndex) {
2236                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2237                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2238                     }
2239                 }
2240             }
2241         }
2242 
2243         emit Transfer(from, to, tokenId);
2244         _afterTokenTransfers(from, to, tokenId, 1);
2245     }
2246 
2247     /**
2248      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2249      */
2250     function safeTransferFrom(
2251         address from,
2252         address to,
2253         uint256 tokenId
2254     ) public payable virtual override {
2255         safeTransferFrom(from, to, tokenId, '');
2256     }
2257 
2258     /**
2259      * @dev Safely transfers `tokenId` token from `from` to `to`.
2260      *
2261      * Requirements:
2262      *
2263      * - `from` cannot be the zero address.
2264      * - `to` cannot be the zero address.
2265      * - `tokenId` token must exist and be owned by `from`.
2266      * - If the caller is not `from`, it must be approved to move this token
2267      * by either {approve} or {setApprovalForAll}.
2268      * - If `to` refers to a smart contract, it must implement
2269      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2270      *
2271      * Emits a {Transfer} event.
2272      */
2273     function safeTransferFrom(
2274         address from,
2275         address to,
2276         uint256 tokenId,
2277         bytes memory _data
2278     ) public payable virtual override {
2279         transferFrom(from, to, tokenId);
2280         if (to.code.length != 0)
2281             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2282                 revert TransferToNonERC721ReceiverImplementer();
2283             }
2284     }
2285 
2286     /**
2287      * @dev Hook that is called before a set of serially-ordered token IDs
2288      * are about to be transferred. This includes minting.
2289      * And also called before burning one token.
2290      *
2291      * `startTokenId` - the first token ID to be transferred.
2292      * `quantity` - the amount to be transferred.
2293      *
2294      * Calling conditions:
2295      *
2296      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2297      * transferred to `to`.
2298      * - When `from` is zero, `tokenId` will be minted for `to`.
2299      * - When `to` is zero, `tokenId` will be burned by `from`.
2300      * - `from` and `to` are never both zero.
2301      */
2302     function _beforeTokenTransfers(
2303         address from,
2304         address to,
2305         uint256 startTokenId,
2306         uint256 quantity
2307     ) internal virtual {}
2308 
2309     /**
2310      * @dev Hook that is called after a set of serially-ordered token IDs
2311      * have been transferred. This includes minting.
2312      * And also called after one token has been burned.
2313      *
2314      * `startTokenId` - the first token ID to be transferred.
2315      * `quantity` - the amount to be transferred.
2316      *
2317      * Calling conditions:
2318      *
2319      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2320      * transferred to `to`.
2321      * - When `from` is zero, `tokenId` has been minted for `to`.
2322      * - When `to` is zero, `tokenId` has been burned by `from`.
2323      * - `from` and `to` are never both zero.
2324      */
2325     function _afterTokenTransfers(
2326         address from,
2327         address to,
2328         uint256 startTokenId,
2329         uint256 quantity
2330     ) internal virtual {}
2331 
2332     /**
2333      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2334      *
2335      * `from` - Previous owner of the given token ID.
2336      * `to` - Target address that will receive the token.
2337      * `tokenId` - Token ID to be transferred.
2338      * `_data` - Optional data to send along with the call.
2339      *
2340      * Returns whether the call correctly returned the expected magic value.
2341      */
2342     function _checkContractOnERC721Received(
2343         address from,
2344         address to,
2345         uint256 tokenId,
2346         bytes memory _data
2347     ) private returns (bool) {
2348         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2349             bytes4 retval
2350         ) {
2351             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2352         } catch (bytes memory reason) {
2353             if (reason.length == 0) {
2354                 revert TransferToNonERC721ReceiverImplementer();
2355             } else {
2356                 assembly {
2357                     revert(add(32, reason), mload(reason))
2358                 }
2359             }
2360         }
2361     }
2362 
2363     // =============================================================
2364     //                        MINT OPERATIONS
2365     // =============================================================
2366 
2367     /**
2368      * @dev Mints `quantity` tokens and transfers them to `to`.
2369      *
2370      * Requirements:
2371      *
2372      * - `to` cannot be the zero address.
2373      * - `quantity` must be greater than 0.
2374      *
2375      * Emits a {Transfer} event for each mint.
2376      */
2377     function _mint(address to, uint256 quantity) internal virtual {
2378         uint256 startTokenId = _currentIndex;
2379         if (quantity == 0) revert MintZeroQuantity();
2380 
2381         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2382 
2383         // Overflows are incredibly unrealistic.
2384         // `balance` and `numberMinted` have a maximum limit of 2**64.
2385         // `tokenId` has a maximum limit of 2**256.
2386         unchecked {
2387             // Updates:
2388             // - `balance += quantity`.
2389             // - `numberMinted += quantity`.
2390             //
2391             // We can directly add to the `balance` and `numberMinted`.
2392             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2393 
2394             // Updates:
2395             // - `address` to the owner.
2396             // - `startTimestamp` to the timestamp of minting.
2397             // - `burned` to `false`.
2398             // - `nextInitialized` to `quantity == 1`.
2399             _packedOwnerships[startTokenId] = _packOwnershipData(
2400                 to,
2401                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2402             );
2403 
2404             uint256 toMasked;
2405             uint256 end = startTokenId + quantity;
2406 
2407             // Use assembly to loop and emit the `Transfer` event for gas savings.
2408             // The duplicated `log4` removes an extra check and reduces stack juggling.
2409             // The assembly, together with the surrounding Solidity code, have been
2410             // delicately arranged to nudge the compiler into producing optimized opcodes.
2411             assembly {
2412                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2413                 toMasked := and(to, _BITMASK_ADDRESS)
2414                 // Emit the `Transfer` event.
2415                 log4(
2416                     0, // Start of data (0, since no data).
2417                     0, // End of data (0, since no data).
2418                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2419                     0, // `address(0)`.
2420                     toMasked, // `to`.
2421                     startTokenId // `tokenId`.
2422                 )
2423 
2424                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2425                 // that overflows uint256 will make the loop run out of gas.
2426                 // The compiler will optimize the `iszero` away for performance.
2427                 for {
2428                     let tokenId := add(startTokenId, 1)
2429                 } iszero(eq(tokenId, end)) {
2430                     tokenId := add(tokenId, 1)
2431                 } {
2432                     // Emit the `Transfer` event. Similar to above.
2433                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2434                 }
2435             }
2436             if (toMasked == 0) revert MintToZeroAddress();
2437 
2438             _currentIndex = end;
2439         }
2440         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2441     }
2442 
2443     /**
2444      * @dev Mints `quantity` tokens and transfers them to `to`.
2445      *
2446      * This function is intended for efficient minting only during contract creation.
2447      *
2448      * It emits only one {ConsecutiveTransfer} as defined in
2449      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2450      * instead of a sequence of {Transfer} event(s).
2451      *
2452      * Calling this function outside of contract creation WILL make your contract
2453      * non-compliant with the ERC721 standard.
2454      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2455      * {ConsecutiveTransfer} event is only permissible during contract creation.
2456      *
2457      * Requirements:
2458      *
2459      * - `to` cannot be the zero address.
2460      * - `quantity` must be greater than 0.
2461      *
2462      * Emits a {ConsecutiveTransfer} event.
2463      */
2464     function _mintERC2309(address to, uint256 quantity) internal virtual {
2465         uint256 startTokenId = _currentIndex;
2466         if (to == address(0)) revert MintToZeroAddress();
2467         if (quantity == 0) revert MintZeroQuantity();
2468         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2469 
2470         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2471 
2472         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2473         unchecked {
2474             // Updates:
2475             // - `balance += quantity`.
2476             // - `numberMinted += quantity`.
2477             //
2478             // We can directly add to the `balance` and `numberMinted`.
2479             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2480 
2481             // Updates:
2482             // - `address` to the owner.
2483             // - `startTimestamp` to the timestamp of minting.
2484             // - `burned` to `false`.
2485             // - `nextInitialized` to `quantity == 1`.
2486             _packedOwnerships[startTokenId] = _packOwnershipData(
2487                 to,
2488                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2489             );
2490 
2491             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2492 
2493             _currentIndex = startTokenId + quantity;
2494         }
2495         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2496     }
2497 
2498     /**
2499      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2500      *
2501      * Requirements:
2502      *
2503      * - If `to` refers to a smart contract, it must implement
2504      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2505      * - `quantity` must be greater than 0.
2506      *
2507      * See {_mint}.
2508      *
2509      * Emits a {Transfer} event for each mint.
2510      */
2511     function _safeMint(
2512         address to,
2513         uint256 quantity,
2514         bytes memory _data
2515     ) internal virtual {
2516         _mint(to, quantity);
2517 
2518         unchecked {
2519             if (to.code.length != 0) {
2520                 uint256 end = _currentIndex;
2521                 uint256 index = end - quantity;
2522                 do {
2523                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2524                         revert TransferToNonERC721ReceiverImplementer();
2525                     }
2526                 } while (index < end);
2527                 // Reentrancy protection.
2528                 if (_currentIndex != end) revert();
2529             }
2530         }
2531     }
2532 
2533     /**
2534      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2535      */
2536     function _safeMint(address to, uint256 quantity) internal virtual {
2537         _safeMint(to, quantity, '');
2538     }
2539 
2540     // =============================================================
2541     //                        BURN OPERATIONS
2542     // =============================================================
2543 
2544     /**
2545      * @dev Equivalent to `_burn(tokenId, false)`.
2546      */
2547     function _burn(uint256 tokenId) internal virtual {
2548         _burn(tokenId, false);
2549     }
2550 
2551     /**
2552      * @dev Destroys `tokenId`.
2553      * The approval is cleared when the token is burned.
2554      *
2555      * Requirements:
2556      *
2557      * - `tokenId` must exist.
2558      *
2559      * Emits a {Transfer} event.
2560      */
2561     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2562         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2563 
2564         address from = address(uint160(prevOwnershipPacked));
2565 
2566         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2567 
2568         if (approvalCheck) {
2569             // The nested ifs save around 20+ gas over a compound boolean condition.
2570             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2571                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2572         }
2573 
2574         _beforeTokenTransfers(from, address(0), tokenId, 1);
2575 
2576         // Clear approvals from the previous owner.
2577         assembly {
2578             if approvedAddress {
2579                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2580                 sstore(approvedAddressSlot, 0)
2581             }
2582         }
2583 
2584         // Underflow of the sender's balance is impossible because we check for
2585         // ownership above and the recipient's balance can't realistically overflow.
2586         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2587         unchecked {
2588             // Updates:
2589             // - `balance -= 1`.
2590             // - `numberBurned += 1`.
2591             //
2592             // We can directly decrement the balance, and increment the number burned.
2593             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2594             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2595 
2596             // Updates:
2597             // - `address` to the last owner.
2598             // - `startTimestamp` to the timestamp of burning.
2599             // - `burned` to `true`.
2600             // - `nextInitialized` to `true`.
2601             _packedOwnerships[tokenId] = _packOwnershipData(
2602                 from,
2603                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2604             );
2605 
2606             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2607             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2608                 uint256 nextTokenId = tokenId + 1;
2609                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2610                 if (_packedOwnerships[nextTokenId] == 0) {
2611                     // If the next slot is within bounds.
2612                     if (nextTokenId != _currentIndex) {
2613                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2614                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2615                     }
2616                 }
2617             }
2618         }
2619 
2620         emit Transfer(from, address(0), tokenId);
2621         _afterTokenTransfers(from, address(0), tokenId, 1);
2622 
2623         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2624         unchecked {
2625             _burnCounter++;
2626         }
2627     }
2628 
2629     // =============================================================
2630     //                     EXTRA DATA OPERATIONS
2631     // =============================================================
2632 
2633     /**
2634      * @dev Directly sets the extra data for the ownership data `index`.
2635      */
2636     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2637         uint256 packed = _packedOwnerships[index];
2638         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2639         uint256 extraDataCasted;
2640         // Cast `extraData` with assembly to avoid redundant masking.
2641         assembly {
2642             extraDataCasted := extraData
2643         }
2644         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2645         _packedOwnerships[index] = packed;
2646     }
2647 
2648     /**
2649      * @dev Called during each token transfer to set the 24bit `extraData` field.
2650      * Intended to be overridden by the cosumer contract.
2651      *
2652      * `previousExtraData` - the value of `extraData` before transfer.
2653      *
2654      * Calling conditions:
2655      *
2656      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2657      * transferred to `to`.
2658      * - When `from` is zero, `tokenId` will be minted for `to`.
2659      * - When `to` is zero, `tokenId` will be burned by `from`.
2660      * - `from` and `to` are never both zero.
2661      */
2662     function _extraData(
2663         address from,
2664         address to,
2665         uint24 previousExtraData
2666     ) internal view virtual returns (uint24) {}
2667 
2668     /**
2669      * @dev Returns the next extra data for the packed ownership data.
2670      * The returned result is shifted into position.
2671      */
2672     function _nextExtraData(
2673         address from,
2674         address to,
2675         uint256 prevOwnershipPacked
2676     ) private view returns (uint256) {
2677         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2678         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2679     }
2680 
2681     // =============================================================
2682     //                       OTHER OPERATIONS
2683     // =============================================================
2684 
2685     /**
2686      * @dev Returns the message sender (defaults to `msg.sender`).
2687      *
2688      * If you are writing GSN compatible contracts, you need to override this function.
2689      */
2690     function _msgSenderERC721A() internal view virtual returns (address) {
2691         return msg.sender;
2692     }
2693 
2694     /**
2695      * @dev Converts a uint256 to its ASCII string decimal representation.
2696      */
2697     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2698         assembly {
2699             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2700             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2701             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2702             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2703             let m := add(mload(0x40), 0xa0)
2704             // Update the free memory pointer to allocate.
2705             mstore(0x40, m)
2706             // Assign the `str` to the end.
2707             str := sub(m, 0x20)
2708             // Zeroize the slot after the string.
2709             mstore(str, 0)
2710 
2711             // Cache the end of the memory to calculate the length later.
2712             let end := str
2713 
2714             // We write the string from rightmost digit to leftmost digit.
2715             // The following is essentially a do-while loop that also handles the zero case.
2716             // prettier-ignore
2717             for { let temp := value } 1 {} {
2718                 str := sub(str, 1)
2719                 // Write the character to the pointer.
2720                 // The ASCII index of the '0' character is 48.
2721                 mstore8(str, add(48, mod(temp, 10)))
2722                 // Keep dividing `temp` until zero.
2723                 temp := div(temp, 10)
2724                 // prettier-ignore
2725                 if iszero(temp) { break }
2726             }
2727 
2728             let length := sub(end, str)
2729             // Move the pointer 32 bytes leftwards to make room for the length.
2730             str := sub(str, 0x20)
2731             // Store the length.
2732             mstore(str, length)
2733         }
2734     }
2735 }
2736 
2737 // File: contracts/SkullIsland.sol
2738 
2739 
2740 pragma solidity ^0.8.4;
2741 
2742 
2743 
2744 
2745 
2746 
2747 // @author <https://welabs.io>   
2748 
2749 // ░██╗░░░░░░░██╗███████╗██╗░░░░░░█████╗░██████╗░░██████╗░░░██╗░█████╗░
2750 // ░██║░░██╗░░██║██╔════╝██║░░░░░██╔══██╗██╔══██╗██╔════╝░░░██║██╔══██╗
2751 // ░╚██╗████╗██╔╝█████╗░░██║░░░░░███████║██████╦╝╚█████╗░░░░██║██║░░██║
2752 // ░░████╔═████║░██╔══╝░░██║░░░░░██╔══██║██╔══██╗░╚═══██╗░░░██║██║░░██║
2753 // ░░╚██╔╝░╚██╔╝░███████╗███████╗██║░░██║██████╦╝██████╔╝██╗██║╚█████╔╝
2754 // ░░░╚═╝░░░╚═╝░░╚══════╝╚══════╝╚═╝░░╚═╝╚═════╝░╚═════╝░╚═╝╚═╝░╚════╝░
2755 
2756 
2757 contract SkullIsland is ERC721A, Ownable, AccessControlEnumerable {
2758 
2759   uint256 public maxTotalSupply = 3165;
2760   uint256 public holderMintPrice = 1200 * 10 ** 18;
2761   uint256 public publicMintPrice = 0.007 ether;
2762   uint8 private maxTokenPrivate = 1;
2763   uint8 private maxTokenPublic = 5;
2764 
2765   enum SaleState{ CLOSED, PRIVATE, PUBLIC }
2766   SaleState public saleState = SaleState.CLOSED;
2767 
2768   bytes32 private merkleRoot;
2769 
2770   address public tokenContract;
2771 
2772   mapping(address => uint256) public maxMintPerAddress;
2773   mapping(address => uint256) public mintedPerAddress;
2774   mapping(address => uint256) privateMinted;
2775   mapping(address => uint256) publicMinted;
2776 
2777   string _baseTokenURI;
2778 
2779   constructor(address _tokenContract) ERC721A("SkullIsland", "SKULL") {
2780     tokenContract = _tokenContract;
2781     _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2782   }
2783 
2784   function holderMint(uint256 amount) external {
2785     require (saleState == SaleState.PRIVATE, "Sale state should be private");
2786     require(totalSupply() + amount <= maxTotalSupply, "Max supply reached");
2787     require(maxMintPerAddress[msg.sender] > 0, "You are not a holder");
2788     require(amount + mintedPerAddress[msg.sender] <= maxMintPerAddress[msg.sender], "sender address cannot mint more than maxMintPerAddress lands");
2789     IERC20(tokenContract).transferFrom(msg.sender, address(this), holderMintPrice * amount);
2790     mintedPerAddress[msg.sender] += amount;
2791     _safeMint(_msgSender(), amount);
2792   }
2793 
2794   function privateMint(uint256 amount, bytes32[] calldata proof) public payable {
2795     require (saleState == SaleState.PRIVATE, "Sale state should be private");
2796     require(totalSupply() + amount <= maxTotalSupply, "Max supply reached");
2797     require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are not in the valid whitelist");
2798     require(amount + publicMinted[msg.sender] <= maxTokenPrivate, "sender address cannot mint more than maxMintPerAddress lands");
2799     require(amount * publicMintPrice <= msg.value, "Provided not enough Ether for purchase");
2800     privateMinted[msg.sender] += amount;
2801     _safeMint(_msgSender(), amount);
2802   }
2803 
2804   function publicsale(uint256 amount) public payable {
2805     require (saleState == SaleState.PUBLIC, "Sale state should be public");
2806     require(totalSupply() + amount <= maxTotalSupply, "Max supply reached");
2807     require(amount + publicMinted[msg.sender] <= maxTokenPublic, "Your token amount reached out max");
2808     require(amount * publicMintPrice <= msg.value, "Provided not enough Ether for purchase");
2809     publicMinted[msg.sender] += amount;
2810     _safeMint(_msgSender(), amount);
2811   }
2812 
2813   function withdraw() public onlyOwner {
2814     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot withdraw");
2815 
2816     uint256 balance = address(this).balance;
2817     if(balance > 0){
2818       payable(owner()).transfer(address(this).balance);
2819     }
2820     balance = IERC20(tokenContract).balanceOf(address(this));
2821     if(balance > 0){
2822       IERC20(tokenContract).transfer(owner(), balance);
2823     }
2824   }
2825 
2826   function setSaleState(SaleState newState) public {
2827     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot alter sale state");
2828     saleState = newState;
2829   }
2830 
2831   function setMerkleRoot(bytes32 _merkleRoot) public {
2832     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set merkle root");
2833     merkleRoot = _merkleRoot;
2834   }
2835 
2836   function setMaxMintPerAddress(address[] calldata _addresses, uint256[] calldata _mints) public onlyOwner{
2837     for(uint256 i = 0; i < _addresses.length; i++) {
2838         maxMintPerAddress[_addresses[i]] = _mints[i];
2839     }
2840   }
2841 
2842   function _baseURI() internal view virtual override returns (string memory) {
2843     return _baseTokenURI;
2844   }
2845 
2846   function setBaseURI(string memory baseURI) public onlyOwner {
2847     _baseTokenURI = baseURI;
2848   }
2849   
2850   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, AccessControlEnumerable) returns (bool) {
2851     return super.supportsInterface(interfaceId);
2852   }
2853 }