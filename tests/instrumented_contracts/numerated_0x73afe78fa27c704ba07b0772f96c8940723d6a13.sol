1 //
2 // __          ___           _        _                                  
3 // \ \        / / |         | |      | |                                 
4 //  \ \  /\  / /| |__   __ _| | ___  | |     ___  _   _ _ __   __ _  ___ 
5 //   \ \/  \/ / | '_ \ / _` | |/ _ \ | |    / _ \| | | | '_ \ / _` |/ _ \
6 //    \  /\  /  | | | | (_| | |  __/ | |___| (_) | |_| | | | | (_| |  __/
7 //     \/  \/   |_| |_|\__,_|_|\___| |______\___/ \__,_|_| |_|\__, |\___|
8 //                                                             __/ |     
9 //                                                            |___/      
10 //
11 
12 /*
13  * @creator Whale Lounge NFT
14  * @author burakcbdn twitter.com/burakcbdn
15  */
16 
17 // SPDX-License-Identifier: MIT
18 
19 
20 // File: @openzeppelin/contracts/utils/Strings.sol
21 
22 
23 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32     uint8 private constant _ADDRESS_LENGTH = 20;
33 
34     /**
35      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
36      */
37     function toString(uint256 value) internal pure returns (string memory) {
38         // Inspired by OraclizeAPI's implementation - MIT licence
39         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
40 
41         if (value == 0) {
42             return "0";
43         }
44         uint256 temp = value;
45         uint256 digits;
46         while (temp != 0) {
47             digits++;
48             temp /= 10;
49         }
50         bytes memory buffer = new bytes(digits);
51         while (value != 0) {
52             digits -= 1;
53             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
54             value /= 10;
55         }
56         return string(buffer);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
61      */
62     function toHexString(uint256 value) internal pure returns (string memory) {
63         if (value == 0) {
64             return "0x00";
65         }
66         uint256 temp = value;
67         uint256 length = 0;
68         while (temp != 0) {
69             length++;
70             temp >>= 8;
71         }
72         return toHexString(value, length);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
77      */
78     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
79         bytes memory buffer = new bytes(2 * length + 2);
80         buffer[0] = "0";
81         buffer[1] = "x";
82         for (uint256 i = 2 * length + 1; i > 1; --i) {
83             buffer[i] = _HEX_SYMBOLS[value & 0xf];
84             value >>= 4;
85         }
86         require(value == 0, "Strings: hex length insufficient");
87         return string(buffer);
88     }
89 
90     /**
91      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
92      */
93     function toHexString(address addr) internal pure returns (string memory) {
94         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
99 
100 
101 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev These functions deal with verification of Merkle Tree proofs.
107  *
108  * The proofs can be generated using the JavaScript library
109  * https://github.com/miguelmota/merkletreejs[merkletreejs].
110  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
111  *
112  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
113  *
114  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
115  * hashing, or use a hash function other than keccak256 for hashing leaves.
116  * This is because the concatenation of a sorted pair of internal nodes in
117  * the merkle tree could be reinterpreted as a leaf value.
118  */
119 library MerkleProof {
120     /**
121      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
122      * defined by `root`. For this, a `proof` must be provided, containing
123      * sibling hashes on the branch from the leaf to the root of the tree. Each
124      * pair of leaves and each pair of pre-images are assumed to be sorted.
125      */
126     function verify(
127         bytes32[] memory proof,
128         bytes32 root,
129         bytes32 leaf
130     ) internal pure returns (bool) {
131         return processProof(proof, leaf) == root;
132     }
133 
134     /**
135      * @dev Calldata version of {verify}
136      *
137      * _Available since v4.7._
138      */
139     function verifyCalldata(
140         bytes32[] calldata proof,
141         bytes32 root,
142         bytes32 leaf
143     ) internal pure returns (bool) {
144         return processProofCalldata(proof, leaf) == root;
145     }
146 
147     /**
148      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
149      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
150      * hash matches the root of the tree. When processing the proof, the pairs
151      * of leafs & pre-images are assumed to be sorted.
152      *
153      * _Available since v4.4._
154      */
155     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
156         bytes32 computedHash = leaf;
157         for (uint256 i = 0; i < proof.length; i++) {
158             computedHash = _hashPair(computedHash, proof[i]);
159         }
160         return computedHash;
161     }
162 
163     /**
164      * @dev Calldata version of {processProof}
165      *
166      * _Available since v4.7._
167      */
168     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
169         bytes32 computedHash = leaf;
170         for (uint256 i = 0; i < proof.length; i++) {
171             computedHash = _hashPair(computedHash, proof[i]);
172         }
173         return computedHash;
174     }
175 
176     /**
177      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
178      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
179      *
180      * _Available since v4.7._
181      */
182     function multiProofVerify(
183         bytes32[] memory proof,
184         bool[] memory proofFlags,
185         bytes32 root,
186         bytes32[] memory leaves
187     ) internal pure returns (bool) {
188         return processMultiProof(proof, proofFlags, leaves) == root;
189     }
190 
191     /**
192      * @dev Calldata version of {multiProofVerify}
193      *
194      * _Available since v4.7._
195      */
196     function multiProofVerifyCalldata(
197         bytes32[] calldata proof,
198         bool[] calldata proofFlags,
199         bytes32 root,
200         bytes32[] memory leaves
201     ) internal pure returns (bool) {
202         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
203     }
204 
205     /**
206      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
207      * consuming from one or the other at each step according to the instructions given by
208      * `proofFlags`.
209      *
210      * _Available since v4.7._
211      */
212     function processMultiProof(
213         bytes32[] memory proof,
214         bool[] memory proofFlags,
215         bytes32[] memory leaves
216     ) internal pure returns (bytes32 merkleRoot) {
217         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
218         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
219         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
220         // the merkle tree.
221         uint256 leavesLen = leaves.length;
222         uint256 totalHashes = proofFlags.length;
223 
224         // Check proof validity.
225         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
226 
227         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
228         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
229         bytes32[] memory hashes = new bytes32[](totalHashes);
230         uint256 leafPos = 0;
231         uint256 hashPos = 0;
232         uint256 proofPos = 0;
233         // At each step, we compute the next hash using two values:
234         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
235         //   get the next hash.
236         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
237         //   `proof` array.
238         for (uint256 i = 0; i < totalHashes; i++) {
239             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
240             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
241             hashes[i] = _hashPair(a, b);
242         }
243 
244         if (totalHashes > 0) {
245             return hashes[totalHashes - 1];
246         } else if (leavesLen > 0) {
247             return leaves[0];
248         } else {
249             return proof[0];
250         }
251     }
252 
253     /**
254      * @dev Calldata version of {processMultiProof}
255      *
256      * _Available since v4.7._
257      */
258     function processMultiProofCalldata(
259         bytes32[] calldata proof,
260         bool[] calldata proofFlags,
261         bytes32[] memory leaves
262     ) internal pure returns (bytes32 merkleRoot) {
263         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
264         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
265         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
266         // the merkle tree.
267         uint256 leavesLen = leaves.length;
268         uint256 totalHashes = proofFlags.length;
269 
270         // Check proof validity.
271         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
272 
273         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
274         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
275         bytes32[] memory hashes = new bytes32[](totalHashes);
276         uint256 leafPos = 0;
277         uint256 hashPos = 0;
278         uint256 proofPos = 0;
279         // At each step, we compute the next hash using two values:
280         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
281         //   get the next hash.
282         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
283         //   `proof` array.
284         for (uint256 i = 0; i < totalHashes; i++) {
285             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
286             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
287             hashes[i] = _hashPair(a, b);
288         }
289 
290         if (totalHashes > 0) {
291             return hashes[totalHashes - 1];
292         } else if (leavesLen > 0) {
293             return leaves[0];
294         } else {
295             return proof[0];
296         }
297     }
298 
299     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
300         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
301     }
302 
303     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
304         /// @solidity memory-safe-assembly
305         assembly {
306             mstore(0x00, a)
307             mstore(0x20, b)
308             value := keccak256(0x00, 0x40)
309         }
310     }
311 }
312 
313 // File: erc721a/contracts/IERC721A.sol
314 
315 
316 // ERC721A Contracts v4.2.2
317 // Creator: Chiru Labs
318 
319 pragma solidity ^0.8.4;
320 
321 /**
322  * @dev Interface of ERC721A.
323  */
324 interface IERC721A {
325     /**
326      * The caller must own the token or be an approved operator.
327      */
328     error ApprovalCallerNotOwnerNorApproved();
329 
330     /**
331      * The token does not exist.
332      */
333     error ApprovalQueryForNonexistentToken();
334 
335     /**
336      * The caller cannot approve to their own address.
337      */
338     error ApproveToCaller();
339 
340     /**
341      * Cannot query the balance for the zero address.
342      */
343     error BalanceQueryForZeroAddress();
344 
345     /**
346      * Cannot mint to the zero address.
347      */
348     error MintToZeroAddress();
349 
350     /**
351      * The quantity of tokens minted must be more than zero.
352      */
353     error MintZeroQuantity();
354 
355     /**
356      * The token does not exist.
357      */
358     error OwnerQueryForNonexistentToken();
359 
360     /**
361      * The caller must own the token or be an approved operator.
362      */
363     error TransferCallerNotOwnerNorApproved();
364 
365     /**
366      * The token must be owned by `from`.
367      */
368     error TransferFromIncorrectOwner();
369 
370     /**
371      * Cannot safely transfer to a contract that does not implement the
372      * ERC721Receiver interface.
373      */
374     error TransferToNonERC721ReceiverImplementer();
375 
376     /**
377      * Cannot transfer to the zero address.
378      */
379     error TransferToZeroAddress();
380 
381     /**
382      * The token does not exist.
383      */
384     error URIQueryForNonexistentToken();
385 
386     /**
387      * The `quantity` minted with ERC2309 exceeds the safety limit.
388      */
389     error MintERC2309QuantityExceedsLimit();
390 
391     /**
392      * The `extraData` cannot be set on an unintialized ownership slot.
393      */
394     error OwnershipNotInitializedForExtraData();
395 
396     // =============================================================
397     //                            STRUCTS
398     // =============================================================
399 
400     struct TokenOwnership {
401         // The address of the owner.
402         address addr;
403         // Stores the start time of ownership with minimal overhead for tokenomics.
404         uint64 startTimestamp;
405         // Whether the token has been burned.
406         bool burned;
407         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
408         uint24 extraData;
409     }
410 
411     // =============================================================
412     //                         TOKEN COUNTERS
413     // =============================================================
414 
415     /**
416      * @dev Returns the total number of tokens in existence.
417      * Burned tokens will reduce the count.
418      * To get the total number of tokens minted, please see {_totalMinted}.
419      */
420     function totalSupply() external view returns (uint256);
421 
422     // =============================================================
423     //                            IERC165
424     // =============================================================
425 
426     /**
427      * @dev Returns true if this contract implements the interface defined by
428      * `interfaceId`. See the corresponding
429      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
430      * to learn more about how these ids are created.
431      *
432      * This function call must use less than 30000 gas.
433      */
434     function supportsInterface(bytes4 interfaceId) external view returns (bool);
435 
436     // =============================================================
437     //                            IERC721
438     // =============================================================
439 
440     /**
441      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
442      */
443     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
444 
445     /**
446      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
447      */
448     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
449 
450     /**
451      * @dev Emitted when `owner` enables or disables
452      * (`approved`) `operator` to manage all of its assets.
453      */
454     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
455 
456     /**
457      * @dev Returns the number of tokens in `owner`'s account.
458      */
459     function balanceOf(address owner) external view returns (uint256 balance);
460 
461     /**
462      * @dev Returns the owner of the `tokenId` token.
463      *
464      * Requirements:
465      *
466      * - `tokenId` must exist.
467      */
468     function ownerOf(uint256 tokenId) external view returns (address owner);
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`,
472      * checking first that contract recipients are aware of the ERC721 protocol
473      * to prevent tokens from being forever locked.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must exist and be owned by `from`.
480      * - If the caller is not `from`, it must be have been allowed to move
481      * this token by either {approve} or {setApprovalForAll}.
482      * - If `to` refers to a smart contract, it must implement
483      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484      *
485      * Emits a {Transfer} event.
486      */
487     function safeTransferFrom(
488         address from,
489         address to,
490         uint256 tokenId,
491         bytes calldata data
492     ) external;
493 
494     /**
495      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
496      */
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     ) external;
502 
503     /**
504      * @dev Transfers `tokenId` from `from` to `to`.
505      *
506      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
507      * whenever possible.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must be owned by `from`.
514      * - If the caller is not `from`, it must be approved to move this token
515      * by either {approve} or {setApprovalForAll}.
516      *
517      * Emits a {Transfer} event.
518      */
519     function transferFrom(
520         address from,
521         address to,
522         uint256 tokenId
523     ) external;
524 
525     /**
526      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
527      * The approval is cleared when the token is transferred.
528      *
529      * Only a single account can be approved at a time, so approving the
530      * zero address clears previous approvals.
531      *
532      * Requirements:
533      *
534      * - The caller must own the token or be an approved operator.
535      * - `tokenId` must exist.
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address to, uint256 tokenId) external;
540 
541     /**
542      * @dev Approve or remove `operator` as an operator for the caller.
543      * Operators can call {transferFrom} or {safeTransferFrom}
544      * for any token owned by the caller.
545      *
546      * Requirements:
547      *
548      * - The `operator` cannot be the caller.
549      *
550      * Emits an {ApprovalForAll} event.
551      */
552     function setApprovalForAll(address operator, bool _approved) external;
553 
554     /**
555      * @dev Returns the account approved for `tokenId` token.
556      *
557      * Requirements:
558      *
559      * - `tokenId` must exist.
560      */
561     function getApproved(uint256 tokenId) external view returns (address operator);
562 
563     /**
564      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
565      *
566      * See {setApprovalForAll}.
567      */
568     function isApprovedForAll(address owner, address operator) external view returns (bool);
569 
570     // =============================================================
571     //                        IERC721Metadata
572     // =============================================================
573 
574     /**
575      * @dev Returns the token collection name.
576      */
577     function name() external view returns (string memory);
578 
579     /**
580      * @dev Returns the token collection symbol.
581      */
582     function symbol() external view returns (string memory);
583 
584     /**
585      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
586      */
587     function tokenURI(uint256 tokenId) external view returns (string memory);
588 
589     // =============================================================
590     //                           IERC2309
591     // =============================================================
592 
593     /**
594      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
595      * (inclusive) is transferred from `from` to `to`, as defined in the
596      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
597      *
598      * See {_mintERC2309} for more details.
599      */
600     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
601 }
602 
603 // File: erc721a/contracts/ERC721A.sol
604 
605 
606 // ERC721A Contracts v4.2.2
607 // Creator: Chiru Labs
608 
609 pragma solidity ^0.8.4;
610 
611 
612 /**
613  * @dev Interface of ERC721 token receiver.
614  */
615 interface ERC721A__IERC721Receiver {
616     function onERC721Received(
617         address operator,
618         address from,
619         uint256 tokenId,
620         bytes calldata data
621     ) external returns (bytes4);
622 }
623 
624 /**
625  * @title ERC721A
626  *
627  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
628  * Non-Fungible Token Standard, including the Metadata extension.
629  * Optimized for lower gas during batch mints.
630  *
631  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
632  * starting from `_startTokenId()`.
633  *
634  * Assumptions:
635  *
636  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
637  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
638  */
639 contract ERC721A is IERC721A {
640     // Reference type for token approval.
641     struct TokenApprovalRef {
642         address value;
643     }
644 
645     // =============================================================
646     //                           CONSTANTS
647     // =============================================================
648 
649     // Mask of an entry in packed address data.
650     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
651 
652     // The bit position of `numberMinted` in packed address data.
653     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
654 
655     // The bit position of `numberBurned` in packed address data.
656     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
657 
658     // The bit position of `aux` in packed address data.
659     uint256 private constant _BITPOS_AUX = 192;
660 
661     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
662     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
663 
664     // The bit position of `startTimestamp` in packed ownership.
665     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
666 
667     // The bit mask of the `burned` bit in packed ownership.
668     uint256 private constant _BITMASK_BURNED = 1 << 224;
669 
670     // The bit position of the `nextInitialized` bit in packed ownership.
671     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
672 
673     // The bit mask of the `nextInitialized` bit in packed ownership.
674     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
675 
676     // The bit position of `extraData` in packed ownership.
677     uint256 private constant _BITPOS_EXTRA_DATA = 232;
678 
679     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
680     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
681 
682     // The mask of the lower 160 bits for addresses.
683     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
684 
685     // The maximum `quantity` that can be minted with {_mintERC2309}.
686     // This limit is to prevent overflows on the address data entries.
687     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
688     // is required to cause an overflow, which is unrealistic.
689     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
690 
691     // The `Transfer` event signature is given by:
692     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
693     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
694         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
695 
696     // =============================================================
697     //                            STORAGE
698     // =============================================================
699 
700     // The next token ID to be minted.
701     uint256 private _currentIndex;
702 
703     // The number of tokens burned.
704     uint256 private _burnCounter;
705 
706     // Token name
707     string private _name;
708 
709     // Token symbol
710     string private _symbol;
711 
712     // Mapping from token ID to ownership details
713     // An empty struct value does not necessarily mean the token is unowned.
714     // See {_packedOwnershipOf} implementation for details.
715     //
716     // Bits Layout:
717     // - [0..159]   `addr`
718     // - [160..223] `startTimestamp`
719     // - [224]      `burned`
720     // - [225]      `nextInitialized`
721     // - [232..255] `extraData`
722     mapping(uint256 => uint256) private _packedOwnerships;
723 
724     // Mapping owner address to address data.
725     //
726     // Bits Layout:
727     // - [0..63]    `balance`
728     // - [64..127]  `numberMinted`
729     // - [128..191] `numberBurned`
730     // - [192..255] `aux`
731     mapping(address => uint256) private _packedAddressData;
732 
733     // Mapping from token ID to approved address.
734     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
735 
736     // Mapping from owner to operator approvals
737     mapping(address => mapping(address => bool)) private _operatorApprovals;
738 
739     // =============================================================
740     //                          CONSTRUCTOR
741     // =============================================================
742 
743     constructor(string memory name_, string memory symbol_) {
744         _name = name_;
745         _symbol = symbol_;
746         _currentIndex = _startTokenId();
747     }
748 
749     // =============================================================
750     //                   TOKEN COUNTING OPERATIONS
751     // =============================================================
752 
753     /**
754      * @dev Returns the starting token ID.
755      * To change the starting token ID, please override this function.
756      */
757     function _startTokenId() internal view virtual returns (uint256) {
758         return 0;
759     }
760 
761     /**
762      * @dev Returns the next token ID to be minted.
763      */
764     function _nextTokenId() internal view virtual returns (uint256) {
765         return _currentIndex;
766     }
767 
768     /**
769      * @dev Returns the total number of tokens in existence.
770      * Burned tokens will reduce the count.
771      * To get the total number of tokens minted, please see {_totalMinted}.
772      */
773     function totalSupply() public view virtual override returns (uint256) {
774         // Counter underflow is impossible as _burnCounter cannot be incremented
775         // more than `_currentIndex - _startTokenId()` times.
776         unchecked {
777             return _currentIndex - _burnCounter - _startTokenId();
778         }
779     }
780 
781     /**
782      * @dev Returns the total amount of tokens minted in the contract.
783      */
784     function _totalMinted() internal view virtual returns (uint256) {
785         // Counter underflow is impossible as `_currentIndex` does not decrement,
786         // and it is initialized to `_startTokenId()`.
787         unchecked {
788             return _currentIndex - _startTokenId();
789         }
790     }
791 
792     /**
793      * @dev Returns the total number of tokens burned.
794      */
795     function _totalBurned() internal view virtual returns (uint256) {
796         return _burnCounter;
797     }
798 
799     // =============================================================
800     //                    ADDRESS DATA OPERATIONS
801     // =============================================================
802 
803     /**
804      * @dev Returns the number of tokens in `owner`'s account.
805      */
806     function balanceOf(address owner) public view virtual override returns (uint256) {
807         if (owner == address(0)) revert BalanceQueryForZeroAddress();
808         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
809     }
810 
811     /**
812      * Returns the number of tokens minted by `owner`.
813      */
814     function _numberMinted(address owner) internal view returns (uint256) {
815         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
816     }
817 
818     /**
819      * Returns the number of tokens burned by or on behalf of `owner`.
820      */
821     function _numberBurned(address owner) internal view returns (uint256) {
822         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
823     }
824 
825     /**
826      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
827      */
828     function _getAux(address owner) internal view returns (uint64) {
829         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
830     }
831 
832     /**
833      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
834      * If there are multiple variables, please pack them into a uint64.
835      */
836     function _setAux(address owner, uint64 aux) internal virtual {
837         uint256 packed = _packedAddressData[owner];
838         uint256 auxCasted;
839         // Cast `aux` with assembly to avoid redundant masking.
840         assembly {
841             auxCasted := aux
842         }
843         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
844         _packedAddressData[owner] = packed;
845     }
846 
847     // =============================================================
848     //                            IERC165
849     // =============================================================
850 
851     /**
852      * @dev Returns true if this contract implements the interface defined by
853      * `interfaceId`. See the corresponding
854      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
855      * to learn more about how these ids are created.
856      *
857      * This function call must use less than 30000 gas.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
860         // The interface IDs are constants representing the first 4 bytes
861         // of the XOR of all function selectors in the interface.
862         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
863         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
864         return
865             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
866             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
867             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
868     }
869 
870     // =============================================================
871     //                        IERC721Metadata
872     // =============================================================
873 
874     /**
875      * @dev Returns the token collection name.
876      */
877     function name() public view virtual override returns (string memory) {
878         return _name;
879     }
880 
881     /**
882      * @dev Returns the token collection symbol.
883      */
884     function symbol() public view virtual override returns (string memory) {
885         return _symbol;
886     }
887 
888     /**
889      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
890      */
891     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
892         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
893 
894         string memory baseURI = _baseURI();
895         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
896     }
897 
898     /**
899      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
900      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
901      * by default, it can be overridden in child contracts.
902      */
903     function _baseURI() internal view virtual returns (string memory) {
904         return '';
905     }
906 
907     // =============================================================
908     //                     OWNERSHIPS OPERATIONS
909     // =============================================================
910 
911     /**
912      * @dev Returns the owner of the `tokenId` token.
913      *
914      * Requirements:
915      *
916      * - `tokenId` must exist.
917      */
918     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
919         return address(uint160(_packedOwnershipOf(tokenId)));
920     }
921 
922     /**
923      * @dev Gas spent here starts off proportional to the maximum mint batch size.
924      * It gradually moves to O(1) as tokens get transferred around over time.
925      */
926     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
927         return _unpackedOwnership(_packedOwnershipOf(tokenId));
928     }
929 
930     /**
931      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
932      */
933     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
934         return _unpackedOwnership(_packedOwnerships[index]);
935     }
936 
937     /**
938      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
939      */
940     function _initializeOwnershipAt(uint256 index) internal virtual {
941         if (_packedOwnerships[index] == 0) {
942             _packedOwnerships[index] = _packedOwnershipOf(index);
943         }
944     }
945 
946     /**
947      * Returns the packed ownership data of `tokenId`.
948      */
949     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
950         uint256 curr = tokenId;
951 
952         unchecked {
953             if (_startTokenId() <= curr)
954                 if (curr < _currentIndex) {
955                     uint256 packed = _packedOwnerships[curr];
956                     // If not burned.
957                     if (packed & _BITMASK_BURNED == 0) {
958                         // Invariant:
959                         // There will always be an initialized ownership slot
960                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
961                         // before an unintialized ownership slot
962                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
963                         // Hence, `curr` will not underflow.
964                         //
965                         // We can directly compare the packed value.
966                         // If the address is zero, packed will be zero.
967                         while (packed == 0) {
968                             packed = _packedOwnerships[--curr];
969                         }
970                         return packed;
971                     }
972                 }
973         }
974         revert OwnerQueryForNonexistentToken();
975     }
976 
977     /**
978      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
979      */
980     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
981         ownership.addr = address(uint160(packed));
982         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
983         ownership.burned = packed & _BITMASK_BURNED != 0;
984         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
985     }
986 
987     /**
988      * @dev Packs ownership data into a single uint256.
989      */
990     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
991         assembly {
992             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
993             owner := and(owner, _BITMASK_ADDRESS)
994             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
995             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
996         }
997     }
998 
999     /**
1000      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1001      */
1002     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1003         // For branchless setting of the `nextInitialized` flag.
1004         assembly {
1005             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1006             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1007         }
1008     }
1009 
1010     // =============================================================
1011     //                      APPROVAL OPERATIONS
1012     // =============================================================
1013 
1014     /**
1015      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1016      * The approval is cleared when the token is transferred.
1017      *
1018      * Only a single account can be approved at a time, so approving the
1019      * zero address clears previous approvals.
1020      *
1021      * Requirements:
1022      *
1023      * - The caller must own the token or be an approved operator.
1024      * - `tokenId` must exist.
1025      *
1026      * Emits an {Approval} event.
1027      */
1028     function approve(address to, uint256 tokenId) public virtual override {
1029         address owner = ownerOf(tokenId);
1030 
1031         if (_msgSenderERC721A() != owner)
1032             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1033                 revert ApprovalCallerNotOwnerNorApproved();
1034             }
1035 
1036         _tokenApprovals[tokenId].value = to;
1037         emit Approval(owner, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev Returns the account approved for `tokenId` token.
1042      *
1043      * Requirements:
1044      *
1045      * - `tokenId` must exist.
1046      */
1047     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1048         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1049 
1050         return _tokenApprovals[tokenId].value;
1051     }
1052 
1053     /**
1054      * @dev Approve or remove `operator` as an operator for the caller.
1055      * Operators can call {transferFrom} or {safeTransferFrom}
1056      * for any token owned by the caller.
1057      *
1058      * Requirements:
1059      *
1060      * - The `operator` cannot be the caller.
1061      *
1062      * Emits an {ApprovalForAll} event.
1063      */
1064     function setApprovalForAll(address operator, bool approved) public virtual override {
1065         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1066 
1067         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1068         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1069     }
1070 
1071     /**
1072      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1073      *
1074      * See {setApprovalForAll}.
1075      */
1076     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1077         return _operatorApprovals[owner][operator];
1078     }
1079 
1080     /**
1081      * @dev Returns whether `tokenId` exists.
1082      *
1083      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1084      *
1085      * Tokens start existing when they are minted. See {_mint}.
1086      */
1087     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1088         return
1089             _startTokenId() <= tokenId &&
1090             tokenId < _currentIndex && // If within bounds,
1091             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1092     }
1093 
1094     /**
1095      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1096      */
1097     function _isSenderApprovedOrOwner(
1098         address approvedAddress,
1099         address owner,
1100         address msgSender
1101     ) private pure returns (bool result) {
1102         assembly {
1103             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1104             owner := and(owner, _BITMASK_ADDRESS)
1105             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1106             msgSender := and(msgSender, _BITMASK_ADDRESS)
1107             // `msgSender == owner || msgSender == approvedAddress`.
1108             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1109         }
1110     }
1111 
1112     /**
1113      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1114      */
1115     function _getApprovedSlotAndAddress(uint256 tokenId)
1116         private
1117         view
1118         returns (uint256 approvedAddressSlot, address approvedAddress)
1119     {
1120         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1121         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1122         assembly {
1123             approvedAddressSlot := tokenApproval.slot
1124             approvedAddress := sload(approvedAddressSlot)
1125         }
1126     }
1127 
1128     // =============================================================
1129     //                      TRANSFER OPERATIONS
1130     // =============================================================
1131 
1132     /**
1133      * @dev Transfers `tokenId` from `from` to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `from` cannot be the zero address.
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      * - If the caller is not `from`, it must be approved to move this token
1141      * by either {approve} or {setApprovalForAll}.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function transferFrom(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) public virtual override {
1150         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1151 
1152         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1153 
1154         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1155 
1156         // The nested ifs save around 20+ gas over a compound boolean condition.
1157         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1158             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1159 
1160         if (to == address(0)) revert TransferToZeroAddress();
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner.
1165         assembly {
1166             if approvedAddress {
1167                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1168                 sstore(approvedAddressSlot, 0)
1169             }
1170         }
1171 
1172         // Underflow of the sender's balance is impossible because we check for
1173         // ownership above and the recipient's balance can't realistically overflow.
1174         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1175         unchecked {
1176             // We can directly increment and decrement the balances.
1177             --_packedAddressData[from]; // Updates: `balance -= 1`.
1178             ++_packedAddressData[to]; // Updates: `balance += 1`.
1179 
1180             // Updates:
1181             // - `address` to the next owner.
1182             // - `startTimestamp` to the timestamp of transfering.
1183             // - `burned` to `false`.
1184             // - `nextInitialized` to `true`.
1185             _packedOwnerships[tokenId] = _packOwnershipData(
1186                 to,
1187                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1188             );
1189 
1190             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1191             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1192                 uint256 nextTokenId = tokenId + 1;
1193                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1194                 if (_packedOwnerships[nextTokenId] == 0) {
1195                     // If the next slot is within bounds.
1196                     if (nextTokenId != _currentIndex) {
1197                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1198                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1199                     }
1200                 }
1201             }
1202         }
1203 
1204         emit Transfer(from, to, tokenId);
1205         _afterTokenTransfers(from, to, tokenId, 1);
1206     }
1207 
1208     /**
1209      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1210      */
1211     function safeTransferFrom(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) public virtual override {
1216         safeTransferFrom(from, to, tokenId, '');
1217     }
1218 
1219     /**
1220      * @dev Safely transfers `tokenId` token from `from` to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - `from` cannot be the zero address.
1225      * - `to` cannot be the zero address.
1226      * - `tokenId` token must exist and be owned by `from`.
1227      * - If the caller is not `from`, it must be approved to move this token
1228      * by either {approve} or {setApprovalForAll}.
1229      * - If `to` refers to a smart contract, it must implement
1230      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function safeTransferFrom(
1235         address from,
1236         address to,
1237         uint256 tokenId,
1238         bytes memory _data
1239     ) public virtual override {
1240         transferFrom(from, to, tokenId);
1241         if (to.code.length != 0)
1242             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1243                 revert TransferToNonERC721ReceiverImplementer();
1244             }
1245     }
1246 
1247     /**
1248      * @dev Hook that is called before a set of serially-ordered token IDs
1249      * are about to be transferred. This includes minting.
1250      * And also called before burning one token.
1251      *
1252      * `startTokenId` - the first token ID to be transferred.
1253      * `quantity` - the amount to be transferred.
1254      *
1255      * Calling conditions:
1256      *
1257      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1258      * transferred to `to`.
1259      * - When `from` is zero, `tokenId` will be minted for `to`.
1260      * - When `to` is zero, `tokenId` will be burned by `from`.
1261      * - `from` and `to` are never both zero.
1262      */
1263     function _beforeTokenTransfers(
1264         address from,
1265         address to,
1266         uint256 startTokenId,
1267         uint256 quantity
1268     ) internal virtual {}
1269 
1270     /**
1271      * @dev Hook that is called after a set of serially-ordered token IDs
1272      * have been transferred. This includes minting.
1273      * And also called after one token has been burned.
1274      *
1275      * `startTokenId` - the first token ID to be transferred.
1276      * `quantity` - the amount to be transferred.
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` has been minted for `to`.
1283      * - When `to` is zero, `tokenId` has been burned by `from`.
1284      * - `from` and `to` are never both zero.
1285      */
1286     function _afterTokenTransfers(
1287         address from,
1288         address to,
1289         uint256 startTokenId,
1290         uint256 quantity
1291     ) internal virtual {}
1292 
1293     /**
1294      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1295      *
1296      * `from` - Previous owner of the given token ID.
1297      * `to` - Target address that will receive the token.
1298      * `tokenId` - Token ID to be transferred.
1299      * `_data` - Optional data to send along with the call.
1300      *
1301      * Returns whether the call correctly returned the expected magic value.
1302      */
1303     function _checkContractOnERC721Received(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory _data
1308     ) private returns (bool) {
1309         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1310             bytes4 retval
1311         ) {
1312             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1313         } catch (bytes memory reason) {
1314             if (reason.length == 0) {
1315                 revert TransferToNonERC721ReceiverImplementer();
1316             } else {
1317                 assembly {
1318                     revert(add(32, reason), mload(reason))
1319                 }
1320             }
1321         }
1322     }
1323 
1324     // =============================================================
1325     //                        MINT OPERATIONS
1326     // =============================================================
1327 
1328     /**
1329      * @dev Mints `quantity` tokens and transfers them to `to`.
1330      *
1331      * Requirements:
1332      *
1333      * - `to` cannot be the zero address.
1334      * - `quantity` must be greater than 0.
1335      *
1336      * Emits a {Transfer} event for each mint.
1337      */
1338     function _mint(address to, uint256 quantity) internal virtual {
1339         uint256 startTokenId = _currentIndex;
1340         if (quantity == 0) revert MintZeroQuantity();
1341 
1342         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1343 
1344         // Overflows are incredibly unrealistic.
1345         // `balance` and `numberMinted` have a maximum limit of 2**64.
1346         // `tokenId` has a maximum limit of 2**256.
1347         unchecked {
1348             // Updates:
1349             // - `balance += quantity`.
1350             // - `numberMinted += quantity`.
1351             //
1352             // We can directly add to the `balance` and `numberMinted`.
1353             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1354 
1355             // Updates:
1356             // - `address` to the owner.
1357             // - `startTimestamp` to the timestamp of minting.
1358             // - `burned` to `false`.
1359             // - `nextInitialized` to `quantity == 1`.
1360             _packedOwnerships[startTokenId] = _packOwnershipData(
1361                 to,
1362                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1363             );
1364 
1365             uint256 toMasked;
1366             uint256 end = startTokenId + quantity;
1367 
1368             // Use assembly to loop and emit the `Transfer` event for gas savings.
1369             assembly {
1370                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1371                 toMasked := and(to, _BITMASK_ADDRESS)
1372                 // Emit the `Transfer` event.
1373                 log4(
1374                     0, // Start of data (0, since no data).
1375                     0, // End of data (0, since no data).
1376                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1377                     0, // `address(0)`.
1378                     toMasked, // `to`.
1379                     startTokenId // `tokenId`.
1380                 )
1381 
1382                 for {
1383                     let tokenId := add(startTokenId, 1)
1384                 } iszero(eq(tokenId, end)) {
1385                     tokenId := add(tokenId, 1)
1386                 } {
1387                     // Emit the `Transfer` event. Similar to above.
1388                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1389                 }
1390             }
1391             if (toMasked == 0) revert MintToZeroAddress();
1392 
1393             _currentIndex = end;
1394         }
1395         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1396     }
1397 
1398     /**
1399      * @dev Mints `quantity` tokens and transfers them to `to`.
1400      *
1401      * This function is intended for efficient minting only during contract creation.
1402      *
1403      * It emits only one {ConsecutiveTransfer} as defined in
1404      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1405      * instead of a sequence of {Transfer} event(s).
1406      *
1407      * Calling this function outside of contract creation WILL make your contract
1408      * non-compliant with the ERC721 standard.
1409      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1410      * {ConsecutiveTransfer} event is only permissible during contract creation.
1411      *
1412      * Requirements:
1413      *
1414      * - `to` cannot be the zero address.
1415      * - `quantity` must be greater than 0.
1416      *
1417      * Emits a {ConsecutiveTransfer} event.
1418      */
1419     function _mintERC2309(address to, uint256 quantity) internal virtual {
1420         uint256 startTokenId = _currentIndex;
1421         if (to == address(0)) revert MintToZeroAddress();
1422         if (quantity == 0) revert MintZeroQuantity();
1423         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1424 
1425         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1426 
1427         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1428         unchecked {
1429             // Updates:
1430             // - `balance += quantity`.
1431             // - `numberMinted += quantity`.
1432             //
1433             // We can directly add to the `balance` and `numberMinted`.
1434             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1435 
1436             // Updates:
1437             // - `address` to the owner.
1438             // - `startTimestamp` to the timestamp of minting.
1439             // - `burned` to `false`.
1440             // - `nextInitialized` to `quantity == 1`.
1441             _packedOwnerships[startTokenId] = _packOwnershipData(
1442                 to,
1443                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1444             );
1445 
1446             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1447 
1448             _currentIndex = startTokenId + quantity;
1449         }
1450         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1451     }
1452 
1453     /**
1454      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1455      *
1456      * Requirements:
1457      *
1458      * - If `to` refers to a smart contract, it must implement
1459      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1460      * - `quantity` must be greater than 0.
1461      *
1462      * See {_mint}.
1463      *
1464      * Emits a {Transfer} event for each mint.
1465      */
1466     function _safeMint(
1467         address to,
1468         uint256 quantity,
1469         bytes memory _data
1470     ) internal virtual {
1471         _mint(to, quantity);
1472 
1473         unchecked {
1474             if (to.code.length != 0) {
1475                 uint256 end = _currentIndex;
1476                 uint256 index = end - quantity;
1477                 do {
1478                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1479                         revert TransferToNonERC721ReceiverImplementer();
1480                     }
1481                 } while (index < end);
1482                 // Reentrancy protection.
1483                 if (_currentIndex != end) revert();
1484             }
1485         }
1486     }
1487 
1488     /**
1489      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1490      */
1491     function _safeMint(address to, uint256 quantity) internal virtual {
1492         _safeMint(to, quantity, '');
1493     }
1494 
1495     // =============================================================
1496     //                        BURN OPERATIONS
1497     // =============================================================
1498 
1499     /**
1500      * @dev Equivalent to `_burn(tokenId, false)`.
1501      */
1502     function _burn(uint256 tokenId) internal virtual {
1503         _burn(tokenId, false);
1504     }
1505 
1506     /**
1507      * @dev Destroys `tokenId`.
1508      * The approval is cleared when the token is burned.
1509      *
1510      * Requirements:
1511      *
1512      * - `tokenId` must exist.
1513      *
1514      * Emits a {Transfer} event.
1515      */
1516     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1517         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1518 
1519         address from = address(uint160(prevOwnershipPacked));
1520 
1521         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1522 
1523         if (approvalCheck) {
1524             // The nested ifs save around 20+ gas over a compound boolean condition.
1525             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1526                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1527         }
1528 
1529         _beforeTokenTransfers(from, address(0), tokenId, 1);
1530 
1531         // Clear approvals from the previous owner.
1532         assembly {
1533             if approvedAddress {
1534                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1535                 sstore(approvedAddressSlot, 0)
1536             }
1537         }
1538 
1539         // Underflow of the sender's balance is impossible because we check for
1540         // ownership above and the recipient's balance can't realistically overflow.
1541         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1542         unchecked {
1543             // Updates:
1544             // - `balance -= 1`.
1545             // - `numberBurned += 1`.
1546             //
1547             // We can directly decrement the balance, and increment the number burned.
1548             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1549             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1550 
1551             // Updates:
1552             // - `address` to the last owner.
1553             // - `startTimestamp` to the timestamp of burning.
1554             // - `burned` to `true`.
1555             // - `nextInitialized` to `true`.
1556             _packedOwnerships[tokenId] = _packOwnershipData(
1557                 from,
1558                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1559             );
1560 
1561             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1562             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1563                 uint256 nextTokenId = tokenId + 1;
1564                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1565                 if (_packedOwnerships[nextTokenId] == 0) {
1566                     // If the next slot is within bounds.
1567                     if (nextTokenId != _currentIndex) {
1568                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1569                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1570                     }
1571                 }
1572             }
1573         }
1574 
1575         emit Transfer(from, address(0), tokenId);
1576         _afterTokenTransfers(from, address(0), tokenId, 1);
1577 
1578         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1579         unchecked {
1580             _burnCounter++;
1581         }
1582     }
1583 
1584     // =============================================================
1585     //                     EXTRA DATA OPERATIONS
1586     // =============================================================
1587 
1588     /**
1589      * @dev Directly sets the extra data for the ownership data `index`.
1590      */
1591     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1592         uint256 packed = _packedOwnerships[index];
1593         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1594         uint256 extraDataCasted;
1595         // Cast `extraData` with assembly to avoid redundant masking.
1596         assembly {
1597             extraDataCasted := extraData
1598         }
1599         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1600         _packedOwnerships[index] = packed;
1601     }
1602 
1603     /**
1604      * @dev Called during each token transfer to set the 24bit `extraData` field.
1605      * Intended to be overridden by the cosumer contract.
1606      *
1607      * `previousExtraData` - the value of `extraData` before transfer.
1608      *
1609      * Calling conditions:
1610      *
1611      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1612      * transferred to `to`.
1613      * - When `from` is zero, `tokenId` will be minted for `to`.
1614      * - When `to` is zero, `tokenId` will be burned by `from`.
1615      * - `from` and `to` are never both zero.
1616      */
1617     function _extraData(
1618         address from,
1619         address to,
1620         uint24 previousExtraData
1621     ) internal view virtual returns (uint24) {}
1622 
1623     /**
1624      * @dev Returns the next extra data for the packed ownership data.
1625      * The returned result is shifted into position.
1626      */
1627     function _nextExtraData(
1628         address from,
1629         address to,
1630         uint256 prevOwnershipPacked
1631     ) private view returns (uint256) {
1632         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1633         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1634     }
1635 
1636     // =============================================================
1637     //                       OTHER OPERATIONS
1638     // =============================================================
1639 
1640     /**
1641      * @dev Returns the message sender (defaults to `msg.sender`).
1642      *
1643      * If you are writing GSN compatible contracts, you need to override this function.
1644      */
1645     function _msgSenderERC721A() internal view virtual returns (address) {
1646         return msg.sender;
1647     }
1648 
1649     /**
1650      * @dev Converts a uint256 to its ASCII string decimal representation.
1651      */
1652     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1653         assembly {
1654             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1655             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1656             // We will need 1 32-byte word to store the length,
1657             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1658             str := add(mload(0x40), 0x80)
1659             // Update the free memory pointer to allocate.
1660             mstore(0x40, str)
1661 
1662             // Cache the end of the memory to calculate the length later.
1663             let end := str
1664 
1665             // We write the string from rightmost digit to leftmost digit.
1666             // The following is essentially a do-while loop that also handles the zero case.
1667             // prettier-ignore
1668             for { let temp := value } 1 {} {
1669                 str := sub(str, 1)
1670                 // Write the character to the pointer.
1671                 // The ASCII index of the '0' character is 48.
1672                 mstore8(str, add(48, mod(temp, 10)))
1673                 // Keep dividing `temp` until zero.
1674                 temp := div(temp, 10)
1675                 // prettier-ignore
1676                 if iszero(temp) { break }
1677             }
1678 
1679             let length := sub(end, str)
1680             // Move the pointer 32 bytes leftwards to make room for the length.
1681             str := sub(str, 0x20)
1682             // Store the length.
1683             mstore(str, length)
1684         }
1685     }
1686 }
1687 
1688 // File: @openzeppelin/contracts/utils/Context.sol
1689 
1690 
1691 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1692 
1693 pragma solidity ^0.8.0;
1694 
1695 /**
1696  * @dev Provides information about the current execution context, including the
1697  * sender of the transaction and its data. While these are generally available
1698  * via msg.sender and msg.data, they should not be accessed in such a direct
1699  * manner, since when dealing with meta-transactions the account sending and
1700  * paying for execution may not be the actual sender (as far as an application
1701  * is concerned).
1702  *
1703  * This contract is only required for intermediate, library-like contracts.
1704  */
1705 abstract contract Context {
1706     function _msgSender() internal view virtual returns (address) {
1707         return msg.sender;
1708     }
1709 
1710     function _msgData() internal view virtual returns (bytes calldata) {
1711         return msg.data;
1712     }
1713 }
1714 
1715 // File: @openzeppelin/contracts/access/Ownable.sol
1716 
1717 
1718 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1719 
1720 pragma solidity ^0.8.0;
1721 
1722 
1723 /**
1724  * @dev Contract module which provides a basic access control mechanism, where
1725  * there is an account (an owner) that can be granted exclusive access to
1726  * specific functions.
1727  *
1728  * By default, the owner account will be the one that deploys the contract. This
1729  * can later be changed with {transferOwnership}.
1730  *
1731  * This module is used through inheritance. It will make available the modifier
1732  * `onlyOwner`, which can be applied to your functions to restrict their use to
1733  * the owner.
1734  */
1735 abstract contract Ownable is Context {
1736     address private _owner;
1737 
1738     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1739 
1740     /**
1741      * @dev Initializes the contract setting the deployer as the initial owner.
1742      */
1743     constructor() {
1744         _transferOwnership(_msgSender());
1745     }
1746 
1747     /**
1748      * @dev Throws if called by any account other than the owner.
1749      */
1750     modifier onlyOwner() {
1751         _checkOwner();
1752         _;
1753     }
1754 
1755     /**
1756      * @dev Returns the address of the current owner.
1757      */
1758     function owner() public view virtual returns (address) {
1759         return _owner;
1760     }
1761 
1762     /**
1763      * @dev Throws if the sender is not the owner.
1764      */
1765     function _checkOwner() internal view virtual {
1766         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1767     }
1768 
1769     /**
1770      * @dev Leaves the contract without owner. It will not be possible to call
1771      * `onlyOwner` functions anymore. Can only be called by the current owner.
1772      *
1773      * NOTE: Renouncing ownership will leave the contract without an owner,
1774      * thereby removing any functionality that is only available to the owner.
1775      */
1776     function renounceOwnership() public virtual onlyOwner {
1777         _transferOwnership(address(0));
1778     }
1779 
1780     /**
1781      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1782      * Can only be called by the current owner.
1783      */
1784     function transferOwnership(address newOwner) public virtual onlyOwner {
1785         require(newOwner != address(0), "Ownable: new owner is the zero address");
1786         _transferOwnership(newOwner);
1787     }
1788 
1789     /**
1790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1791      * Internal function without access restriction.
1792      */
1793     function _transferOwnership(address newOwner) internal virtual {
1794         address oldOwner = _owner;
1795         _owner = newOwner;
1796         emit OwnershipTransferred(oldOwner, newOwner);
1797     }
1798 }
1799 
1800 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1801 
1802 
1803 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1804 
1805 pragma solidity ^0.8.0;
1806 
1807 /**
1808  * @dev Contract module that helps prevent reentrant calls to a function.
1809  *
1810  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1811  * available, which can be applied to functions to make sure there are no nested
1812  * (reentrant) calls to them.
1813  *
1814  * Note that because there is a single `nonReentrant` guard, functions marked as
1815  * `nonReentrant` may not call one another. This can be worked around by making
1816  * those functions `private`, and then adding `external` `nonReentrant` entry
1817  * points to them.
1818  *
1819  * TIP: If you would like to learn more about reentrancy and alternative ways
1820  * to protect against it, check out our blog post
1821  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1822  */
1823 abstract contract ReentrancyGuard {
1824     // Booleans are more expensive than uint256 or any type that takes up a full
1825     // word because each write operation emits an extra SLOAD to first read the
1826     // slot's contents, replace the bits taken up by the boolean, and then write
1827     // back. This is the compiler's defense against contract upgrades and
1828     // pointer aliasing, and it cannot be disabled.
1829 
1830     // The values being non-zero value makes deployment a bit more expensive,
1831     // but in exchange the refund on every call to nonReentrant will be lower in
1832     // amount. Since refunds are capped to a percentage of the total
1833     // transaction's gas, it is best to keep them low in cases like this one, to
1834     // increase the likelihood of the full refund coming into effect.
1835     uint256 private constant _NOT_ENTERED = 1;
1836     uint256 private constant _ENTERED = 2;
1837 
1838     uint256 private _status;
1839 
1840     constructor() {
1841         _status = _NOT_ENTERED;
1842     }
1843 
1844     /**
1845      * @dev Prevents a contract from calling itself, directly or indirectly.
1846      * Calling a `nonReentrant` function from another `nonReentrant`
1847      * function is not supported. It is possible to prevent this from happening
1848      * by making the `nonReentrant` function external, and making it call a
1849      * `private` function that does the actual work.
1850      */
1851     modifier nonReentrant() {
1852         // On the first call to nonReentrant, _notEntered will be true
1853         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1854 
1855         // Any calls to nonReentrant after this point will fail
1856         _status = _ENTERED;
1857 
1858         _;
1859 
1860         // By storing the original value once again, a refund is triggered (see
1861         // https://eips.ethereum.org/EIPS/eip-2200)
1862         _status = _NOT_ENTERED;
1863     }
1864 }
1865 
1866 // File: contracts/whale.sol
1867 
1868 pragma solidity >=0.8.9 <0.9.0;
1869 
1870 
1871 
1872 
1873 
1874 
1875 contract WhaleLounge is  Ownable, ReentrancyGuard , ERC721A {
1876     using Strings for uint256;
1877     uint256 public maxSupply = 1000;
1878     string private BASE_URI = "https://meta.whalelounge.xyz/";
1879     uint256 public MAX_MINT_AMOUNT_PER_TX = 1;
1880     bool public IS_SALE_ACTIVE = false;
1881     bool public IS_WHITESALE_ACTIVE = false;
1882 
1883     uint256 public cost = 0;
1884     uint256 public wl_cost = 0;   
1885    
1886     bytes32 public merkleRoot;
1887 
1888     constructor() ERC721A("Whale Lounge", "WLP") {}
1889 
1890  
1891     /** GETTERS **/
1892 
1893     function _baseURI() internal view virtual override returns (string memory) {
1894         return BASE_URI;
1895     }
1896 
1897     /** SETTERS **/
1898 
1899     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1900         BASE_URI = customBaseURI_;
1901     }
1902     
1903     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1904         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1905     }
1906 
1907     function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
1908         require(newMaxSupply >= totalSupply(), "Invalid new max supply");
1909         maxSupply = newMaxSupply;
1910     }
1911 
1912     function setSaleActive(bool saleIsActive) external onlyOwner {
1913         IS_SALE_ACTIVE = saleIsActive;
1914     }
1915 
1916     function setWhiteSaleActive(bool WhitesaleIsActive) external onlyOwner {
1917         IS_WHITESALE_ACTIVE = WhitesaleIsActive;
1918     }
1919 
1920     function setMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
1921         merkleRoot = _newMerkleRoot;
1922     }
1923 
1924     function setPrice(uint256 newPrice) external onlyOwner {
1925         cost = newPrice;
1926     }
1927 
1928     function setWLPrice(uint256 newWLPrice) external onlyOwner {
1929         wl_cost = newWLPrice;
1930     }
1931 
1932     /** MINT **/
1933     modifier mintCompliance(uint256 _mintAmount) {
1934         require(
1935             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1936             "Invalid mint amount!"
1937         );
1938         require(
1939             totalSupply() + _mintAmount <= maxSupply,
1940             "Max supply exceeded!"
1941         );
1942         _;
1943     }
1944 
1945     function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
1946         public
1947         payable
1948         mintCompliance(_mintAmount)
1949     {
1950         require(IS_SALE_ACTIVE, "Sale is not active!");
1951         if (IS_WHITESALE_ACTIVE == true) {
1952 
1953             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1954             require(
1955                 MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1956                 "Invalid proof!"
1957             );
1958 
1959             uint256 price = wl_cost * _mintAmount;
1960             require(msg.value >= price, "Insufficient funds!");
1961 
1962             _safeMint(msg.sender, _mintAmount);  
1963         } else {
1964 
1965             uint256 price = cost * _mintAmount;
1966             require(msg.value >= price, "Insufficient funds!");
1967 
1968             _safeMint(msg.sender, _mintAmount);
1969         }
1970     }
1971 
1972     function ownerMint(address _to, uint256 _mintAmount)
1973         public
1974         mintCompliance(_mintAmount)
1975         onlyOwner
1976     {
1977         _safeMint(_to, _mintAmount);
1978     }
1979 
1980 
1981     function withdraw() public onlyOwner nonReentrant {
1982         uint256 balance = address(this).balance;
1983 
1984         (bool c1, ) = payable(0x3e8C9A71431BBcB4e4203D5ab9Aa78A0D0394478).call{value: balance * 30 / 100}('');
1985         require(c1);
1986         (bool c2, ) = payable(0x382DE335821632A7882e7fD9867107B1D59334AD).call{value: balance * 30 / 100}('');
1987         require(c2);
1988         (bool c3, ) = payable(0x191A0b21B74e036e95Bda7690155789B9C75A547).call{value: balance * 30 / 100}('');
1989         require(c3);
1990         (bool c4, ) = payable(0xAB23379b7B4606Ea0Da596592c2ef2a5b09a9fC5).call{value: balance * 8 / 100}('');
1991         require(c4);
1992         (bool c5, ) = payable(0x14aB3F3a1dB48963D6d8Bff9803596c5c3394212).call{value: balance * 2 / 100}('');
1993         require(c5);
1994 
1995     }
1996 
1997 }