1 // OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)
2 
3 /**
4  * @dev These functions deal with verification of Merkle Tree proofs.
5  *
6  * The tree and the proofs can be generated using our
7  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
8  * You will find a quickstart guide in the readme.
9  *
10  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
11  * hashing, or use a hash function other than keccak256 for hashing leaves.
12  * This is because the concatenation of a sorted pair of internal nodes in
13  * the merkle tree could be reinterpreted as a leaf value.
14  * OpenZeppelin's JavaScript library generates merkle trees that are safe
15  * against this attack out of the box.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
25         return processProof(proof, leaf) == root;
26     }
27 
28     /**
29      * @dev Calldata version of {verify}
30      *
31      * _Available since v4.7._
32      */
33     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
34         return processProofCalldata(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             computedHash = _hashPair(computedHash, proof[i]);
49         }
50         return computedHash;
51     }
52 
53     /**
54      * @dev Calldata version of {processProof}
55      *
56      * _Available since v4.7._
57      */
58     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
68      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
69      *
70      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
71      *
72      * _Available since v4.7._
73      */
74     function multiProofVerify(
75         bytes32[] memory proof,
76         bool[] memory proofFlags,
77         bytes32 root,
78         bytes32[] memory leaves
79     ) internal pure returns (bool) {
80         return processMultiProof(proof, proofFlags, leaves) == root;
81     }
82 
83     /**
84      * @dev Calldata version of {multiProofVerify}
85      *
86      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
87      *
88      * _Available since v4.7._
89      */
90     function multiProofVerifyCalldata(
91         bytes32[] calldata proof,
92         bool[] calldata proofFlags,
93         bytes32 root,
94         bytes32[] memory leaves
95     ) internal pure returns (bool) {
96         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
97     }
98 
99     /**
100      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
101      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
102      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
103      * respectively.
104      *
105      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
106      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
107      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
108      *
109      * _Available since v4.7._
110      */
111     function processMultiProof(
112         bytes32[] memory proof,
113         bool[] memory proofFlags,
114         bytes32[] memory leaves
115     ) internal pure returns (bytes32 merkleRoot) {
116         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
117         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
118         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
119         // the merkle tree.
120         uint256 leavesLen = leaves.length;
121         uint256 proofLen = proof.length;
122         uint256 totalHashes = proofFlags.length;
123 
124         // Check proof validity.
125         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
126 
127         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
128         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
129         bytes32[] memory hashes = new bytes32[](totalHashes);
130         uint256 leafPos = 0;
131         uint256 hashPos = 0;
132         uint256 proofPos = 0;
133         // At each step, we compute the next hash using two values:
134         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
135         //   get the next hash.
136         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
137         //   `proof` array.
138         for (uint256 i = 0; i < totalHashes; i++) {
139             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
140             bytes32 b = proofFlags[i]
141                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
142                 : proof[proofPos++];
143             hashes[i] = _hashPair(a, b);
144         }
145 
146         if (totalHashes > 0) {
147             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
148             unchecked {
149                 return hashes[totalHashes - 1];
150             }
151         } else if (leavesLen > 0) {
152             return leaves[0];
153         } else {
154             return proof[0];
155         }
156     }
157 
158     /**
159      * @dev Calldata version of {processMultiProof}.
160      *
161      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
162      *
163      * _Available since v4.7._
164      */
165     function processMultiProofCalldata(
166         bytes32[] calldata proof,
167         bool[] calldata proofFlags,
168         bytes32[] memory leaves
169     ) internal pure returns (bytes32 merkleRoot) {
170         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
171         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
172         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
173         // the merkle tree.
174         uint256 leavesLen = leaves.length;
175         uint256 proofLen = proof.length;
176         uint256 totalHashes = proofFlags.length;
177 
178         // Check proof validity.
179         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
180 
181         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
182         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
183         bytes32[] memory hashes = new bytes32[](totalHashes);
184         uint256 leafPos = 0;
185         uint256 hashPos = 0;
186         uint256 proofPos = 0;
187         // At each step, we compute the next hash using two values:
188         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
189         //   get the next hash.
190         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
191         //   `proof` array.
192         for (uint256 i = 0; i < totalHashes; i++) {
193             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
194             bytes32 b = proofFlags[i]
195                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
196                 : proof[proofPos++];
197             hashes[i] = _hashPair(a, b);
198         }
199 
200         if (totalHashes > 0) {
201             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
202             unchecked {
203                 return hashes[totalHashes - 1];
204             }
205         } else if (leavesLen > 0) {
206             return leaves[0];
207         } else {
208             return proof[0];
209         }
210     }
211 
212     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
213         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
214     }
215 
216     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
217         /// @solidity memory-safe-assembly
218         assembly {
219             mstore(0x00, a)
220             mstore(0x20, b)
221             value := keccak256(0x00, 0x40)
222         }
223     }
224 }
225 
226 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
227 
228 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
229 
230 /**
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes calldata) {
246         return msg.data;
247     }
248 }
249 
250 /**
251  * @dev Contract module which provides a basic access control mechanism, where
252  * there is an account (an owner) that can be granted exclusive access to
253  * specific functions.
254  *
255  * By default, the owner account will be the one that deploys the contract. This
256  * can later be changed with {transferOwnership}.
257  *
258  * This module is used through inheritance. It will make available the modifier
259  * `onlyOwner`, which can be applied to your functions to restrict their use to
260  * the owner.
261  */
262 abstract contract Ownable is Context {
263     address private _owner;
264 
265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
266 
267     /**
268      * @dev Initializes the contract setting the deployer as the initial owner.
269      */
270     constructor() {
271         _transferOwnership(_msgSender());
272     }
273 
274     /**
275      * @dev Throws if called by any account other than the owner.
276      */
277     modifier onlyOwner() {
278         _checkOwner();
279         _;
280     }
281 
282     /**
283      * @dev Returns the address of the current owner.
284      */
285     function owner() public view virtual returns (address) {
286         return _owner;
287     }
288 
289     /**
290      * @dev Throws if the sender is not the owner.
291      */
292     function _checkOwner() internal view virtual {
293         require(owner() == _msgSender(), "Ownable: caller is not the owner");
294     }
295 
296     /**
297      * @dev Leaves the contract without owner. It will not be possible to call
298      * `onlyOwner` functions. Can only be called by the current owner.
299      *
300      * NOTE: Renouncing ownership will leave the contract without an owner,
301      * thereby disabling any functionality that is only available to the owner.
302      */
303     function renounceOwnership() public virtual onlyOwner {
304         _transferOwnership(address(0));
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      * Can only be called by the current owner.
310      */
311     function transferOwnership(address newOwner) public virtual onlyOwner {
312         require(newOwner != address(0), "Ownable: new owner is the zero address");
313         _transferOwnership(newOwner);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Internal function without access restriction.
319      */
320     function _transferOwnership(address newOwner) internal virtual {
321         address oldOwner = _owner;
322         _owner = newOwner;
323         emit OwnershipTransferred(oldOwner, newOwner);
324     }
325 }
326 
327 // OpenZeppelin Contracts (last updated v4.9.0) (token/common/ERC2981.sol)
328 
329 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC2981.sol)
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 /**
355  * @dev Interface for the NFT Royalty Standard.
356  *
357  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
358  * support for royalty payments across all NFT marketplaces and ecosystem participants.
359  *
360  * _Available since v4.5._
361  */
362 interface IERC2981 is IERC165 {
363     /**
364      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
365      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
366      */
367     function royaltyInfo(
368         uint256 tokenId,
369         uint256 salePrice
370     ) external view returns (address receiver, uint256 royaltyAmount);
371 }
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
374 
375 /**
376  * @dev Implementation of the {IERC165} interface.
377  *
378  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
379  * for the additional interface id that will be supported. For example:
380  *
381  * ```solidity
382  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
383  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
384  * }
385  * ```
386  *
387  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
388  */
389 abstract contract ERC165 is IERC165 {
390     /**
391      * @dev See {IERC165-supportsInterface}.
392      */
393     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394         return interfaceId == type(IERC165).interfaceId;
395     }
396 }
397 
398 /**
399  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
400  *
401  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
402  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
403  *
404  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
405  * fee is specified in basis points by default.
406  *
407  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
408  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
409  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
410  *
411  * _Available since v4.5._
412  */
413 abstract contract ERC2981 is IERC2981, ERC165 {
414     struct RoyaltyInfo {
415         address receiver;
416         uint96 royaltyFraction;
417     }
418 
419     RoyaltyInfo private _defaultRoyaltyInfo;
420     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
421 
422     /**
423      * @dev See {IERC165-supportsInterface}.
424      */
425     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
426         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
427     }
428 
429     /**
430      * @inheritdoc IERC2981
431      */
432     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
433         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
434 
435         if (royalty.receiver == address(0)) {
436             royalty = _defaultRoyaltyInfo;
437         }
438 
439         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
440 
441         return (royalty.receiver, royaltyAmount);
442     }
443 
444     /**
445      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
446      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
447      * override.
448      */
449     function _feeDenominator() internal pure virtual returns (uint96) {
450         return 10000;
451     }
452 
453     /**
454      * @dev Sets the royalty information that all ids in this contract will default to.
455      *
456      * Requirements:
457      *
458      * - `receiver` cannot be the zero address.
459      * - `feeNumerator` cannot be greater than the fee denominator.
460      */
461     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
462         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
463         require(receiver != address(0), "ERC2981: invalid receiver");
464 
465         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
466     }
467 
468     /**
469      * @dev Removes default royalty information.
470      */
471     function _deleteDefaultRoyalty() internal virtual {
472         delete _defaultRoyaltyInfo;
473     }
474 
475     /**
476      * @dev Sets the royalty information for a specific token id, overriding the global default.
477      *
478      * Requirements:
479      *
480      * - `receiver` cannot be the zero address.
481      * - `feeNumerator` cannot be greater than the fee denominator.
482      */
483     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
484         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
485         require(receiver != address(0), "ERC2981: Invalid parameters");
486 
487         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
488     }
489 
490     /**
491      * @dev Resets royalty information for the token id back to the global default.
492      */
493     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
494         delete _tokenRoyaltyInfo[tokenId];
495     }
496 }
497 
498 // ERC721A Contracts v4.2.3
499 // Creator: Chiru Labs
500 
501 // ERC721A Contracts v4.2.3
502 // Creator: Chiru Labs
503 
504 // ERC721A Contracts v4.2.3
505 // Creator: Chiru Labs
506 
507 /**
508  * @dev Interface of ERC721A.
509  */
510 interface IERC721A {
511     /**
512      * The caller must own the token or be an approved operator.
513      */
514     error ApprovalCallerNotOwnerNorApproved();
515 
516     /**
517      * The token does not exist.
518      */
519     error ApprovalQueryForNonexistentToken();
520 
521     /**
522      * Cannot query the balance for the zero address.
523      */
524     error BalanceQueryForZeroAddress();
525 
526     /**
527      * Cannot mint to the zero address.
528      */
529     error MintToZeroAddress();
530 
531     /**
532      * The quantity of tokens minted must be more than zero.
533      */
534     error MintZeroQuantity();
535 
536     /**
537      * The token does not exist.
538      */
539     error OwnerQueryForNonexistentToken();
540 
541     /**
542      * The caller must own the token or be an approved operator.
543      */
544     error TransferCallerNotOwnerNorApproved();
545 
546     /**
547      * The token must be owned by `from`.
548      */
549     error TransferFromIncorrectOwner();
550 
551     /**
552      * Cannot safely transfer to a contract that does not implement the
553      * ERC721Receiver interface.
554      */
555     error TransferToNonERC721ReceiverImplementer();
556 
557     /**
558      * Cannot transfer to the zero address.
559      */
560     error TransferToZeroAddress();
561 
562     /**
563      * The token does not exist.
564      */
565     error URIQueryForNonexistentToken();
566 
567     /**
568      * The `quantity` minted with ERC2309 exceeds the safety limit.
569      */
570     error MintERC2309QuantityExceedsLimit();
571 
572     /**
573      * The `extraData` cannot be set on an unintialized ownership slot.
574      */
575     error OwnershipNotInitializedForExtraData();
576 
577     // =============================================================
578     //                            STRUCTS
579     // =============================================================
580 
581     struct TokenOwnership {
582         // The address of the owner.
583         address addr;
584         // Stores the start time of ownership with minimal overhead for tokenomics.
585         uint64 startTimestamp;
586         // Whether the token has been burned.
587         bool burned;
588         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
589         uint24 extraData;
590     }
591 
592     // =============================================================
593     //                         TOKEN COUNTERS
594     // =============================================================
595 
596     /**
597      * @dev Returns the total number of tokens in existence.
598      * Burned tokens will reduce the count.
599      * To get the total number of tokens minted, please see {_totalMinted}.
600      */
601     function totalSupply() external view returns (uint256);
602 
603     // =============================================================
604     //                            IERC165
605     // =============================================================
606 
607     /**
608      * @dev Returns true if this contract implements the interface defined by
609      * `interfaceId`. See the corresponding
610      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
611      * to learn more about how these ids are created.
612      *
613      * This function call must use less than 30000 gas.
614      */
615     function supportsInterface(bytes4 interfaceId) external view returns (bool);
616 
617     // =============================================================
618     //                            IERC721
619     // =============================================================
620 
621     /**
622      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
623      */
624     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
625 
626     /**
627      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
628      */
629     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
630 
631     /**
632      * @dev Emitted when `owner` enables or disables
633      * (`approved`) `operator` to manage all of its assets.
634      */
635     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
636 
637     /**
638      * @dev Returns the number of tokens in `owner`'s account.
639      */
640     function balanceOf(address owner) external view returns (uint256 balance);
641 
642     /**
643      * @dev Returns the owner of the `tokenId` token.
644      *
645      * Requirements:
646      *
647      * - `tokenId` must exist.
648      */
649     function ownerOf(uint256 tokenId) external view returns (address owner);
650 
651     /**
652      * @dev Safely transfers `tokenId` token from `from` to `to`,
653      * checking first that contract recipients are aware of the ERC721 protocol
654      * to prevent tokens from being forever locked.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must exist and be owned by `from`.
661      * - If the caller is not `from`, it must be have been allowed to move
662      * this token by either {approve} or {setApprovalForAll}.
663      * - If `to` refers to a smart contract, it must implement
664      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665      *
666      * Emits a {Transfer} event.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes calldata data
673     ) external payable;
674 
675     /**
676      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external payable;
683 
684     /**
685      * @dev Transfers `tokenId` from `from` to `to`.
686      *
687      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
688      * whenever possible.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must be owned by `from`.
695      * - If the caller is not `from`, it must be approved to move this token
696      * by either {approve} or {setApprovalForAll}.
697      *
698      * Emits a {Transfer} event.
699      */
700     function transferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) external payable;
705 
706     /**
707      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
708      * The approval is cleared when the token is transferred.
709      *
710      * Only a single account can be approved at a time, so approving the
711      * zero address clears previous approvals.
712      *
713      * Requirements:
714      *
715      * - The caller must own the token or be an approved operator.
716      * - `tokenId` must exist.
717      *
718      * Emits an {Approval} event.
719      */
720     function approve(address to, uint256 tokenId) external payable;
721 
722     /**
723      * @dev Approve or remove `operator` as an operator for the caller.
724      * Operators can call {transferFrom} or {safeTransferFrom}
725      * for any token owned by the caller.
726      *
727      * Requirements:
728      *
729      * - The `operator` cannot be the caller.
730      *
731      * Emits an {ApprovalForAll} event.
732      */
733     function setApprovalForAll(address operator, bool _approved) external;
734 
735     /**
736      * @dev Returns the account approved for `tokenId` token.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function getApproved(uint256 tokenId) external view returns (address operator);
743 
744     /**
745      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
746      *
747      * See {setApprovalForAll}.
748      */
749     function isApprovedForAll(address owner, address operator) external view returns (bool);
750 
751     // =============================================================
752     //                        IERC721Metadata
753     // =============================================================
754 
755     /**
756      * @dev Returns the token collection name.
757      */
758     function name() external view returns (string memory);
759 
760     /**
761      * @dev Returns the token collection symbol.
762      */
763     function symbol() external view returns (string memory);
764 
765     /**
766      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
767      */
768     function tokenURI(uint256 tokenId) external view returns (string memory);
769 
770     // =============================================================
771     //                           IERC2309
772     // =============================================================
773 
774     /**
775      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
776      * (inclusive) is transferred from `from` to `to`, as defined in the
777      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
778      *
779      * See {_mintERC2309} for more details.
780      */
781     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
782 }
783 
784 /**
785  * @dev Interface of ERC721AQueryable.
786  */
787 interface IERC721AQueryable is IERC721A {
788     /**
789      * Invalid query range (`start` >= `stop`).
790      */
791     error InvalidQueryRange();
792 
793     /**
794      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
795      *
796      * If the `tokenId` is out of bounds:
797      *
798      * - `addr = address(0)`
799      * - `startTimestamp = 0`
800      * - `burned = false`
801      * - `extraData = 0`
802      *
803      * If the `tokenId` is burned:
804      *
805      * - `addr = <Address of owner before token was burned>`
806      * - `startTimestamp = <Timestamp when token was burned>`
807      * - `burned = true`
808      * - `extraData = <Extra data when token was burned>`
809      *
810      * Otherwise:
811      *
812      * - `addr = <Address of owner>`
813      * - `startTimestamp = <Timestamp of start of ownership>`
814      * - `burned = false`
815      * - `extraData = <Extra data at start of ownership>`
816      */
817     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
818 
819     /**
820      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
821      * See {ERC721AQueryable-explicitOwnershipOf}
822      */
823     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
824 
825     /**
826      * @dev Returns an array of token IDs owned by `owner`,
827      * in the range [`start`, `stop`)
828      * (i.e. `start <= tokenId < stop`).
829      *
830      * This function allows for tokens to be queried if the collection
831      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
832      *
833      * Requirements:
834      *
835      * - `start < stop`
836      */
837     function tokensOfOwnerIn(
838         address owner,
839         uint256 start,
840         uint256 stop
841     ) external view returns (uint256[] memory);
842 
843     /**
844      * @dev Returns an array of token IDs owned by `owner`.
845      *
846      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
847      * It is meant to be called off-chain.
848      *
849      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
850      * multiple smaller scans if the collection is large enough to cause
851      * an out-of-gas error (10K collections should be fine).
852      */
853     function tokensOfOwner(address owner) external view returns (uint256[] memory);
854 }
855 
856 // ERC721A Contracts v4.2.3
857 // Creator: Chiru Labs
858 
859 /**
860  * @dev Interface of ERC721 token receiver.
861  */
862 interface ERC721A__IERC721Receiver {
863     function onERC721Received(
864         address operator,
865         address from,
866         uint256 tokenId,
867         bytes calldata data
868     ) external returns (bytes4);
869 }
870 
871 /**
872  * @title ERC721A
873  *
874  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
875  * Non-Fungible Token Standard, including the Metadata extension.
876  * Optimized for lower gas during batch mints.
877  *
878  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
879  * starting from `_startTokenId()`.
880  *
881  * Assumptions:
882  *
883  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
884  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
885  */
886 contract ERC721A is IERC721A {
887     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
888     struct TokenApprovalRef {
889         address value;
890     }
891 
892     // =============================================================
893     //                           CONSTANTS
894     // =============================================================
895 
896     // Mask of an entry in packed address data.
897     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
898 
899     // The bit position of `numberMinted` in packed address data.
900     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
901 
902     // The bit position of `numberBurned` in packed address data.
903     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
904 
905     // The bit position of `aux` in packed address data.
906     uint256 private constant _BITPOS_AUX = 192;
907 
908     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
909     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
910 
911     // The bit position of `startTimestamp` in packed ownership.
912     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
913 
914     // The bit mask of the `burned` bit in packed ownership.
915     uint256 private constant _BITMASK_BURNED = 1 << 224;
916 
917     // The bit position of the `nextInitialized` bit in packed ownership.
918     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
919 
920     // The bit mask of the `nextInitialized` bit in packed ownership.
921     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
922 
923     // The bit position of `extraData` in packed ownership.
924     uint256 private constant _BITPOS_EXTRA_DATA = 232;
925 
926     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
927     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
928 
929     // The mask of the lower 160 bits for addresses.
930     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
931 
932     // The maximum `quantity` that can be minted with {_mintERC2309}.
933     // This limit is to prevent overflows on the address data entries.
934     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
935     // is required to cause an overflow, which is unrealistic.
936     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
937 
938     // The `Transfer` event signature is given by:
939     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
940     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
941         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
942 
943     // =============================================================
944     //                            STORAGE
945     // =============================================================
946 
947     // The next token ID to be minted.
948     uint256 private _currentIndex;
949 
950     // The number of tokens burned.
951     uint256 private _burnCounter;
952 
953     // Token name
954     string private _name;
955 
956     // Token symbol
957     string private _symbol;
958 
959     // Mapping from token ID to ownership details
960     // An empty struct value does not necessarily mean the token is unowned.
961     // See {_packedOwnershipOf} implementation for details.
962     //
963     // Bits Layout:
964     // - [0..159]   `addr`
965     // - [160..223] `startTimestamp`
966     // - [224]      `burned`
967     // - [225]      `nextInitialized`
968     // - [232..255] `extraData`
969     mapping(uint256 => uint256) private _packedOwnerships;
970 
971     // Mapping owner address to address data.
972     //
973     // Bits Layout:
974     // - [0..63]    `balance`
975     // - [64..127]  `numberMinted`
976     // - [128..191] `numberBurned`
977     // - [192..255] `aux`
978     mapping(address => uint256) private _packedAddressData;
979 
980     // Mapping from token ID to approved address.
981     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
982 
983     // Mapping from owner to operator approvals
984     mapping(address => mapping(address => bool)) private _operatorApprovals;
985 
986     // =============================================================
987     //                          CONSTRUCTOR
988     // =============================================================
989 
990     constructor(string memory name_, string memory symbol_) {
991         _name = name_;
992         _symbol = symbol_;
993         _currentIndex = _startTokenId();
994     }
995 
996     // =============================================================
997     //                   TOKEN COUNTING OPERATIONS
998     // =============================================================
999 
1000     /**
1001      * @dev Returns the starting token ID.
1002      * To change the starting token ID, please override this function.
1003      */
1004     function _startTokenId() internal view virtual returns (uint256) {
1005         return 0;
1006     }
1007 
1008     /**
1009      * @dev Returns the next token ID to be minted.
1010      */
1011     function _nextTokenId() internal view virtual returns (uint256) {
1012         return _currentIndex;
1013     }
1014 
1015     /**
1016      * @dev Returns the total number of tokens in existence.
1017      * Burned tokens will reduce the count.
1018      * To get the total number of tokens minted, please see {_totalMinted}.
1019      */
1020     function totalSupply() public view virtual override returns (uint256) {
1021         // Counter underflow is impossible as _burnCounter cannot be incremented
1022         // more than `_currentIndex - _startTokenId()` times.
1023         unchecked {
1024             return _currentIndex - _burnCounter - _startTokenId();
1025         }
1026     }
1027 
1028     /**
1029      * @dev Returns the total amount of tokens minted in the contract.
1030      */
1031     function _totalMinted() internal view virtual returns (uint256) {
1032         // Counter underflow is impossible as `_currentIndex` does not decrement,
1033         // and it is initialized to `_startTokenId()`.
1034         unchecked {
1035             return _currentIndex - _startTokenId();
1036         }
1037     }
1038 
1039     /**
1040      * @dev Returns the total number of tokens burned.
1041      */
1042     function _totalBurned() internal view virtual returns (uint256) {
1043         return _burnCounter;
1044     }
1045 
1046     // =============================================================
1047     //                    ADDRESS DATA OPERATIONS
1048     // =============================================================
1049 
1050     /**
1051      * @dev Returns the number of tokens in `owner`'s account.
1052      */
1053     function balanceOf(address owner) public view virtual override returns (uint256) {
1054         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1055         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1056     }
1057 
1058     /**
1059      * Returns the number of tokens minted by `owner`.
1060      */
1061     function _numberMinted(address owner) internal view returns (uint256) {
1062         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1063     }
1064 
1065     /**
1066      * Returns the number of tokens burned by or on behalf of `owner`.
1067      */
1068     function _numberBurned(address owner) internal view returns (uint256) {
1069         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1070     }
1071 
1072     /**
1073      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1074      */
1075     function _getAux(address owner) internal view returns (uint64) {
1076         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1077     }
1078 
1079     /**
1080      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1081      * If there are multiple variables, please pack them into a uint64.
1082      */
1083     function _setAux(address owner, uint64 aux) internal virtual {
1084         uint256 packed = _packedAddressData[owner];
1085         uint256 auxCasted;
1086         // Cast `aux` with assembly to avoid redundant masking.
1087         assembly {
1088             auxCasted := aux
1089         }
1090         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1091         _packedAddressData[owner] = packed;
1092     }
1093 
1094     // =============================================================
1095     //                            IERC165
1096     // =============================================================
1097 
1098     /**
1099      * @dev Returns true if this contract implements the interface defined by
1100      * `interfaceId`. See the corresponding
1101      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1102      * to learn more about how these ids are created.
1103      *
1104      * This function call must use less than 30000 gas.
1105      */
1106     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1107         // The interface IDs are constants representing the first 4 bytes
1108         // of the XOR of all function selectors in the interface.
1109         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1110         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1111         return
1112             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1113             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1114             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1115     }
1116 
1117     // =============================================================
1118     //                        IERC721Metadata
1119     // =============================================================
1120 
1121     /**
1122      * @dev Returns the token collection name.
1123      */
1124     function name() public view virtual override returns (string memory) {
1125         return _name;
1126     }
1127 
1128     /**
1129      * @dev Returns the token collection symbol.
1130      */
1131     function symbol() public view virtual override returns (string memory) {
1132         return _symbol;
1133     }
1134 
1135     /**
1136      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1137      */
1138     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1139         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1140 
1141         string memory baseURI = _baseURI();
1142         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1143     }
1144 
1145     /**
1146      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1147      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1148      * by default, it can be overridden in child contracts.
1149      */
1150     function _baseURI() internal view virtual returns (string memory) {
1151         return '';
1152     }
1153 
1154     // =============================================================
1155     //                     OWNERSHIPS OPERATIONS
1156     // =============================================================
1157 
1158     /**
1159      * @dev Returns the owner of the `tokenId` token.
1160      *
1161      * Requirements:
1162      *
1163      * - `tokenId` must exist.
1164      */
1165     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1166         return address(uint160(_packedOwnershipOf(tokenId)));
1167     }
1168 
1169     /**
1170      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1171      * It gradually moves to O(1) as tokens get transferred around over time.
1172      */
1173     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1174         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1175     }
1176 
1177     /**
1178      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1179      */
1180     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1181         return _unpackedOwnership(_packedOwnerships[index]);
1182     }
1183 
1184     /**
1185      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1186      */
1187     function _initializeOwnershipAt(uint256 index) internal virtual {
1188         if (_packedOwnerships[index] == 0) {
1189             _packedOwnerships[index] = _packedOwnershipOf(index);
1190         }
1191     }
1192 
1193     /**
1194      * Returns the packed ownership data of `tokenId`.
1195      */
1196     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1197         uint256 curr = tokenId;
1198 
1199         unchecked {
1200             if (_startTokenId() <= curr)
1201                 if (curr < _currentIndex) {
1202                     uint256 packed = _packedOwnerships[curr];
1203                     // If not burned.
1204                     if (packed & _BITMASK_BURNED == 0) {
1205                         // Invariant:
1206                         // There will always be an initialized ownership slot
1207                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1208                         // before an unintialized ownership slot
1209                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1210                         // Hence, `curr` will not underflow.
1211                         //
1212                         // We can directly compare the packed value.
1213                         // If the address is zero, packed will be zero.
1214                         while (packed == 0) {
1215                             packed = _packedOwnerships[--curr];
1216                         }
1217                         return packed;
1218                     }
1219                 }
1220         }
1221         revert OwnerQueryForNonexistentToken();
1222     }
1223 
1224     /**
1225      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1226      */
1227     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1228         ownership.addr = address(uint160(packed));
1229         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1230         ownership.burned = packed & _BITMASK_BURNED != 0;
1231         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1232     }
1233 
1234     /**
1235      * @dev Packs ownership data into a single uint256.
1236      */
1237     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1238         assembly {
1239             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1240             owner := and(owner, _BITMASK_ADDRESS)
1241             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1242             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1243         }
1244     }
1245 
1246     /**
1247      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1248      */
1249     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1250         // For branchless setting of the `nextInitialized` flag.
1251         assembly {
1252             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1253             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1254         }
1255     }
1256 
1257     // =============================================================
1258     //                      APPROVAL OPERATIONS
1259     // =============================================================
1260 
1261     /**
1262      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1263      * The approval is cleared when the token is transferred.
1264      *
1265      * Only a single account can be approved at a time, so approving the
1266      * zero address clears previous approvals.
1267      *
1268      * Requirements:
1269      *
1270      * - The caller must own the token or be an approved operator.
1271      * - `tokenId` must exist.
1272      *
1273      * Emits an {Approval} event.
1274      */
1275     function approve(address to, uint256 tokenId) public payable virtual override {
1276         address owner = ownerOf(tokenId);
1277 
1278         if (_msgSenderERC721A() != owner)
1279             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1280                 revert ApprovalCallerNotOwnerNorApproved();
1281             }
1282 
1283         _tokenApprovals[tokenId].value = to;
1284         emit Approval(owner, to, tokenId);
1285     }
1286 
1287     /**
1288      * @dev Returns the account approved for `tokenId` token.
1289      *
1290      * Requirements:
1291      *
1292      * - `tokenId` must exist.
1293      */
1294     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1295         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1296 
1297         return _tokenApprovals[tokenId].value;
1298     }
1299 
1300     /**
1301      * @dev Approve or remove `operator` as an operator for the caller.
1302      * Operators can call {transferFrom} or {safeTransferFrom}
1303      * for any token owned by the caller.
1304      *
1305      * Requirements:
1306      *
1307      * - The `operator` cannot be the caller.
1308      *
1309      * Emits an {ApprovalForAll} event.
1310      */
1311     function setApprovalForAll(address operator, bool approved) public virtual override {
1312         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1313         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1314     }
1315 
1316     /**
1317      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1318      *
1319      * See {setApprovalForAll}.
1320      */
1321     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1322         return _operatorApprovals[owner][operator];
1323     }
1324 
1325     /**
1326      * @dev Returns whether `tokenId` exists.
1327      *
1328      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1329      *
1330      * Tokens start existing when they are minted. See {_mint}.
1331      */
1332     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1333         return
1334             _startTokenId() <= tokenId &&
1335             tokenId < _currentIndex && // If within bounds,
1336             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1337     }
1338 
1339     /**
1340      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1341      */
1342     function _isSenderApprovedOrOwner(
1343         address approvedAddress,
1344         address owner,
1345         address msgSender
1346     ) private pure returns (bool result) {
1347         assembly {
1348             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1349             owner := and(owner, _BITMASK_ADDRESS)
1350             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1351             msgSender := and(msgSender, _BITMASK_ADDRESS)
1352             // `msgSender == owner || msgSender == approvedAddress`.
1353             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1354         }
1355     }
1356 
1357     /**
1358      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1359      */
1360     function _getApprovedSlotAndAddress(uint256 tokenId)
1361         private
1362         view
1363         returns (uint256 approvedAddressSlot, address approvedAddress)
1364     {
1365         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1366         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1367         assembly {
1368             approvedAddressSlot := tokenApproval.slot
1369             approvedAddress := sload(approvedAddressSlot)
1370         }
1371     }
1372 
1373     // =============================================================
1374     //                      TRANSFER OPERATIONS
1375     // =============================================================
1376 
1377     /**
1378      * @dev Transfers `tokenId` from `from` to `to`.
1379      *
1380      * Requirements:
1381      *
1382      * - `from` cannot be the zero address.
1383      * - `to` cannot be the zero address.
1384      * - `tokenId` token must be owned by `from`.
1385      * - If the caller is not `from`, it must be approved to move this token
1386      * by either {approve} or {setApprovalForAll}.
1387      *
1388      * Emits a {Transfer} event.
1389      */
1390     function transferFrom(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) public payable virtual override {
1395         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1396 
1397         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1398 
1399         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1400 
1401         // The nested ifs save around 20+ gas over a compound boolean condition.
1402         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1403             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1404 
1405         if (to == address(0)) revert TransferToZeroAddress();
1406 
1407         _beforeTokenTransfers(from, to, tokenId, 1);
1408 
1409         // Clear approvals from the previous owner.
1410         assembly {
1411             if approvedAddress {
1412                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1413                 sstore(approvedAddressSlot, 0)
1414             }
1415         }
1416 
1417         // Underflow of the sender's balance is impossible because we check for
1418         // ownership above and the recipient's balance can't realistically overflow.
1419         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1420         unchecked {
1421             // We can directly increment and decrement the balances.
1422             --_packedAddressData[from]; // Updates: `balance -= 1`.
1423             ++_packedAddressData[to]; // Updates: `balance += 1`.
1424 
1425             // Updates:
1426             // - `address` to the next owner.
1427             // - `startTimestamp` to the timestamp of transfering.
1428             // - `burned` to `false`.
1429             // - `nextInitialized` to `true`.
1430             _packedOwnerships[tokenId] = _packOwnershipData(
1431                 to,
1432                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1433             );
1434 
1435             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1436             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1437                 uint256 nextTokenId = tokenId + 1;
1438                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1439                 if (_packedOwnerships[nextTokenId] == 0) {
1440                     // If the next slot is within bounds.
1441                     if (nextTokenId != _currentIndex) {
1442                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1443                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1444                     }
1445                 }
1446             }
1447         }
1448 
1449         emit Transfer(from, to, tokenId);
1450         _afterTokenTransfers(from, to, tokenId, 1);
1451     }
1452 
1453     /**
1454      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1455      */
1456     function safeTransferFrom(
1457         address from,
1458         address to,
1459         uint256 tokenId
1460     ) public payable virtual override {
1461         safeTransferFrom(from, to, tokenId, '');
1462     }
1463 
1464     /**
1465      * @dev Safely transfers `tokenId` token from `from` to `to`.
1466      *
1467      * Requirements:
1468      *
1469      * - `from` cannot be the zero address.
1470      * - `to` cannot be the zero address.
1471      * - `tokenId` token must exist and be owned by `from`.
1472      * - If the caller is not `from`, it must be approved to move this token
1473      * by either {approve} or {setApprovalForAll}.
1474      * - If `to` refers to a smart contract, it must implement
1475      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function safeTransferFrom(
1480         address from,
1481         address to,
1482         uint256 tokenId,
1483         bytes memory _data
1484     ) public payable virtual override {
1485         transferFrom(from, to, tokenId);
1486         if (to.code.length != 0)
1487             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1488                 revert TransferToNonERC721ReceiverImplementer();
1489             }
1490     }
1491 
1492     /**
1493      * @dev Hook that is called before a set of serially-ordered token IDs
1494      * are about to be transferred. This includes minting.
1495      * And also called before burning one token.
1496      *
1497      * `startTokenId` - the first token ID to be transferred.
1498      * `quantity` - the amount to be transferred.
1499      *
1500      * Calling conditions:
1501      *
1502      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1503      * transferred to `to`.
1504      * - When `from` is zero, `tokenId` will be minted for `to`.
1505      * - When `to` is zero, `tokenId` will be burned by `from`.
1506      * - `from` and `to` are never both zero.
1507      */
1508     function _beforeTokenTransfers(
1509         address from,
1510         address to,
1511         uint256 startTokenId,
1512         uint256 quantity
1513     ) internal virtual {}
1514 
1515     /**
1516      * @dev Hook that is called after a set of serially-ordered token IDs
1517      * have been transferred. This includes minting.
1518      * And also called after one token has been burned.
1519      *
1520      * `startTokenId` - the first token ID to be transferred.
1521      * `quantity` - the amount to be transferred.
1522      *
1523      * Calling conditions:
1524      *
1525      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1526      * transferred to `to`.
1527      * - When `from` is zero, `tokenId` has been minted for `to`.
1528      * - When `to` is zero, `tokenId` has been burned by `from`.
1529      * - `from` and `to` are never both zero.
1530      */
1531     function _afterTokenTransfers(
1532         address from,
1533         address to,
1534         uint256 startTokenId,
1535         uint256 quantity
1536     ) internal virtual {}
1537 
1538     /**
1539      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1540      *
1541      * `from` - Previous owner of the given token ID.
1542      * `to` - Target address that will receive the token.
1543      * `tokenId` - Token ID to be transferred.
1544      * `_data` - Optional data to send along with the call.
1545      *
1546      * Returns whether the call correctly returned the expected magic value.
1547      */
1548     function _checkContractOnERC721Received(
1549         address from,
1550         address to,
1551         uint256 tokenId,
1552         bytes memory _data
1553     ) private returns (bool) {
1554         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1555             bytes4 retval
1556         ) {
1557             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1558         } catch (bytes memory reason) {
1559             if (reason.length == 0) {
1560                 revert TransferToNonERC721ReceiverImplementer();
1561             } else {
1562                 assembly {
1563                     revert(add(32, reason), mload(reason))
1564                 }
1565             }
1566         }
1567     }
1568 
1569     // =============================================================
1570     //                        MINT OPERATIONS
1571     // =============================================================
1572 
1573     /**
1574      * @dev Mints `quantity` tokens and transfers them to `to`.
1575      *
1576      * Requirements:
1577      *
1578      * - `to` cannot be the zero address.
1579      * - `quantity` must be greater than 0.
1580      *
1581      * Emits a {Transfer} event for each mint.
1582      */
1583     function _mint(address to, uint256 quantity) internal virtual {
1584         uint256 startTokenId = _currentIndex;
1585         if (quantity == 0) revert MintZeroQuantity();
1586 
1587         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1588 
1589         // Overflows are incredibly unrealistic.
1590         // `balance` and `numberMinted` have a maximum limit of 2**64.
1591         // `tokenId` has a maximum limit of 2**256.
1592         unchecked {
1593             // Updates:
1594             // - `balance += quantity`.
1595             // - `numberMinted += quantity`.
1596             //
1597             // We can directly add to the `balance` and `numberMinted`.
1598             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1599 
1600             // Updates:
1601             // - `address` to the owner.
1602             // - `startTimestamp` to the timestamp of minting.
1603             // - `burned` to `false`.
1604             // - `nextInitialized` to `quantity == 1`.
1605             _packedOwnerships[startTokenId] = _packOwnershipData(
1606                 to,
1607                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1608             );
1609 
1610             uint256 toMasked;
1611             uint256 end = startTokenId + quantity;
1612 
1613             // Use assembly to loop and emit the `Transfer` event for gas savings.
1614             // The duplicated `log4` removes an extra check and reduces stack juggling.
1615             // The assembly, together with the surrounding Solidity code, have been
1616             // delicately arranged to nudge the compiler into producing optimized opcodes.
1617             assembly {
1618                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1619                 toMasked := and(to, _BITMASK_ADDRESS)
1620                 // Emit the `Transfer` event.
1621                 log4(
1622                     0, // Start of data (0, since no data).
1623                     0, // End of data (0, since no data).
1624                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1625                     0, // `address(0)`.
1626                     toMasked, // `to`.
1627                     startTokenId // `tokenId`.
1628                 )
1629 
1630                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1631                 // that overflows uint256 will make the loop run out of gas.
1632                 // The compiler will optimize the `iszero` away for performance.
1633                 for {
1634                     let tokenId := add(startTokenId, 1)
1635                 } iszero(eq(tokenId, end)) {
1636                     tokenId := add(tokenId, 1)
1637                 } {
1638                     // Emit the `Transfer` event. Similar to above.
1639                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1640                 }
1641             }
1642             if (toMasked == 0) revert MintToZeroAddress();
1643 
1644             _currentIndex = end;
1645         }
1646         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1647     }
1648 
1649     /**
1650      * @dev Mints `quantity` tokens and transfers them to `to`.
1651      *
1652      * This function is intended for efficient minting only during contract creation.
1653      *
1654      * It emits only one {ConsecutiveTransfer} as defined in
1655      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1656      * instead of a sequence of {Transfer} event(s).
1657      *
1658      * Calling this function outside of contract creation WILL make your contract
1659      * non-compliant with the ERC721 standard.
1660      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1661      * {ConsecutiveTransfer} event is only permissible during contract creation.
1662      *
1663      * Requirements:
1664      *
1665      * - `to` cannot be the zero address.
1666      * - `quantity` must be greater than 0.
1667      *
1668      * Emits a {ConsecutiveTransfer} event.
1669      */
1670     function _mintERC2309(address to, uint256 quantity) internal virtual {
1671         uint256 startTokenId = _currentIndex;
1672         if (to == address(0)) revert MintToZeroAddress();
1673         if (quantity == 0) revert MintZeroQuantity();
1674         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1675 
1676         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1677 
1678         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1679         unchecked {
1680             // Updates:
1681             // - `balance += quantity`.
1682             // - `numberMinted += quantity`.
1683             //
1684             // We can directly add to the `balance` and `numberMinted`.
1685             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1686 
1687             // Updates:
1688             // - `address` to the owner.
1689             // - `startTimestamp` to the timestamp of minting.
1690             // - `burned` to `false`.
1691             // - `nextInitialized` to `quantity == 1`.
1692             _packedOwnerships[startTokenId] = _packOwnershipData(
1693                 to,
1694                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1695             );
1696 
1697             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1698 
1699             _currentIndex = startTokenId + quantity;
1700         }
1701         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1702     }
1703 
1704     /**
1705      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1706      *
1707      * Requirements:
1708      *
1709      * - If `to` refers to a smart contract, it must implement
1710      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1711      * - `quantity` must be greater than 0.
1712      *
1713      * See {_mint}.
1714      *
1715      * Emits a {Transfer} event for each mint.
1716      */
1717     function _safeMint(
1718         address to,
1719         uint256 quantity,
1720         bytes memory _data
1721     ) internal virtual {
1722         _mint(to, quantity);
1723 
1724         unchecked {
1725             if (to.code.length != 0) {
1726                 uint256 end = _currentIndex;
1727                 uint256 index = end - quantity;
1728                 do {
1729                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1730                         revert TransferToNonERC721ReceiverImplementer();
1731                     }
1732                 } while (index < end);
1733                 // Reentrancy protection.
1734                 if (_currentIndex != end) revert();
1735             }
1736         }
1737     }
1738 
1739     /**
1740      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1741      */
1742     function _safeMint(address to, uint256 quantity) internal virtual {
1743         _safeMint(to, quantity, '');
1744     }
1745 
1746     // =============================================================
1747     //                        BURN OPERATIONS
1748     // =============================================================
1749 
1750     /**
1751      * @dev Equivalent to `_burn(tokenId, false)`.
1752      */
1753     function _burn(uint256 tokenId) internal virtual {
1754         _burn(tokenId, false);
1755     }
1756 
1757     /**
1758      * @dev Destroys `tokenId`.
1759      * The approval is cleared when the token is burned.
1760      *
1761      * Requirements:
1762      *
1763      * - `tokenId` must exist.
1764      *
1765      * Emits a {Transfer} event.
1766      */
1767     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1768         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1769 
1770         address from = address(uint160(prevOwnershipPacked));
1771 
1772         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1773 
1774         if (approvalCheck) {
1775             // The nested ifs save around 20+ gas over a compound boolean condition.
1776             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1777                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1778         }
1779 
1780         _beforeTokenTransfers(from, address(0), tokenId, 1);
1781 
1782         // Clear approvals from the previous owner.
1783         assembly {
1784             if approvedAddress {
1785                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1786                 sstore(approvedAddressSlot, 0)
1787             }
1788         }
1789 
1790         // Underflow of the sender's balance is impossible because we check for
1791         // ownership above and the recipient's balance can't realistically overflow.
1792         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1793         unchecked {
1794             // Updates:
1795             // - `balance -= 1`.
1796             // - `numberBurned += 1`.
1797             //
1798             // We can directly decrement the balance, and increment the number burned.
1799             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1800             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1801 
1802             // Updates:
1803             // - `address` to the last owner.
1804             // - `startTimestamp` to the timestamp of burning.
1805             // - `burned` to `true`.
1806             // - `nextInitialized` to `true`.
1807             _packedOwnerships[tokenId] = _packOwnershipData(
1808                 from,
1809                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1810             );
1811 
1812             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1813             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1814                 uint256 nextTokenId = tokenId + 1;
1815                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1816                 if (_packedOwnerships[nextTokenId] == 0) {
1817                     // If the next slot is within bounds.
1818                     if (nextTokenId != _currentIndex) {
1819                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1820                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1821                     }
1822                 }
1823             }
1824         }
1825 
1826         emit Transfer(from, address(0), tokenId);
1827         _afterTokenTransfers(from, address(0), tokenId, 1);
1828 
1829         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1830         unchecked {
1831             _burnCounter++;
1832         }
1833     }
1834 
1835     // =============================================================
1836     //                     EXTRA DATA OPERATIONS
1837     // =============================================================
1838 
1839     /**
1840      * @dev Directly sets the extra data for the ownership data `index`.
1841      */
1842     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1843         uint256 packed = _packedOwnerships[index];
1844         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1845         uint256 extraDataCasted;
1846         // Cast `extraData` with assembly to avoid redundant masking.
1847         assembly {
1848             extraDataCasted := extraData
1849         }
1850         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1851         _packedOwnerships[index] = packed;
1852     }
1853 
1854     /**
1855      * @dev Called during each token transfer to set the 24bit `extraData` field.
1856      * Intended to be overridden by the cosumer contract.
1857      *
1858      * `previousExtraData` - the value of `extraData` before transfer.
1859      *
1860      * Calling conditions:
1861      *
1862      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1863      * transferred to `to`.
1864      * - When `from` is zero, `tokenId` will be minted for `to`.
1865      * - When `to` is zero, `tokenId` will be burned by `from`.
1866      * - `from` and `to` are never both zero.
1867      */
1868     function _extraData(
1869         address from,
1870         address to,
1871         uint24 previousExtraData
1872     ) internal view virtual returns (uint24) {}
1873 
1874     /**
1875      * @dev Returns the next extra data for the packed ownership data.
1876      * The returned result is shifted into position.
1877      */
1878     function _nextExtraData(
1879         address from,
1880         address to,
1881         uint256 prevOwnershipPacked
1882     ) private view returns (uint256) {
1883         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1884         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1885     }
1886 
1887     // =============================================================
1888     //                       OTHER OPERATIONS
1889     // =============================================================
1890 
1891     /**
1892      * @dev Returns the message sender (defaults to `msg.sender`).
1893      *
1894      * If you are writing GSN compatible contracts, you need to override this function.
1895      */
1896     function _msgSenderERC721A() internal view virtual returns (address) {
1897         return msg.sender;
1898     }
1899 
1900     /**
1901      * @dev Converts a uint256 to its ASCII string decimal representation.
1902      */
1903     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1904         assembly {
1905             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1906             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1907             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1908             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1909             let m := add(mload(0x40), 0xa0)
1910             // Update the free memory pointer to allocate.
1911             mstore(0x40, m)
1912             // Assign the `str` to the end.
1913             str := sub(m, 0x20)
1914             // Zeroize the slot after the string.
1915             mstore(str, 0)
1916 
1917             // Cache the end of the memory to calculate the length later.
1918             let end := str
1919 
1920             // We write the string from rightmost digit to leftmost digit.
1921             // The following is essentially a do-while loop that also handles the zero case.
1922             // prettier-ignore
1923             for { let temp := value } 1 {} {
1924                 str := sub(str, 1)
1925                 // Write the character to the pointer.
1926                 // The ASCII index of the '0' character is 48.
1927                 mstore8(str, add(48, mod(temp, 10)))
1928                 // Keep dividing `temp` until zero.
1929                 temp := div(temp, 10)
1930                 // prettier-ignore
1931                 if iszero(temp) { break }
1932             }
1933 
1934             let length := sub(end, str)
1935             // Move the pointer 32 bytes leftwards to make room for the length.
1936             str := sub(str, 0x20)
1937             // Store the length.
1938             mstore(str, length)
1939         }
1940     }
1941 }
1942 
1943 /**
1944  * @title ERC721AQueryable.
1945  *
1946  * @dev ERC721A subclass with convenience query functions.
1947  */
1948 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1949     /**
1950      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1951      *
1952      * If the `tokenId` is out of bounds:
1953      *
1954      * - `addr = address(0)`
1955      * - `startTimestamp = 0`
1956      * - `burned = false`
1957      * - `extraData = 0`
1958      *
1959      * If the `tokenId` is burned:
1960      *
1961      * - `addr = <Address of owner before token was burned>`
1962      * - `startTimestamp = <Timestamp when token was burned>`
1963      * - `burned = true`
1964      * - `extraData = <Extra data when token was burned>`
1965      *
1966      * Otherwise:
1967      *
1968      * - `addr = <Address of owner>`
1969      * - `startTimestamp = <Timestamp of start of ownership>`
1970      * - `burned = false`
1971      * - `extraData = <Extra data at start of ownership>`
1972      */
1973     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1974         TokenOwnership memory ownership;
1975         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1976             return ownership;
1977         }
1978         ownership = _ownershipAt(tokenId);
1979         if (ownership.burned) {
1980             return ownership;
1981         }
1982         return _ownershipOf(tokenId);
1983     }
1984 
1985     /**
1986      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1987      * See {ERC721AQueryable-explicitOwnershipOf}
1988      */
1989     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1990         external
1991         view
1992         virtual
1993         override
1994         returns (TokenOwnership[] memory)
1995     {
1996         unchecked {
1997             uint256 tokenIdsLength = tokenIds.length;
1998             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1999             for (uint256 i; i != tokenIdsLength; ++i) {
2000                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2001             }
2002             return ownerships;
2003         }
2004     }
2005 
2006     /**
2007      * @dev Returns an array of token IDs owned by `owner`,
2008      * in the range [`start`, `stop`)
2009      * (i.e. `start <= tokenId < stop`).
2010      *
2011      * This function allows for tokens to be queried if the collection
2012      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2013      *
2014      * Requirements:
2015      *
2016      * - `start < stop`
2017      */
2018     function tokensOfOwnerIn(
2019         address owner,
2020         uint256 start,
2021         uint256 stop
2022     ) external view virtual override returns (uint256[] memory) {
2023         unchecked {
2024             if (start >= stop) revert InvalidQueryRange();
2025             uint256 tokenIdsIdx;
2026             uint256 stopLimit = _nextTokenId();
2027             // Set `start = max(start, _startTokenId())`.
2028             if (start < _startTokenId()) {
2029                 start = _startTokenId();
2030             }
2031             // Set `stop = min(stop, stopLimit)`.
2032             if (stop > stopLimit) {
2033                 stop = stopLimit;
2034             }
2035             uint256 tokenIdsMaxLength = balanceOf(owner);
2036             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2037             // to cater for cases where `balanceOf(owner)` is too big.
2038             if (start < stop) {
2039                 uint256 rangeLength = stop - start;
2040                 if (rangeLength < tokenIdsMaxLength) {
2041                     tokenIdsMaxLength = rangeLength;
2042                 }
2043             } else {
2044                 tokenIdsMaxLength = 0;
2045             }
2046             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2047             if (tokenIdsMaxLength == 0) {
2048                 return tokenIds;
2049             }
2050             // We need to call `explicitOwnershipOf(start)`,
2051             // because the slot at `start` may not be initialized.
2052             TokenOwnership memory ownership = explicitOwnershipOf(start);
2053             address currOwnershipAddr;
2054             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2055             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2056             if (!ownership.burned) {
2057                 currOwnershipAddr = ownership.addr;
2058             }
2059             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2060                 ownership = _ownershipAt(i);
2061                 if (ownership.burned) {
2062                     continue;
2063                 }
2064                 if (ownership.addr != address(0)) {
2065                     currOwnershipAddr = ownership.addr;
2066                 }
2067                 if (currOwnershipAddr == owner) {
2068                     tokenIds[tokenIdsIdx++] = i;
2069                 }
2070             }
2071             // Downsize the array to fit.
2072             assembly {
2073                 mstore(tokenIds, tokenIdsIdx)
2074             }
2075             return tokenIds;
2076         }
2077     }
2078 
2079     /**
2080      * @dev Returns an array of token IDs owned by `owner`.
2081      *
2082      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2083      * It is meant to be called off-chain.
2084      *
2085      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2086      * multiple smaller scans if the collection is large enough to cause
2087      * an out-of-gas error (10K collections should be fine).
2088      */
2089     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2090         unchecked {
2091             uint256 tokenIdsIdx;
2092             address currOwnershipAddr;
2093             uint256 tokenIdsLength = balanceOf(owner);
2094             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2095             TokenOwnership memory ownership;
2096             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2097                 ownership = _ownershipAt(i);
2098                 if (ownership.burned) {
2099                     continue;
2100                 }
2101                 if (ownership.addr != address(0)) {
2102                     currOwnershipAddr = ownership.addr;
2103                 }
2104                 if (currOwnershipAddr == owner) {
2105                     tokenIds[tokenIdsIdx++] = i;
2106                 }
2107             }
2108             return tokenIds;
2109         }
2110     }
2111 }
2112 
2113 interface IOperatorFilterRegistry {
2114     /**
2115      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
2116      *         true if supplied registrant address is not registered.
2117      */
2118     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2119 
2120     /**
2121      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
2122      */
2123     function register(address registrant) external;
2124 
2125     /**
2126      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
2127      */
2128     function registerAndSubscribe(address registrant, address subscription) external;
2129 
2130     /**
2131      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
2132      *         address without subscribing.
2133      */
2134     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2135 
2136     /**
2137      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
2138      *         Note that this does not remove any filtered addresses or codeHashes.
2139      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
2140      */
2141     function unregister(address addr) external;
2142 
2143     /**
2144      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
2145      */
2146     function updateOperator(address registrant, address operator, bool filtered) external;
2147 
2148     /**
2149      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
2150      */
2151     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2152 
2153     /**
2154      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
2155      */
2156     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2157 
2158     /**
2159      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
2160      */
2161     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2162 
2163     /**
2164      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
2165      *         subscription if present.
2166      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
2167      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
2168      *         used.
2169      */
2170     function subscribe(address registrant, address registrantToSubscribe) external;
2171 
2172     /**
2173      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
2174      */
2175     function unsubscribe(address registrant, bool copyExistingEntries) external;
2176 
2177     /**
2178      * @notice Get the subscription address of a given registrant, if any.
2179      */
2180     function subscriptionOf(address addr) external returns (address registrant);
2181 
2182     /**
2183      * @notice Get the set of addresses subscribed to a given registrant.
2184      *         Note that order is not guaranteed as updates are made.
2185      */
2186     function subscribers(address registrant) external returns (address[] memory);
2187 
2188     /**
2189      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
2190      *         Note that order is not guaranteed as updates are made.
2191      */
2192     function subscriberAt(address registrant, uint256 index) external returns (address);
2193 
2194     /**
2195      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
2196      */
2197     function copyEntriesOf(address registrant, address registrantToCopy) external;
2198 
2199     /**
2200      * @notice Returns true if operator is filtered by a given address or its subscription.
2201      */
2202     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2203 
2204     /**
2205      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
2206      */
2207     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2208 
2209     /**
2210      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
2211      */
2212     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2213 
2214     /**
2215      * @notice Returns a list of filtered operators for a given address or its subscription.
2216      */
2217     function filteredOperators(address addr) external returns (address[] memory);
2218 
2219     /**
2220      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
2221      *         Note that order is not guaranteed as updates are made.
2222      */
2223     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2224 
2225     /**
2226      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
2227      *         its subscription.
2228      *         Note that order is not guaranteed as updates are made.
2229      */
2230     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2231 
2232     /**
2233      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
2234      *         its subscription.
2235      *         Note that order is not guaranteed as updates are made.
2236      */
2237     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2238 
2239     /**
2240      * @notice Returns true if an address has registered
2241      */
2242     function isRegistered(address addr) external returns (bool);
2243 
2244     /**
2245      * @dev Convenience method to compute the code hash of an arbitrary contract
2246      */
2247     function codeHashOf(address addr) external returns (bytes32);
2248 }
2249 
2250 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
2251 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2252 
2253 /**
2254  * @title  OperatorFilterer
2255  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2256  *         registrant's entries in the OperatorFilterRegistry.
2257  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2258  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2259  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2260  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
2261  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2262  *         will be locked to the options set during construction.
2263  */
2264 
2265 abstract contract OperatorFilterer {
2266     /// @dev Emitted when an operator is not allowed.
2267     error OperatorNotAllowed(address operator);
2268 
2269     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2270         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
2271 
2272     /// @dev The constructor that is called when the contract is being deployed.
2273     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2274         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2275         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2276         // order for the modifier to filter addresses.
2277         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2278             if (subscribe) {
2279                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2280             } else {
2281                 if (subscriptionOrRegistrantToCopy != address(0)) {
2282                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2283                 } else {
2284                     OPERATOR_FILTER_REGISTRY.register(address(this));
2285                 }
2286             }
2287         }
2288     }
2289 
2290     /**
2291      * @dev A helper function to check if an operator is allowed.
2292      */
2293     modifier onlyAllowedOperator(address from) virtual {
2294         // Allow spending tokens from addresses with balance
2295         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2296         // from an EOA.
2297         if (from != msg.sender) {
2298             _checkFilterOperator(msg.sender);
2299         }
2300         _;
2301     }
2302 
2303     /**
2304      * @dev A helper function to check if an operator approval is allowed.
2305      */
2306     modifier onlyAllowedOperatorApproval(address operator) virtual {
2307         _checkFilterOperator(operator);
2308         _;
2309     }
2310 
2311     /**
2312      * @dev A helper function to check if an operator is allowed.
2313      */
2314     function _checkFilterOperator(address operator) internal view virtual {
2315         // Check registry code length to facilitate testing in environments without a deployed registry.
2316         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2317             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2318             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2319             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2320                 revert OperatorNotAllowed(operator);
2321             }
2322         }
2323     }
2324 }
2325 
2326 /**
2327  * @title  DefaultOperatorFilterer
2328  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2329  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2330  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2331  *         will be locked to the options set during construction.
2332  */
2333 
2334 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2335     /// @dev The constructor that is called when the contract is being deployed.
2336     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2337 }
2338 
2339 pragma solidity ^0.8.19;
2340 
2341 error ZeroBalance();
2342 error SaleNotActive();
2343 error AddressNotWhitelisted();
2344 error SoldOut();
2345 error MaxPerTransactionExceeded();
2346 error AlreadyMintedDuringPresale();
2347 
2348 contract Punks2023 is DefaultOperatorFilterer, ERC2981, ERC721AQueryable, Ownable {
2349   using MerkleProof for bytes32[];
2350   bytes32 public whitelistMerkleRoot;
2351   bool public presaleActive;
2352   bool public publicsaleActive;
2353   uint256 public punkPerTransaction = 1;
2354   uint256 public constant SUPPLY = 10000;
2355   string public baseURI;
2356   mapping (address => uint256) public presaleClaimAmount;
2357 
2358   constructor() ERC721A("Punks2023", "PUNK2023") { }
2359 
2360   /* ADMIN FUNCTIONS */
2361   function togglePublicSale() external onlyOwner {
2362     publicsaleActive = !publicsaleActive;
2363   }
2364 
2365   function togglePresale() external onlyOwner {
2366     presaleActive = !presaleActive;
2367   }
2368 
2369   function setPunkPerTransaction(uint256 count) external onlyOwner {
2370     punkPerTransaction = count;
2371   }
2372 
2373   function withdraw() external onlyOwner {
2374     uint256 balance = address(this).balance;
2375     if (balance == 0) revert ZeroBalance();
2376     address owner = payable(msg.sender);
2377 
2378     (bool ownerSuccess, ) = owner.call{value: address(this).balance}("");
2379     require(ownerSuccess, "Failed to send to Owner.");
2380   }
2381 
2382   function setBaseUri(string memory _uri) external onlyOwner {
2383     baseURI = _uri;
2384   }
2385 
2386   function setMerkleRoot(bytes32 root) external onlyOwner {
2387     whitelistMerkleRoot = root;
2388   }
2389 
2390   function adminMint(address wallet, uint256 count) external onlyOwner {
2391     if (SUPPLY < (totalSupply() + count)) revert SoldOut();
2392 
2393     _mint(wallet, count);
2394   }
2395   /* END ADMIN FUNCTIONS */
2396 
2397   function presaleMint(uint256 count, bytes32[] memory proof) payable public {
2398     if (!presaleActive) revert SaleNotActive();
2399     if (SUPPLY < (totalSupply() + count)) revert SoldOut();
2400     if (count > punkPerTransaction) revert MaxPerTransactionExceeded();
2401     if (!_verify(_leaf(msg.sender), whitelistMerkleRoot, proof)) revert AddressNotWhitelisted();
2402     if (presaleClaimAmount[msg.sender] + count > punkPerTransaction) revert AlreadyMintedDuringPresale();
2403 
2404     presaleClaimAmount[msg.sender] += count;
2405     _mint(msg.sender, count);
2406   }
2407 
2408   function mint(uint256 count) payable public {
2409     if (!publicsaleActive) revert SaleNotActive();
2410     if (SUPPLY < (totalSupply() + count)) revert SoldOut();
2411     if (count > punkPerTransaction) revert MaxPerTransactionExceeded();
2412 
2413     _mint(msg.sender, count);
2414   }
2415 
2416   function _leaf(address account) internal pure returns (bytes32) {
2417     return keccak256(abi.encodePacked(account));
2418   }
2419 
2420   function _verify(bytes32 leaf, bytes32 root, bytes32[] memory proof) internal pure returns (bool) {
2421     return MerkleProof.verify(proof, root, leaf);
2422   }
2423 
2424   function _baseURI() internal view virtual override returns (string memory) {
2425     return baseURI;
2426   }
2427 
2428   function setApprovalForAll(address operator, bool approved)
2429     public
2430     override(ERC721A, IERC721A)
2431     onlyAllowedOperatorApproval(operator)
2432   {
2433     super.setApprovalForAll(operator, approved);
2434   }
2435 
2436   function approve(address operator, uint256 tokenId) public override(ERC721A, IERC721A) payable onlyAllowedOperatorApproval(operator) {
2437     super.approve(operator, tokenId);
2438   }
2439 
2440   function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) payable onlyAllowedOperator(from) {
2441     super.transferFrom(from, to, tokenId);
2442   }
2443 
2444   function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) payable onlyAllowedOperator(from) {
2445     super.safeTransferFrom(from, to, tokenId);
2446   }
2447 
2448   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2449     public
2450     override(ERC721A, IERC721A)
2451     payable
2452     onlyAllowedOperator(from)
2453   {
2454     super.safeTransferFrom(from, to, tokenId, data);
2455   }
2456 
2457   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A, ERC2981) returns (bool) {
2458     return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2459   }
2460 }