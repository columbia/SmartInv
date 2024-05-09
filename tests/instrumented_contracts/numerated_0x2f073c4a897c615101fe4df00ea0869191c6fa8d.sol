1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Interface of the ERC165 standard, as defined in the
80  * https://eips.ethereum.org/EIPS/eip-165[EIP].
81  *
82  * Implementers can declare support of contract interfaces, which can then be
83  * queried by others ({ERC165Checker}).
84  *
85  * For an implementation, see {ERC165}.
86  */
87 interface IERC165 {
88     /**
89      * @dev Returns true if this contract implements the interface defined by
90      * `interfaceId`. See the corresponding
91      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
92      * to learn more about how these ids are created.
93      *
94      * This function call must use less than 30 000 gas.
95      */
96     function supportsInterface(bytes4 interfaceId) external view returns (bool);
97 }
98 
99 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
100 
101 
102 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Interface for the NFT Royalty Standard.
109  *
110  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
111  * support for royalty payments across all NFT marketplaces and ecosystem participants.
112  *
113  * _Available since v4.5._
114  */
115 interface IERC2981 is IERC165 {
116     /**
117      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
118      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
119      */
120     function royaltyInfo(uint256 tokenId, uint256 salePrice)
121         external
122         view
123         returns (address receiver, uint256 royaltyAmount);
124 }
125 
126 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Contract module that helps prevent reentrant calls to a function.
135  *
136  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
137  * available, which can be applied to functions to make sure there are no nested
138  * (reentrant) calls to them.
139  *
140  * Note that because there is a single `nonReentrant` guard, functions marked as
141  * `nonReentrant` may not call one another. This can be worked around by making
142  * those functions `private`, and then adding `external` `nonReentrant` entry
143  * points to them.
144  *
145  * TIP: If you would like to learn more about reentrancy and alternative ways
146  * to protect against it, check out our blog post
147  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
148  */
149 abstract contract ReentrancyGuard {
150     // Booleans are more expensive than uint256 or any type that takes up a full
151     // word because each write operation emits an extra SLOAD to first read the
152     // slot's contents, replace the bits taken up by the boolean, and then write
153     // back. This is the compiler's defense against contract upgrades and
154     // pointer aliasing, and it cannot be disabled.
155 
156     // The values being non-zero value makes deployment a bit more expensive,
157     // but in exchange the refund on every call to nonReentrant will be lower in
158     // amount. Since refunds are capped to a percentage of the total
159     // transaction's gas, it is best to keep them low in cases like this one, to
160     // increase the likelihood of the full refund coming into effect.
161     uint256 private constant _NOT_ENTERED = 1;
162     uint256 private constant _ENTERED = 2;
163 
164     uint256 private _status;
165 
166     constructor() {
167         _status = _NOT_ENTERED;
168     }
169 
170     /**
171      * @dev Prevents a contract from calling itself, directly or indirectly.
172      * Calling a `nonReentrant` function from another `nonReentrant`
173      * function is not supported. It is possible to prevent this from happening
174      * by making the `nonReentrant` function external, and making it call a
175      * `private` function that does the actual work.
176      */
177     modifier nonReentrant() {
178         // On the first call to nonReentrant, _notEntered will be true
179         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
180 
181         // Any calls to nonReentrant after this point will fail
182         _status = _ENTERED;
183 
184         _;
185 
186         // By storing the original value once again, a refund is triggered (see
187         // https://eips.ethereum.org/EIPS/eip-2200)
188         _status = _NOT_ENTERED;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev These functions deal with verification of Merkle Tree proofs.
201  *
202  * The proofs can be generated using the JavaScript library
203  * https://github.com/miguelmota/merkletreejs[merkletreejs].
204  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
205  *
206  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
207  *
208  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
209  * hashing, or use a hash function other than keccak256 for hashing leaves.
210  * This is because the concatenation of a sorted pair of internal nodes in
211  * the merkle tree could be reinterpreted as a leaf value.
212  */
213 library MerkleProof {
214     /**
215      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
216      * defined by `root`. For this, a `proof` must be provided, containing
217      * sibling hashes on the branch from the leaf to the root of the tree. Each
218      * pair of leaves and each pair of pre-images are assumed to be sorted.
219      */
220     function verify(
221         bytes32[] memory proof,
222         bytes32 root,
223         bytes32 leaf
224     ) internal pure returns (bool) {
225         return processProof(proof, leaf) == root;
226     }
227 
228     /**
229      * @dev Calldata version of {verify}
230      *
231      * _Available since v4.7._
232      */
233     function verifyCalldata(
234         bytes32[] calldata proof,
235         bytes32 root,
236         bytes32 leaf
237     ) internal pure returns (bool) {
238         return processProofCalldata(proof, leaf) == root;
239     }
240 
241     /**
242      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
243      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
244      * hash matches the root of the tree. When processing the proof, the pairs
245      * of leafs & pre-images are assumed to be sorted.
246      *
247      * _Available since v4.4._
248      */
249     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
250         bytes32 computedHash = leaf;
251         for (uint256 i = 0; i < proof.length; i++) {
252             computedHash = _hashPair(computedHash, proof[i]);
253         }
254         return computedHash;
255     }
256 
257     /**
258      * @dev Calldata version of {processProof}
259      *
260      * _Available since v4.7._
261      */
262     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
263         bytes32 computedHash = leaf;
264         for (uint256 i = 0; i < proof.length; i++) {
265             computedHash = _hashPair(computedHash, proof[i]);
266         }
267         return computedHash;
268     }
269 
270     /**
271      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
272      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
273      *
274      * _Available since v4.7._
275      */
276     function multiProofVerify(
277         bytes32[] memory proof,
278         bool[] memory proofFlags,
279         bytes32 root,
280         bytes32[] memory leaves
281     ) internal pure returns (bool) {
282         return processMultiProof(proof, proofFlags, leaves) == root;
283     }
284 
285     /**
286      * @dev Calldata version of {multiProofVerify}
287      *
288      * _Available since v4.7._
289      */
290     function multiProofVerifyCalldata(
291         bytes32[] calldata proof,
292         bool[] calldata proofFlags,
293         bytes32 root,
294         bytes32[] memory leaves
295     ) internal pure returns (bool) {
296         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
297     }
298 
299     /**
300      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
301      * consuming from one or the other at each step according to the instructions given by
302      * `proofFlags`.
303      *
304      * _Available since v4.7._
305      */
306     function processMultiProof(
307         bytes32[] memory proof,
308         bool[] memory proofFlags,
309         bytes32[] memory leaves
310     ) internal pure returns (bytes32 merkleRoot) {
311         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
312         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
313         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
314         // the merkle tree.
315         uint256 leavesLen = leaves.length;
316         uint256 totalHashes = proofFlags.length;
317 
318         // Check proof validity.
319         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
320 
321         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
322         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
323         bytes32[] memory hashes = new bytes32[](totalHashes);
324         uint256 leafPos = 0;
325         uint256 hashPos = 0;
326         uint256 proofPos = 0;
327         // At each step, we compute the next hash using two values:
328         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
329         //   get the next hash.
330         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
331         //   `proof` array.
332         for (uint256 i = 0; i < totalHashes; i++) {
333             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
334             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
335             hashes[i] = _hashPair(a, b);
336         }
337 
338         if (totalHashes > 0) {
339             return hashes[totalHashes - 1];
340         } else if (leavesLen > 0) {
341             return leaves[0];
342         } else {
343             return proof[0];
344         }
345     }
346 
347     /**
348      * @dev Calldata version of {processMultiProof}
349      *
350      * _Available since v4.7._
351      */
352     function processMultiProofCalldata(
353         bytes32[] calldata proof,
354         bool[] calldata proofFlags,
355         bytes32[] memory leaves
356     ) internal pure returns (bytes32 merkleRoot) {
357         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
358         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
359         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
360         // the merkle tree.
361         uint256 leavesLen = leaves.length;
362         uint256 totalHashes = proofFlags.length;
363 
364         // Check proof validity.
365         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
366 
367         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
368         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
369         bytes32[] memory hashes = new bytes32[](totalHashes);
370         uint256 leafPos = 0;
371         uint256 hashPos = 0;
372         uint256 proofPos = 0;
373         // At each step, we compute the next hash using two values:
374         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
375         //   get the next hash.
376         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
377         //   `proof` array.
378         for (uint256 i = 0; i < totalHashes; i++) {
379             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
380             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
381             hashes[i] = _hashPair(a, b);
382         }
383 
384         if (totalHashes > 0) {
385             return hashes[totalHashes - 1];
386         } else if (leavesLen > 0) {
387             return leaves[0];
388         } else {
389             return proof[0];
390         }
391     }
392 
393     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
394         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
395     }
396 
397     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
398         /// @solidity memory-safe-assembly
399         assembly {
400             mstore(0x00, a)
401             mstore(0x20, b)
402             value := keccak256(0x00, 0x40)
403         }
404     }
405 }
406 
407 // File: @openzeppelin/contracts/utils/Context.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @dev Provides information about the current execution context, including the
416  * sender of the transaction and its data. While these are generally available
417  * via msg.sender and msg.data, they should not be accessed in such a direct
418  * manner, since when dealing with meta-transactions the account sending and
419  * paying for execution may not be the actual sender (as far as an application
420  * is concerned).
421  *
422  * This contract is only required for intermediate, library-like contracts.
423  */
424 abstract contract Context {
425     function _msgSender() internal view virtual returns (address) {
426         return msg.sender;
427     }
428 
429     function _msgData() internal view virtual returns (bytes calldata) {
430         return msg.data;
431     }
432 }
433 
434 // File: @openzeppelin/contracts/access/Ownable.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 
442 /**
443  * @dev Contract module which provides a basic access control mechanism, where
444  * there is an account (an owner) that can be granted exclusive access to
445  * specific functions.
446  *
447  * By default, the owner account will be the one that deploys the contract. This
448  * can later be changed with {transferOwnership}.
449  *
450  * This module is used through inheritance. It will make available the modifier
451  * `onlyOwner`, which can be applied to your functions to restrict their use to
452  * the owner.
453  */
454 abstract contract Ownable is Context {
455     address private _owner;
456 
457     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
458 
459     /**
460      * @dev Initializes the contract setting the deployer as the initial owner.
461      */
462     constructor() {
463         _transferOwnership(_msgSender());
464     }
465 
466     /**
467      * @dev Returns the address of the current owner.
468      */
469     function owner() public view virtual returns (address) {
470         return _owner;
471     }
472 
473     /**
474      * @dev Throws if called by any account other than the owner.
475      */
476     modifier onlyOwner() {
477         require(owner() == _msgSender(), "Ownable: caller is not the owner");
478         _;
479     }
480 
481     /**
482      * @dev Leaves the contract without owner. It will not be possible to call
483      * `onlyOwner` functions anymore. Can only be called by the current owner.
484      *
485      * NOTE: Renouncing ownership will leave the contract without an owner,
486      * thereby removing any functionality that is only available to the owner.
487      */
488     function renounceOwnership() public virtual onlyOwner {
489         _transferOwnership(address(0));
490     }
491 
492     /**
493      * @dev Transfers ownership of the contract to a new account (`newOwner`).
494      * Can only be called by the current owner.
495      */
496     function transferOwnership(address newOwner) public virtual onlyOwner {
497         require(newOwner != address(0), "Ownable: new owner is the zero address");
498         _transferOwnership(newOwner);
499     }
500 
501     /**
502      * @dev Transfers ownership of the contract to a new account (`newOwner`).
503      * Internal function without access restriction.
504      */
505     function _transferOwnership(address newOwner) internal virtual {
506         address oldOwner = _owner;
507         _owner = newOwner;
508         emit OwnershipTransferred(oldOwner, newOwner);
509     }
510 }
511 
512 // File: erc721a/contracts/IERC721A.sol
513 
514 
515 // ERC721A Contracts v4.2.0
516 // Creator: Chiru Labs
517 
518 pragma solidity ^0.8.4;
519 
520 /**
521  * @dev Interface of ERC721A.
522  */
523 interface IERC721A {
524     /**
525      * The caller must own the token or be an approved operator.
526      */
527     error ApprovalCallerNotOwnerNorApproved();
528 
529     /**
530      * The token does not exist.
531      */
532     error ApprovalQueryForNonexistentToken();
533 
534     /**
535      * The caller cannot approve to their own address.
536      */
537     error ApproveToCaller();
538 
539     /**
540      * Cannot query the balance for the zero address.
541      */
542     error BalanceQueryForZeroAddress();
543 
544     /**
545      * Cannot mint to the zero address.
546      */
547     error MintToZeroAddress();
548 
549     /**
550      * The quantity of tokens minted must be more than zero.
551      */
552     error MintZeroQuantity();
553 
554     /**
555      * The token does not exist.
556      */
557     error OwnerQueryForNonexistentToken();
558 
559     /**
560      * The caller must own the token or be an approved operator.
561      */
562     error TransferCallerNotOwnerNorApproved();
563 
564     /**
565      * The token must be owned by `from`.
566      */
567     error TransferFromIncorrectOwner();
568 
569     /**
570      * Cannot safely transfer to a contract that does not implement the
571      * ERC721Receiver interface.
572      */
573     error TransferToNonERC721ReceiverImplementer();
574 
575     /**
576      * Cannot transfer to the zero address.
577      */
578     error TransferToZeroAddress();
579 
580     /**
581      * The token does not exist.
582      */
583     error URIQueryForNonexistentToken();
584 
585     /**
586      * The `quantity` minted with ERC2309 exceeds the safety limit.
587      */
588     error MintERC2309QuantityExceedsLimit();
589 
590     /**
591      * The `extraData` cannot be set on an unintialized ownership slot.
592      */
593     error OwnershipNotInitializedForExtraData();
594 
595     // =============================================================
596     //                            STRUCTS
597     // =============================================================
598 
599     struct TokenOwnership {
600         // The address of the owner.
601         address addr;
602         // Stores the start time of ownership with minimal overhead for tokenomics.
603         uint64 startTimestamp;
604         // Whether the token has been burned.
605         bool burned;
606         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
607         uint24 extraData;
608     }
609 
610     // =============================================================
611     //                         TOKEN COUNTERS
612     // =============================================================
613 
614     /**
615      * @dev Returns the total number of tokens in existence.
616      * Burned tokens will reduce the count.
617      * To get the total number of tokens minted, please see {_totalMinted}.
618      */
619     function totalSupply() external view returns (uint256);
620 
621     // =============================================================
622     //                            IERC165
623     // =============================================================
624 
625     /**
626      * @dev Returns true if this contract implements the interface defined by
627      * `interfaceId`. See the corresponding
628      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
629      * to learn more about how these ids are created.
630      *
631      * This function call must use less than 30000 gas.
632      */
633     function supportsInterface(bytes4 interfaceId) external view returns (bool);
634 
635     // =============================================================
636     //                            IERC721
637     // =============================================================
638 
639     /**
640      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
641      */
642     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
643 
644     /**
645      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
646      */
647     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
648 
649     /**
650      * @dev Emitted when `owner` enables or disables
651      * (`approved`) `operator` to manage all of its assets.
652      */
653     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
654 
655     /**
656      * @dev Returns the number of tokens in `owner`'s account.
657      */
658     function balanceOf(address owner) external view returns (uint256 balance);
659 
660     /**
661      * @dev Returns the owner of the `tokenId` token.
662      *
663      * Requirements:
664      *
665      * - `tokenId` must exist.
666      */
667     function ownerOf(uint256 tokenId) external view returns (address owner);
668 
669     /**
670      * @dev Safely transfers `tokenId` token from `from` to `to`,
671      * checking first that contract recipients are aware of the ERC721 protocol
672      * to prevent tokens from being forever locked.
673      *
674      * Requirements:
675      *
676      * - `from` cannot be the zero address.
677      * - `to` cannot be the zero address.
678      * - `tokenId` token must exist and be owned by `from`.
679      * - If the caller is not `from`, it must be have been allowed to move
680      * this token by either {approve} or {setApprovalForAll}.
681      * - If `to` refers to a smart contract, it must implement
682      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
683      *
684      * Emits a {Transfer} event.
685      */
686     function safeTransferFrom(
687         address from,
688         address to,
689         uint256 tokenId,
690         bytes calldata data
691     ) external;
692 
693     /**
694      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Transfers `tokenId` from `from` to `to`.
704      *
705      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
706      * whenever possible.
707      *
708      * Requirements:
709      *
710      * - `from` cannot be the zero address.
711      * - `to` cannot be the zero address.
712      * - `tokenId` token must be owned by `from`.
713      * - If the caller is not `from`, it must be approved to move this token
714      * by either {approve} or {setApprovalForAll}.
715      *
716      * Emits a {Transfer} event.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) external;
723 
724     /**
725      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
726      * The approval is cleared when the token is transferred.
727      *
728      * Only a single account can be approved at a time, so approving the
729      * zero address clears previous approvals.
730      *
731      * Requirements:
732      *
733      * - The caller must own the token or be an approved operator.
734      * - `tokenId` must exist.
735      *
736      * Emits an {Approval} event.
737      */
738     function approve(address to, uint256 tokenId) external;
739 
740     /**
741      * @dev Approve or remove `operator` as an operator for the caller.
742      * Operators can call {transferFrom} or {safeTransferFrom}
743      * for any token owned by the caller.
744      *
745      * Requirements:
746      *
747      * - The `operator` cannot be the caller.
748      *
749      * Emits an {ApprovalForAll} event.
750      */
751     function setApprovalForAll(address operator, bool _approved) external;
752 
753     /**
754      * @dev Returns the account approved for `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function getApproved(uint256 tokenId) external view returns (address operator);
761 
762     /**
763      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
764      *
765      * See {setApprovalForAll}.
766      */
767     function isApprovedForAll(address owner, address operator) external view returns (bool);
768 
769     // =============================================================
770     //                        IERC721Metadata
771     // =============================================================
772 
773     /**
774      * @dev Returns the token collection name.
775      */
776     function name() external view returns (string memory);
777 
778     /**
779      * @dev Returns the token collection symbol.
780      */
781     function symbol() external view returns (string memory);
782 
783     /**
784      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
785      */
786     function tokenURI(uint256 tokenId) external view returns (string memory);
787 
788     // =============================================================
789     //                           IERC2309
790     // =============================================================
791 
792     /**
793      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
794      * (inclusive) is transferred from `from` to `to`, as defined in the
795      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
796      *
797      * See {_mintERC2309} for more details.
798      */
799     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
800 }
801 
802 // File: erc721a/contracts/ERC721A.sol
803 
804 
805 // ERC721A Contracts v4.2.0
806 // Creator: Chiru Labs
807 
808 pragma solidity ^0.8.4;
809 
810 
811 /**
812  * @dev Interface of ERC721 token receiver.
813  */
814 interface ERC721A__IERC721Receiver {
815     function onERC721Received(
816         address operator,
817         address from,
818         uint256 tokenId,
819         bytes calldata data
820     ) external returns (bytes4);
821 }
822 
823 /**
824  * @title ERC721A
825  *
826  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
827  * Non-Fungible Token Standard, including the Metadata extension.
828  * Optimized for lower gas during batch mints.
829  *
830  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
831  * starting from `_startTokenId()`.
832  *
833  * Assumptions:
834  *
835  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
836  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
837  */
838 contract ERC721A is IERC721A {
839     // Reference type for token approval.
840     struct TokenApprovalRef {
841         address value;
842     }
843 
844     // =============================================================
845     //                           CONSTANTS
846     // =============================================================
847 
848     // Mask of an entry in packed address data.
849     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
850 
851     // The bit position of `numberMinted` in packed address data.
852     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
853 
854     // The bit position of `numberBurned` in packed address data.
855     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
856 
857     // The bit position of `aux` in packed address data.
858     uint256 private constant _BITPOS_AUX = 192;
859 
860     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
861     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
862 
863     // The bit position of `startTimestamp` in packed ownership.
864     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
865 
866     // The bit mask of the `burned` bit in packed ownership.
867     uint256 private constant _BITMASK_BURNED = 1 << 224;
868 
869     // The bit position of the `nextInitialized` bit in packed ownership.
870     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
871 
872     // The bit mask of the `nextInitialized` bit in packed ownership.
873     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
874 
875     // The bit position of `extraData` in packed ownership.
876     uint256 private constant _BITPOS_EXTRA_DATA = 232;
877 
878     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
879     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
880 
881     // The mask of the lower 160 bits for addresses.
882     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
883 
884     // The maximum `quantity` that can be minted with {_mintERC2309}.
885     // This limit is to prevent overflows on the address data entries.
886     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
887     // is required to cause an overflow, which is unrealistic.
888     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
889 
890     // The `Transfer` event signature is given by:
891     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
892     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
893         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
894 
895     // =============================================================
896     //                            STORAGE
897     // =============================================================
898 
899     // The next token ID to be minted.
900     uint256 private _currentIndex;
901 
902     // The number of tokens burned.
903     uint256 private _burnCounter;
904 
905     // Token name
906     string private _name;
907 
908     // Token symbol
909     string private _symbol;
910 
911     // Mapping from token ID to ownership details
912     // An empty struct value does not necessarily mean the token is unowned.
913     // See {_packedOwnershipOf} implementation for details.
914     //
915     // Bits Layout:
916     // - [0..159]   `addr`
917     // - [160..223] `startTimestamp`
918     // - [224]      `burned`
919     // - [225]      `nextInitialized`
920     // - [232..255] `extraData`
921     mapping(uint256 => uint256) private _packedOwnerships;
922 
923     // Mapping owner address to address data.
924     //
925     // Bits Layout:
926     // - [0..63]    `balance`
927     // - [64..127]  `numberMinted`
928     // - [128..191] `numberBurned`
929     // - [192..255] `aux`
930     mapping(address => uint256) private _packedAddressData;
931 
932     // Mapping from token ID to approved address.
933     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
934 
935     // Mapping from owner to operator approvals
936     mapping(address => mapping(address => bool)) private _operatorApprovals;
937 
938     // =============================================================
939     //                          CONSTRUCTOR
940     // =============================================================
941 
942     constructor(string memory name_, string memory symbol_) {
943         _name = name_;
944         _symbol = symbol_;
945         _currentIndex = _startTokenId();
946     }
947 
948     // =============================================================
949     //                   TOKEN COUNTING OPERATIONS
950     // =============================================================
951 
952     /**
953      * @dev Returns the starting token ID.
954      * To change the starting token ID, please override this function.
955      */
956     function _startTokenId() internal view virtual returns (uint256) {
957         return 0;
958     }
959 
960     /**
961      * @dev Returns the next token ID to be minted.
962      */
963     function _nextTokenId() internal view virtual returns (uint256) {
964         return _currentIndex;
965     }
966 
967     /**
968      * @dev Returns the total number of tokens in existence.
969      * Burned tokens will reduce the count.
970      * To get the total number of tokens minted, please see {_totalMinted}.
971      */
972     function totalSupply() public view virtual override returns (uint256) {
973         // Counter underflow is impossible as _burnCounter cannot be incremented
974         // more than `_currentIndex - _startTokenId()` times.
975         unchecked {
976             return _currentIndex - _burnCounter - _startTokenId();
977         }
978     }
979 
980     /**
981      * @dev Returns the total amount of tokens minted in the contract.
982      */
983     function _totalMinted() internal view virtual returns (uint256) {
984         // Counter underflow is impossible as `_currentIndex` does not decrement,
985         // and it is initialized to `_startTokenId()`.
986         unchecked {
987             return _currentIndex - _startTokenId();
988         }
989     }
990 
991     /**
992      * @dev Returns the total number of tokens burned.
993      */
994     function _totalBurned() internal view virtual returns (uint256) {
995         return _burnCounter;
996     }
997 
998     // =============================================================
999     //                    ADDRESS DATA OPERATIONS
1000     // =============================================================
1001 
1002     /**
1003      * @dev Returns the number of tokens in `owner`'s account.
1004      */
1005     function balanceOf(address owner) public view virtual override returns (uint256) {
1006         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1007         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1008     }
1009 
1010     /**
1011      * Returns the number of tokens minted by `owner`.
1012      */
1013     function _numberMinted(address owner) internal view returns (uint256) {
1014         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1015     }
1016 
1017     /**
1018      * Returns the number of tokens burned by or on behalf of `owner`.
1019      */
1020     function _numberBurned(address owner) internal view returns (uint256) {
1021         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1022     }
1023 
1024     /**
1025      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1026      */
1027     function _getAux(address owner) internal view returns (uint64) {
1028         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1029     }
1030 
1031     /**
1032      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1033      * If there are multiple variables, please pack them into a uint64.
1034      */
1035     function _setAux(address owner, uint64 aux) internal virtual {
1036         uint256 packed = _packedAddressData[owner];
1037         uint256 auxCasted;
1038         // Cast `aux` with assembly to avoid redundant masking.
1039         assembly {
1040             auxCasted := aux
1041         }
1042         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1043         _packedAddressData[owner] = packed;
1044     }
1045 
1046     // =============================================================
1047     //                            IERC165
1048     // =============================================================
1049 
1050     /**
1051      * @dev Returns true if this contract implements the interface defined by
1052      * `interfaceId`. See the corresponding
1053      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1054      * to learn more about how these ids are created.
1055      *
1056      * This function call must use less than 30000 gas.
1057      */
1058     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1059         // The interface IDs are constants representing the first 4 bytes
1060         // of the XOR of all function selectors in the interface.
1061         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1062         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1063         return
1064             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1065             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1066             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1067     }
1068 
1069     // =============================================================
1070     //                        IERC721Metadata
1071     // =============================================================
1072 
1073     /**
1074      * @dev Returns the token collection name.
1075      */
1076     function name() public view virtual override returns (string memory) {
1077         return _name;
1078     }
1079 
1080     /**
1081      * @dev Returns the token collection symbol.
1082      */
1083     function symbol() public view virtual override returns (string memory) {
1084         return _symbol;
1085     }
1086 
1087     /**
1088      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1089      */
1090     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1091         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1092 
1093         string memory baseURI = _baseURI();
1094         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1095     }
1096 
1097     /**
1098      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1099      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1100      * by default, it can be overridden in child contracts.
1101      */
1102     function _baseURI() internal view virtual returns (string memory) {
1103         return '';
1104     }
1105 
1106     // =============================================================
1107     //                     OWNERSHIPS OPERATIONS
1108     // =============================================================
1109 
1110     /**
1111      * @dev Returns the owner of the `tokenId` token.
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must exist.
1116      */
1117     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1118         return address(uint160(_packedOwnershipOf(tokenId)));
1119     }
1120 
1121     /**
1122      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1123      * It gradually moves to O(1) as tokens get transferred around over time.
1124      */
1125     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1126         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1127     }
1128 
1129     /**
1130      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1131      */
1132     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1133         return _unpackedOwnership(_packedOwnerships[index]);
1134     }
1135 
1136     /**
1137      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1138      */
1139     function _initializeOwnershipAt(uint256 index) internal virtual {
1140         if (_packedOwnerships[index] == 0) {
1141             _packedOwnerships[index] = _packedOwnershipOf(index);
1142         }
1143     }
1144 
1145     /**
1146      * Returns the packed ownership data of `tokenId`.
1147      */
1148     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1149         uint256 curr = tokenId;
1150 
1151         unchecked {
1152             if (_startTokenId() <= curr)
1153                 if (curr < _currentIndex) {
1154                     uint256 packed = _packedOwnerships[curr];
1155                     // If not burned.
1156                     if (packed & _BITMASK_BURNED == 0) {
1157                         // Invariant:
1158                         // There will always be an initialized ownership slot
1159                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1160                         // before an unintialized ownership slot
1161                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1162                         // Hence, `curr` will not underflow.
1163                         //
1164                         // We can directly compare the packed value.
1165                         // If the address is zero, packed will be zero.
1166                         while (packed == 0) {
1167                             packed = _packedOwnerships[--curr];
1168                         }
1169                         return packed;
1170                     }
1171                 }
1172         }
1173         revert OwnerQueryForNonexistentToken();
1174     }
1175 
1176     /**
1177      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1178      */
1179     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1180         ownership.addr = address(uint160(packed));
1181         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1182         ownership.burned = packed & _BITMASK_BURNED != 0;
1183         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1184     }
1185 
1186     /**
1187      * @dev Packs ownership data into a single uint256.
1188      */
1189     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1190         assembly {
1191             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1192             owner := and(owner, _BITMASK_ADDRESS)
1193             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1194             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1195         }
1196     }
1197 
1198     /**
1199      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1200      */
1201     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1202         // For branchless setting of the `nextInitialized` flag.
1203         assembly {
1204             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1205             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1206         }
1207     }
1208 
1209     // =============================================================
1210     //                      APPROVAL OPERATIONS
1211     // =============================================================
1212 
1213     /**
1214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1215      * The approval is cleared when the token is transferred.
1216      *
1217      * Only a single account can be approved at a time, so approving the
1218      * zero address clears previous approvals.
1219      *
1220      * Requirements:
1221      *
1222      * - The caller must own the token or be an approved operator.
1223      * - `tokenId` must exist.
1224      *
1225      * Emits an {Approval} event.
1226      */
1227     function approve(address to, uint256 tokenId) public virtual override {
1228         address owner = ownerOf(tokenId);
1229 
1230         if (_msgSenderERC721A() != owner)
1231             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1232                 revert ApprovalCallerNotOwnerNorApproved();
1233             }
1234 
1235         _tokenApprovals[tokenId].value = to;
1236         emit Approval(owner, to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev Returns the account approved for `tokenId` token.
1241      *
1242      * Requirements:
1243      *
1244      * - `tokenId` must exist.
1245      */
1246     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1247         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1248 
1249         return _tokenApprovals[tokenId].value;
1250     }
1251 
1252     /**
1253      * @dev Approve or remove `operator` as an operator for the caller.
1254      * Operators can call {transferFrom} or {safeTransferFrom}
1255      * for any token owned by the caller.
1256      *
1257      * Requirements:
1258      *
1259      * - The `operator` cannot be the caller.
1260      *
1261      * Emits an {ApprovalForAll} event.
1262      */
1263     function setApprovalForAll(address operator, bool approved) public virtual override {
1264         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1265 
1266         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1267         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1268     }
1269 
1270     /**
1271      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1272      *
1273      * See {setApprovalForAll}.
1274      */
1275     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1276         return _operatorApprovals[owner][operator];
1277     }
1278 
1279     /**
1280      * @dev Returns whether `tokenId` exists.
1281      *
1282      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1283      *
1284      * Tokens start existing when they are minted. See {_mint}.
1285      */
1286     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1287         return
1288             _startTokenId() <= tokenId &&
1289             tokenId < _currentIndex && // If within bounds,
1290             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1291     }
1292 
1293     /**
1294      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1295      */
1296     function _isSenderApprovedOrOwner(
1297         address approvedAddress,
1298         address owner,
1299         address msgSender
1300     ) private pure returns (bool result) {
1301         assembly {
1302             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1303             owner := and(owner, _BITMASK_ADDRESS)
1304             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1305             msgSender := and(msgSender, _BITMASK_ADDRESS)
1306             // `msgSender == owner || msgSender == approvedAddress`.
1307             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1313      */
1314     function _getApprovedSlotAndAddress(uint256 tokenId)
1315         private
1316         view
1317         returns (uint256 approvedAddressSlot, address approvedAddress)
1318     {
1319         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1320         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1321         assembly {
1322             approvedAddressSlot := tokenApproval.slot
1323             approvedAddress := sload(approvedAddressSlot)
1324         }
1325     }
1326 
1327     // =============================================================
1328     //                      TRANSFER OPERATIONS
1329     // =============================================================
1330 
1331     /**
1332      * @dev Transfers `tokenId` from `from` to `to`.
1333      *
1334      * Requirements:
1335      *
1336      * - `from` cannot be the zero address.
1337      * - `to` cannot be the zero address.
1338      * - `tokenId` token must be owned by `from`.
1339      * - If the caller is not `from`, it must be approved to move this token
1340      * by either {approve} or {setApprovalForAll}.
1341      *
1342      * Emits a {Transfer} event.
1343      */
1344     function transferFrom(
1345         address from,
1346         address to,
1347         uint256 tokenId
1348     ) public virtual override {
1349         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1350 
1351         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1352 
1353         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1354 
1355         // The nested ifs save around 20+ gas over a compound boolean condition.
1356         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1357             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1358 
1359         if (to == address(0)) revert TransferToZeroAddress();
1360 
1361         _beforeTokenTransfers(from, to, tokenId, 1);
1362 
1363         // Clear approvals from the previous owner.
1364         assembly {
1365             if approvedAddress {
1366                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1367                 sstore(approvedAddressSlot, 0)
1368             }
1369         }
1370 
1371         // Underflow of the sender's balance is impossible because we check for
1372         // ownership above and the recipient's balance can't realistically overflow.
1373         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1374         unchecked {
1375             // We can directly increment and decrement the balances.
1376             --_packedAddressData[from]; // Updates: `balance -= 1`.
1377             ++_packedAddressData[to]; // Updates: `balance += 1`.
1378 
1379             // Updates:
1380             // - `address` to the next owner.
1381             // - `startTimestamp` to the timestamp of transfering.
1382             // - `burned` to `false`.
1383             // - `nextInitialized` to `true`.
1384             _packedOwnerships[tokenId] = _packOwnershipData(
1385                 to,
1386                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1387             );
1388 
1389             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1390             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1391                 uint256 nextTokenId = tokenId + 1;
1392                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1393                 if (_packedOwnerships[nextTokenId] == 0) {
1394                     // If the next slot is within bounds.
1395                     if (nextTokenId != _currentIndex) {
1396                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1397                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1398                     }
1399                 }
1400             }
1401         }
1402 
1403         emit Transfer(from, to, tokenId);
1404         _afterTokenTransfers(from, to, tokenId, 1);
1405     }
1406 
1407     /**
1408      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1409      */
1410     function safeTransferFrom(
1411         address from,
1412         address to,
1413         uint256 tokenId
1414     ) public virtual override {
1415         safeTransferFrom(from, to, tokenId, '');
1416     }
1417 
1418     /**
1419      * @dev Safely transfers `tokenId` token from `from` to `to`.
1420      *
1421      * Requirements:
1422      *
1423      * - `from` cannot be the zero address.
1424      * - `to` cannot be the zero address.
1425      * - `tokenId` token must exist and be owned by `from`.
1426      * - If the caller is not `from`, it must be approved to move this token
1427      * by either {approve} or {setApprovalForAll}.
1428      * - If `to` refers to a smart contract, it must implement
1429      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1430      *
1431      * Emits a {Transfer} event.
1432      */
1433     function safeTransferFrom(
1434         address from,
1435         address to,
1436         uint256 tokenId,
1437         bytes memory _data
1438     ) public virtual override {
1439         transferFrom(from, to, tokenId);
1440         if (to.code.length != 0)
1441             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1442                 revert TransferToNonERC721ReceiverImplementer();
1443             }
1444     }
1445 
1446     /**
1447      * @dev Hook that is called before a set of serially-ordered token IDs
1448      * are about to be transferred. This includes minting.
1449      * And also called before burning one token.
1450      *
1451      * `startTokenId` - the first token ID to be transferred.
1452      * `quantity` - the amount to be transferred.
1453      *
1454      * Calling conditions:
1455      *
1456      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1457      * transferred to `to`.
1458      * - When `from` is zero, `tokenId` will be minted for `to`.
1459      * - When `to` is zero, `tokenId` will be burned by `from`.
1460      * - `from` and `to` are never both zero.
1461      */
1462     function _beforeTokenTransfers(
1463         address from,
1464         address to,
1465         uint256 startTokenId,
1466         uint256 quantity
1467     ) internal virtual {}
1468 
1469     /**
1470      * @dev Hook that is called after a set of serially-ordered token IDs
1471      * have been transferred. This includes minting.
1472      * And also called after one token has been burned.
1473      *
1474      * `startTokenId` - the first token ID to be transferred.
1475      * `quantity` - the amount to be transferred.
1476      *
1477      * Calling conditions:
1478      *
1479      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1480      * transferred to `to`.
1481      * - When `from` is zero, `tokenId` has been minted for `to`.
1482      * - When `to` is zero, `tokenId` has been burned by `from`.
1483      * - `from` and `to` are never both zero.
1484      */
1485     function _afterTokenTransfers(
1486         address from,
1487         address to,
1488         uint256 startTokenId,
1489         uint256 quantity
1490     ) internal virtual {}
1491 
1492     /**
1493      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1494      *
1495      * `from` - Previous owner of the given token ID.
1496      * `to` - Target address that will receive the token.
1497      * `tokenId` - Token ID to be transferred.
1498      * `_data` - Optional data to send along with the call.
1499      *
1500      * Returns whether the call correctly returned the expected magic value.
1501      */
1502     function _checkContractOnERC721Received(
1503         address from,
1504         address to,
1505         uint256 tokenId,
1506         bytes memory _data
1507     ) private returns (bool) {
1508         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1509             bytes4 retval
1510         ) {
1511             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1512         } catch (bytes memory reason) {
1513             if (reason.length == 0) {
1514                 revert TransferToNonERC721ReceiverImplementer();
1515             } else {
1516                 assembly {
1517                     revert(add(32, reason), mload(reason))
1518                 }
1519             }
1520         }
1521     }
1522 
1523     // =============================================================
1524     //                        MINT OPERATIONS
1525     // =============================================================
1526 
1527     /**
1528      * @dev Mints `quantity` tokens and transfers them to `to`.
1529      *
1530      * Requirements:
1531      *
1532      * - `to` cannot be the zero address.
1533      * - `quantity` must be greater than 0.
1534      *
1535      * Emits a {Transfer} event for each mint.
1536      */
1537     function _mint(address to, uint256 quantity) internal virtual {
1538         uint256 startTokenId = _currentIndex;
1539         if (quantity == 0) revert MintZeroQuantity();
1540 
1541         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1542 
1543         // Overflows are incredibly unrealistic.
1544         // `balance` and `numberMinted` have a maximum limit of 2**64.
1545         // `tokenId` has a maximum limit of 2**256.
1546         unchecked {
1547             // Updates:
1548             // - `balance += quantity`.
1549             // - `numberMinted += quantity`.
1550             //
1551             // We can directly add to the `balance` and `numberMinted`.
1552             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1553 
1554             // Updates:
1555             // - `address` to the owner.
1556             // - `startTimestamp` to the timestamp of minting.
1557             // - `burned` to `false`.
1558             // - `nextInitialized` to `quantity == 1`.
1559             _packedOwnerships[startTokenId] = _packOwnershipData(
1560                 to,
1561                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1562             );
1563 
1564             uint256 toMasked;
1565             uint256 end = startTokenId + quantity;
1566 
1567             // Use assembly to loop and emit the `Transfer` event for gas savings.
1568             assembly {
1569                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1570                 toMasked := and(to, _BITMASK_ADDRESS)
1571                 // Emit the `Transfer` event.
1572                 log4(
1573                     0, // Start of data (0, since no data).
1574                     0, // End of data (0, since no data).
1575                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1576                     0, // `address(0)`.
1577                     toMasked, // `to`.
1578                     startTokenId // `tokenId`.
1579                 )
1580 
1581                 for {
1582                     let tokenId := add(startTokenId, 1)
1583                 } iszero(eq(tokenId, end)) {
1584                     tokenId := add(tokenId, 1)
1585                 } {
1586                     // Emit the `Transfer` event. Similar to above.
1587                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1588                 }
1589             }
1590             if (toMasked == 0) revert MintToZeroAddress();
1591 
1592             _currentIndex = end;
1593         }
1594         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1595     }
1596 
1597     /**
1598      * @dev Mints `quantity` tokens and transfers them to `to`.
1599      *
1600      * This function is intended for efficient minting only during contract creation.
1601      *
1602      * It emits only one {ConsecutiveTransfer} as defined in
1603      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1604      * instead of a sequence of {Transfer} event(s).
1605      *
1606      * Calling this function outside of contract creation WILL make your contract
1607      * non-compliant with the ERC721 standard.
1608      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1609      * {ConsecutiveTransfer} event is only permissible during contract creation.
1610      *
1611      * Requirements:
1612      *
1613      * - `to` cannot be the zero address.
1614      * - `quantity` must be greater than 0.
1615      *
1616      * Emits a {ConsecutiveTransfer} event.
1617      */
1618     function _mintERC2309(address to, uint256 quantity) internal virtual {
1619         uint256 startTokenId = _currentIndex;
1620         if (to == address(0)) revert MintToZeroAddress();
1621         if (quantity == 0) revert MintZeroQuantity();
1622         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1623 
1624         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1625 
1626         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1627         unchecked {
1628             // Updates:
1629             // - `balance += quantity`.
1630             // - `numberMinted += quantity`.
1631             //
1632             // We can directly add to the `balance` and `numberMinted`.
1633             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1634 
1635             // Updates:
1636             // - `address` to the owner.
1637             // - `startTimestamp` to the timestamp of minting.
1638             // - `burned` to `false`.
1639             // - `nextInitialized` to `quantity == 1`.
1640             _packedOwnerships[startTokenId] = _packOwnershipData(
1641                 to,
1642                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1643             );
1644 
1645             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1646 
1647             _currentIndex = startTokenId + quantity;
1648         }
1649         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1650     }
1651 
1652     /**
1653      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1654      *
1655      * Requirements:
1656      *
1657      * - If `to` refers to a smart contract, it must implement
1658      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1659      * - `quantity` must be greater than 0.
1660      *
1661      * See {_mint}.
1662      *
1663      * Emits a {Transfer} event for each mint.
1664      */
1665     function _safeMint(
1666         address to,
1667         uint256 quantity,
1668         bytes memory _data
1669     ) internal virtual {
1670         _mint(to, quantity);
1671 
1672         unchecked {
1673             if (to.code.length != 0) {
1674                 uint256 end = _currentIndex;
1675                 uint256 index = end - quantity;
1676                 do {
1677                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1678                         revert TransferToNonERC721ReceiverImplementer();
1679                     }
1680                 } while (index < end);
1681                 // Reentrancy protection.
1682                 if (_currentIndex != end) revert();
1683             }
1684         }
1685     }
1686 
1687     /**
1688      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1689      */
1690     function _safeMint(address to, uint256 quantity) internal virtual {
1691         _safeMint(to, quantity, '');
1692     }
1693 
1694     // =============================================================
1695     //                        BURN OPERATIONS
1696     // =============================================================
1697 
1698     /**
1699      * @dev Equivalent to `_burn(tokenId, false)`.
1700      */
1701     function _burn(uint256 tokenId) internal virtual {
1702         _burn(tokenId, false);
1703     }
1704 
1705     /**
1706      * @dev Destroys `tokenId`.
1707      * The approval is cleared when the token is burned.
1708      *
1709      * Requirements:
1710      *
1711      * - `tokenId` must exist.
1712      *
1713      * Emits a {Transfer} event.
1714      */
1715     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1716         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1717 
1718         address from = address(uint160(prevOwnershipPacked));
1719 
1720         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1721 
1722         if (approvalCheck) {
1723             // The nested ifs save around 20+ gas over a compound boolean condition.
1724             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1725                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1726         }
1727 
1728         _beforeTokenTransfers(from, address(0), tokenId, 1);
1729 
1730         // Clear approvals from the previous owner.
1731         assembly {
1732             if approvedAddress {
1733                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1734                 sstore(approvedAddressSlot, 0)
1735             }
1736         }
1737 
1738         // Underflow of the sender's balance is impossible because we check for
1739         // ownership above and the recipient's balance can't realistically overflow.
1740         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1741         unchecked {
1742             // Updates:
1743             // - `balance -= 1`.
1744             // - `numberBurned += 1`.
1745             //
1746             // We can directly decrement the balance, and increment the number burned.
1747             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1748             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1749 
1750             // Updates:
1751             // - `address` to the last owner.
1752             // - `startTimestamp` to the timestamp of burning.
1753             // - `burned` to `true`.
1754             // - `nextInitialized` to `true`.
1755             _packedOwnerships[tokenId] = _packOwnershipData(
1756                 from,
1757                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1758             );
1759 
1760             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1761             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1762                 uint256 nextTokenId = tokenId + 1;
1763                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1764                 if (_packedOwnerships[nextTokenId] == 0) {
1765                     // If the next slot is within bounds.
1766                     if (nextTokenId != _currentIndex) {
1767                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1768                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1769                     }
1770                 }
1771             }
1772         }
1773 
1774         emit Transfer(from, address(0), tokenId);
1775         _afterTokenTransfers(from, address(0), tokenId, 1);
1776 
1777         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1778         unchecked {
1779             _burnCounter++;
1780         }
1781     }
1782 
1783     // =============================================================
1784     //                     EXTRA DATA OPERATIONS
1785     // =============================================================
1786 
1787     /**
1788      * @dev Directly sets the extra data for the ownership data `index`.
1789      */
1790     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1791         uint256 packed = _packedOwnerships[index];
1792         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1793         uint256 extraDataCasted;
1794         // Cast `extraData` with assembly to avoid redundant masking.
1795         assembly {
1796             extraDataCasted := extraData
1797         }
1798         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1799         _packedOwnerships[index] = packed;
1800     }
1801 
1802     /**
1803      * @dev Called during each token transfer to set the 24bit `extraData` field.
1804      * Intended to be overridden by the cosumer contract.
1805      *
1806      * `previousExtraData` - the value of `extraData` before transfer.
1807      *
1808      * Calling conditions:
1809      *
1810      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1811      * transferred to `to`.
1812      * - When `from` is zero, `tokenId` will be minted for `to`.
1813      * - When `to` is zero, `tokenId` will be burned by `from`.
1814      * - `from` and `to` are never both zero.
1815      */
1816     function _extraData(
1817         address from,
1818         address to,
1819         uint24 previousExtraData
1820     ) internal view virtual returns (uint24) {}
1821 
1822     /**
1823      * @dev Returns the next extra data for the packed ownership data.
1824      * The returned result is shifted into position.
1825      */
1826     function _nextExtraData(
1827         address from,
1828         address to,
1829         uint256 prevOwnershipPacked
1830     ) private view returns (uint256) {
1831         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1832         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1833     }
1834 
1835     // =============================================================
1836     //                       OTHER OPERATIONS
1837     // =============================================================
1838 
1839     /**
1840      * @dev Returns the message sender (defaults to `msg.sender`).
1841      *
1842      * If you are writing GSN compatible contracts, you need to override this function.
1843      */
1844     function _msgSenderERC721A() internal view virtual returns (address) {
1845         return msg.sender;
1846     }
1847 
1848     /**
1849      * @dev Converts a uint256 to its ASCII string decimal representation.
1850      */
1851     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1852         assembly {
1853             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1854             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1855             // We will need 1 32-byte word to store the length,
1856             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1857             ptr := add(mload(0x40), 128)
1858             // Update the free memory pointer to allocate.
1859             mstore(0x40, ptr)
1860 
1861             // Cache the end of the memory to calculate the length later.
1862             let end := ptr
1863 
1864             // We write the string from the rightmost digit to the leftmost digit.
1865             // The following is essentially a do-while loop that also handles the zero case.
1866             // Costs a bit more than early returning for the zero case,
1867             // but cheaper in terms of deployment and overall runtime costs.
1868             for {
1869                 // Initialize and perform the first pass without check.
1870                 let temp := value
1871                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1872                 ptr := sub(ptr, 1)
1873                 // Write the character to the pointer.
1874                 // The ASCII index of the '0' character is 48.
1875                 mstore8(ptr, add(48, mod(temp, 10)))
1876                 temp := div(temp, 10)
1877             } temp {
1878                 // Keep dividing `temp` until zero.
1879                 temp := div(temp, 10)
1880             } {
1881                 // Body of the for loop.
1882                 ptr := sub(ptr, 1)
1883                 mstore8(ptr, add(48, mod(temp, 10)))
1884             }
1885 
1886             let length := sub(end, ptr)
1887             // Move the pointer 32 bytes leftwards to make room for the length.
1888             ptr := sub(ptr, 32)
1889             // Store the length.
1890             mstore(ptr, length)
1891         }
1892     }
1893 }
1894 
1895 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1896 
1897 
1898 // ERC721A Contracts v4.2.0
1899 // Creator: Chiru Labs
1900 
1901 pragma solidity ^0.8.4;
1902 
1903 
1904 /**
1905  * @dev Interface of ERC721AQueryable.
1906  */
1907 interface IERC721AQueryable is IERC721A {
1908     /**
1909      * Invalid query range (`start` >= `stop`).
1910      */
1911     error InvalidQueryRange();
1912 
1913     /**
1914      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1915      *
1916      * If the `tokenId` is out of bounds:
1917      *
1918      * - `addr = address(0)`
1919      * - `startTimestamp = 0`
1920      * - `burned = false`
1921      * - `extraData = 0`
1922      *
1923      * If the `tokenId` is burned:
1924      *
1925      * - `addr = <Address of owner before token was burned>`
1926      * - `startTimestamp = <Timestamp when token was burned>`
1927      * - `burned = true`
1928      * - `extraData = <Extra data when token was burned>`
1929      *
1930      * Otherwise:
1931      *
1932      * - `addr = <Address of owner>`
1933      * - `startTimestamp = <Timestamp of start of ownership>`
1934      * - `burned = false`
1935      * - `extraData = <Extra data at start of ownership>`
1936      */
1937     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1938 
1939     /**
1940      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1941      * See {ERC721AQueryable-explicitOwnershipOf}
1942      */
1943     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1944 
1945     /**
1946      * @dev Returns an array of token IDs owned by `owner`,
1947      * in the range [`start`, `stop`)
1948      * (i.e. `start <= tokenId < stop`).
1949      *
1950      * This function allows for tokens to be queried if the collection
1951      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1952      *
1953      * Requirements:
1954      *
1955      * - `start < stop`
1956      */
1957     function tokensOfOwnerIn(
1958         address owner,
1959         uint256 start,
1960         uint256 stop
1961     ) external view returns (uint256[] memory);
1962 
1963     /**
1964      * @dev Returns an array of token IDs owned by `owner`.
1965      *
1966      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1967      * It is meant to be called off-chain.
1968      *
1969      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1970      * multiple smaller scans if the collection is large enough to cause
1971      * an out-of-gas error (10K collections should be fine).
1972      */
1973     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1974 }
1975 
1976 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1977 
1978 
1979 // ERC721A Contracts v4.2.0
1980 // Creator: Chiru Labs
1981 
1982 pragma solidity ^0.8.4;
1983 
1984 
1985 
1986 /**
1987  * @title ERC721AQueryable.
1988  *
1989  * @dev ERC721A subclass with convenience query functions.
1990  */
1991 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1992     /**
1993      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1994      *
1995      * If the `tokenId` is out of bounds:
1996      *
1997      * - `addr = address(0)`
1998      * - `startTimestamp = 0`
1999      * - `burned = false`
2000      * - `extraData = 0`
2001      *
2002      * If the `tokenId` is burned:
2003      *
2004      * - `addr = <Address of owner before token was burned>`
2005      * - `startTimestamp = <Timestamp when token was burned>`
2006      * - `burned = true`
2007      * - `extraData = <Extra data when token was burned>`
2008      *
2009      * Otherwise:
2010      *
2011      * - `addr = <Address of owner>`
2012      * - `startTimestamp = <Timestamp of start of ownership>`
2013      * - `burned = false`
2014      * - `extraData = <Extra data at start of ownership>`
2015      */
2016     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2017         TokenOwnership memory ownership;
2018         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2019             return ownership;
2020         }
2021         ownership = _ownershipAt(tokenId);
2022         if (ownership.burned) {
2023             return ownership;
2024         }
2025         return _ownershipOf(tokenId);
2026     }
2027 
2028     /**
2029      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2030      * See {ERC721AQueryable-explicitOwnershipOf}
2031      */
2032     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2033         external
2034         view
2035         virtual
2036         override
2037         returns (TokenOwnership[] memory)
2038     {
2039         unchecked {
2040             uint256 tokenIdsLength = tokenIds.length;
2041             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2042             for (uint256 i; i != tokenIdsLength; ++i) {
2043                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2044             }
2045             return ownerships;
2046         }
2047     }
2048 
2049     /**
2050      * @dev Returns an array of token IDs owned by `owner`,
2051      * in the range [`start`, `stop`)
2052      * (i.e. `start <= tokenId < stop`).
2053      *
2054      * This function allows for tokens to be queried if the collection
2055      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2056      *
2057      * Requirements:
2058      *
2059      * - `start < stop`
2060      */
2061     function tokensOfOwnerIn(
2062         address owner,
2063         uint256 start,
2064         uint256 stop
2065     ) external view virtual override returns (uint256[] memory) {
2066         unchecked {
2067             if (start >= stop) revert InvalidQueryRange();
2068             uint256 tokenIdsIdx;
2069             uint256 stopLimit = _nextTokenId();
2070             // Set `start = max(start, _startTokenId())`.
2071             if (start < _startTokenId()) {
2072                 start = _startTokenId();
2073             }
2074             // Set `stop = min(stop, stopLimit)`.
2075             if (stop > stopLimit) {
2076                 stop = stopLimit;
2077             }
2078             uint256 tokenIdsMaxLength = balanceOf(owner);
2079             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2080             // to cater for cases where `balanceOf(owner)` is too big.
2081             if (start < stop) {
2082                 uint256 rangeLength = stop - start;
2083                 if (rangeLength < tokenIdsMaxLength) {
2084                     tokenIdsMaxLength = rangeLength;
2085                 }
2086             } else {
2087                 tokenIdsMaxLength = 0;
2088             }
2089             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2090             if (tokenIdsMaxLength == 0) {
2091                 return tokenIds;
2092             }
2093             // We need to call `explicitOwnershipOf(start)`,
2094             // because the slot at `start` may not be initialized.
2095             TokenOwnership memory ownership = explicitOwnershipOf(start);
2096             address currOwnershipAddr;
2097             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2098             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2099             if (!ownership.burned) {
2100                 currOwnershipAddr = ownership.addr;
2101             }
2102             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2103                 ownership = _ownershipAt(i);
2104                 if (ownership.burned) {
2105                     continue;
2106                 }
2107                 if (ownership.addr != address(0)) {
2108                     currOwnershipAddr = ownership.addr;
2109                 }
2110                 if (currOwnershipAddr == owner) {
2111                     tokenIds[tokenIdsIdx++] = i;
2112                 }
2113             }
2114             // Downsize the array to fit.
2115             assembly {
2116                 mstore(tokenIds, tokenIdsIdx)
2117             }
2118             return tokenIds;
2119         }
2120     }
2121 
2122     /**
2123      * @dev Returns an array of token IDs owned by `owner`.
2124      *
2125      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2126      * It is meant to be called off-chain.
2127      *
2128      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2129      * multiple smaller scans if the collection is large enough to cause
2130      * an out-of-gas error (10K collections should be fine).
2131      */
2132     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2133         unchecked {
2134             uint256 tokenIdsIdx;
2135             address currOwnershipAddr;
2136             uint256 tokenIdsLength = balanceOf(owner);
2137             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2138             TokenOwnership memory ownership;
2139             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2140                 ownership = _ownershipAt(i);
2141                 if (ownership.burned) {
2142                     continue;
2143                 }
2144                 if (ownership.addr != address(0)) {
2145                     currOwnershipAddr = ownership.addr;
2146                 }
2147                 if (currOwnershipAddr == owner) {
2148                     tokenIds[tokenIdsIdx++] = i;
2149                 }
2150             }
2151             return tokenIds;
2152         }
2153     }
2154 }
2155 
2156 // File: contracts/ERC721DrunkRobots.sol
2157 
2158 
2159 
2160 pragma solidity >=0.8.9 <0.9.0;
2161 
2162 
2163 
2164 
2165 
2166 
2167 
2168 contract ERC721DrunkRobots is
2169     ERC721AQueryable,
2170     Ownable,
2171     IERC2981,
2172     ReentrancyGuard
2173 {
2174     using Strings for uint256;
2175 
2176     uint256 public mintPrice = 0.02 ether; // mint price per token
2177     uint16 public mintLimit = 5; // initially, only 20 tokens per address are allowd to mint.
2178     uint16 public constant maxSupply = 10000;
2179     uint16 private reserve = 400; // tokens reserve for the owner
2180     uint16 private publicSupply = maxSupply - reserve; // tokens avaiable for public to mint
2181     uint16 private royalties = 500; // royalties for secondary sale
2182 
2183     bool public isPublicMintingEnable;
2184     bool public isWhitelistMintingEnable;
2185 
2186     string public baseURI;
2187     bytes32 private merkleRoot;
2188 
2189     modifier mintRequirements(uint16 volume) {
2190         require(volume > 0, "You Must Mint at least one token");
2191         require(
2192             totalSupply() <= publicSupply &&
2193                 balanceOf(_msgSender()) + volume <= mintLimit,
2194             "no more tokens than mint limit"
2195         );
2196         require(msg.value >= mintPrice * volume, "low price!");
2197         _;
2198     }
2199     event MintPriceUpdated(uint256 price);
2200     event Withdrawal(address indexed owner, uint256 price, uint256 time);
2201     event RoyaltiesUpdated(uint256 royalties);
2202 
2203     constructor(string memory _uri) ERC721A("Drunk Robots", "DR") {
2204         baseURI = _uri;
2205     }
2206 
2207     /**
2208      * @dev private function to mint given amount of tokens
2209      * @param to is the address to which the tokens will be minted
2210      * @param amount is the quantity of tokens to be minted
2211      */
2212     function __mint(address to, uint16 amount) private {
2213         require(
2214             (totalSupply() + amount) <= maxSupply,
2215             "Request will exceed max supply!"
2216         );
2217 
2218         _safeMint(to, amount);
2219     }
2220 
2221     /**
2222      * @dev  it will allow the whitelisted wallets to mint tokens
2223      * @param volume is the quantity of tokens to be minted
2224      * @param _merkleProof is markel tree hash proof for the address
2225      */
2226     function whitelistMint(uint16 volume, bytes32[] calldata _merkleProof)
2227         external
2228         payable
2229         mintRequirements(volume)
2230     {
2231         require(isWhitelistMintingEnable, "minting is not enabled");
2232         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2233         require(
2234             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
2235             "Invalid proof"
2236         );
2237 
2238         __mint(_msgSender(), volume);
2239     }
2240 
2241     /**
2242      * @dev  It will mint from tokens allocated for public for owner
2243      * @param volume is the quantity of tokens to be minted
2244      */
2245     function mint(uint16 volume) external payable mintRequirements(volume) {
2246         require(isPublicMintingEnable, "minting is not enabled");
2247 
2248         __mint(_msgSender(), volume);
2249     }
2250 
2251     /**
2252      * @dev it will return tokenURI for given tokenIdToOwner
2253      * @param _tokenId is valid token id mint in this contract
2254      */
2255     function tokenURI(uint256 _tokenId)
2256         public
2257         view
2258         override(ERC721A, IERC721A)
2259         returns (string memory)
2260     {
2261         require(
2262             _exists(_tokenId),
2263             "ERC721Metadata: URI query for nonexistent token"
2264         );
2265         return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
2266     }
2267 
2268     /***************************/
2269     /***** ADMIN FUNCTIONS *****/
2270     /***************************/
2271 
2272     /**
2273      * @dev it is only callable by Contract owner. it will toggle public minting status
2274      */
2275     function togglePublicMintingStatus() external onlyOwner {
2276         isPublicMintingEnable = !isPublicMintingEnable;
2277     }
2278 
2279     /**
2280      * @dev it is only callable by Contract owner. it will toggle whitelist minting status
2281      */
2282     function toggleWhitelistMintingStatus() external onlyOwner {
2283         isWhitelistMintingEnable = !isWhitelistMintingEnable;
2284     }
2285 
2286     /**
2287      * @dev mint function only callable by the Contract owner. It will mint from reserve tokens for owner
2288      * @param to is the address to which the tokens will be minted
2289      * @param amount is the quantity of tokens to be minted
2290      */
2291     function mintFromReserve(address to, uint16 amount) external onlyOwner {
2292         unchecked {
2293             require(amount < (reserve + 1), "no more in reserve");
2294         }
2295         reserve -= amount;
2296         __mint(to, amount);
2297     }
2298 
2299     /**
2300      * @dev it will update mint price
2301      * @param _mintPrice is new value for mint
2302      */
2303     function setMintPrice(uint256 _mintPrice) external onlyOwner {
2304         mintPrice = _mintPrice;
2305         emit MintPriceUpdated(_mintPrice);
2306     }
2307 
2308     /**
2309      *
2310      * @dev it will update the mint limit aka amount of nfts a wallet can hold
2311      * @param _mintLimit is new value for the limit
2312      */
2313     function setMintLimit(uint16 _mintLimit) external onlyOwner {
2314         mintLimit = _mintLimit;
2315     }
2316 
2317     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2318         merkleRoot = _merkleRoot;
2319     }
2320 
2321     /**
2322      * @dev it will update baseURI for tokens
2323      * @param _uri is new URI for tokens
2324      */
2325     function setBaseURI(string memory _uri) external onlyOwner {
2326         baseURI = _uri;
2327     }
2328 
2329     /**
2330      * @dev it will update the royalties for token
2331      * @param _royalties is new percentage of royalties. it should be more than 0 and least 90
2332      */
2333     function setRoyalties(uint16 _royalties) external onlyOwner {
2334         require(
2335             _royalties > 0 && _royalties < 90,
2336             "royalties should be between 0 and 90"
2337         );
2338 
2339         royalties = (_royalties * 100); // convert percentage into bps
2340 
2341         emit RoyaltiesUpdated(_royalties);
2342     }
2343 
2344     /**
2345      * @dev it is only callable by Contract owner. it will withdraw balace of contract
2346      */
2347     function withdraw() external onlyOwner {
2348         uint256 balance = address(this).balance;
2349         bool success = payable(msg.sender).send(address(this).balance);
2350         require(success, "Payment did not go through!");
2351         emit Withdrawal(msg.sender, block.timestamp, balance);
2352     }
2353 
2354     /******************************/
2355     /******* CONFIGURATIONS *******/
2356     /******************************/
2357 
2358     function supportsInterface(bytes4 _interfaceId)
2359         public
2360         view
2361         virtual
2362         override(ERC721A, IERC721A, IERC165)
2363         returns (bool)
2364     {
2365         return
2366             _interfaceId == type(IERC2981).interfaceId ||
2367             super.supportsInterface(_interfaceId);
2368     }
2369 
2370     /**
2371      *  @dev it retruns the amount of royalty the owner will receive for given tokenId
2372      *  @param _tokenId is valid token number
2373      *  @param _salePrice is amount for which token will be traded
2374      */
2375     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
2376         external
2377         view
2378         override
2379         returns (address receiver, uint256 royaltyAmount)
2380     {
2381         require(
2382             _exists(_tokenId),
2383             "ERC2981RoyaltyStandard: Royalty info for nonexistent token"
2384         );
2385         return (address(this), (_salePrice * royalties) / 10000);
2386     }
2387 
2388     receive() external payable {}
2389 
2390     fallback() external payable {}
2391 }