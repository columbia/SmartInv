1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
87 
88 
89 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev These functions deal with verification of Merkle Tree proofs.
95  *
96  * The proofs can be generated using the JavaScript library
97  * https://github.com/miguelmota/merkletreejs[merkletreejs].
98  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
99  *
100  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
101  *
102  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
103  * hashing, or use a hash function other than keccak256 for hashing leaves.
104  * This is because the concatenation of a sorted pair of internal nodes in
105  * the merkle tree could be reinterpreted as a leaf value.
106  */
107 library MerkleProof {
108     /**
109      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
110      * defined by `root`. For this, a `proof` must be provided, containing
111      * sibling hashes on the branch from the leaf to the root of the tree. Each
112      * pair of leaves and each pair of pre-images are assumed to be sorted.
113      */
114     function verify(
115         bytes32[] memory proof,
116         bytes32 root,
117         bytes32 leaf
118     ) internal pure returns (bool) {
119         return processProof(proof, leaf) == root;
120     }
121 
122     /**
123      * @dev Calldata version of {verify}
124      *
125      * _Available since v4.7._
126      */
127     function verifyCalldata(
128         bytes32[] calldata proof,
129         bytes32 root,
130         bytes32 leaf
131     ) internal pure returns (bool) {
132         return processProofCalldata(proof, leaf) == root;
133     }
134 
135     /**
136      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
137      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
138      * hash matches the root of the tree. When processing the proof, the pairs
139      * of leafs & pre-images are assumed to be sorted.
140      *
141      * _Available since v4.4._
142      */
143     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
144         bytes32 computedHash = leaf;
145         for (uint256 i = 0; i < proof.length; i++) {
146             computedHash = _hashPair(computedHash, proof[i]);
147         }
148         return computedHash;
149     }
150 
151     /**
152      * @dev Calldata version of {processProof}
153      *
154      * _Available since v4.7._
155      */
156     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
157         bytes32 computedHash = leaf;
158         for (uint256 i = 0; i < proof.length; i++) {
159             computedHash = _hashPair(computedHash, proof[i]);
160         }
161         return computedHash;
162     }
163 
164     /**
165      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
166      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
167      *
168      * _Available since v4.7._
169      */
170     function multiProofVerify(
171         bytes32[] memory proof,
172         bool[] memory proofFlags,
173         bytes32 root,
174         bytes32[] memory leaves
175     ) internal pure returns (bool) {
176         return processMultiProof(proof, proofFlags, leaves) == root;
177     }
178 
179     /**
180      * @dev Calldata version of {multiProofVerify}
181      *
182      * _Available since v4.7._
183      */
184     function multiProofVerifyCalldata(
185         bytes32[] calldata proof,
186         bool[] calldata proofFlags,
187         bytes32 root,
188         bytes32[] memory leaves
189     ) internal pure returns (bool) {
190         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
191     }
192 
193     /**
194      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
195      * consuming from one or the other at each step according to the instructions given by
196      * `proofFlags`.
197      *
198      * _Available since v4.7._
199      */
200     function processMultiProof(
201         bytes32[] memory proof,
202         bool[] memory proofFlags,
203         bytes32[] memory leaves
204     ) internal pure returns (bytes32 merkleRoot) {
205         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
206         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
207         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
208         // the merkle tree.
209         uint256 leavesLen = leaves.length;
210         uint256 totalHashes = proofFlags.length;
211 
212         // Check proof validity.
213         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
214 
215         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
216         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
217         bytes32[] memory hashes = new bytes32[](totalHashes);
218         uint256 leafPos = 0;
219         uint256 hashPos = 0;
220         uint256 proofPos = 0;
221         // At each step, we compute the next hash using two values:
222         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
223         //   get the next hash.
224         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
225         //   `proof` array.
226         for (uint256 i = 0; i < totalHashes; i++) {
227             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
228             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
229             hashes[i] = _hashPair(a, b);
230         }
231 
232         if (totalHashes > 0) {
233             return hashes[totalHashes - 1];
234         } else if (leavesLen > 0) {
235             return leaves[0];
236         } else {
237             return proof[0];
238         }
239     }
240 
241     /**
242      * @dev Calldata version of {processMultiProof}
243      *
244      * _Available since v4.7._
245      */
246     function processMultiProofCalldata(
247         bytes32[] calldata proof,
248         bool[] calldata proofFlags,
249         bytes32[] memory leaves
250     ) internal pure returns (bytes32 merkleRoot) {
251         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
252         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
253         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
254         // the merkle tree.
255         uint256 leavesLen = leaves.length;
256         uint256 totalHashes = proofFlags.length;
257 
258         // Check proof validity.
259         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
260 
261         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
262         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
263         bytes32[] memory hashes = new bytes32[](totalHashes);
264         uint256 leafPos = 0;
265         uint256 hashPos = 0;
266         uint256 proofPos = 0;
267         // At each step, we compute the next hash using two values:
268         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
269         //   get the next hash.
270         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
271         //   `proof` array.
272         for (uint256 i = 0; i < totalHashes; i++) {
273             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
274             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
275             hashes[i] = _hashPair(a, b);
276         }
277 
278         if (totalHashes > 0) {
279             return hashes[totalHashes - 1];
280         } else if (leavesLen > 0) {
281             return leaves[0];
282         } else {
283             return proof[0];
284         }
285     }
286 
287     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
288         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
289     }
290 
291     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
292         /// @solidity memory-safe-assembly
293         assembly {
294             mstore(0x00, a)
295             mstore(0x20, b)
296             value := keccak256(0x00, 0x40)
297         }
298     }
299 }
300 
301 // File: erc721a/contracts/IERC721A.sol
302 
303 
304 // ERC721A Contracts v4.2.3
305 // Creator: Chiru Labs
306 
307 pragma solidity ^0.8.4;
308 
309 /**
310  * @dev Interface of ERC721A.
311  */
312 interface IERC721A {
313     /**
314      * The caller must own the token or be an approved operator.
315      */
316     error ApprovalCallerNotOwnerNorApproved();
317 
318     /**
319      * The token does not exist.
320      */
321     error ApprovalQueryForNonexistentToken();
322 
323     /**
324      * Cannot query the balance for the zero address.
325      */
326     error BalanceQueryForZeroAddress();
327 
328     /**
329      * Cannot mint to the zero address.
330      */
331     error MintToZeroAddress();
332 
333     /**
334      * The quantity of tokens minted must be more than zero.
335      */
336     error MintZeroQuantity();
337 
338     /**
339      * The token does not exist.
340      */
341     error OwnerQueryForNonexistentToken();
342 
343     /**
344      * The caller must own the token or be an approved operator.
345      */
346     error TransferCallerNotOwnerNorApproved();
347 
348     /**
349      * The token must be owned by `from`.
350      */
351     error TransferFromIncorrectOwner();
352 
353     /**
354      * Cannot safely transfer to a contract that does not implement the
355      * ERC721Receiver interface.
356      */
357     error TransferToNonERC721ReceiverImplementer();
358 
359     /**
360      * Cannot transfer to the zero address.
361      */
362     error TransferToZeroAddress();
363 
364     /**
365      * The token does not exist.
366      */
367     error URIQueryForNonexistentToken();
368 
369     /**
370      * The `quantity` minted with ERC2309 exceeds the safety limit.
371      */
372     error MintERC2309QuantityExceedsLimit();
373 
374     /**
375      * The `extraData` cannot be set on an unintialized ownership slot.
376      */
377     error OwnershipNotInitializedForExtraData();
378 
379     // =============================================================
380     //                            STRUCTS
381     // =============================================================
382 
383     struct TokenOwnership {
384         // The address of the owner.
385         address addr;
386         // Stores the start time of ownership with minimal overhead for tokenomics.
387         uint64 startTimestamp;
388         // Whether the token has been burned.
389         bool burned;
390         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
391         uint24 extraData;
392     }
393 
394     // =============================================================
395     //                         TOKEN COUNTERS
396     // =============================================================
397 
398     /**
399      * @dev Returns the total number of tokens in existence.
400      * Burned tokens will reduce the count.
401      * To get the total number of tokens minted, please see {_totalMinted}.
402      */
403     function totalSupply() external view returns (uint256);
404 
405     // =============================================================
406     //                            IERC165
407     // =============================================================
408 
409     /**
410      * @dev Returns true if this contract implements the interface defined by
411      * `interfaceId`. See the corresponding
412      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
413      * to learn more about how these ids are created.
414      *
415      * This function call must use less than 30000 gas.
416      */
417     function supportsInterface(bytes4 interfaceId) external view returns (bool);
418 
419     // =============================================================
420     //                            IERC721
421     // =============================================================
422 
423     /**
424      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
425      */
426     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
430      */
431     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables or disables
435      * (`approved`) `operator` to manage all of its assets.
436      */
437     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
438 
439     /**
440      * @dev Returns the number of tokens in `owner`'s account.
441      */
442     function balanceOf(address owner) external view returns (uint256 balance);
443 
444     /**
445      * @dev Returns the owner of the `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function ownerOf(uint256 tokenId) external view returns (address owner);
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`,
455      * checking first that contract recipients are aware of the ERC721 protocol
456      * to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be have been allowed to move
464      * this token by either {approve} or {setApprovalForAll}.
465      * - If `to` refers to a smart contract, it must implement
466      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes calldata data
475     ) external payable;
476 
477     /**
478      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
479      */
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external payable;
485 
486     /**
487      * @dev Transfers `tokenId` from `from` to `to`.
488      *
489      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
490      * whenever possible.
491      *
492      * Requirements:
493      *
494      * - `from` cannot be the zero address.
495      * - `to` cannot be the zero address.
496      * - `tokenId` token must be owned by `from`.
497      * - If the caller is not `from`, it must be approved to move this token
498      * by either {approve} or {setApprovalForAll}.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transferFrom(
503         address from,
504         address to,
505         uint256 tokenId
506     ) external payable;
507 
508     /**
509      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
510      * The approval is cleared when the token is transferred.
511      *
512      * Only a single account can be approved at a time, so approving the
513      * zero address clears previous approvals.
514      *
515      * Requirements:
516      *
517      * - The caller must own the token or be an approved operator.
518      * - `tokenId` must exist.
519      *
520      * Emits an {Approval} event.
521      */
522     function approve(address to, uint256 tokenId) external payable;
523 
524     /**
525      * @dev Approve or remove `operator` as an operator for the caller.
526      * Operators can call {transferFrom} or {safeTransferFrom}
527      * for any token owned by the caller.
528      *
529      * Requirements:
530      *
531      * - The `operator` cannot be the caller.
532      *
533      * Emits an {ApprovalForAll} event.
534      */
535     function setApprovalForAll(address operator, bool _approved) external;
536 
537     /**
538      * @dev Returns the account approved for `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function getApproved(uint256 tokenId) external view returns (address operator);
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}.
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 
553     // =============================================================
554     //                        IERC721Metadata
555     // =============================================================
556 
557     /**
558      * @dev Returns the token collection name.
559      */
560     function name() external view returns (string memory);
561 
562     /**
563      * @dev Returns the token collection symbol.
564      */
565     function symbol() external view returns (string memory);
566 
567     /**
568      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
569      */
570     function tokenURI(uint256 tokenId) external view returns (string memory);
571 
572     // =============================================================
573     //                           IERC2309
574     // =============================================================
575 
576     /**
577      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
578      * (inclusive) is transferred from `from` to `to`, as defined in the
579      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
580      *
581      * See {_mintERC2309} for more details.
582      */
583     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
584 }
585 
586 // File: erc721a/contracts/ERC721A.sol
587 
588 
589 // ERC721A Contracts v4.2.3
590 // Creator: Chiru Labs
591 
592 pragma solidity ^0.8.4;
593 
594 
595 /**
596  * @dev Interface of ERC721 token receiver.
597  */
598 interface ERC721A__IERC721Receiver {
599     function onERC721Received(
600         address operator,
601         address from,
602         uint256 tokenId,
603         bytes calldata data
604     ) external returns (bytes4);
605 }
606 
607 /**
608  * @title ERC721A
609  *
610  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
611  * Non-Fungible Token Standard, including the Metadata extension.
612  * Optimized for lower gas during batch mints.
613  *
614  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
615  * starting from `_startTokenId()`.
616  *
617  * Assumptions:
618  *
619  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
620  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
621  */
622 contract ERC721A is IERC721A {
623     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
624     struct TokenApprovalRef {
625         address value;
626     }
627 
628     // =============================================================
629     //                           CONSTANTS
630     // =============================================================
631 
632     // Mask of an entry in packed address data.
633     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
634 
635     // The bit position of `numberMinted` in packed address data.
636     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
637 
638     // The bit position of `numberBurned` in packed address data.
639     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
640 
641     // The bit position of `aux` in packed address data.
642     uint256 private constant _BITPOS_AUX = 192;
643 
644     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
645     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
646 
647     // The bit position of `startTimestamp` in packed ownership.
648     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
649 
650     // The bit mask of the `burned` bit in packed ownership.
651     uint256 private constant _BITMASK_BURNED = 1 << 224;
652 
653     // The bit position of the `nextInitialized` bit in packed ownership.
654     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
655 
656     // The bit mask of the `nextInitialized` bit in packed ownership.
657     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
658 
659     // The bit position of `extraData` in packed ownership.
660     uint256 private constant _BITPOS_EXTRA_DATA = 232;
661 
662     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
663     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
664 
665     // The mask of the lower 160 bits for addresses.
666     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
667 
668     // The maximum `quantity` that can be minted with {_mintERC2309}.
669     // This limit is to prevent overflows on the address data entries.
670     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
671     // is required to cause an overflow, which is unrealistic.
672     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
673 
674     // The `Transfer` event signature is given by:
675     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
676     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
677         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
678 
679     // =============================================================
680     //                            STORAGE
681     // =============================================================
682 
683     // The next token ID to be minted.
684     uint256 private _currentIndex;
685 
686     // The number of tokens burned.
687     uint256 private _burnCounter;
688 
689     // Token name
690     string private _name;
691 
692     // Token symbol
693     string private _symbol;
694 
695     // Mapping from token ID to ownership details
696     // An empty struct value does not necessarily mean the token is unowned.
697     // See {_packedOwnershipOf} implementation for details.
698     //
699     // Bits Layout:
700     // - [0..159]   `addr`
701     // - [160..223] `startTimestamp`
702     // - [224]      `burned`
703     // - [225]      `nextInitialized`
704     // - [232..255] `extraData`
705     mapping(uint256 => uint256) private _packedOwnerships;
706 
707     // Mapping owner address to address data.
708     //
709     // Bits Layout:
710     // - [0..63]    `balance`
711     // - [64..127]  `numberMinted`
712     // - [128..191] `numberBurned`
713     // - [192..255] `aux`
714     mapping(address => uint256) private _packedAddressData;
715 
716     // Mapping from token ID to approved address.
717     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
718 
719     // Mapping from owner to operator approvals
720     mapping(address => mapping(address => bool)) private _operatorApprovals;
721 
722     // =============================================================
723     //                          CONSTRUCTOR
724     // =============================================================
725 
726     constructor(string memory name_, string memory symbol_) {
727         _name = name_;
728         _symbol = symbol_;
729         _currentIndex = _startTokenId();
730     }
731 
732     // =============================================================
733     //                   TOKEN COUNTING OPERATIONS
734     // =============================================================
735 
736     /**
737      * @dev Returns the starting token ID.
738      * To change the starting token ID, please override this function.
739      */
740     function _startTokenId() internal view virtual returns (uint256) {
741         return 0;
742     }
743 
744     /**
745      * @dev Returns the next token ID to be minted.
746      */
747     function _nextTokenId() internal view virtual returns (uint256) {
748         return _currentIndex;
749     }
750 
751     /**
752      * @dev Returns the total number of tokens in existence.
753      * Burned tokens will reduce the count.
754      * To get the total number of tokens minted, please see {_totalMinted}.
755      */
756     function totalSupply() public view virtual override returns (uint256) {
757         // Counter underflow is impossible as _burnCounter cannot be incremented
758         // more than `_currentIndex - _startTokenId()` times.
759         unchecked {
760             return _currentIndex - _burnCounter - _startTokenId();
761         }
762     }
763 
764     /**
765      * @dev Returns the total amount of tokens minted in the contract.
766      */
767     function _totalMinted() internal view virtual returns (uint256) {
768         // Counter underflow is impossible as `_currentIndex` does not decrement,
769         // and it is initialized to `_startTokenId()`.
770         unchecked {
771             return _currentIndex - _startTokenId();
772         }
773     }
774 
775     /**
776      * @dev Returns the total number of tokens burned.
777      */
778     function _totalBurned() internal view virtual returns (uint256) {
779         return _burnCounter;
780     }
781 
782     // =============================================================
783     //                    ADDRESS DATA OPERATIONS
784     // =============================================================
785 
786     /**
787      * @dev Returns the number of tokens in `owner`'s account.
788      */
789     function balanceOf(address owner) public view virtual override returns (uint256) {
790         if (owner == address(0)) revert BalanceQueryForZeroAddress();
791         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
792     }
793 
794     /**
795      * Returns the number of tokens minted by `owner`.
796      */
797     function _numberMinted(address owner) internal view returns (uint256) {
798         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
799     }
800 
801     /**
802      * Returns the number of tokens burned by or on behalf of `owner`.
803      */
804     function _numberBurned(address owner) internal view returns (uint256) {
805         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
806     }
807 
808     /**
809      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
810      */
811     function _getAux(address owner) internal view returns (uint64) {
812         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
813     }
814 
815     /**
816      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
817      * If there are multiple variables, please pack them into a uint64.
818      */
819     function _setAux(address owner, uint64 aux) internal virtual {
820         uint256 packed = _packedAddressData[owner];
821         uint256 auxCasted;
822         // Cast `aux` with assembly to avoid redundant masking.
823         assembly {
824             auxCasted := aux
825         }
826         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
827         _packedAddressData[owner] = packed;
828     }
829 
830     // =============================================================
831     //                            IERC165
832     // =============================================================
833 
834     /**
835      * @dev Returns true if this contract implements the interface defined by
836      * `interfaceId`. See the corresponding
837      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
838      * to learn more about how these ids are created.
839      *
840      * This function call must use less than 30000 gas.
841      */
842     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
843         // The interface IDs are constants representing the first 4 bytes
844         // of the XOR of all function selectors in the interface.
845         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
846         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
847         return
848             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
849             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
850             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
851     }
852 
853     // =============================================================
854     //                        IERC721Metadata
855     // =============================================================
856 
857     /**
858      * @dev Returns the token collection name.
859      */
860     function name() public view virtual override returns (string memory) {
861         return _name;
862     }
863 
864     /**
865      * @dev Returns the token collection symbol.
866      */
867     function symbol() public view virtual override returns (string memory) {
868         return _symbol;
869     }
870 
871     /**
872      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
873      */
874     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
875         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
876 
877         string memory baseURI = _baseURI();
878         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
879     }
880 
881     /**
882      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
883      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
884      * by default, it can be overridden in child contracts.
885      */
886     function _baseURI() internal view virtual returns (string memory) {
887         return '';
888     }
889 
890     // =============================================================
891     //                     OWNERSHIPS OPERATIONS
892     // =============================================================
893 
894     /**
895      * @dev Returns the owner of the `tokenId` token.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
902         return address(uint160(_packedOwnershipOf(tokenId)));
903     }
904 
905     /**
906      * @dev Gas spent here starts off proportional to the maximum mint batch size.
907      * It gradually moves to O(1) as tokens get transferred around over time.
908      */
909     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
910         return _unpackedOwnership(_packedOwnershipOf(tokenId));
911     }
912 
913     /**
914      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
915      */
916     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
917         return _unpackedOwnership(_packedOwnerships[index]);
918     }
919 
920     /**
921      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
922      */
923     function _initializeOwnershipAt(uint256 index) internal virtual {
924         if (_packedOwnerships[index] == 0) {
925             _packedOwnerships[index] = _packedOwnershipOf(index);
926         }
927     }
928 
929     /**
930      * Returns the packed ownership data of `tokenId`.
931      */
932     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
933         uint256 curr = tokenId;
934 
935         unchecked {
936             if (_startTokenId() <= curr)
937                 if (curr < _currentIndex) {
938                     uint256 packed = _packedOwnerships[curr];
939                     // If not burned.
940                     if (packed & _BITMASK_BURNED == 0) {
941                         // Invariant:
942                         // There will always be an initialized ownership slot
943                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
944                         // before an unintialized ownership slot
945                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
946                         // Hence, `curr` will not underflow.
947                         //
948                         // We can directly compare the packed value.
949                         // If the address is zero, packed will be zero.
950                         while (packed == 0) {
951                             packed = _packedOwnerships[--curr];
952                         }
953                         return packed;
954                     }
955                 }
956         }
957         revert OwnerQueryForNonexistentToken();
958     }
959 
960     /**
961      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
962      */
963     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
964         ownership.addr = address(uint160(packed));
965         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
966         ownership.burned = packed & _BITMASK_BURNED != 0;
967         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
968     }
969 
970     /**
971      * @dev Packs ownership data into a single uint256.
972      */
973     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
974         assembly {
975             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
976             owner := and(owner, _BITMASK_ADDRESS)
977             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
978             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
979         }
980     }
981 
982     /**
983      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
984      */
985     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
986         // For branchless setting of the `nextInitialized` flag.
987         assembly {
988             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
989             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
990         }
991     }
992 
993     // =============================================================
994     //                      APPROVAL OPERATIONS
995     // =============================================================
996 
997     /**
998      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
999      * The approval is cleared when the token is transferred.
1000      *
1001      * Only a single account can be approved at a time, so approving the
1002      * zero address clears previous approvals.
1003      *
1004      * Requirements:
1005      *
1006      * - The caller must own the token or be an approved operator.
1007      * - `tokenId` must exist.
1008      *
1009      * Emits an {Approval} event.
1010      */
1011     function approve(address to, uint256 tokenId) public payable virtual override {
1012         address owner = ownerOf(tokenId);
1013 
1014         if (_msgSenderERC721A() != owner)
1015             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1016                 revert ApprovalCallerNotOwnerNorApproved();
1017             }
1018 
1019         _tokenApprovals[tokenId].value = to;
1020         emit Approval(owner, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev Returns the account approved for `tokenId` token.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must exist.
1029      */
1030     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1031         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1032 
1033         return _tokenApprovals[tokenId].value;
1034     }
1035 
1036     /**
1037      * @dev Approve or remove `operator` as an operator for the caller.
1038      * Operators can call {transferFrom} or {safeTransferFrom}
1039      * for any token owned by the caller.
1040      *
1041      * Requirements:
1042      *
1043      * - The `operator` cannot be the caller.
1044      *
1045      * Emits an {ApprovalForAll} event.
1046      */
1047     function setApprovalForAll(address operator, bool approved) public virtual override {
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
1102         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
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
1130     ) public payable virtual override {
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
1196     ) public payable virtual override {
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
1220     ) public payable virtual override {
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
1350             // The duplicated `log4` removes an extra check and reduces stack juggling.
1351             // The assembly, together with the surrounding Solidity code, have been
1352             // delicately arranged to nudge the compiler into producing optimized opcodes.
1353             assembly {
1354                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1355                 toMasked := and(to, _BITMASK_ADDRESS)
1356                 // Emit the `Transfer` event.
1357                 log4(
1358                     0, // Start of data (0, since no data).
1359                     0, // End of data (0, since no data).
1360                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1361                     0, // `address(0)`.
1362                     toMasked, // `to`.
1363                     startTokenId // `tokenId`.
1364                 )
1365 
1366                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1367                 // that overflows uint256 will make the loop run out of gas.
1368                 // The compiler will optimize the `iszero` away for performance.
1369                 for {
1370                     let tokenId := add(startTokenId, 1)
1371                 } iszero(eq(tokenId, end)) {
1372                     tokenId := add(tokenId, 1)
1373                 } {
1374                     // Emit the `Transfer` event. Similar to above.
1375                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1376                 }
1377             }
1378             if (toMasked == 0) revert MintToZeroAddress();
1379 
1380             _currentIndex = end;
1381         }
1382         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1383     }
1384 
1385     /**
1386      * @dev Mints `quantity` tokens and transfers them to `to`.
1387      *
1388      * This function is intended for efficient minting only during contract creation.
1389      *
1390      * It emits only one {ConsecutiveTransfer} as defined in
1391      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1392      * instead of a sequence of {Transfer} event(s).
1393      *
1394      * Calling this function outside of contract creation WILL make your contract
1395      * non-compliant with the ERC721 standard.
1396      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1397      * {ConsecutiveTransfer} event is only permissible during contract creation.
1398      *
1399      * Requirements:
1400      *
1401      * - `to` cannot be the zero address.
1402      * - `quantity` must be greater than 0.
1403      *
1404      * Emits a {ConsecutiveTransfer} event.
1405      */
1406     function _mintERC2309(address to, uint256 quantity) internal virtual {
1407         uint256 startTokenId = _currentIndex;
1408         if (to == address(0)) revert MintToZeroAddress();
1409         if (quantity == 0) revert MintZeroQuantity();
1410         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1411 
1412         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1413 
1414         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1415         unchecked {
1416             // Updates:
1417             // - `balance += quantity`.
1418             // - `numberMinted += quantity`.
1419             //
1420             // We can directly add to the `balance` and `numberMinted`.
1421             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1422 
1423             // Updates:
1424             // - `address` to the owner.
1425             // - `startTimestamp` to the timestamp of minting.
1426             // - `burned` to `false`.
1427             // - `nextInitialized` to `quantity == 1`.
1428             _packedOwnerships[startTokenId] = _packOwnershipData(
1429                 to,
1430                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1431             );
1432 
1433             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1434 
1435             _currentIndex = startTokenId + quantity;
1436         }
1437         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1438     }
1439 
1440     /**
1441      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1442      *
1443      * Requirements:
1444      *
1445      * - If `to` refers to a smart contract, it must implement
1446      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1447      * - `quantity` must be greater than 0.
1448      *
1449      * See {_mint}.
1450      *
1451      * Emits a {Transfer} event for each mint.
1452      */
1453     function _safeMint(
1454         address to,
1455         uint256 quantity,
1456         bytes memory _data
1457     ) internal virtual {
1458         _mint(to, quantity);
1459 
1460         unchecked {
1461             if (to.code.length != 0) {
1462                 uint256 end = _currentIndex;
1463                 uint256 index = end - quantity;
1464                 do {
1465                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1466                         revert TransferToNonERC721ReceiverImplementer();
1467                     }
1468                 } while (index < end);
1469                 // Reentrancy protection.
1470                 if (_currentIndex != end) revert();
1471             }
1472         }
1473     }
1474 
1475     /**
1476      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1477      */
1478     function _safeMint(address to, uint256 quantity) internal virtual {
1479         _safeMint(to, quantity, '');
1480     }
1481 
1482     // =============================================================
1483     //                        BURN OPERATIONS
1484     // =============================================================
1485 
1486     /**
1487      * @dev Equivalent to `_burn(tokenId, false)`.
1488      */
1489     function _burn(uint256 tokenId) internal virtual {
1490         _burn(tokenId, false);
1491     }
1492 
1493     /**
1494      * @dev Destroys `tokenId`.
1495      * The approval is cleared when the token is burned.
1496      *
1497      * Requirements:
1498      *
1499      * - `tokenId` must exist.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1504         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1505 
1506         address from = address(uint160(prevOwnershipPacked));
1507 
1508         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1509 
1510         if (approvalCheck) {
1511             // The nested ifs save around 20+ gas over a compound boolean condition.
1512             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1513                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1514         }
1515 
1516         _beforeTokenTransfers(from, address(0), tokenId, 1);
1517 
1518         // Clear approvals from the previous owner.
1519         assembly {
1520             if approvedAddress {
1521                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1522                 sstore(approvedAddressSlot, 0)
1523             }
1524         }
1525 
1526         // Underflow of the sender's balance is impossible because we check for
1527         // ownership above and the recipient's balance can't realistically overflow.
1528         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1529         unchecked {
1530             // Updates:
1531             // - `balance -= 1`.
1532             // - `numberBurned += 1`.
1533             //
1534             // We can directly decrement the balance, and increment the number burned.
1535             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1536             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1537 
1538             // Updates:
1539             // - `address` to the last owner.
1540             // - `startTimestamp` to the timestamp of burning.
1541             // - `burned` to `true`.
1542             // - `nextInitialized` to `true`.
1543             _packedOwnerships[tokenId] = _packOwnershipData(
1544                 from,
1545                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1546             );
1547 
1548             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1549             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1550                 uint256 nextTokenId = tokenId + 1;
1551                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1552                 if (_packedOwnerships[nextTokenId] == 0) {
1553                     // If the next slot is within bounds.
1554                     if (nextTokenId != _currentIndex) {
1555                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1556                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1557                     }
1558                 }
1559             }
1560         }
1561 
1562         emit Transfer(from, address(0), tokenId);
1563         _afterTokenTransfers(from, address(0), tokenId, 1);
1564 
1565         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1566         unchecked {
1567             _burnCounter++;
1568         }
1569     }
1570 
1571     // =============================================================
1572     //                     EXTRA DATA OPERATIONS
1573     // =============================================================
1574 
1575     /**
1576      * @dev Directly sets the extra data for the ownership data `index`.
1577      */
1578     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1579         uint256 packed = _packedOwnerships[index];
1580         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1581         uint256 extraDataCasted;
1582         // Cast `extraData` with assembly to avoid redundant masking.
1583         assembly {
1584             extraDataCasted := extraData
1585         }
1586         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1587         _packedOwnerships[index] = packed;
1588     }
1589 
1590     /**
1591      * @dev Called during each token transfer to set the 24bit `extraData` field.
1592      * Intended to be overridden by the cosumer contract.
1593      *
1594      * `previousExtraData` - the value of `extraData` before transfer.
1595      *
1596      * Calling conditions:
1597      *
1598      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1599      * transferred to `to`.
1600      * - When `from` is zero, `tokenId` will be minted for `to`.
1601      * - When `to` is zero, `tokenId` will be burned by `from`.
1602      * - `from` and `to` are never both zero.
1603      */
1604     function _extraData(
1605         address from,
1606         address to,
1607         uint24 previousExtraData
1608     ) internal view virtual returns (uint24) {}
1609 
1610     /**
1611      * @dev Returns the next extra data for the packed ownership data.
1612      * The returned result is shifted into position.
1613      */
1614     function _nextExtraData(
1615         address from,
1616         address to,
1617         uint256 prevOwnershipPacked
1618     ) private view returns (uint256) {
1619         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1620         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1621     }
1622 
1623     // =============================================================
1624     //                       OTHER OPERATIONS
1625     // =============================================================
1626 
1627     /**
1628      * @dev Returns the message sender (defaults to `msg.sender`).
1629      *
1630      * If you are writing GSN compatible contracts, you need to override this function.
1631      */
1632     function _msgSenderERC721A() internal view virtual returns (address) {
1633         return msg.sender;
1634     }
1635 
1636     /**
1637      * @dev Converts a uint256 to its ASCII string decimal representation.
1638      */
1639     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1640         assembly {
1641             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1642             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1643             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1644             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1645             let m := add(mload(0x40), 0xa0)
1646             // Update the free memory pointer to allocate.
1647             mstore(0x40, m)
1648             // Assign the `str` to the end.
1649             str := sub(m, 0x20)
1650             // Zeroize the slot after the string.
1651             mstore(str, 0)
1652 
1653             // Cache the end of the memory to calculate the length later.
1654             let end := str
1655 
1656             // We write the string from rightmost digit to leftmost digit.
1657             // The following is essentially a do-while loop that also handles the zero case.
1658             // prettier-ignore
1659             for { let temp := value } 1 {} {
1660                 str := sub(str, 1)
1661                 // Write the character to the pointer.
1662                 // The ASCII index of the '0' character is 48.
1663                 mstore8(str, add(48, mod(temp, 10)))
1664                 // Keep dividing `temp` until zero.
1665                 temp := div(temp, 10)
1666                 // prettier-ignore
1667                 if iszero(temp) { break }
1668             }
1669 
1670             let length := sub(end, str)
1671             // Move the pointer 32 bytes leftwards to make room for the length.
1672             str := sub(str, 0x20)
1673             // Store the length.
1674             mstore(str, length)
1675         }
1676     }
1677 }
1678 
1679 // File: @openzeppelin/contracts/utils/Context.sol
1680 
1681 
1682 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1683 
1684 pragma solidity ^0.8.0;
1685 
1686 /**
1687  * @dev Provides information about the current execution context, including the
1688  * sender of the transaction and its data. While these are generally available
1689  * via msg.sender and msg.data, they should not be accessed in such a direct
1690  * manner, since when dealing with meta-transactions the account sending and
1691  * paying for execution may not be the actual sender (as far as an application
1692  * is concerned).
1693  *
1694  * This contract is only required for intermediate, library-like contracts.
1695  */
1696 abstract contract Context {
1697     function _msgSender() internal view virtual returns (address) {
1698         return msg.sender;
1699     }
1700 
1701     function _msgData() internal view virtual returns (bytes calldata) {
1702         return msg.data;
1703     }
1704 }
1705 
1706 // File: @openzeppelin/contracts/access/Ownable.sol
1707 
1708 
1709 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1710 
1711 pragma solidity ^0.8.0;
1712 
1713 
1714 /**
1715  * @dev Contract module which provides a basic access control mechanism, where
1716  * there is an account (an owner) that can be granted exclusive access to
1717  * specific functions.
1718  *
1719  * By default, the owner account will be the one that deploys the contract. This
1720  * can later be changed with {transferOwnership}.
1721  *
1722  * This module is used through inheritance. It will make available the modifier
1723  * `onlyOwner`, which can be applied to your functions to restrict their use to
1724  * the owner.
1725  */
1726 abstract contract Ownable is Context {
1727     address private _owner;
1728 
1729     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1730 
1731     /**
1732      * @dev Initializes the contract setting the deployer as the initial owner.
1733      */
1734     constructor() {
1735         _transferOwnership(_msgSender());
1736     }
1737 
1738     /**
1739      * @dev Throws if called by any account other than the owner.
1740      */
1741     modifier onlyOwner() {
1742         _checkOwner();
1743         _;
1744     }
1745 
1746     /**
1747      * @dev Returns the address of the current owner.
1748      */
1749     function owner() public view virtual returns (address) {
1750         return _owner;
1751     }
1752 
1753     /**
1754      * @dev Throws if the sender is not the owner.
1755      */
1756     function _checkOwner() internal view virtual {
1757         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1758     }
1759 
1760     /**
1761      * @dev Leaves the contract without owner. It will not be possible to call
1762      * `onlyOwner` functions anymore. Can only be called by the current owner.
1763      *
1764      * NOTE: Renouncing ownership will leave the contract without an owner,
1765      * thereby removing any functionality that is only available to the owner.
1766      */
1767     function renounceOwnership() public virtual onlyOwner {
1768         _transferOwnership(address(0));
1769     }
1770 
1771     /**
1772      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1773      * Can only be called by the current owner.
1774      */
1775     function transferOwnership(address newOwner) public virtual onlyOwner {
1776         require(newOwner != address(0), "Ownable: new owner is the zero address");
1777         _transferOwnership(newOwner);
1778     }
1779 
1780     /**
1781      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1782      * Internal function without access restriction.
1783      */
1784     function _transferOwnership(address newOwner) internal virtual {
1785         address oldOwner = _owner;
1786         _owner = newOwner;
1787         emit OwnershipTransferred(oldOwner, newOwner);
1788     }
1789 }
1790 
1791 // File: AvatizerNFT.sol
1792 
1793 
1794 pragma solidity ^0.8.12;
1795 
1796 
1797 
1798 
1799 
1800 interface AvatizerMetadataManager {
1801     function tokenURI(uint256 tokenId) external view returns (string memory);
1802 }
1803 
1804 contract AvatizerNFT is ERC721A("Avatizer", "AVA"), Ownable {
1805     uint256 public maxSupply = 999;
1806     uint256 public maxPerWallet = 1;
1807     
1808     bool public saleStarted;
1809     
1810     bytes32 public merkleRoot;
1811 
1812     mapping(uint256 => bytes32) public tokenDNA;
1813     mapping(uint256 => bytes) public pausedTokenGenes;
1814 
1815     AvatizerMetadataManager metadataManager = AvatizerMetadataManager(address(0)); //placeholder
1816     
1817     function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
1818         maxPerWallet = _maxPerWallet;
1819     }
1820 
1821     function setSaleStarted(bool _saleStarted) external onlyOwner {
1822         saleStarted = _saleStarted;
1823     }
1824 
1825     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1826         merkleRoot = _merkleRoot;
1827     }
1828 
1829     function setMetadataManager(address _metadataManager) external onlyOwner {
1830         metadataManager = AvatizerMetadataManager(_metadataManager);
1831     }
1832 
1833     function isWhitelisted(address user, bytes32[] calldata _merkleProof) public view returns (bool) {
1834         bytes32 leaf = keccak256(abi.encodePacked(user));
1835         return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1836     }
1837 
1838     function getTokenGenes(uint256 tokenId) public view returns (bytes memory) {
1839         if (pausedTokenGenes[tokenId].length == 0) {
1840             return abi.encodePacked(tokenDNA[tokenId], (block.timestamp + 25200)/86400);
1841         } else {
1842             return pausedTokenGenes[tokenId];
1843         }
1844     }
1845 
1846     function pauseDNAGeneration(uint256 tokenId) external {
1847         require(ownerOf(tokenId) == msg.sender, "Only the token owner can pause token DNA");
1848         require(pausedTokenGenes[tokenId].length == 0, "Token DNA is already paused");
1849         pausedTokenGenes[tokenId] = abi.encodePacked(tokenDNA[tokenId], (block.timestamp + 25200)/86400);
1850     }
1851 
1852     function unpauseDNAGeneration(uint256 tokenId) external {
1853         require(ownerOf(tokenId) == msg.sender, "Only the token owner can unpause token DNA");
1854         require(pausedTokenGenes[tokenId].length > 0, "Token DNA is already unpaused");
1855         delete pausedTokenGenes[tokenId];
1856     }
1857 
1858     function mint(uint64 amount, bytes32[] calldata _merkleProof) external {
1859         require(saleStarted, "Sale has not started yet");
1860         require(_totalMinted() + amount <= maxSupply, "Max Supply Exceeded");
1861         require(isWhitelisted(msg.sender, _merkleProof), "Address not whitelisted");
1862         require(_numberMinted(msg.sender) + amount <= maxPerWallet, "Address cannot mint more tokens");
1863         unchecked {
1864             uint256 startToken = _nextTokenId();
1865             for (uint256 i = 0; i < amount; i++) {
1866                 tokenDNA[startToken + i] = keccak256(abi.encodePacked(msg.sender, startToken + i));
1867             }
1868         }
1869         _safeMint(msg.sender, amount);
1870     }
1871 
1872     function adminMint(address to, uint256 amount) external onlyOwner {
1873         require(_totalMinted() + amount <= maxSupply, "Max Supply Exceeded");
1874         require(amount <= 30, "Max mint per transaction exceeded");
1875         unchecked {
1876             uint256 startToken = _nextTokenId();
1877             for (uint256 i = 0; i < amount; i++) {
1878                 tokenDNA[startToken + i] = keccak256(abi.encodePacked(msg.sender, startToken + i));
1879             }
1880         }
1881         _safeMint(to, amount);
1882     }
1883 
1884     function rescueFunds(address to) external onlyOwner {
1885         uint256 balance = address(this).balance;
1886         (bool callSuccess, ) = payable(to).call{value: balance}("");
1887         require(callSuccess, "Call failed");
1888     }
1889 
1890     function rescueToken(address token) external onlyOwner {
1891         IERC20 tokenContract = IERC20(token);
1892         uint256 balance = tokenContract.balanceOf(address(this));
1893         tokenContract.transfer(msg.sender, balance);
1894     }
1895 
1896     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1897         return metadataManager.tokenURI(tokenId);
1898     }
1899 }