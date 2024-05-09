1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Strings.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228     uint8 private constant _ADDRESS_LENGTH = 20;
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 
286     /**
287      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
288      */
289     function toHexString(address addr) internal pure returns (string memory) {
290         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
291     }
292 }
293 
294 // File: contracts/IERC721A.sol
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
317      * Cannot query the balance for the zero address.
318      */
319     error BalanceQueryForZeroAddress();
320 
321     /**
322      * Cannot mint to the zero address.
323      */
324     error MintToZeroAddress();
325 
326     /**
327      * The quantity of tokens minted must be more than zero.
328      */
329     error MintZeroQuantity();
330 
331     /**
332      * The token does not exist.
333      */
334     error OwnerQueryForNonexistentToken();
335 
336     /**
337      * The caller must own the token or be an approved operator.
338      */
339     error TransferCallerNotOwnerNorApproved();
340 
341     /**
342      * The token must be owned by `from`.
343      */
344     error TransferFromIncorrectOwner();
345 
346     /**
347      * Cannot safely transfer to a contract that does not implement the
348      * ERC721Receiver interface.
349      */
350     error TransferToNonERC721ReceiverImplementer();
351 
352     /**
353      * Cannot transfer to the zero address.
354      */
355     error TransferToZeroAddress();
356 
357     /**
358      * The token does not exist.
359      */
360     error URIQueryForNonexistentToken();
361 
362     /**
363      * The `quantity` minted with ERC2309 exceeds the safety limit.
364      */
365     error MintERC2309QuantityExceedsLimit();
366 
367     /**
368      * The `extraData` cannot be set on an unintialized ownership slot.
369      */
370     error OwnershipNotInitializedForExtraData();
371 
372     // =============================================================
373     //                            STRUCTS
374     // =============================================================
375 
376     struct TokenOwnership {
377         // The address of the owner.
378         address addr;
379         // Stores the start time of ownership with minimal overhead for tokenomics.
380         uint64 startTimestamp;
381         // Whether the token has been burned.
382         bool burned;
383         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
384         uint24 extraData;
385     }
386 
387     // =============================================================
388     //                         TOKEN COUNTERS
389     // =============================================================
390 
391     /**
392      * @dev Returns the total number of tokens in existence.
393      * Burned tokens will reduce the count.
394      * To get the total number of tokens minted, please see {_totalMinted}.
395      */
396     function totalSupply() external view returns (uint256);
397 
398     // =============================================================
399     //                            IERC165
400     // =============================================================
401 
402     /**
403      * @dev Returns true if this contract implements the interface defined by
404      * `interfaceId`. See the corresponding
405      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
406      * to learn more about how these ids are created.
407      *
408      * This function call must use less than 30000 gas.
409      */
410     function supportsInterface(bytes4 interfaceId) external view returns (bool);
411 
412     // =============================================================
413     //                            IERC721
414     // =============================================================
415 
416     /**
417      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
418      */
419     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
420 
421     /**
422      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
423      */
424     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
425 
426     /**
427      * @dev Emitted when `owner` enables or disables
428      * (`approved`) `operator` to manage all of its assets.
429      */
430     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
431 
432     /**
433      * @dev Returns the number of tokens in `owner`'s account.
434      */
435     function balanceOf(address owner) external view returns (uint256 balance);
436 
437     /**
438      * @dev Returns the owner of the `tokenId` token.
439      *
440      * Requirements:
441      *
442      * - `tokenId` must exist.
443      */
444     function ownerOf(uint256 tokenId) external view returns (address owner);
445 
446     /**
447      * @dev Safely transfers `tokenId` token from `from` to `to`,
448      * checking first that contract recipients are aware of the ERC721 protocol
449      * to prevent tokens from being forever locked.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must exist and be owned by `from`.
456      * - If the caller is not `from`, it must be have been allowed to move
457      * this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement
459      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId,
467         bytes calldata data
468     ) external;
469 
470     /**
471      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
472      */
473     function safeTransferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external;
478 
479     /**
480      * @dev Transfers `tokenId` from `from` to `to`.
481      *
482      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
483      * whenever possible.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must be owned by `from`.
490      * - If the caller is not `from`, it must be approved to move this token
491      * by either {approve} or {setApprovalForAll}.
492      *
493      * Emits a {Transfer} event.
494      */
495     function transferFrom(
496         address from,
497         address to,
498         uint256 tokenId
499     ) external;
500 
501     /**
502      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
503      * The approval is cleared when the token is transferred.
504      *
505      * Only a single account can be approved at a time, so approving the
506      * zero address clears previous approvals.
507      *
508      * Requirements:
509      *
510      * - The caller must own the token or be an approved operator.
511      * - `tokenId` must exist.
512      *
513      * Emits an {Approval} event.
514      */
515     function approve(address to, uint256 tokenId) external;
516 
517     /**
518      * @dev Approve or remove `operator` as an operator for the caller.
519      * Operators can call {transferFrom} or {safeTransferFrom}
520      * for any token owned by the caller.
521      *
522      * Requirements:
523      *
524      * - The `operator` cannot be the caller.
525      *
526      * Emits an {ApprovalForAll} event.
527      */
528     function setApprovalForAll(address operator, bool _approved) external;
529 
530     /**
531      * @dev Returns the account approved for `tokenId` token.
532      *
533      * Requirements:
534      *
535      * - `tokenId` must exist.
536      */
537     function getApproved(uint256 tokenId) external view returns (address operator);
538 
539     /**
540      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
541      *
542      * See {setApprovalForAll}.
543      */
544     function isApprovedForAll(address owner, address operator) external view returns (bool);
545 
546     // =============================================================
547     //                        IERC721Metadata
548     // =============================================================
549 
550     /**
551      * @dev Returns the token collection name.
552      */
553     function name() external view returns (string memory);
554 
555     /**
556      * @dev Returns the token collection symbol.
557      */
558     function symbol() external view returns (string memory);
559 
560     /**
561      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
562      */
563     function tokenURI(uint256 tokenId) external view returns (string memory);
564 
565     // =============================================================
566     //                           IERC2309
567     // =============================================================
568 
569     /**
570      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
571      * (inclusive) is transferred from `from` to `to`, as defined in the
572      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
573      *
574      * See {_mintERC2309} for more details.
575      */
576     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
577 }
578 // File: contracts/ERC721A.sol
579 
580 
581 // ERC721A Contracts v4.2.2
582 // Creator: Chiru Labs
583 
584 pragma solidity ^0.8.4;
585 
586 
587 /**
588  * @dev Interface of ERC721 token receiver.
589  */
590 interface ERC721A__IERC721Receiver {
591     function onERC721Received(
592         address operator,
593         address from,
594         uint256 tokenId,
595         bytes calldata data
596     ) external returns (bytes4);
597 }
598 
599 /**
600  * @title ERC721A
601  *
602  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
603  * Non-Fungible Token Standard, including the Metadata extension.
604  * Optimized for lower gas during batch mints.
605  *
606  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
607  * starting from `_startTokenId()`.
608  *
609  * Assumptions:
610  *
611  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
612  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
613  */
614 contract ERC721A is IERC721A {
615     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
616     struct TokenApprovalRef {
617         address value;
618     }
619 
620     // =============================================================
621     //                           CONSTANTS
622     // =============================================================
623 
624     // Mask of an entry in packed address data.
625     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
626 
627     // The bit position of `numberMinted` in packed address data.
628     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
629 
630     // The bit position of `numberBurned` in packed address data.
631     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
632 
633     // The bit position of `aux` in packed address data.
634     uint256 private constant _BITPOS_AUX = 192;
635 
636     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
637     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
638 
639     // The bit position of `startTimestamp` in packed ownership.
640     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
641 
642     // The bit mask of the `burned` bit in packed ownership.
643     uint256 private constant _BITMASK_BURNED = 1 << 224;
644 
645     // The bit position of the `nextInitialized` bit in packed ownership.
646     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
647 
648     // The bit mask of the `nextInitialized` bit in packed ownership.
649     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
650 
651     // The bit position of `extraData` in packed ownership.
652     uint256 private constant _BITPOS_EXTRA_DATA = 232;
653 
654     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
655     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
656 
657     // The mask of the lower 160 bits for addresses.
658     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
659 
660     // The maximum `quantity` that can be minted with {_mintERC2309}.
661     // This limit is to prevent overflows on the address data entries.
662     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
663     // is required to cause an overflow, which is unrealistic.
664     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
665 
666     // The `Transfer` event signature is given by:
667     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
668     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
669         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
670 
671     // =============================================================
672     //                            STORAGE
673     // =============================================================
674 
675     // The next token ID to be minted.
676     uint256 private _currentIndex;
677 
678     // The number of tokens burned.
679     uint256 private _burnCounter;
680 
681     // Token name
682     string private _name;
683 
684     // Token symbol
685     string private _symbol;
686 
687     // Mapping from token ID to ownership details
688     // An empty struct value does not necessarily mean the token is unowned.
689     // See {_packedOwnershipOf} implementation for details.
690     //
691     // Bits Layout:
692     // - [0..159]   `addr`
693     // - [160..223] `startTimestamp`
694     // - [224]      `burned`
695     // - [225]      `nextInitialized`
696     // - [232..255] `extraData`
697     mapping(uint256 => uint256) private _packedOwnerships;
698 
699     // Mapping owner address to address data.
700     //
701     // Bits Layout:
702     // - [0..63]    `balance`
703     // - [64..127]  `numberMinted`
704     // - [128..191] `numberBurned`
705     // - [192..255] `aux`
706     mapping(address => uint256) private _packedAddressData;
707 
708     // Mapping from token ID to approved address.
709     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
710 
711     // Mapping from owner to operator approvals
712     mapping(address => mapping(address => bool)) private _operatorApprovals;
713 
714     // =============================================================
715     //                          CONSTRUCTOR
716     // =============================================================
717 
718     constructor(string memory name_, string memory symbol_) {
719         _name = name_;
720         _symbol = symbol_;
721         _currentIndex = _startTokenId();
722     }
723 
724     // =============================================================
725     //                   TOKEN COUNTING OPERATIONS
726     // =============================================================
727 
728     /**
729      * @dev Returns the starting token ID.
730      * To change the starting token ID, please override this function.
731      */
732     function _startTokenId() internal view virtual returns (uint256) {
733         return 0;
734     }
735 
736     /**
737      * @dev Returns the next token ID to be minted.
738      */
739     function _nextTokenId() internal view virtual returns (uint256) {
740         return _currentIndex;
741     }
742 
743     /**
744      * @dev Returns the total number of tokens in existence.
745      * Burned tokens will reduce the count.
746      * To get the total number of tokens minted, please see {_totalMinted}.
747      */
748     function totalSupply() public view virtual override returns (uint256) {
749         // Counter underflow is impossible as _burnCounter cannot be incremented
750         // more than `_currentIndex - _startTokenId()` times.
751         unchecked {
752             return _currentIndex - _burnCounter - _startTokenId();
753         }
754     }
755 
756     /**
757      * @dev Returns the total amount of tokens minted in the contract.
758      */
759     function _totalMinted() internal view virtual returns (uint256) {
760         // Counter underflow is impossible as `_currentIndex` does not decrement,
761         // and it is initialized to `_startTokenId()`.
762         unchecked {
763             return _currentIndex - _startTokenId();
764         }
765     }
766 
767     /**
768      * @dev Returns the total number of tokens burned.
769      */
770     function _totalBurned() internal view virtual returns (uint256) {
771         return _burnCounter;
772     }
773 
774     // =============================================================
775     //                    ADDRESS DATA OPERATIONS
776     // =============================================================
777 
778     /**
779      * @dev Returns the number of tokens in `owner`'s account.
780      */
781     function balanceOf(address owner) public view virtual override returns (uint256) {
782         if (owner == address(0)) revert BalanceQueryForZeroAddress();
783         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
784     }
785 
786     /**
787      * Returns the number of tokens minted by `owner`.
788      */
789     function _numberMinted(address owner) internal view returns (uint256) {
790         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
791     }
792 
793     /**
794      * Returns the number of tokens burned by or on behalf of `owner`.
795      */
796     function _numberBurned(address owner) internal view returns (uint256) {
797         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
798     }
799 
800     /**
801      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
802      */
803     function _getAux(address owner) internal view returns (uint64) {
804         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
805     }
806 
807     /**
808      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
809      * If there are multiple variables, please pack them into a uint64.
810      */
811     function _setAux(address owner, uint64 aux) internal virtual {
812         uint256 packed = _packedAddressData[owner];
813         uint256 auxCasted;
814         // Cast `aux` with assembly to avoid redundant masking.
815         assembly {
816             auxCasted := aux
817         }
818         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
819         _packedAddressData[owner] = packed;
820     }
821 
822     // =============================================================
823     //                            IERC165
824     // =============================================================
825 
826     /**
827      * @dev Returns true if this contract implements the interface defined by
828      * `interfaceId`. See the corresponding
829      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
830      * to learn more about how these ids are created.
831      *
832      * This function call must use less than 30000 gas.
833      */
834     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
835         // The interface IDs are constants representing the first 4 bytes
836         // of the XOR of all function selectors in the interface.
837         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
838         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
839         return
840             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
841             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
842             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
843     }
844 
845     // =============================================================
846     //                        IERC721Metadata
847     // =============================================================
848 
849     /**
850      * @dev Returns the token collection name.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev Returns the token collection symbol.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, it can be overridden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return '';
880     }
881 
882     // =============================================================
883     //                     OWNERSHIPS OPERATIONS
884     // =============================================================
885 
886     /**
887      * @dev Returns the owner of the `tokenId` token.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must exist.
892      */
893     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
894         return address(uint160(_packedOwnershipOf(tokenId)));
895     }
896 
897     /**
898      * @dev Gas spent here starts off proportional to the maximum mint batch size.
899      * It gradually moves to O(1) as tokens get transferred around over time.
900      */
901     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
902         return _unpackedOwnership(_packedOwnershipOf(tokenId));
903     }
904 
905     /**
906      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
907      */
908     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
909         return _unpackedOwnership(_packedOwnerships[index]);
910     }
911 
912     /**
913      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
914      */
915     function _initializeOwnershipAt(uint256 index) internal virtual {
916         if (_packedOwnerships[index] == 0) {
917             _packedOwnerships[index] = _packedOwnershipOf(index);
918         }
919     }
920 
921     /**
922      * Returns the packed ownership data of `tokenId`.
923      */
924     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
925         uint256 curr = tokenId;
926 
927         unchecked {
928             if (_startTokenId() <= curr)
929                 if (curr < _currentIndex) {
930                     uint256 packed = _packedOwnerships[curr];
931                     // If not burned.
932                     if (packed & _BITMASK_BURNED == 0) {
933                         // Invariant:
934                         // There will always be an initialized ownership slot
935                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
936                         // before an unintialized ownership slot
937                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
938                         // Hence, `curr` will not underflow.
939                         //
940                         // We can directly compare the packed value.
941                         // If the address is zero, packed will be zero.
942                         while (packed == 0) {
943                             packed = _packedOwnerships[--curr];
944                         }
945                         return packed;
946                     }
947                 }
948         }
949         revert OwnerQueryForNonexistentToken();
950     }
951 
952     /**
953      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
954      */
955     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
956         ownership.addr = address(uint160(packed));
957         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
958         ownership.burned = packed & _BITMASK_BURNED != 0;
959         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
960     }
961 
962     /**
963      * @dev Packs ownership data into a single uint256.
964      */
965     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
966         assembly {
967             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
968             owner := and(owner, _BITMASK_ADDRESS)
969             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
970             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
971         }
972     }
973 
974     /**
975      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
976      */
977     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
978         // For branchless setting of the `nextInitialized` flag.
979         assembly {
980             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
981             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
982         }
983     }
984 
985     // =============================================================
986     //                      APPROVAL OPERATIONS
987     // =============================================================
988 
989     /**
990      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
991      * The approval is cleared when the token is transferred.
992      *
993      * Only a single account can be approved at a time, so approving the
994      * zero address clears previous approvals.
995      *
996      * Requirements:
997      *
998      * - The caller must own the token or be an approved operator.
999      * - `tokenId` must exist.
1000      *
1001      * Emits an {Approval} event.
1002      */
1003     function approve(address to, uint256 tokenId) public virtual override {
1004         address owner = ownerOf(tokenId);
1005 
1006         if (_msgSenderERC721A() != owner)
1007             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1008                 revert ApprovalCallerNotOwnerNorApproved();
1009             }
1010 
1011         _tokenApprovals[tokenId].value = to;
1012         emit Approval(owner, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev Returns the account approved for `tokenId` token.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      */
1022     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1023         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1024 
1025         return _tokenApprovals[tokenId].value;
1026     }
1027 
1028     /**
1029      * @dev Approve or remove `operator` as an operator for the caller.
1030      * Operators can call {transferFrom} or {safeTransferFrom}
1031      * for any token owned by the caller.
1032      *
1033      * Requirements:
1034      *
1035      * - The `operator` cannot be the caller.
1036      *
1037      * Emits an {ApprovalForAll} event.
1038      */
1039     function setApprovalForAll(address operator, bool approved) public virtual override {
1040         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1041         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1042     }
1043 
1044     /**
1045      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1046      *
1047      * See {setApprovalForAll}.
1048      */
1049     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1050         return _operatorApprovals[owner][operator];
1051     }
1052 
1053     /**
1054      * @dev Returns whether `tokenId` exists.
1055      *
1056      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1057      *
1058      * Tokens start existing when they are minted. See {_mint}.
1059      */
1060     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1061         return
1062             _startTokenId() <= tokenId &&
1063             tokenId < _currentIndex && // If within bounds,
1064             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1065     }
1066 
1067     /**
1068      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1069      */
1070     function _isSenderApprovedOrOwner(
1071         address approvedAddress,
1072         address owner,
1073         address msgSender
1074     ) private pure returns (bool result) {
1075         assembly {
1076             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1077             owner := and(owner, _BITMASK_ADDRESS)
1078             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1079             msgSender := and(msgSender, _BITMASK_ADDRESS)
1080             // `msgSender == owner || msgSender == approvedAddress`.
1081             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1082         }
1083     }
1084 
1085     /**
1086      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1087      */
1088     function _getApprovedSlotAndAddress(uint256 tokenId)
1089         private
1090         view
1091         returns (uint256 approvedAddressSlot, address approvedAddress)
1092     {
1093         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1094         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1095         assembly {
1096             approvedAddressSlot := tokenApproval.slot
1097             approvedAddress := sload(approvedAddressSlot)
1098         }
1099     }
1100 
1101     // =============================================================
1102     //                      TRANSFER OPERATIONS
1103     // =============================================================
1104 
1105     /**
1106      * @dev Transfers `tokenId` from `from` to `to`.
1107      *
1108      * Requirements:
1109      *
1110      * - `from` cannot be the zero address.
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must be owned by `from`.
1113      * - If the caller is not `from`, it must be approved to move this token
1114      * by either {approve} or {setApprovalForAll}.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function transferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) public virtual override {
1123         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1124 
1125         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1126 
1127         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1128 
1129         // The nested ifs save around 20+ gas over a compound boolean condition.
1130         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1131             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1132 
1133         if (to == address(0)) revert TransferToZeroAddress();
1134 
1135         _beforeTokenTransfers(from, to, tokenId, 1);
1136 
1137         // Clear approvals from the previous owner.
1138         assembly {
1139             if approvedAddress {
1140                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1141                 sstore(approvedAddressSlot, 0)
1142             }
1143         }
1144 
1145         // Underflow of the sender's balance is impossible because we check for
1146         // ownership above and the recipient's balance can't realistically overflow.
1147         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1148         unchecked {
1149             // We can directly increment and decrement the balances.
1150             --_packedAddressData[from]; // Updates: `balance -= 1`.
1151             ++_packedAddressData[to]; // Updates: `balance += 1`.
1152 
1153             // Updates:
1154             // - `address` to the next owner.
1155             // - `startTimestamp` to the timestamp of transfering.
1156             // - `burned` to `false`.
1157             // - `nextInitialized` to `true`.
1158             _packedOwnerships[tokenId] = _packOwnershipData(
1159                 to,
1160                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1161             );
1162 
1163             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1164             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1165                 uint256 nextTokenId = tokenId + 1;
1166                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1167                 if (_packedOwnerships[nextTokenId] == 0) {
1168                     // If the next slot is within bounds.
1169                     if (nextTokenId != _currentIndex) {
1170                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1171                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1172                     }
1173                 }
1174             }
1175         }
1176 
1177         emit Transfer(from, to, tokenId);
1178         _afterTokenTransfers(from, to, tokenId, 1);
1179     }
1180 
1181     /**
1182      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1183      */
1184     function safeTransferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) public virtual override {
1189         safeTransferFrom(from, to, tokenId, '');
1190     }
1191 
1192     /**
1193      * @dev Safely transfers `tokenId` token from `from` to `to`.
1194      *
1195      * Requirements:
1196      *
1197      * - `from` cannot be the zero address.
1198      * - `to` cannot be the zero address.
1199      * - `tokenId` token must exist and be owned by `from`.
1200      * - If the caller is not `from`, it must be approved to move this token
1201      * by either {approve} or {setApprovalForAll}.
1202      * - If `to` refers to a smart contract, it must implement
1203      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function safeTransferFrom(
1208         address from,
1209         address to,
1210         uint256 tokenId,
1211         bytes memory _data
1212     ) public virtual override {
1213         transferFrom(from, to, tokenId);
1214         if (to.code.length != 0)
1215             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1216                 revert TransferToNonERC721ReceiverImplementer();
1217             }
1218     }
1219 
1220     /**
1221      * @dev Hook that is called before a set of serially-ordered token IDs
1222      * are about to be transferred. This includes minting.
1223      * And also called before burning one token.
1224      *
1225      * `startTokenId` - the first token ID to be transferred.
1226      * `quantity` - the amount to be transferred.
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` will be minted for `to`.
1233      * - When `to` is zero, `tokenId` will be burned by `from`.
1234      * - `from` and `to` are never both zero.
1235      */
1236     function _beforeTokenTransfers(
1237         address from,
1238         address to,
1239         uint256 startTokenId,
1240         uint256 quantity
1241     ) internal virtual {}
1242 
1243     /**
1244      * @dev Hook that is called after a set of serially-ordered token IDs
1245      * have been transferred. This includes minting.
1246      * And also called after one token has been burned.
1247      *
1248      * `startTokenId` - the first token ID to be transferred.
1249      * `quantity` - the amount to be transferred.
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` has been minted for `to`.
1256      * - When `to` is zero, `tokenId` has been burned by `from`.
1257      * - `from` and `to` are never both zero.
1258      */
1259     function _afterTokenTransfers(
1260         address from,
1261         address to,
1262         uint256 startTokenId,
1263         uint256 quantity
1264     ) internal virtual {}
1265 
1266     /**
1267      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1268      *
1269      * `from` - Previous owner of the given token ID.
1270      * `to` - Target address that will receive the token.
1271      * `tokenId` - Token ID to be transferred.
1272      * `_data` - Optional data to send along with the call.
1273      *
1274      * Returns whether the call correctly returned the expected magic value.
1275      */
1276     function _checkContractOnERC721Received(
1277         address from,
1278         address to,
1279         uint256 tokenId,
1280         bytes memory _data
1281     ) private returns (bool) {
1282         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1283             bytes4 retval
1284         ) {
1285             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1286         } catch (bytes memory reason) {
1287             if (reason.length == 0) {
1288                 revert TransferToNonERC721ReceiverImplementer();
1289             } else {
1290                 assembly {
1291                     revert(add(32, reason), mload(reason))
1292                 }
1293             }
1294         }
1295     }
1296 
1297     // =============================================================
1298     //                        MINT OPERATIONS
1299     // =============================================================
1300 
1301     /**
1302      * @dev Mints `quantity` tokens and transfers them to `to`.
1303      *
1304      * Requirements:
1305      *
1306      * - `to` cannot be the zero address.
1307      * - `quantity` must be greater than 0.
1308      *
1309      * Emits a {Transfer} event for each mint.
1310      */
1311     function _mint(address to, uint256 quantity) internal virtual {
1312         uint256 startTokenId = _currentIndex;
1313         if (quantity == 0) revert MintZeroQuantity();
1314 
1315         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1316 
1317         // Overflows are incredibly unrealistic.
1318         // `balance` and `numberMinted` have a maximum limit of 2**64.
1319         // `tokenId` has a maximum limit of 2**256.
1320         unchecked {
1321             // Updates:
1322             // - `balance += quantity`.
1323             // - `numberMinted += quantity`.
1324             //
1325             // We can directly add to the `balance` and `numberMinted`.
1326             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1327 
1328             // Updates:
1329             // - `address` to the owner.
1330             // - `startTimestamp` to the timestamp of minting.
1331             // - `burned` to `false`.
1332             // - `nextInitialized` to `quantity == 1`.
1333             _packedOwnerships[startTokenId] = _packOwnershipData(
1334                 to,
1335                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1336             );
1337 
1338             uint256 toMasked;
1339             uint256 end = startTokenId + quantity;
1340 
1341             // Use assembly to loop and emit the `Transfer` event for gas savings.
1342             // The duplicated `log4` removes an extra check and reduces stack juggling.
1343             // The assembly, together with the surrounding Solidity code, have been
1344             // delicately arranged to nudge the compiler into producing optimized opcodes.
1345             assembly {
1346                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1347                 toMasked := and(to, _BITMASK_ADDRESS)
1348                 // Emit the `Transfer` event.
1349                 log4(
1350                     0, // Start of data (0, since no data).
1351                     0, // End of data (0, since no data).
1352                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1353                     0, // `address(0)`.
1354                     toMasked, // `to`.
1355                     startTokenId // `tokenId`.
1356                 )
1357 
1358                 for {
1359                     let tokenId := add(startTokenId, 1)
1360                 } iszero(eq(tokenId, end)) {
1361                     tokenId := add(tokenId, 1)
1362                 } {
1363                     // Emit the `Transfer` event. Similar to above.
1364                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1365                 }
1366             }
1367             if (toMasked == 0) revert MintToZeroAddress();
1368 
1369             _currentIndex = end;
1370         }
1371         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1372     }
1373 
1374     /**
1375      * @dev Mints `quantity` tokens and transfers them to `to`.
1376      *
1377      * This function is intended for efficient minting only during contract creation.
1378      *
1379      * It emits only one {ConsecutiveTransfer} as defined in
1380      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1381      * instead of a sequence of {Transfer} event(s).
1382      *
1383      * Calling this function outside of contract creation WILL make your contract
1384      * non-compliant with the ERC721 standard.
1385      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1386      * {ConsecutiveTransfer} event is only permissible during contract creation.
1387      *
1388      * Requirements:
1389      *
1390      * - `to` cannot be the zero address.
1391      * - `quantity` must be greater than 0.
1392      *
1393      * Emits a {ConsecutiveTransfer} event.
1394      */
1395     function _mintERC2309(address to, uint256 quantity) internal virtual {
1396         uint256 startTokenId = _currentIndex;
1397         if (to == address(0)) revert MintToZeroAddress();
1398         if (quantity == 0) revert MintZeroQuantity();
1399         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1400 
1401         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1402 
1403         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1404         unchecked {
1405             // Updates:
1406             // - `balance += quantity`.
1407             // - `numberMinted += quantity`.
1408             //
1409             // We can directly add to the `balance` and `numberMinted`.
1410             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1411 
1412             // Updates:
1413             // - `address` to the owner.
1414             // - `startTimestamp` to the timestamp of minting.
1415             // - `burned` to `false`.
1416             // - `nextInitialized` to `quantity == 1`.
1417             _packedOwnerships[startTokenId] = _packOwnershipData(
1418                 to,
1419                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1420             );
1421 
1422             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1423 
1424             _currentIndex = startTokenId + quantity;
1425         }
1426         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1427     }
1428 
1429     /**
1430      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1431      *
1432      * Requirements:
1433      *
1434      * - If `to` refers to a smart contract, it must implement
1435      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1436      * - `quantity` must be greater than 0.
1437      *
1438      * See {_mint}.
1439      *
1440      * Emits a {Transfer} event for each mint.
1441      */
1442     function _safeMint(
1443         address to,
1444         uint256 quantity,
1445         bytes memory _data
1446     ) internal virtual {
1447         _mint(to, quantity);
1448 
1449         unchecked {
1450             if (to.code.length != 0) {
1451                 uint256 end = _currentIndex;
1452                 uint256 index = end - quantity;
1453                 do {
1454                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1455                         revert TransferToNonERC721ReceiverImplementer();
1456                     }
1457                 } while (index < end);
1458                 // Reentrancy protection.
1459                 if (_currentIndex != end) revert();
1460             }
1461         }
1462     }
1463 
1464     /**
1465      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1466      */
1467     function _safeMint(address to, uint256 quantity) internal virtual {
1468         _safeMint(to, quantity, '');
1469     }
1470 
1471     // =============================================================
1472     //                        BURN OPERATIONS
1473     // =============================================================
1474 
1475     /**
1476      * @dev Equivalent to `_burn(tokenId, false)`.
1477      */
1478     function _burn(uint256 tokenId) internal virtual {
1479         _burn(tokenId, false);
1480     }
1481 
1482     /**
1483      * @dev Destroys `tokenId`.
1484      * The approval is cleared when the token is burned.
1485      *
1486      * Requirements:
1487      *
1488      * - `tokenId` must exist.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1493         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1494 
1495         address from = address(uint160(prevOwnershipPacked));
1496 
1497         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1498 
1499         if (approvalCheck) {
1500             // The nested ifs save around 20+ gas over a compound boolean condition.
1501             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1502                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1503         }
1504 
1505         _beforeTokenTransfers(from, address(0), tokenId, 1);
1506 
1507         // Clear approvals from the previous owner.
1508         assembly {
1509             if approvedAddress {
1510                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1511                 sstore(approvedAddressSlot, 0)
1512             }
1513         }
1514 
1515         // Underflow of the sender's balance is impossible because we check for
1516         // ownership above and the recipient's balance can't realistically overflow.
1517         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1518         unchecked {
1519             // Updates:
1520             // - `balance -= 1`.
1521             // - `numberBurned += 1`.
1522             //
1523             // We can directly decrement the balance, and increment the number burned.
1524             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1525             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1526 
1527             // Updates:
1528             // - `address` to the last owner.
1529             // - `startTimestamp` to the timestamp of burning.
1530             // - `burned` to `true`.
1531             // - `nextInitialized` to `true`.
1532             _packedOwnerships[tokenId] = _packOwnershipData(
1533                 from,
1534                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1535             );
1536 
1537             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1538             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1539                 uint256 nextTokenId = tokenId + 1;
1540                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1541                 if (_packedOwnerships[nextTokenId] == 0) {
1542                     // If the next slot is within bounds.
1543                     if (nextTokenId != _currentIndex) {
1544                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1545                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1546                     }
1547                 }
1548             }
1549         }
1550 
1551         emit Transfer(from, address(0), tokenId);
1552         _afterTokenTransfers(from, address(0), tokenId, 1);
1553 
1554         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1555         unchecked {
1556             _burnCounter++;
1557         }
1558     }
1559 
1560     // =============================================================
1561     //                     EXTRA DATA OPERATIONS
1562     // =============================================================
1563 
1564     /**
1565      * @dev Directly sets the extra data for the ownership data `index`.
1566      */
1567     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1568         uint256 packed = _packedOwnerships[index];
1569         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1570         uint256 extraDataCasted;
1571         // Cast `extraData` with assembly to avoid redundant masking.
1572         assembly {
1573             extraDataCasted := extraData
1574         }
1575         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1576         _packedOwnerships[index] = packed;
1577     }
1578 
1579     /**
1580      * @dev Called during each token transfer to set the 24bit `extraData` field.
1581      * Intended to be overridden by the cosumer contract.
1582      *
1583      * `previousExtraData` - the value of `extraData` before transfer.
1584      *
1585      * Calling conditions:
1586      *
1587      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1588      * transferred to `to`.
1589      * - When `from` is zero, `tokenId` will be minted for `to`.
1590      * - When `to` is zero, `tokenId` will be burned by `from`.
1591      * - `from` and `to` are never both zero.
1592      */
1593     function _extraData(
1594         address from,
1595         address to,
1596         uint24 previousExtraData
1597     ) internal view virtual returns (uint24) {}
1598 
1599     /**
1600      * @dev Returns the next extra data for the packed ownership data.
1601      * The returned result is shifted into position.
1602      */
1603     function _nextExtraData(
1604         address from,
1605         address to,
1606         uint256 prevOwnershipPacked
1607     ) private view returns (uint256) {
1608         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1609         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1610     }
1611 
1612     // =============================================================
1613     //                       OTHER OPERATIONS
1614     // =============================================================
1615 
1616     /**
1617      * @dev Returns the message sender (defaults to `msg.sender`).
1618      *
1619      * If you are writing GSN compatible contracts, you need to override this function.
1620      */
1621     function _msgSenderERC721A() internal view virtual returns (address) {
1622         return msg.sender;
1623     }
1624 
1625     /**
1626      * @dev Converts a uint256 to its ASCII string decimal representation.
1627      */
1628     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1629         assembly {
1630             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1631             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1632             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1633             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1634             let m := add(mload(0x40), 0xa0)
1635             // Update the free memory pointer to allocate.
1636             mstore(0x40, m)
1637             // Assign the `str` to the end.
1638             str := sub(m, 0x20)
1639             // Zeroize the slot after the string.
1640             mstore(str, 0)
1641 
1642             // Cache the end of the memory to calculate the length later.
1643             let end := str
1644 
1645             // We write the string from rightmost digit to leftmost digit.
1646             // The following is essentially a do-while loop that also handles the zero case.
1647             // prettier-ignore
1648             for { let temp := value } 1 {} {
1649                 str := sub(str, 1)
1650                 // Write the character to the pointer.
1651                 // The ASCII index of the '0' character is 48.
1652                 mstore8(str, add(48, mod(temp, 10)))
1653                 // Keep dividing `temp` until zero.
1654                 temp := div(temp, 10)
1655                 // prettier-ignore
1656                 if iszero(temp) { break }
1657             }
1658 
1659             let length := sub(end, str)
1660             // Move the pointer 32 bytes leftwards to make room for the length.
1661             str := sub(str, 0x20)
1662             // Store the length.
1663             mstore(str, length)
1664         }
1665     }
1666 }
1667 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1668 
1669 
1670 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1671 
1672 pragma solidity ^0.8.0;
1673 
1674 /**
1675  * @dev Contract module that helps prevent reentrant calls to a function.
1676  *
1677  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1678  * available, which can be applied to functions to make sure there are no nested
1679  * (reentrant) calls to them.
1680  *
1681  * Note that because there is a single `nonReentrant` guard, functions marked as
1682  * `nonReentrant` may not call one another. This can be worked around by making
1683  * those functions `private`, and then adding `external` `nonReentrant` entry
1684  * points to them.
1685  *
1686  * TIP: If you would like to learn more about reentrancy and alternative ways
1687  * to protect against it, check out our blog post
1688  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1689  */
1690 abstract contract ReentrancyGuard {
1691     // Booleans are more expensive than uint256 or any type that takes up a full
1692     // word because each write operation emits an extra SLOAD to first read the
1693     // slot's contents, replace the bits taken up by the boolean, and then write
1694     // back. This is the compiler's defense against contract upgrades and
1695     // pointer aliasing, and it cannot be disabled.
1696 
1697     // The values being non-zero value makes deployment a bit more expensive,
1698     // but in exchange the refund on every call to nonReentrant will be lower in
1699     // amount. Since refunds are capped to a percentage of the total
1700     // transaction's gas, it is best to keep them low in cases like this one, to
1701     // increase the likelihood of the full refund coming into effect.
1702     uint256 private constant _NOT_ENTERED = 1;
1703     uint256 private constant _ENTERED = 2;
1704 
1705     uint256 private _status;
1706 
1707     constructor() {
1708         _status = _NOT_ENTERED;
1709     }
1710 
1711     /**
1712      * @dev Prevents a contract from calling itself, directly or indirectly.
1713      * Calling a `nonReentrant` function from another `nonReentrant`
1714      * function is not supported. It is possible to prevent this from happening
1715      * by making the `nonReentrant` function external, and making it call a
1716      * `private` function that does the actual work.
1717      */
1718     modifier nonReentrant() {
1719         // On the first call to nonReentrant, _notEntered will be true
1720         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1721 
1722         // Any calls to nonReentrant after this point will fail
1723         _status = _ENTERED;
1724 
1725         _;
1726 
1727         // By storing the original value once again, a refund is triggered (see
1728         // https://eips.ethereum.org/EIPS/eip-2200)
1729         _status = _NOT_ENTERED;
1730     }
1731 }
1732 
1733 // File: @openzeppelin/contracts/utils/Context.sol
1734 
1735 
1736 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1737 
1738 pragma solidity ^0.8.0;
1739 
1740 /**
1741  * @dev Provides information about the current execution context, including the
1742  * sender of the transaction and its data. While these are generally available
1743  * via msg.sender and msg.data, they should not be accessed in such a direct
1744  * manner, since when dealing with meta-transactions the account sending and
1745  * paying for execution may not be the actual sender (as far as an application
1746  * is concerned).
1747  *
1748  * This contract is only required for intermediate, library-like contracts.
1749  */
1750 abstract contract Context {
1751     function _msgSender() internal view virtual returns (address) {
1752         return msg.sender;
1753     }
1754 
1755     function _msgData() internal view virtual returns (bytes calldata) {
1756         return msg.data;
1757     }
1758 }
1759 
1760 // File: @openzeppelin/contracts/access/Ownable.sol
1761 
1762 
1763 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1764 
1765 pragma solidity ^0.8.0;
1766 
1767 
1768 /**
1769  * @dev Contract module which provides a basic access control mechanism, where
1770  * there is an account (an owner) that can be granted exclusive access to
1771  * specific functions.
1772  *
1773  * By default, the owner account will be the one that deploys the contract. This
1774  * can later be changed with {transferOwnership}.
1775  *
1776  * This module is used through inheritance. It will make available the modifier
1777  * `onlyOwner`, which can be applied to your functions to restrict their use to
1778  * the owner.
1779  */
1780 abstract contract Ownable is Context {
1781     address private _owner;
1782 
1783     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1784 
1785     /**
1786      * @dev Initializes the contract setting the deployer as the initial owner.
1787      */
1788     constructor() {
1789         _transferOwnership(_msgSender());
1790     }
1791 
1792     /**
1793      * @dev Throws if called by any account other than the owner.
1794      */
1795     modifier onlyOwner() {
1796         _checkOwner();
1797         _;
1798     }
1799 
1800     /**
1801      * @dev Returns the address of the current owner.
1802      */
1803     function owner() public view virtual returns (address) {
1804         return _owner;
1805     }
1806 
1807     /**
1808      * @dev Throws if the sender is not the owner.
1809      */
1810     function _checkOwner() internal view virtual {
1811         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1812     }
1813 
1814     /**
1815      * @dev Leaves the contract without owner. It will not be possible to call
1816      * `onlyOwner` functions anymore. Can only be called by the current owner.
1817      *
1818      * NOTE: Renouncing ownership will leave the contract without an owner,
1819      * thereby removing any functionality that is only available to the owner.
1820      */
1821     function renounceOwnership() public virtual onlyOwner {
1822         _transferOwnership(address(0));
1823     }
1824 
1825     /**
1826      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1827      * Can only be called by the current owner.
1828      */
1829     function transferOwnership(address newOwner) public virtual onlyOwner {
1830         require(newOwner != address(0), "Ownable: new owner is the zero address");
1831         _transferOwnership(newOwner);
1832     }
1833 
1834     /**
1835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1836      * Internal function without access restriction.
1837      */
1838     function _transferOwnership(address newOwner) internal virtual {
1839         address oldOwner = _owner;
1840         _owner = newOwner;
1841         emit OwnershipTransferred(oldOwner, newOwner);
1842     }
1843 }
1844 
1845 // File: contracts/Parrots.sol
1846 
1847 
1848 
1849 pragma solidity ^0.8.0;
1850 
1851 
1852 
1853 
1854 
1855 
1856 contract Parrots is Ownable, ERC721A, ReentrancyGuard {
1857 
1858     bool private isPublicSaleOn = false;
1859     uint private constant MAX_SUPPLY = 1111;
1860     bytes32 public whiteListRoot;
1861   
1862     bool private whitelistOn = false;
1863     mapping(address => uint256) public whiteListClaimed;
1864     mapping(address => bool) public whiteListClaimedChecker;
1865     
1866 
1867 
1868     constructor() ERC721A("Pumping Parrots", "PP") {}
1869 
1870     modifier callerIsUser() {
1871         require(tx.origin == msg.sender, "The caller is another contract");
1872         _;
1873     }
1874 
1875 
1876     function reserveGiveaway(uint256 num, address walletAddress)
1877         public
1878         onlyOwner
1879     {
1880         require(totalSupply() + num <= MAX_SUPPLY, "Exceeds total supply");
1881         _safeMint(walletAddress, num);
1882     }
1883 
1884     function whiteListMint(bytes32[] calldata _merkleProof, uint256 quantity) external payable callerIsUser {
1885         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1886         require(MerkleProof.verify(_merkleProof, whiteListRoot, leaf),
1887             "Invalid Merkle Proof.");
1888         require(whitelistOn, "whitelist sale has not begun yet");
1889         require(totalSupply() + quantity <= 1000, "Exceeds total supply");
1890         if (!whiteListClaimedChecker[msg.sender]) {
1891             whiteListClaimedChecker[msg.sender] = true;
1892             whiteListClaimed[msg.sender] = 3;
1893         }
1894         require(whiteListClaimed[msg.sender] - quantity >= 0, "Address already minted num of tokens allowed");
1895         whiteListClaimed[msg.sender] = whiteListClaimed[msg.sender] - quantity;
1896         _safeMint(msg.sender, quantity);
1897         
1898     }
1899 
1900      function getWallet(address _owner) public view returns (uint256[] memory) {
1901         uint256 ownerBalance = balanceOf(_owner);
1902         uint256[] memory ownedIds = new uint256[](ownerBalance);
1903         uint256 tokenIdCounter = 0;
1904         uint256 index = 0;
1905 
1906         while (index < ownerBalance && tokenIdCounter <= 1111) {
1907             address tokenOwner = ownerOf(tokenIdCounter);
1908             if (tokenOwner == _owner) {
1909                 ownedIds[index] = tokenIdCounter;
1910                 index++;
1911             }
1912             tokenIdCounter++;
1913         }
1914         return ownedIds;
1915     }
1916 
1917 
1918     function publicSaleMint(uint256 quantity)
1919         external
1920         payable
1921         callerIsUser
1922     {
1923       
1924         require(
1925             isPublicSaleOn,
1926             "public sale has not begun yet"
1927         );
1928         require(
1929             totalSupply() + quantity <= MAX_SUPPLY,
1930             "reached max supply"
1931         );
1932        
1933         _safeMint(msg.sender, quantity);
1934   
1935     }
1936 
1937 
1938     function setPublicSale(bool flag) external onlyOwner {
1939         isPublicSaleOn = flag;
1940     }
1941 
1942     function setWhitelistFlag(bool flag) external onlyOwner {
1943         whitelistOn = flag;
1944     }
1945 
1946     function setWhiteListRoot(bytes32 merkle_root) external onlyOwner {
1947         whiteListRoot = merkle_root;
1948     }
1949 
1950     string private _baseTokenURI;
1951 
1952     function _baseURI() internal view virtual override returns (string memory) {
1953         return _baseTokenURI;
1954     }
1955 
1956     function setBaseURI(string calldata baseURI) external onlyOwner {
1957         _baseTokenURI = baseURI;
1958     }
1959 
1960     function withdraw() external onlyOwner nonReentrant {
1961          (bool success, ) = msg.sender.call{value: address(this).balance}("");
1962          require(success, "Transfer failed.");
1963     }
1964 
1965     function numberMinted(address owner) public view returns (uint256) {
1966         return _numberMinted(owner);
1967     }
1968 
1969 }