1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Interface of the ERC165 standard, as defined in the
225  * https://eips.ethereum.org/EIPS/eip-165[EIP].
226  *
227  * Implementers can declare support of contract interfaces, which can then be
228  * queried by others ({ERC165Checker}).
229  *
230  * For an implementation, see {ERC165}.
231  */
232 interface IERC165 {
233     /**
234      * @dev Returns true if this contract implements the interface defined by
235      * `interfaceId`. See the corresponding
236      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
237      * to learn more about how these ids are created.
238      *
239      * This function call must use less than 30 000 gas.
240      */
241     function supportsInterface(bytes4 interfaceId) external view returns (bool);
242 }
243 
244 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
245 
246 
247 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 
252 /**
253  * @dev Interface for the NFT Royalty Standard.
254  *
255  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
256  * support for royalty payments across all NFT marketplaces and ecosystem participants.
257  *
258  * _Available since v4.5._
259  */
260 interface IERC2981 is IERC165 {
261     /**
262      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
263      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
264      */
265     function royaltyInfo(uint256 tokenId, uint256 salePrice)
266         external
267         view
268         returns (address receiver, uint256 royaltyAmount);
269 }
270 
271 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
272 
273 
274 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 
279 /**
280  * @dev Implementation of the {IERC165} interface.
281  *
282  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
283  * for the additional interface id that will be supported. For example:
284  *
285  * ```solidity
286  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
287  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
288  * }
289  * ```
290  *
291  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
292  */
293 abstract contract ERC165 is IERC165 {
294     /**
295      * @dev See {IERC165-supportsInterface}.
296      */
297     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
298         return interfaceId == type(IERC165).interfaceId;
299     }
300 }
301 
302 // File: @openzeppelin/contracts/token/common/ERC2981.sol
303 
304 
305 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 
310 
311 /**
312  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
313  *
314  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
315  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
316  *
317  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
318  * fee is specified in basis points by default.
319  *
320  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
321  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
322  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
323  *
324  * _Available since v4.5._
325  */
326 abstract contract ERC2981 is IERC2981, ERC165 {
327     struct RoyaltyInfo {
328         address receiver;
329         uint96 royaltyFraction;
330     }
331 
332     RoyaltyInfo private _defaultRoyaltyInfo;
333     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
334 
335     /**
336      * @dev See {IERC165-supportsInterface}.
337      */
338     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
339         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
340     }
341 
342     /**
343      * @inheritdoc IERC2981
344      */
345     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
346         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
347 
348         if (royalty.receiver == address(0)) {
349             royalty = _defaultRoyaltyInfo;
350         }
351 
352         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
353 
354         return (royalty.receiver, royaltyAmount);
355     }
356 
357     /**
358      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
359      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
360      * override.
361      */
362     function _feeDenominator() internal pure virtual returns (uint96) {
363         return 10000;
364     }
365 
366     /**
367      * @dev Sets the royalty information that all ids in this contract will default to.
368      *
369      * Requirements:
370      *
371      * - `receiver` cannot be the zero address.
372      * - `feeNumerator` cannot be greater than the fee denominator.
373      */
374     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
375         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
376         require(receiver != address(0), "ERC2981: invalid receiver");
377 
378         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
379     }
380 
381     /**
382      * @dev Removes default royalty information.
383      */
384     function _deleteDefaultRoyalty() internal virtual {
385         delete _defaultRoyaltyInfo;
386     }
387 
388     /**
389      * @dev Sets the royalty information for a specific token id, overriding the global default.
390      *
391      * Requirements:
392      *
393      * - `receiver` cannot be the zero address.
394      * - `feeNumerator` cannot be greater than the fee denominator.
395      */
396     function _setTokenRoyalty(
397         uint256 tokenId,
398         address receiver,
399         uint96 feeNumerator
400     ) internal virtual {
401         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
402         require(receiver != address(0), "ERC2981: Invalid parameters");
403 
404         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
405     }
406 
407     /**
408      * @dev Resets royalty information for the token id back to the global default.
409      */
410     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
411         delete _tokenRoyaltyInfo[tokenId];
412     }
413 }
414 
415 // File: @openzeppelin/contracts/utils/Strings.sol
416 
417 
418 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev String operations.
424  */
425 library Strings {
426     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
427     uint8 private constant _ADDRESS_LENGTH = 20;
428 
429     /**
430      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
431      */
432     function toString(uint256 value) internal pure returns (string memory) {
433         // Inspired by OraclizeAPI's implementation - MIT licence
434         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
435 
436         if (value == 0) {
437             return "0";
438         }
439         uint256 temp = value;
440         uint256 digits;
441         while (temp != 0) {
442             digits++;
443             temp /= 10;
444         }
445         bytes memory buffer = new bytes(digits);
446         while (value != 0) {
447             digits -= 1;
448             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
449             value /= 10;
450         }
451         return string(buffer);
452     }
453 
454     /**
455      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
456      */
457     function toHexString(uint256 value) internal pure returns (string memory) {
458         if (value == 0) {
459             return "0x00";
460         }
461         uint256 temp = value;
462         uint256 length = 0;
463         while (temp != 0) {
464             length++;
465             temp >>= 8;
466         }
467         return toHexString(value, length);
468     }
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
472      */
473     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
474         bytes memory buffer = new bytes(2 * length + 2);
475         buffer[0] = "0";
476         buffer[1] = "x";
477         for (uint256 i = 2 * length + 1; i > 1; --i) {
478             buffer[i] = _HEX_SYMBOLS[value & 0xf];
479             value >>= 4;
480         }
481         require(value == 0, "Strings: hex length insufficient");
482         return string(buffer);
483     }
484 
485     /**
486      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
487      */
488     function toHexString(address addr) internal pure returns (string memory) {
489         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
490     }
491 }
492 
493 // File: @openzeppelin/contracts/access/IAccessControl.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev External interface of AccessControl declared to support ERC165 detection.
502  */
503 interface IAccessControl {
504     /**
505      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
506      *
507      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
508      * {RoleAdminChanged} not being emitted signaling this.
509      *
510      * _Available since v3.1._
511      */
512     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
513 
514     /**
515      * @dev Emitted when `account` is granted `role`.
516      *
517      * `sender` is the account that originated the contract call, an admin role
518      * bearer except when using {AccessControl-_setupRole}.
519      */
520     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
521 
522     /**
523      * @dev Emitted when `account` is revoked `role`.
524      *
525      * `sender` is the account that originated the contract call:
526      *   - if using `revokeRole`, it is the admin role bearer
527      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
528      */
529     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
530 
531     /**
532      * @dev Returns `true` if `account` has been granted `role`.
533      */
534     function hasRole(bytes32 role, address account) external view returns (bool);
535 
536     /**
537      * @dev Returns the admin role that controls `role`. See {grantRole} and
538      * {revokeRole}.
539      *
540      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
541      */
542     function getRoleAdmin(bytes32 role) external view returns (bytes32);
543 
544     /**
545      * @dev Grants `role` to `account`.
546      *
547      * If `account` had not been already granted `role`, emits a {RoleGranted}
548      * event.
549      *
550      * Requirements:
551      *
552      * - the caller must have ``role``'s admin role.
553      */
554     function grantRole(bytes32 role, address account) external;
555 
556     /**
557      * @dev Revokes `role` from `account`.
558      *
559      * If `account` had been granted `role`, emits a {RoleRevoked} event.
560      *
561      * Requirements:
562      *
563      * - the caller must have ``role``'s admin role.
564      */
565     function revokeRole(bytes32 role, address account) external;
566 
567     /**
568      * @dev Revokes `role` from the calling account.
569      *
570      * Roles are often managed via {grantRole} and {revokeRole}: this function's
571      * purpose is to provide a mechanism for accounts to lose their privileges
572      * if they are compromised (such as when a trusted device is misplaced).
573      *
574      * If the calling account had been granted `role`, emits a {RoleRevoked}
575      * event.
576      *
577      * Requirements:
578      *
579      * - the caller must be `account`.
580      */
581     function renounceRole(bytes32 role, address account) external;
582 }
583 
584 // File: contract-allow-list/contracts/proxy/interface/IContractAllowListProxy.sol
585 
586 
587 pragma solidity >=0.7.0 <0.9.0;
588 
589 interface IContractAllowListProxy {
590     function isAllowed(address _transferer, uint256 _level)
591         external
592         view
593         returns (bool);
594 }
595 
596 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
597 
598 
599 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev Library for managing
605  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
606  * types.
607  *
608  * Sets have the following properties:
609  *
610  * - Elements are added, removed, and checked for existence in constant time
611  * (O(1)).
612  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
613  *
614  * ```
615  * contract Example {
616  *     // Add the library methods
617  *     using EnumerableSet for EnumerableSet.AddressSet;
618  *
619  *     // Declare a set state variable
620  *     EnumerableSet.AddressSet private mySet;
621  * }
622  * ```
623  *
624  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
625  * and `uint256` (`UintSet`) are supported.
626  *
627  * [WARNING]
628  * ====
629  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
630  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
631  *
632  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
633  * ====
634  */
635 library EnumerableSet {
636     // To implement this library for multiple types with as little code
637     // repetition as possible, we write it in terms of a generic Set type with
638     // bytes32 values.
639     // The Set implementation uses private functions, and user-facing
640     // implementations (such as AddressSet) are just wrappers around the
641     // underlying Set.
642     // This means that we can only create new EnumerableSets for types that fit
643     // in bytes32.
644 
645     struct Set {
646         // Storage of set values
647         bytes32[] _values;
648         // Position of the value in the `values` array, plus 1 because index 0
649         // means a value is not in the set.
650         mapping(bytes32 => uint256) _indexes;
651     }
652 
653     /**
654      * @dev Add a value to a set. O(1).
655      *
656      * Returns true if the value was added to the set, that is if it was not
657      * already present.
658      */
659     function _add(Set storage set, bytes32 value) private returns (bool) {
660         if (!_contains(set, value)) {
661             set._values.push(value);
662             // The value is stored at length-1, but we add 1 to all indexes
663             // and use 0 as a sentinel value
664             set._indexes[value] = set._values.length;
665             return true;
666         } else {
667             return false;
668         }
669     }
670 
671     /**
672      * @dev Removes a value from a set. O(1).
673      *
674      * Returns true if the value was removed from the set, that is if it was
675      * present.
676      */
677     function _remove(Set storage set, bytes32 value) private returns (bool) {
678         // We read and store the value's index to prevent multiple reads from the same storage slot
679         uint256 valueIndex = set._indexes[value];
680 
681         if (valueIndex != 0) {
682             // Equivalent to contains(set, value)
683             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
684             // the array, and then remove the last element (sometimes called as 'swap and pop').
685             // This modifies the order of the array, as noted in {at}.
686 
687             uint256 toDeleteIndex = valueIndex - 1;
688             uint256 lastIndex = set._values.length - 1;
689 
690             if (lastIndex != toDeleteIndex) {
691                 bytes32 lastValue = set._values[lastIndex];
692 
693                 // Move the last value to the index where the value to delete is
694                 set._values[toDeleteIndex] = lastValue;
695                 // Update the index for the moved value
696                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
697             }
698 
699             // Delete the slot where the moved value was stored
700             set._values.pop();
701 
702             // Delete the index for the deleted slot
703             delete set._indexes[value];
704 
705             return true;
706         } else {
707             return false;
708         }
709     }
710 
711     /**
712      * @dev Returns true if the value is in the set. O(1).
713      */
714     function _contains(Set storage set, bytes32 value) private view returns (bool) {
715         return set._indexes[value] != 0;
716     }
717 
718     /**
719      * @dev Returns the number of values on the set. O(1).
720      */
721     function _length(Set storage set) private view returns (uint256) {
722         return set._values.length;
723     }
724 
725     /**
726      * @dev Returns the value stored at position `index` in the set. O(1).
727      *
728      * Note that there are no guarantees on the ordering of values inside the
729      * array, and it may change when more values are added or removed.
730      *
731      * Requirements:
732      *
733      * - `index` must be strictly less than {length}.
734      */
735     function _at(Set storage set, uint256 index) private view returns (bytes32) {
736         return set._values[index];
737     }
738 
739     /**
740      * @dev Return the entire set in an array
741      *
742      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
743      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
744      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
745      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
746      */
747     function _values(Set storage set) private view returns (bytes32[] memory) {
748         return set._values;
749     }
750 
751     // Bytes32Set
752 
753     struct Bytes32Set {
754         Set _inner;
755     }
756 
757     /**
758      * @dev Add a value to a set. O(1).
759      *
760      * Returns true if the value was added to the set, that is if it was not
761      * already present.
762      */
763     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
764         return _add(set._inner, value);
765     }
766 
767     /**
768      * @dev Removes a value from a set. O(1).
769      *
770      * Returns true if the value was removed from the set, that is if it was
771      * present.
772      */
773     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
774         return _remove(set._inner, value);
775     }
776 
777     /**
778      * @dev Returns true if the value is in the set. O(1).
779      */
780     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
781         return _contains(set._inner, value);
782     }
783 
784     /**
785      * @dev Returns the number of values in the set. O(1).
786      */
787     function length(Bytes32Set storage set) internal view returns (uint256) {
788         return _length(set._inner);
789     }
790 
791     /**
792      * @dev Returns the value stored at position `index` in the set. O(1).
793      *
794      * Note that there are no guarantees on the ordering of values inside the
795      * array, and it may change when more values are added or removed.
796      *
797      * Requirements:
798      *
799      * - `index` must be strictly less than {length}.
800      */
801     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
802         return _at(set._inner, index);
803     }
804 
805     /**
806      * @dev Return the entire set in an array
807      *
808      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
809      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
810      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
811      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
812      */
813     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
814         return _values(set._inner);
815     }
816 
817     // AddressSet
818 
819     struct AddressSet {
820         Set _inner;
821     }
822 
823     /**
824      * @dev Add a value to a set. O(1).
825      *
826      * Returns true if the value was added to the set, that is if it was not
827      * already present.
828      */
829     function add(AddressSet storage set, address value) internal returns (bool) {
830         return _add(set._inner, bytes32(uint256(uint160(value))));
831     }
832 
833     /**
834      * @dev Removes a value from a set. O(1).
835      *
836      * Returns true if the value was removed from the set, that is if it was
837      * present.
838      */
839     function remove(AddressSet storage set, address value) internal returns (bool) {
840         return _remove(set._inner, bytes32(uint256(uint160(value))));
841     }
842 
843     /**
844      * @dev Returns true if the value is in the set. O(1).
845      */
846     function contains(AddressSet storage set, address value) internal view returns (bool) {
847         return _contains(set._inner, bytes32(uint256(uint160(value))));
848     }
849 
850     /**
851      * @dev Returns the number of values in the set. O(1).
852      */
853     function length(AddressSet storage set) internal view returns (uint256) {
854         return _length(set._inner);
855     }
856 
857     /**
858      * @dev Returns the value stored at position `index` in the set. O(1).
859      *
860      * Note that there are no guarantees on the ordering of values inside the
861      * array, and it may change when more values are added or removed.
862      *
863      * Requirements:
864      *
865      * - `index` must be strictly less than {length}.
866      */
867     function at(AddressSet storage set, uint256 index) internal view returns (address) {
868         return address(uint160(uint256(_at(set._inner, index))));
869     }
870 
871     /**
872      * @dev Return the entire set in an array
873      *
874      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
875      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
876      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
877      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
878      */
879     function values(AddressSet storage set) internal view returns (address[] memory) {
880         bytes32[] memory store = _values(set._inner);
881         address[] memory result;
882 
883         /// @solidity memory-safe-assembly
884         assembly {
885             result := store
886         }
887 
888         return result;
889     }
890 
891     // UintSet
892 
893     struct UintSet {
894         Set _inner;
895     }
896 
897     /**
898      * @dev Add a value to a set. O(1).
899      *
900      * Returns true if the value was added to the set, that is if it was not
901      * already present.
902      */
903     function add(UintSet storage set, uint256 value) internal returns (bool) {
904         return _add(set._inner, bytes32(value));
905     }
906 
907     /**
908      * @dev Removes a value from a set. O(1).
909      *
910      * Returns true if the value was removed from the set, that is if it was
911      * present.
912      */
913     function remove(UintSet storage set, uint256 value) internal returns (bool) {
914         return _remove(set._inner, bytes32(value));
915     }
916 
917     /**
918      * @dev Returns true if the value is in the set. O(1).
919      */
920     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
921         return _contains(set._inner, bytes32(value));
922     }
923 
924     /**
925      * @dev Returns the number of values on the set. O(1).
926      */
927     function length(UintSet storage set) internal view returns (uint256) {
928         return _length(set._inner);
929     }
930 
931     /**
932      * @dev Returns the value stored at position `index` in the set. O(1).
933      *
934      * Note that there are no guarantees on the ordering of values inside the
935      * array, and it may change when more values are added or removed.
936      *
937      * Requirements:
938      *
939      * - `index` must be strictly less than {length}.
940      */
941     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
942         return uint256(_at(set._inner, index));
943     }
944 
945     /**
946      * @dev Return the entire set in an array
947      *
948      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
949      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
950      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
951      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
952      */
953     function values(UintSet storage set) internal view returns (uint256[] memory) {
954         bytes32[] memory store = _values(set._inner);
955         uint256[] memory result;
956 
957         /// @solidity memory-safe-assembly
958         assembly {
959             result := store
960         }
961 
962         return result;
963     }
964 }
965 
966 // File: @openzeppelin/contracts/utils/Context.sol
967 
968 
969 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
970 
971 pragma solidity ^0.8.0;
972 
973 /**
974  * @dev Provides information about the current execution context, including the
975  * sender of the transaction and its data. While these are generally available
976  * via msg.sender and msg.data, they should not be accessed in such a direct
977  * manner, since when dealing with meta-transactions the account sending and
978  * paying for execution may not be the actual sender (as far as an application
979  * is concerned).
980  *
981  * This contract is only required for intermediate, library-like contracts.
982  */
983 abstract contract Context {
984     function _msgSender() internal view virtual returns (address) {
985         return msg.sender;
986     }
987 
988     function _msgData() internal view virtual returns (bytes calldata) {
989         return msg.data;
990     }
991 }
992 
993 // File: @openzeppelin/contracts/access/AccessControl.sol
994 
995 
996 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
997 
998 pragma solidity ^0.8.0;
999 
1000 
1001 
1002 
1003 
1004 /**
1005  * @dev Contract module that allows children to implement role-based access
1006  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1007  * members except through off-chain means by accessing the contract event logs. Some
1008  * applications may benefit from on-chain enumerability, for those cases see
1009  * {AccessControlEnumerable}.
1010  *
1011  * Roles are referred to by their `bytes32` identifier. These should be exposed
1012  * in the external API and be unique. The best way to achieve this is by
1013  * using `public constant` hash digests:
1014  *
1015  * ```
1016  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1017  * ```
1018  *
1019  * Roles can be used to represent a set of permissions. To restrict access to a
1020  * function call, use {hasRole}:
1021  *
1022  * ```
1023  * function foo() public {
1024  *     require(hasRole(MY_ROLE, msg.sender));
1025  *     ...
1026  * }
1027  * ```
1028  *
1029  * Roles can be granted and revoked dynamically via the {grantRole} and
1030  * {revokeRole} functions. Each role has an associated admin role, and only
1031  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1032  *
1033  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1034  * that only accounts with this role will be able to grant or revoke other
1035  * roles. More complex role relationships can be created by using
1036  * {_setRoleAdmin}.
1037  *
1038  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1039  * grant and revoke this role. Extra precautions should be taken to secure
1040  * accounts that have been granted it.
1041  */
1042 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1043     struct RoleData {
1044         mapping(address => bool) members;
1045         bytes32 adminRole;
1046     }
1047 
1048     mapping(bytes32 => RoleData) private _roles;
1049 
1050     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1051 
1052     /**
1053      * @dev Modifier that checks that an account has a specific role. Reverts
1054      * with a standardized message including the required role.
1055      *
1056      * The format of the revert reason is given by the following regular expression:
1057      *
1058      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1059      *
1060      * _Available since v4.1._
1061      */
1062     modifier onlyRole(bytes32 role) {
1063         _checkRole(role);
1064         _;
1065     }
1066 
1067     /**
1068      * @dev See {IERC165-supportsInterface}.
1069      */
1070     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1071         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1072     }
1073 
1074     /**
1075      * @dev Returns `true` if `account` has been granted `role`.
1076      */
1077     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1078         return _roles[role].members[account];
1079     }
1080 
1081     /**
1082      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1083      * Overriding this function changes the behavior of the {onlyRole} modifier.
1084      *
1085      * Format of the revert message is described in {_checkRole}.
1086      *
1087      * _Available since v4.6._
1088      */
1089     function _checkRole(bytes32 role) internal view virtual {
1090         _checkRole(role, _msgSender());
1091     }
1092 
1093     /**
1094      * @dev Revert with a standard message if `account` is missing `role`.
1095      *
1096      * The format of the revert reason is given by the following regular expression:
1097      *
1098      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1099      */
1100     function _checkRole(bytes32 role, address account) internal view virtual {
1101         if (!hasRole(role, account)) {
1102             revert(
1103                 string(
1104                     abi.encodePacked(
1105                         "AccessControl: account ",
1106                         Strings.toHexString(uint160(account), 20),
1107                         " is missing role ",
1108                         Strings.toHexString(uint256(role), 32)
1109                     )
1110                 )
1111             );
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns the admin role that controls `role`. See {grantRole} and
1117      * {revokeRole}.
1118      *
1119      * To change a role's admin, use {_setRoleAdmin}.
1120      */
1121     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1122         return _roles[role].adminRole;
1123     }
1124 
1125     /**
1126      * @dev Grants `role` to `account`.
1127      *
1128      * If `account` had not been already granted `role`, emits a {RoleGranted}
1129      * event.
1130      *
1131      * Requirements:
1132      *
1133      * - the caller must have ``role``'s admin role.
1134      *
1135      * May emit a {RoleGranted} event.
1136      */
1137     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1138         _grantRole(role, account);
1139     }
1140 
1141     /**
1142      * @dev Revokes `role` from `account`.
1143      *
1144      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1145      *
1146      * Requirements:
1147      *
1148      * - the caller must have ``role``'s admin role.
1149      *
1150      * May emit a {RoleRevoked} event.
1151      */
1152     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1153         _revokeRole(role, account);
1154     }
1155 
1156     /**
1157      * @dev Revokes `role` from the calling account.
1158      *
1159      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1160      * purpose is to provide a mechanism for accounts to lose their privileges
1161      * if they are compromised (such as when a trusted device is misplaced).
1162      *
1163      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1164      * event.
1165      *
1166      * Requirements:
1167      *
1168      * - the caller must be `account`.
1169      *
1170      * May emit a {RoleRevoked} event.
1171      */
1172     function renounceRole(bytes32 role, address account) public virtual override {
1173         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1174 
1175         _revokeRole(role, account);
1176     }
1177 
1178     /**
1179      * @dev Grants `role` to `account`.
1180      *
1181      * If `account` had not been already granted `role`, emits a {RoleGranted}
1182      * event. Note that unlike {grantRole}, this function doesn't perform any
1183      * checks on the calling account.
1184      *
1185      * May emit a {RoleGranted} event.
1186      *
1187      * [WARNING]
1188      * ====
1189      * This function should only be called from the constructor when setting
1190      * up the initial roles for the system.
1191      *
1192      * Using this function in any other way is effectively circumventing the admin
1193      * system imposed by {AccessControl}.
1194      * ====
1195      *
1196      * NOTE: This function is deprecated in favor of {_grantRole}.
1197      */
1198     function _setupRole(bytes32 role, address account) internal virtual {
1199         _grantRole(role, account);
1200     }
1201 
1202     /**
1203      * @dev Sets `adminRole` as ``role``'s admin role.
1204      *
1205      * Emits a {RoleAdminChanged} event.
1206      */
1207     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1208         bytes32 previousAdminRole = getRoleAdmin(role);
1209         _roles[role].adminRole = adminRole;
1210         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1211     }
1212 
1213     /**
1214      * @dev Grants `role` to `account`.
1215      *
1216      * Internal function without access restriction.
1217      *
1218      * May emit a {RoleGranted} event.
1219      */
1220     function _grantRole(bytes32 role, address account) internal virtual {
1221         if (!hasRole(role, account)) {
1222             _roles[role].members[account] = true;
1223             emit RoleGranted(role, account, _msgSender());
1224         }
1225     }
1226 
1227     /**
1228      * @dev Revokes `role` from `account`.
1229      *
1230      * Internal function without access restriction.
1231      *
1232      * May emit a {RoleRevoked} event.
1233      */
1234     function _revokeRole(bytes32 role, address account) internal virtual {
1235         if (hasRole(role, account)) {
1236             _roles[role].members[account] = false;
1237             emit RoleRevoked(role, account, _msgSender());
1238         }
1239     }
1240 }
1241 
1242 // File: @openzeppelin/contracts/access/Ownable.sol
1243 
1244 
1245 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 
1250 /**
1251  * @dev Contract module which provides a basic access control mechanism, where
1252  * there is an account (an owner) that can be granted exclusive access to
1253  * specific functions.
1254  *
1255  * By default, the owner account will be the one that deploys the contract. This
1256  * can later be changed with {transferOwnership}.
1257  *
1258  * This module is used through inheritance. It will make available the modifier
1259  * `onlyOwner`, which can be applied to your functions to restrict their use to
1260  * the owner.
1261  */
1262 abstract contract Ownable is Context {
1263     address private _owner;
1264 
1265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1266 
1267     /**
1268      * @dev Initializes the contract setting the deployer as the initial owner.
1269      */
1270     constructor() {
1271         _transferOwnership(_msgSender());
1272     }
1273 
1274     /**
1275      * @dev Throws if called by any account other than the owner.
1276      */
1277     modifier onlyOwner() {
1278         _checkOwner();
1279         _;
1280     }
1281 
1282     /**
1283      * @dev Returns the address of the current owner.
1284      */
1285     function owner() public view virtual returns (address) {
1286         return _owner;
1287     }
1288 
1289     /**
1290      * @dev Throws if the sender is not the owner.
1291      */
1292     function _checkOwner() internal view virtual {
1293         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1294     }
1295 
1296     /**
1297      * @dev Leaves the contract without owner. It will not be possible to call
1298      * `onlyOwner` functions anymore. Can only be called by the current owner.
1299      *
1300      * NOTE: Renouncing ownership will leave the contract without an owner,
1301      * thereby removing any functionality that is only available to the owner.
1302      */
1303     function renounceOwnership() public virtual onlyOwner {
1304         _transferOwnership(address(0));
1305     }
1306 
1307     /**
1308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1309      * Can only be called by the current owner.
1310      */
1311     function transferOwnership(address newOwner) public virtual onlyOwner {
1312         require(newOwner != address(0), "Ownable: new owner is the zero address");
1313         _transferOwnership(newOwner);
1314     }
1315 
1316     /**
1317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1318      * Internal function without access restriction.
1319      */
1320     function _transferOwnership(address newOwner) internal virtual {
1321         address oldOwner = _owner;
1322         _owner = newOwner;
1323         emit OwnershipTransferred(oldOwner, newOwner);
1324     }
1325 }
1326 
1327 // File: contract-allow-list/contracts/ERC721AntiScam/IERC721AntiScam.sol
1328 
1329 
1330 pragma solidity >=0.8.0;
1331 
1332 /// @title IERC721AntiScam
1333 /// @dev 詐欺防止機能付きコントラクトのインターフェース
1334 /// @author hayatti.eth
1335 
1336 interface IERC721AntiScam {
1337 
1338    enum LockStatus {
1339       UnSet,
1340       UnLock,
1341       CalLock,
1342       AllLock
1343    }
1344 
1345     /**
1346      * @dev 個別ロックが指定された場合のイベント
1347      */
1348     event TokenLock(address indexed owner, address indexed from, uint lockStatus, uint256 indexed tokenId);
1349 
1350     /**
1351      * @dev 該当トークンIDにおけるロックレベルを return で返す。
1352      */
1353     function getLockStatus(uint256 tokenId) external view returns (LockStatus);
1354 
1355     /**
1356      * @dev 該当トークンIDにおいて、該当コントラクトの転送が許可されているかを返す
1357      */
1358     function getTokenLocked(address to ,uint256 tokenId) external view returns (bool);
1359     
1360     /**
1361      * @dev 該当コントラクトの転送が拒否されているトークンを全て返す
1362      */
1363     function getTokensUnderLock(address to) external view returns (uint256[] memory);
1364 
1365     /**
1366      * @dev 該当コントラクトの転送が拒否されているstartからstopまでのトークンIDを返す
1367      */
1368     function getTokensUnderLock(address to, uint256 start, uint256 end) external view returns (uint256[] memory);
1369 
1370     
1371     /**
1372      * @dev holderが所有するトークンのうち、該当コントラクトの転送が拒否されているトークンを全て返す
1373      */
1374     function getTokensUnderLock(address holder, address to) external view returns (uint256[] memory);
1375 
1376     /**
1377      * @dev holderが所有するトークンのうち、該当コントラクトの転送が拒否されているstartからstopまでのトークンIDを返す
1378      */
1379     function getTokensUnderLock(address holder, address to, uint256 start, uint256 end) external view returns (uint256[] memory);
1380 
1381     /**
1382      * @dev 該当ウォレットアドレスにおいて、該当コントラクトの転送が許可されているかを返す
1383      */
1384     function getLocked(address to ,address holder) external view returns (bool);
1385 
1386     /**
1387      * @dev CALのリストに無い独自の許可アドレスを追加する場合、こちらにアドレスを記載する。
1388      */
1389     function addLocalContractAllowList(address _contract) external;
1390 
1391     /**
1392      * @dev CALのリストにある独自の許可アドレスを削除する場合、こちらにアドレスを記載する。
1393      */
1394     function removeLocalContractAllowList(address _contract) external;
1395 
1396 
1397     /**
1398      * @dev CALを利用する場合のCALのレベルを設定する。レベルが高いほど、許可されるコントラクトの範囲が狭い。
1399      */
1400     function setContractAllowListLevel(uint256 level) external;
1401 
1402     /**
1403      * @dev デフォルトでのロックレベルを指定する。
1404      */
1405     function setContractLockStatus(LockStatus status) external;
1406 
1407 }
1408 // File: erc721a/contracts/IERC721A.sol
1409 
1410 
1411 // ERC721A Contracts v4.2.3
1412 // Creator: Chiru Labs
1413 
1414 pragma solidity ^0.8.4;
1415 
1416 /**
1417  * @dev Interface of ERC721A.
1418  */
1419 interface IERC721A {
1420     /**
1421      * The caller must own the token or be an approved operator.
1422      */
1423     error ApprovalCallerNotOwnerNorApproved();
1424 
1425     /**
1426      * The token does not exist.
1427      */
1428     error ApprovalQueryForNonexistentToken();
1429 
1430     /**
1431      * Cannot query the balance for the zero address.
1432      */
1433     error BalanceQueryForZeroAddress();
1434 
1435     /**
1436      * Cannot mint to the zero address.
1437      */
1438     error MintToZeroAddress();
1439 
1440     /**
1441      * The quantity of tokens minted must be more than zero.
1442      */
1443     error MintZeroQuantity();
1444 
1445     /**
1446      * The token does not exist.
1447      */
1448     error OwnerQueryForNonexistentToken();
1449 
1450     /**
1451      * The caller must own the token or be an approved operator.
1452      */
1453     error TransferCallerNotOwnerNorApproved();
1454 
1455     /**
1456      * The token must be owned by `from`.
1457      */
1458     error TransferFromIncorrectOwner();
1459 
1460     /**
1461      * Cannot safely transfer to a contract that does not implement the
1462      * ERC721Receiver interface.
1463      */
1464     error TransferToNonERC721ReceiverImplementer();
1465 
1466     /**
1467      * Cannot transfer to the zero address.
1468      */
1469     error TransferToZeroAddress();
1470 
1471     /**
1472      * The token does not exist.
1473      */
1474     error URIQueryForNonexistentToken();
1475 
1476     /**
1477      * The `quantity` minted with ERC2309 exceeds the safety limit.
1478      */
1479     error MintERC2309QuantityExceedsLimit();
1480 
1481     /**
1482      * The `extraData` cannot be set on an unintialized ownership slot.
1483      */
1484     error OwnershipNotInitializedForExtraData();
1485 
1486     // =============================================================
1487     //                            STRUCTS
1488     // =============================================================
1489 
1490     struct TokenOwnership {
1491         // The address of the owner.
1492         address addr;
1493         // Stores the start time of ownership with minimal overhead for tokenomics.
1494         uint64 startTimestamp;
1495         // Whether the token has been burned.
1496         bool burned;
1497         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1498         uint24 extraData;
1499     }
1500 
1501     // =============================================================
1502     //                         TOKEN COUNTERS
1503     // =============================================================
1504 
1505     /**
1506      * @dev Returns the total number of tokens in existence.
1507      * Burned tokens will reduce the count.
1508      * To get the total number of tokens minted, please see {_totalMinted}.
1509      */
1510     function totalSupply() external view returns (uint256);
1511 
1512     // =============================================================
1513     //                            IERC165
1514     // =============================================================
1515 
1516     /**
1517      * @dev Returns true if this contract implements the interface defined by
1518      * `interfaceId`. See the corresponding
1519      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1520      * to learn more about how these ids are created.
1521      *
1522      * This function call must use less than 30000 gas.
1523      */
1524     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1525 
1526     // =============================================================
1527     //                            IERC721
1528     // =============================================================
1529 
1530     /**
1531      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1532      */
1533     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1534 
1535     /**
1536      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1537      */
1538     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1539 
1540     /**
1541      * @dev Emitted when `owner` enables or disables
1542      * (`approved`) `operator` to manage all of its assets.
1543      */
1544     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1545 
1546     /**
1547      * @dev Returns the number of tokens in `owner`'s account.
1548      */
1549     function balanceOf(address owner) external view returns (uint256 balance);
1550 
1551     /**
1552      * @dev Returns the owner of the `tokenId` token.
1553      *
1554      * Requirements:
1555      *
1556      * - `tokenId` must exist.
1557      */
1558     function ownerOf(uint256 tokenId) external view returns (address owner);
1559 
1560     /**
1561      * @dev Safely transfers `tokenId` token from `from` to `to`,
1562      * checking first that contract recipients are aware of the ERC721 protocol
1563      * to prevent tokens from being forever locked.
1564      *
1565      * Requirements:
1566      *
1567      * - `from` cannot be the zero address.
1568      * - `to` cannot be the zero address.
1569      * - `tokenId` token must exist and be owned by `from`.
1570      * - If the caller is not `from`, it must be have been allowed to move
1571      * this token by either {approve} or {setApprovalForAll}.
1572      * - If `to` refers to a smart contract, it must implement
1573      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1574      *
1575      * Emits a {Transfer} event.
1576      */
1577     function safeTransferFrom(
1578         address from,
1579         address to,
1580         uint256 tokenId,
1581         bytes calldata data
1582     ) external payable;
1583 
1584     /**
1585      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1586      */
1587     function safeTransferFrom(
1588         address from,
1589         address to,
1590         uint256 tokenId
1591     ) external payable;
1592 
1593     /**
1594      * @dev Transfers `tokenId` from `from` to `to`.
1595      *
1596      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1597      * whenever possible.
1598      *
1599      * Requirements:
1600      *
1601      * - `from` cannot be the zero address.
1602      * - `to` cannot be the zero address.
1603      * - `tokenId` token must be owned by `from`.
1604      * - If the caller is not `from`, it must be approved to move this token
1605      * by either {approve} or {setApprovalForAll}.
1606      *
1607      * Emits a {Transfer} event.
1608      */
1609     function transferFrom(
1610         address from,
1611         address to,
1612         uint256 tokenId
1613     ) external payable;
1614 
1615     /**
1616      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1617      * The approval is cleared when the token is transferred.
1618      *
1619      * Only a single account can be approved at a time, so approving the
1620      * zero address clears previous approvals.
1621      *
1622      * Requirements:
1623      *
1624      * - The caller must own the token or be an approved operator.
1625      * - `tokenId` must exist.
1626      *
1627      * Emits an {Approval} event.
1628      */
1629     function approve(address to, uint256 tokenId) external payable;
1630 
1631     /**
1632      * @dev Approve or remove `operator` as an operator for the caller.
1633      * Operators can call {transferFrom} or {safeTransferFrom}
1634      * for any token owned by the caller.
1635      *
1636      * Requirements:
1637      *
1638      * - The `operator` cannot be the caller.
1639      *
1640      * Emits an {ApprovalForAll} event.
1641      */
1642     function setApprovalForAll(address operator, bool _approved) external;
1643 
1644     /**
1645      * @dev Returns the account approved for `tokenId` token.
1646      *
1647      * Requirements:
1648      *
1649      * - `tokenId` must exist.
1650      */
1651     function getApproved(uint256 tokenId) external view returns (address operator);
1652 
1653     /**
1654      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1655      *
1656      * See {setApprovalForAll}.
1657      */
1658     function isApprovedForAll(address owner, address operator) external view returns (bool);
1659 
1660     // =============================================================
1661     //                        IERC721Metadata
1662     // =============================================================
1663 
1664     /**
1665      * @dev Returns the token collection name.
1666      */
1667     function name() external view returns (string memory);
1668 
1669     /**
1670      * @dev Returns the token collection symbol.
1671      */
1672     function symbol() external view returns (string memory);
1673 
1674     /**
1675      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1676      */
1677     function tokenURI(uint256 tokenId) external view returns (string memory);
1678 
1679     // =============================================================
1680     //                           IERC2309
1681     // =============================================================
1682 
1683     /**
1684      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1685      * (inclusive) is transferred from `from` to `to`, as defined in the
1686      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1687      *
1688      * See {_mintERC2309} for more details.
1689      */
1690     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1691 }
1692 
1693 // File: erc721a/contracts/ERC721A.sol
1694 
1695 
1696 // ERC721A Contracts v4.2.3
1697 // Creator: Chiru Labs
1698 
1699 pragma solidity ^0.8.4;
1700 
1701 
1702 /**
1703  * @dev Interface of ERC721 token receiver.
1704  */
1705 interface ERC721A__IERC721Receiver {
1706     function onERC721Received(
1707         address operator,
1708         address from,
1709         uint256 tokenId,
1710         bytes calldata data
1711     ) external returns (bytes4);
1712 }
1713 
1714 /**
1715  * @title ERC721A
1716  *
1717  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1718  * Non-Fungible Token Standard, including the Metadata extension.
1719  * Optimized for lower gas during batch mints.
1720  *
1721  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1722  * starting from `_startTokenId()`.
1723  *
1724  * Assumptions:
1725  *
1726  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1727  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1728  */
1729 contract ERC721A is IERC721A {
1730     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1731     struct TokenApprovalRef {
1732         address value;
1733     }
1734 
1735     // =============================================================
1736     //                           CONSTANTS
1737     // =============================================================
1738 
1739     // Mask of an entry in packed address data.
1740     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1741 
1742     // The bit position of `numberMinted` in packed address data.
1743     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1744 
1745     // The bit position of `numberBurned` in packed address data.
1746     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1747 
1748     // The bit position of `aux` in packed address data.
1749     uint256 private constant _BITPOS_AUX = 192;
1750 
1751     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1752     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1753 
1754     // The bit position of `startTimestamp` in packed ownership.
1755     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1756 
1757     // The bit mask of the `burned` bit in packed ownership.
1758     uint256 private constant _BITMASK_BURNED = 1 << 224;
1759 
1760     // The bit position of the `nextInitialized` bit in packed ownership.
1761     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1762 
1763     // The bit mask of the `nextInitialized` bit in packed ownership.
1764     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1765 
1766     // The bit position of `extraData` in packed ownership.
1767     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1768 
1769     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1770     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1771 
1772     // The mask of the lower 160 bits for addresses.
1773     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1774 
1775     // The maximum `quantity` that can be minted with {_mintERC2309}.
1776     // This limit is to prevent overflows on the address data entries.
1777     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1778     // is required to cause an overflow, which is unrealistic.
1779     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1780 
1781     // The `Transfer` event signature is given by:
1782     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1783     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1784         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1785 
1786     // =============================================================
1787     //                            STORAGE
1788     // =============================================================
1789 
1790     // The next token ID to be minted.
1791     uint256 private _currentIndex;
1792 
1793     // The number of tokens burned.
1794     uint256 private _burnCounter;
1795 
1796     // Token name
1797     string private _name;
1798 
1799     // Token symbol
1800     string private _symbol;
1801 
1802     // Mapping from token ID to ownership details
1803     // An empty struct value does not necessarily mean the token is unowned.
1804     // See {_packedOwnershipOf} implementation for details.
1805     //
1806     // Bits Layout:
1807     // - [0..159]   `addr`
1808     // - [160..223] `startTimestamp`
1809     // - [224]      `burned`
1810     // - [225]      `nextInitialized`
1811     // - [232..255] `extraData`
1812     mapping(uint256 => uint256) private _packedOwnerships;
1813 
1814     // Mapping owner address to address data.
1815     //
1816     // Bits Layout:
1817     // - [0..63]    `balance`
1818     // - [64..127]  `numberMinted`
1819     // - [128..191] `numberBurned`
1820     // - [192..255] `aux`
1821     mapping(address => uint256) private _packedAddressData;
1822 
1823     // Mapping from token ID to approved address.
1824     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1825 
1826     // Mapping from owner to operator approvals
1827     mapping(address => mapping(address => bool)) private _operatorApprovals;
1828 
1829     // =============================================================
1830     //                          CONSTRUCTOR
1831     // =============================================================
1832 
1833     constructor(string memory name_, string memory symbol_) {
1834         _name = name_;
1835         _symbol = symbol_;
1836         _currentIndex = _startTokenId();
1837     }
1838 
1839     // =============================================================
1840     //                   TOKEN COUNTING OPERATIONS
1841     // =============================================================
1842 
1843     /**
1844      * @dev Returns the starting token ID.
1845      * To change the starting token ID, please override this function.
1846      */
1847     function _startTokenId() internal view virtual returns (uint256) {
1848         return 0;
1849     }
1850 
1851     /**
1852      * @dev Returns the next token ID to be minted.
1853      */
1854     function _nextTokenId() internal view virtual returns (uint256) {
1855         return _currentIndex;
1856     }
1857 
1858     /**
1859      * @dev Returns the total number of tokens in existence.
1860      * Burned tokens will reduce the count.
1861      * To get the total number of tokens minted, please see {_totalMinted}.
1862      */
1863     function totalSupply() public view virtual override returns (uint256) {
1864         // Counter underflow is impossible as _burnCounter cannot be incremented
1865         // more than `_currentIndex - _startTokenId()` times.
1866         unchecked {
1867             return _currentIndex - _burnCounter - _startTokenId();
1868         }
1869     }
1870 
1871     /**
1872      * @dev Returns the total amount of tokens minted in the contract.
1873      */
1874     function _totalMinted() internal view virtual returns (uint256) {
1875         // Counter underflow is impossible as `_currentIndex` does not decrement,
1876         // and it is initialized to `_startTokenId()`.
1877         unchecked {
1878             return _currentIndex - _startTokenId();
1879         }
1880     }
1881 
1882     /**
1883      * @dev Returns the total number of tokens burned.
1884      */
1885     function _totalBurned() internal view virtual returns (uint256) {
1886         return _burnCounter;
1887     }
1888 
1889     // =============================================================
1890     //                    ADDRESS DATA OPERATIONS
1891     // =============================================================
1892 
1893     /**
1894      * @dev Returns the number of tokens in `owner`'s account.
1895      */
1896     function balanceOf(address owner) public view virtual override returns (uint256) {
1897         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1898         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1899     }
1900 
1901     /**
1902      * Returns the number of tokens minted by `owner`.
1903      */
1904     function _numberMinted(address owner) internal view returns (uint256) {
1905         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1906     }
1907 
1908     /**
1909      * Returns the number of tokens burned by or on behalf of `owner`.
1910      */
1911     function _numberBurned(address owner) internal view returns (uint256) {
1912         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1913     }
1914 
1915     /**
1916      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1917      */
1918     function _getAux(address owner) internal view returns (uint64) {
1919         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1920     }
1921 
1922     /**
1923      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1924      * If there are multiple variables, please pack them into a uint64.
1925      */
1926     function _setAux(address owner, uint64 aux) internal virtual {
1927         uint256 packed = _packedAddressData[owner];
1928         uint256 auxCasted;
1929         // Cast `aux` with assembly to avoid redundant masking.
1930         assembly {
1931             auxCasted := aux
1932         }
1933         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1934         _packedAddressData[owner] = packed;
1935     }
1936 
1937     // =============================================================
1938     //                            IERC165
1939     // =============================================================
1940 
1941     /**
1942      * @dev Returns true if this contract implements the interface defined by
1943      * `interfaceId`. See the corresponding
1944      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1945      * to learn more about how these ids are created.
1946      *
1947      * This function call must use less than 30000 gas.
1948      */
1949     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1950         // The interface IDs are constants representing the first 4 bytes
1951         // of the XOR of all function selectors in the interface.
1952         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1953         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1954         return
1955             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1956             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1957             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1958     }
1959 
1960     // =============================================================
1961     //                        IERC721Metadata
1962     // =============================================================
1963 
1964     /**
1965      * @dev Returns the token collection name.
1966      */
1967     function name() public view virtual override returns (string memory) {
1968         return _name;
1969     }
1970 
1971     /**
1972      * @dev Returns the token collection symbol.
1973      */
1974     function symbol() public view virtual override returns (string memory) {
1975         return _symbol;
1976     }
1977 
1978     /**
1979      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1980      */
1981     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1982         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1983 
1984         string memory baseURI = _baseURI();
1985         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1986     }
1987 
1988     /**
1989      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1990      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1991      * by default, it can be overridden in child contracts.
1992      */
1993     function _baseURI() internal view virtual returns (string memory) {
1994         return '';
1995     }
1996 
1997     // =============================================================
1998     //                     OWNERSHIPS OPERATIONS
1999     // =============================================================
2000 
2001     /**
2002      * @dev Returns the owner of the `tokenId` token.
2003      *
2004      * Requirements:
2005      *
2006      * - `tokenId` must exist.
2007      */
2008     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2009         return address(uint160(_packedOwnershipOf(tokenId)));
2010     }
2011 
2012     /**
2013      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2014      * It gradually moves to O(1) as tokens get transferred around over time.
2015      */
2016     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2017         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2018     }
2019 
2020     /**
2021      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2022      */
2023     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2024         return _unpackedOwnership(_packedOwnerships[index]);
2025     }
2026 
2027     /**
2028      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2029      */
2030     function _initializeOwnershipAt(uint256 index) internal virtual {
2031         if (_packedOwnerships[index] == 0) {
2032             _packedOwnerships[index] = _packedOwnershipOf(index);
2033         }
2034     }
2035 
2036     /**
2037      * Returns the packed ownership data of `tokenId`.
2038      */
2039     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2040         uint256 curr = tokenId;
2041 
2042         unchecked {
2043             if (_startTokenId() <= curr)
2044                 if (curr < _currentIndex) {
2045                     uint256 packed = _packedOwnerships[curr];
2046                     // If not burned.
2047                     if (packed & _BITMASK_BURNED == 0) {
2048                         // Invariant:
2049                         // There will always be an initialized ownership slot
2050                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2051                         // before an unintialized ownership slot
2052                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2053                         // Hence, `curr` will not underflow.
2054                         //
2055                         // We can directly compare the packed value.
2056                         // If the address is zero, packed will be zero.
2057                         while (packed == 0) {
2058                             packed = _packedOwnerships[--curr];
2059                         }
2060                         return packed;
2061                     }
2062                 }
2063         }
2064         revert OwnerQueryForNonexistentToken();
2065     }
2066 
2067     /**
2068      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2069      */
2070     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2071         ownership.addr = address(uint160(packed));
2072         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2073         ownership.burned = packed & _BITMASK_BURNED != 0;
2074         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2075     }
2076 
2077     /**
2078      * @dev Packs ownership data into a single uint256.
2079      */
2080     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2081         assembly {
2082             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2083             owner := and(owner, _BITMASK_ADDRESS)
2084             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2085             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2086         }
2087     }
2088 
2089     /**
2090      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2091      */
2092     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2093         // For branchless setting of the `nextInitialized` flag.
2094         assembly {
2095             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2096             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2097         }
2098     }
2099 
2100     // =============================================================
2101     //                      APPROVAL OPERATIONS
2102     // =============================================================
2103 
2104     /**
2105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2106      * The approval is cleared when the token is transferred.
2107      *
2108      * Only a single account can be approved at a time, so approving the
2109      * zero address clears previous approvals.
2110      *
2111      * Requirements:
2112      *
2113      * - The caller must own the token or be an approved operator.
2114      * - `tokenId` must exist.
2115      *
2116      * Emits an {Approval} event.
2117      */
2118     function approve(address to, uint256 tokenId) public payable virtual override {
2119         address owner = ownerOf(tokenId);
2120 
2121         if (_msgSenderERC721A() != owner)
2122             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2123                 revert ApprovalCallerNotOwnerNorApproved();
2124             }
2125 
2126         _tokenApprovals[tokenId].value = to;
2127         emit Approval(owner, to, tokenId);
2128     }
2129 
2130     /**
2131      * @dev Returns the account approved for `tokenId` token.
2132      *
2133      * Requirements:
2134      *
2135      * - `tokenId` must exist.
2136      */
2137     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2138         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2139 
2140         return _tokenApprovals[tokenId].value;
2141     }
2142 
2143     /**
2144      * @dev Approve or remove `operator` as an operator for the caller.
2145      * Operators can call {transferFrom} or {safeTransferFrom}
2146      * for any token owned by the caller.
2147      *
2148      * Requirements:
2149      *
2150      * - The `operator` cannot be the caller.
2151      *
2152      * Emits an {ApprovalForAll} event.
2153      */
2154     function setApprovalForAll(address operator, bool approved) public virtual override {
2155         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2156         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2157     }
2158 
2159     /**
2160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2161      *
2162      * See {setApprovalForAll}.
2163      */
2164     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2165         return _operatorApprovals[owner][operator];
2166     }
2167 
2168     /**
2169      * @dev Returns whether `tokenId` exists.
2170      *
2171      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2172      *
2173      * Tokens start existing when they are minted. See {_mint}.
2174      */
2175     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2176         return
2177             _startTokenId() <= tokenId &&
2178             tokenId < _currentIndex && // If within bounds,
2179             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2180     }
2181 
2182     /**
2183      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2184      */
2185     function _isSenderApprovedOrOwner(
2186         address approvedAddress,
2187         address owner,
2188         address msgSender
2189     ) private pure returns (bool result) {
2190         assembly {
2191             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2192             owner := and(owner, _BITMASK_ADDRESS)
2193             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2194             msgSender := and(msgSender, _BITMASK_ADDRESS)
2195             // `msgSender == owner || msgSender == approvedAddress`.
2196             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2197         }
2198     }
2199 
2200     /**
2201      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2202      */
2203     function _getApprovedSlotAndAddress(uint256 tokenId)
2204         private
2205         view
2206         returns (uint256 approvedAddressSlot, address approvedAddress)
2207     {
2208         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2209         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2210         assembly {
2211             approvedAddressSlot := tokenApproval.slot
2212             approvedAddress := sload(approvedAddressSlot)
2213         }
2214     }
2215 
2216     // =============================================================
2217     //                      TRANSFER OPERATIONS
2218     // =============================================================
2219 
2220     /**
2221      * @dev Transfers `tokenId` from `from` to `to`.
2222      *
2223      * Requirements:
2224      *
2225      * - `from` cannot be the zero address.
2226      * - `to` cannot be the zero address.
2227      * - `tokenId` token must be owned by `from`.
2228      * - If the caller is not `from`, it must be approved to move this token
2229      * by either {approve} or {setApprovalForAll}.
2230      *
2231      * Emits a {Transfer} event.
2232      */
2233     function transferFrom(
2234         address from,
2235         address to,
2236         uint256 tokenId
2237     ) public payable virtual override {
2238         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2239 
2240         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2241 
2242         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2243 
2244         // The nested ifs save around 20+ gas over a compound boolean condition.
2245         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2246             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2247 
2248         if (to == address(0)) revert TransferToZeroAddress();
2249 
2250         _beforeTokenTransfers(from, to, tokenId, 1);
2251 
2252         // Clear approvals from the previous owner.
2253         assembly {
2254             if approvedAddress {
2255                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2256                 sstore(approvedAddressSlot, 0)
2257             }
2258         }
2259 
2260         // Underflow of the sender's balance is impossible because we check for
2261         // ownership above and the recipient's balance can't realistically overflow.
2262         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2263         unchecked {
2264             // We can directly increment and decrement the balances.
2265             --_packedAddressData[from]; // Updates: `balance -= 1`.
2266             ++_packedAddressData[to]; // Updates: `balance += 1`.
2267 
2268             // Updates:
2269             // - `address` to the next owner.
2270             // - `startTimestamp` to the timestamp of transfering.
2271             // - `burned` to `false`.
2272             // - `nextInitialized` to `true`.
2273             _packedOwnerships[tokenId] = _packOwnershipData(
2274                 to,
2275                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2276             );
2277 
2278             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2279             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2280                 uint256 nextTokenId = tokenId + 1;
2281                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2282                 if (_packedOwnerships[nextTokenId] == 0) {
2283                     // If the next slot is within bounds.
2284                     if (nextTokenId != _currentIndex) {
2285                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2286                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2287                     }
2288                 }
2289             }
2290         }
2291 
2292         emit Transfer(from, to, tokenId);
2293         _afterTokenTransfers(from, to, tokenId, 1);
2294     }
2295 
2296     /**
2297      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2298      */
2299     function safeTransferFrom(
2300         address from,
2301         address to,
2302         uint256 tokenId
2303     ) public payable virtual override {
2304         safeTransferFrom(from, to, tokenId, '');
2305     }
2306 
2307     /**
2308      * @dev Safely transfers `tokenId` token from `from` to `to`.
2309      *
2310      * Requirements:
2311      *
2312      * - `from` cannot be the zero address.
2313      * - `to` cannot be the zero address.
2314      * - `tokenId` token must exist and be owned by `from`.
2315      * - If the caller is not `from`, it must be approved to move this token
2316      * by either {approve} or {setApprovalForAll}.
2317      * - If `to` refers to a smart contract, it must implement
2318      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2319      *
2320      * Emits a {Transfer} event.
2321      */
2322     function safeTransferFrom(
2323         address from,
2324         address to,
2325         uint256 tokenId,
2326         bytes memory _data
2327     ) public payable virtual override {
2328         transferFrom(from, to, tokenId);
2329         if (to.code.length != 0)
2330             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2331                 revert TransferToNonERC721ReceiverImplementer();
2332             }
2333     }
2334 
2335     /**
2336      * @dev Hook that is called before a set of serially-ordered token IDs
2337      * are about to be transferred. This includes minting.
2338      * And also called before burning one token.
2339      *
2340      * `startTokenId` - the first token ID to be transferred.
2341      * `quantity` - the amount to be transferred.
2342      *
2343      * Calling conditions:
2344      *
2345      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2346      * transferred to `to`.
2347      * - When `from` is zero, `tokenId` will be minted for `to`.
2348      * - When `to` is zero, `tokenId` will be burned by `from`.
2349      * - `from` and `to` are never both zero.
2350      */
2351     function _beforeTokenTransfers(
2352         address from,
2353         address to,
2354         uint256 startTokenId,
2355         uint256 quantity
2356     ) internal virtual {}
2357 
2358     /**
2359      * @dev Hook that is called after a set of serially-ordered token IDs
2360      * have been transferred. This includes minting.
2361      * And also called after one token has been burned.
2362      *
2363      * `startTokenId` - the first token ID to be transferred.
2364      * `quantity` - the amount to be transferred.
2365      *
2366      * Calling conditions:
2367      *
2368      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2369      * transferred to `to`.
2370      * - When `from` is zero, `tokenId` has been minted for `to`.
2371      * - When `to` is zero, `tokenId` has been burned by `from`.
2372      * - `from` and `to` are never both zero.
2373      */
2374     function _afterTokenTransfers(
2375         address from,
2376         address to,
2377         uint256 startTokenId,
2378         uint256 quantity
2379     ) internal virtual {}
2380 
2381     /**
2382      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2383      *
2384      * `from` - Previous owner of the given token ID.
2385      * `to` - Target address that will receive the token.
2386      * `tokenId` - Token ID to be transferred.
2387      * `_data` - Optional data to send along with the call.
2388      *
2389      * Returns whether the call correctly returned the expected magic value.
2390      */
2391     function _checkContractOnERC721Received(
2392         address from,
2393         address to,
2394         uint256 tokenId,
2395         bytes memory _data
2396     ) private returns (bool) {
2397         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2398             bytes4 retval
2399         ) {
2400             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2401         } catch (bytes memory reason) {
2402             if (reason.length == 0) {
2403                 revert TransferToNonERC721ReceiverImplementer();
2404             } else {
2405                 assembly {
2406                     revert(add(32, reason), mload(reason))
2407                 }
2408             }
2409         }
2410     }
2411 
2412     // =============================================================
2413     //                        MINT OPERATIONS
2414     // =============================================================
2415 
2416     /**
2417      * @dev Mints `quantity` tokens and transfers them to `to`.
2418      *
2419      * Requirements:
2420      *
2421      * - `to` cannot be the zero address.
2422      * - `quantity` must be greater than 0.
2423      *
2424      * Emits a {Transfer} event for each mint.
2425      */
2426     function _mint(address to, uint256 quantity) internal virtual {
2427         uint256 startTokenId = _currentIndex;
2428         if (quantity == 0) revert MintZeroQuantity();
2429 
2430         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2431 
2432         // Overflows are incredibly unrealistic.
2433         // `balance` and `numberMinted` have a maximum limit of 2**64.
2434         // `tokenId` has a maximum limit of 2**256.
2435         unchecked {
2436             // Updates:
2437             // - `balance += quantity`.
2438             // - `numberMinted += quantity`.
2439             //
2440             // We can directly add to the `balance` and `numberMinted`.
2441             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2442 
2443             // Updates:
2444             // - `address` to the owner.
2445             // - `startTimestamp` to the timestamp of minting.
2446             // - `burned` to `false`.
2447             // - `nextInitialized` to `quantity == 1`.
2448             _packedOwnerships[startTokenId] = _packOwnershipData(
2449                 to,
2450                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2451             );
2452 
2453             uint256 toMasked;
2454             uint256 end = startTokenId + quantity;
2455 
2456             // Use assembly to loop and emit the `Transfer` event for gas savings.
2457             // The duplicated `log4` removes an extra check and reduces stack juggling.
2458             // The assembly, together with the surrounding Solidity code, have been
2459             // delicately arranged to nudge the compiler into producing optimized opcodes.
2460             assembly {
2461                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2462                 toMasked := and(to, _BITMASK_ADDRESS)
2463                 // Emit the `Transfer` event.
2464                 log4(
2465                     0, // Start of data (0, since no data).
2466                     0, // End of data (0, since no data).
2467                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2468                     0, // `address(0)`.
2469                     toMasked, // `to`.
2470                     startTokenId // `tokenId`.
2471                 )
2472 
2473                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2474                 // that overflows uint256 will make the loop run out of gas.
2475                 // The compiler will optimize the `iszero` away for performance.
2476                 for {
2477                     let tokenId := add(startTokenId, 1)
2478                 } iszero(eq(tokenId, end)) {
2479                     tokenId := add(tokenId, 1)
2480                 } {
2481                     // Emit the `Transfer` event. Similar to above.
2482                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2483                 }
2484             }
2485             if (toMasked == 0) revert MintToZeroAddress();
2486 
2487             _currentIndex = end;
2488         }
2489         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2490     }
2491 
2492     /**
2493      * @dev Mints `quantity` tokens and transfers them to `to`.
2494      *
2495      * This function is intended for efficient minting only during contract creation.
2496      *
2497      * It emits only one {ConsecutiveTransfer} as defined in
2498      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2499      * instead of a sequence of {Transfer} event(s).
2500      *
2501      * Calling this function outside of contract creation WILL make your contract
2502      * non-compliant with the ERC721 standard.
2503      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2504      * {ConsecutiveTransfer} event is only permissible during contract creation.
2505      *
2506      * Requirements:
2507      *
2508      * - `to` cannot be the zero address.
2509      * - `quantity` must be greater than 0.
2510      *
2511      * Emits a {ConsecutiveTransfer} event.
2512      */
2513     function _mintERC2309(address to, uint256 quantity) internal virtual {
2514         uint256 startTokenId = _currentIndex;
2515         if (to == address(0)) revert MintToZeroAddress();
2516         if (quantity == 0) revert MintZeroQuantity();
2517         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2518 
2519         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2520 
2521         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2522         unchecked {
2523             // Updates:
2524             // - `balance += quantity`.
2525             // - `numberMinted += quantity`.
2526             //
2527             // We can directly add to the `balance` and `numberMinted`.
2528             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2529 
2530             // Updates:
2531             // - `address` to the owner.
2532             // - `startTimestamp` to the timestamp of minting.
2533             // - `burned` to `false`.
2534             // - `nextInitialized` to `quantity == 1`.
2535             _packedOwnerships[startTokenId] = _packOwnershipData(
2536                 to,
2537                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2538             );
2539 
2540             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2541 
2542             _currentIndex = startTokenId + quantity;
2543         }
2544         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2545     }
2546 
2547     /**
2548      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2549      *
2550      * Requirements:
2551      *
2552      * - If `to` refers to a smart contract, it must implement
2553      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2554      * - `quantity` must be greater than 0.
2555      *
2556      * See {_mint}.
2557      *
2558      * Emits a {Transfer} event for each mint.
2559      */
2560     function _safeMint(
2561         address to,
2562         uint256 quantity,
2563         bytes memory _data
2564     ) internal virtual {
2565         _mint(to, quantity);
2566 
2567         unchecked {
2568             if (to.code.length != 0) {
2569                 uint256 end = _currentIndex;
2570                 uint256 index = end - quantity;
2571                 do {
2572                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2573                         revert TransferToNonERC721ReceiverImplementer();
2574                     }
2575                 } while (index < end);
2576                 // Reentrancy protection.
2577                 if (_currentIndex != end) revert();
2578             }
2579         }
2580     }
2581 
2582     /**
2583      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2584      */
2585     function _safeMint(address to, uint256 quantity) internal virtual {
2586         _safeMint(to, quantity, '');
2587     }
2588 
2589     // =============================================================
2590     //                        BURN OPERATIONS
2591     // =============================================================
2592 
2593     /**
2594      * @dev Equivalent to `_burn(tokenId, false)`.
2595      */
2596     function _burn(uint256 tokenId) internal virtual {
2597         _burn(tokenId, false);
2598     }
2599 
2600     /**
2601      * @dev Destroys `tokenId`.
2602      * The approval is cleared when the token is burned.
2603      *
2604      * Requirements:
2605      *
2606      * - `tokenId` must exist.
2607      *
2608      * Emits a {Transfer} event.
2609      */
2610     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2611         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2612 
2613         address from = address(uint160(prevOwnershipPacked));
2614 
2615         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2616 
2617         if (approvalCheck) {
2618             // The nested ifs save around 20+ gas over a compound boolean condition.
2619             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2620                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2621         }
2622 
2623         _beforeTokenTransfers(from, address(0), tokenId, 1);
2624 
2625         // Clear approvals from the previous owner.
2626         assembly {
2627             if approvedAddress {
2628                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2629                 sstore(approvedAddressSlot, 0)
2630             }
2631         }
2632 
2633         // Underflow of the sender's balance is impossible because we check for
2634         // ownership above and the recipient's balance can't realistically overflow.
2635         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2636         unchecked {
2637             // Updates:
2638             // - `balance -= 1`.
2639             // - `numberBurned += 1`.
2640             //
2641             // We can directly decrement the balance, and increment the number burned.
2642             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2643             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2644 
2645             // Updates:
2646             // - `address` to the last owner.
2647             // - `startTimestamp` to the timestamp of burning.
2648             // - `burned` to `true`.
2649             // - `nextInitialized` to `true`.
2650             _packedOwnerships[tokenId] = _packOwnershipData(
2651                 from,
2652                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2653             );
2654 
2655             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2656             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2657                 uint256 nextTokenId = tokenId + 1;
2658                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2659                 if (_packedOwnerships[nextTokenId] == 0) {
2660                     // If the next slot is within bounds.
2661                     if (nextTokenId != _currentIndex) {
2662                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2663                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2664                     }
2665                 }
2666             }
2667         }
2668 
2669         emit Transfer(from, address(0), tokenId);
2670         _afterTokenTransfers(from, address(0), tokenId, 1);
2671 
2672         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2673         unchecked {
2674             _burnCounter++;
2675         }
2676     }
2677 
2678     // =============================================================
2679     //                     EXTRA DATA OPERATIONS
2680     // =============================================================
2681 
2682     /**
2683      * @dev Directly sets the extra data for the ownership data `index`.
2684      */
2685     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2686         uint256 packed = _packedOwnerships[index];
2687         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2688         uint256 extraDataCasted;
2689         // Cast `extraData` with assembly to avoid redundant masking.
2690         assembly {
2691             extraDataCasted := extraData
2692         }
2693         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2694         _packedOwnerships[index] = packed;
2695     }
2696 
2697     /**
2698      * @dev Called during each token transfer to set the 24bit `extraData` field.
2699      * Intended to be overridden by the cosumer contract.
2700      *
2701      * `previousExtraData` - the value of `extraData` before transfer.
2702      *
2703      * Calling conditions:
2704      *
2705      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2706      * transferred to `to`.
2707      * - When `from` is zero, `tokenId` will be minted for `to`.
2708      * - When `to` is zero, `tokenId` will be burned by `from`.
2709      * - `from` and `to` are never both zero.
2710      */
2711     function _extraData(
2712         address from,
2713         address to,
2714         uint24 previousExtraData
2715     ) internal view virtual returns (uint24) {}
2716 
2717     /**
2718      * @dev Returns the next extra data for the packed ownership data.
2719      * The returned result is shifted into position.
2720      */
2721     function _nextExtraData(
2722         address from,
2723         address to,
2724         uint256 prevOwnershipPacked
2725     ) private view returns (uint256) {
2726         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2727         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2728     }
2729 
2730     // =============================================================
2731     //                       OTHER OPERATIONS
2732     // =============================================================
2733 
2734     /**
2735      * @dev Returns the message sender (defaults to `msg.sender`).
2736      *
2737      * If you are writing GSN compatible contracts, you need to override this function.
2738      */
2739     function _msgSenderERC721A() internal view virtual returns (address) {
2740         return msg.sender;
2741     }
2742 
2743     /**
2744      * @dev Converts a uint256 to its ASCII string decimal representation.
2745      */
2746     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2747         assembly {
2748             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2749             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2750             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2751             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2752             let m := add(mload(0x40), 0xa0)
2753             // Update the free memory pointer to allocate.
2754             mstore(0x40, m)
2755             // Assign the `str` to the end.
2756             str := sub(m, 0x20)
2757             // Zeroize the slot after the string.
2758             mstore(str, 0)
2759 
2760             // Cache the end of the memory to calculate the length later.
2761             let end := str
2762 
2763             // We write the string from rightmost digit to leftmost digit.
2764             // The following is essentially a do-while loop that also handles the zero case.
2765             // prettier-ignore
2766             for { let temp := value } 1 {} {
2767                 str := sub(str, 1)
2768                 // Write the character to the pointer.
2769                 // The ASCII index of the '0' character is 48.
2770                 mstore8(str, add(48, mod(temp, 10)))
2771                 // Keep dividing `temp` until zero.
2772                 temp := div(temp, 10)
2773                 // prettier-ignore
2774                 if iszero(temp) { break }
2775             }
2776 
2777             let length := sub(end, str)
2778             // Move the pointer 32 bytes leftwards to make room for the length.
2779             str := sub(str, 0x20)
2780             // Store the length.
2781             mstore(str, length)
2782         }
2783     }
2784 }
2785 
2786 // File: contract-allow-list/contracts/ERC721AntiScam/ERC721AntiScam.sol
2787 
2788 
2789 pragma solidity >=0.8.0;
2790 
2791 
2792 
2793 
2794 
2795 
2796 /// @title AntiScam機能付きERC721A
2797 /// @dev Readmeを見てください。
2798 
2799 abstract contract ERC721AntiScam is ERC721A, IERC721AntiScam, Ownable {
2800     using EnumerableSet for EnumerableSet.AddressSet;
2801 
2802     IContractAllowListProxy public CAL;
2803     EnumerableSet.AddressSet localAllowedAddresses;
2804 
2805     /*//////////////////////////////////////////////////////////////
2806     ロック変数。トークンごとに個別ロック設定を行う
2807     //////////////////////////////////////////////////////////////*/
2808 
2809     // token lock
2810     mapping(uint256 => LockStatus) internal _tokenLockStatus;
2811     mapping(uint256 => uint256) internal _tokenCALLevel;
2812 
2813     // wallet lock
2814     mapping(address => LockStatus) internal _walletLockStatus;
2815     mapping(address => uint256) internal _walletCALLevel;
2816 
2817     // contract lock
2818     LockStatus public contractLockStatus = LockStatus.CalLock;
2819     uint256 public CALLevel = 1;
2820 
2821     /*///////////////////////////////////////////////////////////////
2822     ロック機能ロジック
2823     //////////////////////////////////////////////////////////////*/
2824 
2825     function getLockStatus(uint256 tokenId) public virtual view override returns (LockStatus) {
2826         require(_exists(tokenId), "AntiScam: locking query for nonexistent token");
2827         return _getLockStatus(ownerOf(tokenId), tokenId);
2828     }
2829 
2830     function getTokenLocked(address operator, uint256 tokenId) public virtual view override returns(bool isLocked) {
2831         address holder = ownerOf(tokenId);
2832         LockStatus status = _getLockStatus(holder, tokenId);
2833         uint256 level = _getCALLevel(holder, tokenId);
2834 
2835         if (status == LockStatus.CalLock) {
2836             if (ownerOf(tokenId) == msg.sender) {
2837                 return false;
2838             }
2839         } else {
2840             return _getLocked(operator, status, level);
2841         }
2842     }
2843     
2844     // TODO 標準実装
2845     function getTokensUnderLock(address /*to*/) external pure override returns (uint256[] memory){
2846         return new uint256[](0);
2847     }
2848 
2849     // TODO 標準実装
2850     function getTokensUnderLock(address /*to*/, uint256 /*start*/, uint256 /*end*/) external pure override returns (uint256[] memory){
2851         return new uint256[](0);
2852     }
2853     
2854     // TODO 標準実装
2855     function getTokensUnderLock(address /*holder*/, address /*to*/) external pure override returns (uint256[] memory){
2856         return new uint256[](0);
2857     }
2858 
2859     // TODO 標準実装
2860     function getTokensUnderLock(address /*holder*/, address /*to*/, uint256 /*start*/, uint256 /*end*/) external pure override returns (uint256[] memory){
2861         return new uint256[](0);
2862     }
2863 
2864     function getLocked(address operator, address holder) public virtual view override returns(bool) {
2865         LockStatus status = _getLockStatus(holder);
2866         uint256 level = _getCALLevel(holder);
2867         return _getLocked(operator, status, level);
2868     }
2869 
2870     function _getLocked(address operator, LockStatus status, uint256 level) internal virtual view returns(bool){
2871         if (status == LockStatus.UnLock) {
2872             return false;
2873         } else if (status == LockStatus.AllLock)  {
2874             return true;
2875         } else if (status == LockStatus.CalLock) {
2876             if (isLocalAllowed(operator)) {
2877                 return false;
2878             }
2879             if (address(CAL) == address(0)) {
2880                 return true;
2881             }
2882             if (CAL.isAllowed(operator, level)) {
2883                 return false;
2884             } else {
2885                 return true;
2886             }
2887         } else {
2888             revert("LockStatus is invalid");
2889         }
2890     }
2891 
2892     function addLocalContractAllowList(address _contract) external override onlyOwner {
2893         localAllowedAddresses.add(_contract);
2894     }
2895 
2896     function removeLocalContractAllowList(address _contract) external override onlyOwner {
2897         localAllowedAddresses.remove(_contract);
2898     }
2899 
2900     function isLocalAllowed(address _transferer)
2901         public
2902         view
2903         returns (bool)
2904     {
2905         bool Allowed = false;
2906         if(localAllowedAddresses.contains(_transferer) == true){
2907             Allowed = true;
2908         }
2909         return Allowed;
2910     }
2911 
2912     function _getLockStatus(address holder, uint256 tokenId) internal virtual view returns(LockStatus){
2913         if(_tokenLockStatus[tokenId] != LockStatus.UnSet) {
2914             return _tokenLockStatus[tokenId];
2915         }
2916 
2917         return _getLockStatus(holder);
2918     }
2919 
2920     function _getLockStatus(address holder) internal virtual view returns(LockStatus){
2921         if(_walletLockStatus[holder] != LockStatus.UnSet) {
2922             return _walletLockStatus[holder];
2923         }
2924 
2925         return contractLockStatus;
2926     }
2927 
2928     function _getCALLevel(address holder, uint256 tokenId) internal virtual view returns(uint256){
2929         if(_tokenCALLevel[tokenId] > 0) {
2930             return _tokenCALLevel[tokenId];
2931         }
2932 
2933         return _getCALLevel(holder);
2934     }
2935 
2936     function _getCALLevel(address holder) internal virtual view returns(uint256){
2937         if(_walletCALLevel[holder] > 0) {
2938             return _walletCALLevel[holder];
2939         }
2940 
2941         return CALLevel;
2942     }
2943 
2944     // For token lock
2945     function _lock(LockStatus status, uint256 id) internal virtual {
2946         _tokenLockStatus[id] = status;
2947         emit TokenLock(ownerOf(id), msg.sender, uint(status), id);
2948     }
2949 
2950     // For wallet lock
2951     function _setWalletLock(address to, LockStatus status) internal virtual {
2952         _walletLockStatus[to] = status;
2953     }
2954 
2955     function _setWalletCALLevel(address to ,uint256 level) internal virtual {
2956         _walletCALLevel[to] = level;
2957     }
2958 
2959     // For contract lock
2960     function setContractAllowListLevel(uint256 level) external override onlyOwner{
2961         CALLevel = level;
2962     }
2963 
2964     function setContractLockStatus(LockStatus status) external override onlyOwner {
2965        require(status != LockStatus.UnSet, "AntiScam: contract lock status can not set UNSET");
2966        contractLockStatus = status;
2967     }
2968 
2969     function setCAL(address _cal) external onlyOwner {
2970         CAL = IContractAllowListProxy(_cal);
2971     }
2972 
2973     /*///////////////////////////////////////////////////////////////
2974                               OVERRIDES
2975     //////////////////////////////////////////////////////////////*/
2976 
2977     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2978         if(getLocked(operator, owner)){
2979             return false;
2980         }
2981         return super.isApprovedForAll(owner, operator);
2982     }
2983 
2984     function setApprovalForAll(address operator, bool approved) public virtual override {
2985         require (getLocked(operator, msg.sender) == false || approved == false, "Can not approve locked token");
2986         super.setApprovalForAll(operator, approved);
2987     }
2988 
2989     function approve(address to, uint256 tokenId) public payable virtual override {
2990         if(to != address(0)){
2991             address holder = ownerOf(tokenId);
2992             LockStatus status = _tokenLockStatus[tokenId];
2993             require (status != LockStatus.AllLock, "Can not approve locked token");
2994             if (status == LockStatus.CalLock){
2995                 uint256 level = _getCALLevel(holder, tokenId);
2996                 require (_getLocked(to, status, level) == false, "Can not approve locked token");
2997             } else if (status == LockStatus.UnSet){
2998                 require (getLocked(to,holder) == false, "Can not approve locked token");
2999             }
3000         }
3001         super.approve(to, tokenId);
3002     }
3003 
3004     function _beforeTokenTransfers(
3005         address from,
3006         address to,
3007         uint256 startTokenId,
3008         uint256 /*quantity*/
3009     ) internal virtual override {
3010         // 転送やバーンにおいては、常にstartTokenIdは TokenIDそのものとなります。
3011         if (from != address(0)) {
3012             // トークンがロックされている場合、転送を許可しない
3013             require(getTokenLocked(to, startTokenId) == false , "LOCKED");
3014         }
3015     }
3016 
3017     function _afterTokenTransfers(
3018         address from,
3019         address /*to*/,
3020         uint256 startTokenId,
3021         uint256 /*quantity*/
3022     ) internal virtual override {
3023         // 転送やバーンにおいては、常にstartTokenIdは TokenIDそのものとなります。
3024         if (from != address(0)) {
3025             // ロックをデフォルトに戻す。（デフォルトは、 contractのLock status）
3026             delete _tokenLockStatus[startTokenId];
3027             delete _tokenCALLevel[startTokenId];
3028         }
3029     }
3030 
3031 
3032     function supportsInterface(bytes4 interfaceId)
3033         public
3034         view
3035         virtual
3036         override
3037         returns (bool)
3038     {
3039         return
3040             interfaceId == type(IERC721AntiScam).interfaceId ||
3041             super.supportsInterface(interfaceId);
3042     }
3043 
3044 }
3045 // File: base64-sol/base64.sol
3046 
3047 
3048 
3049 pragma solidity >=0.6.0;
3050 
3051 /// @title Base64
3052 /// @author Brecht Devos - <brecht@loopring.org>
3053 /// @notice Provides functions for encoding/decoding base64
3054 library Base64 {
3055     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
3056     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
3057                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
3058                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
3059                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
3060 
3061     function encode(bytes memory data) internal pure returns (string memory) {
3062         if (data.length == 0) return '';
3063 
3064         // load the table into memory
3065         string memory table = TABLE_ENCODE;
3066 
3067         // multiply by 4/3 rounded up
3068         uint256 encodedLen = 4 * ((data.length + 2) / 3);
3069 
3070         // add some extra buffer at the end required for the writing
3071         string memory result = new string(encodedLen + 32);
3072 
3073         assembly {
3074             // set the actual output length
3075             mstore(result, encodedLen)
3076 
3077             // prepare the lookup table
3078             let tablePtr := add(table, 1)
3079 
3080             // input ptr
3081             let dataPtr := data
3082             let endPtr := add(dataPtr, mload(data))
3083 
3084             // result ptr, jump over length
3085             let resultPtr := add(result, 32)
3086 
3087             // run over the input, 3 bytes at a time
3088             for {} lt(dataPtr, endPtr) {}
3089             {
3090                 // read 3 bytes
3091                 dataPtr := add(dataPtr, 3)
3092                 let input := mload(dataPtr)
3093 
3094                 // write 4 characters
3095                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
3096                 resultPtr := add(resultPtr, 1)
3097                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
3098                 resultPtr := add(resultPtr, 1)
3099                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
3100                 resultPtr := add(resultPtr, 1)
3101                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
3102                 resultPtr := add(resultPtr, 1)
3103             }
3104 
3105             // padding with '='
3106             switch mod(mload(data), 3)
3107             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
3108             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
3109         }
3110 
3111         return result;
3112     }
3113 
3114     function decode(string memory _data) internal pure returns (bytes memory) {
3115         bytes memory data = bytes(_data);
3116 
3117         if (data.length == 0) return new bytes(0);
3118         require(data.length % 4 == 0, "invalid base64 decoder input");
3119 
3120         // load the table into memory
3121         bytes memory table = TABLE_DECODE;
3122 
3123         // every 4 characters represent 3 bytes
3124         uint256 decodedLen = (data.length / 4) * 3;
3125 
3126         // add some extra buffer at the end required for the writing
3127         bytes memory result = new bytes(decodedLen + 32);
3128 
3129         assembly {
3130             // padding with '='
3131             let lastBytes := mload(add(data, mload(data)))
3132             if eq(and(lastBytes, 0xFF), 0x3d) {
3133                 decodedLen := sub(decodedLen, 1)
3134                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
3135                     decodedLen := sub(decodedLen, 1)
3136                 }
3137             }
3138 
3139             // set the actual output length
3140             mstore(result, decodedLen)
3141 
3142             // prepare the lookup table
3143             let tablePtr := add(table, 1)
3144 
3145             // input ptr
3146             let dataPtr := data
3147             let endPtr := add(dataPtr, mload(data))
3148 
3149             // result ptr, jump over length
3150             let resultPtr := add(result, 32)
3151 
3152             // run over the input, 4 characters at a time
3153             for {} lt(dataPtr, endPtr) {}
3154             {
3155                // read 4 characters
3156                dataPtr := add(dataPtr, 4)
3157                let input := mload(dataPtr)
3158 
3159                // write 3 bytes
3160                let output := add(
3161                    add(
3162                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
3163                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
3164                    add(
3165                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
3166                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
3167                     )
3168                 )
3169                 mstore(resultPtr, shl(232, output))
3170                 resultPtr := add(resultPtr, 3)
3171             }
3172         }
3173 
3174         return result;
3175     }
3176 }
3177 
3178 // File: tereqn.sol
3179 
3180 
3181 // Copyright (c) 2022 Keisuke OHNO
3182 
3183 /*
3184 
3185 Permission is hereby granted, free of charge, to any person obtaining a copy
3186 of this software and associated documentation files (the "Software"), to deal
3187 in the Software without restriction, including without limitation the rights
3188 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
3189 copies of the Software, and to permit persons to whom the Software is
3190 furnished to do so, subject to the following conditions:
3191 
3192 The above copyright notice and this permission notice shall be included in all
3193 copies or substantial portions of the Software.
3194 
3195 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
3196 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
3197 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
3198 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
3199 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
3200 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
3201 SOFTWARE.
3202 
3203 */
3204 
3205 pragma solidity >=0.7.0 <0.9.0;
3206 
3207 
3208 
3209 
3210 
3211 
3212 
3213 
3214 //tokenURI interface
3215 interface iTokenURI {
3216     function tokenURI(uint256 _tokenId) external view returns (string memory);
3217 }
3218 
3219 
3220 contract TereQN is Ownable , ERC2981 , AccessControl , ERC721AntiScam{
3221 
3222     constructor(
3223     ) ERC721A("TereQN", "TQN") {
3224         
3225         //Role initialization
3226         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
3227         _setupRole(MINTER_ROLE       , msg.sender);
3228         _setupRole(AIRDROP_ROLE      , msg.sender);
3229 
3230 
3231         //Royality initialization
3232         setRoyaltyFee(1000);
3233         setRoyaltyAddress(0x40abd10506bC2C62B5Ed6EcD4E97C042afd9927C);
3234 
3235 
3236         //URI initialization
3237         setBaseURI("https://data.zqn.wtf/sanuqn/metadata/");
3238 
3239         setUseSingleMetadata(true);
3240         setMetadataTitle("Tere QN");
3241         setMetadataDescription("This is Tere QN NFT!");
3242         setMetadataAttributes("Tere QN");
3243         setImageURI("https://data.zqn.wtf/tereqn/pic/1.gif");//sanuqn
3244 
3245         //CAL initialization
3246         CAL = IContractAllowListProxy(0xdbaa28cBe70aF04EbFB166b1A3E8F8034e5B9FC7);//Ethereum mainnet proxy
3247         //CAL = IContractAllowListProxy(0xb506d7BbE23576b8AAf22477cd9A7FDF08002211);//Goerli testnet proxy
3248 
3249 
3250         //first airdrop
3251         _safeMint(0xC06AAbAD85ecccfa35CFe671D6DF90Ac9D46619b, 500);
3252         _safeMint(0xdEcf4B112d4120B6998e5020a6B4819E490F7db6, 500);
3253 
3254     }
3255 
3256 
3257     //
3258     //withdraw section
3259     //
3260 
3261     address public constant withdrawAddress = 0xdEcf4B112d4120B6998e5020a6B4819E490F7db6;
3262 
3263     function withdraw() public onlyOwner {
3264         (bool os, ) = payable(withdrawAddress).call{value: address(this).balance}('');
3265         require(os);
3266     }
3267 
3268 
3269     //
3270     //mint section
3271     //
3272 
3273     uint256 public cost = 0;
3274     uint256 public maxSupply = 10000;
3275     uint256 public maxMintAmountPerTransaction = 200;
3276     uint256 public publicSaleMaxMintAmountPerAddress = 300;
3277     bool public paused = true;
3278     bool public onlyWhitelisted = true;
3279     bool public mintCount = true;
3280     mapping(address => uint256) public whitelistMintedAmount;
3281     mapping(address => uint256) public publicSaleMintedAmount;
3282 
3283     modifier callerIsUser() {
3284         require(tx.origin == msg.sender, "The caller is another contract.");
3285         _;
3286     }
3287  
3288     //mint with merkle tree
3289     bytes32 public merkleRoot;
3290     function mint(uint256 _mintAmount , uint256 _maxMintAmount , bytes32[] calldata _merkleProof) public payable callerIsUser{
3291         require(!paused, "the contract is paused");
3292         require(0 < _mintAmount, "need to mint at least 1 NFT");
3293         require(_mintAmount <= maxMintAmountPerTransaction, "max mint amount per session exceeded");
3294         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
3295         require(cost * _mintAmount <= msg.value, "insufficient funds");
3296         if(onlyWhitelisted == true) {
3297             bytes32 leaf = keccak256( abi.encodePacked(msg.sender, _maxMintAmount) );
3298             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "user is not whitelisted");
3299             if(mintCount == true){
3300                 require(_mintAmount <= _maxMintAmount - whitelistMintedAmount[msg.sender] , "max NFT per address exceeded");
3301                 whitelistMintedAmount[msg.sender] += _mintAmount;
3302             }
3303         }else{
3304             if(mintCount == true){
3305                 require(_mintAmount <= publicSaleMaxMintAmountPerAddress - publicSaleMintedAmount[msg.sender] , "max NFT per address exceeded");
3306                 publicSaleMintedAmount[msg.sender] += _mintAmount;
3307             }
3308         }
3309         _safeMint(msg.sender, _mintAmount);
3310     }
3311 
3312     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
3313         merkleRoot = _merkleRoot;
3314     }
3315 
3316 
3317 /*
3318     //mint with mapping
3319     mapping(address => uint256) public whitelistUserAmount;
3320     function mint(uint256 _mintAmount ) public payable callerIsUser{
3321         require(!paused, "the contract is paused");
3322         require(0 < _mintAmount, "need to mint at least 1 NFT");
3323         require(_mintAmount <= maxMintAmountPerTransaction, "max mint amount per session exceeded");
3324         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
3325         require(cost * _mintAmount <= msg.value, "insufficient funds");
3326         if(onlyWhitelisted == true) {
3327             require( whitelistUserAmount[msg.sender] != 0 , "user is not whitelisted");
3328             if(mintCount == true){
3329                 require(_mintAmount <= whitelistUserAmount[msg.sender] - whitelistMintedAmount[msg.sender] , "max NFT per address exceeded");
3330                 whitelistMintedAmount[msg.sender] += _mintAmount;
3331             }
3332         }else{
3333             if(mintCount == true){
3334                 require(_mintAmount <= publicSaleMaxMintAmountPerAddress - publicSaleMintedAmount[msg.sender] , "max NFT per address exceeded");
3335                 publicSaleMintedAmount[msg.sender] += _mintAmount;
3336             }
3337         }
3338         _safeMint(msg.sender, _mintAmount);
3339     }
3340 
3341     function setWhitelist(address[] memory addresses, uint256[] memory saleSupplies) public onlyOwner {
3342         require(addresses.length == saleSupplies.length);
3343         for (uint256 i = 0; i < addresses.length; i++) {
3344             whitelistUserAmount[addresses[i]] = saleSupplies[i];
3345         }
3346     }    
3347 */
3348 
3349 
3350     bytes32 public constant AIRDROP_ROLE = keccak256("AIRDROP_ROLE");
3351     function airdropMint(address[] calldata _airdropAddresses , uint256[] memory _UserMintAmount) public {
3352         require(hasRole(AIRDROP_ROLE, msg.sender), "Caller is not a air dropper");
3353         uint256 _mintAmount = 0;
3354         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
3355             _mintAmount += _UserMintAmount[i];
3356         }
3357         require(0 < _mintAmount , "need to mint at least 1 NFT");
3358         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
3359         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
3360             _safeMint(_airdropAddresses[i], _UserMintAmount[i] );
3361         }
3362     }
3363 
3364 
3365     function setMaxSupply(uint256 _maxSupply) public onlyOwner() {
3366         maxSupply = _maxSupply;
3367     }
3368 
3369     function setPublicSaleMaxMintAmountPerAddress(uint256 _publicSaleMaxMintAmountPerAddress) public onlyOwner() {
3370         publicSaleMaxMintAmountPerAddress = _publicSaleMaxMintAmountPerAddress;
3371     }
3372 
3373     function setCost(uint256 _newCost) public onlyOwner {
3374         cost = _newCost;
3375     }
3376 
3377     function setOnlyWhitelisted(bool _state) public onlyOwner {
3378         onlyWhitelisted = _state;
3379     }
3380 
3381     function setMaxMintAmountPerTransaction(uint256 _maxMintAmountPerTransaction) public onlyOwner {
3382         maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
3383     }
3384   
3385     function pause(bool _state) public onlyOwner {
3386         paused = _state;
3387     }
3388 
3389     function setMintCount(bool _state) public onlyOwner {
3390         mintCount = _state;
3391     }
3392  
3393 
3394 
3395     //
3396     //URI section
3397     //
3398 
3399     string public baseURI;
3400     string public baseExtension = ".json";
3401 
3402     function _baseURI() internal view virtual override returns (string memory) {
3403         return baseURI;        
3404     }
3405 
3406     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3407         baseURI = _newBaseURI;
3408     }
3409 
3410     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
3411         baseExtension = _newBaseExtension;
3412     }
3413 
3414 
3415 
3416     //
3417     //interface metadata
3418     //
3419 
3420     iTokenURI public interfaceOfTokenURI;
3421     bool public useInterfaceMetadata = false;
3422 
3423     function setInterfaceOfTokenURI(address _address) public onlyOwner() {
3424         interfaceOfTokenURI = iTokenURI(_address);
3425     }
3426 
3427     function setUseInterfaceMetadata(bool _useInterfaceMetadata) public onlyOwner() {
3428         useInterfaceMetadata = _useInterfaceMetadata;
3429     }
3430 
3431 
3432     //
3433     //single metadata
3434     //
3435 
3436     bool public useSingleMetadata = false;
3437     string public imageURI;
3438     string public metadataTitle;
3439     string public metadataDescription;
3440     string public metadataAttributes;
3441 
3442 
3443     //single image metadata
3444     function setUseSingleMetadata(bool _useSingleMetadata) public onlyOwner() {
3445         useSingleMetadata = _useSingleMetadata;
3446     }
3447     function setMetadataTitle(string memory _metadataTitle) public onlyOwner {
3448         metadataTitle = _metadataTitle;
3449     }
3450     function setMetadataDescription(string memory _metadataDescription) public onlyOwner {
3451         metadataDescription = _metadataDescription;
3452     }
3453     function setMetadataAttributes(string memory _metadataAttributes) public onlyOwner {
3454         metadataAttributes = _metadataAttributes;
3455     }
3456     function setImageURI(string memory _newImageURI) public onlyOwner {
3457         imageURI = _newImageURI;
3458     }
3459 
3460 
3461     //
3462     //token URI
3463     //
3464 
3465     function tokenURI(uint256 tokenId) public view override returns (string memory) {
3466         if (useInterfaceMetadata == true) {
3467             return interfaceOfTokenURI.tokenURI(tokenId);
3468         }
3469         if(useSingleMetadata == true){
3470             return string( abi.encodePacked( 'data:application/json;base64,' , Base64.encode(
3471                 abi.encodePacked(
3472                     '{'
3473                         '"name":"' , metadataTitle ,'",' ,
3474                         '"description":"' , metadataDescription ,  '",' ,
3475                         '"image": "' , imageURI , '",' ,
3476                         '"attributes":[{"trait_type":"type","value":"' , metadataAttributes , '"}]',
3477                     '}'
3478                 )
3479             ) ) );
3480         }
3481         return string(abi.encodePacked(ERC721A.tokenURI(tokenId), baseExtension));
3482     }
3483 
3484 
3485 
3486     //
3487     //burnin' section
3488     //
3489 
3490     bytes32 public constant MINTER_ROLE  = keccak256("MINTER_ROLE");    
3491     function externalMint(address _address , uint256 _amount ) external payable {
3492         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
3493         require( _nextTokenId() -1 + _amount <= maxSupply , "max NFT limit exceeded");
3494         _safeMint( _address, _amount );
3495     }
3496 
3497 
3498 
3499 
3500     //
3501     //viewer section
3502     //
3503 
3504     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
3505         unchecked {
3506             uint256 tokenIdsIdx;
3507             address currOwnershipAddr;
3508             uint256 tokenIdsLength = balanceOf(owner);
3509             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
3510             TokenOwnership memory ownership;
3511             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
3512                 ownership = _ownershipAt(i);
3513                 if (ownership.burned) {
3514                     continue;
3515                 }
3516                 if (ownership.addr != address(0)) {
3517                     currOwnershipAddr = ownership.addr;
3518                 }
3519                 if (currOwnershipAddr == owner) {
3520                     tokenIds[tokenIdsIdx++] = i;
3521                 }
3522             }
3523             return tokenIds;
3524         }
3525     }
3526 
3527 
3528 
3529     //
3530     //sbt section
3531     //
3532 
3533     bool public isSBT = false;
3534 
3535     function setIsSBT(bool _state) public onlyOwner {
3536         isSBT = _state;
3537     }
3538 
3539     function _beforeTokenTransfers( address from, address to, uint256 startTokenId, uint256 quantity) internal virtual override{
3540         require( isSBT == false || from == address(0) || to == address(0x000000000000000000000000000000000000dEaD), "transfer is prohibited");
3541         super._beforeTokenTransfers(from, to, startTokenId, quantity);
3542     }
3543 
3544     function setApprovalForAll(address operator, bool approved) public virtual override {
3545         require( isSBT == false , "setApprovalForAll is prohibited");
3546         super.setApprovalForAll(operator, approved);
3547     }
3548 
3549     function approve(address to, uint256 tokenId) public payable virtual override {
3550         require( isSBT == false , "approve is prohibited");
3551         super.approve(to, tokenId);
3552     }
3553 
3554 
3555 
3556 
3557     //
3558     // royalty section
3559     //
3560 
3561     address public royaltyAddress = 0x40abd10506bC2C62B5Ed6EcD4E97C042afd9927C;
3562     uint96 public royaltyFee = 1000;    // default:10%
3563 
3564     function setRoyaltyFee(uint96 _feeNumerator) public onlyOwner {
3565         royaltyFee = _feeNumerator;         // set Default Royalty._feeNumerator 500 = 5% Royalty
3566         _setDefaultRoyalty(royaltyAddress, royaltyFee);
3567     }
3568 
3569     function setRoyaltyAddress(address _royaltyAddress) public onlyOwner {
3570         royaltyAddress = _royaltyAddress;   //Change the royalty address where royalty payouts are sent
3571         _setDefaultRoyalty(royaltyAddress, royaltyFee);
3572     }
3573 
3574 
3575     //
3576     //override
3577     //
3578 
3579     //for ERC2981,ERC721AntiScam.AccessControl
3580     function supportsInterface(bytes4 interfaceId) public view override(ERC721AntiScam , AccessControl, ERC2981) returns (bool) {
3581         return(
3582             ERC721AntiScam.supportsInterface(interfaceId) || 
3583             AccessControl.supportsInterface(interfaceId) ||
3584             ERC2981.supportsInterface(interfaceId) ||
3585             super.supportsInterface(interfaceId)
3586         );
3587     }
3588 
3589     function _startTokenId() internal view virtual override returns (uint256) {
3590         return 1;
3591     }
3592 
3593 
3594 }