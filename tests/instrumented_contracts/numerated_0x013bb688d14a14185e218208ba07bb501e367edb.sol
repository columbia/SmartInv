1 // File: operator-filter-registry/src/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
10 
11 
12 pragma solidity ^0.8.13;
13 
14 interface IOperatorFilterRegistry {
15     /**
16      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
17      *         true if supplied registrant address is not registered.
18      */
19     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
20 
21     /**
22      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
23      */
24     function register(address registrant) external;
25 
26     /**
27      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
28      */
29     function registerAndSubscribe(address registrant, address subscription) external;
30 
31     /**
32      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
33      *         address without subscribing.
34      */
35     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
36 
37     /**
38      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
39      *         Note that this does not remove any filtered addresses or codeHashes.
40      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
41      */
42     function unregister(address addr) external;
43 
44     /**
45      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
46      */
47     function updateOperator(address registrant, address operator, bool filtered) external;
48 
49     /**
50      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
51      */
52     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
53 
54     /**
55      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
56      */
57     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
58 
59     /**
60      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
61      */
62     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
63 
64     /**
65      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
66      *         subscription if present.
67      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
68      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
69      *         used.
70      */
71     function subscribe(address registrant, address registrantToSubscribe) external;
72 
73     /**
74      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
75      */
76     function unsubscribe(address registrant, bool copyExistingEntries) external;
77 
78     /**
79      * @notice Get the subscription address of a given registrant, if any.
80      */
81     function subscriptionOf(address addr) external returns (address registrant);
82 
83     /**
84      * @notice Get the set of addresses subscribed to a given registrant.
85      *         Note that order is not guaranteed as updates are made.
86      */
87     function subscribers(address registrant) external returns (address[] memory);
88 
89     /**
90      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
91      *         Note that order is not guaranteed as updates are made.
92      */
93     function subscriberAt(address registrant, uint256 index) external returns (address);
94 
95     /**
96      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
97      */
98     function copyEntriesOf(address registrant, address registrantToCopy) external;
99 
100     /**
101      * @notice Returns true if operator is filtered by a given address or its subscription.
102      */
103     function isOperatorFiltered(address registrant, address operator) external returns (bool);
104 
105     /**
106      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
107      */
108     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
109 
110     /**
111      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
112      */
113     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
114 
115     /**
116      * @notice Returns a list of filtered operators for a given address or its subscription.
117      */
118     function filteredOperators(address addr) external returns (address[] memory);
119 
120     /**
121      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
122      *         Note that order is not guaranteed as updates are made.
123      */
124     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
125 
126     /**
127      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
128      *         its subscription.
129      *         Note that order is not guaranteed as updates are made.
130      */
131     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
132 
133     /**
134      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
135      *         its subscription.
136      *         Note that order is not guaranteed as updates are made.
137      */
138     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
139 
140     /**
141      * @notice Returns true if an address has registered
142      */
143     function isRegistered(address addr) external returns (bool);
144 
145     /**
146      * @dev Convenience method to compute the code hash of an arbitrary contract
147      */
148     function codeHashOf(address addr) external returns (bytes32);
149 }
150 
151 // File: operator-filter-registry/src/OperatorFilterer.sol
152 
153 
154 pragma solidity ^0.8.13;
155 
156 
157 /**
158  * @title  OperatorFilterer
159  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
160  *         registrant's entries in the OperatorFilterRegistry.
161  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
162  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
163  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
164  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
165  *         administration methods on the contract itself to interact with the registry otherwise the subscription
166  *         will be locked to the options set during construction.
167  */
168 
169 abstract contract OperatorFilterer {
170     /// @dev Emitted when an operator is not allowed.
171     error OperatorNotAllowed(address operator);
172 
173     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
174         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
175 
176     /// @dev The constructor that is called when the contract is being deployed.
177     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
178         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
179         // will not revert, but the contract will need to be registered with the registry once it is deployed in
180         // order for the modifier to filter addresses.
181         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
182             if (subscribe) {
183                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
184             } else {
185                 if (subscriptionOrRegistrantToCopy != address(0)) {
186                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
187                 } else {
188                     OPERATOR_FILTER_REGISTRY.register(address(this));
189                 }
190             }
191         }
192     }
193 
194     /**
195      * @dev A helper function to check if an operator is allowed.
196      */
197     modifier onlyAllowedOperator(address from) virtual {
198         // Allow spending tokens from addresses with balance
199         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
200         // from an EOA.
201         if (from != msg.sender) {
202             _checkFilterOperator(msg.sender);
203         }
204         _;
205     }
206 
207     /**
208      * @dev A helper function to check if an operator approval is allowed.
209      */
210     modifier onlyAllowedOperatorApproval(address operator) virtual {
211         _checkFilterOperator(operator);
212         _;
213     }
214 
215     /**
216      * @dev A helper function to check if an operator is allowed.
217      */
218     function _checkFilterOperator(address operator) internal view virtual {
219         // Check registry code length to facilitate testing in environments without a deployed registry.
220         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
221             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
222             // may specify their own OperatorFilterRegistry implementations, which may behave differently
223             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
224                 revert OperatorNotAllowed(operator);
225             }
226         }
227     }
228 }
229 
230 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
231 
232 
233 pragma solidity ^0.8.13;
234 
235 
236 /**
237  * @title  DefaultOperatorFilterer
238  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
239  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
240  *         administration methods on the contract itself to interact with the registry otherwise the subscription
241  *         will be locked to the options set during construction.
242  */
243 
244 abstract contract DefaultOperatorFilterer is OperatorFilterer {
245     /// @dev The constructor that is called when the contract is being deployed.
246     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
247 }
248 
249 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
250 
251 
252 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/MerkleProof.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev These functions deal with verification of Merkle Tree proofs.
258  *
259  * The tree and the proofs can be generated using our
260  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
261  * You will find a quickstart guide in the readme.
262  *
263  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
264  * hashing, or use a hash function other than keccak256 for hashing leaves.
265  * This is because the concatenation of a sorted pair of internal nodes in
266  * the merkle tree could be reinterpreted as a leaf value.
267  * OpenZeppelin's JavaScript library generates merkle trees that are safe
268  * against this attack out of the box.
269  */
270 library MerkleProof {
271     /**
272      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
273      * defined by `root`. For this, a `proof` must be provided, containing
274      * sibling hashes on the branch from the leaf to the root of the tree. Each
275      * pair of leaves and each pair of pre-images are assumed to be sorted.
276      */
277     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
278         return processProof(proof, leaf) == root;
279     }
280 
281     /**
282      * @dev Calldata version of {verify}
283      *
284      * _Available since v4.7._
285      */
286     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
287         return processProofCalldata(proof, leaf) == root;
288     }
289 
290     /**
291      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
292      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
293      * hash matches the root of the tree. When processing the proof, the pairs
294      * of leafs & pre-images are assumed to be sorted.
295      *
296      * _Available since v4.4._
297      */
298     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
299         bytes32 computedHash = leaf;
300         for (uint256 i = 0; i < proof.length; i++) {
301             computedHash = _hashPair(computedHash, proof[i]);
302         }
303         return computedHash;
304     }
305 
306     /**
307      * @dev Calldata version of {processProof}
308      *
309      * _Available since v4.7._
310      */
311     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
312         bytes32 computedHash = leaf;
313         for (uint256 i = 0; i < proof.length; i++) {
314             computedHash = _hashPair(computedHash, proof[i]);
315         }
316         return computedHash;
317     }
318 
319     /**
320      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
321      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
322      *
323      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
324      *
325      * _Available since v4.7._
326      */
327     function multiProofVerify(
328         bytes32[] memory proof,
329         bool[] memory proofFlags,
330         bytes32 root,
331         bytes32[] memory leaves
332     ) internal pure returns (bool) {
333         return processMultiProof(proof, proofFlags, leaves) == root;
334     }
335 
336     /**
337      * @dev Calldata version of {multiProofVerify}
338      *
339      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
340      *
341      * _Available since v4.7._
342      */
343     function multiProofVerifyCalldata(
344         bytes32[] calldata proof,
345         bool[] calldata proofFlags,
346         bytes32 root,
347         bytes32[] memory leaves
348     ) internal pure returns (bool) {
349         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
350     }
351 
352     /**
353      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
354      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
355      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
356      * respectively.
357      *
358      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
359      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
360      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
361      *
362      * _Available since v4.7._
363      */
364     function processMultiProof(
365         bytes32[] memory proof,
366         bool[] memory proofFlags,
367         bytes32[] memory leaves
368     ) internal pure returns (bytes32 merkleRoot) {
369         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
370         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
371         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
372         // the merkle tree.
373         uint256 leavesLen = leaves.length;
374         uint256 totalHashes = proofFlags.length;
375 
376         // Check proof validity.
377         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
378 
379         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
380         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
381         bytes32[] memory hashes = new bytes32[](totalHashes);
382         uint256 leafPos = 0;
383         uint256 hashPos = 0;
384         uint256 proofPos = 0;
385         // At each step, we compute the next hash using two values:
386         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
387         //   get the next hash.
388         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
389         //   `proof` array.
390         for (uint256 i = 0; i < totalHashes; i++) {
391             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
392             bytes32 b = proofFlags[i]
393                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
394                 : proof[proofPos++];
395             hashes[i] = _hashPair(a, b);
396         }
397 
398         if (totalHashes > 0) {
399             unchecked {
400                 return hashes[totalHashes - 1];
401             }
402         } else if (leavesLen > 0) {
403             return leaves[0];
404         } else {
405             return proof[0];
406         }
407     }
408 
409     /**
410      * @dev Calldata version of {processMultiProof}.
411      *
412      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
413      *
414      * _Available since v4.7._
415      */
416     function processMultiProofCalldata(
417         bytes32[] calldata proof,
418         bool[] calldata proofFlags,
419         bytes32[] memory leaves
420     ) internal pure returns (bytes32 merkleRoot) {
421         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
422         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
423         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
424         // the merkle tree.
425         uint256 leavesLen = leaves.length;
426         uint256 totalHashes = proofFlags.length;
427 
428         // Check proof validity.
429         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
430 
431         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
432         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
433         bytes32[] memory hashes = new bytes32[](totalHashes);
434         uint256 leafPos = 0;
435         uint256 hashPos = 0;
436         uint256 proofPos = 0;
437         // At each step, we compute the next hash using two values:
438         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
439         //   get the next hash.
440         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
441         //   `proof` array.
442         for (uint256 i = 0; i < totalHashes; i++) {
443             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
444             bytes32 b = proofFlags[i]
445                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
446                 : proof[proofPos++];
447             hashes[i] = _hashPair(a, b);
448         }
449 
450         if (totalHashes > 0) {
451             unchecked {
452                 return hashes[totalHashes - 1];
453             }
454         } else if (leavesLen > 0) {
455             return leaves[0];
456         } else {
457             return proof[0];
458         }
459     }
460 
461     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
462         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
463     }
464 
465     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
466         /// @solidity memory-safe-assembly
467         assembly {
468             mstore(0x00, a)
469             mstore(0x20, b)
470             value := keccak256(0x00, 0x40)
471         }
472     }
473 }
474 
475 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Interface of the ERC165 standard, as defined in the
484  * https://eips.ethereum.org/EIPS/eip-165[EIP].
485  *
486  * Implementers can declare support of contract interfaces, which can then be
487  * queried by others ({ERC165Checker}).
488  *
489  * For an implementation, see {ERC165}.
490  */
491 interface IERC165 {
492     /**
493      * @dev Returns true if this contract implements the interface defined by
494      * `interfaceId`. See the corresponding
495      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
496      * to learn more about how these ids are created.
497      *
498      * This function call must use less than 30 000 gas.
499      */
500     function supportsInterface(bytes4 interfaceId) external view returns (bool);
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
504 
505 
506 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Required interface of an ERC721 compliant contract.
513  */
514 interface IERC721 is IERC165 {
515     /**
516      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
517      */
518     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
519 
520     /**
521      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
522      */
523     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
524 
525     /**
526      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
527      */
528     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
529 
530     /**
531      * @dev Returns the number of tokens in ``owner``'s account.
532      */
533     function balanceOf(address owner) external view returns (uint256 balance);
534 
535     /**
536      * @dev Returns the owner of the `tokenId` token.
537      *
538      * Requirements:
539      *
540      * - `tokenId` must exist.
541      */
542     function ownerOf(uint256 tokenId) external view returns (address owner);
543 
544     /**
545      * @dev Safely transfers `tokenId` token from `from` to `to`.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
554      *
555      * Emits a {Transfer} event.
556      */
557     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
558 
559     /**
560      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
561      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570      *
571      * Emits a {Transfer} event.
572      */
573     function safeTransferFrom(address from, address to, uint256 tokenId) external;
574 
575     /**
576      * @dev Transfers `tokenId` token from `from` to `to`.
577      *
578      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
579      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
580      * understand this adds an external call which potentially creates a reentrancy vulnerability.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must be owned by `from`.
587      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transferFrom(address from, address to, uint256 tokenId) external;
592 
593     /**
594      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
595      * The approval is cleared when the token is transferred.
596      *
597      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
598      *
599      * Requirements:
600      *
601      * - The caller must own the token or be an approved operator.
602      * - `tokenId` must exist.
603      *
604      * Emits an {Approval} event.
605      */
606     function approve(address to, uint256 tokenId) external;
607 
608     /**
609      * @dev Approve or remove `operator` as an operator for the caller.
610      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
611      *
612      * Requirements:
613      *
614      * - The `operator` cannot be the caller.
615      *
616      * Emits an {ApprovalForAll} event.
617      */
618     function setApprovalForAll(address operator, bool approved) external;
619 
620     /**
621      * @dev Returns the account approved for `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function getApproved(uint256 tokenId) external view returns (address operator);
628 
629     /**
630      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
631      *
632      * See {setApprovalForAll}
633      */
634     function isApprovedForAll(address owner, address operator) external view returns (bool);
635 }
636 
637 // File: @openzeppelin/contracts-upgradeable/utils/math/SignedMathUpgradeable.sol
638 
639 
640 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Standard signed math utilities missing in the Solidity language.
646  */
647 library SignedMathUpgradeable {
648     /**
649      * @dev Returns the largest of two signed numbers.
650      */
651     function max(int256 a, int256 b) internal pure returns (int256) {
652         return a > b ? a : b;
653     }
654 
655     /**
656      * @dev Returns the smallest of two signed numbers.
657      */
658     function min(int256 a, int256 b) internal pure returns (int256) {
659         return a < b ? a : b;
660     }
661 
662     /**
663      * @dev Returns the average of two signed numbers without overflow.
664      * The result is rounded towards zero.
665      */
666     function average(int256 a, int256 b) internal pure returns (int256) {
667         // Formula from the book "Hacker's Delight"
668         int256 x = (a & b) + ((a ^ b) >> 1);
669         return x + (int256(uint256(x) >> 255) & (a ^ b));
670     }
671 
672     /**
673      * @dev Returns the absolute unsigned value of a signed value.
674      */
675     function abs(int256 n) internal pure returns (uint256) {
676         unchecked {
677             // must be unchecked in order to support `n = type(int256).min`
678             return uint256(n >= 0 ? n : -n);
679         }
680     }
681 }
682 
683 // File: @openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol
684 
685 
686 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Standard math utilities missing in the Solidity language.
692  */
693 library MathUpgradeable {
694     enum Rounding {
695         Down, // Toward negative infinity
696         Up, // Toward infinity
697         Zero // Toward zero
698     }
699 
700     /**
701      * @dev Returns the largest of two numbers.
702      */
703     function max(uint256 a, uint256 b) internal pure returns (uint256) {
704         return a > b ? a : b;
705     }
706 
707     /**
708      * @dev Returns the smallest of two numbers.
709      */
710     function min(uint256 a, uint256 b) internal pure returns (uint256) {
711         return a < b ? a : b;
712     }
713 
714     /**
715      * @dev Returns the average of two numbers. The result is rounded towards
716      * zero.
717      */
718     function average(uint256 a, uint256 b) internal pure returns (uint256) {
719         // (a + b) / 2 can overflow.
720         return (a & b) + (a ^ b) / 2;
721     }
722 
723     /**
724      * @dev Returns the ceiling of the division of two numbers.
725      *
726      * This differs from standard division with `/` in that it rounds up instead
727      * of rounding down.
728      */
729     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
730         // (a + b - 1) / b can overflow on addition, so we distribute.
731         return a == 0 ? 0 : (a - 1) / b + 1;
732     }
733 
734     /**
735      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
736      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
737      * with further edits by Uniswap Labs also under MIT license.
738      */
739     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
740         unchecked {
741             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
742             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
743             // variables such that product = prod1 * 2^256 + prod0.
744             uint256 prod0; // Least significant 256 bits of the product
745             uint256 prod1; // Most significant 256 bits of the product
746             assembly {
747                 let mm := mulmod(x, y, not(0))
748                 prod0 := mul(x, y)
749                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
750             }
751 
752             // Handle non-overflow cases, 256 by 256 division.
753             if (prod1 == 0) {
754                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
755                 // The surrounding unchecked block does not change this fact.
756                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
757                 return prod0 / denominator;
758             }
759 
760             // Make sure the result is less than 2^256. Also prevents denominator == 0.
761             require(denominator > prod1, "Math: mulDiv overflow");
762 
763             ///////////////////////////////////////////////
764             // 512 by 256 division.
765             ///////////////////////////////////////////////
766 
767             // Make division exact by subtracting the remainder from [prod1 prod0].
768             uint256 remainder;
769             assembly {
770                 // Compute remainder using mulmod.
771                 remainder := mulmod(x, y, denominator)
772 
773                 // Subtract 256 bit number from 512 bit number.
774                 prod1 := sub(prod1, gt(remainder, prod0))
775                 prod0 := sub(prod0, remainder)
776             }
777 
778             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
779             // See https://cs.stackexchange.com/q/138556/92363.
780 
781             // Does not overflow because the denominator cannot be zero at this stage in the function.
782             uint256 twos = denominator & (~denominator + 1);
783             assembly {
784                 // Divide denominator by twos.
785                 denominator := div(denominator, twos)
786 
787                 // Divide [prod1 prod0] by twos.
788                 prod0 := div(prod0, twos)
789 
790                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
791                 twos := add(div(sub(0, twos), twos), 1)
792             }
793 
794             // Shift in bits from prod1 into prod0.
795             prod0 |= prod1 * twos;
796 
797             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
798             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
799             // four bits. That is, denominator * inv = 1 mod 2^4.
800             uint256 inverse = (3 * denominator) ^ 2;
801 
802             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
803             // in modular arithmetic, doubling the correct bits in each step.
804             inverse *= 2 - denominator * inverse; // inverse mod 2^8
805             inverse *= 2 - denominator * inverse; // inverse mod 2^16
806             inverse *= 2 - denominator * inverse; // inverse mod 2^32
807             inverse *= 2 - denominator * inverse; // inverse mod 2^64
808             inverse *= 2 - denominator * inverse; // inverse mod 2^128
809             inverse *= 2 - denominator * inverse; // inverse mod 2^256
810 
811             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
812             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
813             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
814             // is no longer required.
815             result = prod0 * inverse;
816             return result;
817         }
818     }
819 
820     /**
821      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
822      */
823     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
824         uint256 result = mulDiv(x, y, denominator);
825         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
826             result += 1;
827         }
828         return result;
829     }
830 
831     /**
832      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
833      *
834      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
835      */
836     function sqrt(uint256 a) internal pure returns (uint256) {
837         if (a == 0) {
838             return 0;
839         }
840 
841         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
842         //
843         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
844         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
845         //
846         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
847         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
848         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
849         //
850         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
851         uint256 result = 1 << (log2(a) >> 1);
852 
853         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
854         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
855         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
856         // into the expected uint128 result.
857         unchecked {
858             result = (result + a / result) >> 1;
859             result = (result + a / result) >> 1;
860             result = (result + a / result) >> 1;
861             result = (result + a / result) >> 1;
862             result = (result + a / result) >> 1;
863             result = (result + a / result) >> 1;
864             result = (result + a / result) >> 1;
865             return min(result, a / result);
866         }
867     }
868 
869     /**
870      * @notice Calculates sqrt(a), following the selected rounding direction.
871      */
872     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
873         unchecked {
874             uint256 result = sqrt(a);
875             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
876         }
877     }
878 
879     /**
880      * @dev Return the log in base 2, rounded down, of a positive value.
881      * Returns 0 if given 0.
882      */
883     function log2(uint256 value) internal pure returns (uint256) {
884         uint256 result = 0;
885         unchecked {
886             if (value >> 128 > 0) {
887                 value >>= 128;
888                 result += 128;
889             }
890             if (value >> 64 > 0) {
891                 value >>= 64;
892                 result += 64;
893             }
894             if (value >> 32 > 0) {
895                 value >>= 32;
896                 result += 32;
897             }
898             if (value >> 16 > 0) {
899                 value >>= 16;
900                 result += 16;
901             }
902             if (value >> 8 > 0) {
903                 value >>= 8;
904                 result += 8;
905             }
906             if (value >> 4 > 0) {
907                 value >>= 4;
908                 result += 4;
909             }
910             if (value >> 2 > 0) {
911                 value >>= 2;
912                 result += 2;
913             }
914             if (value >> 1 > 0) {
915                 result += 1;
916             }
917         }
918         return result;
919     }
920 
921     /**
922      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
923      * Returns 0 if given 0.
924      */
925     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
926         unchecked {
927             uint256 result = log2(value);
928             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
929         }
930     }
931 
932     /**
933      * @dev Return the log in base 10, rounded down, of a positive value.
934      * Returns 0 if given 0.
935      */
936     function log10(uint256 value) internal pure returns (uint256) {
937         uint256 result = 0;
938         unchecked {
939             if (value >= 10 ** 64) {
940                 value /= 10 ** 64;
941                 result += 64;
942             }
943             if (value >= 10 ** 32) {
944                 value /= 10 ** 32;
945                 result += 32;
946             }
947             if (value >= 10 ** 16) {
948                 value /= 10 ** 16;
949                 result += 16;
950             }
951             if (value >= 10 ** 8) {
952                 value /= 10 ** 8;
953                 result += 8;
954             }
955             if (value >= 10 ** 4) {
956                 value /= 10 ** 4;
957                 result += 4;
958             }
959             if (value >= 10 ** 2) {
960                 value /= 10 ** 2;
961                 result += 2;
962             }
963             if (value >= 10 ** 1) {
964                 result += 1;
965             }
966         }
967         return result;
968     }
969 
970     /**
971      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
972      * Returns 0 if given 0.
973      */
974     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
975         unchecked {
976             uint256 result = log10(value);
977             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
978         }
979     }
980 
981     /**
982      * @dev Return the log in base 256, rounded down, of a positive value.
983      * Returns 0 if given 0.
984      *
985      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
986      */
987     function log256(uint256 value) internal pure returns (uint256) {
988         uint256 result = 0;
989         unchecked {
990             if (value >> 128 > 0) {
991                 value >>= 128;
992                 result += 16;
993             }
994             if (value >> 64 > 0) {
995                 value >>= 64;
996                 result += 8;
997             }
998             if (value >> 32 > 0) {
999                 value >>= 32;
1000                 result += 4;
1001             }
1002             if (value >> 16 > 0) {
1003                 value >>= 16;
1004                 result += 2;
1005             }
1006             if (value >> 8 > 0) {
1007                 result += 1;
1008             }
1009         }
1010         return result;
1011     }
1012 
1013     /**
1014      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
1015      * Returns 0 if given 0.
1016      */
1017     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1018         unchecked {
1019             uint256 result = log256(value);
1020             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1021         }
1022     }
1023 }
1024 
1025 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
1026 
1027 
1028 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
1029 
1030 pragma solidity ^0.8.0;
1031 
1032 
1033 
1034 /**
1035  * @dev String operations.
1036  */
1037 library StringsUpgradeable {
1038     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1039     uint8 private constant _ADDRESS_LENGTH = 20;
1040 
1041     /**
1042      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1043      */
1044     function toString(uint256 value) internal pure returns (string memory) {
1045         unchecked {
1046             uint256 length = MathUpgradeable.log10(value) + 1;
1047             string memory buffer = new string(length);
1048             uint256 ptr;
1049             /// @solidity memory-safe-assembly
1050             assembly {
1051                 ptr := add(buffer, add(32, length))
1052             }
1053             while (true) {
1054                 ptr--;
1055                 /// @solidity memory-safe-assembly
1056                 assembly {
1057                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1058                 }
1059                 value /= 10;
1060                 if (value == 0) break;
1061             }
1062             return buffer;
1063         }
1064     }
1065 
1066     /**
1067      * @dev Converts a `int256` to its ASCII `string` decimal representation.
1068      */
1069     function toString(int256 value) internal pure returns (string memory) {
1070         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMathUpgradeable.abs(value))));
1071     }
1072 
1073     /**
1074      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1075      */
1076     function toHexString(uint256 value) internal pure returns (string memory) {
1077         unchecked {
1078             return toHexString(value, MathUpgradeable.log256(value) + 1);
1079         }
1080     }
1081 
1082     /**
1083      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1084      */
1085     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1086         bytes memory buffer = new bytes(2 * length + 2);
1087         buffer[0] = "0";
1088         buffer[1] = "x";
1089         for (uint256 i = 2 * length + 1; i > 1; --i) {
1090             buffer[i] = _SYMBOLS[value & 0xf];
1091             value >>= 4;
1092         }
1093         require(value == 0, "Strings: hex length insufficient");
1094         return string(buffer);
1095     }
1096 
1097     /**
1098      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1099      */
1100     function toHexString(address addr) internal pure returns (string memory) {
1101         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1102     }
1103 
1104     /**
1105      * @dev Returns true if the two strings are equal.
1106      */
1107     function equal(string memory a, string memory b) internal pure returns (bool) {
1108         return keccak256(bytes(a)) == keccak256(bytes(b));
1109     }
1110 }
1111 
1112 // File: @openzeppelin/contracts/utils/Context.sol
1113 
1114 
1115 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 /**
1120  * @dev Provides information about the current execution context, including the
1121  * sender of the transaction and its data. While these are generally available
1122  * via msg.sender and msg.data, they should not be accessed in such a direct
1123  * manner, since when dealing with meta-transactions the account sending and
1124  * paying for execution may not be the actual sender (as far as an application
1125  * is concerned).
1126  *
1127  * This contract is only required for intermediate, library-like contracts.
1128  */
1129 abstract contract Context {
1130     function _msgSender() internal view virtual returns (address) {
1131         return msg.sender;
1132     }
1133 
1134     function _msgData() internal view virtual returns (bytes calldata) {
1135         return msg.data;
1136     }
1137 }
1138 
1139 // File: @openzeppelin/contracts/access/Ownable.sol
1140 
1141 
1142 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1143 
1144 pragma solidity ^0.8.0;
1145 
1146 
1147 /**
1148  * @dev Contract module which provides a basic access control mechanism, where
1149  * there is an account (an owner) that can be granted exclusive access to
1150  * specific functions.
1151  *
1152  * By default, the owner account will be the one that deploys the contract. This
1153  * can later be changed with {transferOwnership}.
1154  *
1155  * This module is used through inheritance. It will make available the modifier
1156  * `onlyOwner`, which can be applied to your functions to restrict their use to
1157  * the owner.
1158  */
1159 abstract contract Ownable is Context {
1160     address private _owner;
1161 
1162     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1163 
1164     /**
1165      * @dev Initializes the contract setting the deployer as the initial owner.
1166      */
1167     constructor() {
1168         _transferOwnership(_msgSender());
1169     }
1170 
1171     /**
1172      * @dev Throws if called by any account other than the owner.
1173      */
1174     modifier onlyOwner() {
1175         _checkOwner();
1176         _;
1177     }
1178 
1179     /**
1180      * @dev Returns the address of the current owner.
1181      */
1182     function owner() public view virtual returns (address) {
1183         return _owner;
1184     }
1185 
1186     /**
1187      * @dev Throws if the sender is not the owner.
1188      */
1189     function _checkOwner() internal view virtual {
1190         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1191     }
1192 
1193     /**
1194      * @dev Leaves the contract without owner. It will not be possible to call
1195      * `onlyOwner` functions. Can only be called by the current owner.
1196      *
1197      * NOTE: Renouncing ownership will leave the contract without an owner,
1198      * thereby disabling any functionality that is only available to the owner.
1199      */
1200     function renounceOwnership() public virtual onlyOwner {
1201         _transferOwnership(address(0));
1202     }
1203 
1204     /**
1205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1206      * Can only be called by the current owner.
1207      */
1208     function transferOwnership(address newOwner) public virtual onlyOwner {
1209         require(newOwner != address(0), "Ownable: new owner is the zero address");
1210         _transferOwnership(newOwner);
1211     }
1212 
1213     /**
1214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1215      * Internal function without access restriction.
1216      */
1217     function _transferOwnership(address newOwner) internal virtual {
1218         address oldOwner = _owner;
1219         _owner = newOwner;
1220         emit OwnershipTransferred(oldOwner, newOwner);
1221     }
1222 }
1223 
1224 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
1225 
1226 
1227 // ERC721A Contracts v4.2.3
1228 // Creator: Chiru Labs
1229 
1230 pragma solidity ^0.8.4;
1231 
1232 /**
1233  * @dev Interface of ERC721A.
1234  */
1235 interface IERC721A {
1236     /**
1237      * The caller must own the token or be an approved operator.
1238      */
1239     error ApprovalCallerNotOwnerNorApproved();
1240 
1241     /**
1242      * The token does not exist.
1243      */
1244     error ApprovalQueryForNonexistentToken();
1245 
1246     /**
1247      * Cannot query the balance for the zero address.
1248      */
1249     error BalanceQueryForZeroAddress();
1250 
1251     /**
1252      * Cannot mint to the zero address.
1253      */
1254     error MintToZeroAddress();
1255 
1256     /**
1257      * The quantity of tokens minted must be more than zero.
1258      */
1259     error MintZeroQuantity();
1260 
1261     /**
1262      * The token does not exist.
1263      */
1264     error OwnerQueryForNonexistentToken();
1265 
1266     /**
1267      * The caller must own the token or be an approved operator.
1268      */
1269     error TransferCallerNotOwnerNorApproved();
1270 
1271     /**
1272      * The token must be owned by `from`.
1273      */
1274     error TransferFromIncorrectOwner();
1275 
1276     /**
1277      * Cannot safely transfer to a contract that does not implement the
1278      * ERC721Receiver interface.
1279      */
1280     error TransferToNonERC721ReceiverImplementer();
1281 
1282     /**
1283      * Cannot transfer to the zero address.
1284      */
1285     error TransferToZeroAddress();
1286 
1287     /**
1288      * The token does not exist.
1289      */
1290     error URIQueryForNonexistentToken();
1291 
1292     /**
1293      * The `quantity` minted with ERC2309 exceeds the safety limit.
1294      */
1295     error MintERC2309QuantityExceedsLimit();
1296 
1297     /**
1298      * The `extraData` cannot be set on an unintialized ownership slot.
1299      */
1300     error OwnershipNotInitializedForExtraData();
1301 
1302     // =============================================================
1303     //                            STRUCTS
1304     // =============================================================
1305 
1306     struct TokenOwnership {
1307         // The address of the owner.
1308         address addr;
1309         // Stores the start time of ownership with minimal overhead for tokenomics.
1310         uint64 startTimestamp;
1311         // Whether the token has been burned.
1312         bool burned;
1313         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1314         uint24 extraData;
1315     }
1316 
1317     // =============================================================
1318     //                         TOKEN COUNTERS
1319     // =============================================================
1320 
1321     /**
1322      * @dev Returns the total number of tokens in existence.
1323      * Burned tokens will reduce the count.
1324      * To get the total number of tokens minted, please see {_totalMinted}.
1325      */
1326     function totalSupply() external view returns (uint256);
1327 
1328     // =============================================================
1329     //                            IERC165
1330     // =============================================================
1331 
1332     /**
1333      * @dev Returns true if this contract implements the interface defined by
1334      * `interfaceId`. See the corresponding
1335      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1336      * to learn more about how these ids are created.
1337      *
1338      * This function call must use less than 30000 gas.
1339      */
1340     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1341 
1342     // =============================================================
1343     //                            IERC721
1344     // =============================================================
1345 
1346     /**
1347      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1348      */
1349     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1350 
1351     /**
1352      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1353      */
1354     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1355 
1356     /**
1357      * @dev Emitted when `owner` enables or disables
1358      * (`approved`) `operator` to manage all of its assets.
1359      */
1360     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1361 
1362     /**
1363      * @dev Returns the number of tokens in `owner`'s account.
1364      */
1365     function balanceOf(address owner) external view returns (uint256 balance);
1366 
1367     /**
1368      * @dev Returns the owner of the `tokenId` token.
1369      *
1370      * Requirements:
1371      *
1372      * - `tokenId` must exist.
1373      */
1374     function ownerOf(uint256 tokenId) external view returns (address owner);
1375 
1376     /**
1377      * @dev Safely transfers `tokenId` token from `from` to `to`,
1378      * checking first that contract recipients are aware of the ERC721 protocol
1379      * to prevent tokens from being forever locked.
1380      *
1381      * Requirements:
1382      *
1383      * - `from` cannot be the zero address.
1384      * - `to` cannot be the zero address.
1385      * - `tokenId` token must exist and be owned by `from`.
1386      * - If the caller is not `from`, it must be have been allowed to move
1387      * this token by either {approve} or {setApprovalForAll}.
1388      * - If `to` refers to a smart contract, it must implement
1389      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function safeTransferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes calldata data
1398     ) external payable;
1399 
1400     /**
1401      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1402      */
1403     function safeTransferFrom(
1404         address from,
1405         address to,
1406         uint256 tokenId
1407     ) external payable;
1408 
1409     /**
1410      * @dev Transfers `tokenId` from `from` to `to`.
1411      *
1412      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1413      * whenever possible.
1414      *
1415      * Requirements:
1416      *
1417      * - `from` cannot be the zero address.
1418      * - `to` cannot be the zero address.
1419      * - `tokenId` token must be owned by `from`.
1420      * - If the caller is not `from`, it must be approved to move this token
1421      * by either {approve} or {setApprovalForAll}.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function transferFrom(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) external payable;
1430 
1431     /**
1432      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1433      * The approval is cleared when the token is transferred.
1434      *
1435      * Only a single account can be approved at a time, so approving the
1436      * zero address clears previous approvals.
1437      *
1438      * Requirements:
1439      *
1440      * - The caller must own the token or be an approved operator.
1441      * - `tokenId` must exist.
1442      *
1443      * Emits an {Approval} event.
1444      */
1445     function approve(address to, uint256 tokenId) external payable;
1446 
1447     /**
1448      * @dev Approve or remove `operator` as an operator for the caller.
1449      * Operators can call {transferFrom} or {safeTransferFrom}
1450      * for any token owned by the caller.
1451      *
1452      * Requirements:
1453      *
1454      * - The `operator` cannot be the caller.
1455      *
1456      * Emits an {ApprovalForAll} event.
1457      */
1458     function setApprovalForAll(address operator, bool _approved) external;
1459 
1460     /**
1461      * @dev Returns the account approved for `tokenId` token.
1462      *
1463      * Requirements:
1464      *
1465      * - `tokenId` must exist.
1466      */
1467     function getApproved(uint256 tokenId) external view returns (address operator);
1468 
1469     /**
1470      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1471      *
1472      * See {setApprovalForAll}.
1473      */
1474     function isApprovedForAll(address owner, address operator) external view returns (bool);
1475 
1476     // =============================================================
1477     //                        IERC721Metadata
1478     // =============================================================
1479 
1480     /**
1481      * @dev Returns the token collection name.
1482      */
1483     function name() external view returns (string memory);
1484 
1485     /**
1486      * @dev Returns the token collection symbol.
1487      */
1488     function symbol() external view returns (string memory);
1489 
1490     /**
1491      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1492      */
1493     function tokenURI(uint256 tokenId) external view returns (string memory);
1494 
1495     // =============================================================
1496     //                           IERC2309
1497     // =============================================================
1498 
1499     /**
1500      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1501      * (inclusive) is transferred from `from` to `to`, as defined in the
1502      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1503      *
1504      * See {_mintERC2309} for more details.
1505      */
1506     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1507 }
1508 
1509 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1510 
1511 
1512 // ERC721A Contracts v4.2.3
1513 // Creator: Chiru Labs
1514 
1515 pragma solidity ^0.8.4;
1516 
1517 
1518 /**
1519  * @dev Interface of ERC721 token receiver.
1520  */
1521 interface ERC721A__IERC721Receiver {
1522     function onERC721Received(
1523         address operator,
1524         address from,
1525         uint256 tokenId,
1526         bytes calldata data
1527     ) external returns (bytes4);
1528 }
1529 
1530 /**
1531  * @title ERC721A
1532  *
1533  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1534  * Non-Fungible Token Standard, including the Metadata extension.
1535  * Optimized for lower gas during batch mints.
1536  *
1537  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1538  * starting from `_startTokenId()`.
1539  *
1540  * Assumptions:
1541  *
1542  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1543  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1544  */
1545 contract ERC721A is IERC721A {
1546     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1547     struct TokenApprovalRef {
1548         address value;
1549     }
1550 
1551     // =============================================================
1552     //                           CONSTANTS
1553     // =============================================================
1554 
1555     // Mask of an entry in packed address data.
1556     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1557 
1558     // The bit position of `numberMinted` in packed address data.
1559     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1560 
1561     // The bit position of `numberBurned` in packed address data.
1562     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1563 
1564     // The bit position of `aux` in packed address data.
1565     uint256 private constant _BITPOS_AUX = 192;
1566 
1567     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1568     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1569 
1570     // The bit position of `startTimestamp` in packed ownership.
1571     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1572 
1573     // The bit mask of the `burned` bit in packed ownership.
1574     uint256 private constant _BITMASK_BURNED = 1 << 224;
1575 
1576     // The bit position of the `nextInitialized` bit in packed ownership.
1577     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1578 
1579     // The bit mask of the `nextInitialized` bit in packed ownership.
1580     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1581 
1582     // The bit position of `extraData` in packed ownership.
1583     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1584 
1585     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1586     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1587 
1588     // The mask of the lower 160 bits for addresses.
1589     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1590 
1591     // The maximum `quantity` that can be minted with {_mintERC2309}.
1592     // This limit is to prevent overflows on the address data entries.
1593     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1594     // is required to cause an overflow, which is unrealistic.
1595     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1596 
1597     // The `Transfer` event signature is given by:
1598     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1599     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1600         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1601 
1602     // =============================================================
1603     //                            STORAGE
1604     // =============================================================
1605 
1606     // The next token ID to be minted.
1607     uint256 private _currentIndex;
1608 
1609     // The number of tokens burned.
1610     uint256 private _burnCounter;
1611 
1612     // Token name
1613     string private _name;
1614 
1615     // Token symbol
1616     string private _symbol;
1617 
1618     // Mapping from token ID to ownership details
1619     // An empty struct value does not necessarily mean the token is unowned.
1620     // See {_packedOwnershipOf} implementation for details.
1621     //
1622     // Bits Layout:
1623     // - [0..159]   `addr`
1624     // - [160..223] `startTimestamp`
1625     // - [224]      `burned`
1626     // - [225]      `nextInitialized`
1627     // - [232..255] `extraData`
1628     mapping(uint256 => uint256) private _packedOwnerships;
1629 
1630     // Mapping owner address to address data.
1631     //
1632     // Bits Layout:
1633     // - [0..63]    `balance`
1634     // - [64..127]  `numberMinted`
1635     // - [128..191] `numberBurned`
1636     // - [192..255] `aux`
1637     mapping(address => uint256) private _packedAddressData;
1638 
1639     // Mapping from token ID to approved address.
1640     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1641 
1642     // Mapping from owner to operator approvals
1643     mapping(address => mapping(address => bool)) private _operatorApprovals;
1644 
1645     // =============================================================
1646     //                          CONSTRUCTOR
1647     // =============================================================
1648 
1649     constructor(string memory name_, string memory symbol_) {
1650         _name = name_;
1651         _symbol = symbol_;
1652         _currentIndex = _startTokenId();
1653     }
1654 
1655     // =============================================================
1656     //                   TOKEN COUNTING OPERATIONS
1657     // =============================================================
1658 
1659     /**
1660      * @dev Returns the starting token ID.
1661      * To change the starting token ID, please override this function.
1662      */
1663     function _startTokenId() internal view virtual returns (uint256) {
1664         return 0;
1665     }
1666 
1667     /**
1668      * @dev Returns the next token ID to be minted.
1669      */
1670     function _nextTokenId() internal view virtual returns (uint256) {
1671         return _currentIndex;
1672     }
1673 
1674     /**
1675      * @dev Returns the total number of tokens in existence.
1676      * Burned tokens will reduce the count.
1677      * To get the total number of tokens minted, please see {_totalMinted}.
1678      */
1679     function totalSupply() public view virtual override returns (uint256) {
1680         // Counter underflow is impossible as _burnCounter cannot be incremented
1681         // more than `_currentIndex - _startTokenId()` times.
1682         unchecked {
1683             return _currentIndex - _burnCounter - _startTokenId();
1684         }
1685     }
1686 
1687     /**
1688      * @dev Returns the total amount of tokens minted in the contract.
1689      */
1690     function _totalMinted() internal view virtual returns (uint256) {
1691         // Counter underflow is impossible as `_currentIndex` does not decrement,
1692         // and it is initialized to `_startTokenId()`.
1693         unchecked {
1694             return _currentIndex - _startTokenId();
1695         }
1696     }
1697 
1698     /**
1699      * @dev Returns the total number of tokens burned.
1700      */
1701     function _totalBurned() internal view virtual returns (uint256) {
1702         return _burnCounter;
1703     }
1704 
1705     // =============================================================
1706     //                    ADDRESS DATA OPERATIONS
1707     // =============================================================
1708 
1709     /**
1710      * @dev Returns the number of tokens in `owner`'s account.
1711      */
1712     function balanceOf(address owner) public view virtual override returns (uint256) {
1713         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1714         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1715     }
1716 
1717     /**
1718      * Returns the number of tokens minted by `owner`.
1719      */
1720     function _numberMinted(address owner) internal view returns (uint256) {
1721         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1722     }
1723 
1724     /**
1725      * Returns the number of tokens burned by or on behalf of `owner`.
1726      */
1727     function _numberBurned(address owner) internal view returns (uint256) {
1728         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1729     }
1730 
1731     /**
1732      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1733      */
1734     function _getAux(address owner) internal view returns (uint64) {
1735         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1736     }
1737 
1738     /**
1739      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1740      * If there are multiple variables, please pack them into a uint64.
1741      */
1742     function _setAux(address owner, uint64 aux) internal virtual {
1743         uint256 packed = _packedAddressData[owner];
1744         uint256 auxCasted;
1745         // Cast `aux` with assembly to avoid redundant masking.
1746         assembly {
1747             auxCasted := aux
1748         }
1749         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1750         _packedAddressData[owner] = packed;
1751     }
1752 
1753     // =============================================================
1754     //                            IERC165
1755     // =============================================================
1756 
1757     /**
1758      * @dev Returns true if this contract implements the interface defined by
1759      * `interfaceId`. See the corresponding
1760      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1761      * to learn more about how these ids are created.
1762      *
1763      * This function call must use less than 30000 gas.
1764      */
1765     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1766         // The interface IDs are constants representing the first 4 bytes
1767         // of the XOR of all function selectors in the interface.
1768         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1769         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1770         return
1771             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1772             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1773             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1774     }
1775 
1776     // =============================================================
1777     //                        IERC721Metadata
1778     // =============================================================
1779 
1780     /**
1781      * @dev Returns the token collection name.
1782      */
1783     function name() public view virtual override returns (string memory) {
1784         return _name;
1785     }
1786 
1787     /**
1788      * @dev Returns the token collection symbol.
1789      */
1790     function symbol() public view virtual override returns (string memory) {
1791         return _symbol;
1792     }
1793 
1794     /**
1795      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1796      */
1797     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1798         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1799 
1800         string memory baseURI = _baseURI();
1801         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1802     }
1803 
1804     /**
1805      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1806      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1807      * by default, it can be overridden in child contracts.
1808      */
1809     function _baseURI() internal view virtual returns (string memory) {
1810         return '';
1811     }
1812 
1813     // =============================================================
1814     //                     OWNERSHIPS OPERATIONS
1815     // =============================================================
1816 
1817     /**
1818      * @dev Returns the owner of the `tokenId` token.
1819      *
1820      * Requirements:
1821      *
1822      * - `tokenId` must exist.
1823      */
1824     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1825         return address(uint160(_packedOwnershipOf(tokenId)));
1826     }
1827 
1828     /**
1829      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1830      * It gradually moves to O(1) as tokens get transferred around over time.
1831      */
1832     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1833         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1834     }
1835 
1836     /**
1837      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1838      */
1839     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1840         return _unpackedOwnership(_packedOwnerships[index]);
1841     }
1842 
1843     /**
1844      * @dev Returns whether the ownership slot at `index` is initialized.
1845      * An uninitialized slot does not necessarily mean that the slot has no owner.
1846      */
1847     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1848         return _packedOwnerships[index] != 0;
1849     }
1850 
1851     /**
1852      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1853      */
1854     function _initializeOwnershipAt(uint256 index) internal virtual {
1855         if (_packedOwnerships[index] == 0) {
1856             _packedOwnerships[index] = _packedOwnershipOf(index);
1857         }
1858     }
1859 
1860     /**
1861      * Returns the packed ownership data of `tokenId`.
1862      */
1863     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1864         if (_startTokenId() <= tokenId) {
1865             packed = _packedOwnerships[tokenId];
1866             // If the data at the starting slot does not exist, start the scan.
1867             if (packed == 0) {
1868                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1869                 // Invariant:
1870                 // There will always be an initialized ownership slot
1871                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1872                 // before an unintialized ownership slot
1873                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1874                 // Hence, `tokenId` will not underflow.
1875                 //
1876                 // We can directly compare the packed value.
1877                 // If the address is zero, packed will be zero.
1878                 for (;;) {
1879                     unchecked {
1880                         packed = _packedOwnerships[--tokenId];
1881                     }
1882                     if (packed == 0) continue;
1883                     if (packed & _BITMASK_BURNED == 0) return packed;
1884                     // Otherwise, the token is burned, and we must revert.
1885                     // This handles the case of batch burned tokens, where only the burned bit
1886                     // of the starting slot is set, and remaining slots are left uninitialized.
1887                     _revert(OwnerQueryForNonexistentToken.selector);
1888                 }
1889             }
1890             // Otherwise, the data exists and we can skip the scan.
1891             // This is possible because we have already achieved the target condition.
1892             // This saves 2143 gas on transfers of initialized tokens.
1893             // If the token is not burned, return `packed`. Otherwise, revert.
1894             if (packed & _BITMASK_BURNED == 0) return packed;
1895         }
1896         _revert(OwnerQueryForNonexistentToken.selector);
1897     }
1898 
1899     /**
1900      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1901      */
1902     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1903         ownership.addr = address(uint160(packed));
1904         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1905         ownership.burned = packed & _BITMASK_BURNED != 0;
1906         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1907     }
1908 
1909     /**
1910      * @dev Packs ownership data into a single uint256.
1911      */
1912     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1913         assembly {
1914             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1915             owner := and(owner, _BITMASK_ADDRESS)
1916             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1917             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1918         }
1919     }
1920 
1921     /**
1922      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1923      */
1924     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1925         // For branchless setting of the `nextInitialized` flag.
1926         assembly {
1927             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1928             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1929         }
1930     }
1931 
1932     // =============================================================
1933     //                      APPROVAL OPERATIONS
1934     // =============================================================
1935 
1936     /**
1937      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1938      *
1939      * Requirements:
1940      *
1941      * - The caller must own the token or be an approved operator.
1942      */
1943     function approve(address to, uint256 tokenId) public payable virtual override {
1944         _approve(to, tokenId, true);
1945     }
1946 
1947     /**
1948      * @dev Returns the account approved for `tokenId` token.
1949      *
1950      * Requirements:
1951      *
1952      * - `tokenId` must exist.
1953      */
1954     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1955         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1956 
1957         return _tokenApprovals[tokenId].value;
1958     }
1959 
1960     /**
1961      * @dev Approve or remove `operator` as an operator for the caller.
1962      * Operators can call {transferFrom} or {safeTransferFrom}
1963      * for any token owned by the caller.
1964      *
1965      * Requirements:
1966      *
1967      * - The `operator` cannot be the caller.
1968      *
1969      * Emits an {ApprovalForAll} event.
1970      */
1971     function setApprovalForAll(address operator, bool approved) public virtual override {
1972         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1973         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1974     }
1975 
1976     /**
1977      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1978      *
1979      * See {setApprovalForAll}.
1980      */
1981     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1982         return _operatorApprovals[owner][operator];
1983     }
1984 
1985     /**
1986      * @dev Returns whether `tokenId` exists.
1987      *
1988      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1989      *
1990      * Tokens start existing when they are minted. See {_mint}.
1991      */
1992     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1993         if (_startTokenId() <= tokenId) {
1994             if (tokenId < _currentIndex) {
1995                 uint256 packed;
1996                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1997                 result = packed & _BITMASK_BURNED == 0;
1998             }
1999         }
2000     }
2001 
2002     /**
2003      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2004      */
2005     function _isSenderApprovedOrOwner(
2006         address approvedAddress,
2007         address owner,
2008         address msgSender
2009     ) private pure returns (bool result) {
2010         assembly {
2011             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2012             owner := and(owner, _BITMASK_ADDRESS)
2013             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2014             msgSender := and(msgSender, _BITMASK_ADDRESS)
2015             // `msgSender == owner || msgSender == approvedAddress`.
2016             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2017         }
2018     }
2019 
2020     /**
2021      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2022      */
2023     function _getApprovedSlotAndAddress(uint256 tokenId)
2024         private
2025         view
2026         returns (uint256 approvedAddressSlot, address approvedAddress)
2027     {
2028         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2029         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2030         assembly {
2031             approvedAddressSlot := tokenApproval.slot
2032             approvedAddress := sload(approvedAddressSlot)
2033         }
2034     }
2035 
2036     // =============================================================
2037     //                      TRANSFER OPERATIONS
2038     // =============================================================
2039 
2040     /**
2041      * @dev Transfers `tokenId` from `from` to `to`.
2042      *
2043      * Requirements:
2044      *
2045      * - `from` cannot be the zero address.
2046      * - `to` cannot be the zero address.
2047      * - `tokenId` token must be owned by `from`.
2048      * - If the caller is not `from`, it must be approved to move this token
2049      * by either {approve} or {setApprovalForAll}.
2050      *
2051      * Emits a {Transfer} event.
2052      */
2053     function transferFrom(
2054         address from,
2055         address to,
2056         uint256 tokenId
2057     ) public payable virtual override {
2058         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2059 
2060         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
2061         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
2062 
2063         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
2064 
2065         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2066 
2067         // The nested ifs save around 20+ gas over a compound boolean condition.
2068         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2069             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2070 
2071         _beforeTokenTransfers(from, to, tokenId, 1);
2072 
2073         // Clear approvals from the previous owner.
2074         assembly {
2075             if approvedAddress {
2076                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2077                 sstore(approvedAddressSlot, 0)
2078             }
2079         }
2080 
2081         // Underflow of the sender's balance is impossible because we check for
2082         // ownership above and the recipient's balance can't realistically overflow.
2083         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2084         unchecked {
2085             // We can directly increment and decrement the balances.
2086             --_packedAddressData[from]; // Updates: `balance -= 1`.
2087             ++_packedAddressData[to]; // Updates: `balance += 1`.
2088 
2089             // Updates:
2090             // - `address` to the next owner.
2091             // - `startTimestamp` to the timestamp of transfering.
2092             // - `burned` to `false`.
2093             // - `nextInitialized` to `true`.
2094             _packedOwnerships[tokenId] = _packOwnershipData(
2095                 to,
2096                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2097             );
2098 
2099             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2100             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2101                 uint256 nextTokenId = tokenId + 1;
2102                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2103                 if (_packedOwnerships[nextTokenId] == 0) {
2104                     // If the next slot is within bounds.
2105                     if (nextTokenId != _currentIndex) {
2106                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2107                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2108                     }
2109                 }
2110             }
2111         }
2112 
2113         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2114         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2115         assembly {
2116             // Emit the `Transfer` event.
2117             log4(
2118                 0, // Start of data (0, since no data).
2119                 0, // End of data (0, since no data).
2120                 _TRANSFER_EVENT_SIGNATURE, // Signature.
2121                 from, // `from`.
2122                 toMasked, // `to`.
2123                 tokenId // `tokenId`.
2124             )
2125         }
2126         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
2127 
2128         _afterTokenTransfers(from, to, tokenId, 1);
2129     }
2130 
2131     /**
2132      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2133      */
2134     function safeTransferFrom(
2135         address from,
2136         address to,
2137         uint256 tokenId
2138     ) public payable virtual override {
2139         safeTransferFrom(from, to, tokenId, '');
2140     }
2141 
2142     /**
2143      * @dev Safely transfers `tokenId` token from `from` to `to`.
2144      *
2145      * Requirements:
2146      *
2147      * - `from` cannot be the zero address.
2148      * - `to` cannot be the zero address.
2149      * - `tokenId` token must exist and be owned by `from`.
2150      * - If the caller is not `from`, it must be approved to move this token
2151      * by either {approve} or {setApprovalForAll}.
2152      * - If `to` refers to a smart contract, it must implement
2153      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2154      *
2155      * Emits a {Transfer} event.
2156      */
2157     function safeTransferFrom(
2158         address from,
2159         address to,
2160         uint256 tokenId,
2161         bytes memory _data
2162     ) public payable virtual override {
2163         transferFrom(from, to, tokenId);
2164         if (to.code.length != 0)
2165             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2166                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2167             }
2168     }
2169 
2170     /**
2171      * @dev Hook that is called before a set of serially-ordered token IDs
2172      * are about to be transferred. This includes minting.
2173      * And also called before burning one token.
2174      *
2175      * `startTokenId` - the first token ID to be transferred.
2176      * `quantity` - the amount to be transferred.
2177      *
2178      * Calling conditions:
2179      *
2180      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2181      * transferred to `to`.
2182      * - When `from` is zero, `tokenId` will be minted for `to`.
2183      * - When `to` is zero, `tokenId` will be burned by `from`.
2184      * - `from` and `to` are never both zero.
2185      */
2186     function _beforeTokenTransfers(
2187         address from,
2188         address to,
2189         uint256 startTokenId,
2190         uint256 quantity
2191     ) internal virtual {}
2192 
2193     /**
2194      * @dev Hook that is called after a set of serially-ordered token IDs
2195      * have been transferred. This includes minting.
2196      * And also called after one token has been burned.
2197      *
2198      * `startTokenId` - the first token ID to be transferred.
2199      * `quantity` - the amount to be transferred.
2200      *
2201      * Calling conditions:
2202      *
2203      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2204      * transferred to `to`.
2205      * - When `from` is zero, `tokenId` has been minted for `to`.
2206      * - When `to` is zero, `tokenId` has been burned by `from`.
2207      * - `from` and `to` are never both zero.
2208      */
2209     function _afterTokenTransfers(
2210         address from,
2211         address to,
2212         uint256 startTokenId,
2213         uint256 quantity
2214     ) internal virtual {}
2215 
2216     /**
2217      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2218      *
2219      * `from` - Previous owner of the given token ID.
2220      * `to` - Target address that will receive the token.
2221      * `tokenId` - Token ID to be transferred.
2222      * `_data` - Optional data to send along with the call.
2223      *
2224      * Returns whether the call correctly returned the expected magic value.
2225      */
2226     function _checkContractOnERC721Received(
2227         address from,
2228         address to,
2229         uint256 tokenId,
2230         bytes memory _data
2231     ) private returns (bool) {
2232         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2233             bytes4 retval
2234         ) {
2235             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2236         } catch (bytes memory reason) {
2237             if (reason.length == 0) {
2238                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2239             }
2240             assembly {
2241                 revert(add(32, reason), mload(reason))
2242             }
2243         }
2244     }
2245 
2246     // =============================================================
2247     //                        MINT OPERATIONS
2248     // =============================================================
2249 
2250     /**
2251      * @dev Mints `quantity` tokens and transfers them to `to`.
2252      *
2253      * Requirements:
2254      *
2255      * - `to` cannot be the zero address.
2256      * - `quantity` must be greater than 0.
2257      *
2258      * Emits a {Transfer} event for each mint.
2259      */
2260     function _mint(address to, uint256 quantity) internal virtual {
2261         uint256 startTokenId = _currentIndex;
2262         if (quantity == 0) _revert(MintZeroQuantity.selector);
2263 
2264         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2265 
2266         // Overflows are incredibly unrealistic.
2267         // `balance` and `numberMinted` have a maximum limit of 2**64.
2268         // `tokenId` has a maximum limit of 2**256.
2269         unchecked {
2270             // Updates:
2271             // - `address` to the owner.
2272             // - `startTimestamp` to the timestamp of minting.
2273             // - `burned` to `false`.
2274             // - `nextInitialized` to `quantity == 1`.
2275             _packedOwnerships[startTokenId] = _packOwnershipData(
2276                 to,
2277                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2278             );
2279 
2280             // Updates:
2281             // - `balance += quantity`.
2282             // - `numberMinted += quantity`.
2283             //
2284             // We can directly add to the `balance` and `numberMinted`.
2285             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2286 
2287             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2288             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2289 
2290             if (toMasked == 0) _revert(MintToZeroAddress.selector);
2291 
2292             uint256 end = startTokenId + quantity;
2293             uint256 tokenId = startTokenId;
2294 
2295             do {
2296                 assembly {
2297                     // Emit the `Transfer` event.
2298                     log4(
2299                         0, // Start of data (0, since no data).
2300                         0, // End of data (0, since no data).
2301                         _TRANSFER_EVENT_SIGNATURE, // Signature.
2302                         0, // `address(0)`.
2303                         toMasked, // `to`.
2304                         tokenId // `tokenId`.
2305                     )
2306                 }
2307                 // The `!=` check ensures that large values of `quantity`
2308                 // that overflows uint256 will make the loop run out of gas.
2309             } while (++tokenId != end);
2310 
2311             _currentIndex = end;
2312         }
2313         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2314     }
2315 
2316     /**
2317      * @dev Mints `quantity` tokens and transfers them to `to`.
2318      *
2319      * This function is intended for efficient minting only during contract creation.
2320      *
2321      * It emits only one {ConsecutiveTransfer} as defined in
2322      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2323      * instead of a sequence of {Transfer} event(s).
2324      *
2325      * Calling this function outside of contract creation WILL make your contract
2326      * non-compliant with the ERC721 standard.
2327      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2328      * {ConsecutiveTransfer} event is only permissible during contract creation.
2329      *
2330      * Requirements:
2331      *
2332      * - `to` cannot be the zero address.
2333      * - `quantity` must be greater than 0.
2334      *
2335      * Emits a {ConsecutiveTransfer} event.
2336      */
2337     function _mintERC2309(address to, uint256 quantity) internal virtual {
2338         uint256 startTokenId = _currentIndex;
2339         if (to == address(0)) _revert(MintToZeroAddress.selector);
2340         if (quantity == 0) _revert(MintZeroQuantity.selector);
2341         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
2342 
2343         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2344 
2345         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2346         unchecked {
2347             // Updates:
2348             // - `balance += quantity`.
2349             // - `numberMinted += quantity`.
2350             //
2351             // We can directly add to the `balance` and `numberMinted`.
2352             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2353 
2354             // Updates:
2355             // - `address` to the owner.
2356             // - `startTimestamp` to the timestamp of minting.
2357             // - `burned` to `false`.
2358             // - `nextInitialized` to `quantity == 1`.
2359             _packedOwnerships[startTokenId] = _packOwnershipData(
2360                 to,
2361                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2362             );
2363 
2364             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2365 
2366             _currentIndex = startTokenId + quantity;
2367         }
2368         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2369     }
2370 
2371     /**
2372      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2373      *
2374      * Requirements:
2375      *
2376      * - If `to` refers to a smart contract, it must implement
2377      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2378      * - `quantity` must be greater than 0.
2379      *
2380      * See {_mint}.
2381      *
2382      * Emits a {Transfer} event for each mint.
2383      */
2384     function _safeMint(
2385         address to,
2386         uint256 quantity,
2387         bytes memory _data
2388     ) internal virtual {
2389         _mint(to, quantity);
2390 
2391         unchecked {
2392             if (to.code.length != 0) {
2393                 uint256 end = _currentIndex;
2394                 uint256 index = end - quantity;
2395                 do {
2396                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2397                         _revert(TransferToNonERC721ReceiverImplementer.selector);
2398                     }
2399                 } while (index < end);
2400                 // Reentrancy protection.
2401                 if (_currentIndex != end) _revert(bytes4(0));
2402             }
2403         }
2404     }
2405 
2406     /**
2407      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2408      */
2409     function _safeMint(address to, uint256 quantity) internal virtual {
2410         _safeMint(to, quantity, '');
2411     }
2412 
2413     // =============================================================
2414     //                       APPROVAL OPERATIONS
2415     // =============================================================
2416 
2417     /**
2418      * @dev Equivalent to `_approve(to, tokenId, false)`.
2419      */
2420     function _approve(address to, uint256 tokenId) internal virtual {
2421         _approve(to, tokenId, false);
2422     }
2423 
2424     /**
2425      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2426      * The approval is cleared when the token is transferred.
2427      *
2428      * Only a single account can be approved at a time, so approving the
2429      * zero address clears previous approvals.
2430      *
2431      * Requirements:
2432      *
2433      * - `tokenId` must exist.
2434      *
2435      * Emits an {Approval} event.
2436      */
2437     function _approve(
2438         address to,
2439         uint256 tokenId,
2440         bool approvalCheck
2441     ) internal virtual {
2442         address owner = ownerOf(tokenId);
2443 
2444         if (approvalCheck && _msgSenderERC721A() != owner)
2445             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2446                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
2447             }
2448 
2449         _tokenApprovals[tokenId].value = to;
2450         emit Approval(owner, to, tokenId);
2451     }
2452 
2453     // =============================================================
2454     //                        BURN OPERATIONS
2455     // =============================================================
2456 
2457     /**
2458      * @dev Equivalent to `_burn(tokenId, false)`.
2459      */
2460     function _burn(uint256 tokenId) internal virtual {
2461         _burn(tokenId, false);
2462     }
2463 
2464     /**
2465      * @dev Destroys `tokenId`.
2466      * The approval is cleared when the token is burned.
2467      *
2468      * Requirements:
2469      *
2470      * - `tokenId` must exist.
2471      *
2472      * Emits a {Transfer} event.
2473      */
2474     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2475         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2476 
2477         address from = address(uint160(prevOwnershipPacked));
2478 
2479         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2480 
2481         if (approvalCheck) {
2482             // The nested ifs save around 20+ gas over a compound boolean condition.
2483             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2484                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2485         }
2486 
2487         _beforeTokenTransfers(from, address(0), tokenId, 1);
2488 
2489         // Clear approvals from the previous owner.
2490         assembly {
2491             if approvedAddress {
2492                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2493                 sstore(approvedAddressSlot, 0)
2494             }
2495         }
2496 
2497         // Underflow of the sender's balance is impossible because we check for
2498         // ownership above and the recipient's balance can't realistically overflow.
2499         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2500         unchecked {
2501             // Updates:
2502             // - `balance -= 1`.
2503             // - `numberBurned += 1`.
2504             //
2505             // We can directly decrement the balance, and increment the number burned.
2506             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2507             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2508 
2509             // Updates:
2510             // - `address` to the last owner.
2511             // - `startTimestamp` to the timestamp of burning.
2512             // - `burned` to `true`.
2513             // - `nextInitialized` to `true`.
2514             _packedOwnerships[tokenId] = _packOwnershipData(
2515                 from,
2516                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2517             );
2518 
2519             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2520             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2521                 uint256 nextTokenId = tokenId + 1;
2522                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2523                 if (_packedOwnerships[nextTokenId] == 0) {
2524                     // If the next slot is within bounds.
2525                     if (nextTokenId != _currentIndex) {
2526                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2527                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2528                     }
2529                 }
2530             }
2531         }
2532 
2533         emit Transfer(from, address(0), tokenId);
2534         _afterTokenTransfers(from, address(0), tokenId, 1);
2535 
2536         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2537         unchecked {
2538             _burnCounter++;
2539         }
2540     }
2541 
2542     // =============================================================
2543     //                     EXTRA DATA OPERATIONS
2544     // =============================================================
2545 
2546     /**
2547      * @dev Directly sets the extra data for the ownership data `index`.
2548      */
2549     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2550         uint256 packed = _packedOwnerships[index];
2551         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
2552         uint256 extraDataCasted;
2553         // Cast `extraData` with assembly to avoid redundant masking.
2554         assembly {
2555             extraDataCasted := extraData
2556         }
2557         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2558         _packedOwnerships[index] = packed;
2559     }
2560 
2561     /**
2562      * @dev Called during each token transfer to set the 24bit `extraData` field.
2563      * Intended to be overridden by the cosumer contract.
2564      *
2565      * `previousExtraData` - the value of `extraData` before transfer.
2566      *
2567      * Calling conditions:
2568      *
2569      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2570      * transferred to `to`.
2571      * - When `from` is zero, `tokenId` will be minted for `to`.
2572      * - When `to` is zero, `tokenId` will be burned by `from`.
2573      * - `from` and `to` are never both zero.
2574      */
2575     function _extraData(
2576         address from,
2577         address to,
2578         uint24 previousExtraData
2579     ) internal view virtual returns (uint24) {}
2580 
2581     /**
2582      * @dev Returns the next extra data for the packed ownership data.
2583      * The returned result is shifted into position.
2584      */
2585     function _nextExtraData(
2586         address from,
2587         address to,
2588         uint256 prevOwnershipPacked
2589     ) private view returns (uint256) {
2590         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2591         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2592     }
2593 
2594     // =============================================================
2595     //                       OTHER OPERATIONS
2596     // =============================================================
2597 
2598     /**
2599      * @dev Returns the message sender (defaults to `msg.sender`).
2600      *
2601      * If you are writing GSN compatible contracts, you need to override this function.
2602      */
2603     function _msgSenderERC721A() internal view virtual returns (address) {
2604         return msg.sender;
2605     }
2606 
2607     /**
2608      * @dev Converts a uint256 to its ASCII string decimal representation.
2609      */
2610     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2611         assembly {
2612             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2613             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2614             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2615             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2616             let m := add(mload(0x40), 0xa0)
2617             // Update the free memory pointer to allocate.
2618             mstore(0x40, m)
2619             // Assign the `str` to the end.
2620             str := sub(m, 0x20)
2621             // Zeroize the slot after the string.
2622             mstore(str, 0)
2623 
2624             // Cache the end of the memory to calculate the length later.
2625             let end := str
2626 
2627             // We write the string from rightmost digit to leftmost digit.
2628             // The following is essentially a do-while loop that also handles the zero case.
2629             // prettier-ignore
2630             for { let temp := value } 1 {} {
2631                 str := sub(str, 1)
2632                 // Write the character to the pointer.
2633                 // The ASCII index of the '0' character is 48.
2634                 mstore8(str, add(48, mod(temp, 10)))
2635                 // Keep dividing `temp` until zero.
2636                 temp := div(temp, 10)
2637                 // prettier-ignore
2638                 if iszero(temp) { break }
2639             }
2640 
2641             let length := sub(end, str)
2642             // Move the pointer 32 bytes leftwards to make room for the length.
2643             str := sub(str, 0x20)
2644             // Store the length.
2645             mstore(str, length)
2646         }
2647     }
2648 
2649     /**
2650      * @dev For more efficient reverts.
2651      */
2652     function _revert(bytes4 errorSelector) internal pure {
2653         assembly {
2654             mstore(0x00, errorSelector)
2655             revert(0x00, 0x04)
2656         }
2657     }
2658 }
2659 
2660 // File: contracts/Bedtime/BedtimeCreation.sol
2661 
2662 
2663 
2664 pragma solidity ^0.8.19;
2665 
2666 
2667 
2668 
2669 
2670 
2671 
2672 
2673 
2674 contract BedtimeCreation is ERC721A, DefaultOperatorFilterer, Ownable {
2675 
2676     event ClaimEvent(address indexed _from, uint _amount, uint _ts);
2677     using StringsUpgradeable for uint256;
2678     //Goerli 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
2679     //ETH 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
2680     
2681     address public crossmintAddress;
2682     string public baseApiURI;
2683 
2684     //Prices
2685     uint256 public cost =  0.02 ether;
2686     //Referal Payout in $
2687     uint256 public referalPayout = 0 ether;
2688 
2689     uint256 public maxSupply = 10000;
2690     uint256 public mintableSupply = 1000;
2691     uint256 public maxMintAmountPerTransaction = 20;
2692     
2693 
2694     bool public claim = false;
2695     bool public publicSale = true;
2696     bool public payReferal = false;
2697     bool public contractPause = false;
2698     bool public offer = true;
2699 
2700     //Merkle Tree Roots
2701     bytes32 private claimRoot;
2702     
2703 
2704     mapping(address => uint256) public claims;
2705     mapping(uint256 => bool) public jobs;
2706     mapping(address => bool) public externalContract;
2707 
2708     constructor(string memory _baseUrl)
2709         ERC721A("Bedtime Creation", "BCV2")
2710     {
2711         baseApiURI = _baseUrl;
2712         crossmintAddress = 0xdAb1a1854214684acE522439684a145E62505233;
2713        _safeMint(msg.sender, 1);
2714     }
2715 
2716     modifier publicMintCheck(uint256 _mintAmount) {
2717         require(!contractPause, "Contract is Paused");
2718         require(publicSale, "Sale Has Not Started.");
2719         require(_mintAmount > 0, "Mint amount should be greater than 0");
2720         require(
2721             _mintAmount <= maxMintAmountPerTransaction,
2722             "Sorry you cant mint this amount at once"
2723         );
2724 
2725         require(totalSupply() + _mintAmount <= maxSupply, "Exceeds Max Supply");
2726         require(totalSupply() + _mintAmount <= mintableSupply, "Exceeds Max Supply");
2727         _;
2728         
2729     }
2730 
2731     modifier claimcheck(
2732         bytes32[] calldata proof,
2733         uint256 _mintAmount,
2734         uint256 _totalClaimable
2735     ) {
2736         require(!contractPause, "Contract is Paused");
2737         require(claim, "Claims are Paused");
2738         require(_mintAmount > 0, "Mint amount should be greater than 0");
2739         require(
2740             _mintAmount <= maxMintAmountPerTransaction,
2741             "Sorry you cant mint this amount at once"
2742         );
2743 
2744         require(totalSupply() + _mintAmount <= maxSupply, "Exceeds Max Supply");
2745        
2746             require(
2747                 _verify(_leaf(msg.sender, _totalClaimable), proof),
2748                 "Invalid claim proof"
2749             );
2750             require(
2751                 (_mintAmount + claims[msg.sender]) <= _totalClaimable, "You cannot claim more"
2752             );
2753         
2754         _;
2755     }
2756 
2757    
2758 
2759     modifier supplyCheck(uint256 _mintAmount) {
2760         require(_mintAmount > 0, "Mint amount should be greater than 0");
2761         require(totalSupply() + _mintAmount <= maxSupply, "Exceeds Max Supply");
2762         _;
2763     }
2764 
2765     // Verify that a given leaf is in the tree.
2766     function _verify(
2767         bytes32 _leafNode,
2768         bytes32[] memory proof
2769     ) internal view returns (bool) {
2770         return MerkleProof.verify(proof, claimRoot, _leafNode);
2771     }
2772 
2773    
2774 
2775     function _leaf(address account, uint256 _totalClaimable)
2776         internal
2777         pure
2778         returns (bytes32)
2779     {
2780         return keccak256(abi.encodePacked(account, _totalClaimable));
2781     }
2782 
2783     
2784 
2785     //This function will be used to extend the project with more capabilities
2786     function setExternalContract(address _bAddress, bool _val) public onlyOwner {
2787         externalContract[_bAddress] = _val;
2788     }
2789 
2790     //this function can be called only from the extending contract
2791     function mintExternal(address _address, uint256 _mintAmount)
2792         external
2793         supplyCheck(_mintAmount)
2794     {
2795         require(
2796             externalContract[msg.sender],
2797             "Sorry you dont have permission to mint"
2798         );
2799 
2800         _safeMint(_address, _mintAmount);
2801     }
2802 
2803 
2804     function gift(address _to, uint256 _mintAmount)
2805         public
2806         supplyCheck(_mintAmount)
2807         onlyOwner
2808     {
2809         _safeMint(_to, _mintAmount);
2810     }
2811 
2812     function airdrop(address[] memory _airdropAddresses, uint256 _amount)
2813         public
2814         onlyOwner
2815     {
2816         require(
2817             totalSupply() + (_airdropAddresses.length * _amount) <= maxSupply,
2818             "Exceeds Max Supply"
2819         );
2820         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
2821             address to = _airdropAddresses[i];
2822             _safeMint(to, _amount);
2823         }
2824     }
2825 
2826     function _mintCheckingOffer(address _to, uint256 _amount) internal {
2827         if (offer) {
2828             if (_amount >= 20) {
2829                 _safeMint(msg.sender, _amount + 4);
2830             } else if (_amount >= 15) {
2831                 _safeMint(msg.sender, _amount + 3);
2832             } else if (_amount >= 10) {
2833                 _safeMint(msg.sender, _amount + 2);
2834             } else if (_amount >= 5) {
2835                 _safeMint(msg.sender, _amount + 1);
2836             } else {
2837                 _safeMint(msg.sender, _amount);
2838             }
2839         } else {
2840             _safeMint(_to, _amount);
2841         }
2842     }
2843 
2844     function numberMinted(address owner) public view returns (uint256) {
2845         return _numberMinted(owner);
2846     }
2847 
2848     function mint(uint256 _mintAmount, address payable _ref)
2849         external
2850         payable
2851         publicMintCheck(_mintAmount)
2852     {
2853         require(tx.origin == msg.sender, "Not EOA");
2854         if (_ref != 0x0000000000000000000000000000000000000000 && payReferal) {
2855             uint256 refPayoutAmount = referalPayout;
2856             (bool sent, ) = _ref.call{value: _mintAmount * refPayoutAmount}("");
2857             require(sent, "Failed to send to Referer");
2858         }
2859         //check price 
2860           require(msg.value >= cost * _mintAmount, "Insuffient funds");
2861          _mintCheckingOffer(msg.sender, _mintAmount);
2862     }
2863 
2864     //whitelist mint
2865     function claimBedtime(
2866         bytes32[] calldata proof,
2867         uint256 _mintAmount,
2868         uint256 _totalClaimable
2869     ) public  claimcheck(proof, _mintAmount, _totalClaimable) {
2870         claims[msg.sender] += _mintAmount;
2871         _safeMint(msg.sender, _mintAmount);
2872         emit ClaimEvent(msg.sender, _mintAmount, totalSupply());
2873     }
2874 
2875     function crossmint(
2876         address _to,
2877         uint256 _mintAmount,
2878         address payable _ref
2879     ) public payable publicMintCheck(_mintAmount) {
2880         // ethereum (all)  = 0xdab1a1854214684ace522439684a145e62505233
2881         require(
2882             msg.sender == crossmintAddress,
2883             "This function is for Crossmint only."
2884         );
2885       
2886         require(msg.value >= cost * _mintAmount, "Insuffient funds");
2887         if (_ref != 0x0000000000000000000000000000000000000000 && payReferal) {
2888             uint256 refPayoutAmount =  referalPayout;
2889             (bool sent, ) = _ref.call{value: _mintAmount * refPayoutAmount}("");
2890             require(sent, "Failed to send to Referer");
2891         }
2892           _mintCheckingOffer(_to, _mintAmount);
2893     }
2894 
2895     function _baseURI() internal view virtual override returns (string memory) {
2896         return baseApiURI;
2897     }
2898 
2899     function tokenURI(uint256 tokenId)
2900         public
2901         view
2902         virtual
2903         override
2904         returns (string memory)
2905     {
2906         require(
2907             _exists(tokenId),
2908             "ERC721Metadata: URI query for nonexistent token"
2909         );
2910         string memory currentBaseURI = _baseURI();
2911         return
2912             bytes(currentBaseURI).length > 0
2913                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2914                 : "";
2915     }
2916 
2917     function setClaimRoot(bytes32 _root) public onlyOwner {
2918         claimRoot = _root;
2919     }
2920 
2921     function setmaxMintAmountPerTransaction(uint256 _amount) public onlyOwner {
2922         maxMintAmountPerTransaction = _amount;
2923     }
2924 
2925     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2926         baseApiURI = _newBaseURI;
2927     }
2928 
2929     function setSaleStatus(
2930         bool _sale,
2931         bool _claim,
2932         bool _payref,
2933         bool _pause,
2934         bool _offer
2935     ) public onlyOwner {
2936         publicSale = _sale;
2937         claim = _claim;
2938         payReferal = _payref;
2939         contractPause = _pause;
2940         offer = _offer;
2941     }
2942 
2943     function setCrossmintAddress(address _crossmintAddress) public onlyOwner {
2944         crossmintAddress = _crossmintAddress;
2945     }
2946 
2947     
2948 
2949     function setCost(uint256 _cost) external onlyOwner {
2950         cost = _cost;
2951     }
2952 
2953     function setMintableSupply(uint256 _val) external onlyOwner{
2954         mintableSupply = _val;
2955     }
2956 
2957 
2958     //opensea Operator filter overides
2959     function setApprovalForAll(address operator, bool approved)
2960         public
2961         override
2962         onlyAllowedOperatorApproval(operator)
2963     {
2964         super.setApprovalForAll(operator, approved);
2965     }
2966 
2967     function approve(address operator, uint256 tokenId)
2968         public
2969         payable
2970         override
2971         onlyAllowedOperatorApproval(operator)
2972     {
2973         super.approve(operator, tokenId);
2974     }
2975 
2976     function transferFrom(
2977         address from,
2978         address to,
2979         uint256 tokenId
2980     ) public payable override onlyAllowedOperator(from) {
2981         super.transferFrom(from, to, tokenId);
2982     }
2983 
2984     function safeTransferFrom(
2985         address from,
2986         address to,
2987         uint256 tokenId
2988     ) public payable override onlyAllowedOperator(from) {
2989         super.safeTransferFrom(from, to, tokenId);
2990     }
2991 
2992     function safeTransferFrom(
2993         address from,
2994         address to,
2995         uint256 tokenId,
2996         bytes memory data
2997     ) public payable override onlyAllowedOperator(from) {
2998         super.safeTransferFrom(from, to, tokenId, data);
2999     }
3000 
3001     function withdraw() public onlyOwner {
3002         uint256 balance = address(this).balance;
3003         uint256 community = (balance * 40) / 100;
3004         uint256 b = (balance * 30) / 100;
3005         uint256 d = (balance * 15) / 100;
3006 
3007         (bool com, ) = payable(0x9F95737a2aE5B9f5d8969757B1eb3Ef6b7F179FC)
3008             .call{value: community}("");
3009         require(com);
3010 
3011        
3012         (bool os, ) = payable(0x76827cfb4Dc7E574211d20e7B976d697BF572F7A).call{
3013             value: b
3014         }("");
3015         require(os);
3016 
3017         (bool d1, ) = payable(0x4A2e2e750cB9fC6c6cd085269Ceb52Fc79e978c7).call{
3018             value: d
3019         }("");
3020         require(d1);
3021 
3022          (bool d2, ) = payable(0x366587d3648687Bf6743A7002038aE4559ecd0CF).call{
3023             value: d
3024         }("");
3025         require(d2);
3026     }
3027 
3028   
3029 }