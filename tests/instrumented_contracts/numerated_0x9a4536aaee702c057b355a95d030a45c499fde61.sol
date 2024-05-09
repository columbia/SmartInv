1 // File: The Devious Dead NFT.sol
2 // Developer - TTibbs
3 // SPDX-License-Identifier: GPL-3.0
4 
5 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         // On the first call to nonReentrant, _notEntered will be true
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59 
60         // Any calls to nonReentrant after this point will fail
61         _status = _ENTERED;
62 
63         _;
64 
65         // By storing the original value once again, a refund is triggered (see
66         // https://eips.ethereum.org/EIPS/eip-2200)
67         _status = _NOT_ENTERED;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev These functions deal with verification of Merkle Tree proofs.
80  *
81  * The proofs can be generated using the JavaScript library
82  * https://github.com/miguelmota/merkletreejs[merkletreejs].
83  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
84  *
85  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
86  *
87  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
88  * hashing, or use a hash function other than keccak256 for hashing leaves.
89  * This is because the concatenation of a sorted pair of internal nodes in
90  * the merkle tree could be reinterpreted as a leaf value.
91  */
92 library MerkleProof {
93     /**
94      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
95      * defined by `root`. For this, a `proof` must be provided, containing
96      * sibling hashes on the branch from the leaf to the root of the tree. Each
97      * pair of leaves and each pair of pre-images are assumed to be sorted.
98      */
99     function verify(
100         bytes32[] memory proof,
101         bytes32 root,
102         bytes32 leaf
103     ) internal pure returns (bool) {
104         return processProof(proof, leaf) == root;
105     }
106 
107     /**
108      * @dev Calldata version of {verify}
109      *
110      * _Available since v4.7._
111      */
112     function verifyCalldata(
113         bytes32[] calldata proof,
114         bytes32 root,
115         bytes32 leaf
116     ) internal pure returns (bool) {
117         return processProofCalldata(proof, leaf) == root;
118     }
119 
120     /**
121      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
122      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
123      * hash matches the root of the tree. When processing the proof, the pairs
124      * of leafs & pre-images are assumed to be sorted.
125      *
126      * _Available since v4.4._
127      */
128     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
129         bytes32 computedHash = leaf;
130         for (uint256 i = 0; i < proof.length; i++) {
131             computedHash = _hashPair(computedHash, proof[i]);
132         }
133         return computedHash;
134     }
135 
136     /**
137      * @dev Calldata version of {processProof}
138      *
139      * _Available since v4.7._
140      */
141     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
142         bytes32 computedHash = leaf;
143         for (uint256 i = 0; i < proof.length; i++) {
144             computedHash = _hashPair(computedHash, proof[i]);
145         }
146         return computedHash;
147     }
148 
149     /**
150      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
151      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
152      *
153      * _Available since v4.7._
154      */
155     function multiProofVerify(
156         bytes32[] memory proof,
157         bool[] memory proofFlags,
158         bytes32 root,
159         bytes32[] memory leaves
160     ) internal pure returns (bool) {
161         return processMultiProof(proof, proofFlags, leaves) == root;
162     }
163 
164     /**
165      * @dev Calldata version of {multiProofVerify}
166      *
167      * _Available since v4.7._
168      */
169     function multiProofVerifyCalldata(
170         bytes32[] calldata proof,
171         bool[] calldata proofFlags,
172         bytes32 root,
173         bytes32[] memory leaves
174     ) internal pure returns (bool) {
175         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
176     }
177 
178     /**
179      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
180      * consuming from one or the other at each step according to the instructions given by
181      * `proofFlags`.
182      *
183      * _Available since v4.7._
184      */
185     function processMultiProof(
186         bytes32[] memory proof,
187         bool[] memory proofFlags,
188         bytes32[] memory leaves
189     ) internal pure returns (bytes32 merkleRoot) {
190         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
191         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
192         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
193         // the merkle tree.
194         uint256 leavesLen = leaves.length;
195         uint256 totalHashes = proofFlags.length;
196 
197         // Check proof validity.
198         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
199 
200         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
201         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
202         bytes32[] memory hashes = new bytes32[](totalHashes);
203         uint256 leafPos = 0;
204         uint256 hashPos = 0;
205         uint256 proofPos = 0;
206         // At each step, we compute the next hash using two values:
207         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
208         //   get the next hash.
209         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
210         //   `proof` array.
211         for (uint256 i = 0; i < totalHashes; i++) {
212             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
213             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
214             hashes[i] = _hashPair(a, b);
215         }
216 
217         if (totalHashes > 0) {
218             return hashes[totalHashes - 1];
219         } else if (leavesLen > 0) {
220             return leaves[0];
221         } else {
222             return proof[0];
223         }
224     }
225 
226     /**
227      * @dev Calldata version of {processMultiProof}
228      *
229      * _Available since v4.7._
230      */
231     function processMultiProofCalldata(
232         bytes32[] calldata proof,
233         bool[] calldata proofFlags,
234         bytes32[] memory leaves
235     ) internal pure returns (bytes32 merkleRoot) {
236         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
237         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
238         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
239         // the merkle tree.
240         uint256 leavesLen = leaves.length;
241         uint256 totalHashes = proofFlags.length;
242 
243         // Check proof validity.
244         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
245 
246         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
247         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
248         bytes32[] memory hashes = new bytes32[](totalHashes);
249         uint256 leafPos = 0;
250         uint256 hashPos = 0;
251         uint256 proofPos = 0;
252         // At each step, we compute the next hash using two values:
253         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
254         //   get the next hash.
255         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
256         //   `proof` array.
257         for (uint256 i = 0; i < totalHashes; i++) {
258             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
259             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
260             hashes[i] = _hashPair(a, b);
261         }
262 
263         if (totalHashes > 0) {
264             return hashes[totalHashes - 1];
265         } else if (leavesLen > 0) {
266             return leaves[0];
267         } else {
268             return proof[0];
269         }
270     }
271 
272     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
273         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
274     }
275 
276     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
277         /// @solidity memory-safe-assembly
278         assembly {
279             mstore(0x00, a)
280             mstore(0x20, b)
281             value := keccak256(0x00, 0x40)
282         }
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Context.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Provides information about the current execution context, including the
295  * sender of the transaction and its data. While these are generally available
296  * via msg.sender and msg.data, they should not be accessed in such a direct
297  * manner, since when dealing with meta-transactions the account sending and
298  * paying for execution may not be the actual sender (as far as an application
299  * is concerned).
300  *
301  * This contract is only required for intermediate, library-like contracts.
302  */
303 abstract contract Context {
304     function _msgSender() internal view virtual returns (address) {
305         return msg.sender;
306     }
307 
308     function _msgData() internal view virtual returns (bytes calldata) {
309         return msg.data;
310     }
311 }
312 
313 // File: @openzeppelin/contracts/access/Ownable.sol
314 
315 
316 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 
321 /**
322  * @dev Contract module which provides a basic access control mechanism, where
323  * there is an account (an owner) that can be granted exclusive access to
324  * specific functions.
325  *
326  * By default, the owner account will be the one that deploys the contract. This
327  * can later be changed with {transferOwnership}.
328  *
329  * This module is used through inheritance. It will make available the modifier
330  * `onlyOwner`, which can be applied to your functions to restrict their use to
331  * the owner.
332  */
333 abstract contract Ownable is Context {
334     address private _owner;
335 
336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
337 
338     /**
339      * @dev Initializes the contract setting the deployer as the initial owner.
340      */
341     constructor() {
342         _transferOwnership(_msgSender());
343     }
344 
345     /**
346      * @dev Throws if called by any account other than the owner.
347      */
348     modifier onlyOwner() {
349         _checkOwner();
350         _;
351     }
352 
353     /**
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view virtual returns (address) {
357         return _owner;
358     }
359 
360     /**
361      * @dev Throws if the sender is not the owner.
362      */
363     function _checkOwner() internal view virtual {
364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
365     }
366 
367     /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public virtual onlyOwner {
375         _transferOwnership(address(0));
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         _transferOwnership(newOwner);
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      * Internal function without access restriction.
390      */
391     function _transferOwnership(address newOwner) internal virtual {
392         address oldOwner = _owner;
393         _owner = newOwner;
394         emit OwnershipTransferred(oldOwner, newOwner);
395     }
396 }
397 
398 // File: @openzeppelin/contracts/utils/Strings.sol
399 
400 
401 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @dev String operations.
407  */
408 library Strings {
409     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
410     uint8 private constant _ADDRESS_LENGTH = 20;
411 
412     /**
413      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
414      */
415     function toString(uint256 value) internal pure returns (string memory) {
416         // Inspired by OraclizeAPI's implementation - MIT licence
417         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
418 
419         if (value == 0) {
420             return "0";
421         }
422         uint256 temp = value;
423         uint256 digits;
424         while (temp != 0) {
425             digits++;
426             temp /= 10;
427         }
428         bytes memory buffer = new bytes(digits);
429         while (value != 0) {
430             digits -= 1;
431             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
432             value /= 10;
433         }
434         return string(buffer);
435     }
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
439      */
440     function toHexString(uint256 value) internal pure returns (string memory) {
441         if (value == 0) {
442             return "0x00";
443         }
444         uint256 temp = value;
445         uint256 length = 0;
446         while (temp != 0) {
447             length++;
448             temp >>= 8;
449         }
450         return toHexString(value, length);
451     }
452 
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
455      */
456     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
457         bytes memory buffer = new bytes(2 * length + 2);
458         buffer[0] = "0";
459         buffer[1] = "x";
460         for (uint256 i = 2 * length + 1; i > 1; --i) {
461             buffer[i] = _HEX_SYMBOLS[value & 0xf];
462             value >>= 4;
463         }
464         require(value == 0, "Strings: hex length insufficient");
465         return string(buffer);
466     }
467 
468     /**
469      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
470      */
471     function toHexString(address addr) internal pure returns (string memory) {
472         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
473     }
474 }
475 
476 // File: erc721a/contracts/IERC721A.sol
477 
478 
479 // ERC721A Contracts v4.2.0
480 // Creator: Chiru Labs
481 
482 pragma solidity ^0.8.4;
483 
484 /**
485  * @dev Interface of ERC721A.
486  */
487 interface IERC721A {
488     /**
489      * The caller must own the token or be an approved operator.
490      */
491     error ApprovalCallerNotOwnerNorApproved();
492 
493     /**
494      * The token does not exist.
495      */
496     error ApprovalQueryForNonexistentToken();
497 
498     /**
499      * The caller cannot approve to their own address.
500      */
501     error ApproveToCaller();
502 
503     /**
504      * Cannot query the balance for the zero address.
505      */
506     error BalanceQueryForZeroAddress();
507 
508     /**
509      * Cannot mint to the zero address.
510      */
511     error MintToZeroAddress();
512 
513     /**
514      * The quantity of tokens minted must be more than zero.
515      */
516     error MintZeroQuantity();
517 
518     /**
519      * The token does not exist.
520      */
521     error OwnerQueryForNonexistentToken();
522 
523     /**
524      * The caller must own the token or be an approved operator.
525      */
526     error TransferCallerNotOwnerNorApproved();
527 
528     /**
529      * The token must be owned by `from`.
530      */
531     error TransferFromIncorrectOwner();
532 
533     /**
534      * Cannot safely transfer to a contract that does not implement the
535      * ERC721Receiver interface.
536      */
537     error TransferToNonERC721ReceiverImplementer();
538 
539     /**
540      * Cannot transfer to the zero address.
541      */
542     error TransferToZeroAddress();
543 
544     /**
545      * The token does not exist.
546      */
547     error URIQueryForNonexistentToken();
548 
549     /**
550      * The `quantity` minted with ERC2309 exceeds the safety limit.
551      */
552     error MintERC2309QuantityExceedsLimit();
553 
554     /**
555      * The `extraData` cannot be set on an unintialized ownership slot.
556      */
557     error OwnershipNotInitializedForExtraData();
558 
559     // =============================================================
560     //                            STRUCTS
561     // =============================================================
562 
563     struct TokenOwnership {
564         // The address of the owner.
565         address addr;
566         // Stores the start time of ownership with minimal overhead for tokenomics.
567         uint64 startTimestamp;
568         // Whether the token has been burned.
569         bool burned;
570         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
571         uint24 extraData;
572     }
573 
574     // =============================================================
575     //                         TOKEN COUNTERS
576     // =============================================================
577 
578     /**
579      * @dev Returns the total number of tokens in existence.
580      * Burned tokens will reduce the count.
581      * To get the total number of tokens minted, please see {_totalMinted}.
582      */
583     function totalSupply() external view returns (uint256);
584 
585     // =============================================================
586     //                            IERC165
587     // =============================================================
588 
589     /**
590      * @dev Returns true if this contract implements the interface defined by
591      * `interfaceId`. See the corresponding
592      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
593      * to learn more about how these ids are created.
594      *
595      * This function call must use less than 30000 gas.
596      */
597     function supportsInterface(bytes4 interfaceId) external view returns (bool);
598 
599     // =============================================================
600     //                            IERC721
601     // =============================================================
602 
603     /**
604      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
605      */
606     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
607 
608     /**
609      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
610      */
611     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
612 
613     /**
614      * @dev Emitted when `owner` enables or disables
615      * (`approved`) `operator` to manage all of its assets.
616      */
617     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
618 
619     /**
620      * @dev Returns the number of tokens in `owner`'s account.
621      */
622     function balanceOf(address owner) external view returns (uint256 balance);
623 
624     /**
625      * @dev Returns the owner of the `tokenId` token.
626      *
627      * Requirements:
628      *
629      * - `tokenId` must exist.
630      */
631     function ownerOf(uint256 tokenId) external view returns (address owner);
632 
633     /**
634      * @dev Safely transfers `tokenId` token from `from` to `to`,
635      * checking first that contract recipients are aware of the ERC721 protocol
636      * to prevent tokens from being forever locked.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If the caller is not `from`, it must be have been allowed to move
644      * this token by either {approve} or {setApprovalForAll}.
645      * - If `to` refers to a smart contract, it must implement
646      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
647      *
648      * Emits a {Transfer} event.
649      */
650     function safeTransferFrom(
651         address from,
652         address to,
653         uint256 tokenId,
654         bytes calldata data
655     ) external;
656 
657     /**
658      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
659      */
660     function safeTransferFrom(
661         address from,
662         address to,
663         uint256 tokenId
664     ) external;
665 
666     /**
667      * @dev Transfers `tokenId` from `from` to `to`.
668      *
669      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
670      * whenever possible.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must be owned by `from`.
677      * - If the caller is not `from`, it must be approved to move this token
678      * by either {approve} or {setApprovalForAll}.
679      *
680      * Emits a {Transfer} event.
681      */
682     function transferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) external;
687 
688     /**
689      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
690      * The approval is cleared when the token is transferred.
691      *
692      * Only a single account can be approved at a time, so approving the
693      * zero address clears previous approvals.
694      *
695      * Requirements:
696      *
697      * - The caller must own the token or be an approved operator.
698      * - `tokenId` must exist.
699      *
700      * Emits an {Approval} event.
701      */
702     function approve(address to, uint256 tokenId) external;
703 
704     /**
705      * @dev Approve or remove `operator` as an operator for the caller.
706      * Operators can call {transferFrom} or {safeTransferFrom}
707      * for any token owned by the caller.
708      *
709      * Requirements:
710      *
711      * - The `operator` cannot be the caller.
712      *
713      * Emits an {ApprovalForAll} event.
714      */
715     function setApprovalForAll(address operator, bool _approved) external;
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId) external view returns (address operator);
725 
726     /**
727      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
728      *
729      * See {setApprovalForAll}.
730      */
731     function isApprovedForAll(address owner, address operator) external view returns (bool);
732 
733     // =============================================================
734     //                        IERC721Metadata
735     // =============================================================
736 
737     /**
738      * @dev Returns the token collection name.
739      */
740     function name() external view returns (string memory);
741 
742     /**
743      * @dev Returns the token collection symbol.
744      */
745     function symbol() external view returns (string memory);
746 
747     /**
748      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
749      */
750     function tokenURI(uint256 tokenId) external view returns (string memory);
751 
752     // =============================================================
753     //                           IERC2309
754     // =============================================================
755 
756     /**
757      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
758      * (inclusive) is transferred from `from` to `to`, as defined in the
759      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
760      *
761      * See {_mintERC2309} for more details.
762      */
763     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
764 }
765 
766 // File: erc721a/contracts/ERC721A.sol
767 
768 
769 // ERC721A Contracts v4.2.0
770 // Creator: Chiru Labs
771 
772 pragma solidity ^0.8.4;
773 
774 
775 /**
776  * @dev Interface of ERC721 token receiver.
777  */
778 interface ERC721A__IERC721Receiver {
779     function onERC721Received(
780         address operator,
781         address from,
782         uint256 tokenId,
783         bytes calldata data
784     ) external returns (bytes4);
785 }
786 
787 /**
788  * @title ERC721A
789  *
790  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
791  * Non-Fungible Token Standard, including the Metadata extension.
792  * Optimized for lower gas during batch mints.
793  *
794  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
795  * starting from `_startTokenId()`.
796  *
797  * Assumptions:
798  *
799  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
800  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
801  */
802 contract ERC721A is IERC721A {
803     // Reference type for token approval.
804     struct TokenApprovalRef {
805         address value;
806     }
807 
808     // =============================================================
809     //                           CONSTANTS
810     // =============================================================
811 
812     // Mask of an entry in packed address data.
813     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
814 
815     // The bit position of `numberMinted` in packed address data.
816     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
817 
818     // The bit position of `numberBurned` in packed address data.
819     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
820 
821     // The bit position of `aux` in packed address data.
822     uint256 private constant _BITPOS_AUX = 192;
823 
824     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
825     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
826 
827     // The bit position of `startTimestamp` in packed ownership.
828     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
829 
830     // The bit mask of the `burned` bit in packed ownership.
831     uint256 private constant _BITMASK_BURNED = 1 << 224;
832 
833     // The bit position of the `nextInitialized` bit in packed ownership.
834     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
835 
836     // The bit mask of the `nextInitialized` bit in packed ownership.
837     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
838 
839     // The bit position of `extraData` in packed ownership.
840     uint256 private constant _BITPOS_EXTRA_DATA = 232;
841 
842     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
843     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
844 
845     // The mask of the lower 160 bits for addresses.
846     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
847 
848     // The maximum `quantity` that can be minted with {_mintERC2309}.
849     // This limit is to prevent overflows on the address data entries.
850     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
851     // is required to cause an overflow, which is unrealistic.
852     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
853 
854     // The `Transfer` event signature is given by:
855     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
856     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
857         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
858 
859     // =============================================================
860     //                            STORAGE
861     // =============================================================
862 
863     // The next token ID to be minted.
864     uint256 private _currentIndex;
865 
866     // The number of tokens burned.
867     uint256 private _burnCounter;
868 
869     // Token name
870     string private _name;
871 
872     // Token symbol
873     string private _symbol;
874 
875     // Mapping from token ID to ownership details
876     // An empty struct value does not necessarily mean the token is unowned.
877     // See {_packedOwnershipOf} implementation for details.
878     //
879     // Bits Layout:
880     // - [0..159]   `addr`
881     // - [160..223] `startTimestamp`
882     // - [224]      `burned`
883     // - [225]      `nextInitialized`
884     // - [232..255] `extraData`
885     mapping(uint256 => uint256) private _packedOwnerships;
886 
887     // Mapping owner address to address data.
888     //
889     // Bits Layout:
890     // - [0..63]    `balance`
891     // - [64..127]  `numberMinted`
892     // - [128..191] `numberBurned`
893     // - [192..255] `aux`
894     mapping(address => uint256) private _packedAddressData;
895 
896     // Mapping from token ID to approved address.
897     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
898 
899     // Mapping from owner to operator approvals
900     mapping(address => mapping(address => bool)) private _operatorApprovals;
901 
902     // =============================================================
903     //                          CONSTRUCTOR
904     // =============================================================
905 
906     constructor(string memory name_, string memory symbol_) {
907         _name = name_;
908         _symbol = symbol_;
909         _currentIndex = _startTokenId();
910     }
911 
912     // =============================================================
913     //                   TOKEN COUNTING OPERATIONS
914     // =============================================================
915 
916     /**
917      * @dev Returns the starting token ID.
918      * To change the starting token ID, please override this function.
919      */
920     function _startTokenId() internal view virtual returns (uint256) {
921         return 0;
922     }
923 
924     /**
925      * @dev Returns the next token ID to be minted.
926      */
927     function _nextTokenId() internal view virtual returns (uint256) {
928         return _currentIndex;
929     }
930 
931     /**
932      * @dev Returns the total number of tokens in existence.
933      * Burned tokens will reduce the count.
934      * To get the total number of tokens minted, please see {_totalMinted}.
935      */
936     function totalSupply() public view virtual override returns (uint256) {
937         // Counter underflow is impossible as _burnCounter cannot be incremented
938         // more than `_currentIndex - _startTokenId()` times.
939         unchecked {
940             return _currentIndex - _burnCounter - _startTokenId();
941         }
942     }
943 
944     /**
945      * @dev Returns the total amount of tokens minted in the contract.
946      */
947     function _totalMinted() internal view virtual returns (uint256) {
948         // Counter underflow is impossible as `_currentIndex` does not decrement,
949         // and it is initialized to `_startTokenId()`.
950         unchecked {
951             return _currentIndex - _startTokenId();
952         }
953     }
954 
955     /**
956      * @dev Returns the total number of tokens burned.
957      */
958     function _totalBurned() internal view virtual returns (uint256) {
959         return _burnCounter;
960     }
961 
962     // =============================================================
963     //                    ADDRESS DATA OPERATIONS
964     // =============================================================
965 
966     /**
967      * @dev Returns the number of tokens in `owner`'s account.
968      */
969     function balanceOf(address owner) public view virtual override returns (uint256) {
970         if (owner == address(0)) revert BalanceQueryForZeroAddress();
971         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
972     }
973 
974     /**
975      * Returns the number of tokens minted by `owner`.
976      */
977     function _numberMinted(address owner) internal view returns (uint256) {
978         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
979     }
980 
981     /**
982      * Returns the number of tokens burned by or on behalf of `owner`.
983      */
984     function _numberBurned(address owner) internal view returns (uint256) {
985         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
986     }
987 
988     /**
989      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
990      */
991     function _getAux(address owner) internal view returns (uint64) {
992         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
993     }
994 
995     /**
996      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
997      * If there are multiple variables, please pack them into a uint64.
998      */
999     function _setAux(address owner, uint64 aux) internal virtual {
1000         uint256 packed = _packedAddressData[owner];
1001         uint256 auxCasted;
1002         // Cast `aux` with assembly to avoid redundant masking.
1003         assembly {
1004             auxCasted := aux
1005         }
1006         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1007         _packedAddressData[owner] = packed;
1008     }
1009 
1010     // =============================================================
1011     //                            IERC165
1012     // =============================================================
1013 
1014     /**
1015      * @dev Returns true if this contract implements the interface defined by
1016      * `interfaceId`. See the corresponding
1017      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1018      * to learn more about how these ids are created.
1019      *
1020      * This function call must use less than 30000 gas.
1021      */
1022     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1023         // The interface IDs are constants representing the first 4 bytes
1024         // of the XOR of all function selectors in the interface.
1025         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1026         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1027         return
1028             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1029             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1030             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1031     }
1032 
1033     // =============================================================
1034     //                        IERC721Metadata
1035     // =============================================================
1036 
1037     /**
1038      * @dev Returns the token collection name.
1039      */
1040     function name() public view virtual override returns (string memory) {
1041         return _name;
1042     }
1043 
1044     /**
1045      * @dev Returns the token collection symbol.
1046      */
1047     function symbol() public view virtual override returns (string memory) {
1048         return _symbol;
1049     }
1050 
1051     /**
1052      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1053      */
1054     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1055         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1056 
1057         string memory baseURI = _baseURI();
1058         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1059     }
1060 
1061     /**
1062      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1063      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1064      * by default, it can be overridden in child contracts.
1065      */
1066     function _baseURI() internal view virtual returns (string memory) {
1067         return '';
1068     }
1069 
1070     // =============================================================
1071     //                     OWNERSHIPS OPERATIONS
1072     // =============================================================
1073 
1074     /**
1075      * @dev Returns the owner of the `tokenId` token.
1076      *
1077      * Requirements:
1078      *
1079      * - `tokenId` must exist.
1080      */
1081     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1082         return address(uint160(_packedOwnershipOf(tokenId)));
1083     }
1084 
1085     /**
1086      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1087      * It gradually moves to O(1) as tokens get transferred around over time.
1088      */
1089     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1090         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1091     }
1092 
1093     /**
1094      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1095      */
1096     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1097         return _unpackedOwnership(_packedOwnerships[index]);
1098     }
1099 
1100     /**
1101      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1102      */
1103     function _initializeOwnershipAt(uint256 index) internal virtual {
1104         if (_packedOwnerships[index] == 0) {
1105             _packedOwnerships[index] = _packedOwnershipOf(index);
1106         }
1107     }
1108 
1109     /**
1110      * Returns the packed ownership data of `tokenId`.
1111      */
1112     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1113         uint256 curr = tokenId;
1114 
1115         unchecked {
1116             if (_startTokenId() <= curr)
1117                 if (curr < _currentIndex) {
1118                     uint256 packed = _packedOwnerships[curr];
1119                     // If not burned.
1120                     if (packed & _BITMASK_BURNED == 0) {
1121                         // Invariant:
1122                         // There will always be an initialized ownership slot
1123                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1124                         // before an unintialized ownership slot
1125                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1126                         // Hence, `curr` will not underflow.
1127                         //
1128                         // We can directly compare the packed value.
1129                         // If the address is zero, packed will be zero.
1130                         while (packed == 0) {
1131                             packed = _packedOwnerships[--curr];
1132                         }
1133                         return packed;
1134                     }
1135                 }
1136         }
1137         revert OwnerQueryForNonexistentToken();
1138     }
1139 
1140     /**
1141      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1142      */
1143     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1144         ownership.addr = address(uint160(packed));
1145         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1146         ownership.burned = packed & _BITMASK_BURNED != 0;
1147         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1148     }
1149 
1150     /**
1151      * @dev Packs ownership data into a single uint256.
1152      */
1153     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1154         assembly {
1155             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1156             owner := and(owner, _BITMASK_ADDRESS)
1157             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1158             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1159         }
1160     }
1161 
1162     /**
1163      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1164      */
1165     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1166         // For branchless setting of the `nextInitialized` flag.
1167         assembly {
1168             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1169             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1170         }
1171     }
1172 
1173     // =============================================================
1174     //                      APPROVAL OPERATIONS
1175     // =============================================================
1176 
1177     /**
1178      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1179      * The approval is cleared when the token is transferred.
1180      *
1181      * Only a single account can be approved at a time, so approving the
1182      * zero address clears previous approvals.
1183      *
1184      * Requirements:
1185      *
1186      * - The caller must own the token or be an approved operator.
1187      * - `tokenId` must exist.
1188      *
1189      * Emits an {Approval} event.
1190      */
1191     function approve(address to, uint256 tokenId) public virtual override {
1192         address owner = ownerOf(tokenId);
1193 
1194         if (_msgSenderERC721A() != owner)
1195             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1196                 revert ApprovalCallerNotOwnerNorApproved();
1197             }
1198 
1199         _tokenApprovals[tokenId].value = to;
1200         emit Approval(owner, to, tokenId);
1201     }
1202 
1203     /**
1204      * @dev Returns the account approved for `tokenId` token.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      */
1210     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1211         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1212 
1213         return _tokenApprovals[tokenId].value;
1214     }
1215 
1216     /**
1217      * @dev Approve or remove `operator` as an operator for the caller.
1218      * Operators can call {transferFrom} or {safeTransferFrom}
1219      * for any token owned by the caller.
1220      *
1221      * Requirements:
1222      *
1223      * - The `operator` cannot be the caller.
1224      *
1225      * Emits an {ApprovalForAll} event.
1226      */
1227     function setApprovalForAll(address operator, bool approved) public virtual override {
1228         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1229 
1230         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1231         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1232     }
1233 
1234     /**
1235      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1236      *
1237      * See {setApprovalForAll}.
1238      */
1239     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1240         return _operatorApprovals[owner][operator];
1241     }
1242 
1243     /**
1244      * @dev Returns whether `tokenId` exists.
1245      *
1246      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1247      *
1248      * Tokens start existing when they are minted. See {_mint}.
1249      */
1250     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1251         return
1252             _startTokenId() <= tokenId &&
1253             tokenId < _currentIndex && // If within bounds,
1254             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1255     }
1256 
1257     /**
1258      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1259      */
1260     function _isSenderApprovedOrOwner(
1261         address approvedAddress,
1262         address owner,
1263         address msgSender
1264     ) private pure returns (bool result) {
1265         assembly {
1266             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1267             owner := and(owner, _BITMASK_ADDRESS)
1268             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1269             msgSender := and(msgSender, _BITMASK_ADDRESS)
1270             // `msgSender == owner || msgSender == approvedAddress`.
1271             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1272         }
1273     }
1274 
1275     /**
1276      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1277      */
1278     function _getApprovedSlotAndAddress(uint256 tokenId)
1279         private
1280         view
1281         returns (uint256 approvedAddressSlot, address approvedAddress)
1282     {
1283         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1284         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1285         assembly {
1286             approvedAddressSlot := tokenApproval.slot
1287             approvedAddress := sload(approvedAddressSlot)
1288         }
1289     }
1290 
1291     // =============================================================
1292     //                      TRANSFER OPERATIONS
1293     // =============================================================
1294 
1295     /**
1296      * @dev Transfers `tokenId` from `from` to `to`.
1297      *
1298      * Requirements:
1299      *
1300      * - `from` cannot be the zero address.
1301      * - `to` cannot be the zero address.
1302      * - `tokenId` token must be owned by `from`.
1303      * - If the caller is not `from`, it must be approved to move this token
1304      * by either {approve} or {setApprovalForAll}.
1305      *
1306      * Emits a {Transfer} event.
1307      */
1308     function transferFrom(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) public virtual override {
1313         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1314 
1315         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1316 
1317         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1318 
1319         // The nested ifs save around 20+ gas over a compound boolean condition.
1320         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1321             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1322 
1323         if (to == address(0)) revert TransferToZeroAddress();
1324 
1325         _beforeTokenTransfers(from, to, tokenId, 1);
1326 
1327         // Clear approvals from the previous owner.
1328         assembly {
1329             if approvedAddress {
1330                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1331                 sstore(approvedAddressSlot, 0)
1332             }
1333         }
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1338         unchecked {
1339             // We can directly increment and decrement the balances.
1340             --_packedAddressData[from]; // Updates: `balance -= 1`.
1341             ++_packedAddressData[to]; // Updates: `balance += 1`.
1342 
1343             // Updates:
1344             // - `address` to the next owner.
1345             // - `startTimestamp` to the timestamp of transfering.
1346             // - `burned` to `false`.
1347             // - `nextInitialized` to `true`.
1348             _packedOwnerships[tokenId] = _packOwnershipData(
1349                 to,
1350                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1351             );
1352 
1353             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1354             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1355                 uint256 nextTokenId = tokenId + 1;
1356                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1357                 if (_packedOwnerships[nextTokenId] == 0) {
1358                     // If the next slot is within bounds.
1359                     if (nextTokenId != _currentIndex) {
1360                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1361                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1362                     }
1363                 }
1364             }
1365         }
1366 
1367         emit Transfer(from, to, tokenId);
1368         _afterTokenTransfers(from, to, tokenId, 1);
1369     }
1370 
1371     /**
1372      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1373      */
1374     function safeTransferFrom(
1375         address from,
1376         address to,
1377         uint256 tokenId
1378     ) public virtual override {
1379         safeTransferFrom(from, to, tokenId, '');
1380     }
1381 
1382     /**
1383      * @dev Safely transfers `tokenId` token from `from` to `to`.
1384      *
1385      * Requirements:
1386      *
1387      * - `from` cannot be the zero address.
1388      * - `to` cannot be the zero address.
1389      * - `tokenId` token must exist and be owned by `from`.
1390      * - If the caller is not `from`, it must be approved to move this token
1391      * by either {approve} or {setApprovalForAll}.
1392      * - If `to` refers to a smart contract, it must implement
1393      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1394      *
1395      * Emits a {Transfer} event.
1396      */
1397     function safeTransferFrom(
1398         address from,
1399         address to,
1400         uint256 tokenId,
1401         bytes memory _data
1402     ) public virtual override {
1403         transferFrom(from, to, tokenId);
1404         if (to.code.length != 0)
1405             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1406                 revert TransferToNonERC721ReceiverImplementer();
1407             }
1408     }
1409 
1410     /**
1411      * @dev Hook that is called before a set of serially-ordered token IDs
1412      * are about to be transferred. This includes minting.
1413      * And also called before burning one token.
1414      *
1415      * `startTokenId` - the first token ID to be transferred.
1416      * `quantity` - the amount to be transferred.
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      * - When `to` is zero, `tokenId` will be burned by `from`.
1424      * - `from` and `to` are never both zero.
1425      */
1426     function _beforeTokenTransfers(
1427         address from,
1428         address to,
1429         uint256 startTokenId,
1430         uint256 quantity
1431     ) internal virtual {}
1432 
1433     /**
1434      * @dev Hook that is called after a set of serially-ordered token IDs
1435      * have been transferred. This includes minting.
1436      * And also called after one token has been burned.
1437      *
1438      * `startTokenId` - the first token ID to be transferred.
1439      * `quantity` - the amount to be transferred.
1440      *
1441      * Calling conditions:
1442      *
1443      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1444      * transferred to `to`.
1445      * - When `from` is zero, `tokenId` has been minted for `to`.
1446      * - When `to` is zero, `tokenId` has been burned by `from`.
1447      * - `from` and `to` are never both zero.
1448      */
1449     function _afterTokenTransfers(
1450         address from,
1451         address to,
1452         uint256 startTokenId,
1453         uint256 quantity
1454     ) internal virtual {}
1455 
1456     /**
1457      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1458      *
1459      * `from` - Previous owner of the given token ID.
1460      * `to` - Target address that will receive the token.
1461      * `tokenId` - Token ID to be transferred.
1462      * `_data` - Optional data to send along with the call.
1463      *
1464      * Returns whether the call correctly returned the expected magic value.
1465      */
1466     function _checkContractOnERC721Received(
1467         address from,
1468         address to,
1469         uint256 tokenId,
1470         bytes memory _data
1471     ) private returns (bool) {
1472         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1473             bytes4 retval
1474         ) {
1475             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1476         } catch (bytes memory reason) {
1477             if (reason.length == 0) {
1478                 revert TransferToNonERC721ReceiverImplementer();
1479             } else {
1480                 assembly {
1481                     revert(add(32, reason), mload(reason))
1482                 }
1483             }
1484         }
1485     }
1486 
1487     // =============================================================
1488     //                        MINT OPERATIONS
1489     // =============================================================
1490 
1491     /**
1492      * @dev Mints `quantity` tokens and transfers them to `to`.
1493      *
1494      * Requirements:
1495      *
1496      * - `to` cannot be the zero address.
1497      * - `quantity` must be greater than 0.
1498      *
1499      * Emits a {Transfer} event for each mint.
1500      */
1501     function _mint(address to, uint256 quantity) internal virtual {
1502         uint256 startTokenId = _currentIndex;
1503         if (quantity == 0) revert MintZeroQuantity();
1504 
1505         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1506 
1507         // Overflows are incredibly unrealistic.
1508         // `balance` and `numberMinted` have a maximum limit of 2**64.
1509         // `tokenId` has a maximum limit of 2**256.
1510         unchecked {
1511             // Updates:
1512             // - `balance += quantity`.
1513             // - `numberMinted += quantity`.
1514             //
1515             // We can directly add to the `balance` and `numberMinted`.
1516             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1517 
1518             // Updates:
1519             // - `address` to the owner.
1520             // - `startTimestamp` to the timestamp of minting.
1521             // - `burned` to `false`.
1522             // - `nextInitialized` to `quantity == 1`.
1523             _packedOwnerships[startTokenId] = _packOwnershipData(
1524                 to,
1525                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1526             );
1527 
1528             uint256 toMasked;
1529             uint256 end = startTokenId + quantity;
1530 
1531             // Use assembly to loop and emit the `Transfer` event for gas savings.
1532             assembly {
1533                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1534                 toMasked := and(to, _BITMASK_ADDRESS)
1535                 // Emit the `Transfer` event.
1536                 log4(
1537                     0, // Start of data (0, since no data).
1538                     0, // End of data (0, since no data).
1539                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1540                     0, // `address(0)`.
1541                     toMasked, // `to`.
1542                     startTokenId // `tokenId`.
1543                 )
1544 
1545                 for {
1546                     let tokenId := add(startTokenId, 1)
1547                 } iszero(eq(tokenId, end)) {
1548                     tokenId := add(tokenId, 1)
1549                 } {
1550                     // Emit the `Transfer` event. Similar to above.
1551                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1552                 }
1553             }
1554             if (toMasked == 0) revert MintToZeroAddress();
1555 
1556             _currentIndex = end;
1557         }
1558         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1559     }
1560 
1561     /**
1562      * @dev Mints `quantity` tokens and transfers them to `to`.
1563      *
1564      * This function is intended for efficient minting only during contract creation.
1565      *
1566      * It emits only one {ConsecutiveTransfer} as defined in
1567      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1568      * instead of a sequence of {Transfer} event(s).
1569      *
1570      * Calling this function outside of contract creation WILL make your contract
1571      * non-compliant with the ERC721 standard.
1572      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1573      * {ConsecutiveTransfer} event is only permissible during contract creation.
1574      *
1575      * Requirements:
1576      *
1577      * - `to` cannot be the zero address.
1578      * - `quantity` must be greater than 0.
1579      *
1580      * Emits a {ConsecutiveTransfer} event.
1581      */
1582     function _mintERC2309(address to, uint256 quantity) internal virtual {
1583         uint256 startTokenId = _currentIndex;
1584         if (to == address(0)) revert MintToZeroAddress();
1585         if (quantity == 0) revert MintZeroQuantity();
1586         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1587 
1588         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1589 
1590         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1591         unchecked {
1592             // Updates:
1593             // - `balance += quantity`.
1594             // - `numberMinted += quantity`.
1595             //
1596             // We can directly add to the `balance` and `numberMinted`.
1597             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1598 
1599             // Updates:
1600             // - `address` to the owner.
1601             // - `startTimestamp` to the timestamp of minting.
1602             // - `burned` to `false`.
1603             // - `nextInitialized` to `quantity == 1`.
1604             _packedOwnerships[startTokenId] = _packOwnershipData(
1605                 to,
1606                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1607             );
1608 
1609             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1610 
1611             _currentIndex = startTokenId + quantity;
1612         }
1613         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1614     }
1615 
1616     /**
1617      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1618      *
1619      * Requirements:
1620      *
1621      * - If `to` refers to a smart contract, it must implement
1622      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1623      * - `quantity` must be greater than 0.
1624      *
1625      * See {_mint}.
1626      *
1627      * Emits a {Transfer} event for each mint.
1628      */
1629     function _safeMint(
1630         address to,
1631         uint256 quantity,
1632         bytes memory _data
1633     ) internal virtual {
1634         _mint(to, quantity);
1635 
1636         unchecked {
1637             if (to.code.length != 0) {
1638                 uint256 end = _currentIndex;
1639                 uint256 index = end - quantity;
1640                 do {
1641                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1642                         revert TransferToNonERC721ReceiverImplementer();
1643                     }
1644                 } while (index < end);
1645                 // Reentrancy protection.
1646                 if (_currentIndex != end) revert();
1647             }
1648         }
1649     }
1650 
1651     /**
1652      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1653      */
1654     function _safeMint(address to, uint256 quantity) internal virtual {
1655         _safeMint(to, quantity, '');
1656     }
1657 
1658     // =============================================================
1659     //                        BURN OPERATIONS
1660     // =============================================================
1661 
1662     /**
1663      * @dev Equivalent to `_burn(tokenId, false)`.
1664      */
1665     function _burn(uint256 tokenId) internal virtual {
1666         _burn(tokenId, false);
1667     }
1668 
1669     /**
1670      * @dev Destroys `tokenId`.
1671      * The approval is cleared when the token is burned.
1672      *
1673      * Requirements:
1674      *
1675      * - `tokenId` must exist.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1680         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1681 
1682         address from = address(uint160(prevOwnershipPacked));
1683 
1684         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1685 
1686         if (approvalCheck) {
1687             // The nested ifs save around 20+ gas over a compound boolean condition.
1688             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1689                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1690         }
1691 
1692         _beforeTokenTransfers(from, address(0), tokenId, 1);
1693 
1694         // Clear approvals from the previous owner.
1695         assembly {
1696             if approvedAddress {
1697                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1698                 sstore(approvedAddressSlot, 0)
1699             }
1700         }
1701 
1702         // Underflow of the sender's balance is impossible because we check for
1703         // ownership above and the recipient's balance can't realistically overflow.
1704         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1705         unchecked {
1706             // Updates:
1707             // - `balance -= 1`.
1708             // - `numberBurned += 1`.
1709             //
1710             // We can directly decrement the balance, and increment the number burned.
1711             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1712             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1713 
1714             // Updates:
1715             // - `address` to the last owner.
1716             // - `startTimestamp` to the timestamp of burning.
1717             // - `burned` to `true`.
1718             // - `nextInitialized` to `true`.
1719             _packedOwnerships[tokenId] = _packOwnershipData(
1720                 from,
1721                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1722             );
1723 
1724             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1725             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1726                 uint256 nextTokenId = tokenId + 1;
1727                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1728                 if (_packedOwnerships[nextTokenId] == 0) {
1729                     // If the next slot is within bounds.
1730                     if (nextTokenId != _currentIndex) {
1731                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1732                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1733                     }
1734                 }
1735             }
1736         }
1737 
1738         emit Transfer(from, address(0), tokenId);
1739         _afterTokenTransfers(from, address(0), tokenId, 1);
1740 
1741         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1742         unchecked {
1743             _burnCounter++;
1744         }
1745     }
1746 
1747     // =============================================================
1748     //                     EXTRA DATA OPERATIONS
1749     // =============================================================
1750 
1751     /**
1752      * @dev Directly sets the extra data for the ownership data `index`.
1753      */
1754     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1755         uint256 packed = _packedOwnerships[index];
1756         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1757         uint256 extraDataCasted;
1758         // Cast `extraData` with assembly to avoid redundant masking.
1759         assembly {
1760             extraDataCasted := extraData
1761         }
1762         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1763         _packedOwnerships[index] = packed;
1764     }
1765 
1766     /**
1767      * @dev Called during each token transfer to set the 24bit `extraData` field.
1768      * Intended to be overridden by the cosumer contract.
1769      *
1770      * `previousExtraData` - the value of `extraData` before transfer.
1771      *
1772      * Calling conditions:
1773      *
1774      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1775      * transferred to `to`.
1776      * - When `from` is zero, `tokenId` will be minted for `to`.
1777      * - When `to` is zero, `tokenId` will be burned by `from`.
1778      * - `from` and `to` are never both zero.
1779      */
1780     function _extraData(
1781         address from,
1782         address to,
1783         uint24 previousExtraData
1784     ) internal view virtual returns (uint24) {}
1785 
1786     /**
1787      * @dev Returns the next extra data for the packed ownership data.
1788      * The returned result is shifted into position.
1789      */
1790     function _nextExtraData(
1791         address from,
1792         address to,
1793         uint256 prevOwnershipPacked
1794     ) private view returns (uint256) {
1795         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1796         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1797     }
1798 
1799     // =============================================================
1800     //                       OTHER OPERATIONS
1801     // =============================================================
1802 
1803     /**
1804      * @dev Returns the message sender (defaults to `msg.sender`).
1805      *
1806      * If you are writing GSN compatible contracts, you need to override this function.
1807      */
1808     function _msgSenderERC721A() internal view virtual returns (address) {
1809         return msg.sender;
1810     }
1811 
1812     /**
1813      * @dev Converts a uint256 to its ASCII string decimal representation.
1814      */
1815     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1816         assembly {
1817             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1818             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1819             // We will need 1 32-byte word to store the length,
1820             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1821             ptr := add(mload(0x40), 128)
1822             // Update the free memory pointer to allocate.
1823             mstore(0x40, ptr)
1824 
1825             // Cache the end of the memory to calculate the length later.
1826             let end := ptr
1827 
1828             // We write the string from the rightmost digit to the leftmost digit.
1829             // The following is essentially a do-while loop that also handles the zero case.
1830             // Costs a bit more than early returning for the zero case,
1831             // but cheaper in terms of deployment and overall runtime costs.
1832             for {
1833                 // Initialize and perform the first pass without check.
1834                 let temp := value
1835                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1836                 ptr := sub(ptr, 1)
1837                 // Write the character to the pointer.
1838                 // The ASCII index of the '0' character is 48.
1839                 mstore8(ptr, add(48, mod(temp, 10)))
1840                 temp := div(temp, 10)
1841             } temp {
1842                 // Keep dividing `temp` until zero.
1843                 temp := div(temp, 10)
1844             } {
1845                 // Body of the for loop.
1846                 ptr := sub(ptr, 1)
1847                 mstore8(ptr, add(48, mod(temp, 10)))
1848             }
1849 
1850             let length := sub(end, ptr)
1851             // Move the pointer 32 bytes leftwards to make room for the length.
1852             ptr := sub(ptr, 32)
1853             // Store the length.
1854             mstore(ptr, length)
1855         }
1856     }
1857 }
1858 
1859 // File: contracts/dead.sol
1860 
1861 // File: The Devious Dead NFT.sol
1862 // Developer - TTibbs
1863 
1864 pragma solidity ^0.8.0;
1865 
1866 
1867 
1868 
1869 
1870 contract The_Devious_Dead_NFT is ERC721A, Ownable, ReentrancyGuard {
1871 
1872   using Strings for uint256;
1873   
1874   // Merkletree root hash (create merkleroot.js and add roothash from it)
1875   bytes32 public merkleRoot;
1876   bytes32 public ogmerkleRoot;
1877   
1878   // Reveal URI (set to blank if you want it sniper proof and update before minting)
1879   string public uri;
1880   string public uriSuffix = ".json";
1881 
1882   // Hidden URI (add your hidden metadata CID here)
1883   string public hiddenMetadataUri = "ipfs://QmWwPjoWzh8oGjzKkevkS4b9GrFbpRhKmq12vXzbqsc6QM/hidden.json";
1884 
1885   // Set the prices for each phase of minting
1886   uint256 public price = 0.065 ether;
1887   uint256 public wlprice = 0.04 ether;
1888   uint256 public ogprice = 0 ether;
1889 
1890   // Replace with your total supply here
1891   uint256 public supplyLimit = 3333;
1892 
1893   // Set the max per transaction for each phase of minting
1894   uint256 public maxMintAmountPerTx = 10;
1895   uint256 public wlmaxMintAmountPerTx = 4;
1896   uint256 public ogmaxMintAmountPerTx = 2;
1897 
1898   // Set the max per wallet for each phase of minting
1899   uint256 public maxLimitPerWallet = 20;
1900   uint256 public wlmaxLimitPerWallet = 8;
1901   uint256 public ogmaxLimitPerWallet = 2;
1902 
1903   // enable/disable minting phases
1904   bool public whitelistSale = false;
1905   bool public publicSale = false;
1906   bool public ogSale = false;
1907 
1908   // Reveal NFTs (set to false if you have want hidden metadata then change to true to reveal)
1909   bool public revealed = false;
1910 
1911   // Collection name and symbol, don't forget to change this
1912   constructor() ERC721A("The Devious Dead Official", "TDD")  {}
1913 
1914   // Minting functions 
1915   function OgMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable {
1916 
1917     // Verify og requirements
1918     require(ogSale, 'The OgSale is paused!');
1919     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1920     require(MerkleProof.verify(_merkleProof, ogmerkleRoot, leaf), 'Invalid proof!');
1921 
1922 
1923     // Normal requirements 
1924     require(_mintAmount > 0 && _mintAmount <= ogmaxMintAmountPerTx, 'Invalid mint amount!');
1925     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1926     require(balanceOf(msg.sender) + _mintAmount <= ogmaxLimitPerWallet, 'Max mint per wallet exceeded!');
1927     require(msg.value >= ogprice * _mintAmount, 'Insufficient funds!');
1928      
1929     // Mint
1930      _safeMint(_msgSender(), _mintAmount);
1931   }
1932 
1933   function WlMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable {
1934 
1935     // Verify wl requirements
1936     require(whitelistSale, 'The WlSale is paused!');
1937     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1938     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1939 
1940 
1941     // Normal requirements 
1942     require(_mintAmount > 0 && _mintAmount <= wlmaxMintAmountPerTx, 'Invalid mint amount!');
1943     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1944     require(balanceOf(msg.sender) + _mintAmount <= wlmaxLimitPerWallet, 'Max mint per wallet exceeded!');
1945     require(msg.value >= wlprice * _mintAmount, 'Insufficient funds!');
1946      
1947     // Mint
1948      _safeMint(_msgSender(), _mintAmount);
1949   }
1950 
1951   function PublicMint(uint256 _mintAmount) public payable {
1952     
1953     // Normal requirements 
1954     require(publicSale, 'The PublicSale is paused!');
1955     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1956     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1957     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet, 'Max mint per wallet exceeded!');
1958     require(msg.value >= price * _mintAmount, 'Insufficient funds!');
1959      
1960     // Mint
1961      _safeMint(_msgSender(), _mintAmount);
1962   }  
1963   // Airdrops to given addresses
1964   function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
1965     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1966     _safeMint(_receiver, _mintAmount);
1967   }
1968 
1969   // Changes the revealed state of your contract
1970   function setRevealed(bool _state) public onlyOwner {
1971     revealed = _state;
1972   }
1973 
1974   // Changes the URI you have set for the metadata
1975   function seturi(string memory _uri) public onlyOwner {
1976     uri = _uri;
1977   }
1978   // Changes the URI suffix for the metadata (Most will be .json)
1979   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1980     uriSuffix = _uriSuffix;
1981   }
1982   // Changes the hidden metadata CID
1983   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1984     hiddenMetadataUri = _hiddenMetadataUri;
1985   }
1986 
1987   // Toggles the sale settings for each phase of minting
1988   function setpublicSale(bool _publicSale) public onlyOwner {
1989     publicSale = _publicSale;
1990   }
1991 
1992   function setwlSale(bool _whitelistSale) public onlyOwner {
1993     whitelistSale = _whitelistSale;
1994   }
1995 
1996   function setogSale(bool _ogSale) public onlyOwner {
1997     ogSale = _ogSale;
1998   }
1999 
2000   // Sets the root hash from merkletree.js for each WL phase
2001   function setwlMerkleRootHash(bytes32 _merkleRoot) public onlyOwner {
2002     merkleRoot = _merkleRoot;
2003   }
2004 
2005   function setogMerkleRootHash(bytes32 _ogmerkleRoot) public onlyOwner {
2006     ogmerkleRoot = _ogmerkleRoot;
2007   }  
2008 
2009   // Sets the max mint amount for each phase of minting
2010   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2011     maxMintAmountPerTx = _maxMintAmountPerTx;
2012   }
2013 
2014   function setwlmaxMintAmountPerTx(uint256 _wlmaxMintAmountPerTx) public onlyOwner {
2015     wlmaxMintAmountPerTx = _wlmaxMintAmountPerTx;
2016   }
2017 
2018   function setogmaxMintAmountPerTx(uint256 _ogmaxMintAmountPerTx) public onlyOwner {
2019     ogmaxMintAmountPerTx = _ogmaxMintAmountPerTx;
2020   } 
2021 
2022   // Sets the max amount per wallet for each phase of minting
2023   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
2024     maxLimitPerWallet = _maxLimitPerWallet;
2025   }
2026 
2027   function setwlmaxLimitPerWallet(uint256 _wlmaxLimitPerWallet) public onlyOwner {
2028     wlmaxLimitPerWallet = _wlmaxLimitPerWallet;
2029   }  
2030 
2031   function setogmaxLimitPerWallet(uint256 _ogmaxLimitPerWallet) public onlyOwner {
2032     ogmaxLimitPerWallet = _ogmaxLimitPerWallet;
2033   }  
2034 
2035   // Sets the price per NFT for each phase of minting
2036   function setPrice(uint256 _price) public onlyOwner {
2037     price = _price;
2038   }
2039 
2040   function setwlprice(uint256 _wlprice) public onlyOwner {
2041     wlprice = _wlprice;
2042   }  
2043 
2044   function setogprice(uint256 _ogprice) public onlyOwner {
2045     ogprice = _ogprice;
2046   }  
2047 
2048   // Changes the supply limit, use this when you want to mint for each phase and update as you go along
2049   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
2050     supplyLimit = _supplyLimit;
2051   }
2052   // Do not remove this function or you will not be able to withdraw funds being held on the contract
2053   function withdraw() public onlyOwner nonReentrant {
2054     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2055     require(os);
2056   }
2057   // Reads and returns the token IDs owned by a wallet
2058   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
2059       uint256 ownerTokenCount = balanceOf(_owner);
2060       uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2061       uint256 currentTokenId = 1;
2062       uint256 ownedTokenIndex = 0;
2063 
2064       while (ownedTokenIndex < ownerTokenCount && currentTokenId <= supplyLimit) {
2065         address currentTokenOwner = ownerOf(currentTokenId);
2066 
2067         if (currentTokenOwner == _owner) {
2068             ownedTokenIds[ownedTokenIndex] = currentTokenId;
2069 
2070             ownedTokenIndex++;
2071         }
2072         currentTokenId++;
2073       }
2074       return ownedTokenIds;
2075     }
2076   // Sets the first minted NFT to #1 instead of #0
2077   function _startTokenId() internal view virtual override returns (uint256) {
2078     return 1;
2079   }
2080   // Returns the URI for the metadata of given token IDs
2081   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2082     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2083 
2084     if (revealed == false) {
2085       return hiddenMetadataUri;
2086     }
2087 
2088     string memory currentBaseURI = _baseURI();
2089     return bytes(currentBaseURI).length > 0
2090         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2091         : '';
2092   }
2093   // Returns the metadata baseURI for the collection itself
2094   function _baseURI() internal view virtual override returns (string memory) {
2095     return uri;
2096   }
2097 }