1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Contract module that helps prevent reentrant calls to a function.
88  *
89  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
90  * available, which can be applied to functions to make sure there are no nested
91  * (reentrant) calls to them.
92  *
93  * Note that because there is a single `nonReentrant` guard, functions marked as
94  * `nonReentrant` may not call one another. This can be worked around by making
95  * those functions `private`, and then adding `external` `nonReentrant` entry
96  * points to them.
97  *
98  * TIP: If you would like to learn more about reentrancy and alternative ways
99  * to protect against it, check out our blog post
100  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
101  */
102 abstract contract ReentrancyGuard {
103     // Booleans are more expensive than uint256 or any type that takes up a full
104     // word because each write operation emits an extra SLOAD to first read the
105     // slot's contents, replace the bits taken up by the boolean, and then write
106     // back. This is the compiler's defense against contract upgrades and
107     // pointer aliasing, and it cannot be disabled.
108 
109     // The values being non-zero value makes deployment a bit more expensive,
110     // but in exchange the refund on every call to nonReentrant will be lower in
111     // amount. Since refunds are capped to a percentage of the total
112     // transaction's gas, it is best to keep them low in cases like this one, to
113     // increase the likelihood of the full refund coming into effect.
114     uint256 private constant _NOT_ENTERED = 1;
115     uint256 private constant _ENTERED = 2;
116 
117     uint256 private _status;
118 
119     constructor() {
120         _status = _NOT_ENTERED;
121     }
122 
123     /**
124      * @dev Prevents a contract from calling itself, directly or indirectly.
125      * Calling a `nonReentrant` function from another `nonReentrant`
126      * function is not supported. It is possible to prevent this from happening
127      * by making the `nonReentrant` function external, and making it call a
128      * `private` function that does the actual work.
129      */
130     modifier nonReentrant() {
131         // On the first call to nonReentrant, _notEntered will be true
132         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
133 
134         // Any calls to nonReentrant after this point will fail
135         _status = _ENTERED;
136 
137         _;
138 
139         // By storing the original value once again, a refund is triggered (see
140         // https://eips.ethereum.org/EIPS/eip-2200)
141         _status = _NOT_ENTERED;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
146 
147 
148 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev These functions deal with verification of Merkle Tree proofs.
154  *
155  * The proofs can be generated using the JavaScript library
156  * https://github.com/miguelmota/merkletreejs[merkletreejs].
157  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
158  *
159  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
160  *
161  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
162  * hashing, or use a hash function other than keccak256 for hashing leaves.
163  * This is because the concatenation of a sorted pair of internal nodes in
164  * the merkle tree could be reinterpreted as a leaf value.
165  */
166 library MerkleProof {
167     /**
168      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
169      * defined by `root`. For this, a `proof` must be provided, containing
170      * sibling hashes on the branch from the leaf to the root of the tree. Each
171      * pair of leaves and each pair of pre-images are assumed to be sorted.
172      */
173     function verify(
174         bytes32[] memory proof,
175         bytes32 root,
176         bytes32 leaf
177     ) internal pure returns (bool) {
178         return processProof(proof, leaf) == root;
179     }
180 
181     /**
182      * @dev Calldata version of {verify}
183      *
184      * _Available since v4.7._
185      */
186     function verifyCalldata(
187         bytes32[] calldata proof,
188         bytes32 root,
189         bytes32 leaf
190     ) internal pure returns (bool) {
191         return processProofCalldata(proof, leaf) == root;
192     }
193 
194     /**
195      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
196      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
197      * hash matches the root of the tree. When processing the proof, the pairs
198      * of leafs & pre-images are assumed to be sorted.
199      *
200      * _Available since v4.4._
201      */
202     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
203         bytes32 computedHash = leaf;
204         for (uint256 i = 0; i < proof.length; i++) {
205             computedHash = _hashPair(computedHash, proof[i]);
206         }
207         return computedHash;
208     }
209 
210     /**
211      * @dev Calldata version of {processProof}
212      *
213      * _Available since v4.7._
214      */
215     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
216         bytes32 computedHash = leaf;
217         for (uint256 i = 0; i < proof.length; i++) {
218             computedHash = _hashPair(computedHash, proof[i]);
219         }
220         return computedHash;
221     }
222 
223     /**
224      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
225      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
226      *
227      * _Available since v4.7._
228      */
229     function multiProofVerify(
230         bytes32[] memory proof,
231         bool[] memory proofFlags,
232         bytes32 root,
233         bytes32[] memory leaves
234     ) internal pure returns (bool) {
235         return processMultiProof(proof, proofFlags, leaves) == root;
236     }
237 
238     /**
239      * @dev Calldata version of {multiProofVerify}
240      *
241      * _Available since v4.7._
242      */
243     function multiProofVerifyCalldata(
244         bytes32[] calldata proof,
245         bool[] calldata proofFlags,
246         bytes32 root,
247         bytes32[] memory leaves
248     ) internal pure returns (bool) {
249         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
250     }
251 
252     /**
253      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
254      * consuming from one or the other at each step according to the instructions given by
255      * `proofFlags`.
256      *
257      * _Available since v4.7._
258      */
259     function processMultiProof(
260         bytes32[] memory proof,
261         bool[] memory proofFlags,
262         bytes32[] memory leaves
263     ) internal pure returns (bytes32 merkleRoot) {
264         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
265         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
266         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
267         // the merkle tree.
268         uint256 leavesLen = leaves.length;
269         uint256 totalHashes = proofFlags.length;
270 
271         // Check proof validity.
272         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
273 
274         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
275         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
276         bytes32[] memory hashes = new bytes32[](totalHashes);
277         uint256 leafPos = 0;
278         uint256 hashPos = 0;
279         uint256 proofPos = 0;
280         // At each step, we compute the next hash using two values:
281         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
282         //   get the next hash.
283         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
284         //   `proof` array.
285         for (uint256 i = 0; i < totalHashes; i++) {
286             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
287             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
288             hashes[i] = _hashPair(a, b);
289         }
290 
291         if (totalHashes > 0) {
292             return hashes[totalHashes - 1];
293         } else if (leavesLen > 0) {
294             return leaves[0];
295         } else {
296             return proof[0];
297         }
298     }
299 
300     /**
301      * @dev Calldata version of {processMultiProof}
302      *
303      * _Available since v4.7._
304      */
305     function processMultiProofCalldata(
306         bytes32[] calldata proof,
307         bool[] calldata proofFlags,
308         bytes32[] memory leaves
309     ) internal pure returns (bytes32 merkleRoot) {
310         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
311         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
312         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
313         // the merkle tree.
314         uint256 leavesLen = leaves.length;
315         uint256 totalHashes = proofFlags.length;
316 
317         // Check proof validity.
318         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
319 
320         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
321         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
322         bytes32[] memory hashes = new bytes32[](totalHashes);
323         uint256 leafPos = 0;
324         uint256 hashPos = 0;
325         uint256 proofPos = 0;
326         // At each step, we compute the next hash using two values:
327         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
328         //   get the next hash.
329         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
330         //   `proof` array.
331         for (uint256 i = 0; i < totalHashes; i++) {
332             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
333             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
334             hashes[i] = _hashPair(a, b);
335         }
336 
337         if (totalHashes > 0) {
338             return hashes[totalHashes - 1];
339         } else if (leavesLen > 0) {
340             return leaves[0];
341         } else {
342             return proof[0];
343         }
344     }
345 
346     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
347         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
348     }
349 
350     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
351         /// @solidity memory-safe-assembly
352         assembly {
353             mstore(0x00, a)
354             mstore(0x20, b)
355             value := keccak256(0x00, 0x40)
356         }
357     }
358 }
359 
360 // File: @openzeppelin/contracts/utils/Context.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Provides information about the current execution context, including the
369  * sender of the transaction and its data. While these are generally available
370  * via msg.sender and msg.data, they should not be accessed in such a direct
371  * manner, since when dealing with meta-transactions the account sending and
372  * paying for execution may not be the actual sender (as far as an application
373  * is concerned).
374  *
375  * This contract is only required for intermediate, library-like contracts.
376  */
377 abstract contract Context {
378     function _msgSender() internal view virtual returns (address) {
379         return msg.sender;
380     }
381 
382     function _msgData() internal view virtual returns (bytes calldata) {
383         return msg.data;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/access/Ownable.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 abstract contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor() {
416         _transferOwnership(_msgSender());
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         _checkOwner();
424         _;
425     }
426 
427     /**
428      * @dev Returns the address of the current owner.
429      */
430     function owner() public view virtual returns (address) {
431         return _owner;
432     }
433 
434     /**
435      * @dev Throws if the sender is not the owner.
436      */
437     function _checkOwner() internal view virtual {
438         require(owner() == _msgSender(), "Ownable: caller is not the owner");
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         _transferOwnership(address(0));
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         _transferOwnership(newOwner);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Internal function without access restriction.
464      */
465     function _transferOwnership(address newOwner) internal virtual {
466         address oldOwner = _owner;
467         _owner = newOwner;
468         emit OwnershipTransferred(oldOwner, newOwner);
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Interface of the ERC165 standard, as defined in the
481  * https://eips.ethereum.org/EIPS/eip-165[EIP].
482  *
483  * Implementers can declare support of contract interfaces, which can then be
484  * queried by others ({ERC165Checker}).
485  *
486  * For an implementation, see {ERC165}.
487  */
488 interface IERC165 {
489     /**
490      * @dev Returns true if this contract implements the interface defined by
491      * `interfaceId`. See the corresponding
492      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
493      * to learn more about how these ids are created.
494      *
495      * This function call must use less than 30 000 gas.
496      */
497     function supportsInterface(bytes4 interfaceId) external view returns (bool);
498 }
499 
500 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
501 
502 
503 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Interface for the NFT Royalty Standard.
510  *
511  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
512  * support for royalty payments across all NFT marketplaces and ecosystem participants.
513  *
514  * _Available since v4.5._
515  */
516 interface IERC2981 is IERC165 {
517     /**
518      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
519      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
520      */
521     function royaltyInfo(uint256 tokenId, uint256 salePrice)
522         external
523         view
524         returns (address receiver, uint256 royaltyAmount);
525 }
526 
527 // File: erc721a/contracts/IERC721A.sol
528 
529 
530 // ERC721A Contracts v4.2.0
531 // Creator: Chiru Labs
532 
533 pragma solidity ^0.8.4;
534 
535 /**
536  * @dev Interface of ERC721A.
537  */
538 interface IERC721A {
539     /**
540      * The caller must own the token or be an approved operator.
541      */
542     error ApprovalCallerNotOwnerNorApproved();
543 
544     /**
545      * The token does not exist.
546      */
547     error ApprovalQueryForNonexistentToken();
548 
549     /**
550      * The caller cannot approve to their own address.
551      */
552     error ApproveToCaller();
553 
554     /**
555      * Cannot query the balance for the zero address.
556      */
557     error BalanceQueryForZeroAddress();
558 
559     /**
560      * Cannot mint to the zero address.
561      */
562     error MintToZeroAddress();
563 
564     /**
565      * The quantity of tokens minted must be more than zero.
566      */
567     error MintZeroQuantity();
568 
569     /**
570      * The token does not exist.
571      */
572     error OwnerQueryForNonexistentToken();
573 
574     /**
575      * The caller must own the token or be an approved operator.
576      */
577     error TransferCallerNotOwnerNorApproved();
578 
579     /**
580      * The token must be owned by `from`.
581      */
582     error TransferFromIncorrectOwner();
583 
584     /**
585      * Cannot safely transfer to a contract that does not implement the
586      * ERC721Receiver interface.
587      */
588     error TransferToNonERC721ReceiverImplementer();
589 
590     /**
591      * Cannot transfer to the zero address.
592      */
593     error TransferToZeroAddress();
594 
595     /**
596      * The token does not exist.
597      */
598     error URIQueryForNonexistentToken();
599 
600     /**
601      * The `quantity` minted with ERC2309 exceeds the safety limit.
602      */
603     error MintERC2309QuantityExceedsLimit();
604 
605     /**
606      * The `extraData` cannot be set on an unintialized ownership slot.
607      */
608     error OwnershipNotInitializedForExtraData();
609 
610     // =============================================================
611     //                            STRUCTS
612     // =============================================================
613 
614     struct TokenOwnership {
615         // The address of the owner.
616         address addr;
617         // Stores the start time of ownership with minimal overhead for tokenomics.
618         uint64 startTimestamp;
619         // Whether the token has been burned.
620         bool burned;
621         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
622         uint24 extraData;
623     }
624 
625     // =============================================================
626     //                         TOKEN COUNTERS
627     // =============================================================
628 
629     /**
630      * @dev Returns the total number of tokens in existence.
631      * Burned tokens will reduce the count.
632      * To get the total number of tokens minted, please see {_totalMinted}.
633      */
634     function totalSupply() external view returns (uint256);
635 
636     // =============================================================
637     //                            IERC165
638     // =============================================================
639 
640     /**
641      * @dev Returns true if this contract implements the interface defined by
642      * `interfaceId`. See the corresponding
643      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
644      * to learn more about how these ids are created.
645      *
646      * This function call must use less than 30000 gas.
647      */
648     function supportsInterface(bytes4 interfaceId) external view returns (bool);
649 
650     // =============================================================
651     //                            IERC721
652     // =============================================================
653 
654     /**
655      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
656      */
657     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
658 
659     /**
660      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
661      */
662     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
663 
664     /**
665      * @dev Emitted when `owner` enables or disables
666      * (`approved`) `operator` to manage all of its assets.
667      */
668     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
669 
670     /**
671      * @dev Returns the number of tokens in `owner`'s account.
672      */
673     function balanceOf(address owner) external view returns (uint256 balance);
674 
675     /**
676      * @dev Returns the owner of the `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function ownerOf(uint256 tokenId) external view returns (address owner);
683 
684     /**
685      * @dev Safely transfers `tokenId` token from `from` to `to`,
686      * checking first that contract recipients are aware of the ERC721 protocol
687      * to prevent tokens from being forever locked.
688      *
689      * Requirements:
690      *
691      * - `from` cannot be the zero address.
692      * - `to` cannot be the zero address.
693      * - `tokenId` token must exist and be owned by `from`.
694      * - If the caller is not `from`, it must be have been allowed to move
695      * this token by either {approve} or {setApprovalForAll}.
696      * - If `to` refers to a smart contract, it must implement
697      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
698      *
699      * Emits a {Transfer} event.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes calldata data
706     ) external;
707 
708     /**
709      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) external;
716 
717     /**
718      * @dev Transfers `tokenId` from `from` to `to`.
719      *
720      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
721      * whenever possible.
722      *
723      * Requirements:
724      *
725      * - `from` cannot be the zero address.
726      * - `to` cannot be the zero address.
727      * - `tokenId` token must be owned by `from`.
728      * - If the caller is not `from`, it must be approved to move this token
729      * by either {approve} or {setApprovalForAll}.
730      *
731      * Emits a {Transfer} event.
732      */
733     function transferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) external;
738 
739     /**
740      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
741      * The approval is cleared when the token is transferred.
742      *
743      * Only a single account can be approved at a time, so approving the
744      * zero address clears previous approvals.
745      *
746      * Requirements:
747      *
748      * - The caller must own the token or be an approved operator.
749      * - `tokenId` must exist.
750      *
751      * Emits an {Approval} event.
752      */
753     function approve(address to, uint256 tokenId) external;
754 
755     /**
756      * @dev Approve or remove `operator` as an operator for the caller.
757      * Operators can call {transferFrom} or {safeTransferFrom}
758      * for any token owned by the caller.
759      *
760      * Requirements:
761      *
762      * - The `operator` cannot be the caller.
763      *
764      * Emits an {ApprovalForAll} event.
765      */
766     function setApprovalForAll(address operator, bool _approved) external;
767 
768     /**
769      * @dev Returns the account approved for `tokenId` token.
770      *
771      * Requirements:
772      *
773      * - `tokenId` must exist.
774      */
775     function getApproved(uint256 tokenId) external view returns (address operator);
776 
777     /**
778      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
779      *
780      * See {setApprovalForAll}.
781      */
782     function isApprovedForAll(address owner, address operator) external view returns (bool);
783 
784     // =============================================================
785     //                        IERC721Metadata
786     // =============================================================
787 
788     /**
789      * @dev Returns the token collection name.
790      */
791     function name() external view returns (string memory);
792 
793     /**
794      * @dev Returns the token collection symbol.
795      */
796     function symbol() external view returns (string memory);
797 
798     /**
799      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
800      */
801     function tokenURI(uint256 tokenId) external view returns (string memory);
802 
803     // =============================================================
804     //                           IERC2309
805     // =============================================================
806 
807     /**
808      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
809      * (inclusive) is transferred from `from` to `to`, as defined in the
810      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
811      *
812      * See {_mintERC2309} for more details.
813      */
814     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
815 }
816 
817 // File: erc721a/contracts/ERC721A.sol
818 
819 
820 // ERC721A Contracts v4.2.0
821 // Creator: Chiru Labs
822 
823 pragma solidity ^0.8.4;
824 
825 
826 /**
827  * @dev Interface of ERC721 token receiver.
828  */
829 interface ERC721A__IERC721Receiver {
830     function onERC721Received(
831         address operator,
832         address from,
833         uint256 tokenId,
834         bytes calldata data
835     ) external returns (bytes4);
836 }
837 
838 /**
839  * @title ERC721A
840  *
841  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
842  * Non-Fungible Token Standard, including the Metadata extension.
843  * Optimized for lower gas during batch mints.
844  *
845  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
846  * starting from `_startTokenId()`.
847  *
848  * Assumptions:
849  *
850  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
851  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
852  */
853 contract ERC721A is IERC721A {
854     // Reference type for token approval.
855     struct TokenApprovalRef {
856         address value;
857     }
858 
859     // =============================================================
860     //                           CONSTANTS
861     // =============================================================
862 
863     // Mask of an entry in packed address data.
864     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
865 
866     // The bit position of `numberMinted` in packed address data.
867     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
868 
869     // The bit position of `numberBurned` in packed address data.
870     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
871 
872     // The bit position of `aux` in packed address data.
873     uint256 private constant _BITPOS_AUX = 192;
874 
875     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
876     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
877 
878     // The bit position of `startTimestamp` in packed ownership.
879     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
880 
881     // The bit mask of the `burned` bit in packed ownership.
882     uint256 private constant _BITMASK_BURNED = 1 << 224;
883 
884     // The bit position of the `nextInitialized` bit in packed ownership.
885     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
886 
887     // The bit mask of the `nextInitialized` bit in packed ownership.
888     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
889 
890     // The bit position of `extraData` in packed ownership.
891     uint256 private constant _BITPOS_EXTRA_DATA = 232;
892 
893     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
894     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
895 
896     // The mask of the lower 160 bits for addresses.
897     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
898 
899     // The maximum `quantity` that can be minted with {_mintERC2309}.
900     // This limit is to prevent overflows on the address data entries.
901     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
902     // is required to cause an overflow, which is unrealistic.
903     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
904 
905     // The `Transfer` event signature is given by:
906     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
907     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
908         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
909 
910     // =============================================================
911     //                            STORAGE
912     // =============================================================
913 
914     // The next token ID to be minted.
915     uint256 private _currentIndex;
916 
917     // The number of tokens burned.
918     uint256 private _burnCounter;
919 
920     // Token name
921     string private _name;
922 
923     // Token symbol
924     string private _symbol;
925 
926     // Mapping from token ID to ownership details
927     // An empty struct value does not necessarily mean the token is unowned.
928     // See {_packedOwnershipOf} implementation for details.
929     //
930     // Bits Layout:
931     // - [0..159]   `addr`
932     // - [160..223] `startTimestamp`
933     // - [224]      `burned`
934     // - [225]      `nextInitialized`
935     // - [232..255] `extraData`
936     mapping(uint256 => uint256) private _packedOwnerships;
937 
938     // Mapping owner address to address data.
939     //
940     // Bits Layout:
941     // - [0..63]    `balance`
942     // - [64..127]  `numberMinted`
943     // - [128..191] `numberBurned`
944     // - [192..255] `aux`
945     mapping(address => uint256) private _packedAddressData;
946 
947     // Mapping from token ID to approved address.
948     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
949 
950     // Mapping from owner to operator approvals
951     mapping(address => mapping(address => bool)) private _operatorApprovals;
952 
953     // =============================================================
954     //                          CONSTRUCTOR
955     // =============================================================
956 
957     constructor(string memory name_, string memory symbol_) {
958         _name = name_;
959         _symbol = symbol_;
960         _currentIndex = _startTokenId();
961     }
962 
963     // =============================================================
964     //                   TOKEN COUNTING OPERATIONS
965     // =============================================================
966 
967     /**
968      * @dev Returns the starting token ID.
969      * To change the starting token ID, please override this function.
970      */
971     function _startTokenId() internal view virtual returns (uint256) {
972         return 0;
973     }
974 
975     /**
976      * @dev Returns the next token ID to be minted.
977      */
978     function _nextTokenId() internal view virtual returns (uint256) {
979         return _currentIndex;
980     }
981 
982     /**
983      * @dev Returns the total number of tokens in existence.
984      * Burned tokens will reduce the count.
985      * To get the total number of tokens minted, please see {_totalMinted}.
986      */
987     function totalSupply() public view virtual override returns (uint256) {
988         // Counter underflow is impossible as _burnCounter cannot be incremented
989         // more than `_currentIndex - _startTokenId()` times.
990         unchecked {
991             return _currentIndex - _burnCounter - _startTokenId();
992         }
993     }
994 
995     /**
996      * @dev Returns the total amount of tokens minted in the contract.
997      */
998     function _totalMinted() internal view virtual returns (uint256) {
999         // Counter underflow is impossible as `_currentIndex` does not decrement,
1000         // and it is initialized to `_startTokenId()`.
1001         unchecked {
1002             return _currentIndex - _startTokenId();
1003         }
1004     }
1005 
1006     /**
1007      * @dev Returns the total number of tokens burned.
1008      */
1009     function _totalBurned() internal view virtual returns (uint256) {
1010         return _burnCounter;
1011     }
1012 
1013     // =============================================================
1014     //                    ADDRESS DATA OPERATIONS
1015     // =============================================================
1016 
1017     /**
1018      * @dev Returns the number of tokens in `owner`'s account.
1019      */
1020     function balanceOf(address owner) public view virtual override returns (uint256) {
1021         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1022         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1023     }
1024 
1025     /**
1026      * Returns the number of tokens minted by `owner`.
1027      */
1028     function _numberMinted(address owner) internal view returns (uint256) {
1029         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1030     }
1031 
1032     /**
1033      * Returns the number of tokens burned by or on behalf of `owner`.
1034      */
1035     function _numberBurned(address owner) internal view returns (uint256) {
1036         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1037     }
1038 
1039     /**
1040      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1041      */
1042     function _getAux(address owner) internal view returns (uint64) {
1043         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1044     }
1045 
1046     /**
1047      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1048      * If there are multiple variables, please pack them into a uint64.
1049      */
1050     function _setAux(address owner, uint64 aux) internal virtual {
1051         uint256 packed = _packedAddressData[owner];
1052         uint256 auxCasted;
1053         // Cast `aux` with assembly to avoid redundant masking.
1054         assembly {
1055             auxCasted := aux
1056         }
1057         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1058         _packedAddressData[owner] = packed;
1059     }
1060 
1061     // =============================================================
1062     //                            IERC165
1063     // =============================================================
1064 
1065     /**
1066      * @dev Returns true if this contract implements the interface defined by
1067      * `interfaceId`. See the corresponding
1068      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1069      * to learn more about how these ids are created.
1070      *
1071      * This function call must use less than 30000 gas.
1072      */
1073     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1074         // The interface IDs are constants representing the first 4 bytes
1075         // of the XOR of all function selectors in the interface.
1076         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1077         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1078         return
1079             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1080             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1081             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1082     }
1083 
1084     // =============================================================
1085     //                        IERC721Metadata
1086     // =============================================================
1087 
1088     /**
1089      * @dev Returns the token collection name.
1090      */
1091     function name() public view virtual override returns (string memory) {
1092         return _name;
1093     }
1094 
1095     /**
1096      * @dev Returns the token collection symbol.
1097      */
1098     function symbol() public view virtual override returns (string memory) {
1099         return _symbol;
1100     }
1101 
1102     /**
1103      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1104      */
1105     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1106         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1107 
1108         string memory baseURI = _baseURI();
1109         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1110     }
1111 
1112     /**
1113      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1114      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1115      * by default, it can be overridden in child contracts.
1116      */
1117     function _baseURI() internal view virtual returns (string memory) {
1118         return '';
1119     }
1120 
1121     // =============================================================
1122     //                     OWNERSHIPS OPERATIONS
1123     // =============================================================
1124 
1125     /**
1126      * @dev Returns the owner of the `tokenId` token.
1127      *
1128      * Requirements:
1129      *
1130      * - `tokenId` must exist.
1131      */
1132     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1133         return address(uint160(_packedOwnershipOf(tokenId)));
1134     }
1135 
1136     /**
1137      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1138      * It gradually moves to O(1) as tokens get transferred around over time.
1139      */
1140     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1141         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1142     }
1143 
1144     /**
1145      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1146      */
1147     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1148         return _unpackedOwnership(_packedOwnerships[index]);
1149     }
1150 
1151     /**
1152      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1153      */
1154     function _initializeOwnershipAt(uint256 index) internal virtual {
1155         if (_packedOwnerships[index] == 0) {
1156             _packedOwnerships[index] = _packedOwnershipOf(index);
1157         }
1158     }
1159 
1160     /**
1161      * Returns the packed ownership data of `tokenId`.
1162      */
1163     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1164         uint256 curr = tokenId;
1165 
1166         unchecked {
1167             if (_startTokenId() <= curr)
1168                 if (curr < _currentIndex) {
1169                     uint256 packed = _packedOwnerships[curr];
1170                     // If not burned.
1171                     if (packed & _BITMASK_BURNED == 0) {
1172                         // Invariant:
1173                         // There will always be an initialized ownership slot
1174                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1175                         // before an unintialized ownership slot
1176                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1177                         // Hence, `curr` will not underflow.
1178                         //
1179                         // We can directly compare the packed value.
1180                         // If the address is zero, packed will be zero.
1181                         while (packed == 0) {
1182                             packed = _packedOwnerships[--curr];
1183                         }
1184                         return packed;
1185                     }
1186                 }
1187         }
1188         revert OwnerQueryForNonexistentToken();
1189     }
1190 
1191     /**
1192      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1193      */
1194     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1195         ownership.addr = address(uint160(packed));
1196         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1197         ownership.burned = packed & _BITMASK_BURNED != 0;
1198         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1199     }
1200 
1201     /**
1202      * @dev Packs ownership data into a single uint256.
1203      */
1204     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1205         assembly {
1206             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1207             owner := and(owner, _BITMASK_ADDRESS)
1208             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1209             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1210         }
1211     }
1212 
1213     /**
1214      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1215      */
1216     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1217         // For branchless setting of the `nextInitialized` flag.
1218         assembly {
1219             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1220             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1221         }
1222     }
1223 
1224     // =============================================================
1225     //                      APPROVAL OPERATIONS
1226     // =============================================================
1227 
1228     /**
1229      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1230      * The approval is cleared when the token is transferred.
1231      *
1232      * Only a single account can be approved at a time, so approving the
1233      * zero address clears previous approvals.
1234      *
1235      * Requirements:
1236      *
1237      * - The caller must own the token or be an approved operator.
1238      * - `tokenId` must exist.
1239      *
1240      * Emits an {Approval} event.
1241      */
1242     function approve(address to, uint256 tokenId) public virtual override {
1243         address owner = ownerOf(tokenId);
1244 
1245         if (_msgSenderERC721A() != owner)
1246             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1247                 revert ApprovalCallerNotOwnerNorApproved();
1248             }
1249 
1250         _tokenApprovals[tokenId].value = to;
1251         emit Approval(owner, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev Returns the account approved for `tokenId` token.
1256      *
1257      * Requirements:
1258      *
1259      * - `tokenId` must exist.
1260      */
1261     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1262         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1263 
1264         return _tokenApprovals[tokenId].value;
1265     }
1266 
1267     /**
1268      * @dev Approve or remove `operator` as an operator for the caller.
1269      * Operators can call {transferFrom} or {safeTransferFrom}
1270      * for any token owned by the caller.
1271      *
1272      * Requirements:
1273      *
1274      * - The `operator` cannot be the caller.
1275      *
1276      * Emits an {ApprovalForAll} event.
1277      */
1278     function setApprovalForAll(address operator, bool approved) public virtual override {
1279         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1280 
1281         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1282         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1283     }
1284 
1285     /**
1286      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1287      *
1288      * See {setApprovalForAll}.
1289      */
1290     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1291         return _operatorApprovals[owner][operator];
1292     }
1293 
1294     /**
1295      * @dev Returns whether `tokenId` exists.
1296      *
1297      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1298      *
1299      * Tokens start existing when they are minted. See {_mint}.
1300      */
1301     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1302         return
1303             _startTokenId() <= tokenId &&
1304             tokenId < _currentIndex && // If within bounds,
1305             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1306     }
1307 
1308     /**
1309      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1310      */
1311     function _isSenderApprovedOrOwner(
1312         address approvedAddress,
1313         address owner,
1314         address msgSender
1315     ) private pure returns (bool result) {
1316         assembly {
1317             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1318             owner := and(owner, _BITMASK_ADDRESS)
1319             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1320             msgSender := and(msgSender, _BITMASK_ADDRESS)
1321             // `msgSender == owner || msgSender == approvedAddress`.
1322             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1323         }
1324     }
1325 
1326     /**
1327      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1328      */
1329     function _getApprovedSlotAndAddress(uint256 tokenId)
1330         private
1331         view
1332         returns (uint256 approvedAddressSlot, address approvedAddress)
1333     {
1334         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1335         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1336         assembly {
1337             approvedAddressSlot := tokenApproval.slot
1338             approvedAddress := sload(approvedAddressSlot)
1339         }
1340     }
1341 
1342     // =============================================================
1343     //                      TRANSFER OPERATIONS
1344     // =============================================================
1345 
1346     /**
1347      * @dev Transfers `tokenId` from `from` to `to`.
1348      *
1349      * Requirements:
1350      *
1351      * - `from` cannot be the zero address.
1352      * - `to` cannot be the zero address.
1353      * - `tokenId` token must be owned by `from`.
1354      * - If the caller is not `from`, it must be approved to move this token
1355      * by either {approve} or {setApprovalForAll}.
1356      *
1357      * Emits a {Transfer} event.
1358      */
1359     function transferFrom(
1360         address from,
1361         address to,
1362         uint256 tokenId
1363     ) public virtual override {
1364         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1365 
1366         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1367 
1368         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1369 
1370         // The nested ifs save around 20+ gas over a compound boolean condition.
1371         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1372             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1373 
1374         if (to == address(0)) revert TransferToZeroAddress();
1375 
1376         _beforeTokenTransfers(from, to, tokenId, 1);
1377 
1378         // Clear approvals from the previous owner.
1379         assembly {
1380             if approvedAddress {
1381                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1382                 sstore(approvedAddressSlot, 0)
1383             }
1384         }
1385 
1386         // Underflow of the sender's balance is impossible because we check for
1387         // ownership above and the recipient's balance can't realistically overflow.
1388         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1389         unchecked {
1390             // We can directly increment and decrement the balances.
1391             --_packedAddressData[from]; // Updates: `balance -= 1`.
1392             ++_packedAddressData[to]; // Updates: `balance += 1`.
1393 
1394             // Updates:
1395             // - `address` to the next owner.
1396             // - `startTimestamp` to the timestamp of transfering.
1397             // - `burned` to `false`.
1398             // - `nextInitialized` to `true`.
1399             _packedOwnerships[tokenId] = _packOwnershipData(
1400                 to,
1401                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1402             );
1403 
1404             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1405             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1406                 uint256 nextTokenId = tokenId + 1;
1407                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1408                 if (_packedOwnerships[nextTokenId] == 0) {
1409                     // If the next slot is within bounds.
1410                     if (nextTokenId != _currentIndex) {
1411                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1412                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1413                     }
1414                 }
1415             }
1416         }
1417 
1418         emit Transfer(from, to, tokenId);
1419         _afterTokenTransfers(from, to, tokenId, 1);
1420     }
1421 
1422     /**
1423      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1424      */
1425     function safeTransferFrom(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) public virtual override {
1430         safeTransferFrom(from, to, tokenId, '');
1431     }
1432 
1433     /**
1434      * @dev Safely transfers `tokenId` token from `from` to `to`.
1435      *
1436      * Requirements:
1437      *
1438      * - `from` cannot be the zero address.
1439      * - `to` cannot be the zero address.
1440      * - `tokenId` token must exist and be owned by `from`.
1441      * - If the caller is not `from`, it must be approved to move this token
1442      * by either {approve} or {setApprovalForAll}.
1443      * - If `to` refers to a smart contract, it must implement
1444      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function safeTransferFrom(
1449         address from,
1450         address to,
1451         uint256 tokenId,
1452         bytes memory _data
1453     ) public virtual override {
1454         transferFrom(from, to, tokenId);
1455         if (to.code.length != 0)
1456             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1457                 revert TransferToNonERC721ReceiverImplementer();
1458             }
1459     }
1460 
1461     /**
1462      * @dev Hook that is called before a set of serially-ordered token IDs
1463      * are about to be transferred. This includes minting.
1464      * And also called before burning one token.
1465      *
1466      * `startTokenId` - the first token ID to be transferred.
1467      * `quantity` - the amount to be transferred.
1468      *
1469      * Calling conditions:
1470      *
1471      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1472      * transferred to `to`.
1473      * - When `from` is zero, `tokenId` will be minted for `to`.
1474      * - When `to` is zero, `tokenId` will be burned by `from`.
1475      * - `from` and `to` are never both zero.
1476      */
1477     function _beforeTokenTransfers(
1478         address from,
1479         address to,
1480         uint256 startTokenId,
1481         uint256 quantity
1482     ) internal virtual {}
1483 
1484     /**
1485      * @dev Hook that is called after a set of serially-ordered token IDs
1486      * have been transferred. This includes minting.
1487      * And also called after one token has been burned.
1488      *
1489      * `startTokenId` - the first token ID to be transferred.
1490      * `quantity` - the amount to be transferred.
1491      *
1492      * Calling conditions:
1493      *
1494      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1495      * transferred to `to`.
1496      * - When `from` is zero, `tokenId` has been minted for `to`.
1497      * - When `to` is zero, `tokenId` has been burned by `from`.
1498      * - `from` and `to` are never both zero.
1499      */
1500     function _afterTokenTransfers(
1501         address from,
1502         address to,
1503         uint256 startTokenId,
1504         uint256 quantity
1505     ) internal virtual {}
1506 
1507     /**
1508      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1509      *
1510      * `from` - Previous owner of the given token ID.
1511      * `to` - Target address that will receive the token.
1512      * `tokenId` - Token ID to be transferred.
1513      * `_data` - Optional data to send along with the call.
1514      *
1515      * Returns whether the call correctly returned the expected magic value.
1516      */
1517     function _checkContractOnERC721Received(
1518         address from,
1519         address to,
1520         uint256 tokenId,
1521         bytes memory _data
1522     ) private returns (bool) {
1523         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1524             bytes4 retval
1525         ) {
1526             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1527         } catch (bytes memory reason) {
1528             if (reason.length == 0) {
1529                 revert TransferToNonERC721ReceiverImplementer();
1530             } else {
1531                 assembly {
1532                     revert(add(32, reason), mload(reason))
1533                 }
1534             }
1535         }
1536     }
1537 
1538     // =============================================================
1539     //                        MINT OPERATIONS
1540     // =============================================================
1541 
1542     /**
1543      * @dev Mints `quantity` tokens and transfers them to `to`.
1544      *
1545      * Requirements:
1546      *
1547      * - `to` cannot be the zero address.
1548      * - `quantity` must be greater than 0.
1549      *
1550      * Emits a {Transfer} event for each mint.
1551      */
1552     function _mint(address to, uint256 quantity) internal virtual {
1553         uint256 startTokenId = _currentIndex;
1554         if (quantity == 0) revert MintZeroQuantity();
1555 
1556         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1557 
1558         // Overflows are incredibly unrealistic.
1559         // `balance` and `numberMinted` have a maximum limit of 2**64.
1560         // `tokenId` has a maximum limit of 2**256.
1561         unchecked {
1562             // Updates:
1563             // - `balance += quantity`.
1564             // - `numberMinted += quantity`.
1565             //
1566             // We can directly add to the `balance` and `numberMinted`.
1567             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1568 
1569             // Updates:
1570             // - `address` to the owner.
1571             // - `startTimestamp` to the timestamp of minting.
1572             // - `burned` to `false`.
1573             // - `nextInitialized` to `quantity == 1`.
1574             _packedOwnerships[startTokenId] = _packOwnershipData(
1575                 to,
1576                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1577             );
1578 
1579             uint256 toMasked;
1580             uint256 end = startTokenId + quantity;
1581 
1582             // Use assembly to loop and emit the `Transfer` event for gas savings.
1583             assembly {
1584                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1585                 toMasked := and(to, _BITMASK_ADDRESS)
1586                 // Emit the `Transfer` event.
1587                 log4(
1588                     0, // Start of data (0, since no data).
1589                     0, // End of data (0, since no data).
1590                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1591                     0, // `address(0)`.
1592                     toMasked, // `to`.
1593                     startTokenId // `tokenId`.
1594                 )
1595 
1596                 for {
1597                     let tokenId := add(startTokenId, 1)
1598                 } iszero(eq(tokenId, end)) {
1599                     tokenId := add(tokenId, 1)
1600                 } {
1601                     // Emit the `Transfer` event. Similar to above.
1602                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1603                 }
1604             }
1605             if (toMasked == 0) revert MintToZeroAddress();
1606 
1607             _currentIndex = end;
1608         }
1609         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1610     }
1611 
1612     /**
1613      * @dev Mints `quantity` tokens and transfers them to `to`.
1614      *
1615      * This function is intended for efficient minting only during contract creation.
1616      *
1617      * It emits only one {ConsecutiveTransfer} as defined in
1618      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1619      * instead of a sequence of {Transfer} event(s).
1620      *
1621      * Calling this function outside of contract creation WILL make your contract
1622      * non-compliant with the ERC721 standard.
1623      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1624      * {ConsecutiveTransfer} event is only permissible during contract creation.
1625      *
1626      * Requirements:
1627      *
1628      * - `to` cannot be the zero address.
1629      * - `quantity` must be greater than 0.
1630      *
1631      * Emits a {ConsecutiveTransfer} event.
1632      */
1633     function _mintERC2309(address to, uint256 quantity) internal virtual {
1634         uint256 startTokenId = _currentIndex;
1635         if (to == address(0)) revert MintToZeroAddress();
1636         if (quantity == 0) revert MintZeroQuantity();
1637         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1638 
1639         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1640 
1641         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1642         unchecked {
1643             // Updates:
1644             // - `balance += quantity`.
1645             // - `numberMinted += quantity`.
1646             //
1647             // We can directly add to the `balance` and `numberMinted`.
1648             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1649 
1650             // Updates:
1651             // - `address` to the owner.
1652             // - `startTimestamp` to the timestamp of minting.
1653             // - `burned` to `false`.
1654             // - `nextInitialized` to `quantity == 1`.
1655             _packedOwnerships[startTokenId] = _packOwnershipData(
1656                 to,
1657                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1658             );
1659 
1660             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1661 
1662             _currentIndex = startTokenId + quantity;
1663         }
1664         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1665     }
1666 
1667     /**
1668      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1669      *
1670      * Requirements:
1671      *
1672      * - If `to` refers to a smart contract, it must implement
1673      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1674      * - `quantity` must be greater than 0.
1675      *
1676      * See {_mint}.
1677      *
1678      * Emits a {Transfer} event for each mint.
1679      */
1680     function _safeMint(
1681         address to,
1682         uint256 quantity,
1683         bytes memory _data
1684     ) internal virtual {
1685         _mint(to, quantity);
1686 
1687         unchecked {
1688             if (to.code.length != 0) {
1689                 uint256 end = _currentIndex;
1690                 uint256 index = end - quantity;
1691                 do {
1692                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1693                         revert TransferToNonERC721ReceiverImplementer();
1694                     }
1695                 } while (index < end);
1696                 // Reentrancy protection.
1697                 if (_currentIndex != end) revert();
1698             }
1699         }
1700     }
1701 
1702     /**
1703      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1704      */
1705     function _safeMint(address to, uint256 quantity) internal virtual {
1706         _safeMint(to, quantity, '');
1707     }
1708 
1709     // =============================================================
1710     //                        BURN OPERATIONS
1711     // =============================================================
1712 
1713     /**
1714      * @dev Equivalent to `_burn(tokenId, false)`.
1715      */
1716     function _burn(uint256 tokenId) internal virtual {
1717         _burn(tokenId, false);
1718     }
1719 
1720     /**
1721      * @dev Destroys `tokenId`.
1722      * The approval is cleared when the token is burned.
1723      *
1724      * Requirements:
1725      *
1726      * - `tokenId` must exist.
1727      *
1728      * Emits a {Transfer} event.
1729      */
1730     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1731         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1732 
1733         address from = address(uint160(prevOwnershipPacked));
1734 
1735         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1736 
1737         if (approvalCheck) {
1738             // The nested ifs save around 20+ gas over a compound boolean condition.
1739             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1740                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1741         }
1742 
1743         _beforeTokenTransfers(from, address(0), tokenId, 1);
1744 
1745         // Clear approvals from the previous owner.
1746         assembly {
1747             if approvedAddress {
1748                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1749                 sstore(approvedAddressSlot, 0)
1750             }
1751         }
1752 
1753         // Underflow of the sender's balance is impossible because we check for
1754         // ownership above and the recipient's balance can't realistically overflow.
1755         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1756         unchecked {
1757             // Updates:
1758             // - `balance -= 1`.
1759             // - `numberBurned += 1`.
1760             //
1761             // We can directly decrement the balance, and increment the number burned.
1762             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1763             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1764 
1765             // Updates:
1766             // - `address` to the last owner.
1767             // - `startTimestamp` to the timestamp of burning.
1768             // - `burned` to `true`.
1769             // - `nextInitialized` to `true`.
1770             _packedOwnerships[tokenId] = _packOwnershipData(
1771                 from,
1772                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1773             );
1774 
1775             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1776             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1777                 uint256 nextTokenId = tokenId + 1;
1778                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1779                 if (_packedOwnerships[nextTokenId] == 0) {
1780                     // If the next slot is within bounds.
1781                     if (nextTokenId != _currentIndex) {
1782                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1783                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1784                     }
1785                 }
1786             }
1787         }
1788 
1789         emit Transfer(from, address(0), tokenId);
1790         _afterTokenTransfers(from, address(0), tokenId, 1);
1791 
1792         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1793         unchecked {
1794             _burnCounter++;
1795         }
1796     }
1797 
1798     // =============================================================
1799     //                     EXTRA DATA OPERATIONS
1800     // =============================================================
1801 
1802     /**
1803      * @dev Directly sets the extra data for the ownership data `index`.
1804      */
1805     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1806         uint256 packed = _packedOwnerships[index];
1807         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1808         uint256 extraDataCasted;
1809         // Cast `extraData` with assembly to avoid redundant masking.
1810         assembly {
1811             extraDataCasted := extraData
1812         }
1813         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1814         _packedOwnerships[index] = packed;
1815     }
1816 
1817     /**
1818      * @dev Called during each token transfer to set the 24bit `extraData` field.
1819      * Intended to be overridden by the cosumer contract.
1820      *
1821      * `previousExtraData` - the value of `extraData` before transfer.
1822      *
1823      * Calling conditions:
1824      *
1825      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1826      * transferred to `to`.
1827      * - When `from` is zero, `tokenId` will be minted for `to`.
1828      * - When `to` is zero, `tokenId` will be burned by `from`.
1829      * - `from` and `to` are never both zero.
1830      */
1831     function _extraData(
1832         address from,
1833         address to,
1834         uint24 previousExtraData
1835     ) internal view virtual returns (uint24) {}
1836 
1837     /**
1838      * @dev Returns the next extra data for the packed ownership data.
1839      * The returned result is shifted into position.
1840      */
1841     function _nextExtraData(
1842         address from,
1843         address to,
1844         uint256 prevOwnershipPacked
1845     ) private view returns (uint256) {
1846         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1847         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1848     }
1849 
1850     // =============================================================
1851     //                       OTHER OPERATIONS
1852     // =============================================================
1853 
1854     /**
1855      * @dev Returns the message sender (defaults to `msg.sender`).
1856      *
1857      * If you are writing GSN compatible contracts, you need to override this function.
1858      */
1859     function _msgSenderERC721A() internal view virtual returns (address) {
1860         return msg.sender;
1861     }
1862 
1863     /**
1864      * @dev Converts a uint256 to its ASCII string decimal representation.
1865      */
1866     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1867         assembly {
1868             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1869             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1870             // We will need 1 32-byte word to store the length,
1871             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1872             ptr := add(mload(0x40), 128)
1873             // Update the free memory pointer to allocate.
1874             mstore(0x40, ptr)
1875 
1876             // Cache the end of the memory to calculate the length later.
1877             let end := ptr
1878 
1879             // We write the string from the rightmost digit to the leftmost digit.
1880             // The following is essentially a do-while loop that also handles the zero case.
1881             // Costs a bit more than early returning for the zero case,
1882             // but cheaper in terms of deployment and overall runtime costs.
1883             for {
1884                 // Initialize and perform the first pass without check.
1885                 let temp := value
1886                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1887                 ptr := sub(ptr, 1)
1888                 // Write the character to the pointer.
1889                 // The ASCII index of the '0' character is 48.
1890                 mstore8(ptr, add(48, mod(temp, 10)))
1891                 temp := div(temp, 10)
1892             } temp {
1893                 // Keep dividing `temp` until zero.
1894                 temp := div(temp, 10)
1895             } {
1896                 // Body of the for loop.
1897                 ptr := sub(ptr, 1)
1898                 mstore8(ptr, add(48, mod(temp, 10)))
1899             }
1900 
1901             let length := sub(end, ptr)
1902             // Move the pointer 32 bytes leftwards to make room for the length.
1903             ptr := sub(ptr, 32)
1904             // Store the length.
1905             mstore(ptr, length)
1906         }
1907     }
1908 }
1909 
1910 // File: contracts/UWAG_CONTRACT.sol
1911 
1912 
1913 pragma solidity ^0.8.9;
1914 
1915 
1916 
1917 
1918 
1919 
1920 
1921 contract UWA_GENESIS is 
1922      ERC721A, 
1923      IERC2981,
1924      Ownable, 
1925      ReentrancyGuard 
1926 {
1927   using Strings for uint256;
1928   string public hiddenMetadataUri = "ipfs://QmYi3kqfJCtZ1pcu1wcmHuJgxSn9RVWuzoxytBYjkNu4pJ";
1929   uint256 public maxSupply = 777;
1930   uint256 public mintAmount = 2;
1931   bytes32 public merkleRoot; 
1932   address public royaltyAddress = 0xdE551e3D1A6c09Bd94d8bdF753055d394126AB86;
1933   uint256 public royalty = 100; // Must be a whole number 7.5% is 75
1934   string public uriPrefix = '';
1935   string public uriSuffix = '.json';
1936   bool public paused = false;
1937   bool public revealed = false;
1938   mapping(address => bool) public addressClaimed; // mark if claimed
1939   constructor() 
1940   ERC721A("UWA GENESIS", "UWAG") {
1941   }
1942 
1943 /// @dev === MODIFIER ===
1944   modifier mintCompliance() {
1945     require(!paused, 'The sale is paused!');
1946     require(totalSupply() + mintAmount <= maxSupply, 'Sold out!');
1947     require(!addressClaimed[_msgSender()], 'Address already claimed!');
1948     _;
1949   }
1950 
1951 /// @dev === Minting Function - Input ====
1952   function mint(bytes32[] calldata _merkleProof) external payable
1953   mintCompliance() 
1954   nonReentrant
1955   {
1956     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1957     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid signature!');
1958     addressClaimed[_msgSender()] = true;
1959     _safeMint(_msgSender(), mintAmount);
1960   }
1961 
1962   function mintForAddress(uint256 _amount, address _receiver) public onlyOwner {
1963     require(totalSupply() + _amount < maxSupply, 'Sold out!');
1964     _safeMint(_receiver, _amount);
1965   }
1966 
1967 /// @dev === Override ERC721A ===
1968   function _startTokenId() internal view virtual override returns (uint256) {
1969       return 1;
1970     }
1971 
1972   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1973     require(_exists(_tokenId), 'Nonexistent token!');
1974     if (revealed == false) {
1975       return hiddenMetadataUri;
1976     }
1977 
1978     string memory currentBaseURI = _baseURI();
1979     return bytes(currentBaseURI).length > 0
1980         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1981         : '';
1982   }
1983 
1984 /// @dev === Owner Control/Configuration Functions ===
1985   function pause() public onlyOwner {
1986     paused = !paused;
1987   }
1988 
1989   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1990     merkleRoot = _merkleRoot;
1991   }
1992 
1993   function setMintAmount(uint256 _amount) public onlyOwner {
1994     mintAmount = _amount;
1995   }
1996   
1997   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1998     uriPrefix = _uriPrefix;
1999   }
2000 
2001   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2002     uriSuffix = _uriSuffix;
2003   }
2004   
2005   function setRevealed() public onlyOwner {
2006     revealed = true;
2007   }
2008 
2009   function setRoyaltyAddress(address _royaltyAddress) public onlyOwner {
2010     royaltyAddress = _royaltyAddress;
2011   }
2012 
2013   function setRoyaly(uint256 _royalty) external onlyOwner {
2014         royalty = _royalty;
2015   }
2016 
2017 /// @dev === INTERNAL READ-ONLY ===
2018   function _baseURI() internal view virtual override returns (string memory) {
2019     return uriPrefix;
2020   }
2021 
2022 /// @dev === Withdraw ====
2023   function withdraw() public onlyOwner nonReentrant {
2024     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2025     require(os);
2026   }
2027 
2028 //IERC2981 Royalty Standard
2029     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2030         external view override returns (address receiver, uint256 royaltyAmount)
2031     {
2032         require(_exists(tokenId), "Nonexistent token");
2033         return (royaltyAddress, (salePrice * royalty) / 1000);
2034     }                                                
2035 
2036 /// @dev === Support Functions ==
2037     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC165) returns (bool) {
2038         return
2039             interfaceId == type(IERC2981).interfaceId ||
2040             super.supportsInterface(interfaceId);
2041     }
2042 }