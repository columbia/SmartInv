1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Calldata version of {verify}
40      *
41      * _Available since v4.7._
42      */
43     function verifyCalldata(
44         bytes32[] calldata proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProofCalldata(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
73         bytes32 computedHash = leaf;
74         for (uint256 i = 0; i < proof.length; i++) {
75             computedHash = _hashPair(computedHash, proof[i]);
76         }
77         return computedHash;
78     }
79 
80     /**
81      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * _Available since v4.7._
85      */
86     function multiProofVerify(
87         bytes32[] memory proof,
88         bool[] memory proofFlags,
89         bytes32 root,
90         bytes32[] memory leaves
91     ) internal pure returns (bool) {
92         return processMultiProof(proof, proofFlags, leaves) == root;
93     }
94 
95     /**
96      * @dev Calldata version of {multiProofVerify}
97      *
98      * _Available since v4.7._
99      */
100     function multiProofVerifyCalldata(
101         bytes32[] calldata proof,
102         bool[] calldata proofFlags,
103         bytes32 root,
104         bytes32[] memory leaves
105     ) internal pure returns (bool) {
106         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
107     }
108 
109     /**
110      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
111      * consuming from one or the other at each step according to the instructions given by
112      * `proofFlags`.
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
122         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
123         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
124         // the merkle tree.
125         uint256 leavesLen = leaves.length;
126         uint256 totalHashes = proofFlags.length;
127 
128         // Check proof validity.
129         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
130 
131         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
132         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
133         bytes32[] memory hashes = new bytes32[](totalHashes);
134         uint256 leafPos = 0;
135         uint256 hashPos = 0;
136         uint256 proofPos = 0;
137         // At each step, we compute the next hash using two values:
138         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
139         //   get the next hash.
140         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
141         //   `proof` array.
142         for (uint256 i = 0; i < totalHashes; i++) {
143             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
144             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
145             hashes[i] = _hashPair(a, b);
146         }
147 
148         if (totalHashes > 0) {
149             return hashes[totalHashes - 1];
150         } else if (leavesLen > 0) {
151             return leaves[0];
152         } else {
153             return proof[0];
154         }
155     }
156 
157     /**
158      * @dev Calldata version of {processMultiProof}
159      *
160      * _Available since v4.7._
161      */
162     function processMultiProofCalldata(
163         bytes32[] calldata proof,
164         bool[] calldata proofFlags,
165         bytes32[] memory leaves
166     ) internal pure returns (bytes32 merkleRoot) {
167         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
168         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
169         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
170         // the merkle tree.
171         uint256 leavesLen = leaves.length;
172         uint256 totalHashes = proofFlags.length;
173 
174         // Check proof validity.
175         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
176 
177         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
178         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
179         bytes32[] memory hashes = new bytes32[](totalHashes);
180         uint256 leafPos = 0;
181         uint256 hashPos = 0;
182         uint256 proofPos = 0;
183         // At each step, we compute the next hash using two values:
184         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
185         //   get the next hash.
186         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
187         //   `proof` array.
188         for (uint256 i = 0; i < totalHashes; i++) {
189             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
190             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
191             hashes[i] = _hashPair(a, b);
192         }
193 
194         if (totalHashes > 0) {
195             return hashes[totalHashes - 1];
196         } else if (leavesLen > 0) {
197             return leaves[0];
198         } else {
199             return proof[0];
200         }
201     }
202 
203     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
204         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
205     }
206 
207     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
208         /// @solidity memory-safe-assembly
209         assembly {
210             mstore(0x00, a)
211             mstore(0x20, b)
212             value := keccak256(0x00, 0x40)
213         }
214     }
215 }
216 
217 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Contract module that helps prevent reentrant calls to a function.
226  *
227  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
228  * available, which can be applied to functions to make sure there are no nested
229  * (reentrant) calls to them.
230  *
231  * Note that because there is a single `nonReentrant` guard, functions marked as
232  * `nonReentrant` may not call one another. This can be worked around by making
233  * those functions `private`, and then adding `external` `nonReentrant` entry
234  * points to them.
235  *
236  * TIP: If you would like to learn more about reentrancy and alternative ways
237  * to protect against it, check out our blog post
238  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
239  */
240 abstract contract ReentrancyGuard {
241     // Booleans are more expensive than uint256 or any type that takes up a full
242     // word because each write operation emits an extra SLOAD to first read the
243     // slot's contents, replace the bits taken up by the boolean, and then write
244     // back. This is the compiler's defense against contract upgrades and
245     // pointer aliasing, and it cannot be disabled.
246 
247     // The values being non-zero value makes deployment a bit more expensive,
248     // but in exchange the refund on every call to nonReentrant will be lower in
249     // amount. Since refunds are capped to a percentage of the total
250     // transaction's gas, it is best to keep them low in cases like this one, to
251     // increase the likelihood of the full refund coming into effect.
252     uint256 private constant _NOT_ENTERED = 1;
253     uint256 private constant _ENTERED = 2;
254 
255     uint256 private _status;
256 
257     constructor() {
258         _status = _NOT_ENTERED;
259     }
260 
261     /**
262      * @dev Prevents a contract from calling itself, directly or indirectly.
263      * Calling a `nonReentrant` function from another `nonReentrant`
264      * function is not supported. It is possible to prevent this from happening
265      * by making the `nonReentrant` function external, and making it call a
266      * `private` function that does the actual work.
267      */
268     modifier nonReentrant() {
269         // On the first call to nonReentrant, _notEntered will be true
270         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
271 
272         // Any calls to nonReentrant after this point will fail
273         _status = _ENTERED;
274 
275         _;
276 
277         // By storing the original value once again, a refund is triggered (see
278         // https://eips.ethereum.org/EIPS/eip-2200)
279         _status = _NOT_ENTERED;
280     }
281 }
282 
283 // File: @openzeppelin/contracts/utils/Strings.sol
284 
285 
286 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev String operations.
292  */
293 library Strings {
294     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
295     uint8 private constant _ADDRESS_LENGTH = 20;
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
299      */
300     function toString(uint256 value) internal pure returns (string memory) {
301         // Inspired by OraclizeAPI's implementation - MIT licence
302         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
303 
304         if (value == 0) {
305             return "0";
306         }
307         uint256 temp = value;
308         uint256 digits;
309         while (temp != 0) {
310             digits++;
311             temp /= 10;
312         }
313         bytes memory buffer = new bytes(digits);
314         while (value != 0) {
315             digits -= 1;
316             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
317             value /= 10;
318         }
319         return string(buffer);
320     }
321 
322     /**
323      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
324      */
325     function toHexString(uint256 value) internal pure returns (string memory) {
326         if (value == 0) {
327             return "0x00";
328         }
329         uint256 temp = value;
330         uint256 length = 0;
331         while (temp != 0) {
332             length++;
333             temp >>= 8;
334         }
335         return toHexString(value, length);
336     }
337 
338     /**
339      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
340      */
341     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
342         bytes memory buffer = new bytes(2 * length + 2);
343         buffer[0] = "0";
344         buffer[1] = "x";
345         for (uint256 i = 2 * length + 1; i > 1; --i) {
346             buffer[i] = _HEX_SYMBOLS[value & 0xf];
347             value >>= 4;
348         }
349         require(value == 0, "Strings: hex length insufficient");
350         return string(buffer);
351     }
352 
353     /**
354      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
355      */
356     function toHexString(address addr) internal pure returns (string memory) {
357         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
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
476 // ERC721A Contracts v4.1.0
477 // Creator: Chiru Labs
478 
479 pragma solidity ^0.8.4;
480 
481 /**
482  * @dev Interface of an ERC721A compliant contract.
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
531      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
532      */
533     error TransferToNonERC721ReceiverImplementer();
534 
535     /**
536      * Cannot transfer to the zero address.
537      */
538     error TransferToZeroAddress();
539 
540     /**
541      * The token does not exist.
542      */
543     error URIQueryForNonexistentToken();
544 
545     /**
546      * The `quantity` minted with ERC2309 exceeds the safety limit.
547      */
548     error MintERC2309QuantityExceedsLimit();
549 
550     /**
551      * The `extraData` cannot be set on an unintialized ownership slot.
552      */
553     error OwnershipNotInitializedForExtraData();
554 
555     struct TokenOwnership {
556         // The address of the owner.
557         address addr;
558         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
559         uint64 startTimestamp;
560         // Whether the token has been burned.
561         bool burned;
562         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
563         uint24 extraData;
564     }
565 
566     /**
567      * @dev Returns the total amount of tokens stored by the contract.
568      *
569      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
570      */
571     function totalSupply() external view returns (uint256);
572 
573     // ==============================
574     //            IERC165
575     // ==============================
576 
577     /**
578      * @dev Returns true if this contract implements the interface defined by
579      * `interfaceId`. See the corresponding
580      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
581      * to learn more about how these ids are created.
582      *
583      * This function call must use less than 30 000 gas.
584      */
585     function supportsInterface(bytes4 interfaceId) external view returns (bool);
586 
587     // ==============================
588     //            IERC721
589     // ==============================
590 
591     /**
592      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
593      */
594     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
598      */
599     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
600 
601     /**
602      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
603      */
604     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
605 
606     /**
607      * @dev Returns the number of tokens in ``owner``'s account.
608      */
609     function balanceOf(address owner) external view returns (uint256 balance);
610 
611     /**
612      * @dev Returns the owner of the `tokenId` token.
613      *
614      * Requirements:
615      *
616      * - `tokenId` must exist.
617      */
618     function ownerOf(uint256 tokenId) external view returns (address owner);
619 
620     /**
621      * @dev Safely transfers `tokenId` token from `from` to `to`.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId,
637         bytes calldata data
638     ) external;
639 
640     /**
641      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
642      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must exist and be owned by `from`.
649      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) external;
659 
660     /**
661      * @dev Transfers `tokenId` token from `from` to `to`.
662      *
663      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
664      *
665      * Requirements:
666      *
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      * - `tokenId` token must be owned by `from`.
670      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
671      *
672      * Emits a {Transfer} event.
673      */
674     function transferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) external;
679 
680     /**
681      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
682      * The approval is cleared when the token is transferred.
683      *
684      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
685      *
686      * Requirements:
687      *
688      * - The caller must own the token or be an approved operator.
689      * - `tokenId` must exist.
690      *
691      * Emits an {Approval} event.
692      */
693     function approve(address to, uint256 tokenId) external;
694 
695     /**
696      * @dev Approve or remove `operator` as an operator for the caller.
697      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
698      *
699      * Requirements:
700      *
701      * - The `operator` cannot be the caller.
702      *
703      * Emits an {ApprovalForAll} event.
704      */
705     function setApprovalForAll(address operator, bool _approved) external;
706 
707     /**
708      * @dev Returns the account approved for `tokenId` token.
709      *
710      * Requirements:
711      *
712      * - `tokenId` must exist.
713      */
714     function getApproved(uint256 tokenId) external view returns (address operator);
715 
716     /**
717      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
718      *
719      * See {setApprovalForAll}
720      */
721     function isApprovedForAll(address owner, address operator) external view returns (bool);
722 
723     // ==============================
724     //        IERC721Metadata
725     // ==============================
726 
727     /**
728      * @dev Returns the token collection name.
729      */
730     function name() external view returns (string memory);
731 
732     /**
733      * @dev Returns the token collection symbol.
734      */
735     function symbol() external view returns (string memory);
736 
737     /**
738      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
739      */
740     function tokenURI(uint256 tokenId) external view returns (string memory);
741 
742     // ==============================
743     //            IERC2309
744     // ==============================
745 
746     /**
747      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
748      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
749      */
750     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
751 }
752 
753 // File: erc721a/contracts/ERC721A.sol
754 
755 
756 // ERC721A Contracts v4.1.0
757 // Creator: Chiru Labs
758 
759 pragma solidity ^0.8.4;
760 
761 
762 /**
763  * @dev ERC721 token receiver interface.
764  */
765 interface ERC721A__IERC721Receiver {
766     function onERC721Received(
767         address operator,
768         address from,
769         uint256 tokenId,
770         bytes calldata data
771     ) external returns (bytes4);
772 }
773 
774 /**
775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
776  * including the Metadata extension. Built to optimize for lower gas during batch mints.
777  *
778  * Assumes serials are sequentially minted starting at `_startTokenId()`
779  * (defaults to 0, e.g. 0, 1, 2, 3..).
780  *
781  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
782  *
783  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
784  */
785 contract ERC721A is IERC721A {
786     // Mask of an entry in packed address data.
787     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
788 
789     // The bit position of `numberMinted` in packed address data.
790     uint256 private constant BITPOS_NUMBER_MINTED = 64;
791 
792     // The bit position of `numberBurned` in packed address data.
793     uint256 private constant BITPOS_NUMBER_BURNED = 128;
794 
795     // The bit position of `aux` in packed address data.
796     uint256 private constant BITPOS_AUX = 192;
797 
798     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
799     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
800 
801     // The bit position of `startTimestamp` in packed ownership.
802     uint256 private constant BITPOS_START_TIMESTAMP = 160;
803 
804     // The bit mask of the `burned` bit in packed ownership.
805     uint256 private constant BITMASK_BURNED = 1 << 224;
806 
807     // The bit position of the `nextInitialized` bit in packed ownership.
808     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
809 
810     // The bit mask of the `nextInitialized` bit in packed ownership.
811     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
812 
813     // The bit position of `extraData` in packed ownership.
814     uint256 private constant BITPOS_EXTRA_DATA = 232;
815 
816     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
817     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
818 
819     // The mask of the lower 160 bits for addresses.
820     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
821 
822     // The maximum `quantity` that can be minted with `_mintERC2309`.
823     // This limit is to prevent overflows on the address data entries.
824     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
825     // is required to cause an overflow, which is unrealistic.
826     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
827 
828     // The tokenId of the next token to be minted.
829     uint256 private _currentIndex;
830 
831     // The number of tokens burned.
832     uint256 private _burnCounter;
833 
834     // Token name
835     string private _name;
836 
837     // Token symbol
838     string private _symbol;
839 
840     // Mapping from token ID to ownership details
841     // An empty struct value does not necessarily mean the token is unowned.
842     // See `_packedOwnershipOf` implementation for details.
843     //
844     // Bits Layout:
845     // - [0..159]   `addr`
846     // - [160..223] `startTimestamp`
847     // - [224]      `burned`
848     // - [225]      `nextInitialized`
849     // - [232..255] `extraData`
850     mapping(uint256 => uint256) private _packedOwnerships;
851 
852     // Mapping owner address to address data.
853     //
854     // Bits Layout:
855     // - [0..63]    `balance`
856     // - [64..127]  `numberMinted`
857     // - [128..191] `numberBurned`
858     // - [192..255] `aux`
859     mapping(address => uint256) private _packedAddressData;
860 
861     // Mapping from token ID to approved address.
862     mapping(uint256 => address) private _tokenApprovals;
863 
864     // Mapping from owner to operator approvals
865     mapping(address => mapping(address => bool)) private _operatorApprovals;
866 
867     constructor(string memory name_, string memory symbol_) {
868         _name = name_;
869         _symbol = symbol_;
870         _currentIndex = _startTokenId();
871     }
872 
873     /**
874      * @dev Returns the starting token ID.
875      * To change the starting token ID, please override this function.
876      */
877     function _startTokenId() internal view virtual returns (uint256) {
878         return 0;
879     }
880 
881     /**
882      * @dev Returns the next token ID to be minted.
883      */
884     function _nextTokenId() internal view returns (uint256) {
885         return _currentIndex;
886     }
887 
888     /**
889      * @dev Returns the total number of tokens in existence.
890      * Burned tokens will reduce the count.
891      * To get the total number of tokens minted, please see `_totalMinted`.
892      */
893     function totalSupply() public view override returns (uint256) {
894         // Counter underflow is impossible as _burnCounter cannot be incremented
895         // more than `_currentIndex - _startTokenId()` times.
896         unchecked {
897             return _currentIndex - _burnCounter - _startTokenId();
898         }
899     }
900 
901     /**
902      * @dev Returns the total amount of tokens minted in the contract.
903      */
904     function _totalMinted() internal view returns (uint256) {
905         // Counter underflow is impossible as _currentIndex does not decrement,
906         // and it is initialized to `_startTokenId()`
907         unchecked {
908             return _currentIndex - _startTokenId();
909         }
910     }
911 
912     /**
913      * @dev Returns the total number of tokens burned.
914      */
915     function _totalBurned() internal view returns (uint256) {
916         return _burnCounter;
917     }
918 
919     /**
920      * @dev See {IERC165-supportsInterface}.
921      */
922     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
923         // The interface IDs are constants representing the first 4 bytes of the XOR of
924         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
925         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
926         return
927             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
928             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
929             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
930     }
931 
932     /**
933      * @dev See {IERC721-balanceOf}.
934      */
935     function balanceOf(address owner) public view override returns (uint256) {
936         if (owner == address(0)) revert BalanceQueryForZeroAddress();
937         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
938     }
939 
940     /**
941      * Returns the number of tokens minted by `owner`.
942      */
943     function _numberMinted(address owner) internal view returns (uint256) {
944         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
945     }
946 
947     /**
948      * Returns the number of tokens burned by or on behalf of `owner`.
949      */
950     function _numberBurned(address owner) internal view returns (uint256) {
951         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
952     }
953 
954     /**
955      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
956      */
957     function _getAux(address owner) internal view returns (uint64) {
958         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
959     }
960 
961     /**
962      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
963      * If there are multiple variables, please pack them into a uint64.
964      */
965     function _setAux(address owner, uint64 aux) internal {
966         uint256 packed = _packedAddressData[owner];
967         uint256 auxCasted;
968         // Cast `aux` with assembly to avoid redundant masking.
969         assembly {
970             auxCasted := aux
971         }
972         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
973         _packedAddressData[owner] = packed;
974     }
975 
976     /**
977      * Returns the packed ownership data of `tokenId`.
978      */
979     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
980         uint256 curr = tokenId;
981 
982         unchecked {
983             if (_startTokenId() <= curr)
984                 if (curr < _currentIndex) {
985                     uint256 packed = _packedOwnerships[curr];
986                     // If not burned.
987                     if (packed & BITMASK_BURNED == 0) {
988                         // Invariant:
989                         // There will always be an ownership that has an address and is not burned
990                         // before an ownership that does not have an address and is not burned.
991                         // Hence, curr will not underflow.
992                         //
993                         // We can directly compare the packed value.
994                         // If the address is zero, packed is zero.
995                         while (packed == 0) {
996                             packed = _packedOwnerships[--curr];
997                         }
998                         return packed;
999                     }
1000                 }
1001         }
1002         revert OwnerQueryForNonexistentToken();
1003     }
1004 
1005     /**
1006      * Returns the unpacked `TokenOwnership` struct from `packed`.
1007      */
1008     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1009         ownership.addr = address(uint160(packed));
1010         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1011         ownership.burned = packed & BITMASK_BURNED != 0;
1012         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1013     }
1014 
1015     /**
1016      * Returns the unpacked `TokenOwnership` struct at `index`.
1017      */
1018     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1019         return _unpackedOwnership(_packedOwnerships[index]);
1020     }
1021 
1022     /**
1023      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1024      */
1025     function _initializeOwnershipAt(uint256 index) internal {
1026         if (_packedOwnerships[index] == 0) {
1027             _packedOwnerships[index] = _packedOwnershipOf(index);
1028         }
1029     }
1030 
1031     /**
1032      * Gas spent here starts off proportional to the maximum mint batch size.
1033      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1034      */
1035     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1036         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1037     }
1038 
1039     /**
1040      * @dev Packs ownership data into a single uint256.
1041      */
1042     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1043         assembly {
1044             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1045             owner := and(owner, BITMASK_ADDRESS)
1046             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1047             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1048         }
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-ownerOf}.
1053      */
1054     function ownerOf(uint256 tokenId) public view override returns (address) {
1055         return address(uint160(_packedOwnershipOf(tokenId)));
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Metadata-name}.
1060      */
1061     function name() public view virtual override returns (string memory) {
1062         return _name;
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Metadata-symbol}.
1067      */
1068     function symbol() public view virtual override returns (string memory) {
1069         return _symbol;
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Metadata-tokenURI}.
1074      */
1075     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1076         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1077 
1078         string memory baseURI = _baseURI();
1079         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1080     }
1081 
1082     /**
1083      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1084      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1085      * by default, it can be overridden in child contracts.
1086      */
1087     function _baseURI() internal view virtual returns (string memory) {
1088         return '';
1089     }
1090 
1091     /**
1092      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1093      */
1094     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1095         // For branchless setting of the `nextInitialized` flag.
1096         assembly {
1097             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1098             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1099         }
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-approve}.
1104      */
1105     function approve(address to, uint256 tokenId) public override {
1106         address owner = ownerOf(tokenId);
1107 
1108         if (_msgSenderERC721A() != owner)
1109             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1110                 revert ApprovalCallerNotOwnerNorApproved();
1111             }
1112 
1113         _tokenApprovals[tokenId] = to;
1114         emit Approval(owner, to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-getApproved}.
1119      */
1120     function getApproved(uint256 tokenId) public view override returns (address) {
1121         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1122 
1123         return _tokenApprovals[tokenId];
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-setApprovalForAll}.
1128      */
1129     function setApprovalForAll(address operator, bool approved) public virtual override {
1130         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1131 
1132         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1133         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-isApprovedForAll}.
1138      */
1139     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1140         return _operatorApprovals[owner][operator];
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-safeTransferFrom}.
1145      */
1146     function safeTransferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) public virtual override {
1151         safeTransferFrom(from, to, tokenId, '');
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-safeTransferFrom}.
1156      */
1157     function safeTransferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId,
1161         bytes memory _data
1162     ) public virtual override {
1163         transferFrom(from, to, tokenId);
1164         if (to.code.length != 0)
1165             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1166                 revert TransferToNonERC721ReceiverImplementer();
1167             }
1168     }
1169 
1170     /**
1171      * @dev Returns whether `tokenId` exists.
1172      *
1173      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1174      *
1175      * Tokens start existing when they are minted (`_mint`),
1176      */
1177     function _exists(uint256 tokenId) internal view returns (bool) {
1178         return
1179             _startTokenId() <= tokenId &&
1180             tokenId < _currentIndex && // If within bounds,
1181             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1182     }
1183 
1184     /**
1185      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1186      */
1187     function _safeMint(address to, uint256 quantity) internal {
1188         _safeMint(to, quantity, '');
1189     }
1190 
1191     /**
1192      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1193      *
1194      * Requirements:
1195      *
1196      * - If `to` refers to a smart contract, it must implement
1197      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1198      * - `quantity` must be greater than 0.
1199      *
1200      * See {_mint}.
1201      *
1202      * Emits a {Transfer} event for each mint.
1203      */
1204     function _safeMint(
1205         address to,
1206         uint256 quantity,
1207         bytes memory _data
1208     ) internal {
1209         _mint(to, quantity);
1210 
1211         unchecked {
1212             if (to.code.length != 0) {
1213                 uint256 end = _currentIndex;
1214                 uint256 index = end - quantity;
1215                 do {
1216                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1217                         revert TransferToNonERC721ReceiverImplementer();
1218                     }
1219                 } while (index < end);
1220                 // Reentrancy protection.
1221                 if (_currentIndex != end) revert();
1222             }
1223         }
1224     }
1225 
1226     /**
1227      * @dev Mints `quantity` tokens and transfers them to `to`.
1228      *
1229      * Requirements:
1230      *
1231      * - `to` cannot be the zero address.
1232      * - `quantity` must be greater than 0.
1233      *
1234      * Emits a {Transfer} event for each mint.
1235      */
1236     function _mint(address to, uint256 quantity) internal {
1237         uint256 startTokenId = _currentIndex;
1238         if (to == address(0)) revert MintToZeroAddress();
1239         if (quantity == 0) revert MintZeroQuantity();
1240 
1241         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1242 
1243         // Overflows are incredibly unrealistic.
1244         // `balance` and `numberMinted` have a maximum limit of 2**64.
1245         // `tokenId` has a maximum limit of 2**256.
1246         unchecked {
1247             // Updates:
1248             // - `balance += quantity`.
1249             // - `numberMinted += quantity`.
1250             //
1251             // We can directly add to the `balance` and `numberMinted`.
1252             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1253 
1254             // Updates:
1255             // - `address` to the owner.
1256             // - `startTimestamp` to the timestamp of minting.
1257             // - `burned` to `false`.
1258             // - `nextInitialized` to `quantity == 1`.
1259             _packedOwnerships[startTokenId] = _packOwnershipData(
1260                 to,
1261                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1262             );
1263 
1264             uint256 tokenId = startTokenId;
1265             uint256 end = startTokenId + quantity;
1266             do {
1267                 emit Transfer(address(0), to, tokenId++);
1268             } while (tokenId < end);
1269 
1270             _currentIndex = end;
1271         }
1272         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1273     }
1274 
1275     /**
1276      * @dev Mints `quantity` tokens and transfers them to `to`.
1277      *
1278      * This function is intended for efficient minting only during contract creation.
1279      *
1280      * It emits only one {ConsecutiveTransfer} as defined in
1281      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1282      * instead of a sequence of {Transfer} event(s).
1283      *
1284      * Calling this function outside of contract creation WILL make your contract
1285      * non-compliant with the ERC721 standard.
1286      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1287      * {ConsecutiveTransfer} event is only permissible during contract creation.
1288      *
1289      * Requirements:
1290      *
1291      * - `to` cannot be the zero address.
1292      * - `quantity` must be greater than 0.
1293      *
1294      * Emits a {ConsecutiveTransfer} event.
1295      */
1296     function _mintERC2309(address to, uint256 quantity) internal {
1297         uint256 startTokenId = _currentIndex;
1298         if (to == address(0)) revert MintToZeroAddress();
1299         if (quantity == 0) revert MintZeroQuantity();
1300         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1301 
1302         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1303 
1304         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1305         unchecked {
1306             // Updates:
1307             // - `balance += quantity`.
1308             // - `numberMinted += quantity`.
1309             //
1310             // We can directly add to the `balance` and `numberMinted`.
1311             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1312 
1313             // Updates:
1314             // - `address` to the owner.
1315             // - `startTimestamp` to the timestamp of minting.
1316             // - `burned` to `false`.
1317             // - `nextInitialized` to `quantity == 1`.
1318             _packedOwnerships[startTokenId] = _packOwnershipData(
1319                 to,
1320                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1321             );
1322 
1323             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1324 
1325             _currentIndex = startTokenId + quantity;
1326         }
1327         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1328     }
1329 
1330     /**
1331      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1332      */
1333     function _getApprovedAddress(uint256 tokenId)
1334         private
1335         view
1336         returns (uint256 approvedAddressSlot, address approvedAddress)
1337     {
1338         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1339         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1340         assembly {
1341             // Compute the slot.
1342             mstore(0x00, tokenId)
1343             mstore(0x20, tokenApprovalsPtr.slot)
1344             approvedAddressSlot := keccak256(0x00, 0x40)
1345             // Load the slot's value from storage.
1346             approvedAddress := sload(approvedAddressSlot)
1347         }
1348     }
1349 
1350     /**
1351      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1352      */
1353     function _isOwnerOrApproved(
1354         address approvedAddress,
1355         address from,
1356         address msgSender
1357     ) private pure returns (bool result) {
1358         assembly {
1359             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1360             from := and(from, BITMASK_ADDRESS)
1361             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1362             msgSender := and(msgSender, BITMASK_ADDRESS)
1363             // `msgSender == from || msgSender == approvedAddress`.
1364             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1365         }
1366     }
1367 
1368     /**
1369      * @dev Transfers `tokenId` from `from` to `to`.
1370      *
1371      * Requirements:
1372      *
1373      * - `to` cannot be the zero address.
1374      * - `tokenId` token must be owned by `from`.
1375      *
1376      * Emits a {Transfer} event.
1377      */
1378     function transferFrom(
1379         address from,
1380         address to,
1381         uint256 tokenId
1382     ) public virtual override {
1383         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1384 
1385         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1386 
1387         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1388 
1389         // The nested ifs save around 20+ gas over a compound boolean condition.
1390         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1391             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1392 
1393         if (to == address(0)) revert TransferToZeroAddress();
1394 
1395         _beforeTokenTransfers(from, to, tokenId, 1);
1396 
1397         // Clear approvals from the previous owner.
1398         assembly {
1399             if approvedAddress {
1400                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1401                 sstore(approvedAddressSlot, 0)
1402             }
1403         }
1404 
1405         // Underflow of the sender's balance is impossible because we check for
1406         // ownership above and the recipient's balance can't realistically overflow.
1407         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1408         unchecked {
1409             // We can directly increment and decrement the balances.
1410             --_packedAddressData[from]; // Updates: `balance -= 1`.
1411             ++_packedAddressData[to]; // Updates: `balance += 1`.
1412 
1413             // Updates:
1414             // - `address` to the next owner.
1415             // - `startTimestamp` to the timestamp of transfering.
1416             // - `burned` to `false`.
1417             // - `nextInitialized` to `true`.
1418             _packedOwnerships[tokenId] = _packOwnershipData(
1419                 to,
1420                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1421             );
1422 
1423             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1424             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1425                 uint256 nextTokenId = tokenId + 1;
1426                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1427                 if (_packedOwnerships[nextTokenId] == 0) {
1428                     // If the next slot is within bounds.
1429                     if (nextTokenId != _currentIndex) {
1430                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1431                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1432                     }
1433                 }
1434             }
1435         }
1436 
1437         emit Transfer(from, to, tokenId);
1438         _afterTokenTransfers(from, to, tokenId, 1);
1439     }
1440 
1441     /**
1442      * @dev Equivalent to `_burn(tokenId, false)`.
1443      */
1444     function _burn(uint256 tokenId) internal virtual {
1445         _burn(tokenId, false);
1446     }
1447 
1448     /**
1449      * @dev Destroys `tokenId`.
1450      * The approval is cleared when the token is burned.
1451      *
1452      * Requirements:
1453      *
1454      * - `tokenId` must exist.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1459         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1460 
1461         address from = address(uint160(prevOwnershipPacked));
1462 
1463         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1464 
1465         if (approvalCheck) {
1466             // The nested ifs save around 20+ gas over a compound boolean condition.
1467             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1468                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1469         }
1470 
1471         _beforeTokenTransfers(from, address(0), tokenId, 1);
1472 
1473         // Clear approvals from the previous owner.
1474         assembly {
1475             if approvedAddress {
1476                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1477                 sstore(approvedAddressSlot, 0)
1478             }
1479         }
1480 
1481         // Underflow of the sender's balance is impossible because we check for
1482         // ownership above and the recipient's balance can't realistically overflow.
1483         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1484         unchecked {
1485             // Updates:
1486             // - `balance -= 1`.
1487             // - `numberBurned += 1`.
1488             //
1489             // We can directly decrement the balance, and increment the number burned.
1490             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1491             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1492 
1493             // Updates:
1494             // - `address` to the last owner.
1495             // - `startTimestamp` to the timestamp of burning.
1496             // - `burned` to `true`.
1497             // - `nextInitialized` to `true`.
1498             _packedOwnerships[tokenId] = _packOwnershipData(
1499                 from,
1500                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1501             );
1502 
1503             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1504             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1505                 uint256 nextTokenId = tokenId + 1;
1506                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1507                 if (_packedOwnerships[nextTokenId] == 0) {
1508                     // If the next slot is within bounds.
1509                     if (nextTokenId != _currentIndex) {
1510                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1511                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1512                     }
1513                 }
1514             }
1515         }
1516 
1517         emit Transfer(from, address(0), tokenId);
1518         _afterTokenTransfers(from, address(0), tokenId, 1);
1519 
1520         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1521         unchecked {
1522             _burnCounter++;
1523         }
1524     }
1525 
1526     /**
1527      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1528      *
1529      * @param from address representing the previous owner of the given token ID
1530      * @param to target address that will receive the tokens
1531      * @param tokenId uint256 ID of the token to be transferred
1532      * @param _data bytes optional data to send along with the call
1533      * @return bool whether the call correctly returned the expected magic value
1534      */
1535     function _checkContractOnERC721Received(
1536         address from,
1537         address to,
1538         uint256 tokenId,
1539         bytes memory _data
1540     ) private returns (bool) {
1541         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1542             bytes4 retval
1543         ) {
1544             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1545         } catch (bytes memory reason) {
1546             if (reason.length == 0) {
1547                 revert TransferToNonERC721ReceiverImplementer();
1548             } else {
1549                 assembly {
1550                     revert(add(32, reason), mload(reason))
1551                 }
1552             }
1553         }
1554     }
1555 
1556     /**
1557      * @dev Directly sets the extra data for the ownership data `index`.
1558      */
1559     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1560         uint256 packed = _packedOwnerships[index];
1561         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1562         uint256 extraDataCasted;
1563         // Cast `extraData` with assembly to avoid redundant masking.
1564         assembly {
1565             extraDataCasted := extraData
1566         }
1567         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1568         _packedOwnerships[index] = packed;
1569     }
1570 
1571     /**
1572      * @dev Returns the next extra data for the packed ownership data.
1573      * The returned result is shifted into position.
1574      */
1575     function _nextExtraData(
1576         address from,
1577         address to,
1578         uint256 prevOwnershipPacked
1579     ) private view returns (uint256) {
1580         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1581         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1582     }
1583 
1584     /**
1585      * @dev Called during each token transfer to set the 24bit `extraData` field.
1586      * Intended to be overridden by the cosumer contract.
1587      *
1588      * `previousExtraData` - the value of `extraData` before transfer.
1589      *
1590      * Calling conditions:
1591      *
1592      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1593      * transferred to `to`.
1594      * - When `from` is zero, `tokenId` will be minted for `to`.
1595      * - When `to` is zero, `tokenId` will be burned by `from`.
1596      * - `from` and `to` are never both zero.
1597      */
1598     function _extraData(
1599         address from,
1600         address to,
1601         uint24 previousExtraData
1602     ) internal view virtual returns (uint24) {}
1603 
1604     /**
1605      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1606      * This includes minting.
1607      * And also called before burning one token.
1608      *
1609      * startTokenId - the first token id to be transferred
1610      * quantity - the amount to be transferred
1611      *
1612      * Calling conditions:
1613      *
1614      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1615      * transferred to `to`.
1616      * - When `from` is zero, `tokenId` will be minted for `to`.
1617      * - When `to` is zero, `tokenId` will be burned by `from`.
1618      * - `from` and `to` are never both zero.
1619      */
1620     function _beforeTokenTransfers(
1621         address from,
1622         address to,
1623         uint256 startTokenId,
1624         uint256 quantity
1625     ) internal virtual {}
1626 
1627     /**
1628      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1629      * This includes minting.
1630      * And also called after one token has been burned.
1631      *
1632      * startTokenId - the first token id to be transferred
1633      * quantity - the amount to be transferred
1634      *
1635      * Calling conditions:
1636      *
1637      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1638      * transferred to `to`.
1639      * - When `from` is zero, `tokenId` has been minted for `to`.
1640      * - When `to` is zero, `tokenId` has been burned by `from`.
1641      * - `from` and `to` are never both zero.
1642      */
1643     function _afterTokenTransfers(
1644         address from,
1645         address to,
1646         uint256 startTokenId,
1647         uint256 quantity
1648     ) internal virtual {}
1649 
1650     /**
1651      * @dev Returns the message sender (defaults to `msg.sender`).
1652      *
1653      * If you are writing GSN compatible contracts, you need to override this function.
1654      */
1655     function _msgSenderERC721A() internal view virtual returns (address) {
1656         return msg.sender;
1657     }
1658 
1659     /**
1660      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1661      */
1662     function _toString(uint256 value) internal pure returns (string memory ptr) {
1663         assembly {
1664             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1665             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1666             // We will need 1 32-byte word to store the length,
1667             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1668             ptr := add(mload(0x40), 128)
1669             // Update the free memory pointer to allocate.
1670             mstore(0x40, ptr)
1671 
1672             // Cache the end of the memory to calculate the length later.
1673             let end := ptr
1674 
1675             // We write the string from the rightmost digit to the leftmost digit.
1676             // The following is essentially a do-while loop that also handles the zero case.
1677             // Costs a bit more than early returning for the zero case,
1678             // but cheaper in terms of deployment and overall runtime costs.
1679             for {
1680                 // Initialize and perform the first pass without check.
1681                 let temp := value
1682                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1683                 ptr := sub(ptr, 1)
1684                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1685                 mstore8(ptr, add(48, mod(temp, 10)))
1686                 temp := div(temp, 10)
1687             } temp {
1688                 // Keep dividing `temp` until zero.
1689                 temp := div(temp, 10)
1690             } {
1691                 // Body of the for loop.
1692                 ptr := sub(ptr, 1)
1693                 mstore8(ptr, add(48, mod(temp, 10)))
1694             }
1695 
1696             let length := sub(end, ptr)
1697             // Move the pointer 32 bytes leftwards to make room for the length.
1698             ptr := sub(ptr, 32)
1699             // Store the length.
1700             mstore(ptr, length)
1701         }
1702     }
1703 }
1704 
1705 // File: outsideentitesfinal.sol
1706 
1707 
1708 
1709 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1710 
1711 
1712 
1713 pragma solidity >=0.7.0 <0.9.0;
1714 
1715 
1716 
1717 
1718 
1719 
1720 contract OutsideEntities is ERC721A, Ownable, ReentrancyGuard {
1721   using Strings for uint256;
1722 
1723   string public baseURI;
1724   string public baseExtension = ".json";
1725   uint256 public cost = 0.007 ether;
1726   uint256 public maxSupply = 5000;
1727   uint256 public WlSupply = 2500;
1728   uint256 public MaxperWallet = 3;
1729   uint256 public MaxperWalletWL = 1;
1730   bool public paused = false;
1731   bool public preSale = true;
1732   bool public publicSale = false;
1733   bytes32 public merkleRoot = 0x797d156b828ecdc8e26492154e251c8f4f629468cd0e2c52ed3f989e89463792;
1734 
1735   constructor() ERC721A("Outside Entities", "OE") {
1736     setBaseURI("ipfs://bafybeieoz2jiw5vmfgyzsdoloulsri3ufk2xmu2zoa4ag3psnuadyfgsri/");
1737     _safeMint(_msgSenderERC721A(), 250);
1738   }
1739 
1740   // internal
1741   function _baseURI() internal view virtual override returns (string memory) {
1742     return baseURI;
1743   }
1744       function _startTokenId() internal view virtual override returns (uint256) {
1745         return 1;
1746     }
1747 
1748   // public
1749   /// @dev Public mint 
1750   function mint(uint256 tokens) public payable nonReentrant {
1751     require(!paused, "OE: oops contract is paused");
1752     require(publicSale, "OE: Sale HOE't started yet");
1753     require(tokens <= MaxperWallet, "OE: max mint amount per tx exceeded");
1754     require(totalSupply() + tokens <= maxSupply, "OE: We Soldout");
1755     require(_numberMinted(_msgSenderERC721A()) + tokens <= MaxperWallet, "OE: Max NFT Per Wallet exceeded");
1756     require(msg.value >= cost * tokens, "OE: insufficient funds");
1757 
1758       _safeMint(_msgSenderERC721A(), tokens);
1759   }
1760 
1761 /// @dev presale mint for whitelisted
1762     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public nonReentrant {
1763     require(!paused, "OE: oops contract is paused");
1764     require(preSale, "OE: Presale HOE't started yet");
1765     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "OE: You are not Whitelisted");
1766     require(_numberMinted(_msgSenderERC721A()) + tokens <= MaxperWalletWL, "OE: Max NFT Per Wallet exceeded");
1767     require(tokens <= MaxperWallet, "OE: max mint per Tx exceeded");
1768     require(totalSupply() + tokens <= WlSupply, "OE: Whitelist MaxSupply exceeded");
1769 
1770       _safeMint(_msgSenderERC721A(), tokens);
1771     
1772   }
1773 
1774   /// @dev use it for giveaway and team mint
1775      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
1776     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1777 
1778       _safeMint(destination, _mintAmount);
1779   }
1780 
1781 /// @notice returns metadata link of tokenid
1782   function tokenURI(uint256 tokenId)
1783     public
1784     view
1785     virtual
1786     override
1787     returns (string memory)
1788   {
1789     require(
1790       _exists(tokenId),
1791       "ERC721AMetadata: URI query for nonexistent token"
1792     );
1793     string memory currentBaseURI = _baseURI();
1794     return bytes(currentBaseURI).length > 0
1795         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1796         : "";
1797   }
1798 
1799      /// @notice return the number minted by an address
1800     function numberMinted(address owner) public view returns (uint256) {
1801     return _numberMinted(owner);
1802   }
1803 
1804     /// @notice return the tokens owned by an address
1805       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1806         unchecked {
1807             uint256 tokenIdsIdx;
1808             address currOwnershipAddr;
1809             uint256 tokenIdsLength = balanceOf(owner);
1810             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1811             TokenOwnership memory ownership;
1812             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1813                 ownership = _ownershipAt(i);
1814                 if (ownership.burned) {
1815                     continue;
1816                 }
1817                 if (ownership.addr != address(0)) {
1818                     currOwnershipAddr = ownership.addr;
1819                 }
1820                 if (currOwnershipAddr == owner) {
1821                     tokenIds[tokenIdsIdx++] = i;
1822                 }
1823             }
1824             return tokenIds;
1825         }
1826     }
1827 
1828   //only owner
1829     /// @dev change the merkle root for the whitelist phase
1830   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1831         merkleRoot = _merkleRoot;
1832     }
1833 
1834   /// @dev change the public max per wallet
1835   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1836     MaxperWallet = _limit;
1837   }
1838 
1839     /// @dev change the wl max per wallet
1840   function setWLMaxPerWallet(uint256 _limit) public onlyOwner {
1841     MaxperWalletWL = _limit;
1842   }
1843   
1844    /// @dev change the public price(amount need to be in wei)
1845   function setCost(uint256 _newCost) public onlyOwner {
1846     cost = _newCost;
1847   }
1848   
1849   /// @dev cut the supply if we dont sold out
1850     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1851     maxSupply = _newsupply;
1852   }
1853 
1854  /// @dev cut the whitelist supply if we dont sold out
1855     function setwlsupply(uint256 _newsupply) public onlyOwner {
1856     WlSupply = _newsupply;
1857   }
1858 
1859  /// @dev set your baseuri
1860   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1861     baseURI = _newBaseURI;
1862   }
1863 
1864   /// @dev set base extension(default is .json)
1865   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1866     baseExtension = _newBaseExtension;
1867   }
1868 
1869  /// @dev to pause and unpause your contract(use booleans true or false)
1870   function pause(bool _state) public onlyOwner {
1871     paused = _state;
1872   }
1873 
1874      /// @dev activate whitelist sale(use booleans true or false)
1875     function togglepreSale(bool _state) external onlyOwner {
1876         preSale = _state;
1877     }
1878 
1879     /// @dev activate public sale(use booleans true or false)
1880     function togglepublicSale(bool _state) external onlyOwner {
1881         publicSale = _state;
1882     }
1883   
1884   /// @dev withdraw funds from contract
1885   function withdraw() public payable onlyOwner nonReentrant {
1886       uint256 balance = address(this).balance;
1887       payable(_msgSenderERC721A()).transfer(balance);
1888   }
1889 }