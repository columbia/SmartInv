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
294 // File: erc721a/contracts/IERC721A.sol
295 
296 
297 // ERC721A Contracts v4.2.3
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
468     ) external payable;
469 
470     /**
471      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
472      */
473     function safeTransferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external payable;
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
499     ) external payable;
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
515     function approve(address to, uint256 tokenId) external payable;
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
578 
579 // File: erc721a/contracts/ERC721A.sol
580 
581 
582 // ERC721A Contracts v4.2.3
583 // Creator: Chiru Labs
584 
585 pragma solidity ^0.8.4;
586 
587 
588 /**
589  * @dev Interface of ERC721 token receiver.
590  */
591 interface ERC721A__IERC721Receiver {
592     function onERC721Received(
593         address operator,
594         address from,
595         uint256 tokenId,
596         bytes calldata data
597     ) external returns (bytes4);
598 }
599 
600 /**
601  * @title ERC721A
602  *
603  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
604  * Non-Fungible Token Standard, including the Metadata extension.
605  * Optimized for lower gas during batch mints.
606  *
607  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
608  * starting from `_startTokenId()`.
609  *
610  * Assumptions:
611  *
612  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
613  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
614  */
615 contract ERC721A is IERC721A {
616     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
617     struct TokenApprovalRef {
618         address value;
619     }
620 
621     // =============================================================
622     //                           CONSTANTS
623     // =============================================================
624 
625     // Mask of an entry in packed address data.
626     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
627 
628     // The bit position of `numberMinted` in packed address data.
629     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
630 
631     // The bit position of `numberBurned` in packed address data.
632     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
633 
634     // The bit position of `aux` in packed address data.
635     uint256 private constant _BITPOS_AUX = 192;
636 
637     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
638     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
639 
640     // The bit position of `startTimestamp` in packed ownership.
641     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
642 
643     // The bit mask of the `burned` bit in packed ownership.
644     uint256 private constant _BITMASK_BURNED = 1 << 224;
645 
646     // The bit position of the `nextInitialized` bit in packed ownership.
647     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
648 
649     // The bit mask of the `nextInitialized` bit in packed ownership.
650     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
651 
652     // The bit position of `extraData` in packed ownership.
653     uint256 private constant _BITPOS_EXTRA_DATA = 232;
654 
655     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
656     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
657 
658     // The mask of the lower 160 bits for addresses.
659     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
660 
661     // The maximum `quantity` that can be minted with {_mintERC2309}.
662     // This limit is to prevent overflows on the address data entries.
663     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
664     // is required to cause an overflow, which is unrealistic.
665     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
666 
667     // The `Transfer` event signature is given by:
668     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
669     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
670         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
671 
672     // =============================================================
673     //                            STORAGE
674     // =============================================================
675 
676     // The next token ID to be minted.
677     uint256 private _currentIndex;
678 
679     // The number of tokens burned.
680     uint256 private _burnCounter;
681 
682     // Token name
683     string private _name;
684 
685     // Token symbol
686     string private _symbol;
687 
688     // Mapping from token ID to ownership details
689     // An empty struct value does not necessarily mean the token is unowned.
690     // See {_packedOwnershipOf} implementation for details.
691     //
692     // Bits Layout:
693     // - [0..159]   `addr`
694     // - [160..223] `startTimestamp`
695     // - [224]      `burned`
696     // - [225]      `nextInitialized`
697     // - [232..255] `extraData`
698     mapping(uint256 => uint256) private _packedOwnerships;
699 
700     // Mapping owner address to address data.
701     //
702     // Bits Layout:
703     // - [0..63]    `balance`
704     // - [64..127]  `numberMinted`
705     // - [128..191] `numberBurned`
706     // - [192..255] `aux`
707     mapping(address => uint256) private _packedAddressData;
708 
709     // Mapping from token ID to approved address.
710     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
711 
712     // Mapping from owner to operator approvals
713     mapping(address => mapping(address => bool)) private _operatorApprovals;
714 
715     // =============================================================
716     //                          CONSTRUCTOR
717     // =============================================================
718 
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722         _currentIndex = _startTokenId();
723     }
724 
725     // =============================================================
726     //                   TOKEN COUNTING OPERATIONS
727     // =============================================================
728 
729     /**
730      * @dev Returns the starting token ID.
731      * To change the starting token ID, please override this function.
732      */
733     function _startTokenId() internal view virtual returns (uint256) {
734         return 0;
735     }
736 
737     /**
738      * @dev Returns the next token ID to be minted.
739      */
740     function _nextTokenId() internal view virtual returns (uint256) {
741         return _currentIndex;
742     }
743 
744     /**
745      * @dev Returns the total number of tokens in existence.
746      * Burned tokens will reduce the count.
747      * To get the total number of tokens minted, please see {_totalMinted}.
748      */
749     function totalSupply() public view virtual override returns (uint256) {
750         // Counter underflow is impossible as _burnCounter cannot be incremented
751         // more than `_currentIndex - _startTokenId()` times.
752         unchecked {
753             return _currentIndex - _burnCounter - _startTokenId();
754         }
755     }
756 
757     /**
758      * @dev Returns the total amount of tokens minted in the contract.
759      */
760     function _totalMinted() internal view virtual returns (uint256) {
761         // Counter underflow is impossible as `_currentIndex` does not decrement,
762         // and it is initialized to `_startTokenId()`.
763         unchecked {
764             return _currentIndex - _startTokenId();
765         }
766     }
767 
768     /**
769      * @dev Returns the total number of tokens burned.
770      */
771     function _totalBurned() internal view virtual returns (uint256) {
772         return _burnCounter;
773     }
774 
775     // =============================================================
776     //                    ADDRESS DATA OPERATIONS
777     // =============================================================
778 
779     /**
780      * @dev Returns the number of tokens in `owner`'s account.
781      */
782     function balanceOf(address owner) public view virtual override returns (uint256) {
783         if (owner == address(0)) revert BalanceQueryForZeroAddress();
784         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
785     }
786 
787     /**
788      * Returns the number of tokens minted by `owner`.
789      */
790     function _numberMinted(address owner) internal view returns (uint256) {
791         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
792     }
793 
794     /**
795      * Returns the number of tokens burned by or on behalf of `owner`.
796      */
797     function _numberBurned(address owner) internal view returns (uint256) {
798         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
799     }
800 
801     /**
802      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
803      */
804     function _getAux(address owner) internal view returns (uint64) {
805         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
806     }
807 
808     /**
809      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
810      * If there are multiple variables, please pack them into a uint64.
811      */
812     function _setAux(address owner, uint64 aux) internal virtual {
813         uint256 packed = _packedAddressData[owner];
814         uint256 auxCasted;
815         // Cast `aux` with assembly to avoid redundant masking.
816         assembly {
817             auxCasted := aux
818         }
819         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
820         _packedAddressData[owner] = packed;
821     }
822 
823     // =============================================================
824     //                            IERC165
825     // =============================================================
826 
827     /**
828      * @dev Returns true if this contract implements the interface defined by
829      * `interfaceId`. See the corresponding
830      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
831      * to learn more about how these ids are created.
832      *
833      * This function call must use less than 30000 gas.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
836         // The interface IDs are constants representing the first 4 bytes
837         // of the XOR of all function selectors in the interface.
838         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
839         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
840         return
841             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
842             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
843             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
844     }
845 
846     // =============================================================
847     //                        IERC721Metadata
848     // =============================================================
849 
850     /**
851      * @dev Returns the token collection name.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev Returns the token collection symbol.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, it can be overridden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return '';
881     }
882 
883     // =============================================================
884     //                     OWNERSHIPS OPERATIONS
885     // =============================================================
886 
887     /**
888      * @dev Returns the owner of the `tokenId` token.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
895         return address(uint160(_packedOwnershipOf(tokenId)));
896     }
897 
898     /**
899      * @dev Gas spent here starts off proportional to the maximum mint batch size.
900      * It gradually moves to O(1) as tokens get transferred around over time.
901      */
902     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
903         return _unpackedOwnership(_packedOwnershipOf(tokenId));
904     }
905 
906     /**
907      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
908      */
909     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
910         return _unpackedOwnership(_packedOwnerships[index]);
911     }
912 
913     /**
914      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
915      */
916     function _initializeOwnershipAt(uint256 index) internal virtual {
917         if (_packedOwnerships[index] == 0) {
918             _packedOwnerships[index] = _packedOwnershipOf(index);
919         }
920     }
921 
922     /**
923      * Returns the packed ownership data of `tokenId`.
924      */
925     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
926         uint256 curr = tokenId;
927 
928         unchecked {
929             if (_startTokenId() <= curr)
930                 if (curr < _currentIndex) {
931                     uint256 packed = _packedOwnerships[curr];
932                     // If not burned.
933                     if (packed & _BITMASK_BURNED == 0) {
934                         // Invariant:
935                         // There will always be an initialized ownership slot
936                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
937                         // before an unintialized ownership slot
938                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
939                         // Hence, `curr` will not underflow.
940                         //
941                         // We can directly compare the packed value.
942                         // If the address is zero, packed will be zero.
943                         while (packed == 0) {
944                             packed = _packedOwnerships[--curr];
945                         }
946                         return packed;
947                     }
948                 }
949         }
950         revert OwnerQueryForNonexistentToken();
951     }
952 
953     /**
954      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
955      */
956     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
957         ownership.addr = address(uint160(packed));
958         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
959         ownership.burned = packed & _BITMASK_BURNED != 0;
960         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
961     }
962 
963     /**
964      * @dev Packs ownership data into a single uint256.
965      */
966     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
967         assembly {
968             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
969             owner := and(owner, _BITMASK_ADDRESS)
970             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
971             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
972         }
973     }
974 
975     /**
976      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
977      */
978     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
979         // For branchless setting of the `nextInitialized` flag.
980         assembly {
981             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
982             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
983         }
984     }
985 
986     // =============================================================
987     //                      APPROVAL OPERATIONS
988     // =============================================================
989 
990     /**
991      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
992      * The approval is cleared when the token is transferred.
993      *
994      * Only a single account can be approved at a time, so approving the
995      * zero address clears previous approvals.
996      *
997      * Requirements:
998      *
999      * - The caller must own the token or be an approved operator.
1000      * - `tokenId` must exist.
1001      *
1002      * Emits an {Approval} event.
1003      */
1004     function approve(address to, uint256 tokenId) public payable virtual override {
1005         address owner = ownerOf(tokenId);
1006 
1007         if (_msgSenderERC721A() != owner)
1008             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1009                 revert ApprovalCallerNotOwnerNorApproved();
1010             }
1011 
1012         _tokenApprovals[tokenId].value = to;
1013         emit Approval(owner, to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev Returns the account approved for `tokenId` token.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      */
1023     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1024         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1025 
1026         return _tokenApprovals[tokenId].value;
1027     }
1028 
1029     /**
1030      * @dev Approve or remove `operator` as an operator for the caller.
1031      * Operators can call {transferFrom} or {safeTransferFrom}
1032      * for any token owned by the caller.
1033      *
1034      * Requirements:
1035      *
1036      * - The `operator` cannot be the caller.
1037      *
1038      * Emits an {ApprovalForAll} event.
1039      */
1040     function setApprovalForAll(address operator, bool approved) public virtual override {
1041         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1042         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1043     }
1044 
1045     /**
1046      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1047      *
1048      * See {setApprovalForAll}.
1049      */
1050     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1051         return _operatorApprovals[owner][operator];
1052     }
1053 
1054     /**
1055      * @dev Returns whether `tokenId` exists.
1056      *
1057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1058      *
1059      * Tokens start existing when they are minted. See {_mint}.
1060      */
1061     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1062         return
1063             _startTokenId() <= tokenId &&
1064             tokenId < _currentIndex && // If within bounds,
1065             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1066     }
1067 
1068     /**
1069      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1070      */
1071     function _isSenderApprovedOrOwner(
1072         address approvedAddress,
1073         address owner,
1074         address msgSender
1075     ) private pure returns (bool result) {
1076         assembly {
1077             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1078             owner := and(owner, _BITMASK_ADDRESS)
1079             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1080             msgSender := and(msgSender, _BITMASK_ADDRESS)
1081             // `msgSender == owner || msgSender == approvedAddress`.
1082             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1088      */
1089     function _getApprovedSlotAndAddress(uint256 tokenId)
1090         private
1091         view
1092         returns (uint256 approvedAddressSlot, address approvedAddress)
1093     {
1094         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1095         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1096         assembly {
1097             approvedAddressSlot := tokenApproval.slot
1098             approvedAddress := sload(approvedAddressSlot)
1099         }
1100     }
1101 
1102     // =============================================================
1103     //                      TRANSFER OPERATIONS
1104     // =============================================================
1105 
1106     /**
1107      * @dev Transfers `tokenId` from `from` to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - `from` cannot be the zero address.
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must be owned by `from`.
1114      * - If the caller is not `from`, it must be approved to move this token
1115      * by either {approve} or {setApprovalForAll}.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function transferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) public payable virtual override {
1124         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1125 
1126         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1127 
1128         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1129 
1130         // The nested ifs save around 20+ gas over a compound boolean condition.
1131         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1132             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1133 
1134         if (to == address(0)) revert TransferToZeroAddress();
1135 
1136         _beforeTokenTransfers(from, to, tokenId, 1);
1137 
1138         // Clear approvals from the previous owner.
1139         assembly {
1140             if approvedAddress {
1141                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1142                 sstore(approvedAddressSlot, 0)
1143             }
1144         }
1145 
1146         // Underflow of the sender's balance is impossible because we check for
1147         // ownership above and the recipient's balance can't realistically overflow.
1148         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1149         unchecked {
1150             // We can directly increment and decrement the balances.
1151             --_packedAddressData[from]; // Updates: `balance -= 1`.
1152             ++_packedAddressData[to]; // Updates: `balance += 1`.
1153 
1154             // Updates:
1155             // - `address` to the next owner.
1156             // - `startTimestamp` to the timestamp of transfering.
1157             // - `burned` to `false`.
1158             // - `nextInitialized` to `true`.
1159             _packedOwnerships[tokenId] = _packOwnershipData(
1160                 to,
1161                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1162             );
1163 
1164             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1165             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1166                 uint256 nextTokenId = tokenId + 1;
1167                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1168                 if (_packedOwnerships[nextTokenId] == 0) {
1169                     // If the next slot is within bounds.
1170                     if (nextTokenId != _currentIndex) {
1171                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1172                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1173                     }
1174                 }
1175             }
1176         }
1177 
1178         emit Transfer(from, to, tokenId);
1179         _afterTokenTransfers(from, to, tokenId, 1);
1180     }
1181 
1182     /**
1183      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1184      */
1185     function safeTransferFrom(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) public payable virtual override {
1190         safeTransferFrom(from, to, tokenId, '');
1191     }
1192 
1193     /**
1194      * @dev Safely transfers `tokenId` token from `from` to `to`.
1195      *
1196      * Requirements:
1197      *
1198      * - `from` cannot be the zero address.
1199      * - `to` cannot be the zero address.
1200      * - `tokenId` token must exist and be owned by `from`.
1201      * - If the caller is not `from`, it must be approved to move this token
1202      * by either {approve} or {setApprovalForAll}.
1203      * - If `to` refers to a smart contract, it must implement
1204      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function safeTransferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId,
1212         bytes memory _data
1213     ) public payable virtual override {
1214         transferFrom(from, to, tokenId);
1215         if (to.code.length != 0)
1216             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1217                 revert TransferToNonERC721ReceiverImplementer();
1218             }
1219     }
1220 
1221     /**
1222      * @dev Hook that is called before a set of serially-ordered token IDs
1223      * are about to be transferred. This includes minting.
1224      * And also called before burning one token.
1225      *
1226      * `startTokenId` - the first token ID to be transferred.
1227      * `quantity` - the amount to be transferred.
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` will be minted for `to`.
1234      * - When `to` is zero, `tokenId` will be burned by `from`.
1235      * - `from` and `to` are never both zero.
1236      */
1237     function _beforeTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Hook that is called after a set of serially-ordered token IDs
1246      * have been transferred. This includes minting.
1247      * And also called after one token has been burned.
1248      *
1249      * `startTokenId` - the first token ID to be transferred.
1250      * `quantity` - the amount to be transferred.
1251      *
1252      * Calling conditions:
1253      *
1254      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1255      * transferred to `to`.
1256      * - When `from` is zero, `tokenId` has been minted for `to`.
1257      * - When `to` is zero, `tokenId` has been burned by `from`.
1258      * - `from` and `to` are never both zero.
1259      */
1260     function _afterTokenTransfers(
1261         address from,
1262         address to,
1263         uint256 startTokenId,
1264         uint256 quantity
1265     ) internal virtual {}
1266 
1267     /**
1268      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1269      *
1270      * `from` - Previous owner of the given token ID.
1271      * `to` - Target address that will receive the token.
1272      * `tokenId` - Token ID to be transferred.
1273      * `_data` - Optional data to send along with the call.
1274      *
1275      * Returns whether the call correctly returned the expected magic value.
1276      */
1277     function _checkContractOnERC721Received(
1278         address from,
1279         address to,
1280         uint256 tokenId,
1281         bytes memory _data
1282     ) private returns (bool) {
1283         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1284             bytes4 retval
1285         ) {
1286             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1287         } catch (bytes memory reason) {
1288             if (reason.length == 0) {
1289                 revert TransferToNonERC721ReceiverImplementer();
1290             } else {
1291                 assembly {
1292                     revert(add(32, reason), mload(reason))
1293                 }
1294             }
1295         }
1296     }
1297 
1298     // =============================================================
1299     //                        MINT OPERATIONS
1300     // =============================================================
1301 
1302     /**
1303      * @dev Mints `quantity` tokens and transfers them to `to`.
1304      *
1305      * Requirements:
1306      *
1307      * - `to` cannot be the zero address.
1308      * - `quantity` must be greater than 0.
1309      *
1310      * Emits a {Transfer} event for each mint.
1311      */
1312     function _mint(address to, uint256 quantity) internal virtual {
1313         uint256 startTokenId = _currentIndex;
1314         if (quantity == 0) revert MintZeroQuantity();
1315 
1316         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1317 
1318         // Overflows are incredibly unrealistic.
1319         // `balance` and `numberMinted` have a maximum limit of 2**64.
1320         // `tokenId` has a maximum limit of 2**256.
1321         unchecked {
1322             // Updates:
1323             // - `balance += quantity`.
1324             // - `numberMinted += quantity`.
1325             //
1326             // We can directly add to the `balance` and `numberMinted`.
1327             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1328 
1329             // Updates:
1330             // - `address` to the owner.
1331             // - `startTimestamp` to the timestamp of minting.
1332             // - `burned` to `false`.
1333             // - `nextInitialized` to `quantity == 1`.
1334             _packedOwnerships[startTokenId] = _packOwnershipData(
1335                 to,
1336                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1337             );
1338 
1339             uint256 toMasked;
1340             uint256 end = startTokenId + quantity;
1341 
1342             // Use assembly to loop and emit the `Transfer` event for gas savings.
1343             // The duplicated `log4` removes an extra check and reduces stack juggling.
1344             // The assembly, together with the surrounding Solidity code, have been
1345             // delicately arranged to nudge the compiler into producing optimized opcodes.
1346             assembly {
1347                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1348                 toMasked := and(to, _BITMASK_ADDRESS)
1349                 // Emit the `Transfer` event.
1350                 log4(
1351                     0, // Start of data (0, since no data).
1352                     0, // End of data (0, since no data).
1353                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1354                     0, // `address(0)`.
1355                     toMasked, // `to`.
1356                     startTokenId // `tokenId`.
1357                 )
1358 
1359                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1360                 // that overflows uint256 will make the loop run out of gas.
1361                 // The compiler will optimize the `iszero` away for performance.
1362                 for {
1363                     let tokenId := add(startTokenId, 1)
1364                 } iszero(eq(tokenId, end)) {
1365                     tokenId := add(tokenId, 1)
1366                 } {
1367                     // Emit the `Transfer` event. Similar to above.
1368                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1369                 }
1370             }
1371             if (toMasked == 0) revert MintToZeroAddress();
1372 
1373             _currentIndex = end;
1374         }
1375         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1376     }
1377 
1378     /**
1379      * @dev Mints `quantity` tokens and transfers them to `to`.
1380      *
1381      * This function is intended for efficient minting only during contract creation.
1382      *
1383      * It emits only one {ConsecutiveTransfer} as defined in
1384      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1385      * instead of a sequence of {Transfer} event(s).
1386      *
1387      * Calling this function outside of contract creation WILL make your contract
1388      * non-compliant with the ERC721 standard.
1389      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1390      * {ConsecutiveTransfer} event is only permissible during contract creation.
1391      *
1392      * Requirements:
1393      *
1394      * - `to` cannot be the zero address.
1395      * - `quantity` must be greater than 0.
1396      *
1397      * Emits a {ConsecutiveTransfer} event.
1398      */
1399     function _mintERC2309(address to, uint256 quantity) internal virtual {
1400         uint256 startTokenId = _currentIndex;
1401         if (to == address(0)) revert MintToZeroAddress();
1402         if (quantity == 0) revert MintZeroQuantity();
1403         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1404 
1405         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1406 
1407         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1408         unchecked {
1409             // Updates:
1410             // - `balance += quantity`.
1411             // - `numberMinted += quantity`.
1412             //
1413             // We can directly add to the `balance` and `numberMinted`.
1414             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1415 
1416             // Updates:
1417             // - `address` to the owner.
1418             // - `startTimestamp` to the timestamp of minting.
1419             // - `burned` to `false`.
1420             // - `nextInitialized` to `quantity == 1`.
1421             _packedOwnerships[startTokenId] = _packOwnershipData(
1422                 to,
1423                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1424             );
1425 
1426             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1427 
1428             _currentIndex = startTokenId + quantity;
1429         }
1430         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1431     }
1432 
1433     /**
1434      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1435      *
1436      * Requirements:
1437      *
1438      * - If `to` refers to a smart contract, it must implement
1439      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1440      * - `quantity` must be greater than 0.
1441      *
1442      * See {_mint}.
1443      *
1444      * Emits a {Transfer} event for each mint.
1445      */
1446     function _safeMint(
1447         address to,
1448         uint256 quantity,
1449         bytes memory _data
1450     ) internal virtual {
1451         _mint(to, quantity);
1452 
1453         unchecked {
1454             if (to.code.length != 0) {
1455                 uint256 end = _currentIndex;
1456                 uint256 index = end - quantity;
1457                 do {
1458                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1459                         revert TransferToNonERC721ReceiverImplementer();
1460                     }
1461                 } while (index < end);
1462                 // Reentrancy protection.
1463                 if (_currentIndex != end) revert();
1464             }
1465         }
1466     }
1467 
1468     /**
1469      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1470      */
1471     function _safeMint(address to, uint256 quantity) internal virtual {
1472         _safeMint(to, quantity, '');
1473     }
1474 
1475     // =============================================================
1476     //                        BURN OPERATIONS
1477     // =============================================================
1478 
1479     /**
1480      * @dev Equivalent to `_burn(tokenId, false)`.
1481      */
1482     function _burn(uint256 tokenId) internal virtual {
1483         _burn(tokenId, false);
1484     }
1485 
1486     /**
1487      * @dev Destroys `tokenId`.
1488      * The approval is cleared when the token is burned.
1489      *
1490      * Requirements:
1491      *
1492      * - `tokenId` must exist.
1493      *
1494      * Emits a {Transfer} event.
1495      */
1496     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1497         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1498 
1499         address from = address(uint160(prevOwnershipPacked));
1500 
1501         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1502 
1503         if (approvalCheck) {
1504             // The nested ifs save around 20+ gas over a compound boolean condition.
1505             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1506                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1507         }
1508 
1509         _beforeTokenTransfers(from, address(0), tokenId, 1);
1510 
1511         // Clear approvals from the previous owner.
1512         assembly {
1513             if approvedAddress {
1514                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1515                 sstore(approvedAddressSlot, 0)
1516             }
1517         }
1518 
1519         // Underflow of the sender's balance is impossible because we check for
1520         // ownership above and the recipient's balance can't realistically overflow.
1521         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1522         unchecked {
1523             // Updates:
1524             // - `balance -= 1`.
1525             // - `numberBurned += 1`.
1526             //
1527             // We can directly decrement the balance, and increment the number burned.
1528             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1529             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1530 
1531             // Updates:
1532             // - `address` to the last owner.
1533             // - `startTimestamp` to the timestamp of burning.
1534             // - `burned` to `true`.
1535             // - `nextInitialized` to `true`.
1536             _packedOwnerships[tokenId] = _packOwnershipData(
1537                 from,
1538                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1539             );
1540 
1541             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1542             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1543                 uint256 nextTokenId = tokenId + 1;
1544                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1545                 if (_packedOwnerships[nextTokenId] == 0) {
1546                     // If the next slot is within bounds.
1547                     if (nextTokenId != _currentIndex) {
1548                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1549                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1550                     }
1551                 }
1552             }
1553         }
1554 
1555         emit Transfer(from, address(0), tokenId);
1556         _afterTokenTransfers(from, address(0), tokenId, 1);
1557 
1558         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1559         unchecked {
1560             _burnCounter++;
1561         }
1562     }
1563 
1564     // =============================================================
1565     //                     EXTRA DATA OPERATIONS
1566     // =============================================================
1567 
1568     /**
1569      * @dev Directly sets the extra data for the ownership data `index`.
1570      */
1571     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1572         uint256 packed = _packedOwnerships[index];
1573         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1574         uint256 extraDataCasted;
1575         // Cast `extraData` with assembly to avoid redundant masking.
1576         assembly {
1577             extraDataCasted := extraData
1578         }
1579         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1580         _packedOwnerships[index] = packed;
1581     }
1582 
1583     /**
1584      * @dev Called during each token transfer to set the 24bit `extraData` field.
1585      * Intended to be overridden by the cosumer contract.
1586      *
1587      * `previousExtraData` - the value of `extraData` before transfer.
1588      *
1589      * Calling conditions:
1590      *
1591      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1592      * transferred to `to`.
1593      * - When `from` is zero, `tokenId` will be minted for `to`.
1594      * - When `to` is zero, `tokenId` will be burned by `from`.
1595      * - `from` and `to` are never both zero.
1596      */
1597     function _extraData(
1598         address from,
1599         address to,
1600         uint24 previousExtraData
1601     ) internal view virtual returns (uint24) {}
1602 
1603     /**
1604      * @dev Returns the next extra data for the packed ownership data.
1605      * The returned result is shifted into position.
1606      */
1607     function _nextExtraData(
1608         address from,
1609         address to,
1610         uint256 prevOwnershipPacked
1611     ) private view returns (uint256) {
1612         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1613         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1614     }
1615 
1616     // =============================================================
1617     //                       OTHER OPERATIONS
1618     // =============================================================
1619 
1620     /**
1621      * @dev Returns the message sender (defaults to `msg.sender`).
1622      *
1623      * If you are writing GSN compatible contracts, you need to override this function.
1624      */
1625     function _msgSenderERC721A() internal view virtual returns (address) {
1626         return msg.sender;
1627     }
1628 
1629     /**
1630      * @dev Converts a uint256 to its ASCII string decimal representation.
1631      */
1632     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1633         assembly {
1634             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1635             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1636             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1637             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1638             let m := add(mload(0x40), 0xa0)
1639             // Update the free memory pointer to allocate.
1640             mstore(0x40, m)
1641             // Assign the `str` to the end.
1642             str := sub(m, 0x20)
1643             // Zeroize the slot after the string.
1644             mstore(str, 0)
1645 
1646             // Cache the end of the memory to calculate the length later.
1647             let end := str
1648 
1649             // We write the string from rightmost digit to leftmost digit.
1650             // The following is essentially a do-while loop that also handles the zero case.
1651             // prettier-ignore
1652             for { let temp := value } 1 {} {
1653                 str := sub(str, 1)
1654                 // Write the character to the pointer.
1655                 // The ASCII index of the '0' character is 48.
1656                 mstore8(str, add(48, mod(temp, 10)))
1657                 // Keep dividing `temp` until zero.
1658                 temp := div(temp, 10)
1659                 // prettier-ignore
1660                 if iszero(temp) { break }
1661             }
1662 
1663             let length := sub(end, str)
1664             // Move the pointer 32 bytes leftwards to make room for the length.
1665             str := sub(str, 0x20)
1666             // Store the length.
1667             mstore(str, length)
1668         }
1669     }
1670 }
1671 
1672 // File: Fragments.sol
1673 
1674 
1675 
1676 pragma solidity ^0.8.7;
1677 
1678 
1679 
1680 
1681 contract Fragments is ERC721A {
1682 
1683     mapping (address => uint8) public ownerTokenMapping;
1684     bytes32 public root;
1685 
1686     string public baseURI = "https://mint.fragments.money/api/metadata/";
1687     address private owner;
1688     uint public MINT_PRICE = 0.042 ether;
1689     uint public WHITELISTED_MINT_PRICE = 0.042 ether;
1690     bool public PUBLIC_MINT = false;
1691     uint16 public MAX_SUPPLY = 729;
1692     uint16 public MAX_WHITELISTED_SUPPLY = 500;
1693     uint8 public MAX_PER_WALLET = 4;
1694 
1695     constructor(bytes32 _root) ERC721A("Fragments Early Believers' NFT", "FRAG") {
1696         owner = msg.sender;
1697         root = _root;
1698     }
1699 
1700 
1701     function _baseURI() internal view override returns (string memory) {
1702         return baseURI;
1703     }
1704     
1705     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1706         baseURI = _newBaseURI;
1707     }
1708 
1709     function setMintPrice(uint price) external onlyOwner {
1710         MINT_PRICE = price;
1711     }
1712 
1713     function setMaxTokensPerWallet(uint8 tokens) external onlyOwner {
1714         MAX_PER_WALLET = tokens;
1715     }
1716 
1717     function setPublicMint() external onlyOwner {
1718         PUBLIC_MINT = !PUBLIC_MINT;
1719     }
1720 
1721     function withdraw() external onlyOwner {
1722         payable(owner).transfer(address(this).balance);
1723     }
1724 
1725     modifier onlyOwner {
1726         require(owner == msg.sender, "Not the owner!");
1727         _;
1728     }
1729 
1730     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1731         string memory json = string(
1732                     abi.encodePacked(
1733                         baseURI,
1734                         '/',
1735                         Strings.toString(_tokenId),
1736                         '.json'
1737                     )
1738                 );
1739         return json;
1740     }
1741 
1742     function transferOwnership(address newOwner) external onlyOwner {
1743         owner = newOwner;
1744     }
1745 
1746     function mint(uint8 amount, bytes32[] memory proof) external payable {
1747         require(PUBLIC_MINT, "Sale not active!");
1748         require (totalSupply() + amount <= MAX_SUPPLY + 1, "Not enough tokens to sell");
1749         require(amount <= MAX_PER_WALLET, "Max tokens exceeded");
1750         require(ownerTokenMapping[msg.sender] + amount <= MAX_PER_WALLET, "Max tokens exceeded");
1751         bool isWhitelisted = isValid(proof, keccak256(abi.encodePacked(msg.sender)));
1752 
1753         if(isWhitelisted){
1754             require(msg.value == WHITELISTED_MINT_PRICE * amount, "Insufficient eth for mint");
1755         }else {
1756             require(msg.value == MINT_PRICE * amount, "Insufficient eth for mint");
1757         }
1758       
1759         _safeMint(msg.sender, amount);
1760         ownerTokenMapping[msg.sender] += amount;
1761     }
1762 
1763     function isValid(bytes32[] memory proof, bytes32 leaf) private view returns(bool){
1764         return MerkleProof.verify(proof, root, leaf);
1765     }
1766 
1767    function burn(uint256 tokenId) public virtual onlyOwner {
1768         _burn(tokenId);
1769     }
1770 }