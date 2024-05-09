1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Implementation of the {IERC165} interface.
39  *
40  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
41  * for the additional interface id that will be supported. For example:
42  *
43  * ```solidity
44  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
46  * }
47  * ```
48  *
49  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
50  */
51 abstract contract ERC165 is IERC165 {
52     /**
53      * @dev See {IERC165-supportsInterface}.
54      */
55     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
56         return interfaceId == type(IERC165).interfaceId;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 
68 /**
69  * @dev Interface for the NFT Royalty Standard.
70  *
71  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
72  * support for royalty payments across all NFT marketplaces and ecosystem participants.
73  *
74  * _Available since v4.5._
75  */
76 interface IERC2981 is IERC165 {
77     /**
78      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
79      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
80      */
81     function royaltyInfo(uint256 tokenId, uint256 salePrice)
82         external
83         view
84         returns (address receiver, uint256 royaltyAmount);
85 }
86 
87 // File: @openzeppelin/contracts/token/common/ERC2981.sol
88 
89 
90 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 
95 
96 /**
97  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
98  *
99  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
100  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
101  *
102  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
103  * fee is specified in basis points by default.
104  *
105  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
106  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
107  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
108  *
109  * _Available since v4.5._
110  */
111 abstract contract ERC2981 is IERC2981, ERC165 {
112     struct RoyaltyInfo {
113         address receiver;
114         uint96 royaltyFraction;
115     }
116 
117     RoyaltyInfo private _defaultRoyaltyInfo;
118     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
119 
120     /**
121      * @dev See {IERC165-supportsInterface}.
122      */
123     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
124         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
125     }
126 
127     /**
128      * @inheritdoc IERC2981
129      */
130     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
131         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
132 
133         if (royalty.receiver == address(0)) {
134             royalty = _defaultRoyaltyInfo;
135         }
136 
137         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
138 
139         return (royalty.receiver, royaltyAmount);
140     }
141 
142     /**
143      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
144      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
145      * override.
146      */
147     function _feeDenominator() internal pure virtual returns (uint96) {
148         return 10000;
149     }
150 
151     /**
152      * @dev Sets the royalty information that all ids in this contract will default to.
153      *
154      * Requirements:
155      *
156      * - `receiver` cannot be the zero address.
157      * - `feeNumerator` cannot be greater than the fee denominator.
158      */
159     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
160         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
161         require(receiver != address(0), "ERC2981: invalid receiver");
162 
163         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
164     }
165 
166     /**
167      * @dev Removes default royalty information.
168      */
169     function _deleteDefaultRoyalty() internal virtual {
170         delete _defaultRoyaltyInfo;
171     }
172 
173     /**
174      * @dev Sets the royalty information for a specific token id, overriding the global default.
175      *
176      * Requirements:
177      *
178      * - `receiver` cannot be the zero address.
179      * - `feeNumerator` cannot be greater than the fee denominator.
180      */
181     function _setTokenRoyalty(
182         uint256 tokenId,
183         address receiver,
184         uint96 feeNumerator
185     ) internal virtual {
186         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
187         require(receiver != address(0), "ERC2981: Invalid parameters");
188 
189         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
190     }
191 
192     /**
193      * @dev Resets royalty information for the token id back to the global default.
194      */
195     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
196         delete _tokenRoyaltyInfo[tokenId];
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
201 
202 
203 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev These functions deal with verification of Merkle Tree proofs.
209  *
210  * The tree and the proofs can be generated using our
211  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
212  * You will find a quickstart guide in the readme.
213  *
214  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
215  * hashing, or use a hash function other than keccak256 for hashing leaves.
216  * This is because the concatenation of a sorted pair of internal nodes in
217  * the merkle tree could be reinterpreted as a leaf value.
218  * OpenZeppelin's JavaScript library generates merkle trees that are safe
219  * against this attack out of the box.
220  */
221 library MerkleProof {
222     /**
223      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
224      * defined by `root`. For this, a `proof` must be provided, containing
225      * sibling hashes on the branch from the leaf to the root of the tree. Each
226      * pair of leaves and each pair of pre-images are assumed to be sorted.
227      */
228     function verify(
229         bytes32[] memory proof,
230         bytes32 root,
231         bytes32 leaf
232     ) internal pure returns (bool) {
233         return processProof(proof, leaf) == root;
234     }
235 
236     /**
237      * @dev Calldata version of {verify}
238      *
239      * _Available since v4.7._
240      */
241     function verifyCalldata(
242         bytes32[] calldata proof,
243         bytes32 root,
244         bytes32 leaf
245     ) internal pure returns (bool) {
246         return processProofCalldata(proof, leaf) == root;
247     }
248 
249     /**
250      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
251      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
252      * hash matches the root of the tree. When processing the proof, the pairs
253      * of leafs & pre-images are assumed to be sorted.
254      *
255      * _Available since v4.4._
256      */
257     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
258         bytes32 computedHash = leaf;
259         for (uint256 i = 0; i < proof.length; i++) {
260             computedHash = _hashPair(computedHash, proof[i]);
261         }
262         return computedHash;
263     }
264 
265     /**
266      * @dev Calldata version of {processProof}
267      *
268      * _Available since v4.7._
269      */
270     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
271         bytes32 computedHash = leaf;
272         for (uint256 i = 0; i < proof.length; i++) {
273             computedHash = _hashPair(computedHash, proof[i]);
274         }
275         return computedHash;
276     }
277 
278     /**
279      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
280      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
281      *
282      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
283      *
284      * _Available since v4.7._
285      */
286     function multiProofVerify(
287         bytes32[] memory proof,
288         bool[] memory proofFlags,
289         bytes32 root,
290         bytes32[] memory leaves
291     ) internal pure returns (bool) {
292         return processMultiProof(proof, proofFlags, leaves) == root;
293     }
294 
295     /**
296      * @dev Calldata version of {multiProofVerify}
297      *
298      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
299      *
300      * _Available since v4.7._
301      */
302     function multiProofVerifyCalldata(
303         bytes32[] calldata proof,
304         bool[] calldata proofFlags,
305         bytes32 root,
306         bytes32[] memory leaves
307     ) internal pure returns (bool) {
308         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
309     }
310 
311     /**
312      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
313      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
314      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
315      * respectively.
316      *
317      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
318      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
319      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
320      *
321      * _Available since v4.7._
322      */
323     function processMultiProof(
324         bytes32[] memory proof,
325         bool[] memory proofFlags,
326         bytes32[] memory leaves
327     ) internal pure returns (bytes32 merkleRoot) {
328         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
329         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
330         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
331         // the merkle tree.
332         uint256 leavesLen = leaves.length;
333         uint256 totalHashes = proofFlags.length;
334 
335         // Check proof validity.
336         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
337 
338         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
339         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
340         bytes32[] memory hashes = new bytes32[](totalHashes);
341         uint256 leafPos = 0;
342         uint256 hashPos = 0;
343         uint256 proofPos = 0;
344         // At each step, we compute the next hash using two values:
345         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
346         //   get the next hash.
347         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
348         //   `proof` array.
349         for (uint256 i = 0; i < totalHashes; i++) {
350             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
351             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
352             hashes[i] = _hashPair(a, b);
353         }
354 
355         if (totalHashes > 0) {
356             return hashes[totalHashes - 1];
357         } else if (leavesLen > 0) {
358             return leaves[0];
359         } else {
360             return proof[0];
361         }
362     }
363 
364     /**
365      * @dev Calldata version of {processMultiProof}.
366      *
367      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
368      *
369      * _Available since v4.7._
370      */
371     function processMultiProofCalldata(
372         bytes32[] calldata proof,
373         bool[] calldata proofFlags,
374         bytes32[] memory leaves
375     ) internal pure returns (bytes32 merkleRoot) {
376         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
377         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
378         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
379         // the merkle tree.
380         uint256 leavesLen = leaves.length;
381         uint256 totalHashes = proofFlags.length;
382 
383         // Check proof validity.
384         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
385 
386         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
387         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
388         bytes32[] memory hashes = new bytes32[](totalHashes);
389         uint256 leafPos = 0;
390         uint256 hashPos = 0;
391         uint256 proofPos = 0;
392         // At each step, we compute the next hash using two values:
393         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
394         //   get the next hash.
395         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
396         //   `proof` array.
397         for (uint256 i = 0; i < totalHashes; i++) {
398             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
399             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
400             hashes[i] = _hashPair(a, b);
401         }
402 
403         if (totalHashes > 0) {
404             return hashes[totalHashes - 1];
405         } else if (leavesLen > 0) {
406             return leaves[0];
407         } else {
408             return proof[0];
409         }
410     }
411 
412     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
413         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
414     }
415 
416     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
417         /// @solidity memory-safe-assembly
418         assembly {
419             mstore(0x00, a)
420             mstore(0x20, b)
421             value := keccak256(0x00, 0x40)
422         }
423     }
424 }
425 
426 // File: operator-filter-registry/src/lib/Constants.sol
427 
428 
429 pragma solidity ^0.8.17;
430 
431 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
432 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
433 
434 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
435 
436 
437 pragma solidity ^0.8.13;
438 
439 interface IOperatorFilterRegistry {
440     /**
441      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
442      *         true if supplied registrant address is not registered.
443      */
444     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
445 
446     /**
447      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
448      */
449     function register(address registrant) external;
450 
451     /**
452      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
453      */
454     function registerAndSubscribe(address registrant, address subscription) external;
455 
456     /**
457      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
458      *         address without subscribing.
459      */
460     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
461 
462     /**
463      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
464      *         Note that this does not remove any filtered addresses or codeHashes.
465      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
466      */
467     function unregister(address addr) external;
468 
469     /**
470      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
471      */
472     function updateOperator(address registrant, address operator, bool filtered) external;
473 
474     /**
475      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
476      */
477     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
478 
479     /**
480      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
481      */
482     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
483 
484     /**
485      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
486      */
487     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
488 
489     /**
490      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
491      *         subscription if present.
492      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
493      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
494      *         used.
495      */
496     function subscribe(address registrant, address registrantToSubscribe) external;
497 
498     /**
499      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
500      */
501     function unsubscribe(address registrant, bool copyExistingEntries) external;
502 
503     /**
504      * @notice Get the subscription address of a given registrant, if any.
505      */
506     function subscriptionOf(address addr) external returns (address registrant);
507 
508     /**
509      * @notice Get the set of addresses subscribed to a given registrant.
510      *         Note that order is not guaranteed as updates are made.
511      */
512     function subscribers(address registrant) external returns (address[] memory);
513 
514     /**
515      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
516      *         Note that order is not guaranteed as updates are made.
517      */
518     function subscriberAt(address registrant, uint256 index) external returns (address);
519 
520     /**
521      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
522      */
523     function copyEntriesOf(address registrant, address registrantToCopy) external;
524 
525     /**
526      * @notice Returns true if operator is filtered by a given address or its subscription.
527      */
528     function isOperatorFiltered(address registrant, address operator) external returns (bool);
529 
530     /**
531      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
532      */
533     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
534 
535     /**
536      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
537      */
538     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
539 
540     /**
541      * @notice Returns a list of filtered operators for a given address or its subscription.
542      */
543     function filteredOperators(address addr) external returns (address[] memory);
544 
545     /**
546      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
547      *         Note that order is not guaranteed as updates are made.
548      */
549     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
550 
551     /**
552      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
553      *         its subscription.
554      *         Note that order is not guaranteed as updates are made.
555      */
556     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
557 
558     /**
559      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
560      *         its subscription.
561      *         Note that order is not guaranteed as updates are made.
562      */
563     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
564 
565     /**
566      * @notice Returns true if an address has registered
567      */
568     function isRegistered(address addr) external returns (bool);
569 
570     /**
571      * @dev Convenience method to compute the code hash of an arbitrary contract
572      */
573     function codeHashOf(address addr) external returns (bytes32);
574 }
575 
576 // File: operator-filter-registry/src/OperatorFilterer.sol
577 
578 
579 pragma solidity ^0.8.13;
580 
581 
582 /**
583  * @title  OperatorFilterer
584  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
585  *         registrant's entries in the OperatorFilterRegistry.
586  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
587  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
588  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
589  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
590  *         administration methods on the contract itself to interact with the registry otherwise the subscription
591  *         will be locked to the options set during construction.
592  */
593 
594 abstract contract OperatorFilterer {
595     /// @dev Emitted when an operator is not allowed.
596     error OperatorNotAllowed(address operator);
597 
598     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
599         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
600 
601     /// @dev The constructor that is called when the contract is being deployed.
602     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
603         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
604         // will not revert, but the contract will need to be registered with the registry once it is deployed in
605         // order for the modifier to filter addresses.
606         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
607             if (subscribe) {
608                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
609             } else {
610                 if (subscriptionOrRegistrantToCopy != address(0)) {
611                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
612                 } else {
613                     OPERATOR_FILTER_REGISTRY.register(address(this));
614                 }
615             }
616         }
617     }
618 
619     /**
620      * @dev A helper function to check if an operator is allowed.
621      */
622     modifier onlyAllowedOperator(address from) virtual {
623         // Allow spending tokens from addresses with balance
624         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
625         // from an EOA.
626         if (from != msg.sender) {
627             _checkFilterOperator(msg.sender);
628         }
629         _;
630     }
631 
632     /**
633      * @dev A helper function to check if an operator approval is allowed.
634      */
635     modifier onlyAllowedOperatorApproval(address operator) virtual {
636         _checkFilterOperator(operator);
637         _;
638     }
639 
640     /**
641      * @dev A helper function to check if an operator is allowed.
642      */
643     function _checkFilterOperator(address operator) internal view virtual {
644         // Check registry code length to facilitate testing in environments without a deployed registry.
645         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
646             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
647             // may specify their own OperatorFilterRegistry implementations, which may behave differently
648             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
649                 revert OperatorNotAllowed(operator);
650             }
651         }
652     }
653 }
654 
655 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
656 
657 
658 pragma solidity ^0.8.13;
659 
660 
661 /**
662  * @title  DefaultOperatorFilterer
663  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
664  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
665  *         administration methods on the contract itself to interact with the registry otherwise the subscription
666  *         will be locked to the options set during construction.
667  */
668 
669 abstract contract DefaultOperatorFilterer is OperatorFilterer {
670     /// @dev The constructor that is called when the contract is being deployed.
671     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
672 }
673 
674 // File: @openzeppelin/contracts/utils/Context.sol
675 
676 
677 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev Provides information about the current execution context, including the
683  * sender of the transaction and its data. While these are generally available
684  * via msg.sender and msg.data, they should not be accessed in such a direct
685  * manner, since when dealing with meta-transactions the account sending and
686  * paying for execution may not be the actual sender (as far as an application
687  * is concerned).
688  *
689  * This contract is only required for intermediate, library-like contracts.
690  */
691 abstract contract Context {
692     function _msgSender() internal view virtual returns (address) {
693         return msg.sender;
694     }
695 
696     function _msgData() internal view virtual returns (bytes calldata) {
697         return msg.data;
698     }
699 }
700 
701 // File: @openzeppelin/contracts/access/Ownable.sol
702 
703 
704 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @dev Contract module which provides a basic access control mechanism, where
711  * there is an account (an owner) that can be granted exclusive access to
712  * specific functions.
713  *
714  * By default, the owner account will be the one that deploys the contract. This
715  * can later be changed with {transferOwnership}.
716  *
717  * This module is used through inheritance. It will make available the modifier
718  * `onlyOwner`, which can be applied to your functions to restrict their use to
719  * the owner.
720  */
721 abstract contract Ownable is Context {
722     address private _owner;
723 
724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
725 
726     /**
727      * @dev Initializes the contract setting the deployer as the initial owner.
728      */
729     constructor() {
730         _transferOwnership(_msgSender());
731     }
732 
733     /**
734      * @dev Throws if called by any account other than the owner.
735      */
736     modifier onlyOwner() {
737         _checkOwner();
738         _;
739     }
740 
741     /**
742      * @dev Returns the address of the current owner.
743      */
744     function owner() public view virtual returns (address) {
745         return _owner;
746     }
747 
748     /**
749      * @dev Throws if the sender is not the owner.
750      */
751     function _checkOwner() internal view virtual {
752         require(owner() == _msgSender(), "Ownable: caller is not the owner");
753     }
754 
755     /**
756      * @dev Leaves the contract without owner. It will not be possible to call
757      * `onlyOwner` functions anymore. Can only be called by the current owner.
758      *
759      * NOTE: Renouncing ownership will leave the contract without an owner,
760      * thereby removing any functionality that is only available to the owner.
761      */
762     function renounceOwnership() public virtual onlyOwner {
763         _transferOwnership(address(0));
764     }
765 
766     /**
767      * @dev Transfers ownership of the contract to a new account (`newOwner`).
768      * Can only be called by the current owner.
769      */
770     function transferOwnership(address newOwner) public virtual onlyOwner {
771         require(newOwner != address(0), "Ownable: new owner is the zero address");
772         _transferOwnership(newOwner);
773     }
774 
775     /**
776      * @dev Transfers ownership of the contract to a new account (`newOwner`).
777      * Internal function without access restriction.
778      */
779     function _transferOwnership(address newOwner) internal virtual {
780         address oldOwner = _owner;
781         _owner = newOwner;
782         emit OwnershipTransferred(oldOwner, newOwner);
783     }
784 }
785 
786 // File: erc721a/contracts/IERC721A.sol
787 
788 
789 // ERC721A Contracts v4.2.3
790 // Creator: Chiru Labs
791 
792 pragma solidity ^0.8.4;
793 
794 /**
795  * @dev Interface of ERC721A.
796  */
797 interface IERC721A {
798     /**
799      * The caller must own the token or be an approved operator.
800      */
801     error ApprovalCallerNotOwnerNorApproved();
802 
803     /**
804      * The token does not exist.
805      */
806     error ApprovalQueryForNonexistentToken();
807 
808     /**
809      * Cannot query the balance for the zero address.
810      */
811     error BalanceQueryForZeroAddress();
812 
813     /**
814      * Cannot mint to the zero address.
815      */
816     error MintToZeroAddress();
817 
818     /**
819      * The quantity of tokens minted must be more than zero.
820      */
821     error MintZeroQuantity();
822 
823     /**
824      * The token does not exist.
825      */
826     error OwnerQueryForNonexistentToken();
827 
828     /**
829      * The caller must own the token or be an approved operator.
830      */
831     error TransferCallerNotOwnerNorApproved();
832 
833     /**
834      * The token must be owned by `from`.
835      */
836     error TransferFromIncorrectOwner();
837 
838     /**
839      * Cannot safely transfer to a contract that does not implement the
840      * ERC721Receiver interface.
841      */
842     error TransferToNonERC721ReceiverImplementer();
843 
844     /**
845      * Cannot transfer to the zero address.
846      */
847     error TransferToZeroAddress();
848 
849     /**
850      * The token does not exist.
851      */
852     error URIQueryForNonexistentToken();
853 
854     /**
855      * The `quantity` minted with ERC2309 exceeds the safety limit.
856      */
857     error MintERC2309QuantityExceedsLimit();
858 
859     /**
860      * The `extraData` cannot be set on an unintialized ownership slot.
861      */
862     error OwnershipNotInitializedForExtraData();
863 
864     // =============================================================
865     //                            STRUCTS
866     // =============================================================
867 
868     struct TokenOwnership {
869         // The address of the owner.
870         address addr;
871         // Stores the start time of ownership with minimal overhead for tokenomics.
872         uint64 startTimestamp;
873         // Whether the token has been burned.
874         bool burned;
875         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
876         uint24 extraData;
877     }
878 
879     // =============================================================
880     //                         TOKEN COUNTERS
881     // =============================================================
882 
883     /**
884      * @dev Returns the total number of tokens in existence.
885      * Burned tokens will reduce the count.
886      * To get the total number of tokens minted, please see {_totalMinted}.
887      */
888     function totalSupply() external view returns (uint256);
889 
890     // =============================================================
891     //                            IERC165
892     // =============================================================
893 
894     /**
895      * @dev Returns true if this contract implements the interface defined by
896      * `interfaceId`. See the corresponding
897      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
898      * to learn more about how these ids are created.
899      *
900      * This function call must use less than 30000 gas.
901      */
902     function supportsInterface(bytes4 interfaceId) external view returns (bool);
903 
904     // =============================================================
905     //                            IERC721
906     // =============================================================
907 
908     /**
909      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
910      */
911     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
912 
913     /**
914      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
915      */
916     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
917 
918     /**
919      * @dev Emitted when `owner` enables or disables
920      * (`approved`) `operator` to manage all of its assets.
921      */
922     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
923 
924     /**
925      * @dev Returns the number of tokens in `owner`'s account.
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
939      * @dev Safely transfers `tokenId` token from `from` to `to`,
940      * checking first that contract recipients are aware of the ERC721 protocol
941      * to prevent tokens from being forever locked.
942      *
943      * Requirements:
944      *
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must exist and be owned by `from`.
948      * - If the caller is not `from`, it must be have been allowed to move
949      * this token by either {approve} or {setApprovalForAll}.
950      * - If `to` refers to a smart contract, it must implement
951      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes calldata data
960     ) external payable;
961 
962     /**
963      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) external payable;
970 
971     /**
972      * @dev Transfers `tokenId` from `from` to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
975      * whenever possible.
976      *
977      * Requirements:
978      *
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must be owned by `from`.
982      * - If the caller is not `from`, it must be approved to move this token
983      * by either {approve} or {setApprovalForAll}.
984      *
985      * Emits a {Transfer} event.
986      */
987     function transferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) external payable;
992 
993     /**
994      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
995      * The approval is cleared when the token is transferred.
996      *
997      * Only a single account can be approved at a time, so approving the
998      * zero address clears previous approvals.
999      *
1000      * Requirements:
1001      *
1002      * - The caller must own the token or be an approved operator.
1003      * - `tokenId` must exist.
1004      *
1005      * Emits an {Approval} event.
1006      */
1007     function approve(address to, uint256 tokenId) external payable;
1008 
1009     /**
1010      * @dev Approve or remove `operator` as an operator for the caller.
1011      * Operators can call {transferFrom} or {safeTransferFrom}
1012      * for any token owned by the caller.
1013      *
1014      * Requirements:
1015      *
1016      * - The `operator` cannot be the caller.
1017      *
1018      * Emits an {ApprovalForAll} event.
1019      */
1020     function setApprovalForAll(address operator, bool _approved) external;
1021 
1022     /**
1023      * @dev Returns the account approved for `tokenId` token.
1024      *
1025      * Requirements:
1026      *
1027      * - `tokenId` must exist.
1028      */
1029     function getApproved(uint256 tokenId) external view returns (address operator);
1030 
1031     /**
1032      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1033      *
1034      * See {setApprovalForAll}.
1035      */
1036     function isApprovedForAll(address owner, address operator) external view returns (bool);
1037 
1038     // =============================================================
1039     //                        IERC721Metadata
1040     // =============================================================
1041 
1042     /**
1043      * @dev Returns the token collection name.
1044      */
1045     function name() external view returns (string memory);
1046 
1047     /**
1048      * @dev Returns the token collection symbol.
1049      */
1050     function symbol() external view returns (string memory);
1051 
1052     /**
1053      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1054      */
1055     function tokenURI(uint256 tokenId) external view returns (string memory);
1056 
1057     // =============================================================
1058     //                           IERC2309
1059     // =============================================================
1060 
1061     /**
1062      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1063      * (inclusive) is transferred from `from` to `to`, as defined in the
1064      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1065      *
1066      * See {_mintERC2309} for more details.
1067      */
1068     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1069 }
1070 
1071 // File: erc721a/contracts/ERC721A.sol
1072 
1073 
1074 // ERC721A Contracts v4.2.3
1075 // Creator: Chiru Labs
1076 
1077 pragma solidity ^0.8.4;
1078 
1079 
1080 /**
1081  * @dev Interface of ERC721 token receiver.
1082  */
1083 interface ERC721A__IERC721Receiver {
1084     function onERC721Received(
1085         address operator,
1086         address from,
1087         uint256 tokenId,
1088         bytes calldata data
1089     ) external returns (bytes4);
1090 }
1091 
1092 /**
1093  * @title ERC721A
1094  *
1095  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1096  * Non-Fungible Token Standard, including the Metadata extension.
1097  * Optimized for lower gas during batch mints.
1098  *
1099  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1100  * starting from `_startTokenId()`.
1101  *
1102  * Assumptions:
1103  *
1104  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1105  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1106  */
1107 contract ERC721A is IERC721A {
1108     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1109     struct TokenApprovalRef {
1110         address value;
1111     }
1112 
1113     // =============================================================
1114     //                           CONSTANTS
1115     // =============================================================
1116 
1117     // Mask of an entry in packed address data.
1118     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1119 
1120     // The bit position of `numberMinted` in packed address data.
1121     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1122 
1123     // The bit position of `numberBurned` in packed address data.
1124     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1125 
1126     // The bit position of `aux` in packed address data.
1127     uint256 private constant _BITPOS_AUX = 192;
1128 
1129     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1130     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1131 
1132     // The bit position of `startTimestamp` in packed ownership.
1133     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1134 
1135     // The bit mask of the `burned` bit in packed ownership.
1136     uint256 private constant _BITMASK_BURNED = 1 << 224;
1137 
1138     // The bit position of the `nextInitialized` bit in packed ownership.
1139     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1140 
1141     // The bit mask of the `nextInitialized` bit in packed ownership.
1142     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1143 
1144     // The bit position of `extraData` in packed ownership.
1145     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1146 
1147     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1148     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1149 
1150     // The mask of the lower 160 bits for addresses.
1151     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1152 
1153     // The maximum `quantity` that can be minted with {_mintERC2309}.
1154     // This limit is to prevent overflows on the address data entries.
1155     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1156     // is required to cause an overflow, which is unrealistic.
1157     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1158 
1159     // The `Transfer` event signature is given by:
1160     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1161     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1162         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1163 
1164     // =============================================================
1165     //                            STORAGE
1166     // =============================================================
1167 
1168     // The next token ID to be minted.
1169     uint256 private _currentIndex;
1170 
1171     // The number of tokens burned.
1172     uint256 private _burnCounter;
1173 
1174     // Token name
1175     string private _name;
1176 
1177     // Token symbol
1178     string private _symbol;
1179 
1180     // Mapping from token ID to ownership details
1181     // An empty struct value does not necessarily mean the token is unowned.
1182     // See {_packedOwnershipOf} implementation for details.
1183     //
1184     // Bits Layout:
1185     // - [0..159]   `addr`
1186     // - [160..223] `startTimestamp`
1187     // - [224]      `burned`
1188     // - [225]      `nextInitialized`
1189     // - [232..255] `extraData`
1190     mapping(uint256 => uint256) private _packedOwnerships;
1191 
1192     // Mapping owner address to address data.
1193     //
1194     // Bits Layout:
1195     // - [0..63]    `balance`
1196     // - [64..127]  `numberMinted`
1197     // - [128..191] `numberBurned`
1198     // - [192..255] `aux`
1199     mapping(address => uint256) private _packedAddressData;
1200 
1201     // Mapping from token ID to approved address.
1202     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1203 
1204     // Mapping from owner to operator approvals
1205     mapping(address => mapping(address => bool)) private _operatorApprovals;
1206 
1207     // =============================================================
1208     //                          CONSTRUCTOR
1209     // =============================================================
1210 
1211     constructor(string memory name_, string memory symbol_) {
1212         _name = name_;
1213         _symbol = symbol_;
1214         _currentIndex = _startTokenId();
1215     }
1216 
1217     // =============================================================
1218     //                   TOKEN COUNTING OPERATIONS
1219     // =============================================================
1220 
1221     /**
1222      * @dev Returns the starting token ID.
1223      * To change the starting token ID, please override this function.
1224      */
1225     function _startTokenId() internal view virtual returns (uint256) {
1226         return 0;
1227     }
1228 
1229     /**
1230      * @dev Returns the next token ID to be minted.
1231      */
1232     function _nextTokenId() internal view virtual returns (uint256) {
1233         return _currentIndex;
1234     }
1235 
1236     /**
1237      * @dev Returns the total number of tokens in existence.
1238      * Burned tokens will reduce the count.
1239      * To get the total number of tokens minted, please see {_totalMinted}.
1240      */
1241     function totalSupply() public view virtual override returns (uint256) {
1242         // Counter underflow is impossible as _burnCounter cannot be incremented
1243         // more than `_currentIndex - _startTokenId()` times.
1244         unchecked {
1245             return _currentIndex - _burnCounter - _startTokenId();
1246         }
1247     }
1248 
1249     /**
1250      * @dev Returns the total amount of tokens minted in the contract.
1251      */
1252     function _totalMinted() internal view virtual returns (uint256) {
1253         // Counter underflow is impossible as `_currentIndex` does not decrement,
1254         // and it is initialized to `_startTokenId()`.
1255         unchecked {
1256             return _currentIndex - _startTokenId();
1257         }
1258     }
1259 
1260     /**
1261      * @dev Returns the total number of tokens burned.
1262      */
1263     function _totalBurned() internal view virtual returns (uint256) {
1264         return _burnCounter;
1265     }
1266 
1267     // =============================================================
1268     //                    ADDRESS DATA OPERATIONS
1269     // =============================================================
1270 
1271     /**
1272      * @dev Returns the number of tokens in `owner`'s account.
1273      */
1274     function balanceOf(address owner) public view virtual override returns (uint256) {
1275         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1276         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1277     }
1278 
1279     /**
1280      * Returns the number of tokens minted by `owner`.
1281      */
1282     function _numberMinted(address owner) internal view returns (uint256) {
1283         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1284     }
1285 
1286     /**
1287      * Returns the number of tokens burned by or on behalf of `owner`.
1288      */
1289     function _numberBurned(address owner) internal view returns (uint256) {
1290         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1291     }
1292 
1293     /**
1294      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1295      */
1296     function _getAux(address owner) internal view returns (uint64) {
1297         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1298     }
1299 
1300     /**
1301      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1302      * If there are multiple variables, please pack them into a uint64.
1303      */
1304     function _setAux(address owner, uint64 aux) internal virtual {
1305         uint256 packed = _packedAddressData[owner];
1306         uint256 auxCasted;
1307         // Cast `aux` with assembly to avoid redundant masking.
1308         assembly {
1309             auxCasted := aux
1310         }
1311         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1312         _packedAddressData[owner] = packed;
1313     }
1314 
1315     // =============================================================
1316     //                            IERC165
1317     // =============================================================
1318 
1319     /**
1320      * @dev Returns true if this contract implements the interface defined by
1321      * `interfaceId`. See the corresponding
1322      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1323      * to learn more about how these ids are created.
1324      *
1325      * This function call must use less than 30000 gas.
1326      */
1327     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1328         // The interface IDs are constants representing the first 4 bytes
1329         // of the XOR of all function selectors in the interface.
1330         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1331         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1332         return
1333             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1334             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1335             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1336     }
1337 
1338     // =============================================================
1339     //                        IERC721Metadata
1340     // =============================================================
1341 
1342     /**
1343      * @dev Returns the token collection name.
1344      */
1345     function name() public view virtual override returns (string memory) {
1346         return _name;
1347     }
1348 
1349     /**
1350      * @dev Returns the token collection symbol.
1351      */
1352     function symbol() public view virtual override returns (string memory) {
1353         return _symbol;
1354     }
1355 
1356     /**
1357      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1358      */
1359     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1360         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1361 
1362         string memory baseURI = _baseURI();
1363         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1364     }
1365 
1366     /**
1367      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1368      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1369      * by default, it can be overridden in child contracts.
1370      */
1371     function _baseURI() internal view virtual returns (string memory) {
1372         return '';
1373     }
1374 
1375     // =============================================================
1376     //                     OWNERSHIPS OPERATIONS
1377     // =============================================================
1378 
1379     /**
1380      * @dev Returns the owner of the `tokenId` token.
1381      *
1382      * Requirements:
1383      *
1384      * - `tokenId` must exist.
1385      */
1386     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1387         return address(uint160(_packedOwnershipOf(tokenId)));
1388     }
1389 
1390     /**
1391      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1392      * It gradually moves to O(1) as tokens get transferred around over time.
1393      */
1394     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1395         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1396     }
1397 
1398     /**
1399      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1400      */
1401     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1402         return _unpackedOwnership(_packedOwnerships[index]);
1403     }
1404 
1405     /**
1406      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1407      */
1408     function _initializeOwnershipAt(uint256 index) internal virtual {
1409         if (_packedOwnerships[index] == 0) {
1410             _packedOwnerships[index] = _packedOwnershipOf(index);
1411         }
1412     }
1413 
1414     /**
1415      * Returns the packed ownership data of `tokenId`.
1416      */
1417     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1418         uint256 curr = tokenId;
1419 
1420         unchecked {
1421             if (_startTokenId() <= curr)
1422                 if (curr < _currentIndex) {
1423                     uint256 packed = _packedOwnerships[curr];
1424                     // If not burned.
1425                     if (packed & _BITMASK_BURNED == 0) {
1426                         // Invariant:
1427                         // There will always be an initialized ownership slot
1428                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1429                         // before an unintialized ownership slot
1430                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1431                         // Hence, `curr` will not underflow.
1432                         //
1433                         // We can directly compare the packed value.
1434                         // If the address is zero, packed will be zero.
1435                         while (packed == 0) {
1436                             packed = _packedOwnerships[--curr];
1437                         }
1438                         return packed;
1439                     }
1440                 }
1441         }
1442         revert OwnerQueryForNonexistentToken();
1443     }
1444 
1445     /**
1446      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1447      */
1448     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1449         ownership.addr = address(uint160(packed));
1450         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1451         ownership.burned = packed & _BITMASK_BURNED != 0;
1452         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1453     }
1454 
1455     /**
1456      * @dev Packs ownership data into a single uint256.
1457      */
1458     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1459         assembly {
1460             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1461             owner := and(owner, _BITMASK_ADDRESS)
1462             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1463             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1464         }
1465     }
1466 
1467     /**
1468      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1469      */
1470     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1471         // For branchless setting of the `nextInitialized` flag.
1472         assembly {
1473             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1474             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1475         }
1476     }
1477 
1478     // =============================================================
1479     //                      APPROVAL OPERATIONS
1480     // =============================================================
1481 
1482     /**
1483      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1484      * The approval is cleared when the token is transferred.
1485      *
1486      * Only a single account can be approved at a time, so approving the
1487      * zero address clears previous approvals.
1488      *
1489      * Requirements:
1490      *
1491      * - The caller must own the token or be an approved operator.
1492      * - `tokenId` must exist.
1493      *
1494      * Emits an {Approval} event.
1495      */
1496     function approve(address to, uint256 tokenId) public payable virtual override {
1497         address owner = ownerOf(tokenId);
1498 
1499         if (_msgSenderERC721A() != owner)
1500             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1501                 revert ApprovalCallerNotOwnerNorApproved();
1502             }
1503 
1504         _tokenApprovals[tokenId].value = to;
1505         emit Approval(owner, to, tokenId);
1506     }
1507 
1508     /**
1509      * @dev Returns the account approved for `tokenId` token.
1510      *
1511      * Requirements:
1512      *
1513      * - `tokenId` must exist.
1514      */
1515     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1516         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1517 
1518         return _tokenApprovals[tokenId].value;
1519     }
1520 
1521     /**
1522      * @dev Approve or remove `operator` as an operator for the caller.
1523      * Operators can call {transferFrom} or {safeTransferFrom}
1524      * for any token owned by the caller.
1525      *
1526      * Requirements:
1527      *
1528      * - The `operator` cannot be the caller.
1529      *
1530      * Emits an {ApprovalForAll} event.
1531      */
1532     function setApprovalForAll(address operator, bool approved) public virtual override {
1533         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1534         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1535     }
1536 
1537     /**
1538      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1539      *
1540      * See {setApprovalForAll}.
1541      */
1542     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1543         return _operatorApprovals[owner][operator];
1544     }
1545 
1546     /**
1547      * @dev Returns whether `tokenId` exists.
1548      *
1549      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1550      *
1551      * Tokens start existing when they are minted. See {_mint}.
1552      */
1553     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1554         return
1555             _startTokenId() <= tokenId &&
1556             tokenId < _currentIndex && // If within bounds,
1557             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1558     }
1559 
1560     /**
1561      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1562      */
1563     function _isSenderApprovedOrOwner(
1564         address approvedAddress,
1565         address owner,
1566         address msgSender
1567     ) private pure returns (bool result) {
1568         assembly {
1569             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1570             owner := and(owner, _BITMASK_ADDRESS)
1571             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1572             msgSender := and(msgSender, _BITMASK_ADDRESS)
1573             // `msgSender == owner || msgSender == approvedAddress`.
1574             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1575         }
1576     }
1577 
1578     /**
1579      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1580      */
1581     function _getApprovedSlotAndAddress(uint256 tokenId)
1582         private
1583         view
1584         returns (uint256 approvedAddressSlot, address approvedAddress)
1585     {
1586         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1587         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1588         assembly {
1589             approvedAddressSlot := tokenApproval.slot
1590             approvedAddress := sload(approvedAddressSlot)
1591         }
1592     }
1593 
1594     // =============================================================
1595     //                      TRANSFER OPERATIONS
1596     // =============================================================
1597 
1598     /**
1599      * @dev Transfers `tokenId` from `from` to `to`.
1600      *
1601      * Requirements:
1602      *
1603      * - `from` cannot be the zero address.
1604      * - `to` cannot be the zero address.
1605      * - `tokenId` token must be owned by `from`.
1606      * - If the caller is not `from`, it must be approved to move this token
1607      * by either {approve} or {setApprovalForAll}.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function transferFrom(
1612         address from,
1613         address to,
1614         uint256 tokenId
1615     ) public payable virtual override {
1616         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1617 
1618         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1619 
1620         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1621 
1622         // The nested ifs save around 20+ gas over a compound boolean condition.
1623         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1624             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1625 
1626         if (to == address(0)) revert TransferToZeroAddress();
1627 
1628         _beforeTokenTransfers(from, to, tokenId, 1);
1629 
1630         // Clear approvals from the previous owner.
1631         assembly {
1632             if approvedAddress {
1633                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1634                 sstore(approvedAddressSlot, 0)
1635             }
1636         }
1637 
1638         // Underflow of the sender's balance is impossible because we check for
1639         // ownership above and the recipient's balance can't realistically overflow.
1640         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1641         unchecked {
1642             // We can directly increment and decrement the balances.
1643             --_packedAddressData[from]; // Updates: `balance -= 1`.
1644             ++_packedAddressData[to]; // Updates: `balance += 1`.
1645 
1646             // Updates:
1647             // - `address` to the next owner.
1648             // - `startTimestamp` to the timestamp of transfering.
1649             // - `burned` to `false`.
1650             // - `nextInitialized` to `true`.
1651             _packedOwnerships[tokenId] = _packOwnershipData(
1652                 to,
1653                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1654             );
1655 
1656             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1657             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1658                 uint256 nextTokenId = tokenId + 1;
1659                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1660                 if (_packedOwnerships[nextTokenId] == 0) {
1661                     // If the next slot is within bounds.
1662                     if (nextTokenId != _currentIndex) {
1663                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1664                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1665                     }
1666                 }
1667             }
1668         }
1669 
1670         emit Transfer(from, to, tokenId);
1671         _afterTokenTransfers(from, to, tokenId, 1);
1672     }
1673 
1674     /**
1675      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1676      */
1677     function safeTransferFrom(
1678         address from,
1679         address to,
1680         uint256 tokenId
1681     ) public payable virtual override {
1682         safeTransferFrom(from, to, tokenId, '');
1683     }
1684 
1685     /**
1686      * @dev Safely transfers `tokenId` token from `from` to `to`.
1687      *
1688      * Requirements:
1689      *
1690      * - `from` cannot be the zero address.
1691      * - `to` cannot be the zero address.
1692      * - `tokenId` token must exist and be owned by `from`.
1693      * - If the caller is not `from`, it must be approved to move this token
1694      * by either {approve} or {setApprovalForAll}.
1695      * - If `to` refers to a smart contract, it must implement
1696      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1697      *
1698      * Emits a {Transfer} event.
1699      */
1700     function safeTransferFrom(
1701         address from,
1702         address to,
1703         uint256 tokenId,
1704         bytes memory _data
1705     ) public payable virtual override {
1706         transferFrom(from, to, tokenId);
1707         if (to.code.length != 0)
1708             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1709                 revert TransferToNonERC721ReceiverImplementer();
1710             }
1711     }
1712 
1713     /**
1714      * @dev Hook that is called before a set of serially-ordered token IDs
1715      * are about to be transferred. This includes minting.
1716      * And also called before burning one token.
1717      *
1718      * `startTokenId` - the first token ID to be transferred.
1719      * `quantity` - the amount to be transferred.
1720      *
1721      * Calling conditions:
1722      *
1723      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1724      * transferred to `to`.
1725      * - When `from` is zero, `tokenId` will be minted for `to`.
1726      * - When `to` is zero, `tokenId` will be burned by `from`.
1727      * - `from` and `to` are never both zero.
1728      */
1729     function _beforeTokenTransfers(
1730         address from,
1731         address to,
1732         uint256 startTokenId,
1733         uint256 quantity
1734     ) internal virtual {}
1735 
1736     /**
1737      * @dev Hook that is called after a set of serially-ordered token IDs
1738      * have been transferred. This includes minting.
1739      * And also called after one token has been burned.
1740      *
1741      * `startTokenId` - the first token ID to be transferred.
1742      * `quantity` - the amount to be transferred.
1743      *
1744      * Calling conditions:
1745      *
1746      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1747      * transferred to `to`.
1748      * - When `from` is zero, `tokenId` has been minted for `to`.
1749      * - When `to` is zero, `tokenId` has been burned by `from`.
1750      * - `from` and `to` are never both zero.
1751      */
1752     function _afterTokenTransfers(
1753         address from,
1754         address to,
1755         uint256 startTokenId,
1756         uint256 quantity
1757     ) internal virtual {}
1758 
1759     /**
1760      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1761      *
1762      * `from` - Previous owner of the given token ID.
1763      * `to` - Target address that will receive the token.
1764      * `tokenId` - Token ID to be transferred.
1765      * `_data` - Optional data to send along with the call.
1766      *
1767      * Returns whether the call correctly returned the expected magic value.
1768      */
1769     function _checkContractOnERC721Received(
1770         address from,
1771         address to,
1772         uint256 tokenId,
1773         bytes memory _data
1774     ) private returns (bool) {
1775         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1776             bytes4 retval
1777         ) {
1778             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1779         } catch (bytes memory reason) {
1780             if (reason.length == 0) {
1781                 revert TransferToNonERC721ReceiverImplementer();
1782             } else {
1783                 assembly {
1784                     revert(add(32, reason), mload(reason))
1785                 }
1786             }
1787         }
1788     }
1789 
1790     // =============================================================
1791     //                        MINT OPERATIONS
1792     // =============================================================
1793 
1794     /**
1795      * @dev Mints `quantity` tokens and transfers them to `to`.
1796      *
1797      * Requirements:
1798      *
1799      * - `to` cannot be the zero address.
1800      * - `quantity` must be greater than 0.
1801      *
1802      * Emits a {Transfer} event for each mint.
1803      */
1804     function _mint(address to, uint256 quantity) internal virtual {
1805         uint256 startTokenId = _currentIndex;
1806         if (quantity == 0) revert MintZeroQuantity();
1807 
1808         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1809 
1810         // Overflows are incredibly unrealistic.
1811         // `balance` and `numberMinted` have a maximum limit of 2**64.
1812         // `tokenId` has a maximum limit of 2**256.
1813         unchecked {
1814             // Updates:
1815             // - `balance += quantity`.
1816             // - `numberMinted += quantity`.
1817             //
1818             // We can directly add to the `balance` and `numberMinted`.
1819             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1820 
1821             // Updates:
1822             // - `address` to the owner.
1823             // - `startTimestamp` to the timestamp of minting.
1824             // - `burned` to `false`.
1825             // - `nextInitialized` to `quantity == 1`.
1826             _packedOwnerships[startTokenId] = _packOwnershipData(
1827                 to,
1828                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1829             );
1830 
1831             uint256 toMasked;
1832             uint256 end = startTokenId + quantity;
1833 
1834             // Use assembly to loop and emit the `Transfer` event for gas savings.
1835             // The duplicated `log4` removes an extra check and reduces stack juggling.
1836             // The assembly, together with the surrounding Solidity code, have been
1837             // delicately arranged to nudge the compiler into producing optimized opcodes.
1838             assembly {
1839                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1840                 toMasked := and(to, _BITMASK_ADDRESS)
1841                 // Emit the `Transfer` event.
1842                 log4(
1843                     0, // Start of data (0, since no data).
1844                     0, // End of data (0, since no data).
1845                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1846                     0, // `address(0)`.
1847                     toMasked, // `to`.
1848                     startTokenId // `tokenId`.
1849                 )
1850 
1851                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1852                 // that overflows uint256 will make the loop run out of gas.
1853                 // The compiler will optimize the `iszero` away for performance.
1854                 for {
1855                     let tokenId := add(startTokenId, 1)
1856                 } iszero(eq(tokenId, end)) {
1857                     tokenId := add(tokenId, 1)
1858                 } {
1859                     // Emit the `Transfer` event. Similar to above.
1860                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1861                 }
1862             }
1863             if (toMasked == 0) revert MintToZeroAddress();
1864 
1865             _currentIndex = end;
1866         }
1867         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1868     }
1869 
1870     /**
1871      * @dev Mints `quantity` tokens and transfers them to `to`.
1872      *
1873      * This function is intended for efficient minting only during contract creation.
1874      *
1875      * It emits only one {ConsecutiveTransfer} as defined in
1876      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1877      * instead of a sequence of {Transfer} event(s).
1878      *
1879      * Calling this function outside of contract creation WILL make your contract
1880      * non-compliant with the ERC721 standard.
1881      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1882      * {ConsecutiveTransfer} event is only permissible during contract creation.
1883      *
1884      * Requirements:
1885      *
1886      * - `to` cannot be the zero address.
1887      * - `quantity` must be greater than 0.
1888      *
1889      * Emits a {ConsecutiveTransfer} event.
1890      */
1891     function _mintERC2309(address to, uint256 quantity) internal virtual {
1892         uint256 startTokenId = _currentIndex;
1893         if (to == address(0)) revert MintToZeroAddress();
1894         if (quantity == 0) revert MintZeroQuantity();
1895         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1896 
1897         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1898 
1899         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1900         unchecked {
1901             // Updates:
1902             // - `balance += quantity`.
1903             // - `numberMinted += quantity`.
1904             //
1905             // We can directly add to the `balance` and `numberMinted`.
1906             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1907 
1908             // Updates:
1909             // - `address` to the owner.
1910             // - `startTimestamp` to the timestamp of minting.
1911             // - `burned` to `false`.
1912             // - `nextInitialized` to `quantity == 1`.
1913             _packedOwnerships[startTokenId] = _packOwnershipData(
1914                 to,
1915                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1916             );
1917 
1918             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1919 
1920             _currentIndex = startTokenId + quantity;
1921         }
1922         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1923     }
1924 
1925     /**
1926      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1927      *
1928      * Requirements:
1929      *
1930      * - If `to` refers to a smart contract, it must implement
1931      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1932      * - `quantity` must be greater than 0.
1933      *
1934      * See {_mint}.
1935      *
1936      * Emits a {Transfer} event for each mint.
1937      */
1938     function _safeMint(
1939         address to,
1940         uint256 quantity,
1941         bytes memory _data
1942     ) internal virtual {
1943         _mint(to, quantity);
1944 
1945         unchecked {
1946             if (to.code.length != 0) {
1947                 uint256 end = _currentIndex;
1948                 uint256 index = end - quantity;
1949                 do {
1950                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1951                         revert TransferToNonERC721ReceiverImplementer();
1952                     }
1953                 } while (index < end);
1954                 // Reentrancy protection.
1955                 if (_currentIndex != end) revert();
1956             }
1957         }
1958     }
1959 
1960     /**
1961      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1962      */
1963     function _safeMint(address to, uint256 quantity) internal virtual {
1964         _safeMint(to, quantity, '');
1965     }
1966 
1967     // =============================================================
1968     //                        BURN OPERATIONS
1969     // =============================================================
1970 
1971     /**
1972      * @dev Equivalent to `_burn(tokenId, false)`.
1973      */
1974     function _burn(uint256 tokenId) internal virtual {
1975         _burn(tokenId, false);
1976     }
1977 
1978     /**
1979      * @dev Destroys `tokenId`.
1980      * The approval is cleared when the token is burned.
1981      *
1982      * Requirements:
1983      *
1984      * - `tokenId` must exist.
1985      *
1986      * Emits a {Transfer} event.
1987      */
1988     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1989         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1990 
1991         address from = address(uint160(prevOwnershipPacked));
1992 
1993         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1994 
1995         if (approvalCheck) {
1996             // The nested ifs save around 20+ gas over a compound boolean condition.
1997             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1998                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1999         }
2000 
2001         _beforeTokenTransfers(from, address(0), tokenId, 1);
2002 
2003         // Clear approvals from the previous owner.
2004         assembly {
2005             if approvedAddress {
2006                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2007                 sstore(approvedAddressSlot, 0)
2008             }
2009         }
2010 
2011         // Underflow of the sender's balance is impossible because we check for
2012         // ownership above and the recipient's balance can't realistically overflow.
2013         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2014         unchecked {
2015             // Updates:
2016             // - `balance -= 1`.
2017             // - `numberBurned += 1`.
2018             //
2019             // We can directly decrement the balance, and increment the number burned.
2020             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2021             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2022 
2023             // Updates:
2024             // - `address` to the last owner.
2025             // - `startTimestamp` to the timestamp of burning.
2026             // - `burned` to `true`.
2027             // - `nextInitialized` to `true`.
2028             _packedOwnerships[tokenId] = _packOwnershipData(
2029                 from,
2030                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2031             );
2032 
2033             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2034             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2035                 uint256 nextTokenId = tokenId + 1;
2036                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2037                 if (_packedOwnerships[nextTokenId] == 0) {
2038                     // If the next slot is within bounds.
2039                     if (nextTokenId != _currentIndex) {
2040                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2041                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2042                     }
2043                 }
2044             }
2045         }
2046 
2047         emit Transfer(from, address(0), tokenId);
2048         _afterTokenTransfers(from, address(0), tokenId, 1);
2049 
2050         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2051         unchecked {
2052             _burnCounter++;
2053         }
2054     }
2055 
2056     // =============================================================
2057     //                     EXTRA DATA OPERATIONS
2058     // =============================================================
2059 
2060     /**
2061      * @dev Directly sets the extra data for the ownership data `index`.
2062      */
2063     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2064         uint256 packed = _packedOwnerships[index];
2065         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2066         uint256 extraDataCasted;
2067         // Cast `extraData` with assembly to avoid redundant masking.
2068         assembly {
2069             extraDataCasted := extraData
2070         }
2071         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2072         _packedOwnerships[index] = packed;
2073     }
2074 
2075     /**
2076      * @dev Called during each token transfer to set the 24bit `extraData` field.
2077      * Intended to be overridden by the cosumer contract.
2078      *
2079      * `previousExtraData` - the value of `extraData` before transfer.
2080      *
2081      * Calling conditions:
2082      *
2083      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2084      * transferred to `to`.
2085      * - When `from` is zero, `tokenId` will be minted for `to`.
2086      * - When `to` is zero, `tokenId` will be burned by `from`.
2087      * - `from` and `to` are never both zero.
2088      */
2089     function _extraData(
2090         address from,
2091         address to,
2092         uint24 previousExtraData
2093     ) internal view virtual returns (uint24) {}
2094 
2095     /**
2096      * @dev Returns the next extra data for the packed ownership data.
2097      * The returned result is shifted into position.
2098      */
2099     function _nextExtraData(
2100         address from,
2101         address to,
2102         uint256 prevOwnershipPacked
2103     ) private view returns (uint256) {
2104         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2105         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2106     }
2107 
2108     // =============================================================
2109     //                       OTHER OPERATIONS
2110     // =============================================================
2111 
2112     /**
2113      * @dev Returns the message sender (defaults to `msg.sender`).
2114      *
2115      * If you are writing GSN compatible contracts, you need to override this function.
2116      */
2117     function _msgSenderERC721A() internal view virtual returns (address) {
2118         return msg.sender;
2119     }
2120 
2121     /**
2122      * @dev Converts a uint256 to its ASCII string decimal representation.
2123      */
2124     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2125         assembly {
2126             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2127             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2128             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2129             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2130             let m := add(mload(0x40), 0xa0)
2131             // Update the free memory pointer to allocate.
2132             mstore(0x40, m)
2133             // Assign the `str` to the end.
2134             str := sub(m, 0x20)
2135             // Zeroize the slot after the string.
2136             mstore(str, 0)
2137 
2138             // Cache the end of the memory to calculate the length later.
2139             let end := str
2140 
2141             // We write the string from rightmost digit to leftmost digit.
2142             // The following is essentially a do-while loop that also handles the zero case.
2143             // prettier-ignore
2144             for { let temp := value } 1 {} {
2145                 str := sub(str, 1)
2146                 // Write the character to the pointer.
2147                 // The ASCII index of the '0' character is 48.
2148                 mstore8(str, add(48, mod(temp, 10)))
2149                 // Keep dividing `temp` until zero.
2150                 temp := div(temp, 10)
2151                 // prettier-ignore
2152                 if iszero(temp) { break }
2153             }
2154 
2155             let length := sub(end, str)
2156             // Move the pointer 32 bytes leftwards to make room for the length.
2157             str := sub(str, 0x20)
2158             // Store the length.
2159             mstore(str, length)
2160         }
2161     }
2162 }
2163 
2164 // File: contracts/contracts2/HardWorkers.sol
2165 
2166 //SPDX-License-Identifier: Unlicense
2167 pragma solidity ^0.8.18;
2168 
2169 
2170 
2171 
2172 
2173 
2174 contract HardWorkers is ERC721A, ERC2981, DefaultOperatorFilterer, Ownable {
2175 
2176     address private constant TEAM_ADDRESS = 0x838a81d00D7353b80cDDe7a8E9396A51F0265982;
2177     address private constant DEV_ADDRESS = 0x757CD3448AcAa7801BC629F7740A4C91f3d11f10;
2178 
2179     uint256 public constant MAX_SUPPLY = 5555;
2180     uint256 public wlSupply = 3000;
2181     uint256 public publicSupply = 2555;
2182     uint256 public constant MAX_PER_WALLET = 6;
2183     uint256 public constant PRICE = 0.003 ether;
2184 
2185     bytes32 private merkleRoot;
2186     mapping(address => uint256) mints_per_wallet;
2187     uint256 wlMinted = 0;
2188     uint256 publicMinted = 0;
2189 
2190     bool public wlSale = false;
2191     bool public publicSale = false;
2192     string public baseUri = "ipfs://bafybeibbpf7tx46op345kset44fawtkyihsgvogpvwr6iaxwneeedt2cdi/";
2193 
2194     constructor() ERC721A("HardWorkers", "HWS") {
2195         setDefaultRoyalty(TEAM_ADDRESS, 500);
2196         _mint(msg.sender, 1);
2197     }
2198 
2199     function wlMint(uint amount, bytes32[] calldata _proof) external payable {
2200         require(wlSale, "WL mint not active");
2201         require(mints_per_wallet[msg.sender] + amount <= MAX_PER_WALLET, "Exceeds max per wallet");
2202         require(_totalMinted() + amount <= MAX_SUPPLY, "SOLD OUT");
2203         require(wlMinted + amount <= wlSupply, "WL supply exceeded");
2204 
2205         if (mints_per_wallet[msg.sender] == 0) {
2206             require(PRICE * (amount - 1) <= msg.value,"Insufficient funds sent");
2207         } else {
2208             require(PRICE * amount <= msg.value,"Insufficient funds sent");
2209         }
2210 
2211         require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
2212 
2213         wlMinted += amount;
2214         mints_per_wallet[msg.sender] += amount;
2215         _mint(msg.sender, amount);
2216     }
2217 
2218     function mint(uint256 amount) public payable {
2219         require(publicSale, "Public mint not active");
2220         require(mints_per_wallet[msg.sender] + amount <= MAX_PER_WALLET, "Exceeds max per wallet");
2221         require(_totalMinted() + amount <= MAX_SUPPLY, "SOLD OUT");
2222         require(publicMinted + amount <= publicSupply, "Public supply exceeded");
2223         require(msg.sender == tx.origin, "No contracts allowed");
2224 
2225         if (mints_per_wallet[msg.sender] == 0) {
2226             require(PRICE * (amount - 1) <= msg.value,"Insufficient funds sent");
2227         } else {
2228             require(PRICE * amount <= msg.value,"Insufficient funds sent");
2229         }
2230 
2231         publicMinted += amount;
2232         mints_per_wallet[msg.sender] += amount;
2233         _mint(msg.sender, amount);
2234     }
2235 
2236     function ownerMint(address adress, uint256 amount) external payable onlyOwner {
2237         require(_totalMinted() + amount <= MAX_SUPPLY, "SOLD OUT");
2238         _mint(adress, amount);
2239     }
2240 
2241     function _startTokenId() internal view virtual override returns (uint256) {
2242         return 1;
2243     }
2244 
2245     function _baseURI() internal view override returns (string memory) {
2246         return baseUri;
2247     }
2248 
2249     function withdraw() public onlyOwner {
2250         uint256 balance = address(this).balance / 10000;
2251         payable(DEV_ADDRESS).transfer(balance * 1800);
2252         payable(TEAM_ADDRESS).transfer(balance * 8200);
2253     }
2254 
2255     function setSupply(uint256 _wlSupply, uint256 _publicSupply) external onlyOwner {
2256         wlSupply = _wlSupply;
2257         publicSupply = _publicSupply;
2258     }
2259 
2260     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2261         merkleRoot = _merkleRoot;
2262     }
2263 
2264     function isWhiteListed(address walletAddress, bytes32[] calldata _proof) internal view returns(bool) {
2265         return verifyWL(leaf(walletAddress), _proof);
2266     }
2267 
2268     function verifyWL(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
2269         return MerkleProof.verify(_proof, merkleRoot, _leaf);
2270     }
2271     
2272     function leaf(address walletAddress) internal pure returns(bytes32) {
2273         return keccak256(abi.encodePacked(walletAddress));
2274     }
2275 
2276     function setBaseUri(string memory newURI) external onlyOwner {
2277         baseUri = newURI;
2278     }
2279 
2280     function flipPublicMint(bool _publicSale) external onlyOwner {
2281         publicSale = _publicSale;
2282     }
2283 
2284     function flipWLMint(bool _wlSale) external onlyOwner {
2285         wlSale = _wlSale;
2286     }
2287 
2288     function openSale() external onlyOwner {
2289         publicSale = true;
2290         wlSale = true;
2291     }
2292 
2293     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
2294         _setDefaultRoyalty(receiver, feeNumerator);
2295     }
2296 
2297     function deleteDefaultRoyalty() public onlyOwner {
2298         _deleteDefaultRoyalty();
2299     }
2300 
2301     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool){
2302         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2303     }
2304 
2305     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2306         super.setApprovalForAll(operator, approved);
2307     }
2308 
2309     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2310         super.approve(operator, tokenId);
2311     }
2312 
2313     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2314         super.transferFrom(from, to, tokenId);
2315     }
2316 
2317     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2318         super.safeTransferFrom(from, to, tokenId);
2319     }
2320 
2321     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2322         super.safeTransferFrom(from, to, tokenId, data);
2323     }
2324 }