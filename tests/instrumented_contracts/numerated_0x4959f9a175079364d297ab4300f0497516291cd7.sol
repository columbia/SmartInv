1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Contract module that helps prevent reentrant calls to a function.
89  *
90  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
91  * available, which can be applied to functions to make sure there are no nested
92  * (reentrant) calls to them.
93  *
94  * Note that because there is a single `nonReentrant` guard, functions marked as
95  * `nonReentrant` may not call one another. This can be worked around by making
96  * those functions `private`, and then adding `external` `nonReentrant` entry
97  * points to them.
98  *
99  * TIP: If you would like to learn more about reentrancy and alternative ways
100  * to protect against it, check out our blog post
101  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
102  */
103 abstract contract ReentrancyGuard {
104     // Booleans are more expensive than uint256 or any type that takes up a full
105     // word because each write operation emits an extra SLOAD to first read the
106     // slot's contents, replace the bits taken up by the boolean, and then write
107     // back. This is the compiler's defense against contract upgrades and
108     // pointer aliasing, and it cannot be disabled.
109 
110     // The values being non-zero value makes deployment a bit more expensive,
111     // but in exchange the refund on every call to nonReentrant will be lower in
112     // amount. Since refunds are capped to a percentage of the total
113     // transaction's gas, it is best to keep them low in cases like this one, to
114     // increase the likelihood of the full refund coming into effect.
115     uint256 private constant _NOT_ENTERED = 1;
116     uint256 private constant _ENTERED = 2;
117 
118     uint256 private _status;
119 
120     constructor() {
121         _status = _NOT_ENTERED;
122     }
123 
124     /**
125      * @dev Prevents a contract from calling itself, directly or indirectly.
126      * Calling a `nonReentrant` function from another `nonReentrant`
127      * function is not supported. It is possible to prevent this from happening
128      * by making the `nonReentrant` function external, and making it call a
129      * `private` function that does the actual work.
130      */
131     modifier nonReentrant() {
132         // On the first call to nonReentrant, _notEntered will be true
133         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
134 
135         // Any calls to nonReentrant after this point will fail
136         _status = _ENTERED;
137 
138         _;
139 
140         // By storing the original value once again, a refund is triggered (see
141         // https://eips.ethereum.org/EIPS/eip-2200)
142         _status = _NOT_ENTERED;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
147 
148 
149 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev These functions deal with verification of Merkle Tree proofs.
155  *
156  * The proofs can be generated using the JavaScript library
157  * https://github.com/miguelmota/merkletreejs[merkletreejs].
158  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
159  *
160  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
161  *
162  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
163  * hashing, or use a hash function other than keccak256 for hashing leaves.
164  * This is because the concatenation of a sorted pair of internal nodes in
165  * the merkle tree could be reinterpreted as a leaf value.
166  */
167 library MerkleProof {
168     /**
169      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
170      * defined by `root`. For this, a `proof` must be provided, containing
171      * sibling hashes on the branch from the leaf to the root of the tree. Each
172      * pair of leaves and each pair of pre-images are assumed to be sorted.
173      */
174     function verify(
175         bytes32[] memory proof,
176         bytes32 root,
177         bytes32 leaf
178     ) internal pure returns (bool) {
179         return processProof(proof, leaf) == root;
180     }
181 
182     /**
183      * @dev Calldata version of {verify}
184      *
185      * _Available since v4.7._
186      */
187     function verifyCalldata(
188         bytes32[] calldata proof,
189         bytes32 root,
190         bytes32 leaf
191     ) internal pure returns (bool) {
192         return processProofCalldata(proof, leaf) == root;
193     }
194 
195     /**
196      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
197      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
198      * hash matches the root of the tree. When processing the proof, the pairs
199      * of leafs & pre-images are assumed to be sorted.
200      *
201      * _Available since v4.4._
202      */
203     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
204         bytes32 computedHash = leaf;
205         for (uint256 i = 0; i < proof.length; i++) {
206             computedHash = _hashPair(computedHash, proof[i]);
207         }
208         return computedHash;
209     }
210 
211     /**
212      * @dev Calldata version of {processProof}
213      *
214      * _Available since v4.7._
215      */
216     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
217         bytes32 computedHash = leaf;
218         for (uint256 i = 0; i < proof.length; i++) {
219             computedHash = _hashPair(computedHash, proof[i]);
220         }
221         return computedHash;
222     }
223 
224     /**
225      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
226      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
227      *
228      * _Available since v4.7._
229      */
230     function multiProofVerify(
231         bytes32[] memory proof,
232         bool[] memory proofFlags,
233         bytes32 root,
234         bytes32[] memory leaves
235     ) internal pure returns (bool) {
236         return processMultiProof(proof, proofFlags, leaves) == root;
237     }
238 
239     /**
240      * @dev Calldata version of {multiProofVerify}
241      *
242      * _Available since v4.7._
243      */
244     function multiProofVerifyCalldata(
245         bytes32[] calldata proof,
246         bool[] calldata proofFlags,
247         bytes32 root,
248         bytes32[] memory leaves
249     ) internal pure returns (bool) {
250         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
251     }
252 
253     /**
254      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
255      * consuming from one or the other at each step according to the instructions given by
256      * `proofFlags`.
257      *
258      * _Available since v4.7._
259      */
260     function processMultiProof(
261         bytes32[] memory proof,
262         bool[] memory proofFlags,
263         bytes32[] memory leaves
264     ) internal pure returns (bytes32 merkleRoot) {
265         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
266         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
267         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
268         // the merkle tree.
269         uint256 leavesLen = leaves.length;
270         uint256 totalHashes = proofFlags.length;
271 
272         // Check proof validity.
273         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
274 
275         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
276         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
277         bytes32[] memory hashes = new bytes32[](totalHashes);
278         uint256 leafPos = 0;
279         uint256 hashPos = 0;
280         uint256 proofPos = 0;
281         // At each step, we compute the next hash using two values:
282         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
283         //   get the next hash.
284         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
285         //   `proof` array.
286         for (uint256 i = 0; i < totalHashes; i++) {
287             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
288             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
289             hashes[i] = _hashPair(a, b);
290         }
291 
292         if (totalHashes > 0) {
293             return hashes[totalHashes - 1];
294         } else if (leavesLen > 0) {
295             return leaves[0];
296         } else {
297             return proof[0];
298         }
299     }
300 
301     /**
302      * @dev Calldata version of {processMultiProof}
303      *
304      * _Available since v4.7._
305      */
306     function processMultiProofCalldata(
307         bytes32[] calldata proof,
308         bool[] calldata proofFlags,
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
347     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
348         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
349     }
350 
351     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
352         /// @solidity memory-safe-assembly
353         assembly {
354             mstore(0x00, a)
355             mstore(0x20, b)
356             value := keccak256(0x00, 0x40)
357         }
358     }
359 }
360 
361 // File: @openzeppelin/contracts/utils/Context.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev Provides information about the current execution context, including the
370  * sender of the transaction and its data. While these are generally available
371  * via msg.sender and msg.data, they should not be accessed in such a direct
372  * manner, since when dealing with meta-transactions the account sending and
373  * paying for execution may not be the actual sender (as far as an application
374  * is concerned).
375  *
376  * This contract is only required for intermediate, library-like contracts.
377  */
378 abstract contract Context {
379     function _msgSender() internal view virtual returns (address) {
380         return msg.sender;
381     }
382 
383     function _msgData() internal view virtual returns (bytes calldata) {
384         return msg.data;
385     }
386 }
387 
388 // File: @openzeppelin/contracts/access/Ownable.sol
389 
390 
391 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 
396 /**
397  * @dev Contract module which provides a basic access control mechanism, where
398  * there is an account (an owner) that can be granted exclusive access to
399  * specific functions.
400  *
401  * By default, the owner account will be the one that deploys the contract. This
402  * can later be changed with {transferOwnership}.
403  *
404  * This module is used through inheritance. It will make available the modifier
405  * `onlyOwner`, which can be applied to your functions to restrict their use to
406  * the owner.
407  */
408 abstract contract Ownable is Context {
409     address private _owner;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     /**
414      * @dev Initializes the contract setting the deployer as the initial owner.
415      */
416     constructor() {
417         _transferOwnership(_msgSender());
418     }
419 
420     /**
421      * @dev Throws if called by any account other than the owner.
422      */
423     modifier onlyOwner() {
424         _checkOwner();
425         _;
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view virtual returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if the sender is not the owner.
437      */
438     function _checkOwner() internal view virtual {
439         require(owner() == _msgSender(), "Ownable: caller is not the owner");
440     }
441 
442     /**
443      * @dev Leaves the contract without owner. It will not be possible to call
444      * `onlyOwner` functions anymore. Can only be called by the current owner.
445      *
446      * NOTE: Renouncing ownership will leave the contract without an owner,
447      * thereby removing any functionality that is only available to the owner.
448      */
449     function renounceOwnership() public virtual onlyOwner {
450         _transferOwnership(address(0));
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      * Can only be called by the current owner.
456      */
457     function transferOwnership(address newOwner) public virtual onlyOwner {
458         require(newOwner != address(0), "Ownable: new owner is the zero address");
459         _transferOwnership(newOwner);
460     }
461 
462     /**
463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
464      * Internal function without access restriction.
465      */
466     function _transferOwnership(address newOwner) internal virtual {
467         address oldOwner = _owner;
468         _owner = newOwner;
469         emit OwnershipTransferred(oldOwner, newOwner);
470     }
471 }
472 
473 // File: erc721a/contracts/IERC721A.sol
474 
475 
476 // ERC721A Contracts v4.2.0
477 // Creator: Chiru Labs
478 
479 pragma solidity ^0.8.4;
480 
481 /**
482  * @dev Interface of ERC721A.
483  */
484 interface IERC721A {
485     /**
486      * The caller must own the token or be an approved operator.
487      */
488     error ApprovalCallerNotOwnerNorApproved();
489 
490     /**
491      * The token does not exist.
492      */
493     error ApprovalQueryForNonexistentToken();
494 
495     /**
496      * The caller cannot approve to their own address.
497      */
498     error ApproveToCaller();
499 
500     /**
501      * Cannot query the balance for the zero address.
502      */
503     error BalanceQueryForZeroAddress();
504 
505     /**
506      * Cannot mint to the zero address.
507      */
508     error MintToZeroAddress();
509 
510     /**
511      * The quantity of tokens minted must be more than zero.
512      */
513     error MintZeroQuantity();
514 
515     /**
516      * The token does not exist.
517      */
518     error OwnerQueryForNonexistentToken();
519 
520     /**
521      * The caller must own the token or be an approved operator.
522      */
523     error TransferCallerNotOwnerNorApproved();
524 
525     /**
526      * The token must be owned by `from`.
527      */
528     error TransferFromIncorrectOwner();
529 
530     /**
531      * Cannot safely transfer to a contract that does not implement the
532      * ERC721Receiver interface.
533      */
534     error TransferToNonERC721ReceiverImplementer();
535 
536     /**
537      * Cannot transfer to the zero address.
538      */
539     error TransferToZeroAddress();
540 
541     /**
542      * The token does not exist.
543      */
544     error URIQueryForNonexistentToken();
545 
546     /**
547      * The `quantity` minted with ERC2309 exceeds the safety limit.
548      */
549     error MintERC2309QuantityExceedsLimit();
550 
551     /**
552      * The `extraData` cannot be set on an unintialized ownership slot.
553      */
554     error OwnershipNotInitializedForExtraData();
555 
556     // =============================================================
557     //                            STRUCTS
558     // =============================================================
559 
560     struct TokenOwnership {
561         // The address of the owner.
562         address addr;
563         // Stores the start time of ownership with minimal overhead for tokenomics.
564         uint64 startTimestamp;
565         // Whether the token has been burned.
566         bool burned;
567         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
568         uint24 extraData;
569     }
570 
571     // =============================================================
572     //                         TOKEN COUNTERS
573     // =============================================================
574 
575     /**
576      * @dev Returns the total number of tokens in existence.
577      * Burned tokens will reduce the count.
578      * To get the total number of tokens minted, please see {_totalMinted}.
579      */
580     function totalSupply() external view returns (uint256);
581 
582     // =============================================================
583     //                            IERC165
584     // =============================================================
585 
586     /**
587      * @dev Returns true if this contract implements the interface defined by
588      * `interfaceId`. See the corresponding
589      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
590      * to learn more about how these ids are created.
591      *
592      * This function call must use less than 30000 gas.
593      */
594     function supportsInterface(bytes4 interfaceId) external view returns (bool);
595 
596     // =============================================================
597     //                            IERC721
598     // =============================================================
599 
600     /**
601      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
602      */
603     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
604 
605     /**
606      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
607      */
608     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
609 
610     /**
611      * @dev Emitted when `owner` enables or disables
612      * (`approved`) `operator` to manage all of its assets.
613      */
614     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
615 
616     /**
617      * @dev Returns the number of tokens in `owner`'s account.
618      */
619     function balanceOf(address owner) external view returns (uint256 balance);
620 
621     /**
622      * @dev Returns the owner of the `tokenId` token.
623      *
624      * Requirements:
625      *
626      * - `tokenId` must exist.
627      */
628     function ownerOf(uint256 tokenId) external view returns (address owner);
629 
630     /**
631      * @dev Safely transfers `tokenId` token from `from` to `to`,
632      * checking first that contract recipients are aware of the ERC721 protocol
633      * to prevent tokens from being forever locked.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must exist and be owned by `from`.
640      * - If the caller is not `from`, it must be have been allowed to move
641      * this token by either {approve} or {setApprovalForAll}.
642      * - If `to` refers to a smart contract, it must implement
643      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
644      *
645      * Emits a {Transfer} event.
646      */
647     function safeTransferFrom(
648         address from,
649         address to,
650         uint256 tokenId,
651         bytes calldata data
652     ) external;
653 
654     /**
655      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) external;
662 
663     /**
664      * @dev Transfers `tokenId` from `from` to `to`.
665      *
666      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
667      * whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token
675      * by either {approve} or {setApprovalForAll}.
676      *
677      * Emits a {Transfer} event.
678      */
679     function transferFrom(
680         address from,
681         address to,
682         uint256 tokenId
683     ) external;
684 
685     /**
686      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
687      * The approval is cleared when the token is transferred.
688      *
689      * Only a single account can be approved at a time, so approving the
690      * zero address clears previous approvals.
691      *
692      * Requirements:
693      *
694      * - The caller must own the token or be an approved operator.
695      * - `tokenId` must exist.
696      *
697      * Emits an {Approval} event.
698      */
699     function approve(address to, uint256 tokenId) external;
700 
701     /**
702      * @dev Approve or remove `operator` as an operator for the caller.
703      * Operators can call {transferFrom} or {safeTransferFrom}
704      * for any token owned by the caller.
705      *
706      * Requirements:
707      *
708      * - The `operator` cannot be the caller.
709      *
710      * Emits an {ApprovalForAll} event.
711      */
712     function setApprovalForAll(address operator, bool _approved) external;
713 
714     /**
715      * @dev Returns the account approved for `tokenId` token.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must exist.
720      */
721     function getApproved(uint256 tokenId) external view returns (address operator);
722 
723     /**
724      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
725      *
726      * See {setApprovalForAll}.
727      */
728     function isApprovedForAll(address owner, address operator) external view returns (bool);
729 
730     // =============================================================
731     //                        IERC721Metadata
732     // =============================================================
733 
734     /**
735      * @dev Returns the token collection name.
736      */
737     function name() external view returns (string memory);
738 
739     /**
740      * @dev Returns the token collection symbol.
741      */
742     function symbol() external view returns (string memory);
743 
744     /**
745      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
746      */
747     function tokenURI(uint256 tokenId) external view returns (string memory);
748 
749     // =============================================================
750     //                           IERC2309
751     // =============================================================
752 
753     /**
754      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
755      * (inclusive) is transferred from `from` to `to`, as defined in the
756      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
757      *
758      * See {_mintERC2309} for more details.
759      */
760     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
761 }
762 
763 // File: erc721a/contracts/ERC721A.sol
764 
765 
766 // ERC721A Contracts v4.2.0
767 // Creator: Chiru Labs
768 
769 pragma solidity ^0.8.4;
770 
771 
772 /**
773  * @dev Interface of ERC721 token receiver.
774  */
775 interface ERC721A__IERC721Receiver {
776     function onERC721Received(
777         address operator,
778         address from,
779         uint256 tokenId,
780         bytes calldata data
781     ) external returns (bytes4);
782 }
783 
784 /**
785  * @title ERC721A
786  *
787  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
788  * Non-Fungible Token Standard, including the Metadata extension.
789  * Optimized for lower gas during batch mints.
790  *
791  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
792  * starting from `_startTokenId()`.
793  *
794  * Assumptions:
795  *
796  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
797  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
798  */
799 contract ERC721A is IERC721A {
800     // Reference type for token approval.
801     struct TokenApprovalRef {
802         address value;
803     }
804 
805     // =============================================================
806     //                           CONSTANTS
807     // =============================================================
808 
809     // Mask of an entry in packed address data.
810     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
811 
812     // The bit position of `numberMinted` in packed address data.
813     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
814 
815     // The bit position of `numberBurned` in packed address data.
816     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
817 
818     // The bit position of `aux` in packed address data.
819     uint256 private constant _BITPOS_AUX = 192;
820 
821     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
822     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
823 
824     // The bit position of `startTimestamp` in packed ownership.
825     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
826 
827     // The bit mask of the `burned` bit in packed ownership.
828     uint256 private constant _BITMASK_BURNED = 1 << 224;
829 
830     // The bit position of the `nextInitialized` bit in packed ownership.
831     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
832 
833     // The bit mask of the `nextInitialized` bit in packed ownership.
834     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
835 
836     // The bit position of `extraData` in packed ownership.
837     uint256 private constant _BITPOS_EXTRA_DATA = 232;
838 
839     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
840     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
841 
842     // The mask of the lower 160 bits for addresses.
843     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
844 
845     // The maximum `quantity` that can be minted with {_mintERC2309}.
846     // This limit is to prevent overflows on the address data entries.
847     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
848     // is required to cause an overflow, which is unrealistic.
849     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
850 
851     // The `Transfer` event signature is given by:
852     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
853     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
854         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
855 
856     // =============================================================
857     //                            STORAGE
858     // =============================================================
859 
860     // The next token ID to be minted.
861     uint256 private _currentIndex;
862 
863     // The number of tokens burned.
864     uint256 private _burnCounter;
865 
866     // Token name
867     string private _name;
868 
869     // Token symbol
870     string private _symbol;
871 
872     // Mapping from token ID to ownership details
873     // An empty struct value does not necessarily mean the token is unowned.
874     // See {_packedOwnershipOf} implementation for details.
875     //
876     // Bits Layout:
877     // - [0..159]   `addr`
878     // - [160..223] `startTimestamp`
879     // - [224]      `burned`
880     // - [225]      `nextInitialized`
881     // - [232..255] `extraData`
882     mapping(uint256 => uint256) private _packedOwnerships;
883 
884     // Mapping owner address to address data.
885     //
886     // Bits Layout:
887     // - [0..63]    `balance`
888     // - [64..127]  `numberMinted`
889     // - [128..191] `numberBurned`
890     // - [192..255] `aux`
891     mapping(address => uint256) private _packedAddressData;
892 
893     // Mapping from token ID to approved address.
894     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
895 
896     // Mapping from owner to operator approvals
897     mapping(address => mapping(address => bool)) private _operatorApprovals;
898 
899     // =============================================================
900     //                          CONSTRUCTOR
901     // =============================================================
902 
903     constructor(string memory name_, string memory symbol_) {
904         _name = name_;
905         _symbol = symbol_;
906         _currentIndex = _startTokenId();
907     }
908 
909     // =============================================================
910     //                   TOKEN COUNTING OPERATIONS
911     // =============================================================
912 
913     /**
914      * @dev Returns the starting token ID.
915      * To change the starting token ID, please override this function.
916      */
917     function _startTokenId() internal view virtual returns (uint256) {
918         return 0;
919     }
920 
921     /**
922      * @dev Returns the next token ID to be minted.
923      */
924     function _nextTokenId() internal view virtual returns (uint256) {
925         return _currentIndex;
926     }
927 
928     /**
929      * @dev Returns the total number of tokens in existence.
930      * Burned tokens will reduce the count.
931      * To get the total number of tokens minted, please see {_totalMinted}.
932      */
933     function totalSupply() public view virtual override returns (uint256) {
934         // Counter underflow is impossible as _burnCounter cannot be incremented
935         // more than `_currentIndex - _startTokenId()` times.
936         unchecked {
937             return _currentIndex - _burnCounter - _startTokenId();
938         }
939     }
940 
941     /**
942      * @dev Returns the total amount of tokens minted in the contract.
943      */
944     function _totalMinted() internal view virtual returns (uint256) {
945         // Counter underflow is impossible as `_currentIndex` does not decrement,
946         // and it is initialized to `_startTokenId()`.
947         unchecked {
948             return _currentIndex - _startTokenId();
949         }
950     }
951 
952     /**
953      * @dev Returns the total number of tokens burned.
954      */
955     function _totalBurned() internal view virtual returns (uint256) {
956         return _burnCounter;
957     }
958 
959     // =============================================================
960     //                    ADDRESS DATA OPERATIONS
961     // =============================================================
962 
963     /**
964      * @dev Returns the number of tokens in `owner`'s account.
965      */
966     function balanceOf(address owner) public view virtual override returns (uint256) {
967         if (owner == address(0)) revert BalanceQueryForZeroAddress();
968         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
969     }
970 
971     /**
972      * Returns the number of tokens minted by `owner`.
973      */
974     function _numberMinted(address owner) internal view returns (uint256) {
975         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
976     }
977 
978     /**
979      * Returns the number of tokens burned by or on behalf of `owner`.
980      */
981     function _numberBurned(address owner) internal view returns (uint256) {
982         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
983     }
984 
985     /**
986      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
987      */
988     function _getAux(address owner) internal view returns (uint64) {
989         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
990     }
991 
992     /**
993      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
994      * If there are multiple variables, please pack them into a uint64.
995      */
996     function _setAux(address owner, uint64 aux) internal virtual {
997         uint256 packed = _packedAddressData[owner];
998         uint256 auxCasted;
999         // Cast `aux` with assembly to avoid redundant masking.
1000         assembly {
1001             auxCasted := aux
1002         }
1003         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1004         _packedAddressData[owner] = packed;
1005     }
1006 
1007     // =============================================================
1008     //                            IERC165
1009     // =============================================================
1010 
1011     /**
1012      * @dev Returns true if this contract implements the interface defined by
1013      * `interfaceId`. See the corresponding
1014      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1015      * to learn more about how these ids are created.
1016      *
1017      * This function call must use less than 30000 gas.
1018      */
1019     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1020         // The interface IDs are constants representing the first 4 bytes
1021         // of the XOR of all function selectors in the interface.
1022         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1023         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1024         return
1025             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1026             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1027             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1028     }
1029 
1030     // =============================================================
1031     //                        IERC721Metadata
1032     // =============================================================
1033 
1034     /**
1035      * @dev Returns the token collection name.
1036      */
1037     function name() public view virtual override returns (string memory) {
1038         return _name;
1039     }
1040 
1041     /**
1042      * @dev Returns the token collection symbol.
1043      */
1044     function symbol() public view virtual override returns (string memory) {
1045         return _symbol;
1046     }
1047 
1048     /**
1049      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1050      */
1051     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1052         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1053 
1054         string memory baseURI = _baseURI();
1055         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1056     }
1057 
1058     /**
1059      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1060      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1061      * by default, it can be overridden in child contracts.
1062      */
1063     function _baseURI() internal view virtual returns (string memory) {
1064         return '';
1065     }
1066 
1067     // =============================================================
1068     //                     OWNERSHIPS OPERATIONS
1069     // =============================================================
1070 
1071     /**
1072      * @dev Returns the owner of the `tokenId` token.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      */
1078     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1079         return address(uint160(_packedOwnershipOf(tokenId)));
1080     }
1081 
1082     /**
1083      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1084      * It gradually moves to O(1) as tokens get transferred around over time.
1085      */
1086     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1087         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1088     }
1089 
1090     /**
1091      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1092      */
1093     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1094         return _unpackedOwnership(_packedOwnerships[index]);
1095     }
1096 
1097     /**
1098      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1099      */
1100     function _initializeOwnershipAt(uint256 index) internal virtual {
1101         if (_packedOwnerships[index] == 0) {
1102             _packedOwnerships[index] = _packedOwnershipOf(index);
1103         }
1104     }
1105 
1106     /**
1107      * Returns the packed ownership data of `tokenId`.
1108      */
1109     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1110         uint256 curr = tokenId;
1111 
1112         unchecked {
1113             if (_startTokenId() <= curr)
1114                 if (curr < _currentIndex) {
1115                     uint256 packed = _packedOwnerships[curr];
1116                     // If not burned.
1117                     if (packed & _BITMASK_BURNED == 0) {
1118                         // Invariant:
1119                         // There will always be an initialized ownership slot
1120                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1121                         // before an unintialized ownership slot
1122                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1123                         // Hence, `curr` will not underflow.
1124                         //
1125                         // We can directly compare the packed value.
1126                         // If the address is zero, packed will be zero.
1127                         while (packed == 0) {
1128                             packed = _packedOwnerships[--curr];
1129                         }
1130                         return packed;
1131                     }
1132                 }
1133         }
1134         revert OwnerQueryForNonexistentToken();
1135     }
1136 
1137     /**
1138      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1139      */
1140     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1141         ownership.addr = address(uint160(packed));
1142         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1143         ownership.burned = packed & _BITMASK_BURNED != 0;
1144         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1145     }
1146 
1147     /**
1148      * @dev Packs ownership data into a single uint256.
1149      */
1150     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1151         assembly {
1152             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1153             owner := and(owner, _BITMASK_ADDRESS)
1154             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1155             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1156         }
1157     }
1158 
1159     /**
1160      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1161      */
1162     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1163         // For branchless setting of the `nextInitialized` flag.
1164         assembly {
1165             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1166             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1167         }
1168     }
1169 
1170     // =============================================================
1171     //                      APPROVAL OPERATIONS
1172     // =============================================================
1173 
1174     /**
1175      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1176      * The approval is cleared when the token is transferred.
1177      *
1178      * Only a single account can be approved at a time, so approving the
1179      * zero address clears previous approvals.
1180      *
1181      * Requirements:
1182      *
1183      * - The caller must own the token or be an approved operator.
1184      * - `tokenId` must exist.
1185      *
1186      * Emits an {Approval} event.
1187      */
1188     function approve(address to, uint256 tokenId) public virtual override {
1189         address owner = ownerOf(tokenId);
1190 
1191         if (_msgSenderERC721A() != owner)
1192             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1193                 revert ApprovalCallerNotOwnerNorApproved();
1194             }
1195 
1196         _tokenApprovals[tokenId].value = to;
1197         emit Approval(owner, to, tokenId);
1198     }
1199 
1200     /**
1201      * @dev Returns the account approved for `tokenId` token.
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must exist.
1206      */
1207     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1208         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1209 
1210         return _tokenApprovals[tokenId].value;
1211     }
1212 
1213     /**
1214      * @dev Approve or remove `operator` as an operator for the caller.
1215      * Operators can call {transferFrom} or {safeTransferFrom}
1216      * for any token owned by the caller.
1217      *
1218      * Requirements:
1219      *
1220      * - The `operator` cannot be the caller.
1221      *
1222      * Emits an {ApprovalForAll} event.
1223      */
1224     function setApprovalForAll(address operator, bool approved) public virtual override {
1225         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1226 
1227         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1228         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1229     }
1230 
1231     /**
1232      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1233      *
1234      * See {setApprovalForAll}.
1235      */
1236     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1237         return _operatorApprovals[owner][operator];
1238     }
1239 
1240     /**
1241      * @dev Returns whether `tokenId` exists.
1242      *
1243      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1244      *
1245      * Tokens start existing when they are minted. See {_mint}.
1246      */
1247     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1248         return
1249             _startTokenId() <= tokenId &&
1250             tokenId < _currentIndex && // If within bounds,
1251             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1252     }
1253 
1254     /**
1255      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1256      */
1257     function _isSenderApprovedOrOwner(
1258         address approvedAddress,
1259         address owner,
1260         address msgSender
1261     ) private pure returns (bool result) {
1262         assembly {
1263             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1264             owner := and(owner, _BITMASK_ADDRESS)
1265             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1266             msgSender := and(msgSender, _BITMASK_ADDRESS)
1267             // `msgSender == owner || msgSender == approvedAddress`.
1268             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1269         }
1270     }
1271 
1272     /**
1273      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1274      */
1275     function _getApprovedSlotAndAddress(uint256 tokenId)
1276         private
1277         view
1278         returns (uint256 approvedAddressSlot, address approvedAddress)
1279     {
1280         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1281         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1282         assembly {
1283             approvedAddressSlot := tokenApproval.slot
1284             approvedAddress := sload(approvedAddressSlot)
1285         }
1286     }
1287 
1288     // =============================================================
1289     //                      TRANSFER OPERATIONS
1290     // =============================================================
1291 
1292     /**
1293      * @dev Transfers `tokenId` from `from` to `to`.
1294      *
1295      * Requirements:
1296      *
1297      * - `from` cannot be the zero address.
1298      * - `to` cannot be the zero address.
1299      * - `tokenId` token must be owned by `from`.
1300      * - If the caller is not `from`, it must be approved to move this token
1301      * by either {approve} or {setApprovalForAll}.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function transferFrom(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) public virtual override {
1310         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1311 
1312         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1313 
1314         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1315 
1316         // The nested ifs save around 20+ gas over a compound boolean condition.
1317         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1318             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1319 
1320         if (to == address(0)) revert TransferToZeroAddress();
1321 
1322         _beforeTokenTransfers(from, to, tokenId, 1);
1323 
1324         // Clear approvals from the previous owner.
1325         assembly {
1326             if approvedAddress {
1327                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1328                 sstore(approvedAddressSlot, 0)
1329             }
1330         }
1331 
1332         // Underflow of the sender's balance is impossible because we check for
1333         // ownership above and the recipient's balance can't realistically overflow.
1334         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1335         unchecked {
1336             // We can directly increment and decrement the balances.
1337             --_packedAddressData[from]; // Updates: `balance -= 1`.
1338             ++_packedAddressData[to]; // Updates: `balance += 1`.
1339 
1340             // Updates:
1341             // - `address` to the next owner.
1342             // - `startTimestamp` to the timestamp of transfering.
1343             // - `burned` to `false`.
1344             // - `nextInitialized` to `true`.
1345             _packedOwnerships[tokenId] = _packOwnershipData(
1346                 to,
1347                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1348             );
1349 
1350             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1351             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1352                 uint256 nextTokenId = tokenId + 1;
1353                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1354                 if (_packedOwnerships[nextTokenId] == 0) {
1355                     // If the next slot is within bounds.
1356                     if (nextTokenId != _currentIndex) {
1357                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1358                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1359                     }
1360                 }
1361             }
1362         }
1363 
1364         emit Transfer(from, to, tokenId);
1365         _afterTokenTransfers(from, to, tokenId, 1);
1366     }
1367 
1368     /**
1369      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1370      */
1371     function safeTransferFrom(
1372         address from,
1373         address to,
1374         uint256 tokenId
1375     ) public virtual override {
1376         safeTransferFrom(from, to, tokenId, '');
1377     }
1378 
1379     /**
1380      * @dev Safely transfers `tokenId` token from `from` to `to`.
1381      *
1382      * Requirements:
1383      *
1384      * - `from` cannot be the zero address.
1385      * - `to` cannot be the zero address.
1386      * - `tokenId` token must exist and be owned by `from`.
1387      * - If the caller is not `from`, it must be approved to move this token
1388      * by either {approve} or {setApprovalForAll}.
1389      * - If `to` refers to a smart contract, it must implement
1390      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function safeTransferFrom(
1395         address from,
1396         address to,
1397         uint256 tokenId,
1398         bytes memory _data
1399     ) public virtual override {
1400         transferFrom(from, to, tokenId);
1401         if (to.code.length != 0)
1402             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1403                 revert TransferToNonERC721ReceiverImplementer();
1404             }
1405     }
1406 
1407     /**
1408      * @dev Hook that is called before a set of serially-ordered token IDs
1409      * are about to be transferred. This includes minting.
1410      * And also called before burning one token.
1411      *
1412      * `startTokenId` - the first token ID to be transferred.
1413      * `quantity` - the amount to be transferred.
1414      *
1415      * Calling conditions:
1416      *
1417      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1418      * transferred to `to`.
1419      * - When `from` is zero, `tokenId` will be minted for `to`.
1420      * - When `to` is zero, `tokenId` will be burned by `from`.
1421      * - `from` and `to` are never both zero.
1422      */
1423     function _beforeTokenTransfers(
1424         address from,
1425         address to,
1426         uint256 startTokenId,
1427         uint256 quantity
1428     ) internal virtual {}
1429 
1430     /**
1431      * @dev Hook that is called after a set of serially-ordered token IDs
1432      * have been transferred. This includes minting.
1433      * And also called after one token has been burned.
1434      *
1435      * `startTokenId` - the first token ID to be transferred.
1436      * `quantity` - the amount to be transferred.
1437      *
1438      * Calling conditions:
1439      *
1440      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1441      * transferred to `to`.
1442      * - When `from` is zero, `tokenId` has been minted for `to`.
1443      * - When `to` is zero, `tokenId` has been burned by `from`.
1444      * - `from` and `to` are never both zero.
1445      */
1446     function _afterTokenTransfers(
1447         address from,
1448         address to,
1449         uint256 startTokenId,
1450         uint256 quantity
1451     ) internal virtual {}
1452 
1453     /**
1454      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1455      *
1456      * `from` - Previous owner of the given token ID.
1457      * `to` - Target address that will receive the token.
1458      * `tokenId` - Token ID to be transferred.
1459      * `_data` - Optional data to send along with the call.
1460      *
1461      * Returns whether the call correctly returned the expected magic value.
1462      */
1463     function _checkContractOnERC721Received(
1464         address from,
1465         address to,
1466         uint256 tokenId,
1467         bytes memory _data
1468     ) private returns (bool) {
1469         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1470             bytes4 retval
1471         ) {
1472             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1473         } catch (bytes memory reason) {
1474             if (reason.length == 0) {
1475                 revert TransferToNonERC721ReceiverImplementer();
1476             } else {
1477                 assembly {
1478                     revert(add(32, reason), mload(reason))
1479                 }
1480             }
1481         }
1482     }
1483 
1484     // =============================================================
1485     //                        MINT OPERATIONS
1486     // =============================================================
1487 
1488     /**
1489      * @dev Mints `quantity` tokens and transfers them to `to`.
1490      *
1491      * Requirements:
1492      *
1493      * - `to` cannot be the zero address.
1494      * - `quantity` must be greater than 0.
1495      *
1496      * Emits a {Transfer} event for each mint.
1497      */
1498     function _mint(address to, uint256 quantity) internal virtual {
1499         uint256 startTokenId = _currentIndex;
1500         if (quantity == 0) revert MintZeroQuantity();
1501 
1502         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1503 
1504         // Overflows are incredibly unrealistic.
1505         // `balance` and `numberMinted` have a maximum limit of 2**64.
1506         // `tokenId` has a maximum limit of 2**256.
1507         unchecked {
1508             // Updates:
1509             // - `balance += quantity`.
1510             // - `numberMinted += quantity`.
1511             //
1512             // We can directly add to the `balance` and `numberMinted`.
1513             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1514 
1515             // Updates:
1516             // - `address` to the owner.
1517             // - `startTimestamp` to the timestamp of minting.
1518             // - `burned` to `false`.
1519             // - `nextInitialized` to `quantity == 1`.
1520             _packedOwnerships[startTokenId] = _packOwnershipData(
1521                 to,
1522                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1523             );
1524 
1525             uint256 toMasked;
1526             uint256 end = startTokenId + quantity;
1527 
1528             // Use assembly to loop and emit the `Transfer` event for gas savings.
1529             assembly {
1530                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1531                 toMasked := and(to, _BITMASK_ADDRESS)
1532                 // Emit the `Transfer` event.
1533                 log4(
1534                     0, // Start of data (0, since no data).
1535                     0, // End of data (0, since no data).
1536                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1537                     0, // `address(0)`.
1538                     toMasked, // `to`.
1539                     startTokenId // `tokenId`.
1540                 )
1541 
1542                 for {
1543                     let tokenId := add(startTokenId, 1)
1544                 } iszero(eq(tokenId, end)) {
1545                     tokenId := add(tokenId, 1)
1546                 } {
1547                     // Emit the `Transfer` event. Similar to above.
1548                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1549                 }
1550             }
1551             if (toMasked == 0) revert MintToZeroAddress();
1552 
1553             _currentIndex = end;
1554         }
1555         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1556     }
1557 
1558     /**
1559      * @dev Mints `quantity` tokens and transfers them to `to`.
1560      *
1561      * This function is intended for efficient minting only during contract creation.
1562      *
1563      * It emits only one {ConsecutiveTransfer} as defined in
1564      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1565      * instead of a sequence of {Transfer} event(s).
1566      *
1567      * Calling this function outside of contract creation WILL make your contract
1568      * non-compliant with the ERC721 standard.
1569      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1570      * {ConsecutiveTransfer} event is only permissible during contract creation.
1571      *
1572      * Requirements:
1573      *
1574      * - `to` cannot be the zero address.
1575      * - `quantity` must be greater than 0.
1576      *
1577      * Emits a {ConsecutiveTransfer} event.
1578      */
1579     function _mintERC2309(address to, uint256 quantity) internal virtual {
1580         uint256 startTokenId = _currentIndex;
1581         if (to == address(0)) revert MintToZeroAddress();
1582         if (quantity == 0) revert MintZeroQuantity();
1583         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1584 
1585         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1586 
1587         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1588         unchecked {
1589             // Updates:
1590             // - `balance += quantity`.
1591             // - `numberMinted += quantity`.
1592             //
1593             // We can directly add to the `balance` and `numberMinted`.
1594             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1595 
1596             // Updates:
1597             // - `address` to the owner.
1598             // - `startTimestamp` to the timestamp of minting.
1599             // - `burned` to `false`.
1600             // - `nextInitialized` to `quantity == 1`.
1601             _packedOwnerships[startTokenId] = _packOwnershipData(
1602                 to,
1603                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1604             );
1605 
1606             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1607 
1608             _currentIndex = startTokenId + quantity;
1609         }
1610         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1611     }
1612 
1613     /**
1614      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1615      *
1616      * Requirements:
1617      *
1618      * - If `to` refers to a smart contract, it must implement
1619      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1620      * - `quantity` must be greater than 0.
1621      *
1622      * See {_mint}.
1623      *
1624      * Emits a {Transfer} event for each mint.
1625      */
1626     function _safeMint(
1627         address to,
1628         uint256 quantity,
1629         bytes memory _data
1630     ) internal virtual {
1631         _mint(to, quantity);
1632 
1633         unchecked {
1634             if (to.code.length != 0) {
1635                 uint256 end = _currentIndex;
1636                 uint256 index = end - quantity;
1637                 do {
1638                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1639                         revert TransferToNonERC721ReceiverImplementer();
1640                     }
1641                 } while (index < end);
1642                 // Reentrancy protection.
1643                 if (_currentIndex != end) revert();
1644             }
1645         }
1646     }
1647 
1648     /**
1649      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1650      */
1651     function _safeMint(address to, uint256 quantity) internal virtual {
1652         _safeMint(to, quantity, '');
1653     }
1654 
1655     // =============================================================
1656     //                        BURN OPERATIONS
1657     // =============================================================
1658 
1659     /**
1660      * @dev Equivalent to `_burn(tokenId, false)`.
1661      */
1662     function _burn(uint256 tokenId) internal virtual {
1663         _burn(tokenId, false);
1664     }
1665 
1666     /**
1667      * @dev Destroys `tokenId`.
1668      * The approval is cleared when the token is burned.
1669      *
1670      * Requirements:
1671      *
1672      * - `tokenId` must exist.
1673      *
1674      * Emits a {Transfer} event.
1675      */
1676     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1677         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1678 
1679         address from = address(uint160(prevOwnershipPacked));
1680 
1681         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1682 
1683         if (approvalCheck) {
1684             // The nested ifs save around 20+ gas over a compound boolean condition.
1685             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1686                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1687         }
1688 
1689         _beforeTokenTransfers(from, address(0), tokenId, 1);
1690 
1691         // Clear approvals from the previous owner.
1692         assembly {
1693             if approvedAddress {
1694                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1695                 sstore(approvedAddressSlot, 0)
1696             }
1697         }
1698 
1699         // Underflow of the sender's balance is impossible because we check for
1700         // ownership above and the recipient's balance can't realistically overflow.
1701         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1702         unchecked {
1703             // Updates:
1704             // - `balance -= 1`.
1705             // - `numberBurned += 1`.
1706             //
1707             // We can directly decrement the balance, and increment the number burned.
1708             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1709             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1710 
1711             // Updates:
1712             // - `address` to the last owner.
1713             // - `startTimestamp` to the timestamp of burning.
1714             // - `burned` to `true`.
1715             // - `nextInitialized` to `true`.
1716             _packedOwnerships[tokenId] = _packOwnershipData(
1717                 from,
1718                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1719             );
1720 
1721             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1722             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1723                 uint256 nextTokenId = tokenId + 1;
1724                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1725                 if (_packedOwnerships[nextTokenId] == 0) {
1726                     // If the next slot is within bounds.
1727                     if (nextTokenId != _currentIndex) {
1728                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1729                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1730                     }
1731                 }
1732             }
1733         }
1734 
1735         emit Transfer(from, address(0), tokenId);
1736         _afterTokenTransfers(from, address(0), tokenId, 1);
1737 
1738         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1739         unchecked {
1740             _burnCounter++;
1741         }
1742     }
1743 
1744     // =============================================================
1745     //                     EXTRA DATA OPERATIONS
1746     // =============================================================
1747 
1748     /**
1749      * @dev Directly sets the extra data for the ownership data `index`.
1750      */
1751     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1752         uint256 packed = _packedOwnerships[index];
1753         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1754         uint256 extraDataCasted;
1755         // Cast `extraData` with assembly to avoid redundant masking.
1756         assembly {
1757             extraDataCasted := extraData
1758         }
1759         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1760         _packedOwnerships[index] = packed;
1761     }
1762 
1763     /**
1764      * @dev Called during each token transfer to set the 24bit `extraData` field.
1765      * Intended to be overridden by the cosumer contract.
1766      *
1767      * `previousExtraData` - the value of `extraData` before transfer.
1768      *
1769      * Calling conditions:
1770      *
1771      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1772      * transferred to `to`.
1773      * - When `from` is zero, `tokenId` will be minted for `to`.
1774      * - When `to` is zero, `tokenId` will be burned by `from`.
1775      * - `from` and `to` are never both zero.
1776      */
1777     function _extraData(
1778         address from,
1779         address to,
1780         uint24 previousExtraData
1781     ) internal view virtual returns (uint24) {}
1782 
1783     /**
1784      * @dev Returns the next extra data for the packed ownership data.
1785      * The returned result is shifted into position.
1786      */
1787     function _nextExtraData(
1788         address from,
1789         address to,
1790         uint256 prevOwnershipPacked
1791     ) private view returns (uint256) {
1792         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1793         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1794     }
1795 
1796     // =============================================================
1797     //                       OTHER OPERATIONS
1798     // =============================================================
1799 
1800     /**
1801      * @dev Returns the message sender (defaults to `msg.sender`).
1802      *
1803      * If you are writing GSN compatible contracts, you need to override this function.
1804      */
1805     function _msgSenderERC721A() internal view virtual returns (address) {
1806         return msg.sender;
1807     }
1808 
1809     /**
1810      * @dev Converts a uint256 to its ASCII string decimal representation.
1811      */
1812     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1813         assembly {
1814             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1815             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1816             // We will need 1 32-byte word to store the length,
1817             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1818             ptr := add(mload(0x40), 128)
1819             // Update the free memory pointer to allocate.
1820             mstore(0x40, ptr)
1821 
1822             // Cache the end of the memory to calculate the length later.
1823             let end := ptr
1824 
1825             // We write the string from the rightmost digit to the leftmost digit.
1826             // The following is essentially a do-while loop that also handles the zero case.
1827             // Costs a bit more than early returning for the zero case,
1828             // but cheaper in terms of deployment and overall runtime costs.
1829             for {
1830                 // Initialize and perform the first pass without check.
1831                 let temp := value
1832                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1833                 ptr := sub(ptr, 1)
1834                 // Write the character to the pointer.
1835                 // The ASCII index of the '0' character is 48.
1836                 mstore8(ptr, add(48, mod(temp, 10)))
1837                 temp := div(temp, 10)
1838             } temp {
1839                 // Keep dividing `temp` until zero.
1840                 temp := div(temp, 10)
1841             } {
1842                 // Body of the for loop.
1843                 ptr := sub(ptr, 1)
1844                 mstore8(ptr, add(48, mod(temp, 10)))
1845             }
1846 
1847             let length := sub(end, ptr)
1848             // Move the pointer 32 bytes leftwards to make room for the length.
1849             ptr := sub(ptr, 32)
1850             // Store the length.
1851             mstore(ptr, length)
1852         }
1853     }
1854 }
1855 
1856 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1857 
1858 
1859 // ERC721A Contracts v4.2.0
1860 // Creator: Chiru Labs
1861 
1862 pragma solidity ^0.8.4;
1863 
1864 
1865 /**
1866  * @dev Interface of ERC721AQueryable.
1867  */
1868 interface IERC721AQueryable is IERC721A {
1869     /**
1870      * Invalid query range (`start` >= `stop`).
1871      */
1872     error InvalidQueryRange();
1873 
1874     /**
1875      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1876      *
1877      * If the `tokenId` is out of bounds:
1878      *
1879      * - `addr = address(0)`
1880      * - `startTimestamp = 0`
1881      * - `burned = false`
1882      * - `extraData = 0`
1883      *
1884      * If the `tokenId` is burned:
1885      *
1886      * - `addr = <Address of owner before token was burned>`
1887      * - `startTimestamp = <Timestamp when token was burned>`
1888      * - `burned = true`
1889      * - `extraData = <Extra data when token was burned>`
1890      *
1891      * Otherwise:
1892      *
1893      * - `addr = <Address of owner>`
1894      * - `startTimestamp = <Timestamp of start of ownership>`
1895      * - `burned = false`
1896      * - `extraData = <Extra data at start of ownership>`
1897      */
1898     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1899 
1900     /**
1901      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1902      * See {ERC721AQueryable-explicitOwnershipOf}
1903      */
1904     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1905 
1906     /**
1907      * @dev Returns an array of token IDs owned by `owner`,
1908      * in the range [`start`, `stop`)
1909      * (i.e. `start <= tokenId < stop`).
1910      *
1911      * This function allows for tokens to be queried if the collection
1912      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1913      *
1914      * Requirements:
1915      *
1916      * - `start < stop`
1917      */
1918     function tokensOfOwnerIn(
1919         address owner,
1920         uint256 start,
1921         uint256 stop
1922     ) external view returns (uint256[] memory);
1923 
1924     /**
1925      * @dev Returns an array of token IDs owned by `owner`.
1926      *
1927      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1928      * It is meant to be called off-chain.
1929      *
1930      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1931      * multiple smaller scans if the collection is large enough to cause
1932      * an out-of-gas error (10K collections should be fine).
1933      */
1934     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1935 }
1936 
1937 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1938 
1939 
1940 // ERC721A Contracts v4.2.0
1941 // Creator: Chiru Labs
1942 
1943 pragma solidity ^0.8.4;
1944 
1945 
1946 
1947 /**
1948  * @title ERC721AQueryable.
1949  *
1950  * @dev ERC721A subclass with convenience query functions.
1951  */
1952 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1953     /**
1954      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1955      *
1956      * If the `tokenId` is out of bounds:
1957      *
1958      * - `addr = address(0)`
1959      * - `startTimestamp = 0`
1960      * - `burned = false`
1961      * - `extraData = 0`
1962      *
1963      * If the `tokenId` is burned:
1964      *
1965      * - `addr = <Address of owner before token was burned>`
1966      * - `startTimestamp = <Timestamp when token was burned>`
1967      * - `burned = true`
1968      * - `extraData = <Extra data when token was burned>`
1969      *
1970      * Otherwise:
1971      *
1972      * - `addr = <Address of owner>`
1973      * - `startTimestamp = <Timestamp of start of ownership>`
1974      * - `burned = false`
1975      * - `extraData = <Extra data at start of ownership>`
1976      */
1977     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1978         TokenOwnership memory ownership;
1979         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1980             return ownership;
1981         }
1982         ownership = _ownershipAt(tokenId);
1983         if (ownership.burned) {
1984             return ownership;
1985         }
1986         return _ownershipOf(tokenId);
1987     }
1988 
1989     /**
1990      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1991      * See {ERC721AQueryable-explicitOwnershipOf}
1992      */
1993     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1994         external
1995         view
1996         virtual
1997         override
1998         returns (TokenOwnership[] memory)
1999     {
2000         unchecked {
2001             uint256 tokenIdsLength = tokenIds.length;
2002             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2003             for (uint256 i; i != tokenIdsLength; ++i) {
2004                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2005             }
2006             return ownerships;
2007         }
2008     }
2009 
2010     /**
2011      * @dev Returns an array of token IDs owned by `owner`,
2012      * in the range [`start`, `stop`)
2013      * (i.e. `start <= tokenId < stop`).
2014      *
2015      * This function allows for tokens to be queried if the collection
2016      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2017      *
2018      * Requirements:
2019      *
2020      * - `start < stop`
2021      */
2022     function tokensOfOwnerIn(
2023         address owner,
2024         uint256 start,
2025         uint256 stop
2026     ) external view virtual override returns (uint256[] memory) {
2027         unchecked {
2028             if (start >= stop) revert InvalidQueryRange();
2029             uint256 tokenIdsIdx;
2030             uint256 stopLimit = _nextTokenId();
2031             // Set `start = max(start, _startTokenId())`.
2032             if (start < _startTokenId()) {
2033                 start = _startTokenId();
2034             }
2035             // Set `stop = min(stop, stopLimit)`.
2036             if (stop > stopLimit) {
2037                 stop = stopLimit;
2038             }
2039             uint256 tokenIdsMaxLength = balanceOf(owner);
2040             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2041             // to cater for cases where `balanceOf(owner)` is too big.
2042             if (start < stop) {
2043                 uint256 rangeLength = stop - start;
2044                 if (rangeLength < tokenIdsMaxLength) {
2045                     tokenIdsMaxLength = rangeLength;
2046                 }
2047             } else {
2048                 tokenIdsMaxLength = 0;
2049             }
2050             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2051             if (tokenIdsMaxLength == 0) {
2052                 return tokenIds;
2053             }
2054             // We need to call `explicitOwnershipOf(start)`,
2055             // because the slot at `start` may not be initialized.
2056             TokenOwnership memory ownership = explicitOwnershipOf(start);
2057             address currOwnershipAddr;
2058             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2059             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2060             if (!ownership.burned) {
2061                 currOwnershipAddr = ownership.addr;
2062             }
2063             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2064                 ownership = _ownershipAt(i);
2065                 if (ownership.burned) {
2066                     continue;
2067                 }
2068                 if (ownership.addr != address(0)) {
2069                     currOwnershipAddr = ownership.addr;
2070                 }
2071                 if (currOwnershipAddr == owner) {
2072                     tokenIds[tokenIdsIdx++] = i;
2073                 }
2074             }
2075             // Downsize the array to fit.
2076             assembly {
2077                 mstore(tokenIds, tokenIdsIdx)
2078             }
2079             return tokenIds;
2080         }
2081     }
2082 
2083     /**
2084      * @dev Returns an array of token IDs owned by `owner`.
2085      *
2086      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2087      * It is meant to be called off-chain.
2088      *
2089      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2090      * multiple smaller scans if the collection is large enough to cause
2091      * an out-of-gas error (10K collections should be fine).
2092      */
2093     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2094         unchecked {
2095             uint256 tokenIdsIdx;
2096             address currOwnershipAddr;
2097             uint256 tokenIdsLength = balanceOf(owner);
2098             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2099             TokenOwnership memory ownership;
2100             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2101                 ownership = _ownershipAt(i);
2102                 if (ownership.burned) {
2103                     continue;
2104                 }
2105                 if (ownership.addr != address(0)) {
2106                     currOwnershipAddr = ownership.addr;
2107                 }
2108                 if (currOwnershipAddr == owner) {
2109                     tokenIds[tokenIdsIdx++] = i;
2110                 }
2111             }
2112             return tokenIds;
2113         }
2114     }
2115 }
2116 
2117 // File: the italians/theitalians.sol
2118 
2119 
2120 
2121 pragma solidity >=0.8.9 <0.9.0;
2122 
2123 
2124 
2125 
2126 
2127 
2128 contract TheItalians is ERC721AQueryable, Ownable, ReentrancyGuard {
2129     using Strings for uint256;
2130 
2131     bytes32 public merkleRoot;
2132     mapping(address => bool) public mintClaimed;
2133 
2134     string public uriPrefix = "";
2135     string public uriSuffix = "";
2136     string public hiddenMetadataUri;
2137 
2138     uint256 public cost = 0.0059 ether;
2139     uint256 public maxSupply = 5555;
2140     uint256 public maxMintAmountPerTx = 8;
2141 
2142     bool public paused = true;
2143     bool public whitelistMintEnabled = false;
2144     bool public revealed = false;
2145 
2146     constructor() ERC721A("The Italians", "Italians"){}
2147 
2148     modifier mintPriceCompliance(uint256 _mintAmount) {
2149         require(
2150             msg.value >= updateMintCost(_mintAmount),
2151             "Insufficient funds!"
2152         );
2153         _;
2154     }
2155 
2156     function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
2157         public
2158         payable
2159         mintPriceCompliance(_mintAmount)
2160     {
2161         if (whitelistMintEnabled == true) {
2162             bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2163             require(
2164                 MerkleProof.verify(_merkleProof, merkleRoot, leaf),
2165                 "Invalid proof!"
2166             );
2167         }
2168 
2169         require(!paused, "The contract is paused!");
2170         require(
2171             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
2172             "Invalid mint amount!"
2173         );
2174         require(
2175             totalSupply() + _mintAmount <= (maxSupply),
2176             "Max supply exceeded!"
2177         );
2178         require(!mintClaimed[_msgSender()], "Address already claimed!");
2179 
2180         mintClaimed[_msgSender()] = true;
2181         _safeMint(_msgSender(), _mintAmount);
2182     }
2183 
2184     function mint(uint256 _mintAmount)
2185         public
2186         payable
2187         mintPriceCompliance(_mintAmount)
2188     {
2189         require(!paused, "The contract is paused!");
2190         if (mintClaimed[msg.sender] == false) {
2191             mintClaimed[msg.sender] = true;
2192         }
2193         _safeMint(_msgSender(), _mintAmount);
2194     }
2195 
2196     function mintForAddress(uint256 _mintAmount, address _receiver)
2197         public
2198         onlyOwner
2199     {
2200         _safeMint(_receiver, _mintAmount);
2201     }
2202 
2203     function _startTokenId() internal view virtual override returns (uint256) {
2204         return 1;
2205     }
2206 
2207     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2208     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2209 
2210     if (revealed == false) {
2211       return hiddenMetadataUri;
2212     }
2213 
2214     string memory currentBaseURI = _baseURI();
2215     return bytes(currentBaseURI).length > 0
2216         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2217         : '';
2218   }
2219 
2220 
2221     function setRevealed(bool _state) public onlyOwner {
2222         revealed = _state;
2223     }
2224 
2225     function setCost(uint256 _cost) public onlyOwner {
2226         cost = _cost;
2227     }
2228 
2229     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
2230         public
2231         onlyOwner
2232     {
2233         maxMintAmountPerTx = _maxMintAmountPerTx;
2234     }
2235 
2236     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
2237         public
2238         onlyOwner
2239     {
2240         hiddenMetadataUri = _hiddenMetadataUri;
2241     }
2242 
2243     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2244         uriPrefix = _uriPrefix;
2245     }
2246 
2247     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2248         uriSuffix = _uriSuffix;
2249     }
2250 
2251     function setPaused(bool _state) public onlyOwner {
2252         paused = _state;
2253     }
2254 
2255     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2256         merkleRoot = _merkleRoot;
2257     }
2258 
2259     function setWhitelistMintEnabled(bool _state) public onlyOwner {
2260         whitelistMintEnabled = _state;
2261     }
2262 
2263     function withdraw() public onlyOwner nonReentrant {
2264         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2265         require(os);
2266     }
2267 
2268     function _baseURI() internal view virtual override returns (string memory) {
2269         return uriPrefix;
2270     }
2271 
2272     function getTotalCost(uint256 _amount) public view returns (uint256) {
2273         return updateMintCost(_amount);
2274     }
2275 
2276     function updateMintCost(uint256 _amount) internal view returns (uint256) {
2277         if (mintClaimed[msg.sender] == false) {
2278             if (_amount == 1) {
2279                 return 0 ether;
2280             } else {
2281                 uint256 ChargedAmt = _amount - 1;
2282                 uint256 totalCost = ChargedAmt * cost;
2283                 return totalCost;
2284             }
2285         } else {
2286             return cost * _amount;
2287         }
2288     }
2289 }