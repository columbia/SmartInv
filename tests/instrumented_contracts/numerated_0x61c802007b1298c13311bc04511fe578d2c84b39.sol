1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)
4 
5 /**
6  * @dev These functions deal with verification of Merkle Tree proofs.
7  *
8  * The tree and the proofs can be generated using our
9  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
10  * You will find a quickstart guide in the readme.
11  *
12  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
13  * hashing, or use a hash function other than keccak256 for hashing leaves.
14  * This is because the concatenation of a sorted pair of internal nodes in
15  * the merkle tree could be reinterpreted as a leaf value.
16  * OpenZeppelin's JavaScript library generates merkle trees that are safe
17  * against this attack out of the box.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
27         return processProof(proof, leaf) == root;
28     }
29 
30     /**
31      * @dev Calldata version of {verify}
32      *
33      * _Available since v4.7._
34      */
35     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
36         return processProofCalldata(proof, leaf) == root;
37     }
38 
39     /**
40      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
41      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
42      * hash matches the root of the tree. When processing the proof, the pairs
43      * of leafs & pre-images are assumed to be sorted.
44      *
45      * _Available since v4.4._
46      */
47     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
48         bytes32 computedHash = leaf;
49         for (uint256 i = 0; i < proof.length; i++) {
50             computedHash = _hashPair(computedHash, proof[i]);
51         }
52         return computedHash;
53     }
54 
55     /**
56      * @dev Calldata version of {processProof}
57      *
58      * _Available since v4.7._
59      */
60     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
61         bytes32 computedHash = leaf;
62         for (uint256 i = 0; i < proof.length; i++) {
63             computedHash = _hashPair(computedHash, proof[i]);
64         }
65         return computedHash;
66     }
67 
68     /**
69      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
70      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
71      *
72      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
73      *
74      * _Available since v4.7._
75      */
76     function multiProofVerify(
77         bytes32[] memory proof,
78         bool[] memory proofFlags,
79         bytes32 root,
80         bytes32[] memory leaves
81     ) internal pure returns (bool) {
82         return processMultiProof(proof, proofFlags, leaves) == root;
83     }
84 
85     /**
86      * @dev Calldata version of {multiProofVerify}
87      *
88      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
89      *
90      * _Available since v4.7._
91      */
92     function multiProofVerifyCalldata(
93         bytes32[] calldata proof,
94         bool[] calldata proofFlags,
95         bytes32 root,
96         bytes32[] memory leaves
97     ) internal pure returns (bool) {
98         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
99     }
100 
101     /**
102      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
103      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
104      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
105      * respectively.
106      *
107      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
108      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
109      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
110      *
111      * _Available since v4.7._
112      */
113     function processMultiProof(
114         bytes32[] memory proof,
115         bool[] memory proofFlags,
116         bytes32[] memory leaves
117     ) internal pure returns (bytes32 merkleRoot) {
118         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
119         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
120         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
121         // the merkle tree.
122         uint256 leavesLen = leaves.length;
123         uint256 proofLen = proof.length;
124         uint256 totalHashes = proofFlags.length;
125 
126         // Check proof validity.
127         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
128 
129         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
130         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
131         bytes32[] memory hashes = new bytes32[](totalHashes);
132         uint256 leafPos = 0;
133         uint256 hashPos = 0;
134         uint256 proofPos = 0;
135         // At each step, we compute the next hash using two values:
136         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
137         //   get the next hash.
138         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
139         //   `proof` array.
140         for (uint256 i = 0; i < totalHashes; i++) {
141             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
142             bytes32 b = proofFlags[i]
143                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
144                 : proof[proofPos++];
145             hashes[i] = _hashPair(a, b);
146         }
147 
148         if (totalHashes > 0) {
149             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
150             unchecked {
151                 return hashes[totalHashes - 1];
152             }
153         } else if (leavesLen > 0) {
154             return leaves[0];
155         } else {
156             return proof[0];
157         }
158     }
159 
160     /**
161      * @dev Calldata version of {processMultiProof}.
162      *
163      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
164      *
165      * _Available since v4.7._
166      */
167     function processMultiProofCalldata(
168         bytes32[] calldata proof,
169         bool[] calldata proofFlags,
170         bytes32[] memory leaves
171     ) internal pure returns (bytes32 merkleRoot) {
172         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
173         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
174         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
175         // the merkle tree.
176         uint256 leavesLen = leaves.length;
177         uint256 proofLen = proof.length;
178         uint256 totalHashes = proofFlags.length;
179 
180         // Check proof validity.
181         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
182 
183         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
184         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
185         bytes32[] memory hashes = new bytes32[](totalHashes);
186         uint256 leafPos = 0;
187         uint256 hashPos = 0;
188         uint256 proofPos = 0;
189         // At each step, we compute the next hash using two values:
190         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
191         //   get the next hash.
192         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
193         //   `proof` array.
194         for (uint256 i = 0; i < totalHashes; i++) {
195             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
196             bytes32 b = proofFlags[i]
197                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
198                 : proof[proofPos++];
199             hashes[i] = _hashPair(a, b);
200         }
201 
202         if (totalHashes > 0) {
203             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
204             unchecked {
205                 return hashes[totalHashes - 1];
206             }
207         } else if (leavesLen > 0) {
208             return leaves[0];
209         } else {
210             return proof[0];
211         }
212     }
213 
214     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
215         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
216     }
217 
218     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
219         /// @solidity memory-safe-assembly
220         assembly {
221             mstore(0x00, a)
222             mstore(0x20, b)
223             value := keccak256(0x00, 0x40)
224         }
225     }
226 }
227 
228 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
231 
232 /**
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         return msg.data;
249     }
250 }
251 
252 /**
253  * @dev Contract module which provides a basic access control mechanism, where
254  * there is an account (an owner) that can be granted exclusive access to
255  * specific functions.
256  *
257  * By default, the owner account will be the one that deploys the contract. This
258  * can later be changed with {transferOwnership}.
259  *
260  * This module is used through inheritance. It will make available the modifier
261  * `onlyOwner`, which can be applied to your functions to restrict their use to
262  * the owner.
263  */
264 abstract contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268 
269     /**
270      * @dev Initializes the contract setting the deployer as the initial owner.
271      */
272     constructor() {
273         _transferOwnership(_msgSender());
274     }
275 
276     /**
277      * @dev Throws if called by any account other than the owner.
278      */
279     modifier onlyOwner() {
280         _checkOwner();
281         _;
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view virtual returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if the sender is not the owner.
293      */
294     function _checkOwner() internal view virtual {
295         require(owner() == _msgSender(), "Ownable: caller is not the owner");
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby disabling any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _transferOwnership(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         _transferOwnership(newOwner);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Internal function without access restriction.
321      */
322     function _transferOwnership(address newOwner) internal virtual {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // OpenZeppelin Contracts (last updated v4.9.0) (token/common/ERC2981.sol)
330 
331 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC2981.sol)
332 
333 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
334 
335 /**
336  * @dev Interface of the ERC165 standard, as defined in the
337  * https://eips.ethereum.org/EIPS/eip-165[EIP].
338  *
339  * Implementers can declare support of contract interfaces, which can then be
340  * queried by others ({ERC165Checker}).
341  *
342  * For an implementation, see {ERC165}.
343  */
344 interface IERC165 {
345     /**
346      * @dev Returns true if this contract implements the interface defined by
347      * `interfaceId`. See the corresponding
348      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
349      * to learn more about how these ids are created.
350      *
351      * This function call must use less than 30 000 gas.
352      */
353     function supportsInterface(bytes4 interfaceId) external view returns (bool);
354 }
355 
356 /**
357  * @dev Interface for the NFT Royalty Standard.
358  *
359  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
360  * support for royalty payments across all NFT marketplaces and ecosystem participants.
361  *
362  * _Available since v4.5._
363  */
364 interface IERC2981 is IERC165 {
365     /**
366      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
367      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
368      */
369     function royaltyInfo(
370         uint256 tokenId,
371         uint256 salePrice
372     ) external view returns (address receiver, uint256 royaltyAmount);
373 }
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
376 
377 /**
378  * @dev Implementation of the {IERC165} interface.
379  *
380  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
381  * for the additional interface id that will be supported. For example:
382  *
383  * ```solidity
384  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
385  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
386  * }
387  * ```
388  *
389  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
390  */
391 abstract contract ERC165 is IERC165 {
392     /**
393      * @dev See {IERC165-supportsInterface}.
394      */
395     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
396         return interfaceId == type(IERC165).interfaceId;
397     }
398 }
399 
400 /**
401  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
402  *
403  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
404  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
405  *
406  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
407  * fee is specified in basis points by default.
408  *
409  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
410  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
411  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
412  *
413  * _Available since v4.5._
414  */
415 abstract contract ERC2981 is IERC2981, ERC165 {
416     struct RoyaltyInfo {
417         address receiver;
418         uint96 royaltyFraction;
419     }
420 
421     RoyaltyInfo private _defaultRoyaltyInfo;
422     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
423 
424     /**
425      * @dev See {IERC165-supportsInterface}.
426      */
427     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
428         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
429     }
430 
431     /**
432      * @inheritdoc IERC2981
433      */
434     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
435         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
436 
437         if (royalty.receiver == address(0)) {
438             royalty = _defaultRoyaltyInfo;
439         }
440 
441         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
442 
443         return (royalty.receiver, royaltyAmount);
444     }
445 
446     /**
447      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
448      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
449      * override.
450      */
451     function _feeDenominator() internal pure virtual returns (uint96) {
452         return 10000;
453     }
454 
455     /**
456      * @dev Sets the royalty information that all ids in this contract will default to.
457      *
458      * Requirements:
459      *
460      * - `receiver` cannot be the zero address.
461      * - `feeNumerator` cannot be greater than the fee denominator.
462      */
463     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
464         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
465         require(receiver != address(0), "ERC2981: invalid receiver");
466 
467         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
468     }
469 
470     /**
471      * @dev Removes default royalty information.
472      */
473     function _deleteDefaultRoyalty() internal virtual {
474         delete _defaultRoyaltyInfo;
475     }
476 
477     /**
478      * @dev Sets the royalty information for a specific token id, overriding the global default.
479      *
480      * Requirements:
481      *
482      * - `receiver` cannot be the zero address.
483      * - `feeNumerator` cannot be greater than the fee denominator.
484      */
485     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
486         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
487         require(receiver != address(0), "ERC2981: Invalid parameters");
488 
489         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
490     }
491 
492     /**
493      * @dev Resets royalty information for the token id back to the global default.
494      */
495     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
496         delete _tokenRoyaltyInfo[tokenId];
497     }
498 }
499 
500 // ERC721A Contracts v4.2.3
501 // Creator: Chiru Labs
502 
503 // ERC721A Contracts v4.2.3
504 // Creator: Chiru Labs
505 
506 // ERC721A Contracts v4.2.3
507 // Creator: Chiru Labs
508 
509 /**
510  * @dev Interface of ERC721A.
511  */
512 interface IERC721A {
513     /**
514      * The caller must own the token or be an approved operator.
515      */
516     error ApprovalCallerNotOwnerNorApproved();
517 
518     /**
519      * The token does not exist.
520      */
521     error ApprovalQueryForNonexistentToken();
522 
523     /**
524      * Cannot query the balance for the zero address.
525      */
526     error BalanceQueryForZeroAddress();
527 
528     /**
529      * Cannot mint to the zero address.
530      */
531     error MintToZeroAddress();
532 
533     /**
534      * The quantity of tokens minted must be more than zero.
535      */
536     error MintZeroQuantity();
537 
538     /**
539      * The token does not exist.
540      */
541     error OwnerQueryForNonexistentToken();
542 
543     /**
544      * The caller must own the token or be an approved operator.
545      */
546     error TransferCallerNotOwnerNorApproved();
547 
548     /**
549      * The token must be owned by `from`.
550      */
551     error TransferFromIncorrectOwner();
552 
553     /**
554      * Cannot safely transfer to a contract that does not implement the
555      * ERC721Receiver interface.
556      */
557     error TransferToNonERC721ReceiverImplementer();
558 
559     /**
560      * Cannot transfer to the zero address.
561      */
562     error TransferToZeroAddress();
563 
564     /**
565      * The token does not exist.
566      */
567     error URIQueryForNonexistentToken();
568 
569     /**
570      * The `quantity` minted with ERC2309 exceeds the safety limit.
571      */
572     error MintERC2309QuantityExceedsLimit();
573 
574     /**
575      * The `extraData` cannot be set on an unintialized ownership slot.
576      */
577     error OwnershipNotInitializedForExtraData();
578 
579     // =============================================================
580     //                            STRUCTS
581     // =============================================================
582 
583     struct TokenOwnership {
584         // The address of the owner.
585         address addr;
586         // Stores the start time of ownership with minimal overhead for tokenomics.
587         uint64 startTimestamp;
588         // Whether the token has been burned.
589         bool burned;
590         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
591         uint24 extraData;
592     }
593 
594     // =============================================================
595     //                         TOKEN COUNTERS
596     // =============================================================
597 
598     /**
599      * @dev Returns the total number of tokens in existence.
600      * Burned tokens will reduce the count.
601      * To get the total number of tokens minted, please see {_totalMinted}.
602      */
603     function totalSupply() external view returns (uint256);
604 
605     // =============================================================
606     //                            IERC165
607     // =============================================================
608 
609     /**
610      * @dev Returns true if this contract implements the interface defined by
611      * `interfaceId`. See the corresponding
612      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
613      * to learn more about how these ids are created.
614      *
615      * This function call must use less than 30000 gas.
616      */
617     function supportsInterface(bytes4 interfaceId) external view returns (bool);
618 
619     // =============================================================
620     //                            IERC721
621     // =============================================================
622 
623     /**
624      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
625      */
626     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
630      */
631     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
632 
633     /**
634      * @dev Emitted when `owner` enables or disables
635      * (`approved`) `operator` to manage all of its assets.
636      */
637     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
638 
639     /**
640      * @dev Returns the number of tokens in `owner`'s account.
641      */
642     function balanceOf(address owner) external view returns (uint256 balance);
643 
644     /**
645      * @dev Returns the owner of the `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function ownerOf(uint256 tokenId) external view returns (address owner);
652 
653     /**
654      * @dev Safely transfers `tokenId` token from `from` to `to`,
655      * checking first that contract recipients are aware of the ERC721 protocol
656      * to prevent tokens from being forever locked.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be have been allowed to move
664      * this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement
666      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667      *
668      * Emits a {Transfer} event.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId,
674         bytes calldata data
675     ) external payable;
676 
677     /**
678      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId
684     ) external payable;
685 
686     /**
687      * @dev Transfers `tokenId` from `from` to `to`.
688      *
689      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
690      * whenever possible.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token
698      * by either {approve} or {setApprovalForAll}.
699      *
700      * Emits a {Transfer} event.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external payable;
707 
708     /**
709      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
710      * The approval is cleared when the token is transferred.
711      *
712      * Only a single account can be approved at a time, so approving the
713      * zero address clears previous approvals.
714      *
715      * Requirements:
716      *
717      * - The caller must own the token or be an approved operator.
718      * - `tokenId` must exist.
719      *
720      * Emits an {Approval} event.
721      */
722     function approve(address to, uint256 tokenId) external payable;
723 
724     /**
725      * @dev Approve or remove `operator` as an operator for the caller.
726      * Operators can call {transferFrom} or {safeTransferFrom}
727      * for any token owned by the caller.
728      *
729      * Requirements:
730      *
731      * - The `operator` cannot be the caller.
732      *
733      * Emits an {ApprovalForAll} event.
734      */
735     function setApprovalForAll(address operator, bool _approved) external;
736 
737     /**
738      * @dev Returns the account approved for `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function getApproved(uint256 tokenId) external view returns (address operator);
745 
746     /**
747      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
748      *
749      * See {setApprovalForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) external view returns (bool);
752 
753     // =============================================================
754     //                        IERC721Metadata
755     // =============================================================
756 
757     /**
758      * @dev Returns the token collection name.
759      */
760     function name() external view returns (string memory);
761 
762     /**
763      * @dev Returns the token collection symbol.
764      */
765     function symbol() external view returns (string memory);
766 
767     /**
768      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
769      */
770     function tokenURI(uint256 tokenId) external view returns (string memory);
771 
772     // =============================================================
773     //                           IERC2309
774     // =============================================================
775 
776     /**
777      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
778      * (inclusive) is transferred from `from` to `to`, as defined in the
779      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
780      *
781      * See {_mintERC2309} for more details.
782      */
783     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
784 }
785 
786 /**
787  * @dev Interface of ERC721AQueryable.
788  */
789 interface IERC721AQueryable is IERC721A {
790     /**
791      * Invalid query range (`start` >= `stop`).
792      */
793     error InvalidQueryRange();
794 
795     /**
796      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
797      *
798      * If the `tokenId` is out of bounds:
799      *
800      * - `addr = address(0)`
801      * - `startTimestamp = 0`
802      * - `burned = false`
803      * - `extraData = 0`
804      *
805      * If the `tokenId` is burned:
806      *
807      * - `addr = <Address of owner before token was burned>`
808      * - `startTimestamp = <Timestamp when token was burned>`
809      * - `burned = true`
810      * - `extraData = <Extra data when token was burned>`
811      *
812      * Otherwise:
813      *
814      * - `addr = <Address of owner>`
815      * - `startTimestamp = <Timestamp of start of ownership>`
816      * - `burned = false`
817      * - `extraData = <Extra data at start of ownership>`
818      */
819     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
820 
821     /**
822      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
823      * See {ERC721AQueryable-explicitOwnershipOf}
824      */
825     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
826 
827     /**
828      * @dev Returns an array of token IDs owned by `owner`,
829      * in the range [`start`, `stop`)
830      * (i.e. `start <= tokenId < stop`).
831      *
832      * This function allows for tokens to be queried if the collection
833      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
834      *
835      * Requirements:
836      *
837      * - `start < stop`
838      */
839     function tokensOfOwnerIn(
840         address owner,
841         uint256 start,
842         uint256 stop
843     ) external view returns (uint256[] memory);
844 
845     /**
846      * @dev Returns an array of token IDs owned by `owner`.
847      *
848      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
849      * It is meant to be called off-chain.
850      *
851      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
852      * multiple smaller scans if the collection is large enough to cause
853      * an out-of-gas error (10K collections should be fine).
854      */
855     function tokensOfOwner(address owner) external view returns (uint256[] memory);
856 }
857 
858 // ERC721A Contracts v4.2.3
859 // Creator: Chiru Labs
860 
861 /**
862  * @dev Interface of ERC721 token receiver.
863  */
864 interface ERC721A__IERC721Receiver {
865     function onERC721Received(
866         address operator,
867         address from,
868         uint256 tokenId,
869         bytes calldata data
870     ) external returns (bytes4);
871 }
872 
873 /**
874  * @title ERC721A
875  *
876  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
877  * Non-Fungible Token Standard, including the Metadata extension.
878  * Optimized for lower gas during batch mints.
879  *
880  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
881  * starting from `_startTokenId()`.
882  *
883  * Assumptions:
884  *
885  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
886  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
887  */
888 contract ERC721A is IERC721A {
889     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
890     struct TokenApprovalRef {
891         address value;
892     }
893 
894     // =============================================================
895     //                           CONSTANTS
896     // =============================================================
897 
898     // Mask of an entry in packed address data.
899     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
900 
901     // The bit position of `numberMinted` in packed address data.
902     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
903 
904     // The bit position of `numberBurned` in packed address data.
905     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
906 
907     // The bit position of `aux` in packed address data.
908     uint256 private constant _BITPOS_AUX = 192;
909 
910     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
911     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
912 
913     // The bit position of `startTimestamp` in packed ownership.
914     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
915 
916     // The bit mask of the `burned` bit in packed ownership.
917     uint256 private constant _BITMASK_BURNED = 1 << 224;
918 
919     // The bit position of the `nextInitialized` bit in packed ownership.
920     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
921 
922     // The bit mask of the `nextInitialized` bit in packed ownership.
923     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
924 
925     // The bit position of `extraData` in packed ownership.
926     uint256 private constant _BITPOS_EXTRA_DATA = 232;
927 
928     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
929     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
930 
931     // The mask of the lower 160 bits for addresses.
932     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
933 
934     // The maximum `quantity` that can be minted with {_mintERC2309}.
935     // This limit is to prevent overflows on the address data entries.
936     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
937     // is required to cause an overflow, which is unrealistic.
938     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
939 
940     // The `Transfer` event signature is given by:
941     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
942     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
943         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
944 
945     // =============================================================
946     //                            STORAGE
947     // =============================================================
948 
949     // The next token ID to be minted.
950     uint256 private _currentIndex;
951 
952     // The number of tokens burned.
953     uint256 private _burnCounter;
954 
955     // Token name
956     string private _name;
957 
958     // Token symbol
959     string private _symbol;
960 
961     // Mapping from token ID to ownership details
962     // An empty struct value does not necessarily mean the token is unowned.
963     // See {_packedOwnershipOf} implementation for details.
964     //
965     // Bits Layout:
966     // - [0..159]   `addr`
967     // - [160..223] `startTimestamp`
968     // - [224]      `burned`
969     // - [225]      `nextInitialized`
970     // - [232..255] `extraData`
971     mapping(uint256 => uint256) private _packedOwnerships;
972 
973     // Mapping owner address to address data.
974     //
975     // Bits Layout:
976     // - [0..63]    `balance`
977     // - [64..127]  `numberMinted`
978     // - [128..191] `numberBurned`
979     // - [192..255] `aux`
980     mapping(address => uint256) private _packedAddressData;
981 
982     // Mapping from token ID to approved address.
983     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
984 
985     // Mapping from owner to operator approvals
986     mapping(address => mapping(address => bool)) private _operatorApprovals;
987 
988     // =============================================================
989     //                          CONSTRUCTOR
990     // =============================================================
991 
992     constructor(string memory name_, string memory symbol_) {
993         _name = name_;
994         _symbol = symbol_;
995         _currentIndex = _startTokenId();
996     }
997 
998     // =============================================================
999     //                   TOKEN COUNTING OPERATIONS
1000     // =============================================================
1001 
1002     /**
1003      * @dev Returns the starting token ID.
1004      * To change the starting token ID, please override this function.
1005      */
1006     function _startTokenId() internal view virtual returns (uint256) {
1007         return 0;
1008     }
1009 
1010     /**
1011      * @dev Returns the next token ID to be minted.
1012      */
1013     function _nextTokenId() internal view virtual returns (uint256) {
1014         return _currentIndex;
1015     }
1016 
1017     /**
1018      * @dev Returns the total number of tokens in existence.
1019      * Burned tokens will reduce the count.
1020      * To get the total number of tokens minted, please see {_totalMinted}.
1021      */
1022     function totalSupply() public view virtual override returns (uint256) {
1023         // Counter underflow is impossible as _burnCounter cannot be incremented
1024         // more than `_currentIndex - _startTokenId()` times.
1025         unchecked {
1026             return _currentIndex - _burnCounter - _startTokenId();
1027         }
1028     }
1029 
1030     /**
1031      * @dev Returns the total amount of tokens minted in the contract.
1032      */
1033     function _totalMinted() internal view virtual returns (uint256) {
1034         // Counter underflow is impossible as `_currentIndex` does not decrement,
1035         // and it is initialized to `_startTokenId()`.
1036         unchecked {
1037             return _currentIndex - _startTokenId();
1038         }
1039     }
1040 
1041     /**
1042      * @dev Returns the total number of tokens burned.
1043      */
1044     function _totalBurned() internal view virtual returns (uint256) {
1045         return _burnCounter;
1046     }
1047 
1048     // =============================================================
1049     //                    ADDRESS DATA OPERATIONS
1050     // =============================================================
1051 
1052     /**
1053      * @dev Returns the number of tokens in `owner`'s account.
1054      */
1055     function balanceOf(address owner) public view virtual override returns (uint256) {
1056         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1057         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1058     }
1059 
1060     /**
1061      * Returns the number of tokens minted by `owner`.
1062      */
1063     function _numberMinted(address owner) internal view returns (uint256) {
1064         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1065     }
1066 
1067     /**
1068      * Returns the number of tokens burned by or on behalf of `owner`.
1069      */
1070     function _numberBurned(address owner) internal view returns (uint256) {
1071         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1072     }
1073 
1074     /**
1075      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1076      */
1077     function _getAux(address owner) internal view returns (uint64) {
1078         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1079     }
1080 
1081     /**
1082      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1083      * If there are multiple variables, please pack them into a uint64.
1084      */
1085     function _setAux(address owner, uint64 aux) internal virtual {
1086         uint256 packed = _packedAddressData[owner];
1087         uint256 auxCasted;
1088         // Cast `aux` with assembly to avoid redundant masking.
1089         assembly {
1090             auxCasted := aux
1091         }
1092         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1093         _packedAddressData[owner] = packed;
1094     }
1095 
1096     // =============================================================
1097     //                            IERC165
1098     // =============================================================
1099 
1100     /**
1101      * @dev Returns true if this contract implements the interface defined by
1102      * `interfaceId`. See the corresponding
1103      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1104      * to learn more about how these ids are created.
1105      *
1106      * This function call must use less than 30000 gas.
1107      */
1108     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1109         // The interface IDs are constants representing the first 4 bytes
1110         // of the XOR of all function selectors in the interface.
1111         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1112         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1113         return
1114             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1115             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1116             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1117     }
1118 
1119     // =============================================================
1120     //                        IERC721Metadata
1121     // =============================================================
1122 
1123     /**
1124      * @dev Returns the token collection name.
1125      */
1126     function name() public view virtual override returns (string memory) {
1127         return _name;
1128     }
1129 
1130     /**
1131      * @dev Returns the token collection symbol.
1132      */
1133     function symbol() public view virtual override returns (string memory) {
1134         return _symbol;
1135     }
1136 
1137     /**
1138      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1139      */
1140     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1141         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1142 
1143         string memory baseURI = _baseURI();
1144         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1145     }
1146 
1147     /**
1148      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1149      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1150      * by default, it can be overridden in child contracts.
1151      */
1152     function _baseURI() internal view virtual returns (string memory) {
1153         return '';
1154     }
1155 
1156     // =============================================================
1157     //                     OWNERSHIPS OPERATIONS
1158     // =============================================================
1159 
1160     /**
1161      * @dev Returns the owner of the `tokenId` token.
1162      *
1163      * Requirements:
1164      *
1165      * - `tokenId` must exist.
1166      */
1167     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1168         return address(uint160(_packedOwnershipOf(tokenId)));
1169     }
1170 
1171     /**
1172      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1173      * It gradually moves to O(1) as tokens get transferred around over time.
1174      */
1175     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1176         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1177     }
1178 
1179     /**
1180      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1181      */
1182     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1183         return _unpackedOwnership(_packedOwnerships[index]);
1184     }
1185 
1186     /**
1187      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1188      */
1189     function _initializeOwnershipAt(uint256 index) internal virtual {
1190         if (_packedOwnerships[index] == 0) {
1191             _packedOwnerships[index] = _packedOwnershipOf(index);
1192         }
1193     }
1194 
1195     /**
1196      * Returns the packed ownership data of `tokenId`.
1197      */
1198     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1199         uint256 curr = tokenId;
1200 
1201         unchecked {
1202             if (_startTokenId() <= curr)
1203                 if (curr < _currentIndex) {
1204                     uint256 packed = _packedOwnerships[curr];
1205                     // If not burned.
1206                     if (packed & _BITMASK_BURNED == 0) {
1207                         // Invariant:
1208                         // There will always be an initialized ownership slot
1209                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1210                         // before an unintialized ownership slot
1211                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1212                         // Hence, `curr` will not underflow.
1213                         //
1214                         // We can directly compare the packed value.
1215                         // If the address is zero, packed will be zero.
1216                         while (packed == 0) {
1217                             packed = _packedOwnerships[--curr];
1218                         }
1219                         return packed;
1220                     }
1221                 }
1222         }
1223         revert OwnerQueryForNonexistentToken();
1224     }
1225 
1226     /**
1227      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1228      */
1229     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1230         ownership.addr = address(uint160(packed));
1231         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1232         ownership.burned = packed & _BITMASK_BURNED != 0;
1233         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1234     }
1235 
1236     /**
1237      * @dev Packs ownership data into a single uint256.
1238      */
1239     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1240         assembly {
1241             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1242             owner := and(owner, _BITMASK_ADDRESS)
1243             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1244             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1245         }
1246     }
1247 
1248     /**
1249      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1250      */
1251     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1252         // For branchless setting of the `nextInitialized` flag.
1253         assembly {
1254             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1255             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1256         }
1257     }
1258 
1259     // =============================================================
1260     //                      APPROVAL OPERATIONS
1261     // =============================================================
1262 
1263     /**
1264      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1265      * The approval is cleared when the token is transferred.
1266      *
1267      * Only a single account can be approved at a time, so approving the
1268      * zero address clears previous approvals.
1269      *
1270      * Requirements:
1271      *
1272      * - The caller must own the token or be an approved operator.
1273      * - `tokenId` must exist.
1274      *
1275      * Emits an {Approval} event.
1276      */
1277     function approve(address to, uint256 tokenId) public payable virtual override {
1278         address owner = ownerOf(tokenId);
1279 
1280         if (_msgSenderERC721A() != owner)
1281             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1282                 revert ApprovalCallerNotOwnerNorApproved();
1283             }
1284 
1285         _tokenApprovals[tokenId].value = to;
1286         emit Approval(owner, to, tokenId);
1287     }
1288 
1289     /**
1290      * @dev Returns the account approved for `tokenId` token.
1291      *
1292      * Requirements:
1293      *
1294      * - `tokenId` must exist.
1295      */
1296     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1297         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1298 
1299         return _tokenApprovals[tokenId].value;
1300     }
1301 
1302     /**
1303      * @dev Approve or remove `operator` as an operator for the caller.
1304      * Operators can call {transferFrom} or {safeTransferFrom}
1305      * for any token owned by the caller.
1306      *
1307      * Requirements:
1308      *
1309      * - The `operator` cannot be the caller.
1310      *
1311      * Emits an {ApprovalForAll} event.
1312      */
1313     function setApprovalForAll(address operator, bool approved) public virtual override {
1314         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1315         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1316     }
1317 
1318     /**
1319      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1320      *
1321      * See {setApprovalForAll}.
1322      */
1323     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1324         return _operatorApprovals[owner][operator];
1325     }
1326 
1327     /**
1328      * @dev Returns whether `tokenId` exists.
1329      *
1330      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1331      *
1332      * Tokens start existing when they are minted. See {_mint}.
1333      */
1334     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1335         return
1336             _startTokenId() <= tokenId &&
1337             tokenId < _currentIndex && // If within bounds,
1338             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1339     }
1340 
1341     /**
1342      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1343      */
1344     function _isSenderApprovedOrOwner(
1345         address approvedAddress,
1346         address owner,
1347         address msgSender
1348     ) private pure returns (bool result) {
1349         assembly {
1350             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1351             owner := and(owner, _BITMASK_ADDRESS)
1352             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1353             msgSender := and(msgSender, _BITMASK_ADDRESS)
1354             // `msgSender == owner || msgSender == approvedAddress`.
1355             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1356         }
1357     }
1358 
1359     /**
1360      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1361      */
1362     function _getApprovedSlotAndAddress(uint256 tokenId)
1363         private
1364         view
1365         returns (uint256 approvedAddressSlot, address approvedAddress)
1366     {
1367         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1368         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1369         assembly {
1370             approvedAddressSlot := tokenApproval.slot
1371             approvedAddress := sload(approvedAddressSlot)
1372         }
1373     }
1374 
1375     // =============================================================
1376     //                      TRANSFER OPERATIONS
1377     // =============================================================
1378 
1379     /**
1380      * @dev Transfers `tokenId` from `from` to `to`.
1381      *
1382      * Requirements:
1383      *
1384      * - `from` cannot be the zero address.
1385      * - `to` cannot be the zero address.
1386      * - `tokenId` token must be owned by `from`.
1387      * - If the caller is not `from`, it must be approved to move this token
1388      * by either {approve} or {setApprovalForAll}.
1389      *
1390      * Emits a {Transfer} event.
1391      */
1392     function transferFrom(
1393         address from,
1394         address to,
1395         uint256 tokenId
1396     ) public payable virtual override {
1397         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1398 
1399         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1400 
1401         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1402 
1403         // The nested ifs save around 20+ gas over a compound boolean condition.
1404         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1405             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1406 
1407         if (to == address(0)) revert TransferToZeroAddress();
1408 
1409         _beforeTokenTransfers(from, to, tokenId, 1);
1410 
1411         // Clear approvals from the previous owner.
1412         assembly {
1413             if approvedAddress {
1414                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1415                 sstore(approvedAddressSlot, 0)
1416             }
1417         }
1418 
1419         // Underflow of the sender's balance is impossible because we check for
1420         // ownership above and the recipient's balance can't realistically overflow.
1421         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1422         unchecked {
1423             // We can directly increment and decrement the balances.
1424             --_packedAddressData[from]; // Updates: `balance -= 1`.
1425             ++_packedAddressData[to]; // Updates: `balance += 1`.
1426 
1427             // Updates:
1428             // - `address` to the next owner.
1429             // - `startTimestamp` to the timestamp of transfering.
1430             // - `burned` to `false`.
1431             // - `nextInitialized` to `true`.
1432             _packedOwnerships[tokenId] = _packOwnershipData(
1433                 to,
1434                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1435             );
1436 
1437             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1438             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1439                 uint256 nextTokenId = tokenId + 1;
1440                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1441                 if (_packedOwnerships[nextTokenId] == 0) {
1442                     // If the next slot is within bounds.
1443                     if (nextTokenId != _currentIndex) {
1444                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1445                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1446                     }
1447                 }
1448             }
1449         }
1450 
1451         emit Transfer(from, to, tokenId);
1452         _afterTokenTransfers(from, to, tokenId, 1);
1453     }
1454 
1455     /**
1456      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1457      */
1458     function safeTransferFrom(
1459         address from,
1460         address to,
1461         uint256 tokenId
1462     ) public payable virtual override {
1463         safeTransferFrom(from, to, tokenId, '');
1464     }
1465 
1466     /**
1467      * @dev Safely transfers `tokenId` token from `from` to `to`.
1468      *
1469      * Requirements:
1470      *
1471      * - `from` cannot be the zero address.
1472      * - `to` cannot be the zero address.
1473      * - `tokenId` token must exist and be owned by `from`.
1474      * - If the caller is not `from`, it must be approved to move this token
1475      * by either {approve} or {setApprovalForAll}.
1476      * - If `to` refers to a smart contract, it must implement
1477      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1478      *
1479      * Emits a {Transfer} event.
1480      */
1481     function safeTransferFrom(
1482         address from,
1483         address to,
1484         uint256 tokenId,
1485         bytes memory _data
1486     ) public payable virtual override {
1487         transferFrom(from, to, tokenId);
1488         if (to.code.length != 0)
1489             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1490                 revert TransferToNonERC721ReceiverImplementer();
1491             }
1492     }
1493 
1494     /**
1495      * @dev Hook that is called before a set of serially-ordered token IDs
1496      * are about to be transferred. This includes minting.
1497      * And also called before burning one token.
1498      *
1499      * `startTokenId` - the first token ID to be transferred.
1500      * `quantity` - the amount to be transferred.
1501      *
1502      * Calling conditions:
1503      *
1504      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1505      * transferred to `to`.
1506      * - When `from` is zero, `tokenId` will be minted for `to`.
1507      * - When `to` is zero, `tokenId` will be burned by `from`.
1508      * - `from` and `to` are never both zero.
1509      */
1510     function _beforeTokenTransfers(
1511         address from,
1512         address to,
1513         uint256 startTokenId,
1514         uint256 quantity
1515     ) internal virtual {}
1516 
1517     /**
1518      * @dev Hook that is called after a set of serially-ordered token IDs
1519      * have been transferred. This includes minting.
1520      * And also called after one token has been burned.
1521      *
1522      * `startTokenId` - the first token ID to be transferred.
1523      * `quantity` - the amount to be transferred.
1524      *
1525      * Calling conditions:
1526      *
1527      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1528      * transferred to `to`.
1529      * - When `from` is zero, `tokenId` has been minted for `to`.
1530      * - When `to` is zero, `tokenId` has been burned by `from`.
1531      * - `from` and `to` are never both zero.
1532      */
1533     function _afterTokenTransfers(
1534         address from,
1535         address to,
1536         uint256 startTokenId,
1537         uint256 quantity
1538     ) internal virtual {}
1539 
1540     /**
1541      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1542      *
1543      * `from` - Previous owner of the given token ID.
1544      * `to` - Target address that will receive the token.
1545      * `tokenId` - Token ID to be transferred.
1546      * `_data` - Optional data to send along with the call.
1547      *
1548      * Returns whether the call correctly returned the expected magic value.
1549      */
1550     function _checkContractOnERC721Received(
1551         address from,
1552         address to,
1553         uint256 tokenId,
1554         bytes memory _data
1555     ) private returns (bool) {
1556         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1557             bytes4 retval
1558         ) {
1559             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1560         } catch (bytes memory reason) {
1561             if (reason.length == 0) {
1562                 revert TransferToNonERC721ReceiverImplementer();
1563             } else {
1564                 assembly {
1565                     revert(add(32, reason), mload(reason))
1566                 }
1567             }
1568         }
1569     }
1570 
1571     // =============================================================
1572     //                        MINT OPERATIONS
1573     // =============================================================
1574 
1575     /**
1576      * @dev Mints `quantity` tokens and transfers them to `to`.
1577      *
1578      * Requirements:
1579      *
1580      * - `to` cannot be the zero address.
1581      * - `quantity` must be greater than 0.
1582      *
1583      * Emits a {Transfer} event for each mint.
1584      */
1585     function _mint(address to, uint256 quantity) internal virtual {
1586         uint256 startTokenId = _currentIndex;
1587         if (quantity == 0) revert MintZeroQuantity();
1588 
1589         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1590 
1591         // Overflows are incredibly unrealistic.
1592         // `balance` and `numberMinted` have a maximum limit of 2**64.
1593         // `tokenId` has a maximum limit of 2**256.
1594         unchecked {
1595             // Updates:
1596             // - `balance += quantity`.
1597             // - `numberMinted += quantity`.
1598             //
1599             // We can directly add to the `balance` and `numberMinted`.
1600             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1601 
1602             // Updates:
1603             // - `address` to the owner.
1604             // - `startTimestamp` to the timestamp of minting.
1605             // - `burned` to `false`.
1606             // - `nextInitialized` to `quantity == 1`.
1607             _packedOwnerships[startTokenId] = _packOwnershipData(
1608                 to,
1609                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1610             );
1611 
1612             uint256 toMasked;
1613             uint256 end = startTokenId + quantity;
1614 
1615             // Use assembly to loop and emit the `Transfer` event for gas savings.
1616             // The duplicated `log4` removes an extra check and reduces stack juggling.
1617             // The assembly, together with the surrounding Solidity code, have been
1618             // delicately arranged to nudge the compiler into producing optimized opcodes.
1619             assembly {
1620                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1621                 toMasked := and(to, _BITMASK_ADDRESS)
1622                 // Emit the `Transfer` event.
1623                 log4(
1624                     0, // Start of data (0, since no data).
1625                     0, // End of data (0, since no data).
1626                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1627                     0, // `address(0)`.
1628                     toMasked, // `to`.
1629                     startTokenId // `tokenId`.
1630                 )
1631 
1632                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1633                 // that overflows uint256 will make the loop run out of gas.
1634                 // The compiler will optimize the `iszero` away for performance.
1635                 for {
1636                     let tokenId := add(startTokenId, 1)
1637                 } iszero(eq(tokenId, end)) {
1638                     tokenId := add(tokenId, 1)
1639                 } {
1640                     // Emit the `Transfer` event. Similar to above.
1641                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1642                 }
1643             }
1644             if (toMasked == 0) revert MintToZeroAddress();
1645 
1646             _currentIndex = end;
1647         }
1648         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1649     }
1650 
1651     /**
1652      * @dev Mints `quantity` tokens and transfers them to `to`.
1653      *
1654      * This function is intended for efficient minting only during contract creation.
1655      *
1656      * It emits only one {ConsecutiveTransfer} as defined in
1657      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1658      * instead of a sequence of {Transfer} event(s).
1659      *
1660      * Calling this function outside of contract creation WILL make your contract
1661      * non-compliant with the ERC721 standard.
1662      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1663      * {ConsecutiveTransfer} event is only permissible during contract creation.
1664      *
1665      * Requirements:
1666      *
1667      * - `to` cannot be the zero address.
1668      * - `quantity` must be greater than 0.
1669      *
1670      * Emits a {ConsecutiveTransfer} event.
1671      */
1672     function _mintERC2309(address to, uint256 quantity) internal virtual {
1673         uint256 startTokenId = _currentIndex;
1674         if (to == address(0)) revert MintToZeroAddress();
1675         if (quantity == 0) revert MintZeroQuantity();
1676         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1677 
1678         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1679 
1680         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1681         unchecked {
1682             // Updates:
1683             // - `balance += quantity`.
1684             // - `numberMinted += quantity`.
1685             //
1686             // We can directly add to the `balance` and `numberMinted`.
1687             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1688 
1689             // Updates:
1690             // - `address` to the owner.
1691             // - `startTimestamp` to the timestamp of minting.
1692             // - `burned` to `false`.
1693             // - `nextInitialized` to `quantity == 1`.
1694             _packedOwnerships[startTokenId] = _packOwnershipData(
1695                 to,
1696                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1697             );
1698 
1699             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1700 
1701             _currentIndex = startTokenId + quantity;
1702         }
1703         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1704     }
1705 
1706     /**
1707      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1708      *
1709      * Requirements:
1710      *
1711      * - If `to` refers to a smart contract, it must implement
1712      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1713      * - `quantity` must be greater than 0.
1714      *
1715      * See {_mint}.
1716      *
1717      * Emits a {Transfer} event for each mint.
1718      */
1719     function _safeMint(
1720         address to,
1721         uint256 quantity,
1722         bytes memory _data
1723     ) internal virtual {
1724         _mint(to, quantity);
1725 
1726         unchecked {
1727             if (to.code.length != 0) {
1728                 uint256 end = _currentIndex;
1729                 uint256 index = end - quantity;
1730                 do {
1731                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1732                         revert TransferToNonERC721ReceiverImplementer();
1733                     }
1734                 } while (index < end);
1735                 // Reentrancy protection.
1736                 if (_currentIndex != end) revert();
1737             }
1738         }
1739     }
1740 
1741     /**
1742      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1743      */
1744     function _safeMint(address to, uint256 quantity) internal virtual {
1745         _safeMint(to, quantity, '');
1746     }
1747 
1748     // =============================================================
1749     //                        BURN OPERATIONS
1750     // =============================================================
1751 
1752     /**
1753      * @dev Equivalent to `_burn(tokenId, false)`.
1754      */
1755     function _burn(uint256 tokenId) internal virtual {
1756         _burn(tokenId, false);
1757     }
1758 
1759     /**
1760      * @dev Destroys `tokenId`.
1761      * The approval is cleared when the token is burned.
1762      *
1763      * Requirements:
1764      *
1765      * - `tokenId` must exist.
1766      *
1767      * Emits a {Transfer} event.
1768      */
1769     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1770         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1771 
1772         address from = address(uint160(prevOwnershipPacked));
1773 
1774         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1775 
1776         if (approvalCheck) {
1777             // The nested ifs save around 20+ gas over a compound boolean condition.
1778             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1779                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1780         }
1781 
1782         _beforeTokenTransfers(from, address(0), tokenId, 1);
1783 
1784         // Clear approvals from the previous owner.
1785         assembly {
1786             if approvedAddress {
1787                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1788                 sstore(approvedAddressSlot, 0)
1789             }
1790         }
1791 
1792         // Underflow of the sender's balance is impossible because we check for
1793         // ownership above and the recipient's balance can't realistically overflow.
1794         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1795         unchecked {
1796             // Updates:
1797             // - `balance -= 1`.
1798             // - `numberBurned += 1`.
1799             //
1800             // We can directly decrement the balance, and increment the number burned.
1801             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1802             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1803 
1804             // Updates:
1805             // - `address` to the last owner.
1806             // - `startTimestamp` to the timestamp of burning.
1807             // - `burned` to `true`.
1808             // - `nextInitialized` to `true`.
1809             _packedOwnerships[tokenId] = _packOwnershipData(
1810                 from,
1811                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1812             );
1813 
1814             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1815             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1816                 uint256 nextTokenId = tokenId + 1;
1817                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1818                 if (_packedOwnerships[nextTokenId] == 0) {
1819                     // If the next slot is within bounds.
1820                     if (nextTokenId != _currentIndex) {
1821                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1822                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1823                     }
1824                 }
1825             }
1826         }
1827 
1828         emit Transfer(from, address(0), tokenId);
1829         _afterTokenTransfers(from, address(0), tokenId, 1);
1830 
1831         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1832         unchecked {
1833             _burnCounter++;
1834         }
1835     }
1836 
1837     // =============================================================
1838     //                     EXTRA DATA OPERATIONS
1839     // =============================================================
1840 
1841     /**
1842      * @dev Directly sets the extra data for the ownership data `index`.
1843      */
1844     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1845         uint256 packed = _packedOwnerships[index];
1846         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1847         uint256 extraDataCasted;
1848         // Cast `extraData` with assembly to avoid redundant masking.
1849         assembly {
1850             extraDataCasted := extraData
1851         }
1852         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1853         _packedOwnerships[index] = packed;
1854     }
1855 
1856     /**
1857      * @dev Called during each token transfer to set the 24bit `extraData` field.
1858      * Intended to be overridden by the cosumer contract.
1859      *
1860      * `previousExtraData` - the value of `extraData` before transfer.
1861      *
1862      * Calling conditions:
1863      *
1864      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1865      * transferred to `to`.
1866      * - When `from` is zero, `tokenId` will be minted for `to`.
1867      * - When `to` is zero, `tokenId` will be burned by `from`.
1868      * - `from` and `to` are never both zero.
1869      */
1870     function _extraData(
1871         address from,
1872         address to,
1873         uint24 previousExtraData
1874     ) internal view virtual returns (uint24) {}
1875 
1876     /**
1877      * @dev Returns the next extra data for the packed ownership data.
1878      * The returned result is shifted into position.
1879      */
1880     function _nextExtraData(
1881         address from,
1882         address to,
1883         uint256 prevOwnershipPacked
1884     ) private view returns (uint256) {
1885         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1886         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1887     }
1888 
1889     // =============================================================
1890     //                       OTHER OPERATIONS
1891     // =============================================================
1892 
1893     /**
1894      * @dev Returns the message sender (defaults to `msg.sender`).
1895      *
1896      * If you are writing GSN compatible contracts, you need to override this function.
1897      */
1898     function _msgSenderERC721A() internal view virtual returns (address) {
1899         return msg.sender;
1900     }
1901 
1902     /**
1903      * @dev Converts a uint256 to its ASCII string decimal representation.
1904      */
1905     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1906         assembly {
1907             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1908             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1909             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1910             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1911             let m := add(mload(0x40), 0xa0)
1912             // Update the free memory pointer to allocate.
1913             mstore(0x40, m)
1914             // Assign the `str` to the end.
1915             str := sub(m, 0x20)
1916             // Zeroize the slot after the string.
1917             mstore(str, 0)
1918 
1919             // Cache the end of the memory to calculate the length later.
1920             let end := str
1921 
1922             // We write the string from rightmost digit to leftmost digit.
1923             // The following is essentially a do-while loop that also handles the zero case.
1924             // prettier-ignore
1925             for { let temp := value } 1 {} {
1926                 str := sub(str, 1)
1927                 // Write the character to the pointer.
1928                 // The ASCII index of the '0' character is 48.
1929                 mstore8(str, add(48, mod(temp, 10)))
1930                 // Keep dividing `temp` until zero.
1931                 temp := div(temp, 10)
1932                 // prettier-ignore
1933                 if iszero(temp) { break }
1934             }
1935 
1936             let length := sub(end, str)
1937             // Move the pointer 32 bytes leftwards to make room for the length.
1938             str := sub(str, 0x20)
1939             // Store the length.
1940             mstore(str, length)
1941         }
1942     }
1943 }
1944 
1945 /**
1946  * @title ERC721AQueryable.
1947  *
1948  * @dev ERC721A subclass with convenience query functions.
1949  */
1950 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1951     /**
1952      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1953      *
1954      * If the `tokenId` is out of bounds:
1955      *
1956      * - `addr = address(0)`
1957      * - `startTimestamp = 0`
1958      * - `burned = false`
1959      * - `extraData = 0`
1960      *
1961      * If the `tokenId` is burned:
1962      *
1963      * - `addr = <Address of owner before token was burned>`
1964      * - `startTimestamp = <Timestamp when token was burned>`
1965      * - `burned = true`
1966      * - `extraData = <Extra data when token was burned>`
1967      *
1968      * Otherwise:
1969      *
1970      * - `addr = <Address of owner>`
1971      * - `startTimestamp = <Timestamp of start of ownership>`
1972      * - `burned = false`
1973      * - `extraData = <Extra data at start of ownership>`
1974      */
1975     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1976         TokenOwnership memory ownership;
1977         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1978             return ownership;
1979         }
1980         ownership = _ownershipAt(tokenId);
1981         if (ownership.burned) {
1982             return ownership;
1983         }
1984         return _ownershipOf(tokenId);
1985     }
1986 
1987     /**
1988      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1989      * See {ERC721AQueryable-explicitOwnershipOf}
1990      */
1991     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1992         external
1993         view
1994         virtual
1995         override
1996         returns (TokenOwnership[] memory)
1997     {
1998         unchecked {
1999             uint256 tokenIdsLength = tokenIds.length;
2000             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2001             for (uint256 i; i != tokenIdsLength; ++i) {
2002                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2003             }
2004             return ownerships;
2005         }
2006     }
2007 
2008     /**
2009      * @dev Returns an array of token IDs owned by `owner`,
2010      * in the range [`start`, `stop`)
2011      * (i.e. `start <= tokenId < stop`).
2012      *
2013      * This function allows for tokens to be queried if the collection
2014      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2015      *
2016      * Requirements:
2017      *
2018      * - `start < stop`
2019      */
2020     function tokensOfOwnerIn(
2021         address owner,
2022         uint256 start,
2023         uint256 stop
2024     ) external view virtual override returns (uint256[] memory) {
2025         unchecked {
2026             if (start >= stop) revert InvalidQueryRange();
2027             uint256 tokenIdsIdx;
2028             uint256 stopLimit = _nextTokenId();
2029             // Set `start = max(start, _startTokenId())`.
2030             if (start < _startTokenId()) {
2031                 start = _startTokenId();
2032             }
2033             // Set `stop = min(stop, stopLimit)`.
2034             if (stop > stopLimit) {
2035                 stop = stopLimit;
2036             }
2037             uint256 tokenIdsMaxLength = balanceOf(owner);
2038             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2039             // to cater for cases where `balanceOf(owner)` is too big.
2040             if (start < stop) {
2041                 uint256 rangeLength = stop - start;
2042                 if (rangeLength < tokenIdsMaxLength) {
2043                     tokenIdsMaxLength = rangeLength;
2044                 }
2045             } else {
2046                 tokenIdsMaxLength = 0;
2047             }
2048             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2049             if (tokenIdsMaxLength == 0) {
2050                 return tokenIds;
2051             }
2052             // We need to call `explicitOwnershipOf(start)`,
2053             // because the slot at `start` may not be initialized.
2054             TokenOwnership memory ownership = explicitOwnershipOf(start);
2055             address currOwnershipAddr;
2056             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2057             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2058             if (!ownership.burned) {
2059                 currOwnershipAddr = ownership.addr;
2060             }
2061             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2062                 ownership = _ownershipAt(i);
2063                 if (ownership.burned) {
2064                     continue;
2065                 }
2066                 if (ownership.addr != address(0)) {
2067                     currOwnershipAddr = ownership.addr;
2068                 }
2069                 if (currOwnershipAddr == owner) {
2070                     tokenIds[tokenIdsIdx++] = i;
2071                 }
2072             }
2073             // Downsize the array to fit.
2074             assembly {
2075                 mstore(tokenIds, tokenIdsIdx)
2076             }
2077             return tokenIds;
2078         }
2079     }
2080 
2081     /**
2082      * @dev Returns an array of token IDs owned by `owner`.
2083      *
2084      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2085      * It is meant to be called off-chain.
2086      *
2087      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2088      * multiple smaller scans if the collection is large enough to cause
2089      * an out-of-gas error (10K collections should be fine).
2090      */
2091     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2092         unchecked {
2093             uint256 tokenIdsIdx;
2094             address currOwnershipAddr;
2095             uint256 tokenIdsLength = balanceOf(owner);
2096             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2097             TokenOwnership memory ownership;
2098             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2099                 ownership = _ownershipAt(i);
2100                 if (ownership.burned) {
2101                     continue;
2102                 }
2103                 if (ownership.addr != address(0)) {
2104                     currOwnershipAddr = ownership.addr;
2105                 }
2106                 if (currOwnershipAddr == owner) {
2107                     tokenIds[tokenIdsIdx++] = i;
2108                 }
2109             }
2110             return tokenIds;
2111         }
2112     }
2113 }
2114 
2115 interface IOperatorFilterRegistry {
2116     /**
2117      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
2118      *         true if supplied registrant address is not registered.
2119      */
2120     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2121 
2122     /**
2123      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
2124      */
2125     function register(address registrant) external;
2126 
2127     /**
2128      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
2129      */
2130     function registerAndSubscribe(address registrant, address subscription) external;
2131 
2132     /**
2133      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
2134      *         address without subscribing.
2135      */
2136     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2137 
2138     /**
2139      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
2140      *         Note that this does not remove any filtered addresses or codeHashes.
2141      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
2142      */
2143     function unregister(address addr) external;
2144 
2145     /**
2146      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
2147      */
2148     function updateOperator(address registrant, address operator, bool filtered) external;
2149 
2150     /**
2151      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
2152      */
2153     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2154 
2155     /**
2156      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
2157      */
2158     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2159 
2160     /**
2161      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
2162      */
2163     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2164 
2165     /**
2166      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
2167      *         subscription if present.
2168      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
2169      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
2170      *         used.
2171      */
2172     function subscribe(address registrant, address registrantToSubscribe) external;
2173 
2174     /**
2175      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
2176      */
2177     function unsubscribe(address registrant, bool copyExistingEntries) external;
2178 
2179     /**
2180      * @notice Get the subscription address of a given registrant, if any.
2181      */
2182     function subscriptionOf(address addr) external returns (address registrant);
2183 
2184     /**
2185      * @notice Get the set of addresses subscribed to a given registrant.
2186      *         Note that order is not guaranteed as updates are made.
2187      */
2188     function subscribers(address registrant) external returns (address[] memory);
2189 
2190     /**
2191      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
2192      *         Note that order is not guaranteed as updates are made.
2193      */
2194     function subscriberAt(address registrant, uint256 index) external returns (address);
2195 
2196     /**
2197      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
2198      */
2199     function copyEntriesOf(address registrant, address registrantToCopy) external;
2200 
2201     /**
2202      * @notice Returns true if operator is filtered by a given address or its subscription.
2203      */
2204     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2205 
2206     /**
2207      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
2208      */
2209     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2210 
2211     /**
2212      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
2213      */
2214     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2215 
2216     /**
2217      * @notice Returns a list of filtered operators for a given address or its subscription.
2218      */
2219     function filteredOperators(address addr) external returns (address[] memory);
2220 
2221     /**
2222      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
2223      *         Note that order is not guaranteed as updates are made.
2224      */
2225     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2226 
2227     /**
2228      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
2229      *         its subscription.
2230      *         Note that order is not guaranteed as updates are made.
2231      */
2232     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2233 
2234     /**
2235      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
2236      *         its subscription.
2237      *         Note that order is not guaranteed as updates are made.
2238      */
2239     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2240 
2241     /**
2242      * @notice Returns true if an address has registered
2243      */
2244     function isRegistered(address addr) external returns (bool);
2245 
2246     /**
2247      * @dev Convenience method to compute the code hash of an arbitrary contract
2248      */
2249     function codeHashOf(address addr) external returns (bytes32);
2250 }
2251 
2252 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
2253 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2254 
2255 /**
2256  * @title  OperatorFilterer
2257  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2258  *         registrant's entries in the OperatorFilterRegistry.
2259  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2260  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2261  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2262  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
2263  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2264  *         will be locked to the options set during construction.
2265  */
2266 
2267 abstract contract OperatorFilterer {
2268     /// @dev Emitted when an operator is not allowed.
2269     error OperatorNotAllowed(address operator);
2270 
2271     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2272         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
2273 
2274     /// @dev The constructor that is called when the contract is being deployed.
2275     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2276         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2277         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2278         // order for the modifier to filter addresses.
2279         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2280             if (subscribe) {
2281                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2282             } else {
2283                 if (subscriptionOrRegistrantToCopy != address(0)) {
2284                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2285                 } else {
2286                     OPERATOR_FILTER_REGISTRY.register(address(this));
2287                 }
2288             }
2289         }
2290     }
2291 
2292     /**
2293      * @dev A helper function to check if an operator is allowed.
2294      */
2295     modifier onlyAllowedOperator(address from) virtual {
2296         // Allow spending tokens from addresses with balance
2297         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2298         // from an EOA.
2299         if (from != msg.sender) {
2300             _checkFilterOperator(msg.sender);
2301         }
2302         _;
2303     }
2304 
2305     /**
2306      * @dev A helper function to check if an operator approval is allowed.
2307      */
2308     modifier onlyAllowedOperatorApproval(address operator) virtual {
2309         _checkFilterOperator(operator);
2310         _;
2311     }
2312 
2313     /**
2314      * @dev A helper function to check if an operator is allowed.
2315      */
2316     function _checkFilterOperator(address operator) internal view virtual {
2317         // Check registry code length to facilitate testing in environments without a deployed registry.
2318         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2319             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2320             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2321             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2322                 revert OperatorNotAllowed(operator);
2323             }
2324         }
2325     }
2326 }
2327 
2328 /**
2329  * @title  DefaultOperatorFilterer
2330  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2331  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2332  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2333  *         will be locked to the options set during construction.
2334  */
2335 
2336 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2337     /// @dev The constructor that is called when the contract is being deployed.
2338     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2339 }
2340 
2341 pragma solidity ^0.8.19;
2342 
2343 contract IRLPunks is DefaultOperatorFilterer, ERC2981, ERC721AQueryable, Ownable {
2344   uint256 public constant SUPPLY = 10000;
2345   uint   public totalFreeMinted = 0;
2346   uint   public totalWLMinted = 0;
2347   uint256 public reservedSupply = 50;
2348   uint   public price             = 0.0069 ether;
2349   uint   public publicPrice             = 0.0089 ether;
2350   uint   public maxPerWallet = 40;
2351   uint256 public freePerWL = 1;
2352   uint256 public maxPerWL = 5;
2353   string public baseURI;
2354   uint256 public Max_PublicPerTX = 20;
2355   using MerkleProof for bytes32[];
2356   bytes32 public whitelistMerkleRoot;
2357   bool public WLSaleActive;
2358   bool public publicsaleActive;
2359   uint256 public walletsInWL;
2360 
2361   mapping (address => uint256) public _WLClaimed;
2362 
2363   mapping(address => uint256) public _freeMinted;
2364 
2365   mapping(address => uint256) public _maxPerWallet;
2366 
2367   constructor() ERC721A("IRL Punks", "IRL") { }
2368 
2369   function setPublicSaleActive() external onlyOwner {
2370     publicsaleActive = !publicsaleActive;
2371   }
2372 
2373   function setWLSaleActive() external onlyOwner {
2374     WLSaleActive = !WLSaleActive;
2375   }
2376 
2377   function setfreePerWL(uint256 count) external onlyOwner {
2378     freePerWL = count;
2379   }
2380 
2381   function setMaxPerWL(uint256 count) external onlyOwner {
2382     maxPerWL = count;
2383   }
2384 
2385   function setMax_PublicPerTX(uint256 count) external onlyOwner {
2386     Max_PublicPerTX = count;
2387   }
2388 
2389   function withdraw() external onlyOwner {
2390         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2391         require(success, "Transfer failed.");
2392     }
2393 
2394    function setBaseUri(string memory _uri) external onlyOwner {
2395     baseURI = _uri;
2396   }
2397 
2398    function setMerkleRoot(bytes32 root) external onlyOwner {
2399     whitelistMerkleRoot = root;
2400   }
2401 
2402    function setCost(uint256 price_) external onlyOwner {
2403         price = price_;
2404     }
2405 
2406     function setPublicCost(uint256 publicPrice_) external onlyOwner {
2407         publicPrice = publicPrice_;
2408     }
2409 
2410     function setWalletsInWL(uint256 count) external onlyOwner {
2411         walletsInWL = count;
2412     }
2413 
2414    function costInspect() public view returns (uint256) {
2415         return price;
2416     }
2417 
2418     function costPublicInspect() public view returns (uint256) {
2419         return publicPrice;
2420     }
2421 
2422    function reservedMint(uint256 count) external onlyOwner
2423     {
2424         uint256 Remaining = reservedSupply;
2425 
2426         require(totalSupply() + count <= SUPPLY, "No more supply to be minted");
2427         require(Remaining >= count, "Reserved Supply Minted");
2428     
2429         reservedSupply = Remaining - count;
2430         _safeMint(msg.sender, count);
2431        
2432     }
2433   
2434    function presaleMint(uint256 count, bytes32[] memory proof) payable public {
2435 
2436     require(WLSaleActive, "Presale Not Active Yet");
2437     require(_verify(_leaf(msg.sender), whitelistMerkleRoot, proof), "Wallet not whitelisted");
2438     require(((totalSupply() + count) <= SUPPLY), "Sold Out!");
2439     require(_WLClaimed[msg.sender] + count <= maxPerWL, "Max Presale Allocation reached");     
2440     require(((totalWLMinted + count) <= (SUPPLY - walletsInWL + totalFreeMinted)), "Only Guaranteed Free Supply Left");
2441   
2442     bool MintForFree = (_freeMinted[msg.sender] < freePerWL);
2443 
2444     if(MintForFree)
2445     {
2446        if(count >= (freePerWL - _freeMinted[msg.sender]))
2447             {
2448              require(msg.value >= (count * price) - ((freePerWL - _freeMinted[msg.sender]) * price), "Please send enough ETH");
2449              _freeMinted[msg.sender] = freePerWL;
2450              totalFreeMinted += freePerWL;
2451              totalWLMinted += count;
2452             }
2453     }
2454     else 
2455     {
2456         require(msg.value >= count * price, "Please send enough ETH");
2457         totalWLMinted += count;
2458     }
2459 
2460     _WLClaimed[msg.sender] += count;
2461     _safeMint(msg.sender, count);
2462   }
2463 
2464   function mint(uint256 count) payable public {
2465 
2466     require(publicsaleActive, "Public Not Active Yet");
2467     require(((totalSupply() + count) <= SUPPLY), "Sold Out!");
2468     require(msg.value >= count * publicPrice, "Please send enough ETH");
2469     require ((count <= Max_PublicPerTX), "Max per transaction exceeded");
2470     require (((_maxPerWallet[msg.sender] + count) <= maxPerWallet), "Max per wallet exceeded");
2471     require(((totalSupply() + count) <= (SUPPLY - walletsInWL + totalFreeMinted)), "Only Guaranteed Free Supply Left");
2472 
2473     _maxPerWallet[msg.sender] += count;
2474 
2475     _safeMint(msg.sender, count);
2476   }
2477 
2478   function _leaf(address account) public pure returns (bytes32) {
2479     return keccak256(abi.encodePacked(account));
2480   }
2481 
2482   function _verify(bytes32 leaf, bytes32 root, bytes32[] memory proof) public pure returns (bool) {
2483     return MerkleProof.verify(proof, root, leaf);
2484   }
2485 
2486   function _baseURI() internal view virtual override returns (string memory) {
2487     return baseURI;
2488   }
2489 
2490   function setApprovalForAll(address operator, bool approved)
2491     public
2492     override(ERC721A, IERC721A)
2493     onlyAllowedOperatorApproval(operator)
2494   {
2495     super.setApprovalForAll(operator, approved);
2496   }
2497 
2498   function approve(address operator, uint256 tokenId) public override(ERC721A, IERC721A) payable onlyAllowedOperatorApproval(operator) {
2499     super.approve(operator, tokenId);
2500   }
2501 
2502   function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) payable onlyAllowedOperator(from) {
2503     super.transferFrom(from, to, tokenId);
2504   }
2505 
2506   function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) payable onlyAllowedOperator(from) {
2507     super.safeTransferFrom(from, to, tokenId);
2508   }
2509 
2510   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2511     public
2512     override(ERC721A, IERC721A)
2513     payable
2514     onlyAllowedOperator(from)
2515   {
2516     super.safeTransferFrom(from, to, tokenId, data);
2517   }
2518 
2519   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A, ERC2981) returns (bool) {
2520     return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2521   }
2522 }