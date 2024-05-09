1 // File @openzeppelin/contracts/utils/Context.sol@v4.8.1
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.1
30 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         _checkOwner();
63         _;
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if the sender is not the owner.
75      */
76     function _checkOwner() internal view virtual {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _transferOwnership(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 
112 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.1
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Interface of the ERC165 standard, as defined in the
120  * https://eips.ethereum.org/EIPS/eip-165[EIP].
121  *
122  * Implementers can declare support of contract interfaces, which can then be
123  * queried by others ({ERC165Checker}).
124  *
125  * For an implementation, see {ERC165}.
126  */
127 interface IERC165 {
128     /**
129      * @dev Returns true if this contract implements the interface defined by
130      * `interfaceId`. See the corresponding
131      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
132      * to learn more about how these ids are created.
133      *
134      * This function call must use less than 30 000 gas.
135      */
136     function supportsInterface(bytes4 interfaceId) external view returns (bool);
137 }
138 
139 
140 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.8.1
141 
142 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Interface for the NFT Royalty Standard.
148  *
149  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
150  * support for royalty payments across all NFT marketplaces and ecosystem participants.
151  *
152  * _Available since v4.5._
153  */
154 interface IERC2981 is IERC165 {
155     /**
156      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
157      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
158      */
159     function royaltyInfo(uint256 tokenId, uint256 salePrice)
160         external
161         view
162         returns (address receiver, uint256 royaltyAmount);
163 }
164 
165 
166 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.1
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Implementation of the {IERC165} interface.
174  *
175  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
176  * for the additional interface id that will be supported. For example:
177  *
178  * ```solidity
179  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
180  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
181  * }
182  * ```
183  *
184  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
185  */
186 abstract contract ERC165 is IERC165 {
187     /**
188      * @dev See {IERC165-supportsInterface}.
189      */
190     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
191         return interfaceId == type(IERC165).interfaceId;
192     }
193 }
194 
195 
196 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.8.1
197 
198 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 
203 /**
204  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
205  *
206  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
207  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
208  *
209  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
210  * fee is specified in basis points by default.
211  *
212  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
213  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
214  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
215  *
216  * _Available since v4.5._
217  */
218 abstract contract ERC2981 is IERC2981, ERC165 {
219     struct RoyaltyInfo {
220         address receiver;
221         uint96 royaltyFraction;
222     }
223 
224     RoyaltyInfo private _defaultRoyaltyInfo;
225     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
226 
227     /**
228      * @dev See {IERC165-supportsInterface}.
229      */
230     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
231         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
232     }
233 
234     /**
235      * @inheritdoc IERC2981
236      */
237     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
238         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
239 
240         if (royalty.receiver == address(0)) {
241             royalty = _defaultRoyaltyInfo;
242         }
243 
244         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
245 
246         return (royalty.receiver, royaltyAmount);
247     }
248 
249     /**
250      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
251      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
252      * override.
253      */
254     function _feeDenominator() internal pure virtual returns (uint96) {
255         return 10000;
256     }
257 
258     /**
259      * @dev Sets the royalty information that all ids in this contract will default to.
260      *
261      * Requirements:
262      *
263      * - `receiver` cannot be the zero address.
264      * - `feeNumerator` cannot be greater than the fee denominator.
265      */
266     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
267         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
268         require(receiver != address(0), "ERC2981: invalid receiver");
269 
270         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
271     }
272 
273     /**
274      * @dev Removes default royalty information.
275      */
276     function _deleteDefaultRoyalty() internal virtual {
277         delete _defaultRoyaltyInfo;
278     }
279 
280     /**
281      * @dev Sets the royalty information for a specific token id, overriding the global default.
282      *
283      * Requirements:
284      *
285      * - `receiver` cannot be the zero address.
286      * - `feeNumerator` cannot be greater than the fee denominator.
287      */
288     function _setTokenRoyalty(
289         uint256 tokenId,
290         address receiver,
291         uint96 feeNumerator
292     ) internal virtual {
293         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
294         require(receiver != address(0), "ERC2981: Invalid parameters");
295 
296         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
297     }
298 
299     /**
300      * @dev Resets royalty information for the token id back to the global default.
301      */
302     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
303         delete _tokenRoyaltyInfo[tokenId];
304     }
305 }
306 
307 
308 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.1
309 
310 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Contract module that helps prevent reentrant calls to a function.
316  *
317  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
318  * available, which can be applied to functions to make sure there are no nested
319  * (reentrant) calls to them.
320  *
321  * Note that because there is a single `nonReentrant` guard, functions marked as
322  * `nonReentrant` may not call one another. This can be worked around by making
323  * those functions `private`, and then adding `external` `nonReentrant` entry
324  * points to them.
325  *
326  * TIP: If you would like to learn more about reentrancy and alternative ways
327  * to protect against it, check out our blog post
328  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
329  */
330 abstract contract ReentrancyGuard {
331     // Booleans are more expensive than uint256 or any type that takes up a full
332     // word because each write operation emits an extra SLOAD to first read the
333     // slot's contents, replace the bits taken up by the boolean, and then write
334     // back. This is the compiler's defense against contract upgrades and
335     // pointer aliasing, and it cannot be disabled.
336 
337     // The values being non-zero value makes deployment a bit more expensive,
338     // but in exchange the refund on every call to nonReentrant will be lower in
339     // amount. Since refunds are capped to a percentage of the total
340     // transaction's gas, it is best to keep them low in cases like this one, to
341     // increase the likelihood of the full refund coming into effect.
342     uint256 private constant _NOT_ENTERED = 1;
343     uint256 private constant _ENTERED = 2;
344 
345     uint256 private _status;
346 
347     constructor() {
348         _status = _NOT_ENTERED;
349     }
350 
351     /**
352      * @dev Prevents a contract from calling itself, directly or indirectly.
353      * Calling a `nonReentrant` function from another `nonReentrant`
354      * function is not supported. It is possible to prevent this from happening
355      * by making the `nonReentrant` function external, and making it call a
356      * `private` function that does the actual work.
357      */
358     modifier nonReentrant() {
359         _nonReentrantBefore();
360         _;
361         _nonReentrantAfter();
362     }
363 
364     function _nonReentrantBefore() private {
365         // On the first call to nonReentrant, _status will be _NOT_ENTERED
366         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
367 
368         // Any calls to nonReentrant after this point will fail
369         _status = _ENTERED;
370     }
371 
372     function _nonReentrantAfter() private {
373         // By storing the original value once again, a refund is triggered (see
374         // https://eips.ethereum.org/EIPS/eip-2200)
375         _status = _NOT_ENTERED;
376     }
377 }
378 
379 
380 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.8.1
381 
382 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev These functions deal with verification of Merkle Tree proofs.
388  *
389  * The tree and the proofs can be generated using our
390  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
391  * You will find a quickstart guide in the readme.
392  *
393  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
394  * hashing, or use a hash function other than keccak256 for hashing leaves.
395  * This is because the concatenation of a sorted pair of internal nodes in
396  * the merkle tree could be reinterpreted as a leaf value.
397  * OpenZeppelin's JavaScript library generates merkle trees that are safe
398  * against this attack out of the box.
399  */
400 library MerkleProof {
401     /**
402      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
403      * defined by `root`. For this, a `proof` must be provided, containing
404      * sibling hashes on the branch from the leaf to the root of the tree. Each
405      * pair of leaves and each pair of pre-images are assumed to be sorted.
406      */
407     function verify(
408         bytes32[] memory proof,
409         bytes32 root,
410         bytes32 leaf
411     ) internal pure returns (bool) {
412         return processProof(proof, leaf) == root;
413     }
414 
415     /**
416      * @dev Calldata version of {verify}
417      *
418      * _Available since v4.7._
419      */
420     function verifyCalldata(
421         bytes32[] calldata proof,
422         bytes32 root,
423         bytes32 leaf
424     ) internal pure returns (bool) {
425         return processProofCalldata(proof, leaf) == root;
426     }
427 
428     /**
429      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
430      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
431      * hash matches the root of the tree. When processing the proof, the pairs
432      * of leafs & pre-images are assumed to be sorted.
433      *
434      * _Available since v4.4._
435      */
436     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
437         bytes32 computedHash = leaf;
438         for (uint256 i = 0; i < proof.length; i++) {
439             computedHash = _hashPair(computedHash, proof[i]);
440         }
441         return computedHash;
442     }
443 
444     /**
445      * @dev Calldata version of {processProof}
446      *
447      * _Available since v4.7._
448      */
449     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
450         bytes32 computedHash = leaf;
451         for (uint256 i = 0; i < proof.length; i++) {
452             computedHash = _hashPair(computedHash, proof[i]);
453         }
454         return computedHash;
455     }
456 
457     /**
458      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
459      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
460      *
461      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
462      *
463      * _Available since v4.7._
464      */
465     function multiProofVerify(
466         bytes32[] memory proof,
467         bool[] memory proofFlags,
468         bytes32 root,
469         bytes32[] memory leaves
470     ) internal pure returns (bool) {
471         return processMultiProof(proof, proofFlags, leaves) == root;
472     }
473 
474     /**
475      * @dev Calldata version of {multiProofVerify}
476      *
477      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
478      *
479      * _Available since v4.7._
480      */
481     function multiProofVerifyCalldata(
482         bytes32[] calldata proof,
483         bool[] calldata proofFlags,
484         bytes32 root,
485         bytes32[] memory leaves
486     ) internal pure returns (bool) {
487         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
488     }
489 
490     /**
491      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
492      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
493      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
494      * respectively.
495      *
496      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
497      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
498      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
499      *
500      * _Available since v4.7._
501      */
502     function processMultiProof(
503         bytes32[] memory proof,
504         bool[] memory proofFlags,
505         bytes32[] memory leaves
506     ) internal pure returns (bytes32 merkleRoot) {
507         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
508         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
509         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
510         // the merkle tree.
511         uint256 leavesLen = leaves.length;
512         uint256 totalHashes = proofFlags.length;
513 
514         // Check proof validity.
515         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
516 
517         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
518         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
519         bytes32[] memory hashes = new bytes32[](totalHashes);
520         uint256 leafPos = 0;
521         uint256 hashPos = 0;
522         uint256 proofPos = 0;
523         // At each step, we compute the next hash using two values:
524         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
525         //   get the next hash.
526         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
527         //   `proof` array.
528         for (uint256 i = 0; i < totalHashes; i++) {
529             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
530             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
531             hashes[i] = _hashPair(a, b);
532         }
533 
534         if (totalHashes > 0) {
535             return hashes[totalHashes - 1];
536         } else if (leavesLen > 0) {
537             return leaves[0];
538         } else {
539             return proof[0];
540         }
541     }
542 
543     /**
544      * @dev Calldata version of {processMultiProof}.
545      *
546      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
547      *
548      * _Available since v4.7._
549      */
550     function processMultiProofCalldata(
551         bytes32[] calldata proof,
552         bool[] calldata proofFlags,
553         bytes32[] memory leaves
554     ) internal pure returns (bytes32 merkleRoot) {
555         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
556         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
557         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
558         // the merkle tree.
559         uint256 leavesLen = leaves.length;
560         uint256 totalHashes = proofFlags.length;
561 
562         // Check proof validity.
563         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
564 
565         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
566         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
567         bytes32[] memory hashes = new bytes32[](totalHashes);
568         uint256 leafPos = 0;
569         uint256 hashPos = 0;
570         uint256 proofPos = 0;
571         // At each step, we compute the next hash using two values:
572         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
573         //   get the next hash.
574         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
575         //   `proof` array.
576         for (uint256 i = 0; i < totalHashes; i++) {
577             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
578             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
579             hashes[i] = _hashPair(a, b);
580         }
581 
582         if (totalHashes > 0) {
583             return hashes[totalHashes - 1];
584         } else if (leavesLen > 0) {
585             return leaves[0];
586         } else {
587             return proof[0];
588         }
589     }
590 
591     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
592         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
593     }
594 
595     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
596         /// @solidity memory-safe-assembly
597         assembly {
598             mstore(0x00, a)
599             mstore(0x20, b)
600             value := keccak256(0x00, 0x40)
601         }
602     }
603 }
604 
605 
606 // File contracts/IERC721A.sol
607 
608 // ERC721A Contracts v4.2.2
609 // Creator: Chiru Labs
610 
611 pragma solidity ^0.8.4;
612 
613 /**
614  * @dev Interface of ERC721A.
615  */
616 interface IERC721A {
617     /**
618      * The caller must own the token or be an approved operator.
619      */
620     error ApprovalCallerNotOwnerNorApproved();
621 
622     /**
623      * The token does not exist.
624      */
625     error ApprovalQueryForNonexistentToken();
626 
627     /**
628      * The caller cannot approve to their own address.
629      */
630     error ApproveToCaller();
631 
632     /**
633      * Cannot query the balance for the zero address.
634      */
635     error BalanceQueryForZeroAddress();
636 
637     /**
638      * Cannot mint to the zero address.
639      */
640     error MintToZeroAddress();
641 
642     /**
643      * The quantity of tokens minted must be more than zero.
644      */
645     error MintZeroQuantity();
646 
647     /**
648      * The token does not exist.
649      */
650     error OwnerQueryForNonexistentToken();
651 
652     /**
653      * The caller must own the token or be an approved operator.
654      */
655     error TransferCallerNotOwnerNorApproved();
656 
657     /**
658      * The token must be owned by `from`.
659      */
660     error TransferFromIncorrectOwner();
661 
662     /**
663      * Cannot safely transfer to a contract that does not implement the
664      * ERC721Receiver interface.
665      */
666     error TransferToNonERC721ReceiverImplementer();
667 
668     /**
669      * Cannot transfer to the zero address.
670      */
671     error TransferToZeroAddress();
672 
673     /**
674      * The token does not exist.
675      */
676     error URIQueryForNonexistentToken();
677 
678     /**
679      * The `quantity` minted with ERC2309 exceeds the safety limit.
680      */
681     error MintERC2309QuantityExceedsLimit();
682 
683     /**
684      * The `extraData` cannot be set on an unintialized ownership slot.
685      */
686     error OwnershipNotInitializedForExtraData();
687 
688     // =============================================================
689     //                            STRUCTS
690     // =============================================================
691 
692     struct TokenOwnership {
693         // The address of the owner.
694         address addr;
695         // Stores the start time of ownership with minimal overhead for tokenomics.
696         uint64 startTimestamp;
697         // Whether the token has been burned.
698         bool burned;
699         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
700         uint24 extraData;
701     }
702 
703     // =============================================================
704     //                         TOKEN COUNTERS
705     // =============================================================
706 
707     /**
708      * @dev Returns the total number of tokens in existence.
709      * Burned tokens will reduce the count.
710      * To get the total number of tokens minted, please see {_totalMinted}.
711      */
712     function totalSupply() external view returns (uint256);
713 
714     // =============================================================
715     //                            IERC165
716     // =============================================================
717 
718     /**
719      * @dev Returns true if this contract implements the interface defined by
720      * `interfaceId`. See the corresponding
721      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
722      * to learn more about how these ids are created.
723      *
724      * This function call must use less than 30000 gas.
725      */
726     function supportsInterface(bytes4 interfaceId) external view returns (bool);
727 
728     // =============================================================
729     //                            IERC721
730     // =============================================================
731 
732     /**
733      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
734      */
735     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
736 
737     /**
738      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
739      */
740     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
741 
742     /**
743      * @dev Emitted when `owner` enables or disables
744      * (`approved`) `operator` to manage all of its assets.
745      */
746     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
747 
748     /**
749      * @dev Returns the number of tokens in `owner`'s account.
750      */
751     function balanceOf(address owner) external view returns (uint256 balance);
752 
753     /**
754      * @dev Returns the owner of the `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function ownerOf(uint256 tokenId) external view returns (address owner);
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`,
764      * checking first that contract recipients are aware of the ERC721 protocol
765      * to prevent tokens from being forever locked.
766      *
767      * Requirements:
768      *
769      * - `from` cannot be the zero address.
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must exist and be owned by `from`.
772      * - If the caller is not `from`, it must be have been allowed to move
773      * this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement
775      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes calldata data
784     ) external;
785 
786     /**
787      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
788      */
789     function safeTransferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) external;
794 
795     /**
796      * @dev Transfers `tokenId` from `from` to `to`.
797      *
798      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
799      * whenever possible.
800      *
801      * Requirements:
802      *
803      * - `from` cannot be the zero address.
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must be owned by `from`.
806      * - If the caller is not `from`, it must be approved to move this token
807      * by either {approve} or {setApprovalForAll}.
808      *
809      * Emits a {Transfer} event.
810      */
811     function transferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) external;
816 
817     /**
818      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
819      * The approval is cleared when the token is transferred.
820      *
821      * Only a single account can be approved at a time, so approving the
822      * zero address clears previous approvals.
823      *
824      * Requirements:
825      *
826      * - The caller must own the token or be an approved operator.
827      * - `tokenId` must exist.
828      *
829      * Emits an {Approval} event.
830      */
831     function approve(address to, uint256 tokenId) external;
832 
833     /**
834      * @dev Approve or remove `operator` as an operator for the caller.
835      * Operators can call {transferFrom} or {safeTransferFrom}
836      * for any token owned by the caller.
837      *
838      * Requirements:
839      *
840      * - The `operator` cannot be the caller.
841      *
842      * Emits an {ApprovalForAll} event.
843      */
844     function setApprovalForAll(address operator, bool _approved) external;
845 
846     /**
847      * @dev Returns the account approved for `tokenId` token.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function getApproved(uint256 tokenId) external view returns (address operator);
854 
855     /**
856      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
857      *
858      * See {setApprovalForAll}.
859      */
860     function isApprovedForAll(address owner, address operator) external view returns (bool);
861 
862     // =============================================================
863     //                        IERC721Metadata
864     // =============================================================
865 
866     /**
867      * @dev Returns the token collection name.
868      */
869     function name() external view returns (string memory);
870 
871     /**
872      * @dev Returns the token collection symbol.
873      */
874     function symbol() external view returns (string memory);
875 
876     /**
877      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
878      */
879     function tokenURI(uint256 tokenId) external view returns (string memory);
880 
881     // =============================================================
882     //                           IERC2309
883     // =============================================================
884 
885     /**
886      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
887      * (inclusive) is transferred from `from` to `to`, as defined in the
888      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
889      *
890      * See {_mintERC2309} for more details.
891      */
892     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
893 }
894 
895 
896 // File contracts/ERC721A.sol
897 
898 // ERC721A Contracts v4.2.2
899 // Creator: Chiru Labs
900 
901 pragma solidity ^0.8.4;
902 
903 /**
904  * @dev Interface of ERC721 token receiver.
905  */
906 interface ERC721A__IERC721Receiver {
907     function onERC721Received(
908         address operator,
909         address from,
910         uint256 tokenId,
911         bytes calldata data
912     ) external returns (bytes4);
913 }
914 
915 /**
916  * @title ERC721A
917  *
918  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
919  * Non-Fungible Token Standard, including the Metadata extension.
920  * Optimized for lower gas during batch mints.
921  *
922  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
923  * starting from `_startTokenId()`.
924  *
925  * Assumptions:
926  *
927  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
928  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
929  */
930 contract ERC721A is IERC721A {
931     // Reference type for token approval.
932     struct TokenApprovalRef {
933         address value;
934     }
935 
936     // =============================================================
937     //                           CONSTANTS
938     // =============================================================
939 
940     // Mask of an entry in packed address data.
941     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
942 
943     // The bit position of `numberMinted` in packed address data.
944     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
945 
946     // The bit position of `numberBurned` in packed address data.
947     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
948 
949     // The bit position of `aux` in packed address data.
950     uint256 private constant _BITPOS_AUX = 192;
951 
952     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
953     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
954 
955     // The bit position of `startTimestamp` in packed ownership.
956     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
957 
958     // The bit mask of the `burned` bit in packed ownership.
959     uint256 private constant _BITMASK_BURNED = 1 << 224;
960 
961     // The bit position of the `nextInitialized` bit in packed ownership.
962     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
963 
964     // The bit mask of the `nextInitialized` bit in packed ownership.
965     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
966 
967     // The bit position of `extraData` in packed ownership.
968     uint256 private constant _BITPOS_EXTRA_DATA = 232;
969 
970     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
971     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
972 
973     // The mask of the lower 160 bits for addresses.
974     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
975 
976     // The maximum `quantity` that can be minted with {_mintERC2309}.
977     // This limit is to prevent overflows on the address data entries.
978     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
979     // is required to cause an overflow, which is unrealistic.
980     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
981 
982     // The `Transfer` event signature is given by:
983     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
984     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
985         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
986 
987     // =============================================================
988     //                            STORAGE
989     // =============================================================
990 
991     // The next token ID to be minted.
992     uint256 private _currentIndex;
993 
994     // The number of tokens burned.
995     uint256 private _burnCounter;
996 
997     // Token name
998     string private _name;
999 
1000     // Token symbol
1001     string private _symbol;
1002 
1003     // Mapping from token ID to ownership details
1004     // An empty struct value does not necessarily mean the token is unowned.
1005     // See {_packedOwnershipOf} implementation for details.
1006     //
1007     // Bits Layout:
1008     // - [0..159]   `addr`
1009     // - [160..223] `startTimestamp`
1010     // - [224]      `burned`
1011     // - [225]      `nextInitialized`
1012     // - [232..255] `extraData`
1013     mapping(uint256 => uint256) private _packedOwnerships;
1014 
1015     // Mapping owner address to address data.
1016     //
1017     // Bits Layout:
1018     // - [0..63]    `balance`
1019     // - [64..127]  `numberMinted`
1020     // - [128..191] `numberBurned`
1021     // - [192..255] `aux`
1022     mapping(address => uint256) private _packedAddressData;
1023 
1024     // Mapping from token ID to approved address.
1025     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1026 
1027     // Mapping from owner to operator approvals
1028     mapping(address => mapping(address => bool)) private _operatorApprovals;
1029 
1030     // =============================================================
1031     //                          CONSTRUCTOR
1032     // =============================================================
1033 
1034     constructor(string memory name_, string memory symbol_) {
1035         _name = name_;
1036         _symbol = symbol_;
1037         _currentIndex = _startTokenId();
1038     }
1039 
1040     // =============================================================
1041     //                   TOKEN COUNTING OPERATIONS
1042     // =============================================================
1043 
1044     /**
1045      * @dev Returns the starting token ID.
1046      * To change the starting token ID, please override this function.
1047      */
1048     function _startTokenId() internal view virtual returns (uint256) {
1049         return 0;
1050     }
1051 
1052     /**
1053      * @dev Returns the next token ID to be minted.
1054      */
1055     function _nextTokenId() internal view virtual returns (uint256) {
1056         return _currentIndex;
1057     }
1058 
1059     /**
1060      * @dev Returns the total number of tokens in existence.
1061      * Burned tokens will reduce the count.
1062      * To get the total number of tokens minted, please see {_totalMinted}.
1063      */
1064     function totalSupply() public view virtual override returns (uint256) {
1065         // Counter underflow is impossible as _burnCounter cannot be incremented
1066         // more than `_currentIndex - _startTokenId()` times.
1067         unchecked {
1068             return _currentIndex - _burnCounter - _startTokenId();
1069         }
1070     }
1071 
1072     /**
1073      * @dev Returns the total amount of tokens minted in the contract.
1074      */
1075     function _totalMinted() internal view virtual returns (uint256) {
1076         // Counter underflow is impossible as `_currentIndex` does not decrement,
1077         // and it is initialized to `_startTokenId()`.
1078         unchecked {
1079             return _currentIndex - _startTokenId();
1080         }
1081     }
1082 
1083     /**
1084      * @dev Returns the total number of tokens burned.
1085      */
1086     function _totalBurned() internal view virtual returns (uint256) {
1087         return _burnCounter;
1088     }
1089 
1090     // =============================================================
1091     //                    ADDRESS DATA OPERATIONS
1092     // =============================================================
1093 
1094     /**
1095      * @dev Returns the number of tokens in `owner`'s account.
1096      */
1097     function balanceOf(address owner) public view virtual override returns (uint256) {
1098         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1099         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1100     }
1101 
1102     /**
1103      * Returns the number of tokens minted by `owner`.
1104      */
1105     function _numberMinted(address owner) internal view returns (uint256) {
1106         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1107     }
1108 
1109     /**
1110      * Returns the number of tokens burned by or on behalf of `owner`.
1111      */
1112     function _numberBurned(address owner) internal view returns (uint256) {
1113         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1114     }
1115 
1116     /**
1117      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1118      */
1119     function _getAux(address owner) internal view returns (uint64) {
1120         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1121     }
1122 
1123     /**
1124      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1125      * If there are multiple variables, please pack them into a uint64.
1126      */
1127     function _setAux(address owner, uint64 aux) internal virtual {
1128         uint256 packed = _packedAddressData[owner];
1129         uint256 auxCasted;
1130         // Cast `aux` with assembly to avoid redundant masking.
1131         assembly {
1132             auxCasted := aux
1133         }
1134         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1135         _packedAddressData[owner] = packed;
1136     }
1137 
1138     // =============================================================
1139     //                            IERC165
1140     // =============================================================
1141 
1142     /**
1143      * @dev Returns true if this contract implements the interface defined by
1144      * `interfaceId`. See the corresponding
1145      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1146      * to learn more about how these ids are created.
1147      *
1148      * This function call must use less than 30000 gas.
1149      */
1150     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1151         // The interface IDs are constants representing the first 4 bytes
1152         // of the XOR of all function selectors in the interface.
1153         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1154         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1155         return
1156             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1157             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1158             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1159     }
1160 
1161     // =============================================================
1162     //                        IERC721Metadata
1163     // =============================================================
1164 
1165     /**
1166      * @dev Returns the token collection name.
1167      */
1168     function name() public view virtual override returns (string memory) {
1169         return _name;
1170     }
1171 
1172     /**
1173      * @dev Returns the token collection symbol.
1174      */
1175     function symbol() public view virtual override returns (string memory) {
1176         return _symbol;
1177     }
1178 
1179     /**
1180      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1181      */
1182     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1183         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1184 
1185         string memory baseURI = _baseURI();
1186         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1187     }
1188 
1189     /**
1190      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1191      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1192      * by default, it can be overridden in child contracts.
1193      */
1194     function _baseURI() internal view virtual returns (string memory) {
1195         return '';
1196     }
1197 
1198     // =============================================================
1199     //                     OWNERSHIPS OPERATIONS
1200     // =============================================================
1201 
1202     /**
1203      * @dev Returns the owner of the `tokenId` token.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      */
1209     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1210         return address(uint160(_packedOwnershipOf(tokenId)));
1211     }
1212 
1213     /**
1214      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1215      * It gradually moves to O(1) as tokens get transferred around over time.
1216      */
1217     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1218         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1219     }
1220 
1221     /**
1222      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1223      */
1224     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1225         return _unpackedOwnership(_packedOwnerships[index]);
1226     }
1227 
1228     /**
1229      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1230      */
1231     function _initializeOwnershipAt(uint256 index) internal virtual {
1232         if (_packedOwnerships[index] == 0) {
1233             _packedOwnerships[index] = _packedOwnershipOf(index);
1234         }
1235     }
1236 
1237     /**
1238      * Returns the packed ownership data of `tokenId`.
1239      */
1240     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1241         uint256 curr = tokenId;
1242 
1243         unchecked {
1244             if (_startTokenId() <= curr)
1245                 if (curr < _currentIndex) {
1246                     uint256 packed = _packedOwnerships[curr];
1247                     // If not burned.
1248                     if (packed & _BITMASK_BURNED == 0) {
1249                         // Invariant:
1250                         // There will always be an initialized ownership slot
1251                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1252                         // before an unintialized ownership slot
1253                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1254                         // Hence, `curr` will not underflow.
1255                         //
1256                         // We can directly compare the packed value.
1257                         // If the address is zero, packed will be zero.
1258                         while (packed == 0) {
1259                             packed = _packedOwnerships[--curr];
1260                         }
1261                         return packed;
1262                     }
1263                 }
1264         }
1265         revert OwnerQueryForNonexistentToken();
1266     }
1267 
1268     /**
1269      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1270      */
1271     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1272         ownership.addr = address(uint160(packed));
1273         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1274         ownership.burned = packed & _BITMASK_BURNED != 0;
1275         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1276     }
1277 
1278     /**
1279      * @dev Packs ownership data into a single uint256.
1280      */
1281     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1282         assembly {
1283             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1284             owner := and(owner, _BITMASK_ADDRESS)
1285             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1286             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1287         }
1288     }
1289 
1290     /**
1291      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1292      */
1293     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1294         // For branchless setting of the `nextInitialized` flag.
1295         assembly {
1296             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1297             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1298         }
1299     }
1300 
1301     // =============================================================
1302     //                      APPROVAL OPERATIONS
1303     // =============================================================
1304 
1305     /**
1306      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1307      * The approval is cleared when the token is transferred.
1308      *
1309      * Only a single account can be approved at a time, so approving the
1310      * zero address clears previous approvals.
1311      *
1312      * Requirements:
1313      *
1314      * - The caller must own the token or be an approved operator.
1315      * - `tokenId` must exist.
1316      *
1317      * Emits an {Approval} event.
1318      */
1319     function approve(address to, uint256 tokenId) public virtual override {
1320         address owner = ownerOf(tokenId);
1321 
1322         if (_msgSenderERC721A() != owner)
1323             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1324                 revert ApprovalCallerNotOwnerNorApproved();
1325             }
1326 
1327         _tokenApprovals[tokenId].value = to;
1328         emit Approval(owner, to, tokenId);
1329     }
1330 
1331     /**
1332      * @dev Returns the account approved for `tokenId` token.
1333      *
1334      * Requirements:
1335      *
1336      * - `tokenId` must exist.
1337      */
1338     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1339         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1340 
1341         return _tokenApprovals[tokenId].value;
1342     }
1343 
1344     /**
1345      * @dev Approve or remove `operator` as an operator for the caller.
1346      * Operators can call {transferFrom} or {safeTransferFrom}
1347      * for any token owned by the caller.
1348      *
1349      * Requirements:
1350      *
1351      * - The `operator` cannot be the caller.
1352      *
1353      * Emits an {ApprovalForAll} event.
1354      */
1355     function setApprovalForAll(address operator, bool approved) public virtual override {
1356         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1357 
1358         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1359         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1360     }
1361 
1362     /**
1363      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1364      *
1365      * See {setApprovalForAll}.
1366      */
1367     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1368         return _operatorApprovals[owner][operator];
1369     }
1370 
1371     /**
1372      * @dev Returns whether `tokenId` exists.
1373      *
1374      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1375      *
1376      * Tokens start existing when they are minted. See {_mint}.
1377      */
1378     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1379         return
1380             _startTokenId() <= tokenId &&
1381             tokenId < _currentIndex && // If within bounds,
1382             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1383     }
1384 
1385     /**
1386      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1387      */
1388     function _isSenderApprovedOrOwner(
1389         address approvedAddress,
1390         address owner,
1391         address msgSender
1392     ) private pure returns (bool result) {
1393         assembly {
1394             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1395             owner := and(owner, _BITMASK_ADDRESS)
1396             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1397             msgSender := and(msgSender, _BITMASK_ADDRESS)
1398             // `msgSender == owner || msgSender == approvedAddress`.
1399             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1400         }
1401     }
1402 
1403     /**
1404      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1405      */
1406     function _getApprovedSlotAndAddress(uint256 tokenId)
1407         private
1408         view
1409         returns (uint256 approvedAddressSlot, address approvedAddress)
1410     {
1411         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1412         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1413         assembly {
1414             approvedAddressSlot := tokenApproval.slot
1415             approvedAddress := sload(approvedAddressSlot)
1416         }
1417     }
1418 
1419     // =============================================================
1420     //                      TRANSFER OPERATIONS
1421     // =============================================================
1422 
1423     /**
1424      * @dev Transfers `tokenId` from `from` to `to`.
1425      *
1426      * Requirements:
1427      *
1428      * - `from` cannot be the zero address.
1429      * - `to` cannot be the zero address.
1430      * - `tokenId` token must be owned by `from`.
1431      * - If the caller is not `from`, it must be approved to move this token
1432      * by either {approve} or {setApprovalForAll}.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function transferFrom(
1437         address from,
1438         address to,
1439         uint256 tokenId
1440     ) public virtual override {
1441         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1442 
1443         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1444 
1445         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1446 
1447         // The nested ifs save around 20+ gas over a compound boolean condition.
1448         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1449             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1450 
1451         if (to == address(0)) revert TransferToZeroAddress();
1452 
1453         _beforeTokenTransfers(from, to, tokenId, 1);
1454 
1455         // Clear approvals from the previous owner.
1456         assembly {
1457             if approvedAddress {
1458                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1459                 sstore(approvedAddressSlot, 0)
1460             }
1461         }
1462 
1463         // Underflow of the sender's balance is impossible because we check for
1464         // ownership above and the recipient's balance can't realistically overflow.
1465         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1466         unchecked {
1467             // We can directly increment and decrement the balances.
1468             --_packedAddressData[from]; // Updates: `balance -= 1`.
1469             ++_packedAddressData[to]; // Updates: `balance += 1`.
1470 
1471             // Updates:
1472             // - `address` to the next owner.
1473             // - `startTimestamp` to the timestamp of transfering.
1474             // - `burned` to `false`.
1475             // - `nextInitialized` to `true`.
1476             _packedOwnerships[tokenId] = _packOwnershipData(
1477                 to,
1478                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1479             );
1480 
1481             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1482             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1483                 uint256 nextTokenId = tokenId + 1;
1484                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1485                 if (_packedOwnerships[nextTokenId] == 0) {
1486                     // If the next slot is within bounds.
1487                     if (nextTokenId != _currentIndex) {
1488                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1489                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1490                     }
1491                 }
1492             }
1493         }
1494 
1495         emit Transfer(from, to, tokenId);
1496         _afterTokenTransfers(from, to, tokenId, 1);
1497     }
1498 
1499     /**
1500      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1501      */
1502     function safeTransferFrom(
1503         address from,
1504         address to,
1505         uint256 tokenId
1506     ) public virtual override {
1507         safeTransferFrom(from, to, tokenId, '');
1508     }
1509 
1510     /**
1511      * @dev Safely transfers `tokenId` token from `from` to `to`.
1512      *
1513      * Requirements:
1514      *
1515      * - `from` cannot be the zero address.
1516      * - `to` cannot be the zero address.
1517      * - `tokenId` token must exist and be owned by `from`.
1518      * - If the caller is not `from`, it must be approved to move this token
1519      * by either {approve} or {setApprovalForAll}.
1520      * - If `to` refers to a smart contract, it must implement
1521      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1522      *
1523      * Emits a {Transfer} event.
1524      */
1525     function safeTransferFrom(
1526         address from,
1527         address to,
1528         uint256 tokenId,
1529         bytes memory _data
1530     ) public virtual override {
1531         transferFrom(from, to, tokenId);
1532         if (to.code.length != 0)
1533             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1534                 revert TransferToNonERC721ReceiverImplementer();
1535             }
1536     }
1537 
1538     /**
1539      * @dev Hook that is called before a set of serially-ordered token IDs
1540      * are about to be transferred. This includes minting.
1541      * And also called before burning one token.
1542      *
1543      * `startTokenId` - the first token ID to be transferred.
1544      * `quantity` - the amount to be transferred.
1545      *
1546      * Calling conditions:
1547      *
1548      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1549      * transferred to `to`.
1550      * - When `from` is zero, `tokenId` will be minted for `to`.
1551      * - When `to` is zero, `tokenId` will be burned by `from`.
1552      * - `from` and `to` are never both zero.
1553      */
1554     function _beforeTokenTransfers(
1555         address from,
1556         address to,
1557         uint256 startTokenId,
1558         uint256 quantity
1559     ) internal virtual {}
1560 
1561     /**
1562      * @dev Hook that is called after a set of serially-ordered token IDs
1563      * have been transferred. This includes minting.
1564      * And also called after one token has been burned.
1565      *
1566      * `startTokenId` - the first token ID to be transferred.
1567      * `quantity` - the amount to be transferred.
1568      *
1569      * Calling conditions:
1570      *
1571      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1572      * transferred to `to`.
1573      * - When `from` is zero, `tokenId` has been minted for `to`.
1574      * - When `to` is zero, `tokenId` has been burned by `from`.
1575      * - `from` and `to` are never both zero.
1576      */
1577     function _afterTokenTransfers(
1578         address from,
1579         address to,
1580         uint256 startTokenId,
1581         uint256 quantity
1582     ) internal virtual {}
1583 
1584     /**
1585      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1586      *
1587      * `from` - Previous owner of the given token ID.
1588      * `to` - Target address that will receive the token.
1589      * `tokenId` - Token ID to be transferred.
1590      * `_data` - Optional data to send along with the call.
1591      *
1592      * Returns whether the call correctly returned the expected magic value.
1593      */
1594     function _checkContractOnERC721Received(
1595         address from,
1596         address to,
1597         uint256 tokenId,
1598         bytes memory _data
1599     ) private returns (bool) {
1600         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1601             bytes4 retval
1602         ) {
1603             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1604         } catch (bytes memory reason) {
1605             if (reason.length == 0) {
1606                 revert TransferToNonERC721ReceiverImplementer();
1607             } else {
1608                 assembly {
1609                     revert(add(32, reason), mload(reason))
1610                 }
1611             }
1612         }
1613     }
1614 
1615     // =============================================================
1616     //                        MINT OPERATIONS
1617     // =============================================================
1618 
1619     /**
1620      * @dev Mints `quantity` tokens and transfers them to `to`.
1621      *
1622      * Requirements:
1623      *
1624      * - `to` cannot be the zero address.
1625      * - `quantity` must be greater than 0.
1626      *
1627      * Emits a {Transfer} event for each mint.
1628      */
1629     function _mint(address to, uint256 quantity) internal virtual {
1630         uint256 startTokenId = _currentIndex;
1631         if (quantity == 0) revert MintZeroQuantity();
1632 
1633         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1634 
1635         // Overflows are incredibly unrealistic.
1636         // `balance` and `numberMinted` have a maximum limit of 2**64.
1637         // `tokenId` has a maximum limit of 2**256.
1638         unchecked {
1639             // Updates:
1640             // - `balance += quantity`.
1641             // - `numberMinted += quantity`.
1642             //
1643             // We can directly add to the `balance` and `numberMinted`.
1644             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1645 
1646             // Updates:
1647             // - `address` to the owner.
1648             // - `startTimestamp` to the timestamp of minting.
1649             // - `burned` to `false`.
1650             // - `nextInitialized` to `quantity == 1`.
1651             _packedOwnerships[startTokenId] = _packOwnershipData(
1652                 to,
1653                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1654             );
1655 
1656             uint256 toMasked;
1657             uint256 end = startTokenId + quantity;
1658 
1659             // Use assembly to loop and emit the `Transfer` event for gas savings.
1660             // The duplicated `log4` removes an extra check and reduces stack juggling.
1661             // The assembly, together with the surrounding Solidity code, have been
1662             // delicately arranged to nudge the compiler into producing optimized opcodes.
1663             assembly {
1664                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1665                 toMasked := and(to, _BITMASK_ADDRESS)
1666                 // Emit the `Transfer` event.
1667                 log4(
1668                     0, // Start of data (0, since no data).
1669                     0, // End of data (0, since no data).
1670                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1671                     0, // `address(0)`.
1672                     toMasked, // `to`.
1673                     startTokenId // `tokenId`.
1674                 )
1675 
1676                 for {
1677                     let tokenId := add(startTokenId, 1)
1678                 } iszero(eq(tokenId, end)) {
1679                     tokenId := add(tokenId, 1)
1680                 } {
1681                     // Emit the `Transfer` event. Similar to above.
1682                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1683                 }
1684             }
1685             if (toMasked == 0) revert MintToZeroAddress();
1686 
1687             _currentIndex = end;
1688         }
1689         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1690     }
1691 
1692     /**
1693      * @dev Mints `quantity` tokens and transfers them to `to`.
1694      *
1695      * This function is intended for efficient minting only during contract creation.
1696      *
1697      * It emits only one {ConsecutiveTransfer} as defined in
1698      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1699      * instead of a sequence of {Transfer} event(s).
1700      *
1701      * Calling this function outside of contract creation WILL make your contract
1702      * non-compliant with the ERC721 standard.
1703      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1704      * {ConsecutiveTransfer} event is only permissible during contract creation.
1705      *
1706      * Requirements:
1707      *
1708      * - `to` cannot be the zero address.
1709      * - `quantity` must be greater than 0.
1710      *
1711      * Emits a {ConsecutiveTransfer} event.
1712      */
1713     function _mintERC2309(address to, uint256 quantity) internal virtual {
1714         uint256 startTokenId = _currentIndex;
1715         if (to == address(0)) revert MintToZeroAddress();
1716         if (quantity == 0) revert MintZeroQuantity();
1717         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1718 
1719         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1720 
1721         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1722         unchecked {
1723             // Updates:
1724             // - `balance += quantity`.
1725             // - `numberMinted += quantity`.
1726             //
1727             // We can directly add to the `balance` and `numberMinted`.
1728             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1729 
1730             // Updates:
1731             // - `address` to the owner.
1732             // - `startTimestamp` to the timestamp of minting.
1733             // - `burned` to `false`.
1734             // - `nextInitialized` to `quantity == 1`.
1735             _packedOwnerships[startTokenId] = _packOwnershipData(
1736                 to,
1737                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1738             );
1739 
1740             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1741 
1742             _currentIndex = startTokenId + quantity;
1743         }
1744         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1745     }
1746 
1747     /**
1748      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1749      *
1750      * Requirements:
1751      *
1752      * - If `to` refers to a smart contract, it must implement
1753      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1754      * - `quantity` must be greater than 0.
1755      *
1756      * See {_mint}.
1757      *
1758      * Emits a {Transfer} event for each mint.
1759      */
1760     function _safeMint(
1761         address to,
1762         uint256 quantity,
1763         bytes memory _data
1764     ) internal virtual {
1765         _mint(to, quantity);
1766 
1767         unchecked {
1768             if (to.code.length != 0) {
1769                 uint256 end = _currentIndex;
1770                 uint256 index = end - quantity;
1771                 do {
1772                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1773                         revert TransferToNonERC721ReceiverImplementer();
1774                     }
1775                 } while (index < end);
1776                 // Reentrancy protection.
1777                 if (_currentIndex != end) revert();
1778             }
1779         }
1780     }
1781 
1782     /**
1783      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1784      */
1785     function _safeMint(address to, uint256 quantity) internal virtual {
1786         _safeMint(to, quantity, '');
1787     }
1788 
1789     // =============================================================
1790     //                        BURN OPERATIONS
1791     // =============================================================
1792 
1793     /**
1794      * @dev Equivalent to `_burn(tokenId, false)`.
1795      */
1796     function _burn(uint256 tokenId) internal virtual {
1797         _burn(tokenId, false);
1798     }
1799 
1800     /**
1801      * @dev Destroys `tokenId`.
1802      * The approval is cleared when the token is burned.
1803      *
1804      * Requirements:
1805      *
1806      * - `tokenId` must exist.
1807      *
1808      * Emits a {Transfer} event.
1809      */
1810     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1811         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1812 
1813         address from = address(uint160(prevOwnershipPacked));
1814 
1815         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1816 
1817         if (approvalCheck) {
1818             // The nested ifs save around 20+ gas over a compound boolean condition.
1819             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1820                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1821         }
1822 
1823         _beforeTokenTransfers(from, address(0), tokenId, 1);
1824 
1825         // Clear approvals from the previous owner.
1826         assembly {
1827             if approvedAddress {
1828                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1829                 sstore(approvedAddressSlot, 0)
1830             }
1831         }
1832 
1833         // Underflow of the sender's balance is impossible because we check for
1834         // ownership above and the recipient's balance can't realistically overflow.
1835         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1836         unchecked {
1837             // Updates:
1838             // - `balance -= 1`.
1839             // - `numberBurned += 1`.
1840             //
1841             // We can directly decrement the balance, and increment the number burned.
1842             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1843             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1844 
1845             // Updates:
1846             // - `address` to the last owner.
1847             // - `startTimestamp` to the timestamp of burning.
1848             // - `burned` to `true`.
1849             // - `nextInitialized` to `true`.
1850             _packedOwnerships[tokenId] = _packOwnershipData(
1851                 from,
1852                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1853             );
1854 
1855             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1856             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1857                 uint256 nextTokenId = tokenId + 1;
1858                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1859                 if (_packedOwnerships[nextTokenId] == 0) {
1860                     // If the next slot is within bounds.
1861                     if (nextTokenId != _currentIndex) {
1862                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1863                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1864                     }
1865                 }
1866             }
1867         }
1868 
1869         emit Transfer(from, address(0), tokenId);
1870         _afterTokenTransfers(from, address(0), tokenId, 1);
1871 
1872         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1873         unchecked {
1874             _burnCounter++;
1875         }
1876     }
1877 
1878     // =============================================================
1879     //                     EXTRA DATA OPERATIONS
1880     // =============================================================
1881 
1882     /**
1883      * @dev Directly sets the extra data for the ownership data `index`.
1884      */
1885     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1886         uint256 packed = _packedOwnerships[index];
1887         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1888         uint256 extraDataCasted;
1889         // Cast `extraData` with assembly to avoid redundant masking.
1890         assembly {
1891             extraDataCasted := extraData
1892         }
1893         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1894         _packedOwnerships[index] = packed;
1895     }
1896 
1897     /**
1898      * @dev Called during each token transfer to set the 24bit `extraData` field.
1899      * Intended to be overridden by the cosumer contract.
1900      *
1901      * `previousExtraData` - the value of `extraData` before transfer.
1902      *
1903      * Calling conditions:
1904      *
1905      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1906      * transferred to `to`.
1907      * - When `from` is zero, `tokenId` will be minted for `to`.
1908      * - When `to` is zero, `tokenId` will be burned by `from`.
1909      * - `from` and `to` are never both zero.
1910      */
1911     function _extraData(
1912         address from,
1913         address to,
1914         uint24 previousExtraData
1915     ) internal view virtual returns (uint24) {}
1916 
1917     /**
1918      * @dev Returns the next extra data for the packed ownership data.
1919      * The returned result is shifted into position.
1920      */
1921     function _nextExtraData(
1922         address from,
1923         address to,
1924         uint256 prevOwnershipPacked
1925     ) private view returns (uint256) {
1926         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1927         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1928     }
1929 
1930     // =============================================================
1931     //                       OTHER OPERATIONS
1932     // =============================================================
1933 
1934     /**
1935      * @dev Returns the message sender (defaults to `msg.sender`).
1936      *
1937      * If you are writing GSN compatible contracts, you need to override this function.
1938      */
1939     function _msgSenderERC721A() internal view virtual returns (address) {
1940         return msg.sender;
1941     }
1942 
1943     /**
1944      * @dev Converts a uint256 to its ASCII string decimal representation.
1945      */
1946     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1947         assembly {
1948             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1949             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1950             // We will need 1 32-byte word to store the length,
1951             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1952             str := add(mload(0x40), 0x80)
1953             // Update the free memory pointer to allocate.
1954             mstore(0x40, str)
1955 
1956             // Cache the end of the memory to calculate the length later.
1957             let end := str
1958 
1959             // We write the string from rightmost digit to leftmost digit.
1960             // The following is essentially a do-while loop that also handles the zero case.
1961             // prettier-ignore
1962             for { let temp := value } 1 {} {
1963                 str := sub(str, 1)
1964                 // Write the character to the pointer.
1965                 // The ASCII index of the '0' character is 48.
1966                 mstore8(str, add(48, mod(temp, 10)))
1967                 // Keep dividing `temp` until zero.
1968                 temp := div(temp, 10)
1969                 // prettier-ignore
1970                 if iszero(temp) { break }
1971             }
1972 
1973             let length := sub(end, str)
1974             // Move the pointer 32 bytes leftwards to make room for the length.
1975             str := sub(str, 0x20)
1976             // Store the length.
1977             mstore(str, length)
1978         }
1979     }
1980 }
1981 
1982 
1983 // File contracts/extensions/IERC721AQueryable.sol
1984 // ERC721A Contracts v4.2.2
1985 // Creator: Chiru Labs
1986 
1987 pragma solidity ^0.8.4;
1988 
1989 /**
1990  * @dev Interface of ERC721AQueryable.
1991  */
1992 interface IERC721AQueryable is IERC721A {
1993     /**
1994      * Invalid query range (`start` >= `stop`).
1995      */
1996     error InvalidQueryRange();
1997 
1998     /**
1999      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2000      *
2001      * If the `tokenId` is out of bounds:
2002      *
2003      * - `addr = address(0)`
2004      * - `startTimestamp = 0`
2005      * - `burned = false`
2006      * - `extraData = 0`
2007      *
2008      * If the `tokenId` is burned:
2009      *
2010      * - `addr = <Address of owner before token was burned>`
2011      * - `startTimestamp = <Timestamp when token was burned>`
2012      * - `burned = true`
2013      * - `extraData = <Extra data when token was burned>`
2014      *
2015      * Otherwise:
2016      *
2017      * - `addr = <Address of owner>`
2018      * - `startTimestamp = <Timestamp of start of ownership>`
2019      * - `burned = false`
2020      * - `extraData = <Extra data at start of ownership>`
2021      */
2022     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2023 
2024     /**
2025      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2026      * See {ERC721AQueryable-explicitOwnershipOf}
2027      */
2028     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2029 
2030     /**
2031      * @dev Returns an array of token IDs owned by `owner`,
2032      * in the range [`start`, `stop`)
2033      * (i.e. `start <= tokenId < stop`).
2034      *
2035      * This function allows for tokens to be queried if the collection
2036      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2037      *
2038      * Requirements:
2039      *
2040      * - `start < stop`
2041      */
2042     function tokensOfOwnerIn(
2043         address owner,
2044         uint256 start,
2045         uint256 stop
2046     ) external view returns (uint256[] memory);
2047 
2048     /**
2049      * @dev Returns an array of token IDs owned by `owner`.
2050      *
2051      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2052      * It is meant to be called off-chain.
2053      *
2054      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2055      * multiple smaller scans if the collection is large enough to cause
2056      * an out-of-gas error (10K collections should be fine).
2057      */
2058     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2059 }
2060 
2061 
2062 // File contracts/extensions/ERC721AQueryable.sol
2063 
2064 // ERC721A Contracts v4.2.2
2065 // Creator: Chiru Labs
2066 
2067 pragma solidity ^0.8.4;
2068 
2069 
2070 /**
2071  * @title ERC721AQueryable.
2072  *
2073  * @dev ERC721A subclass with convenience query functions.
2074  */
2075 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2076     /**
2077      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2078      *
2079      * If the `tokenId` is out of bounds:
2080      *
2081      * - `addr = address(0)`
2082      * - `startTimestamp = 0`
2083      * - `burned = false`
2084      * - `extraData = 0`
2085      *
2086      * If the `tokenId` is burned:
2087      *
2088      * - `addr = <Address of owner before token was burned>`
2089      * - `startTimestamp = <Timestamp when token was burned>`
2090      * - `burned = true`
2091      * - `extraData = <Extra data when token was burned>`
2092      *
2093      * Otherwise:
2094      *
2095      * - `addr = <Address of owner>`
2096      * - `startTimestamp = <Timestamp of start of ownership>`
2097      * - `burned = false`
2098      * - `extraData = <Extra data at start of ownership>`
2099      */
2100     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2101         TokenOwnership memory ownership;
2102         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2103             return ownership;
2104         }
2105         ownership = _ownershipAt(tokenId);
2106         if (ownership.burned) {
2107             return ownership;
2108         }
2109         return _ownershipOf(tokenId);
2110     }
2111 
2112     /**
2113      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2114      * See {ERC721AQueryable-explicitOwnershipOf}
2115      */
2116     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2117         external
2118         view
2119         virtual
2120         override
2121         returns (TokenOwnership[] memory)
2122     {
2123         unchecked {
2124             uint256 tokenIdsLength = tokenIds.length;
2125             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2126             for (uint256 i; i != tokenIdsLength; ++i) {
2127                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2128             }
2129             return ownerships;
2130         }
2131     }
2132 
2133     /**
2134      * @dev Returns an array of token IDs owned by `owner`,
2135      * in the range [`start`, `stop`)
2136      * (i.e. `start <= tokenId < stop`).
2137      *
2138      * This function allows for tokens to be queried if the collection
2139      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2140      *
2141      * Requirements:
2142      *
2143      * - `start < stop`
2144      */
2145     function tokensOfOwnerIn(
2146         address owner,
2147         uint256 start,
2148         uint256 stop
2149     ) external view virtual override returns (uint256[] memory) {
2150         unchecked {
2151             if (start >= stop) revert InvalidQueryRange();
2152             uint256 tokenIdsIdx;
2153             uint256 stopLimit = _nextTokenId();
2154             // Set `start = max(start, _startTokenId())`.
2155             if (start < _startTokenId()) {
2156                 start = _startTokenId();
2157             }
2158             // Set `stop = min(stop, stopLimit)`.
2159             if (stop > stopLimit) {
2160                 stop = stopLimit;
2161             }
2162             uint256 tokenIdsMaxLength = balanceOf(owner);
2163             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2164             // to cater for cases where `balanceOf(owner)` is too big.
2165             if (start < stop) {
2166                 uint256 rangeLength = stop - start;
2167                 if (rangeLength < tokenIdsMaxLength) {
2168                     tokenIdsMaxLength = rangeLength;
2169                 }
2170             } else {
2171                 tokenIdsMaxLength = 0;
2172             }
2173             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2174             if (tokenIdsMaxLength == 0) {
2175                 return tokenIds;
2176             }
2177             // We need to call `explicitOwnershipOf(start)`,
2178             // because the slot at `start` may not be initialized.
2179             TokenOwnership memory ownership = explicitOwnershipOf(start);
2180             address currOwnershipAddr;
2181             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2182             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2183             if (!ownership.burned) {
2184                 currOwnershipAddr = ownership.addr;
2185             }
2186             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2187                 ownership = _ownershipAt(i);
2188                 if (ownership.burned) {
2189                     continue;
2190                 }
2191                 if (ownership.addr != address(0)) {
2192                     currOwnershipAddr = ownership.addr;
2193                 }
2194                 if (currOwnershipAddr == owner) {
2195                     tokenIds[tokenIdsIdx++] = i;
2196                 }
2197             }
2198             // Downsize the array to fit.
2199             assembly {
2200                 mstore(tokenIds, tokenIdsIdx)
2201             }
2202             return tokenIds;
2203         }
2204     }
2205 
2206     /**
2207      * @dev Returns an array of token IDs owned by `owner`.
2208      *
2209      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2210      * It is meant to be called off-chain.
2211      *
2212      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2213      * multiple smaller scans if the collection is large enough to cause
2214      * an out-of-gas error (10K collections should be fine).
2215      */
2216     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2217         unchecked {
2218             uint256 tokenIdsIdx;
2219             address currOwnershipAddr;
2220             uint256 tokenIdsLength = balanceOf(owner);
2221             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2222             TokenOwnership memory ownership;
2223             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2224                 ownership = _ownershipAt(i);
2225                 if (ownership.burned) {
2226                     continue;
2227                 }
2228                 if (ownership.addr != address(0)) {
2229                     currOwnershipAddr = ownership.addr;
2230                 }
2231                 if (currOwnershipAddr == owner) {
2232                     tokenIds[tokenIdsIdx++] = i;
2233                 }
2234             }
2235             return tokenIds;
2236         }
2237     }
2238 }
2239 
2240 
2241 // AN APE CALLED BEAST
2242 
2243 pragma solidity ^0.8.13;
2244 
2245 error AllowlistRequired();
2246 error ExceedsMaxPerTransaction();
2247 error ExceedsMaxPerWallet();
2248 error IncorrectPaymentAmount();
2249 error InvalidMintSize();
2250 error MintDisabled();
2251 error NoPresaleForYou();
2252 error NonExistentToken();
2253 error PresaleDisabled();
2254 error NotEnoughEth();
2255 error SupplyLimitReached();
2256 error WithdrawFailed();
2257 
2258 contract AnApeCalledBeast is ERC721AQueryable, ReentrancyGuard, ERC2981, Ownable {
2259 
2260     string private _baseTokenURI;
2261     bytes32 public presaleRoot;
2262     bool public canMint = false;
2263     bool public canPresale = false;
2264     uint public cost = 0.0042 ether;
2265     uint public freePerWallet = 1;
2266     uint public maxPerTransaction = 7;
2267     uint public maxPerWallet = 7;
2268     uint public totalAvailable = 7777;
2269 
2270     constructor() ERC721A("An Ape Called Beast", "AACB") {}
2271 
2272     modifier callerIsUser() {
2273         require(tx.origin == msg.sender, "not original sender");
2274         _;
2275     }
2276 
2277     function mint(uint qty)
2278       external
2279       payable
2280       callerIsUser
2281       nonReentrant {
2282         uint price = getPrice(qty);
2283 
2284         if (!canMint) revert MintDisabled();
2285         if (qty > maxPerTransaction + 1) revert ExceedsMaxPerTransaction();
2286         if (_numberMinted(msg.sender) + qty > maxPerWallet + 1) revert ExceedsMaxPerWallet();
2287         if (_totalMinted() + qty > totalAvailable + 1) revert SupplyLimitReached();
2288 
2289         _mint(msg.sender, qty);
2290         _refundOverPayment(price);
2291     }
2292 
2293     function presale(
2294       bytes32[] calldata proof,
2295       uint qty)
2296         external
2297         payable
2298         callerIsUser
2299         nonReentrant
2300     {
2301         if (!canPresale) revert PresaleDisabled();
2302         if (_totalMinted() + qty > totalAvailable + 1) revert SupplyLimitReached();
2303         if (_numberMinted(msg.sender) + qty > maxPerWallet + 1) revert ExceedsMaxPerWallet();
2304 
2305         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2306 
2307         if (!MerkleProof.verify(proof, presaleRoot, leaf)) revert NoPresaleForYou();
2308 
2309         uint price = getPrice(qty);
2310 
2311         _mint(msg.sender, qty);
2312         _refundOverPayment(price);
2313     }
2314 
2315     function getPrice(uint qty) public view returns (uint) {
2316       uint numMinted = _numberMinted(msg.sender);
2317       uint free = numMinted < freePerWallet ? freePerWallet - numMinted : 0;
2318       if (qty >= free) {
2319         return (cost) * (qty - free);
2320       }
2321       return 0;
2322     }
2323 
2324     function _refundOverPayment(uint256 amount) internal {
2325         if (msg.value < amount) revert NotEnoughEth();
2326         if (msg.value > amount) {
2327             payable(msg.sender).transfer(msg.value - amount);
2328         }
2329     }
2330 
2331     function devMint(uint256 quantity, address to) external onlyOwner {
2332         require(
2333             totalSupply() + quantity <= totalAvailable,
2334             "dev you should know better"
2335         );
2336         _mint(to, quantity);
2337     }
2338 
2339     function _baseURI() internal view virtual override returns (string memory) {
2340         return _baseTokenURI;
2341     }
2342 
2343     function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
2344         _setDefaultRoyalty(receiver, feeNumerator);
2345     }
2346 
2347     function deleteDefaultRoyalty() external onlyOwner {
2348         _deleteDefaultRoyalty();
2349     }
2350 
2351     function _startTokenId() internal view virtual override returns (uint256) {
2352         return 1;
2353     }
2354 
2355     function setMaxPerTx(uint256 maxPerTransaction_) external onlyOwner {
2356         maxPerTransaction = maxPerTransaction_;
2357     }
2358 
2359     function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
2360         maxPerWallet = maxPerWallet_;
2361     }
2362 
2363     function setMaxSupply(uint256 maxSupply_) public onlyOwner {
2364         totalAvailable = maxSupply_;
2365     }
2366 
2367     function setPresaleRoot(bytes32 presaleRoot_) external onlyOwner{
2368         presaleRoot = presaleRoot_;
2369     }
2370 
2371     function numberAdopted(address owner) public view returns (uint256) {
2372         return _numberMinted(owner);
2373     }
2374 
2375     function toggleCanPresale() external onlyOwner {
2376         canPresale = !canPresale;
2377     }
2378 
2379     function toggleCanMint() external onlyOwner {
2380         canMint = !canMint;
2381     }
2382 
2383     function setBaseURI(string calldata baseURI_) external onlyOwner {
2384         _baseTokenURI = baseURI_;
2385     }
2386 
2387     function withdraw() external onlyOwner {
2388         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2389         if (!success) revert WithdrawFailed();
2390     }
2391 
2392     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981, IERC721A) returns (bool) {
2393         // Supports the following `interfaceId`s:
2394         // - IERC165: 0x01ffc9a7
2395         // - IERC721: 0x80ac58cd
2396         // - IERC721Metadata: 0x5b5e139f
2397         // - IERC2981: 0x2a55205a
2398         return
2399             ERC721A.supportsInterface(interfaceId) ||
2400             ERC2981.supportsInterface(interfaceId);
2401     }
2402 
2403 }
2404 
2405 
2406 // File contracts/extensions/IERC4907A.sol
2407 
2408 // ERC721A Contracts v4.2.2
2409 // Creator: Chiru Labs
2410 
2411 pragma solidity ^0.8.4;
2412 
2413 /**
2414  * @dev Interface of ERC4907A.
2415  */
2416 interface IERC4907A is IERC721A {
2417     /**
2418      * The caller must own the token or be an approved operator.
2419      */
2420     error SetUserCallerNotOwnerNorApproved();
2421 
2422     /**
2423      * @dev Emitted when the `user` of an NFT or the `expires` of the `user` is changed.
2424      * The zero address for user indicates that there is no user address.
2425      */
2426     event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
2427 
2428     /**
2429      * @dev Sets the `user` and `expires` for `tokenId`.
2430      * The zero address indicates there is no user.
2431      *
2432      * Requirements:
2433      *
2434      * - The caller must own `tokenId` or be an approved operator.
2435      */
2436     function setUser(
2437         uint256 tokenId,
2438         address user,
2439         uint64 expires
2440     ) external;
2441 
2442     /**
2443      * @dev Returns the user address for `tokenId`.
2444      * The zero address indicates that there is no user or if the user is expired.
2445      */
2446     function userOf(uint256 tokenId) external view returns (address);
2447 
2448     /**
2449      * @dev Returns the user's expires of `tokenId`.
2450      */
2451     function userExpires(uint256 tokenId) external view returns (uint256);
2452 }
2453 
2454 
2455 // File contracts/extensions/ERC4907A.sol
2456 
2457 // ERC721A Contracts v4.2.2
2458 // Creator: Chiru Labs
2459 
2460 pragma solidity ^0.8.4;
2461 
2462 
2463 /**
2464  * @title ERC4907A
2465  *
2466  * @dev [ERC4907](https://eips.ethereum.org/EIPS/eip-4907) compliant
2467  * extension of ERC721A, which allows owners and authorized addresses
2468  * to add a time-limited role with restricted permissions to ERC721 tokens.
2469  */
2470 abstract contract ERC4907A is ERC721A, IERC4907A {
2471     // The bit position of `expires` in packed user info.
2472     uint256 private constant _BITPOS_EXPIRES = 160;
2473 
2474     // Mapping from token ID to user info.
2475     //
2476     // Bits Layout:
2477     // - [0..159]   `user`
2478     // - [160..223] `expires`
2479     mapping(uint256 => uint256) private _packedUserInfo;
2480 
2481     /**
2482      * @dev Sets the `user` and `expires` for `tokenId`.
2483      * The zero address indicates there is no user.
2484      *
2485      * Requirements:
2486      *
2487      * - The caller must own `tokenId` or be an approved operator.
2488      */
2489     function setUser(
2490         uint256 tokenId,
2491         address user,
2492         uint64 expires
2493     ) public virtual override {
2494         // Require the caller to be either the token owner or an approved operator.
2495         address owner = ownerOf(tokenId);
2496         if (_msgSenderERC721A() != owner)
2497             if (!isApprovedForAll(owner, _msgSenderERC721A()))
2498                 if (getApproved(tokenId) != _msgSenderERC721A()) revert SetUserCallerNotOwnerNorApproved();
2499 
2500         _packedUserInfo[tokenId] = (uint256(expires) << _BITPOS_EXPIRES) | uint256(uint160(user));
2501 
2502         emit UpdateUser(tokenId, user, expires);
2503     }
2504 
2505     /**
2506      * @dev Returns the user address for `tokenId`.
2507      * The zero address indicates that there is no user or if the user is expired.
2508      */
2509     function userOf(uint256 tokenId) public view virtual override returns (address) {
2510         uint256 packed = _packedUserInfo[tokenId];
2511         assembly {
2512             // Branchless `packed *= (block.timestamp <= expires ? 1 : 0)`.
2513             // If the `block.timestamp == expires`, the `lt` clause will be true
2514             // if there is a non-zero user address in the lower 160 bits of `packed`.
2515             packed := mul(
2516                 packed,
2517                 // `block.timestamp <= expires ? 1 : 0`.
2518                 lt(shl(_BITPOS_EXPIRES, timestamp()), packed)
2519             )
2520         }
2521         return address(uint160(packed));
2522     }
2523 
2524     /**
2525      * @dev Returns the user's expires of `tokenId`.
2526      */
2527     function userExpires(uint256 tokenId) public view virtual override returns (uint256) {
2528         return _packedUserInfo[tokenId] >> _BITPOS_EXPIRES;
2529     }
2530 
2531     /**
2532      * @dev Override of {IERC165-supportsInterface}.
2533      */
2534     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A) returns (bool) {
2535         // The interface ID for ERC4907 is `0xad092b5c`,
2536         // as defined in [ERC4907](https://eips.ethereum.org/EIPS/eip-4907).
2537         return super.supportsInterface(interfaceId) || interfaceId == 0xad092b5c;
2538     }
2539 
2540     /**
2541      * @dev Returns the user address for `tokenId`, ignoring the expiry status.
2542      */
2543     function _explicitUserOf(uint256 tokenId) internal view virtual returns (address) {
2544         return address(uint160(_packedUserInfo[tokenId]));
2545     }
2546 }
2547 
2548 
2549 // File contracts/extensions/IERC721ABurnable.sol
2550 
2551 // ERC721A Contracts v4.2.2
2552 // Creator: Chiru Labs
2553 
2554 pragma solidity ^0.8.4;
2555 
2556 /**
2557  * @dev Interface of ERC721ABurnable.
2558  */
2559 interface IERC721ABurnable is IERC721A {
2560     /**
2561      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2562      *
2563      * Requirements:
2564      *
2565      * - The caller must own `tokenId` or be an approved operator.
2566      */
2567     function burn(uint256 tokenId) external;
2568 }
2569 
2570 
2571 // File contracts/extensions/ERC721ABurnable.sol
2572 
2573 // ERC721A Contracts v4.2.2
2574 // Creator: Chiru Labs
2575 
2576 pragma solidity ^0.8.4;
2577 
2578 
2579 /**
2580  * @title ERC721ABurnable.
2581  *
2582  * @dev ERC721A token that can be irreversibly burned (destroyed).
2583  */
2584 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2585     /**
2586      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2587      *
2588      * Requirements:
2589      *
2590      * - The caller must own `tokenId` or be an approved operator.
2591      */
2592     function burn(uint256 tokenId) public virtual override {
2593         _burn(tokenId, true);
2594     }
2595 }