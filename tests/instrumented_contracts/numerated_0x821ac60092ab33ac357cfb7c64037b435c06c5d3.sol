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
297 // ERC721A Contracts v4.1.0
298 // Creator: Chiru Labs
299 
300 pragma solidity ^0.8.4;
301 
302 /**
303  * @dev Interface of an ERC721A compliant contract.
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
352      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
353      */
354     error TransferToNonERC721ReceiverImplementer();
355 
356     /**
357      * Cannot transfer to the zero address.
358      */
359     error TransferToZeroAddress();
360 
361     /**
362      * The token does not exist.
363      */
364     error URIQueryForNonexistentToken();
365 
366     /**
367      * The `quantity` minted with ERC2309 exceeds the safety limit.
368      */
369     error MintERC2309QuantityExceedsLimit();
370 
371     /**
372      * The `extraData` cannot be set on an unintialized ownership slot.
373      */
374     error OwnershipNotInitializedForExtraData();
375 
376     struct TokenOwnership {
377         // The address of the owner.
378         address addr;
379         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
380         uint64 startTimestamp;
381         // Whether the token has been burned.
382         bool burned;
383         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
384         uint24 extraData;
385     }
386 
387     /**
388      * @dev Returns the total amount of tokens stored by the contract.
389      *
390      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
391      */
392     function totalSupply() external view returns (uint256);
393 
394     // ==============================
395     //            IERC165
396     // ==============================
397 
398     /**
399      * @dev Returns true if this contract implements the interface defined by
400      * `interfaceId`. See the corresponding
401      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
402      * to learn more about how these ids are created.
403      *
404      * This function call must use less than 30 000 gas.
405      */
406     function supportsInterface(bytes4 interfaceId) external view returns (bool);
407 
408     // ==============================
409     //            IERC721
410     // ==============================
411 
412     /**
413      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
414      */
415     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
416 
417     /**
418      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
419      */
420     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
421 
422     /**
423      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
424      */
425     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
426 
427     /**
428      * @dev Returns the number of tokens in ``owner``'s account.
429      */
430     function balanceOf(address owner) external view returns (uint256 balance);
431 
432     /**
433      * @dev Returns the owner of the `tokenId` token.
434      *
435      * Requirements:
436      *
437      * - `tokenId` must exist.
438      */
439     function ownerOf(uint256 tokenId) external view returns (address owner);
440 
441     /**
442      * @dev Safely transfers `tokenId` token from `from` to `to`.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must exist and be owned by `from`.
449      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
450      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function safeTransferFrom(
455         address from,
456         address to,
457         uint256 tokenId,
458         bytes calldata data
459     ) external;
460 
461     /**
462      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
463      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
464      *
465      * Requirements:
466      *
467      * - `from` cannot be the zero address.
468      * - `to` cannot be the zero address.
469      * - `tokenId` token must exist and be owned by `from`.
470      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
471      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
472      *
473      * Emits a {Transfer} event.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) external;
480 
481     /**
482      * @dev Transfers `tokenId` token from `from` to `to`.
483      *
484      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must be owned by `from`.
491      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
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
505      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
506      *
507      * Requirements:
508      *
509      * - The caller must own the token or be an approved operator.
510      * - `tokenId` must exist.
511      *
512      * Emits an {Approval} event.
513      */
514     function approve(address to, uint256 tokenId) external;
515 
516     /**
517      * @dev Approve or remove `operator` as an operator for the caller.
518      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
519      *
520      * Requirements:
521      *
522      * - The `operator` cannot be the caller.
523      *
524      * Emits an {ApprovalForAll} event.
525      */
526     function setApprovalForAll(address operator, bool _approved) external;
527 
528     /**
529      * @dev Returns the account approved for `tokenId` token.
530      *
531      * Requirements:
532      *
533      * - `tokenId` must exist.
534      */
535     function getApproved(uint256 tokenId) external view returns (address operator);
536 
537     /**
538      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
539      *
540      * See {setApprovalForAll}
541      */
542     function isApprovedForAll(address owner, address operator) external view returns (bool);
543 
544     // ==============================
545     //        IERC721Metadata
546     // ==============================
547 
548     /**
549      * @dev Returns the token collection name.
550      */
551     function name() external view returns (string memory);
552 
553     /**
554      * @dev Returns the token collection symbol.
555      */
556     function symbol() external view returns (string memory);
557 
558     /**
559      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
560      */
561     function tokenURI(uint256 tokenId) external view returns (string memory);
562 
563     // ==============================
564     //            IERC2309
565     // ==============================
566 
567     /**
568      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
569      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
570      */
571     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
572 }
573 // File: contracts/ERC721A.sol
574 
575 
576 // ERC721A Contracts v4.1.0
577 // Creator: Chiru Labs
578 
579 pragma solidity ^0.8.4;
580 
581 
582 /**
583  * @dev ERC721 token receiver interface.
584  */
585 interface ERC721A__IERC721Receiver {
586     function onERC721Received(
587         address operator,
588         address from,
589         uint256 tokenId,
590         bytes calldata data
591     ) external returns (bytes4);
592 }
593 
594 /**
595  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
596  * including the Metadata extension. Built to optimize for lower gas during batch mints.
597  *
598  * Assumes serials are sequentially minted starting at `_startTokenId()`
599  * (defaults to 0, e.g. 0, 1, 2, 3..).
600  *
601  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
602  *
603  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
604  */
605 contract ERC721A is IERC721A {
606     // Reference type for token approval.
607     struct TokenApprovalRef {
608         address value;
609     }
610 
611     // Mask of an entry in packed address data.
612     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
613 
614     // The bit position of `numberMinted` in packed address data.
615     uint256 private constant BITPOS_NUMBER_MINTED = 64;
616 
617     // The bit position of `numberBurned` in packed address data.
618     uint256 private constant BITPOS_NUMBER_BURNED = 128;
619 
620     // The bit position of `aux` in packed address data.
621     uint256 private constant BITPOS_AUX = 192;
622 
623     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
624     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
625 
626     // The bit position of `startTimestamp` in packed ownership.
627     uint256 private constant BITPOS_START_TIMESTAMP = 160;
628 
629     // The bit mask of the `burned` bit in packed ownership.
630     uint256 private constant BITMASK_BURNED = 1 << 224;
631 
632     // The bit position of the `nextInitialized` bit in packed ownership.
633     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
634 
635     // The bit mask of the `nextInitialized` bit in packed ownership.
636     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
637 
638     // The bit position of `extraData` in packed ownership.
639     uint256 private constant BITPOS_EXTRA_DATA = 232;
640 
641     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
642     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
643 
644     // The mask of the lower 160 bits for addresses.
645     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
646 
647     // The maximum `quantity` that can be minted with `_mintERC2309`.
648     // This limit is to prevent overflows on the address data entries.
649     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
650     // is required to cause an overflow, which is unrealistic.
651     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
652 
653     // The tokenId of the next token to be minted.
654     uint256 private _currentIndex;
655 
656     // The number of tokens burned.
657     uint256 private _burnCounter;
658 
659     // Token name
660     string private _name;
661 
662     // Token symbol
663     string private _symbol;
664 
665     // Mapping from token ID to ownership details
666     // An empty struct value does not necessarily mean the token is unowned.
667     // See `_packedOwnershipOf` implementation for details.
668     //
669     // Bits Layout:
670     // - [0..159]   `addr`
671     // - [160..223] `startTimestamp`
672     // - [224]      `burned`
673     // - [225]      `nextInitialized`
674     // - [232..255] `extraData`
675     mapping(uint256 => uint256) private _packedOwnerships;
676 
677     // Mapping owner address to address data.
678     //
679     // Bits Layout:
680     // - [0..63]    `balance`
681     // - [64..127]  `numberMinted`
682     // - [128..191] `numberBurned`
683     // - [192..255] `aux`
684     mapping(address => uint256) private _packedAddressData;
685 
686     // Mapping from token ID to approved address.
687     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
688 
689     // Mapping from owner to operator approvals
690     mapping(address => mapping(address => bool)) private _operatorApprovals;
691 
692     constructor(string memory name_, string memory symbol_) {
693         _name = name_;
694         _symbol = symbol_;
695         _currentIndex = _startTokenId();
696     }
697 
698     /**
699      * @dev Returns the starting token ID.
700      * To change the starting token ID, please override this function.
701      */
702     function _startTokenId() internal view virtual returns (uint256) {
703         return 0;
704     }
705 
706     /**
707      * @dev Returns the next token ID to be minted.
708      */
709     function _nextTokenId() internal view virtual returns (uint256) {
710         return _currentIndex;
711     }
712 
713     /**
714      * @dev Returns the total number of tokens in existence.
715      * Burned tokens will reduce the count.
716      * To get the total number of tokens minted, please see `_totalMinted`.
717      */
718     function totalSupply() public view virtual override returns (uint256) {
719         // Counter underflow is impossible as _burnCounter cannot be incremented
720         // more than `_currentIndex - _startTokenId()` times.
721         unchecked {
722             return _currentIndex - _burnCounter - _startTokenId();
723         }
724     }
725 
726     /**
727      * @dev Returns the total amount of tokens minted in the contract.
728      */
729     function _totalMinted() internal view virtual returns (uint256) {
730         // Counter underflow is impossible as _currentIndex does not decrement,
731         // and it is initialized to `_startTokenId()`
732         unchecked {
733             return _currentIndex - _startTokenId();
734         }
735     }
736 
737     /**
738      * @dev Returns the total number of tokens burned.
739      */
740     function _totalBurned() internal view virtual returns (uint256) {
741         return _burnCounter;
742     }
743 
744     /**
745      * @dev See {IERC165-supportsInterface}.
746      */
747     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
748         // The interface IDs are constants representing the first 4 bytes of the XOR of
749         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
750         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
751         return
752             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
753             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
754             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
755     }
756 
757     /**
758      * @dev See {IERC721-balanceOf}.
759      */
760     function balanceOf(address owner) public view virtual override returns (uint256) {
761         if (owner == address(0)) revert BalanceQueryForZeroAddress();
762         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
763     }
764 
765     /**
766      * Returns the number of tokens minted by `owner`.
767      */
768     function _numberMinted(address owner) internal view virtual returns (uint256) {
769         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
770     }
771 
772     /**
773      * Returns the number of tokens burned by or on behalf of `owner`.
774      */
775     function _numberBurned(address owner) internal view virtual returns (uint256) {
776         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
777     }
778 
779     /**
780      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
781      */
782     function _getAux(address owner) internal view virtual returns (uint64) {
783         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
784     }
785 
786     /**
787      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
788      * If there are multiple variables, please pack them into a uint64.
789      */
790     function _setAux(address owner, uint64 aux) internal virtual {
791         uint256 packed = _packedAddressData[owner];
792         uint256 auxCasted;
793         // Cast `aux` with assembly to avoid redundant masking.
794         assembly {
795             auxCasted := aux
796         }
797         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
798         _packedAddressData[owner] = packed;
799     }
800 
801     /**
802      * Returns the packed ownership data of `tokenId`.
803      */
804     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
805         uint256 curr = tokenId;
806 
807         unchecked {
808             if (_startTokenId() <= curr)
809                 if (curr < _currentIndex) {
810                     uint256 packed = _packedOwnerships[curr];
811                     // If not burned.
812                     if (packed & BITMASK_BURNED == 0) {
813                         // Invariant:
814                         // There will always be an ownership that has an address and is not burned
815                         // before an ownership that does not have an address and is not burned.
816                         // Hence, curr will not underflow.
817                         //
818                         // We can directly compare the packed value.
819                         // If the address is zero, packed is zero.
820                         while (packed == 0) {
821                             packed = _packedOwnerships[--curr];
822                         }
823                         return packed;
824                     }
825                 }
826         }
827         revert OwnerQueryForNonexistentToken();
828     }
829 
830     /**
831      * Returns the unpacked `TokenOwnership` struct from `packed`.
832      */
833     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
834         ownership.addr = address(uint160(packed));
835         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
836         ownership.burned = packed & BITMASK_BURNED != 0;
837         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
838     }
839 
840     /**
841      * Returns the unpacked `TokenOwnership` struct at `index`.
842      */
843     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
844         return _unpackedOwnership(_packedOwnerships[index]);
845     }
846 
847     /**
848      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
849      */
850     function _initializeOwnershipAt(uint256 index) internal virtual {
851         if (_packedOwnerships[index] == 0) {
852             _packedOwnerships[index] = _packedOwnershipOf(index);
853         }
854     }
855 
856     /**
857      * Gas spent here starts off proportional to the maximum mint batch size.
858      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
859      */
860     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
861         return _unpackedOwnership(_packedOwnershipOf(tokenId));
862     }
863 
864     /**
865      * @dev Packs ownership data into a single uint256.
866      */
867     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
868         assembly {
869             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
870             owner := and(owner, BITMASK_ADDRESS)
871             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
872             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
873         }
874     }
875 
876     /**
877      * @dev See {IERC721-ownerOf}.
878      */
879     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
880         return address(uint160(_packedOwnershipOf(tokenId)));
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-name}.
885      */
886     function name() public view virtual override returns (string memory) {
887         return _name;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-symbol}.
892      */
893     function symbol() public view virtual override returns (string memory) {
894         return _symbol;
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-tokenURI}.
899      */
900     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
901         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
902 
903         string memory baseURI = _baseURI();
904         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
905     }
906 
907     /**
908      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
909      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
910      * by default, it can be overridden in child contracts.
911      */
912     function _baseURI() internal view virtual returns (string memory) {
913         return '';
914     }
915 
916     /**
917      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
918      */
919     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
920         // For branchless setting of the `nextInitialized` flag.
921         assembly {
922             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
923             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
924         }
925     }
926 
927     /**
928      * @dev See {IERC721-approve}.
929      */
930     function approve(address to, uint256 tokenId) public virtual override {
931         address owner = ownerOf(tokenId);
932 
933         if (_msgSenderERC721A() != owner)
934             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
935                 revert ApprovalCallerNotOwnerNorApproved();
936             }
937 
938         _tokenApprovals[tokenId].value = to;
939         emit Approval(owner, to, tokenId);
940     }
941 
942     /**
943      * @dev See {IERC721-getApproved}.
944      */
945     function getApproved(uint256 tokenId) public view virtual override returns (address) {
946         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
947 
948         return _tokenApprovals[tokenId].value;
949     }
950 
951     /**
952      * @dev See {IERC721-setApprovalForAll}.
953      */
954     function setApprovalForAll(address operator, bool approved) public virtual override {
955         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
956 
957         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
958         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
959     }
960 
961     /**
962      * @dev See {IERC721-isApprovedForAll}.
963      */
964     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
965         return _operatorApprovals[owner][operator];
966     }
967 
968     /**
969      * @dev See {IERC721-safeTransferFrom}.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId
975     ) public virtual override {
976         safeTransferFrom(from, to, tokenId, '');
977     }
978 
979     /**
980      * @dev See {IERC721-safeTransferFrom}.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) public virtual override {
988         transferFrom(from, to, tokenId);
989         if (to.code.length != 0)
990             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
991                 revert TransferToNonERC721ReceiverImplementer();
992             }
993     }
994 
995     /**
996      * @dev Returns whether `tokenId` exists.
997      *
998      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
999      *
1000      * Tokens start existing when they are minted (`_mint`),
1001      */
1002     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1003         return
1004             _startTokenId() <= tokenId &&
1005             tokenId < _currentIndex && // If within bounds,
1006             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1007     }
1008 
1009     /**
1010      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1011      */
1012     function _safeMint(address to, uint256 quantity) internal virtual {
1013         _safeMint(to, quantity, '');
1014     }
1015 
1016     /**
1017      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1018      *
1019      * Requirements:
1020      *
1021      * - If `to` refers to a smart contract, it must implement
1022      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1023      * - `quantity` must be greater than 0.
1024      *
1025      * See {_mint}.
1026      *
1027      * Emits a {Transfer} event for each mint.
1028      */
1029     function _safeMint(
1030         address to,
1031         uint256 quantity,
1032         bytes memory _data
1033     ) internal virtual {
1034         _mint(to, quantity);
1035 
1036         unchecked {
1037             if (to.code.length != 0) {
1038                 uint256 end = _currentIndex;
1039                 uint256 index = end - quantity;
1040                 do {
1041                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1042                         revert TransferToNonERC721ReceiverImplementer();
1043                     }
1044                 } while (index < end);
1045                 // Reentrancy protection.
1046                 if (_currentIndex != end) revert();
1047             }
1048         }
1049     }
1050 
1051     /**
1052      * @dev Mints `quantity` tokens and transfers them to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `quantity` must be greater than 0.
1058      *
1059      * Emits a {Transfer} event for each mint.
1060      */
1061     function _mint(address to, uint256 quantity) internal virtual {
1062         uint256 startTokenId = _currentIndex;
1063         if (to == address(0)) revert MintToZeroAddress();
1064         if (quantity == 0) revert MintZeroQuantity();
1065 
1066         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1067 
1068         // Overflows are incredibly unrealistic.
1069         // `balance` and `numberMinted` have a maximum limit of 2**64.
1070         // `tokenId` has a maximum limit of 2**256.
1071         unchecked {
1072             // Updates:
1073             // - `balance += quantity`.
1074             // - `numberMinted += quantity`.
1075             //
1076             // We can directly add to the `balance` and `numberMinted`.
1077             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1078 
1079             // Updates:
1080             // - `address` to the owner.
1081             // - `startTimestamp` to the timestamp of minting.
1082             // - `burned` to `false`.
1083             // - `nextInitialized` to `quantity == 1`.
1084             _packedOwnerships[startTokenId] = _packOwnershipData(
1085                 to,
1086                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1087             );
1088 
1089             uint256 tokenId = startTokenId;
1090             uint256 end = startTokenId + quantity;
1091             do {
1092                 emit Transfer(address(0), to, tokenId++);
1093             } while (tokenId < end);
1094 
1095             _currentIndex = end;
1096         }
1097         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1098     }
1099 
1100     /**
1101      * @dev Mints `quantity` tokens and transfers them to `to`.
1102      *
1103      * This function is intended for efficient minting only during contract creation.
1104      *
1105      * It emits only one {ConsecutiveTransfer} as defined in
1106      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1107      * instead of a sequence of {Transfer} event(s).
1108      *
1109      * Calling this function outside of contract creation WILL make your contract
1110      * non-compliant with the ERC721 standard.
1111      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1112      * {ConsecutiveTransfer} event is only permissible during contract creation.
1113      *
1114      * Requirements:
1115      *
1116      * - `to` cannot be the zero address.
1117      * - `quantity` must be greater than 0.
1118      *
1119      * Emits a {ConsecutiveTransfer} event.
1120      */
1121     function _mintERC2309(address to, uint256 quantity) internal virtual {
1122         uint256 startTokenId = _currentIndex;
1123         if (to == address(0)) revert MintToZeroAddress();
1124         if (quantity == 0) revert MintZeroQuantity();
1125         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1130         unchecked {
1131             // Updates:
1132             // - `balance += quantity`.
1133             // - `numberMinted += quantity`.
1134             //
1135             // We can directly add to the `balance` and `numberMinted`.
1136             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1137 
1138             // Updates:
1139             // - `address` to the owner.
1140             // - `startTimestamp` to the timestamp of minting.
1141             // - `burned` to `false`.
1142             // - `nextInitialized` to `quantity == 1`.
1143             _packedOwnerships[startTokenId] = _packOwnershipData(
1144                 to,
1145                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1146             );
1147 
1148             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1149 
1150             _currentIndex = startTokenId + quantity;
1151         }
1152         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1153     }
1154 
1155     /**
1156      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1157      */
1158     function _getApprovedAddress(uint256 tokenId)
1159         private
1160         view
1161         returns (uint256 approvedAddressSlot, address approvedAddress)
1162     {
1163         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1164         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1165         assembly {
1166             approvedAddressSlot := tokenApproval.slot
1167             approvedAddress := sload(approvedAddressSlot)
1168         }
1169     }
1170 
1171     /**
1172      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1173      */
1174     function _isOwnerOrApproved(
1175         address approvedAddress,
1176         address from,
1177         address msgSender
1178     ) private pure returns (bool result) {
1179         assembly {
1180             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1181             from := and(from, BITMASK_ADDRESS)
1182             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1183             msgSender := and(msgSender, BITMASK_ADDRESS)
1184             // `msgSender == from || msgSender == approvedAddress`.
1185             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1186         }
1187     }
1188 
1189     /**
1190      * @dev Transfers `tokenId` from `from` to `to`.
1191      *
1192      * Requirements:
1193      *
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must be owned by `from`.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function transferFrom(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) public virtual override {
1204         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1205 
1206         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1207 
1208         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1209 
1210         // The nested ifs save around 20+ gas over a compound boolean condition.
1211         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1212             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1213 
1214         if (to == address(0)) revert TransferToZeroAddress();
1215 
1216         _beforeTokenTransfers(from, to, tokenId, 1);
1217 
1218         // Clear approvals from the previous owner.
1219         assembly {
1220             if approvedAddress {
1221                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1222                 sstore(approvedAddressSlot, 0)
1223             }
1224         }
1225 
1226         // Underflow of the sender's balance is impossible because we check for
1227         // ownership above and the recipient's balance can't realistically overflow.
1228         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1229         unchecked {
1230             // We can directly increment and decrement the balances.
1231             --_packedAddressData[from]; // Updates: `balance -= 1`.
1232             ++_packedAddressData[to]; // Updates: `balance += 1`.
1233 
1234             // Updates:
1235             // - `address` to the next owner.
1236             // - `startTimestamp` to the timestamp of transfering.
1237             // - `burned` to `false`.
1238             // - `nextInitialized` to `true`.
1239             _packedOwnerships[tokenId] = _packOwnershipData(
1240                 to,
1241                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1242             );
1243 
1244             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1245             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1246                 uint256 nextTokenId = tokenId + 1;
1247                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1248                 if (_packedOwnerships[nextTokenId] == 0) {
1249                     // If the next slot is within bounds.
1250                     if (nextTokenId != _currentIndex) {
1251                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1252                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1253                     }
1254                 }
1255             }
1256         }
1257 
1258         emit Transfer(from, to, tokenId);
1259         _afterTokenTransfers(from, to, tokenId, 1);
1260     }
1261 
1262     /**
1263      * @dev Equivalent to `_burn(tokenId, false)`.
1264      */
1265     function _burn(uint256 tokenId) internal virtual {
1266         _burn(tokenId, false);
1267     }
1268 
1269     /**
1270      * @dev Destroys `tokenId`.
1271      * The approval is cleared when the token is burned.
1272      *
1273      * Requirements:
1274      *
1275      * - `tokenId` must exist.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1280         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1281 
1282         address from = address(uint160(prevOwnershipPacked));
1283 
1284         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1285 
1286         if (approvalCheck) {
1287             // The nested ifs save around 20+ gas over a compound boolean condition.
1288             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1289                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1290         }
1291 
1292         _beforeTokenTransfers(from, address(0), tokenId, 1);
1293 
1294         // Clear approvals from the previous owner.
1295         assembly {
1296             if approvedAddress {
1297                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1298                 sstore(approvedAddressSlot, 0)
1299             }
1300         }
1301 
1302         // Underflow of the sender's balance is impossible because we check for
1303         // ownership above and the recipient's balance can't realistically overflow.
1304         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1305         unchecked {
1306             // Updates:
1307             // - `balance -= 1`.
1308             // - `numberBurned += 1`.
1309             //
1310             // We can directly decrement the balance, and increment the number burned.
1311             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1312             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1313 
1314             // Updates:
1315             // - `address` to the last owner.
1316             // - `startTimestamp` to the timestamp of burning.
1317             // - `burned` to `true`.
1318             // - `nextInitialized` to `true`.
1319             _packedOwnerships[tokenId] = _packOwnershipData(
1320                 from,
1321                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1322             );
1323 
1324             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1325             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1326                 uint256 nextTokenId = tokenId + 1;
1327                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1328                 if (_packedOwnerships[nextTokenId] == 0) {
1329                     // If the next slot is within bounds.
1330                     if (nextTokenId != _currentIndex) {
1331                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1332                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1333                     }
1334                 }
1335             }
1336         }
1337 
1338         emit Transfer(from, address(0), tokenId);
1339         _afterTokenTransfers(from, address(0), tokenId, 1);
1340 
1341         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1342         unchecked {
1343             _burnCounter++;
1344         }
1345     }
1346 
1347     /**
1348      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1349      *
1350      * @param from address representing the previous owner of the given token ID
1351      * @param to target address that will receive the tokens
1352      * @param tokenId uint256 ID of the token to be transferred
1353      * @param _data bytes optional data to send along with the call
1354      * @return bool whether the call correctly returned the expected magic value
1355      */
1356     function _checkContractOnERC721Received(
1357         address from,
1358         address to,
1359         uint256 tokenId,
1360         bytes memory _data
1361     ) private returns (bool) {
1362         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1363             bytes4 retval
1364         ) {
1365             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1366         } catch (bytes memory reason) {
1367             if (reason.length == 0) {
1368                 revert TransferToNonERC721ReceiverImplementer();
1369             } else {
1370                 assembly {
1371                     revert(add(32, reason), mload(reason))
1372                 }
1373             }
1374         }
1375     }
1376 
1377     /**
1378      * @dev Directly sets the extra data for the ownership data `index`.
1379      */
1380     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1381         uint256 packed = _packedOwnerships[index];
1382         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1383         uint256 extraDataCasted;
1384         // Cast `extraData` with assembly to avoid redundant masking.
1385         assembly {
1386             extraDataCasted := extraData
1387         }
1388         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1389         _packedOwnerships[index] = packed;
1390     }
1391 
1392     /**
1393      * @dev Returns the next extra data for the packed ownership data.
1394      * The returned result is shifted into position.
1395      */
1396     function _nextExtraData(
1397         address from,
1398         address to,
1399         uint256 prevOwnershipPacked
1400     ) private view returns (uint256) {
1401         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1402         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1403     }
1404 
1405     /**
1406      * @dev Called during each token transfer to set the 24bit `extraData` field.
1407      * Intended to be overridden by the cosumer contract.
1408      *
1409      * `previousExtraData` - the value of `extraData` before transfer.
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` will be minted for `to`.
1416      * - When `to` is zero, `tokenId` will be burned by `from`.
1417      * - `from` and `to` are never both zero.
1418      */
1419     function _extraData(
1420         address from,
1421         address to,
1422         uint24 previousExtraData
1423     ) internal view virtual returns (uint24) {}
1424 
1425     /**
1426      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1427      * This includes minting.
1428      * And also called before burning one token.
1429      *
1430      * startTokenId - the first token id to be transferred
1431      * quantity - the amount to be transferred
1432      *
1433      * Calling conditions:
1434      *
1435      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1436      * transferred to `to`.
1437      * - When `from` is zero, `tokenId` will be minted for `to`.
1438      * - When `to` is zero, `tokenId` will be burned by `from`.
1439      * - `from` and `to` are never both zero.
1440      */
1441     function _beforeTokenTransfers(
1442         address from,
1443         address to,
1444         uint256 startTokenId,
1445         uint256 quantity
1446     ) internal virtual {}
1447 
1448     /**
1449      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1450      * This includes minting.
1451      * And also called after one token has been burned.
1452      *
1453      * startTokenId - the first token id to be transferred
1454      * quantity - the amount to be transferred
1455      *
1456      * Calling conditions:
1457      *
1458      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1459      * transferred to `to`.
1460      * - When `from` is zero, `tokenId` has been minted for `to`.
1461      * - When `to` is zero, `tokenId` has been burned by `from`.
1462      * - `from` and `to` are never both zero.
1463      */
1464     function _afterTokenTransfers(
1465         address from,
1466         address to,
1467         uint256 startTokenId,
1468         uint256 quantity
1469     ) internal virtual {}
1470 
1471     /**
1472      * @dev Returns the message sender (defaults to `msg.sender`).
1473      *
1474      * If you are writing GSN compatible contracts, you need to override this function.
1475      */
1476     function _msgSenderERC721A() internal view virtual returns (address) {
1477         return msg.sender;
1478     }
1479 
1480     /**
1481      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1482      */
1483     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1484         assembly {
1485             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1486             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1487             // We will need 1 32-byte word to store the length,
1488             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1489             ptr := add(mload(0x40), 128)
1490             // Update the free memory pointer to allocate.
1491             mstore(0x40, ptr)
1492 
1493             // Cache the end of the memory to calculate the length later.
1494             let end := ptr
1495 
1496             // We write the string from the rightmost digit to the leftmost digit.
1497             // The following is essentially a do-while loop that also handles the zero case.
1498             // Costs a bit more than early returning for the zero case,
1499             // but cheaper in terms of deployment and overall runtime costs.
1500             for {
1501                 // Initialize and perform the first pass without check.
1502                 let temp := value
1503                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1504                 ptr := sub(ptr, 1)
1505                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1506                 mstore8(ptr, add(48, mod(temp, 10)))
1507                 temp := div(temp, 10)
1508             } temp {
1509                 // Keep dividing `temp` until zero.
1510                 temp := div(temp, 10)
1511             } {
1512                 // Body of the for loop.
1513                 ptr := sub(ptr, 1)
1514                 mstore8(ptr, add(48, mod(temp, 10)))
1515             }
1516 
1517             let length := sub(end, ptr)
1518             // Move the pointer 32 bytes leftwards to make room for the length.
1519             ptr := sub(ptr, 32)
1520             // Store the length.
1521             mstore(ptr, length)
1522         }
1523     }
1524 }
1525 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1526 
1527 
1528 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1529 
1530 pragma solidity ^0.8.0;
1531 
1532 /**
1533  * @dev Contract module that helps prevent reentrant calls to a function.
1534  *
1535  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1536  * available, which can be applied to functions to make sure there are no nested
1537  * (reentrant) calls to them.
1538  *
1539  * Note that because there is a single `nonReentrant` guard, functions marked as
1540  * `nonReentrant` may not call one another. This can be worked around by making
1541  * those functions `private`, and then adding `external` `nonReentrant` entry
1542  * points to them.
1543  *
1544  * TIP: If you would like to learn more about reentrancy and alternative ways
1545  * to protect against it, check out our blog post
1546  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1547  */
1548 abstract contract ReentrancyGuard {
1549     // Booleans are more expensive than uint256 or any type that takes up a full
1550     // word because each write operation emits an extra SLOAD to first read the
1551     // slot's contents, replace the bits taken up by the boolean, and then write
1552     // back. This is the compiler's defense against contract upgrades and
1553     // pointer aliasing, and it cannot be disabled.
1554 
1555     // The values being non-zero value makes deployment a bit more expensive,
1556     // but in exchange the refund on every call to nonReentrant will be lower in
1557     // amount. Since refunds are capped to a percentage of the total
1558     // transaction's gas, it is best to keep them low in cases like this one, to
1559     // increase the likelihood of the full refund coming into effect.
1560     uint256 private constant _NOT_ENTERED = 1;
1561     uint256 private constant _ENTERED = 2;
1562 
1563     uint256 private _status;
1564 
1565     constructor() {
1566         _status = _NOT_ENTERED;
1567     }
1568 
1569     /**
1570      * @dev Prevents a contract from calling itself, directly or indirectly.
1571      * Calling a `nonReentrant` function from another `nonReentrant`
1572      * function is not supported. It is possible to prevent this from happening
1573      * by making the `nonReentrant` function external, and making it call a
1574      * `private` function that does the actual work.
1575      */
1576     modifier nonReentrant() {
1577         // On the first call to nonReentrant, _notEntered will be true
1578         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1579 
1580         // Any calls to nonReentrant after this point will fail
1581         _status = _ENTERED;
1582 
1583         _;
1584 
1585         // By storing the original value once again, a refund is triggered (see
1586         // https://eips.ethereum.org/EIPS/eip-2200)
1587         _status = _NOT_ENTERED;
1588     }
1589 }
1590 
1591 // File: @openzeppelin/contracts/utils/Context.sol
1592 
1593 
1594 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1595 
1596 pragma solidity ^0.8.0;
1597 
1598 /**
1599  * @dev Provides information about the current execution context, including the
1600  * sender of the transaction and its data. While these are generally available
1601  * via msg.sender and msg.data, they should not be accessed in such a direct
1602  * manner, since when dealing with meta-transactions the account sending and
1603  * paying for execution may not be the actual sender (as far as an application
1604  * is concerned).
1605  *
1606  * This contract is only required for intermediate, library-like contracts.
1607  */
1608 abstract contract Context {
1609     function _msgSender() internal view virtual returns (address) {
1610         return msg.sender;
1611     }
1612 
1613     function _msgData() internal view virtual returns (bytes calldata) {
1614         return msg.data;
1615     }
1616 }
1617 
1618 // File: @openzeppelin/contracts/access/Ownable.sol
1619 
1620 
1621 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1622 
1623 pragma solidity ^0.8.0;
1624 
1625 
1626 /**
1627  * @dev Contract module which provides a basic access control mechanism, where
1628  * there is an account (an owner) that can be granted exclusive access to
1629  * specific functions.
1630  *
1631  * By default, the owner account will be the one that deploys the contract. This
1632  * can later be changed with {transferOwnership}.
1633  *
1634  * This module is used through inheritance. It will make available the modifier
1635  * `onlyOwner`, which can be applied to your functions to restrict their use to
1636  * the owner.
1637  */
1638 abstract contract Ownable is Context {
1639     address private _owner;
1640 
1641     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1642 
1643     /**
1644      * @dev Initializes the contract setting the deployer as the initial owner.
1645      */
1646     constructor() {
1647         _transferOwnership(_msgSender());
1648     }
1649 
1650     /**
1651      * @dev Throws if called by any account other than the owner.
1652      */
1653     modifier onlyOwner() {
1654         _checkOwner();
1655         _;
1656     }
1657 
1658     /**
1659      * @dev Returns the address of the current owner.
1660      */
1661     function owner() public view virtual returns (address) {
1662         return _owner;
1663     }
1664 
1665     /**
1666      * @dev Throws if the sender is not the owner.
1667      */
1668     function _checkOwner() internal view virtual {
1669         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1670     }
1671 
1672     /**
1673      * @dev Leaves the contract without owner. It will not be possible to call
1674      * `onlyOwner` functions anymore. Can only be called by the current owner.
1675      *
1676      * NOTE: Renouncing ownership will leave the contract without an owner,
1677      * thereby removing any functionality that is only available to the owner.
1678      */
1679     function renounceOwnership() public virtual onlyOwner {
1680         _transferOwnership(address(0));
1681     }
1682 
1683     /**
1684      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1685      * Can only be called by the current owner.
1686      */
1687     function transferOwnership(address newOwner) public virtual onlyOwner {
1688         require(newOwner != address(0), "Ownable: new owner is the zero address");
1689         _transferOwnership(newOwner);
1690     }
1691 
1692     /**
1693      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1694      * Internal function without access restriction.
1695      */
1696     function _transferOwnership(address newOwner) internal virtual {
1697         address oldOwner = _owner;
1698         _owner = newOwner;
1699         emit OwnershipTransferred(oldOwner, newOwner);
1700     }
1701 }
1702 
1703 // File: contracts/Dumbkeys.sol
1704 
1705 
1706 
1707 pragma solidity ^0.8.0;
1708 
1709 
1710 
1711 
1712 
1713 
1714 contract Dumbkeys is Ownable, ERC721A, ReentrancyGuard {
1715 
1716     bool private isPublicSaleOn = false;
1717     uint private constant MAX_SUPPLY = 3333;
1718     bytes32 public whiteListRoot;
1719   
1720     bool private whitelistOn = false;
1721     mapping(address => uint256) public whiteListClaimed;
1722     mapping(address => bool) public whiteListClaimedChecker;
1723     
1724 
1725 
1726     constructor() ERC721A("Dumbkeys", "DUMB") {}
1727 
1728     modifier callerIsUser() {
1729         require(tx.origin == msg.sender, "The caller is another contract");
1730         _;
1731     }
1732 
1733 
1734     function reserveGiveaway(uint256 num, address walletAddress)
1735         public
1736         onlyOwner
1737     {
1738         require(totalSupply() + num <= MAX_SUPPLY, "Exceeds total supply");
1739         _safeMint(walletAddress, num);
1740     }
1741 
1742     function whiteListMint(bytes32[] calldata _merkleProof, uint256 quantity) external payable callerIsUser {
1743         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1744         require(MerkleProof.verify(_merkleProof, whiteListRoot, leaf),
1745             "Invalid Merkle Proof.");
1746         require(whitelistOn, "whitelist sale has not begun yet");
1747         require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds total supply");
1748         if (!whiteListClaimedChecker[msg.sender]) {
1749             whiteListClaimedChecker[msg.sender] = true;
1750             whiteListClaimed[msg.sender] = 3;
1751         }
1752         require(whiteListClaimed[msg.sender] - quantity >= 0, "Address already minted num of tokens allowed");
1753         whiteListClaimed[msg.sender] = whiteListClaimed[msg.sender] - quantity;
1754         _safeMint(msg.sender, quantity);
1755         
1756     }
1757 
1758 
1759     function publicSaleMint(uint256 quantity)
1760         external
1761         payable
1762         callerIsUser
1763     {
1764       
1765         require(
1766             isPublicSaleOn,
1767             "public sale has not begun yet"
1768         );
1769         require(
1770             totalSupply() + quantity <= MAX_SUPPLY,
1771             "reached max supply"
1772         );
1773        
1774         _safeMint(msg.sender, quantity);
1775   
1776     }
1777 
1778 
1779     function setPublicSale(bool flag) external onlyOwner {
1780         isPublicSaleOn = flag;
1781     }
1782 
1783     function setWhitelistFlag(bool flag) external onlyOwner {
1784         whitelistOn = flag;
1785     }
1786 
1787     function setWhiteListRoot(bytes32 merkle_root) external onlyOwner {
1788         whiteListRoot = merkle_root;
1789     }
1790 
1791     string private _baseTokenURI;
1792 
1793     function _baseURI() internal view virtual override returns (string memory) {
1794         return _baseTokenURI;
1795     }
1796 
1797     function setBaseURI(string calldata baseURI) external onlyOwner {
1798         _baseTokenURI = baseURI;
1799     }
1800 
1801     function withdraw() external onlyOwner nonReentrant {
1802          (bool success, ) = msg.sender.call{value: address(this).balance}("");
1803          require(success, "Transfer failed.");
1804     }
1805 
1806     function numberMinted(address owner) public view returns (uint256) {
1807         return _numberMinted(owner);
1808     }
1809 
1810 }