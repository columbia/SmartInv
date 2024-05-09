1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
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
79 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev These functions deal with verification of Merkle Tree proofs.
88  *
89  * The proofs can be generated using the JavaScript library
90  * https://github.com/miguelmota/merkletreejs[merkletreejs].
91  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
92  *
93  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
94  *
95  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
96  * hashing, or use a hash function other than keccak256 for hashing leaves.
97  * This is because the concatenation of a sorted pair of internal nodes in
98  * the merkle tree could be reinterpreted as a leaf value.
99  */
100 library MerkleProof {
101     /**
102      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
103      * defined by `root`. For this, a `proof` must be provided, containing
104      * sibling hashes on the branch from the leaf to the root of the tree. Each
105      * pair of leaves and each pair of pre-images are assumed to be sorted.
106      */
107     function verify(
108         bytes32[] memory proof,
109         bytes32 root,
110         bytes32 leaf
111     ) internal pure returns (bool) {
112         return processProof(proof, leaf) == root;
113     }
114 
115     /**
116      * @dev Calldata version of {verify}
117      *
118      * _Available since v4.7._
119      */
120     function verifyCalldata(
121         bytes32[] calldata proof,
122         bytes32 root,
123         bytes32 leaf
124     ) internal pure returns (bool) {
125         return processProofCalldata(proof, leaf) == root;
126     }
127 
128     /**
129      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
130      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
131      * hash matches the root of the tree. When processing the proof, the pairs
132      * of leafs & pre-images are assumed to be sorted.
133      *
134      * _Available since v4.4._
135      */
136     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
137         bytes32 computedHash = leaf;
138         for (uint256 i = 0; i < proof.length; i++) {
139             computedHash = _hashPair(computedHash, proof[i]);
140         }
141         return computedHash;
142     }
143 
144     /**
145      * @dev Calldata version of {processProof}
146      *
147      * _Available since v4.7._
148      */
149     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
150         bytes32 computedHash = leaf;
151         for (uint256 i = 0; i < proof.length; i++) {
152             computedHash = _hashPair(computedHash, proof[i]);
153         }
154         return computedHash;
155     }
156 
157     /**
158      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
159      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
160      *
161      * _Available since v4.7._
162      */
163     function multiProofVerify(
164         bytes32[] memory proof,
165         bool[] memory proofFlags,
166         bytes32 root,
167         bytes32[] memory leaves
168     ) internal pure returns (bool) {
169         return processMultiProof(proof, proofFlags, leaves) == root;
170     }
171 
172     /**
173      * @dev Calldata version of {multiProofVerify}
174      *
175      * _Available since v4.7._
176      */
177     function multiProofVerifyCalldata(
178         bytes32[] calldata proof,
179         bool[] calldata proofFlags,
180         bytes32 root,
181         bytes32[] memory leaves
182     ) internal pure returns (bool) {
183         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
184     }
185 
186     /**
187      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
188      * consuming from one or the other at each step according to the instructions given by
189      * `proofFlags`.
190      *
191      * _Available since v4.7._
192      */
193     function processMultiProof(
194         bytes32[] memory proof,
195         bool[] memory proofFlags,
196         bytes32[] memory leaves
197     ) internal pure returns (bytes32 merkleRoot) {
198         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
199         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
200         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
201         // the merkle tree.
202         uint256 leavesLen = leaves.length;
203         uint256 totalHashes = proofFlags.length;
204 
205         // Check proof validity.
206         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
207 
208         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
209         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
210         bytes32[] memory hashes = new bytes32[](totalHashes);
211         uint256 leafPos = 0;
212         uint256 hashPos = 0;
213         uint256 proofPos = 0;
214         // At each step, we compute the next hash using two values:
215         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
216         //   get the next hash.
217         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
218         //   `proof` array.
219         for (uint256 i = 0; i < totalHashes; i++) {
220             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
221             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
222             hashes[i] = _hashPair(a, b);
223         }
224 
225         if (totalHashes > 0) {
226             return hashes[totalHashes - 1];
227         } else if (leavesLen > 0) {
228             return leaves[0];
229         } else {
230             return proof[0];
231         }
232     }
233 
234     /**
235      * @dev Calldata version of {processMultiProof}
236      *
237      * _Available since v4.7._
238      */
239     function processMultiProofCalldata(
240         bytes32[] calldata proof,
241         bool[] calldata proofFlags,
242         bytes32[] memory leaves
243     ) internal pure returns (bytes32 merkleRoot) {
244         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
245         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
246         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
247         // the merkle tree.
248         uint256 leavesLen = leaves.length;
249         uint256 totalHashes = proofFlags.length;
250 
251         // Check proof validity.
252         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
253 
254         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
255         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
256         bytes32[] memory hashes = new bytes32[](totalHashes);
257         uint256 leafPos = 0;
258         uint256 hashPos = 0;
259         uint256 proofPos = 0;
260         // At each step, we compute the next hash using two values:
261         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
262         //   get the next hash.
263         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
264         //   `proof` array.
265         for (uint256 i = 0; i < totalHashes; i++) {
266             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
267             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
268             hashes[i] = _hashPair(a, b);
269         }
270 
271         if (totalHashes > 0) {
272             return hashes[totalHashes - 1];
273         } else if (leavesLen > 0) {
274             return leaves[0];
275         } else {
276             return proof[0];
277         }
278     }
279 
280     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
281         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
282     }
283 
284     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
285         /// @solidity memory-safe-assembly
286         assembly {
287             mstore(0x00, a)
288             mstore(0x20, b)
289             value := keccak256(0x00, 0x40)
290         }
291     }
292 }
293 
294 // File: erc721a/contracts/IERC721A.sol
295 
296 
297 // ERC721A Contracts v4.2.2
298 // Creator: Chiru Labs
299 
300 pragma solidity ^0.8.4;
301 
302 /**
303  * @dev Interface of ERC721A.
304  */
305 interface IERC721A {
306     /**
307      * The caller must own the token or be an approved operator.
308      */
309     error ApprovalCallerNotOwnerNorApproved();
310 
311     /**
312      * The token does not exist.
313      */
314     error ApprovalQueryForNonexistentToken();
315 
316     /**
317      * The caller cannot approve to their own address.
318      */
319     error ApproveToCaller();
320 
321     /**
322      * Cannot query the balance for the zero address.
323      */
324     error BalanceQueryForZeroAddress();
325 
326     /**
327      * Cannot mint to the zero address.
328      */
329     error MintToZeroAddress();
330 
331     /**
332      * The quantity of tokens minted must be more than zero.
333      */
334     error MintZeroQuantity();
335 
336     /**
337      * The token does not exist.
338      */
339     error OwnerQueryForNonexistentToken();
340 
341     /**
342      * The caller must own the token or be an approved operator.
343      */
344     error TransferCallerNotOwnerNorApproved();
345 
346     /**
347      * The token must be owned by `from`.
348      */
349     error TransferFromIncorrectOwner();
350 
351     /**
352      * Cannot safely transfer to a contract that does not implement the
353      * ERC721Receiver interface.
354      */
355     error TransferToNonERC721ReceiverImplementer();
356 
357     /**
358      * Cannot transfer to the zero address.
359      */
360     error TransferToZeroAddress();
361 
362     /**
363      * The token does not exist.
364      */
365     error URIQueryForNonexistentToken();
366 
367     /**
368      * The `quantity` minted with ERC2309 exceeds the safety limit.
369      */
370     error MintERC2309QuantityExceedsLimit();
371 
372     /**
373      * The `extraData` cannot be set on an unintialized ownership slot.
374      */
375     error OwnershipNotInitializedForExtraData();
376 
377     // =============================================================
378     //                            STRUCTS
379     // =============================================================
380 
381     struct TokenOwnership {
382         // The address of the owner.
383         address addr;
384         // Stores the start time of ownership with minimal overhead for tokenomics.
385         uint64 startTimestamp;
386         // Whether the token has been burned.
387         bool burned;
388         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
389         uint24 extraData;
390     }
391 
392     // =============================================================
393     //                         TOKEN COUNTERS
394     // =============================================================
395 
396     /**
397      * @dev Returns the total number of tokens in existence.
398      * Burned tokens will reduce the count.
399      * To get the total number of tokens minted, please see {_totalMinted}.
400      */
401     function totalSupply() external view returns (uint256);
402 
403     // =============================================================
404     //                            IERC165
405     // =============================================================
406 
407     /**
408      * @dev Returns true if this contract implements the interface defined by
409      * `interfaceId`. See the corresponding
410      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
411      * to learn more about how these ids are created.
412      *
413      * This function call must use less than 30000 gas.
414      */
415     function supportsInterface(bytes4 interfaceId) external view returns (bool);
416 
417     // =============================================================
418     //                            IERC721
419     // =============================================================
420 
421     /**
422      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
425 
426     /**
427      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
428      */
429     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables or disables
433      * (`approved`) `operator` to manage all of its assets.
434      */
435     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
436 
437     /**
438      * @dev Returns the number of tokens in `owner`'s account.
439      */
440     function balanceOf(address owner) external view returns (uint256 balance);
441 
442     /**
443      * @dev Returns the owner of the `tokenId` token.
444      *
445      * Requirements:
446      *
447      * - `tokenId` must exist.
448      */
449     function ownerOf(uint256 tokenId) external view returns (address owner);
450 
451     /**
452      * @dev Safely transfers `tokenId` token from `from` to `to`,
453      * checking first that contract recipients are aware of the ERC721 protocol
454      * to prevent tokens from being forever locked.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be have been allowed to move
462      * this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement
464      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes calldata data
473     ) external;
474 
475     /**
476      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId
482     ) external;
483 
484     /**
485      * @dev Transfers `tokenId` from `from` to `to`.
486      *
487      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
488      * whenever possible.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must be owned by `from`.
495      * - If the caller is not `from`, it must be approved to move this token
496      * by either {approve} or {setApprovalForAll}.
497      *
498      * Emits a {Transfer} event.
499      */
500     function transferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
508      * The approval is cleared when the token is transferred.
509      *
510      * Only a single account can be approved at a time, so approving the
511      * zero address clears previous approvals.
512      *
513      * Requirements:
514      *
515      * - The caller must own the token or be an approved operator.
516      * - `tokenId` must exist.
517      *
518      * Emits an {Approval} event.
519      */
520     function approve(address to, uint256 tokenId) external;
521 
522     /**
523      * @dev Approve or remove `operator` as an operator for the caller.
524      * Operators can call {transferFrom} or {safeTransferFrom}
525      * for any token owned by the caller.
526      *
527      * Requirements:
528      *
529      * - The `operator` cannot be the caller.
530      *
531      * Emits an {ApprovalForAll} event.
532      */
533     function setApprovalForAll(address operator, bool _approved) external;
534 
535     /**
536      * @dev Returns the account approved for `tokenId` token.
537      *
538      * Requirements:
539      *
540      * - `tokenId` must exist.
541      */
542     function getApproved(uint256 tokenId) external view returns (address operator);
543 
544     /**
545      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
546      *
547      * See {setApprovalForAll}.
548      */
549     function isApprovedForAll(address owner, address operator) external view returns (bool);
550 
551     // =============================================================
552     //                        IERC721Metadata
553     // =============================================================
554 
555     /**
556      * @dev Returns the token collection name.
557      */
558     function name() external view returns (string memory);
559 
560     /**
561      * @dev Returns the token collection symbol.
562      */
563     function symbol() external view returns (string memory);
564 
565     /**
566      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
567      */
568     function tokenURI(uint256 tokenId) external view returns (string memory);
569 
570     // =============================================================
571     //                           IERC2309
572     // =============================================================
573 
574     /**
575      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
576      * (inclusive) is transferred from `from` to `to`, as defined in the
577      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
578      *
579      * See {_mintERC2309} for more details.
580      */
581     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
582 }
583 
584 // File: erc721a/contracts/ERC721A.sol
585 
586 
587 // ERC721A Contracts v4.2.2
588 // Creator: Chiru Labs
589 
590 pragma solidity ^0.8.4;
591 
592 
593 /**
594  * @dev Interface of ERC721 token receiver.
595  */
596 interface ERC721A__IERC721Receiver {
597     function onERC721Received(
598         address operator,
599         address from,
600         uint256 tokenId,
601         bytes calldata data
602     ) external returns (bytes4);
603 }
604 
605 /**
606  * @title ERC721A
607  *
608  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
609  * Non-Fungible Token Standard, including the Metadata extension.
610  * Optimized for lower gas during batch mints.
611  *
612  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
613  * starting from `_startTokenId()`.
614  *
615  * Assumptions:
616  *
617  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
618  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
619  */
620 contract ERC721A is IERC721A {
621     // Reference type for token approval.
622     struct TokenApprovalRef {
623         address value;
624     }
625 
626     // =============================================================
627     //                           CONSTANTS
628     // =============================================================
629 
630     // Mask of an entry in packed address data.
631     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
632 
633     // The bit position of `numberMinted` in packed address data.
634     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
635 
636     // The bit position of `numberBurned` in packed address data.
637     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
638 
639     // The bit position of `aux` in packed address data.
640     uint256 private constant _BITPOS_AUX = 192;
641 
642     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
643     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
644 
645     // The bit position of `startTimestamp` in packed ownership.
646     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
647 
648     // The bit mask of the `burned` bit in packed ownership.
649     uint256 private constant _BITMASK_BURNED = 1 << 224;
650 
651     // The bit position of the `nextInitialized` bit in packed ownership.
652     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
653 
654     // The bit mask of the `nextInitialized` bit in packed ownership.
655     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
656 
657     // The bit position of `extraData` in packed ownership.
658     uint256 private constant _BITPOS_EXTRA_DATA = 232;
659 
660     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
661     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
662 
663     // The mask of the lower 160 bits for addresses.
664     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
665 
666     // The maximum `quantity` that can be minted with {_mintERC2309}.
667     // This limit is to prevent overflows on the address data entries.
668     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
669     // is required to cause an overflow, which is unrealistic.
670     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
671 
672     // The `Transfer` event signature is given by:
673     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
674     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
675         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
676 
677     // =============================================================
678     //                            STORAGE
679     // =============================================================
680 
681     // The next token ID to be minted.
682     uint256 private _currentIndex;
683 
684     // The number of tokens burned.
685     uint256 private _burnCounter;
686 
687     // Token name
688     string private _name;
689 
690     // Token symbol
691     string private _symbol;
692 
693     // Mapping from token ID to ownership details
694     // An empty struct value does not necessarily mean the token is unowned.
695     // See {_packedOwnershipOf} implementation for details.
696     //
697     // Bits Layout:
698     // - [0..159]   `addr`
699     // - [160..223] `startTimestamp`
700     // - [224]      `burned`
701     // - [225]      `nextInitialized`
702     // - [232..255] `extraData`
703     mapping(uint256 => uint256) private _packedOwnerships;
704 
705     // Mapping owner address to address data.
706     //
707     // Bits Layout:
708     // - [0..63]    `balance`
709     // - [64..127]  `numberMinted`
710     // - [128..191] `numberBurned`
711     // - [192..255] `aux`
712     mapping(address => uint256) private _packedAddressData;
713 
714     // Mapping from token ID to approved address.
715     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
716 
717     // Mapping from owner to operator approvals
718     mapping(address => mapping(address => bool)) private _operatorApprovals;
719 
720     // =============================================================
721     //                          CONSTRUCTOR
722     // =============================================================
723 
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727         _currentIndex = _startTokenId();
728     }
729 
730     // =============================================================
731     //                   TOKEN COUNTING OPERATIONS
732     // =============================================================
733 
734     /**
735      * @dev Returns the starting token ID.
736      * To change the starting token ID, please override this function.
737      */
738     function _startTokenId() internal view virtual returns (uint256) {
739         return 0;
740     }
741 
742     /**
743      * @dev Returns the next token ID to be minted.
744      */
745     function _nextTokenId() internal view virtual returns (uint256) {
746         return _currentIndex;
747     }
748 
749     /**
750      * @dev Returns the total number of tokens in existence.
751      * Burned tokens will reduce the count.
752      * To get the total number of tokens minted, please see {_totalMinted}.
753      */
754     function totalSupply() public view virtual override returns (uint256) {
755         // Counter underflow is impossible as _burnCounter cannot be incremented
756         // more than `_currentIndex - _startTokenId()` times.
757         unchecked {
758             return _currentIndex - _burnCounter - _startTokenId();
759         }
760     }
761 
762     /**
763      * @dev Returns the total amount of tokens minted in the contract.
764      */
765     function _totalMinted() internal view virtual returns (uint256) {
766         // Counter underflow is impossible as `_currentIndex` does not decrement,
767         // and it is initialized to `_startTokenId()`.
768         unchecked {
769             return _currentIndex - _startTokenId();
770         }
771     }
772 
773     /**
774      * @dev Returns the total number of tokens burned.
775      */
776     function _totalBurned() internal view virtual returns (uint256) {
777         return _burnCounter;
778     }
779 
780     // =============================================================
781     //                    ADDRESS DATA OPERATIONS
782     // =============================================================
783 
784     /**
785      * @dev Returns the number of tokens in `owner`'s account.
786      */
787     function balanceOf(address owner) public view virtual override returns (uint256) {
788         if (owner == address(0)) revert BalanceQueryForZeroAddress();
789         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
790     }
791 
792     /**
793      * Returns the number of tokens minted by `owner`.
794      */
795     function _numberMinted(address owner) internal view returns (uint256) {
796         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
797     }
798 
799     /**
800      * Returns the number of tokens burned by or on behalf of `owner`.
801      */
802     function _numberBurned(address owner) internal view returns (uint256) {
803         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
804     }
805 
806     /**
807      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
808      */
809     function _getAux(address owner) internal view returns (uint64) {
810         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
811     }
812 
813     /**
814      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
815      * If there are multiple variables, please pack them into a uint64.
816      */
817     function _setAux(address owner, uint64 aux) internal virtual {
818         uint256 packed = _packedAddressData[owner];
819         uint256 auxCasted;
820         // Cast `aux` with assembly to avoid redundant masking.
821         assembly {
822             auxCasted := aux
823         }
824         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
825         _packedAddressData[owner] = packed;
826     }
827 
828     // =============================================================
829     //                            IERC165
830     // =============================================================
831 
832     /**
833      * @dev Returns true if this contract implements the interface defined by
834      * `interfaceId`. See the corresponding
835      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
836      * to learn more about how these ids are created.
837      *
838      * This function call must use less than 30000 gas.
839      */
840     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
841         // The interface IDs are constants representing the first 4 bytes
842         // of the XOR of all function selectors in the interface.
843         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
844         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
845         return
846             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
847             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
848             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
849     }
850 
851     // =============================================================
852     //                        IERC721Metadata
853     // =============================================================
854 
855     /**
856      * @dev Returns the token collection name.
857      */
858     function name() public view virtual override returns (string memory) {
859         return _name;
860     }
861 
862     /**
863      * @dev Returns the token collection symbol.
864      */
865     function symbol() public view virtual override returns (string memory) {
866         return _symbol;
867     }
868 
869     /**
870      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
871      */
872     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
873         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
874 
875         string memory baseURI = _baseURI();
876         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
877     }
878 
879     /**
880      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
881      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
882      * by default, it can be overridden in child contracts.
883      */
884     function _baseURI() internal view virtual returns (string memory) {
885         return '';
886     }
887 
888     // =============================================================
889     //                     OWNERSHIPS OPERATIONS
890     // =============================================================
891 
892     /**
893      * @dev Returns the owner of the `tokenId` token.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
900         return address(uint160(_packedOwnershipOf(tokenId)));
901     }
902 
903     /**
904      * @dev Gas spent here starts off proportional to the maximum mint batch size.
905      * It gradually moves to O(1) as tokens get transferred around over time.
906      */
907     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
908         return _unpackedOwnership(_packedOwnershipOf(tokenId));
909     }
910 
911     /**
912      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
913      */
914     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
915         return _unpackedOwnership(_packedOwnerships[index]);
916     }
917 
918     /**
919      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
920      */
921     function _initializeOwnershipAt(uint256 index) internal virtual {
922         if (_packedOwnerships[index] == 0) {
923             _packedOwnerships[index] = _packedOwnershipOf(index);
924         }
925     }
926 
927     /**
928      * Returns the packed ownership data of `tokenId`.
929      */
930     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
931         uint256 curr = tokenId;
932 
933         unchecked {
934             if (_startTokenId() <= curr)
935                 if (curr < _currentIndex) {
936                     uint256 packed = _packedOwnerships[curr];
937                     // If not burned.
938                     if (packed & _BITMASK_BURNED == 0) {
939                         // Invariant:
940                         // There will always be an initialized ownership slot
941                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
942                         // before an unintialized ownership slot
943                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
944                         // Hence, `curr` will not underflow.
945                         //
946                         // We can directly compare the packed value.
947                         // If the address is zero, packed will be zero.
948                         while (packed == 0) {
949                             packed = _packedOwnerships[--curr];
950                         }
951                         return packed;
952                     }
953                 }
954         }
955         revert OwnerQueryForNonexistentToken();
956     }
957 
958     /**
959      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
960      */
961     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
962         ownership.addr = address(uint160(packed));
963         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
964         ownership.burned = packed & _BITMASK_BURNED != 0;
965         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
966     }
967 
968     /**
969      * @dev Packs ownership data into a single uint256.
970      */
971     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
972         assembly {
973             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
974             owner := and(owner, _BITMASK_ADDRESS)
975             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
976             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
977         }
978     }
979 
980     /**
981      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
982      */
983     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
984         // For branchless setting of the `nextInitialized` flag.
985         assembly {
986             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
987             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
988         }
989     }
990 
991     // =============================================================
992     //                      APPROVAL OPERATIONS
993     // =============================================================
994 
995     /**
996      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
997      * The approval is cleared when the token is transferred.
998      *
999      * Only a single account can be approved at a time, so approving the
1000      * zero address clears previous approvals.
1001      *
1002      * Requirements:
1003      *
1004      * - The caller must own the token or be an approved operator.
1005      * - `tokenId` must exist.
1006      *
1007      * Emits an {Approval} event.
1008      */
1009     function approve(address to, uint256 tokenId) public virtual override {
1010         address owner = ownerOf(tokenId);
1011 
1012         if (_msgSenderERC721A() != owner)
1013             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1014                 revert ApprovalCallerNotOwnerNorApproved();
1015             }
1016 
1017         _tokenApprovals[tokenId].value = to;
1018         emit Approval(owner, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Returns the account approved for `tokenId` token.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must exist.
1027      */
1028     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1029         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1030 
1031         return _tokenApprovals[tokenId].value;
1032     }
1033 
1034     /**
1035      * @dev Approve or remove `operator` as an operator for the caller.
1036      * Operators can call {transferFrom} or {safeTransferFrom}
1037      * for any token owned by the caller.
1038      *
1039      * Requirements:
1040      *
1041      * - The `operator` cannot be the caller.
1042      *
1043      * Emits an {ApprovalForAll} event.
1044      */
1045     function setApprovalForAll(address operator, bool approved) public virtual override {
1046         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1047 
1048         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1049         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1050     }
1051 
1052     /**
1053      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1054      *
1055      * See {setApprovalForAll}.
1056      */
1057     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1058         return _operatorApprovals[owner][operator];
1059     }
1060 
1061     /**
1062      * @dev Returns whether `tokenId` exists.
1063      *
1064      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1065      *
1066      * Tokens start existing when they are minted. See {_mint}.
1067      */
1068     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1069         return
1070             _startTokenId() <= tokenId &&
1071             tokenId < _currentIndex && // If within bounds,
1072             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1073     }
1074 
1075     /**
1076      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1077      */
1078     function _isSenderApprovedOrOwner(
1079         address approvedAddress,
1080         address owner,
1081         address msgSender
1082     ) private pure returns (bool result) {
1083         assembly {
1084             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1085             owner := and(owner, _BITMASK_ADDRESS)
1086             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1087             msgSender := and(msgSender, _BITMASK_ADDRESS)
1088             // `msgSender == owner || msgSender == approvedAddress`.
1089             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1090         }
1091     }
1092 
1093     /**
1094      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1095      */
1096     function _getApprovedSlotAndAddress(uint256 tokenId)
1097         private
1098         view
1099         returns (uint256 approvedAddressSlot, address approvedAddress)
1100     {
1101         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1102         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1103         assembly {
1104             approvedAddressSlot := tokenApproval.slot
1105             approvedAddress := sload(approvedAddressSlot)
1106         }
1107     }
1108 
1109     // =============================================================
1110     //                      TRANSFER OPERATIONS
1111     // =============================================================
1112 
1113     /**
1114      * @dev Transfers `tokenId` from `from` to `to`.
1115      *
1116      * Requirements:
1117      *
1118      * - `from` cannot be the zero address.
1119      * - `to` cannot be the zero address.
1120      * - `tokenId` token must be owned by `from`.
1121      * - If the caller is not `from`, it must be approved to move this token
1122      * by either {approve} or {setApprovalForAll}.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function transferFrom(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) public virtual override {
1131         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1132 
1133         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1134 
1135         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1136 
1137         // The nested ifs save around 20+ gas over a compound boolean condition.
1138         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1139             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1140 
1141         if (to == address(0)) revert TransferToZeroAddress();
1142 
1143         _beforeTokenTransfers(from, to, tokenId, 1);
1144 
1145         // Clear approvals from the previous owner.
1146         assembly {
1147             if approvedAddress {
1148                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1149                 sstore(approvedAddressSlot, 0)
1150             }
1151         }
1152 
1153         // Underflow of the sender's balance is impossible because we check for
1154         // ownership above and the recipient's balance can't realistically overflow.
1155         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1156         unchecked {
1157             // We can directly increment and decrement the balances.
1158             --_packedAddressData[from]; // Updates: `balance -= 1`.
1159             ++_packedAddressData[to]; // Updates: `balance += 1`.
1160 
1161             // Updates:
1162             // - `address` to the next owner.
1163             // - `startTimestamp` to the timestamp of transfering.
1164             // - `burned` to `false`.
1165             // - `nextInitialized` to `true`.
1166             _packedOwnerships[tokenId] = _packOwnershipData(
1167                 to,
1168                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1169             );
1170 
1171             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1172             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1173                 uint256 nextTokenId = tokenId + 1;
1174                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1175                 if (_packedOwnerships[nextTokenId] == 0) {
1176                     // If the next slot is within bounds.
1177                     if (nextTokenId != _currentIndex) {
1178                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1179                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1180                     }
1181                 }
1182             }
1183         }
1184 
1185         emit Transfer(from, to, tokenId);
1186         _afterTokenTransfers(from, to, tokenId, 1);
1187     }
1188 
1189     /**
1190      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1191      */
1192     function safeTransferFrom(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) public virtual override {
1197         safeTransferFrom(from, to, tokenId, '');
1198     }
1199 
1200     /**
1201      * @dev Safely transfers `tokenId` token from `from` to `to`.
1202      *
1203      * Requirements:
1204      *
1205      * - `from` cannot be the zero address.
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must exist and be owned by `from`.
1208      * - If the caller is not `from`, it must be approved to move this token
1209      * by either {approve} or {setApprovalForAll}.
1210      * - If `to` refers to a smart contract, it must implement
1211      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function safeTransferFrom(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) public virtual override {
1221         transferFrom(from, to, tokenId);
1222         if (to.code.length != 0)
1223             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1224                 revert TransferToNonERC721ReceiverImplementer();
1225             }
1226     }
1227 
1228     /**
1229      * @dev Hook that is called before a set of serially-ordered token IDs
1230      * are about to be transferred. This includes minting.
1231      * And also called before burning one token.
1232      *
1233      * `startTokenId` - the first token ID to be transferred.
1234      * `quantity` - the amount to be transferred.
1235      *
1236      * Calling conditions:
1237      *
1238      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1239      * transferred to `to`.
1240      * - When `from` is zero, `tokenId` will be minted for `to`.
1241      * - When `to` is zero, `tokenId` will be burned by `from`.
1242      * - `from` and `to` are never both zero.
1243      */
1244     function _beforeTokenTransfers(
1245         address from,
1246         address to,
1247         uint256 startTokenId,
1248         uint256 quantity
1249     ) internal virtual {}
1250 
1251     /**
1252      * @dev Hook that is called after a set of serially-ordered token IDs
1253      * have been transferred. This includes minting.
1254      * And also called after one token has been burned.
1255      *
1256      * `startTokenId` - the first token ID to be transferred.
1257      * `quantity` - the amount to be transferred.
1258      *
1259      * Calling conditions:
1260      *
1261      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1262      * transferred to `to`.
1263      * - When `from` is zero, `tokenId` has been minted for `to`.
1264      * - When `to` is zero, `tokenId` has been burned by `from`.
1265      * - `from` and `to` are never both zero.
1266      */
1267     function _afterTokenTransfers(
1268         address from,
1269         address to,
1270         uint256 startTokenId,
1271         uint256 quantity
1272     ) internal virtual {}
1273 
1274     /**
1275      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1276      *
1277      * `from` - Previous owner of the given token ID.
1278      * `to` - Target address that will receive the token.
1279      * `tokenId` - Token ID to be transferred.
1280      * `_data` - Optional data to send along with the call.
1281      *
1282      * Returns whether the call correctly returned the expected magic value.
1283      */
1284     function _checkContractOnERC721Received(
1285         address from,
1286         address to,
1287         uint256 tokenId,
1288         bytes memory _data
1289     ) private returns (bool) {
1290         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1291             bytes4 retval
1292         ) {
1293             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1294         } catch (bytes memory reason) {
1295             if (reason.length == 0) {
1296                 revert TransferToNonERC721ReceiverImplementer();
1297             } else {
1298                 assembly {
1299                     revert(add(32, reason), mload(reason))
1300                 }
1301             }
1302         }
1303     }
1304 
1305     // =============================================================
1306     //                        MINT OPERATIONS
1307     // =============================================================
1308 
1309     /**
1310      * @dev Mints `quantity` tokens and transfers them to `to`.
1311      *
1312      * Requirements:
1313      *
1314      * - `to` cannot be the zero address.
1315      * - `quantity` must be greater than 0.
1316      *
1317      * Emits a {Transfer} event for each mint.
1318      */
1319     function _mint(address to, uint256 quantity) internal virtual {
1320         uint256 startTokenId = _currentIndex;
1321         if (quantity == 0) revert MintZeroQuantity();
1322 
1323         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1324 
1325         // Overflows are incredibly unrealistic.
1326         // `balance` and `numberMinted` have a maximum limit of 2**64.
1327         // `tokenId` has a maximum limit of 2**256.
1328         unchecked {
1329             // Updates:
1330             // - `balance += quantity`.
1331             // - `numberMinted += quantity`.
1332             //
1333             // We can directly add to the `balance` and `numberMinted`.
1334             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1335 
1336             // Updates:
1337             // - `address` to the owner.
1338             // - `startTimestamp` to the timestamp of minting.
1339             // - `burned` to `false`.
1340             // - `nextInitialized` to `quantity == 1`.
1341             _packedOwnerships[startTokenId] = _packOwnershipData(
1342                 to,
1343                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1344             );
1345 
1346             uint256 toMasked;
1347             uint256 end = startTokenId + quantity;
1348 
1349             // Use assembly to loop and emit the `Transfer` event for gas savings.
1350             assembly {
1351                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1352                 toMasked := and(to, _BITMASK_ADDRESS)
1353                 // Emit the `Transfer` event.
1354                 log4(
1355                     0, // Start of data (0, since no data).
1356                     0, // End of data (0, since no data).
1357                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1358                     0, // `address(0)`.
1359                     toMasked, // `to`.
1360                     startTokenId // `tokenId`.
1361                 )
1362 
1363                 for {
1364                     let tokenId := add(startTokenId, 1)
1365                 } iszero(eq(tokenId, end)) {
1366                     tokenId := add(tokenId, 1)
1367                 } {
1368                     // Emit the `Transfer` event. Similar to above.
1369                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1370                 }
1371             }
1372             if (toMasked == 0) revert MintToZeroAddress();
1373 
1374             _currentIndex = end;
1375         }
1376         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1377     }
1378 
1379     /**
1380      * @dev Mints `quantity` tokens and transfers them to `to`.
1381      *
1382      * This function is intended for efficient minting only during contract creation.
1383      *
1384      * It emits only one {ConsecutiveTransfer} as defined in
1385      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1386      * instead of a sequence of {Transfer} event(s).
1387      *
1388      * Calling this function outside of contract creation WILL make your contract
1389      * non-compliant with the ERC721 standard.
1390      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1391      * {ConsecutiveTransfer} event is only permissible during contract creation.
1392      *
1393      * Requirements:
1394      *
1395      * - `to` cannot be the zero address.
1396      * - `quantity` must be greater than 0.
1397      *
1398      * Emits a {ConsecutiveTransfer} event.
1399      */
1400     function _mintERC2309(address to, uint256 quantity) internal virtual {
1401         uint256 startTokenId = _currentIndex;
1402         if (to == address(0)) revert MintToZeroAddress();
1403         if (quantity == 0) revert MintZeroQuantity();
1404         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1405 
1406         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1407 
1408         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1409         unchecked {
1410             // Updates:
1411             // - `balance += quantity`.
1412             // - `numberMinted += quantity`.
1413             //
1414             // We can directly add to the `balance` and `numberMinted`.
1415             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1416 
1417             // Updates:
1418             // - `address` to the owner.
1419             // - `startTimestamp` to the timestamp of minting.
1420             // - `burned` to `false`.
1421             // - `nextInitialized` to `quantity == 1`.
1422             _packedOwnerships[startTokenId] = _packOwnershipData(
1423                 to,
1424                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1425             );
1426 
1427             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1428 
1429             _currentIndex = startTokenId + quantity;
1430         }
1431         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1432     }
1433 
1434     /**
1435      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1436      *
1437      * Requirements:
1438      *
1439      * - If `to` refers to a smart contract, it must implement
1440      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1441      * - `quantity` must be greater than 0.
1442      *
1443      * See {_mint}.
1444      *
1445      * Emits a {Transfer} event for each mint.
1446      */
1447     function _safeMint(
1448         address to,
1449         uint256 quantity,
1450         bytes memory _data
1451     ) internal virtual {
1452         _mint(to, quantity);
1453 
1454         unchecked {
1455             if (to.code.length != 0) {
1456                 uint256 end = _currentIndex;
1457                 uint256 index = end - quantity;
1458                 do {
1459                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1460                         revert TransferToNonERC721ReceiverImplementer();
1461                     }
1462                 } while (index < end);
1463                 // Reentrancy protection.
1464                 if (_currentIndex != end) revert();
1465             }
1466         }
1467     }
1468 
1469     /**
1470      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1471      */
1472     function _safeMint(address to, uint256 quantity) internal virtual {
1473         _safeMint(to, quantity, '');
1474     }
1475 
1476     // =============================================================
1477     //                        BURN OPERATIONS
1478     // =============================================================
1479 
1480     /**
1481      * @dev Equivalent to `_burn(tokenId, false)`.
1482      */
1483     function _burn(uint256 tokenId) internal virtual {
1484         _burn(tokenId, false);
1485     }
1486 
1487     /**
1488      * @dev Destroys `tokenId`.
1489      * The approval is cleared when the token is burned.
1490      *
1491      * Requirements:
1492      *
1493      * - `tokenId` must exist.
1494      *
1495      * Emits a {Transfer} event.
1496      */
1497     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1498         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1499 
1500         address from = address(uint160(prevOwnershipPacked));
1501 
1502         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1503 
1504         if (approvalCheck) {
1505             // The nested ifs save around 20+ gas over a compound boolean condition.
1506             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1507                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1508         }
1509 
1510         _beforeTokenTransfers(from, address(0), tokenId, 1);
1511 
1512         // Clear approvals from the previous owner.
1513         assembly {
1514             if approvedAddress {
1515                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1516                 sstore(approvedAddressSlot, 0)
1517             }
1518         }
1519 
1520         // Underflow of the sender's balance is impossible because we check for
1521         // ownership above and the recipient's balance can't realistically overflow.
1522         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1523         unchecked {
1524             // Updates:
1525             // - `balance -= 1`.
1526             // - `numberBurned += 1`.
1527             //
1528             // We can directly decrement the balance, and increment the number burned.
1529             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1530             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1531 
1532             // Updates:
1533             // - `address` to the last owner.
1534             // - `startTimestamp` to the timestamp of burning.
1535             // - `burned` to `true`.
1536             // - `nextInitialized` to `true`.
1537             _packedOwnerships[tokenId] = _packOwnershipData(
1538                 from,
1539                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1540             );
1541 
1542             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1543             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1544                 uint256 nextTokenId = tokenId + 1;
1545                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1546                 if (_packedOwnerships[nextTokenId] == 0) {
1547                     // If the next slot is within bounds.
1548                     if (nextTokenId != _currentIndex) {
1549                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1550                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1551                     }
1552                 }
1553             }
1554         }
1555 
1556         emit Transfer(from, address(0), tokenId);
1557         _afterTokenTransfers(from, address(0), tokenId, 1);
1558 
1559         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1560         unchecked {
1561             _burnCounter++;
1562         }
1563     }
1564 
1565     // =============================================================
1566     //                     EXTRA DATA OPERATIONS
1567     // =============================================================
1568 
1569     /**
1570      * @dev Directly sets the extra data for the ownership data `index`.
1571      */
1572     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1573         uint256 packed = _packedOwnerships[index];
1574         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1575         uint256 extraDataCasted;
1576         // Cast `extraData` with assembly to avoid redundant masking.
1577         assembly {
1578             extraDataCasted := extraData
1579         }
1580         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1581         _packedOwnerships[index] = packed;
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
1605      * @dev Returns the next extra data for the packed ownership data.
1606      * The returned result is shifted into position.
1607      */
1608     function _nextExtraData(
1609         address from,
1610         address to,
1611         uint256 prevOwnershipPacked
1612     ) private view returns (uint256) {
1613         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1614         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1615     }
1616 
1617     // =============================================================
1618     //                       OTHER OPERATIONS
1619     // =============================================================
1620 
1621     /**
1622      * @dev Returns the message sender (defaults to `msg.sender`).
1623      *
1624      * If you are writing GSN compatible contracts, you need to override this function.
1625      */
1626     function _msgSenderERC721A() internal view virtual returns (address) {
1627         return msg.sender;
1628     }
1629 
1630     /**
1631      * @dev Converts a uint256 to its ASCII string decimal representation.
1632      */
1633     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1634         assembly {
1635             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1636             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1637             // We will need 1 32-byte word to store the length,
1638             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1639             str := add(mload(0x40), 0x80)
1640             // Update the free memory pointer to allocate.
1641             mstore(0x40, str)
1642 
1643             // Cache the end of the memory to calculate the length later.
1644             let end := str
1645 
1646             // We write the string from rightmost digit to leftmost digit.
1647             // The following is essentially a do-while loop that also handles the zero case.
1648             // prettier-ignore
1649             for { let temp := value } 1 {} {
1650                 str := sub(str, 1)
1651                 // Write the character to the pointer.
1652                 // The ASCII index of the '0' character is 48.
1653                 mstore8(str, add(48, mod(temp, 10)))
1654                 // Keep dividing `temp` until zero.
1655                 temp := div(temp, 10)
1656                 // prettier-ignore
1657                 if iszero(temp) { break }
1658             }
1659 
1660             let length := sub(end, str)
1661             // Move the pointer 32 bytes leftwards to make room for the length.
1662             str := sub(str, 0x20)
1663             // Store the length.
1664             mstore(str, length)
1665         }
1666     }
1667 }
1668 
1669 // File: @openzeppelin/contracts/utils/Context.sol
1670 
1671 
1672 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1673 
1674 pragma solidity ^0.8.0;
1675 
1676 /**
1677  * @dev Provides information about the current execution context, including the
1678  * sender of the transaction and its data. While these are generally available
1679  * via msg.sender and msg.data, they should not be accessed in such a direct
1680  * manner, since when dealing with meta-transactions the account sending and
1681  * paying for execution may not be the actual sender (as far as an application
1682  * is concerned).
1683  *
1684  * This contract is only required for intermediate, library-like contracts.
1685  */
1686 abstract contract Context {
1687     function _msgSender() internal view virtual returns (address) {
1688         return msg.sender;
1689     }
1690 
1691     function _msgData() internal view virtual returns (bytes calldata) {
1692         return msg.data;
1693     }
1694 }
1695 
1696 // File: @openzeppelin/contracts/access/Ownable.sol
1697 
1698 
1699 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1700 
1701 pragma solidity ^0.8.0;
1702 
1703 
1704 /**
1705  * @dev Contract module which provides a basic access control mechanism, where
1706  * there is an account (an owner) that can be granted exclusive access to
1707  * specific functions.
1708  *
1709  * By default, the owner account will be the one that deploys the contract. This
1710  * can later be changed with {transferOwnership}.
1711  *
1712  * This module is used through inheritance. It will make available the modifier
1713  * `onlyOwner`, which can be applied to your functions to restrict their use to
1714  * the owner.
1715  */
1716 abstract contract Ownable is Context {
1717     address private _owner;
1718 
1719     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1720 
1721     /**
1722      * @dev Initializes the contract setting the deployer as the initial owner.
1723      */
1724     constructor() {
1725         _transferOwnership(_msgSender());
1726     }
1727 
1728     /**
1729      * @dev Throws if called by any account other than the owner.
1730      */
1731     modifier onlyOwner() {
1732         _checkOwner();
1733         _;
1734     }
1735 
1736     /**
1737      * @dev Returns the address of the current owner.
1738      */
1739     function owner() public view virtual returns (address) {
1740         return _owner;
1741     }
1742 
1743     /**
1744      * @dev Throws if the sender is not the owner.
1745      */
1746     function _checkOwner() internal view virtual {
1747         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1748     }
1749 
1750     /**
1751      * @dev Leaves the contract without owner. It will not be possible to call
1752      * `onlyOwner` functions anymore. Can only be called by the current owner.
1753      *
1754      * NOTE: Renouncing ownership will leave the contract without an owner,
1755      * thereby removing any functionality that is only available to the owner.
1756      */
1757     function renounceOwnership() public virtual onlyOwner {
1758         _transferOwnership(address(0));
1759     }
1760 
1761     /**
1762      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1763      * Can only be called by the current owner.
1764      */
1765     function transferOwnership(address newOwner) public virtual onlyOwner {
1766         require(newOwner != address(0), "Ownable: new owner is the zero address");
1767         _transferOwnership(newOwner);
1768     }
1769 
1770     /**
1771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1772      * Internal function without access restriction.
1773      */
1774     function _transferOwnership(address newOwner) internal virtual {
1775         address oldOwner = _owner;
1776         _owner = newOwner;
1777         emit OwnershipTransferred(oldOwner, newOwner);
1778     }
1779 }
1780 
1781 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1782 
1783 
1784 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1785 
1786 pragma solidity ^0.8.0;
1787 
1788 /**
1789  * @dev Contract module that helps prevent reentrant calls to a function.
1790  *
1791  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1792  * available, which can be applied to functions to make sure there are no nested
1793  * (reentrant) calls to them.
1794  *
1795  * Note that because there is a single `nonReentrant` guard, functions marked as
1796  * `nonReentrant` may not call one another. This can be worked around by making
1797  * those functions `private`, and then adding `external` `nonReentrant` entry
1798  * points to them.
1799  *
1800  * TIP: If you would like to learn more about reentrancy and alternative ways
1801  * to protect against it, check out our blog post
1802  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1803  */
1804 abstract contract ReentrancyGuard {
1805     // Booleans are more expensive than uint256 or any type that takes up a full
1806     // word because each write operation emits an extra SLOAD to first read the
1807     // slot's contents, replace the bits taken up by the boolean, and then write
1808     // back. This is the compiler's defense against contract upgrades and
1809     // pointer aliasing, and it cannot be disabled.
1810 
1811     // The values being non-zero value makes deployment a bit more expensive,
1812     // but in exchange the refund on every call to nonReentrant will be lower in
1813     // amount. Since refunds are capped to a percentage of the total
1814     // transaction's gas, it is best to keep them low in cases like this one, to
1815     // increase the likelihood of the full refund coming into effect.
1816     uint256 private constant _NOT_ENTERED = 1;
1817     uint256 private constant _ENTERED = 2;
1818 
1819     uint256 private _status;
1820 
1821     constructor() {
1822         _status = _NOT_ENTERED;
1823     }
1824 
1825     /**
1826      * @dev Prevents a contract from calling itself, directly or indirectly.
1827      * Calling a `nonReentrant` function from another `nonReentrant`
1828      * function is not supported. It is possible to prevent this from happening
1829      * by making the `nonReentrant` function external, and making it call a
1830      * `private` function that does the actual work.
1831      */
1832     modifier nonReentrant() {
1833         // On the first call to nonReentrant, _notEntered will be true
1834         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1835 
1836         // Any calls to nonReentrant after this point will fail
1837         _status = _ENTERED;
1838 
1839         _;
1840 
1841         // By storing the original value once again, a refund is triggered (see
1842         // https://eips.ethereum.org/EIPS/eip-2200)
1843         _status = _NOT_ENTERED;
1844     }
1845 }
1846 
1847 // File: contracts/whale.sol
1848 
1849 pragma solidity >=0.8.9 <0.9.0;
1850 
1851 
1852 contract Prepump is  Ownable, ReentrancyGuard , ERC721A {
1853     using Strings for uint256;
1854     uint256 public maxSupply = 2000;
1855     string private BASE_URI = "https://www.gamerids.com/meta_prepump/";
1856     uint256 public MAX_MINT_AMOUNT_PER_TX = 50;
1857     bool public IS_SALE_ACTIVE = false;
1858     bool public IS_WHITESALE_ACTIVE = false;
1859 
1860     uint256 public cost = 5000000000000000;
1861     uint256 public wl_cost = 3000000000000000;   
1862    
1863     bytes32 public merkleRoot;
1864 
1865     constructor() ERC721A("Prepump Tools Access Key", "PTAK") {}
1866 
1867  
1868     /** GETTERS **/
1869 
1870     function _baseURI() internal view virtual override returns (string memory) {
1871         return BASE_URI;
1872     }
1873 
1874     /** SETTERS **/
1875 
1876     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1877         BASE_URI = customBaseURI_;
1878     }
1879     
1880     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1881         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1882     }
1883 
1884     function setMaxSupply(uint256 newMaxSupply) external onlyOwner {        
1885         maxSupply = newMaxSupply;
1886     }
1887 
1888     function setSaleActive(bool saleIsActive) external onlyOwner {
1889         IS_SALE_ACTIVE = saleIsActive;
1890     }
1891 
1892     function setWhiteSaleActive(bool WhitesaleIsActive) external onlyOwner {
1893         IS_WHITESALE_ACTIVE = WhitesaleIsActive;
1894     }
1895 
1896     function setMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
1897         merkleRoot = _newMerkleRoot;
1898     }
1899 
1900     function setPrice(uint256 newPrice) external onlyOwner {
1901         cost = newPrice;
1902     }
1903 
1904     function setWLPrice(uint256 newWLPrice) external onlyOwner {
1905         wl_cost = newWLPrice;
1906     }
1907 
1908     /** MINT **/
1909     modifier mintCompliance(uint256 _mintAmount) {
1910         require(
1911             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1912             "Invalid mint amount!"
1913         );
1914         require(
1915             totalSupply() + _mintAmount <= maxSupply,
1916             "Max supply exceeded!"
1917         );
1918         _;
1919     }
1920 
1921     function publicMint(uint256 _mintAmount)
1922         public
1923         payable
1924         mintCompliance(_mintAmount)
1925     {
1926             require(IS_SALE_ACTIVE, "Sale is not active!");
1927             uint256 price = cost * _mintAmount;
1928             require(msg.value >= price, "Insufficient funds!");
1929             _safeMint(msg.sender, _mintAmount);        
1930     }
1931 
1932     function whitelist(uint256 _mintAmount, bytes32[] calldata _merkleProof)
1933         public
1934         payable
1935         mintCompliance(_mintAmount)
1936     {
1937             require(IS_WHITESALE_ACTIVE, "Whitelist sale is not active!");
1938             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1939             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf),"Invalid proof!");
1940             uint256 price = wl_cost * _mintAmount;
1941             require(msg.value >= price, "Insufficient funds!");
1942             _safeMint(msg.sender, _mintAmount);  
1943     }
1944 
1945 
1946 
1947 
1948     function ownerMint(address _to, uint256 _mintAmount)
1949         public
1950         mintCompliance(_mintAmount)
1951         onlyOwner
1952     {
1953         _safeMint(_to, _mintAmount);
1954     }
1955 
1956 
1957     function withdraw() public onlyOwner nonReentrant {
1958         uint256 balance = address(this).balance;
1959 
1960         (bool c1, ) = payable(0x6D4B289FD858f048944DB2CE3d242b410E1c6A72).call{value: balance}('');
1961         require(c1);
1962     }
1963 
1964 }