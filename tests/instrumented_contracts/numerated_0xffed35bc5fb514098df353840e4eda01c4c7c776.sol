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
217 // File: @openzeppelin/contracts/utils/Strings.sol
218 
219 
220 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev String operations.
226  */
227 library Strings {
228     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
229     uint8 private constant _ADDRESS_LENGTH = 20;
230 
231     /**
232      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
233      */
234     function toString(uint256 value) internal pure returns (string memory) {
235         // Inspired by OraclizeAPI's implementation - MIT licence
236         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
237 
238         if (value == 0) {
239             return "0";
240         }
241         uint256 temp = value;
242         uint256 digits;
243         while (temp != 0) {
244             digits++;
245             temp /= 10;
246         }
247         bytes memory buffer = new bytes(digits);
248         while (value != 0) {
249             digits -= 1;
250             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
251             value /= 10;
252         }
253         return string(buffer);
254     }
255 
256     /**
257      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
258      */
259     function toHexString(uint256 value) internal pure returns (string memory) {
260         if (value == 0) {
261             return "0x00";
262         }
263         uint256 temp = value;
264         uint256 length = 0;
265         while (temp != 0) {
266             length++;
267             temp >>= 8;
268         }
269         return toHexString(value, length);
270     }
271 
272     /**
273      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
274      */
275     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
276         bytes memory buffer = new bytes(2 * length + 2);
277         buffer[0] = "0";
278         buffer[1] = "x";
279         for (uint256 i = 2 * length + 1; i > 1; --i) {
280             buffer[i] = _HEX_SYMBOLS[value & 0xf];
281             value >>= 4;
282         }
283         require(value == 0, "Strings: hex length insufficient");
284         return string(buffer);
285     }
286 
287     /**
288      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
289      */
290     function toHexString(address addr) internal pure returns (string memory) {
291         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
292     }
293 }
294 
295 // File: @openzeppelin/contracts/utils/Context.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev Provides information about the current execution context, including the
304  * sender of the transaction and its data. While these are generally available
305  * via msg.sender and msg.data, they should not be accessed in such a direct
306  * manner, since when dealing with meta-transactions the account sending and
307  * paying for execution may not be the actual sender (as far as an application
308  * is concerned).
309  *
310  * This contract is only required for intermediate, library-like contracts.
311  */
312 abstract contract Context {
313     function _msgSender() internal view virtual returns (address) {
314         return msg.sender;
315     }
316 
317     function _msgData() internal view virtual returns (bytes calldata) {
318         return msg.data;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/access/Ownable.sol
323 
324 
325 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @dev Contract module which provides a basic access control mechanism, where
332  * there is an account (an owner) that can be granted exclusive access to
333  * specific functions.
334  *
335  * By default, the owner account will be the one that deploys the contract. This
336  * can later be changed with {transferOwnership}.
337  *
338  * This module is used through inheritance. It will make available the modifier
339  * `onlyOwner`, which can be applied to your functions to restrict their use to
340  * the owner.
341  */
342 abstract contract Ownable is Context {
343     address private _owner;
344 
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor() {
351         _transferOwnership(_msgSender());
352     }
353 
354     /**
355      * @dev Throws if called by any account other than the owner.
356      */
357     modifier onlyOwner() {
358         _checkOwner();
359         _;
360     }
361 
362     /**
363      * @dev Returns the address of the current owner.
364      */
365     function owner() public view virtual returns (address) {
366         return _owner;
367     }
368 
369     /**
370      * @dev Throws if the sender is not the owner.
371      */
372     function _checkOwner() internal view virtual {
373         require(owner() == _msgSender(), "Ownable: caller is not the owner");
374     }
375 
376     /**
377      * @dev Leaves the contract without owner. It will not be possible to call
378      * `onlyOwner` functions anymore. Can only be called by the current owner.
379      *
380      * NOTE: Renouncing ownership will leave the contract without an owner,
381      * thereby removing any functionality that is only available to the owner.
382      */
383     function renounceOwnership() public virtual onlyOwner {
384         _transferOwnership(address(0));
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      * Can only be called by the current owner.
390      */
391     function transferOwnership(address newOwner) public virtual onlyOwner {
392         require(newOwner != address(0), "Ownable: new owner is the zero address");
393         _transferOwnership(newOwner);
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Internal function without access restriction.
399      */
400     function _transferOwnership(address newOwner) internal virtual {
401         address oldOwner = _owner;
402         _owner = newOwner;
403         emit OwnershipTransferred(oldOwner, newOwner);
404     }
405 }
406 
407 // File: erc721a/contracts/IERC721A.sol
408 
409 
410 // ERC721A Contracts v4.1.0
411 // Creator: Chiru Labs
412 
413 pragma solidity ^0.8.4;
414 
415 /**
416  * @dev Interface of an ERC721A compliant contract.
417  */
418 interface IERC721A {
419     /**
420      * The caller must own the token or be an approved operator.
421      */
422     error ApprovalCallerNotOwnerNorApproved();
423 
424     /**
425      * The token does not exist.
426      */
427     error ApprovalQueryForNonexistentToken();
428 
429     /**
430      * The caller cannot approve to their own address.
431      */
432     error ApproveToCaller();
433 
434     /**
435      * Cannot query the balance for the zero address.
436      */
437     error BalanceQueryForZeroAddress();
438 
439     /**
440      * Cannot mint to the zero address.
441      */
442     error MintToZeroAddress();
443 
444     /**
445      * The quantity of tokens minted must be more than zero.
446      */
447     error MintZeroQuantity();
448 
449     /**
450      * The token does not exist.
451      */
452     error OwnerQueryForNonexistentToken();
453 
454     /**
455      * The caller must own the token or be an approved operator.
456      */
457     error TransferCallerNotOwnerNorApproved();
458 
459     /**
460      * The token must be owned by `from`.
461      */
462     error TransferFromIncorrectOwner();
463 
464     /**
465      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
466      */
467     error TransferToNonERC721ReceiverImplementer();
468 
469     /**
470      * Cannot transfer to the zero address.
471      */
472     error TransferToZeroAddress();
473 
474     /**
475      * The token does not exist.
476      */
477     error URIQueryForNonexistentToken();
478 
479     /**
480      * The `quantity` minted with ERC2309 exceeds the safety limit.
481      */
482     error MintERC2309QuantityExceedsLimit();
483 
484     /**
485      * The `extraData` cannot be set on an unintialized ownership slot.
486      */
487     error OwnershipNotInitializedForExtraData();
488 
489     struct TokenOwnership {
490         // The address of the owner.
491         address addr;
492         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
493         uint64 startTimestamp;
494         // Whether the token has been burned.
495         bool burned;
496         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
497         uint24 extraData;
498     }
499 
500     /**
501      * @dev Returns the total amount of tokens stored by the contract.
502      *
503      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
504      */
505     function totalSupply() external view returns (uint256);
506 
507     // ==============================
508     //            IERC165
509     // ==============================
510 
511     /**
512      * @dev Returns true if this contract implements the interface defined by
513      * `interfaceId`. See the corresponding
514      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
515      * to learn more about how these ids are created.
516      *
517      * This function call must use less than 30 000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool);
520 
521     // ==============================
522     //            IERC721
523     // ==============================
524 
525     /**
526      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
527      */
528     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
529 
530     /**
531      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
532      */
533     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
534 
535     /**
536      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
537      */
538     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
539 
540     /**
541      * @dev Returns the number of tokens in ``owner``'s account.
542      */
543     function balanceOf(address owner) external view returns (uint256 balance);
544 
545     /**
546      * @dev Returns the owner of the `tokenId` token.
547      *
548      * Requirements:
549      *
550      * - `tokenId` must exist.
551      */
552     function ownerOf(uint256 tokenId) external view returns (address owner);
553 
554     /**
555      * @dev Safely transfers `tokenId` token from `from` to `to`.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must exist and be owned by `from`.
562      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
563      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
564      *
565      * Emits a {Transfer} event.
566      */
567     function safeTransferFrom(
568         address from,
569         address to,
570         uint256 tokenId,
571         bytes calldata data
572     ) external;
573 
574     /**
575      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
576      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId
592     ) external;
593 
594     /**
595      * @dev Transfers `tokenId` token from `from` to `to`.
596      *
597      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must be owned by `from`.
604      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
605      *
606      * Emits a {Transfer} event.
607      */
608     function transferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) external;
613 
614     /**
615      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
616      * The approval is cleared when the token is transferred.
617      *
618      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
619      *
620      * Requirements:
621      *
622      * - The caller must own the token or be an approved operator.
623      * - `tokenId` must exist.
624      *
625      * Emits an {Approval} event.
626      */
627     function approve(address to, uint256 tokenId) external;
628 
629     /**
630      * @dev Approve or remove `operator` as an operator for the caller.
631      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
632      *
633      * Requirements:
634      *
635      * - The `operator` cannot be the caller.
636      *
637      * Emits an {ApprovalForAll} event.
638      */
639     function setApprovalForAll(address operator, bool _approved) external;
640 
641     /**
642      * @dev Returns the account approved for `tokenId` token.
643      *
644      * Requirements:
645      *
646      * - `tokenId` must exist.
647      */
648     function getApproved(uint256 tokenId) external view returns (address operator);
649 
650     /**
651      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
652      *
653      * See {setApprovalForAll}
654      */
655     function isApprovedForAll(address owner, address operator) external view returns (bool);
656 
657     // ==============================
658     //        IERC721Metadata
659     // ==============================
660 
661     /**
662      * @dev Returns the token collection name.
663      */
664     function name() external view returns (string memory);
665 
666     /**
667      * @dev Returns the token collection symbol.
668      */
669     function symbol() external view returns (string memory);
670 
671     /**
672      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
673      */
674     function tokenURI(uint256 tokenId) external view returns (string memory);
675 
676     // ==============================
677     //            IERC2309
678     // ==============================
679 
680     /**
681      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
682      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
683      */
684     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
685 }
686 
687 // File: erc721a/contracts/ERC721A.sol
688 
689 
690 // ERC721A Contracts v4.1.0
691 // Creator: Chiru Labs
692 
693 pragma solidity ^0.8.4;
694 
695 
696 /**
697  * @dev ERC721 token receiver interface.
698  */
699 interface ERC721A__IERC721Receiver {
700     function onERC721Received(
701         address operator,
702         address from,
703         uint256 tokenId,
704         bytes calldata data
705     ) external returns (bytes4);
706 }
707 
708 /**
709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
710  * including the Metadata extension. Built to optimize for lower gas during batch mints.
711  *
712  * Assumes serials are sequentially minted starting at `_startTokenId()`
713  * (defaults to 0, e.g. 0, 1, 2, 3..).
714  *
715  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
716  *
717  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
718  */
719 contract ERC721A is IERC721A {
720     // Mask of an entry in packed address data.
721     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
722 
723     // The bit position of `numberMinted` in packed address data.
724     uint256 private constant BITPOS_NUMBER_MINTED = 64;
725 
726     // The bit position of `numberBurned` in packed address data.
727     uint256 private constant BITPOS_NUMBER_BURNED = 128;
728 
729     // The bit position of `aux` in packed address data.
730     uint256 private constant BITPOS_AUX = 192;
731 
732     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
733     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
734 
735     // The bit position of `startTimestamp` in packed ownership.
736     uint256 private constant BITPOS_START_TIMESTAMP = 160;
737 
738     // The bit mask of the `burned` bit in packed ownership.
739     uint256 private constant BITMASK_BURNED = 1 << 224;
740 
741     // The bit position of the `nextInitialized` bit in packed ownership.
742     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
743 
744     // The bit mask of the `nextInitialized` bit in packed ownership.
745     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
746 
747     // The bit position of `extraData` in packed ownership.
748     uint256 private constant BITPOS_EXTRA_DATA = 232;
749 
750     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
751     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
752 
753     // The mask of the lower 160 bits for addresses.
754     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
755 
756     // The maximum `quantity` that can be minted with `_mintERC2309`.
757     // This limit is to prevent overflows on the address data entries.
758     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
759     // is required to cause an overflow, which is unrealistic.
760     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
761 
762     // The tokenId of the next token to be minted.
763     uint256 private _currentIndex;
764 
765     // The number of tokens burned.
766     uint256 private _burnCounter;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to ownership details
775     // An empty struct value does not necessarily mean the token is unowned.
776     // See `_packedOwnershipOf` implementation for details.
777     //
778     // Bits Layout:
779     // - [0..159]   `addr`
780     // - [160..223] `startTimestamp`
781     // - [224]      `burned`
782     // - [225]      `nextInitialized`
783     // - [232..255] `extraData`
784     mapping(uint256 => uint256) private _packedOwnerships;
785 
786     // Mapping owner address to address data.
787     //
788     // Bits Layout:
789     // - [0..63]    `balance`
790     // - [64..127]  `numberMinted`
791     // - [128..191] `numberBurned`
792     // - [192..255] `aux`
793     mapping(address => uint256) private _packedAddressData;
794 
795     // Mapping from token ID to approved address.
796     mapping(uint256 => address) private _tokenApprovals;
797 
798     // Mapping from owner to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     constructor(string memory name_, string memory symbol_) {
802         _name = name_;
803         _symbol = symbol_;
804         _currentIndex = _startTokenId();
805     }
806 
807     /**
808      * @dev Returns the starting token ID.
809      * To change the starting token ID, please override this function.
810      */
811     function _startTokenId() internal view virtual returns (uint256) {
812         return 0;
813     }
814 
815     /**
816      * @dev Returns the next token ID to be minted.
817      */
818     function _nextTokenId() internal view returns (uint256) {
819         return _currentIndex;
820     }
821 
822     /**
823      * @dev Returns the total number of tokens in existence.
824      * Burned tokens will reduce the count.
825      * To get the total number of tokens minted, please see `_totalMinted`.
826      */
827     function totalSupply() public view override returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than `_currentIndex - _startTokenId()` times.
830         unchecked {
831             return _currentIndex - _burnCounter - _startTokenId();
832         }
833     }
834 
835     /**
836      * @dev Returns the total amount of tokens minted in the contract.
837      */
838     function _totalMinted() internal view returns (uint256) {
839         // Counter underflow is impossible as _currentIndex does not decrement,
840         // and it is initialized to `_startTokenId()`
841         unchecked {
842             return _currentIndex - _startTokenId();
843         }
844     }
845 
846     /**
847      * @dev Returns the total number of tokens burned.
848      */
849     function _totalBurned() internal view returns (uint256) {
850         return _burnCounter;
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
857         // The interface IDs are constants representing the first 4 bytes of the XOR of
858         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
859         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
860         return
861             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
862             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
863             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
864     }
865 
866     /**
867      * @dev See {IERC721-balanceOf}.
868      */
869     function balanceOf(address owner) public view override returns (uint256) {
870         if (owner == address(0)) revert BalanceQueryForZeroAddress();
871         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
872     }
873 
874     /**
875      * Returns the number of tokens minted by `owner`.
876      */
877     function _numberMinted(address owner) internal view returns (uint256) {
878         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
879     }
880 
881     /**
882      * Returns the number of tokens burned by or on behalf of `owner`.
883      */
884     function _numberBurned(address owner) internal view returns (uint256) {
885         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
886     }
887 
888     /**
889      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
890      */
891     function _getAux(address owner) internal view returns (uint64) {
892         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
893     }
894 
895     /**
896      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
897      * If there are multiple variables, please pack them into a uint64.
898      */
899     function _setAux(address owner, uint64 aux) internal {
900         uint256 packed = _packedAddressData[owner];
901         uint256 auxCasted;
902         // Cast `aux` with assembly to avoid redundant masking.
903         assembly {
904             auxCasted := aux
905         }
906         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
907         _packedAddressData[owner] = packed;
908     }
909 
910     /**
911      * Returns the packed ownership data of `tokenId`.
912      */
913     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
914         uint256 curr = tokenId;
915 
916         unchecked {
917             if (_startTokenId() <= curr)
918                 if (curr < _currentIndex) {
919                     uint256 packed = _packedOwnerships[curr];
920                     // If not burned.
921                     if (packed & BITMASK_BURNED == 0) {
922                         // Invariant:
923                         // There will always be an ownership that has an address and is not burned
924                         // before an ownership that does not have an address and is not burned.
925                         // Hence, curr will not underflow.
926                         //
927                         // We can directly compare the packed value.
928                         // If the address is zero, packed is zero.
929                         while (packed == 0) {
930                             packed = _packedOwnerships[--curr];
931                         }
932                         return packed;
933                     }
934                 }
935         }
936         revert OwnerQueryForNonexistentToken();
937     }
938 
939     /**
940      * Returns the unpacked `TokenOwnership` struct from `packed`.
941      */
942     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
943         ownership.addr = address(uint160(packed));
944         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
945         ownership.burned = packed & BITMASK_BURNED != 0;
946         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
947     }
948 
949     /**
950      * Returns the unpacked `TokenOwnership` struct at `index`.
951      */
952     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
953         return _unpackedOwnership(_packedOwnerships[index]);
954     }
955 
956     /**
957      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
958      */
959     function _initializeOwnershipAt(uint256 index) internal {
960         if (_packedOwnerships[index] == 0) {
961             _packedOwnerships[index] = _packedOwnershipOf(index);
962         }
963     }
964 
965     /**
966      * Gas spent here starts off proportional to the maximum mint batch size.
967      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
968      */
969     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
970         return _unpackedOwnership(_packedOwnershipOf(tokenId));
971     }
972 
973     /**
974      * @dev Packs ownership data into a single uint256.
975      */
976     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
977         assembly {
978             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
979             owner := and(owner, BITMASK_ADDRESS)
980             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
981             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
982         }
983     }
984 
985     /**
986      * @dev See {IERC721-ownerOf}.
987      */
988     function ownerOf(uint256 tokenId) public view override returns (address) {
989         return address(uint160(_packedOwnershipOf(tokenId)));
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-name}.
994      */
995     function name() public view virtual override returns (string memory) {
996         return _name;
997     }
998 
999     /**
1000      * @dev See {IERC721Metadata-symbol}.
1001      */
1002     function symbol() public view virtual override returns (string memory) {
1003         return _symbol;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Metadata-tokenURI}.
1008      */
1009     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1010         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1011 
1012         string memory baseURI = _baseURI();
1013         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1014     }
1015 
1016     /**
1017      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1018      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1019      * by default, it can be overridden in child contracts.
1020      */
1021     function _baseURI() internal view virtual returns (string memory) {
1022         return '';
1023     }
1024 
1025     /**
1026      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1027      */
1028     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1029         // For branchless setting of the `nextInitialized` flag.
1030         assembly {
1031             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1032             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1033         }
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-approve}.
1038      */
1039     function approve(address to, uint256 tokenId) public override {
1040         address owner = ownerOf(tokenId);
1041 
1042         if (_msgSenderERC721A() != owner)
1043             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1044                 revert ApprovalCallerNotOwnerNorApproved();
1045             }
1046 
1047         _tokenApprovals[tokenId] = to;
1048         emit Approval(owner, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-getApproved}.
1053      */
1054     function getApproved(uint256 tokenId) public view override returns (address) {
1055         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1056 
1057         return _tokenApprovals[tokenId];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-setApprovalForAll}.
1062      */
1063     function setApprovalForAll(address operator, bool approved) public virtual override {
1064         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1065 
1066         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1067         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-isApprovedForAll}.
1072      */
1073     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1074         return _operatorApprovals[owner][operator];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-safeTransferFrom}.
1079      */
1080     function safeTransferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) public virtual override {
1085         safeTransferFrom(from, to, tokenId, '');
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-safeTransferFrom}.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) public virtual override {
1097         transferFrom(from, to, tokenId);
1098         if (to.code.length != 0)
1099             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1100                 revert TransferToNonERC721ReceiverImplementer();
1101             }
1102     }
1103 
1104     /**
1105      * @dev Returns whether `tokenId` exists.
1106      *
1107      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1108      *
1109      * Tokens start existing when they are minted (`_mint`),
1110      */
1111     function _exists(uint256 tokenId) internal view returns (bool) {
1112         return
1113             _startTokenId() <= tokenId &&
1114             tokenId < _currentIndex && // If within bounds,
1115             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1116     }
1117 
1118     /**
1119      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1120      */
1121     function _safeMint(address to, uint256 quantity) internal {
1122         _safeMint(to, quantity, '');
1123     }
1124 
1125     /**
1126      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1127      *
1128      * Requirements:
1129      *
1130      * - If `to` refers to a smart contract, it must implement
1131      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1132      * - `quantity` must be greater than 0.
1133      *
1134      * See {_mint}.
1135      *
1136      * Emits a {Transfer} event for each mint.
1137      */
1138     function _safeMint(
1139         address to,
1140         uint256 quantity,
1141         bytes memory _data
1142     ) internal {
1143         _mint(to, quantity);
1144 
1145         unchecked {
1146             if (to.code.length != 0) {
1147                 uint256 end = _currentIndex;
1148                 uint256 index = end - quantity;
1149                 do {
1150                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1151                         revert TransferToNonERC721ReceiverImplementer();
1152                     }
1153                 } while (index < end);
1154                 // Reentrancy protection.
1155                 if (_currentIndex != end) revert();
1156             }
1157         }
1158     }
1159 
1160     /**
1161      * @dev Mints `quantity` tokens and transfers them to `to`.
1162      *
1163      * Requirements:
1164      *
1165      * - `to` cannot be the zero address.
1166      * - `quantity` must be greater than 0.
1167      *
1168      * Emits a {Transfer} event for each mint.
1169      */
1170     function _mint(address to, uint256 quantity) internal {
1171         uint256 startTokenId = _currentIndex;
1172         if (to == address(0)) revert MintToZeroAddress();
1173         if (quantity == 0) revert MintZeroQuantity();
1174 
1175         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1176 
1177         // Overflows are incredibly unrealistic.
1178         // `balance` and `numberMinted` have a maximum limit of 2**64.
1179         // `tokenId` has a maximum limit of 2**256.
1180         unchecked {
1181             // Updates:
1182             // - `balance += quantity`.
1183             // - `numberMinted += quantity`.
1184             //
1185             // We can directly add to the `balance` and `numberMinted`.
1186             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1187 
1188             // Updates:
1189             // - `address` to the owner.
1190             // - `startTimestamp` to the timestamp of minting.
1191             // - `burned` to `false`.
1192             // - `nextInitialized` to `quantity == 1`.
1193             _packedOwnerships[startTokenId] = _packOwnershipData(
1194                 to,
1195                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1196             );
1197 
1198             uint256 tokenId = startTokenId;
1199             uint256 end = startTokenId + quantity;
1200             do {
1201                 emit Transfer(address(0), to, tokenId++);
1202             } while (tokenId < end);
1203 
1204             _currentIndex = end;
1205         }
1206         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1207     }
1208 
1209     /**
1210      * @dev Mints `quantity` tokens and transfers them to `to`.
1211      *
1212      * This function is intended for efficient minting only during contract creation.
1213      *
1214      * It emits only one {ConsecutiveTransfer} as defined in
1215      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1216      * instead of a sequence of {Transfer} event(s).
1217      *
1218      * Calling this function outside of contract creation WILL make your contract
1219      * non-compliant with the ERC721 standard.
1220      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1221      * {ConsecutiveTransfer} event is only permissible during contract creation.
1222      *
1223      * Requirements:
1224      *
1225      * - `to` cannot be the zero address.
1226      * - `quantity` must be greater than 0.
1227      *
1228      * Emits a {ConsecutiveTransfer} event.
1229      */
1230     function _mintERC2309(address to, uint256 quantity) internal {
1231         uint256 startTokenId = _currentIndex;
1232         if (to == address(0)) revert MintToZeroAddress();
1233         if (quantity == 0) revert MintZeroQuantity();
1234         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1235 
1236         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1237 
1238         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1239         unchecked {
1240             // Updates:
1241             // - `balance += quantity`.
1242             // - `numberMinted += quantity`.
1243             //
1244             // We can directly add to the `balance` and `numberMinted`.
1245             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1246 
1247             // Updates:
1248             // - `address` to the owner.
1249             // - `startTimestamp` to the timestamp of minting.
1250             // - `burned` to `false`.
1251             // - `nextInitialized` to `quantity == 1`.
1252             _packedOwnerships[startTokenId] = _packOwnershipData(
1253                 to,
1254                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1255             );
1256 
1257             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1258 
1259             _currentIndex = startTokenId + quantity;
1260         }
1261         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1262     }
1263 
1264     /**
1265      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1266      */
1267     function _getApprovedAddress(uint256 tokenId)
1268         private
1269         view
1270         returns (uint256 approvedAddressSlot, address approvedAddress)
1271     {
1272         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1273         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1274         assembly {
1275             // Compute the slot.
1276             mstore(0x00, tokenId)
1277             mstore(0x20, tokenApprovalsPtr.slot)
1278             approvedAddressSlot := keccak256(0x00, 0x40)
1279             // Load the slot's value from storage.
1280             approvedAddress := sload(approvedAddressSlot)
1281         }
1282     }
1283 
1284     /**
1285      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1286      */
1287     function _isOwnerOrApproved(
1288         address approvedAddress,
1289         address from,
1290         address msgSender
1291     ) private pure returns (bool result) {
1292         assembly {
1293             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1294             from := and(from, BITMASK_ADDRESS)
1295             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1296             msgSender := and(msgSender, BITMASK_ADDRESS)
1297             // `msgSender == from || msgSender == approvedAddress`.
1298             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1299         }
1300     }
1301 
1302     /**
1303      * @dev Transfers `tokenId` from `from` to `to`.
1304      *
1305      * Requirements:
1306      *
1307      * - `to` cannot be the zero address.
1308      * - `tokenId` token must be owned by `from`.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function transferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public virtual override {
1317         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1318 
1319         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1320 
1321         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1322 
1323         // The nested ifs save around 20+ gas over a compound boolean condition.
1324         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1325             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1326 
1327         if (to == address(0)) revert TransferToZeroAddress();
1328 
1329         _beforeTokenTransfers(from, to, tokenId, 1);
1330 
1331         // Clear approvals from the previous owner.
1332         assembly {
1333             if approvedAddress {
1334                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1335                 sstore(approvedAddressSlot, 0)
1336             }
1337         }
1338 
1339         // Underflow of the sender's balance is impossible because we check for
1340         // ownership above and the recipient's balance can't realistically overflow.
1341         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1342         unchecked {
1343             // We can directly increment and decrement the balances.
1344             --_packedAddressData[from]; // Updates: `balance -= 1`.
1345             ++_packedAddressData[to]; // Updates: `balance += 1`.
1346 
1347             // Updates:
1348             // - `address` to the next owner.
1349             // - `startTimestamp` to the timestamp of transfering.
1350             // - `burned` to `false`.
1351             // - `nextInitialized` to `true`.
1352             _packedOwnerships[tokenId] = _packOwnershipData(
1353                 to,
1354                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1355             );
1356 
1357             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1358             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1359                 uint256 nextTokenId = tokenId + 1;
1360                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1361                 if (_packedOwnerships[nextTokenId] == 0) {
1362                     // If the next slot is within bounds.
1363                     if (nextTokenId != _currentIndex) {
1364                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1365                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1366                     }
1367                 }
1368             }
1369         }
1370 
1371         emit Transfer(from, to, tokenId);
1372         _afterTokenTransfers(from, to, tokenId, 1);
1373     }
1374 
1375     /**
1376      * @dev Equivalent to `_burn(tokenId, false)`.
1377      */
1378     function _burn(uint256 tokenId) internal virtual {
1379         _burn(tokenId, false);
1380     }
1381 
1382     /**
1383      * @dev Destroys `tokenId`.
1384      * The approval is cleared when the token is burned.
1385      *
1386      * Requirements:
1387      *
1388      * - `tokenId` must exist.
1389      *
1390      * Emits a {Transfer} event.
1391      */
1392     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1393         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1394 
1395         address from = address(uint160(prevOwnershipPacked));
1396 
1397         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1398 
1399         if (approvalCheck) {
1400             // The nested ifs save around 20+ gas over a compound boolean condition.
1401             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1402                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1403         }
1404 
1405         _beforeTokenTransfers(from, address(0), tokenId, 1);
1406 
1407         // Clear approvals from the previous owner.
1408         assembly {
1409             if approvedAddress {
1410                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1411                 sstore(approvedAddressSlot, 0)
1412             }
1413         }
1414 
1415         // Underflow of the sender's balance is impossible because we check for
1416         // ownership above and the recipient's balance can't realistically overflow.
1417         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1418         unchecked {
1419             // Updates:
1420             // - `balance -= 1`.
1421             // - `numberBurned += 1`.
1422             //
1423             // We can directly decrement the balance, and increment the number burned.
1424             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1425             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1426 
1427             // Updates:
1428             // - `address` to the last owner.
1429             // - `startTimestamp` to the timestamp of burning.
1430             // - `burned` to `true`.
1431             // - `nextInitialized` to `true`.
1432             _packedOwnerships[tokenId] = _packOwnershipData(
1433                 from,
1434                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1435             );
1436 
1437             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1438             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
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
1451         emit Transfer(from, address(0), tokenId);
1452         _afterTokenTransfers(from, address(0), tokenId, 1);
1453 
1454         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1455         unchecked {
1456             _burnCounter++;
1457         }
1458     }
1459 
1460     /**
1461      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1462      *
1463      * @param from address representing the previous owner of the given token ID
1464      * @param to target address that will receive the tokens
1465      * @param tokenId uint256 ID of the token to be transferred
1466      * @param _data bytes optional data to send along with the call
1467      * @return bool whether the call correctly returned the expected magic value
1468      */
1469     function _checkContractOnERC721Received(
1470         address from,
1471         address to,
1472         uint256 tokenId,
1473         bytes memory _data
1474     ) private returns (bool) {
1475         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1476             bytes4 retval
1477         ) {
1478             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1479         } catch (bytes memory reason) {
1480             if (reason.length == 0) {
1481                 revert TransferToNonERC721ReceiverImplementer();
1482             } else {
1483                 assembly {
1484                     revert(add(32, reason), mload(reason))
1485                 }
1486             }
1487         }
1488     }
1489 
1490     /**
1491      * @dev Directly sets the extra data for the ownership data `index`.
1492      */
1493     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1494         uint256 packed = _packedOwnerships[index];
1495         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1496         uint256 extraDataCasted;
1497         // Cast `extraData` with assembly to avoid redundant masking.
1498         assembly {
1499             extraDataCasted := extraData
1500         }
1501         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1502         _packedOwnerships[index] = packed;
1503     }
1504 
1505     /**
1506      * @dev Returns the next extra data for the packed ownership data.
1507      * The returned result is shifted into position.
1508      */
1509     function _nextExtraData(
1510         address from,
1511         address to,
1512         uint256 prevOwnershipPacked
1513     ) private view returns (uint256) {
1514         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1515         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1516     }
1517 
1518     /**
1519      * @dev Called during each token transfer to set the 24bit `extraData` field.
1520      * Intended to be overridden by the cosumer contract.
1521      *
1522      * `previousExtraData` - the value of `extraData` before transfer.
1523      *
1524      * Calling conditions:
1525      *
1526      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1527      * transferred to `to`.
1528      * - When `from` is zero, `tokenId` will be minted for `to`.
1529      * - When `to` is zero, `tokenId` will be burned by `from`.
1530      * - `from` and `to` are never both zero.
1531      */
1532     function _extraData(
1533         address from,
1534         address to,
1535         uint24 previousExtraData
1536     ) internal view virtual returns (uint24) {}
1537 
1538     /**
1539      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1540      * This includes minting.
1541      * And also called before burning one token.
1542      *
1543      * startTokenId - the first token id to be transferred
1544      * quantity - the amount to be transferred
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
1562      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1563      * This includes minting.
1564      * And also called after one token has been burned.
1565      *
1566      * startTokenId - the first token id to be transferred
1567      * quantity - the amount to be transferred
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
1585      * @dev Returns the message sender (defaults to `msg.sender`).
1586      *
1587      * If you are writing GSN compatible contracts, you need to override this function.
1588      */
1589     function _msgSenderERC721A() internal view virtual returns (address) {
1590         return msg.sender;
1591     }
1592 
1593     /**
1594      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1595      */
1596     function _toString(uint256 value) internal pure returns (string memory ptr) {
1597         assembly {
1598             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1599             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1600             // We will need 1 32-byte word to store the length,
1601             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1602             ptr := add(mload(0x40), 128)
1603             // Update the free memory pointer to allocate.
1604             mstore(0x40, ptr)
1605 
1606             // Cache the end of the memory to calculate the length later.
1607             let end := ptr
1608 
1609             // We write the string from the rightmost digit to the leftmost digit.
1610             // The following is essentially a do-while loop that also handles the zero case.
1611             // Costs a bit more than early returning for the zero case,
1612             // but cheaper in terms of deployment and overall runtime costs.
1613             for {
1614                 // Initialize and perform the first pass without check.
1615                 let temp := value
1616                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1617                 ptr := sub(ptr, 1)
1618                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1619                 mstore8(ptr, add(48, mod(temp, 10)))
1620                 temp := div(temp, 10)
1621             } temp {
1622                 // Keep dividing `temp` until zero.
1623                 temp := div(temp, 10)
1624             } {
1625                 // Body of the for loop.
1626                 ptr := sub(ptr, 1)
1627                 mstore8(ptr, add(48, mod(temp, 10)))
1628             }
1629 
1630             let length := sub(end, ptr)
1631             // Move the pointer 32 bytes leftwards to make room for the length.
1632             ptr := sub(ptr, 32)
1633             // Store the length.
1634             mstore(ptr, length)
1635         }
1636     }
1637 }
1638 
1639 // File: contracts/peder.sol
1640 
1641 
1642 
1643 pragma solidity >=0.7.0 <0.9.0;
1644 
1645 
1646 
1647 
1648 
1649 contract Downsies is ERC721A, Ownable {
1650   using Strings for uint256;
1651 
1652   string public baseURI;
1653   string public baseExtension = ".json";
1654   string public notRevealedUri;
1655   uint256 public cost = 0 ether;
1656   uint256 public wlcost = 0 ether;
1657   uint256 public maxSupply = 3333;
1658   uint256 public MaxperWallet = 333;
1659   uint256 public MaxperWalletWl = 333;
1660   uint256 public MaxperTxWl = 2;
1661   uint256 public maxpertx = 5; // max mint per tx
1662   bool public paused = false;
1663   bool public revealed = false;
1664   bool public preSale = false;
1665   bool public publicSale = false;
1666   bytes32 public merkleRoot = 0x7d47dd9d8fd212164c3a9e8d23f89077455d468a3e287590d7f66b9c5ed8dcfd;
1667 
1668   constructor(
1669     string memory _initBaseURI,
1670     string memory _initNotRevealedUri
1671   ) ERC721A("Downsies", "Downsie") {
1672     setBaseURI(_initBaseURI);
1673     setNotRevealedURI(_initNotRevealedUri);
1674   }
1675 
1676   // internal
1677   function _baseURI() internal view virtual override returns (string memory) {
1678     return baseURI;
1679   }
1680       function _startTokenId() internal view virtual override returns (uint256) {
1681         return 1;
1682     }
1683 
1684   // public
1685   function mint(uint256 tokens) public payable {
1686     require(!paused, "Downsie: oops contract is paused");
1687     require(publicSale, "Downsie: Sale Hasn't started yet");
1688     uint256 supply = totalSupply();
1689     uint256 ownerTokenCount = balanceOf(_msgSender());
1690     require(tokens > 0, "Downsie: need to mint at least 1 NFT");
1691     require(tokens <= maxpertx, "Downsie: max mint amount per tx exceeded");
1692     require(supply + tokens <= maxSupply, "Downsie: We Sold Out");
1693     require(ownerTokenCount + tokens <= MaxperWallet, "Downsie: Max NFT Per Wallet exceeded");
1694     require(msg.value >= cost * tokens, "Downsie: insufficient funds");
1695 
1696       _safeMint(_msgSender(), tokens);
1697     
1698   }
1699 /// @dev presale mint for whitelisted
1700     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable  {
1701     require(!paused, "Downsie: oops contract is paused");
1702     require(preSale, "Downsie: Presale Hasn't started yet");
1703     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Downsie: You are not Whitelisted");
1704     uint256 supply = totalSupply();
1705     uint256 ownerTokenCount = balanceOf(_msgSender());
1706     require(ownerTokenCount + tokens <= MaxperWalletWl, "Downsie: Max NFT Per Wallet exceeded");
1707     require(tokens > 0, "Downsie: need to mint at least 1 NFT");
1708     require(tokens <= MaxperTxWl, "Downsie: max mint per Tx exceeded");
1709     require(supply + tokens <= maxSupply, "Downsie: Whitelist MaxSupply exceeded");
1710     require(msg.value >= wlcost * tokens, "Downsie: insufficient funds");
1711 
1712       _safeMint(_msgSender(), tokens);
1713     
1714   }
1715 
1716 
1717 
1718 
1719   /// @dev use it for giveaway and mint for yourself
1720      function gift(uint256 _mintAmount, address destination) public onlyOwner {
1721     require(_mintAmount > 0, "need to mint at least 1 NFT");
1722     uint256 supply = totalSupply();
1723     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1724 
1725       _safeMint(destination, _mintAmount);
1726     
1727   }
1728 
1729   
1730 
1731 
1732   function tokenURI(uint256 tokenId)
1733     public
1734     view
1735     virtual
1736     override
1737     returns (string memory)
1738   {
1739     require(
1740       _exists(tokenId),
1741       "ERC721AMetadata: URI query for nonexistent token"
1742     );
1743     
1744     if(revealed == false) {
1745         return notRevealedUri;
1746     }
1747 
1748     string memory currentBaseURI = _baseURI();
1749     return bytes(currentBaseURI).length > 0
1750         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1751         : "";
1752   }
1753 
1754   //only owner
1755   function reveal(bool _state) public onlyOwner {
1756       revealed = _state;
1757   }
1758 
1759   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1760         merkleRoot = _merkleRoot;
1761     }
1762   
1763   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1764     MaxperWallet = _limit;
1765   }
1766 
1767     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
1768     MaxperWalletWl = _limit;
1769   }
1770 
1771   function setmaxpertx(uint256 _maxpertx) public onlyOwner {
1772     maxpertx = _maxpertx;
1773   }
1774 
1775     function setWLMaxpertx(uint256 _wlmaxpertx) public onlyOwner {
1776     MaxperTxWl = _wlmaxpertx;
1777   }
1778   
1779   function setCost(uint256 _newCost) public onlyOwner {
1780     cost = _newCost;
1781   }
1782 
1783     function setWlCost(uint256 _newWlCost) public onlyOwner {
1784     wlcost = _newWlCost;
1785   }
1786 
1787     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1788     maxSupply = _newsupply;
1789   }
1790 
1791   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1792     baseURI = _newBaseURI;
1793   }
1794 
1795   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1796     baseExtension = _newBaseExtension;
1797   }
1798   
1799   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1800     notRevealedUri = _notRevealedURI;
1801   }
1802 
1803   function pause(bool _state) public onlyOwner {
1804     paused = _state;
1805   }
1806 
1807     function togglepreSale(bool _state) external onlyOwner {
1808         preSale = _state;
1809     }
1810 
1811     function togglepublicSale(bool _state) external onlyOwner {
1812         publicSale = _state;
1813     }
1814   
1815  
1816   function withdraw() public payable onlyOwner {
1817     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1818     require(success);
1819   }
1820 }