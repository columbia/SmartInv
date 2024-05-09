1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Strings.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev String operations.
77  */
78 library Strings {
79     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
80     uint8 private constant _ADDRESS_LENGTH = 20;
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 
138     /**
139      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
140      */
141     function toHexString(address addr) internal pure returns (string memory) {
142         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/Context.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes calldata) {
169         return msg.data;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/access/Ownable.sol
174 
175 
176 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 
181 /**
182  * @dev Contract module which provides a basic access control mechanism, where
183  * there is an account (an owner) that can be granted exclusive access to
184  * specific functions.
185  *
186  * By default, the owner account will be the one that deploys the contract. This
187  * can later be changed with {transferOwnership}.
188  *
189  * This module is used through inheritance. It will make available the modifier
190  * `onlyOwner`, which can be applied to your functions to restrict their use to
191  * the owner.
192  */
193 abstract contract Ownable is Context {
194     address private _owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199      * @dev Initializes the contract setting the deployer as the initial owner.
200      */
201     constructor() {
202         _transferOwnership(_msgSender());
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         _checkOwner();
210         _;
211     }
212 
213     /**
214      * @dev Returns the address of the current owner.
215      */
216     function owner() public view virtual returns (address) {
217         return _owner;
218     }
219 
220     /**
221      * @dev Throws if the sender is not the owner.
222      */
223     function _checkOwner() internal view virtual {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225     }
226 
227     /**
228      * @dev Leaves the contract without owner. It will not be possible to call
229      * `onlyOwner` functions anymore. Can only be called by the current owner.
230      *
231      * NOTE: Renouncing ownership will leave the contract without an owner,
232      * thereby removing any functionality that is only available to the owner.
233      */
234     function renounceOwnership() public virtual onlyOwner {
235         _transferOwnership(address(0));
236     }
237 
238     /**
239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
240      * Can only be called by the current owner.
241      */
242     function transferOwnership(address newOwner) public virtual onlyOwner {
243         require(newOwner != address(0), "Ownable: new owner is the zero address");
244         _transferOwnership(newOwner);
245     }
246 
247     /**
248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
249      * Internal function without access restriction.
250      */
251     function _transferOwnership(address newOwner) internal virtual {
252         address oldOwner = _owner;
253         _owner = newOwner;
254         emit OwnershipTransferred(oldOwner, newOwner);
255     }
256 }
257 
258 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
259 
260 
261 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev These functions deal with verification of Merkle Tree proofs.
267  *
268  * The proofs can be generated using the JavaScript library
269  * https://github.com/miguelmota/merkletreejs[merkletreejs].
270  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
271  *
272  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
273  *
274  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
275  * hashing, or use a hash function other than keccak256 for hashing leaves.
276  * This is because the concatenation of a sorted pair of internal nodes in
277  * the merkle tree could be reinterpreted as a leaf value.
278  */
279 library MerkleProof {
280     /**
281      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
282      * defined by `root`. For this, a `proof` must be provided, containing
283      * sibling hashes on the branch from the leaf to the root of the tree. Each
284      * pair of leaves and each pair of pre-images are assumed to be sorted.
285      */
286     function verify(
287         bytes32[] memory proof,
288         bytes32 root,
289         bytes32 leaf
290     ) internal pure returns (bool) {
291         return processProof(proof, leaf) == root;
292     }
293 
294     /**
295      * @dev Calldata version of {verify}
296      *
297      * _Available since v4.7._
298      */
299     function verifyCalldata(
300         bytes32[] calldata proof,
301         bytes32 root,
302         bytes32 leaf
303     ) internal pure returns (bool) {
304         return processProofCalldata(proof, leaf) == root;
305     }
306 
307     /**
308      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
309      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
310      * hash matches the root of the tree. When processing the proof, the pairs
311      * of leafs & pre-images are assumed to be sorted.
312      *
313      * _Available since v4.4._
314      */
315     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
316         bytes32 computedHash = leaf;
317         for (uint256 i = 0; i < proof.length; i++) {
318             computedHash = _hashPair(computedHash, proof[i]);
319         }
320         return computedHash;
321     }
322 
323     /**
324      * @dev Calldata version of {processProof}
325      *
326      * _Available since v4.7._
327      */
328     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
329         bytes32 computedHash = leaf;
330         for (uint256 i = 0; i < proof.length; i++) {
331             computedHash = _hashPair(computedHash, proof[i]);
332         }
333         return computedHash;
334     }
335 
336     /**
337      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
338      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
339      *
340      * _Available since v4.7._
341      */
342     function multiProofVerify(
343         bytes32[] memory proof,
344         bool[] memory proofFlags,
345         bytes32 root,
346         bytes32[] memory leaves
347     ) internal pure returns (bool) {
348         return processMultiProof(proof, proofFlags, leaves) == root;
349     }
350 
351     /**
352      * @dev Calldata version of {multiProofVerify}
353      *
354      * _Available since v4.7._
355      */
356     function multiProofVerifyCalldata(
357         bytes32[] calldata proof,
358         bool[] calldata proofFlags,
359         bytes32 root,
360         bytes32[] memory leaves
361     ) internal pure returns (bool) {
362         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
363     }
364 
365     /**
366      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
367      * consuming from one or the other at each step according to the instructions given by
368      * `proofFlags`.
369      *
370      * _Available since v4.7._
371      */
372     function processMultiProof(
373         bytes32[] memory proof,
374         bool[] memory proofFlags,
375         bytes32[] memory leaves
376     ) internal pure returns (bytes32 merkleRoot) {
377         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
378         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
379         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
380         // the merkle tree.
381         uint256 leavesLen = leaves.length;
382         uint256 totalHashes = proofFlags.length;
383 
384         // Check proof validity.
385         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
386 
387         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
388         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
389         bytes32[] memory hashes = new bytes32[](totalHashes);
390         uint256 leafPos = 0;
391         uint256 hashPos = 0;
392         uint256 proofPos = 0;
393         // At each step, we compute the next hash using two values:
394         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
395         //   get the next hash.
396         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
397         //   `proof` array.
398         for (uint256 i = 0; i < totalHashes; i++) {
399             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
400             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
401             hashes[i] = _hashPair(a, b);
402         }
403 
404         if (totalHashes > 0) {
405             return hashes[totalHashes - 1];
406         } else if (leavesLen > 0) {
407             return leaves[0];
408         } else {
409             return proof[0];
410         }
411     }
412 
413     /**
414      * @dev Calldata version of {processMultiProof}
415      *
416      * _Available since v4.7._
417      */
418     function processMultiProofCalldata(
419         bytes32[] calldata proof,
420         bool[] calldata proofFlags,
421         bytes32[] memory leaves
422     ) internal pure returns (bytes32 merkleRoot) {
423         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
424         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
425         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
426         // the merkle tree.
427         uint256 leavesLen = leaves.length;
428         uint256 totalHashes = proofFlags.length;
429 
430         // Check proof validity.
431         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
432 
433         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
434         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
435         bytes32[] memory hashes = new bytes32[](totalHashes);
436         uint256 leafPos = 0;
437         uint256 hashPos = 0;
438         uint256 proofPos = 0;
439         // At each step, we compute the next hash using two values:
440         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
441         //   get the next hash.
442         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
443         //   `proof` array.
444         for (uint256 i = 0; i < totalHashes; i++) {
445             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
446             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
447             hashes[i] = _hashPair(a, b);
448         }
449 
450         if (totalHashes > 0) {
451             return hashes[totalHashes - 1];
452         } else if (leavesLen > 0) {
453             return leaves[0];
454         } else {
455             return proof[0];
456         }
457     }
458 
459     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
460         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
461     }
462 
463     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
464         /// @solidity memory-safe-assembly
465         assembly {
466             mstore(0x00, a)
467             mstore(0x20, b)
468             value := keccak256(0x00, 0x40)
469         }
470     }
471 }
472 
473 // File: erc721a/contracts/IERC721A.sol
474 
475 
476 // ERC721A Contracts v4.2.3
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
496      * Cannot query the balance for the zero address.
497      */
498     error BalanceQueryForZeroAddress();
499 
500     /**
501      * Cannot mint to the zero address.
502      */
503     error MintToZeroAddress();
504 
505     /**
506      * The quantity of tokens minted must be more than zero.
507      */
508     error MintZeroQuantity();
509 
510     /**
511      * The token does not exist.
512      */
513     error OwnerQueryForNonexistentToken();
514 
515     /**
516      * The caller must own the token or be an approved operator.
517      */
518     error TransferCallerNotOwnerNorApproved();
519 
520     /**
521      * The token must be owned by `from`.
522      */
523     error TransferFromIncorrectOwner();
524 
525     /**
526      * Cannot safely transfer to a contract that does not implement the
527      * ERC721Receiver interface.
528      */
529     error TransferToNonERC721ReceiverImplementer();
530 
531     /**
532      * Cannot transfer to the zero address.
533      */
534     error TransferToZeroAddress();
535 
536     /**
537      * The token does not exist.
538      */
539     error URIQueryForNonexistentToken();
540 
541     /**
542      * The `quantity` minted with ERC2309 exceeds the safety limit.
543      */
544     error MintERC2309QuantityExceedsLimit();
545 
546     /**
547      * The `extraData` cannot be set on an unintialized ownership slot.
548      */
549     error OwnershipNotInitializedForExtraData();
550 
551     // =============================================================
552     //                            STRUCTS
553     // =============================================================
554 
555     struct TokenOwnership {
556         // The address of the owner.
557         address addr;
558         // Stores the start time of ownership with minimal overhead for tokenomics.
559         uint64 startTimestamp;
560         // Whether the token has been burned.
561         bool burned;
562         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
563         uint24 extraData;
564     }
565 
566     // =============================================================
567     //                         TOKEN COUNTERS
568     // =============================================================
569 
570     /**
571      * @dev Returns the total number of tokens in existence.
572      * Burned tokens will reduce the count.
573      * To get the total number of tokens minted, please see {_totalMinted}.
574      */
575     function totalSupply() external view returns (uint256);
576 
577     // =============================================================
578     //                            IERC165
579     // =============================================================
580 
581     /**
582      * @dev Returns true if this contract implements the interface defined by
583      * `interfaceId`. See the corresponding
584      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
585      * to learn more about how these ids are created.
586      *
587      * This function call must use less than 30000 gas.
588      */
589     function supportsInterface(bytes4 interfaceId) external view returns (bool);
590 
591     // =============================================================
592     //                            IERC721
593     // =============================================================
594 
595     /**
596      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
597      */
598     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
602      */
603     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
604 
605     /**
606      * @dev Emitted when `owner` enables or disables
607      * (`approved`) `operator` to manage all of its assets.
608      */
609     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
610 
611     /**
612      * @dev Returns the number of tokens in `owner`'s account.
613      */
614     function balanceOf(address owner) external view returns (uint256 balance);
615 
616     /**
617      * @dev Returns the owner of the `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function ownerOf(uint256 tokenId) external view returns (address owner);
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`,
627      * checking first that contract recipients are aware of the ERC721 protocol
628      * to prevent tokens from being forever locked.
629      *
630      * Requirements:
631      *
632      * - `from` cannot be the zero address.
633      * - `to` cannot be the zero address.
634      * - `tokenId` token must exist and be owned by `from`.
635      * - If the caller is not `from`, it must be have been allowed to move
636      * this token by either {approve} or {setApprovalForAll}.
637      * - If `to` refers to a smart contract, it must implement
638      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
639      *
640      * Emits a {Transfer} event.
641      */
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId,
646         bytes calldata data
647     ) external payable;
648 
649     /**
650      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external payable;
657 
658     /**
659      * @dev Transfers `tokenId` from `from` to `to`.
660      *
661      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
662      * whenever possible.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must be owned by `from`.
669      * - If the caller is not `from`, it must be approved to move this token
670      * by either {approve} or {setApprovalForAll}.
671      *
672      * Emits a {Transfer} event.
673      */
674     function transferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) external payable;
679 
680     /**
681      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
682      * The approval is cleared when the token is transferred.
683      *
684      * Only a single account can be approved at a time, so approving the
685      * zero address clears previous approvals.
686      *
687      * Requirements:
688      *
689      * - The caller must own the token or be an approved operator.
690      * - `tokenId` must exist.
691      *
692      * Emits an {Approval} event.
693      */
694     function approve(address to, uint256 tokenId) external payable;
695 
696     /**
697      * @dev Approve or remove `operator` as an operator for the caller.
698      * Operators can call {transferFrom} or {safeTransferFrom}
699      * for any token owned by the caller.
700      *
701      * Requirements:
702      *
703      * - The `operator` cannot be the caller.
704      *
705      * Emits an {ApprovalForAll} event.
706      */
707     function setApprovalForAll(address operator, bool _approved) external;
708 
709     /**
710      * @dev Returns the account approved for `tokenId` token.
711      *
712      * Requirements:
713      *
714      * - `tokenId` must exist.
715      */
716     function getApproved(uint256 tokenId) external view returns (address operator);
717 
718     /**
719      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
720      *
721      * See {setApprovalForAll}.
722      */
723     function isApprovedForAll(address owner, address operator) external view returns (bool);
724 
725     // =============================================================
726     //                        IERC721Metadata
727     // =============================================================
728 
729     /**
730      * @dev Returns the token collection name.
731      */
732     function name() external view returns (string memory);
733 
734     /**
735      * @dev Returns the token collection symbol.
736      */
737     function symbol() external view returns (string memory);
738 
739     /**
740      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
741      */
742     function tokenURI(uint256 tokenId) external view returns (string memory);
743 
744     // =============================================================
745     //                           IERC2309
746     // =============================================================
747 
748     /**
749      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
750      * (inclusive) is transferred from `from` to `to`, as defined in the
751      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
752      *
753      * See {_mintERC2309} for more details.
754      */
755     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
756 }
757 
758 // File: erc721a/contracts/ERC721A.sol
759 
760 
761 // ERC721A Contracts v4.2.3
762 // Creator: Chiru Labs
763 
764 pragma solidity ^0.8.4;
765 
766 
767 /**
768  * @dev Interface of ERC721 token receiver.
769  */
770 interface ERC721A__IERC721Receiver {
771     function onERC721Received(
772         address operator,
773         address from,
774         uint256 tokenId,
775         bytes calldata data
776     ) external returns (bytes4);
777 }
778 
779 /**
780  * @title ERC721A
781  *
782  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
783  * Non-Fungible Token Standard, including the Metadata extension.
784  * Optimized for lower gas during batch mints.
785  *
786  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
787  * starting from `_startTokenId()`.
788  *
789  * Assumptions:
790  *
791  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
792  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
793  */
794 contract ERC721A is IERC721A {
795     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
796     struct TokenApprovalRef {
797         address value;
798     }
799 
800     // =============================================================
801     //                           CONSTANTS
802     // =============================================================
803 
804     // Mask of an entry in packed address data.
805     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
806 
807     // The bit position of `numberMinted` in packed address data.
808     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
809 
810     // The bit position of `numberBurned` in packed address data.
811     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
812 
813     // The bit position of `aux` in packed address data.
814     uint256 private constant _BITPOS_AUX = 192;
815 
816     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
817     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
818 
819     // The bit position of `startTimestamp` in packed ownership.
820     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
821 
822     // The bit mask of the `burned` bit in packed ownership.
823     uint256 private constant _BITMASK_BURNED = 1 << 224;
824 
825     // The bit position of the `nextInitialized` bit in packed ownership.
826     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
827 
828     // The bit mask of the `nextInitialized` bit in packed ownership.
829     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
830 
831     // The bit position of `extraData` in packed ownership.
832     uint256 private constant _BITPOS_EXTRA_DATA = 232;
833 
834     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
835     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
836 
837     // The mask of the lower 160 bits for addresses.
838     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
839 
840     // The maximum `quantity` that can be minted with {_mintERC2309}.
841     // This limit is to prevent overflows on the address data entries.
842     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
843     // is required to cause an overflow, which is unrealistic.
844     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
845 
846     // The `Transfer` event signature is given by:
847     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
848     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
849         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
850 
851     // =============================================================
852     //                            STORAGE
853     // =============================================================
854 
855     // The next token ID to be minted.
856     uint256 private _currentIndex;
857 
858     // The number of tokens burned.
859     uint256 private _burnCounter;
860 
861     // Token name
862     string private _name;
863 
864     // Token symbol
865     string private _symbol;
866 
867     // Mapping from token ID to ownership details
868     // An empty struct value does not necessarily mean the token is unowned.
869     // See {_packedOwnershipOf} implementation for details.
870     //
871     // Bits Layout:
872     // - [0..159]   `addr`
873     // - [160..223] `startTimestamp`
874     // - [224]      `burned`
875     // - [225]      `nextInitialized`
876     // - [232..255] `extraData`
877     mapping(uint256 => uint256) private _packedOwnerships;
878 
879     // Mapping owner address to address data.
880     //
881     // Bits Layout:
882     // - [0..63]    `balance`
883     // - [64..127]  `numberMinted`
884     // - [128..191] `numberBurned`
885     // - [192..255] `aux`
886     mapping(address => uint256) private _packedAddressData;
887 
888     // Mapping from token ID to approved address.
889     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
890 
891     // Mapping from owner to operator approvals
892     mapping(address => mapping(address => bool)) private _operatorApprovals;
893 
894     // =============================================================
895     //                          CONSTRUCTOR
896     // =============================================================
897 
898     constructor(string memory name_, string memory symbol_) {
899         _name = name_;
900         _symbol = symbol_;
901         _currentIndex = _startTokenId();
902     }
903 
904     // =============================================================
905     //                   TOKEN COUNTING OPERATIONS
906     // =============================================================
907 
908     /**
909      * @dev Returns the starting token ID.
910      * To change the starting token ID, please override this function.
911      */
912     function _startTokenId() internal view virtual returns (uint256) {
913         return 0;
914     }
915 
916     /**
917      * @dev Returns the next token ID to be minted.
918      */
919     function _nextTokenId() internal view virtual returns (uint256) {
920         return _currentIndex;
921     }
922 
923     /**
924      * @dev Returns the total number of tokens in existence.
925      * Burned tokens will reduce the count.
926      * To get the total number of tokens minted, please see {_totalMinted}.
927      */
928     function totalSupply() public view virtual override returns (uint256) {
929         // Counter underflow is impossible as _burnCounter cannot be incremented
930         // more than `_currentIndex - _startTokenId()` times.
931         unchecked {
932             return _currentIndex - _burnCounter - _startTokenId();
933         }
934     }
935 
936     /**
937      * @dev Returns the total amount of tokens minted in the contract.
938      */
939     function _totalMinted() internal view virtual returns (uint256) {
940         // Counter underflow is impossible as `_currentIndex` does not decrement,
941         // and it is initialized to `_startTokenId()`.
942         unchecked {
943             return _currentIndex - _startTokenId();
944         }
945     }
946 
947     /**
948      * @dev Returns the total number of tokens burned.
949      */
950     function _totalBurned() internal view virtual returns (uint256) {
951         return _burnCounter;
952     }
953 
954     // =============================================================
955     //                    ADDRESS DATA OPERATIONS
956     // =============================================================
957 
958     /**
959      * @dev Returns the number of tokens in `owner`'s account.
960      */
961     function balanceOf(address owner) public view virtual override returns (uint256) {
962         if (owner == address(0)) revert BalanceQueryForZeroAddress();
963         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
964     }
965 
966     /**
967      * Returns the number of tokens minted by `owner`.
968      */
969     function _numberMinted(address owner) internal view returns (uint256) {
970         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
971     }
972 
973     /**
974      * Returns the number of tokens burned by or on behalf of `owner`.
975      */
976     function _numberBurned(address owner) internal view returns (uint256) {
977         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
978     }
979 
980     /**
981      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
982      */
983     function _getAux(address owner) internal view returns (uint64) {
984         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
985     }
986 
987     /**
988      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
989      * If there are multiple variables, please pack them into a uint64.
990      */
991     function _setAux(address owner, uint64 aux) internal virtual {
992         uint256 packed = _packedAddressData[owner];
993         uint256 auxCasted;
994         // Cast `aux` with assembly to avoid redundant masking.
995         assembly {
996             auxCasted := aux
997         }
998         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
999         _packedAddressData[owner] = packed;
1000     }
1001 
1002     // =============================================================
1003     //                            IERC165
1004     // =============================================================
1005 
1006     /**
1007      * @dev Returns true if this contract implements the interface defined by
1008      * `interfaceId`. See the corresponding
1009      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1010      * to learn more about how these ids are created.
1011      *
1012      * This function call must use less than 30000 gas.
1013      */
1014     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1015         // The interface IDs are constants representing the first 4 bytes
1016         // of the XOR of all function selectors in the interface.
1017         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1018         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1019         return
1020             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1021             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1022             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1023     }
1024 
1025     // =============================================================
1026     //                        IERC721Metadata
1027     // =============================================================
1028 
1029     /**
1030      * @dev Returns the token collection name.
1031      */
1032     function name() public view virtual override returns (string memory) {
1033         return _name;
1034     }
1035 
1036     /**
1037      * @dev Returns the token collection symbol.
1038      */
1039     function symbol() public view virtual override returns (string memory) {
1040         return _symbol;
1041     }
1042 
1043     /**
1044      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1045      */
1046     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1047         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1048 
1049         string memory baseURI = _baseURI();
1050         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1051     }
1052 
1053     /**
1054      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1055      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1056      * by default, it can be overridden in child contracts.
1057      */
1058     function _baseURI() internal view virtual returns (string memory) {
1059         return '';
1060     }
1061 
1062     // =============================================================
1063     //                     OWNERSHIPS OPERATIONS
1064     // =============================================================
1065 
1066     /**
1067      * @dev Returns the owner of the `tokenId` token.
1068      *
1069      * Requirements:
1070      *
1071      * - `tokenId` must exist.
1072      */
1073     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1074         return address(uint160(_packedOwnershipOf(tokenId)));
1075     }
1076 
1077     /**
1078      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1079      * It gradually moves to O(1) as tokens get transferred around over time.
1080      */
1081     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1082         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1083     }
1084 
1085     /**
1086      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1087      */
1088     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1089         return _unpackedOwnership(_packedOwnerships[index]);
1090     }
1091 
1092     /**
1093      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1094      */
1095     function _initializeOwnershipAt(uint256 index) internal virtual {
1096         if (_packedOwnerships[index] == 0) {
1097             _packedOwnerships[index] = _packedOwnershipOf(index);
1098         }
1099     }
1100 
1101     /**
1102      * Returns the packed ownership data of `tokenId`.
1103      */
1104     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1105         uint256 curr = tokenId;
1106 
1107         unchecked {
1108             if (_startTokenId() <= curr)
1109                 if (curr < _currentIndex) {
1110                     uint256 packed = _packedOwnerships[curr];
1111                     // If not burned.
1112                     if (packed & _BITMASK_BURNED == 0) {
1113                         // Invariant:
1114                         // There will always be an initialized ownership slot
1115                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1116                         // before an unintialized ownership slot
1117                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1118                         // Hence, `curr` will not underflow.
1119                         //
1120                         // We can directly compare the packed value.
1121                         // If the address is zero, packed will be zero.
1122                         while (packed == 0) {
1123                             packed = _packedOwnerships[--curr];
1124                         }
1125                         return packed;
1126                     }
1127                 }
1128         }
1129         revert OwnerQueryForNonexistentToken();
1130     }
1131 
1132     /**
1133      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1134      */
1135     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1136         ownership.addr = address(uint160(packed));
1137         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1138         ownership.burned = packed & _BITMASK_BURNED != 0;
1139         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1140     }
1141 
1142     /**
1143      * @dev Packs ownership data into a single uint256.
1144      */
1145     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1146         assembly {
1147             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1148             owner := and(owner, _BITMASK_ADDRESS)
1149             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1150             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1151         }
1152     }
1153 
1154     /**
1155      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1156      */
1157     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1158         // For branchless setting of the `nextInitialized` flag.
1159         assembly {
1160             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1161             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1162         }
1163     }
1164 
1165     // =============================================================
1166     //                      APPROVAL OPERATIONS
1167     // =============================================================
1168 
1169     /**
1170      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1171      * The approval is cleared when the token is transferred.
1172      *
1173      * Only a single account can be approved at a time, so approving the
1174      * zero address clears previous approvals.
1175      *
1176      * Requirements:
1177      *
1178      * - The caller must own the token or be an approved operator.
1179      * - `tokenId` must exist.
1180      *
1181      * Emits an {Approval} event.
1182      */
1183     function approve(address to, uint256 tokenId) public payable virtual override {
1184         address owner = ownerOf(tokenId);
1185 
1186         if (_msgSenderERC721A() != owner)
1187             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1188                 revert ApprovalCallerNotOwnerNorApproved();
1189             }
1190 
1191         _tokenApprovals[tokenId].value = to;
1192         emit Approval(owner, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Returns the account approved for `tokenId` token.
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must exist.
1201      */
1202     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1203         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1204 
1205         return _tokenApprovals[tokenId].value;
1206     }
1207 
1208     /**
1209      * @dev Approve or remove `operator` as an operator for the caller.
1210      * Operators can call {transferFrom} or {safeTransferFrom}
1211      * for any token owned by the caller.
1212      *
1213      * Requirements:
1214      *
1215      * - The `operator` cannot be the caller.
1216      *
1217      * Emits an {ApprovalForAll} event.
1218      */
1219     function setApprovalForAll(address operator, bool approved) public virtual override {
1220         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1221         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1222     }
1223 
1224     /**
1225      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1226      *
1227      * See {setApprovalForAll}.
1228      */
1229     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1230         return _operatorApprovals[owner][operator];
1231     }
1232 
1233     /**
1234      * @dev Returns whether `tokenId` exists.
1235      *
1236      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1237      *
1238      * Tokens start existing when they are minted. See {_mint}.
1239      */
1240     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1241         return
1242             _startTokenId() <= tokenId &&
1243             tokenId < _currentIndex && // If within bounds,
1244             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1245     }
1246 
1247     /**
1248      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1249      */
1250     function _isSenderApprovedOrOwner(
1251         address approvedAddress,
1252         address owner,
1253         address msgSender
1254     ) private pure returns (bool result) {
1255         assembly {
1256             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1257             owner := and(owner, _BITMASK_ADDRESS)
1258             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1259             msgSender := and(msgSender, _BITMASK_ADDRESS)
1260             // `msgSender == owner || msgSender == approvedAddress`.
1261             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1262         }
1263     }
1264 
1265     /**
1266      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1267      */
1268     function _getApprovedSlotAndAddress(uint256 tokenId)
1269         private
1270         view
1271         returns (uint256 approvedAddressSlot, address approvedAddress)
1272     {
1273         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1274         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1275         assembly {
1276             approvedAddressSlot := tokenApproval.slot
1277             approvedAddress := sload(approvedAddressSlot)
1278         }
1279     }
1280 
1281     // =============================================================
1282     //                      TRANSFER OPERATIONS
1283     // =============================================================
1284 
1285     /**
1286      * @dev Transfers `tokenId` from `from` to `to`.
1287      *
1288      * Requirements:
1289      *
1290      * - `from` cannot be the zero address.
1291      * - `to` cannot be the zero address.
1292      * - `tokenId` token must be owned by `from`.
1293      * - If the caller is not `from`, it must be approved to move this token
1294      * by either {approve} or {setApprovalForAll}.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function transferFrom(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) public payable virtual override {
1303         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1304 
1305         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1306 
1307         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1308 
1309         // The nested ifs save around 20+ gas over a compound boolean condition.
1310         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1311             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1312 
1313         if (to == address(0)) revert TransferToZeroAddress();
1314 
1315         _beforeTokenTransfers(from, to, tokenId, 1);
1316 
1317         // Clear approvals from the previous owner.
1318         assembly {
1319             if approvedAddress {
1320                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1321                 sstore(approvedAddressSlot, 0)
1322             }
1323         }
1324 
1325         // Underflow of the sender's balance is impossible because we check for
1326         // ownership above and the recipient's balance can't realistically overflow.
1327         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1328         unchecked {
1329             // We can directly increment and decrement the balances.
1330             --_packedAddressData[from]; // Updates: `balance -= 1`.
1331             ++_packedAddressData[to]; // Updates: `balance += 1`.
1332 
1333             // Updates:
1334             // - `address` to the next owner.
1335             // - `startTimestamp` to the timestamp of transfering.
1336             // - `burned` to `false`.
1337             // - `nextInitialized` to `true`.
1338             _packedOwnerships[tokenId] = _packOwnershipData(
1339                 to,
1340                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1341             );
1342 
1343             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1344             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1345                 uint256 nextTokenId = tokenId + 1;
1346                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1347                 if (_packedOwnerships[nextTokenId] == 0) {
1348                     // If the next slot is within bounds.
1349                     if (nextTokenId != _currentIndex) {
1350                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1351                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1352                     }
1353                 }
1354             }
1355         }
1356 
1357         emit Transfer(from, to, tokenId);
1358         _afterTokenTransfers(from, to, tokenId, 1);
1359     }
1360 
1361     /**
1362      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1363      */
1364     function safeTransferFrom(
1365         address from,
1366         address to,
1367         uint256 tokenId
1368     ) public payable virtual override {
1369         safeTransferFrom(from, to, tokenId, '');
1370     }
1371 
1372     /**
1373      * @dev Safely transfers `tokenId` token from `from` to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - `from` cannot be the zero address.
1378      * - `to` cannot be the zero address.
1379      * - `tokenId` token must exist and be owned by `from`.
1380      * - If the caller is not `from`, it must be approved to move this token
1381      * by either {approve} or {setApprovalForAll}.
1382      * - If `to` refers to a smart contract, it must implement
1383      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1384      *
1385      * Emits a {Transfer} event.
1386      */
1387     function safeTransferFrom(
1388         address from,
1389         address to,
1390         uint256 tokenId,
1391         bytes memory _data
1392     ) public payable virtual override {
1393         transferFrom(from, to, tokenId);
1394         if (to.code.length != 0)
1395             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1396                 revert TransferToNonERC721ReceiverImplementer();
1397             }
1398     }
1399 
1400     /**
1401      * @dev Hook that is called before a set of serially-ordered token IDs
1402      * are about to be transferred. This includes minting.
1403      * And also called before burning one token.
1404      *
1405      * `startTokenId` - the first token ID to be transferred.
1406      * `quantity` - the amount to be transferred.
1407      *
1408      * Calling conditions:
1409      *
1410      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1411      * transferred to `to`.
1412      * - When `from` is zero, `tokenId` will be minted for `to`.
1413      * - When `to` is zero, `tokenId` will be burned by `from`.
1414      * - `from` and `to` are never both zero.
1415      */
1416     function _beforeTokenTransfers(
1417         address from,
1418         address to,
1419         uint256 startTokenId,
1420         uint256 quantity
1421     ) internal virtual {}
1422 
1423     /**
1424      * @dev Hook that is called after a set of serially-ordered token IDs
1425      * have been transferred. This includes minting.
1426      * And also called after one token has been burned.
1427      *
1428      * `startTokenId` - the first token ID to be transferred.
1429      * `quantity` - the amount to be transferred.
1430      *
1431      * Calling conditions:
1432      *
1433      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1434      * transferred to `to`.
1435      * - When `from` is zero, `tokenId` has been minted for `to`.
1436      * - When `to` is zero, `tokenId` has been burned by `from`.
1437      * - `from` and `to` are never both zero.
1438      */
1439     function _afterTokenTransfers(
1440         address from,
1441         address to,
1442         uint256 startTokenId,
1443         uint256 quantity
1444     ) internal virtual {}
1445 
1446     /**
1447      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1448      *
1449      * `from` - Previous owner of the given token ID.
1450      * `to` - Target address that will receive the token.
1451      * `tokenId` - Token ID to be transferred.
1452      * `_data` - Optional data to send along with the call.
1453      *
1454      * Returns whether the call correctly returned the expected magic value.
1455      */
1456     function _checkContractOnERC721Received(
1457         address from,
1458         address to,
1459         uint256 tokenId,
1460         bytes memory _data
1461     ) private returns (bool) {
1462         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1463             bytes4 retval
1464         ) {
1465             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1466         } catch (bytes memory reason) {
1467             if (reason.length == 0) {
1468                 revert TransferToNonERC721ReceiverImplementer();
1469             } else {
1470                 assembly {
1471                     revert(add(32, reason), mload(reason))
1472                 }
1473             }
1474         }
1475     }
1476 
1477     // =============================================================
1478     //                        MINT OPERATIONS
1479     // =============================================================
1480 
1481     /**
1482      * @dev Mints `quantity` tokens and transfers them to `to`.
1483      *
1484      * Requirements:
1485      *
1486      * - `to` cannot be the zero address.
1487      * - `quantity` must be greater than 0.
1488      *
1489      * Emits a {Transfer} event for each mint.
1490      */
1491     function _mint(address to, uint256 quantity) internal virtual {
1492         uint256 startTokenId = _currentIndex;
1493         if (quantity == 0) revert MintZeroQuantity();
1494 
1495         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1496 
1497         // Overflows are incredibly unrealistic.
1498         // `balance` and `numberMinted` have a maximum limit of 2**64.
1499         // `tokenId` has a maximum limit of 2**256.
1500         unchecked {
1501             // Updates:
1502             // - `balance += quantity`.
1503             // - `numberMinted += quantity`.
1504             //
1505             // We can directly add to the `balance` and `numberMinted`.
1506             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1507 
1508             // Updates:
1509             // - `address` to the owner.
1510             // - `startTimestamp` to the timestamp of minting.
1511             // - `burned` to `false`.
1512             // - `nextInitialized` to `quantity == 1`.
1513             _packedOwnerships[startTokenId] = _packOwnershipData(
1514                 to,
1515                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1516             );
1517 
1518             uint256 toMasked;
1519             uint256 end = startTokenId + quantity;
1520 
1521             // Use assembly to loop and emit the `Transfer` event for gas savings.
1522             // The duplicated `log4` removes an extra check and reduces stack juggling.
1523             // The assembly, together with the surrounding Solidity code, have been
1524             // delicately arranged to nudge the compiler into producing optimized opcodes.
1525             assembly {
1526                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1527                 toMasked := and(to, _BITMASK_ADDRESS)
1528                 // Emit the `Transfer` event.
1529                 log4(
1530                     0, // Start of data (0, since no data).
1531                     0, // End of data (0, since no data).
1532                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1533                     0, // `address(0)`.
1534                     toMasked, // `to`.
1535                     startTokenId // `tokenId`.
1536                 )
1537 
1538                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1539                 // that overflows uint256 will make the loop run out of gas.
1540                 // The compiler will optimize the `iszero` away for performance.
1541                 for {
1542                     let tokenId := add(startTokenId, 1)
1543                 } iszero(eq(tokenId, end)) {
1544                     tokenId := add(tokenId, 1)
1545                 } {
1546                     // Emit the `Transfer` event. Similar to above.
1547                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1548                 }
1549             }
1550             if (toMasked == 0) revert MintToZeroAddress();
1551 
1552             _currentIndex = end;
1553         }
1554         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1555     }
1556 
1557     /**
1558      * @dev Mints `quantity` tokens and transfers them to `to`.
1559      *
1560      * This function is intended for efficient minting only during contract creation.
1561      *
1562      * It emits only one {ConsecutiveTransfer} as defined in
1563      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1564      * instead of a sequence of {Transfer} event(s).
1565      *
1566      * Calling this function outside of contract creation WILL make your contract
1567      * non-compliant with the ERC721 standard.
1568      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1569      * {ConsecutiveTransfer} event is only permissible during contract creation.
1570      *
1571      * Requirements:
1572      *
1573      * - `to` cannot be the zero address.
1574      * - `quantity` must be greater than 0.
1575      *
1576      * Emits a {ConsecutiveTransfer} event.
1577      */
1578     function _mintERC2309(address to, uint256 quantity) internal virtual {
1579         uint256 startTokenId = _currentIndex;
1580         if (to == address(0)) revert MintToZeroAddress();
1581         if (quantity == 0) revert MintZeroQuantity();
1582         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1583 
1584         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1585 
1586         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1587         unchecked {
1588             // Updates:
1589             // - `balance += quantity`.
1590             // - `numberMinted += quantity`.
1591             //
1592             // We can directly add to the `balance` and `numberMinted`.
1593             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1594 
1595             // Updates:
1596             // - `address` to the owner.
1597             // - `startTimestamp` to the timestamp of minting.
1598             // - `burned` to `false`.
1599             // - `nextInitialized` to `quantity == 1`.
1600             _packedOwnerships[startTokenId] = _packOwnershipData(
1601                 to,
1602                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1603             );
1604 
1605             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1606 
1607             _currentIndex = startTokenId + quantity;
1608         }
1609         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1610     }
1611 
1612     /**
1613      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1614      *
1615      * Requirements:
1616      *
1617      * - If `to` refers to a smart contract, it must implement
1618      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1619      * - `quantity` must be greater than 0.
1620      *
1621      * See {_mint}.
1622      *
1623      * Emits a {Transfer} event for each mint.
1624      */
1625     function _safeMint(
1626         address to,
1627         uint256 quantity,
1628         bytes memory _data
1629     ) internal virtual {
1630         _mint(to, quantity);
1631 
1632         unchecked {
1633             if (to.code.length != 0) {
1634                 uint256 end = _currentIndex;
1635                 uint256 index = end - quantity;
1636                 do {
1637                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1638                         revert TransferToNonERC721ReceiverImplementer();
1639                     }
1640                 } while (index < end);
1641                 // Reentrancy protection.
1642                 if (_currentIndex != end) revert();
1643             }
1644         }
1645     }
1646 
1647     /**
1648      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1649      */
1650     function _safeMint(address to, uint256 quantity) internal virtual {
1651         _safeMint(to, quantity, '');
1652     }
1653 
1654     // =============================================================
1655     //                        BURN OPERATIONS
1656     // =============================================================
1657 
1658     /**
1659      * @dev Equivalent to `_burn(tokenId, false)`.
1660      */
1661     function _burn(uint256 tokenId) internal virtual {
1662         _burn(tokenId, false);
1663     }
1664 
1665     /**
1666      * @dev Destroys `tokenId`.
1667      * The approval is cleared when the token is burned.
1668      *
1669      * Requirements:
1670      *
1671      * - `tokenId` must exist.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1676         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1677 
1678         address from = address(uint160(prevOwnershipPacked));
1679 
1680         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1681 
1682         if (approvalCheck) {
1683             // The nested ifs save around 20+ gas over a compound boolean condition.
1684             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1685                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1686         }
1687 
1688         _beforeTokenTransfers(from, address(0), tokenId, 1);
1689 
1690         // Clear approvals from the previous owner.
1691         assembly {
1692             if approvedAddress {
1693                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1694                 sstore(approvedAddressSlot, 0)
1695             }
1696         }
1697 
1698         // Underflow of the sender's balance is impossible because we check for
1699         // ownership above and the recipient's balance can't realistically overflow.
1700         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1701         unchecked {
1702             // Updates:
1703             // - `balance -= 1`.
1704             // - `numberBurned += 1`.
1705             //
1706             // We can directly decrement the balance, and increment the number burned.
1707             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1708             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1709 
1710             // Updates:
1711             // - `address` to the last owner.
1712             // - `startTimestamp` to the timestamp of burning.
1713             // - `burned` to `true`.
1714             // - `nextInitialized` to `true`.
1715             _packedOwnerships[tokenId] = _packOwnershipData(
1716                 from,
1717                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1718             );
1719 
1720             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1721             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1722                 uint256 nextTokenId = tokenId + 1;
1723                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1724                 if (_packedOwnerships[nextTokenId] == 0) {
1725                     // If the next slot is within bounds.
1726                     if (nextTokenId != _currentIndex) {
1727                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1728                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1729                     }
1730                 }
1731             }
1732         }
1733 
1734         emit Transfer(from, address(0), tokenId);
1735         _afterTokenTransfers(from, address(0), tokenId, 1);
1736 
1737         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1738         unchecked {
1739             _burnCounter++;
1740         }
1741     }
1742 
1743     // =============================================================
1744     //                     EXTRA DATA OPERATIONS
1745     // =============================================================
1746 
1747     /**
1748      * @dev Directly sets the extra data for the ownership data `index`.
1749      */
1750     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1751         uint256 packed = _packedOwnerships[index];
1752         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1753         uint256 extraDataCasted;
1754         // Cast `extraData` with assembly to avoid redundant masking.
1755         assembly {
1756             extraDataCasted := extraData
1757         }
1758         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1759         _packedOwnerships[index] = packed;
1760     }
1761 
1762     /**
1763      * @dev Called during each token transfer to set the 24bit `extraData` field.
1764      * Intended to be overridden by the cosumer contract.
1765      *
1766      * `previousExtraData` - the value of `extraData` before transfer.
1767      *
1768      * Calling conditions:
1769      *
1770      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1771      * transferred to `to`.
1772      * - When `from` is zero, `tokenId` will be minted for `to`.
1773      * - When `to` is zero, `tokenId` will be burned by `from`.
1774      * - `from` and `to` are never both zero.
1775      */
1776     function _extraData(
1777         address from,
1778         address to,
1779         uint24 previousExtraData
1780     ) internal view virtual returns (uint24) {}
1781 
1782     /**
1783      * @dev Returns the next extra data for the packed ownership data.
1784      * The returned result is shifted into position.
1785      */
1786     function _nextExtraData(
1787         address from,
1788         address to,
1789         uint256 prevOwnershipPacked
1790     ) private view returns (uint256) {
1791         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1792         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1793     }
1794 
1795     // =============================================================
1796     //                       OTHER OPERATIONS
1797     // =============================================================
1798 
1799     /**
1800      * @dev Returns the message sender (defaults to `msg.sender`).
1801      *
1802      * If you are writing GSN compatible contracts, you need to override this function.
1803      */
1804     function _msgSenderERC721A() internal view virtual returns (address) {
1805         return msg.sender;
1806     }
1807 
1808     /**
1809      * @dev Converts a uint256 to its ASCII string decimal representation.
1810      */
1811     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1812         assembly {
1813             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1814             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1815             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1816             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1817             let m := add(mload(0x40), 0xa0)
1818             // Update the free memory pointer to allocate.
1819             mstore(0x40, m)
1820             // Assign the `str` to the end.
1821             str := sub(m, 0x20)
1822             // Zeroize the slot after the string.
1823             mstore(str, 0)
1824 
1825             // Cache the end of the memory to calculate the length later.
1826             let end := str
1827 
1828             // We write the string from rightmost digit to leftmost digit.
1829             // The following is essentially a do-while loop that also handles the zero case.
1830             // prettier-ignore
1831             for { let temp := value } 1 {} {
1832                 str := sub(str, 1)
1833                 // Write the character to the pointer.
1834                 // The ASCII index of the '0' character is 48.
1835                 mstore8(str, add(48, mod(temp, 10)))
1836                 // Keep dividing `temp` until zero.
1837                 temp := div(temp, 10)
1838                 // prettier-ignore
1839                 if iszero(temp) { break }
1840             }
1841 
1842             let length := sub(end, str)
1843             // Move the pointer 32 bytes leftwards to make room for the length.
1844             str := sub(str, 0x20)
1845             // Store the length.
1846             mstore(str, length)
1847         }
1848     }
1849 }
1850 
1851 // File: contracts/ChunkyMonkeys.sol
1852 
1853 
1854 /*
1855 ******************************************************************
1856                  
1857                  Contract DEGEN PIGEONS GENERATOR
1858 
1859 
1860 ******************************************************************
1861 */
1862 
1863 
1864 
1865 
1866 
1867 
1868 
1869 
1870     pragma solidity ^0.8.0;
1871     
1872     contract chunkymonkeys  is ERC721A, Ownable, ReentrancyGuard {
1873         using Strings for uint256;
1874     
1875         constructor() ERC721A("chunkymonkeys", "cm") {}
1876     
1877         //URI uriPrefix is the BaseURI
1878         string public uriPrefix = "ipfs:///";
1879         string public uriSuffix = ".json";
1880       
1881         // hiddenMetadataUri is the not reveal URI
1882         string public hiddenMetadataUri= "ipfs://QmNs49Hv56L91SfRQ3ecUogPFhr6LKztLC99BdbsFiMWJ9/hidden"; 
1883         
1884         uint256 public cost = 0.0099 ether; 
1885         uint256 public WLcost = 0.0099 ether;
1886         uint256 public maxSupply = 999;
1887         uint256 public wlSupply = 999;
1888         uint256 public nftPerAddressLimit = 2;
1889         uint256 public maxMintAmount = 2;
1890       
1891         bool public paused = true;
1892         bool public revealed = true;
1893         bool public onlyWhitelisted = true;
1894       
1895         bytes32 public merkleRoot = 0x71946bc0a2155cfa5fc88839e593b445f5d645258c93b9471c3b6080037a221f;
1896 
1897   mapping(address => uint256) public addressMintedBalance;
1898 
1899   modifier mintCompliance(uint256 _mintAmount) {
1900     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1901     require(balanceOf(msg.sender) + _mintAmount <= maxMintAmount , "Exceeds Max mint!");
1902     require(!paused, "The contract is paused!");
1903     _;
1904   }
1905 
1906   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1907     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1908     require(!onlyWhitelisted, "Public mint is not active");
1909         if (msg.sender != owner()) {
1910             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1911             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1912         
1913         require(msg.value >= cost * _mintAmount, "insufficient funds");
1914     }
1915     
1916     for (uint256 i = 1; i <= _mintAmount; i++) {
1917         addressMintedBalance[msg.sender]++;
1918      
1919     }
1920 
1921     _safeMint(msg.sender, _mintAmount);
1922   }
1923 
1924   function mintWl(uint256 _mintAmount, bytes32[] memory _merkleProof) public payable mintCompliance(_mintAmount) {
1925     require(msg.value >= WLcost * _mintAmount, "Insufficient funds!");
1926     require(onlyWhitelisted, "The presale ended!");
1927     require(totalSupply() + _mintAmount <= wlSupply, "The presale ended!");
1928     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1929     require(
1930         MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1931         "Invalid Merkle Proof."
1932     );
1933 
1934     _safeMint(msg.sender, _mintAmount);
1935   }
1936   
1937   function mintForAddress(uint256 _mintAmount, address[] memory _receiver) public onlyOwner {
1938     for (uint256 i = 0; i < _receiver.length; i++) {
1939       _safeMint(_receiver[i], _mintAmount);
1940     }
1941   }
1942 
1943 
1944   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1945     uint256 ownerTokenCount = balanceOf(_owner);
1946     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1947     uint256 currentTokenId = 1;
1948     uint256 ownedTokenIndex = 0;
1949 
1950     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1951       address currentTokenOwner = ownerOf(currentTokenId);
1952       if (currentTokenOwner == _owner) {
1953         ownedTokenIds[ownedTokenIndex] = currentTokenId+1;
1954         ownedTokenIndex++;
1955       }
1956       currentTokenId++;
1957     }
1958     return ownedTokenIds;
1959   }
1960 
1961   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
1962     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1963     if (revealed == false) {
1964       return hiddenMetadataUri;}
1965     string memory currentBaseURI = _baseURI();
1966     _tokenId = _tokenId+1;
1967     return bytes(currentBaseURI).length > 0
1968         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1969         : "";
1970   }
1971 
1972   function setOnlyWhitelisted(bool _state) public onlyOwner {
1973     onlyWhitelisted = _state;
1974   }
1975 
1976   function setRevealed(bool _state) public onlyOwner {
1977     revealed = _state;
1978   }
1979 
1980   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1981     merkleRoot = _merkleRoot;
1982   }
1983 
1984   function setCost(uint256 _cost) public onlyOwner {
1985     cost = _cost;
1986   }
1987 
1988   
1989   function setWLcost(uint256 _WLcost) public onlyOwner {
1990     WLcost = _WLcost;
1991   }
1992 
1993 
1994   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1995     maxMintAmount = _maxMintAmount;
1996   }
1997 
1998     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1999     nftPerAddressLimit = _limit;
2000   }
2001 
2002   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2003     hiddenMetadataUri = _hiddenMetadataUri;
2004   }
2005 
2006   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2007     uriPrefix = _uriPrefix;
2008   }
2009 
2010   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2011     uriSuffix = _uriSuffix;
2012   }
2013 
2014 
2015   function setWlSupply(uint256 _wlSupply) public onlyOwner {
2016     wlSupply = _wlSupply;
2017   }
2018 
2019   function setPaused(bool _state) public onlyOwner {
2020     paused = _state;
2021   }
2022 
2023   function withdraw() public onlyOwner nonReentrant {
2024     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2025     require(os);
2026   }
2027 
2028   function _baseURI() internal view virtual override returns (string memory) {
2029     return uriPrefix;
2030   }
2031 }